set define '^'
declare

  v_source_id         PR_SOURCES.SOURCE_ID%TYPE;

begin

  v_source_id := pr_records_pkg.insert_source
    ( x_source_name  => 'Brevard Property Appraiser'
    , x_source_type  => 'Tax Appraiser'
    , x_base_url     => 'http://www.brevardpropertyappraiser.com/'
    , x_photo_url    => 'http://www.brevardpropertyappraiser.com/asp/show_buildings.asp?taxAcct=[[SOURCE_PK]]'
    , x_property_url => 'http://www.brevardpropertyappraiser.com/asp/Show_parcel.asp?acct=[[SOURCE_PK]]&gen=T&tax=T&bld=T&oth=T&sal=T&lnd=T&leg=T&GoWhere=real_search.asp&SearchBy=Tax'
    , x_platbook_url => 'http://www.brevardpropertyappraiser.com/asp/_include/bookpage_link.asp?book=[[PLATBOOK]]&page=[[PLATPAGE]]'
    , x_tax_url      => 'http://www.brevardpropertyappraiser.com/asp/_include/tax_link.asp?taxAcct=[[SOURCE_PK]]'
    , x_pk_column_name => 'TaxAcct');
end;
/     