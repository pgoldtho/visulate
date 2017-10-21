set define ^

insert into pr_usage_codes
(ucode, description, parent_ucode)
values
(9200, 'Mining and Prod of Pet and Gas', 3);

insert into pr_sources
(source_id, source_name, source_type, base_url, pk_column_name)
values
(4, 'Volusia County Property Appraiser', 'Tax Appraiser',
 'http://webserver.vcgov.org/', 'ALT_KEY');
 
update  pr_sources
set PROPERTY_URL =
 '<FORM action="http://webserver.vcgov.org/cgi-bin/mainSrch3.cgi" method="post">
<INPUT type="hidden" name="Alt_key" value="[[SOURCE_PK]]">
<INPUT type="hidden" value="1" name="mode">
<INPUT type="submit" value="Property Appraiser" name="SUBMIT" 
       >
</FORM>'
where source_id = 4;

update  pr_sources
set TAX_URL =
 '<form><input type="button" value="Tax Value"
         onclick="parent.location=''http://webserver.vcgov.org/cgi-bin/estimatetaxpopup.cgi?Alt_Key=[[SOURCE_PK]]''">
  </form></td><td>
 <form><input type="button" value="Tax History"  
   onclick="parent.location=''http://webserver.vcgov.org/cgi-bin/valhistpopup.cgi?Alt_Key=[[SOURCE_PK]]&Roll_year=0&mode=1&Trim_Mode=0''">'
where source_id = 4;

update  pr_sources
set PHOTO_URL =
 '<form><input type="button" value="Sales History"  
    onclick="parent.location=''http://webserver.vcgov.org/cgi-bin/salespopup.cgi?Alt_Key=[[SOURCE_PK]]&Roll_year=0&mode=1''">'
where source_id = 4;


update  pr_sources
set PHOTO_URL =
 '<form><input type="button" value="Property Apprasiser Photos (if Any)"  
    onclick="parent.location=''http://www.brevardpropertyappraiser.com/asp/show_buildings.asp?taxAcct=[[SOURCE_PK]]''"/>'
where source_id = 3;	

update  pr_sources
set PROPERTY_URL =
 '<form><input type="button" value="Property Apprasiser"  
    onclick="parent.location=''http://www.brevardpropertyappraiser.com/asp/Show_parcel.asp?acct=[[SOURCE_PK]]&gen=T&tax=T&bld=T&oth=T&sal=T&lnd=T&leg=T&GoWhere=real_search.asp&SearchBy=Tax''"/>'
where source_id = 3;	
	
update  pr_sources
set TAX_URL =
 '<form><input type="button" value="Tax Record"  
   onclick="parent.location=''http://www.brevardpropertyappraiser.com/asp/_include/tax_link.asp?taxAcct=[[SOURCE_PK]]''"/>'
 where source_id = 3;  


declare
  v_return   number;
begin
    v_return := pr_records_pkg.insert_owner( x_owner_name => 'Not Recorded'
                                           , x_owner_type => 'N/A');
	commit;
end;
/

insert into pr_deed_codes 
(deed_code, description)
values
('AG1', 'Agreement for Deed');
insert into pr_deed_codes 
(deed_code, description)
values
('AG2', 'Articles of Agreement');
insert into pr_deed_codes 
(deed_code, description)
values
(AG3'', 'Contract for Sale');
insert into pr_deed_codes 
(deed_code, description)
values
('AG4', 'Land Installment Contract');
insert into pr_deed_codes 
(deed_code, description)
values
(AG5'', 'Assignment Agreement for Deed');
insert into pr_deed_codes 
(deed_code, description)
values
('AP', 'D.O.R. Appraisal');
insert into pr_deed_codes 
(deed_code, description)
values
('BS', 'Bargain and Sale');
insert into pr_deed_codes 
(deed_code, description)
values
('DC', 'Corporation Deed');
insert into pr_deed_codes 
(deed_code, description)
values
('DS', 'Deed of Surrender');
insert into pr_deed_codes 
(deed_code, description)
values
('EX', 'Executor''s Deed');
insert into pr_deed_codes 
(deed_code, description)
values
('FS', 'Fee Simple');
insert into pr_deed_codes 
(deed_code, description)
values
('LA', 'Lease');
insert into pr_deed_codes 
(deed_code, description)
values
('MD', 'Marshall''s Deed');
insert into pr_deed_codes 
(deed_code, description)
values
('MG', 'Mortgage');
insert into pr_deed_codes 
(deed_code, description)
values
('OT1', 'Order of Taking');
insert into pr_deed_codes 
(deed_code, description)
values
('OT2', 'Final Judgment of Order of Taking');
insert into pr_deed_codes 
(deed_code, description)
values
('PR1', 'Personal Rep');
insert into pr_deed_codes 
(deed_code, description)
values
('PR2', 'Death Certificate');
insert into pr_deed_codes 
(deed_code, description)
values
('QC1', 'Quit Claim Deed');
insert into pr_deed_codes 
(deed_code, description)
values
('QC2', 'Final Judgment of Divorce');
insert into pr_deed_codes 
(deed_code, description)
values
('QT', 'Quiet Title');
insert into pr_deed_codes 
(deed_code, description)
values
('RE', 'Resolution');
insert into pr_deed_codes 
(deed_code, description)
values
('TR', 'Trustee''s Deed');


EXEC DBMS_STATS.gather_schema_stats('RNTMGR');
