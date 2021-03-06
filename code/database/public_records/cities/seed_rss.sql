set define ^
declare
  procedure add_rss
   ( p_name    in    varchar2
   , p_county  in    varchar2
   , p_rss     in    varchar2
   , p_source  in    varchar2
   , p_rname   in    varchar2) is
  begin
    update rnt_cities
    set rss_news = p_rss
    ,   rss_source = p_source
    ,   rss_name    = p_rname
    where name = p_name
    and county = p_county
    and state = 'FL';
  end add_rss;

  procedure seed_rss is
  begin
    add_rss ( p_name    => 'ANY'
            , p_county  => 'ANY'
            , p_rss     => 'http://www.miamiherald.com/news/florida/index.rss'
            , p_source  => 'http://www.miamiherald.com/'
            , p_rname   => 'The Miami Herald');

    add_rss ( p_name    => 'HIALEAH'
            , p_county  => 'MIAMI-DADE'
            , p_rss     => 'http://www.miamiherald.com/hialeah/index.xml'
            , p_source  => 'http://www.miamiherald.com/'
            , p_rname   => 'The Miami Herald');
            
    add_rss ( p_name    => 'HOMESTEAD'
            , p_county  => 'MIAMI-DADE'
            , p_rss     => 'http://www.miamiherald.com/south-dade/index.xml'
            , p_source  => 'http://www.miamiherald.com/'
            , p_rname   => 'The Miami Herald');
            
    add_rss ( p_name    => 'OPA LOCKA'
            , p_county  => 'MIAMI-DADE'
            , p_rss     => 'http://www.miamiherald.com/miami-gardens/index.xml'
            , p_source  => 'http://www.miamiherald.com/'
            , p_rname   => 'The Miami Herald');
            
    add_rss ( p_name    => 'MIAMI'
            , p_county  => 'MIAMI-DADE'
            , p_rss     => 'http://www.miamiherald.com/brickell/index.xml'
            , p_source  => 'http://www.miamiherald.com/'
            , p_rname   => 'The Miami Herald');
            
    add_rss ( p_name    => 'MIAMI BEACH'
            , p_county  => 'MIAMI-DADE'
            , p_rss     => 'http://www.miamiherald.com/miami-beach/index.xml'
            , p_source  => 'http://www.miamiherald.com/'
            , p_rname   => 'The Miami Herald');
            
    add_rss ( p_name    => 'KEY BISCAYNE'
            , p_county  => 'MIAMI-DADE'
            , p_rss     => 'http://www.miamiherald.com/key-biscayne/index.xml'
            , p_source  => 'http://www.miamiherald.com/'
            , p_rname   => 'The Miami Herald');
            
    add_rss ( p_name    => 'NORTH MIAMI BEACH'
            , p_county  => 'MIAMI-DADE'
            , p_rss     => 'http://www.miamiherald.com/north-miami/index.xml'
            , p_source  => 'http://www.miamiherald.com/'
            , p_rname   => 'The Miami Herald');
            
    add_rss ( p_name    => 'ANY'
            , p_county  => 'MIAMI-DADE'
            , p_rss     => 'http://www.miamiherald.com/news/miami-dade/index.xml'
            , p_source  => 'http://www.miamiherald.com/'
            , p_rname   => 'The Miami Herald');


    add_rss ( p_name    => 'DANIA'
            , p_county  => 'BROWARD'
            , p_rss     => 'http://www.miamiherald.com/dania-beach/index.xml'
            , p_source  => 'http://www.miamiherald.com/'
            , p_rname   => 'The Miami Herald');

    add_rss ( p_name    => 'DEERFIELD BEACH'
            , p_county  => 'BROWARD'
            , p_rss     => 'http://www.miamiherald.com/deerfield-beach/index.xml'
            , p_source  => 'http://www.miamiherald.com/'
            , p_rname   => 'The Miami Herald');
            
    add_rss ( p_name    => 'FORT LAUDERDALE'
            , p_county  => 'BROWARD'
            , p_rss     => 'http://www.miamiherald.com/fort-lauderdale/index.xml'
            , p_source  => 'http://www.miamiherald.com/'
            , p_rname   => 'The Miami Herald');
            
    add_rss ( p_name    => 'HALLANDALE'
            , p_county  => 'BROWARD'
            , p_rss     => 'http://www.miamiherald.com/hallandale-beach/index.xml'
            , p_source  => 'http://www.miamiherald.com/'
            , p_rname   => 'The Miami Herald');
            
    add_rss ( p_name    => 'HOLLYWOOD'
            , p_county  => 'BROWARD'
            , p_rss     => 'http://www.miamiherald.com/hollywood/index.xml'
            , p_source  => 'http://www.miamiherald.com/'
            , p_rname   => 'The Miami Herald');
            
    add_rss ( p_name    => 'PEMBROKE PINES'
            , p_county  => 'BROWARD'
            , p_rss     => 'http://www.miamiherald.com/pembroke-pines/index.xml'
            , p_source  => 'http://www.miamiherald.com/'
            , p_rname   => 'The Miami Herald');
            
    add_rss ( p_name    => 'POMPANO BEACH'
            , p_county  => 'BROWARD'
            , p_rss     => 'http://thepelicanpaper.com/feed/'
            , p_source  => 'http://thepelicanpaper.com/'
            , p_rname   => 'The Pelican');
            
    add_rss ( p_name    => 'ANY'
            , p_county  => 'BROWARD'
            , p_rss     => 'http://www.miamiherald.com/news/broward/index.xml'
            , p_source  => 'http://www.miamiherald.com/'
            , p_rname   => 'The Miami Herald');

    add_rss ( p_name    => 'ANY'
            , p_county  => 'PALM BEACH'
            , p_rss     => 'http://www.wpbf.com/8789800?format=rss_2.0&view=feed'
            , p_source  => 'http://www.wpbf.com/'
            , p_rname   => 'abc 25 WPBF');

    add_rss ( p_name    => 'ANY'
            , p_county  => 'MARTIN'
            , p_rss     => 'http://www.tcpalm.com/feeds/headlines/news/local/martin-county/'
            , p_source  => 'http://www.tcpalm.com/'
            , p_rname   => 'TC Palm');

    add_rss ( p_name    => 'ANY'
            , p_county  => 'INDIAN RIVER'
            , p_rss     => 'http://www.tcpalm.com/rss/headlines/local/indian-river-county/'
            , p_source  => 'http://www.tcpalm.com/'
            , p_rname   => 'TC Palm');

    add_rss ( p_name    => 'ANY'
            , p_county  => 'MONROE'
            , p_rss     => 'http://keysnews.com/rss.xml'
            , p_source  => 'http://keysnews.com/'
            , p_rname   => 'Keys News');
            
    add_rss ( p_name    => 'ANY'
            , p_county  => 'BREVARD'
            , p_rss     => 'http://rssfeeds.floridatoday.com/brevard/news'
            , p_source  => 'http://floridatoday.com/'
            , p_rname   => 'Florida Today');
            
    add_rss ( p_name    => 'ANY'
            , p_county  => 'LAKE'
            , p_rss     => 'http://www.orlandosentinel.com/news/local/lake/rss2.0.xml'
            , p_source  => 'http://www.orlandosentinel.com/'
            , p_rname   => 'Orlando Sentinel');
            
    add_rss ( p_name    => 'ANY'
            , p_county  => 'ORANGE'
            , p_rss     => 'http://www.orlandosentinel.com/news/local/orange/rss2.0.xml'
            , p_source  => 'http://www.orlandosentinel.com/'
            , p_rname   => 'Orlando Sentinel');
            
    add_rss ( p_name    => 'ANY'
            , p_county  => 'OSCEOLA'
            , p_rss     => 'http://www.orlandosentinel.com/news/local/osceola/rss2.0.xml'
            , p_source  => 'http://www.orlandosentinel.com/'
            , p_rname   => 'Orlando Sentinel');
            
    add_rss ( p_name    => 'ANY'
            , p_county  => 'SEMINOLE'
            , p_rss     => 'http://www.orlandosentinel.com/news/local/seminole/rss2.0.xml'
            , p_source  => 'http://www.orlandosentinel.com/'
            , p_rname   => 'Orlando Sentinel');
            
    add_rss ( p_name    => 'ANY'
            , p_county  => 'SUMTER'
            , p_rss     => 'http://www.sumtercountytimes.com/todaysnews/rss.xml'
            , p_source  => 'http://www.sumtercountytimes.com/'
            , p_rname   => 'Sumter County Times');
            
    add_rss ( p_name    => 'ANY'
            , p_county  => 'VOLUSIA'
            , p_rss     => 'http://www.orlandosentinel.com/news/local/volusia/rss2.0.xml'
            , p_source  => 'http://www.orlandosentinel.com/'
            , p_rname   => 'Orlando Sentinel');

            
    add_rss ( p_name    => 'ANY'
            , p_county  => 'BAKER'
            , p_rss     => 'http://search.firstcoastnews.com/default.aspx?ct=r&type=5,35;6,793;268,6843&ename=rsspage'
            , p_source  => 'http://www.firstcoastnews.com/'
            , p_rname   => 'First Coast News');
            
    add_rss ( p_name    => 'ANY'
            , p_county  => 'CLAY'
            , p_rss     => 'http://search.firstcoastnews.com/default.aspx?ct=r&type=5,35;6,121;268,6843&ename=rsspage'
            , p_source  => 'http://www.firstcoastnews.com/'
            , p_rname   => 'First Coast News');
            
    add_rss ( p_name    => 'ANY'
            , p_county  => 'DUVAL'
            , p_rss     => 'http://search.firstcoastnews.com/default.aspx?ct=R&type=6,803;361,89918&ename=rsspage'
            , p_source  => 'http://www.firstcoastnews.com/'
            , p_rname   => 'First Coast News');
            
    add_rss ( p_name    => 'ANY'
            , p_county  => 'FLAGLER'
            , p_rss     => 'http://flaglerlive.com/category/everything-else/live-wire/feed/'
            , p_source  => 'http://flaglerlive.com/'
            , p_rname   => 'FlaglerLive');
            
    add_rss ( p_name    => 'ANY'
            , p_county  => 'NASSAU'
            , p_rss     => 'http://search.firstcoastnews.com/default.aspx?ct=r&type=5,35;6,818;268,6843&ename=rsspage'
            , p_source  => 'http://www.firstcoastnews.com/'
            , p_rname   => 'First Coast News');
            
    add_rss ( p_name    => 'ANY'
            , p_county  => 'PUTNAM'
            , p_rss     => 'http://search.firstcoastnews.com/default.aspx?ct=r&type=5,35;6,208;268,6843&ename=rsspage'
            , p_source  => 'http://www.firstcoastnews.com/'
            , p_rname   => 'First Coast News');
            
    add_rss ( p_name    => 'ANY'
            , p_county  => 'SAINT JOHNS'
            , p_rss     => 'http://search.firstcoastnews.com/default.aspx?ct=r&type=5,35;6,825;268,6843&ename=rsspage'
            , p_source  => 'http://www.firstcoastnews.com/'
            , p_rname   => 'First Coast News');

    add_rss ( p_name    => 'ANY'
            , p_county  => 'ALACHUA'
            , p_rss     => 'http://www.gainesville.com/rss/articles/NEWS/1002/30'
            , p_source  => 'http://www.gainesville.com/'
            , p_rname   => 'The Gainesville Sun');

    add_rss ( p_name    => 'ANY'
            , p_county  => 'BRADFORD'
            , p_rss     => 'http://search.firstcoastnews.com/default.aspx?ct=r&type=5,35;6,795;268,6843&ename=rsspage'
            , p_source  => 'http://www.firstcoastnews.com/'
            , p_rname   => 'First Coast News');

    add_rss ( p_name    => 'ANY'
            , p_county  => 'COLUMBIA'
            , p_rss     => 'http://search.firstcoastnews.com/default.aspx?ct=r&type=5,35;6,125;268,6843&ename=rsspage'
            , p_source  => 'http://www.firstcoastnews.com/'
            , p_rname   => 'First Coast News');

    add_rss ( p_name    => 'ANY'
            , p_county  => 'DIXIE'
            , p_rss     => 'http://www.wuft.org/news/topics/dixie-county/feed/'
            , p_source  => 'http://www.wuft.org'
            , p_rname   => 'WUFT News');

    add_rss ( p_name    => 'ANY'
            , p_county  => 'GILCHRIST'
            , p_rss     => 'http://www.topix.com/rss/county/gilchrist-fl'
            , p_source  => 'http://www.topix.com/'
            , p_rname   => 'Topix');

    add_rss ( p_name    => 'ANY'
            , p_county  => 'HAMILTON'
            , p_rss     => 'http://www.suwanneedemocrat.com/jasper/atom'
            , p_source  => 'http://www.suwanneedemocrat.com'
            , p_rname   => 'The Suwannee Democrat');
            
    add_rss ( p_name    => 'ANY'
            , p_county  => 'LAFAYETTE'
            , p_rss     => 'http://www.suwanneedemocrat.com/mayo/atom'
            , p_source  => 'http://www.suwanneedemocrat.com'
            , p_rname   => 'The Suwannee Democrat');

    add_rss ( p_name    => 'ANY'
            , p_county  => 'LEVY'
            , p_rss     => 'http://www.chieflandcitizen.com/todaysnews/rss.xml'
            , p_source  => 'http://www.chieflandcitizen.com/'
            , p_rname   => 'The Chiefland Citizen');

    add_rss ( p_name    => 'ANY'
            , p_county  => 'MADISON'
            , p_rss     => 'http://www.topix.com/rss/county/madison-fl'
            , p_source  => 'http://www.topix.com/'
            , p_rname   => 'Topix');
            
    add_rss ( p_name    => 'ANY'
            , p_county  => 'MARION'
            , p_rss     => 'http://www.ocala.com/rss/articles/NEWS/1356/30'
            , p_source  => 'http://www.ocala.com/'
            , p_rname   => 'The Ocala Star-Banner');

    add_rss ( p_name    => 'ANY'
            , p_county  => 'SUWANNEE'
            , p_rss     => 'http://www.suwanneedemocrat.com/branford/atom'
            , p_source  => 'http://www.suwanneedemocrat.com'
            , p_rname   => 'The Suwannee Democrat');

    add_rss ( p_name    => 'ANY'
            , p_county  => 'TAYLOR'
            , p_rss     => 'http://perrynewspapers.com/blog/feed/'
            , p_source  => 'http://perrynewspapers.com'
            , p_rname   => 'Perry News-Herald');

    add_rss ( p_name    => 'ANY'
            , p_county  => 'UNION'
            , p_rss     => 'http://www.topix.com/rss/county/union-fl'
            , p_source  => 'http://www.topix.com/'
            , p_rname   => 'Topix');


    add_rss ( p_name    => 'ANY'
            , p_county  => 'BAY'
            , p_rss     => 'http://www.newsherald.com/cmlink/news-rss-1.2359'
            , p_source  => 'http://www.newsherald.com/'
            , p_rname   => 'The News Herald');


    add_rss ( p_name    => 'ANY'
            , p_county  => 'CALHOUN'
            , p_rss     => 'http://www.thecountyrecord.net/feeds/index.rss2'
            , p_source  => 'http://www.thecountyrecord.net/'
            , p_rname   => 'The County Record');

    add_rss ( p_name    => 'ANY'
            , p_county  => 'ESCAMBIA'
            , p_rss     => 'http://www.northescambia.com/feed'
            , p_source  => 'http://www.northescambia.com/'
            , p_rname   => 'NorthEscambia.com');

    add_rss ( p_name    => 'ANY'
            , p_county  => 'FRANKLIN'
            , p_rss     => 'http://www.apalachtimes.com/cmlink/local-news-rss-1.650'
            , p_source  => 'http://www.apalachtimes.com/'
            , p_rname   => 'The Times Apalachicola & Carrabelle');

    add_rss ( p_name    => 'ANY'
            , p_county  => 'GADSDEN'
            , p_rss     => 'http://www.gadcotimes.com/todaysnews/rss.xml'
            , p_source  => 'http://www.gadcotimes.com/'
            , p_rname   => 'The Gadsden County Times');

    add_rss ( p_name    => 'ANY'
            , p_county  => 'GULF'
            , p_rss     => 'http://www.starfl.com/cmlink/local-news-rss-1.2519'
            , p_source  => 'http://www.starfl.com/'
            , p_rname   => 'The Star');

    add_rss ( p_name    => 'ANY'
            , p_county  => 'HOLMES'
            , p_rss     => 'http://www.chipleypaper.com/cmlink/local-rss-1.770'
            , p_source  => 'http://www.chipleypaper.com/'
            , p_rname   => 'Holmes County Advertiser');

    add_rss ( p_name    => 'ANY'
            , p_county  => 'JACKSON'
            , p_rss     => 'http://www.jcfloridan.com/search/?q=&t=article&l=100&d=&d1=&d2=&s=start_time&sd=desc&c[]=news,news/*&f=rss'
            , p_source  => 'http://www.jcfloridan.com'
            , p_rname   => 'Jackson County Floridian');

    add_rss ( p_name    => 'ANY'
            , p_county  => 'JEFFERSON'
            , p_rss     => 'http://themonticellonews.com/clients/themonticellonews/headlines.rss'
            , p_source  => 'http://themonticellonews.com/'
            , p_rname   => 'The Monticello News');

    add_rss ( p_name    => 'ANY'
            , p_county  => 'LEON'
            , p_rss     => 'http://rssfeeds.tallahassee.com/tallahassee/news'
            , p_source  => 'http://tallahassee.com/'
            , p_rname   => 'Tallahassee Democrat');

    add_rss ( p_name    => 'ANY'
            , p_county  => 'LIBERTY'
            , p_rss     => 'http://www.cljnews.com/feed'
            , p_source  => 'http://www.cljnews.com/'
            , p_rname   => 'The Calhoun-Liberty Journal');

    add_rss ( p_name    => 'ANY'
            , p_county  => 'OKALOOSA'
            , p_rss     => 'http://www.nwfdailynews.com/cmlink/news-rss-1.2266'
            , p_source  => 'http://www.nwfdailynews.com/'
            , p_rname   => 'North West Florida Daily News');

    add_rss ( p_name    => 'ANY'
            , p_county  => 'SANTA ROSA'
            , p_rss     => 'http://www.srpressgazette.com/cmlink/srpg-rss-1.2886'
            , p_source  => 'http://www.srpressgazette.com/'
            , p_rname   => 'Santa Rosa Press Gazette');

    add_rss ( p_name    => 'ANY'
            , p_county  => 'WAKULLA'
            , p_rss     => 'http://www.thewakullanews.com/todaysnews/rss.xml'
            , p_source  => 'http://www.thewakullanews.com/'
            , p_rname   => 'Wakulla News');

    add_rss ( p_name    => 'ANY'
            , p_county  => 'WALTON'
            , p_rss     => 'http://www.chipleypaper.com/cmlink/local-rss-1.770'
            , p_source  => 'http://www.chipleypaper.com/'
            , p_rname   => 'Washington County News');

    add_rss ( p_name    => 'ANY'
            , p_county  => 'WASHINGTON'
            , p_rss     => 'http://www.chipleypaper.com/cmlink/local-rss-1.770'
            , p_source  => 'http://www.chipleypaper.com/'
            , p_rname   => 'Washington County News');

    add_rss ( p_name    => 'ANY'
            , p_county  => 'DESOTO'
            , p_rss     => 'http://www.wfla.com/category/252054/desoto?clienttype=rss'
            , p_source  => 'http://www.wfla.com'
            , p_rname   => 'News Channel 8 WFLA');


    add_rss ( p_name    => 'ANY'
            , p_county  => 'GLADES'
            , p_rss     => ''
            , p_source  => ''
            , p_rname   => '');

    add_rss ( p_name    => 'ANY'
            , p_county  => 'HARDEE'
            , p_rss     => ''
            , p_source  => ''
            , p_rname   => '');

    add_rss ( p_name    => 'ANY'
            , p_county  => 'HENDRY'
            , p_rss     => ''
            , p_source  => ''
            , p_rname   => '');

    add_rss ( p_name    => 'ANY'
            , p_county  => 'HIGHLANDS'
            , p_rss     => 'http://www.wfla.com/category/252050/highlands?clienttype=rss'
            , p_source  => 'http://www.wfla.com'
            , p_rname   => 'News Channel 8 WFLA');

    add_rss ( p_name    => 'ANY'
            , p_county  => 'OKEECHOBEE'
            , p_rss     => 'http://www.tcpalm.com/feeds/headlines/news/local/okeechobee-county/'
            , p_source  => 'http://www.tcpalm.com/'
            , p_rname   => 'TC Palm');

    add_rss ( p_name    => 'ANY'
            , p_county  => 'CHARLOTTE'
            , p_rss     => 'http://www.nbc-2.com/category/170699/news?clienttype=rss'
            , p_source  => 'http://www.nbc-2.com/'
            , p_rname   => 'NBC-2');

    add_rss ( p_name    => 'ANY'
            , p_county  => 'COLLIER'
            , p_rss     => 'http://www.nbc-2.com/category/170699/news?clienttype=rss'
            , p_source  => 'http://www.nbc-2.com/'
            , p_rname   => 'NBC-2');

    add_rss ( p_name    => 'ANY'
            , p_county  => 'LEE'
            , p_rss     => 'http://www.nbc-2.com/category/170699/news?clienttype=rss'
            , p_source  => 'http://www.nbc-2.com/'
            , p_rname   => 'NBC-2');
            

    add_rss ( p_name    => 'ANY'
            , p_county  => 'CITRUS'
            , p_rss     => 'http://www.baynews9.com/content/news/baynews9/feeds/rss.html/citrus.html'
            , p_source  => 'http://www.baynews9.com/'
            , p_rname   => 'Bay News 9');

    add_rss ( p_name    => 'ANY'
            , p_county  => 'HERNANDO'
            , p_rss     => 'http://www.baynews9.com/content/news/baynews9/feeds/rss.html/hernando.html'
            , p_source  => 'http://www.baynews9.com/'
            , p_rname   => 'Bay News 9');

    add_rss ( p_name    => 'ANY'
            , p_county  => 'HILLSBOROUGH'
            , p_rss     => 'http://www.baynews9.com/content/news/baynews9/feeds/rss.html/hillsborough.html'
            , p_source  => 'http://www.baynews9.com/'
            , p_rname   => 'Bay News 9');

    add_rss ( p_name    => 'ANY'
            , p_county  => 'MANATEE'
            , p_rss     => 'http://www.baynews9.com/content/news/baynews9/feeds/rss.html/manatee.html'
            , p_source  => 'http://www.baynews9.com/'
            , p_rname   => 'Bay News 9');

    add_rss ( p_name    => 'ANY'
            , p_county  => 'PASCO'
            , p_rss     => 'http://www.baynews9.com/content/news/baynews9/feeds/rss.html/pasco.html'
            , p_source  => 'http://www.baynews9.com/'
            , p_rname   => 'Bay News 9');

    add_rss ( p_name    => 'ANY'
            , p_county  => 'PINELLAS'
            , p_rss     => 'http://www.baynews9.com/content/news/baynews9/feeds/rss.html/pinellas.html'
            , p_source  => 'http://www.baynews9.com/'
            , p_rname   => 'Bay News 9');

    add_rss ( p_name    => 'ANY'
            , p_county  => 'POLK'
            , p_rss     => 'http://www.baynews9.com/content/news/baynews9/feeds/rss.html/polk.html'
            , p_source  => 'http://www.baynews9.com/'
            , p_rname   => 'Bay News 9');

    add_rss ( p_name    => 'ANY'
            , p_county  => 'SARASOTA'
            , p_rss     => 'http://www.heraldtribune.com/rss/articles/article/2055/10'
            , p_source  => 'http://www.heraldtribune.com/'
            , p_rname   => 'Sarasota Herald-Tribune');

            
    commit;
  end seed_rss;

begin
  seed_rss;
end;
/