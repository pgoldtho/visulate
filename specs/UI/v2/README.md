# UI Version 2 Specifications and Prototypes

This directory (`specs/UI/v2`) contains early user interface prototypes, design specifications, and supporting assets for Visulate UI version 2. It provides a glimpse into the initial layout, navigation structures, and interactive components planned for the "Visulate Rentals" application, featuring property management views and administrative sections. The components here largely rely on HTML, CSS, and client-side JavaScript, including the MooTools framework and a custom tree widget.

## Functional Overview

The primary function of this directory is to host the foundational HTML, CSS, and JavaScript files that served as prototypes for the Visulate application's user interface. These files demonstrate specific page layouts, menu systems (both static and dynamic), and general visual styling. They represent a snapshot of UI development, likely from an earlier phase, focusing on distinct modules like "Property" management and "Admin" functionality.

## Files & Component Responsibilities

| File Name          | Description                                                                                                                                                                                                                                                                                        |
| :----------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `1-1_new.html`     | Prototype HTML page for the "Property Details" view within the Visulate Rentals application. It showcases the main layout, header, and a multi-level navigation menu with "Property" selected.                                                                                                        |
| `1-2_new.html`     | Prototype HTML page for the "Property Finance" view. Similar in structure to `1-1_new.html`, it maintains the navigation context, highlighting the "Finance" sub-menu item.                                                                                                                        |
| `1-3_new.html`     | Prototype HTML page for the "Property Expense" view. This file extends the property management interface, with "Expense" marked as the current active sub-menu item.                                                                                                                               |
| `1-4_new.html`     | Prototype HTML page for the "Property Summary" view. It completes the series of property management related UI prototypes, focusing on a summary display and marking "Summary" as the active sub-menu item.                                                                                           |
| `dymanic_menu.html`| **(Typo: Should be `dynamic_menu.html`)** A prototype HTML page demonstrating a dynamic menu structure, likely intended for an "Admin" section. It integrates both `tree.js` for hierarchical display and the MooTools Accordion library for interactive content panels.                                 |
| `dynamic_content.doc`| A Microsoft Word document outlining "Visulate Requirements" for "Dynamic Page Content." This file serves as a specification or requirements document, detailing how dynamic elements should function within the application's UI.                                                                 |
| `tree.js`          | A custom JavaScript library that implements a content-separated tree widget. This script is responsible for transforming unordered lists into an interactive, collapsible/expandable tree-view structure, primarily used for navigation or hierarchical data display (e.g., in `dymanic_menu.html`). |

## Database Dependencies & Interactions

No direct database dependencies or interactions are identified within these client-side UI specification files. These files are primarily concerned with the presentation layer and do not contain logic for direct database access. Backend interactions would be handled by server-side scripts or APIs not present in this directory.

## Submodules / Subdirectories

*   **`css`**: This directory contains the core CSS stylesheets for Visulate UI version 2, covering general layout, the main theme, and print-specific styles for the application's visual presentation.
*   **`images`**: This directory is designated for UI v2 image assets but currently only contains a Windows thumbnail cache file (`Thumbs.db`), which should be ignored by version control.
*   **`mootools_accordion`**: This directory houses the MooTools JavaScript framework (v1.2.0), providing the core library for developing interactive UI components, as exemplified by its contained Accordion module.
*   **`tree`**: This directory contains CSS files (`tree.css` and its `.safe.txt` copy) responsible for styling hierarchical tree-view UI components, defining their layout, appearance, and collapse/expand behavior.

## Maintenance & Modernization Notes

*   These files represent UI prototypes from an earlier development phase. The use of XHTML 1.0 Transitional DTD and MooTools v1.2.0 indicates an older web technology stack. Modernization efforts would likely involve migrating to contemporary HTML5, CSS3, and a more current JavaScript framework (e.g., React, Vue, Angular).
*   The file `dynamic_content.doc` is a binary document (Microsoft Word) and is generally not recommended for storage in a Git repository. It should ideally be managed in a dedicated documentation system or converted to a text-based format (e.g., Markdown) if its content is still relevant and needs to be version-controlled with the code.
*   The typo in `dymanic_menu.html` should be corrected to `dynamic_menu.html` for consistency and clarity if this file is intended for continued use or as a reference.
*   The architectural approach to dynamic UI, involving specific JavaScript files like `tree.js` and a full MooTools library, could be refactored into a component-based structure if transitioning to a modern frontend framework.
