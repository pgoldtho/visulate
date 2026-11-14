# PHP Search and Display Functionality

This directory, `code/php/search`, encapsulates the core PHP logic for various public-facing search, display, and data processing functionalities within the Visulate application. It handles requests for property details, corporate information, real estate agent lookups, rental listings, and property sales data, leveraging the Smarty templating engine for presentation.

## Functional Overview

This module is responsible for retrieving and preparing data for display on the Visulate website, primarily related to real estate listings, corporate entities, and agent information. It processes user requests, queries various data sources (via database abstraction classes), and assigns the results to Smarty templates for rendering dynamic HTML pages. It also includes utility functions for menu generation and data range calculations.

## Files & Component Responsibilities

| File Name          | Description                                                                                                                                                                                                                                                                                                                            |
| :----------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `display_corp.php` | Handles the display of detailed information for a specific corporate entity (`CORP_ID`). It fetches corporate details, manages canonical URLs, and provides editing capabilities for administrative or site editor users, including interaction with Florida Sunbiz data.                                                                 |
| `display_property.php` | Manages the display of comprehensive property details based on a `PROP_ID`. It includes sub-sections for "Neighborhood Information" and "Cashflow Estimate". For users with 'Buyer' roles, it provides access to business unit lists. It sets page titles and canonical URLs.                                                             |
| `find_agent.php`   | Facilitates searching for real estate agents. It can display details for a specific agent by `LICENSE` number or list agents by training courses within a given `ZIPCODE`. It dynamically sets page titles and descriptions based on the search results.                                                                               |
| `menu_functions.php` | Contains helper functions primarily for generating dynamic submenus. `get_region_submenu()` constructs a menu for different regions (e.g., states or counties), while `get_skey()` determines the active menu item's key based on a `region_id`.                                                                                   |
| `process_city.php` | Processes requests related to geographic data (state, county, city, zipcode, UCODE, year). It fetches commercial listings, zipcode lists, and other region-specific data, assigning them to the Smarty template for display. It often works in conjunction with `menu_functions.php` for regional navigation.                           |
| `process_listing.php` | Provides logic to calculate maximum and minimum price values for property listings (`getMaxMin()`) based on various predefined categories (e.g., 'A_MAX', 'B_MEDIAN', 'C_MIN') and a given zipcode. This is likely used for filtering or categorizing search results.                                                               |
| `process_rentals.php` | Handles the processing and display of rental property listings. It can list rental properties by state and county, or display details for a specific rental agreement. It retrieves property photos and sets page metadata for rental search results.                                                                                  |
| `process_search.php` | A versatile search handler that processes general search queries. It supports searching by full street address, latitude/longitude coordinates, or a generic query string (`q`). It leverages cURL to make external HTTP GET requests and interacts with the database to retrieve relevant data (e.g., `getStreetAddress`). |
| `sales_requests.php` | Manages requests for property sales data, typically broken down by year and county. It retrieves and displays sales history, including the number of properties sold, total sales volume, and median prices per city and month. It also uses `menu_functions.php` for region-based navigation.                                      |

## Database Dependencies & Interactions

The files in this directory interact with the database primarily through a set of abstraction classes. While direct SQL queries are not visible in the provided samples, the following classes are instantiated and used, implying specific database interactions:

*   **`LISTSearch`**: Likely responsible for general property listings, search operations, rental property data, and sales data retrieval. Used in `process_city.php`, `process_rentals.php`, `process_search.php`, and `sales_requests.php`.
*   **`RNTCities`**: Manages data related to cities, counties, states, and regions. Used in `process_city.php` and `sales_requests.php`.
*   **`PRReports`**: Provides various reporting functionalities, including getting property details, corporate details, agent information, MLS data, and yearly sales data. Used in `display_corp.php`, `display_property.php`, `find_agent.php`, `process_city.php`, and `sales_requests.php`.
*   **`PRSunbiz`**: Specific to querying data from the Florida Sunbiz corporate registry. Used in `display_corp.php`.
*   **`RNTBusinessUnit`**: Manages business unit-related data, potentially tied to user roles and permissions (e.g., 'BUYER' roles). Used in `display_property.php`.

The specific tables, views, or stored procedures accessed by these classes are not detailed here but are encapsulated within the respective class implementations. It's crucial that these classes utilize prepared statements and parameterized queries to prevent SQL injection vulnerabilities.

## Submodules / Subdirectories

This directory does not contain any subdirectories.

## Maintenance & Modernization Notes

*   **Input Sanitization**: There's consistent use of `htmlentities($_REQUEST[...], ENT_QUOTES)` for input sanitization. While effective against XSS, a more centralized and robust input validation framework could improve maintainability and ensure all inputs are handled uniformly.
*   **Smarty Templating**: The code relies heavily on the Smarty templating engine. Any modernization efforts would need to consider this dependency.
*   **Function Length & Complexity**: Some functions, such as `display_corp` and `display_property`, are quite large and handle multiple concerns (data retrieval, display logic, editing actions). These could potentially benefit from further refactoring into smaller, more focused functions or classes following a Single Responsibility Principle.
*   **Conditional Logic**: The `getMaxMin` function in `process_listing.php` and `get_skey` in `menu_functions.php` use long `if/elseif` chains. These could potentially be refactored using arrays/maps for cleaner, more scalable logic, especially `get_skey` if `REGION_ID` values are consistent.
*   **Database Abstraction**: The use of dedicated classes (`LISTSearch`, `PRReports`, etc.) for database interaction is a good practice. When modernizing, ensure these classes enforce strict data typing, proper error handling, and parameterized queries for all database operations to maintain security and reliability.
*   **URL Parameter Handling**: The extensive use of `$_REQUEST` and `$_GET` directly within functions could be centralized or abstracted to a request object for better testability and clearer parameter management.
