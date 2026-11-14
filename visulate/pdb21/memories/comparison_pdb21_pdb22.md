# Cross-Database Comparison: pdb21 (Source) vs pdb22 (Target)

## Executive Summary
A structural and data comparison between database instances `pdb21` and `pdb22` shows:
- **Operational ERP (`RNT_*`) Match**: Identical table schemas and nearly identical row counts (General Ledger, Chart of Accounts, Invoices, Payables, Posting Rules are 100% in sync).
- **Public Records Warehouse (`PR_*`, `MLS_*`, `SUNBIZ_*`)**: Fully populated with 130M+ records in `pdb21`, but completely empty (0 rows) in `pdb22`. This indicates `pdb22` is configured as a development/testbed environment.
- **New Tables in `pdb22`**: Three tables exist exclusively in `pdb22`: `RNT_COUNTY_DESCRIPTIONS` (67 rows), `RNT_MLS_COUNTY_PAGES` (19 rows), and `RNT_TAX_SOURCES` (22 rows).
- **Table Missing in `pdb22`**: `DBTOOLS$MCP_LOG` exists only in `pdb21` (29 rows).
- **Invalid Objects**:
  - `PR_RETS_PKG` and `RNT_USER_MAIL_PKG` are invalid in both databases due to missing execute grants on `DBMS_CRYPTO` and `UTL_MAIL`.
  - `RNT_PROPERTIES_PKG` is valid in `pdb22` but invalid in `pdb21`.
  - 7 analytical materialized views (`PR_*_MV`) are valid in `pdb21`, but invalid in `pdb22` due to underlying `PR_` tables having 0 rows.
