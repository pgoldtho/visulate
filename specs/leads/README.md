# `specs/leads`

## Functional Overview
This directory houses the design specifications and requirements documents for the lead management functionality within the Visulate application. It includes mockups illustrating user interfaces for finding persons (who may be leads or tenants) and recording new leads, alongside a formal requirements document outlining the system's expected behavior and features. These documents serve as the foundation for the development of lead-related modules, guiding UI/UX and backend logic implementation.

## Files & Component Responsibilities

| File Name          | Description                                                                                                                                                                                                                               |
| :----------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `find_person.bmml` | Balsamiq Mockup file outlining the user interface for searching or finding individuals. It includes UI elements for distinguishing between "Lead" and "Tenant" types, suggesting a system that handles both prospective and existing clients. |
| `record_lead.bmml` | Balsamiq Mockup file demonstrating the UI for recording new lead information. This mockup includes fields for lead details and a "Reference Property" section, indicating the ability to associate leads with specific properties.              |
| `requirements.doc` | A Microsoft Word document containing detailed business and functional requirements for the lead management system. This document serves as a comprehensive specification for the features outlined in the mockups.                          |

## Database Dependencies & Interactions
While the files in this directory (`.bmml` mockups and a `.doc` requirements file) are static specification documents and do not directly interact with a database, the features they describe implicitly depend on the application's core database.

The lead management functionality envisioned in these specifications would interact with:
*   **Lead Data**: Tables storing lead-specific information (e.g., contact details, status, source).
*   **Property Data**: Tables storing property listings, as indicated by the "Reference Property" section in `record_lead.bmml`.
*   **Person/User Data**: Tables managing general person records, potentially allowing for the distinction between "Lead" and "Tenant" as seen in `find_person.bmml`.

Actual database tables, views, packages, or procedures would be defined and implemented in associated application code directories (e.g., `src/main/java/com/visulate/leads`, `database/schema/leads`).

## Submodules / Subdirectories

*   **`assets`**: This directory is reserved for static assets, such as images, icons, or supporting files relevant to the lead specifications. The Balsamiq mockups (`.bmml` files) explicitly reference images (e.g., `find_page.png`, `rec_lead.png`) expected to reside in this `assets` subdirectory, although it is currently empty.

## Maintenance & Modernization Notes
*   **Mockup Updates**: The `.bmml` files represent design artifacts. Any changes to the UI/UX for lead management should be reflected and versioned in these mockups or migrated to a more modern design tool/format if appropriate.
*   **Requirements Clarity**: The `requirements.doc` is a binary Word document. For improved collaboration, searchability, and version control, consider migrating its content to a text-based format (e.g., Markdown, Confluence, or an issue tracking system) that can be more easily integrated into the development workflow.
*   **Consistency with Code**: Ensure that the implemented lead management features remain consistent with these foundational specifications. Discrepancies should prompt updates to either the specifications or the code.
*   **Data Model Implications**: The mockups imply a data model for `Lead`, `Tenant`, and `Property` entities. When developing or refactoring the database schema, refer to these specifications to ensure all required data points are captured.
