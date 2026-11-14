# PL/SQL Packages and Procedures

This directory (`code/database/plsql`) contains a comprehensive collection of Oracle PL/SQL packages and standalone procedures that form the core business logic and data manipulation layer for the Visulate application. These scripts are responsible for handling a wide range of functionalities, from managing public records and real estate listings to orchestrating rental property management, accounting, and user interactions.

The packages are generally organized by functional area, with prefixes like `PR_` for public records, `MLS_` for Multiple Listing Service integrations, and `RNT_` for rental management operations.

## Functional Overview

The PL/SQL code within this directory provides the backend services for:

*   **Public Records & GIS Integration**: Processing and standardizing public property records, incorporating Geographic Information System (GIS) utilities for location data, and integrating with external corporate databases like Sunbiz.
*   **MLS Data Management**: Interfacing with various Multiple Listing Service (MLS) providers (e.g., Brevard, MFR, SEF) to retrieve, process, and store property listings and associated media (photos).
*   **Rental Property Management**: Implementing the full lifecycle of rental properties, including tenant management, lease agreements, property expenses, revenue tracking, detailed financial accounting (General Ledger, Accounts Payable, Accounts Receivable), and property valuation.
*   **User & System Utilities**: Managing user accounts, roles, email notifications, and providing system-level functions like checksum calculations for data integrity and password obfuscation.

## Files & Component Responsibilities

Below is a categorized list of the PL/SQL files in this directory and their primary responsibilities:

### Public Records (`PR_`) and GIS Utilities

*   **`CENTROID_Package.sql`**: A spatial utility package containing functions for geometric operations, particularly for calculating centroids and converting geometries. Crucial for GIS functionalities.
*   **`pr_geo_utils_pkg.sql`**: Provides geographic utility functions, primarily for geocoding addresses and identifying nearby corporate locations.
*   **`pr_locations_pkg.sql`**: Manages the creation, update, and retrieval of property and corporate location data within the `PR_LOCATIONS` table.
*   **`pr_prop_class_pkg.sql`**: Handles API operations for the `PR_PROP_CLASS` table, which stores property classification details.
*   **`pr_pums_pkg.sql`**: Responsible for integrating Public Use Microdata Sample (PUMS) data, including seeding data, calculating vacancy rates, and generating property and income value estimates.
*   **`pr_records_pkg.sql`**: A central package for public record management, including inserting and updating properties, owners, sales, taxes, and other related records.
*   **`pr_rets_pkg.sql`**: The primary package for interfacing with Real Estate Transaction Standard (RETS) servers, handling authentication, search queries, and data extraction for MLS listings.
*   **`pr_rets_pkg.sql.error`**: A version of the RETS package, possibly a backup or an older version with specific error handling logic.
*   **`pr_rets_pkg.sql.safe`**: Another variant of the RETS package, likely a "safe" or stable version used for particular deployments or testing.
*   **`pr_values_pkg.sql`**: Provides API for managing estimated property values and related statistics (`PR_VALUES`).
*   **`sunbiz_pkg.sql`**: Contains procedures to interact with the Florida Department of State (Sunbiz) corporate records, matching corporate entities with property owners and locations.

### Multiple Listing Service (`MLS_`) Integrations

*   **`mls_brevard_pkg.sql`**: Specific implementation for integrating and processing MLS data from the Brevard County MLS.
*   **`mls_listings_pkg.sql`**: Manages the core `MLS_LISTINGS` data, providing insert, update, and checksum functionalities for listings.
*   **`mls_mfr_pkg.sql`**: Implements the integration logic for the Florida Regional MLS (MFR).
*   **`mls_mfr_pkg_v2.sql`**: An updated version of the MFR integration package, likely incorporating enhancements or changes to the MLS API.
*   **`mls_photos_pkg.sql`**: Manages the storage and retrieval of photos associated with MLS listings (`MLS_PHOTOS`).
*   **`mls_price_ranges_pkg.sql`**: Calculates and maintains MLS price ranges based on market data, used for analytical reports and static page generation.
*   **`mls_sef_pkg.sql`**: Integration package for the South East Florida (SEF) MLS.
*   **`mls_sef_pkg2.sql`**: Another version of the SEF MLS integration.
*   **`mls_sef_pkg3.sql`**: A third version of the SEF MLS integration, indicating potential variations in data sources or ongoing development.

### Rental Management System (`RNT_`) Core Logic

*   **`rnt_acc_receivable_const_pkg.sql`**: Defines constants used within the accounts receivable module.
*   **`rnt_account_balances_pkg.sql`**: Manages the financial balances for various accounts.
*   **`rnt_account_periods_pkg.sql`**: Handles the management of accounting periods for financial reporting.
*   **`rnt_account_types_pkg.sql`**: Manages different types of accounts used in the general ledger.
*   **`rnt_accounts_payable_const_pkg.sql`**: Defines constants used within the accounts payable module.
*   **`rnt_accounts_payable_pkg.sql`**: Manages all aspects of accounts payable, including expenses, supplier payments, and associated ledger entries.
*   **`rnt_accounts_pkg.sql`**: Provides API for managing the chart of accounts for different business units.
*   **`rnt_accounts_receivable_pkg.sql`**: Manages all aspects of accounts receivable, including tenant rent, other income, and payment allocations.
*   **`rnt_agreement_actions_pkg.sql`**: Handles actions and events related to tenancy agreements (e.g., repairs, notices).
*   **`rnt_bu_suppliers_pkg.sql`**: Manages the association of suppliers with specific business units.
*   **`rnt_business_units_pkg.sql`**: Manages the definition and properties of different business units within the system.
*   **`rnt_cities_pkg.sql`**: Manages city-specific data, including geographic information.
*   **`rnt_city_media_pkg.sql`**: Manages media content associated with cities (e.g., images, descriptions).
*   **`rnt_default_accounts_pkg.sql`**: Manages a set of default accounts that can be assigned to new business units.
*   **`rnt_default_pt_rules_pkg.sql`**: Manages default payment transaction rules for ledger postings.
*   **`rnt_doc_templates_pkg.sql`**: Manages reusable document templates for various purposes (e.g., lease agreements, notices).
*   **`rnt_error_description_pkg.sql`**: Stores and retrieves descriptions for application-specific error codes.
*   **`rnt_expense_items_pkg.sql`**: Manages individual expense items associated with property expenses.
*   **`rnt_gen_periods_pkg.sql`**: A utility package for generating financial periods.
*   **`rnt_lead_actions_pkg.sql`**: Manages actions and follow-ups related to property leads.
*   **`rnt_leads_pkg.sql`**: Manages property lead information, including potential buyers/tenants and their preferences.
*   **`rnt_ledger_entries_pkg.sql`**: Manages individual entries posted to the general ledger.
*   **`rnt_ledger_pkg.sql`**: A comprehensive package for general ledger operations, including posting transactions from accounts payable/receivable.
*   **`rnt_loans_pkg.sql`**: Manages loan details associated with properties, including amortization and payment calculations.
*   **`rnt_obfurcation_password_pkg.sql`**: Provides functions for obfuscating and de-obfuscating sensitive data, like passwords.
*   **`rnt_payment_allocations_pkg.sql`**: Manages how individual payments are allocated against accounts receivable or payable items.
*   **`rnt_payments_pkg.sql`**: Manages overall payments made or received by the business units.
*   **`rnt_people_pkg.sql`**: Manages general `PEOPLE` records, serving as a base for users, tenants, and other contacts.
*   **`rnt_properties_pkg.sql`**: The central package for managing property details, including units, purchase/sale information, and links to public records data.
*   **`rnt_property_estimates_pkg.sql`**: Manages financial estimates for properties, such as monthly rent, expenses, and capital expenditures.
*   **`rnt_property_expenses_pkg.sql`**: Manages expenses specific to individual properties.
*   **`rnt_property_links_pkg.sql`**: Manages external links (e.g., to public record websites) associated with properties.
*   **`rnt_property_photos_pkg.sql`**: Manages photos specifically uploaded for properties.
*   **`rnt_property_units_pkg.sql`**: Manages individual rental units within a property.
*   **`rnt_property_value_pkg.sql`**: Manages recorded property valuation data.
*   **`rnt_pt_rules_pkg.sql`**: Manages payment transaction rules, allowing customization of ledger postings per business unit.
*   **`rnt_regions_pkg.sql`**: Manages regional geographical data.
*   **`rnt_section8_offices_pkg.sql`**: Manages information about Section 8 housing offices and their association with business units.
*   **`rnt_summary_pkg.sql`**: Provides summary functions for various financial and operational metrics, including NOI (Net Operating Income) and system alerts.
*   **`rnt_suppliers_all_pkg.sql`**: Manages a comprehensive list of all suppliers in the system.
*   **`rnt_suppliers_pkg.sql`**: Appears to be an older or specialized supplier management package; its primary interaction is with `RNT_SUPPLIERS_V`.
*   **`rnt_sys_checksum_rec_pkg.sql`**: A utility package used internally for calculating checksums of records, primarily for optimistic locking in `*_PKG` update procedures.
*   **`rnt_tenancy_agreement_pkg.sql`**: Manages the details and lifecycle of tenancy agreements.
*   **`rnt_tenant_pkg.sql`**: Manages tenant-specific data, including status, deposit balances, and Section 8 details.
*   **`rnt_user_assignments_pkg.sql`**: Manages the assignment of users to specific roles and business units.
*   **`rnt_user_mail_pkg.sql`**: Handles the generation and sending of various automated emails to users (e.g., welcome, password reset).
*   **`rnt_users_pkg.sql`**: Manages user accounts, authentication, password changes, and active status.

### Standalone Procedures and Miscellaneous

*   **`afiedt.buf`**: This is a temporary SQL*Plus buffer file. It typically contains the last executed SQL or PL/SQL command and should generally not be committed to version control.
*   **`send_mail.sql`**: A standalone procedure that utilizes `UTL_SMTP` to send emails from the database.

## Database Dependencies & Interactions

The PL/SQL packages in this directory heavily interact with a large set of tables and views within the Oracle database. Key interactions include:

*   **Public Records (`PR_` objects)**:
    *   **`PR_PROPERTIES`**: Central table for property details, frequently accessed and updated by `PR_RECORDS_PKG`, `MLS_BREVARD_PKG`, `MLS_MFR_PKG` (and its variants), `MLS_SEF_PKG` (and its variants), `PR_PUMS_PKG`, `RNT_PROPERTIES_PKG`, and `SUNBIZ_PKG`.
    *   **`PR_LOCATIONS`**: Stores address and geospatial data, used by `PR_GEO_UTILS_PKG`, `PR_LOCATIONS_PKG`, and `SUNBIZ_PKG`.
    *   **`PR_OWNERS` / `PR_PROPERTY_OWNERS`**: Manage property ownership details, updated by `PR_RECORDS_PKG` and `SUNBIZ_PKG`.
    *   **`PR_TAXES` / `ASC_TAX_VALUES`**: Store tax assessment data, used by `PR_PUMS_PKG` and `PR_RECORDS_PKG`.
    *   **`PR_VALUES` / `PR_PUMS_VALUES`**: Store estimated property values and PUMS-derived values, used by `PR_PUMS_PKG` and `PR_VALUES_PKG`.
    *   **`PR_CORPORATIONS` / `PR_CORPORATE_LOCATIONS` / `PR_CORPORATE_POSITIONS`**: Store corporate entity data, primarily manipulated by `SUNBIZ_PKG` and `PR_LOCATIONS_PKG`.
    *   **`PR_PROPERTY_USAGE` / `PR_USAGE_CODES`**: Define and assign property usage types, used by `PR_RECORDS_PKG` and `RNT_PROPERTIES_PKG`.

*   **MLS Data (`MLS_` objects)**:
    *   **`MLS_LISTINGS`**: Stores active MLS listings, extensively updated by `MLS_BREVARD_PKG`, `MLS_MFR_PKG` (and its variants), `MLS_SEF_PKG` (and its variants), `PR_RETS_PKG` (and its variants), and queried by `MLS_LISTINGS_PKG` and `MLS_PRICE_RANGES_PKG`.
    *   **`MLS_PHOTOS`**: Stores URLs and descriptions for MLS photos, updated by `MLS_BREVARD_PKG`, `MLS_MFR_PKG` (and its variants), `MLS_SEF_PKG` (and its variants), `MLS_PHOTOS_PKG`, and `PR_RETS_PKG` (and its variants).
    *   **`MLS_RETS_RESPONSES`**: Stores raw RETS responses for debugging/auditing, used by `MLS_BREVARD_PKG`, `MLS_SEF_PKG` (and its variants).
    *   **`MLS_LISTINGS_ARCHIVE` / `MLS_PHOTOS_ARCHIVE`**: Historical storage for MLS data, used by `PR_RETS_PKG.sql.error` and `PR_RETS_PKG.sql.safe`.
    *   **`MLS_PRICE_RANGES`**: Stores aggregated price range data for market analysis, updated by `MLS_PRICE_RANGES_PKG`.

*   **Rental Management (`RNT_` objects)**:
    *   **`RNT_PROPERTIES`**: Central table for properties managed by the rental system, linked to `PR_PROPERTIES`. It is frequently accessed and updated by many `RNT_` packages, including `RNT_PROPERTIES_PKG`, `RNT_ACCOUNTS_PAYABLE_PKG`, `RNT_ACCOUNTS_RECEIVABLE_PKG`, `RNT_LEDGER_PKG`, and `RNT_SUMMARY_PKG`.
    *   **`RNT_BUSINESS_UNITS`**: Defines organizational units, crucial for multi-entity management. Used by `RNT_BUSINESS_UNITS_PKG`, `RNT_LEDGER_PKG`, `RNT_PROPERTIES_PKG`, `RNT_USERS_PKG`, and many others.
    *   **`RNT_TENANCY_AGREEMENT`**: Manages lease details, updated by `RNT_TENANCY_AGREEMENT_PKG`, `RNT_ACCOUNTS_RECEIVABLE_PKG`, `RNT_PROPERTY_UNITS_PKG`, `RNT_PROPERTY_ESTIMATES_PKG`, and `RNT_SUMMARY_PKG`.
    *   **`RNT_TENANT`**: Stores tenant-specific information, managed by `RNT_TENANT_PKG`, `RNT_ACCOUNTS_RECEIVABLE_PKG`, `RNT_AGREEMENT_ACTIONS_PKG`, `RNT_PEOPLE_PKG`, `RNT_PROPERTY_UNITS_PKG`, and `RNT_SECTION8_OFFICES_PKG`.
    *   **`RNT_ACCOUNTS` / `RNT_ACCOUNT_TYPES` / `RNT_ACCOUNT_PERIODS` / `RNT_DEFAULT_ACCOUNTS`**: Foundation for the general ledger, managed by `RNT_ACCOUNTS_PKG`, `RNT_ACCOUNT_TYPES_PKG`, `RNT_ACCOUNT_PERIODS_PKG`, `RNT_DEFAULT_ACCOUNTS_PKG`, and orchestrated by `RNT_LEDGER_PKG`.
    *   **`RNT_ACCOUNTS_RECEIVABLE` / `RNT_ACCOUNTS_PAYABLE` / `RNT_PAYMENTS` / `RNT_PAYMENT_ALLOCATIONS` / `RNT_LEDGER_ENTRIES`**: Core accounting transaction tables. Managed by their respective `*_PKG` packages and integrated by `RNT_LEDGER_PKG` and `RNT_SUMMARY_PKG`.
    *   **`RNT_PROPERTY_UNITS`**: Manages individual rental units within properties, used by `RNT_PROPERTY_UNITS_PKG`, `RNT_PROPERTIES_PKG`, `RNT_PROPERTY_ESTIMATES_PKG`, `RNT_SUMMARY_PKG`.
    *   **`RNT_LOANS`**: Manages loan records linked to properties, used by `RNT_LOANS_PKG`, `RNT_LEDGER_PKG`, `RNT_ACCOUNTS_RECEIVABLE_PKG`, `RNT_ACCOUNTS_PAYABLE_PKG`, and `RNT_PROPERTY_EXPENSES_PKG`.
    *   **`RNT_USERS` / `RNT_USER_ASSIGNMENTS` / `RNT_USER_REGISTRY`**: Handle user management, authentication, and permissions. Managed by `RNT_USERS_PKG`, `RNT_USER_ASSIGNMENTS_PKG`, `RNT_BUSINESS_UNITS_PKG`, and `RNT_USER_MAIL_PKG`.
    *   **`RNT_SUPPLIERS_ALL` / `RNT_BU_SUPPLIERS`**: Manage supplier data, used by `RNT_SUPPLIERS_ALL_PKG`, `RNT_BU_SUPPLIERS_PKG`, and `RNT_PROPERTIES_PKG`.

## Submodules / Subdirectories

This directory does not contain any subdirectories.

## Maintenance & Modernization Notes

1.  **Versioned Files**: The presence of multiple versions of certain packages (e.g., `mls_mfr_pkg.sql` vs. `mls_mfr_pkg_v2.sql`, `mls_sef_pkg.sql`, `mls_sef_pkg2.sql`, `mls_sef_pkg3.sql`, and `pr_rets_pkg.sql` with `.error`/`.safe` suffixes) indicates potential historical evolution, experimental changes, or different implementations for various MLS sources. It's crucial to understand which version is active in production and why older versions are retained. Clean-up or clear documentation on their purpose is recommended.
2.  **`afiedt.buf`**: This file is a SQL*Plus scratchpad and typically should not be part of a version-controlled codebase. It might contain sensitive information or temporary test queries. It should be removed from the repository.
3.  **Code Ownership/AuthID**: `CENTROID_Package.sql` uses `AUTHID CURRENT_USER`. This means the package runs with the privileges of the invoking user, not the package owner. While useful for specific security models, it requires careful management of grants to calling schemas and can complicate privilege auditing.
4.  **Database Mail (`send_mail.sql`)**: The `send_mail` procedure uses `UTL_SMTP` for sending emails. This requires proper configuration of SMTP server details within the Oracle database environment (e.g., ACLs for network access). Any changes or updates to email functionality should consider this dependency.
5.  **Password Obfuscation (`rnt_obfurcation_password_pkg.sql`)**: A custom password obfuscation package is present. While functional, it's essential to ensure that the cryptographic methods used are up-to-date with current security best practices to prevent vulnerabilities. Modern Oracle versions offer built-in encryption functions that might be more robust.
6.  **Modular but Coupled**: The extensive use of PL/SQL packages creates a highly modular backend. However, the numerous dependencies between packages (e.g., `RNT_LEDGER_PKG` interacting with many `RNT_` accounting packages, `PR_RECORDS_PKG` interacting with various `PR_` tables) suggest a tightly coupled architecture. Refactoring efforts should carefully consider these interdependencies to avoid ripple effects.
7.  **`set define` commands**: Many scripts include `set define ~` or `set define ^`. These are SQL*Plus/SQLcl client commands to change the substitution variable prefix. While harmless, they indicate a development environment reliance that might not be standard across all deployment/scripting tools.
