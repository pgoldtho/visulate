# `creole/util`

## Functional Overview
This directory, `specs/creole/util`, provides a set of utility classes for managing Large Objects (LOBs), specifically Binary Large Objects (BLOBs) and Character Large Objects (CLOBs). These classes offer an abstraction layer for handling large data types, often stored in or retrieved from databases, allowing for manipulation, storage, and retrieval of substantial binary or text data within the `creole` framework.

## Files & Component Responsibilities

*   **`Lob.php`**: This file defines the abstract base class for all Large Objects (LOBs). It establishes common properties (such as the LOB's data content, input/output file paths) and an interface for fundamental LOB operations. It serves as a foundational component for concrete LOB implementations, providing a consistent way to manage large data.
*   **`Blob.php`**: This concrete class extends the `Lob` abstract class to specifically manage Binary Large Objects (BLOBs). It provides functionality suitable for handling binary data, such as images, audio files, or other non-textual data. It includes methods like `dump()` to output the binary content, useful for direct streaming or download operations.
*   **`Clob.php`**: This concrete class extends the `Lob` abstract class to specifically manage Character Large Objects (CLOBs). It is designed for handling large amounts of textual data, such as long descriptions, articles, or extensive log files. It offers methods like `readFromFile()` for efficiently reading character data from files into the LOB object.

## Database Dependencies & Interactions
While no explicit database dependencies were indexed for these files, the `Lob`, `Blob`, and `Clob` classes are inherently designed to represent and manage Large Objects (LOBs) that are typically stored within relational database systems. These classes provide an application-level abstraction for interacting with LOB columns in a database, facilitating the transfer, storage, and retrieval of large binary or character data between the application and the database backend.

## Submodules / Subdirectories
*   **`sql/`**: This directory provides a static utility class, `SQLStatementExtractor`, for parsing and extracting individual SQL statements from strings or files, primarily for processing SQL scripts rather than direct database interaction.

## Maintenance & Modernization Notes
The classes in this directory exhibit characteristics of older PHP code (e.g., PHP 4/5 style class and function declarations, `$Id` tags, LGPL license information in file headers). When considering modernization or refactoring, attention should be paid to:
*   **Modern PHP Features**: Refactoring to utilize modern PHP features such as namespaces, stricter type declarations, constructor property promotion, and contemporary class syntax.
*   **LOB Handling**: Reviewing LOB handling in current database drivers (e.g., PDO) as they often provide more direct, stream-based, and efficient ways to manage LOB data, which might simplify or enhance the existing implementation.
*   **Error Handling**: Ensuring error handling aligns with current PHP best practices (e.g., using custom exceptions or a more robust error reporting mechanism).
*   **Documentation**: Updating internal and external documentation, and potentially removing deprecated version control tags like `$Id` and `$Revision`.
