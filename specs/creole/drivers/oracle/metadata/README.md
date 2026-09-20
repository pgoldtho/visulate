# Oracle OCI8 Metadata Drivers

This directory contains the Oracle (OCI8) specific implementations for retrieving database metadata within the Creole database abstraction layer. These classes extend the generic metadata interfaces to provide detailed information about Oracle databases and their tables, such as schema, columns, and other structural details, leveraging the OCI8 PHP extension.

## Files & Component Responsibilities

*   `OCI8DatabaseInfo.php`: This file defines the `OCI8DatabaseInfo` class, which is an Oracle-specific implementation of `DatabaseInfo`. It is responsible for handling connections and retrieving general metadata about an Oracle database, including determining the active schema based on the DSN or username.
*   `OCI8TableInfo.php`: This file defines the `OCI8TableInfo` class, an Oracle-specific implementation of `TableInfo`. It is responsible for retrieving detailed metadata for individual tables within an Oracle database, such as column definitions, data types, and other table-specific attributes, for the specified schema.

## Database Dependencies & Interactions

The classes in this directory are designed to interact directly with the Oracle database's data dictionary views to retrieve metadata. While specific queries are not fully detailed in the provided samples, their purpose implies interaction with Oracle system views such as:
*   `ALL_TABLES` / `USER_TABLES`
*   `ALL_TAB_COLUMNS` / `USER_TAB_COLUMNS`
*   `ALL_CONSTRAINTS` / `USER_CONSTRAINTS`
*   `ALL_IND_COLUMNS` / `USER_IND_COLUMNS`
These views are queried to construct the `DatabaseInfo` and `TableInfo` objects.

## Maintenance & Modernization Notes

*   **Oracle Version Compatibility**: Ensure that the queries used to retrieve metadata are compatible with the target Oracle database versions. Oracle's data dictionary views can evolve, and certain metadata might be structured differently across major versions.
*   **OCI8 Extension**: This code relies on the `php-oci8` extension. When modernizing, consider if a transition to `PDO_OCI` or other Oracle-specific libraries would be beneficial for current PHP environments.
*   **Schema Handling**: The explicit handling of schema (`$this->schema`) is a crucial aspect for multi-schema Oracle environments. Any refactoring should carefully preserve or enhance this functionality.
*   **Performance**: Metadata retrieval can be resource-intensive. Ensure that the queries against the Oracle data dictionary are optimized and avoid unnecessary or redundant calls.
