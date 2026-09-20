# drivers

## Functional Overview
This directory serves as the central hub for various database driver implementations within the Creole Object-Relational Mapper (ORM). It encapsulates the core logic and classes required for Creole to establish connections, execute queries, handle result sets, and manage transactions across different relational database systems. Each subdirectory represents a specific database vendor's driver, providing a standardized interface for database interaction despite underlying technological differences.

## Files & Component Responsibilities
This directory does not contain any direct files. It acts as a container for specialized subdirectories, each of which provides the concrete implementation for a particular database driver.

## Database Dependencies & Interactions
This directory itself does not directly declare or manage database dependencies. Its subdirectories, however, contain the logic to interact with various database systems (e.g., MySQL, PostgreSQL, Oracle, SQLite, SQL Server via MSSQL/ODBC). Specific database object interactions (tables, views, stored procedures) are handled within the respective driver implementations.

## Submodules / Subdirectories
This directory organizes database-specific driver implementations into the following subdirectories:

*   **`mssql`**: This directory provides the core MSSQL-specific implementation for the Creole database abstraction layer, handling connections, queries, result sets, and data typing using the deprecated PHP `mssql_*` extension.
*   **`mysql`**: This directory contains the MySQL-specific driver implementation for the Creole ORM, providing classes for database connection, statement execution, result set handling, ID generation, and type mapping, primarily utilizing deprecated `mysql_*` PHP functions.
*   **`mysqli`**: This directory contains the MySQLi-specific driver implementation for the Creole ORM, providing classes for database connection management, statement execution, result set handling, and ID generation using the PHP `mysqli` extension. It enables the Creole ORM to interact with MySQL databases.
*   **`odbc`**: This directory implements the core ODBC driver for the Creole ORM, providing classes for database connections, statement execution, result set management, and type mapping, including emulations for common ODBC driver limitations.
*   **`oracle`**: This directory provides the Oracle (OCI8) specific driver implementations for the Creole database abstraction layer, handling connections, statements, result sets, ID generation, and type mapping for Oracle databases.
*   **`pgsql`**: This directory contains the PostgreSQL-specific driver implementation for the Creole ORM, providing classes for database connection, query execution, result handling, ID generation, and type mapping, all built upon PHP's `ext/pgsql` extension.
*   **`sqlite`**: This directory provides the `ext/sqlite`-based driver implementation for the Creole DBAL, enabling connection, query execution, and result handling for SQLite databases using a now-deprecated PHP extension.

## Maintenance & Modernization Notes
Several drivers within this directory (e.g., `mssql`, `mysql`, `sqlite`) rely on deprecated PHP extensions or functions. When modernizing or refactoring the Creole ORM, particular attention should be paid to:
*   **Replacing deprecated extensions**: Migrate `mssql_*` and `mysql_*` usages to their modern counterparts like `sqlsrv` (for MSSQL) or PDO_MYSQL/PDO_SQLSRV. Similarly, `ext/sqlite` should be replaced with `PDO_SQLITE` or `ext/sqlite3`.
*   **Security**: Ensure that driver implementations properly handle parameterized queries and prevent SQL injection vulnerabilities, especially when dealing with older, less secure APIs.
*   **Performance**: Evaluate and optimize query execution and result set handling for each driver, as performance characteristics can vary significantly across database systems and PHP extensions.
*   **Compatibility**: Verify compatibility with newer PHP versions, as deprecated extensions might be removed in future releases.
*   **Consistency**: Strive for a consistent API and behavior across all drivers, adhering to the principles of a robust database abstraction layer.
