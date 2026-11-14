# ODBC Adapters for Creole

This directory, `specs/creole/drivers/odbc/adapters`, contains specific database adapters designed to customize the behavior of the Creole ORM's ODBC driver for various database systems. These adapters extend the base `ODBCAdapter` to handle database-specific quirks, limitations, and optimizations when interacting with different database backends via ODBC.

## Functional Overview

The primary function of this directory is to provide specialized implementations for database-specific interactions when using Creole's generic ODBC driver. Since ODBC itself is a common interface, individual database systems often have unique behaviors, data type mappings, and SQL dialect nuances. These adapter classes bridge that gap, ensuring Creole can interact correctly and efficiently with a given database through its ODBC connection.

## Files & Component Responsibilities

| File Name          | Description                                                                                                                                                                                                                                                                                                                                                                                             |
| :----------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `CodeBaseAdapter.php` | Implements driver-specific behavior for Sequiter's CodeBaseSQL product, which utilizes a dBase ODBC driver. It addresses known limitations such as requiring `ODBCCachedResultSet` due to forward-only cursor support and notes specific issues with blob handling and character counts that should be considered during development and testing.                                                         |
| `MySQLAdapter.php`   | Provides an adapter for MySQL databases when accessed via the ODBC driver. While direct MySQL drivers are generally more efficient for MySQL, this adapter was specifically created to facilitate testing of the generic ODBC driver and its capabilities. It defines MySQL-specific behavior, such as determining if `LIMIT` and `OFFSET` clauses are supported for pagination.                      |
| `ODBCAdapter.php`    | The base class for all ODBC driver-specific behaviors. This adapter defines common functionality and serves as the default implementation for general ODBC interactions. Other adapters (like CodeBase and MySQL) extend this class to override or add database-specific logic, ensuring a consistent interface while accommodating database idiosyncrasies. It includes methods like `preservesColumnCase()`. |

## Database Dependencies & Interactions

The files in this directory are adapter implementations; they do not define specific database schemas or directly contain SQL queries for particular tables. Instead, they *facilitate* interaction with various database systems (e.g., CodeBaseSQL, MySQL) through the ODBC layer provided by the operating system and database drivers. Their role is to interpret and translate Creole's requests into database-specific actions compatible with the chosen ODBC connection. Any actual database objects (tables, views, etc.) would be defined within the user's application schema or by the database itself, with these adapters ensuring correct communication.

## Submodules / Subdirectories

This directory does not contain any subdirectories.

## Maintenance & Modernization Notes

*   **Database Quirks**: The `CodeBaseAdapter.php` highlights specific issues with blob/clob handling and character counts. If this adapter is still in use, thorough testing of data integrity, especially with large text or binary fields, is crucial. Any modernization efforts should validate these behaviors against newer versions of CodeBaseSQL or alternative dBase ODBC drivers.
*   **MySQL Usage**: The `MySQLAdapter.php` explicitly states it's for testing the ODBC driver, and a direct MySQL driver would be more efficient. If performance is a concern for MySQL applications using Creole, it's highly recommended to use a native MySQL driver instead of the ODBC path. This adapter should primarily be maintained for its original testing purpose or if there's a specific requirement to connect to MySQL solely via ODBC.
*   **Code Style & Standards**: The codebase adheres to an older PHP style (e.g., using `require_once` without namespaces, CVS/SVN `$Id:` tags). Modernization would involve adopting PSR standards, introducing namespaces, and leveraging more recent PHP features like type hints and stricter error handling.
*   **Extensibility**: The `ODBCAdapter` provides a clear pattern for extending Creole's ODBC support to other database systems by creating new adapter classes that inherit from `ODBCAdapter` and override necessary methods.
