# SQL Statement Extraction Utilities

## Functional Overview
This directory contains utility classes primarily focused on extracting individual SQL statements from larger blocks of text or files. Its core purpose is to parse a given input (string or file content) and break it down into an array of distinct SQL commands, typically separated by a delimiter like a semicolon. This functionality is essential for processing SQL scripts, database migration files, or database dumps where multiple statements are grouped together.

## Files & Component Responsibilities

| File Name             | Description                                                                                                                                                                                                                                                                                                                           |
| :-------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `SQLStatementExtractor.php` | Implements the `SQLStatementExtractor` class, a static utility designed to parse a given string or file content and break it down into an array of individual SQL statements. It includes methods like `extractFile()` and `extractString()` and handles common SQL delimiters (e.g., `;`) to separate the statements. |

## Database Dependencies & Interactions
This directory's components do not directly interact with any specific database tables, views, stored procedures, or packages. The code here is purely for *processing* SQL statements as text; it does not execute them against a database or depend on specific database schema objects.

## Submodules / Subdirectories
There are no subdirectories or submodules within `specs/creole/util/sql`.

## Maintenance & Modernization Notes
*   **Legacy Codebase**: The `SQLStatementExtractor.php` file dates back to 2004. This indicates it was developed for an older version of PHP (likely PHP 4 or early PHP 5). When modernizing, consider updating the code to adhere to current PHP standards (e.g., namespaces, scalar type hints, return type declarations, modern exception handling).
*   **SQL Parsing Robustness**: The current SQL extraction logic, while functional for many cases, might be simplistic. It may not robustly handle advanced SQL syntax nuances such as semicolons embedded within quoted strings, multi-line comments that contain semicolons, or complex SQL structures that could interfere with simple delimiter-based splitting. If dealing with highly complex or varied SQL, a more sophisticated parsing library might be necessary or a more robust custom parser implementation should be considered.
*   **Performance for Large Files**: For extremely large SQL files, reading the entire file into memory using `file_get_contents()` might be inefficient. A streaming approach, reading the file line by line or in chunks, could improve memory usage and performance for very large inputs.
