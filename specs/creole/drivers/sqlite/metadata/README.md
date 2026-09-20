# SQLite Metadata Driver

This directory contains the SQLite-specific implementations for retrieving database and table metadata within the Creole database abstraction layer. It provides concrete classes that extend the generic `creole/metadata` interfaces to interact with an SQLite database and extract structural information such as lists of tables and details of table columns.

## Functional Overview

The primary function of this directory is to enable the Creole framework to introspect SQLite database schemas. It provides the necessary logic to query SQLite's internal schema information, allowing applications to discover database structures programmatically. This is crucial for ORMs, schema migration tools, or any application needing to dynamically understand the underlying database layout.

## Files & Component Responsibilities

| File Name             | Description                                                                                                                                                                                                                                                                                                                              |
| :-------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `SQLiteDatabaseInfo.php` | Implements the `DatabaseInfo` interface for SQLite. This class is responsible for querying the SQLite database to retrieve a list of all tables (both permanent and temporary) within the connected database. It abstracts the SQLite-specific SQL queries used to fetch table names from `sqlite_master` and `sqlite_temp_master`. |
| `SQLiteTableInfo.php`    | Implements the `TableInfo` interface for SQLite. This class is dedicated to fetching detailed information about a specific table, including its columns. It leverages SQLite's `PRAGMA table_info()` statement to efficiently retrieve column names, data types, nullability, default values, and primary key status for a given table. |

## Database Dependencies & Interactions

The components in this directory interact directly with the SQLite database engine to retrieve metadata:

*   **`SQLiteDatabaseInfo.php`**:
    *   Queries the `sqlite_master` and `sqlite_temp_master` system tables using `SELECT name FROM sqlite_master WHERE type='table' UNION ALL SELECT name FROM sqlite_temp_master WHERE type='table' ORDER BY name;` to list all tables.
    *   Relies on the `sqlite_query()` and `sqlite_last_error()` functions from the `ext/sqlite` PHP extension for executing queries and handling errors.
*   **`SQLiteTableInfo.php`**:
    *   Utilizes the `PRAGMA table_info(<table_name>)` statement to obtain detailed column information for a specified table. This PRAGMA statement is a SQLite-specific way to query table schema.
    *   Also depends on `sqlite_query()` for database interaction.

## Submodules / Subdirectories

This directory does not contain any subdirectories.

## Maintenance & Modernization Notes

*   **Deprecated PHP Extension**: The code heavily relies on the `ext/sqlite` PHP extension (e.g., `sqlite_query`, `sqlite_last_error`). This extension has been deprecated and removed in modern PHP versions (PHP 7+). Modernization efforts would require migrating to `PDO_SQLite` or `SQLite3` extension, which would entail significant changes to the database interaction logic within both `SQLiteDatabaseInfo.php` and `SQLiteTableInfo.php`.
*   **Error Handling**: The error handling (`sqlite_last_error`) is specific to the deprecated `ext/sqlite` extension.
*   **Code Age**: The copyright headers and `$Id$` tags (e.g., `$Id: SQLiteDatabaseInfo.php,v 1.3 2004/03/20`) indicate that this codebase is quite old (circa 2004-2005). Modern PHP practices, class autoloading, and dependency injection are not utilized, which might require refactoring for better maintainability and integration into contemporary applications.
