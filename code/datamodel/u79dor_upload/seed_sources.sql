set define ^
set serveroutput on size 1000000
declare
  procedure ins_source( p_id in number
                      , p_name in varchar2) is
  begin
    insert into pr_sources (source_id, source_name, source_type)
    values (p_id, p_name||' Property Appraiser', 'Florida DOR');
  end;

  procedure seed_links( p_source     in number
                      , p_type       in varchar2
                      , p_text  in varchar2) is

  begin

    if upper(p_type) = 'TAX' then
      update pr_sources
      set tax_url = p_text
      where source_id = p_source;
    else
      update pr_sources
      set property_url = p_text
      where source_id = p_source;
    end if;
    commit;
  end seed_links;

  procedure seed_photos( p_source     in number
                       , p_base       in varchar2) is
    cursor cur_prop(p_source     in number) is
    select prop_id
    ,      source_pk
    from pr_properties
    where building_count > 0
    and source_id = p_source;

  begin
    for p_rec in cur_prop(p_source) loop
      insert into pr_property_photos (prop_id, url)
      values (p_rec.prop_id, p_base||p_rec.source_pk);
      commit;
    end loop;
  end seed_photos;
  

  
  procedure set_src is
  begin
     ins_source(11, 'Alachua');
     ins_source(44, 'Lafayette');
     ins_source(12, 'Baker');
     ins_source(45, 'Lake');
     ins_source(13, 'Bay');
     ins_source(46, 'Lee');
     ins_source(14, 'Bradford');
     ins_source(47, 'Leon');
     ins_source(48, 'Levy');
     ins_source(16, 'Broward');
     ins_source(49, 'Liberty');
     ins_source(17, 'Calhoun');
     ins_source(50, 'Madison');
     ins_source(18, 'Charlotte');
     ins_source(51, 'Manatee');
     ins_source(19, 'Citrus');
     ins_source(52, 'Marion');
     ins_source(20, 'Clay');
     ins_source(53, 'Martin');
     ins_source(21, 'Collier');
     ins_source(54, 'Monroe');
     ins_source(22, 'Columbia');
     ins_source(55, 'Nassau');
     ins_source(23, 'Miami Dade');
     ins_source(56, 'Okaloosa');
     ins_source(24, 'Desoto');
     ins_source(57, 'Okeechobee');
     ins_source(25, 'Dixie');
     ins_source(26, 'Duval');
     ins_source(59, 'Osceola');
     ins_source(27, 'Escambia');
     ins_source(60, 'Palm Beach');
     ins_source(28, 'Flagler');
     ins_source(61, 'Pasco');
     ins_source(29, 'Franklin');
     ins_source(62, 'Pinellas');
     ins_source(30, 'Gadsden');
     ins_source(63, 'Polk');
     ins_source(31, 'Gilchrist');
     ins_source(64, 'Putnam');
     ins_source(32, 'Glades');
     ins_source(65, 'St. Johns');
     ins_source(33, 'Gulf');
     ins_source(66, 'St. Lucie');
     ins_source(34, 'Hamilton');
     ins_source(67, 'Santa Rosa');
     ins_source(35, 'Hardee');
     ins_source(68, 'Sarasota');
     ins_source(36, 'Hendry');
     ins_source(69, 'Seminole');
     ins_source(37, 'Hernando');
     ins_source(70, 'Sumter');
     ins_source(38, 'Highlands');
     ins_source(71, 'Suwannee');
     ins_source(39, 'Hillsborough');
     ins_source(72, 'Taylor');
     ins_source(40, 'Holmes');
     ins_source(73, 'Union');
     ins_source(41, 'Indian River');
     ins_source(42, 'Jackson');
     ins_source(75, 'Wakulla');
     ins_source(43, 'Jefferson');
     ins_source(76, 'Walton');
     ins_source(77, 'Washington');
  end set_src;
  
  procedure test_data( p_source     in number
                     , p_msg        in varchar2
                     , p_base       in varchar2 := 'http://centos-pc/property/'
                     , p_count      in number := 2) is

    cursor cur_prop( p_source     in number
                   , p_count      in number := 2 ) is
    select prop_id
    from pr_properties
    where building_count > 0
    and source_id = p_source
    and rownum < p_count;

  begin
    dbms_output.put_line(p_msg);
    for p_rec in cur_prop(p_source, p_count) loop
      dbms_output.put_line(p_base||p_rec.prop_id);
    end loop;
  end test_data;
  
  procedure test_data is
  begin
     test_data(11, 'Alachua');
     test_data(44, 'Lafayette');
     test_data(12, 'Baker');
     test_data(45, 'Lake');
     test_data(13, 'Bay');
     test_data(46, 'Lee');
     test_data(14, 'Bradford');
     test_data(47, 'Leon');
     test_data(48, 'Levy');
     test_data(16, 'Broward');
     test_data(49, 'Liberty');
     test_data(17, 'Calhoun');
     test_data(50, 'Madison');
     test_data(18, 'Charlotte');
     test_data(51, 'Manatee');
     test_data(19, 'Citrus');
     test_data(52, 'Marion');
     test_data(20, 'Clay');
     test_data(53, 'Martin');
     test_data(21, 'Collier');
     test_data(54, 'Monroe');
     test_data(22, 'Columbia');
     test_data(55, 'Nassau');
     test_data(23, 'Miami Dade');
     test_data(56, 'Okaloosa');
     test_data(24, 'Desoto');
     test_data(57, 'Okeechobee');
     test_data(25, 'Dixie');
     test_data(26, 'Duval');
     test_data(59, 'Osceola');
     test_data(27, 'Escambia');
     test_data(60, 'Palm Beach');
     test_data(28, 'Flagler');
     test_data(61, 'Pasco');
     test_data(29, 'Franklin');
     test_data(62, 'Pinellas');
     test_data(30, 'Gadsden');
     test_data(63, 'Polk');
     test_data(31, 'Gilchrist');
     test_data(64, 'Putnam');
     test_data(32, 'Glades');
     test_data(65, 'St. Johns');
     test_data(33, 'Gulf');
     test_data(66, 'St. Lucie');
     test_data(34, 'Hamilton');
     test_data(67, 'Santa Rosa');
     test_data(35, 'Hardee');
     test_data(68, 'Sarasota');
     test_data(36, 'Hendry');
     test_data(69, 'Seminole');
     test_data(37, 'Hernando');
     test_data(70, 'Sumter');
     test_data(38, 'Highlands');
     test_data(71, 'Suwannee');
     test_data(39, 'Hillsborough');
     test_data(72, 'Taylor');
     test_data(40, 'Holmes');
     test_data(73, 'Union');
     test_data(41, 'Indian River');
     test_data(42, 'Jackson');
     test_data(75, 'Wakulla');
     test_data(43, 'Jefferson');
     test_data(76, 'Walton');
     test_data(77, 'Washington');
  end test_data;

  procedure set_alt_keys is
    cursor cur_prop(p_source     in number) is
    select prop_id
    ,      source_pk
    from pr_properties
    where source_id = p_source;

    v_alt_key   pr_properties.alt_key%type;
  begin
    for p_rec in cur_prop(26) loop
      -- remove the check digit 0062233060R => 0062233060
      v_alt_key := regexp_substr(p_rec.source_pk, '[0-9]+');
      update pr_properties
      set alt_key = v_alt_key
      where prop_id = p_rec.prop_id;
    end loop;
    commit;
    for p_rec in cur_prop(65) loop
      -- add a space 0819330150 => 081933 0150
      v_alt_key := substr(p_rec.source_pk, 1,6)||' '||substr(p_rec.source_pk, 7,10);
      update pr_properties
      set alt_key = v_alt_key
      where prop_id = p_rec.prop_id;
    end loop;
    commit;
   for p_rec in cur_prop(66) loop
      -- Remove '-' 3419-530-0152-000-3  => 341953001520003
      v_alt_key := replace(p_rec.source_pk, '-', '');
      update pr_properties
      set alt_key = v_alt_key
      where prop_id = p_rec.prop_id;
    end loop;
    commit;
   for p_rec in cur_prop(49) loop
      -- convert ' ' to '-' 031-1N-7W-01413 000 => 031-1N-7W-01413-000
      v_alt_key := replace(p_rec.source_pk, ' ', '-');
      update pr_properties
      set alt_key = v_alt_key
      where prop_id = p_rec.prop_id;
    end loop;
    commit;
   for p_rec in cur_prop(36) loop
      -- convert ' ' to '-'  1 32 44 14 A00 0123.0000 => 1-32-44-14-A00-0123.0000
      v_alt_key := replace(p_rec.source_pk, ' ', '-');
      update pr_properties
      set alt_key = v_alt_key
      where prop_id = p_rec.prop_id;
    end loop;
    commit;
    
   for p_rec in cur_prop(70) loop
      -- Replace '=' with '-' J05=128   => J05-128
      v_alt_key := replace(p_rec.source_pk, '=', '-');
      update pr_properties
      set alt_key = v_alt_key
      where prop_id = p_rec.prop_id;
    end loop;
    commit;
  end set_alt_keys;


  procedure add_urls is
  begin
     seed_links(11, 'PROP', '<a target="new" href="http://www.acpafl.org/ParcelResults.asp?Parcel=[[SOURCE_PK]]">[Property Apprasier]</a>');
--     seed_photos(11, 'http://ira.property-appraiser.org/PropertySearch_services/PropertyPhoto/PropertyPhoto.aspx?pid=');
     
     seed_links(44, 'PROP', '<a target="new" href="http://www.lafayettepa.com/gis/search_f.asp?pin=[[SOURCE_PK]]">[Property Appraiser]</a>');
     seed_links(44, 'TAX', '<a target="new" href="http://www.lafayettetc.com/?PIN=[[SOURCE_PK]]">[Tax Record]</a>');
     
     seed_links(12, 'PROP', '<a target="new" href="http://www.bakerpa.com/gis/search_f.asp?pin=[[SOURCE_PK]]">[Property Appraiser]</a>');
     
     seed_links(45, 'PROP', '<a target="new" href="http://www.lakecopropappr.com/property-details.aspx?AltKey=[[ALT_KEY]]">[Property Apprasier]</a>');
     seed_links(45, 'TAX', '<a target="new" href="https://www.lake.county-taxes.com/public/real_estate/parcels/[[SOURCE_PK]]">[Tax Record]</a>');
     seed_links(13,  'PROP', '<a target="new" href="http://qpublic6.qpublic.net/fl_display_dw.php?county=fl_bay&KEY=[[SOURCE_PK]]">[Property Apprasier]</a>');
     --seed_links(13,  'TAX', '<a target="new" href="http://tc.co.bay.fl.us/Results.aspx?ParcelNumber=[[SOURCE_PK]]">[Tax Record]</a>');
     seed_links(46, 'PROP',
  '<form name="aspnetForm" method="post" action="http://www.leepa.org/Search/PropertySearch.aspx" id="aspnetForm">
  <input name="ctl00$BodyContentPlaceHolder$PropertySearchWizard$STRAPTextBox" type="hidden" id="ctl00_BodyContentPlaceHolder_PropertySearchWizard_STRAPTextBox" value="[[SOURCE_PK]]" />
  <input type="submit" name="ctl00$BodyContentPlaceHolder$PropertySearchWizard$StartNavigationTemplateContainerID$StartNextButton" value="Property Appraiser" id="ctl00_BodyContentPlaceHolder_PropertySearchWizard_StartNavigationTemplateContainerID_StartNextButton" />');

     seed_links(14, 'PROP', '<a target="new" href="http://bradfordappraiser.com/gis/search_f.asp?pin=[[SOURCE_PK]]">[Property Appraiser]</a>');
     seed_links(14, 'TAX', '<a target="new" href="http://qpublic.net/cgi-bin/bctc_display.cgi?Type=Real_Property&KEY=[[SOURCE_PK]]">[Tax Record]</a>');
     
     seed_links(47, 'PROP', '<a target="new" href="http://www.leonpa.org/ACCT.cfm?ACCOUNT=[[ALT_KEY]]">[Property Appraiser]</a>');
     seed_links(47, 'TAX', '<a target="new" href="https://www.leontaxcollector.net/ITM/PropertyDetails.aspx?Acctno=[[ALT_KEY]]&Acctyear=&Acctbtyear=&Page=1">[Tax Record]</a>');

     --seed_links(48, 'Levy');
     seed_links(48, 'PROP', '<a target="new" href="http://qpublic6.qpublic.net/fl_sdisplay.php?county=fl_levy&KEY=[[SOURCE_PK]]">[Property Appraiser]</a>');
     seed_links(48, 'TAX', '<a target="new" href="https://www.lctax.org/ptaxweb/editPropertySearch.do?action=detailByNewYear&property.accountNumber=[[SOURCE_PK]]&taxYear=2011">[Tax Record]</a>');

     --seed_links(16, 'Broward');
     seed_links(16, 'PROP', '<a target="new" href="http://www.bcpa.net/RecInfo.asp?URL_Folio=[[SOURCE_PK]]">[Property Appraiser]</a>');
     seed_links(16, 'TAX', '<a target="new" href="https://www.broward.county-taxes.com/public/real_estate/parcels/[[SOURCE_PK]]/bills">[Tax Record]</a>');

     --seed_links(49, 'Liberty');  need to convert ' ' to '-'
    seed_links(49, 'PROP', '<a target="new" href="http://www.qpublic.net/cgi-bin/liberty_display.cgi?KEY=[[ALT_KEY]]">[Property Appraiser]</a>'); -- replace ' ' with '-'

     --seed_links(17, 'Calhoun');
     seed_links(17, 'PROP', '<a target="new" href="http://www.qpublic.net/cgi-bin/calhoun_display.cgi?KEY=[[SOURCE_PK]]">[Property Appraiser]</a>');
     --seed_links(17, 'TAX', '<a target="new" href="http://www.calhouncountytaxcollector.com/Results.aspx?ParcelNumber=[[SOURCE_PK]]">[Tax Record]</a>');

     --seed_links(50, 'Madison');

     /*href="http://www.madisonpa.com//Photo//08//08-2N-08-2955-001-000//082N082955001000-8796.jpg*/
     --seed_links(50, 'TAX', '<a target="new" href="http://www.madisoncountytaxcollector.com/Results.aspx?ParcelNumber=[[SOURCE_PK]]">[Tax Record]</a>');
     seed_links(50, 'PROP', '<a target="new" href="http://www.madisonpa.com/gis/search_f.asp?pin=[[SOURCE_PK]]">[Property Appraiser]</a>');
     
     --seed_links(18, 'Charlotte');
     seed_links(18, 'PROP', '<a target="new" href="http://ccappraiser.com/Show_parcel.asp?acct=[[SOURCE_PK]]&gen=T&tax=T&bld=T&oth=T&sal=T&lnd=T&leg=T">[Property Appraiser]</a>');
     seed_links(18, 'TAX', '<a target="new" href="https://www.charlotte.county-taxes.com/public/real_estate/parcels/[[SOURCE_PK]]">[Tax Record]</a>');

     --seed_links(51, 'Manatee');
     seed_links(51, 'PROP', '<a target="new" href="http://www.manateepao.com/Forms/PrintDatalet.aspx?pin=[[SOURCE_PK]]&gsp=IDAMAINPAGE&taxyear=2012&jur=51&ownseq=1&card=1&State=1&item=1&items=-1&all=all&ranks=Datalet">[Property Appraiser]</a>');

     --seed_links(19, 'Citrus');
     seed_links(19, 'PROP', '<a target="new" href="http://www.pa.citrus.fl.us/pls/apex/f?p=100:17:3383879345656739::NO::P17_URL:[[ALT_KEY]]">[Property Appraiser]</a>');

     --seed_links(52, 'Marion');
     seed_links(52, 'PROP', '<a target="new" href="http://216.255.243.135/DEFAULT.aspx?Key=[[ALT_KEY]]&YR=2012">[Property Appraiser]</a>');
     seed_links(52, 'TAX', '<a target="new" href="https://www.mariontax.com/itm/PropertyDetails.aspx?Acctno=R[[SOURCE_PK]]&Acctyear=2011&Acctbtyear=&Page=1">[Tax Record]</a>');

     --seed_links(20, 'Clay');
     seed_links(20, 'PROP', '<a target="new" href="http://www.qpublic.net/cgi-bin/clay_display.cgi?KEY=[[SOURCE_PK]]">[Property Appraiser]</a>');
     /*
     seed_links(53, 'Martin');

     <FORM NAME="searchform" METHOD="POST" ACTION="http://fl-martin-appraiser.governmax.com/propertymax/search_property.asp?go.x=1">
     <INPUT TYPE="TEXT" NAME="p.parcelid"  SIZE="40"  MAXLENGTH="40"  VALUE="">
     */
     --seed_links(21, 'Collier'); frames sample id = 00283000005
     --seed_links(21, 'PROP', '<a target="new" href="http://www.collierappraiser.com/RecordDetail.asp?Map=&FolioID=[[SOURCE_PK]]">[Property Appraiser]</a>');
     /*
     seed_links(54, 'Monroe');
       <form name="aspnetForm" method="post" action="PropSearch.aspx" id="aspnetForm">
 Alternate Key:<input name="ctl00$cphPageContent$txtRealRecords_AK" type="text" maxlength="7" id="ctl00_cphPageContent_txtRealRecords_AK" />
                                                                            
       */
     --seed_links(22, 'Columbia');
     seed_links(22, 'PROP', '<a target="new" href="http://g2.columbia.floridapa.com/gis/search_f.asp?pin=[[SOURCE_PK]]">[Property Appraiser]</a>');
     
     --seed_links(55, 'Nassau');
     seed_links(55, 'PROP', '<a target="new" href="http://maps.roktech.net/nassaurevised/SearchDisplay.aspx?ParcelNumber=[[SOURCE_PK]]">[Property Appraiser]</a>');

     --seed_links(23, 'Miami Dade');
      seed_links(23, 'PROP', '<a target="new" href="http://gisims2.miamidade.gov/myhome/proptext.asp?folio=[[SOURCE_PK]]">[Property Appraiser]</a>');

     --seed_links(56, 'Okaloosa');
    seed_links(56, 'PROP', '<a target="new" href="http://www.qpublic.net/cgi-bin/okaloosa_display.cgi?KEY=[[SOURCE_PK]]">[Property Appraiser]</a>');
    seed_links(56, 'TAX', '<a target="new" href="https://www.okaloosa.county-taxes.com/public/real_estate/parcels/[[SOURCE_PK]]">[Tax Record]</a>');

     --seed_links(24, 'Desoto');
    seed_links(24, 'PROP', '<a target="new" href="http://www.desotopa.com/gis/search_f.asp?pin=[[SOURCE_PK]]">[Property Appraiser]</a>');
    seed_links(24, 'TAX', '<a target="new" href="http://www.desotocountytaxcollector.com/Results.aspx?ParcelNumber=[[SOURCE_PK]]&RollType=R&PA=Y&TaxYear=0&SearchType=2">[Tax Record]</a>');

     --seed_links(57, 'Okeechobee');
      seed_links(57, 'PROP', '<a target="new" href="http://www.okeechobeepa.com/GIS/Show_TRIM.asp?link=http://www.okeechobeepa.com/TRIMS/[[SOURCE_PK]].pdf?2012b">[Property Appraiser]</a>');
     

     seed_links(26, 'PROP', '<a target="new" href="http://apps.coj.net/PAO_PropertySearch/Basic/Detail.aspx?RE=[[ALT_KEY]]">[Property Appraiser]</a>');

     
     --seed_links(59, 'Osceola');
    seed_links(59, 'PROP',
       '<a target="new" href="http://ira.property-appraiser.org/PropertySearch/ajax/ParcelSearch.aspx?parcelid=[[SOURCE_PK]]">[Property Apprasier]</a>
        <a target="new" href="http://ira.property-appraiser.org/PropertySearch_services/parcelPdf/?pin=[[SOURCE_PK]]">[Download PDF Data Sheet]</a>');
    seed_links(59, 'TAX',
    '<a target="new" href="https://www.osceola.county-taxes.com/public/real_estate/parcels/[[SOURCE_PK]]">[Tax Record]</a>');
--     seed_photos(59, 'http://ira.property-appraiser.org/PropertySearch_services/PropertyPhoto/PropertyPhoto.aspx?pid=');
     
     --seed_links(27, 'Escambia');
    seed_links(27, 'PROP', '<a target="new" href="http://www.escpa.org/cama/Detail_a.aspx?s=[[SOURCE_PK]]">[Property Appraiser]</a>');
     --could write script to capture images
     
     --seed_links(60, 'Palm Beach');
     seed_links(60, 'PROP', '<a target="new" href="http://www.pbcgov.com/papa/Asps/PropertyDetail/PropertyDetail.aspx?parcel=[[SOURCE_PK]]">[Property Appraiser]</a>');
     
     --seed_links(28, 'Flagler');
     seed_links(28, 'PROP', '<a target="new" href="http://qpublic1.qpublic.net/cgi-bin/flagler_display.cgi?KEY=[[SOURCE_PK]]">[Property Appraiser]</a>');

     --seed_links(29, 'Franklin');
     seed_links(29, 'PROP', '<a target="new" href="http://www.qpublic.net/cgi-bin/franklin_display.cgi?KEY=[[SOURCE_PK]]">[Property Appraiser]</a>');
     

     --seed_links(30, 'Gadsden');
     seed_links(30, 'PROP', '<a target="new" href="http://www.qpublic.net/cgi-bin/gadsden_display.cgi?KEY=[[SOURCE_PK]]">[Property Appraiser]</a>');
     
     --seed_links(63, 'Polk');
     seed_links(63, 'PROP', '<a target="new" href="http://www.polkpa.org/CamaDisplay.aspx?OutputMode=Display&SearchType=RealEstate&ParcelID=[[SOURCE_PK]]">[Property Appraiser]</a>');
     
     --seed_links(31, 'Gilchrist');
     seed_links(31, 'PROP', '<a target="new" href="http://www.qpublic.net/cgi-bin/gilchrist_display.cgi?KEY=[[SOURCE_PK]]">[Property Appraiser]</a>');
     
     --seed_links(64, 'Putnam');
    seed_links(64, 'PROP', '<a target="new" href="http://www.putnam-fl.com/palookup/view.php?gid=[[ALT_KEY]]">[Property Appraiser]</a>');

     --seed_links(32, 'Glades');
    seed_links(32, 'PROP', '<a target="new" href="http://www.qpublic.net/cgi-bin/glades_display.cgi?KEY=[[SOURCE_PK]]">[Property Appraiser]</a>');

     --seed_links(65, 'St. Johns');

     seed_links(65, 'PROP', '<a target="new" href="http://gis2.sjcpa.us/sjcpa/App/webpropcardv4.cfm?strap=[[ALT_KEY]]">[Property Appraiser]</a>');
     
     --seed_links(33, 'Gulf');
    seed_links(33, 'PROP', '<a target="new" href="http://www.qpublic.net/cgi-bin/gulf_display.cgi?KEY=[[SOURCE_PK]]">[Property Appraiser]</a>');

   -- seed_links(66, 'St. Lucie');

    seed_links(66, 'PROP', '<a target="new" href="http://www.paslc.org/paslc/prc.asp?prclid=[[ALT_KEY]]">[Property Appraiser]</a>'); -- works

 --seed_links(34, 'Hamilton');
     seed_links(34, 'PROP', '<a target="new" href="http://www.qpublic.net/cgi-bin/hamilton_display.cgi?KEY=[[SOURCE_PK]]">[Property Appraiser]</a>');
     
     --seed_links(67, 'Santa Rosa');
     seed_links(67, 'PROP', '<a target="new" href="http://qpublic1.qpublic.net/cgi-bin/santarosa_display.cgi?KEY=[[SOURCE_PK]]">[Property Appraiser]</a>');
     
     --seed_links(35, 'Hardee');
     seed_links(35, 'PROP', '<a target="new" href="http://www.qpublic.net/cgi-bin/hardee_display.cgi?KEY=[[SOURCE_PK]]">[Property Appraiser]</a>');

     
     --seed_links(36, 'Hendry'); 
     seed_links(36, 'PROP', '<a target="new" href="http://www.hendryprop.com/GIS/Show_FieldCard.asp?PIN=[[ALT_KEY]]">[Property Appraiser]</a>');
     /*
     may be possible to generate photo urls
     http://www.hendryprop.com//Photo//1-32/1-32-44-22-010-0036-015.0/1-32-44-22-010-0036-015.0_000.JPG
*/
     --seed_links(69, 'Seminole');
     seed_links(69, 'PROP', '<a target="new" href="http://www.scpafl.org/ParcelDetails.aspx?PID=[[SOURCE_PK]]">[Property Appraiser]</a>');

     --seed_links(37, 'Hernando');
     seed_links(37, 'PROP', '<a target="new" href="http://g2.hernando.floridapa.com/GIS/Show_FieldCard_Link.asp?PARCELID=[[ALT_KEY]]&Type=RPRC">[Property Appraiser]</a>');

     --seed_links(70, 'Sumter');
     seed_links(70, 'PROP', '<a target="new" href="http://www.sumterpa.com/gis/search_f.asp?pin=[[ALT_KEY]]">[Property Appraiser]</a>');
     
     --seed_links(71, 'Suwannee');
     seed_links(71, 'PROP', '<a target="new" href="http://www.suwanneepa.com/GIS/Show_FieldCard.asp?PIN=[[SOURCE_PK]]">[Property Appraiser]</a>');
     
     --seed_links(39, 'Hillsborough');
     seed_links(39, 'PROP', '<a target="new" href="http://www.hcpafl.org/CamaDisplay.aspx?OutputMode=Display&SearchType=RealEstate&ParcelID=[[SOURCE_PK]]">[Property Appraiser]</a>');

     --seed_links(72, 'Taylor');
     --seed_links(72, 'PROP', '<a target="new" href="http://www.qpublic.net/cgi-bin/taylor_display.cgi?KEY=[[SOURCE_PK]]">[Property Appraiser]</a>');

     --seed_links(40, 'Holmes');
     seed_links(40, 'PROP', '<a target="new" href="http://www.qpublic.net/cgi-bin/holmes_display.cgi?KEY=[[SOURCE_PK]]">[Property Appraiser]</a>');
     seed_links(40, 'TAX', '<a target="new" href="http://www.holmescountytaxcollector.com/Results.aspx?ParcelNumber=[[SOURCE_PK]]&RollType=R&TaxYear=0&SearchType=2&PA=Y">[Tax Record]</a>');

     --seed_links(73, 'Union');
     seed_links(73, 'TAX', '<a target="new" href="http://qpublic.net/cgi-bin/uctc_display.cgi?Type=Real_Property&KEY=[[SOURCE_PK]]">[Tax Record]</a>');
     seed_links(73, 'PROP', '<a target="new" href="http://g2.union.floridapa.com/gis/search_f.asp?pin=[[SOURCE_PK]]">[Property Appraiser]</a>');
     
     --seed_links(41, 'Indian River');
     seed_links(41, 'PROP', '<a target="new" href="http://www.ircpa.org/Data.aspx?ParcelID=[[SOURCE_PK]]">[Property Appraiser]</a>');
     --http://www.ircpa.org/UserControls/Default.picx?ResourceType=Photos&Website=IndianRiverFL_Auditor&Filename=20010713%5cLD110005.JPG&Random=634824693276967784
     
     --seed_links(42, 'Jackson');
     seed_links(42, 'PROP', '<a target="new" href="http://www.qpublic.net/cgi-bin/jackson_display.cgi?KEY=[[SOURCE_PK]]">[Property Appraiser]</a>');
     seed_links(42, 'TAX', '<a target="new" href="http://www.jacksoncountytaxcollector.com/Results.aspx?ParcelNumber=[[SOURCE_PK]]&RollType=R&TaxYear=0&SearchType=2&PA=Y">[Tax Record]</a>');
     
     --seed_links(75, 'Wakulla');
     seed_links(75, 'PROP', '<a target="new" href="http://www.qpublic.net/cgi-bin/wakulla_display.cgi?KEY=[[SOURCE_PK]]">[Property Appraiser]</a>');
     seed_links(75, 'TAX', '<a target="new" href="http://www.wakullacountytaxcollector.com/Results.aspx?ParcelNumber=[[SOURCE_PK]]&RollType=R&TaxYear=0&SearchType=2&PA=Y">[Tax Record]</a>');
     
     --seed_links(43, 'Jefferson');
     seed_links(43, 'PROP', '<a target="new" href="http://www.jeffersonpa.net/gis/search_f.asp?pin=[[SOURCE_PK]]">[Property Appraiser]</a>');
     seed_links(43, 'TAX', '<a target="new" href="http://www.jeffersoncountytaxcollector.com/Results.aspx?ParcelNumber=[[SOURCE_PK]]&RollType=R&PA=Y&TaxYear=0&SearchType=2">[Tax Record]</a>');
     
     --seed_links(76, 'Walton');
     seed_links(76, 'PROP', '<a target="new" href="http://qpublic1.qpublic.net/cgi-bin/walton_display.cgi?KEY=[[SOURCE_PK]]">[Property Appraiser]</a>');
     --seed_links(77, 'Washington');
     seed_links(77, 'PROP', '<a target="new" href="http://www.qpublic.net/cgi-bin/washington_display.cgi?KEY=[[SOURCE_PK]]">[Property Appraiser]</a>');
     
  end add_urls;
  
  begin
--    set_src;
    set_alt_keys;
    add_urls;
    commit;
    --test_data;
     
    
  end;
/  
