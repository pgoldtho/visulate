set define '^'
declare

  cursor cur_property is
  select "TaxAcct"          source_pk
  ,      "OwnerName"        owner_name
  ,      rtrim("SiteHouseNo"||' '||"SiteStreetname"||' '||"SiteType"||' '||"SiteDir") address1
  ,      "SiteAptNo"        address2
  ,      "SiteCity"         city
  ,      "SiteZip5"         zipcode
  ,      "BuildingSqFt"     sq_ft
  ,      "Acreage"          acreage
  ,      "MailHouseNo"||' '||"MailAddressLine1" mail_address1
  ,      "MailAddressLine2" mail_address2
  ,      "MailCity"         mail_city
  ,      "MailState"        mail_state
  ,      "MailZip5"         mail_zipcode
  from brd_properties;


  v_source_id         PR_SOURCES.SOURCE_ID%TYPE;
  v_prop_id           PR_PROPERTIES.PROP_ID%TYPE;
  v_mail_id           PR_PROPERTIES.PROP_ID%TYPE;
  v_owner_id          PR_OWNERS.OWNER_ID%type;
  v_address2          pr_properties.address2%type;
  v_counter           pls_integer;

begin
/*
  v_source_id := pr_records_pkg.insert_source
    ( x_source_name  => 'Brevard Property Appraiser'
    , x_source_type  => 'Tax Appraiser'
    , x_base_url     => 'http://www.brevardpropertyappraiser.com/'
    , x_photo_url    => 'http://www.brevardpropertyappraiser.com/asp/show_buildings.asp?taxAcct=[[SOURCE_PK]]'
    , x_property_url => 'http://www.brevardpropertyappraiser.com/asp/Show_parcel.asp?acct=[[SOURCE_PK]]&gen=T&tax=T&bld=T&oth=T&sal=T&lnd=T&leg=T&GoWhere=real_search.asp&SearchBy=Tax'
    , x_platbook_url => 'http://www.brevardpropertyappraiser.com/asp/_include/bookpage_link.asp?book=[[PLATBOOK]]&page=[[PLATPAGE]]'
    , x_tax_url      => 'http://www.brevardpropertyappraiser.com/asp/_include/tax_link.asp?taxAcct=[[SOURCE_PK]]'
    , x_pk_column_name => 'TaxAcct');
*/

  v_source_id := 3;
                                             
  for p_rec in cur_property loop  
    if p_rec.address1 != '0' then
 
       if p_rec.address2 is not null then
          v_address2 := p_rec.address2;
       else
          v_address2 := '';
       end if;

       v_prop_id := PR_RECORDS_PKG.get_prop_id
          ( X_ADDRESS1  => p_rec.address1
          , X_ADDRESS2  => p_rec.address2
          , x_ZIPCODE   => p_rec.zipcode);

-- dbms_output.put_line('prop_id='||v_mail_id);

     if v_prop_id is null then
-- dbms_output.put_line(p_rec.source_pk ||' '||p_rec.address1);
       v_prop_id := PR_RECORDS_PKG.insert_property
          ( X_SOURCE_ID => v_source_id
          , X_SOURCE_PK => p_rec.source_pk
          , X_ADDRESS1  => p_rec.address1
          , X_ADDRESS2  => v_address2
          , X_CITY      => p_rec.city
          , X_STATE     => 'FL'
          , X_ZIPCODE   => p_rec.zipcode
          , X_ACREAGE   => p_rec.acreage
          , X_SQ_FT     => p_rec.sq_ft);
     else
       update pr_properties 
       set source_pk = p_rec.source_pk
       ,   acreage   = p_rec.acreage
       ,   sq_ft     = p_rec.sq_ft
       where prop_id = v_prop_id;
     end if;


     v_mail_id := PR_RECORDS_PKG.get_prop_id
          ( X_ADDRESS1  => p_rec.mail_address1
          , X_ADDRESS2  => p_rec.mail_address2
          , x_ZIPCODE   => p_rec.mail_zipcode);
-- dbms_output.put_line('mail_id='||v_mail_id);
     if v_mail_id is null then
-- dbms_output.put_line(p_Rec.source_pk||'mail='||p_rec.mail_address1||' '||p_rec.mail_address2||' '||p_rec.mail_zipcode);
        v_mail_id := PR_RECORDS_PKG.insert_property
          ( X_SOURCE_ID => v_source_id
          , X_SOURCE_PK => ''
          , X_ADDRESS1  => p_rec.mail_address1
          , X_ADDRESS2  => p_rec.mail_address2
          , X_CITY      => nvl(p_rec.mail_city, 'XXXXX')
          , X_STATE     => nvl(p_rec.mail_state, 'XX')
          , X_ZIPCODE   => nvl(p_rec.mail_zipcode, 'XXXXX')
          , X_ACREAGE   => ''
          , X_SQ_FT     => '');
     end if;

     if p_rec.owner_name is not null then
       v_owner_id := pr_records_pkg.get_owner_id(p_rec.owner_name, v_mail_id);

       if v_owner_id is null then
          v_owner_id := pr_records_pkg.insert_owner
                      ( x_owner_name => p_rec.owner_name
                      , x_owner_type => '');
       end if;

       select count(*)
       into v_counter
       from pr_property_owners
       where owner_id = v_owner_id
       and   prop_id = v_prop_id;

       if v_counter = 0 then
         pr_records_pkg.insert_property_owner
             ( x_owner_id   => v_owner_id
             , x_prop_id    => v_prop_id
             , x_mailing_id => v_mail_id);
--       else
--         dbms_output.put_line('found dup');
       end if;
     end if;
     commit;
    end if;
  end loop;
end;
/     