# specs/creole/drivers/mssql

## Functional Overview

This directory contains the Microsoft SQL Server (MSSQL) specific implementation of the Creole database abstraction layer. It provides the core classes required to connect to, interact with, and retrieve data from an MSSQL database. This includes classes for managing connections, executing SQL statements (regular, prepared, and callable for stored procedures), handling result sets, generating IDs for new records, and mapping MSSQL's native data types to Creole's internal type system. The components here are designed to integrate MSSQL into the Creole framework, abstracting away database-specific details for the application layer.

## Files & Component Responsibilities

| File Name                    | Description                                                                                                                                                                                                                                                                                                                                                                                         |
| :--------------------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `MSSQLCallableStatement.php` | Implements the `CallableStatement` interface for MSSQL, enabling the execution of stored procedures. It extends `MSSQLPreparedStatement` to leverage its parameter binding capabilities.                                                                                                                                                                                                                |
| `MSSQLConnection.php`        | Manages the connection lifecycle to an MSSQL server. This includes establishing and closing connections, handling transactions, and creating `Statement` objects. It also contains notes on PHP `ini` settings (`mssql.textsize`, `mssql.textlimit`) that might be necessary for proper BLOB/CLOB support, particularly with the deprecated `mssql` extension.                                         |
| `MSSQLIdGenerator.php`       | Provides the MSSQL-specific logic for generating unique identifiers (IDs) for new records, typically interacting with MSSQL's `IDENTITY` columns. It indicates that ID generation occurs *after* an insert operation.                                                                                                                                                                                     |
| `MSSQLPreparedStatement.php` | Extends `PreparedStatementCommon` to provide MSSQL-specific handling for prepared statements. This includes methods for binding parameters, notably a specific implementation for `setBlob()`.                                                                                                                                                                                                       |
| `MSSQLResultSet.php`         | Implements `ResultSetCommon` for MSSQL, handling the retrieval and navigation of query results. It includes internal adjustments and extra checking to emulate `LIMIT` and `OFFSET` functionality, as older MSSQL versions do not support these natively, ensuring consistent behavior across different RDBMS drivers.                                                                               |
| `MSSQLStatement.php`         | Provides the basic statement execution capabilities for MSSQL, extending `StatementCommon`. It allows for executing SQL queries and retrieving result sets with specified fetch modes.                                                                                                                                                                                                               |
| `MSSQLTypes.php`             | Defines the mapping between MSSQL native data types (e.g., `binary`, `bit`, `datetime`, `int`) and their corresponding generic Creole (JDBC) types, facilitating type abstraction within the framework.                                                                                                                                                                                             |

## Database Dependencies & Interactions

This directory's components primarily interact with an MSSQL database using the native PHP `mssql_*` extension.

*   **Connection Management**: Direct connections are established using the `mssql_*` PHP functions.
*   **Query Execution**: SQL queries, prepared statements, and stored procedure calls are executed against the MSSQL server.
*   **Result Set Handling**: Data retrieval and navigation are performed using `mssql_fetch_*` functions.
*   **ID Generation**: Relies on MSSQL's `IDENTITY` property for auto-incrementing columns, querying the last inserted ID.
*   **Data Types**: Translates between MSSQL's native types and a more generic Creole type system.
*   **BLOB/CLOB Support**: Handles large binary and character objects, potentially requiring specific PHP `ini` settings for the `mssql` extension.

No specific user-defined database tables, views, or stored procedures are explicitly cataloged in the provided metadata, but the `MSSQLCallableStatement.php` file confirms the capability to execute any stored procedure defined within the MSSQL database.

## Submodules / Subdirectories

*   **`metadata`**: This directory contains MSSQL-specific PHP classes (`MSSQLDatabaseInfo.php`, `MSSQLTableInfo.php`) responsible for retrieving database and table metadata from an MSSQL server using deprecated `mssql_*` PHP functions.

## Maintenance & Modernization Notes

*   **Deprecated PHP Extension**: A significant concern is the reliance on the deprecated `mssql_*` PHP functions. This extension is no longer maintained and was removed in PHP 7.0. This codebase will not function with modern PHP versions without substantial modification.
*   **Modernization Path**: To modernize, this driver would need to be rewritten to use a currently supported PHP extension for MSSQL, such as `PDO_SQLSRV` (Microsoft Drivers for PHP for SQL Server) or `PDO_ODBC` (using an ODBC driver like FreeTDS). This would involve significant changes to connection handling, statement execution, and result set processing.
*   **BLOB/CLOB Configuration**: The specific `ini_set` directives for `mssql.textsize` and `mssql.textlimit` are specific to the old `mssql` extension and would not apply to modern drivers. BLOB/CLOB handling with modern drivers is typically more robust and integrated.
*   **LIMIT/OFFSET Emulation**: The `MSSQLResultSet` contains logic to emulate `LIMIT`/`OFFSET`. While functional for older MSSQL versions, SQL Server 2012 and newer support `OFFSET ... FETCH NEXT` natively. A modernized driver could take advantage of these native features for potentially better performance.
*   **Error Handling**: Review the error handling mechanisms, as the `mssql` extension's error reporting might differ significantly from modern PDO-based drivers.
