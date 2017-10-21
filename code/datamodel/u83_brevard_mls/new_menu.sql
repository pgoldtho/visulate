begin

  rnt_menu_tabs_pkg.insert_row
                     ( X_TAB_NAME    => 'real_estate'
                     , X_TAB_TITLE   => 'Real Estate'
                     , X_PARENT_TAB  => 'public'
                     , X_DISPLAY_SEQ => 1.15
                     , X_TAB_HREF    => 'dbcontent.php');
                     
  rnt_menus_pkg.insert_row
                     ( X_TAB_NAME    => 'real_estate'
                     , X_MENU_NAME   => 'location'
                     , X_MENU_TITLE  => 'Location'
                     , X_DISPLAY_SEQ => 1 );
                     

  rnt_menu_pages_pkg.insert_row
                     ( X_TAB_NAME       => 'real_estate'
                     , X_MENU_NAME      => 'location'
                     , X_PAGE_NAME      => 'brevard'
                     , X_SUB_PAGE       => 'Buy to Rent'
                     , X_PAGE_TITLE     => 'Brevard County'
                     , X_DISPLAY_SEQ    => 1.1
                     , X_HEADER_CONTENT => xmltype('<head><title>Visulate - Brevard County Buy-to-Rent</title>
                     <meta name="keywords" content="Single family rental, buy to rent, florida, real estate, Brevard County"/>
                     <meta name="description" content="Brevard County properties that show potential as buy-to-rent single family homes."/>

                     
                     </head>')
                     , X_BODY_CONTENT   => '<h1>Buy to Rent in Brevard County</h1>');

  rnt_menu_pages_pkg.insert_row
                     ( X_TAB_NAME       => 'real_estate'
                     , X_MENU_NAME      => 'location'
                     , X_PAGE_NAME      => 'brevard'
                     , X_SUB_PAGE       => 'Latest Listings'
                     , X_PAGE_TITLE     => 'Brevard County'
                     , X_DISPLAY_SEQ    => 1.2
                     , X_HEADER_CONTENT => xmltype('<head><title>Visulate - Brevard County Latest Listings</title>
                     <meta name="keywords" content="Brevard County, Florida, Real Estate, MLS"/>
                     <meta name="description" content="Latest MLS listings for Brevard County, Florida."/>
                     </head>')
                     , X_BODY_CONTENT   => '<h1>Latest Listings in Brevard County</h1>');




  rnt_menu_pages_pkg.insert_row
                     ( X_TAB_NAME       => 'real_estate'
                     , X_MENU_NAME      => 'location'
                     , X_PAGE_NAME      => 'charlotte'
                     , X_SUB_PAGE       => 'Buy to Rent'
                     , X_PAGE_TITLE     => 'Charlotte County'
                     , X_DISPLAY_SEQ    => 2.1
                     , X_HEADER_CONTENT => xmltype('<head><title>Visulate - Charlotte County Buy-to-Rent</title>
                     <meta name="keywords" content="Single family rental, buy to rent, florida, real estate, Charlotte County"/>
                     <meta name="description" content="Charlotte County properties that show potential as buy-to-rent single family homes."/>
                     </head>')
                     , X_BODY_CONTENT   => '<h1>Buy to Rent in Charlotte County</h1>');

  rnt_menu_pages_pkg.insert_row
                     ( X_TAB_NAME       => 'real_estate'
                     , X_MENU_NAME      => 'location'
                     , X_PAGE_NAME      => 'charlotte'
                     , X_SUB_PAGE       => 'Latest Listings'
                     , X_PAGE_TITLE     => 'Charlotte County'
                     , X_DISPLAY_SEQ    => 2.2
                     , X_HEADER_CONTENT => xmltype('<head><title>Visulate - Charlotte County Latest Listings</title>
                     <meta name="keywords" content="Charlotte County, Florida, Real Estate, MLS"/>
                     <meta name="description" content="Latest MLS listings for Charlotte County, Florida."/>
                     </head>')
                     , X_BODY_CONTENT   => '<h1>Latest Listings in Charlotte County</h1>');
    
  rnt_menu_pages_pkg.insert_row
                     ( X_TAB_NAME       => 'real_estate'
                     , X_MENU_NAME      => 'location'
                     , X_PAGE_NAME      => 'desoto'
                     , X_SUB_PAGE       => 'Buy to Rent'
                     , X_PAGE_TITLE     => 'Desoto County'
                     , X_DISPLAY_SEQ    => 3.1
                     , X_HEADER_CONTENT => xmltype('<head><title>Visulate - Desoto County Buy-to-Rent</title>
                     <meta name="keywords" content="Single family rental, buy to rent, florida, real estate, Lake County"/>
                     <meta name="description" content="Desoto County properties that show potential as buy-to-rent single family homes."/>
                     </head>')
                     , X_BODY_CONTENT   => '<h1>Buy to Rent in Desoto County</h1>');

  rnt_menu_pages_pkg.insert_row
                     ( X_TAB_NAME       => 'real_estate'
                     , X_MENU_NAME      => 'location'
                     , X_PAGE_NAME      => 'desoto'
                     , X_SUB_PAGE       => 'Latest Listings'
                     , X_PAGE_TITLE     => 'Desoto County'
                     , X_DISPLAY_SEQ    => 3.2
                     , X_HEADER_CONTENT => xmltype('<head><title>Visulate - Desoto County Latest Listings</title>
                     <meta name="keywords" content="Desoto County, Florida, Real Estate, MLS"/>
                     <meta name="description" content="Latest MLS listings for Desoto County, Florida."/>
                     </head>')
                     , X_BODY_CONTENT   => '<h1>Latest Listings in Desoto County</h1>');

    
    
  rnt_menu_pages_pkg.insert_row
                     ( X_TAB_NAME       => 'real_estate'
                     , X_MENU_NAME      => 'location'
                     , X_PAGE_NAME      => 'hernando'
                     , X_SUB_PAGE       => 'Buy to Rent'
                     , X_PAGE_TITLE     => 'Hernando County'
                     , X_DISPLAY_SEQ    => 4.1
                     , X_HEADER_CONTENT => xmltype('<head><title>Visulate - Hernando County Buy-to-Rent</title>
                     <meta name="keywords" content="Single family rental, buy to rent, florida, real estate, Hernando County"/>
                     <meta name="description" content="Hernando County properties that show potential as buy-to-rent single family homes."/>
                     </head>')
                     , X_BODY_CONTENT   => '<h1>Buy to Rent in Hernando County</h1>');

  rnt_menu_pages_pkg.insert_row
                     ( X_TAB_NAME       => 'real_estate'
                     , X_MENU_NAME      => 'location'
                     , X_PAGE_NAME      => 'hernando'
                     , X_SUB_PAGE       => 'Latest Listings'
                     , X_PAGE_TITLE     => 'Hernando County'
                     , X_DISPLAY_SEQ    => 4.2
                     , X_HEADER_CONTENT => xmltype('<head><title>Visulate - Hernando County Latest Listings</title>
                     <meta name="keywords" content="Hernando County, Florida, Real Estate, MLS"/>
                     <meta name="description" content="Latest MLS listings for Hernando County, Florida."/>
                     </head>')
                     , X_BODY_CONTENT   => '<h1>Latest Listings in Hernando County</h1>');



  rnt_menu_pages_pkg.insert_row
                     ( X_TAB_NAME       => 'real_estate'
                     , X_MENU_NAME      => 'location'
                     , X_PAGE_NAME      => 'lake'
                     , X_SUB_PAGE       => 'Buy to Rent'
                     , X_PAGE_TITLE     => 'Lake County'
                     , X_DISPLAY_SEQ    => 5.1
                     , X_HEADER_CONTENT => xmltype('<head><title>Visulate - Lake County Buy-to-Rent</title>
                     <meta name="keywords" content="Single family rental, buy to rent, florida, real estate, Lake County"/>
                     <meta name="description" content="Lake County properties that show potential as buy-to-rent single family homes."/>
                     </head>')
                     , X_BODY_CONTENT   => '<h1>Buy to Rent in Lake County</h1>');

  rnt_menu_pages_pkg.insert_row
                     ( X_TAB_NAME       => 'real_estate'
                     , X_MENU_NAME      => 'location'
                     , X_PAGE_NAME      => 'lake'
                     , X_SUB_PAGE       => 'Latest Listings'
                     , X_PAGE_TITLE     => 'Lake County'
                     , X_DISPLAY_SEQ    => 5.2
                     , X_HEADER_CONTENT => xmltype('<head><title>Visulate - Lake County Latest Listings</title>
                     <meta name="keywords" content="Lake County, Florida, Real Estate, MLS"/>
                     <meta name="description" content="Latest MLS listings for Lake County, Florida."/>
                     </head>')
                     , X_BODY_CONTENT   => '<h1>Latest Listings in Lake County</h1>');

  rnt_menu_pages_pkg.insert_row
                     ( X_TAB_NAME       => 'real_estate'
                     , X_MENU_NAME      => 'location'
                     , X_PAGE_NAME      => 'manatee'
                     , X_SUB_PAGE       => 'Buy to Rent'
                     , X_PAGE_TITLE     => 'Manatee County'
                     , X_DISPLAY_SEQ    => 6.1
                     , X_HEADER_CONTENT => xmltype('<head><title>Visulate - Manatee County Buy-to-Rent</title>
                     <meta name="keywords" content="Single family rental, buy to rent, florida, real estate, Manatee County"/>
                     <meta name="description" content="Manatee County properties that show potential as buy-to-rent single family homes."/>
                     </head>')
                     , X_BODY_CONTENT   => '<h1>Buy to Rent in Manatee County</h1>');

  rnt_menu_pages_pkg.insert_row
                     ( X_TAB_NAME       => 'real_estate'
                     , X_MENU_NAME      => 'location'
                     , X_PAGE_NAME      => 'manatee'
                     , X_SUB_PAGE       => 'Latest Listings'
                     , X_PAGE_TITLE     => 'Manatee County'
                     , X_DISPLAY_SEQ    => 6.2
                     , X_HEADER_CONTENT => xmltype('<head><title>Visulate - Manatee County Latest Listings</title>
                     <meta name="keywords" content="Manatee County, Florida, Real Estate, MLS"/>
                     <meta name="description" content="Latest MLS listings for Manatee County, Florida."/>
                     </head>')
                     , X_BODY_CONTENT   => '<h1>Latest Listings in Manatee County</h1>');

  rnt_menu_pages_pkg.insert_row
                     ( X_TAB_NAME       => 'real_estate'
                     , X_MENU_NAME      => 'location'
                     , X_PAGE_NAME      => 'marion'
                     , X_SUB_PAGE       => 'Buy to Rent'
                     , X_PAGE_TITLE     => 'Marion County'
                     , X_DISPLAY_SEQ    => 7.1
                     , X_HEADER_CONTENT => xmltype('<head><title>Visulate - Marion County Buy-to-Rent</title>
                     <meta name="keywords" content="Single family rental, buy to rent, florida, real estate, Marion County"/>
                     <meta name="description" content="Marion County properties that show potential as buy-to-rent single family homes."/>
                     </head>')
                     , X_BODY_CONTENT   => '<h1>Buy to Rent in Marion County</h1>');

  rnt_menu_pages_pkg.insert_row
                     ( X_TAB_NAME       => 'real_estate'
                     , X_MENU_NAME      => 'location'
                     , X_PAGE_NAME      => 'marion'
                     , X_SUB_PAGE       => 'Latest Listings'
                     , X_PAGE_TITLE     => 'Marion County'
                     , X_DISPLAY_SEQ    => 7.2
                     , X_HEADER_CONTENT => xmltype('<head><title>Visulate - Marion County Latest Listings</title>
                     <meta name="keywords" content="Marion County, Florida, Real Estate, MLS"/>
                     <meta name="description" content="Latest MLS listings for Marion County, Florida."/>
                     </head>')
                     , X_BODY_CONTENT   => '<h1>Latest Listings in Marion County</h1>');

  rnt_menu_pages_pkg.insert_row
                     ( X_TAB_NAME       => 'real_estate'
                     , X_MENU_NAME      => 'location'
                     , X_PAGE_NAME      => 'orange'
                     , X_SUB_PAGE       => 'Buy to Rent'
                     , X_PAGE_TITLE     => 'Orange County'
                     , X_DISPLAY_SEQ    => 8.1
                     , X_HEADER_CONTENT => xmltype('<head><title>Visulate - Orange County Buy-to-Rent</title>
                     <meta name="keywords" content="Single family rental, buy to rent, florida, real estate, Orange County"/>
                     <meta name="description" content="Orange County properties that show potential as buy-to-rent single family homes."/>
                     </head>')
                     , X_BODY_CONTENT   => '<h1>Buy to Rent in Orange County</h1>');

  rnt_menu_pages_pkg.insert_row
                     ( X_TAB_NAME       => 'real_estate'
                     , X_MENU_NAME      => 'location'
                     , X_PAGE_NAME      => 'orange'
                     , X_SUB_PAGE       => 'Latest Listings'
                     , X_PAGE_TITLE     => 'Orange County'
                     , X_DISPLAY_SEQ    => 8.2
                     , X_HEADER_CONTENT => xmltype('<head><title>Visulate - Orange County Latest Listings</title>
                     <meta name="keywords" content="Orange County, Florida, Real Estate, MLS"/>
                     <meta name="description" content="Latest MLS listings for Orange County, Florida."/>
                     </head>')
                     , X_BODY_CONTENT   => '<h1>Latest Listings in Orange County</h1>');

  rnt_menu_pages_pkg.insert_row
                     ( X_TAB_NAME       => 'real_estate'
                     , X_MENU_NAME      => 'location'
                     , X_PAGE_NAME      => 'osceola'
                     , X_SUB_PAGE       => 'Buy to Rent'
                     , X_PAGE_TITLE     => 'Osceola County'
                     , X_DISPLAY_SEQ    => 9.1
                     , X_HEADER_CONTENT => xmltype('<head><title>Visulate - Osceola County Buy-to-Rent</title>
                     <meta name="keywords" content="Single family rental, buy to rent, florida, real estate, Osceola County"/>
                     <meta name="description" content="Osceola County properties that show potential as buy-to-rent single family homes."/>
                     </head>')
                     , X_BODY_CONTENT   => '<h1>Buy to Rent in Osceola County</h1>');

  rnt_menu_pages_pkg.insert_row
                     ( X_TAB_NAME       => 'real_estate'
                     , X_MENU_NAME      => 'location'
                     , X_PAGE_NAME      => 'osceola'
                     , X_SUB_PAGE       => 'Latest Listings'
                     , X_PAGE_TITLE     => 'Osceola County'
                     , X_DISPLAY_SEQ    => 9.2
                     , X_HEADER_CONTENT => xmltype('<head><title>Visulate - Osceola County Latest Listings</title>
                     <meta name="keywords" content="Osceola County, Florida, Real Estate, MLS"/>
                     <meta name="description" content="Latest MLS listings for Osceola County, Florida."/>
                     </head>')
                     , X_BODY_CONTENT   => '<h1>Latest Listings in Osceola County</h1>');

  rnt_menu_pages_pkg.insert_row
                     ( X_TAB_NAME       => 'real_estate'
                     , X_MENU_NAME      => 'location'
                     , X_PAGE_NAME      => 'pasco'
                     , X_SUB_PAGE       => 'Buy to Rent'
                     , X_PAGE_TITLE     => 'Pasco County'
                     , X_DISPLAY_SEQ    => 10.1
                     , X_HEADER_CONTENT => xmltype('<head><title>Visulate - Pasco County Buy-to-Rent</title>
                     <meta name="keywords" content="Single family rental, buy to rent, florida, real estate, Pasco County"/>
                     <meta name="description" content="Pasco County properties that show potential as buy-to-rent single family homes."/>
                     </head>')
                     , X_BODY_CONTENT   => '<h1>Buy to Rent in Pasco County</h1>');

  rnt_menu_pages_pkg.insert_row
                     ( X_TAB_NAME       => 'real_estate'
                     , X_MENU_NAME      => 'location'
                     , X_PAGE_NAME      => 'pasco'
                     , X_SUB_PAGE       => 'Latest Listings'
                     , X_PAGE_TITLE     => 'Pasco County'
                     , X_DISPLAY_SEQ    => 10.2
                     , X_HEADER_CONTENT => xmltype('<head><title>Visulate - Pasco County Latest Listings</title>
                     <meta name="keywords" content="Pasco County, Florida, Real Estate, MLS"/>
                     <meta name="description" content="Latest MLS listings for Pasco County, Florida."/>
                     </head>')
                     , X_BODY_CONTENT   => '<h1>Latest Listings in Pasco County</h1>');

  rnt_menu_pages_pkg.insert_row
                     ( X_TAB_NAME       => 'real_estate'
                     , X_MENU_NAME      => 'location'
                     , X_PAGE_NAME      => 'polk'
                     , X_SUB_PAGE       => 'Buy to Rent'
                     , X_PAGE_TITLE     => 'Polk County'
                     , X_DISPLAY_SEQ    => 11.1
                     , X_HEADER_CONTENT => xmltype('<head><title>Visulate - Polk County Buy-to-Rent</title>
                     <meta name="keywords" content="Single family rental, buy to rent, florida, real estate, Polk County"/>
                     <meta name="description" content="Polk County properties that show potential as buy-to-rent single family homes."/>
                     </head>')
                     , X_BODY_CONTENT   => '<h1>Buy to Rent in Polk County</h1>');

  rnt_menu_pages_pkg.insert_row
                     ( X_TAB_NAME       => 'real_estate'
                     , X_MENU_NAME      => 'location'
                     , X_PAGE_NAME      => 'polk'
                     , X_SUB_PAGE       => 'Latest Listings'
                     , X_PAGE_TITLE     => 'Polk County'
                     , X_DISPLAY_SEQ    => 11.2
                     , X_HEADER_CONTENT => xmltype('<head><title>Visulate - Polk County Latest Listings</title>
                     <meta name="keywords" content="Polk County, Florida, Real Estate, MLS"/>
                     <meta name="description" content="Latest MLS listings for Polk County, Florida."/>
                     </head>')
                     , X_BODY_CONTENT   => '<h1>Latest Listings in Polk County</h1>');

  rnt_menu_pages_pkg.insert_row
                     ( X_TAB_NAME       => 'real_estate'
                     , X_MENU_NAME      => 'location'
                     , X_PAGE_NAME      => 'sarasota'
                     , X_SUB_PAGE       => 'Buy to Rent'
                     , X_PAGE_TITLE     => 'Sarasota County'
                     , X_DISPLAY_SEQ    => 12.1
                     , X_HEADER_CONTENT => xmltype('<head><title>Visulate - Sarasota County Buy-to-Rent</title>
                     <meta name="keywords" content="Single family rental, buy to rent, florida, real estate, Sarasota County"/>
                     <meta name="description" content="Sarasota County properties that show potential as buy-to-rent single family homes."/>
                     </head>')
                     , X_BODY_CONTENT   => '<h1>Buy to Rent in Sarasota County</h1>');

  rnt_menu_pages_pkg.insert_row
                     ( X_TAB_NAME       => 'real_estate'
                     , X_MENU_NAME      => 'location'
                     , X_PAGE_NAME      => 'sarasota'
                     , X_SUB_PAGE       => 'Latest Listings'
                     , X_PAGE_TITLE     => 'Sarasota County'
                     , X_DISPLAY_SEQ    => 12.2
                     , X_HEADER_CONTENT => xmltype('<head><title>Visulate - Sarasota County Latest Listings</title>
                     <meta name="keywords" content="Sarasota County, Florida, Real Estate, MLS"/>
                     <meta name="description" content="Latest MLS listings for Sarasota County, Florida."/>
                     </head>')
                     , X_BODY_CONTENT   => '<h1>Latest Listings in Sarasota County</h1>');

  rnt_menu_pages_pkg.insert_row
                     ( X_TAB_NAME       => 'real_estate'
                     , X_MENU_NAME      => 'location'
                     , X_PAGE_NAME      => 'seminole'
                     , X_SUB_PAGE       => 'Buy to Rent'
                     , X_PAGE_TITLE     => 'Seminole County'
                     , X_DISPLAY_SEQ    => 13.1
                     , X_HEADER_CONTENT => xmltype('<head><title>Visulate - Seminole County Buy-to-Rent</title>
                     <meta name="keywords" content="Single family rental, buy to rent, florida, real estate, Seminole County"/>
                     <meta name="description" content="Seminole County properties that show potential as buy-to-rent single family homes."/>
                    </head>')
                     , X_BODY_CONTENT   => '<h1>Buy to Rent in Seminole County</h1>');

  rnt_menu_pages_pkg.insert_row
                     ( X_TAB_NAME       => 'real_estate'
                     , X_MENU_NAME      => 'location'
                     , X_PAGE_NAME      => 'seminole'
                     , X_SUB_PAGE       => 'Latest Listings'
                     , X_PAGE_TITLE     => 'Seminole County'
                     , X_DISPLAY_SEQ    => 13.2
                     , X_HEADER_CONTENT => xmltype('<head><title>Visulate - Seminole County Latest Listings</title>
                     <meta name="keywords" content="Seminole County, Florida, Real Estate, MLS"/>
                     <meta name="description" content="Latest MLS listings for Seminole County, Florida."/>
                     </head>')
                     , X_BODY_CONTENT   => '<h1>Latest Listings in Seminole County</h1>');

  rnt_menu_pages_pkg.insert_row
                     ( X_TAB_NAME       => 'real_estate'
                     , X_MENU_NAME      => 'location'
                     , X_PAGE_NAME      => 'sumter'
                     , X_SUB_PAGE       => 'Buy to Rent'
                     , X_PAGE_TITLE     => 'Sumter County'
                     , X_DISPLAY_SEQ    => 14.1
                     , X_HEADER_CONTENT => xmltype('<head><title>Visulate - Sumter County Buy-to-Rent</title>
                     <meta name="keywords" content="Single family rental, buy to rent, florida, real estate, Sumter County"/>
                     <meta name="description" content="Sumter County properties that show potential as buy-to-rent single family homes."/>
                     </head>')
                     , X_BODY_CONTENT   => '<h1>Buy to Rent in Sumter County</h1>');

  rnt_menu_pages_pkg.insert_row
                     ( X_TAB_NAME       => 'real_estate'
                     , X_MENU_NAME      => 'location'
                     , X_PAGE_NAME      => 'sumter'
                     , X_SUB_PAGE       => 'Latest Listings'
                     , X_PAGE_TITLE     => 'Sumter County'
                     , X_DISPLAY_SEQ    => 14.2
                     , X_HEADER_CONTENT => xmltype('<head><title>Visulate - Sumter County Latest Listings</title>
                     <meta name="keywords" content="Sumter County, Florida, Real Estate, MLS"/>
                     <meta name="description" content="Latest MLS listings for Sumter County, Florida."/>
                     </head>')
                     , X_BODY_CONTENT   => '<h1>Latest Listings in Sumter County</h1>');

  rnt_menu_pages_pkg.insert_row
                     ( X_TAB_NAME       => 'real_estate'
                     , X_MENU_NAME      => 'location'
                     , X_PAGE_NAME      => 'volusia'
                     , X_SUB_PAGE       => 'Buy to Rent'
                     , X_PAGE_TITLE     => 'Volusia County'
                     , X_DISPLAY_SEQ    => 15.1
                     , X_HEADER_CONTENT => xmltype('<head><title>Visulate - Volusia County Buy-to-Rent</title>
                     <meta name="keywords" content="Single family rental, buy to rent, florida, real estate, Volusia County"/>
                     <meta name="description" content="Volusia County properties that show potential as buy-to-rent single family homes."/>
                     </head>')
                     , X_BODY_CONTENT   => '<h1>Buy to Rent in Volusia County</h1>');

  rnt_menu_pages_pkg.insert_row
                     ( X_TAB_NAME       => 'real_estate'
                     , X_MENU_NAME      => 'location'
                     , X_PAGE_NAME      => 'volusia'
                     , X_SUB_PAGE       => 'Latest Listings'
                     , X_PAGE_TITLE     => 'Volusia County'
                     , X_DISPLAY_SEQ    => 15.2
                     , X_HEADER_CONTENT => xmltype('<head><title>Visulate - Volusia County Latest Listings</title>
                     <meta name="keywords" content="Volusia County, Florida, Real Estate, MLS"/>
                     <meta name="description" content="Latest MLS listings for Volusia County, Florida."/>
                     </head>')
                     , X_BODY_CONTENT   => '<h1>Latest Listings in Volusia County</h1>');


 mls_price_ranges_pkg.get_rentals( X_COUNTY    => 'BREVARD'
                                 , X_TAB_NAME  => 'real_estate'
                                 , X_MENU_NAME => 'location'
                                 , X_PAGE_NAME => 'brevard'
                                 , X_SUB_PAGE  => 'Buy to Rent' );
 
 mls_price_ranges_pkg.latest_listings( X_TAB_NAME  => 'real_estate'
                                     , X_MENU_NAME => 'location'
                                     , X_PAGE_NAME => 'brevard'
                                     , X_SUB_PAGE  => 'Latest Listings'
                                     , X_DATE      => (sysdate - 1)
                                     , X_COUNTY    => 'BR');

 mls_price_ranges_pkg.get_rentals( X_COUNTY    => 'CHARLOTTE'
                                 , X_TAB_NAME  => 'real_estate'
                                 , X_MENU_NAME => 'location'
                                 , X_PAGE_NAME => 'charlotte'
                                 , X_SUB_PAGE  => 'Buy to Rent' );

 mls_price_ranges_pkg.latest_listings( X_TAB_NAME  => 'real_estate'
                                     , X_MENU_NAME => 'location'
                                     , X_PAGE_NAME => 'charlotte'
                                     , X_SUB_PAGE  => 'Latest Listings'
                                     , X_DATE      => (sysdate - 1)
                                     , X_COUNTY    => 'CH');
    
 mls_price_ranges_pkg.get_rentals( X_COUNTY    => 'DESOTO'
                                 , X_TAB_NAME  => 'real_estate'
                                 , X_MENU_NAME => 'location'
                                 , X_PAGE_NAME => 'desoto'
                                 , X_SUB_PAGE  => 'Buy to Rent' );

 mls_price_ranges_pkg.latest_listings( X_TAB_NAME  => 'real_estate'
                                     , X_MENU_NAME => 'location'
                                     , X_PAGE_NAME => 'desoto'
                                     , X_SUB_PAGE  => 'Latest Listings'
                                     , X_DATE      => (sysdate - 1)
                                     , X_COUNTY    => 'DE');
    
 mls_price_ranges_pkg.get_rentals( X_COUNTY    => 'HERNANDO'
                                 , X_TAB_NAME  => 'real_estate'
                                 , X_MENU_NAME => 'location'
                                 , X_PAGE_NAME => 'hernando'
                                 , X_SUB_PAGE  => 'Buy to Rent' );

 mls_price_ranges_pkg.latest_listings( X_TAB_NAME  => 'real_estate'
                                     , X_MENU_NAME => 'location'
                                     , X_PAGE_NAME => 'hernando'
                                     , X_SUB_PAGE  => 'Latest Listings'
                                     , X_DATE      => (sysdate - 1)
                                     , X_COUNTY    => 'HC');
    
 mls_price_ranges_pkg.get_rentals( X_COUNTY    => 'LAKE'
                                 , X_TAB_NAME  => 'real_estate'
                                 , X_MENU_NAME => 'location'
                                 , X_PAGE_NAME => 'lake'
                                 , X_SUB_PAGE  => 'Buy to Rent' );

 mls_price_ranges_pkg.latest_listings( X_TAB_NAME  => 'real_estate'
                                     , X_MENU_NAME => 'location'
                                     , X_PAGE_NAME => 'lake'
                                     , X_SUB_PAGE  => 'Latest Listings'
                                     , X_DATE      => (sysdate - 1)
                                     , X_COUNTY    => 'LK');
    
 mls_price_ranges_pkg.get_rentals( X_COUNTY    => 'MANATEE'
                                 , X_TAB_NAME  => 'real_estate'
                                 , X_MENU_NAME => 'location'
                                 , X_PAGE_NAME => 'manatee'
                                 , X_SUB_PAGE  => 'Buy to Rent' );

 mls_price_ranges_pkg.latest_listings( X_TAB_NAME  => 'real_estate'
                                     , X_MENU_NAME => 'location'
                                     , X_PAGE_NAME => 'manatee'
                                     , X_SUB_PAGE  => 'Latest Listings'
                                     , X_DATE      => (sysdate - 1)
                                     , X_COUNTY    => 'MT');
    
 mls_price_ranges_pkg.get_rentals( X_COUNTY    => 'MARION'
                                 , X_TAB_NAME  => 'real_estate'
                                 , X_MENU_NAME => 'location'
                                 , X_PAGE_NAME => 'marion'
                                 , X_SUB_PAGE  => 'Buy to Rent' );

 mls_price_ranges_pkg.latest_listings( X_TAB_NAME  => 'real_estate'
                                     , X_MENU_NAME => 'location'
                                     , X_PAGE_NAME => 'marion'
                                     , X_SUB_PAGE  => 'Latest Listings'
                                     , X_DATE      => (sysdate - 1)
                                     , X_COUNTY    => 'MA');
    
 mls_price_ranges_pkg.get_rentals( X_COUNTY    => 'ORANGE'
                                 , X_TAB_NAME  => 'real_estate'
                                 , X_MENU_NAME => 'location'
                                 , X_PAGE_NAME => 'orange'
                                 , X_SUB_PAGE  => 'Buy to Rent' );

 mls_price_ranges_pkg.latest_listings( X_TAB_NAME  => 'real_estate'
                                     , X_MENU_NAME => 'location'
                                     , X_PAGE_NAME => 'orange'
                                     , X_SUB_PAGE  => 'Latest Listings'
                                     , X_DATE      => (sysdate - 1)
                                     , X_COUNTY    => 'OC');
   
 mls_price_ranges_pkg.get_rentals( X_COUNTY    => 'OSCEOLA'
                                 , X_TAB_NAME  => 'real_estate'
                                 , X_MENU_NAME => 'location'
                                 , X_PAGE_NAME => 'osceola'
                                 , X_SUB_PAGE  => 'Buy to Rent' );

 mls_price_ranges_pkg.latest_listings( X_TAB_NAME  => 'real_estate'
                                     , X_MENU_NAME => 'location'
                                     , X_PAGE_NAME => 'osceola'
                                     , X_SUB_PAGE  => 'Latest Listings'
                                     , X_DATE      => (sysdate - 1)
                                     , X_COUNTY    => 'OS');
   
 mls_price_ranges_pkg.get_rentals( X_COUNTY    => 'PASCO'
                                 , X_TAB_NAME  => 'real_estate'
                                 , X_MENU_NAME => 'location'
                                 , X_PAGE_NAME => 'pasco'
                                 , X_SUB_PAGE  => 'Buy to Rent' );

 mls_price_ranges_pkg.latest_listings( X_TAB_NAME  => 'real_estate'
                                     , X_MENU_NAME => 'location'
                                     , X_PAGE_NAME => 'pasco'
                                     , X_SUB_PAGE  => 'Latest Listings'
                                     , X_DATE      => (sysdate - 1)
                                     , X_COUNTY    => 'PO');
   
 mls_price_ranges_pkg.get_rentals( X_COUNTY    => 'POLK'
                                 , X_TAB_NAME  => 'real_estate'
                                 , X_MENU_NAME => 'location'
                                 , X_PAGE_NAME => 'polk'
                                 , X_SUB_PAGE  => 'Buy to Rent' );

 mls_price_ranges_pkg.latest_listings( X_TAB_NAME  => 'real_estate'
                                     , X_MENU_NAME => 'location'
                                     , X_PAGE_NAME => 'polk'
                                     , X_SUB_PAGE  => 'Latest Listings'
                                     , X_DATE      => (sysdate - 1)
                                     , X_COUNTY    => 'PK');
   
 mls_price_ranges_pkg.get_rentals( X_COUNTY    => 'SARASOTA'
                                 , X_TAB_NAME  => 'real_estate'
                                 , X_MENU_NAME => 'location'
                                 , X_PAGE_NAME => 'sarasota'
                                 , X_SUB_PAGE  => 'Buy to Rent' );

 mls_price_ranges_pkg.latest_listings( X_TAB_NAME  => 'real_estate'
                                     , X_MENU_NAME => 'location'
                                     , X_PAGE_NAME => 'sarasota'
                                     , X_SUB_PAGE  => 'Latest Listings'
                                     , X_DATE      => (sysdate - 1)
                                     , X_COUNTY    => 'SA');
   
 mls_price_ranges_pkg.get_rentals( X_COUNTY    => 'SEMINOLE'
                                 , X_TAB_NAME  => 'real_estate'
                                 , X_MENU_NAME => 'location'
                                 , X_PAGE_NAME => 'seminole'
                                 , X_SUB_PAGE  => 'Buy to Rent' );

 mls_price_ranges_pkg.latest_listings( X_TAB_NAME  => 'real_estate'
                                     , X_MENU_NAME => 'location'
                                     , X_PAGE_NAME => 'seminole'
                                     , X_SUB_PAGE  => 'Latest Listings'
                                     , X_DATE      => (sysdate - 1)
                                     , X_COUNTY    => 'SM');
    
 mls_price_ranges_pkg.get_rentals( X_COUNTY    => 'SUMTER'
                                 , X_TAB_NAME  => 'real_estate'
                                 , X_MENU_NAME => 'location'
                                 , X_PAGE_NAME => 'sumter'
                                 , X_SUB_PAGE  => 'Buy to Rent' );

 mls_price_ranges_pkg.latest_listings( X_TAB_NAME  => 'real_estate'
                                     , X_MENU_NAME => 'location'
                                     , X_PAGE_NAME => 'sumter'
                                     , X_SUB_PAGE  => 'Latest Listings'
                                     , X_DATE      => (sysdate - 1)
                                     , X_COUNTY    => 'SU');
    
 mls_price_ranges_pkg.get_rentals( X_COUNTY    => 'VOLUSIA'
                                 , X_TAB_NAME  => 'real_estate'
                                 , X_MENU_NAME => 'location'
                                 , X_PAGE_NAME => 'volusia'
                                 , X_SUB_PAGE  => 'Buy to Rent' );

 mls_price_ranges_pkg.latest_listings( X_TAB_NAME  => 'real_estate'
                                     , X_MENU_NAME => 'location'
                                     , X_PAGE_NAME => 'volusia'
                                     , X_SUB_PAGE  => 'Latest Listings'
                                     , X_DATE      => (sysdate - 1)
                                     , X_COUNTY    => 'VL');

end;
/