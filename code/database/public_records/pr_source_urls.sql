set define ^
declare
  procedure update_url( p_property_url   in varchar2
                  , p_tax_url        in varchar2
                  , p_photo_url      in varchar2
                  , p_source_id      in number ) is
  begin
    update pr_sources
    set PROPERTY_URL = p_property_url
    ,   TAX_URL      = p_tax_url
    ,   PHOTO_URL    = p_photo_url
    where SOURCE_ID = p_source_id;
  end update_url;

  procedure update_urls is
  begin

    update_url( p_property_url => 'https://www.bcpao.us/propertysearch/#/account/[[SOURCE_PK]]'
          , p_tax_url => 'https://brevard.county-taxes.com/public/real_estate/parcels/[[SOURCE_PK]]'
          , p_photo_url =>
'<a href="http://map.bcpao.us/map2/photos.aspx?taxacct=[[SOURCE_PK]]" target="_blank">[Property Photos]</a>
 <a href="http://map.bcpao.us/map2/default.aspx?taxacct=[[SOURCE_PK]]" target="_blank">[Aerial Plot]</a>'
          , p_source_id => 3 ); -- Brevard Property Appraiser

    update_url( p_property_url => 'http://vcpa.vcgov.org/propertyLookup.html?Alt_key=[[SOURCE_PK]]'
              , p_tax_url => 'https://www.volusia.county-taxes.com/public/search?search_query=[[SOURCE_PK]]&category=all'
              , p_photo_url => ''
              , p_source_id => 4); -- Volusia County Property Appraiser

    update_url( p_property_url =>'http://www.ocpafl.org/searches/ParcelSearch.aspx?pid=[[SOURCE_PK]]'
              , p_tax_url => ''
              , p_photo_url =>
'<form><input type="button" value="Map and Aerial Photo"
              onclick="parent.location=''http://paarcgis.ocpafl.org/Webmap3/default.aspx?pin=[[SOURCE_PK]]''"/><br/>
<a href="http://paarcgis.ocpafl.org/Webmap3/default.aspx?pin=[[SOURCE_PK]]" target="_new">[Map and Aerial Photo]</a>
</form>'
              , p_source_id => 5); -- Orange County Property Appraiser

    update_url( p_property_url => 'http://www.acpafl.org/ParcelResults.asp?Parcel=[[SOURCE_PK]]'
              , p_tax_url => ''
              , p_photo_url => ''
              , p_source_id => 11); -- Alachua Property Appraiser

    update_url( p_property_url => 'http://www.bakerpa.com/gis/search_f.asp?pin=[[SOURCE_PK]]'
              , p_tax_url => ''
              , p_photo_url => ''
              , p_source_id => 12); -- Baker Property Appraiser

    update_url( p_property_url => 'http://qpublic6.qpublic.net/fl_display_dw.php?county=fl_bay&KEY=[[SOURCE_PK]]'
              , p_tax_url => 'http://tc.co.bay.fl.us/Property/TASearchResults?propertynumber=[[SOURCE_PK]]'
              , p_photo_url => ''
              , p_source_id => 13); -- Bay Property Appraiser

    update_url( p_property_url => 'http://bradfordappraiser.com/gis/search_f.asp?pin=[[SOURCE_PK]]'
              , p_tax_url => 'http://qpublic.net/cgi-bin/bctc_display.cgi?Type=Real_Property&KEY=[[SOURCE_PK]]'
              , p_photo_url => ''
              , p_source_id => 14); -- Bradford Property Appraiser

    update_url( p_property_url => 'http://www.bcpa.net/RecInfo.asp?URL_Folio=[[SOURCE_PK]]'
              , p_tax_url => 'https://www.broward.county-taxes.com/public/real_estate/parcels/[[SOURCE_PK]]/bills'
              , p_photo_url => ''
              , p_source_id => 16); -- Broward Property Appraiser

    update_url( p_property_url => 'http://www.qpublic.net/cgi-bin/calhoun_display.cgi?KEY=[[SOURCE_PK]]'
              , p_tax_url => 'http://www.calhouncountytaxcollector.com/Property/TASearchResults?propertynumber=[[SOURCE_PK]]'
              , p_photo_url => ''
              , p_source_id => 17); -- Calhoun Property Appraiser

    update_url( p_property_url => 'https://www.ccappraiser.com/Show_parcel.asp?acct=[[SOURCE_PK]]&gen=T&tax=T&bld=T&oth=T&sal=T&lnd=T&leg=T'
              , p_tax_url => 'https://www.charlotte.county-taxes.com/public/real_estate/parcels/[[SOURCE_PK]]'
              , p_photo_url => ''
              , p_source_id => 18); -- Charlotte Property Appraiser

    update_url( p_property_url => 'http://www.pa.citrus.fl.us/pls/apex/f?p=100:17:3383879345656739::NO::P17_URL:[[ALT_KEY]]'
              , p_tax_url => ''
              , p_photo_url => ''
              , p_source_id => 19); -- Citrus Property Appraiser

    update_url( p_property_url => 'http://www.qpublic.net/cgi-bin/clay_display.cgi?KEY=[[SOURCE_PK]]'
              , p_tax_url => ''
              , p_photo_url => ''
              , p_source_id => 20); -- Clay Property Appraiser

    update_url( p_property_url => 'http://www.collierappraiser.com/index.html?page=main_search/recorddetail.html&folioid=[[SOURCE_PK]]'
              , p_tax_url => 'http://www.colliertax.com/search/view.php?ID=[[SOURCE_PK]]&page=1&tc=1'
              , p_photo_url => ''
              , p_source_id => 21); -- Collier Property Appraiser

    update_url( p_property_url => 'http://g2.columbia.floridapa.com/gis/search_f.asp?pin=[[SOURCE_PK]]'
              , p_tax_url => ''
              , p_photo_url => ''
              , p_source_id => 22); -- Columbia Property Appraiser

    update_url( p_property_url => 'http://www.miamidade.gov/propertysearch/#/?folio=[[SOURCE_PK]]'
              , p_tax_url => 'https://www.miamidade.county-taxes.com/public/real_estate/parcels/[[SOURCE_PK]]'
              , p_photo_url => ''
              , p_source_id => 23); -- Miami Dade Property Appraiser

    update_url( p_property_url => 'http://www.desotopa.com/gis/search_f.asp?pin=[[SOURCE_PK]]'
              , p_tax_url => 'http://www.desotocountytaxcollector.com/Property/TASearchResults?propertynumber=[[SOURCE_PK]]'
              , p_photo_url => ''
              , p_source_id => 24); -- Desoto Property Appraiser

    update_url( p_property_url => 'http://www.qpublic.net/fl_search.php?county=fl_dixie&searchType=address'
              , p_tax_url => ''
              , p_photo_url => ''
              , p_source_id => 25); -- Dixie Property Appraiser

    update_url( p_property_url => 'http://apps.coj.net/PAO_PropertySearch/Basic/Detail.aspx?RE=[[ALT_KEY]]'
              , p_tax_url => ''
              , p_photo_url => ''
              , p_source_id => 26); -- Duval Property Appraiser

    update_url( p_property_url => 'http://www.escpa.org/cama/Detail_a.aspx?s=[[SOURCE_PK]]'
              , p_tax_url => ''
              , p_photo_url => ''
              , p_source_id => 27); -- Escambia Property Appraiser

    update_url( p_property_url => 'http://qpublic6.qpublic.net/fl_display_dw.php?county=fl_flagler&KEY=[[SOURCE_PK]]'
              , p_tax_url => ''
              , p_photo_url => ''
              , p_source_id => 28); -- Flagler Property Appraiser

    update_url( p_property_url => 'http://www.qpublic.net/cgi-bin/franklin_display.cgi?KEY=[[SOURCE_PK]]'
              , p_tax_url => ''
              , p_photo_url => ''
              , p_source_id => 29); -- Franklin Property Appraiser

    update_url( p_property_url => 'http://www.qpublic.net/cgi-bin/gadsden_display.cgi?KEY=[[SOURCE_PK]]'
              , p_tax_url => ''
              , p_photo_url => ''
              , p_source_id => 30); -- Gadsden Property Appraiser

    update_url( p_property_url => 'http://www.qpublic.net/cgi-bin/gilchrist_display.cgi?KEY=[[SOURCE_PK]]'
              , p_tax_url => ''
              , p_photo_url => ''
              , p_source_id => 31); -- Gilchrist Property Appraiser

    update_url( p_property_url => 'http://www.qpublic.net/cgi-bin/glades_display.cgi?KEY=[[SOURCE_PK]]'
              , p_tax_url => ''
              , p_photo_url => ''
              , p_source_id => 32); -- Glades Property Appraiser

    update_url( p_property_url => 'http://www.qpublic.net/cgi-bin/gulf_display.cgi?KEY=[[SOURCE_PK]]'
              , p_tax_url => ''
              , p_photo_url => ''
              , p_source_id => 33); -- Gulf Property Appraiser

    update_url( p_property_url => 'http://www.qpublic.net/cgi-bin/hamilton_display.cgi?KEY=[[SOURCE_PK]]'
              , p_tax_url => ''
              , p_photo_url => ''
              , p_source_id => 34); -- Hamilton Property Appraiser

    update_url( p_property_url => 'http://www.qpublic.net/cgi-bin/hardee_display.cgi?KEY=[[SOURCE_PK]]'
              , p_tax_url => ''
              , p_photo_url => ''
              , p_source_id => 35); -- Hardee Property Appraiser

    update_url( p_property_url => 'http://www.hendryprop.com/PAlink.asp?pin=[[SOURCE_PK]]'
              , p_tax_url => ''
              , p_photo_url => ''
              , p_source_id => 36); -- Hendry Property Appraiser

    update_url( p_property_url => 'https://www.hernandocountygis-fl.us/propertysearch/default.aspx?pinkey=[[ALT_KEY]]&TabView=4'
              , p_tax_url => 'https://www.hernandopa-fl.us/CATSLIB6/NoFramework.aspx?sessiondata=[[ALT_KEY]]AKEY'
              , p_photo_url => ''
              , p_source_id => 37); -- Hernando Property Appraiser

    update_url( p_property_url => 'http://www.appraiser.co.highlands.fl.us/perl/re2html.pl?strap=[[ALT_KEY]]'
              , p_tax_url => ''
              , p_photo_url => ''
              , p_source_id => 38); -- Highlands Property Appraiser

    update_url( p_property_url => 'http://gis.hcpafl.org/propertysearch/#/parcel/basic/[[SOURCE_PK]]'
              , p_tax_url => ''
              , p_photo_url => ''
              , p_source_id => 39); -- Hillsborough Property Appraiser

    update_url( p_property_url => 'http://www.qpublic.net/cgi-bin/holmes_display.cgi?KEY=[[SOURCE_PK]]'
              , p_tax_url => 'http://www.holmescountytaxcollector.com/Property/TASearchResults?propertynumber=[[SOURCE_PK]]'
              , p_photo_url => ''
              , p_source_id => 40); -- Holmes Property Appraiser

    update_url( p_property_url => 'http://www.ircpa.org/Data.aspx?ParcelID=[[SOURCE_PK]]'
              , p_tax_url => 'https://www.indianriver.county-taxes.com/public/search?search_query=[[ALT_KEY]]'
              , p_photo_url => ''
              , p_source_id => 41); -- Indian River Property Appraiser

    update_url( p_property_url => 'http://www.qpublic.net/cgi-bin/jackson_display.cgi?KEY=[[SOURCE_PK]]'
              , p_tax_url => 'http://www.jacksoncountytaxcollector.com/Property/TASearchResults?propertynumber=[[SOURCE_PK]]'
              , p_photo_url => ''
              , p_source_id => 42); -- Jackson Property Appraiser

    update_url( p_property_url => 'http://www.jeffersonpa.net/gis/search_f.asp?pin=[[SOURCE_PK]]'
              , p_tax_url => 'http://www.jeffersoncountytaxcollector.com/Property/TASearchResults?propertynumber=[[SOURCE_PK]]'
              , p_photo_url => ''
              , p_source_id => 43); -- Jefferson Property Appraiser

    update_url( p_property_url => 'http://g2.lafayettepa.com/GIS/Search_F.asp?PIN=[[SOURCE_PK]]'
              , p_tax_url => 'http://www.lafayettetc.com/?PIN=[[SOURCE_PK]]'
              , p_photo_url => ''
              , p_source_id => 44); -- Lafayette Property Appraiser

    update_url( p_property_url => 'http://www.lakecopropappr.com/property-details.aspx?AltKey=[[ALT_KEY]]'
              , p_tax_url => 'https://www.lake.county-taxes.com/public/real_estate/parcels/[[SOURCE_PK]]'
              , p_photo_url => ''
              , p_source_id => 45); -- Lake Property Appraiser

    update_url( p_property_url => 'http://www.leepa.org/Display/DisplayParcel.aspx?Strap=[[SOURCE_PK]]'
              , p_tax_url => ''
              , p_photo_url => ''
              , p_source_id => 46); -- Lee Property Appraiser

    update_url( p_property_url => 'http://cms.leoncountyfl.gov/prop/searchgeneral.aspx?ACCT=[[SOURCE_PK]]'
              , p_tax_url => 'https://www.leontaxcollector.net/ITM/PropertyDetails.aspx?Acctno=[[ALT_KEY]]&Acctyear=&Acctbtyear=&Page=1'
              , p_photo_url => ''
              , p_source_id => 47); -- Leon Property Appraiser

    update_url( p_property_url => 'http://qpublic6.qpublic.net/fl_sdisplay.php?county=fl_levy&KEY=[[SOURCE_PK]]'
              , p_tax_url => 'https://www.lctax.org/ptaxweb/editPropertySearch.do?action=detailByNewYear&property.accountNumber=[[SOURCE_PK]]&taxYear=2011'
              , p_photo_url => ''
              , p_source_id => 48); -- Levy Property Appraiser

    update_url( p_property_url => 'http://www.qpublic.net/cgi-bin/liberty_display.cgi?KEY=[[ALT_KEY]]'
              , p_tax_url => ''
              , p_photo_url => ''
              , p_source_id => 49); -- Liberty Property Appraiser

    update_url( p_property_url => 'http://www.madisonpa.com/gis/search_f.asp?pin=[[SOURCE_PK]]'
              , p_tax_url => 'http://www.madisoncountytaxcollector.com/Property/TASearchResults?propertynumber=[[SOURCE_PK]]'
              , p_photo_url => ''
              , p_source_id => 50); -- Madison Property Appraiser

    update_url( p_property_url => 'http://www.manateepao.com/ManateeFL/forms/datalets.aspx?mode=idamainpage&UseSearch=no&pin=[[SOURCE_PK]]'
              , p_tax_url => 'https://secure.taxcollector.com/ptaxweb/editPropertySearch.do?action=detail&fromLocation=PAO&accountNumber=[[SOURCE_PK]]&taxYear=2014'
              , p_photo_url => ''
              , p_source_id => 51); -- Manatee Property Appraiser

    update_url( p_property_url => 'http://216.255.243.135/DEFAULT.aspx?Key=[[ALT_KEY]]'
              , p_tax_url => 'https://www.mariontax.com/itm/PropertyDetails.aspx?Acctno=R[[SOURCE_PK]]&Acctyear=2011&Acctbtyear=&Page=1'
              , p_photo_url => ''
              , p_source_id => 52); -- Marion Property Appraiser

    update_url( p_property_url => 'http://geoweb.martin.fl.us/info/pi.html?pcn=[[SOURCE_PK]]0000'
              , p_tax_url => 'http://taxcol.martin.fl.us/itm32/PropertySummary.aspx?Search=Property&Account=[[SOURCE_PK]]0000'
              , p_photo_url => ''
              , p_source_id => 53); -- Martin Property Appraiser

    update_url( p_property_url => 'http://www.mcpafl.org/TaxEstimator.aspx?AK=[[ALT_KEY]]'
              , p_tax_url => ''
              , p_photo_url => ''
              , p_source_id => 54); -- Monroe Property Appraiser

    update_url( p_property_url => 'http://maps2.roktech.net/NassauSearch/ISRecentSales/NassauProperty.aspx?ParcelNumber=[[SOURCE_PK]]'
              , p_tax_url => 'https://nassau.county-taxes.com/public/search?search_query=[[SOURCE_PK]]&category=all'
              , p_photo_url => ''
              , p_source_id => 55); -- Nassau Property Appraiser

    update_url( p_property_url => 'http://www.qpublic.net/cgi-bin/okaloosa_display.cgi?KEY=[[SOURCE_PK]]'
              , p_tax_url => 'https://www.okaloosa.county-taxes.com/public/real_estate/parcels/[[SOURCE_PK]]'
              , p_photo_url => ''
              , p_source_id => 56); -- Okaloosa Property Appraiser

    update_url( p_property_url => 'http://www.okeechobeepa.com/GIS/Search_F.asp?PIN=[[SOURCE_PK]]'
              , p_tax_url => 'http://www.okeechobeecountytaxcollector.com/Property/TASearchResults?propertynumber=[[SOURCE_PK]]'
              , p_photo_url => ''
              , p_source_id => 57); -- Okeechobee Property Appraiser

    update_url( p_property_url => 'http://ira.property-appraiser.org/PropertySearch/Default.aspx?pin=[[SOURCE_PK]]'
              , p_tax_url => 'https://www.osceola.county-taxes.com/public/real_estate/parcels/[[SOURCE_PK]]'
              , p_photo_url => ''
              , p_source_id => 59); -- Osceola Property Appraiser

    update_url( p_property_url => 'http://www.pbcgov.com/papa/Asps/PropertyDetail/PropertyDetail.aspx?parcel=[[SOURCE_PK]]'
              , p_tax_url => 'http://pbctax.manatron.com/tabs/propertyTax/accountdetail.aspx?p=[[ALT_KEY]]'
              , p_photo_url => ''
              , p_source_id => 60); -- Palm Beach Property Appraiser

    update_url( p_property_url => 'http://appraiser.pascogov.com/search/parcel.aspx?parcel=[[SOURCE_PK]]'
              , p_tax_url => 'http://search.pascotaxes.com/Search/prclmain.aspx?parcel=[[ALT_KEY]]'
              , p_photo_url => ''
              , p_source_id => 61); -- Pasco Property Appraiser

    update_url( p_property_url => 'http://www.pcpao.org/clik.html?pg=http://www.pcpao.org/general.php?strap=[[ALT_KEY]]'
              , p_tax_url => ''
              , p_photo_url => ''
              , p_source_id => 62); -- Pinellas Property Appraiser

    update_url( p_property_url => 'http://www.polkpa.org/CamaDisplay.aspx?OutputMode=Display&SearchType=RealEstate&ParcelID=[[SOURCE_PK]]'
              , p_tax_url => ''
              , p_photo_url => ''
              , p_source_id => 63); -- Polk Property Appraiser

    update_url( p_property_url => 'http://www.putnam-fl.com/palookup/view.php?gid=[[ALT_KEY]]'
              , p_tax_url => ''
              , p_photo_url => ''
              , p_source_id => 64); -- Putnam Property Appraiser

    update_url( p_property_url => 'http://gis2.sjcpa.us/sjcpa/App/webpropcardv4.cfm?strap=[[ALT_KEY]]'
              , p_tax_url => ''
              , p_photo_url => ''
              , p_source_id => 65); -- St. Johns Property Appraiser

    update_url( p_property_url => 'http://www.paslc.org/paslc/prc.asp?prclid=[[ALT_KEY]]'
              , p_tax_url => ''
              , p_photo_url => ''
              , p_source_id => 66); -- St. Lucie Property Appraiser

    update_url( p_property_url => 'http://qpublic1.qpublic.net/cgi-bin/santarosa_display.cgi?KEY=[[SOURCE_PK]]'
              , p_tax_url => ''
              , p_photo_url => ''
              , p_source_id => 67); -- Santa Rosa Property Appraiser

    update_url( p_property_url => 'http://www.sc-pa.com/testsearch/parcel/details/[[SOURCE_PK]]'
              , p_tax_url => ''
              , p_photo_url => ''
              , p_source_id => 68); -- Sarasota Property Appraiser

    update_url( p_property_url => 'http://parceldetail.scpafl.org/ParcelDetailInfo.aspx?PID=[[SOURCE_PK]]'
              , p_tax_url => ''
              , p_photo_url => ''
              , p_source_id => 69); -- Seminole Property Appraiser

    update_url( p_property_url => 'http://www.sumterpa.com/gis/search_f.asp?pin=[[ALT_KEY]]'
              , p_tax_url => ''
              , p_photo_url => ''
              , p_source_id => 70); -- Sumter Property Appraiser

    update_url( p_property_url => 'http://www.suwanneepa.com/GIS/Show_FieldCard.asp?PIN=[[SOURCE_PK]]'
              , p_tax_url => ''
              , p_photo_url => ''
              , p_source_id => 71); -- Suwannee Property Appraiser

    update_url( p_property_url => 'http://www.qpublic.net/cgi-bin/taylor_display.cgi?KEY=[[SOURCE_PK]]'
              , p_tax_url => ''
              , p_photo_url => ''
              , p_source_id => 72); -- Taylor Property Appraiser

    update_url( p_property_url => 'http://g2.union.floridapa.com/gis/search_f.asp?pin=[[SOURCE_PK]]'
              , p_tax_url => 'http://www.unioncountytc.com/Property/TASearchResults?propertynumber=[[SOURCE_PK]]'
              , p_photo_url => ''
              , p_source_id => 73); -- Union Property Appraiser

    update_url( p_property_url => 'http://www.qpublic.net/cgi-bin/wakulla_display.cgi?KEY=[[SOURCE_PK]]'
              , p_tax_url => 'http://www.wakullacountytaxcollector.com/Property/TASearchResults?propertynumber=[[SOURCE_PK]]'
              , p_photo_url => ''
              , p_source_id => 75); -- Wakulla Property Appraiser

    update_url( p_property_url => 'http://qpublic6.qpublic.net/fl_display_dw.php?county=fl_walton&KEY=[[SOURCE_PK]]'
              , p_tax_url => ''
              , p_photo_url => ''
              , p_source_id => 76); -- Walton Property Appraiser

    update_url( p_property_url => 'http://www.qpublic.net/cgi-bin/washington_display.cgi?KEY=[[SOURCE_PK]]'
              , p_tax_url => ''
              , p_photo_url => ''
              , p_source_id => 77); -- Washington Property Appraiser


  end update_urls;

begin
  update_urls;
end;
/
