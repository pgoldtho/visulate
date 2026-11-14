# creole.common - Common Database Abstraction Layer Components

## Functional Overview
This directory contains abstract base classes providing shared logic and default implementations for various components of the Creole database abstraction layer. These "Common" classes aim to simplify the creation of concrete driver implementations for different databases by offering boilerplate code, handling common scenarios like emulated prepared statements, and providing consistent result set behavior. They serve as foundational building blocks for the core database interaction interfaces within Creole.

## Files & Component Responsibilities

*   **`ConnectionCommon.php`**:
    Defines an abstract base class (`ConnectionCommon`) intended to provide shared information and default behavior for database connection implementations. It includes methods and properties common to all connections, aiming to reduce redundant code in specific database drivers. The class itself notes that its utility is currently limited.

*   **`PreparedStatementCommon.php`**:
    Provides an abstract base class (`PreparedStatementCommon`) for handling emulated pre-compiled SQL statements. This is particularly useful for database drivers that do not natively support server-side prepared statements, offering a PHP-side emulation layer. It manages parameter binding and query parsing for emulated execution, ensuring consistent behavior across different drivers.

*   **`ResultSetCommon.php`**:
    Implements an abstract base class (`ResultSetCommon`) offering many shared and common methods for result set drivers. This includes robust data retrieval and formatting methods (e.g., `getTimestamp`, `getString`, etc.) that handle `NULL` values gracefully and can throw `SQLException` for non-existent columns. It aids in standardizing how data is fetched and processed from database results across various drivers.

*   **`StatementCommon.php`**:
    Contains an abstract base class (`StatementCommon`) providing common and shared functionality for generic database statements. It manages properties such as the associated `Connection` object, temporarily holds `ResultSet` objects after query execution, and tracks affected row counts. This class forms a foundational base for both simple `Statement` objects and more complex `PreparedStatement` objects.

## Database Dependencies & Interactions
This directory primarily contains abstract PHP classes that define common behaviors and provide shared logic for Creole's database abstraction layer components. As such, these files do not have direct, explicit dependencies on specific database tables, views, or stored procedures. Their purpose is to define the framework for *how* concrete database drivers will interact with databases, rather than performing direct database operations themselves. Actual database interaction is delegated to the concrete driver implementations that extend or utilize these common classes.

## Submodules / Subdirectories
This directory does not contain any subdirectories.

## Maintenance & Modernization Notes
*   **Legacy Codebase Context**: These files are part of the `creole.phpdb.org` project, indicating an older PHP codebase (likely PHP 5.x era). Modern PHP (7.x+) offers significant performance improvements and language features that could simplify or optimize this code.
*   **Prepared Statement Emulation**: The `PreparedStatementCommon.php` class handles emulated prepared statements. While historically useful, modern PHP PDO offers robust native prepared statement support. If modernizing, consider leveraging PDO's native capabilities to avoid the overhead of emulation and improve security.
*   **Utility of Common Classes**: Comments within `ConnectionCommon.php` suggest it "is not very useful yet." A review of whether these "Common" classes genuinely simplify driver development or introduce unnecessary abstraction/indirection would be beneficial during a refactor.
*   **Licensing**: The LGPL license is mentioned in file headers. When modernizing, review if this license is still appropriate or if a more permissive license (e.g., MIT, Apache 2.0) would better suit modern open-source practices, depending on project goals.
*   **Type Hinting and Modern PHP Features**: The classes could benefit from modern PHP features such as scalar type hints, return type declarations, and stricter error handling to improve code clarity, maintainability, and static analysis capabilities.
*   **Error Handling**: The existing exception handling (e.g., `SQLException` mentioned in `ResultSetCommon.php`) should be reviewed against modern PHP exception practices and standards.
