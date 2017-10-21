set define ^
insert into pr_sources
(source_id, source_name, source_type, base_url, pk_column_name)
values
(5, 'Orange County Property Appraiser', 'Tax Appraiser',
 'http://www.ocpafl.org/', 'PARCEL');
 

update  pr_sources
set PHOTO_URL = ''
where source_id = 5;	

update  pr_sources
set PROPERTY_URL =
 '<form><input type="button" value="Property Apprasiser"
    onclick="parent.location=''http://www.ocpafl.org/searches/ParcelSearch.aspx?pid=[[SOURCE_PK]]''"/>
        <br/>
        <a href="http://www.ocpafl.org/searches/ParcelSearch.aspx?pid=[[SOURCE_PK]]" target="_new">
		[Property Appraiser]</a>
        </form>'
where source_id = 5;	
	
insert into pr_deed_codes 
(deed_code, description)
values
('AA', 'Assignement of Agreement');
insert into pr_deed_codes 
(deed_code, description)
values
('AM', 'Unknown');
insert into pr_deed_codes 
(deed_code, description)
values
('CM', 'Contract Deed');
insert into pr_deed_codes 
(deed_code, description)
values
('GM', 'Guardian''s Deed');
insert into pr_deed_codes 
(deed_code, description)
values
('MS', 'Miscellaneous Deed');
insert into pr_deed_codes 
(deed_code, description)
values
('PM', 'Personal Representative''s Deed');
insert into pr_deed_codes 
(deed_code, description)
values
('SM', 'Special Warranty');



