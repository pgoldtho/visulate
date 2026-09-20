# Oracle (OCI8) Driver for Creole

## Functional Overview

This directory contains the Oracle (OCI8) specific implementations for the Creole database abstraction layer. It provides a set of classes that enable the Creole framework to interact with Oracle databases using PHP's OCI8 extension. This includes handling database connections, executing SQL statements, managing prepared statements, processing result sets, generating primary keys, and mapping Oracle-specific data types to a common Creole type system. Essentially, this module serves as the core driver for Oracle database connectivity within the Creole ecosystem, abstracting the complexities of OCI8 for higher-level application logic.

## Files & Component Responsibilities

| File Name                | Description                                                                                                                                                                                                                                                                              |
| :----------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `OCI8Connection.php`     | Implements the `Connection` interface for Oracle (OCI8). This class manages the lifecycle of a database connection, handles transaction management (commit, rollback), and is responsible for creating `Statement` and `PreparedStatement` objects tailored for Oracle.                          |
| `OCI8IdGenerator.php`    | Provides an Oracle-specific implementation of the `IdGenerator` interface. It defines the mechanism for generating unique identifiers (primary keys) for new records, typically by interacting with Oracle sequences or other identity mechanisms before an insert operation.                  |
| `OCI8PreparedStatement.php` | Oracle (OCI8) implementation of `PreparedStatement`. This class manages parameterized SQL queries, allowing for efficient and secure execution of statements with bound values, including complex data types like LOBs (Large Objects) which require special handling in Oracle. |
| `OCI8ResultSet.php`      | Implements the `ResultSet` interface for Oracle (OCI8). This class is responsible for fetching, navigating, and accessing data returned by executed SQL queries from an Oracle database. It provides methods to iterate through rows and retrieve column values.                           |
| `OCI8Statement.php`      | Provides a basic Oracle (OCI8) implementation of the `Statement` interface. It is used for executing simple SQL queries that do not require parameter binding.                                                                                                                            |
| `OCI8Types.php`          | Defines a mapping between Oracle's native data types (e.g., `VARCHAR2`, `NUMBER`, `DATE`) and the generic Creole (JDBC) data types. This ensures consistent type handling across different database drivers within the Creole framework.                                                  |

## Database Dependencies & Interactions

The classes in this directory interact with a standard Oracle database environment via the PHP OCI8 extension. While the provided samples do not explicitly list specific tables or views, the functionality implies:

*   **Sequences**: `OCI8IdGenerator.php` relies on Oracle sequences to generate unique IDs for new records.
*   **Data Dictionary Views**: The functionality often provided by a database driver, especially for metadata retrieval (handled by the `metadata` subdirectory), involves querying Oracle's data dictionary views (e.g., `ALL_TABLES`, `ALL_TAB_COLUMNS`, `ALL_CONSTRAINTS`).
*   **LOBs**: `OCI8PreparedStatement.php` explicitly handles Large Object (LOB) descriptors, indicating interaction with Oracle's LOB data types (e.g., `CLOB`, `BLOB`).
*   **Standard SQL Operations**: All files collectively perform standard DDL/DML operations (e.g., `SELECT`, `INSERT`, `UPDATE`, `DELETE`, `CREATE TABLE`) and transaction management.

## Submodules / Subdirectories

*   **`metadata`**: This directory contains Oracle (OCI8) specific implementations for retrieving database metadata, providing detailed information about Oracle databases and their tables by interacting with Oracle's data dictionary views.

## Maintenance & Modernization Notes

*   **OCI8 Extension**: This driver relies on the PHP OCI8 extension. Ensure it is correctly installed and configured in the PHP environment. For modernization, consider the `PDO_OCI` driver, which offers a more unified API approach consistent with modern PHP practices.
*   **Resource Management**: Pay close attention to resource management, especially with OCI8, to prevent memory leaks or unclosed connections/statements.
*   **Type Mapping**: The `OCI8Types.php` class is critical for consistent data handling. Any new or custom Oracle data types might require updates to this mapping.
*   **LOB Handling**: The explicit handling of LOB descriptors in `OCI8PreparedStatement.php` indicates a potential area for complexity. Modernizing this might involve reviewing how LOB streaming or large data uploads/downloads are managed.
*   **Error Handling**: Review the error handling mechanisms, as OCI8 errors often need specific interpretation and propagation.
*   **Legacy Code Style**: The code exhibits characteristics of older PHP (e.g., `include_once`, `$Revision$` tags, LGPL license headers), which might require refactoring to align with current PHP standards (namespaces, PSR compliance, modern exception handling) if integrating into a newer codebase.
