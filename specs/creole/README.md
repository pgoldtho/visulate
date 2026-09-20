# Creole PHP Database Abstraction Layer Core Interfaces

This directory constitutes the core Application Programming Interface (API) and foundational interfaces for the Creole PHP database abstraction layer. It defines the essential contracts for interacting with various relational databases, providing a vendor-neutral programming model for database connections, statement execution, result set processing, and error handling. The files within this directory establish the fundamental building blocks upon which database-specific drivers and utility classes are built, enabling applications to interact with different database systems through a unified and consistent interface.

## Files & Component Responsibilities

| File Name             | Description                                                                                                                                                                                                                                                                                                                         |
| :-------------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `CallableStatement.php` | Defines the `CallableStatement` interface, extending `PreparedStatement`. It provides methods for executing SQL stored procedures and managing output parameters, akin to JDBC's CallableStatement, enabling interaction with database-side routines.                                                                               |
| `Connection.php`      | Defines the `Connection` interface, the central component for managing a database connection. It outlines methods for creating statements (`Statement`, `PreparedStatement`), managing transactions (commit, rollback), fetching metadata, and setting various connection properties like fetch modes and transaction isolation levels. |
| `Creole.php`          | The primary class for managing and registering database drivers within the Creole framework. It acts as a factory, providing static methods to connect to databases by registering and retrieving `Connection` implementations for various RDBMS types. It also handles global settings like error tracking.                             |
| `CreoleTypes.php`     | Defines an abstract class `CreoleTypes` containing a comprehensive set of constants that represent generic, cross-database SQL data types (e.g., `BOOLEAN`, `VARCHAR`, `INTEGER`, `DATE`, `CLOB`, `BLOB`), largely modeled after JDBC types. This provides a consistent type system across different database drivers.                |
| `IdGenerator.php`     | Defines the `IdGenerator` interface, which provides strategies for obtaining auto-generated primary key values, distinguishing between `SEQUENCE` (generated before INSERT, e.g., Oracle) and `AUTOINCREMENT` (generated after INSERT, e.g., MySQL) methods.                                                                       |
| `PreparedStatement.php` | Defines the `PreparedStatement` interface, extending `Statement`. It represents a pre-compiled SQL statement with parameterized placeholders, allowing for efficient execution of repetitive queries and secure binding of values to prevent SQL injection.                                                                      |
| `ResultSet.php`       | Defines the `ResultSet` interface, which is used to encapsulate and provide access to data retrieved from a database query. It offers methods for navigating through results, fetching column values by name or index with type-specific retrieval (`getString`, `getInt`, `getTimestamp`, etc.), and supports `IteratorAggregate` for easy iteration. |
| `ResultSetIterator.php` | Provides a concrete `Iterator` implementation for `ResultSet` objects, enabling standard PHP `foreach` loops to traverse database query results. It handles the internal logic for moving through the result set and retrieving current data.                                                                                |
| `SQLException.php`    | Defines the `SQLException` class, which extends PHP's base `Exception` class. It is the standardized exception type for all database-related errors within Creole, capturing details such as a descriptive message, the native RDBMS error string, and additional user-defined context (e.g., the problematic SQL statement).   |
| `Statement.php`       | Defines the basic `Statement` interface for executing static SQL commands (without parameters) and managing general statement properties such as setting the maximum number of rows to return from a query or the fetch size.                                                                                                   |

## Database Dependencies & Interactions

The files in `specs/creole` primarily define interfaces and abstract core components of a database abstraction layer. As such, they do not directly interact with specific database tables, views, packages, or procedures. The actual database interaction logic is implemented by concrete driver classes found in the `drivers` subdirectory, which adhere to these interfaces. These core specifications set the contracts that enable subsequent database-specific implementations.

## Submodules / Subdirectories

*   **`common`**: This directory contains abstract common classes for Creole's database abstraction layer components, providing shared logic and default implementations for connections, statements, prepared statements, and result sets to facilitate driver development.
*   **`contrib`**: This directory provides a debugging extension for the Creole ORM, specifically a `DebugConnection` class that uses the decorator pattern to track and log database queries executed through a Creole connection.
*   **`drivers`**: This directory serves as the container for various database driver implementations within the Creole ORM, providing the necessary abstraction layers for connecting, querying, and interacting with different relational databases like MySQL, PostgreSQL, Oracle, and SQLite.
*   **`metadata`**: This directory defines the core "Info" classes for representing database schema metadata (tables, columns, keys, indexes) within the Creole PHP database abstraction framework, acting as data containers for schema introspection.
*   **`util`**: This directory provides PHP classes (`Lob`, `Blob`, `Clob`) for abstracting the handling of Large Objects (binary and character data) typically stored in databases, offering utilities for managing large data streams within the application.

## Maintenance & Modernization Notes

This codebase reflects a design pattern common in earlier versions of PHP (likely PHP 4/5), heavily inspired by Java's JDBC API. When maintaining or modernizing this code, consider the following:

*   **PHP Version Compatibility**: The use of `include_once`, `interface`, and the overall structure indicates compatibility with older PHP versions. Modern PHP (7.x+) would typically leverage namespaces for better organization, stricter type declarations, and potentially `spl_autoload_register` or Composer for dependency loading.
*   **Abstraction Layer Evolution**: While Creole provided a valuable abstraction at its time, the PHP ecosystem has largely standardized on PDO (PHP Data Objects) for database abstraction, which is built into PHP itself and offers a consistent, secure, and performant API.
*   **Refactoring Opportunities**:
    *   **Namespaces**: Introduce namespaces to prevent naming collisions and improve code organization.
    *   **Type Hinting**: Add scalar and object type hints for method parameters and return types where appropriate, enhancing code readability and maintainability.
    *   **Modern Practices**: Consider replacing manual `include_once` calls with an autoloader or Composer's autoloading capabilities.
    *   **Error Handling**: While `SQLException` is custom, its design is robust. Ensure it integrates well with modern error reporting and logging frameworks.
*   **Migration**: For new development or significant overhauls, migrating from Creole to PDO might be a long-term goal to leverage built-in PHP features and community support. If a full migration isn't feasible, updating the Creole interfaces and implementations to conform to modern PHP standards would be beneficial.
