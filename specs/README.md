# specs

This directory serves as a central repository for a wide array of documentation, specifications, and auxiliary scripts related to the Visulate codebase. It encompasses design documents, functional requirements, whitepapers, data mapping details, and specific utility SQL scripts, providing a historical and current view of various system components.

## Files & Component Responsibilities

*   **`Amazon EC2 Environment.odt`**: Documentation detailing the setup and configuration of the Amazon EC2 environment for Visulate deployments.
*   **`NOI_Estimates.odt`**: A document outlining the methodology and considerations for calculating Net Operating Income (NOI) estimates within the Visulate system.
*   **`RatingsWhitePaper.docx`**: A whitepaper concerning ratings, likely related to property or investment evaluations.
*   **`SingleFamilyRentalCMBS Evaluation.docx`**: Documentation focused on the evaluation processes for Single-Family Rental Commercial Mortgage-Backed Securities (CMBS).
*   **`advertise_properties.doc`**: Specification document detailing the features and requirements for advertising properties. This document indicates interaction with property photo storage.
*   **`advertise_properties_public.doc`**: Further specifications for publicly advertising rental properties, potentially an extension or refinement of `advertise_properties.doc`.
*   **`brevard_mapping.doc`**: Documentation on the data mapping process from Brevard County Property Appraiser's data to the Visulate public records tables.
*   **`kroll_multi_family.docx`**: A document likely related to multi-family property analysis, possibly in the context of Kroll rating agency standards or similar financial evaluations.
*   **`vacancy_rate.sql`**: An Oracle PL/SQL script designed to calculate and output vacancy rates by iterating through business units, properties, and tenancy agreements.
*   **`visulate_public_records.docx`**, **`visulate_public_records.odt`**: Comprehensive documentation pertaining to the design, acquisition, and utilization of public records data within the Visulate application.
*   **`whitepaperTemplate.docx`**: A generic template for creating whitepapers, likely used for various analytical or technical documents within the project.
*   **`wiki-requirements-template.txt`**: A plain text template outlining the structure and sections for requirements documentation intended for a wiki platform.

## Database Dependencies & Interactions

This directory contains documents and scripts that directly interact with or specify interactions with several core Visulate database tables:

*   **`RNT_PROPERTY_PHOTOS`**: Referenced by `advertise_properties.doc`, this table is essential for storing and managing images associated with properties, particularly for rental listings and advertising.
*   **`RNT_BUSINESS_UNITS`**: Utilized by `vacancy_rate.sql`, this table defines the organizational structure and business entities, playing a role in financial and operational reporting, such as calculating vacancy rates.
*   **`RNT_PROPERTIES`**: Referenced by `vacancy_rate.sql`, this is a central table for storing detailed information about individual properties, crucial for many system functions including property advertising and vacancy analysis.
*   **`RNT_TENANCY_AGREEMENT`**: Employed by `vacancy_rate.sql`, this table holds details about rental agreements, which are fundamental for tracking occupancy and calculating vacancy rates.

## Submodules / Subdirectories

This directory organizes further specialized documentation and design assets into several subdirectories:

*   **`architecture`**: This directory houses crucial architectural documentation and web server configuration files for the Visulate system, covering deployment, security, and operational aspects. It serves as a central reference for the system's infrastructure.
*   **`Bookkeeping`**: This directory contains legacy specification documents and diagrams crucial for understanding the design and evolution of the Visulate application's double-entry bookkeeping, general ledger, and financial reporting features, detailing interactions with core accounting database tables.
*   **`buyer_role`**: This directory contains design specifications and documentation for the "Buyer Role" in Visulate, detailing features like property investment analysis, advertising, and loan processes, with dependencies on core rental management database tables.
*   **`creole`**: This directory defines the core interfaces and foundational classes of the Creole PHP database abstraction layer, establishing the contract for database connections, statements, result sets, and error handling across various RDBMS platforms. It provides the architectural blueprint for the entire Creole library.
*   **`datamodel`**: This directory contains data models, database diagrams (Visio, Oracle XML), and related documentation for various components like public records (Brevard, Volusia counties) and a rent management system within the Visulate codebase.
*   **`help`**: This directory contains a binary document, `error_code.doc`, which defines custom application error codes and their descriptions, primarily for Oracle PL/SQL packages, and specifies their relationship with the `RNT_ERROR_DESCRIPTION` database table.
*   **`leads`**: This directory contains design mockups and a requirements document detailing the user interfaces and functional requirements for lead management within the Visulate application, including processes for finding individuals and recording new leads.
*   **`training`**: This directory contains static training materials, specifically a PowerPoint presentation (`cfri.pptx`), and has no direct code or database dependencies.
*   **`UI`**: This directory contains early UI prototypes, design specifications, and related assets for the Visulate rental management system, detailing layouts for Property, Tenant, and Payment modules, along with foundational UI/layout standards and mobile requirements.
*   **`Visio`**: This directory contains Microsoft Visio diagrams that serve as visual specifications, Entity-Relationship Diagrams (ERDs), and conceptual models for various business processes, data structures, and system components within the Visulate codebase.

## Maintenance & Modernization Notes

Many documents within this directory are in older `.doc` or `.odt` formats. For improved accessibility, version control, and collaborative editing, consider converting these to modern formats like Markdown or Google Docs. The `vacancy_rate.sql` script, while functional, is a procedural PL/SQL block; for reusability and integration into application logic, it could be refactored into a named stored procedure, function, or view if it represents a recurring business report. This directory's mixed nature of requirements, design, and auxiliary scripts suggests potential benefit from consolidation into a dedicated documentation platform (e.g., a wiki or Confluence) that allows for better organization, searchability, and linking to related code.
