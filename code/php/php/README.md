# PHP Core Application Logic

This directory, `code/php/php`, serves as a central hub for a variety of PHP-based business logic and user interface interaction scripts within the Visulate application. It encompasses functionalities ranging from property data management and financial estimations to administrative tasks like menu configuration, image resizing, and managing relationships for business units (partners, people, suppliers, and Section 8 offices). Many scripts handle AJAX requests for dynamic content updates and data manipulation.

## Files & Component Responsibilities

| File Name                       | Description                                                                                                                                                                                                                                                               |
| :------------------------------ | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `PropertyDownloader.php`        | A class (`PropertyDownloader`) responsible for loading property data into a template Excel document and generating output, specifically populating "Properties" and "Estimates" sheets. It utilizes PHPExcel libraries.                                                      |
| `PropertyEstimatesDownloader.php` | A class (`PropertyEstimatesDownloader`) dedicated to populating an Excel spreadsheet with property estimate data. Similar to `PropertyDownloader.php`, it uses PHPExcel to generate the output based on a template.                                                         |
| `PropertyLoader.php`            | A class (`PropertyLoader`) designed to load property data from an Excel file, validating and extracting attributes such as address, size, units, and year built. It also uses PHPExcel.                                                                                     |
| `addBU-partner-search.php`      | An AJAX script facilitating the search for and addition of partners to specific business units. It includes authorization checks to ensure only business owners can perform this action.                                                                                     |
| `addBU-peoples-search.php`      | An AJAX script for searching and associating people (including transferring leads) with a business unit. It requires manager or manager-owner roles for execution.                                                                                                            |
| `addBU-section8-search.php`     | An AJAX script to search for and add Section 8 offices to business units. It performs existence checks and handles database insertion, requiring manager or manager-owner roles.                                                                                              |
| `addBU-supplier-search.php`     | An AJAX script enabling the search for and association of suppliers with business units, including the option to specify a tax identifier. It includes broad role-based access checks.                                                                                      |
| `addTenantExpense.php`          | Manages the process of adding tenant expenses. It provides functionality to either add an expense associated with a new supplier or an existing one, redirecting users based on their choices. Requires manager or manager-owner roles.                                        |
| `admin_menu-ajax.php`           | Provides AJAX functionality for the administrative interface, specifically for saving and managing multi-level application menus (`L3` menus and menu items). It uses the `RNTMenu` class for database interactions.                                                         |
| `estimate_params.php`           | Retrieves and displays parameters related to property estimates for a given property ID and year. It includes role-based access control and uses the `RNTEstimate` class.                                                                                                     |
| `resizeImg.php`                 | An image resizing utility, based on TimThumb (version 2.8.14). It handles image fetching, caching, resizing, and provides various configuration options for performance and security (e.g., external leeching, debug modes, memory limits).                                |
| `searchSuppliers.php`           | An AJAX script that searches for suppliers based on a provided search string and displays the results. It requires manager or manager-owner roles.                                                                                                                         |

## Database Dependencies & Interactions

This directory relies heavily on custom PHP classes located in the `../classes/database/` directory to interact with the underlying database. These classes abstract direct SQL queries and likely correspond to specific database tables or views.

*   **`rnt_users.class.php`**: Used by `addBU-partner-search.php` for user authentication and role management, likely interacting with a `RNT_USERS` table.
*   **`rnt_business_units.class.php`**: Frequently used across multiple `addBU-*-search.php` scripts and `addTenantExpense.php`, `estimate_params.php`, `searchSuppliers.php` for managing business unit relationships and retrieving business unit details. Implies interaction with a `RNT_BUSINESS_UNITS` table.
*   **`rnt_peoples.class.php`**: Used by `addBU-peoples-search.php` for managing people records and their association with business units. Suggests interaction with `RNT_PEOPLES` table.
*   **`rnt_leads.class.php`**: Used by `addBU-peoples-search.php` to transfer lead records to new business units. Implies interaction with `RNT_LEADS` table.
*   **`rnt_section8.class.php`**: Used by `addBU-section8-search.php` for managing Section 8 office associations with business units. Suggests interaction with `RNT_SECTION8` table.
*   **`rnt_supplier.class.php`**: Used by `addBU-supplier-search.php`, `addTenantExpense.php`, and `searchSuppliers.php` for managing supplier data and their business unit relationships. Implies interaction with `RNT_SUPPLIER` table.
*   **`rnt_menus.class.php`**: Used by `admin_menu-ajax.php` for saving and retrieving menu structures. Suggests interaction with `RNT_MENUS` and possibly `RNT_MENU_ITEMS` tables.
*   **`rnt_estimate.class.php`**: Used by `estimate_params.php` for managing property estimate parameters. Implies interaction with an `RNT_ESTIMATE` or similar table.
*   Database connections are managed by `SmartyInit.class.php`, which provides a database connection object (`$smarty->connection`). Transactions (commit/rollback) are explicitly handled in some scripts.

## Submodules / Subdirectories

*   **`graphs`**: This directory contains PHP scripts that generate various financial and operational graphs for business units using the JpGraph library, retrieving data through the `RNTSummaryAnalysis` class and enforcing user authentication and authorization.

## Maintenance & Modernization Notes

*   **Mixed Technologies**: The directory exhibits a mix of older PHP practices (e.g., `HTML_QuickForm`, `PHPExcel`, direct `require_once` statements) and a templating engine (`Smarty`). Modernizing these components could involve adopting Composer for dependency management, replacing `PHPExcel` with `PhpSpreadsheet`, and `HTML_QuickForm` with a more modern form builder library or a front-end framework.
*   **Image Resizing (`resizeImg.php`)**: The TimThumb library has a history of security vulnerabilities. While the version provided (2.8.14) may include patches, a thorough security review is recommended. Replacing it with a more actively maintained and secure image processing library (e.g., using PHP's GD or Imagick extensions directly, or a library like Intervention Image) would be a significant security enhancement.
*   **Code Structure**: There's a blend of procedural code and object-oriented programming. Refactoring toward a more consistent OOP approach, perhaps using a framework, would improve maintainability and scalability.
*   **Database Abstraction**: The `rnt_*.class.php` wrappers provide a custom layer of database abstraction. While functional, modernizing this could involve migrating to a full-fledged ORM (Object-Relational Mapper) like Doctrine or Eloquent (if introducing a framework) for more robust and maintainable database interactions.
*   **Error Handling**: Error reporting and handling could be standardized. Currently, errors sometimes lead to direct `exit;` calls or generic messages, which can hinder debugging and user experience.
