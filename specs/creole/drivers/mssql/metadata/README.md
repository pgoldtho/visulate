# MSSQL Metadata Drivers

## Functional Overview
This directory contains the Microsoft SQL Server (MSSQL) specific implementations for retrieving database and table metadata within the Creole framework. It provides concrete classes that extend the generic `DatabaseInfo` and `TableInfo` interfaces, adapting them to interact with MSSQL's system catalog to fetch structural information about databases, tables, and their columns. This module is essential for database introspection, schema management, and other operations that require understanding the underlying database structure.

## Files & Component Responsibilities

| File                      | Description                                                                                                                                                                                                                                                                                                 |
| :------------------------ | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `MSSQLDatabaseInfo.php`   | Extends the base `DatabaseInfo` class to provide MSSQL-specific methods for introspecting a database. It is responsible for retrieving a list of tables within a specified MSSQL database, typically by querying the MSSQL system catalog. It relies on `MSSQLTableInfo` to represent individual table details. |
| `MSSQLTableInfo.php`      | Extends the base `TableInfo` class, implementing MSSQL-specific logic for introspecting a database table. This class is responsible for fetching details about a specific table, including its columns, their types, sizes, and other properties, by querying MSSQL system tables.                           |

## Database Dependencies & Interactions
This module directly interacts with an MSSQL server instance to retrieve metadata. The PHP files use the legacy `mssql_*` functions (e.g., `mssql_select_db`) to establish a connection and query the database. While specific user-defined tables are not directly referenced as dependencies, these files inherently depend on and query the MSSQL system catalog (e.g., `INFORMATION_SCHEMA` views or system tables like `sysobjects`, `syscolumns`, `systypes`) to gather information about databases, tables, and columns. The interaction involves executing internal SQL queries against the database's metadata repository.

## Submodules / Subdirectories
This directory does not contain any subdirectories.

## Maintenance & Modernization Notes
*   **Deprecated PHP Extension**: The code heavily relies on the `mssql_*` PHP extension, which was deprecated in PHP 5.3 and removed in PHP 7.0. For any modern PHP environment, this code will fail.
*   **Modernization Required**: To maintain compatibility with current PHP versions, the database interaction layer would need to be rewritten to use the `sqlsrv` extension (for Microsoft SQL Server Driver for PHP) or the `PDO_SQLSRV` driver. This would involve significant changes to how database connections are managed and how metadata queries are executed.
*   **SQL Injection Potential**: While metadata queries are generally less susceptible to typical SQL injection, relying on legacy extensions without careful sanitization practices can introduce vulnerabilities, particularly if parts of the metadata query are dynamically constructed from user input (though less likely in this context).
*   **System Catalog Variations**: MSSQL versions can have slight variations in their system catalog views or tables. The current implementation should be validated against the specific MSSQL versions it intends to support.
