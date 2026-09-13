# Schema Summary: RNTMGR2 (Database: pdb21)

## Overview
The `RNTMGR2` schema is the core database underpinning **Visulate**, combining large-scale Florida real estate intelligence and public records aggregation with an operational multi-tenant rental property management and double-entry accounting ERP.

## Core Modules & Functional Areas

### 1. Macro Real Estate Intelligence & Public Records (`PR_`)
- **Parcels & Assessments**: Ingests county tax roll and property appraiser data (~9.2M properties in `PR_PROPERTIES`, ~44.2M records in `PR_TAXES`).
- **Sales & Ownership**: Tracks historical sales, transfers, deed types, and buyers/sellers (`PR_PROPERTY_SALES`, `PR_OWNERS`, `PR_PROPERTY_OWNERS`).
- **Spatial & Geographic**: Normalizes addresses, coordinates, and parcel polygons using Oracle Spatial `SDO_GEOMETRY` with spatial domain indexes (`PR_LOCATIONS`, `PR_GEO`).
- **Building Specifications**: Stores structural features and usage categorizations (`PR_BUILDINGS`, `PR_BUILDING_FEATURES`, `PR_BUILDING_USAGE`).

### 2. Operational Rental Management & Accounting ERP (`RNT_`)
- **Multi-Tenant Segregation**: Uses `RNT_BUSINESS_UNITS` to segregate properties and accounts by owner or investor group.
- **Inventory & Leases**: Manages rental units (`RNT_PROPERTY_UNITS`), tenant applications/leads (`RNT_LEADS`), tenant profiles (`RNT_TENANT`, `RNT_PEOPLE`), and tenancy agreements (`RNT_TENANCY_AGREEMENT`).
- **Double-Entry General Ledger**: Chart of accounts (`RNT_ACCOUNTS`), ledger transactions (`RNT_LEDGER_ENTRIES`), and accounting periods (`RNT_ACCOUNT_PERIODS`).
- **AR / AP & Payment Processing**: Invoicing and liability tracking (`RNT_ACCOUNTS_RECEIVABLE`, `RNT_ACCOUNTS_PAYABLE`, `RNT_SUPPLIERS_ALL`) with payment allocation algorithms (`RNT_PAYMENTS`, `RNT_PAYMENT_ALLOCATIONS`).

### 3. Multiple Listing Service (`MLS_`)
- RETS/MLS ingestion pipelines for active listings (`MLS_LISTINGS`), historical archives (~2.0M records in `MLS_LISTINGS_ARCHIVE`), broker information (`MLS_BROKERS`), and photo metadata (`MLS_PHOTOS`).
- Aggregates price range metrics across geographic tiers (`MLS_PRICE_RANGES`).

### 4. Corporate Registrations (`SUNBIZ_`)
- Syncs Florida Division of Corporations filings (`SUNBIZ`, `PR_CORPORATIONS`, `PR_CORPORATE_POSITIONS`) to map corporate entities, officers, and registered agents to physical real estate assets.

### 5. Demographics & Census (`ACS_`, `ASC_`, `PUMA_`)
- Ingests US Census ACS PUMS microdata, county millage rates, and demographic baselines for market analytics.

## Architectural Design Highlights
- **Optimistic Locking**: Base tables are paired with `*_V` abstraction views featuring row-level checksums calculated by `RNT_SYS_CHECKSUM_REC_PKG`.
- **Spatial and Text Indexing**: Extensive use of Oracle Spatial (`SDO_GEOMETRY`) and Oracle Text domain indexes (`DR$PR_PROPERTIES_CTX$*`).
