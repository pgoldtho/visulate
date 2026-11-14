# Property Management Domain Architecture in RNTMGR2

## Overview
The Property Management module in `RNTMGR2` models rental real estate operations, multi-tenant property portfolios, leasing lifecycles, and asset performance tracking.

## Core Entity Hierarchy & Relationships

### 1. Portfolio & Property Structure
- **`RNT_BUSINESS_UNITS`**: The top-level multi-tenant partitioning entity. Segregates assets and financial operations by landlord, property manager, or investment group.
- **`RNT_PROPERTIES`**: Physical real estate properties owned or managed under a business unit.
- **`RNT_PROPERTY_UNITS`**: Individual rentable spaces (apartments, suites, rooms) within a property. Inherits business unit context from `RNT_PROPERTIES`.

### 2. People & Tenancy Lifecycle
- **`RNT_PEOPLE`**: Master contact directory for individuals (tenants, owners, applicants, vendors).
- **`RNT_PEOPLE_BU`**: Scopes an individual to a specific business unit.
- **`RNT_TENANT`**: Detailed tenant profile linking to `RNT_PEOPLE_BU`, tracking current status, account balances, and Section 8 housing office relationships (`RNT_SECTION8_OFFICES_BU`).
- **`RNT_TENANCY_AGREEMENT`**: Lease agreements connecting a `RNT_TENANT` to a specific `RNT_PROPERTY_UNITS`. Defines lease dates, monthly rent, deposits, and payment frequencies.
- **`RNT_AGREEMENT_ACTIONS`**: Action history and audit log for lease milestones (e.g., invoices generated, notices issued, renewal letters sent).

### 3. Asset Financials & Analytics
- **`RNT_PROPERTY_EXPENSES`**: Tracks direct operational expenses allocated to specific properties or units.
- **`RNT_LOANS`**: Records mortgages, notes, and financing terms secured by properties.
- **`RNT_PROPERTY_VALUE`**: Historical tracking of property valuations over time (actual purchase price, comp appraisals, CAP rate calculations).
- **`RNT_PROPERTY_ESTIMATES`**: Acquisition and performance projection models (pro forma NOI, cash flow, debt service).

### 4. Property Assets & Media
- **`RNT_PROPERTY_PHOTOS`**: Photo gallery URLs and descriptions linked to properties.
- **`RNT_PROPERTY_LINKS`**: External document links and online resource references.
