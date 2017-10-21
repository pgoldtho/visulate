<?


/*************************************************************
*
*     Menu for site.
*
*************************************************************/
$global_menu_data =
   array(
      "home" =>
          array("title" => "Business",
                "href"  => "menu1.html",
                "role"  => array("OWNER",
                                 "MANAGER",
                                 "MANAGER_OWNER",
                                 "BUSINESS_OWNER",
                                 "BUYER",
                                 "BOOKKEEPING"),
                "items" => array(
                               "property_home_summary" =>
                                   array("title" => "Snapshot",
                                         "href"  => "menu1.html",
                                         "role"  => array("MANAGER",
                                                          "MANAGER_OWNER",
                                                          "BOOKKEEPING",
                                                          "OWNER",
                                                          "BUYER",
                                                          "BUSINESS_OWNER")
                                   ),
                               "property_business_units"  =>
                                   array("title" => "Business units",
                                         "href"  => "menu1.html",
                                         "role"  => array("MANAGER",
                                                          "MANAGER_OWNER",
                                                          "BOOKKEEPING",
                                                          "OWNER",
                                                          "BUYER",
                                                          "BUSINESS_OWNER")
                                   ),
                               "property_partners"  =>
                                   array("title" => "Partners",
                                         "href"  => "menu1.html",
                                         "role"  => array("MANAGER",
                                                          "MANAGER_OWNER",
                                                          "BOOKKEEPING",
                                                          "OWNER",
                                                          "BUYER",
                                                          "BUSINESS_OWNER")
                                   ),
                               "property_supplier"  =>
                                   array("title" => "Vendors",
                                         "href"  => "menu1.html",
                                         "role"  => array("MANAGER",
                                                          "MANAGER_OWNER",
                                                          "BOOKKEEPING",
                                                          "OWNER",
                                                          "BUYER",
                                                          "BUSINESS_OWNER")
                                   ),
                               "property_section8"  =>
                                   array("title" => "Section 8",
                                         "href"  => "menu1.html",
                                         "role"  => array("MANAGER",
                                                          "MANAGER_OWNER",
                                                          "BOOKKEEPING",
                                                          "OWNER",
                                                          "BUSINESS_OWNER")
                                   ),
                               "business_reports"  =>
                                   array("title" => "Reports",
                                         "href"  => "menu1.html",
                                         "role"  => array("MANAGER_OWNER",
                                                          "BUYER",
                                                          "BUSINESS_OWNER")
                                   )
                           )
          ),
      // ----  end of home menu
      "property" =>
          array("title" => "Property",
                "href"  => "menu1.html",
                "role"  => array("MANAGER",
                                 "MANAGER_OWNER",
                                 "BOOKKEEPING",
                                 "OWNER",
                                 "BUYER",
                                 "BUSINESS_OWNER"),
                "items" => array(
                               "property_sales" =>
                                   array("title" => "Sales Listing",
                                         "href"  => "menu1.html",
                                         "role"  => array("BUSINESS_OWNER")
                                   ),
                               "property_details" =>
                                   array("title" => "Property",
                                         "href"  => "menu1.html",
                                         "role"  => array("MANAGER",
                                                          "MANAGER_OWNER",
                                                          "BOOKKEEPING",
                                                          "OWNER",
                                                          "BUYER",
                                                          "BUSINESS_OWNER")
                                   ),
                               "property_estimates" =>
                                   array("title" => "Estimates",
                                         "href"  => "menu1.html",
                                         "role"  => array("MANAGER",
                                                          "MANAGER_OWNER",
                                                          "BOOKKEEPING",
                                                          "OWNER",
                                                          "BUYER",
                                                          "BUSINESS_OWNER")
                                   ),
                               "property_finance" =>
                                   array("title" => "Finance",
                                         "href"  => "menu1.html",
                                         "role"  => array("MANAGER",
                                                          "MANAGER_OWNER",
                                                          "BOOKKEEPING",
                                                          "OWNER",
                                                          "BUYER",
                                                          "BUSINESS_OWNER")
                                   ),
                               "property_expence" =>
                                   array("title" => "Expense",
                                         "href"  => "menu1.html",
                                         "role"  => array("MANAGER",
                                                          "MANAGER_OWNER",
                                                          "BOOKKEEPING",
                                                          "OWNER",
                                                          "BUYER",
                                                          "BUSINESS_OWNER")
                                   ),
                               "property_summary" =>
                                   array("title" => "Summary",
                                         "href"  => "menu1.html",
                                         "role"  => array("MANAGER",
                                                          "MANAGER_OWNER",
                                                          "BOOKKEEPING",
                                                          "OWNER",
                                                          "BUSINESS_OWNER")
                                   )
                           )
          ),
      "tenant" =>
          array("title" => "Tenant",
                "href"  => "",
                "role"  => array("MANAGER",
                                 "MANAGER_OWNER",
                                 "BOOKKEEPING",
                                 "OWNER",
                                 "BUSINESS_OWNER"),
                "items" => array(
                               "tenant_peoples"    =>
                                   array("title" => "People",
                                        "href"   => "menu1.html",
                                        "role"   => array("MANAGER",
                                                          "MANAGER_OWNER",
                                                          "BOOKKEEPING",
                                                          "OWNER",
                                                          "BUSINESS_OWNER")
                                   ),
                               "tenant_agreements" =>
                                   array("title" => "Agreements",
                                         "href"  => "menu1.html",
                                         "role"  => array("MANAGER",
                                                          "MANAGER_OWNER",
                                                          "BOOKKEEPING",
                                                          "OWNER",
                                                          "BUSINESS_OWNER")
                                   ),
                               "tenant_tenants"    =>
                                   array("title" => "Tenants",
                                        "href"   => "menu1.html",
                                        "role"   => array("MANAGER",
                                                          "MANAGER_OWNER",
                                                          "BOOKKEEPING",
                                                          "OWNER",
                                                          "BUSINESS_OWNER")
                                   ),
                               "tenant_actions"    =>
                                   array("title" => "Actions",
                                         "href"  => "menu1.html",
                                         "role"  => array("MANAGER",
                                                          "MANAGER_OWNER",
                                                          "BOOKKEEPING",
                                                          "OWNER",
                                                          "BUSINESS_OWNER")
                                   )
                           )
          ),
      "payment" =>
          array("title" => "Payment",
                "href"  => "",
                "role"  => array("MANAGER",
                                 "MANAGER_OWNER",
                                 "BOOKKEEPING",
                                 "OWNER",
                                 "BUYER",
                                 "BUSINESS_OWNER"),
                "items" => array(
                               "payment_accounts"  =>
                                   array("title" => "Accounts",
                                         "href"  => "menu1.html",
                                         "role"  => array("MANAGER",
                                                          "MANAGER_OWNER",
                                                          "BOOKKEEPING",
                                                          "OWNER",
                                                          "BUYER",
                                                          "BUSINESS_OWNER")
                                   ),
                               "payment_rules"  =>
                                   array("title" => "Rules",
                                         "href"  => "menu1.html",
                                         "role"  => array("MANAGER",
                                                          "MANAGER_OWNER",
                                                          "BOOKKEEPING",
                                                          "OWNER",
                                                          "BUYER",
                                                          "BUSINESS_OWNER")
                                   ),
                               "payment_receiveable"  =>
                                   array("title" => "Receiveable",
                                         "href"  => "menu1.html",
                                         "role"  => array("MANAGER",
                                                          "MANAGER_OWNER",
                                                          "BOOKKEEPING",
                                                          "OWNER",
                                                          "BUYER",
                                                          "BUSINESS_OWNER")
                                   ),
                               "payment_payable"   =>
                                   array("title" => "Payable",
                                         "href"  => "menu1.html",
                                         "role"  => array("MANAGER",
                                                          "MANAGER_OWNER",
                                                          "BOOKKEEPING",
                                                          "OWNER",
                                                          "BUYER",
                                                          "BUSINESS_OWNER")
                                   ),
                               "payment_journal"   =>
                                   array("title" => "Journal",
                                         "href"  => "menu1.html",
                                         "role"  => array("MANAGER",
                                                          "MANAGER_OWNER",
                                                          "BOOKKEEPING",
                                                          "OWNER",
                                                          "BUYER",
                                                          "BUSINESS_OWNER")
                                   ),
                               "payment_ledger"   =>
                                   array("title" => "Ledger",
                                         "href"  => "menu1.html",
                                         "role"  => array("MANAGER",
                                                          "MANAGER_OWNER",
                                                          "BOOKKEEPING",
                                                          "OWNER",
                                                          "BUYER",
                                                          "BUSINESS_OWNER")
                                   ),
                               "payment_reports"   =>
                                   array("title" => "Reports",
                                         "href"  => "menu1.html",
                                         "role"  => array("MANAGER",
                                                          "MANAGER_OWNER",
                                                          "BOOKKEEPING",
                                                          "OWNER",
                                                          "BUYER",
                                                          "BUSINESS_OWNER")
                                   )
                           )
          ),
      "advertise" =>
          array("title" => "Advertise",
                "href"  => "",
                "role"  => array("ADVERTISE"),
                "items" => array(
                               "property_details"  =>
                                   array("title" => "My Properties",
                                         "href"  => "menu1.html",
                                         "role"  => array("ADVERTISE")
                                   ),
                               "tenant_agreements"  =>
                                   array("title" => "Rental Agreements",
                                         "href"  => "menu1.html",
                                         "role"  => array("ADVERTISE")
                                   ),
                           )
          ),

      "admin" =>
          array("title" => "Admin",
                "href"  => "",
                "role"  => array("ADMIN"),
                "items" => array(
                               "admin_users" =>
                                   array("title" => "Users",
                                         "href"  => "menu1.html",
                                         "role"  => array("ADMIN")
                                   ),
                               "admin_assignments"  =>
                                   array("title" => "Assignments",
                                         "href"  => "menu1.html",
                                         "role"  => array("ADMIN")
                                   ),
                               "admin_business_units"  =>
                                   array("title" => "Business Units",
                                         "href"  => "menu1.html",
                                         "role"  => array("ADMIN")
                                   ),
                               "admin_messages"  =>
                                   array("title" => "Messages",
                                         "href"  => "menu1.html",
                                         "role"  => array("ADMIN")
                                   ),
                               "admin_menus"  =>
                                   array("title" => "Menus",
                                         "href"  => "menu1.html",
                                         "role"  => array("ADMIN")
                                   )
                           )
          )
   );

?>