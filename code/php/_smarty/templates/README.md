# Smarty Templates

This directory, `code/php/_smarty/templates`, serves as the central repository for all [Smarty](https://www.smarty.net/) template files used by the Visulate PHP application. Smarty is a templating engine that facilitates the separation of presentation (HTML/CSS/JavaScript) from application logic (PHP). These templates are responsible for rendering the entire user interface, including public-facing web pages, mobile views, administrative interfaces, and various data feeds.

## Functional Overview

The primary function of this directory is to define the visual structure and content layout for all pages and components within the Visulate application. It encapsulates the HTML, CSS, and client-side JavaScript necessary to display data prepared by the backend PHP scripts. The templates ensure a consistent look and feel across different parts of the application and handle responsive design for various devices. They range from simple includes for headers and footers to complex forms and data visualizations for property listings, financial reports, and administrative tasks.

## Files & Component Responsibilities

The files within this directory can be broadly categorized by their function:

*   **Core Layout & Utilities**:
    *   `top.tpl`, `header.tpl`, `footer.tpl`, `simple_header.tpl`, `simple_footer.tpl`: Define the overarching page structure, including common HTML boilerplate, navigation, and footers.
    *   `left.tpl`: Renders the left-hand navigation or sidebar menus.
    *   `Exception.tpl`, `errorLong.tpl`: Handle the display of application errors and exceptions.
    *   `google-analytics.tpl`, `adsense-mobile320x100.tpl`, `adsense-mobile320x50.tpl`: Integrate third-party services like Google Analytics and AdSense.
    *   `google-map.tpl`: Renders Google Maps components.
    *   `jqm-menu.tpl`: Defines a jQuery Mobile menu structure.
    *   `letterbox-img.tpl`: Creates a dynamic banner image section, often used for welcome/landing pages.
    *   `social-media-icons.tpl`, `social-media-icons-mobile.tpl`, `social-media-icons-mobile-sharme.tpl`: Embed social media sharing functionality.
    *   `homeTop.tpl`: A specialized header for the main website, including meta tags for SEO and schema.org markup.
    *   `visulate-submenu.tpl`: Renders sub-navigation tabs for various sections.

*   **Authentication & User Management**:
    *   `login.tpl`, `login2.tpl`, `loginTop.tpl`: Templates for user authentication forms and role selection.
    *   `register.tpl`: Handles user registration, including sign-up forms and promotional content.
    *   `recover.tpl`, `recover_success.tpl`, `pref.tpl`: Templates for password recovery and user preference (e.g., change password) pages.

*   **Public-Facing Property Listings & Details (Visulate)**:
    *   `visulate-listings.tpl`, `visulate-property-list.tpl`, `mobile-listings.tpl`, `mobile-property-list.tpl`: Display lists of properties, often with search and filter options.
    *   `visulate-property-details.tpl`, `visulate-property-details-main.tpl`, `visulate-property-details-cashflow.tpl`, `visulate-property-details-location.tpl`, `visulate-property-details-top.tpl`, `mobile-property-details.tpl`, `mobile-property-details-main.tpl`, `mobile-property-details-cashflow.tpl`, `mobile-property-details-cashflow.safe.tpl`: Provide detailed views for individual properties, including financial estimates, maps, photos, and core information.
    *   `visulate_search.tpl`, `mobile_search.tpl`, `search_form.tpl`, `search_form_mobile.tpl`: Implement property search interfaces.
    *   `visulate-welcome.tpl`, `mobile-welcome.tpl`: Welcome messages and contact forms.
    *   `visulate_city.tpl`, `mobile_city.tpl`: Display city-specific real estate market data.
    *   `florida-appraiser.tpl`: Provides links to Florida county property appraiser and clerk of courts websites.
    *   `pums-graph.tpl`, `pums-mobile.tpl`: Visualize household income and rent data from PUMS estimates.
    *   `visulate-commercial.tpl`, `visulate-commercial-class.tpl`, `visulate-commercial-year.tpl`, `visulate-land.tpl`, `visulate-land-year.tpl`, `visulate-month-details.tpl`, `visulate-sales-details.tpl`, `visulate-year-details.tpl`, `visulate-agent-zipcode.tpl`: Specialized templates for displaying commercial, land, and general sales data, broken down by year, class, or zipcode.

*   **Mobile-Specific Views**:
    *   A large collection of templates prefixed with `mobile-` (e.g., `mobile-top.tpl`, `mobile-footer.tpl`, `mobile-ajax-listings.tpl`, `mobile-calc.tpl`, `mobile-login.tpl`, `mobile-expence.tpl`, `mobile-tenant_tenants.tpl`). These are optimized for mobile display, often using jQuery Mobile components.

*   **Administrative & Internal Management Pages**:
    *   `page-admin_assignments.tpl`, `page-admin_business_units.tpl`, `page-admin_menus.tpl`, `page-admin_messages.tpl`, `page-admin_users.tpl`: Templates for the administration panel, allowing management of user roles, business units, menus, system messages, and user accounts.
    *   `page-dbcontent.tpl`: Used for managing general database content, likely for dynamic web pages.

*   **Financial & Business Unit Management**:
    *   `page-business_reports.tpl`, `page-payment_reports.tpl`: Generic templates for rendering various business and financial reports.
    *   `page-payment_accounts.tpl`: Manages chart of accounts for business units.
    *   `page-payment_journal.tpl`, `page-payment_ledger.tpl`: Display and manage journal entries and the general ledger.
    *   `page-payment_payable.tpl`, `page-payment_receiveable.tpl`: Manage accounts payable and receivable.
    *   `page-payment_rules.tpl`: Configures payment rules and accounting logic.
    *   `page-property_business_units.tpl`: Manages the hierarchy and details of business units related to properties.
    *   `page-property_estimates.tpl`, `page-property_expence.tpl`, `page-property_finance.tpl`: Detailed views for property financial estimates, expenses, and finance history.
    *   `page-property_home_summary*.tpl`: Provides various summary views for property portfolios, including cash flow, estimates, performance, and status.
    *   `page-property_sales.tpl`: Manages property sales data.
    *   `page-property_summary.tpl`: Presents a summary of property financials and status.
    *   `page-property_partners-partner.tpl`, `page-property_partners-search.tpl`: Manage property partners and search for new ones.
    *   `page-property_section8-search.tpl`, `page-property_section8-section8.tpl`: Manage Section 8 housing program details and search for relevant offices.
    *   `page-property_supplier-search.tpl`, `page-property_supplier-supplier.tpl`: Manage suppliers (vendors) and search for them.

*   **Tenant Management**:
    *   `addTenantExpense.tpl`: Form for quickly adding tenant-related expenses.
    *   `page-tenant_actions.tpl`: Manages actions related to tenants (e.g., maintenance requests, notices).
    *   `page-tenant_agreements.tpl`, `page-tenant_agreements-advertise.tpl`, `mobile_agreement.tpl`, `visulate_agreement.tpl`: Manage tenant lease agreements and advertising.
    *   `page-tenant_peoples-people.tpl`, `page-tenant_peoples-search.tpl`: Manage tenant profiles and search for people.
    *   `page-tenant_tenants.tpl`, `mobile-tenant_tenants.tpl`: Displays tenant details and payment information.
    *   `mobile-tenant-contact.tpl`: Mobile view for tenant contact information.

*   **Feeds & APIs**:
    *   `atom-footer.tpl`, `atom-gmaps-header.tpl`, `atom-header.tpl`, `rss-footer.tpl`, `rss-header.tpl`, `rss-ymaps-header.tpl`, `sitemap.tpl`: Generate various RSS/Atom feeds and XML sitemaps for content syndication and search engine indexing.
    *   `visulate-listing-feed.tpl`, `visulate-rental-feed.tpl`, `visulate-geo-feed.tpl`, `visulate-gmap-feed.tpl`: Specialized templates for generating specific data feeds (e.g., property listings for Google Merchant Center, geographic data).
    *   `json-property-details.tpl`: Outputs property details in JSON format, likely for AJAX or API consumption.

*   **Corporation & Owner Details**:
    *   `visulate-corp-details.tpl`, `mobile-corp-details.tpl`: Display detailed information about corporations registered in Florida.
    *   `visulate-owner-details.tpl`, `mobile-owner-details.tpl`: Show details related to property owners and their portfolios.

## Database Dependencies & Interactions

The Smarty templates in this directory do not *directly* interact with the database. As a templating layer, their role is purely for presentation. All data displayed in these templates is passed to them by the calling PHP scripts. Therefore, any database dependencies (tables, views, stored procedures, etc.) are managed within the PHP business logic layer (`code/php/` or other related directories) which prepares the data before assigning it to Smarty variables for rendering.

For instance, a template like `visulate-property-details.tpl` might display property information (address, price, etc.), but the actual fetching of this data from tables like `properties`, `photos`, or `mls_listings` is handled by the PHP script that renders this template.

## Submodules / Subdirectories

This directory contains the following subdirectories:

*   **`include`**: This directory contains Smarty template files responsible for rendering various aspects of property details, including photo sliders and differentiated layouts for MLS and non-MLS listings, acting as presentation-layer components that receive data from calling PHP scripts.
*   **`reports`**: This directory contains Smarty template files responsible for rendering a wide array of financial, property, and general ledger reports within the Visulate application, designed for both web display and PDF generation.

## Maintenance & Modernization Notes

*   **Consistency and Duplication**: The large number of templates, especially `mobile-` and `page-` prefixed ones, suggests potential for duplicated HTML structures, CSS rules, and JavaScript logic. A modernization effort could involve consolidating common UI patterns into reusable Smarty functions or blocks, or adopting a more component-based frontend framework to reduce redundancy and improve maintainability.
*   **Responsive Design**: The coexistence of desktop-oriented (`header.tpl`, `footer.tpl`) and mobile-specific (`mobile-top.tpl`, `mobile-footer.tpl`) templates indicates that the application might not be fully leveraging modern responsive design techniques, potentially leading to more maintenance overhead. Transitioning to a single, fully responsive template architecture could streamline development.
*   **JavaScript Management**: The samples show a mix of embedded `<script>` blocks and external JavaScript files (jQuery, Mootools, custom `cap_calc.js`, `expense.js`). Consolidating and modernizing JavaScript, potentially using a module bundler, would improve performance and maintainability.
*   **Hardcoded Values**: Templates should be checked for hardcoded URLs, configuration values, or static text that should ideally be dynamic variables passed from PHP or defined in Smarty configuration files (`default.conf`).
*   **Template Logic**: While Smarty is designed for presentation logic, complex conditional logic or data manipulation within `.tpl` files should be reviewed. Such logic is better placed in PHP scripts or Smarty plugins to maintain a clean separation of concerns and simplify testing.
*   **Security**: Ensure proper escaping (`|escape:'html'`) is consistently applied to all user-generated or external data displayed in templates to prevent XSS vulnerabilities.
