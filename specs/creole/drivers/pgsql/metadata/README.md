# PostgreSQL Metadata Drivers

This directory contains the PostgreSQL-specific implementations for retrieving database and table metadata within the Creole ORM framework. It provides concrete classes that extend the generic `DatabaseInfo` and `TableInfo` interfaces, tailoring them to query and parse metadata from a PostgreSQL database server.

## Functional Overview

The primary function of this module is to abstract the process of introspecting a PostgreSQL database. It allows the Creole ORM to discover information about the database schema, such as the tables present, their columns, primary keys, foreign keys, and indexes, without needing to hardcode PostgreSQL-specific SQL queries throughout the application. These classes are crucial for schema management, reverse engineering, and ORM functionalities like object hydration and query building.

## Files & Component Responsibilities

| File                 | Description                                                                                                                                                                                                                                                                               |
| :------------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `PgSQLDatabaseInfo.php` | Implements the `DatabaseInfo` interface for PostgreSQL. This class is responsible for retrieving global database-level information, such as the PostgreSQL server version and the list of available tables within the connected database. It makes direct calls to `pg_query` to fetch this data. |
| `PgSQLTableInfo.php` | Implements the `TableInfo` interface for PostgreSQL. This class handles the introspection of individual tables, fetching detailed information about their structure. This includes discovering columns, their data types, constraints (primary keys, foreign keys), and indexes. It leverages PostgreSQL's system catalogs (like `pg_class`, `pg_attribute`, `pg_constraint`, `pg_index`) and potentially `information_schema` for newer PostgreSQL versions to gather this data. |

## Database Dependencies & Interactions

This module directly interacts with a PostgreSQL database using PHP's `ext/pgsql` extension.

*   **System Catalogs**: The classes query PostgreSQL's internal system catalogs to retrieve metadata.
    *   `PgSQLDatabaseInfo.php` executes `SELECT version()` to determine the server version.
    *   `PgSQLTableInfo.php` queries various `pg_` system tables (e.g., `pg_class`, `pg_attribute`, `pg_constraint`, `pg_index`) to gather comprehensive table and column details.
*   **`information_schema`**: The `PgSQLTableInfo.php` file includes a `TODO` note indicating an eventual move to fully support PostgreSQL's `information_schema` for versions `>= 7.4`. This suggests that earlier PostgreSQL versions might be supported using older system catalog queries or a mix of approaches.

The interaction involves sending standard SQL `SELECT` statements to the database via the `pg_query()` function and then parsing the result sets to populate the metadata objects.

## Maintenance & Modernization Notes

*   **Legacy Codebase**: The presence of CVS `$Id$` and `$Revision$` tags suggests this is an older codebase. Modern PHP projects would typically use Composer for dependency management and follow PSR standards.
*   **PostgreSQL Version Compatibility**: The `PgSQLTableInfo.php` file explicitly mentions a `TODO` to support only Postgres >= 7.4 with `information_schema`. This implies that the current implementation might be designed to work with even older PostgreSQL versions, potentially using less standardized or more complex queries against system catalogs. Modernization should aim to fully utilize `information_schema` for cleaner and more standard metadata retrieval where possible, while ensuring backward compatibility if required.
*   **Direct `pg_query` usage**: The direct use of `pg_query` ties this code directly to the `ext/pgsql` PHP extension. While functional, modern ORMs often abstract database interactions through a more generic driver layer, which could make switching database extensions (e.g., to `PDO`) easier.
*   **Error Handling**: Review the error handling mechanism. Older codebases might not always use modern exception handling practices.
