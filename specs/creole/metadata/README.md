# `specs/creole/metadata`

## Functional Overview
This directory contains a set of "Info" classes forming the core metadata representation layer for the Creole PHP database abstraction framework. These classes are responsible for encapsulating the structural details of a database schema, including information about the database itself, its tables, columns, primary keys, foreign keys, and indexes. They act as data transfer objects (DTOs) for database schema elements, allowing other parts of the Creole framework (such as schema introspection tools or ORM components) to work with a standardized representation of database metadata.

## Files & Component Responsibilities

| File Name          | Description                                                                                                                              |
| :----------------- | :--------------------------------------------------------------------------------------------------------------------------------------- |
| `ColumnInfo.php`   | Represents a single column within a database table, detailing its name, Creole type, native type, size, and other properties.               |
| `DatabaseInfo.php` | An abstract base class for encapsulating database-level metadata, such as a collection of tables and sequences. Concrete implementations would extend this for specific database systems. |
| `ForeignKeyInfo.php` | Represents a foreign key constraint, including its name, the columns involved, and the referenced table and columns. Defines constants for `ON DELETE` and `ON UPDATE` actions. |
| `IndexInfo.php`    | Represents a database index, specifying its name, the columns it covers, and whether it enforces uniqueness.                               |
| `PrimaryKeyInfo.php` | Represents a primary key constraint, containing its name and the list of columns that form the primary key.                               |
| `TableInfo.php`    | An abstract base class for encapsulating table-level metadata, including its name, columns, foreign keys, indexes, and primary key. Concrete implementations would extend this for specific database systems. |

## Database Dependencies & Interactions
The classes within this directory are designed to *represent* database metadata rather than directly interact with a database through DDL or DML operations. They serve as containers for information typically retrieved by a database introspection layer (e.g., a schema manager or driver-specific metadata factory) from a live database's system catalog. As such, these files themselves do not contain direct SQL queries or database connection logic. Their role is purely to define the structure for holding schema information.

## Submodules / Subdirectories
There are no subdirectories within `specs/creole/metadata`.

## Maintenance & Modernization Notes
*   **Legacy Code Concerns**: The code originates from the Creole project, an older PHP database abstraction layer. When modernizing, consider replacing this metadata representation with a more contemporary library (e.g., Doctrine DBAL's schema objects) or adapting these classes to work with modern PHP features and design patterns.
*   **Serialization and Encapsulation**: `ColumnInfo.php` explicitly mentions a `FIXME` regarding public member attributes due to PHP's serialization support at the time. In modern PHP, `__sleep()` and `__wakeup()` (or `Serializable` interface / `__serialize` / `__unserialize`) handle protected/private members correctly. Consider refactoring to use protected/private properties with proper getters and setters for better encapsulation and maintainability.
*   **Version Control Tags**: The files contain `$Id` and `$Revision` tags, which are artifacts of older version control systems like CVS/SVN. These tags are not functional in a Git repository and can be safely removed or updated to reflect Git-based versioning if necessary.
*   **Abstract Base Classes**: `DatabaseInfo.php` and `TableInfo.php` are abstract classes. Ensure that concrete implementations (likely found in driver-specific packages, e.g., `creole.drivers.mysql` or `creole.drivers.pgsql`) correctly extend and implement the necessary methods for metadata retrieval and population.
