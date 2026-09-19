# Schema Summary: RNTMGR2

## Overview
The `RNTMGR2` schema serves as the primary backend database for the **Visulate Real Estate and Property Management Platform**, combining operational property/lease management with double-entry accounting and an analytical public records/MLS data warehouse.

## Core Business Domains

### 1. Property Management & Lease Administration (`RNT_*`)
- **`RNT_BUSINESS_UNITS`**: Multi-tenant/portfolio boundary separating properties by ownership entity or commercial/residential classification.
- **`RNT_PROPERTIES` & `RNT_PROPERTY_UNITS`**: Physical asset hierarchy of managed buildings and rentable suites/units.
- **`RNT_TENANCY_AGREEMENT` & `RNT_TENANT`**: Lease lifecycle, payment terms, discounts/fees, move-in/out records.
- **`RNT_AGREEMENT_ACTIONS`**: Legal eviction workflows, notices, and court actions.
- **`RNT_PEOPLE` / `RNT_PEOPLE_BU`**: Unified party directory linking people to business units and roles.

### 2. Financial Management & Double-Entry Accounting
- **`RNT_ACCOUNTS` & `RNT_DEFAULT_ACCOUNTS`**: Chart of accounts per business unit (Assets, Liabilities, Equity, Income, Expenses).
- **`RNT_ACCOUNTS_RECEIVABLE` (AR)** & **`RNT_ACCOUNTS_PAYABLE` (AP)**: Automated lease billing vs. vendor maintenance expenses.
- **`RNT_PAYMENTS` & `RNT_PAYMENT_ALLOCATIONS`**: Payment collection and disbursement allocation across AR/AP line items.
- **`RNT_PT_RULES` & `RNT_LEDGER_ENTRIES`**: Posting transaction rules engine translating AR/AP and payments into general ledger journal entries.
- **`RNT_ACCOUNT_PERIODS` & `RNT_ACCOUNT_BALANCES`**: Fiscal period close control and rolling balance tracking.
- **`RNT_LOANS`**: Mortgage and credit line tracking against properties.

### 3. Public Records & Market Intelligence (`PR_*`, `MLS_*`, `SUNBIZ*`)
- **`PR_PROPERTIES` / `PR_LOCATIONS`**: County property records with Oracle Spatial (`SDO_GEOMETRY`) and Oracle Text fuzzy indexing.
- **`PR_PROPERTY_SALES` & `PR_PROPERTY_VALUES`**: Deed transaction histories and tax appraisal assessments.
- **`PR_CORPORATIONS` & `PR_PRINCIPALS`**: Corporate registry records (Florida Sunbiz) linking ownership entities to officers.
- **`MLS_LISTINGS` & `MLS_PHOTOS`**: RETS syndicated MLS listings and photos for active real estate inventory.
- **`ACS_*` / `PUMA_*`**: US Census and American Community Survey demographic data.

### 4. Application Framework & Navigation
- **`RNT_USERS`, `RNT_USER_ROLES`, `RNT_USER_ASSIGNMENTS`**: Role-based access control.
- **`RNT_MENUS`, `RNT_MENU_TABS`, `RNT_MENU_ROLES`**: Dynamic web application 3-tier menu navigation layer.
