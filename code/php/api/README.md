# API Endpoints (PHP)

This directory `code/php/api` contains the PHP scripts that serve as the backend API endpoints for various data requests within the Visulate application. It handles incoming HTTP GET and POST requests, routing them to specific classes responsible for processing data related to properties, corporations, MLS listings, and voice interactions. The API primarily delivers JSON-encoded responses.

## Functional Overview

The `code/php/api` directory acts as the public-facing API layer for several core Visulate functionalities. It orchestrates database queries through a set of dedicated classes, retrieves specific data (e.g., property details, corporation information, listing data, geographical coordinates), and returns it in a structured JSON format. This separation allows other parts of the application (e.g., web frontend, mobile apps) to consume data without direct database interaction.

## Files & Component Responsibilities

| File Name                  | Description                                                                                                                                                                                                                                                                                                                                                     |
| :------------------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `AddressSearch.class.php`  | **Note: The provided sample content for this file is identical to `Property.class.php` and defines a `Property` class, not an `AddressSearch` class. This suggests a potential misnaming or duplication.** Based on its filename, this file is *intended* to handle requests related to searching for addresses, likely performing geocoding or property lookups by address. |
| `Corporation.class.php`    | Manages requests for corporation-related data. It retrieves detailed information about corporations (e.g., from Sunbiz-ID records) and can provide associated data like street view URLs.                                                                                                                                                                            |
| `Listing.class.php`        | Processes requests for Multiple Listing Service (MLS) data. It fetches listing-specific details and combines them with general property information.                                                                                                                                                                                                            |
| `Property.class.php`       | Handles requests for various property details. This includes retrieving general property information, calculating property values based on usage and property class, and generating street view URLs for a given property's coordinates.                                                                                                                         |
| `RequestHandler.php`       | This is the primary entry point for all API requests. It parses the incoming HTTP method (GET/POST) and URL parameters (`p1`, `p2`, `p3`) to determine the requested resource and action. It then instantiates the appropriate class (e.g., `Property`, `Corporation`, `Listing`, `VoiceInteraction`) and delegates the request processing to it. It also sets the `Content-Type` header to `application/json`. |
| `VoiceInteraction.class.php` | Dedicated to handling voice interaction requests. It includes functionality for geocoding addresses (converting street addresses to latitude/longitude coordinates) using external APIs (Google Maps Geocoding API and a fallback Visulate CGI script) and processes specific voice commands. |

## Database Dependencies & Interactions

The classes within this directory heavily rely on database interaction, primarily through two helper classes located in `../classes/database/`:

*   **`pr_reports.class.php` (PRReports Class)**: This class is widely used across `Property.class.php`, `Corporation.class.php`, `Listing.class.php`, and `VoiceInteraction.class.php`. It provides methods to fetch detailed information for properties, corporations, and MLS listings, and to retrieve street view URLs.
    *   Methods used: `getPropertyDetails`, `getCorpDetails`, `getMLS`, `getDefaults`, `get_streetview_url`.
    *   Likely interacts with database tables or views storing property, corporation, and listing data, as well as configuration or default values.
*   **`rnt_search.class.php` (LISTSearch Class)**: Used by `Property.class.php` to retrieve summary information related to PUMA (Public Use Microdata Area) codes.
    *   Methods used: `getPumaSummary`.
    *   Likely interacts with database tables or views containing geographical or census-related data.

All database connections are established via the `SmartyInit` class, which retrieves the connection object (`$smarty->connection`) and passes it to the database helper classes.

## Submodules / Subdirectories

This directory does not contain any subdirectories.

## Maintenance & Modernization Notes

*   **Routing Logic**: The `RequestHandler.php` uses a simple switch-case statement based on URL parameters (`p1`, `p2`, `p3`) for routing. For a more robust and scalable API, consider introducing a dedicated routing library (e.g., FastRoute, Slim) that offers more flexible route definitions, middleware support, and better request handling.
*   **Mixed Concerns**: The API classes directly `echo json_encode(...)` for responses. Separating the data retrieval/processing logic from the presentation/response serialization would improve testability and maintainability. A dedicated response builder or API gateway pattern could be beneficial.
*   **Dependency Management**: The use of `require_once dirname(__FILE__) . "/../classes/..."` is functional but can become cumbersome. Migrating to an autoloader (e.g., PSR-4 compatible) would simplify class loading.
*   **Geocoding API**: The `VoiceInteraction.class.php` contains hardcoded URLs for the Google Maps Geocoding API and a fallback Visulate CGI script. Externalizing these URLs into configuration and abstracting the geocoding logic into a dedicated service class would enhance flexibility and allow for easier swapping of geocoding providers.
*   **Error Handling**: The `raise_error(404)` calls indicate basic error handling, but a more structured approach to API error responses (e.g., consistent error codes, messages, and logging) would improve API consumer experience.
*   **`AddressSearch.class.php` Discrepancy**: The fact that `AddressSearch.class.php` contains the code for `Property.class.php` is a significant concern. This file should either be corrected to contain actual address search logic or removed if it's a redundant copy.
