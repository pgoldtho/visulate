declare
  cursor cur_corps is
  select cor_number
  ,      cor_name
  ,      cor_status
  ,      cor_filing_type
  ,      cor_file_date
  ,      cor_fei_number
  from sunbiz;
  c_number      varchar2(20);
begin
  for c_rec in cur_corps loop
    c_number := c_rec.cor_number;
	
	begin
    insert into pr_corporations
	( corp_number        
     , name              
     , status            
     , filing_type       
     , filing_date       
     , fei_number)
	 values
	 ( c_rec.cor_number
	 , c_rec.cor_name
	 , c_rec.cor_status
	 , c_rec.cor_filing_type
	 , to_date(c_rec.cor_file_date, 'MMDDYYYY')
	 , c_rec.cor_fei_number);
	 exception when others then
       dbms_output.put_line(sqlerrm||' :'||c_number||' '||c_rec.cor_file_date);
	 end;
	 commit;
  end loop;
  exception when others then
    dbms_output.put_line(sqlerrm||' :'||c_number);
end;
/  