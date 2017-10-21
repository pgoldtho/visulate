set define ~
create or replace package mls_brevard_pkg as
/*******************************************************************************
   Copyright (c) Visulate 2011        All rights reserved worldwide
    Name:      MLS_BREVARD_PKG
    Purpose:   MLS Replication API's 
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        12-DEC-11   Peter Goldthorp   Initial Version
*******************************************************************************/
  global_login     varchar2(256) := 'rets.offutt-innovia.com:8080/brv/login';
  global_user      varchar2(16)  := 'Su3Gold!';
  global_passwd    varchar2(16)  := 'P3tGo14';
  global_base      varchar2(256) := 'http://rets.offutt-innovia.com:8080/brv/Search?SearchType=Property';
  global_src       number := 6; -- Brevard MLS
  global_tax       number := 3; -- Brevard Property Appraiser
  global_photo_url varchar2(256) := 'http://www.brevardmls.com/brv/jpg';
  global_brokers   varchar2(256) := 'http://rets.offutt-innovia.com:8080/brv/Search?SearchType=Office&Class=Office&Format=COMPACT-DECODED&QueryType=DQML2';
  
  
  function get_select_vals return pr_rets_pkg.value_table;

  function get_id( p_source_id  in mls_listings.source_id%type
                 , p_mls_number in mls_listings.mls_number%type)
				 return mls_listings.mls_id%type;
  
  procedure get_brokers;  
  function  get_broker_name(p_broker_uid in varchar2) return varchar2;
  procedure get_listings;
  procedure process_listings;
  procedure get_listings(p_ltype  in varchar2);
  procedure process_listings(p_ltype  in varchar2);
  procedure update_mls;
end mls_brevard_pkg;
/  
                                   
create or replace package body mls_brevard_pkg as
/*******************************************************************************
   Copyright (c) Visulate 2011        All rights reserved worldwide
    Name:      MLS_BREVARD_PKG
    Purpose:   MLS Replication API's 
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        12-DEC-11   Peter Goldthorp   Initial Version
*******************************************************************************/
  function get_select_vals return pr_rets_pkg.value_table is
    v_select pr_rets_pkg.value_table;
  begin
    v_select('ResidentialProperty') :=
      'ListingID,Bedrooms,BathsTotal,BathsHalf,ListDate,IDX,ListPrice,OriginalListPrice,PhotoCount'
      ||',OriginalListingFirmName,TaxID,ShortSaleYN,OfficeIDX,PublicRemarks,OwnerBankCorporationYN'
      ||',ListingOfficeUID,SqFtLivingArea,Parking,PoolPresent,VirtualTourURL,OwnerWillConsider';    
    v_select('CommercialProperty') :=
      'ListingID,SaleLease,ListDate,IDX,ListPrice,LeaseType,OriginalListPrice,PhotoCount,SqFtTotal,PropertyType'
      ||',OriginalListingFirmName,TaxID,ShortSaleYN,OfficeIDX,PublicRemarks,OwnerBankCorporationYN'
      ||',ListingOfficeUID,CurrentUse,SiteImprovements,InteriorImprovements,AssumableLoanYN';    
    v_select('IncomeProperty') :=
      'ListingID,ListDate,IDX,ListPrice,OriginalListPrice,PhotoCount,PropertyType'
      ||',TaxID,ShortSaleYN,OfficeIDX,PublicRemarks,OwnerBankCorporationYN'
      ||',ListingOfficeUID,SqFtLivingArea,OwnerWillConsider';    
    v_select('VacantLand') :=
      'ListingID,ListDate,IDX,ListPrice,PhotoCount,Area,PropertyUse,PreviousListPrice'
      ||',TaxID,ShortSaleYN,OfficeIDX,PublicRemarks,OwnerBankCorporationYN'
      ||',ListingOfficeUID,OwnerWillConsider,UtilitiesAndFuel';    
    v_select('Rental') :=
      'ListingID,Bedrooms,BathsTotal,BathsHalf,ListDate,IDX,ListPrice,OriginalListPrice,PhotoCount,ApplicationFeeAmount'
      ||',TaxID,ShortSaleYN,OfficeIDX,PublicRemarks,AnimalsPermitted,LeaseTerms,PetFeeAmount'
      ||',ListingOfficeUID,SqFtLivingArea,Parking,RentalPropertyType,EquipmentAndAppliances';    
	return v_select;
  end get_select_vals;


  function get_id( p_source_id  in mls_listings.source_id%type
                 , p_mls_number in mls_listings.mls_number%type)
				 return mls_listings.mls_id%type is
				 
	cursor cur_mls( p_source_id  in mls_listings.source_id%type
                  , p_mls_number in mls_listings.mls_number%type) is
	select mls_id
	from mls_listings
	where source_id = p_source_id
	and mls_number = p_mls_number;
	
	v_return  mls_listings.mls_id%type := null;
  begin
    for m_rec in cur_mls(p_source_id, p_mls_number) loop
	  v_return := m_rec.mls_id;
	end loop;
	return v_return;
  end get_id;
  
  procedure get_brokers is
    v_realm       varchar2(256);
	v_nonce       varchar2(256);
	v_seq         integer;
	v_opaque      varchar2(256);
	v_url         varchar2(4000);
    v_resp        UTL_HTTP.RESP;
    v_value       varchar2(256);
    x_content     xmltype;
    v_count       integer;
	i             integer;
	v_str         varchar2(256);
	str_found     integer;
	v_values      pr_rets_pkg.value_table;
    v_query  varchar2(256);
  begin
    pr_rets_pkg.rets_login
          ( p_url     => global_login
          , p_user    => global_user
		  , p_passwd  => global_passwd
		  , p_realm   => v_realm
	      , p_nonce   => v_nonce
		  , p_seq     => v_seq
		  , p_opaque  => v_opaque);
	--
	-- Get Active Broker UIDs
	--
    v_query := '&Query=(OfficeStatus=A)&Select=OfficeUID';
    v_url := global_brokers||v_query;
    v_resp := pr_rets_pkg.get_resp
                     ( p_url     => v_url
                     , p_user    => global_user
				     , p_passwd  => global_passwd
				     , p_realm   => v_realm
				     , p_nonce   => v_nonce
				     , p_seq     => 2
				     , p_opaque  => v_opaque);
					 
    x_content := pr_rets_pkg.get_xml(v_resp);
	i := 1;
    v_str := '/RETS/DATA['||i||']';
    str_found := x_content.existsnode(v_str);
    v_seq := 2;
    while str_found = 1 loop  
	  --
	  -- Extract UID
	  -- 
	  v_value := x_content.extract(v_str||'/text()').getStringVal();
	  v_value := replace(v_value, '<![CDATA[', '');
	  v_value := replace(v_value, ']]>', '');
	  v_value := regexp_substr(v_value, '\w+');
	  
	  select count(*)
	  into v_count
	  from mls_brokers
	  where broker_uid = v_value
	  and source_id = global_src;
	  
	  if v_count = 0 then -- found a new broker
        v_query := '&Query=(OfficeUID='||v_value||')&Select=OfficeUID,Name,OfficePhone,URL';
        v_url := global_brokers||v_query;
        v_seq := v_seq + 1; 
        v_resp := pr_rets_pkg.get_resp
                     ( p_url     => v_url
                     , p_user    => global_login
				     , p_passwd  => global_passwd
				     , p_realm   => v_realm
				     , p_nonce   => v_nonce
				     , p_seq     => v_seq
				     , p_opaque  => v_opaque);
    
	    v_values := pr_rets_pkg.read_compact_values(v_resp, false);
	    if v_values('validResponse') = 'Y' then
	      insert into mls_brokers( broker_uid
	                             , source_id
							     , name
							     , phone
							     , url)
	           values ( v_value
			          , global_src
					  , v_values('Name')
					  , v_values('OfficePhone')
					  , v_values('URL'));
		end if;
	    commit;
	  end if;
      i := i + 1;
      v_str := '/RETS/DATA['||i||']';
      str_found := x_content.existsnode(v_str);
    end loop;  
  end get_brokers;
  
  function get_broker_name(p_broker_uid in varchar2)
    return varchar2 is
	v_return         varchar2(128);
  begin
    select name
	into v_return
	from mls_brokers
	where broker_uid = p_broker_uid
	and source_id = global_src;
	
	return v_return;
  exception
    when no_data_found then 
	  return 'Brevard MLS ListingOfficeUID: '||p_broker_uid;
  end get_broker_name;

  procedure get_listings is
  begin
    delete from mls_rets_responses;
	commit;
    get_listings('ResidentialProperty');
	get_listings('CommercialProperty');
	get_listings('IncomeProperty');
	get_listings('VacantLand');
	get_listings('Rental');
  end get_listings;
  
  procedure process_listings is
  begin
    process_listings('ResidentialProperty');
	process_listings('CommercialProperty');
	process_listings('IncomeProperty');
	process_listings('VacantLand');
	process_listings('Rental');
  end process_listings;
  
  procedure get_listings(p_ltype  in varchar2) is
    v_realm       varchar2(256);
	v_nonce       varchar2(256);
	v_seq         integer;
	v_opaque      varchar2(256);
	v_url         varchar2(4000);
    v_resp        UTL_HTTP.RESP;
    v_value       varchar2(256);
    x_content     xmltype;
    x_content2    xmltype;
	i             integer;
	v_str         varchar2(256);
	str_found     integer;
	v_values      pr_rets_pkg.value_table;
	v_select      pr_rets_pkg.value_table;


  begin
    --
	-- Populate an array of Select values
	--
    v_select := get_select_vals;
	--
	-- Open a new RETS session
	--
--    pr_rets_pkg.put_line(to_char(sysdate, 'hh24:mi:ss')||' open connection');
    pr_rets_pkg.rets_login
          ( p_url     => global_login
          , p_user    => global_user
		  , p_passwd  => global_passwd
		  , p_realm   => v_realm
	      , p_nonce   => v_nonce
		  , p_seq     => v_seq
		  , p_opaque  => v_opaque);
	--
	-- Get Active listing ID's
	--
    v_url := global_base
           ||'&Class='||p_ltype||'&Format=COMPACT-DECODED'
           ||'&QueryType=DQML2&Query=(ListingStatus=A)'
		   ||'&Select=ListingID';

    v_resp := pr_rets_pkg.get_resp
                     ( p_url     => v_url
                     , p_user    => global_user
				     , p_passwd  => global_passwd
				     , p_realm   => v_realm
				     , p_nonce   => v_nonce
				     , p_seq     => 2
				     , p_opaque  => v_opaque);
					 
    x_content := pr_rets_pkg.get_xml(v_resp);
	--
	-- Loop through each Listing ID and find the listing details.
	-- Write the result in mls_rets_responses
	--
    i := 1;
    v_str := '/RETS/DATA['||i||']';
    str_found := x_content.existsnode(v_str);
    v_seq := 2;
    while str_found = 1 loop  
      v_value := x_content.extract(v_str||'/text()').getStringVal();
      v_value := regexp_substr(v_value, '[0-9]+');

      v_url := global_base
	       ||'&Class='||p_ltype
	       ||'&Format=COMPACT-DECODED&QueryType=DQML2'
		   ||'&Query=(ListingID='||v_value||')'
           ||'&Select='||v_select(p_ltype);

      v_seq := v_seq + 1; 
      v_resp := pr_rets_pkg.get_resp
                     ( p_url     => v_url
                     , p_user    => global_login
				     , p_passwd  => global_passwd
				     , p_realm   => v_realm
				     , p_nonce   => v_nonce
				     , p_seq     => v_seq
				     , p_opaque  => v_opaque);
    
	  x_content2 := pr_rets_pkg.get_xml(v_resp, false);
	
	  insert into mls_rets_responses( mls_number
	                                , date_found
									, query_type
									, processed_yn
									, response)
	  values (v_value, sysdate, p_ltype, 'N', x_content2);
	  commit;
      i := i + 1;
      v_str := '/RETS/DATA['||i||']';
      str_found := x_content.existsnode(v_str);
	  -- Uncomment the following line for testing
      --if i > 30 then str_found := 0; end if;
    end loop;  
  exception
    when others then   
     pr_rets_pkg.put_line('Error in '||v_value);
     pr_rets_pkg.put_line(to_char(sysdate, 'hh24:mi:ss')||' end');
     raise;
  end get_listings;
  
  procedure set_listing( p_query_type  in mls_rets_responses.query_type%type
                       , p_values      in pr_rets_pkg.value_table
					   , p_prop_id     in pr_properties.prop_id%type
					   , p_verified    in varchar2) is
					   
    v_display_price     varchar2(32);
	v_listing_type      varchar2(32);
	v_broker            varchar2(64);
	v_short_desc        varchar2(128);
	v_link_text         varchar2(128);
	v_desc              varchar2(4000);
	v_idx               varchar2(1);
	v_photo             varchar2(256);
	unknown_query_type  exception;
	null_values         exception;
	v_photo_count       pls_integer;
	v_list_date         date;
	v_mls_id            mls_listings.mls_id%type;
	v_checksum          MLS_LISTINGS_V.CHECKSUM%TYPE;
  begin
    --
	-- Check to see if broker has opted out of IDX
	--
	if p_values('IDX') like 'N%' or
	   p_values('OfficeIDX') like 'N%' then
	   v_idx := 'N';
	else
	   v_idx := 'Y';
	end if;
	--
	-- Assemble listing data by query type
	--
	v_list_date := to_date(p_values('ListDate'), 'yyyy-mm-dd');
	if p_query_type = 'ResidentialProperty' then
	  v_display_price := to_char(p_values('ListPrice'),'$999,999,999');
	  v_listing_type := 'Sale';
	  v_broker := p_values('OriginalListingFirmName');
	  v_short_desc := p_values('Bedrooms')||' bedroom '
	                ||p_values('BathsTotal')||' bath '
					||to_char(p_values('SqFtLivingArea'),'999,999')||' Sq Ft';
	  v_desc := '<p>'||p_values('PublicRemarks')||'</p>'
	         || '<table class="datatable">'
			 || '<tr><th>First Listed</th><td>'||to_char(v_list_date, 'mm/dd/yyyy')||'</td></tr>'
			 || '<tr><th>Finance Options</th><td>'||p_values('OwnerWillConsider')||'</td></tr>'
			 || '<tr><th>Bank Owned</th><td>'||p_values('OwnerBankCorporationYN')||'</td></tr>'
			 || '<tr><th>Short Sale</th><td>'||p_values('ShortSaleYN')||'</td></tr>';
	  if p_values('VirtualTourURL') is not null then
	    v_desc := v_desc || '<tr><th>Virtual Tour</th><td><a href="'
	                     ||p_values('VirtualTourURL')||'">'
		   		         ||p_values('VirtualTourURL')||'</a></td></tr>';
	  end if;
	  v_desc := v_desc|| '<tr><th>Verified</th><td>'||p_verified||'</td></tr>'
                      ||'</table>';
	elsif p_query_type = 'CommercialProperty' then
	  v_display_price := to_char(p_values('ListPrice'),'$999,999,999')||' '||p_values('LeaseType');
	  v_listing_type := p_values('SaleLease');
	  v_broker := p_values('OriginalListingFirmName');
	  v_short_desc := to_char(p_values('SqFtTotal'),'999,999')
	                  ||' Sq Ft '||p_values('PropertyType');
	  v_desc := '<p>'||p_values('PublicRemarks')||'</p>'
	         || '<table class="datatable">'
			 || '<tr><th>First Listed</th><td>'||to_char(v_list_date, 'mm/dd/yyyy')||'</td></tr>'
			 || '<tr><th>Current Use</th><td>'||p_values('CurrentUse')||'</td></tr>'
			 || '<tr><th>Site Improvements</th><td>'||p_values('SiteImprovements')||'</td></tr>'
			 || '<tr><th>Interior Improvements</th><td>'||p_values('InteriorImprovements')||'</td></tr>'
			 || '<tr><th>Assumable Loan (Y/N)</th><td>'||p_values('AssumableLoanYN')||'</td></tr>'
			 || '<tr><th>Bank Owned</th><td>'||p_values('OwnerBankCorporationYN')||'</td></tr>'
			 || '<tr><th>Short Sale</th><td>'||p_values('ShortSaleYN')||'</td></tr>'
			 || '<tr><th>Verified</th><td>'||p_verified||'</td></tr>'
			 ||'</table>';
	elsif p_query_type = 'IncomeProperty' then
	  v_display_price := to_char(p_values('ListPrice'),'$999,999,999');
	  v_listing_type := 'Sale';
	  v_broker := get_broker_name(p_values('ListingOfficeUID'));
	  v_short_desc := to_char(p_values('SqFtLivingArea'),'999,999')||' Sq Ft '
	               || p_values('PropertyType');
	  v_desc := '<p>'||p_values('PublicRemarks')||'</p>'
	         || '<table class="datatable">'
			 || '<tr><th>First Listed</th><td>'||to_char(v_list_date, 'mm/dd/yyyy')||'</td></tr>'
			 || '<tr><th>Finance Options</th><td>'||p_values('OwnerWillConsider')||'</td></tr>'
			 || '<tr><th>Bank Owned</th><td>'||p_values('OwnerBankCorporationYN')||'</td></tr>'
			 || '<tr><th>Short Sale</th><td>'||p_values('ShortSaleYN')||'</td></tr>'
			 || '<tr><th>Verified</th><td>'||p_verified||'</td></tr>'
			 ||'</table>';
	elsif p_query_type = 'VacantLand' then
	  v_display_price := to_char(p_values('ListPrice'),'$999,999,999');
	  v_listing_type := 'Sale';
	  v_broker := get_broker_name(p_values('ListingOfficeUID'));
	  v_short_desc := to_char(p_values('Area'),'999,999.99')||' Acre '
	               || p_values('PropertyUse');
	  v_desc := '<p>'||p_values('PublicRemarks')||'</p>'
	         || '<table class="datatable">'
			 || '<tr><th>First Listed</th><td>'||to_char(v_list_date, 'mm/dd/yyyy')||'</td></tr>'
			 || '<tr><th>Finance Options</th><td>'||p_values('OwnerWillConsider')||'</td></tr>'
			 || '<tr><th>Utilities</th><td>'||p_values('UtilitiesAndFuel')||'</td></tr>'
			 || '<tr><th>Bank Owned</th><td>'||p_values('OwnerBankCorporationYN')||'</td></tr>'
			 || '<tr><th>Short Sale</th><td>'||p_values('ShortSaleYN')||'</td></tr>'
			 || '<tr><th>Verified</th><td>'||p_verified||'</td></tr>'
			 ||'</table>';
	elsif p_query_type = 'Rental' then
	  v_display_price := to_char(p_values('ListPrice'),'$999,999,999')||'/ month';
	  v_listing_type := 'Rent';
	  v_broker := get_broker_name(p_values('ListingOfficeUID'));
	  v_short_desc := p_values('Bedrooms')||' bedroom '
	                ||p_values('BathsTotal')||' bath '
					||to_char(p_values('SqFtLivingArea'),'999,999')||' Sq Ft '
					||p_values('RentalPropertyType');
	  v_desc := '<p>'||p_values('PublicRemarks')||'</p>'
	         || '<table class="datatable">'
			 || '<tr><th>First Listed</th><td>'||to_char(v_list_date, 'mm/dd/yyyy')||'</td></tr>'
			 || '<tr><th>Application Fee</th><td>'||to_char(p_values('ApplicationFeeAmount'), '$999,999.99')||'</td></tr>'
			 || '<tr><th>Animals Permitted</th><td>'||p_values('AnimalsPermitted')||'</td></tr>'
			 || '<tr><th>Pet Fee</th><td>'||to_char(p_values('PetFeeAmount'), '$999,999.99')||'</td></tr>'
			 || '<tr><th>Appliances</th><td>'||p_values('EquipmentAndAppliances')||'</td></tr>'
			 || '<tr><th>Verified</th><td>'||p_verified||'</td></tr>'
			 ||'</table>';
	else
	  raise unknown_query_type;
	end if;
	
	--
	-- Assemble the link text
	--
	select initcap(address1)
	into v_link_text
	from pr_properties
	where prop_id = p_prop_id;
	v_link_text := v_link_text||', '||v_display_price;
	
	--
	-- Verify we have data for all of the listing items
	--
    if (p_values('ListingID') is null or 
	    v_listing_type        is null or
	    p_values('ListPrice') is null or
	    v_broker              is null or
	    v_list_date           is null or
	    v_short_desc          is null or
	    v_link_text           is null or
	    v_desc                is null) then
	    raise null_values;
    end if;
	--
	-- Insert or update a record
	--
	 
	 pr_rets_pkg.put_line('processing '||p_values('ListingID'));
    v_mls_id := mls_listings_pkg.get_mls_id(global_src, p_values('ListingID'));
	if v_mls_id is null then
	   v_mls_id := mls_listings_pkg.insert_row
	                 ( X_PROP_ID        => p_prop_id
                     , X_SOURCE_ID      => global_src
                     , X_MLS_NUMBER     => p_values('ListingID')
                     , X_QUERY_TYPE     => p_query_type
                     , X_LISTING_TYPE   => v_listing_type
                     , X_LISTING_STATUS => 'ACTIVE'
                     , X_PRICE          => p_values('ListPrice')
                     , X_IDX_YN         => v_idx
                     , X_LISTING_BROKER => v_broker
                     , X_LISTING_DATE   => v_list_date
                     , X_SHORT_DESC     => v_short_desc
                     , X_LINK_TEXT      => v_link_text
                     , X_DESCRIPTION    => v_desc
                     , X_LAST_ACTIVE    => sysdate);
	
	else
	  v_checksum := mls_listings_pkg.get_checksum(v_mls_id);
	  mls_listings_pkg.update_row
	                 ( X_MLS_ID         => v_mls_id
					 , X_PROP_ID        => p_prop_id
                     , X_SOURCE_ID      => global_src
                     , X_MLS_NUMBER     => p_values('ListingID')
                     , X_QUERY_TYPE     => p_query_type
                     , X_LISTING_TYPE   => v_listing_type
                     , X_LISTING_STATUS => 'ACTIVE'
                     , X_PRICE          => p_values('ListPrice')
                     , X_IDX_YN         => v_idx
                     , X_LISTING_BROKER => v_broker
                     , X_LISTING_DATE   => v_list_date
                     , X_SHORT_DESC     => v_short_desc
                     , X_LINK_TEXT      => v_link_text
                     , X_DESCRIPTION    => v_desc
                     , X_LAST_ACTIVE    => sysdate
					 , X_CHECKSUM       => v_checksum);
	end if;
	--
	-- Find photos for the listing
	--
	select nvl(max(photo_seq), 0) 
	into v_photo_count
	from mls_photos 
	where mls_id = v_mls_id;
    if nvl(p_values('PhotoCount'),0) > v_photo_count then
	    v_photo_count := v_photo_count + 1;
	    for j in v_photo_count .. p_values('PhotoCount') loop
	      if j = 1 then
	        v_photo := global_photo_url||'/';
		  else
		    v_photo := global_photo_url||j||'/';
		  end if;
		  v_photo := v_photo ||substr(p_values('ListingID'), -3, 3)||'/'
		                     ||p_values('ListingID')||'.jpg';
	      mls_photos_pkg.insert_row
		             ( X_MLS_ID      => v_mls_id
                     , X_PHOTO_SEQ  => j
                     , X_PHOTO_URL  => v_photo
                     , X_PHOTO_DESC => null);
	    end loop;
	end if;
	
	exception
	  when unknown_query_type then
	    pr_rets_pkg.put_line('Unknown query type: "'||p_query_type||'"');
		raise;
	  when null_values then
	    pr_rets_pkg.put_line('Found null values in: "'||p_values('ListingID')||'"');
	  when others then raise;

	end set_listing;

  procedure process_listings(p_ltype  in varchar2) is
    cursor cur_listings(p_ltype  in varchar2) is
	  select mls_number
	  ,      date_found
	  ,      query_type
	  ,      response
	  from mls_rets_responses
	  where query_type = p_ltype
	  and processed_yn = 'N';
	  
	v_values      pr_rets_pkg.value_table;  
	v_mls_id      MLS_LISTINGS.MLS_ID%TYPE;
	v_id          number;
	v_prop_id     pr_properties.prop_id%type;

  begin
    for l_rec in cur_listings(p_ltype) loop
	  --
	  -- Read a record from mls_rets_responses
	  --
      v_values := pr_rets_pkg.get_compact_values(l_rec.response, false);
	  v_id := l_rec.mls_number;
	  --
	  -- Mark it as processed
	  --
	  update mls_rets_responses
	  set processed_yn = 'Y'
	  where mls_number = l_rec.mls_number;

	  --
	  -- Find the property with matching Tax ID
	  --
	  if v_values('validResponse') = 'Y' then
	    begin
		  select prop_id
		  into v_prop_id
		  from pr_properties
		  where source_pk = v_values('TaxID')
		  and source_id = global_tax
		  and rownum = 1;
		exception
		  when others then v_prop_id := null;
        end;
	  else
	    v_prop_id := null;
	--  pr_rets_pkg.put_line(v_values('TaxID')||' not found');
	  end if;
	
	  --
	  -- Insert or update listing data for the property
	  --
	  if v_prop_id is not null then
	    set_listing( p_query_type => l_rec.query_type
		           , p_values     => v_values
				   , p_prop_id    => v_prop_id
				   , p_verified   => to_char(l_rec.date_found, 'mm/dd/yyyy  hh:mipm'));
	  end if;
      commit;
    end loop;
	--
	-- Mark old listings as inactive
	--
	update mls_listings
	set listing_status = 'INACTIVE'
	where query_type = p_ltype
	and to_date(last_active, 'dd-mon-yyyy') < to_date(sysdate, 'dd-mon-yyyy');
	commit;
	
  exception
    when others then   
     pr_rets_pkg.put_line('Error in process_listings on MLS# '||v_id);
     raise;
  end process_listings;
  
  procedure update_mls is
  begin
    mls_brevard_pkg.get_brokers;
    mls_brevard_pkg.get_listings;
    mls_brevard_pkg.process_listings;
  end update_mls;
 end mls_brevard_pkg;
/  
show errors package mls_brevard_pkg
show errors package body mls_brevard_pkg

