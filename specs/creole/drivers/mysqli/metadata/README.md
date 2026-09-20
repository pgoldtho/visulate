# MySQLi Metadata Driver

This directory contains the MySQLi-specific implementations for retrieving database and table metadata within the Creole ORM framework. These classes extend the generic `DatabaseInfo` and `TableInfo` interfaces, providing concrete methods to query a MySQL database via the `mysqli` extension to discover schema details such as available tables and the columns within them.

## Files & Component Responsibilities

*   **`MySQLiDatabaseInfo.php`**:
    *   Extends `creole/metadata/DatabaseInfo.php`.
    *   Responsible for fetching general database-level information.
    *   Its primary function is to initialize and populate the list of tables present in the connected database by executing `SHOW TABLES FROM <dbname>`.
    *   It relies on `MySQLiTableInfo.php` to represent individual tables.
*   **`MySQLiTableInfo.php`**:
    *   Extends `creole/metadata/TableInfo.php`.
    *   Responsible for fetching detailed information about a specific database table.
    *   Initializes and populates the list of columns for a table by executing `SHOW COLUMNS FROM <tablename>`.
    *   Utilizes `creole/metadata/ColumnInfo.php` and `creole/drivers/mysql/MySQLTypes.php` to interpret and store column details.

## Database Dependencies & Interactions

The classes in this directory directly interact with a MySQL database using the PHP `mysqli` extension. They perform the following SQL queries to gather metadata:

*   `SHOW TABLES FROM <dbname>`: Used by `MySQLiDatabaseInfo` to retrieve a list of all tables in the current database.
*   `SHOW COLUMNS FROM <tablename>`: Used by `MySQLiTableInfo` to retrieve detailed information (name, type, nullability, default, extra attributes) for all columns within a specified table.

These interactions are fundamental to how Creole introspects the database schema when using the MySQLi driver.

## Submodules / Subdirectories

None.

## Maintenance & Modernization Notes

*   **Direct `mysqli` Calls**: The code directly uses `mysqli_query` and `mysqli_error`, which ties it tightly to the `mysqli` extension. Modernization might involve abstracting this interaction further, potentially through a PDO-like interface or a dedicated database connection wrapper, to allow for easier swapping of underlying database extensions or drivers without modifying the metadata retrieval logic itself.
*   **Error Handling**: Errors are caught using `mysqli_error` and encapsulated in `SQLException`, which is a standard pattern within the Creole framework.
*   **Dependency Management**: `include_once` and `require_once` are used within methods to load dependent classes dynamically. In a more modern PHP context, an autoloader would typically handle class loading, simplifying file includes.
