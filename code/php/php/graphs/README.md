# PHP Graph Generation Scripts

## Functional Overview
This directory contains a collection of PHP scripts responsible for generating various financial and operational summary graphs for business units within the Visulate application. These scripts utilize the JpGraph library to visualize data such as cash flow, property net operating income (NOI), capitalization rates, uncollected income, and unpaid invoices. Each script fetches specific financial data for a given business unit and renders it as an image, typically for display within the application's reporting or dashboard sections. Access to these scripts is restricted to authenticated users with appropriate managerial or ownership roles.

## Files & Component Responsibilities

| File Name             | Description                                                                                             |
| :-------------------- | :------------------------------------------------------------------------------------------------------ |
| `cash_flow.php`       | Generates a line graph depicting the cash flow, income, and expense amounts over time for a business unit. |
| `prop_cap_rate.php`   | Produces a bar graph visualizing the capitalization rate for different properties within a business unit. |
| `prop_noi.php`        | Creates a bar graph showing the Net Operating Income (NOI) for various properties managed by a business unit. |
| `unc_inc_unp_inv.php` | Generates a combined bar graph illustrating both uncollected income and unpaid invoices over time for a business unit. |
| `uncollected_income.php` | Outputs a bar graph displaying the trend of uncollected income for a specific business unit.          |
| `unpaid_invoices.php` | Renders a bar graph showing the outstanding unpaid invoices over time for a given business unit.          |

## Database Dependencies & Interactions
The scripts in this directory primarily interact with the database through the `RNTSummaryAnalysis` class (defined in `classes/database/rnt_summary_analysis.class.php`) and, indirectly, `rnt_business_units.class.php`.

*   **`RNTSummaryAnalysis` Class**: This is the core data access layer for these graphs. Each script calls specific methods on an instance of this class to retrieve the necessary data:
    *   `cash_flow.php` uses `RNTSummaryAnalysis->getCashFlow($currentBUID)`.
    *   `prop_cap_rate.php` uses `RNTSummaryAnalysis->getNOI($currentBUID)` (the data retrieved includes `CAP_RATE_VALUE`).
    *   `prop_noi.php` uses `RNTSummaryAnalysis->getNOI($currentBUID)`.
    *   `unc_inc_unp_inv.php` uses `RNTSummaryAnalysis->getUncollectedIncome($currentBUID)` and `RNTSummaryAnalysis->getUnpaidInvoices($currentBUID)`.
    *   `uncollected_income.php` uses `RNTSummaryAnalysis->getUncollectedIncome($currentBUID)`.
    *   `unpaid_invoices.php` uses `RNTSummaryAnalysis->getUnpaidInvoices($currentBUID)`.

While specific database tables or views are abstracted by `RNTSummaryAnalysis`, it is inferred that the class queries underlying tables related to financial transactions, business unit properties, income, expenses, and invoices to compile the summary data required for these graphs.

## Submodules / Subdirectories
There are no subdirectories within `code/php/php/graphs`.

## Maintenance & Modernization Notes
*   **JpGraph Library**: The reliance on JpGraph indicates a potential for modernization. JpGraph is a mature but less actively developed library compared to modern client-side charting libraries (e.g., Chart.js, D3.js) or server-side alternatives. Migrating to a more current charting solution could improve performance, offer more interactive features, and simplify integration with modern web frontends.
*   **Code Structure**: The graph generation logic is embedded directly within these PHP files. For better maintainability and testability, consider separating data retrieval, data preparation, and graph rendering into distinct layers or dedicated classes.
*   **Dependency Management**: The use of `require_once dirname(__FILE__)."/../../classes/..."` for dependencies is characteristic of older PHP applications. Modernization would typically involve adopting PSR-4 autoloading standards.
*   **Input Handling**: The use of `$_REQUEST["BUSINESS_ID"]` is present. While access is guarded by authentication and authorization checks, ensuring that `$currentBUID` is properly sanitized and validated before use in database queries (if not already handled by `RNTSummaryAnalysis`) is crucial to prevent SQL injection or other vulnerabilities.
*   **Hardcoded Dimensions**: Graph dimensions like `new Graph(390, 300)` are hardcoded. For a more responsive and adaptable user experience, consider making graph dimensions dynamic or configurable.
