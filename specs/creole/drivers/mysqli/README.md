# `specs/creole/drivers/mysqli`

## Functional Overview
This directory contains the MySQLi-specific implementation of the Creole Object-Relational Mapper (ORM) driver. It provides a set of classes that enable Creole to interact with MySQL databases using PHP's `mysqli` extension. This includes functionalities for establishing database connections, executing SQL statements (both regular and prepared), managing result sets, and generating IDs. This driver acts as the bridge between the generic Creole ORM interface and the underlying MySQLi database API.

## Files & Component Responsibilities
| File Name                 | Description                                                                                                                                                                                                                                                                                                                          |
| :------------------------ | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `MySQLiConnection.php`    | Implements the `Connection` interface for MySQLi. It is responsible for establishing and managing the connection to a MySQL database, handling DSN parsing, transaction management (commit, rollback), and providing access to the underlying `mysqli` resource. It extends `ConnectionCommon` and includes `MySQLiResultSet.php`. |
| `MySQLiIdGenerator.php`   | Provides a MySQLi-specific implementation for generating unique IDs, typically utilizing MySQL's auto-increment capabilities. It interacts with the `MySQLiConnection` object to retrieve the last inserted ID.                                                                                                                   |
| `MySQLiPreparedStatement.php` | Implements the `PreparedStatement` interface for MySQLi. This class handles the preparation and execution of parameterized SQL queries, allowing for efficient and secure execution of repetitive queries with different parameter values. It includes a `protected function escape($str)` using `mysqli_real_escape_string`. |
| `MySQLiResultSet.php`     | Implements the `ResultSet` interface for MySQLi. It manages the data returned from executed queries, allowing iteration over rows, fetching data by column name or index, and handling cursor positioning (`seek`). It specifically notes MySQL's native support for `OFFSET / LIMIT`.                                              |
| `MySQLiStatement.php`     | Implements the `Statement` interface for MySQLi. This class represents a general SQL statement, capable of executing queries and returning `MySQLiResultSet` objects. It extends `StatementCommon`.                                                                                                                               |

## Database Dependencies & Interactions
The components in this directory interact directly with a MySQL database using the PHP `mysqli` extension. They perform standard database operations such as connecting, executing DML (Data Manipulation Language) and DDL (Data Definition Language) queries, fetching results, and managing transactions.

Specific interactions include:
*   Establishing connections using `mysqli_connect()`.
*   Executing queries using `mysqli_query()` or prepared statements via `mysqli_prepare()` and related functions.
*   Fetching result data using `mysqli_fetch_array()`, `mysqli_fetch_assoc()`, or similar `mysqli` result functions.
*   Retrieving auto-generated IDs using `mysqli_insert_id()`.
*   Escaping strings for SQL queries using `mysqli_real_escape_string()`.
*   Transaction control using `mysqli_autocommit()`, `mysqli_commit()`, and `mysqli_rollback()`.

## Submodules / Subdirectories
*   **`metadata`**: This directory provides MySQLi-specific implementations for retrieving database and table schema metadata within the Creole ORM, using direct `mysqli` calls to execute `SHOW TABLES` and `SHOW COLUMNS` SQL commands.

## Maintenance & Modernization Notes
This codebase appears to be part of an older ORM project (Creole, referencing `phpdb.org` and LGPL license), likely from the early to mid-2000s, as indicated by the CVS/SVN `$Id` and `$Revision` tags.

*   **PHP Version Compatibility**: While `mysqli` is still standard in modern PHP, the syntax and practices might not align with current PHP 7+ or 8+ standards (e.g., explicit type hints, stricter error handling, modern class autoloading).
*   **Error Handling**: Review the error handling mechanisms. Modern PHP applications often leverage exceptions more consistently for database errors rather than relying solely on return values or global error states.
*   **Dependency Management**: The `require_once` and `include_once` statements suggest a manual class loading mechanism, typical for older PHP projects. Modernization would involve transitioning to PSR-4 compliant autoloading.
*   **Security**: While `mysqli_real_escape_string` and prepared statements are used, a thorough security review is recommended to ensure no potential SQL injection vectors exist, especially in areas where dynamic SQL might be constructed.
*   **Modern ORM Alternatives**: If significant refactoring or modernization is planned, consider whether migrating to a more actively maintained ORM (e.g., Doctrine, Eloquent) or a robust database abstraction layer (like PDO) would be more beneficial in the long term.
