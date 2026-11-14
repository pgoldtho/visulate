# Smarty Template Includes for Property Details

## Functional Overview
This directory contains Smarty template files (`.tpl`) that serve as reusable components for displaying property details on the Visulate website. These templates are designed to be included by other main Smarty templates to present property information, handle image slideshows, and differentiate content based on whether a property listing originates from the Multiple Listing Service (MLS) or is a direct, non-MLS listing. They focus on the presentation layer, receiving data through Smarty variables.

## Files & Component Responsibilities

| File Name                         | Description                                                                                                                                                                                                                                                                                                                                                                       |
| :-------------------------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `photo-slider.tpl`                | Implements a generic photo slider for property images. It iterates through an array of image data (`$m.IMG`) and displays them with custom jQuery-based navigation controls (next/previous, indicators). This template is suitable for displaying a series of photos in an interactive manner.                                                                                          |
| `visulate-property-details-mls.tpl` | Displays detailed information for a property listed on the Multiple Listing Service (MLS). It includes a Bootstrap carousel for images, a property description, and contact information (email, phone, property ID) specifically tailored for MLS listings, including a dynamic MLS number in the contact email subject.                                                         |
| `visulate-property-details-nomls.tpl` | Displays detailed information for a property not originating from the MLS. This template includes a welcome message, an embedded Google AdSense advertising block, and general contact information for Visulate, emphasizing that the property may not be currently for sale or rent. It targets properties within Florida.                                                   |

## Database Dependencies & Interactions
The templates in this directory are purely presentation-layer components and do not directly interact with the database. They rely entirely on data passed to them as Smarty variables by the PHP scripts that invoke and render them. Any data retrieval or manipulation happens upstream in the PHP application logic.

## Submodules / Subdirectories
There are no subdirectories within `code/php/_smarty/templates/include`.

## Maintenance & Modernization Notes
*   **Templating Logic**: The templates use Smarty's syntax for loops (`{foreach}`), conditionals (`{if}`), and variable assignments (`{assign}`). When modernizing, consider if Smarty remains the preferred templating engine or if a more modern PHP templating system (e.g., Twig, Blade) or a client-side rendering approach would be more suitable.
*   **JavaScript Management**: `photo-slider.tpl` uses custom jQuery within a `{literal}` block for its slider functionality, while `visulate-property-details-mls.tpl` leverages the Bootstrap carousel. Consolidating or modernizing the JavaScript approach for image sliders (e.g., using a single, responsive library or moving to a pure CSS solution where feasible) could improve maintainability and performance. Externalizing JavaScript into separate files is recommended over inline `<script>` blocks within templates.
*   **AdSense Integration**: The `visulate-property-details-nomls.tpl` template embeds Google AdSense code directly. For large-scale changes or a re-platforming, consider a more centralized, configurable approach to ad serving, potentially integrating with a dedicated ad management system or using a component that dynamically loads ad units.
*   **Responsiveness**: Ensure that the layouts and image sliders are fully responsive across various device sizes. Bootstrap is used in one, but the custom jQuery slider might need separate attention for responsive behavior.
*   **Data Flow Clarity**: As these templates receive data from PHP, clearly define the expected structure and content of the Smarty variables (e.g., `$mls`, `$m.IMG`, `$data.PROPERTY`, `$report_element`) to facilitate easier debugging and future development.
