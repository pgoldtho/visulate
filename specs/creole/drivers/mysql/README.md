# MySQL Driver for Creole ORM

This directory contains the MySQL-specific implementation for the Creole Object-Relational Mapper (ORM). It provides the necessary classes and logic for Creole applications to connect to, interact with, and retrieve data from MySQL databases. This driver adheres to the Creole API, offering specialized handling for MySQL's unique features, data types, and query mechanisms.

## Functional Overview

The `specs/creole/drivers/mysql` directory serves as the core integration layer between the generic Creole ORM interface and MySQL databases. It encapsulates the specifics of MySQL connectivity, query execution, result set processing, primary key generation, and data type mapping. This allows Creole applications to operate against MySQL without needing to know the underlying database-specific intricacies.

## Files & Component Responsibilities

| File                       | Description                                                                                                                                                                                                                                                                                                                       |
| :------------------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `MySQLConnection.php`      | Extends `ConnectionCommon` and implements `Connection`. This class is responsible for establishing and managing connections to a MySQL database using `mysql_connect()` and related functions. It handles database selection (`mysql_select_db()`) and transaction management (commit/rollback).                                      |
| `MySQLIdGenerator.php`     | Implements the `IdGenerator` interface for MySQL. It provides methods to retrieve the last inserted auto-increment ID after an `INSERT` operation, typically leveraging `mysql_insert_id()`. This class informs Creole that ID generation happens *after* the insert.                                                               |
| `MySQLPreparedStatement.php` | Extends `PreparedStatementCommon` and implements `PreparedStatement`. This class handles MySQL-specific prepared statements. Notably, it overrides the `escape()` method to use `mysql_real_escape_string()` for proper string escaping, which is crucial for preventing SQL injection.                                         |
| `MySQLResultSet.php`       | Extends `ResultSetCommon` and implements `ResultSet`. This class manages the retrieval and iteration over results obtained from MySQL queries. It leverages MySQL's native support for `OFFSET` and `LIMIT` clauses, optimizing result set handling without requiring emulation.                                                   |
| `MySQLStatement.php`       | Extends `StatementCommon` and implements `Statement`. This class provides the basic functionality for executing SQL statements against a MySQL database. It serves as a wrapper around direct MySQL query execution.                                                                                                                   |
| `MySQLTypes.php`           | Extends `CreoleTypes`. This class defines the mapping between MySQL's native data types (e.g., `tinyint`, `varchar`, `datetime`) and Creole's internal, generic `CreoleTypes` constants. This abstraction allows Creole to handle data types consistently across different database platforms.                                |

## Database Dependencies & Interactions

This driver directly interacts with the MySQL database server using PHP's legacy `mysql_*` extension functions. The primary interactions include:

*   **Connection Management**: `mysql_connect()`, `mysql_pconnect()`, `mysql_close()`, `mysql_select_db()`.
*   **Query Execution**: `mysql_query()`, `mysql_unbuffered_query()`.
*   **Result Set Handling**: `mysql_fetch_array()`, `mysql_num_rows()`, `mysql_num_fields()`, `mysql_field_name()`, `mysql_field_type()`, `mysql_seek()`, `mysql_data_seek()`.
*   **Transaction Management**: `mysql_query("START TRANSACTION")`, `mysql_query("COMMIT")`, `mysql_query("ROLLBACK")`.
*   **ID Generation**: `mysql_insert_id()` for retrieving auto-incrementing primary keys.
*   **Data Escaping**: `mysql_real_escape_string()` for securing string literals in SQL queries.

The `MySQLTypes.php` class contains a static type map that correlates MySQL's internal type strings (e.g., `'tinyint'`, `'varchar'`, `'datetime'`) to Creole's abstracted type constants.

## Submodules / Subdirectories

*   **`metadata`**: This directory contains MySQL-specific metadata introspection classes for the Creole ORM, enabling schema reflection such as listing tables and their columns by executing `SHOW TABLES` and `SHOW COLUMNS` queries directly against a MySQL database.

## Maintenance & Modernization Notes

**CRITICAL MODERNIZATION REQUIRED**: The codebase in this directory extensively uses the `mysql_*` functions, which are officially deprecated as of PHP 5.5 and **completely removed** in PHP 7.0 and later versions.

*   **Migration to `mysqli` or PDO**: To ensure compatibility with modern PHP environments, this entire driver would need a significant rewrite to utilize either the `mysqli` extension (procedural or object-oriented style) or, preferably, the PDO (PHP Data Objects) extension. PDO offers a more consistent and database-agnostic interface, aligning better with an ORM's goals.
*   **Prepared Statement Handling**: The current `MySQLPreparedStatement.php` uses `mysql_real_escape_string()` for manual escaping. With `mysqli` or PDO, native prepared statements would be used, eliminating the need for manual escaping and providing better security and performance.
*   **Error Handling**: The `mysql_*` functions typically rely on `mysql_error()` and `mysql_errno()`. A modernization effort would need to update error reporting to align with `mysqli` or PDO exception handling.
