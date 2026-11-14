# Bookkeeping Specifications

This directory (`specs/Bookkeeping`) contains design and specification documents related to the core bookkeeping and general ledger functionality within the Visulate application. It outlines requirements for moving from a single-entry to a double-entry bookkeeping system, defines data models for chart of accounts and payment rules, and specifies reporting needs.

## Functional Overview

The documents in this directory lay the foundation for Visulate's financial accounting system. They detail the "must-have" features for bookkeeping, including the implementation of a double-entry general ledger, the ability to track owner's equity, support for various financial reports (Profit & Loss, Balance Sheet, Rent Roll, Trial Balance), and the management of default and custom accounts and payment rules. These specifications were critical in the evolution of Visulate's financial capabilities.

## Files & Component Responsibilities

| File                                | Description                                                                                                                                                                                                                                    |
| :---------------------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `VISULATE - Trial Balance Report-5.docx` | A Microsoft Word document likely containing the design, layout, and functional specifications for the Visulate Trial Balance Report.                                                                                                            |
| `Visulate MOSCOW.doc`               | This document outlines the "Must-Have" requirements using the MOSCOW method (Must-have, Should-have, Could-have, Won't-have) for Visulate's bookkeeping features. It specifically mentions the General Ledger and tracking owner's equity.     |
| `chart_of_accounts.vsd`             | A Microsoft Visio diagram detailing the structure, relationships, and types of accounts within the Visulate Chart of Accounts. It serves as a visual data model for the accounting structure.                                                     |
| `general_ledger.doc`                | A comprehensive specification document detailing the design and implementation concepts for the Visulate General Ledger. It outlines the transition to double-entry bookkeeping and requirements for account balances and financial transactions. |
| `pt_rules.vsd`                      | A Microsoft Visio diagram illustrating the design and flow for payment rules, likely showing how transactions are classified and posted to accounts.                                                                                              |
| `~$neral_ledger.doc`                | A temporary Microsoft Word lock file. This file can be safely ignored.                                                                                                                                                                         |

## Database Dependencies & Interactions

The design documents in this directory specify interactions with several key database objects, which are implemented in the `RNTMGR2` schema:

*   **`RNT_ACCOUNT_BALANCES` (TABLE)**: This table is central to the double-entry system, storing the balances for various accounts over different accounting periods. `general_ledger.doc` specifies its role in maintaining accurate financial states. It is managed by `rnt_account_balances_pkg.sql` and `rnt_account_periods_pkg.sql`.
*   **`RNT_ACCOUNTS` (TABLE)**: This table holds the master list of all accounts in the Chart of Accounts. Its structure and usage are detailed in `general_ledger.doc` and `chart_of_accounts.vsd`. It is interacted with by various PL/SQL packages (`rnt_accounts_pkg.sql`, `rnt_ledger_pkg.sql`) and PHP classes (e.g., `rnt_ledger.class.php`, `rnt_reports.class.php`) for account management and reporting.
*   **`RNT_DEFAULT_ACCOUNTS` (TABLE)**: This table stores predefined or standard accounts, likely used when setting up new properties or businesses. `general_ledger.doc` would likely describe how these defaults are applied. It is managed by `rnt_accounts_pkg.sql`, `rnt_default_accounts_pkg.sql`, and `rnt_ledger_pkg.sql`.
*   **`RNT_DEFAULT_PT_RULES` (TABLE)**: This table contains default payment rules, which dictate how different types of transactions (e.g., rent payments, expenses) are automatically categorized and posted to the general ledger. `pt_rules.vsd` visually elaborates on these rules. It is managed by `rnt_default_pt_rules_pkg.sql`, `rnt_ledger_pkg.sql`, and `rnt_pt_rules_pkg.sql`.

These documents provide the architectural blueprint for how Visulate's financial modules interact with these database tables to achieve robust bookkeeping capabilities.

## Maintenance & Modernization Notes

*   **Legacy Document Formats**: The prevalence of `.doc` and `.vsd` files indicates that these are older specifications. When making changes to the bookkeeping system, cross-reference these documents carefully, as some details might have evolved or been partially implemented. Consider migrating critical design aspects to more modern, version-controllable formats (e.g., Markdown, Mermaid diagrams).
*   **Transition to Double-Entry**: A key theme in these specifications is the transition from single-entry to double-entry bookkeeping. Any refactoring or new feature development in the accounting modules should ensure strict adherence to double-entry principles and leverage the `RNT_ACCOUNT_BALANCES` table correctly.
*   **Diagram Interpretation**: The Visio diagrams (`.vsd` files) for `chart_of_accounts` and `pt_rules` are crucial for understanding the data models and business logic. Ensure access to Microsoft Visio or compatible software to interpret these visual specifications accurately.
*   **Database Object Alignment**: The documentation refers to database objects that are still active in the codebase. Any updates to the database schema or related PL/SQL packages and PHP classes should be validated against the principles laid out in these specification documents to maintain consistency and prevent regressions in financial logic.
