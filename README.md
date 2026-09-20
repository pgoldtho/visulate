# Visulate Codebase

## Functional Overview
This is the root directory for the Visulate project, serving as the top-level organizer for its entire codebase and associated documentation. It provides a structured entry point to an application designed to interact with Oracle databases, generate code, expose APIs, and present a web interface, with a clear separation between the application's source code and its project specifications.

## Files & Component Responsibilities
This root directory primarily serves as the organizational hub for the entire Visulate project. All functional components and documentation are segregated into distinct subdirectories. There are no standalone files directly present at this level; its main role is to provide a top-level structure and logical grouping for the application's source code and specifications.

## Database Dependencies & Interactions
Direct database dependencies and interactions are not managed at this root level. Instead, all database-related logic, including connection management, SQL scripts, and Oracle-specific operations, are encapsulated within dedicated modules and subdirectories, primarily within the `code/oracle` path and other relevant components deeper within the `code` directory structure.

## Submodules / Subdirectories
The Visulate codebase is structured into the following key subdirectories:

*   **`code/`**: The `code` directory serves as the root of the Visulate application's codebase, organizing subdirectories for API, Oracle database management, code generation, and the main PHP web application, with a significant need for modernization in the PHP components.
*   **`specs/`**: The `specs` directory serves as the central documentation hub for the Visulate codebase, containing design documents, functional requirements, whitepapers, data models, and specialized SQL scripts related to various system features and their database interactions.

## Maintenance & Modernization Notes
As the top-level directory, maintenance efforts here are primarily focused on ensuring the overall project structure remains clear and well-organized, facilitating easy navigation for developers. A significant consideration for the Visulate project, as highlighted by the `code` directory summary, is the ongoing need for modernization, particularly regarding its PHP web application components. Future refactoring and development should prioritize updating these legacy parts while maintaining robust compatibility with the existing Oracle database interactions and the overall system architecture.
