-- =============================================================================
-- Migration 002: ANSI SQL Views & Dynamic Ledger Aggregations
-- Subsystem: Property Management (pdb22.RNTMGR2 -> PostgreSQL 16+)
-- Description: Modernizes Oracle (+) outer join views to ANSI SQL, replaces the
--              static RNT_ACCOUNT_BALANCES snapshot table with dynamic balances,
--              and establishes views for active leases, AR aging, and trial balance.
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. Active Tenancy Agreements View
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW v_active_tenancy_agreements AS
SELECT 
    ta.agreement_id,
    ta.unit_id,
    p.property_id,
    p.business_id,
    p.address1 || COALESCE(' Unit ' || pu.unit_name, '') AS full_address,
    p.city,
    p.state,
    p.zipcode,
    ta.start_date,
    ta.end_date,
    ta.amount AS monthly_rent,
    ta.deposit,
    ta.last_month,
    ta.status AS agreement_status,
    t.tenant_id,
    pe.first_name || ' ' || pe.last_name AS tenant_name,
    pe.phone1 AS tenant_phone,
    pe.email AS tenant_email
FROM rnt_tenancy_agreement ta
JOIN rnt_property_units pu ON ta.unit_id = pu.unit_id
JOIN rnt_properties p ON pu.property_id = p.property_id
LEFT JOIN rnt_tenant t ON ta.tenant_id = t.tenant_id
LEFT JOIN rnt_people pe ON t.people_id = pe.people_id
WHERE ta.status = 'ACTIVE';

COMMENT ON VIEW v_active_tenancy_agreements IS 'Active leases joined with unit, property, and primary tenant contact details.';

-- -----------------------------------------------------------------------------
-- 2. Accounts Receivable Aging View
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW v_ar_aging AS
SELECT 
    ar.ar_id,
    ar.agreement_id,
    COALESCE(ar.business_id, p.business_id, t.business_id) AS business_id,
    p.name AS property_name,
    p.address1 AS property_address,
    pu.unit_name,
    pe.first_name || ' ' || pe.last_name AS tenant_name,
    ar.due_date,
    ar.amount AS total_amount,
    ar.amount_paid,
    (ar.amount - ar.amount_paid) AS balance_due,
    CURRENT_DATE - ar.due_date AS days_past_due,
    CASE 
        WHEN CURRENT_DATE <= ar.due_date THEN 'CURRENT'
        WHEN CURRENT_DATE - ar.due_date BETWEEN 1 AND 30 THEN '1-30 DAYS'
        WHEN CURRENT_DATE - ar.due_date BETWEEN 31 AND 60 THEN '31-60 DAYS'
        WHEN CURRENT_DATE - ar.due_date BETWEEN 61 AND 90 THEN '61-90 DAYS'
        ELSE '90+ DAYS'
    END AS aging_bucket
FROM rnt_accounts_receivable ar
LEFT JOIN rnt_tenancy_agreement ta ON ar.agreement_id = ta.agreement_id
LEFT JOIN rnt_property_units pu ON ta.unit_id = pu.unit_id
LEFT JOIN rnt_properties p ON pu.property_id = p.property_id
LEFT JOIN rnt_tenant t ON COALESCE(ar.tenant_id, ta.tenant_id) = t.tenant_id
LEFT JOIN rnt_people pe ON t.people_id = pe.people_id
WHERE ar.status IN ('OPEN', 'PARTIAL');

COMMENT ON VIEW v_ar_aging IS 'Aging analysis for unpaid and partially paid accounts receivable charges.';

-- -----------------------------------------------------------------------------
-- 3. Dynamic Account Balances View (Replaces RNT_ACCOUNT_BALANCES table)
-- -----------------------------------------------------------------------------
-- Uses a unified UNION ALL CTE for debits and credits so that credit-only months
-- on liability/equity/revenue accounts are preserved without missing rows.
CREATE OR REPLACE VIEW v_account_period_balances AS
WITH account_entries AS (\
    SELECT 
        le.business_id,
        le.debit_account AS account_id,
        DATE_TRUNC('month', le.entry_date)::DATE AS period_month,
        le.amount AS debit_amount,
        0.00::NUMERIC(12,2) AS credit_amount
    FROM rnt_ledger_entries le
    UNION ALL
    SELECT 
        le.business_id,
        le.credit_account AS account_id,
        DATE_TRUNC('month', le.entry_date)::DATE AS period_month,
        0.00::NUMERIC(12,2) AS debit_amount,
        le.amount AS credit_amount
    FROM rnt_ledger_entries le
),
period_sums AS (
    SELECT 
        ae.business_id,
        ae.account_id,
        ae.period_month,
        SUM(ae.debit_amount) AS total_debit,
        SUM(ae.credit_amount) AS total_credit
    FROM account_entries ae
    GROUP BY ae.business_id, ae.account_id, ae.period_month
)
SELECT 
    a.account_id,
    a.business_id,
    a.account_number,
    a.account_name,
    a.account_type,
    ps.period_month,
    ps.total_debit,
    ps.total_credit,
    CASE 
        WHEN a.account_type IN ('ASSET', 'EXPENSE') 
            THEN ps.total_debit - ps.total_credit
        ELSE ps.total_credit - ps.total_debit
    END AS net_balance
FROM rnt_accounts a
JOIN period_sums ps ON a.account_id = ps.account_id AND a.business_id = ps.business_id;

COMMENT ON VIEW v_account_period_balances IS 'Monthly dynamic trial balance by account derived from ledger entries, replacing legacy snapshot table.';

-- -----------------------------------------------------------------------------
-- 4. Unified Ledger Transactions View
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW v_ledger_transactions AS
SELECT 
    le.ledger_id,
    le.business_id,
    le.entry_date,
    le.description,
    le.amount,
    'DEBIT' AS entry_direction,
    le.debit_account AS account_id,
    da.account_number,
    da.account_name,
    da.account_type,
    le.property_id,
    p.address1 AS property_address,
    le.ar_id,
    le.ap_id,
    le.pay_alloc_id,
    le.created_at
FROM rnt_ledger_entries le
JOIN rnt_accounts da ON le.debit_account = da.account_id
LEFT JOIN rnt_properties p ON le.property_id = p.property_id
UNION ALL
SELECT 
    le.ledger_id,
    le.business_id,
    le.entry_date,
    le.description,
    le.amount,
    'CREDIT' AS entry_direction,
    le.credit_account AS account_id,
    ca.account_number,
    ca.account_name,
    ca.account_type,
    le.property_id,
    p.address1 AS property_address,
    le.ar_id,
    le.ap_id,
    le.pay_alloc_id,
    le.created_at
FROM rnt_ledger_entries le
JOIN rnt_accounts ca ON le.credit_account = ca.account_id
LEFT JOIN rnt_properties p ON le.property_id = p.property_id;

COMMENT ON VIEW v_ledger_transactions IS 'Individual balanced debit and credit legs for general ledger transactions.';

-- -----------------------------------------------------------------------------
-- 5. Properties & Units Portfolio Summary View
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW v_properties_summary AS
SELECT 
    p.property_id,
    p.business_id,
    bu.business_name,
    p.name AS property_name,
    p.address1,
    p.city,
    p.state,
    p.zipcode,
    p.status AS property_status,
    p.units AS declared_units,
    COUNT(pu.unit_id) AS active_units_count,
    COUNT(CASE WHEN pu.status = 'OCCUPIED' THEN 1 END) AS occupied_units_count,
    COUNT(CASE WHEN pu.status = 'VACANT' THEN 1 END) AS vacant_units_count,
    ROUND(
        CASE 
            WHEN COUNT(pu.unit_id) > 0 
                THEN (COUNT(CASE WHEN pu.status = 'OCCUPIED' THEN 1 END)::NUMERIC / COUNT(pu.unit_id)::NUMERIC) * 100 
            ELSE 0.00 
        END, 2
    ) AS occupancy_rate,
    COALESCE(SUM(pu.target_rent), 0.00) AS potential_gross_rent,
    p.geom
FROM rnt_properties p
JOIN rnt_business_units bu ON p.business_id = bu.business_id
LEFT JOIN rnt_property_units pu ON p.property_id = pu.property_id
GROUP BY p.property_id, p.business_id, bu.business_name, p.name, p.address1, p.city, p.state, p.zipcode, p.status, p.units, p.geom;

COMMENT ON VIEW v_properties_summary IS 'Portfolio rollup of properties with unit counts, occupancy rates, and spatial geometry.';
