# `specs/creole/drivers/sqlite`

## Functional Overview

This directory contains the SQLite-specific implementation for the Creole database abstraction layer (DBAL). It provides the necessary classes to connect, interact, execute queries, and retrieve results from SQLite databases using the **deprecated `ext/sqlite` PHP extension**. This driver translates Creole's generic database operations into SQLite-specific commands and handles data typing, result set iteration, and connection management for SQLite.

## Files & Component Responsibilities

| File Name                    | Description                                                                                                                                                                                                                                                            |
| :--------------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `SQLiteConnection.php`       | Implements the `Connection` interface for SQLite, providing methods to establish and manage connections, start/commit/rollback transactions, and create `Statement` and `PreparedStatement` objects. It manages the `ext/sqlite` resource handle.                                |
| `SQLiteIdGenerator.php`      | Provides the `IdGenerator` implementation for SQLite. This class is responsible for retrieving the last inserted auto-incrementing ID (e.g., using `sqlite_last_insert_rowid()`) after an `INSERT` operation, as SQLite typically generates IDs post-insertion.          |
| `SQLitePreparedStatement.php`| Extends `PreparedStatementCommon` to implement prepared statement functionality specific to SQLite. It handles parameter binding and uses `sqlite_escape_string()` for escaping and `sqlite_udf_encode_binary()` for binary data encoding.                            |
| `SQLiteResultSet.php`        | Implements the `ResultSet` interface for SQLite. It wraps the native `ext/sqlite` query result resource and provides methods for fetching rows, navigating results, and accessing column metadata. It leverages SQLite's native `OFFSET` / `LIMIT` support.                   |
| `SQLiteResultSetIterator.php`| An optimized `Iterator` implementation designed specifically to work with `SQLiteResultSet`. It allows for efficient iteration over query results, making it compatible with PHP's `foreach` constructs.                                                                 |
| `SQLiteStatement.php`        | Provides the basic `Statement` implementation for SQLite. This class is responsible for executing SQL queries directly (without parameter binding) and returning `SQLiteResultSet` objects.                                                                             |
| `SQLiteTypes.php`            | Defines a type mapping for SQLite, translating common "hint" types often used in SQLite schema definitions (like `int`, `varchar`, `blob`) to Creole's internal `CreoleTypes` constants. Given SQLite's typeless nature, this primarily serves for readability and compatibility. |

## Database Dependencies & Interactions

This driver interacts directly with SQLite database files.
*   **Database System**: SQLite
*   **PHP Extension**: Relies heavily on the **deprecated `ext/sqlite` PHP extension** (functions like `sqlite_open`, `sqlite_query`, `sqlite_fetch_array`, `sqlite_escape_string`, `sqlite_last_insert_rowid`, etc.). This extension is distinct from and older than `ext/pdo_sqlite`.
*   **Data Types**: While SQLite is largely typeless, the `SQLiteTypes.php` class attempts to map commonly perceived SQLite column affinities to Creole's standard types for better consistency across different database drivers.

## Submodules / Subdirectories

*   **`metadata`**: This directory contains the SQLite-specific implementations for retrieving database and table metadata within the Creole framework, enabling schema introspection for SQLite databases using the deprecated `ext/sqlite` PHP extension.

## Maintenance & Modernization Notes

*   **Deprecated PHP Extension**: A critical point for modernization is the reliance on the `ext/sqlite` extension. This extension has been deprecated and removed in modern PHP versions (PHP 7+). Any application using this driver will not function with current PHP environments and must be migrated to `ext/pdo_sqlite` or another suitable driver.
*   **Legacy Codebase**: The code structure, variable naming (`$Id` tags), and use of specific PHP functions indicate this is an older codebase, likely from the PHP 4 or early PHP 5 era. Modern PHP practices (e.g., namespaces, stricter type hinting, `PDO`) are not present.
*   **Typeless Nature of SQLite**: Be mindful of SQLite's flexible type system when interpreting data. The `SQLiteTypes.php` class provides a translation layer, but actual data storage in SQLite is more lenient than in strictly typed databases.
*   **Binary Data Handling**: `SQLitePreparedStatement.php` uses `sqlite_udf_encode_binary()`, which is specific to the `ext/sqlite` extension for handling binary data. This functionality will need to be re-evaluated and potentially reimplemented if migrating to `PDO_sqlite`.
