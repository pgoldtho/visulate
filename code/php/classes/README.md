# `code/php/classes`

## Functional Overview

This directory serves as the central hub for core PHP utility classes and foundational components of the Visulate application. It encapsulates essential services and helpers used across various parts of the application, bridging the gap between the presentation layer and the data access layer. Key functionalities include:

*   **Application Context & Session Management**: Classes to manage application-wide context and user session data.
*   **Database Interaction Helpers**: Utilities for standardized error handling and advanced prepared statement variable retrieval.
*   **UI & Navigation**: Classes for generating dynamic menus, managing List of Values (LOV) for form elements, and initializing the Smarty templating engine.
*   **User Management**: Core class for handling user authentication, session state, and role-based access.
*   **Configuration & Utilities**: Global application settings, menu structure definitions, and data conversion utilities.
*   **Financial Calculations**: A comprehensive library providing a suite of mathematical finance functions.

## Files & Component Responsibilities

*   **`Context.class.php`**: Manages application-wide context variables stored in the user's session, such as `BUSINESS_ID`, `PROPERTY_ID`, `MOBILE_DEVICE` status, and `MENU_TAB` state. Provides static methods for reading and writing these values, facilitating state management across requests.
*   **`DatabaseError.class.php`**: Encapsulates logic for retrieving and interpreting database error messages, specifically interacting with a PL/SQL package (`RNT_ERROR_DESCRIPTION_PKG`) to fetch long descriptions for Oracle error codes. This standardizes error reporting.
*   **`LOV.class.php`**: Provides a utility for generating "List of Values" (LOV) arrays from SQL queries. It fetches data from the database, typically `RNT_LOOKUP_VALUES_V`, and formats it into associative arrays suitable for populating dropdowns or select elements in web forms.
*   **`LovData.class.php`**: A supporting class that holds and manages data for List of Values. It can generate JavaScript arrays of LOV data, likely for client-side dynamic form interactions.
*   **`Menu.class.php`**: Implements the primary navigation menu logic for the application. It constructs menu structures, manages menu levels, and filters menu items based on the authenticated user's roles, relying on `config_menu.php` for menu definitions.
*   **`Menu3.class.php`**: A specialized menu class focused on listing and selecting properties. It queries the `RNT_PROPERTIES` table to build a property selection mechanism, often used when navigating property-specific sections of the application.
*   **`OCI8PreparedStatementVars.php`**: Extends the Creole database abstraction layer's `OCI8PreparedStatement` class. This extension adds functionality to retrieve bound output variables from prepared statements after execution, which is crucial for handling PL/SQL procedures that return values via `OUT` parameters.
*   **`SQLExceptionMessage.class.php`**: A custom exception class that extends `SQLException`. It parses native Oracle error messages to extract a standardized error code and message, providing a more consumable error structure for the application.
*   **`SmartyInit.class.php`**: The initialization class for the Smarty templating engine. It sets up Smarty configurations, registers global variables, and integrates core application services like `User`, `Context`, `DatabaseError`, and `LovData`. It also includes utilities for detecting mobile browsers and logging exceptions.
*   **`User.class.php`**: Manages user authentication, session state, and user role information. It interacts with the `rnt_users.class.php` data access object (located in the `database` subdirectory) to retrieve and store user details, including subscription status.
*   **`UtlConvert.class.php`**: A utility class offering static methods for common data format conversions, primarily between database-friendly date strings (YYYY-MM-DD HH24:MI:SS) and display-friendly date formats (MM/DD/YYYY), and vice-versa.
*   **`config.php`**: Defines global application constants and configuration parameters. This includes database connection credentials, application root paths, upload directories, allowed file extensions for photos and spreadsheets, and maintenance mode settings. It includes `config_menu.php`.
*   **`config_menu.php`**: Contains the comprehensive definition of the application's menu structure. It outlines menu items, their titles, hrefs, and the user roles required to access them, serving as the blueprint for menu generation.
*   **`financial_class.php`**: A substantial class providing a wide array of mathematical finance functions. These functions emulate common Excel financial operations (e.g., present value, future value, interest rate calculations), useful for various financial modeling aspects within the application.

## Database Dependencies & Interactions

Classes within this directory interact with the Oracle database primarily through the `creole` abstraction layer. Key database objects utilized include:

*   **`RNT_LOOKUP_VALUES_V` (VIEW)**: Accessed by `LOV.class.php` to retrieve generic "List of Values" data. This view standardizes access to various lookup data used throughout the application, ensuring consistency in dropdowns and selection fields.
*   **`RNT_PROPERTIES` (TABLE)**: Referenced by `Menu3.class.php` to fetch property details for generating property-specific navigation menus or selection lists. This table stores core information about properties managed by the rental system.
*   **`RNT_ERROR_DESCRIPTION_PKG` (PACKAGE)**: `DatabaseError.class.php` calls `RNT_ERROR_DESCRIPTION_PKG.GET_LONG_DESCRIPTION` to fetch detailed error descriptions for Oracle SQL exceptions.

## Submodules / Subdirectories

*   **`api`**: This directory contains PHP classes, specifically the `phrets.php` library, which provide a client for integrating with and communicating with external Real Estate Transaction Standard (RETS) API servers.
*   **`database`**: This directory contains the PHP classes that form the data access layer for the Visulate application, providing structured interactions with the Oracle database for managing public records and rental system entities through direct SQL queries and PL/SQL package calls.

## Maintenance & Modernization Notes

*   **Database Abstraction Layer (Creole)**: The application utilizes Creole, an older database abstraction layer. Modernizing to a more current ORM or database library (e.g., Doctrine, PDO-based custom solution) could enhance maintainability, security (e.g., prepared statements by default), and developer experience.
*   **Direct SQL in Classes**: While some classes (`LOV.class.php`, `Menu3.class.php`) directly execute SQL queries, the `database` subdirectory contains dedicated Data Access Object (DAO) classes. Promoting consistent use of the DAO layer for all database interactions would improve separation of concerns and testability.
*   **Session Management**: `Context.class.php` and `User.class.php` directly interact with `$_SESSION`. Centralizing session management or abstracting it behind a more robust session handling mechanism (e.g., a session adapter pattern) could enhance security and scalability.
*   **Configuration (`config.php`, `config_menu.php`)**: These files contain hardcoded paths and database credentials. For modern deployments, externalizing sensitive configuration (e.g., environment variables, `.env` files) and making paths relative or configurable per environment is highly recommended.
*   **Error Handling**: `DatabaseError.class.php` and `SQLExceptionMessage.class.php` provide custom error handling. Integrating these with a broader, application-wide exception handling strategy is crucial for consistent and robust error reporting.
