"""
Native Oracle to PostgreSQL Streaming ETL Pipeline.
Uses pure thin mode python-oracledb and psycopg3 in-memory COPY streaming.
Operates with ZERO Oracle Instant Client, C compilers, or disk staging files.
"""
import sys
import io
import time
import logging
from typing import List, Dict, Any
import oracledb
import psycopg
from config import get_config, MigrationConfig

# Enable pure thin mode string fetching for CLOBs
oracledb.defaults.fetch_lobs = False

logging.basicConfig(level=logging.INFO, format="%(asctime)s [%(levelname)s] %(message)s")
logger = logging.getLogger("etl_pipeline")


def build_table_definitions(cfg: MigrationConfig) -> List[Dict[str, Any]]:
    """
    Constructs parameterized table extraction and loading definitions.
    Replaces static schema and cutoff constants with runtime configurations.
    Uses bind parameter :date_cutoff for Oracle queries.
    """
    schema = cfg.oracle_schema
    date_cutoff = cfg.date_cutoff

    return [
        # ---------------------------------------------------------------------
        # TIER 1: Core Lookups, Directory, Document Templates & Security Roots
        # ---------------------------------------------------------------------
        {
            "target": "rnt_user_roles",
            "tier": 1,
            "query": f"""
                SELECT ROLE_ID, ROLE_NAME, ROLE_CODE AS DESCRIPTION
                FROM {schema}.RNT_USER_ROLES
                ORDER BY ROLE_ID
            """,
            "columns": ["role_id", "role_name", "description"]
        },
        {
            "target": "rnt_people",
            "tier": 1,
            "query": f"""
                SELECT 
                    PEOPLE_ID, FIRST_NAME, LAST_NAME, SSN, 
                    PHONE1, PHONE2, EMAIL_ADDRESS AS EMAIL
                FROM {schema}.RNT_PEOPLE
                ORDER BY PEOPLE_ID
            """,
            "columns": ["people_id", "first_name", "last_name", "ssn", "phone1", "phone2", "email"]
        },
        {
            "target": "rnt_business_units",
            "tier": 1,
            "query": f"""
                SELECT BUSINESS_ID, BUSINESS_NAME
                FROM {schema}.RNT_BUSINESS_UNITS
                ORDER BY BUSINESS_ID
            """,
            "columns": ["business_id", "business_name"]
        },
        {
            "target": "rnt_users",
            "tier": 1,
            "query": f"""
                SELECT 
                    USER_ID,
                    USER_LOGIN AS USERNAME,
                    USER_PASSWORD AS PASSWORD_HASH,
                    CASE 
                        WHEN INSTR(USER_LOGIN, '@') > 0 THEN USER_LOGIN 
                        ELSE USER_LOGIN || '@visulate.local' 
                    END AS EMAIL,
                    CASE WHEN IS_ACTIVE_YN = 'Y' THEN TRUE ELSE FALSE END AS IS_ACTIVE,
                    TRUE AS REQUIRES_PASSWORD_RESET
                FROM {schema}.RNT_USERS
                ORDER BY USER_ID
            """,
            "columns": ["user_id", "username", "password_hash", "email", "is_active", "requires_password_reset"]
        },
        {
            "target": "rnt_user_assignments",
            "tier": 1,
            "query": f"""
                SELECT USER_ASSIGN_ID, ROLE_ID, USER_ID, BUSINESS_ID
                FROM {schema}.RNT_USER_ASSIGNMENTS
                ORDER BY USER_ASSIGN_ID
            """,
            "columns": ["user_assign_id", "role_id", "user_id", "business_id"]
        },
        {
            "target": "rnt_people_bu",
            "tier": 1,
            "query": f"""
                SELECT PEOPLE_BUSINESS_ID, PEOPLE_ID, BUSINESS_ID
                FROM {schema}.RNT_PEOPLE_BU
                ORDER BY PEOPLE_BUSINESS_ID
            """,
            "columns": ["people_business_id", "people_id", "business_id"]
        },
        {
            "target": "rnt_section8_offices",
            "tier": 1,
            "query": f"""
                SELECT SECTION8_ID, SECTION_NAME
                FROM {schema}.RNT_SECTION8_OFFICES
                ORDER BY SECTION8_ID
            """,
            "columns": ["section8_id", "section_name"]
        },
        {
            "target": "rnt_section8_offices_bu",
            "tier": 1,
            "query": f"""
                SELECT SECTION8_BUSINESS_ID, SECTION8_ID, BUSINESS_ID
                FROM {schema}.RNT_SECTION8_OFFICES_BU
                ORDER BY SECTION8_BUSINESS_ID
            """,
            "columns": ["section8_business_id", "section8_id", "business_id"]
        },
        {
            "target": "rnt_doc_templates",
            "tier": 1,
            "query": f"""
                SELECT 
                    TEMPLATE_ID,
                    NAME,
                    BUSINESS_ID,
                    'LEASE' AS TEMPLATE_TYPE,
                    CONTENT
                FROM {schema}.RNT_DOC_TEMPLATES
                ORDER BY TEMPLATE_ID
            """,
            "columns": ["template_id", "name", "business_id", "template_type", "content"]
        },
        {
            "target": "rnt_accounts",
            "tier": 1,
            "query": f"""
                SELECT 
                    ACCOUNT_ID, BUSINESS_ID, TO_CHAR(ACCOUNT_NUMBER) AS ACCOUNT_NUMBER,
                    NAME AS ACCOUNT_NAME, UPPER(ACCOUNT_TYPE) AS ACCOUNT_TYPE
                FROM {schema}.RNT_ACCOUNTS
                ORDER BY ACCOUNT_ID
            """,
            "columns": ["account_id", "business_id", "account_number", "account_name", "account_type"]
        },
        {
            "target": "rnt_payment_types",
            "tier": 1,
            "query": f"""
                SELECT 
                    pt.PAYMENT_TYPE_ID,
                    COALESCE(min_bu.BUSINESS_ID, 1) AS BUSINESS_ID,
                    pt.PAYMENT_TYPE_NAME,
                    COALESCE(pt.DEPRECIATION_TERM, 0.00) AS DEPRECIATION_TERM,
                    COALESCE(pt.PAYABLE_YN, 'Y') AS PAYABLE_YN,
                    COALESCE(pt.RECEIVABLE_YN, 'N') AS RECEIVABLE_YN,
                    CASE WHEN pt.RECEIVABLE_YN = 'Y' THEN TRUE ELSE FALSE END AS IS_INCOME,
                    pt.DESCRIPTION
                FROM {schema}.RNT_PAYMENT_TYPES pt
                LEFT JOIN (SELECT PAYMENT_TYPE_ID, MIN(BUSINESS_ID) AS BUSINESS_ID FROM {schema}.RNT_PT_RULES GROUP BY PAYMENT_TYPE_ID) min_bu
                  ON pt.PAYMENT_TYPE_ID = min_bu.PAYMENT_TYPE_ID
                ORDER BY pt.PAYMENT_TYPE_ID
            """,
            "columns": ["payment_type_id", "business_id", "payment_type_name", "depreciation_term", "payable_yn", "receivable_yn", "is_income", "description"]
        },
        {
            "target": "rnt_pt_rules",
            "tier": 1,
            "query": f"""
                SELECT 
                    ROWNUM AS RULE_ID,
                    BUSINESS_ID,
                    PAYMENT_TYPE_ID,
                    TRANSACTION_TYPE,
                    DEBIT_ACCOUNT,
                    CREDIT_ACCOUNT
                FROM {schema}.RNT_PT_RULES
                ORDER BY ROWNUM
            """,
            "columns": ["rule_id", "business_id", "payment_type_id", "transaction_type", "debit_account", "credit_account"]
        },
        {
            "target": "rnt_account_periods",
            "tier": 1,
            "query": f"""
                SELECT PERIOD_ID, BUSINESS_ID, START_DATE, COALESCE(CLOSED_YN, 'N') AS CLOSED_YN
                FROM {schema}.RNT_ACCOUNT_PERIODS
                ORDER BY PERIOD_ID
            """,
            "columns": ["period_id", "business_id", "start_date", "closed_yn"]
        },

        # ---------------------------------------------------------------------
        # TIER 2: Suppliers, Properties, Units, Photos, Valuations, Tenants & Leads
        # ---------------------------------------------------------------------
        {
            "target": "rnt_suppliers_all",
            "tier": 2,
            "query": f"""
                SELECT 
                    SUPPLIER_ID,
                    NAME AS SUPPLIER_NAME,
                    PHONE1 AS PHONE,
                    EMAIL_ADDRESS AS EMAIL,
                    ADDRESS1,
                    CITY,
                    COALESCE(STATE, 'FL') AS STATE,
                    TO_CHAR(ZIPCODE) AS ZIPCODE,
                    'CONTRACTOR' AS SUPPLIER_CATEGORY,
                    TRUE AS IS_CONTRACTOR
                FROM {schema}.RNT_SUPPLIERS_ALL
                ORDER BY SUPPLIER_ID
            """,
            "columns": ["supplier_id", "supplier_name", "phone", "email", "address1", "city", "state", "zipcode", "supplier_category", "is_contractor"]
        },
        {
            "target": "rnt_bu_suppliers",
            "tier": 2,
            "query": f"""
                SELECT BU_SUPPLIER_ID, BUSINESS_ID, SUPPLIER_ID, TAX_IDENTIFIER, NOTES
                FROM {schema}.RNT_BU_SUPPLIERS
                ORDER BY BU_SUPPLIER_ID
            """,
            "columns": ["bu_supplier_id", "business_id", "supplier_id", "tax_identifier", "notes"]
        },
        {
            "target": "rnt_properties",
            "tier": 2,
            "query": f"""
                SELECT 
                    p.PROPERTY_ID,
                    p.BUSINESS_ID,
                    p.NAME,
                    p.ADDRESS1,
                    p.ADDRESS2,
                    p.CITY,
                    COALESCE(p.STATE, 'FL') AS STATE,
                    p.ZIPCODE,
                    COALESCE(p.UNITS, 1) AS UNITS,
                    p.DATE_PURCHASED,
                    p.PURCHASE_PRICE,
                    p.LAND_VALUE,
                    COALESCE(p.DEPRECIATION_TERM, 27.50) AS DEPRECIATION_TERM,
                    p.YEAR_BUILT,
                    p.BUILDING_SIZE,
                    p.LOT_SIZE,
                    p.DATE_SOLD,
                    p.SALE_AMOUNT,
                    COALESCE(p.NOTE_YN, 'N') AS NOTE_YN,
                    CASE 
                        WHEN UPPER(p.STATUS) = 'PURCHASED' THEN 'ACTIVE'
                        WHEN UPPER(p.STATUS) IN ('CANDIDATE', 'ACTIVE', 'SOLD', 'REJECTED') THEN UPPER(p.STATUS)
                        ELSE 'ACTIVE'
                    END AS STATUS,
                    p.DESCRIPTION,
                    p.PROP_ID,
                    CASE 
                        WHEN COALESCE(pr.GEO_LOCATION, pr.GEO_COORDINATES) IS NOT NULL 
                        THEN 'SRID=4326;' || SDO_UTIL.TO_WKTGEOMETRY(COALESCE(pr.GEO_LOCATION, pr.GEO_COORDINATES))
                        ELSE NULL 
                    END AS GEOM
                FROM {schema}.RNT_PROPERTIES p
                LEFT JOIN {schema}.PR_PROPERTIES pr ON p.PROP_ID = pr.PROP_ID
                ORDER BY p.PROPERTY_ID
            """,
            "columns": [
                "property_id", "business_id", "name", "address1", "address2", "city", "state", "zipcode",
                "units", "date_purchased", "purchase_price", "land_value", "depreciation_term",
                "year_built", "building_size", "lot_size", "date_sold", "sale_amount", "note_yn",
                "status", "description", "prop_id", "geom"
            ]
        },
        {
            "target": "rnt_property_units",
            "tier": 2,
            "query": f"""
                SELECT 
                    UNIT_ID, PROPERTY_ID, UNIT_NAME, 
                    BEDROOMS AS BEDS, BATHROOMS AS BATHS, UNIT_SIZE AS SQ_FT, 
                    'VACANT' AS STATUS, DESCRIPTION
                FROM {schema}.RNT_PROPERTY_UNITS
                ORDER BY UNIT_ID
            """,
            "columns": ["unit_id", "property_id", "unit_name", "beds", "baths", "sq_ft", "status", "description"]
        },
        {
            "target": "rnt_property_photos",
            "tier": 2,
            "query": f"""
                SELECT 
                    PHOTO_ID,
                    PROPERTY_ID,
                    PHOTO_TITLE AS TITLE,
                    PHOTO_FILENAME AS FILE_PATH,
                    1 AS DISPLAY_ORDER,
                    FALSE AS IS_PRIMARY
                FROM {schema}.RNT_PROPERTY_PHOTOS
                ORDER BY PHOTO_ID
            """,
            "columns": ["photo_id", "property_id", "title", "file_path", "display_order", "is_primary"]
        },
        {
            "target": "rnt_property_value",
            "tier": 2,
            "query": f"""
                SELECT 
                    VALUE_ID,
                    PROPERTY_ID,
                    VALUE_DATE,
                    CASE 
                        WHEN UPPER(VALUE_METHOD) = 'CAP RATE' THEN 'CAP_RATE'
                        WHEN UPPER(VALUE_METHOD) IN ('SALE', 'ESTIMATE', 'CAP_RATE', 'APPRAISAL') THEN UPPER(VALUE_METHOD)
                        ELSE 'ESTIMATE'
                    END AS VALUE_METHOD,
                    VALUE,
                    CAP_RATE
                FROM {schema}.RNT_PROPERTY_VALUE
                ORDER BY VALUE_ID
            """,
            "columns": ["value_id", "property_id", "value_date", "value_method", "value", "cap_rate"]
        },
        {
            "target": "rnt_tenant",
            "tier": 2,
            "query": f"""
                SELECT 
                    t.TENANT_ID,
                    t.PEOPLE_ID,
                    COALESCE(p.BUSINESS_ID, pb.BUSINESS_ID, 1) AS BUSINESS_ID,
                    t.SECTION8_ID,
                    COALESCE(t.DEPOSIT_BALANCE, 0.00) AS DEPOSIT_BALANCE,
                    CASE 
                        WHEN UPPER(t.STATUS) IN ('PROSPECT', 'ACTIVE', 'PAST', 'EVICTED') THEN UPPER(t.STATUS)
                        WHEN UPPER(t.STATUS) = 'FORMER' THEN 'PAST'
                        ELSE 'ACTIVE' 
                    END AS STATUS
                FROM {schema}.RNT_TENANT t
                LEFT JOIN {schema}.RNT_TENANCY_AGREEMENT a ON t.AGREEMENT_ID = a.AGREEMENT_ID
                LEFT JOIN {schema}.RNT_PROPERTY_UNITS u ON a.UNIT_ID = u.UNIT_ID
                LEFT JOIN {schema}.RNT_PROPERTIES p ON u.PROPERTY_ID = p.PROPERTY_ID
                LEFT JOIN (SELECT PEOPLE_ID, MIN(BUSINESS_ID) AS BUSINESS_ID FROM {schema}.RNT_PEOPLE_BU GROUP BY PEOPLE_ID) pb ON t.PEOPLE_ID = pb.PEOPLE_ID
                ORDER BY t.TENANT_ID
            """,
            "columns": ["tenant_id", "people_id", "business_id", "section8_id", "deposit_balance", "status"]
        },
        {
            "target": "rnt_leads",
            "tier": 2,
            "query": f"""
                SELECT 
                    l.LEAD_ID,
                    pb.BUSINESS_ID,
                    COALESCE(p.FIRST_NAME, 'Lead') AS FIRST_NAME,
                    COALESCE(p.LAST_NAME, TO_CHAR(l.LEAD_ID)) AS LAST_NAME,
                    p.PHONE1 AS PHONE,
                    p.EMAIL_ADDRESS AS EMAIL,
                    CASE 
                        WHEN UPPER(l.LEAD_TYPE) IN ('RENTAL', 'SALE', 'INVESTOR') THEN UPPER(l.LEAD_TYPE)
                        WHEN UPPER(l.LEAD_TYPE) IN ('BUY', 'SELL') THEN 'SALE'
                        ELSE 'RENTAL'
                    END AS LEAD_TYPE,
                    CASE 
                        WHEN UPPER(l.LEAD_STATUS) IN ('NEW', 'CONTACTED', 'QUALIFIED', 'LOST', 'CONVERTED') THEN UPPER(l.LEAD_STATUS)
                        WHEN UPPER(l.LEAD_STATUS) = 'ACTIVE' THEN 'NEW'
                        ELSE 'NEW'
                    END AS STATUS,
                    l.MIN_PRICE AS TARGET_RENT_MIN,
                    l.MAX_PRICE AS TARGET_RENT_MAX,
                    l.DESCRIPTION AS NOTES
                FROM {schema}.RNT_LEADS l
                JOIN {schema}.RNT_PEOPLE_BU pb ON l.PEOPLE_BUSINESS_ID = pb.PEOPLE_BUSINESS_ID
                JOIN {schema}.RNT_PEOPLE p ON pb.PEOPLE_ID = p.PEOPLE_ID
                ORDER BY l.LEAD_ID
            """,
            "columns": ["lead_id", "business_id", "first_name", "last_name", "phone", "email", "lead_type", "status", "target_rent_min", "target_rent_max", "notes"]
        },
        {
            "target": "rnt_lead_actions",
            "tier": 2,
            "query": f"""
                SELECT 
                    la.ACTION_ID,
                    la.LEAD_ID,
                    COALESCE(la.ACTION_DATE, SYSDATE) AS ACTION_DATE,
                    CASE 
                        WHEN UPPER(REPLACE(la.ACTION_TYPE, ' ', '_')) IN ('PHONE_CALL', 'EMAIL', 'LETTER', 'REFERRAL', 'OFFER', 'COUNTER_OFFER', 'SALE_AGREED', 'INSPECTION', 'WITHDRAWN', 'CLOSING') 
                            THEN UPPER(REPLACE(la.ACTION_TYPE, ' ', '_'))
                        ELSE 'PHONE_CALL'
                    END AS ACTION_TYPE,
                    la.BROKER_ID,
                    la.DESCRIPTION
                FROM {schema}.RNT_LEAD_ACTIONS la
                JOIN {schema}.RNT_LEADS l ON la.LEAD_ID = l.LEAD_ID
                ORDER BY la.ACTION_ID
            """,
            "columns": ["action_id", "lead_id", "action_date", "action_type", "broker_id", "description"]
        },

        # ---------------------------------------------------------------------
        # TIER 3: Leases, Agreement Actions, Property Expenses & Loans
        # ---------------------------------------------------------------------
        {
            "target": "rnt_tenancy_agreement",
            "tier": 3,
            "query": f"""
                SELECT 
                    a.AGREEMENT_ID,
                    a.UNIT_ID,
                    t.TENANT_ID,
                    a.AGREEMENT_DATE,
                    a.DATE_AVAILABLE,
                    COALESCE(a.AGREEMENT_DATE, a.DATE_AVAILABLE) AS START_DATE,
                    a.END_DATE,
                    COALESCE(a.TERM, 12) AS TERM,
                    COALESCE(a.AMOUNT, 0.00) AS AMOUNT,
                    COALESCE(a.AMOUNT_PERIOD, 'MONTH') AS AMOUNT_PERIOD,
                    COALESCE(a.DEPOSIT, 0.00) AS DEPOSIT,
                    COALESCE(a.LAST_MONTH, 0.00) AS LAST_MONTH,
                    COALESCE(a.DISCOUNT_AMOUNT, 0.00) AS DISCOUNT_AMOUNT,
                    a.DISCOUNT_TYPE,
                    COALESCE(a.DISCOUNT_PERIOD, 0) AS DISCOUNT_PERIOD,
                    COALESCE(a.AD_PUBLISH_YN, 'N') AS AD_PUBLISH_YN,
                    a.AD_TITLE,
                    a.AD_CONTACT,
                    a.AD_EMAIL,
                    a.AD_PHONE,
                    CASE 
                        WHEN a.END_DATE IS NOT NULL AND a.END_DATE < SYSDATE THEN 'TERMINATED'
                        ELSE 'ACTIVE'
                    END AS STATUS
                FROM {schema}.RNT_TENANCY_AGREEMENT a
                LEFT JOIN {schema}.RNT_TENANT t ON a.AGREEMENT_ID = t.AGREEMENT_ID
                ORDER BY a.AGREEMENT_ID
            """,
            "columns": [
                "agreement_id", "unit_id", "tenant_id", "agreement_date", "date_available", "start_date",
                "end_date", "term", "amount", "amount_period", "deposit", "last_month",
                "discount_amount", "discount_type", "discount_period", "ad_publish_yn",
                "ad_title", "ad_contact", "ad_email", "ad_phone", "status"
            ]
        },
        {
            "target": "rnt_agreement_actions",
            "tier": 3,
            "query": f"""
                SELECT 
                    ACTION_ID,
                    AGREEMENT_ID,
                    ACTION_DATE,
                    ACTION_TYPE,
                    COALESCE(ACTION_COST, 0.00) AS COST,
                    COALESCE(RECOVERABLE_YN, 'N') AS RECOVERABLE_YN,
                    COALESCE(COMMENTS_VARCHAR, DBMS_LOB.SUBSTR(COMMENTS, 4000, 1)) AS DESCRIPTION
                FROM {schema}.RNT_AGREEMENT_ACTIONS
                ORDER BY ACTION_ID
            """,
            "columns": ["action_id", "agreement_id", "action_date", "action_type", "cost", "recoverable_yn", "description"]
        },
        {
            "target": "rnt_property_expenses",
            "tier": 3,
            "query": f"""
                SELECT 
                    EXPENSE_ID, PROPERTY_ID, UNIT_ID, 
                    EVENT_DATE AS EXPENSE_DATE, DESCRIPTION, 
                    COALESCE(RECURRING_YN, 'N') AS RECURRING_YN
                FROM {schema}.RNT_PROPERTY_EXPENSES
                ORDER BY EXPENSE_ID
            """,
            "columns": ["expense_id", "property_id", "unit_id", "expense_date", "description", "recurring_yn"]
        },
        {
            "target": "rnt_loans",
            "tier": 3,
            "query": f"""
                SELECT 
                    LOAN_ID,
                    PROPERTY_ID,
                    'Mortgage Lender' AS LENDER_NAME,
                    'LN-' || TO_CHAR(LOAN_ID) AS LOAN_NUMBER,
                    CASE 
                        WHEN CREDIT_LINE_YN = 'Y' THEN 'HELOC'
                        WHEN ARM_YN = 'Y' THEN 'ARM'
                        WHEN BALLOON_DATE IS NOT NULL THEN 'BALLOON'
                        ELSE 'FIXED'
                    END AS LOAN_TYPE,
                    LOAN_AMOUNT AS ORIGINAL_AMOUNT,
                    COALESCE(PRINCIPAL_BALANCE, LOAN_AMOUNT) AS CURRENT_BALANCE,
                    COALESCE(INTEREST_RATE, 0.05) AS INTEREST_RATE,
                    0.00 AS MONTHLY_PAYMENT,
                    LOAN_DATE AS START_DATE,
                    BALLOON_DATE AS MATURITY_DATE
                FROM {schema}.RNT_LOANS
                ORDER BY LOAN_ID
            """,
            "columns": [
                "loan_id", "property_id", "lender_name", "loan_number", "loan_type",
                "original_amount", "current_balance", "interest_rate", "monthly_payment",
                "start_date", "maturity_date"
            ]
        },

        # ---------------------------------------------------------------------
        # TIER 4: Operational Financial Journals & Invoices (Filtered <= date_cutoff)
        # ---------------------------------------------------------------------
        {
            "target": "rnt_expense_items",
            "tier": 4,
            "query": f"""
                SELECT 
                    EXPENSE_ITEM_ID AS ITEM_ID,
                    EXPENSE_ID,
                    SUPPLIER_ID,
                    ITEM_NAME,
                    ESTIMATE AS ESTIMATE_COST,
                    COALESCE(ACTUAL, ITEM_COST, 0.00) AS ACTUAL_COST,
                    1 AS UNITS,
                    CASE 
                        WHEN ACCEPTED_YN = 'Y' THEN 'ACCEPTED'
                        ELSE 'PENDING'
                    END AS STATUS
                FROM {schema}.RNT_EXPENSE_ITEMS
                ORDER BY EXPENSE_ITEM_ID
            """,
            "columns": ["item_id", "expense_id", "supplier_id", "item_name", "estimate_cost", "actual_cost", "units", "status"]
        },
        {
            "target": "rnt_accounts_payable",
            "tier": 4,
            "query": f"""
                SELECT 
                    AP_ID,
                    BUSINESS_ID,
                    SUPPLIER_ID,
                    PAYMENT_PROPERTY_ID AS PROPERTY_ID,
                    EXPENSE_ID,
                    COALESCE(INVOICE_NUMBER, 'INV-' || TO_CHAR(AP_ID)) AS INVOICE_NUMBER,
                    PAYMENT_DUE_DATE AS INVOICE_DATE,
                    PAYMENT_DUE_DATE AS DUE_DATE,
                    AMOUNT,
                    0.00 AS AMOUNT_PAID,
                    PAYMENT_TYPE_ID,
                    'Historical AP Entry' AS DESCRIPTION,
                    'OPEN' AS STATUS
                FROM {schema}.RNT_ACCOUNTS_PAYABLE
                WHERE PAYMENT_DUE_DATE <= TO_DATE(:date_cutoff, 'YYYY-MM-DD HH24:MI:SS')
                ORDER BY AP_ID
            """,
            "params": {"date_cutoff": date_cutoff},
            "columns": [
                "ap_id", "business_id", "supplier_id", "property_id", "expense_id",
                "invoice_number", "invoice_date", "due_date", "amount", "amount_paid",
                "payment_type_id", "description", "status"
            ]
        },
        {
            "target": "rnt_accounts_receivable",
            "tier": 4,
            "query": f"""
                SELECT 
                    ar.AR_ID,
                    ar.BUSINESS_ID,
                    ar.TENANT_ID,
                    COALESCE(ar.AGREEMENT_ID, t.AGREEMENT_ID) AS AGREEMENT_ID,
                    ar.PAYMENT_TYPE AS PAYMENT_TYPE_ID,
                    ar.PAYMENT_DUE_DATE AS DUE_DATE,
                    ar.AMOUNT,
                    0.00 AS AMOUNT_PAID,
                    'Historical AR Charge' AS DESCRIPTION,
                    'OPEN' AS STATUS
                FROM {schema}.RNT_ACCOUNTS_RECEIVABLE ar
                LEFT JOIN {schema}.RNT_TENANT t ON ar.TENANT_ID = t.TENANT_ID
                WHERE ar.PAYMENT_DUE_DATE <= TO_DATE(:date_cutoff, 'YYYY-MM-DD HH24:MI:SS')
                ORDER BY ar.AR_ID
            """,
            "params": {"date_cutoff": date_cutoff},
            "columns": ["ar_id", "business_id", "tenant_id", "agreement_id", "payment_type_id", "due_date", "amount", "amount_paid", "description", "status"]
        },
        {
            "target": "rnt_payments",
            "tier": 4,
            "query": f"""
                SELECT 
                    PAYMENT_ID,
                    TENANT_ID,
                    PAYMENT_DATE,
                    AMOUNT,
                    0.00 AS ALLOCATED_AMOUNT,
                    'CHECK' AS PAYMENT_METHOD,
                    'REF-' || TO_CHAR(PAYMENT_ID) AS REFERENCE_NUMBER,
                    DESCRIPTION AS NOTES
                FROM {schema}.RNT_PAYMENTS
                WHERE PAYMENT_DATE <= TO_DATE(:date_cutoff, 'YYYY-MM-DD HH24:MI:SS')
                  AND TENANT_ID IS NOT NULL
                  AND AMOUNT > 0
                ORDER BY PAYMENT_ID
            """,
            "params": {"date_cutoff": date_cutoff},
            "columns": ["payment_id", "tenant_id", "payment_date", "amount", "allocated_amount", "payment_method", "reference_number", "notes"]
        },
        {
            "target": "rnt_payment_allocations",
            "tier": 4,
            "query": f"""
                SELECT 
                    pa.PAY_ALLOC_ID,
                    pa.PAYMENT_ID,
                    pa.AR_ID,
                    pa.AMOUNT,
                    pa.PAYMENT_DATE AS ALLOCATION_DATE
                FROM {schema}.RNT_PAYMENT_ALLOCATIONS pa
                JOIN {schema}.RNT_PAYMENTS p ON pa.PAYMENT_ID = p.PAYMENT_ID
                JOIN {schema}.RNT_ACCOUNTS_RECEIVABLE ar ON pa.AR_ID = ar.AR_ID
                WHERE pa.AR_ID IS NOT NULL 
                  AND pa.PAYMENT_ID IS NOT NULL
                  AND pa.PAYMENT_DATE <= TO_DATE(:date_cutoff, 'YYYY-MM-DD HH24:MI:SS')
                  AND pa.AMOUNT > 0
                ORDER BY pa.PAY_ALLOC_ID
            """,
            "params": {"date_cutoff": date_cutoff},
            "columns": ["pay_alloc_id", "payment_id", "ar_id", "amount", "allocation_date"]
        },

        # ---------------------------------------------------------------------
        # TIER 5: General Ledger Journal
        # ---------------------------------------------------------------------
        {
            "target": "rnt_ledger_entries",
            "tier": 5,
            "query": f"""
                SELECT 
                    le.LEDGER_ID,
                    acc.BUSINESS_ID,
                    le.ENTRY_DATE,
                    COALESCE(le.DESCRIPTION, 'Historical Journal Entry') AS DESCRIPTION,
                    le.DEBIT_ACCOUNT,
                    le.CREDIT_ACCOUNT,
                    ROUND(COALESCE(ar.AMOUNT, ap.AMOUNT, pa.AMOUNT, 0.01), 2) AS AMOUNT,
                    le.PAYMENT_TYPE_ID,
                    le.PROPERTY_ID,
                    le.AR_ID,
                    le.AP_ID,
                    le.PAY_ALLOC_ID
                FROM {schema}.RNT_LEDGER_ENTRIES le
                JOIN {schema}.RNT_ACCOUNTS acc ON le.DEBIT_ACCOUNT = acc.ACCOUNT_ID
                LEFT JOIN {schema}.RNT_ACCOUNTS_RECEIVABLE ar ON le.AR_ID = ar.AR_ID
                LEFT JOIN {schema}.RNT_ACCOUNTS_PAYABLE ap ON le.AP_ID = ap.AP_ID
                LEFT JOIN {schema}.RNT_PAYMENT_ALLOCATIONS pa ON le.PAY_ALLOC_ID = pa.PAY_ALLOC_ID
                WHERE le.ENTRY_DATE <= TO_DATE(:date_cutoff, 'YYYY-MM-DD HH24:MI:SS')
                  AND ROUND(COALESCE(ar.AMOUNT, ap.AMOUNT, pa.AMOUNT, 0), 2) > 0
                ORDER BY le.LEDGER_ID
            """,
            "params": {"date_cutoff": date_cutoff},
            "columns": [
                "ledger_id", "business_id", "entry_date", "description",
                "debit_account", "credit_account", "amount", "payment_type_id",
                "property_id", "ar_id", "ap_id", "pay_alloc_id"
            ]
        }
    ]


# Module-level default table definitions
TABLE_DEFINITIONS = build_table_definitions(get_config())


def format_pg_copy_val(val: Any) -> str:
    """Formats an arbitrary Python scalar into PostgreSQL COPY text format."""
    if val is None:
        return r"\N"
    if hasattr(val, "read"):
        val = val.read()
    if isinstance(val, (bytes, bytearray)):
        return r"\x" + val.hex()
    if isinstance(val, bool):
        return "t" if val else "f"
    s = str(val)
    return s.replace("\\", "\\\\").replace("\t", "\\t").replace("\n", "\\n").replace("\r", "\\r")


def stream_table(ora_conn, pg_conn, table_def: Dict[str, Any], batch_size: int) -> int:
    target = table_def["target"]
    columns = table_def["columns"]
    cols_joined = ", ".join(columns)
    copy_sql = f"COPY {target} ({cols_joined}) FROM STDIN WITH (FORMAT text, NULL '\\\\N')"
    params = table_def.get("params", {})
    
    total = 0
    t0 = time.time()
    with ora_conn.cursor() as ora_cur:
        ora_cur.arraysize = batch_size
        if params:
            ora_cur.execute(table_def["query"], params)
        else:
            ora_cur.execute(table_def["query"])
        
        with pg_conn.cursor() as pg_cur:
            with pg_cur.copy(copy_sql) as copy:
                while True:
                    rows = ora_cur.fetchmany(batch_size)
                    if not rows:
                        break
                    
                    buf = io.StringIO()
                    for row in rows:
                        line = [format_pg_copy_val(v) for v in row]
                        buf.write("\t".join(line) + "\n")
                    
                    copy.write(buf.getvalue().encode("utf-8"))
                    total += len(rows)

    elapsed = max(time.time() - t0, 0.001)
    logger.info(f"[Tier {table_def['tier']}] Streamed {total:6d} rows into {target:25s} in {elapsed:.2f}s ({total/elapsed:.0f} rows/s)")
    return total


def reconcile_post_etl_balances(pg_conn, cfg: MigrationConfig):
    """
    Executes post-streaming financial status and balance reconciliations.
    Updates:
      1. rnt_accounts_receivable: amount_paid and status (PAID/PARTIAL/OPEN) based on rnt_payment_allocations.
      2. rnt_payments: allocated_amount based on rnt_payment_allocations.
      3. rnt_accounts_payable: amount_paid and status (PAID/OPEN) for historical bills.
    """
    logger.info("Executing post-streaming AR/AP/Payment status and balance reconciliation...")
    with pg_conn.cursor() as cur:
        # 1. Reconcile AR amount_paid and status from payment allocations
        cur.execute("""
            UPDATE rnt_accounts_receivable ar
            SET amount_paid = COALESCE(sub.total_allocated, 0.00),
                status = CASE 
                    WHEN COALESCE(sub.total_allocated, 0.00) >= ar.amount THEN 'PAID'
                    WHEN COALESCE(sub.total_allocated, 0.00) > 0.00 THEN 'PARTIAL'
                    ELSE 'OPEN'
                END
            FROM (
                SELECT ar_id, SUM(amount) AS total_allocated
                FROM rnt_payment_allocations
                GROUP BY ar_id
            ) sub
            WHERE ar.ar_id = sub.ar_id;
        """)
        ar_count = cur.rowcount
        logger.info(f"Reconciled {ar_count} accounts receivable balances and statuses.")

        # 2. Reconcile tenant payment allocated_amount from payment allocations
        cur.execute("""
            UPDATE rnt_payments p
            SET allocated_amount = LEAST(p.amount, COALESCE(sub.total_allocated, 0.00))
            FROM (
                SELECT payment_id, SUM(amount) AS total_allocated
                FROM rnt_payment_allocations
                GROUP BY payment_id
            ) sub
            WHERE p.payment_id = sub.payment_id;
        """)
        pay_count = cur.rowcount
        logger.info(f"Reconciled {pay_count} payment allocated amounts.")

        # 3. Reconcile historical AP bills (associated with ledger transactions or due prior to cutoff)
        cutoff_date = cfg.date_cutoff.split()[0]
        cur.execute("""
            UPDATE rnt_accounts_payable ap
            SET amount_paid = ap.amount,
                status = 'PAID'
            WHERE ap.ap_id IN (SELECT DISTINCT ap_id FROM rnt_ledger_entries WHERE ap_id IS NOT NULL)
               OR ap.due_date <= %s::date;
        """, (cutoff_date,))
        ap_count = cur.rowcount
        logger.info(f"Reconciled {ap_count} accounts payable bills to PAID status.")


def run_pipeline():
    cfg = get_config()
    logger.info(f"Starting Python ETL Pipeline [Target: {cfg.env_target.upper()}]...")
    logger.info(f"Source Oracle: {cfg.oracle_host}:{cfg.oracle_port}/{cfg.oracle_service} (Schema: {cfg.oracle_schema})")
    logger.info(f"Target Postgres: {cfg.pg_host}:{cfg.pg_port}/{cfg.pg_database} (Schema: {cfg.pg_schema})")
    logger.info(f"Date Cutoff Filter: <= {cfg.date_cutoff}")
    
    table_defs = build_table_definitions(cfg)
    t_start = time.time()
    
    # Establish connections
    ora_conn = oracledb.connect(
        user=cfg.oracle_user,
        password=cfg.oracle_password,
        host=cfg.oracle_host,
        port=cfg.oracle_port,
        service_name=cfg.oracle_service
    )
    
    pg_conn = psycopg.connect(
        host=cfg.pg_host,
        port=cfg.pg_port,
        dbname=cfg.pg_database,
        user=cfg.pg_user,
        password=cfg.pg_password,
        autocommit=False
    )
    
    grand_total = 0
    try:
        with pg_conn.cursor() as cur:
            logger.info("Disabling foreign key constraint enforcement (session_replication_role = 'replica')...")
            cur.execute("SET session_replication_role = 'replica';")
        
        # Execute tables in strict topological order
        for table_def in table_defs:
            rows = stream_table(ora_conn, pg_conn, table_def, cfg.batch_size)
            grand_total += rows

        # Post-ETL AR/AP/Payment Status & Balance Reconciliation
        reconcile_post_etl_balances(pg_conn, cfg)
            
        with pg_conn.cursor() as cur:
            logger.info("Restoring foreign key constraint enforcement (session_replication_role = 'origin')...")
            cur.execute("SET session_replication_role = 'origin';")
            
        pg_conn.commit()
        logger.info("Transaction committed successfully.")
    except Exception as e:
        pg_conn.rollback()
        logger.error(f"ETL Pipeline aborted due to error: {e}", exc_info=True)
        sys.exit(1)
    finally:
        ora_conn.close()
        pg_conn.close()

    total_time = time.time() - t_start
    logger.info(f"ETL Complete: {grand_total} total operational rows migrated across {len(table_defs)} tables in {total_time:.2f}s ({grand_total/max(total_time, 0.001):.0f} avg rows/s).")


if __name__ == "__main__":
    run_pipeline()
