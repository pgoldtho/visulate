declare

  X_MANAGER        CONSTANT number := 1;
  X_OWNER          CONSTANT number := 2;
  X_ADMIN          CONSTANT number := 3;
  X_MANAGER_OWNER  CONSTANT number := 4;
  X_BUSINESS_OWNER CONSTANT NUMBER := 5;
  X_BOOKKEEPING    CONSTANT NUMBER := 6;
  X_ADVERTISE      CONSTANT number := 7;
  X_BUYER          CONSTANT number := 8;
  X_PUBLIC         CONSTANT number := 9;

  v_tab_id         rnt_menu_tabs.tab_name%type;

begin

 insert into rnt_user_roles(role_id, role_code, role_name)
 values (X_PUBLIC, 'PUBLIC', 'Public');

 v_tab_id := 'pc';
  rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'PC Screens'
                     , X_PARENT_TAB  => ''
                     , X_DISPLAY_SEQ => 0
                     , X_TAB_HREF    => 'index.php');

  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_MANAGER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_ADMIN);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_MANAGER_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BUSINESS_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BOOKKEEPING);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BUYER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_ADVERTISE);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_PUBLIC);


 v_tab_id := 'mobi';
  rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'Mobile Screens'
                     , X_PARENT_TAB  => ''
                     , X_DISPLAY_SEQ => 0
                     , X_TAB_HREF    => 'index.php');

  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_MANAGER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_ADMIN);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_MANAGER_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BUSINESS_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BOOKKEEPING);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BUYER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_ADVERTISE);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_PUBLIC);



 v_tab_id  := 'public';
  rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'Home'
                     , X_PARENT_TAB  => 'pc'
                     , X_DISPLAY_SEQ => 1
                     , X_TAB_HREF    => 'config_menu.php');

  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_MANAGER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_ADMIN);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_MANAGER_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BUSINESS_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BOOKKEEPING);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BUYER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_ADVERTISE);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_PUBLIC);

 v_tab_id  := 'find';
  rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'Find'
                     , X_PARENT_TAB  => 'public'
                     , X_DISPLAY_SEQ => 1.1
                     , X_TAB_HREF    => 'dbcontent.php');

  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_MANAGER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_ADMIN);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_MANAGER_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BUSINESS_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BOOKKEEPING);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BUYER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_ADVERTISE);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_PUBLIC);

 v_tab_id  := 'investment';
  rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'Investment'
                     , X_PARENT_TAB  => 'public'
                     , X_DISPLAY_SEQ => 1.2
                     , X_TAB_HREF    => 'dbcontent.php');

  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_MANAGER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_ADMIN);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_MANAGER_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BUSINESS_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BOOKKEEPING);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BUYER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_ADVERTISE);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_PUBLIC);

  v_tab_id  := 'management';
  rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'Management'
                     , X_PARENT_TAB  => 'public'
                     , X_DISPLAY_SEQ => 1.3
                     , X_TAB_HREF    => 'dbcontent.php');

  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_MANAGER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_ADMIN);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_MANAGER_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BUSINESS_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BOOKKEEPING);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BUYER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_ADVERTISE);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_PUBLIC);


  v_tab_id  := 'software';
  rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'Software'
                     , X_PARENT_TAB  => 'public'
                     , X_DISPLAY_SEQ => 1.4
                     , X_TAB_HREF    => 'dbcontent.php');

  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_MANAGER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_ADMIN);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_MANAGER_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BUSINESS_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BOOKKEEPING);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BUYER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_ADVERTISE);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_PUBLIC);



----------------------------------------------------------------
  v_tab_id  := 'home';
  rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'Business'
                     , X_PARENT_TAB  => 'pc'
                     , X_DISPLAY_SEQ => 2
                     , X_TAB_HREF    => 'config_menu.php');

  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_MANAGER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_MANAGER_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BUSINESS_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BOOKKEEPING);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BUYER);

  v_tab_id  := 'property_home_summary';
  rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'Snapshot'
                     , X_PARENT_TAB  => 'home'
                     , X_DISPLAY_SEQ => 2.1
                     , X_TAB_HREF    => 'property_home_summary.php');

  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_MANAGER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_MANAGER_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BUSINESS_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BOOKKEEPING);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BUYER);

  v_tab_id := 'property_business_units';
  rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'Business Units'
                     , X_PARENT_TAB  => 'home'
                     , X_DISPLAY_SEQ => 2.2
                     , X_TAB_HREF    => 'property_business_units.php');

  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_MANAGER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_MANAGER_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BUSINESS_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BOOKKEEPING);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BUYER);

  v_tab_id := 'property_partners';
  rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'Partners'
                     , X_PARENT_TAB  => 'home'
                     , X_DISPLAY_SEQ => 2.3
                     , X_TAB_HREF    => 'property_partners.php');

  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_MANAGER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_MANAGER_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BUSINESS_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BOOKKEEPING);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BUYER);

  v_tab_id := 'property_supplier';
  rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'Vendors'
                     , X_PARENT_TAB  => 'home'
                     , X_DISPLAY_SEQ => 2.4
                     , X_TAB_HREF    => 'property_supplier.php');

  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_MANAGER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_MANAGER_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BUSINESS_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BOOKKEEPING);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BUYER);

  v_tab_id := 'property_section8';
  rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'Section 8'
                     , X_PARENT_TAB  => 'home'
                     , X_DISPLAY_SEQ => 2.5
                     , X_TAB_HREF    => 'property_section8.php');

  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_MANAGER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_MANAGER_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BUSINESS_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BOOKKEEPING);

  v_tab_id := 'business_reports';
  rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'Reports'
                     , X_PARENT_TAB  => 'home'
                     , X_DISPLAY_SEQ => 2.6
                     , X_TAB_HREF    => 'business_reports.php');

  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_MANAGER_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BUSINESS_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BUYER);


---------------------------------------------------------------
  v_tab_id := 'property';
  rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'Property'
                     , X_PARENT_TAB  => 'pc'
                     , X_DISPLAY_SEQ => 3
                     , X_TAB_HREF    => 'config_menu.php');

  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_MANAGER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_MANAGER_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BUSINESS_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BOOKKEEPING);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BUYER);

  v_tab_id := 'property_sales';
  rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'Sales Listings'
                     , X_PARENT_TAB  => 'property'
                     , X_DISPLAY_SEQ => 3.1
                     , X_TAB_HREF    => 'property_sales.php');

  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BUSINESS_OWNER);

  v_tab_id := 'property_details';
  rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'Property'
                     , X_PARENT_TAB  => 'property'
                     , X_DISPLAY_SEQ => 3.2
                     , X_TAB_HREF    => 'property_details.php');

  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_MANAGER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_MANAGER_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BUSINESS_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BOOKKEEPING);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BUYER);

  v_tab_id := 'property_estimates';
  rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'Estimates'
                     , X_PARENT_TAB  => 'property'
                     , X_DISPLAY_SEQ => 3.3
                     , X_TAB_HREF    => 'property_estimates.php');

  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_MANAGER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_MANAGER_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BUSINESS_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BOOKKEEPING);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BUYER);

  v_tab_id := 'property_finance';
  rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'Finance'
                     , X_PARENT_TAB  => 'property'
                     , X_DISPLAY_SEQ => 3.4
                     , X_TAB_HREF    => 'property_finance.php');

  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_MANAGER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_MANAGER_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BUSINESS_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BOOKKEEPING);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BUYER);

  v_tab_id := 'property_expense';
  rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'Expense'
                     , X_PARENT_TAB  => 'property'
                     , X_DISPLAY_SEQ => 3.5
                     , X_TAB_HREF    => 'property_expence.php');

  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_MANAGER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_MANAGER_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BUSINESS_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BOOKKEEPING);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BUYER);

  v_tab_id := 'property_summary';
  rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'Summary'
                     , X_PARENT_TAB  => 'property'
                     , X_DISPLAY_SEQ => 3.6
                     , X_TAB_HREF    => 'property_summary.php');

  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_MANAGER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_MANAGER_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BUSINESS_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BOOKKEEPING);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BUYER);


--------------------------------------------------------
  v_tab_id := 'tenant';
  rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'Tenant'
                     , X_PARENT_TAB  => 'pc'
                     , X_DISPLAY_SEQ => 4
                     , X_TAB_HREF    => 'config_menu.php');

  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_MANAGER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_MANAGER_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BUSINESS_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BOOKKEEPING);
 
  v_tab_id := 'tenant_peoples';
  rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'People'
                     , X_PARENT_TAB  => 'tenant'
                     , X_DISPLAY_SEQ => 4.1
                     , X_TAB_HREF    => 'tenant_peoples.php');

  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_MANAGER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_MANAGER_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BUSINESS_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BOOKKEEPING);

  v_tab_id := 'tenant_agreements';
  rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'Agreements'
                     , X_PARENT_TAB  => 'tenant'
                     , X_DISPLAY_SEQ => 4.2
                     , X_TAB_HREF    => 'tenant_agreements.php');

  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_MANAGER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_MANAGER_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BUSINESS_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BOOKKEEPING);

  v_tab_id := 'tenant_tenants';
  rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'Tenants'
                     , X_PARENT_TAB  => 'tenant'
                     , X_DISPLAY_SEQ => 4.3
                     , X_TAB_HREF    => 'tenant_tenants.php');

  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_MANAGER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_MANAGER_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BUSINESS_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BOOKKEEPING);

  v_tab_id := 'tenant_actions';
  rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'Actions'
                     , X_PARENT_TAB  => 'tenant'
                     , X_DISPLAY_SEQ => 4.4
                     , X_TAB_HREF    => 'tenant_actions.php');

  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_MANAGER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_MANAGER_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BUSINESS_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BOOKKEEPING);




-----------------------------------------------------------
  v_tab_id := 'payment';
  rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'Payment'
                     , X_PARENT_TAB  => 'pc'
                     , X_DISPLAY_SEQ => 5
                     , X_TAB_HREF    => 'config_menu.php');

  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_MANAGER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_MANAGER_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BUSINESS_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BOOKKEEPING);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BUYER);

  v_tab_id := 'payment_accounts';
  rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'Accounts'
                     , X_PARENT_TAB  => 'payment'
                     , X_DISPLAY_SEQ => 5.1
                     , X_TAB_HREF    => 'payment_accounts.php');

  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_MANAGER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_MANAGER_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BUSINESS_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BOOKKEEPING);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BUYER);

  v_tab_id := 'payment_rules';
  rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'Rules'
                     , X_PARENT_TAB  => 'payment'
                     , X_DISPLAY_SEQ => 5.2
                     , X_TAB_HREF    => 'payment_rules.php');

  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_MANAGER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_MANAGER_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BUSINESS_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BOOKKEEPING);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BUYER);

  v_tab_id := 'payment_receiveable';
  rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'Receiveable'
                     , X_PARENT_TAB  => 'payment'
                     , X_DISPLAY_SEQ => 5.3
                     , X_TAB_HREF    => 'payment_receiveable.php');

  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_MANAGER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_MANAGER_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BUSINESS_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BOOKKEEPING);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BUYER);

  v_tab_id := 'payment_payable';
  rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'Payable'
                     , X_PARENT_TAB  => 'payment'
                     , X_DISPLAY_SEQ => 5.4
                     , X_TAB_HREF    => 'payment_payable.php');

  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_MANAGER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_MANAGER_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BUSINESS_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BOOKKEEPING);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BUYER);

  v_tab_id := 'payment_journal';
  rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'Journal'
                     , X_PARENT_TAB  => 'payment'
                     , X_DISPLAY_SEQ => 5.5
                     , X_TAB_HREF    => 'payment_journal.php');

  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_MANAGER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_MANAGER_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BUSINESS_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BOOKKEEPING);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BUYER);

  v_tab_id := 'payment_ledger';
  rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'Ledger'
                     , X_PARENT_TAB  => 'payment'
                     , X_DISPLAY_SEQ => 5.6
                     , X_TAB_HREF    => 'payment_ledger.php');

  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_MANAGER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_MANAGER_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BUSINESS_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BOOKKEEPING);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BUYER);

  v_tab_id := 'payment_reports';
  rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'Reports'
                     , X_PARENT_TAB  => 'payment'
                     , X_DISPLAY_SEQ => 5.7
                     , X_TAB_HREF    => 'payment_reports.php');

  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_MANAGER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_MANAGER_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BUSINESS_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BOOKKEEPING);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_BUYER);

  v_tab_id := 'advertise';
  rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'Advertise'
                     , X_PARENT_TAB  => 'pc'
                     , X_DISPLAY_SEQ => 6
                     , X_TAB_HREF    => 'config_menu.php');

  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_ADVERTISE);

  v_tab_id := 'ad_property_details';
  rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'My Properties'
                     , X_PARENT_TAB  => 'advertise'
                     , X_DISPLAY_SEQ => 6.1
                     , X_TAB_HREF    => 'property_details.php');

  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_ADVERTISE);

  v_tab_id := 'ad_tenancy_agreements';
  rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'Vacancies'
                     , X_PARENT_TAB  => 'advertise'
                     , X_DISPLAY_SEQ => 6.2
                     , X_TAB_HREF    => 'tenant_agreements.php');

  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_ADVERTISE);

  ---------------------------------------------------------------------------------

  v_tab_id := 'admin';
  rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'Admin'
                     , X_PARENT_TAB  => 'pc'
                     , X_DISPLAY_SEQ => 7
                     , X_TAB_HREF    => 'config_menu.php');

  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_ADMIN);

  v_tab_id := 'admin_users';
  rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'Users'
                     , X_PARENT_TAB  => 'admin'
                     , X_DISPLAY_SEQ => 7.1
                     , X_TAB_HREF    => 'admin_users.php');

  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_ADMIN);

  v_tab_id := 'admin_assignments';
  rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'Assignments'
                     , X_PARENT_TAB  => 'admin'
                     , X_DISPLAY_SEQ => 7.2
                     , X_TAB_HREF    => 'admin_assignments.php');

  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_ADMIN);

  v_tab_id := 'admin_business_units';
  rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'Business Units'
                     , X_PARENT_TAB  => 'admin'
                     , X_DISPLAY_SEQ => 7.3
                     , X_TAB_HREF    => 'admin_business_units.php');

  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_ADMIN);

  v_tab_id := 'admin_messages';
  rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'Messages'
                     , X_PARENT_TAB  => 'admin'
                     , X_DISPLAY_SEQ => 7.4
                     , X_TAB_HREF    => 'admin_messages.php');

  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_ADMIN);

  v_tab_id := 'admin_menus';
  rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'Menus'
                     , X_PARENT_TAB  => 'admin'
                     , X_DISPLAY_SEQ => 7.4
                     , X_TAB_HREF    => 'admin_menus.php');

  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id 
                     , X_ROLE_ID  => X_ADMIN);


 ------------------------------------------------------------------
 v_tab_id  := 'm_public';
 rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'Home'
                     , X_PARENT_TAB  => 'mobi'
                     , X_DISPLAY_SEQ => 1
                     , X_TAB_HREF    => 'config_menu.php');

  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_MANAGER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_ADMIN);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_MANAGER_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BUSINESS_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BOOKKEEPING);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BUYER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_ADVERTISE);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_PUBLIC);

 v_tab_id  := 'm_find';
 rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'Find'
                     , X_PARENT_TAB  => 'm_public'
                     , X_DISPLAY_SEQ => 1.1
                     , X_TAB_HREF    => 'dbcontent.php');

  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_MANAGER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_ADMIN);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_MANAGER_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BUSINESS_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BOOKKEEPING);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BUYER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_ADVERTISE);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_PUBLIC);
					 
					 
					 
---------------------------------------------------------------------------------------					 
					 
 v_tab_id  := 'm_business';
 rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'Business'
                     , X_PARENT_TAB  => 'mobi'
                     , X_DISPLAY_SEQ => 2
                     , X_TAB_HREF    => 'config_menu.php');

  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_MANAGER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_ADMIN);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_MANAGER_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BUSINESS_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BOOKKEEPING);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BUYER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_ADVERTISE);
 

v_tab_id  := 'm_alerts';
 rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'Alerts'
                     , X_PARENT_TAB  => 'm_business'
                     , X_DISPLAY_SEQ => 2.1
                     , X_TAB_HREF    => 'property_home_summary.php');

  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_MANAGER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_ADMIN);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_MANAGER_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BUSINESS_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BOOKKEEPING);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BUYER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_ADVERTISE);
					 
					 
v_tab_id  := 'm_properties';
 rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'Properties'
                     , X_PARENT_TAB  => 'm_business'
                     , X_DISPLAY_SEQ => 2.2
                     , X_TAB_HREF    => 'property_details.php');

  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_MANAGER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_ADMIN);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_MANAGER_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BUSINESS_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BOOKKEEPING);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BUYER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_ADVERTISE);					 
					 
v_tab_id  := 'm_vendors';
 rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'Vendors'
                     , X_PARENT_TAB  => 'm_business'
                     , X_DISPLAY_SEQ => 2.3
                     , X_TAB_HREF    => 'property_supplier.php');

  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_MANAGER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_ADMIN);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_MANAGER_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BUSINESS_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BOOKKEEPING);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BUYER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_ADVERTISE);					 
 
v_tab_id  := 'm_jobs';
 rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'Jobs'
                     , X_PARENT_TAB  => 'm_business'
                     , X_DISPLAY_SEQ => 2.4
                     , X_TAB_HREF    => 'property_expence.php');

  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_MANAGER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_ADMIN);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_MANAGER_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BUSINESS_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BOOKKEEPING);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BUYER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_ADVERTISE);					 
 
 
 ---------------------------------------------------------------------------------------					 
					 
 v_tab_id  := 'm_tenant';
 rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'Tenant'
                     , X_PARENT_TAB  => 'mobi'
                     , X_DISPLAY_SEQ => 3
                     , X_TAB_HREF    => 'config_menu.php');

  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_MANAGER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_ADMIN);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_MANAGER_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BUSINESS_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BOOKKEEPING);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BUYER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_ADVERTISE);
 

v_tab_id  := 'm_contacts';
 rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'Contacts'
                     , X_PARENT_TAB  => 'm_tenant'
                     , X_DISPLAY_SEQ => 3.1
                     , X_TAB_HREF    => 'tenant_peoples.php');

  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_MANAGER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_ADMIN);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_MANAGER_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BUSINESS_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BOOKKEEPING);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BUYER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_ADVERTISE);
					 
v_tab_id  := 'm_agreements';
 rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'Agreements'
                     , X_PARENT_TAB  => 'm_tenant'
                     , X_DISPLAY_SEQ => 3.2
                     , X_TAB_HREF    => 'tenant_agreements.php');

  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_MANAGER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_ADMIN);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_MANAGER_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BUSINESS_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BOOKKEEPING);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BUYER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_ADVERTISE);
 
 v_tab_id  := 'm_tenants';
 rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'Tenants'
                     , X_PARENT_TAB  => 'm_tenant'
                     , X_DISPLAY_SEQ => 3.3
                     , X_TAB_HREF    => 'tenant_tenants.php');

  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_MANAGER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_ADMIN);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_MANAGER_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BUSINESS_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BOOKKEEPING);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BUYER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_ADVERTISE);
 
  v_tab_id  := 'm_actions';
 rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'Actions'
                     , X_PARENT_TAB  => 'm_tenant'
                     , X_DISPLAY_SEQ => 3.4
                     , X_TAB_HREF    => 'tenant_actions.php');

  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_MANAGER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_ADMIN);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_MANAGER_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BUSINESS_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BOOKKEEPING);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BUYER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_ADVERTISE);
					 
					 
 ---------------------------------------------------------------------------------------					 
					 
 v_tab_id  := 'm_payment';
 rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'Payment'
                     , X_PARENT_TAB  => 'mobi'
                     , X_DISPLAY_SEQ => 4
                     , X_TAB_HREF    => 'config_menu.php');

  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_MANAGER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_ADMIN);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_MANAGER_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BUSINESS_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BOOKKEEPING);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BUYER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_ADVERTISE);
 

v_tab_id  := 'm_receivable';
 rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'Receivable'
                     , X_PARENT_TAB  => 'm_payment'
                     , X_DISPLAY_SEQ => 4.1
                     , X_TAB_HREF    => 'payment_receiveable.php');

  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_MANAGER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_ADMIN);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_MANAGER_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BUSINESS_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BOOKKEEPING);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BUYER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_ADVERTISE);		

v_tab_id  := 'm_payable';
 rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'Payable'
                     , X_PARENT_TAB  => 'm_payment'
                     , X_DISPLAY_SEQ => 4.2
                     , X_TAB_HREF    => 'payment_payable.php');

  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_MANAGER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_ADMIN);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_MANAGER_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BUSINESS_OWNER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BOOKKEEPING);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BUYER);
  rnt_menu_roles_pkg.insert_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_ADVERTISE);							 
end;
/