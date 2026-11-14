# `code/php/_smarty/templates/reports`

## Functional Overview
This directory contains a collection of Smarty template files (`.tpl`) used to render various financial, property, and general ledger reports within the Visulate application. These templates are designed to display data fetched from the backend PHP controllers in a structured and readable format, often with support for both HTML display and PDF generation. They leverage common header and footer templates to ensure consistent styling and branding across reports.

## Files & Component Responsibilities

| File Name             | Description                                                                                                                                              |
| :-------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `expense-details.tpl` | Displays a detailed breakdown of expenses, typically grouped by property or business unit, including due date, vendor, description, and amount.               |
| `gl-balance.tpl`      | Renders a balance sheet report, categorizing and summing current assets, long-term assets, liabilities, and equity for a given business unit and effective date. |
| `gl-details.tpl`      | Presents a detailed general ledger report, listing individual transactions with account, date, description, debit, credit, and running balance.               |
| `gl-history.tpl`      | Displays a historical view of general ledger entries, showing date, entry description, debit/credit accounts, and amount.                                  |
| `gl-income.tpl`       | Generates an income statement (Profit & Loss report), summarizing revenues and expenses over a period based on a specified accounting basis.                  |
| `gl-summary.tpl`      | Provides a summarized general ledger report, showing total debits and credits for each account within a specified period.                                  |
| `owner-details.tpl`   | Renders comprehensive details for a property owner, including corporate ID (if applicable), mailing address, and a chronological transaction history of property sales and purchases. |
| `owner-list.tpl`      | Lists property owners, their mailing addresses, and associated property usage, with links to detailed owner and property reports.                             |
| `pr-multi-owner.tpl`  | Displays a list of owners who possess multiple properties, categorized by property type, along with the count of properties.                                  |
| `pr-property-details.tpl` | Provides extensive details for a specific property, including usage, address, size (square footage, acreage), and integrates with a Yahoo Maps API for location visualization. |
| `pr-sales-summary.tpl` | Presents a summary of sales transactions, grouped by transaction type (deed code), with links to view recent sales for specific types.                     |
| `property-details.tpl` | Shows a summary of details for a specific property or a set of properties, including address, number of units, building size, year built, and description. |
| `property-summary.tpl` | Provides a high-level summary list of properties, displaying address, units, size, year built, and description for a business unit.                        |
| `report-footer.tpl`   | A shared Smarty template that defines the common closing HTML tags (e.g., `</body></html>`) for reports, typically included at the end of PDF reports.      |
| `report-header.tpl`   | A shared Smarty template providing the common HTML header for reports, including title, base styling, and the Visulate logo, for both web and PDF rendering. |
| `seller-list.tpl`     | Presents two lists: buyers with their purchase counts and sellers with their sale counts, with links to owner details.                                     |
| `tenant-statement.tpl` | Generates a detailed statement for tenants, outlining agreement dates, unit details, tenant names, unpaid balances, deposit balances, and last month balances. |
| `year-tax.tpl`        | Creates an annual income and expenses report, likely for tax purposes, providing a summary per property with total income, expenses, and overall totals.     |

## Database Dependencies & Interactions
The templates in this directory do not directly interact with the database. They are Smarty `.tpl` files, which means they are responsible solely for presentation. All data displayed in these reports (e.g., `$data`, `$PrmBusinessName`, `$item`) is passed to them as variables from the PHP application layer (controllers/models) that prepares the report data by querying the database.

## Submodules / Subdirectories
This directory contains no subdirectories.

## Maintenance & Modernization Notes
*   **Smarty Syntax**: All files are Smarty templates, requiring familiarity with Smarty templating language for modifications.
*   **Styling**: Many templates embed specific `<style>` blocks or rely on the `report-header.tpl` for styling. Consolidating CSS into external stylesheets or a unified internal block in the header would improve maintainability.
*   **PDF Generation**: The `if ($is_pdf_report)` blocks indicate conditional styling or content for PDF output. Ensure consistency and appropriate rendering when updating styles or layouts.
*   **Custom Functions**: The `{show_number number=$variable}` syntax suggests a custom Smarty function for number formatting. Any changes to numerical display should consider this function's implementation.
*   **External APIs**: `pr-property-details.tpl` utilizes the Yahoo Maps API. This API is deprecated and should be updated to a modern mapping solution (e.g., Google Maps, OpenStreetMap) to ensure continued functionality and security.
*   **Parameter Display**: Most reports display input parameters (e.g., `Business Unit`, `Period`) in a tabular format at the top. This provides good context but should be maintained consistently across new reports.
