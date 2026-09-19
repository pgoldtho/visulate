# Visulate Architectural Knowledge Base

This directory contains database architectural memories, object mappings, and generated artifacts maintained by the Visulate AI Root Agent and specialized microservices.

## Directory Structure

| Component | Description |
| :--- | :--- |
| `<db>/oracle-code-map.json` | Cross-reference index mapping database objects to repository source files. |
| `<db>/codebase-dependencies.md` | Human-readable architectural summary of database objects and codebase references. |
| `<db>/memories/` | Functional schema summaries, domain context, and architectural decisions. |
| `<db>/structures/` | Structural analyses, object schemas, and entity relationships. |
| `<db>/erd/` | Entity Relationship Diagrams in Draw.io XML format. |
| `<db>/comments/` | Generated Oracle data dictionary `COMMENT ON` scripts. |
| `<db>/remediation/` | Diagnostic root-cause reports and SQL remediation scripts for invalid database objects. |
| `<db>/test-data/` | Generated test data suites (SQL inserts, CSV, and SQL*Loader CTL/DAT files). |
| `<db>/reports/` | Schema comparison and impact analysis reports. |

---

## Database Environments

### Database: `pdb21`

#### Codebase Dependencies
- **Codebase Mapping**: [`oracle-code-map.json`](pdb21/oracle-code-map.json) (222 database objects mapped across 930 source files)
- **Dependency Summary**: [`codebase-dependencies.md`](pdb21/codebase-dependencies.md)

#### Architectural Memories (`memories/`)
| File | Title / Summary |
| :--- | :--- |
| [`application_database_interaction_pattern.md`](pdb21/memories/application_database_interaction_pattern.md) | **Application-to-Database Interaction Pattern in Visulate** - The Visulate architecture enforces strict encapsulation between the web application layer (PHP) and the database storage... |
| [`comparison_pdb21_pdb22.md`](pdb21/memories/comparison_pdb21_pdb22.md) | **Cross-Database Comparison: pdb21 (Source) vs pdb22 (Target)** - A structural and data comparison between database instances `pdb21` and `pdb22` shows: |
| [`general_ledger_architecture.md`](pdb21/memories/general_ledger_architecture.md) | **General Ledger (GL) Accounting Architecture in RNTMGR2** - Business Unit Scoping**: Every account in `RNT_ACCOUNTS` is scoped to a specific `BUSINESS_ID` (`RNT_BUSINESS_UNITS`), e... |
| [`property_management_architecture.md`](pdb21/memories/property_management_architecture.md) | **Property Management Domain Architecture in RNTMGR2** - The Property Management module in `RNTMGR2` models rental real estate operations, multi-tenant property portfolios, leas... |
| [`schema_rntmgr2_summary.md`](pdb21/memories/schema_rntmgr2_summary.md) | **Schema Summary: RNTMGR2 (Database: pdb21)** - The `RNTMGR2` schema is the core database underpinning **Visulate**, combining large-scale Florida real estate intellige... |

#### Object Structures (`structures/`)
| File | Object / Summary |
| :--- | :--- |
| [`rnt_pt_rules.md`](pdb21/structures/rnt_pt_rules.md) | **Table Structure: RNT_PT_RULES (RNTMGR2.RNT_PT_RULES)** - `RNT_PT_RULES` (Payment Transaction Rules) is the configuration table driving Visulate's automated double-entry General ... |

#### Generated Artifacts
- **Entity Relationship Diagrams (`erd/`)**
  - [`RNTMGR2_Property_Management_Sub_system_RNTMGR2_pdb21_20260919_162648.drawio`](pdb21/erd/RNTMGR2_Property_Management_Sub_system_RNTMGR2_pdb21_20260919_162648.drawio)

---

*Maintained automatically by Visulate Root Agent. Last updated: 2026-09-19 16:59:10*
