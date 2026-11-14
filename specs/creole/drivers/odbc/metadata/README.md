# ODBC Metadata Information

This directory contains classes responsible for retrieving database and table metadata specifically for connections established via the ODBC (Open Database Connectivity) driver within the Creole ORM framework. These classes provide an ODBC-specific implementation of Creole's generic metadata information interfaces, allowing applications to discover database schema details.

## Functional Overview

The primary function of this directory is to abstract the process of querying metadata (such as database tables and table columns) from an ODBC data source. It provides concrete implementations of `DatabaseInfo` and `TableInfo` for the ODBC driver, enabling Creole to interact with various database systems through their ODBC interfaces to introspect their schema.

## Files & Component Responsibilities

| File                    | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| :---------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `ODBCDatabaseInfo.php`  | Extends `creole/metadata/DatabaseInfo.php` to provide ODBC-specific database information. It is responsible for initializing and retrieving a list of tables available in the connected ODBC data source by calling the `odbc_tables()` function. Includes `ODBCTableInfo.php` to instantiate table information objects. **Note**: Contains `@todo` comments regarding obtaining the database name and potentially moving functionality to `ODBCAdapter`. |
| `ODBCTableInfo.php`     | Extends `creole/metadata/TableInfo.php` to provide ODBC-specific table information. It handles the initialization and retrieval of column information for a given table by using the `odbc_columns()` function. It also includes `creole/drivers/odbc/ODBCTypes.php` to load the appropriate type map for column data types.                                                                                                                                      |

## Database Dependencies & Interactions

This module interacts directly with the ODBC API functions rather than specific database tables or views.
-   **`odbc_tables()`**: Used by `ODBCDatabaseInfo.php` to retrieve a list of tables and their types from the ODBC data source.
-   **`odbc_columns()`**: Used by `ODBCTableInfo.php` to retrieve column details (name, type, size, etc.) for a specified table from the ODBC data source.

These functions query the underlying database system's catalog information via the ODBC driver. There are no direct SQL queries against specific database catalog tables within these files; the interaction is through the ODBC API abstraction.

## Maintenance & Modernization Notes

*   **Error Suppression**: The code uses the `@` operator extensively with `odbc_tables()` and `odbc_columns()`. While errors are caught and re-thrown as `SQLException`, suppressing native warnings might mask underlying issues. Consider replacing `@` with explicit error checking and logging where appropriate.
*   **PHP Version Compatibility**: The codebase appears to be older PHP, using `include_once` and a more procedural style within methods. Modernizing this might involve using namespaces, autoloading, and more object-oriented error handling.
*   **`@todo` Comments**: The `@todo` comments in `ODBCDatabaseInfo.php` (regarding obtaining the database name and potentially integrating with `ODBCAdapter`) indicate incomplete functionality or design considerations that should be addressed if this code were to be actively developed or maintained.
*   **Dependency on `php_odbc`**: This entire module is tightly coupled to the `php_odbc` extension. Any migration or modernization effort would need to consider this dependency.
