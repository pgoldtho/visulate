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

 

  procedure add_menus is 
    v_tab_id         rnt_menu_tabs.tab_name%type;
  begin

  v_tab_id  := 'm_visulate_search';
  rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'Florida'
                     , X_PARENT_TAB  => 'mobi'
                     , X_DISPLAY_SEQ => 0.5
                     , X_TAB_HREF    => 'visulate_search.php');

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
  v_tab_id  := 'm_CITY';
  rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'Market'
                     , X_PARENT_TAB  => 'm_visulate_search'
                     , X_DISPLAY_SEQ => 0.51
                     , X_TAB_HREF    => 'visulate_search.php');


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

  v_tab_id  := 'm_PROPERTY_DETAILS';
  rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'Research'
                     , X_PARENT_TAB  => 'm_visulate_search'
                     , X_DISPLAY_SEQ => 0.52
                     , X_TAB_HREF    => 'visulate_search.php');


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



  v_tab_id  := 'm_LISTINGS';
  rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => v_tab_id
                     , X_TAB_TITLE   => 'MLS Listings'
                     , X_PARENT_TAB  => 'm_visulate_search'
                     , X_DISPLAY_SEQ => 0.53
                     , X_TAB_HREF    => 'visulate_search.php');


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


  end add_menus;

  procedure hide_old_items is
    v_tab_id         rnt_menu_tabs.tab_name%type;
  begin
   v_tab_id := 'm_find';

  rnt_menu_roles_pkg.delete_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_MANAGER);
  rnt_menu_roles_pkg.delete_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_OWNER);
  rnt_menu_roles_pkg.delete_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_ADMIN);
  rnt_menu_roles_pkg.delete_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_MANAGER_OWNER);
  rnt_menu_roles_pkg.delete_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BUSINESS_OWNER);
  rnt_menu_roles_pkg.delete_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BOOKKEEPING);
  rnt_menu_roles_pkg.delete_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_BUYER);
  rnt_menu_roles_pkg.delete_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_ADVERTISE);
  rnt_menu_roles_pkg.delete_row
                     ( X_TAB_NAME => v_tab_id
                     , X_ROLE_ID  => X_PUBLIC);
  end hide_old_items;

  procedure update_tabs is

  begin
    update RNT_MENU_TABS 
    set TAB_TITLE = 'Real Estate'
    where tab_name = 'public';

    update RNT_MENU_TABS 
    set TAB_TITLE = 'Listings'
    ,   DISPLAY_SEQ = 1.15
    where tab_name = 'real_estate';


    update RNT_MENU_TABS 
    set DISPLAY_SEQ = 1.1
    where tab_name = 'investment';
  end update_tabs;

begin
  add_menus;
  hide_old_items;
  --update_tabs;
end;
/
