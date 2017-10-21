begin

  rnt_menu_pages_pkg.insert_row
  ( X_TAB_NAME       => 'real_estate'
  , X_MENU_NAME      => 'location'
  , X_PAGE_NAME      => 'broward'
  , X_SUB_PAGE       => 'Latest Listings'
  , X_PAGE_TITLE     => 'Broward County'
  , X_DISPLAY_SEQ    => 1.21
  , X_HEADER_CONTENT => xmltype('<head><title>Visulate - Broward County Latest Listings</title>
  <meta name="keywords" content="Broward County, Florida, Real Estate, MLS"/>
  <meta name="description" content="Latest MLS listings for Broward County, Florida."/>
  </head>')
  , X_BODY_CONTENT   => '<h1>Latest Listings in Broward County</h1>');

  rnt_menu_pages_pkg.insert_row
  ( X_TAB_NAME       => 'real_estate'
  , X_MENU_NAME      => 'location'
  , X_PAGE_NAME      => 'broward'
  , X_SUB_PAGE       => 'Buy to Rent'
  , X_PAGE_TITLE     => 'Broward County'
  , X_DISPLAY_SEQ    => 1.31
  , X_HEADER_CONTENT => xmltype('<head><title>Visulate - Broward County Buy-to-Rent</title>
   <meta name="keywords" content="Single family rental, buy to rent, florida, real estate, Broward County"/>
   <meta name="description" content="Broward County, Florida properties that show potential as buy-to-rent single family homes."/>
   </head>')
 , X_BODY_CONTENT   => '<h1>Buy to Rent in Broward County</h1>');


  rnt_menu_pages_pkg.insert_row
  ( X_TAB_NAME       => 'real_estate'
  , X_MENU_NAME      => 'location'
  , X_PAGE_NAME      => 'miami'
  , X_SUB_PAGE       => 'Latest Listings'
  , X_PAGE_TITLE     => 'Miami-Dade County'
  , X_DISPLAY_SEQ    => 7.21
  , X_HEADER_CONTENT => xmltype('<head><title>Visulate - Miami-Dade County Latest Listings</title>
  <meta name="keywords" content="Miami-Dade County, Florida, Real Estate, MLS"/>
  <meta name="description" content="Latest MLS listings for Miami-Dade County, Florida."/>
  </head>')
  , X_BODY_CONTENT   => '<h1>Latest Listings in Miami-Dade County</h1>');
                     
  rnt_menu_pages_pkg.insert_row
  ( X_TAB_NAME       => 'real_estate'
  , X_MENU_NAME      => 'location'
  , X_PAGE_NAME      => 'miami'
  , X_SUB_PAGE       => 'Buy to Rent'
  , X_PAGE_TITLE     => 'Miami-Dade County'
  , X_DISPLAY_SEQ    => 7.31
  , X_HEADER_CONTENT => xmltype('<head><title>Visulate - Miami-Dade County Buy-to-Rent</title>
   <meta name="keywords" content="Single family rental, buy to rent, florida, real estate, Miami-Dade County"/>
   <meta name="description" content="Miami-Dade County, Florida properties that show potential as buy-to-rent single family homes."/>
   </head>')
 , X_BODY_CONTENT   => '<h1>Buy to Rent in Miami-Dade County</h1>');


  rnt_menu_pages_pkg.insert_row
  ( X_TAB_NAME       => 'real_estate'
  , X_MENU_NAME      => 'location'
  , X_PAGE_NAME      => 'palm_beach'
  , X_SUB_PAGE       => 'Latest Listings'
  , X_PAGE_TITLE     => 'Palm Beach County'
  , X_DISPLAY_SEQ    => 9.21
  , X_HEADER_CONTENT => xmltype('<head><title>Visulate - Palm Beach County Latest Listings</title>
  <meta name="keywords" content="Palm Beach County, Florida, Real Estate, MLS"/>
  <meta name="description" content="Latest MLS listings for Palm Beach County, Florida."/>
  </head>')
  , X_BODY_CONTENT   => '<h1>Latest Listings in Palm Beach County</h1>');
                     
  rnt_menu_pages_pkg.insert_row
  ( X_TAB_NAME       => 'real_estate'
  , X_MENU_NAME      => 'location'
  , X_PAGE_NAME      => 'palm_beach'
  , X_SUB_PAGE       => 'Buy to Rent'
  , X_PAGE_TITLE     => 'Palm Beach County'
  , X_DISPLAY_SEQ    => 9.31
  , X_HEADER_CONTENT => xmltype('<head><title>Visulate - Palm Beach County Buy-to-Rent</title>
   <meta name="keywords" content="Single family rental, buy to rent, florida, real estate, Palm Beach County"/>
   <meta name="description" content="Palm Beach County, Florida properties that show potential as buy-to-rent single family homes."/>
   </head>')
 , X_BODY_CONTENT   => '<h1>Buy to Rent in Palm Beach County</h1>');
                     
                     
  rnt_menu_pages_pkg.insert_row
  ( X_TAB_NAME       => 'real_estate'
  , X_MENU_NAME      => 'location'
  , X_PAGE_NAME      => 'pinellas'
  , X_SUB_PAGE       => 'Latest Listings'
  , X_PAGE_TITLE     => 'Pinellas County'
  , X_DISPLAY_SEQ    => 10.21
  , X_HEADER_CONTENT => xmltype('<head><title>Visulate - Pinellas County Latest Listings</title>
  <meta name="keywords" content="Pinellas County, Florida, Real Estate, MLS"/>
  <meta name="description" content="Latest MLS listings for Pinellas County, Florida."/>
  </head>')
  , X_BODY_CONTENT   => '<h1>Latest Listings in Pinellas County</h1>');
                     
  rnt_menu_pages_pkg.insert_row
  ( X_TAB_NAME       => 'real_estate'
  , X_MENU_NAME      => 'location'
  , X_PAGE_NAME      => 'pinellas'
  , X_SUB_PAGE       => 'Buy to Rent'
  , X_PAGE_TITLE     => 'Pinellas County'
  , X_DISPLAY_SEQ    => 10.31
  , X_HEADER_CONTENT => xmltype('<head><title>Visulate - Pinellas County Buy-to-Rent</title>
   <meta name="keywords" content="Single family rental, buy to rent, florida, real estate, Pinellas County"/>
   <meta name="description" content="Pinellas County, Florida properties that show potential as buy-to-rent single family homes."/>
   </head>')
 , X_BODY_CONTENT   => '<h1>Buy to Rent in Pinellas County</h1>');

end;
/
