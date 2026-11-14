# code/php/html

## Functional Overview

This directory contains a collection of client-side JavaScript files and one HTML file that provide interactive functionality and business logic for various modules within the Visulate application. These scripts primarily handle UI interactions, form validations, financial calculations, data management for agreements, expenses, payables, receivables, people, and suppliers, as well as general utility functions and UI responsiveness. The HTML file facilitates geolocation search.

## Files & Component Responsibilities

| File Name        | Description                                                                                                                                                                                                                                               |
| :--------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `agreement.js`   | Contains JavaScript functions related to tenant agreement management. Specifically, it validates that an agreement date is present when a tenant's status is set to "CURRENT" or "CURRENT_SECONDARY" to ensure receivable lists can be generated.             |
| `cap_calc.js`    | Provides financial calculation utilities. It includes functions to add and strip commas from numeric strings, and to compute property values, gross income, vacancy costs, and replacement reserves based on form inputs.                                     |
| `expense.js`     | Manages the logic for recurring expenses. It enables or disables the "RECURRING_PERIOD" field based on the state of a "RECURRING_YN" checkbox and validates that a recurring period is set if recurring is enabled.                                           |
| `finance.js`     | Contains logic for financial loan management, specifically validating settlement dates. It warns the user if any loan settlement date is in the future.                                                                                                     |
| `geo_search.html`| An HTML page that utilizes browser geolocation services and the Google Maps API to detect and display the user's current location, track location changes, and potentially facilitate nearby searches. Includes responsive styling for mobile devices.     |
| `main.js`        | Provides core UI interaction scripts using jQuery. It implements toggle functionality for a hamburger menu and an advanced search form, enhancing navigability and search capabilities.                                                                     |
| `payable.js`     | Implements functionality for managing accounts payable entries. It allows users to mark payments as "Paid" (setting a payment date) or "Undo" (reverting the payment date) and uses an `undoArray` to store previous states.                                 |
| `peoples.js`     | Contains JavaScript (using Mootools) for UI elements that allow expanding and collapsing sections, typically for lists of people. It dynamically changes arrow icons to indicate the state of the collapsible section.                                       |
| `receivable.js`  | Manages accounts receivable allocations. It provides functions to mark specific allocations as "Paid" (updating amount and date) and to undo these actions. It handles various states for unallocated amounts and previous allocation values.                 |
| `suppliers.js`   | Similar to `peoples.js`, this script provides expand/collapse functionality for supplier lists using Mootools, allowing users to toggle the visibility of detailed supplier information.                                                                    |
| `util.js`        | A collection of general utility JavaScript functions. This includes functions like `getElementByName` (to retrieve DOM elements by name), `helptext` (to display/hide contextual help messages on hover), and `showLov` (to open a List of Values window). |
| `zoom.js`        | Implements responsive design logic by dynamically adjusting the page zoom level based on the browser window width to ensure content remains readable and accessible on wider screens, aiming for a minimum effective width.                                  |

## Database Dependencies & Interactions

The files in this directory are client-side JavaScript and HTML, and as such, they do not directly interact with a database. Their interactions are typically with server-side PHP scripts (found elsewhere in the `code/php` hierarchy) which then handle database operations. No explicit database objects (tables, views, stored procedures) are directly referenced within these client-side scripts or indicated by the provided dependency analysis.

## Submodules / Subdirectories

There are no subdirectories within `code/php/html`.

## Maintenance & Modernization Notes

*   **Mixed Frameworks/Approaches**: The directory contains files using both MooTools (`peoples.js`, `suppliers.js`, `util.js`) and jQuery (`main.js`, `zoom.js`), alongside plain JavaScript. Modernization efforts should consider consolidating to a single, more contemporary JavaScript framework or plain ES6+ for consistency and maintainability.
*   **Direct DOM Manipulation**: Many scripts rely on direct DOM manipulation (e.g., `document.getElementsByName`, `getElementByName`). Refactoring towards a component-based architecture or using a virtual DOM approach could improve performance and development efficiency.
*   **Global Variables**: Files like `payable.js` and `receivable.js` use global variables (`undoArray`, `oldUnnalocIndex`, etc.), which can lead to namespace collisions and make code harder to reason about in larger applications. Encapsulating state within modules or classes would be beneficial.
*   **Basic Error Handling**: Error handling is often limited to `alert()` messages. Implementing more robust, user-friendly error feedback mechanisms and logging would enhance the user experience and debugging process.
*   **Legacy Code Patterns**: The use of `window.open` for List of Values (`util.js`) and older event binding patterns indicate areas where modern browser APIs and event delegation could be applied.
*   **Tight Coupling**: The scripts are often tightly coupled to specific HTML form structures (e.g., `document.formExpense.RECURRING_YN`). Changes to the HTML structure might require significant updates to the JavaScript.
*   **Google Maps API**: `geo_search.html` uses the Google Maps API, which requires careful management of API keys, usage limits, and adherence to Google's terms of service.
