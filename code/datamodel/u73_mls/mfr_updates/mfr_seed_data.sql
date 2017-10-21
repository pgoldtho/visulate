insert into pr_sources (source_id, source_name)
values (7, 'Florida Regional MLS');

begin
  rnt_menu_pages_pkg.insert_row( X_TAB_NAME  => 'find'
	                           , X_MENU_NAME => 'items'
							   , X_PAGE_NAME => 'homePage'
							   , X_SUB_PAGE  => 'Orange'
                               , X_PAGE_TITLE => 'Orange MLS'
                               , X_DISPLAY_SEQ => 1.11
                               , X_HEADER_CONTENT => 
     xmltype('<head>
  <title>Visulate - Orlando and Orange County MLS Listings</title>
  <meta http-equiv="content-type" content="text/html; charset=iso-8859-1" />
  <meta name="keywords" content="Orange County, MLS, Orlando, Winter Park" />
  <meta name="description" content="Latest listings from Mid Florida MLS for Orlando and Orange County."/>
  </head>')							   
                               , X_BODY_CONTENT => null);
							   
  rnt_menu_pages_pkg.insert_row( X_TAB_NAME  => 'find'
	                           , X_MENU_NAME => 'items'
							   , X_PAGE_NAME => 'homePage'
							   , X_SUB_PAGE  => 'Volusia'
                               , X_PAGE_TITLE => 'Volusia MLS'
                               , X_DISPLAY_SEQ => 1.12
                               , X_HEADER_CONTENT => 
     xmltype('<head>
  <title>Visulate - Daytona Beach and Volusia County MLS Listings</title>
  <meta http-equiv="content-type" content="text/html; charset=iso-8859-1" />
  <meta name="keywords" content="Volusia County, MLS, Daytona, Deltona" />
  <meta name="description" content="Latest listings from Mid Florida MLS for Deltona, Daytona Beach and Volusia County."/>
  </head>')							   
                               , X_BODY_CONTENT => null);
							   
end;
/

					 
                     