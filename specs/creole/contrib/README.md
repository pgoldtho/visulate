# specs/creole/contrib

## Functional Overview
This directory contains utility or "contributed" classes specifically designed to extend the functionality of the Creole ORM framework. Its primary purpose is to provide a mechanism for debugging and monitoring database interactions. It houses a debug implementation of the `Connection` interface, which allows developers to track and log database queries executed through a Creole connection without altering the core connection logic. This is achieved using the decorator pattern, where the debug connection wraps around a true `Connection` object to inject debugging capabilities.

## Files & Component Responsibilities
*   **`DebugConnection.php`**: This file defines the `DebugConnection` class, which implements the `Connection` interface. It functions as a decorator, encapsulating a real `Connection` object (`$childConnection`). Its responsibilities include:
    *   Tracking the total number of queries executed (`$numQueriesExecuted`).
    *   Storing the last executed query (`$lastExecutedQuery`).
    *   Providing methods to retrieve these debug statistics.
    *   Allowing a logger (e.g., an instance of PEAR Log) to be set, enabling logging of query execution.
    *   It is designed to be registered as a Creole driver, intercepting database calls to provide transparent debugging.

## Database Dependencies & Interactions
The components within this directory, particularly `DebugConnection.php`, do not declare or manage their own direct database schema dependencies (e.g., tables, views, stored procedures). Instead, `DebugConnection` operates purely as a wrapper around an existing Creole `Connection` object. Its database interactions are entirely delegated to the underlying, wrapped connection. It passively observes and logs the queries executed by the true connection, but it does not perform its own direct SQL operations or depend on any specific database structures for its functionality.

## Submodules / Subdirectories
This directory contains no subdirectories.

## Maintenance & Modernization Notes
*   **Framework Context**: Creole is an older PHP ORM. Any significant maintenance or modernization efforts for this directory should consider the broader context of the Creole framework. If the project is being modernized, evaluate whether migrating to a more contemporary ORM (e.g., Doctrine, Eloquent) might be a more strategic long-term solution.
*   **Debugging & Profiling Tools**: While `DebugConnection` offers basic query tracking, modern PHP applications often benefit from more comprehensive profiling and debugging solutions (e.g., Xdebug, Blackfire, or custom profilers integrated with PSR-3 loggers). If advanced debugging is a continuous need, consider integrating with or replacing this component with a more robust, standard profiling tool.
*   **Logging Standards**: The current implementation expects a logger with a `log()` method (like PEAR Log). For modernization, consider adapting `DebugConnection` to accept a PSR-3 compliant logger interface, which is a widely adopted standard for logging in contemporary PHP projects, enhancing flexibility and interoperability.
