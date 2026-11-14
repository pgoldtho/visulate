# code/php/template_files

## Functional Overview

This directory contains Microsoft Excel template files (`.xlsx` and `.xls`) that are utilized by PHP scripts within the Visulate codebase. These templates serve as layouts for generating various reports or data exports, primarily related to address information and single property details. They act as static structures that consuming PHP applications populate with dynamic data.

## Files & Component Responsibilities

*   **`address2.xlsx`**: An Excel template designed for generating reports or data exports concerning address information. This file uses the modern Office Open XML format (`.xlsx`). It likely provides a structured layout for displaying address-related fields.
*   **`address2irr.xls`**: An Excel template, also used for address data. The `.xls` extension indicates it's in the older Excel Binary File Format (BIFF). The "irr" suffix might denote a specific variation (e.g., "irregular," "irrigation," or a different report type) of the address report, distinct from `address2.xlsx`.
*   **`single_property2.xls`**: An Excel template for exporting or reporting on detailed information for a single property. This file also uses the older `.xls` format. It provides a structured layout for property-specific fields.

## Database Dependencies & Interactions

The files in this directory are static Excel templates and do not directly contain any database interaction logic or embedded queries. They are consumers of data.

However, the PHP scripts that utilize these templates are responsible for fetching data from the underlying database (details of which are outside the scope of this directory's README) and populating these templates to generate final Excel documents. Therefore, while these files themselves have no direct database dependencies, their effective use is entirely dependent on database-sourced data provided by upstream PHP components.

## Submodules / Subdirectories

This directory contains no subdirectories or submodules.

## Maintenance & Modernization Notes

*   **Format Consistency**: The presence of both `.xlsx` and `.xls` formats suggests a need to support older Excel versions or a gradual transition. For modernization, standardizing on the `.xlsx` format (which offers better features, compression, and XML structure) might be beneficial, deprecating the `.xls` files if older Excel compatibility is no longer required.
*   **Template Structure Updates**: Any changes to the data models or reporting requirements (e.g., adding, removing, or renaming fields) will necessitate manual updates to these Excel template files to ensure correct data mapping and presentation.
*   **Dynamic Generation**: If the complexity of reports grows, consider if these templates could be partially or fully generated programmatically by PHP, rather than relying solely on static files. This could offer greater flexibility and reduce manual template maintenance.
*   **Formulas and Formatting**: Be mindful of complex formulas, macros, or conditional formatting embedded directly within the templates. These can be fragile and hard to maintain if not well-documented and consistently updated with data source changes.
