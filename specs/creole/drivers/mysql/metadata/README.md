# Creole MySQL Metadata Driver

This directory contains the MySQL-specific implementations of Creole's metadata introspection classes. These components are responsible for querying a MySQL database to retrieve schema information, such as the list of tables within a database and the detailed column definitions (including types and attributes) for a specific table. They extend the generic `DatabaseInfo` and `TableInfo` abstract classes provided by the Creole ORM, adapting them to interact with MySQL's specific metadata query syntax.

## Files & Component Responsibilities

*   **`MySQLDatabaseInfo.php`**:
    *   This file defines the `MySQLDatabaseInfo` class, which extends `creole/metadata/DatabaseInfo`.
    *   It provides the MySQL-specific logic to retrieve high-level information about a database.
    *   Its primary function is the `initTables()` method, which uses the SQL query `SHOW TABLES FROM \`<database_name>\`` to fetch all table names within the current database.
    *   For each table identified, it instantiates a `MySQLTableInfo` object to gather more detailed table-specific metadata.

*   **`MySQLTableInfo.php`**:
    *   This file defines the `MySQLTableInfo` class, which extends `creole/metadata/TableInfo`.
    *   It encapsulates the MySQL-specific logic required to retrieve detailed information about a particular table.
    *   The `initColumns()` method is central to its functionality, executing `SHOW COLUMNS FROM <table_name>` to fetch column names, their data types, default values, nullability, and other attributes for the specified table.
    *   It also includes `creole/metadata/ColumnInfo.php` for generic column representation and `creole/drivers/mysql/MySQLTypes.php` to map MySQL-specific data types to a more generalized type system.

## Database Dependencies & Interactions

This module interacts directly with the MySQL database server to retrieve schema metadata rather than relying on predefined database objects (tables, views, etc.).

*   **Metadata Queries**:
    *   It executes `SHOW TABLES FROM \`<database_name>\`` to list all tables present in the specified database.
    *   It executes `SHOW COLUMNS FROM <table_name>` to retrieve detailed information about the columns (name, type, length, nullability, key information, default value, extra attributes) of a specific table.
*   **Database Selection**: It implicitly depends on the ability to select a specific database using functions like `mysql_select_db` to ensure queries are run against the correct database context.

## Maintenance & Modernization Notes

*   **Deprecated PHP Functions**: The code heavily utilizes the `mysql_*` family of PHP functions (e.g., `mysql_query`, `mysql_select_db`). These functions are officially deprecated and removed in modern PHP versions (PHP 7.0+). For any modernization or refactoring effort, these should be replaced with the `mysqli_*` extension or, preferably, PDO for better maintainability, security, and performance.
*   **Error Suppression**: The use of the `@` error suppression operator (e.g., `@mysql_query`, `@mysql_select_db`) can mask critical errors, making debugging challenging and potentially hiding underlying issues. This should be refactored to use proper exception handling for robust error management and clearer diagnostics.
*   **Autoloading**: The `include_once` statements within methods (`initTables`, `initColumns`) are indicative of older PHP development practices. Modern PHP applications typically use PSR-4 compliant autoloading for dependency management, which could simplify these imports and improve performance.
