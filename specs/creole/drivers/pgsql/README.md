# pgsql Driver for Creole ORM

This directory (`specs/creole/drivers/pgsql`) contains the PostgreSQL-specific implementation of the Creole Object-Relational Mapper (ORM) driver. It provides the necessary classes for PHP applications using Creole to interact with PostgreSQL databases, leveraging PHP's native `ext/pgsql` extension. This driver offers concrete implementations for establishing connections, executing statements, handling result sets, generating auto-increment IDs, preparing queries, and mapping database-specific data types to generic Creole types.

## Functional Overview

The primary function of this directory is to bridge the Creole ORM's abstract database interfaces with the concrete functionalities provided by PostgreSQL. It defines how Creole performs common database operations such as connecting to a server, managing transactions, executing SQL queries (both simple and prepared), retrieving and iterating over query results, and handling PostgreSQL-specific data types and auto-incrementing primary keys. This allows Creole applications to operate seamlessly with PostgreSQL databases without needing to write database-specific SQL or API calls.

## Files & Component Responsibilities

Here's a breakdown of the files in this directory and their responsibilities:

*   **`PgSQLConnection.php`**: Implements the `Connection` interface for PostgreSQL. This class is responsible for establishing and managing database connections, handling transactions (beginning, committing, and rolling back), and executing raw SQL queries via `pg_query()`. It tracks the number of affected rows for update operations.
*   **`PgSQLIdGenerator.php`**: Implements the `IdGenerator` interface for PostgreSQL. This component is used to retrieve the last generated auto-incrementing ID (e.g., from a sequence) after an `INSERT` operation, crucial for working with primary keys managed by the database.
*   **`PgSQLPreparedStatement.php`**: Extends `PreparedStatementCommon` and implements `PreparedStatement` for PostgreSQL. It handles the preparation and execution of parameterized SQL queries. It includes a protected `escape()` method that utilizes `pg_escape_string()` for safely quoting string literals, helping prevent SQL injection.
*   **`PgSQLResultSet.php`**: Extends `ResultSetCommon` and implements `ResultSet` for PostgreSQL. This class encapsulates the results of a database query, providing methods to fetch rows, access column data by name or index, and navigate through the result set using `pg_fetch_array()`.
*   **`PgSQLResultSetIterator.php`**: An optimized iterator (implementing `SeekableIterator` and `Countable`) specifically designed to efficiently traverse `PgSQLResultSet` objects. It allows for convenient iteration over query results, supporting features like seeking to a specific row and counting rows.
*   **`PgSQLStatement.php`**: A basic implementation of the `Statement` interface, extending `StatementCommon`. This class provides fundamental capabilities for executing simple SQL statements against a PostgreSQL database.
*   **`PgSQLTypes.php`**: Extends `CreoleTypes` and defines a static type map. Its role is to translate native PostgreSQL data types (e.g., `int2`, `varchar`, `text`, `numeric`) into their corresponding generic Creole (JDBC-like) type constants, ensuring consistent type handling across different database drivers.

## Database Dependencies & Interactions

This driver is entirely dependent on the **PostgreSQL** database system. All interactions occur through PHP's `ext/pgsql` extension.

*   **Data Manipulation**: The driver performs standard Data Manipulation Language (DML) operations (INSERT, UPDATE, DELETE) and Data Query Language (DQL) operations (SELECT) against user-defined tables.
*   **ID Generation**: `PgSQLIdGenerator` interacts with PostgreSQL's sequence mechanisms to retrieve auto-generated primary key values after insertions.
*   **Metadata Retrieval**: The `metadata` subdirectory (summarized below) is crucial for introspecting the database schema. It directly queries **PostgreSQL system catalogs and `information_schema`** (e.g., `pg_class`, `pg_attribute`, `information_schema.columns`, `information_schema.tables`) to obtain details about tables, columns, data types, and other schema objects.

## Submodules / Subdirectories

*   **`metadata`**: This directory provides PostgreSQL-specific implementations for retrieving database and table metadata for the Creole ORM, directly querying PostgreSQL system catalogs and `information_schema` via PHP's `ext/pgsql` extension.

## Maintenance & Modernization Notes

*   **`ext/pgsql` vs. `ext/pdo_pgsql`**: The current implementation exclusively relies on the older `ext/pgsql` functions. For modern PHP development, `PDO` (`ext/pdo_pgsql`) is generally preferred due to its unified API, robust error handling, and native support for server-side prepared statements. A significant modernization effort would involve migrating this driver to use PDO.
*   **Type Mapping Accuracy**: The `PgSQLTypes.php` mapping should be reviewed periodically to ensure it accurately reflects current PostgreSQL data types and their appropriate Creole equivalents, especially with newer PostgreSQL versions introducing new types or altering existing ones.
*   **Error Handling**: The error handling mechanisms should be examined. Older `ext/pgsql` usage might rely on `pg_last_error()` and manual checks, which can be less explicit than modern exception-based handling.
*   **SQL Injection Prevention**: While `PgSQLPreparedStatement` uses `pg_escape_string()`, ensuring that all user-supplied data is always passed through prepared statements (or explicitly escaped) is critical. Manual string concatenation before calling `execute()` on a prepared statement object could still lead to vulnerabilities.
*   **Legacy ORM Context**: Creole itself is an older ORM. Any significant refactoring or modernization should consider the broader context of the application's ORM strategy.
