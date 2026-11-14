# code/database/reports

**Functional Overview**:
This directory contains SQL*Plus scripts and their corresponding sample outputs for generating detailed financial reports related to property payments. Specifically, it provides a payment summary that categorizes both income and expenses across various properties and payment types for a specified year and business unit.

**Files & Component Responsibilities**:

*   `tax_summary.sql`: This is a SQL*Plus script designed to generate a comprehensive payment summary. It queries multiple database tables to compile income and expense data, grouping results by property address and payment type. The script then calculates and displays sums at both the property level and the overall report level. Note that specific parameters like the reporting year (`'2007'`) and business unit (`21`) are hardcoded within the script.
*   `tax.LST`: This file serves as a sample output generated from executing the `tax_summary.sql` script. It demonstrates the structured format of the report, showcasing the breakdown of income and expenses for various properties, including payment types, amounts, and sub-totals.

**Database Dependencies & Interactions**:
The `tax_summary.sql` script relies on several database tables to retrieve and aggregate financial data:

*   **`RNT_PAYMENT_TYPES`** (Table, Owner: `RNTMGR2`): This table is fundamental for categorizing all financial transactions by their specific payment type (e.g., 'Rent', 'Late Fee', 'Mortgage Payment P&I'). It ensures that income and expenses are correctly classified in the report.
*   **`RNT_ACCOUNTS_RECEIVABLE`**: Used to fetch all income-related payment records. The script filters these records by `payment_type`, the year derived from `payment_due_date`, and `business_id`.
*   **`RNT_PAYMENT_ALLOCATIONS`**: This table acts as a linking mechanism, connecting the `RNT_ACCOUNTS_RECEIVABLE` and `RNT_ACCOUNTS_PAYABLE` records to their actual allocated payment amounts.
*   **`RNT_PROPERTIES`**: Provides property details, specifically the `address1`, which is used to group payments by the associated property.
*   **`RNT_ACCOUNTS_PAYABLE`**: Used to retrieve all expense-related payment records, filtered by criteria similar to `RNT_ACCOUNTS_RECEIVABLE`.

**Submodules / Subdirectories**:
This directory does not contain any subdirectories.

**Maintenance & Modernization Notes**:

*   **Hardcoded Parameters**: The `tax_summary.sql` script currently includes hardcoded values for the reporting year (`'2007'`) and the `business_id` (`21`). For improved flexibility and reusability, these values should ideally be replaced with bind variables or input parameters, allowing the report to be generated for different periods or business units without direct script modification.
*   **SQL*Plus Specific Commands**: The script extensively uses SQL*Plus-specific commands (`col`, `Prompt`, `break on`, `compute sum`) for formatting and aggregation. If this reporting functionality were to be migrated to a different application environment (e.g., a PHP-based web report or another BI tool), these commands would need to be translated into standard SQL (e.g., using analytic functions) or handled by the new reporting framework.
*   **Performance Considerations**: For very large datasets, the extensive joins and `GROUP BY` clauses, particularly with the `TO_CHAR(ar.payment_due_date, 'YYYY')` function in the `WHERE` clause, could impact performance. Ensuring appropriate indexes are in place on columns used in `WHERE` and `JOIN` clauses (e.g., `payment_due_date`, `payment_type_id`, `ar_id`, `property_id`, `business_id`) could be beneficial. Alternatively, consider rewriting the query or using materialized views for heavily accessed reports.
