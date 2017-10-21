declare
  procedure add_link ( p_city_id         in rnt_cities.city_id%type
                     , p_url             in varchar2
                     , p_label           in varchar2) is
                     
    v_city_desc     rnt_cities.description%type;
    v_name          rnt_cities.name%type;
  begin
    select initcap(name), description into v_name, v_city_desc
    from rnt_cities
    where city_id = p_city_id;
    
    if dbms_lob.instr(v_city_desc, '<ul id="city-links">') > 0 then
      dbms_output.put_line('*****************************************');
      v_city_desc := replace( v_city_desc
                            , '<ul id="city-links">'
                            , '<ul id="city-links"><li><a href="'||p_url||'" target="_blank">'
                              ||p_label||'</a></li>');
    else
    v_city_desc := v_city_desc ||'<p>'||v_name||' links:</p>'
                               ||'<ul id="city-links"><li><a href="'||p_url||'" target="_blank">'
                               ||p_label||'</a></li></ul>';
    end if;
    
    dbms_output.put_line(v_city_desc);
    
    update rnt_cities
    set description = v_city_desc
    where city_id = p_city_id;
  end add_link;
    


procedure add_links is 
begin

-- North Central Florida
---- ALACHUA, Florida Alachua County (Population: 9059)
add_link(9820, 'http://www.alachuacounty.us/Pages/AlachuaCounty.aspx', 'Alachua City Website');
add_link(9820, 'http://en.wikipedia.org/wiki/Alachua,_Florida', 'Wikipedia');
---- ARCHER, Florida Alachua County (Population: 1118)
add_link(9822, 'http://en.wikipedia.org/wiki/Archer,_Florida', 'Wikipedia');
---- EARLETON, Florida Alachua County (Population: )
---- EVINSTON, Florida Alachua County (Population: )
add_link(9830, 'http://en.wikipedia.org/wiki/Evinston,_Florida', 'Wikipedia');
---- GAINESVILLE, Florida Alachua County (Population: 124354)
add_link(9350, 'http://www.cityofgainesville.org', 'Gainesville City Website');
add_link(9350, 'http://www.gainesville.com', 'The Gainesville' );
add_link(9350, 'http://en.wikipedia.org/wiki/Gainesville,_Florida', 'Wikipedia');
add_link(9350, 'http://www.visitgainesville.com', 'Visit Gainesville' );
---- HAWTHORNE, Florida Alachua County (Population: 1417)
add_link(9833, 'http://www.hawthorneflorida.org', 'Hawthorne City Website');
add_link(9833, 'http://www.afn.org/~hawthorn/', 'Alachua Freenet');
add_link(9833, 'http://en.wikipedia.org/wiki/Hawthorne,_Florida', 'Wikipedia');
---- HIGH SPRINGS, Florida Alachua County (Population: 5350)
add_link(9834, 'http://www.highsprings.us', 'High Springs City Website' );
add_link(9834, 'http://www.highsprings.com/welcome/', 'High Springs Chamber of Commerce');
add_link(9834, 'http://en.wikipedia.org/wiki/High_Springs,_Florida', 'Wikipedia');
---- ISLAND GROVE, Florida Alachua County (Population: )
add_link(9836, 'http://www.islandgrovewinecompany.com', 'Island Groove Wine Company' );
add_link(9836, 'http://www.ghosttowns.com/states/fl/islandgrove.html', 'Ghost Towns');
---- LA CROSSE, Florida Alachua County (Population: 360)
add_link(9838, 'http://townoflacrosse.net', 'La Crosse City Website');
add_link(9838, 'http://en.wikipedia.org/wiki/La_Crosse,_Florida', 'Wikipedia');
---- LOCHLOOSA, Florida Alachua County (Population: )
add_link(9839, 'http://myfwc.com/fishing/freshwater/sites-forecast/nc/lochloosa-lake/'
             , 'Florida Fish and Wildlife Conservation Commission');
add_link(9839, 'http://www.lochloosaharbor.com', 'Lochloosa Harbor Fish Camp');
---- MICANOPY, Florida Alachua County (Population: 600)
add_link(9843, 'http://www.micanopytown.com', 'Micanopy City Website');
add_link(9843, 'http://en.wikipedia.org/wiki/Micanopy,_Florida', 'Wikipedia');
---- NEWBERRY, Florida Alachua County (Population: 4950)
add_link(9845, 'http://www.ci.newberry.fl.us', 'Newberry City Website');
add_link(9845, 'http://visitnewberryfl.com', 'Visit Newberry');
add_link(9845, 'http://en.wikipedia.org/wiki/Newberry,_Florida', 'Wikipedia');
---- WALDO, Florida Alachua County (Population: 1015)
add_link(9852, 'http://www.waldo-fl.com', 'Waldo City Website');
add_link(9852, 'http://en.wikipedia.org/wiki/Waldo,_Florida', 'Wikipedia');
-- North Eastern Florida
---- GLEN SAINT MARY, Florida Baker County (Population: 437)
add_link(13505, 'http://www.glenstmary.govoffice.com', 'Glen St. Mary City Website');
add_link(13505, 'http://en.wikipedia.org/wiki/Glen_St._Mary,_Florida', 'Wikipedia');
---- MACCLENNY, Florida Baker County (Population: 6374)
add_link(13520, 'http://www.cityofmacclenny.com', 'Macclenny City Website');
add_link(13520, 'http://en.wikipedia.org/wiki/Macclenny,_Florida', 'Wikipedia');
---- OLUSTEE, Florida Baker County (Population: )
add_link(13524, 'http://en.wikipedia.org/wiki/Olustee,_Florida', 'Wikipedia');
add_link(13524, 'http://www.floridastateparks.org/olusteebattlefield/', 'Florida State Parks');
---- SANDERSON, Florida Baker County (Population: )
add_link(13528, 'http://en.wikipedia.org/wiki/Sanderson,_Florida', 'Wikipedia');
-- North West Florida
---- FOUNTAIN, Florida Bay County (Population: )
add_link(9304, 'http://en.wikipedia.org/wiki/Fountain,_Florida', 'Wikipedia');
---- LYNN HAVEN, Florida Bay County (Population: 18493)
add_link(9309, 'http://cityoflynnhaven.com', 'Lynn Haven City Website');
add_link(9309, 'http://en.wikipedia.org/wiki/Lynn_Haven,_Florida', 'Wikipedia');
---- MEXICO BEACH, Florida Bay County (Population: 1072)
add_link(9288, 'http://www.mexicobeachgov.com', 'Mexico Beach City Website');
add_link(9288, 'http://www.mexicobeach.com', 'Mexico City Visitor Info');
add_link(9288, 'http://www.visitflorida.com/en-us/cities/mexico-beach.html', 'Visit Florida');
add_link(9288, 'http://en.wikipedia.org/wiki/Mexico_Beach,_Florida', 'Wikipedia');
---- PANAMA CITY, Florida Bay County (Population: 36484)
add_link(9286, 'http://www.pcgov.org', 'Panama City Website');
add_link(9286, 'http://en.wikipedia.org/wiki/Panama_City,_Florida', 'Wikipedia');
---- PANAMA CITY BEACH, Florida Bay County (Population: 12018)
add_link(9287, 'http://www.visitpanamacitybeach.com', 'Visit Panama City Beach');
add_link(9287, 'http://www.pcbgov.com', 'Panama City Beach City Website');
add_link(9287, 'http://en.wikipedia.org/wiki/Panama_City_Beach,_Florida', 'Wikipedia');
---- YOUNGSTOWN, Florida Bay County (Population: )
add_link(9323, 'http://en.wikipedia.org/wiki/Youngstown,_Florida', 'Wikipedia');
-- North Central Florida
---- BROOKER, Florida Bradford County (Population: 338)
add_link(9825, 'http://en.wikipedia.org/wiki/Brooker,_Florida', 'Wikipedia');
---- GRAHAM, Florida Bradford County (Population: )
add_link(13507, 'http://en.wikipedia.org/wiki/Graham,_Florida', 'Wikipedia');
---- HAMPTON, Florida Bradford County (Population: 500)
add_link(13509, 'http://en.wikipedia.org/wiki/Hampton,_Florida', 'Wikipedia');
---- LAWTEY, Florida Bradford County (Population: 730)
add_link(13515, 'http://en.wikipedia.org/wiki/Lawtey,_Florida', 'Wikipedia');
add_link(13515, 'http://www.ghosttowns.com/states/fl/lawtey.html', 'Ghost Towns');
---- STARKE, Florida Bradford County (Population: 5449)
add_link(13529, 'http://www.cityofstarke.org', 'Starke City Website');
add_link(13529, 'http://en.wikipedia.org/wiki/Starke,_Florida', 'Wikipedia');
-- East Central Florida
---- CAPE CANAVERAL, Florida Brevard County (Population: 9912)
add_link(10128, 'http://www.cityofcapecanaveral.org', 'Cape Canaveral City Website');
add_link(10128, 'http://en.wikipedia.org/wiki/Cape_Canaveral,_Florida', 'Wikipedia');
add_link(10128, 'http://www.nasa.gov/centers/kennedy/home/index.html', 'Kennedy Space Center');
---- COCOA, Florida Brevard County (Population: 17140)
add_link(10129, 'http://www.cocoafl.org', 'Cocoa City Website');
add_link(10129, 'http://en.wikipedia.org/wiki/Cocoa,_Florida', 'Wikipedia');
---- COCOA BEACH, Florida Brevard County (Population: 11231)
add_link(10131, 'http://www.cityofcocoabeach.com', 'Cocoa Beach City Website');
add_link(10131, 'http://cocoabeachpier.com/cbp/', 'Cocoa Beach Pier');
add_link(10131, 'http://en.wikipedia.org/wiki/Cocoa_Beach,_Florida', 'Wikipedia');
---- GRANT, Florida Brevard County (Population: )
add_link(10134, 'http://www.grantvalkaria.org', 'Grant City Website');
add_link(10134, 'http://en.wikipedia.org/wiki/Grant-Valkaria,_Florida', 'Wikipedia');
---- INDIALANTIC, Florida Brevard County (Population: 2720)
add_link(10126, 'http://www.indialantic.com', 'Indialantic City Website');
add_link(10126, 'http://en.wikipedia.org/wiki/Indialantic,_Florida', 'Wikipedia');
---- MALABAR, Florida Brevard County (Population: 2757)
add_link(10135, 'http://en.wikipedia.org/wiki/Malabar,_Florida', 'Wikipedia');
---- MELBOURNE, Florida Brevard County (Population: 76068)
add_link(10125, 'http://www.melbourneflorida.org', 'Melbourne City Website');
add_link(10125, 'http://en.wikipedia.org/wiki/Melbourne,_Florida', 'Wikipedia');
---- MELBOURNE BEACH, Florida Brevard County (Population: 3101)
add_link(10136, 'http://www.melbournebeachfl.org/Pages/MelbourneBeachFL_WebDocs/about'
              , 'Melbourne Beach Florida City Website');
add_link(10136, 'http://en.wikipedia.org/wiki/Melbourne_Beach,_Florida', 'Wikipedia');
---- MERRITT ISLAND, Florida Brevard County (Population: 34743)
add_link(10137, 'http://en.wikipedia.org/wiki/Merritt_Island,_Florida', 'Wikipedia');
add_link(10137, 'http://www.fws.gov/merrittisland/', 'National Wildlife Refuge');
add_link(10137, 'http://www.nasa.gov/centers/kennedy/home/index.html', 'Kennedy Space Center');
---- MIMS, Florida Brevard County (Population: 7058)
add_link(9877, 'http://en.wikipedia.org/wiki/Mims,_Florida', 'Wikipedia');
---- PALM BAY, Florida Brevard County (Population: 103190)
add_link(10127, 'http://www.palmbayflorida.org', 'Palm Bay City Website');
add_link(10127, 'http://en.wikipedia.org/wiki/Palm_Bay,_Florida', 'Wikipedia');
---- PATRICK AFB, Florida Brevard County (Population: 1222)
add_link(10130, 'http://www.patrick.af.mil', 'Patrick Air Force Base Website');
add_link(10130, 'http://en.wikipedia.org/wiki/Patrick_Air_Force_Base', 'Wikipedia');
---- ROCKLEDGE, Florida Brevard County (Population: 24926)
add_link(10138, 'http://en.wikipedia.org/wiki/Rockledge,_Florida', 'Wikipedia');
---- SATELLITE BEACH, Florida Brevard County (Population: 10109)
add_link(10132, 'http://www.satellitebeachfl.org/Pages/default.aspx', 'Satellite Beach City Website');
add_link(10132, 'http://en.wikipedia.org/wiki/Satellite_Beach,_Florida', 'Wikipedia');
---- SCOTTSMOOR, Florida Brevard County (Population: )
add_link(9886, 'http://www.scottsmoor.org', 'Scottsmoor City Website');
add_link(9886, 'http://en.wikipedia.org/wiki/Scottsmoor,_Florida', 'Wikipedia');
---- SEBASTIAN, Florida Brevard County (Population: 21929)
add_link(10145, 'http://www.cityofsebastian.org', 'Sebastian City Website');
add_link(10145, 'http://www.sebastianchamber.com', 'Sebastian Chamber of Commerce' );
add_link(10145, 'http://en.wikipedia.org/wiki/Sebastian,_Florida', 'Wikipedia');
---- SHARPES, Florida Brevard County (Population: 3411)
add_link(10141, 'http://en.wikipedia.org/wiki/Sharpes,_Florida', 'Wikipedia');
---- TITUSVILLE, Florida Brevard County (Population: 43761)
add_link(9890, 'http://www.titusville.com', 'Titusville City Website' );
add_link(9890, 'http://www.abouttitusville.com', 'About Titusville');
add_link(9890, 'http://en.wikipedia.org/wiki/Titusville,_Florida', 'Wikipedia');
-- South East Florida
---- DANIA, Florida Broward County (Population: )
add_link(10148, 'http://www.ci.dania-beach.fl.us', 'Dania Beach City Website');
add_link(10148, 'http://en.wikipedia.org/wiki/Dania_Beach,_Florida', 'Wikipedia');
---- DEERFIELD BEACH, Florida Broward County (Population: 75018)
add_link(11564, 'http://www.deerfield-beach.com', 'Deerfield Beach City Website');
add_link(11564, 'http://en.wikipedia.org/wiki/Deerfield_Beach,_Florida', 'Wikipedia');
---- FORT LAUDERDALE, Florida Broward County (Population: 165521)
add_link(10989, 'https://www.fortlauderdale.gov', 'Fort Lauderdale City Website');
add_link(10989, 'http://en.wikipedia.org/wiki/Fort_Lauderdale,_Florida', 'Wikipedia');
---- HALLANDALE, Florida Broward County (Population: )
add_link(10149, 'http://www.hallandalebeachfl.gov', 'Hallandale City Website');
add_link(10149, 'http://en.wikipedia.org/wiki/Hallandale_Beach,_Florida', 'Wikipedia');
---- HOLLYWOOD, Florida Broward County (Population: 140768)
add_link(10150, 'http://www.hollywoodfl.org', 'Hollywood City Website');
add_link(10150, 'http://en.wikipedia.org/wiki/Hollywood,_Florida', 'Wikipedia');
---- PEMBROKE PINES, Florida Broward County (Population: 154750)
add_link(10428, 'http://www.ppines.com', 'Pembroke Pines City Website');
add_link(10428, 'http://en.wikipedia.org/wiki/Pembroke_Pines,_Florida', 'Wikipedia');
---- POMPANO BEACH, Florida Broward County (Population: 99845)
add_link(10426, 'http://pompanobeachfl.gov', 'Pompano Beach City Website');
add_link(10426, 'http://en.wikipedia.org/wiki/Pompano_Beach,_Florida', 'Wikipedia');
-- North West Florida
---- ALTHA, Florida Calhoun County (Population: 536)
add_link(9290, 'http://en.wikipedia.org/wiki/Altha,_Florida', 'Wikipedia');
---- BLOUNTSTOWN, Florida Calhoun County (Population: 2514)
add_link(9293, 'http://www.blountstown.org', 'Blountstown City Website');
add_link(9293, 'http://en.wikipedia.org/wiki/Blountstown,_Florida', 'Wikipedia');
---- CLARKSVILLE, Florida Calhoun County (Population: )
---- WEWAHITCHKA, Florida Calhoun County (Population: 1981)
add_link(9312, 'http://www.cityofwewahitchka.com', 'Wewahitchka City Website');
add_link(9312, 'http://en.wikipedia.org/wiki/Wewahitchka,_Florida', 'Wikipedia');
-- South West Florida
---- EL JOBEAN, Florida Charlotte County (Population: )
add_link(12283, 'http://en.wikipedia.org/wiki/El_Jobean,_Florida', 'Wikipedia');
---- ENGLEWOOD, Florida Charlotte County (Population: 14863)
add_link(12594, 'http://en.wikipedia.org/wiki/Englewood,_Florida', 'Wikipedia');
---- MURDOCK, Florida Charlotte County (Population: )
---- PLACIDA, Florida Charlotte County (Population: )
add_link(12292, 'http://en.wikipedia.org/wiki/Placida,_Florida', 'Wikipedia');
---- PORT CHARLOTTE, Florida Charlotte County (Population: 54392)
add_link(12294, 'http://www.charlottecountyfl.gov/Pages/default.aspx', 'Port Charlotte City Website');
add_link(12294, 'http://en.wikipedia.org/wiki/Port_Charlotte,_Florida', 'Wikiepdia');
---- PUNTA GORDA, Florida Charlotte County (Population: 16641)
add_link(12295, 'http://www.ci.punta-gorda.fl.us', 'Punta Gorda City Website');
add_link(12295, 'http://en.wikipedia.org/wiki/Punta_Gorda,_Florida', 'Wikipedia');
add_link(12295, 'http://www.puntagordachamber.com', 'Punta Gorda Chamber of Commerce');
---- ROTONDA WEST, Florida Charlotte County (Population: )
add_link(12293, 'http://www.rotondawest.org', 'Rotonda West City Website');
add_link(12293, 'http://en.wikipedia.org/wiki/Rotonda_West,_Florida', 'Wikipedia');
-- Tampa Bay region of Florida
---- BEVERLY HILLS, Florida Citrus County (Population: 8445)
add_link(12991, 'http://en.wikipedia.org/wiki/Beverly_Hills,_Florida', 'Wikipedia');
---- CRYSTAL RIVER, Florida Citrus County (Population: 3108)
add_link(12980, 'http://www.crystalriverfl.org', 'Crystal River City Website');
add_link(12980, 'http://en.wikipedia.org/wiki/Crystal_River,_Florida', 'Wikipedia');
---- DUNNELLON, Florida Citrus County (Population: 1733)
add_link(12982, 'http://www.dunnellon.org', 'Dunnellon City Website');
add_link(12982, 'http://en.wikipedia.org/wiki/Dunnellon,_Florida', 'Wikipedia');
---- FLORAL CITY, Florida Citrus County (Population: 5217)
add_link(12983, 'http://floralcityfla.com', 'Floral City Website');
add_link(12983, 'http://en.wikipedia.org/wiki/Floral_City,_Florida', 'Wikipedia');
---- HERNANDO, Florida Citrus County (Population: 9054)
add_link(12984, 'http://www.co.hernando.fl.us', 'Hernando City Website');
add_link(12984, 'http://en.wikipedia.org/wiki/Hernando,_Florida', 'Wikipedia');
---- HOLDER, Florida Citrus County (Population: )
add_link(12985, 'http://en.wikipedia.org/wiki/Holder,_Florida', 'Wikipedia');
---- HOMOSASSA, Florida Citrus County (Population: 2578)
add_link(12986, 'http://www.homosassaflorida.com', 'Homosassa City Website');
add_link(12986, 'http://en.wikipedia.org/wiki/Homosassa,_Florida', 'Wikipedia');
---- HOMOSASSA SPRINGS, Florida Citrus County (Population: 13791)
add_link(12987, 'http://www.homosassasprings.org/Homosassa.cfm', 'Homosassa Springs City Website');
add_link(12987, 'http://en.wikipedia.org/wiki/Homosassa_Springs,_Florida', 'Wikipedia');
---- INVERNESS, Florida Citrus County (Population: 7210)
add_link(12989, 'http://www.inverness-fl.gov', 'Inverness City Website');
add_link(12989, 'http://en.wikipedia.org/wiki/Inverness,_Florida', 'Wikipedia');
---- LECANTO, Florida Citrus County (Population: 5882)
add_link(12990, 'http://en.wikipedia.org/wiki/Lecanto,_Florida', 'Wikipedia');
-- North Eastern Florida
---- DOCTORS INLET, Florida Clay County (Population: )
add_link(13501, 'http://en.wikipedia.org/wiki/Doctors_Inlet,_Florida', 'Wikipedia');
---- FLEMING ISLAND, Florida Clay County (Population: 27126)
add_link(13492, 'http://flemingislandonline.net/Welcome.html', 'Flemings Island City Website');
add_link(13492, 'http://en.wikipedia.org/wiki/Fleming_Island,_Florida', 'Wikipedia');
---- GREEN COVE SPRINGS, Florida Clay County (Population: 6908)
add_link(13508, 'http://www.greencovesprings.com', 'Green Cove Springs');
add_link(13508, 'http://en.wikipedia.org/wiki/Green_Cove_Springs,_Florida', 'Wikipedia');
---- KEYSTONE HEIGHTS, Florida Clay County (Population: 1350)
add_link(9837, 'http://www.keystoneheights.us', 'Keystone Heights City Website');
add_link(9837, 'http://en.wikipedia.org/wiki/Keystone_Heights,_Florida', 'Wikipedia');
---- LAKE GENEVA, Florida Clay County (Population: )
add_link(13555, 'http://en.wikipedia.org/wiki/Lake_Geneva,_Florida', 'Wikipedia');
---- MIDDLEBURG, Florida Clay County (Population: 13008)
add_link(13511, 'http://en.wikipedia.org/wiki/Middleburg,_Florida', 'Wikipedia');
---- ORANGE PARK, Florida Clay County (Population: 8412)
add_link(13521, 'http://www.townoforangepark.com', 'Orange Park City Website');
add_link(13521, 'http://en.wikipedia.org/wiki/Orange_Park,_Florida', 'Wikipedia');
---- PENNEY FARMS, Florida Clay County (Population: 749)
add_link(13525, 'http://www.penneyfarmsfl.govoffice2.com', 'Penny Farms City Website');
add_link(13525, 'http://en.wikipedia.org/wiki/Penney_Farms,_Florida', 'Wikipedia');
-- South West Florida
---- CHOKOLOSKEE, Florida Collier County (Population: 359)
add_link(12579, 'http://www.chokoloskee.com', 'Chokoloskee City Website');
add_link(12579, 'http://www.florida-everglades.com/chokol/home.htm', 'Florida Everglades');
add_link(12579, 'http://en.wikipedia.org/wiki/Chokoloskee,_Florida', 'Wikipedia');
---- COPELAND, Florida Collier County (Population: )
add_link(12578, 'http://en.wikipedia.org/wiki/Copeland,_Florida', 'Wikipedia');
---- EVERGLADES CITY, Florida Collier County (Population: 400)
add_link(12580, 'http://www.florida-everglades.com/evercty/', 'Everglades City Website');
add_link(12580, 'http://en.wikipedia.org/wiki/Everglades,_Florida', 'Wikipedia');
---- GOODLAND, Florida Collier County (Population: 267)
add_link(12581, 'http://www.goodland.com', 'Goodland City Website');
add_link(12581, 'http://en.wikipedia.org/wiki/Goodland,_Florida', 'Wikipedia');
---- IMMOKALEE, Florida Collier County (Population: 24154)
add_link(12583, 'http://en.wikipedia.org/wiki/Immokalee,_Florida', 'Wikipedia');
---- MARCO ISLAND, Florida Collier County (Population: 16413)
add_link(12584, 'http://www.cityofmarcoisland.com', 'Marco Island City Website');
add_link(12584, 'http://www.marco-island-florida.com', 'Marco Island Forida');
add_link(12584, 'http://en.wikipedia.org/wiki/Marco_Island,_Florida', 'Wikipedia');
---- NAPLES, Florida Collier County (Population: 19537)
add_link(12575, 'http://www.naplesgov.com', 'Naples City Website');
add_link(12575, 'http://www.naples-florida.com', 'Naples Florida');
add_link(12575, 'http://en.wikipedia.org/wiki/Naples,_Florida', 'Wikipedia');
---- VANDERBILT BEACH, Florida Collier County (Population: )
add_link(12576, 'http://en.wikipedia.org/wiki/Vanderbilt_Beach,_Florida', 'Wikipedia');
-- North Central Florida
---- FORT WHITE, Florida Columbia County (Population: 567)
add_link(13504, 'http://townoffortwhitefl.com', 'Fort White City Website');
add_link(13504, 'http://en.wikipedia.org/wiki/Fort_White,_Florida', 'Wikipedia');
---- LAKE CITY, Florida Columbia County (Population: 12046)
add_link(13499, 'http://www.lcfla.com', 'Lake City Website');
add_link(13499, 'http://en.wikipedia.org/wiki/Lake_City,_Florida', 'Wikipedia');
---- LULU, Florida Columbia County (Population: )
add_link(13518, 'http://en.wikipedia.org/wiki/Lulu,_Florida', 'Wikipedia');
add_link(13518, 'http://www.ghosttowns.com/states/fl/lulu.html', 'Ghost Towns');
-- South Central Florida
---- ARCADIA, Florida Desoto County (Population: 7637)
add_link(12602, 'http://www.arcadia-fl.gov', 'Arcadia City Website');
add_link(12602, 'http://en.wikipedia.org/wiki/Arcadia,_Florida', 'Wikipedia');
---- FORT OGDEN, Florida Desoto County (Population: )
add_link(12603, 'http://en.wikipedia.org/wiki/Fort_Ogden,_Florida', 'Wikipedia');
---- NOCATEE, Florida Desoto County (Population: 4524)
add_link(12604, 'http://nocatee.com', 'Nocatee City Website');
add_link(12604, 'http://en.wikipedia.org/wiki/Nocatee_(St._Johns_County,_Florida)', 'Wikipedia');
-- North Central Florida
---- CROSS CITY, Florida Dixie County (Population: 1728)
add_link(9828, 'http://en.wikipedia.org/wiki/Cross_City,_Florida', 'Wikipedia');
---- HORSESHOE BEACH, Florida Dixie County (Population: 169)
add_link(9835, 'http://en.wikipedia.org/wiki/Horseshoe_Beach,_Florida', 'Wikipedia');
---- OLD TOWN, Florida Dixie County (Population: )
add_link(9846, 'http://en.wikipedia.org/wiki/Old_Town,_Florida', 'Wikipedia');
---- SUWANNEE, Florida Dixie County (Population: )
add_link(9850, 'http://en.wikipedia.org/wiki/Suwannee,_Florida', 'Wikipedia');
-- North Eastern Florida
---- ATLANTIC BEACH, Florida Duval County (Population: 12655)
add_link(9575, 'http://www.coab.us', 'Atlantic Beach City Website');
add_link(9575, 'http://en.wikipedia.org/wiki/Atlantic_Beach,_Florida', 'Wikipedia');
---- JACKSONVILLE, Florida Duval County (Population: 821784)
add_link(9574, 'http://www.coj.net', 'Jacksonville City Website');
add_link(9574, 'http://jacksonville.com', 'The Florida Times');
add_link(9574, 'http://en.wikipedia.org/wiki/Jacksonville,_Florida', 'Wikipedia');
---- JACKSONVILLE BEACH, Florida Duval County (Population: 21362)
add_link(9576, 'http://www.jacksonvillebeach.org', 'Jacksonville Beach City Website');
add_link(9576, 'http://en.wikipedia.org/wiki/Jacksonville_Beach,_Florida', 'Wikipedia');
---- NEPTUNE BEACH, Florida Duval County (Population: 7037)
add_link(9579, 'http://ci.neptune-beach.fl.us', '');
add_link(9579, 'http://en.wikipedia.org/wiki/Neptune_Beach,_Florida', 'Wikipedia');
-- North West Florida
---- CANTONMENT, Florida Escambia County (Population: )
add_link(9327, 'http://en.wikipedia.org/wiki/Cantonment,_Florida', 'Wikipedia');
---- CENTURY, Florida Escambia County (Population: 1698)
add_link(9328, 'http://www.centuryflorida.com/', 'Century City Website');
add_link(9328, 'http://en.wikipedia.org/wiki/Century,_Florida', 'Wikipedia');
---- GONZALEZ, Florida Escambia County (Population: 13273)
add_link(9337, 'http://en.wikipedia.org/wiki/Gonzalez,_Florida', 'Wikipedia');
---- MC DAVID, Florida Escambia County (Population: )
add_link(9343, 'http://en.wikipedia.org/wiki/McDavid,_Florida', 'Wikipedia');
---- MOLINO, Florida Escambia County (Population: 1277)
add_link(9346, 'http://en.wikipedia.org/wiki/Molino,_Florida', 'Wikipedia');
---- PENSACOLA, Florida Escambia County (Population: 51923)
add_link(9324, 'http://www.cityofpensacola.com/', 'Pensacola City Website');
add_link(9324, 'http://www.visitpensacola.com/', 'Visit Pensacola');
add_link(9324, 'http://en.wikipedia.org/wiki/Pensacola,_Florida', 'Wikipedia');
-- North Eastern Florida
---- BUNNELL, Florida Flagler County (Population: 2676)
add_link(13534, 'http://www.bunnellcity.us/', 'Bunnell City Website');
add_link(13534, 'http://en.wikipedia.org/wiki/Bunnell,_Florida', 'Wikipedia');
---- FLAGLER BEACH, Florida Flagler County (Population: 4484)
add_link(13545, 'http://www.cityofflaglerbeach.com/', 'Flagler Beach City Website');
add_link(13545, 'http://en.wikipedia.org/wiki/Flagler_Beach,_Florida', 'Wikipedia');
---- PALM COAST, Florida Flagler County (Population: 75180)
add_link(13544, 'http://www.palmcoastgov.com/', 'Palm Coast City Website');
add_link(13544, 'http://en.wikipedia.org/wiki/Palm_Coast,_Florida', 'Wikipedia');
-- North West Florida
---- APALACHICOLA, Florida Franklin County (Population: 2231)
add_link(9580, 'http://www.cityofapalachicola.com/', 'Apalachicola City Website');
add_link(9580, 'http://en.wikipedia.org/wiki/Apalachicola,_Florida', 'Wikiepdia');
---- CARRABELLE, Florida Franklin County (Population: 2778)
add_link(9582, 'http://mycarrabelle.com/', 'Carrabelle City Website' );
add_link(9582, 'http://en.wikipedia.org/wiki/Carrabelle,_Florida', 'Wikipedia');
---- EASTPOINT, Florida Franklin County (Population: 2337)
add_link(9586, 'http://en.wikipedia.org/wiki/Eastpoint,_Florida', 'Wikipedia');
---- LANARK VILLAGE, Florida Franklin County (Population: )
add_link(9583, 'http://en.wikipedia.org/wiki/Lanark_Village,_Florida', 'Wikipedia');
---- CHATTAHOOCHEE, Florida Gadsden County (Population: 3652)
add_link(9584, 'http://www.cityofchattahoochee.com/', 'Chattahoochee City Website');
add_link(9584, 'http://en.wikipedia.org/wiki/Chattahoochee,_Florida', 'Chattahoochee');
---- GREENSBORO, Florida Gadsden County (Population: 602)
add_link(9587, 'http://en.wikipedia.org/wiki/Greensboro,_Florida', 'Wikiepdia');
---- GRETNA, Florida Gadsden County (Population: 1460)
add_link(9589, 'http://www.mygretna.net/', 'Gretna City Website');
add_link(9589, 'http://en.wikipedia.org/wiki/Gretna,_Florida', 'Wikipedia');
---- HAVANA, Florida Gadsden County (Population: 1754)
add_link(9590, 'http://www.townofhavana.com/', 'Havana City Website');
add_link(9590, 'http://havanaflorida.com/', 'Havana Forida');
add_link(9590, 'http://en.wikipedia.org/wiki/Havana,_Florida', 'Wikipedia');
---- MIDWAY, Florida Gadsden County (Population: 1705)
add_link(9596, 'http://www.mymidwayfl.com/', 'Midway City Website');
add_link(9596, 'http://en.wikipedia.org/wiki/Midway,_Florida', 'Wikipedia');
---- QUINCY, Florida Gadsden County (Population: 7972)
add_link(9276, 'http://www.myquincy.net/i/', 'Quincy City Website');
add_link(9276, 'http://en.wikipedia.org/wiki/Quincy,_Florida', 'Wikipedia');
-- North Central Florida
---- BELL, Florida Gilchrist County (Population: 456)
add_link(9823, 'http://www.townofbellflorida.com/', 'Bell City Website');
add_link(9823, 'http://en.wikipedia.org/wiki/Bell,_Florida', 'Wikipedia');
---- TRENTON, Florida Gilchrist County (Population: 1999)
add_link(9851, 'http://www.trentonflorida.org/', 'Trenton City Website');
add_link(9851, 'http://en.wikipedia.org/wiki/Trenton,_Florida', 'Wikipedia');
-- South Central Florida
---- MOORE HAVEN, Florida Glades County (Population: 1680)
add_link(11571, 'http://www.moorehaven.org/', 'Moore Haven City Website');
add_link(11571, 'http://en.wikipedia.org/wiki/Moore_Haven,_Florida', 'Wikipedia');
---- PALMDALE, Florida Glades County (Population: )
add_link(12290, 'http://en.wikipedia.org/wiki/Palmdale,_Florida', 'Wikipedia');
-- North West Florida
---- PORT SAINT JOE, Florida Gulf County (Population: 3445)
add_link(9315, 'http://www.cityofportstjoe.com/', 'Port St. Joe City Website');
add_link(9315, 'http://en.wikipedia.org/wiki/Port_St._Joe,_Florida', 'Wikipedia');
---- WEWAHITCHKA, Florida Gulf County (Population: 1981)
add_link(9322, 'http://www.cityofwewahitchka.com/', 'Wewahitchka City Website');
add_link(9322, 'http://en.wikipedia.org/wiki/Wewahitchka,_Florida', 'Wikipedia');
-- North Central Florida
---- JASPER, Florida Hamilton County (Population: 4546)
add_link(13512, 'http://www.jasperflonline.com/', 'Jasper City Website');
add_link(13512, 'http://en.wikipedia.org/wiki/Jasper,_Florida', 'Wikipedia');
---- JENNINGS, Florida Hamilton County (Population: 878)
add_link(13513, 'http://en.wikipedia.org/wiki/Jennings,_Florida', 'Wikipedia');
---- WHITE SPRINGS, Florida Hamilton County (Population: 777)
add_link(13531, 'http://whitesprings.org/', 'White Springs City Website');
add_link(13531, 'http://en.wikipedia.org/wiki/White_Springs,_Florida', 'Wikipedia');
-- South Central Florida
---- BOWLING GREEN, Florida Hardee County (Population: 2930)
add_link(12244, 'www.bowlinggreenfl.org/‎', 'Bowling Green City Website');
add_link(12244, 'http://en.wikipedia.org/wiki/Bowling_Green,_Florida', 'Wikipedia');
---- ONA, Florida Hardee County (Population: 314)
add_link(12268, 'http://en.wikipedia.org/wiki/Ona,_Florida', 'Ona City Website');
---- WAUCHULA, Florida Hardee County (Population: 5001)
add_link(12272, 'http://www.cityofwauchula.com/Pages/index', 'Wauchula City Website');
add_link(12272, 'http://en.wikipedia.org/wiki/Wauchula,_Florida', 'Wikipedia');
---- ZOLFO SPRINGS, Florida Hardee County (Population: 1827)
add_link(12275, 'http://www.townofzolfo.com/', 'Zolfo Springs City Website');
add_link(12275, 'http://en.wikipedia.org/wiki/Zolfo_Springs,_Florida', 'Wikipedia');
---- CLEWISTON, Florida Hendry County (Population: 7155)
add_link(11563, 'http://www.clewiston-fl.gov/', 'Clewiston City Website');
add_link(11563, 'http://en.wikipedia.org/wiki/Clewiston,_Florida', 'Wikipedia');
---- FELDA, Florida Hendry County (Population: )
add_link(12285, 'http://en.wikipedia.org/wiki/Felda,_Florida', 'Wikipedia');
---- LABELLE, Florida Hendry County (Population: 4640)
add_link(12287, 'http://www.citylabelle.com/', 'LaBelle City Website');
add_link(12287, 'http://en.wikipedia.org/wiki/LaBelle,_Florida', 'Wikipedia');
-- Tampa Bay region of Florida
---- BROOKSVILLE, Florida Hernando County (Population: 7719)
add_link(12997, 'http://www.ci.brooksville.fl.us/', 'Brooksville City Website');
add_link(12997, 'http://en.wikipedia.org/wiki/Brooksville,_Florida', 'Wikipedia');
---- ISTACHATTA, Florida Hernando County (Population: 116)
add_link(13000, 'http://en.wikipedia.org/wiki/Istachatta,_Florida', 'Wikipedia');
---- NOBLETON, Florida Hernando County (Population: 282)
add_link(13004, 'http://en.wikipedia.org/wiki/Nobleton,_Florida', 'Wikipeida');
---- SPRING HILL, Florida Hernando County (Population: 98621)
add_link(12998, 'http://en.wikipedia.org/wiki/Spring_Hill,_Florida', 'Wikipeida');
-- South Central Florida
---- AVON PARK, Florida Highlands County (Population: 8836)
add_link(12241, 'http://avonpark.cc/', 'Avon Park City Website');
add_link(12241, 'http://en.wikipedia.org/wiki/Avon_Park,_Florida', 'Wikipedia');
---- LAKE PLACID, Florida Highlands County (Population: 2223)
add_link(12259, 'http://www.lakeplacidfl.net/', 'Lake Placid City Website');
add_link(12259, 'http://en.wikipedia.org/wiki/Lake_Placid,_Florida', 'Wikipedia');
---- LORIDA, Florida Highlands County (Population: )
add_link(12264, 'http://en.wikipedia.org/wiki/Lorida,_Florida', 'Wikiepdia');
---- SEBRING, Florida Highlands County (Population: 10491)
add_link(12271, 'http://www.mysebring.com/', 'Sebring City Website');
add_link(12271, 'http://en.wikipedia.org/wiki/Sebring,_Florida', 'Wikipedia');
add_link(12271, 'http://www.sebringraceway.com/', 'Sebring Raceway');
---- VENUS, Florida Highlands County (Population: )
add_link(12574, 'http://en.wikipedia.org/wiki/Venus,_Florida', 'Wikiepdia');
-- Tampa Bay region of Florida
---- APOLLO BEACH, Florida Hillsborough County (Population: 14055)
add_link(11597, 'http://en.wikipedia.org/wiki/Apollo_Beach,_Florida', 'Wikipedia');
---- BALM, Florida Hillsborough County (Population: 1457)
add_link(11575, 'http://en.wikipedia.org/wiki/Balm,_Florida', 'Wikipedia');
add_link(11575, 'http://www.ghosttowns.com/states/fl/balm.html', 'Ghost Towns');
---- BRANDON, Florida Hillsborough County (Population: 103483)
add_link(11576, 'http://en.wikipedia.org/wiki/Brandon,_Florida', 'Brandon');
---- DOVER, Florida Hillsborough County (Population: 3702)
add_link(11582, 'http://en.wikipedia.org/wiki/Dover,_Florida', 'Wikipedia');
---- DURANT, Florida Hillsborough County (Population: )
---- GIBSONTON, Florida Hillsborough County (Population: 14234)
add_link(11584, 'http://en.wikipedia.org/wiki/Gibsonton,_Florida', 'Wikipedia');
---- LITHIA, Florida Hillsborough County (Population: )
add_link(11589, 'http://en.wikipedia.org/wiki/Lithia,_Florida', 'Wikipedia');
---- LUTZ, Florida Hillsborough County (Population: 19344)
add_link(11590, 'http://en.wikipedia.org/wiki/Lutz,_Florida', 'Wikipedia');
---- MANGO, Florida Hillsborough County (Population: 11313)
add_link(11591, 'http://en.wikipedia.org/wiki/Mango,_Florida', 'Wikipedia');
---- ODESSA, Florida Hillsborough County (Population: 7267)
add_link(11592, 'http://www.fivay.org/odessa.html', 'History of Odessa');
add_link(11592, 'http://en.wikipedia.org/wiki/Odessa,_Florida', 'Wikipedia');
---- PLANT CITY, Florida Hillsborough County (Population: 34721)
add_link(11593, 'http://www.plantcitygov.com/', 'Plant City Website');
add_link(11593, 'http://en.wikipedia.org/wiki/Plant_City,_Florida', 'Wikipedia');
---- RIVERVIEW, Florida Hillsborough County (Population: 71050)
add_link(11594, 'http://en.wikipedia.org/wiki/Riverview,_Hillsborough_County,_Florida', 'Wikiepdia');
---- RUSKIN, Florida Hillsborough County (Population: 17208)
add_link(11595, 'http://en.wikipedia.org/wiki/Ruskin,_Florida', 'Wikipedia');
---- SEFFNER, Florida Hillsborough County (Population: 7579)
add_link(11600, 'http://en.wikipedia.org/wiki/Seffner,_Florida', 'Wikipedia');
---- SUN CITY, Florida Hillsborough County (Population: )
---- SUN CITY CENTER, Florida Hillsborough County (Population: 19258)
add_link(11596, 'http://suncitycenter.org/', 'Sun City Center City Website');
add_link(11596, 'http://en.wikipedia.org/wiki/Sun_City_Center,_Florida', 'Wikipedia');
---- SYDNEY, Florida Hillsborough County (Population: )
---- TAMPA, Florida Hillsborough County (Population: 335709)
add_link(11952, 'http://www.tampagov.net/', 'Tampa City Website');
add_link(11952, 'http://www.visittampabay.com/', 'Visit Tampa');
add_link(11952, 'http://en.wikipedia.org/wiki/Tampa,_Florida', 'Wikipedia');
---- THONOTOSASSA, Florida Hillsborough County (Population: 13014)
add_link(11604, 'http://en.wikipedia.org/wiki/Thonotosassa,_Florida', 'Wikipedia');
---- VALRICO, Florida Hillsborough County (Population: 35545)
add_link(11606, 'http://en.wikipedia.org/wiki/Valrico,_Florida', 'Wikipedia');
---- WIMAUMA, Florida Hillsborough County (Population: 6373)
add_link(11951, 'http://en.wikipedia.org/wiki/Wimauma,_Florida', 'Wikipedia');
-- North West Florida
---- BONIFAY, Florida Holmes County (Population: 2793)
add_link(9294, 'http://www.cityofbonifayflorida.com/', 'Bonifay City Website');
add_link(9294, 'http://en.wikipedia.org/wiki/Bonifay,_Florida', 'Wikipedia');
---- NOMA, Florida Holmes County (Population: 211)
add_link(9313, 'http://en.wikipedia.org/wiki/Noma,_Florida', 'Wikipedia');
---- WESTVILLE, Florida Holmes County (Population: 289)
add_link(9321, 'http://en.wikipedia.org/wiki/Westville,_Florida', 'Wikipedia');
-- South East Florida
---- FELLSMERE, Florida Indian River County (Population: 5197)
add_link(10133, 'http://www.cityoffellsmere.org/', 'Fellsmere City Website');
add_link(10133, 'http://en.wikipedia.org/wiki/Fellsmere,_Florida', 'Wikipedia');
---- ROSELAND, Florida Indian River County (Population: 1472)
add_link(10139, 'http://en.wikipedia.org/wiki/Roseland,_Florida', 'Wikipedia');
---- SEBASTIAN, Florida Indian River County (Population: 21929)
add_link(10140, 'http://www.cityofsebastian.org/', 'Sebastian City Website');
add_link(10140, 'http://en.wikipedia.org/wiki/Sebastian,_Florida', 'Wikipedia');
---- VERO BEACH, Florida Indian River County (Population: 15220)
add_link(10142, 'http://www.covb.org/', 'Vero Beach City Website');
add_link(10142, 'http://www.verobeach.com/', 'Vero Beach Florida');
add_link(10142, 'http://en.wikipedia.org/wiki/Vero_Beach,_Florida', 'Wikipedia');
---- WABASSO, Florida Indian River County (Population: 609)
add_link(10143, 'http://en.wikipedia.org/wiki/Wabasso,_Florida', 'Wikipedia');
---- WINTER BEACH, Florida Indian River County (Population: 2067)
add_link(10144, 'http://en.wikipedia.org/wiki/Winter_Beach,_Florida', 'Wikipedia');
-- North West Florida
---- ALFORD, Florida Jackson County (Population: 489)
add_link(9289, 'http://en.wikipedia.org/wiki/Alford,_Florida', 'Wikipedia');
---- BASCOM, Florida Jackson County (Population: 121)
add_link(9292, 'http://en.wikipedia.org/wiki/Bascom,_Florida', 'Wikipedia');
---- CAMPBELLTON, Florida Jackson County (Population: 230)
add_link(9295, 'http://en.wikipedia.org/wiki/Campbellton,_Florida', 'Wikipedia');
---- COTTONDALE, Florida Jackson County (Population: 933)
add_link(9299, 'http://en.wikipedia.org/wiki/Cottondale,_Florida', 'Wikipedia');
---- CYPRESS, Florida Jackson County (Population: )
add_link(9300, 'http://en.wikipedia.org/wiki/Cypress,_Florida', 'Wikipedia');
---- GRACEVILLE, Florida Jackson County (Population: 2278)
add_link(9306, 'http://en.wikipedia.org/wiki/Graceville,_Florida', 'Wikipedia');
---- GRAND RIDGE, Florida Jackson County (Population: 892)
add_link(9307, 'http://en.wikipedia.org/wiki/Grand_Ridge,_Florida', 'Wikipedia');
---- GREENWOOD, Florida Jackson County (Population: 686)
add_link(9308, 'http://townofgreenwood.org/', 'Greenwood City Website');
add_link(9308, 'http://en.wikipedia.org/wiki/Greenwood,_Florida', 'Wikipedia');
---- MALONE, Florida Jackson County (Population: 2088)
add_link(9310, 'http://en.wikipedia.org/wiki/Malone,_Florida', 'Wikipedia');
---- MARIANNA, Florida Jackson County (Population: 6102)
add_link(9311, 'http://www.cityofmarianna.com/', 'Marianna City Website');
add_link(9311, 'http://en.wikipedia.org/wiki/Marianna,_Florida', 'Wikipedia');
---- SNEADS, Florida Jackson County (Population: 1849)
add_link(9317, 'http://www.sneadsfl.com/', 'Sneads City Website');
add_link(9317, 'http://en.wikipedia.org/wiki/Sneads,_Florida', 'Wikipedia');
---- LAMONT, Florida Jefferson County (Population: 178)
add_link(9593, 'http://en.wikipedia.org/wiki/Lamont,_Florida', 'Wikipedia');
---- LLOYD, Florida Jefferson County (Population: 215)
add_link(9594, 'http://en.wikipedia.org/wiki/Lloyd,_Florida', 'Wikipedia');
---- MONTICELLO, Florida Jefferson County (Population: 2506)
add_link(9597, 'http://www.cityofmonticello.us/', 'Monticello City Website');
add_link(9597, 'http://en.wikipedia.org/wiki/Monticello,_Florida', 'Wikipedia');
---- WACISSA, Florida Jefferson County (Population: 386)
add_link(9283, 'http://en.wikipedia.org/wiki/Wacissa,_Florida', 'Wikipedia');
-- North Central Florida
---- DAY, Florida Lafayette County (Population: 116)
add_link(13498, 'http://en.wikipedia.org/wiki/Day,_Florida', 'Wikipedia');
---- MAYO, Florida Lafayette County (Population: 1237)
add_link(13522, 'http://en.wikipedia.org/wiki/Mayo,_Florida', 'Wikipedia');
-- East Central Florida
---- ALTOONA, Florida Lake County (Population: 89)
add_link(9856, 'http://en.wikipedia.org/wiki/Altoona,_Florida', 'Wikipedia');
---- ASTATULA, Florida Lake County (Population: 1810)
add_link(13016, 'http://townofastatula.com/docs/', 'Astatula City Website');
add_link(13016, 'http://en.wikipedia.org/wiki/Astatula,_Florida', 'Wikipedia');
---- ASTOR, Florida Lake County (Population: 1556)
add_link(13532, 'http://en.wikipedia.org/wiki/Astor,_Florida', 'Wikipedia');
---- CLERMONT, Florida Lake County (Population: 28742)
add_link(13017, 'http://www.cityofclermontfl.com/', 'Clermont City Website');
add_link(13017, 'http://en.wikipedia.org/wiki/Clermont,_Florida', 'Wikipedia');
---- EUSTIS, Florida Lake County (Population: 18558)
add_link(9867, 'http://www.eustis.org/', 'Eustis City Website');
add_link(9867, 'http://en.wikipedia.org/wiki/Eustis,_Florida', 'Wikipedia');
---- FERNDALE, Florida Lake County (Population: 472)
add_link(13018, 'http://en.wikipedia.org/wiki/Ferndale,_Florida', 'Wikipedia');
---- FRUITLAND PARK, Florida Lake County (Population: 4078)
add_link(13019, 'http://www.fruitlandpark.org/', 'Fruitland Park City Website');
add_link(13019, 'http://en.wikipedia.org/wiki/Fruitland_Park,_Florida', 'Wikipedia');
---- GRAND ISLAND, Florida Lake County (Population: )
add_link(9870, 'http://en.wikipedia.org/wiki/Grand_Island,_Florida', 'Wikipedia');
---- GROVELAND, Florida Lake County (Population: 8729)
add_link(13021, 'http://groveland-fl.gov/', 'Groveland City Website');
add_link(13021, 'http://en.wikipedia.org/wiki/Groveland,_Florida', 'Wikipedia');
---- HOWEY IN THE HILLS, Florida Lake County (Population: 1098)
add_link(13022, 'http://www.howey.org/', 'Howey in the Hills City Website');
add_link(13022, 'http://en.wikipedia.org/wiki/Howey-in-the-Hills,_Florida', 'Wikipedia');
---- LADY LAKE, Florida Lake County (Population: 13926)
add_link(13554, 'http://www.ladylake.org/', 'Lady Lake City Website');
add_link(13554, 'http://en.wikipedia.org/wiki/Lady_Lake,_Florida', 'Wikipedia');
---- LEESBURG, Florida Lake County (Population: 20117)
add_link(13026, 'http://www.leesburgflorida.gov/', 'Leesburg City Website');
add_link(13026, 'http://en.wikipedia.org/wiki/Leesburg,_Florida', 'Wikipedia');
---- MASCOTTE, Florida Lake County (Population: 5101)
add_link(13027, 'http://www.cityofmascotte.com/', 'Mascotte City Website');
add_link(13027, 'http://en.wikipedia.org/wiki/Mascotte,_Florida', 'Wikipedia');
---- MINNEOLA, Florida Lake County (Population: 9403)
add_link(13028, 'http://www.minneola.us/', 'Minneola City Website');
add_link(13028, 'http://en.wikipedia.org/wiki/Minneola,_Florida', 'Wikipedia');
---- MONTVERDE, Florida Lake County (Population: 1463)
add_link(13029, 'http://www.mymontverde.com/', 'Montverde City Website');
add_link(13029, 'http://en.wikipedia.org/wiki/Montverde,_Florida', 'Wikipedia');
---- MOUNT DORA, Florida Lake County (Population: 12370)
add_link(9878, 'http://ci.mount-dora.fl.us/', 'Mount Dora City Website');
add_link(9878, 'http://en.wikipedia.org/wiki/Mount_Dora,_Florida', 'Wikipedia');
---- OKAHUMPKA, Florida Lake County (Population: 267)
add_link(13033, 'http://en.wikipedia.org/wiki/Okahumpka,_Florida', 'Wikipedia');
---- PAISLEY, Florida Lake County (Population: 818)
add_link(9883, 'http://en.wikipedia.org/wiki/Paisley,_Florida', 'Wikipedia');
---- SORRENTO, Florida Lake County (Population: 861)
add_link(9887, 'http://en.wikipedia.org/wiki/Sorrento,_Florida', 'Wikipedia');
---- TAVARES, Florida Lake County (Population: 13951)
add_link(9889, 'http://www.tavares.org/', 'Tavares City Website');
add_link(9889, 'http://en.wikipedia.org/wiki/Tavares,_Florida', 'Wikipedia');
---- UMATILLA, Florida Lake County (Population: 3456)
add_link(9891, 'http://www.umatillafl.org/Pages/index', 'Umatilla City Website');
add_link(9891, 'http://en.wikipedia.org/wiki/Umatilla,_Florida', 'Wikipedia');
---- YALAHA, Florida Lake County (Population: 1364)
add_link(13038, 'http://en.wikipedia.org/wiki/Yalaha,_Florida', 'Wikipedia');
-- South West Florida
---- ALVA, Florida Lee County (Population: 2596)
add_link(12279, 'http://en.wikipedia.org/wiki/Alva,_Florida', 'Wikipedia');
---- BOCA GRANDE, Florida Lee County (Population: )
add_link(12280, 'http://en.wikipedia.org/wiki/Boca_Grande,_Florida', 'Wikipedia');
---- BOKEELIA, Florida Lee County (Population: 1780)
add_link(12281, 'http://en.wikipedia.org/wiki/Bokeelia,_Florida', 'Wikipedia');
---- BONITA SPRINGS, Florida Lee County (Population: 43914)
add_link(12577, 'http://www.cityofbonitasprings.org/', 'Bonita Springs City Website');
add_link(12577, 'http://en.wikipedia.org/wiki/Bonita_Springs,_Florida', 'Wikipedia');
---- CAPE CORAL, Florida Lee County (Population: 154305)
add_link(12278, 'http://www.capecoral.net/', 'Cape Coral City Website');
add_link(12278, 'http://en.wikipedia.org/wiki/Cape_Coral,_Florida', 'Wikipedia');
---- CAPTIVA, Florida Lee County (Population: 583)
add_link(12282, 'http://en.wikipedia.org/wiki/Captiva,_Florida', 'Wikipedia');
---- ESTERO, Florida Lee County (Population: 22612)
add_link(12284, 'http://en.wikipedia.org/wiki/Estero,_Florida', 'Wikipedia');
add_link(12284, 'http://esterochamber.org/', 'Estero Chamber of Commerce');
---- FORT MYERS, Florida Lee County (Population: 62298)
add_link(12276, 'http://www.cityftmyers.com/', 'Fort Myers City Website');
add_link(12276, 'http://en.wikipedia.org/wiki/Fort_Myers,_Florida', 'Wikipedia');
---- FORT MYERS BEACH, Florida Lee County (Population: 6277)
add_link(12286, 'http://www.fortmyersbeachfl.gov/', 'Fort Myers Beach City Website');
add_link(12286, 'http://en.wikipedia.org/wiki/Fort_Myers_Beach,_Florida', 'Wikipedia');
---- LEHIGH ACRES, Florida Lee County (Population: 86784)
add_link(12288, 'http://en.wikipedia.org/wiki/Lehigh_Acres,_Florida', 'Wikipedia');
---- NORTH FORT MYERS, Florida Lee County (Population: 39407)
add_link(12277, 'http://en.wikipedia.org/wiki/North_Fort_Myers,_Florida', 'Wikipedia');
add_link(12277, 'http://www.nfmchamber.org/', 'North Fort Myers Chamber of Commerce');
---- PINELAND, Florida Lee County (Population: 407)
add_link(12291, 'http://en.wikipedia.org/wiki/Pineland,_Florida', 'Wikipedia');
---- SAINT JAMES CITY, Florida Lee County (Population: 3784)
add_link(12572, 'http://saintjamescity.org/', 'Saint James City Website');
add_link(12572, 'http://en.wikipedia.org/wiki/St._James_City,_Florida', 'Wikipedia');
---- SANIBEL, Florida Lee County (Population: 6469)
add_link(12573, 'http://www.mysanibel.com/', 'Sanibel City Website');
add_link(12573, 'http://en.wikipedia.org/wiki/Sanibel,_Florida', 'Wikipedia');
-- North West Florida
---- TALLAHASSEE, Florida Leon County (Population: 181376)
add_link(9285, 'http://www.talgov.com/Main/Home.aspx', 'Tallahassee City Website');
add_link(9285, 'http://www.fsu.edu/', 'Florida State University');
add_link(9285, 'http://en.wikipedia.org/wiki/Tallahassee,_Florida', 'Wikipedia');
---- WOODVILLE, Florida Leon County (Population: 2978)
add_link(9284, 'http://en.wikipedia.org/wiki/Woodville,_Florida', 'Wikipedia');
-- North Central Florida
---- BRONSON, Florida Levy County (Population: 1113)
add_link(9824, 'http://townofbronson.com/', 'Bronson City Website');
add_link(9824, 'http://en.wikipedia.org/wiki/Bronson,_Florida', 'Wikipedia');
---- CEDAR KEY, Florida Levy County (Population: 702)
add_link(9826, 'http://www.cedarkey.org/', 'Cedar Key Chamber of Commerce');
add_link(9826, 'http://en.wikipedia.org/wiki/Cedar_Key,_Florida', 'Wikipedia');
---- CHIEFLAND, Florida Levy County (Population: 2245)
add_link(9827, 'http://www.chiefland.govoffice.com/', 'Chiefland City Website');
add_link(9827, 'http://en.wikipedia.org/wiki/Chiefland,_Florida', 'Wikipedia');
---- GULF HAMMOCK, Florida Levy County (Population: )
add_link(9832, 'http://en.wikipedia.org/wiki/Gulf_Hammock,_Florida', 'Wikipedia');
---- INGLIS, Florida Levy County (Population: 1325)
add_link(12988, 'http://townofinglis.org/', 'Inglis City Website');
add_link(12988, 'http://en.wikipedia.org/wiki/Inglis,_Florida', 'Wikiepdia');
---- MORRISTON, Florida Levy County (Population: 164)
add_link(9844, 'http://en.wikipedia.org/wiki/Morriston,_Florida', 'Wikipedia');
---- OTTER CREEK, Florida Levy County (Population: 134)
add_link(9848, 'http://en.wikipedia.org/wiki/Otter_Creek,_Florida', 'Wikipedia');
---- WILLISTON, Florida Levy County (Population: 2768)
add_link(9853, 'http://www.willistonfl.com/index_city.html', 'Willison City Website');
add_link(9853, 'http://en.wikipedia.org/wiki/Williston,_Florida', 'Wikipedia');
---- YANKEETOWN, Florida Levy County (Population: 502)
add_link(12996, 'http://www.yankeetownfl.govoffice2.com/', 'Yankeetown City Website');
add_link(12996, 'http://www.yankeetownflorida.com/', 'Yankeetown Florida');
add_link(12996, 'http://en.wikipedia.org/wiki/Yankeetown,_Florida', 'Wikipedia');
-- North West Florida
---- BRISTOL, Florida Liberty County (Population: 996)
add_link(9581, 'http://www.cityofbristolflorida.org/', 'Bristol City Website');
add_link(9581, 'http://en.wikipedia.org/wiki/Bristol,_Florida', 'Wikipedia');
---- HOSFORD, Florida Liberty County (Population: 650)
add_link(9591, 'http://en.wikipedia.org/wiki/Hosford,_Florida', 'Wikipedia');
---- SUMATRA, Florida Liberty County (Population: 148)
add_link(9592, 'http://en.wikipedia.org/wiki/Sumatra,_Florida', 'Wikipedia');
---- TELOGIA, Florida Liberty County (Population: )
-- North Central Florida
---- GREENVILLE, Florida Madison County (Population: 843)
add_link(9588, 'http://www.mygreenvillefl.com/', 'Greenville City Website');
add_link(9588, 'http://en.wikipedia.org/wiki/Greenville,_Florida', 'Wikipedia');
---- LEE, Florida Madison County (Population: 352)
add_link(13516, 'http://www.leeflorida.org/', 'Lee City Website' );
add_link(13516, 'http://en.wikipedia.org/wiki/Lee,_Florida', 'Wikipedia');
---- MADISON, Florida Madison County (Population: 2843)
add_link(9595, 'http://www.cityofmadisonfl.com/', 'Madison City Website');
add_link(9595, 'http://en.wikipedia.org/wiki/Madison,_Florida', 'Wikipedia');
---- PINETTA, Florida Madison County (Population: )
-- Tampa Bay region of Florida
---- ANNA MARIA, Florida Manatee County (Population: 1503)
add_link(12587, 'http://www.cityofannamaria.com/', 'Anne Maria City Website');
add_link(12587, 'http://en.wikipedia.org/wiki/Anna_Maria,_Florida', 'Wikipedia');
---- BRADENTON, Florida Manatee County (Population: 49546)
add_link(12585, 'http://www.cityofbradenton.com/', 'Bradenton City Website');
add_link(12585, 'http://en.wikipedia.org/wiki/Bradenton,_Florida', 'Wikipedia');
---- BRADENTON BEACH, Florida Manatee County (Population: 1171)
add_link(12588, 'http://www.cityofbradentonbeach.com/', 'Bradenton Beach City Website');
add_link(12588, 'http://en.wikipedia.org/wiki/Bradenton_Beach,_Florida', 'Wikipedia');
---- CORTEZ, Florida Manatee County (Population: 4241)
add_link(12586, 'http://en.wikipedia.org/wiki/Cortez,_Florida', 'Wikipedia');
---- ELLENTON, Florida Manatee County (Population: 4275)
add_link(12592, 'http://en.wikipedia.org/wiki/Ellenton,_Florida', 'Wikipedia');
---- HOLMES BEACH, Florida Manatee County (Population: 3836)
add_link(12589, 'http://www.holmesbeachfl.org/Cities/COHB/', 'Holmes Beach City Website');
add_link(12589, 'http://en.wikipedia.org/wiki/Holmes_Beach,_Florida', 'Wikipedia');
---- LONGBOAT KEY, Florida Manatee County (Population: 6888)
add_link(12595, 'http://www.longboatkey.org/', 'Longboat Key City Website');
add_link(12595, 'http://en.wikipedia.org/wiki/Longboat_Key,_Florida', 'Wikipedia');
---- MYAKKA CITY, Florida Manatee County (Population: )
add_link(12600, 'http://www.myakkacityfl.com/', 'Myakka City Website');
add_link(12600, 'http://en.wikipedia.org/wiki/Myakka_City,_Florida', 'Wikipedia');
---- ONECO, Florida Manatee County (Population: )
add_link(12601, 'http://en.wikipedia.org/wiki/Oneco,_Florida', 'Wikipedia');
---- PALMETTO, Florida Manatee County (Population: 12606)
add_link(12591, 'http://www.palmettofl.org/', 'Palmetto City Website');
add_link(12591, 'http://en.wikipedia.org/wiki/Palmetto,_Florida', 'Wikipedia');
---- PARRISH, Florida Manatee County (Population: )
add_link(12590, 'http://www.parrishflorida.com/', 'Parrish City Website');
add_link(12590, 'http://en.wikipedia.org/wiki/Parrish,_Florida', 'Wikipedia');
---- SARASOTA, Florida Manatee County (Population: 51917)
add_link(12598, 'http://www.sarasotagov.com/', 'Sarasota City Website');
add_link(12598, 'http://en.wikipedia.org/wiki/Sarasota,_Florida', 'Wikipedia');
---- TALLEVAST, Florida Manatee County (Population: )
add_link(12605, 'http://en.wikipedia.org/wiki/Tallevast,_Florida', 'Wikipedia');
---- TERRA CEIA, Florida Manatee County (Population: )
add_link(12599, 'http://en.wikipedia.org/wiki/Terra_Ceia,_Florida', 'Wikipedia');
-- North Central Florida
---- ANTHONY, Florida Marion County (Population: )
add_link(9821, 'http://en.wikipedia.org/wiki/Anthony,_Florida', 'Wikipedia');
---- BELLEVIEW, Florida Marion County (Population: 4492)
add_link(12979, 'http://www.belleviewfl.org/Pages/default.aspx', 'City of Belleview Website');
add_link(12979, 'http://en.wikipedia.org/wiki/Belleview,_Florida', 'Wikipedia');
---- CANDLER, Florida Marion County (Population: )
add_link(13535, 'http://en.wikipedia.org/wiki/Candler,_Florida', 'Wikipedia');
---- CITRA, Florida Marion County (Population: )
add_link(13537, 'http://en.wikipedia.org/wiki/Citra,_Florida', 'Wikiepdia');
---- DUNNELLON, Florida Marion County (Population: 1733)
add_link(12981, 'http://www.dunnellon.org/', 'Dunnellon City Website');
add_link(12981, 'http://en.wikipedia.org/wiki/Dunnellon,_Florida', 'Wikipedia');
---- EASTLAKE WEIR, Florida Marion County (Population: )
add_link(13542, 'http://en.wikipedia.org/wiki/Eastlake_Weir,_Florida', 'Wikipedia');
---- FAIRFIELD, Florida Marion County (Population: )
---- FORT MC COY, Florida Marion County (Population: )
add_link(13543, 'http://en.wikipedia.org/wiki/Fort_McCoy,_Florida', 'Wikipedia');
---- LOWELL, Florida Marion County (Population: )
add_link(9840, 'http://en.wikipedia.org/wiki/Lowell,_Florida', 'Wikipedia');
---- MC INTOSH, Florida Marion County (Population: )
add_link(9841, 'http://www.townofmcintosh.org/', 'McIntosh City Website');
add_link(9841, 'http://en.wikipedia.org/wiki/McIntosh,_Florida', 'Wikipedia');
---- OCALA, Florida Marion County (Population: 56315)
add_link(12992, 'http://www.ocalafl.org/', 'Ocala City Website');
add_link(12992, 'http://en.wikipedia.org/wiki/Ocala,_Florida', 'Wikipedia');
---- OCKLAWAHA, Florida Marion County (Population: )
add_link(9562, 'http://en.wikipedia.org/wiki/Ocklawaha,_Florida', 'Wikipedia');
---- ORANGE LAKE, Florida Marion County (Population: )
add_link(9847, 'http://en.wikipedia.org/wiki/Orange_Lake,_Florida', 'Wikipedia');
---- ORANGE SPRINGS, Florida Marion County (Population: )
add_link(9565, 'http://en.wikipedia.org/wiki/Orange_Springs,_Florida', 'Wikipedia');
---- REDDICK, Florida Marion County (Population: 506)
add_link(9849, 'http://www.townofreddick.com/', 'Reddick City Website');
add_link(9849, 'http://en.wikipedia.org/wiki/Reddick,_Florida', 'Wikipedia');
---- SILVER SPRINGS, Florida Marion County (Population: 6539)
add_link(12994, 'http://en.wikipedia.org/wiki/Silver_Springs,_Florida', 'Wikipedia');
add_link(12994, 'http://www.floridastateparks.org/silversprings/default.cfm', 'Silver Springs State Park');
---- SPARR, Florida Marion County (Population: )
add_link(9570, 'http://en.wikipedia.org/wiki/Sparr,_Florida', 'Wikipedia');
---- SUMMERFIELD, Florida Marion County (Population: )
add_link(12995, 'http://en.wikipedia.org/wiki/Summerfield,_Florida', 'Wikipedia');
---- WEIRSDALE, Florida Marion County (Population: )
add_link(9572, 'http://en.wikipedia.org/wiki/Weirsdale,_Florida', 'Wikipedia');
-- South East Florida
---- HOBE SOUND, Florida Martin County (Population: 11521)
add_link(11567, 'http://en.wikipedia.org/wiki/Hobe_Sound,_Florida', 'Wikipedia');
add_link(11567, 'http://www.hobesound.org/', 'Hobe Sound Chamber of Commerce');
---- INDIANTOWN, Florida Martin County (Population: 6083)
add_link(13257, 'http://www.indiantownchamber.com/', 'Indiantown Chamber of Commerce');
add_link(13257, 'http://en.wikipedia.org/wiki/Indiantown,_Florida', 'Wikipedia');
---- JENSEN BEACH, Florida Martin County (Population: 11707)
add_link(13258, 'http://www.jensenbeach.com/', 'Jensen Beach City Website');
add_link(13258, 'http://en.wikipedia.org/wiki/Jensen_Beach,_Florida', 'Wikipedia');
---- PALM CITY, Florida Martin County (Population: 23120)
add_link(13260, 'http://www.palmcitychamber.com/', 'Palm City Chamber of Commerce');
add_link(13260, 'http://en.wikipedia.org/wiki/Palm_City,_Florida', 'Wikipedia');
---- PORT SALERNO, Florida Martin County (Population: 10091)
add_link(13261, 'http://www.portsalernoseafoodfestival.org/', 'Port Salerno Seafood Festival');
add_link(13261, 'http://en.wikipedia.org/wiki/Port_Salerno,_Florida', 'Wikipedia');
---- STUART, Florida Martin County (Population: 15593)
add_link(13262, 'http://cityofstuart.us/', 'Stuart City Website');
add_link(13262, 'http://en.wikipedia.org/wiki/Stuart,_Florida', 'Wikipedia');
---- HIALEAH, Florida Miami-Dade County (Population: 224669)
add_link(10147, 'http://www.hialeahfl.gov/index.php?lang=en', 'Hialeah City Website');
add_link(10147, 'http://en.wikipedia.org/wiki/Hialeah,_Florida', 'Wikipedia');
---- HOMESTEAD, Florida Miami-Dade County (Population: 60512)
add_link(10416, 'http://www.cityofhomestead.com/', 'Homestead City Website');
add_link(10416, 'http://www.chamberinaction.com/', 'Homestead Chamber of Commerce');
add_link(10416, 'http://en.wikipedia.org/wiki/Homestead,_Florida', 'Wikipedia');
---- KEY BISCAYNE, Florida Miami-Dade County (Population: 12344)
add_link(10658, 'http://keybiscayne.fl.gov/', 'Key Biscayne');
add_link(10658, 'http://en.wikipedia.org/wiki/Key_Biscayne,_Florida', 'Wikipedia');
---- MIAMI, Florida Miami-Dade County (Population: 399457)
add_link(10429, 'http://www.miamigov.com/home/', 'Miami City Website');
add_link(10429, 'http://www.miami-florida.com/', 'Miami Florida');
add_link(10429, 'http://en.wikipedia.org/wiki/Miami', 'Wikipedia');
---- MIAMI BEACH, Florida Miami-Dade County (Population: 87779)
add_link(10430, 'http://www.miamibeachfl.gov/', 'Miami Beach City Website');
add_link(10430, 'http://en.wikipedia.org/wiki/Miami_Beach,_Florida', 'Wikipedia');
---- NORTH MIAMI BEACH, Florida Miami-Dade County (Population: 41523)
add_link(10659, 'http://www.citynmb.com/', 'North Miami Beach City Website');
add_link(10659, 'http://en.wikipedia.org/wiki/North_Miami_Beach,_Florida', 'Wikipedia');
---- OCHOPEE, Florida Miami-Dade County (Population: )
add_link(12582, 'http://en.wikipedia.org/wiki/Ochopee,_Florida', 'Wikipedia');
---- OPA LOCKA, Florida Miami-Dade County (Population: )
add_link(10425, 'http://www.opalockafl.gov/', 'Opa-Locka City Website');
add_link(10425, 'http://en.wikipedia.org/wiki/Opa-locka,_Florida', 'Wikipedia');
---- BIG PINE KEY, Florida Monroe County (Population: 4252)
add_link(10421, 'http://www.fla-keys.com/lowerkeys/', 'The Florida Keys');
add_link(10421, 'http://en.wikipedia.org/wiki/Big_Pine_Key,_Florida', 'Wikipedia');
---- ISLAMORADA, Florida Monroe County (Population: )
add_link(10417, 'http://www.islamorada.fl.us/', 'Islamorda City Website');
add_link(10417, 'http://www.fla-keys.com/islamorada/', 'The Florida Keys');
add_link(10417, 'http://en.wikipedia.org/wiki/Islamorada,_Florida', 'Wikipedia');
---- KEY COLONY BEACH, Florida Monroe County (Population: 797)
add_link(10423, 'http://www.keycolonybeach.net/', 'Key Colony Beach City Website');
add_link(10423, 'http://en.wikipedia.org/wiki/Key_Colony_Beach,_Florida', 'Wikipedia');
---- KEY LARGO, Florida Monroe County (Population: 10433)
add_link(10418, 'http://www.keylargochamber.org/', 'Key Largo Chamber of Commerce');
add_link(10418, 'http://www.fla-keys.com/keylargo/', 'The Florida Keys');
add_link(10418, 'http://en.wikipedia.org/wiki/Key_Largo,_Florida', 'Wikipedia');
---- KEY WEST, Florida Monroe County (Population: 24649)
add_link(10419, 'www.keywestcity.com', 'Key West City Website');
add_link(10419, 'http://www.fla-keys.com/', 'The Florida Keys');
add_link(10419, 'http://en.wikipedia.org/wiki/Key_West,_Florida', 'Wikipedia');
---- LONG KEY, Florida Monroe County (Population: )
add_link(10146, 'http://www.floridastateparks.org/longkey/', 'Florida State Parks');
add_link(10146, 'http://en.wikipedia.org/wiki/Long_Key', 'Wikipedia');
---- MARATHON, Florida Monroe County (Population: 8297)
add_link(10422, 'http://www.ci.marathon.fl.us/', 'Marathon City Website');
add_link(10422, 'http://en.wikipedia.org/wiki/Marathon,_Florida', 'Wikipedia');
---- MARATHON SHORES, Florida Monroe County (Population: )
add_link(10424, 'http://en.wikipedia.org/wiki/Marathon_Shores', 'Wikipedia');
---- SUMMERLAND KEY, Florida Monroe County (Population: )
add_link(10420, 'http://en.wikipedia.org/wiki/Summerland_Key,_Florida', 'Wikipedia');
---- TAVERNIER, Florida Monroe County (Population: 2136)
add_link(10427, 'http://en.wikipedia.org/wiki/Tavernier,_Florida', 'Wikipedia');
-- North Eastern Florida
---- BRYCEVILLE, Florida Nassau County (Population: )
add_link(13496, 'http://en.wikipedia.org/wiki/Bryceville,_Florida', 'Wikipedia');
---- CALLAHAN, Florida Nassau County (Population: 1123)
add_link(13497, 'http://www.townofcallahan-fl.gov/', 'Callahan City Website');
add_link(13497, 'http://en.wikipedia.org/wiki/Callahan,_Florida', 'Wikipedia');
---- FERNANDINA BEACH, Florida Nassau County (Population: 11487)
add_link(13503, 'http://www.fbfl.us/', 'Fernandina Beach City Website');
add_link(13503, 'http://en.wikipedia.org/wiki/Fernandina_Beach,_Florida', 'Wikipedia');
---- HILLIARD, Florida Nassau County (Population: 3086)
add_link(13510, 'http://www.townofhilliard.com/', 'Hilliard City Website');
add_link(13510, 'http://en.wikipedia.org/wiki/Hilliard,_Florida', 'Wikipedia');
---- YULEE, Florida Nassau County (Population: 11491)
add_link(13506, 'http://en.wikipedia.org/wiki/Yulee,_Florida', 'Wikipedia');
-- North West Florida
---- BAKER, Florida Okaloosa County (Population: )
add_link(9326, 'http://en.wikipedia.org/wiki/Baker,_Florida', 'Wikipedia');
---- CRESTVIEW, Florida Okaloosa County (Population: 20978)
add_link(9329, 'http://www.cityofcrestview.org/', 'Crestview City Website');
add_link(9329, 'http://en.wikipedia.org/wiki/Crestview,_Florida', 'Wikipedia');
---- DESTIN, Florida Okaloosa County (Population: 12305)
add_link(9332, 'http://www.cityofdestin.com/', 'Destin City Website');
add_link(9332, 'http://www.destinflorida.org/', 'Destin Florida');
add_link(9332, 'http://en.wikipedia.org/wiki/Destin,_Florida', 'Wikipedia');
---- EGLIN AFB, Florida Okaloosa County (Population: 2274)
add_link(9333, 'http://www.eglin.af.mil/', 'Eglin AFB City Website');
add_link(9333, 'http://en.wikipedia.org/wiki/Eglin_Air_Force_Base', 'Wikipedia');
---- FORT WALTON BEACH, Florida Okaloosa County (Population: 19507)
add_link(9335, 'http://fwb.org/', 'Fort Walton Beach City Website');
add_link(9335, 'http://en.wikipedia.org/wiki/Fort_Walton_Beach,_Florida', 'Wikipedia');
add_link(9335, 'http://www.fwbchamber.org/', 'Fort Walton Beach City Website');
---- HOLT, Florida Okaloosa County (Population: )
add_link(9339, 'http://en.wikipedia.org/wiki/Holt,_Florida', 'Wikipedia');
---- HURLBURT FIELD, Florida Okaloosa County (Population: )
add_link(9334, 'http://www2.hurlburt.af.mil/', 'Hurlburt Field City Website');
add_link(9334, 'http://en.wikipedia.org/wiki/Hurlburt_Field', 'Wikipedia');
---- LAUREL HILL, Florida Okaloosa County (Population: 537)
add_link(9342, 'http://laurelhillnow.com/', 'Laurel Hill City Website');
add_link(9342, 'http://en.wikipedia.org/wiki/Laurel_Hill,_Florida', 'Wikipedia');
---- MARY ESTHER, Florida Okaloosa County (Population: 3851)
add_link(9344, 'http://www.cityofmaryesther.com/', 'Mary Esther City Website');
add_link(9344, 'http://en.wikipedia.org/wiki/Mary_Esther,_Florida', 'Wikipedia');
---- MILLIGAN, Florida Okaloosa County (Population: )
add_link(9330, 'http://en.wikipedia.org/wiki/Milligan,_Florida', 'Wikipedia');
---- NICEVILLE, Florida Okaloosa County (Population: 12749)
add_link(9347, 'http://cityofniceville.org/', 'Nicecille City Website');
add_link(9347, 'http://en.wikipedia.org/wiki/Niceville,_Florida', 'Wikipedia');
---- SHALIMAR, Florida Okaloosa County (Population: 717)
add_link(9348, 'http://www.shalimarflorida.org/', 'Shalimar City Website');
add_link(9348, 'http://en.wikipedia.org/wiki/Shalimar,_Florida', 'Wikipedia');
---- VALPARAISO, Florida Okaloosa County (Population: 5036)
add_link(9349, 'http://www.valp.org/', 'Valparaiso City Website');
add_link(9349, 'http://en.wikipedia.org/wiki/Valparaiso,_Florida', 'Wikipedia');
-- South Central Florida
---- OKEECHOBEE, Florida Okeechobee County (Population: 5621)
add_link(13259, 'http://www.cityofokeechobee.com/', 'Okeechobee City Website');
add_link(13259, 'http://en.wikipedia.org/wiki/Okeechobee,_Florida', 'Wikipedia');
-- East Central Florida
---- APOPKA, Florida Orange County (Population: 41542)
add_link(9857, 'http://www.apopka.net/', 'Apopka City Website');
add_link(9857, 'http://en.wikipedia.org/wiki/Apopka,_Florida', 'Wikipedia');
---- CHRISTMAS, Florida Orange County (Population: 1146)
add_link(9861, 'http://en.wikipedia.org/wiki/Christmas,_Florida', 'Wikipedia');
---- CLARCONA, Florida Orange County (Population: 2990)
add_link(9862, 'http://en.wikipedia.org/wiki/Clarcona,_Florida', 'Wikipedia');
---- GOTHA, Florida Orange County (Population: 1915)
add_link(13020, 'http://en.wikipedia.org/wiki/Gotha,_Florida', 'Wikipedia');
---- KILLARNEY, Florida Orange County (Population: )
add_link(13024, 'http://en.wikipedia.org/wiki/Killarney,_Florida', 'Wikipedia');
---- MAITLAND, Florida Orange County (Population: 15751)
add_link(9876, 'http://www.itsmymaitland.com/', 'Maitland City Website');
add_link(9876, 'http://en.wikipedia.org/wiki/Maitland,_Florida', 'Wikipedia');
---- OAKLAND, Florida Orange County (Population: 2538)
add_link(13031, 'http://www.oaklandparkfl.org/index.cfm', 'Oakland City Website');
add_link(13031, 'http://en.wikipedia.org/wiki/Oakland,_Florida', 'Wikipedia');
---- OCOEE, Florida Orange County (Population: 35579)
add_link(13032, 'http://www.ocoee.org/', 'Ocoee City Website');
add_link(13032, 'http://en.wikipedia.org/wiki/Ocoee,_Florida', 'Wikipedia');
---- ORLANDO, Florida Orange County (Population: 238300)
add_link(9894, 'http://www.cityoforlando.net/', 'Orlando City Website');
add_link(9894, 'http://en.wikipedia.org/wiki/Orlando,_Florida', 'Wikipedia');
---- PLYMOUTH, Florida Orange County (Population: )
add_link(9884, 'http://en.wikipedia.org/wiki/Plymouth,_Florida', 'Wikipedia');
---- TANGERINE, Florida Orange County (Population: 2865)
add_link(9888, 'http://en.wikipedia.org/wiki/Tangerine,_Florida', 'Wikipedia');
---- WINDERMERE, Florida Orange County (Population: 2462)
add_link(13037, 'http://www.town.windermere.fl.us/', 'Windermere City Website');
add_link(13037, 'http://en.wikipedia.org/wiki/Windermere,_Florida', 'Wikipedia');
---- WINTER GARDEN, Florida Orange County (Population: 34568)
add_link(13035, 'http://www.cwgdn.com/', 'Winter Garden City Website');
add_link(13035, 'http://en.wikipedia.org/wiki/Winter_Garden,_Florida', 'Wikipedia');
---- WINTER PARK, Florida Orange County (Population: 27852)
add_link(9892, 'http://cityofwinterpark.org/', 'Winter Park City Website');
add_link(9892, 'http://en.wikipedia.org/wiki/Winter_Park,_Florida', 'Wikipedia');
---- ZELLWOOD, Florida Orange County (Population: 2817)
add_link(9893, 'http://en.wikipedia.org/wiki/Zellwood,_Florida', 'Wikipedia');
---- INTERCESSION CITY, Florida Osceola County (Population: )
add_link(12255, 'http://en.wikipedia.org/wiki/Intercession_City,_Florida', 'Wikipedia');
---- KENANSVILLE, Florida Osceola County (Population: )
add_link(13023, 'http://en.wikipedia.org/wiki/Kenansville,_Florida', 'Wikipedia');
add_link(13023, 'http://www.ghosttowns.com/states/fl/kenansville.html', 'Ghost Towns');
---- KISSIMMEE, Florida Osceola County (Population: 59682)
add_link(13025, 'http://www.kissimmee.org/', 'Kissimmee City Website');
add_link(13025, 'http://www.experiencekissimmee.com/', 'Experience Kissimmee');
add_link(13025, 'http://en.wikipedia.org/wiki/Kissimmee,_Florida', 'Wikipedia');
---- SAINT CLOUD, Florida Osceola County (Population: 35183)
add_link(13034, 'http://www.stcloud.org/', 'St. Cloud City Website');
add_link(13034, 'http://en.wikipedia.org/wiki/St._Cloud,_Florida', 'Wikipedia');
-- South East Florida
---- BELLE GLADE, Florida Palm Beach County (Population: 17467)
add_link(11560, 'http://www.bellegladegov.com/', 'Belle Glade City Website');
add_link(11560, 'http://en.wikipedia.org/wiki/Belle_Glade,_Florida', 'Wikipedia');
---- BOCA RATON, Florida Palm Beach County (Population: 84392)
add_link(11559, 'http://www.ci.boca-raton.fl.us/', 'Boca Raton City Website');
add_link(11559, 'http://en.wikipedia.org/wiki/Boca_Raton,_Florida', 'Wikipedia');
---- BOYNTON BEACH, Florida Palm Beach County (Population: 68217)
add_link(11558, 'http://www.boynton-beach.org/', 'Boynton Beach City Website');
add_link(11558, 'http://en.wikipedia.org/wiki/Boynton_Beach,_Florida', 'Wikipedia');
---- BRYANT, Florida Palm Beach County (Population: )
add_link(11562, 'http://en.wikipedia.org/wiki/Bryant,_Florida', 'Wikipedia');
---- CANAL POINT, Florida Palm Beach County (Population: 367)
add_link(11561, 'http://canalpointfl.com/', 'Canal Point City Website');
add_link(11561, 'http://en.wikipedia.org/wiki/Canal_Point,_Florida', 'Wikipedia');
---- DELRAY BEACH, Florida Palm Beach County (Population: 60522)
add_link(11565, 'http://mydelraybeach.com/', 'Delray Beach City Website');
add_link(11565, 'http://en.wikipedia.org/wiki/Delray_Beach,_Florida', 'Wikipedia');
add_link(11565, 'http://www.delraybeach.com/', 'Delray Beach Chamber of Commerce ');
---- JUPITER, Florida Palm Beach County (Population: 55156)
add_link(11568, 'http://www.jupiter.fl.us/', 'Jupiter City Website');
add_link(11568, 'http://en.wikipedia.org/wiki/Jupiter,_Florida', 'Wikipedia');
---- LAKE HARBOR, Florida Palm Beach County (Population: 45)
add_link(11569, 'http://en.wikipedia.org/wiki/Lake_Harbor,_Florida', 'Wikipedia');
---- LAKE WORTH, Florida Palm Beach County (Population: 34910)
add_link(11566, 'http://www.lakeworth.org/', 'Lake Worth City Website');
add_link(11566, 'http://en.wikipedia.org/wiki/Lake_Worth,_Florida', 'Wikipedia');
---- LOXAHATCHEE, Florida Palm Beach County (Population: )
add_link(11570, 'http://www.loxahatcheegrovesfl.gov/', 'Loxahatchee City Website');
add_link(11570, 'http://en.wikipedia.org/wiki/Loxahatchee,_Florida', 'Wikipedia');
---- NORTH PALM BEACH, Florida Palm Beach County (Population: 12015)
add_link(11321, 'http://www.village-npb.org/', 'North Palm Beach City Website');
add_link(11321, 'http://en.wikipedia.org/wiki/North_Palm_Beach,_Florida', 'Wikipedia');
---- PAHOKEE, Florida Palm Beach County (Population: 5649)
add_link(11572, 'http://www.cityofpahokee.com/', 'Pahokee City Website');
add_link(11572, 'http://en.wikipedia.org/wiki/Pahokee,_Florida', 'Wikipedia');
---- PALM BEACH, Florida Palm Beach County (Population: 8348)
add_link(11573, 'http://townofpalmbeach.com/', 'Palm Beach City Website');
add_link(11573, 'http://en.wikipedia.org/wiki/Palm_Beach,_Florida', 'Wikipedia');
---- PALM BEACH GARDENS, Florida Palm Beach County (Population: 48452)
add_link(11322, 'http://www.pbgfl.com/', 'Palm Beach Gardens City Website');
add_link(11322, 'http://en.wikipedia.org/wiki/Palm_Beach_Gardens,_Florida', 'Wikipedia');
---- SOUTH BAY, Florida Palm Beach County (Population: 4876)
add_link(11574, 'http://www.southbaycity.com/Public_Documents/indexnew', 'South Bay City Website');
add_link(11574, 'http://en.wikipedia.org/wiki/South_Bay,_Florida', 'Wikipedia');
---- WEST PALM BEACH, Florida Palm Beach County (Population: 99919)
add_link(11320, 'http://wpb.org/', 'West Palm Beach City Website');
add_link(11320, 'http://en.wikipedia.org/wiki/West_Palm_Beach,_Florida', 'Wikipedia');
add_link(11320, 'http://www.palmbeachfl.com/', 'Palm Beach County Website');
-- Tampa Bay region of Florida
---- ARIPEKA, Florida Pasco County (Population: 308)
add_link(13008, 'http://www.fivay.org/aripeka.html', 'History of Aripeka');
add_link(13008, 'http://en.wikipedia.org/wiki/Aripeka,_Florida', 'Wikipedia');
---- CRYSTAL SPRINGS, Florida Pasco County (Population: 1327)
add_link(11581, 'http://en.wikipedia.org/wiki/Crystal_Springs,_Florida', 'Wikipedia');
add_link(11581, 'http://www.crystalspringspreserve.com/', 'Crystal Springs Preserve');
---- DADE CITY, Florida Pasco County (Population: 6437)
add_link(11580, 'http://www.dadecityfl.com/', 'Dade City Website');
add_link(11580, 'http://www.dadecity.com/', 'Dade City Florida');
add_link(11580, 'http://en.wikipedia.org/wiki/Dade_City,_Florida', 'Wikipedia');
---- ELFERS, Florida Pasco County (Population: 13986)
add_link(13009, 'http://www.fivay.org/elfers.html', 'History of Elfers');
add_link(13009, 'http://en.wikipedia.org/wiki/Elfers,_Florida', 'Wikipedia');
---- HOLIDAY, Florida Pasco County (Population: 22403)
add_link(13013, 'http://en.wikipedia.org/wiki/Holiday,_Florida', 'Wikipedia');
---- HUDSON, Florida Pasco County (Population: 12158)
add_link(13005, 'http://www.hudsonfla.com/', 'Hudson City Website');
add_link(13005, 'http://en.wikipedia.org/wiki/Hudson,_Florida', 'Wikipedia');
---- LACOOCHEE, Florida Pasco County (Population: 1714)
add_link(11585, 'http://www.fivay.org/lacoochee.html', 'History of Lacoochee');
add_link(11585, 'http://en.wikipedia.org/wiki/Lacoochee,_Florida', 'Wikipedia');
---- LAND O LAKES, Florida Pasco County (Population: 31996)
add_link(13001, 'http://en.wikipedia.org/wiki/Land_O''_Lakes,_Florida', 'Wikipedia');
---- NEW PORT RICHEY, Florida Pasco County (Population: 14911)
add_link(13002, 'http://cityofnewportrichey.org/', 'New Port Richey');
add_link(13002, 'http://en.wikipedia.org/wiki/New_Port_Richey,_Florida', 'Wikipedia');
---- PORT RICHEY, Florida Pasco County (Population: 2671)
add_link(13006, 'http://www.cityofportrichey.com/new/', 'Port Richey City Website');
add_link(13006, 'http://en.wikipedia.org/wiki/Port_Richey,_Florida', 'Wikipedia');
---- SAINT LEO, Florida Pasco County (Population: 1340)
add_link(11598, 'http://en.wikipedia.org/wiki/St._Leo,_Florida', 'Wikipedia');
---- SAN ANTONIO, Florida Pasco County (Population: 1138)
add_link(11599, 'http://www.sanantonioflorida.org/', 'San Antonio City Website');
add_link(11599, 'http://en.wikipedia.org/wiki/San_Antonio,_Florida', 'Wikipedia');
---- SPRING HILL, Florida Pasco County (Population: 98621)
---- TRILBY, Florida Pasco County (Population: 419)
add_link(11605, 'http://en.wikipedia.org/wiki/Trilby,_Florida', 'Wikipedia');
---- WESLEY CHAPEL, Florida Pasco County (Population: 44092)
add_link(11588, 'http://www.wesleychapelchamber.com/', 'Wesley Chapel Chamber of Commerce');
add_link(11588, 'http://en.wikipedia.org/wiki/Wesley_Chapel,_Florida', 'Wikipedia');
---- ZEPHYRHILLS, Florida Pasco County (Population: 13288)
add_link(11587, 'http://www.ci.zephyrhills.fl.us/', 'Zephyrhills City Website');
add_link(11587, 'http://en.wikipedia.org/wiki/Zephyrhills,_Florida', 'Wikipedia');
---- BAY PINES, Florida Pinellas County (Population: 2931)
add_link(11954, 'http://en.wikipedia.org/wiki/Bay_Pines,_Florida', 'Wikipedia');
---- BELLEAIR BEACH, Florida Pinellas County (Population: 1560)
add_link(12237, 'http://www.cityofbelleairbeach.com/', 'Belleair Beach City Website');
add_link(12237, 'http://en.wikipedia.org/wiki/Belleair_Beach,_Florida', 'Wikipedia');
---- CLEARWATER, Florida Pinellas County (Population: )
add_link(11955, 'http://www.myclearwater.com/gov/', 'Clearwater City Website');
add_link(11955, 'http://en.wikipedia.org/wiki/Clearwater,_Florida', 'Wikipedia');
---- CLEARWATER BEACH, Florida Pinellas County (Population: 107685)
add_link(12232, 'http://www.clearwaterbeach.com/', 'Clearwater Beach City Website');
add_link(12232, 'http://en.wikipedia.org/wiki/Clearwater_Beach', 'Wikipedia');
---- CRYSTAL BEACH, Florida Pinellas County (Population: )
add_link(13010, 'http://en.wikipedia.org/wiki/Crystal_Beach,_Florida', 'Wikipedia');
---- DUNEDIN, Florida Pinellas County (Population: 35321)
add_link(13015, 'http://www.dunedingov.com/', 'Dunedin City Website');
add_link(13015, 'http://en.wikipedia.org/wiki/Dunedin,_Florida', 'Wikipedia');
add_link(13015, 'http://www.dunedin-fl.com/', 'Dunedin Chamber of Commerce');
---- INDIAN ROCKS BEACH, Florida Pinellas County (Population: 4113)
add_link(12236, 'http://www.indian-rocks-beach.com/', 'Indian Rocks Beach City Website');
add_link(12236, 'http://www.indianrocksbch.com/', 'Indian Rocks Beach Florida');
add_link(12236, 'http://en.wikipedia.org/wiki/Indian_Rocks_Beach,_Florida', 'Wikipedia');
---- LARGO, Florida Pinellas County (Population: 77648)
add_link(12233, 'http://www.largo.com/', 'Largo City Website');
add_link(12233, 'http://en.wikipedia.org/wiki/Largo,_Florida', 'Wikipedia');
---- OLDSMAR, Florida Pinellas County (Population: 13591)
add_link(13007, 'http://www.myoldsmar.com/Pages/index', 'Oldsmar City Website');
add_link(13007, 'http://en.wikipedia.org/wiki/Oldsmar,_Florida', 'Wikipedia');
---- OZONA, Florida Pinellas County (Population: )
add_link(13003, 'http://en.wikipedia.org/wiki/Ozona,_Florida', 'Wikipedia');
---- PALM HARBOR, Florida Pinellas County (Population: 57439)
add_link(13011, 'http://www.palmharborcc.org/', 'Palm Harbor Chamber of Commerce');
add_link(13011, 'http://en.wikipedia.org/wiki/Palm_Harbor,_Florida', 'Wikipedia');
---- PINELLAS PARK, Florida Pinellas County (Population: 49079)
add_link(12235, 'http://www.pinellas-park.com/', 'Pinellas Park City Website');
add_link(12235, 'http://pinellasparkchamber.com/', 'Pinellas Park Chamber of Commerce');
add_link(12235, 'http://en.wikipedia.org/wiki/Pinellas_Park,_Florida', 'Wikipedia');
---- SAFETY HARBOR, Florida Pinellas County (Population: 16884)
add_link(13014, 'http://www.cityofsafetyharbor.com/', 'Safety Harbor City Website');
add_link(13014, 'http://en.wikipedia.org/wiki/Safety_Harbor,_Florida', 'Wikipedia');
---- SAINT PETERSBURG, Florida Pinellas County (Population: 244769)
add_link(11953, 'http://www.stpete.org/', 'St. Petersburg City Website');
add_link(11953, 'http://en.wikipedia.org/wiki/St._Petersburg,_Florida', 'Wikipedia');
---- SEMINOLE, Florida Pinellas County (Population: 17233)
add_link(12234, 'http://www.myseminole.com/', 'Seminole City Website');
add_link(12234, 'http://en.wikipedia.org/wiki/Seminole,_Florida', 'Wikipedia');
---- TARPON SPRINGS, Florida Pinellas County (Population: 23484)
add_link(13012, 'http://ctsfl.us/', 'Tarpon Springs City Website');
add_link(13012, 'http://en.wikipedia.org/wiki/Tarpon_Springs,_Florida', 'Wikipedia');
---- ALTURAS, Florida Polk County (Population: 4185)
add_link(12239, 'http://en.wikipedia.org/wiki/Alturas,_Florida', 'Wikipedia');
---- AUBURNDALE, Florida Polk County (Population: 13507)
add_link(12240, 'http://www.auburndalefl.com/', 'Aubrundale City Website');
add_link(12240, 'http://en.wikipedia.org/wiki/Auburndale,_Florida', 'Wikipedia');
---- BABSON PARK, Florida Polk County (Population: 1356)
add_link(12242, 'http://en.wikipedia.org/wiki/Babson_Park,_Florida', 'Wikipedia');
---- BARTOW, Florida Polk County (Population: 17298)
add_link(12243, 'http://www.cityofbartow.net/', 'Bartow City Website');
add_link(12243, 'http://en.wikipedia.org/wiki/Bartow,_Florida', 'Wikipedia');
---- BRADLEY, Florida Polk County (Population: )
add_link(12245, 'http://en.wikipedia.org/wiki/Bradley_Junction,_Florida', 'Wikipedia');
---- DAVENPORT, Florida Polk County (Population: 2888)
add_link(12246, 'http://www.mydavenport.org/', 'Davenport City Website');
add_link(12246, 'http://en.wikipedia.org/wiki/Davenport,_Florida', 'Wikipedia');
---- DUNDEE, Florida Polk County (Population: 3717)
add_link(12247, 'http://townofdundee.com/', 'Dundee City Website');
add_link(12247, 'http://en.wikipedia.org/wiki/Dundee,_Florida', 'Wikipedia');
---- EAGLE LAKE, Florida Polk County (Population: 2255)
add_link(12248, 'http://www.eaglelake-fla.com/', 'Eagle Lake City Website');
add_link(12248, 'http://en.wikipedia.org/wiki/Eagle_Lake,_Florida', 'Wikipedia');
---- EATON PARK, Florida Polk County (Population: )
add_link(12249, 'http://en.wikipedia.org/wiki/Eaton_Park,_Florida', 'Wikipedia');
---- FORT MEADE, Florida Polk County (Population: 5626)
add_link(12250, 'http://www.cityoffortmeade.com/', 'Fort Meade City Website');
add_link(12250, 'http://en.wikipedia.org/wiki/Fort_Meade,_Florida', 'Wikipedia');
---- FROSTPROOF, Florida Polk County (Population: 2992)
add_link(12251, 'http://www.cityoffrostproof.com/', 'Frostproof City Website');
add_link(12251, 'http://en.wikipedia.org/wiki/Frostproof,_Florida', 'Wikipedia');
---- HAINES CITY, Florida Polk County (Population: 20535)
add_link(12252, 'http://www.hainescity.com/', 'Haines City Website');
add_link(12252, 'http://en.wikipedia.org/wiki/Haines_City,_Florida', 'Wikipedia');
---- HIGHLAND CITY, Florida Polk County (Population: 10834)
add_link(12253, 'http://en.wikipedia.org/wiki/Highland_City,_Florida', 'Wikipedia');
---- HOMELAND, Florida Polk County (Population: 366)
add_link(12254, 'http://en.wikipedia.org/wiki/Homeland,_Florida', 'Wikipedia');
---- INDIAN LAKE ESTATES, Florida Polk County (Population: )
add_link(12262, 'http://www.indianlakeestates.net/', 'Indian Lake Estates City Website');
---- KATHLEEN, Florida Polk County (Population: 6332)
add_link(12256, 'http://en.wikipedia.org/wiki/Kathleen,_Florida', 'Wikipedia');
---- KISSIMMEE, Florida Polk County (Population: 59682)
add_link(13030, 'http://www.kissimmee.org/', 'Kissimmee City Website');
add_link(13030, 'http://en.wikipedia.org/wiki/Kissimmee,_Florida', 'Wikipedia');
---- LAKE ALFRED, Florida Polk County (Population: 5015)
add_link(12257, 'http://mylakealfred.com/', 'Lake Alfred City Website');
add_link(12257, 'http://en.wikipedia.org/wiki/Lake_Alfred,_Florida', 'Wikipedia');
---- LAKE HAMILTON, Florida Polk County (Population: 1231)
add_link(12258, 'http://www.townoflakehamilton.com/', 'Lake Hamilton City Website');
add_link(12258, 'http://en.wikipedia.org/wiki/Lake_Hamilton,_Florida', 'Wikipedia');
---- LAKE WALES, Florida Polk County (Population: 14225)
add_link(12260, 'http://www.cityoflakewales.com/', 'Lake Wales City Website');
add_link(12260, 'http://en.wikipedia.org/wiki/Lake_Wales,_Florida', 'Wikipedia');
---- LAKELAND, Florida Polk County (Population: 97422)
add_link(12238, 'http://www.lakelandgov.net/', 'Lakeland City Website');
add_link(12238, 'http://en.wikipedia.org/wiki/Lakeland,_Florida', 'Wikipedia');
---- LAKESHORE, Florida Polk County (Population: )
add_link(12261, 'http://en.wikipedia.org/wiki/Lakeshore,_Florida', 'Wikipedia');
---- LOUGHMAN, Florida Polk County (Population: 2680)
add_link(12265, 'http://en.wikipedia.org/wiki/Loughman,_Florida', 'Wikipedia');
---- MULBERRY, Florida Polk County (Population: 3817)
add_link(12266, 'http://cityofmulberryflorida.com/', 'Mulberry City Website');
add_link(12266, 'http://en.wikipedia.org/wiki/Mulberry,_Florida', 'Wikipedia');
---- NALCREST, Florida Polk County (Population: )
add_link(12263, 'http://en.wikipedia.org/wiki/Nalcrest,_Florida', 'Wikipedia');
---- NICHOLS, Florida Polk County (Population: )
add_link(12267, 'http://en.wikipedia.org/wiki/Nichols,_Florida', 'Wikipedia');
---- POLK CITY, Florida Polk County (Population: 1562)
add_link(12270, 'http://www.mypolkcity.org/', 'Polk City Website');
add_link(12270, 'http://en.wikipedia.org/wiki/Polk_City,_Florida', 'Wikipedia');
---- RIVER RANCH, Florida Polk County (Population: )
---- WAVERLY, Florida Polk County (Population: 767)
add_link(12273, 'http://en.wikipedia.org/wiki/Waverly,_Florida', 'Wikipedia');
---- WINTER HAVEN, Florida Polk County (Population: 33874)
add_link(12274, 'http://www.mywinterhaven.com/index.htm', 'Winter Haven City Website');
add_link(12274, 'http://en.wikipedia.org/wiki/Winter_Haven,_Florida', 'Wikipedia');
-- North Eastern Florida
---- BOSTWICK, Florida Putnam County (Population: )
add_link(13494, 'http://en.wikipedia.org/wiki/Bostwick,_Florida', 'Wikipedia');
---- CRESCENT CITY, Florida Putnam County (Population: 1577)
add_link(13536, 'http://www.crescentcity-fl.com/', 'Crescent City Website');
add_link(13536, 'http://en.wikipedia.org/wiki/Crescent_City,_Florida', 'Wikipedia');
---- EAST PALATKA, Florida Putnam County (Population: 1654)
add_link(13540, 'http://en.wikipedia.org/wiki/East_Palatka,_Florida', 'Wikipedia');
---- EDGAR, Florida Putnam County (Population: )
add_link(13552, 'http://en.wikipedia.org/wiki/Edgar,_Florida', 'Wikipedia');
---- FLORAHOME, Florida Putnam County (Population: )
add_link(13548, 'http://en.wikipedia.org/wiki/Florahome,_Florida', 'Wikipedia');
---- GEORGETOWN, Florida Putnam County (Population: )
add_link(13547, 'http://en.wikipedia.org/wiki/Georgetown,_Florida', 'Wikipedia');
---- GRANDIN, Florida Putnam County (Population: )
add_link(13546, 'http://en.wikipedia.org/wiki/Grandin,_Florida', 'Wikipedia');
---- HOLLISTER, Florida Putnam County (Population: )
add_link(13550, 'http://en.wikipedia.org/wiki/Hollister,_Florida', 'Wikipedia');
---- INTERLACHEN, Florida Putnam County (Population: 1403)
add_link(13551, 'http://en.wikipedia.org/wiki/Interlachen,_Florida', 'Wikipedia');
---- LAKE COMO, Florida Putnam County (Population: )
add_link(13553, 'http://en.wikipedia.org/wiki/Lake_Como,_Florida', 'Wikipedia');
---- MELROSE, Florida Putnam County (Population: )
add_link(9842, 'http://en.wikipedia.org/wiki/Melrose,_Florida', 'Wikipedia');
---- PALATKA, Florida Putnam County (Population: 10558)
add_link(13559, 'http://palatka-fl.gov/', 'Palatka City Website');
add_link(13559, 'http://en.wikipedia.org/wiki/Palatka,_Florida', 'Wikipedia');
---- POMONA PARK, Florida Putnam County (Population: 912)
add_link(9564, 'http://www.pomonapark.com/', 'Pomona Park City Website');
add_link(9564, 'http://en.wikipedia.org/wiki/Pomona_Park,_Florida', 'Wikipedia');
---- PUTNAM HALL, Florida Putnam County (Population: )
add_link(9566, 'http://en.wikipedia.org/wiki/Putnam_Hall,_Florida', 'Wikipedia');
---- SAN MATEO, Florida Putnam County (Population: )
add_link(9567, 'http://en.wikipedia.org/wiki/San_Mateo,_Florida', 'Wikipedia');
---- SATSUMA, Florida Putnam County (Population: )
add_link(9568, 'http://en.wikipedia.org/wiki/Satsuma,_Florida', 'Wikipedia');
---- WELAKA, Florida Putnam County (Population: 701)
add_link(9571, 'http://welaka-fl.gov/', 'Welaka City Website');
add_link(9571, 'http://en.wikipedia.org/wiki/Welaka,_Florida', 'Wikipedia');
---- ELKTON, Florida Saint Johns County (Population: )
add_link(13502, 'http://en.wikipedia.org/wiki/Elkton,_Florida', 'Wikipedia');
---- HASTINGS, Florida Saint Johns County (Population: 580)
add_link(13549, 'http://www.hastings-fl.com/', 'Hastings City Website');
add_link(13549, 'http://en.wikipedia.org/wiki/Hastings,_Florida', 'Wikipedia');
---- JACKSONVILLE, Florida Saint Johns County (Population: 821784)
add_link(9578, 'http://www.coj.net/', 'Jacksonville City Website');
add_link(9578, 'http://en.wikipedia.org/wiki/Jacksonville,_Florida', 'Wikipedia');
---- PONTE VEDRA, Florida Saint Johns County (Population: )
---- PONTE VEDRA BEACH, Florida Saint Johns County (Population: )
add_link(13493, 'http://en.wikipedia.org/wiki/Ponte_Vedra_Beach,_Florida', 'Wikipedia');
---- SAINT AUGUSTINE, Florida Saint Johns County (Population: 12975)
add_link(13526, 'http://www.ci.st-augustine.fl.us/', 'St. Augustine City Website');
add_link(13526, 'http://en.wikipedia.org/wiki/St._Augustine,_Florida', 'Wikipedia');
add_link(13526, 'http://www.oldcity.com/', 'Old City');
---- SAINT JOHNS, Florida Saint Johns County (Population: )
add_link(9577, 'http://en.wikipedia.org/wiki/St._Johns,_Florida', 'Wikipedia');
-- South East Florida
---- FORT PIERCE, Florida Saint Lucie County (Population: 41590)
add_link(13255, 'http://www.cityoffortpierce.com/', 'Fort Pierce City Website');
add_link(13255, 'http://en.wikipedia.org/wiki/Fort_Pierce,_Florida', 'Wikipedia');
---- PORT SAINT LUCIE, Florida Saint Lucie County (Population: 164603)
add_link(13256, 'http://www.cityofpsl.com/', 'Port St. Lucy City Website');
add_link(13256, 'http://en.wikipedia.org/wiki/Port_St._Lucie,_Florida', 'Wikipedia');
-- North West Florida
---- BAGDAD, Florida Santa Rosa County (Population: 3761)
add_link(9325, 'http://en.wikipedia.org/wiki/Bagdad,_Florida', 'Wikipedia');
---- GULF BREEZE, Florida Santa Rosa County (Population: 5763)
add_link(9338, 'http://cityofgulfbreeze.us/', 'Gulf Breeze City Website');
add_link(9338, 'http://en.wikipedia.org/wiki/Gulf_Breeze,_Florida', 'Wikipedia');
---- JAY, Florida Santa Rosa County (Population: 533)
add_link(9340, 'http://en.wikipedia.org/wiki/Jay,_Florida', 'Wikipedia');
---- MILTON, Florida Santa Rosa County (Population: 8826)
add_link(9345, 'http://www.ci.milton.fl.us/', 'Milton City Website');
add_link(9345, 'http://en.wikipedia.org/wiki/Milton,_Florida', 'Wikipedia');
---- NAVARRE, Florida Santa Rosa County (Population: 31378)
add_link(9341, 'http://en.wikipedia.org/wiki/Navarre,_Florida', 'Wikipedia');
-- Tampa Bay region of Florida
---- ENGLEWOOD, Florida Sarasota County (Population: 14863)
add_link(12593, 'http://englewoodchamber.com/', 'Englewood City Website');
add_link(12593, 'http://en.wikipedia.org/wiki/Englewood,_Florida', 'Wikipedia');
---- LAUREL, Florida Sarasota County (Population: 8171)
add_link(12606, 'http://en.wikipedia.org/wiki/Laurel,_Florida', 'Wikipedia');
---- NOKOMIS, Florida Sarasota County (Population: 3167)
add_link(12607, 'http://en.wikipedia.org/wiki/Nokomis,_Florida', 'Wikipedia');
---- NORTH PORT, Florida Sarasota County (Population: 57357)
add_link(12609, 'http://www.cityofnorthport.com/', 'North Port City Website');
add_link(12609, 'http://en.wikipedia.org/wiki/North_Port,_Florida', 'Wikipedia');
---- OSPREY, Florida Sarasota County (Population: 6100)
add_link(12596, 'http://en.wikipedia.org/wiki/Osprey,_Florida', 'Wikipedia');
---- SARASOTA, Florida Sarasota County (Population: 51917)
add_link(12597, 'http://www.sarasotagov.com/', 'Sarasota City Website');
add_link(12597, 'http://en.wikipedia.org/wiki/Sarasota,_Florida', 'Wikipedia');
---- VENICE, Florida Sarasota County (Population: 20748)
add_link(12608, 'http://www.venicegov.com/', 'Venice City Website');
add_link(12608, 'http://en.wikipedia.org/wiki/Venice,_Florida', 'Wikipedia');
-- East Central Florida
---- ALTAMONTE SPRINGS, Florida Seminole County (Population: 41496)
add_link(9855, 'http://www.altamonte.org/', 'Altamonte City Website');
add_link(9855, 'http://en.wikipedia.org/wiki/Altamonte_Springs,_Florida', 'Wikipedia');
---- CASSELBERRY, Florida Seminole County (Population: 26241)
add_link(9859, 'http://www.casselberry.org/', 'Casselberry City Website');
add_link(9859, 'http://en.wikipedia.org/wiki/Casselberry,_Florida', 'Wikipedia');
---- GENEVA, Florida Seminole County (Population: 2940)
add_link(9868, 'http://en.wikipedia.org/wiki/Geneva,_Florida', 'Wikipedia');
---- GOLDENROD, Florida Seminole County (Population: 12039)
add_link(9869, 'http://en.wikipedia.org/wiki/Goldenrod,_Florida', 'Wikipedia');
---- LAKE MARY, Florida Seminole County (Population: 13822)
add_link(9873, 'http://www.lakemaryfl.com/', 'Lake Mary City Website' );
add_link(9873, 'http://en.wikipedia.org/wiki/Lake_Mary,_Florida', 'Wikipedia');
---- LAKE MONROE, Florida Seminole County (Population: )
---- LONGWOOD, Florida Seminole County (Population: 13657)
add_link(9875, 'http://www.longwoodfl.org/', 'Longwood City Website');
add_link(9875, 'http://en.wikipedia.org/wiki/Longwood,_Florida', 'Wikipedia');
---- MID FLORIDA, Florida Seminole County (Population: )
---- OVIEDO, Florida Seminole County (Population: 33342)
add_link(9880, 'http://www.ci.oviedo.fl.us/', 'Oviedo City Website');
add_link(9880, 'http://en.wikipedia.org/wiki/Oviedo,_Florida', 'Wikipedia');
---- SANFORD, Florida Seminole County (Population: 53570)
add_link(9885, 'http://www.sanfordfl.gov/', 'Sanford City Website');
add_link(9885, 'http://en.wikipedia.org/wiki/Sanford,_Florida', 'Wikipedia');
---- WINTER SPRINGS, Florida Seminole County (Population: 33282)
add_link(9860, 'http://www.winterspringsfl.org/', 'Winter Springs City Website');
add_link(9860, 'http://en.wikipedia.org/wiki/Winter_Springs,_Florida', 'Wikipedia');
---- BUSHNELL, Florida Sumter County (Population: 2418)
add_link(11577, 'http://www.cityofbushnellfl.com/', 'Buchnell City Website');
add_link(11577, 'http://en.wikipedia.org/wiki/Bushnell,_Florida', 'Wikipedia');
---- CENTER HILL, Florida Sumter County (Population: 988)
add_link(11578, 'http://en.wikipedia.org/wiki/Center_Hill,_Florida', 'Wikipedia');
---- COLEMAN, Florida Sumter County (Population: 703)
add_link(11579, 'http://en.wikipedia.org/wiki/Coleman,_Florida', 'Wikipedia');
---- LAKE PANASOFFKEE, Florida Sumter County (Population: 3551)
add_link(11586, 'http://en.wikipedia.org/wiki/Lake_Panasoffkee,_Florida', 'Wikipedia');
---- OXFORD, Florida Sumter County (Population: )
add_link(12993, 'http://en.wikipedia.org/wiki/Oxford,_Florida', 'Wikipedia');
---- SUMTERVILLE, Florida Sumter County (Population: )
add_link(11601, 'http://en.wikipedia.org/wiki/Sumterville,_Florida', 'Wikipedia');
---- THE VILLAGES, Florida Sumter County (Population: 51442)
add_link(13556, 'http://www.thevillages.com/', 'The Villages City Website');
add_link(13556, 'http://en.wikipedia.org/wiki/The_Villages,_Florida', 'Wikipedia');
---- WEBSTER, Florida Sumter County (Population: 785)
add_link(11607, 'http://en.wikipedia.org/wiki/Webster,_Florida', 'Wikipedia');
---- WILDWOOD, Florida Sumter County (Population: 6709)
add_link(13036, 'http://www.wildwood-fl.gov/', 'Wildwood City Website');
add_link(13036, 'http://en.wikipedia.org/wiki/Wildwood,_Florida', 'Wikipedia');
-- North Central Florida
---- BRANFORD, Florida Suwannee County (Population: 712)
add_link(13495, 'http://www.townofbranford.net/', 'Bradford City Website');
add_link(13495, 'http://en.wikipedia.org/wiki/Branford,_Florida', 'Wikipedia');
---- LIVE OAK, Florida Suwannee County (Population: 6850)
add_link(13517, 'http://www.cityofliveoak.org/', 'Live Oak City Website');
add_link(13517, 'http://en.wikipedia.org/wiki/Live_Oak,_Florida', 'Wikipedia');
---- MC ALPIN, Florida Suwannee County (Population: )
add_link(13519, 'http://en.wikipedia.org/wiki/McAlpin,_Florida', 'Wikipedia');
---- O BRIEN, Florida Suwannee County (Population: )
add_link(13523, 'http://en.wikipedia.org/wiki/O''Brien,_Florida', 'Wikipedia');
---- WELLBORN, Florida Suwannee County (Population: )
add_link(13530, 'http://en.wikipedia.org/wiki/Wellborn,_Florida', 'Wikipedia');
---- PERRY, Florida Taylor County (Population: 7017)
add_link(9274, 'http://www.cityofperry.net/', 'Perry City Website');
add_link(9274, 'http://en.wikipedia.org/wiki/Perry,_Florida', 'Wikipedia');
---- SALEM, Florida Taylor County (Population: )
---- SHADY GROVE, Florida Taylor County (Population: )
---- STEINHATCHEE, Florida Taylor County (Population: 1047)
add_link(9281, 'http://en.wikipedia.org/wiki/Steinhatchee,_Florida', 'Wikipedia');
---- LAKE BUTLER, Florida Union County (Population: 1897)
add_link(13514, 'http://www.cityoflakebutler.org/', 'Lake Butler City Website');
add_link(13514, 'http://en.wikipedia.org/wiki/Lake_Butler,_Union_County,_Florida', 'Wikipedia');
---- RAIFORD, Florida Union County (Population: 255)
add_link(13500, 'http://en.wikipedia.org/wiki/Raiford,_Florida', 'Wikipedia');
---- WORTHINGTON SPRINGS, Florida Union County (Population: 181)
add_link(9854, 'http://en.wikipedia.org/wiki/Worthington_Springs,_Florida', 'Wikipedia');
-- East Central Florida
---- BARBERVILLE, Florida Volusia County (Population: )
add_link(13533, 'http://en.wikipedia.org/wiki/Barberville,_Florida', 'Wikipedia');
---- CASSADAGA, Florida Volusia County (Population: )
add_link(9858, 'http://en.wikipedia.org/wiki/Cassadaga,_Florida', 'Wikipedia');
---- DAYTONA BEACH, Florida Volusia County (Population: 61005)
add_link(9573, 'http://www.codb.us/', 'Daytona Beach City Website');
add_link(9573, 'http://en.wikipedia.org/wiki/Daytona_Beach,_Florida', 'Wikipedia');
---- DE LEON SPRINGS, Florida Volusia County (Population: 2614)
add_link(13539, 'http://en.wikipedia.org/wiki/De_Leon_Springs,_Florida', 'Wikipedia');
---- DEBARY, Florida Volusia County (Population: 19320)
add_link(9863, 'http://debary.org/Pages/index', 'Debary City Website');
add_link(9863, 'http://en.wikipedia.org/wiki/DeBary,_Florida', 'Wikipedia');
---- DELAND, Florida Volusia County (Population: 27031)
add_link(9864, 'http://www.deland.org/Pages/DeLandFL_WebDocs/about', 'Deland City Website');
add_link(9864, 'http://en.wikipedia.org/wiki/DeLand,_Florida', 'Wikipedia');
---- DELTONA, Florida Volusia County (Population: 85182)
add_link(9866, 'http://www.ci.deltona.fl.us/Pages/index', 'Deltona City Website');
add_link(9866, 'http://en.wikipedia.org/wiki/Deltona,_Florida', 'Wikipedia');
---- EDGEWATER, Florida Volusia County (Population: 20750)
add_link(13541, 'http://www.cityofedgewater.org/', 'Edgewater City Website');
add_link(13541, 'http://en.wikipedia.org/wiki/Edgewater,_Volusia_County,_Florida', 'Wikipedia');
---- GLENWOOD, Florida Volusia County (Population: )
---- LAKE HELEN, Florida Volusia County (Population: 2624)
add_link(9871, 'http://lakehelen.com/', 'Lake Helen City Website');
add_link(9871, 'http://en.wikipedia.org/wiki/Lake_Helen,_Florida', 'Wikipedia');
---- NEW SMYRNA BEACH, Florida Volusia County (Population: 22464)
add_link(13557, 'http://www.cityofnsb.com/', 'New Smyrna Beach City Website');
add_link(13557, 'http://en.wikipedia.org/wiki/New_Smyrna_Beach,_Florida', 'Wikipedia');
---- OAK HILL, Florida Volusia County (Population: 1792)
add_link(9879, 'http://www.oakhillfl.com/', 'Oak Hill City Website');
add_link(9879, 'http://en.wikipedia.org/wiki/Oak_Hill,_Florida', 'Wikipedia');
---- ORANGE CITY, Florida Volusia County (Population: 10599)
add_link(9881, 'http://www.ci.orange-city.fl.us/', 'Orange City Website');
add_link(9881, 'http://en.wikipedia.org/wiki/Orange_City,_Florida', 'Wikipedia');
---- ORMOND BEACH, Florida Volusia County (Population: 38137)
add_link(13558, 'http://www.ormondbeach.org/', 'Ormond Beach City Website');
add_link(13558, 'http://en.wikipedia.org/wiki/Ormond_Beach,_Florida', 'Wikipedia');
---- OSTEEN, Florida Volusia County (Population: )
add_link(9882, 'http://en.wikipedia.org/wiki/Osteen,_Florida', 'Wikipedia');
---- PIERSON, Florida Volusia County (Population: 1736)
add_link(9563, 'www.townofpierson.org/‎', 'Pierson City Website');
add_link(9563, 'http://en.wikipedia.org/wiki/Pierson,_Florida', 'Wikipedia');
---- PORT ORANGE, Florida Volusia County (Population: 56048)
add_link(13538, 'https://www.port-orange.org/', 'Port Orange City Website');
add_link(13538, 'http://en.wikipedia.org/wiki/Port_Orange,_Florida', 'Wikipedia');
---- SEVILLE, Florida Volusia County (Population: 614)
add_link(9569, 'http://en.wikipedia.org/wiki/Seville,_Florida', 'Wikipedia');
-- North West Florida
---- CRAWFORDVILLE, Florida Wakulla County (Population: 3702)
add_link(9585, 'http://en.wikipedia.org/wiki/Crawfordville,_Florida', 'Wikipedia');
---- PANACEA, Florida Wakulla County (Population: 816)
add_link(9273, 'http://en.wikipedia.org/wiki/Panacea,_Florida', 'Wikipedia');
---- SAINT MARKS, Florida Wakulla County (Population: 293)
add_link(9277, 'http://cityofstmarks.com/businesses.htm', 'St. Marks City Website');
add_link(9277, 'http://en.wikipedia.org/wiki/St._Marks,_Florida', 'Wikipedia');
---- SOPCHOPPY, Florida Wakulla County (Population: 457)
add_link(9280, 'http://www.sopchoppy.org/', 'Sopchoppy City Website');
add_link(9280, 'http://en.wikipedia.org/wiki/Sopchoppy,_Florida', 'Wikipedia');
---- ARGYLE, Florida Walton County (Population: )
---- DEFUNIAK SPRINGS, Florida Walton County (Population: 5177)
add_link(9301, 'http://www.defuniaksprings.net/', 'Defuniak City Website');
add_link(9301, 'http://en.wikipedia.org/wiki/DeFuniak_Springs,_Florida', 'Wikipedia');
---- FREEPORT, Florida Walton County (Population: 1787)
add_link(9305, 'http://freeportflorida.gov/', 'Freeport City Website');
add_link(9305, 'http://en.wikipedia.org/wiki/Freeport,_Florida', 'Wikipedia');
---- MIRAMAR BEACH, Florida Walton County (Population: 6146)
add_link(9336, 'http://en.wikipedia.org/wiki/Miramar_Beach,_Florida', 'Wikipedia');
---- MOSSY HEAD, Florida Walton County (Population: )
---- PAXTON, Florida Walton County (Population: 644)
add_link(9331, 'http://paxtonfl.gov/', 'Paxton City Website');
add_link(9331, 'http://en.wikipedia.org/wiki/Paxton,_Florida', 'Wikipedia');
---- PONCE DE LEON, Florida Walton County (Population: 598)
add_link(9314, 'http://en.wikipedia.org/wiki/Ponce_de_Leon,_Florida', 'Ponce De Leon City Website');
---- ROSEMARY BEACH, Florida Walton County (Population: )
add_link(9318, 'http://en.wikipedia.org/wiki/Rosemary_Beach,_Florida', 'Wikipedia');
---- SANTA ROSA BEACH, Florida Walton County (Population: )
add_link(9316, 'http://en.wikipedia.org/wiki/Santa_Rosa_Beach,_Florida', 'Wikipedia');
---- CARYVILLE, Florida Washington County (Population: 411)
add_link(9296, 'http://en.wikipedia.org/wiki/Caryville,_Florida', 'Wikipedia');
---- CHIPLEY, Florida Washington County (Population: 3605)
add_link(9297, 'http://www.cityofchipley.com/', 'Chipley City Website');
add_link(9297, 'http://en.wikipedia.org/wiki/Chipley,_Florida', 'Wikipedia');
---- EBRO, Florida Washington County (Population: 270)
add_link(9303, 'http://en.wikipedia.org/wiki/Ebro,_Florida', 'Wikipedia');
---- VERNON, Florida Washington County (Population: 687)
add_link(9319, 'http://en.wikipedia.org/wiki/Vernon,_Florida', 'Wikipedia');
---- WAUSAU, Florida Washington County (Population: 383)
add_link(9320, 'http://en.wikipedia.org/wiki/Wausau,_Florida', 'Wikipedia');


end add_links;

begin
  add_links;
end;
/

