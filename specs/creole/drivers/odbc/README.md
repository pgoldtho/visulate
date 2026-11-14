# ODBC Driver for Creole ORM

This directory contains the core implementation of the ODBC (Open Database Connectivity) driver for the Creole ORM framework. It provides the necessary classes to connect to, interact with, and manage data within various relational databases via an ODBC connection. This driver abstracts the complexities of the underlying ODBC API, offering a consistent interface for the Creole ORM to perform database operations, manage result sets, and handle data types.

## Functional Overview

The `specs/creole/drivers/odbc` directory serves as the foundation for Creole's interaction with databases through ODBC. It defines the concrete implementations for database connections, statement execution, result set handling, and ID generation specific to the ODBC standard. Its primary role is to bridge the generic Creole interfaces with the specifics of the PHP ODBC extension, including workarounds and emulations for common ODBC driver limitations (e.g., lack of native `LIMIT`/`OFFSET` support or full cursor scrolling).

## Files & Component Responsibilities

| File Name | Description |
| :-------------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `ODBCCachedResultSet.php`   | An ODBC-specific implementation of a cached `ResultSet`. It provides a workaround for ODBC drivers lacking support for reverse or absolute cursor scrolling by caching result rows on-demand. It also incorporates limit/offset emulation, skipping rows before the offset and stopping caching once the limit is reached. |
| `ODBCConnection.php`        | The ODBC implementation of the `Connection` interface. This class manages the actual ODBC database connection, handles transactions, and facilitates the creation of `Statement` and `PreparedStatement` objects. It depends on an `ODBCAdapter` for driver-specific behavior. |
| `ODBCIdGenerator.php`       | Provides an ODBC-specific implementation for generating unique identifiers (primary keys). It is designed to keep SQL simple but notes that more optimized custom generators can be used via `ODBCAdapter::getIdGenerator()`. |
| `ODBCPreparedStatement.php` | The ODBC-specific implementation of `PreparedStatement`. This class handles the preparation of SQL statements with bound parameters, leveraging native ODBC prepared statement capabilities where available, or falling back to emulation via `PreparedStatementCommon::replaceParams()` if the adapter requires it. |
| `ODBCResultSet.php`         | The standard ODBC implementation of `ResultSet`. It provides methods to fetch rows, navigate results, and retrieve metadata. This class includes logic to emulate `LIMIT` and `OFFSET` clauses and provides a row count if the driver doesn't support it natively, but requires ODBC drivers with absolute cursor positioning (SQL_FETCH_DIRECTION = SQL_FD_FETCH_ABSOLUTE). |
| `ODBCResultSetCommon.php`   | An abstract base class that provides common functionality for ODBC `ResultSet` implementations. It defines shared properties and methods, such as those related to offset and limit handling for result set processing. |
| `ODBCStatement.php`         | The ODBC implementation of `Statement`, used for executing non-prepared SQL queries and returning `ResultSet` objects. It extends `StatementCommon` and interacts with the `ODBCConnection` to run SQL. |
| `ODBCTypes.php`             | Defines the mapping between native ODBC data types and Creole's internal (JDBC-like) data types. This class is crucial for consistent type handling across different database systems connected via ODBC. |

## Database Dependencies & Interactions

This directory, being the driver layer, primarily interacts with the ODBC driver manager and specific ODBC drivers rather than directly with database tables or objects. The files here define the *mechanisms* for database interaction (connection, query execution, result fetching, metadata retrieval) rather than specific SQL queries against user-defined tables.

*   **Database Access**: All database access is performed through the PHP `odbc_*` functions, wrapped by these classes.
*   **Data Types**: `ODBCTypes.php` maps internal Creole types to native ODBC SQL types for correct data handling.
*   **Result Sets**: `ODBCResultSet.php` and `ODBCCachedResultSet.php` manage the fetching and navigation of query results from the ODBC layer.
*   **ID Generation**: `ODBCIdGenerator.php` uses basic SQL queries, executed via the `ODBCConnection`, to generate new IDs, typically by querying sequences or identity columns, or performing `INSERT` operations.

No specific database tables, views, or stored procedures are directly referenced within these core driver files, as that logic resides at higher layers of the ORM or within specific `ODBCAdapter` implementations.

## Submodules / Subdirectories

*   **`metadata`**: This directory provides ODBC-specific implementations for retrieving database and table metadata within the Creole ORM framework, using native ODBC API calls to introspect schema details.
*   **`adapters`**: This directory contains database-specific adapters for Creole's ODBC driver, customizing its behavior for various database systems like CodeBaseSQL and MySQL to handle their unique quirks and optimizations.

## Maintenance & Modernization Notes

*   **ODBC Driver Variability**: ODBC's strength (broad compatibility) is also its weakness (inconsistent behavior across drivers). Emulation logic (e.g., for `LIMIT`/`OFFSET`, cursor scrolling) must be carefully maintained to ensure robustness across different backend databases and ODBC drivers.
*   **Performance Considerations**: `ODBCCachedResultSet` can consume significant memory if large result sets are fully cached (e.g., when `getRecordCount()` or `last()` are called). Ensure its use is intentional, especially in high-performance contexts.
*   **IdGenerator Optimization**: The `ODBCIdGenerator` explicitly states its SQL is basic. If performance bottlenecks are observed during ID generation, specialized, database-specific SQL (implemented in custom `IdGenerator` classes via adapters) might be necessary.
*   **Error Handling**: The existing code structure might use older PHP error handling paradigms. Modernization should consider exceptions for a more robust error management strategy.
*   **Modern PHP Constructs**: The code appears to be from an older PHP version (`require_once`, `$Id:` tags). Modernization would involve adopting namespaces, type hinting, and potentially refactoring for better testability and dependency injection.
