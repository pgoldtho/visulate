# Deterministic Database Migration Assessment: `pdb22.RNTMGR2`

- **Migration Path**: `oracle->postgres`
- **Complexity Level**: **C-5** — High complexity (multi-phase modernization / subsystem decomposition recommended)
- **Total Migration Cost Units**: `2393.1` (Base: `462.2`, Constructs: `1867.9`, Data Types: `63.0`, DB Links: `0.0`)
- **Estimated Pure-DB Conversion Effort**: ~**239.3** engineering day(s) *(excludes application rewrite, architecture redesign & QA)*
- **Inventory**: `708` objects, `2430` columns, `24864` PL/SQL/view lines, `9` invalid objects, `0` DB links
- **Measured Data Volume**: `497,076` total rows, `2.52 GB` total table segments, `19` table(s) with LOB/XML/LONG columns

## Object Inventory & Base Cost

| Object Type | Count | Unit Cost | Subtotal |
| :--- | ---: | ---: | ---: |
| INDEX | 272 | 0.1 | 27.2 |
| MATERIALIZED VIEW | 7 | 3.0 | 21.0 |
| PACKAGE | 74 | 1.0 | 74.0 |
| PACKAGE BODY | 74 | 3.0 | 222.0 |
| PROCEDURE | 1 | 2.0 | 2.0 |
| SEQUENCE | 51 | 0.1 | 5.1 |
| TABLE | 149 | 0.1 | 14.9 |
| TYPE | 16 | 2.0 | 32.0 |
| VIEW | 64 | 1.0 | 64.0 |

## Oracle Construct & Compatibility Findings

| Construct | Severity | Occurrences | Cost | Service Extraction? | Sample Objects | Guidance |
| :--- | :--- | ---: | ---: | :---: | :--- | :--- |
| `TYPE_ROWTYPE` | low | 3508 | 1218.5 | No | MLS_BREVARD_PKG, MLS_LISTINGS_PKG, MLS_MFR_PKG, MLS_PHOTOS_PKG, MLS_PRICE_RANGES_PKG (+63 more) | Verify %TYPE/%ROWTYPE anchors exist in PostgreSQL or replace with explicit types. |
| `UTL_HTTP` | high | 95 | 190.0 | Yes | MLS_BREVARD_PKG, MLS_MFR_PKG, MLS_SEF_PKG, PR_RETS_PKG | Move outbound HTTP calls out of the database into an application service. |
| `DBMS_LOB` | high | 31 | 93.0 | Yes | MLS_PRICE_RANGES_PKG, PR_RETS_PKG, RNT_AGREEMENT_ACTIONS_V, RNT_CITIES_V, RNT_DOC_TEMPLATES_V (+2 more) | Replace with PostgreSQL bytea/text functions or object storage. |
| `OUTER_JOIN_PLUS` | high | 46 | 92.0 | No | RNT_ACCOUNTS_RECEIVABLE_PKG, RNT_LEDGER_PKG, RNT_PAYMENTS_PKG, RNT_PROPERTIES_PKG, RNT_SUMMARY_PKG (+9 more) | Convert legacy (+) outer join syntax to explicit ANSI LEFT/RIGHT OUTER JOIN. |
| `UTL_SMTP_MAIL` | high | 14 | 70.0 | Yes | RNT_USER_MAIL_PKG, SEND_MAIL | Move email dispatch out of PL/SQL into an application notification service. |
| `DB_LINK_REF` | high | 15 | 60.0 | Yes | MLS_BREVARD_PKG, MLS_MFR_PKG, MLS_SEF_PKG, PR_RETS_PKG, RNT_ACCOUNTS_RECEIVABLE_PKG (+3 more) | Replace Oracle DB Links with API integration, postgres_fdw, or merged bounded context. |
| `PIPELINED` | medium | 14 | 42.0 | No | PR_GEO_UTILS_PKG, PR_RECORDS_PKG, RNT_GEN_PERIODS_PKG | Convert to PostgreSQL RETURNS SETOF / RETURN NEXT. |
| `NVL_NVL2` | low | 129 | 27.0 | No | MLS_MFR_PKG, MLS_SEF_PKG, PR_LOCATIONS_PKG, PR_PUMS_PKG, PR_RECORDS_PKG (+10 more) | Convert NVL to COALESCE and NVL2 to CASE WHEN ... IS NOT NULL. |
| `SYSDATE` | low | 72 | 14.4 | No | MLS_BREVARD_PKG, MLS_MFR_PKG, MLS_PRICE_RANGES_PKG, MLS_SEF_PKG, PR_RECORDS_PKG (+11 more) | Replace with CURRENT_TIMESTAMP or clock_timestamp() depending on transaction semantics. |
| `ROWNUM` | medium | 10 | 10.0 | No | MLS_BREVARD_PKG, MLS_MFR_PKG, MLS_SEF_PKG, PR_LOCATIONS_PKG, PR_RECORDS_PKG | Replace with LIMIT/OFFSET or ROW_NUMBER() OVER (...). |
| `BULK_COLLECT_FORALL` | medium | 4 | 10.0 | No | PR_RECORDS_PKG, SUNBIZ_PKG | Replace with set-based SQL, UNNEST arrays, or batch application writes. |
| `DBMS_OUTPUT` | low | 19 | 9.5 | No | PR_LOCATIONS_PKG, PR_PUMS_PKG, PR_RETS_PKG, RNT_ACCOUNTS_RECEIVABLE_PKG, RNT_LEDGER_PKG (+2 more) | Replace with RAISE NOTICE or application logging. |
| `EXECUTE_IMMEDIATE` | medium | 4 | 8.0 | No | MLS_PRICE_RANGES_PKG, PR_RECORDS_PKG | Convert to PL/pgSQL EXECUTE ... USING with bind parameters. |
| `CONNECT_BY` | high | 2 | 6.0 | No | RNT_SUMMARY_PKG, RNT_BUSINESS_UNITS_V | Rewrite using ANSI/PostgreSQL WITH RECURSIVE CTE. |
| `FROM_DUAL` | low | 50 | 5.0 | No | MLS_MFR_PKG, MLS_SEF_PKG, RNT_ACCOUNTS_PAYABLE_PKG, RNT_ACCOUNTS_RECEIVABLE_PKG, RNT_AGREEMENT_ACTIONS_PKG (+18 more) | Omit FROM DUAL in PostgreSQL SELECT statements. |
| `EXCEPTION_PRAGMA` | medium | 3 | 4.5 | No | RNT_PROPERTIES_PKG, RNT_SYS_CHECKSUM_REC_PKG | Map Oracle ORA- error codes to PostgreSQL SQLSTATE codes. |
| `MERGE_INTO` | medium | 2 | 4.0 | No | PR_PUMS_PKG, SUNBIZ_PKG | Verify against PostgreSQL 15+ MERGE or INSERT ... ON CONFLICT. |
| `DECODE` | low | 6 | 3.0 | No | RNT_ACCOUNTS_RECEIVABLE_PKG, RNT_PAYMENTS_PKG, RNT_SUMMARY_PKG | Convert to standard SQL CASE WHEN expression. |
| `START_WITH` | medium | 1 | 1.0 | No | RNT_BUSINESS_UNITS_V | Move START WITH predicate into recursive CTE anchor query. |

## Application Service Extraction Candidates (Avoid Literal PL/SQL Port)

| Object | Type | LOC | Signals |
| :--- | :--- | ---: | :--- |
| `PR_RECORDS_PKG` | PACKAGE BODY | 1959 | Large procedural unit (1959 LOC) |
| `RNT_LEDGER_PKG` | PACKAGE BODY | 1187 | Large procedural unit (1187 LOC) |
| `RNT_ACCOUNTS_RECEIVABLE_PKG` | PACKAGE BODY | 1070 | Large procedural unit (1070 LOC) |
| `PR_PUMS_PKG` | PACKAGE BODY | 1008 | Large procedural unit (1008 LOC) |
| `MLS_MFR_PKG` | PACKAGE BODY | 937 | UTL_HTTP (1x), DB_LINK_REF (3x) |
| `MLS_SEF_PKG` | PACKAGE BODY | 878 | UTL_HTTP (1x), DB_LINK_REF (3x) |
| `MLS_BREVARD_PKG` | PACKAGE BODY | 827 | UTL_HTTP (5x), DB_LINK_REF (3x) |
| `RNT_PROPERTIES_PKG` | PACKAGE BODY | 818 | Large procedural unit (818 LOC) |
| `RNT_ACCOUNTS_PAYABLE_PKG` | PACKAGE BODY | 594 | Large procedural unit (594 LOC) |
| `PR_RETS_PKG` | PACKAGE BODY | 518 | DBMS_LOB (3x), UTL_HTTP (82x), DB_LINK_REF (1x) |
| `SUNBIZ_PKG` | PACKAGE BODY | 460 | Large procedural unit (460 LOC) |
| `RNT_USERS_PKG` | PACKAGE BODY | 458 | DB_LINK_REF (1x) |
| `RNT_SUMMARY_PKG` | PACKAGE BODY | 455 | Large procedural unit (455 LOC) |
| `PR_LOCATIONS_PKG` | PACKAGE BODY | 445 | Large procedural unit (445 LOC) |
| `RNT_TENANCY_AGREEMENT_PKG` | PACKAGE BODY | 424 | Large procedural unit (424 LOC) |
| `MLS_PRICE_RANGES_PKG` | PACKAGE BODY | 389 | DBMS_LOB (12x) |
| `RNT_AGREEMENT_ACTIONS_PKG` | PACKAGE BODY | 265 | Large procedural unit (265 LOC) |
| `RNT_PROPERTY_ESTIMATES_PKG` | PACKAGE BODY | 264 | Large procedural unit (264 LOC) |
| `RNT_PEOPLE_PKG` | PACKAGE BODY | 259 | Large procedural unit (259 LOC) |
| `RNT_USER_MAIL_PKG` | PACKAGE | 170 | DB_LINK_REF (2x) |
| `RNT_ACCOUNTS_RECEIVABLE_PKG` | PACKAGE | 149 | DB_LINK_REF (1x) |
| `PR_RETS_PKG` | PACKAGE | 129 | UTL_HTTP (6x) |
| `RNT_USER_MAIL_PKG` | PACKAGE BODY | 119 | UTL_SMTP_MAIL (4x) |
| `RNT_SYS_CHECKSUM_REC_PKG` | PACKAGE BODY | 82 | DB_LINK_REF (1x) |
| `SEND_MAIL` | PROCEDURE | 35 | UTL_SMTP_MAIL (10x) |
| `RNT_CITIES_V` | VIEW | 29 | DBMS_LOB (4x) |
| `RNT_MENU_PAGES_V` | VIEW | 21 | DBMS_LOB (4x) |
| `RNT_AGREEMENT_ACTIONS_V` | VIEW | 19 | DBMS_LOB (2x) |
| `RNT_REGIONS_V` | VIEW | 13 | DBMS_LOB (4x) |
| `RNT_DOC_TEMPLATES_V` | VIEW | 10 | DBMS_LOB (2x) |

## Data Type Conversion Risks

| Table | Column | Source Type | Target Type | Risk | Note |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `DR$PR_PROPERTIES_CTX$K` | `TEXTKEY` | `ROWID` | `text` | high | Oracle ROWID has no stable equivalent in PostgreSQL; replace with surrogate/primary key. |
| `DR$PR_PROPERTIES_CTX$U` | `RID` | `ROWID` | `text` | high | Oracle ROWID has no stable equivalent in PostgreSQL; replace with surrogate/primary key. |
| `MLS_LISTINGS` | `GEO_LOCATION` | `SDO_GEOMETRY` | `geometry` | high | Requires PostGIS extension. |
| `MLS_LISTINGS_ARCHIVE` | `GEO_LOCATION` | `SDO_GEOMETRY` | `geometry` | high | Requires PostGIS extension. |
| `MLS_RETS_RESPONSES` | `RESPONSE` | `XMLTYPE` | `xml` | high | Verify XML functions (EXTRACTVALUE/XMLTABLE) or consider migrating to jsonb. |
| `PR_COMMERCIAL_PROPERTIES_V` | `GEO_LOCATION` | `SDO_GEOMETRY` | `geometry` | high | Requires PostGIS extension. |
| `PR_COMMERCIAL_PROPERTIES_V` | `GEO_COORDINATES` | `SDO_GEOMETRY` | `geometry` | high | Requires PostGIS extension. |
| `PR_GEO` | `GEOM` | `SDO_GEOMETRY` | `geometry` | high | Requires PostGIS extension. |
| `PR_GEO` | `GEOM_POINT` | `SDO_GEOMETRY` | `geometry` | high | Requires PostGIS extension. |
| `PR_GEO_STAGE` | `GEOM` | `SDO_GEOMETRY` | `geometry` | high | Requires PostGIS extension. |
| `PR_GEO_STAGE` | `GEOM_POINT` | `SDO_GEOMETRY` | `geometry` | high | Requires PostGIS extension. |
| `PR_LOCATIONS` | `GEO_LOCATION` | `SDO_GEOMETRY` | `geometry` | high | Requires PostGIS extension. |
| `PR_LOCATIONS_TMP` | `GEO_LOCATION` | `SDO_GEOMETRY` | `geometry` | high | Requires PostGIS extension. |
| `PR_PROPERTIES` | `GEO_LOCATION` | `SDO_GEOMETRY` | `geometry` | high | Requires PostGIS extension. |
| `PR_PROPERTIES` | `GEO_COORDINATES` | `SDO_GEOMETRY` | `geometry` | high | Requires PostGIS extension. |
| `PR_PROPERTIES_V` | `GEO_LOCATION` | `SDO_GEOMETRY` | `geometry` | high | Requires PostGIS extension. |
| `RNT_CITIES` | `GEO_LOCATION` | `SDO_GEOMETRY` | `geometry` | high | Requires PostGIS extension. |
| `RNT_CITIES_V` | `GEO_LOCATION` | `SDO_GEOMETRY` | `geometry` | high | Requires PostGIS extension. |
| `RNT_MENU_PAGES` | `HEADER_CONTENT` | `XMLTYPE` | `xml` | high | Verify XML functions (EXTRACTVALUE/XMLTABLE) or consider migrating to jsonb. |
| `RNT_MENU_PAGES_V` | `HEADER_CONTENT` | `XMLTYPE` | `xml` | high | Verify XML functions (EXTRACTVALUE/XMLTABLE) or consider migrating to jsonb. |
| `RNT_ZIPCODES` | `GEO_LOCATION` | `SDO_GEOMETRY` | `geometry` | high | Requires PostGIS extension. |

## Data Volume & Cutover Sizing Hotspots

| Table | Tier | Est. Rows | Segment Size | Contains LOBs |
| :--- | :--- | ---: | ---: | :---: |
| `RNT_ACCOUNTS_PAYABLE` | Medium | 29,042 | 352.0 MB | No |
| `MLS_LISTINGS_ARCHIVE` | Medium | 0 | 272.0 MB | No |
| `PR_LOCATIONS` | Medium | 0 | 256.0 MB | No |
| `TMP_TAX_VALUES` | Medium | 0 | 192.0 MB | No |
| `PR_PROPERTIES` | Medium | 0 | 192.0 MB | No |
| `PR_PROPERTY_SALES` | Medium | 0 | 176.0 MB | No |
| `PR_CORPORATIONS` | Medium | 0 | 136.0 MB | No |
| `PR_PRINCIPALS` | Medium | 0 | 128.0 MB | No |
| `PR_PROPERTY_PHOTOS` | Medium | 0 | 120.0 MB | No |
| `PR_CORPORATE_POSITIONS` | Medium | 0 | 112.0 MB | No |
| `PR_CORPORATE_LOCATIONS` | Medium | 0 | 104.0 MB | No |
| `MLS_PHOTOS_ARCHIVE` | Medium | 0 | 96.0 MB | No |
| `PR_PRINCIPAL_LOCATIONS` | Medium | 0 | 80.0 MB | No |
| `PR_OWNERS` | Medium | 0 | 72.0 MB | No |

## Invalid Objects in Source Schema

- `MATERIALIZED VIEW` `PR_COMMERCIAL_SALES_MV`
- `MATERIALIZED VIEW` `PR_COMMERCIAL_SUMMARY_MV`
- `MATERIALIZED VIEW` `PR_COUNTY_SUMMARY_MV`
- `MATERIALIZED VIEW` `PR_LAND_SALES_MV`
- `MATERIALIZED VIEW` `PR_LAND_SUMMARY_MV`
- `MATERIALIZED VIEW` `PR_SALES_MV`
- `MATERIALIZED VIEW` `PR_SALES_SUMMARY_MV`
- `PACKAGE BODY` `PR_RETS_PKG`
- `PACKAGE BODY` `RNT_USER_MAIL_PKG`
