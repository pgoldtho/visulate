set serveroutput on
begin

for x in (SELECT 
               SUPPLIER_ID, NAME, PHONE1, 
               PHONE2, ADDRESS1, ADDRESS2, 
               CITY, STATE, ZIPCODE, 
               EMAIL_ADDRESS, COMMENTS, 1 as SUPPLIER_TYPE_ID
          FROM RNT_SUPPLIERS
        ) loop
     begin   
          INSERT INTO RNT_SUPPLIERS_ALL (
             SUPPLIER_ID, NAME, PHONE1, 
             PHONE2, ADDRESS1, ADDRESS2, 
             CITY, STATE, ZIPCODE, 
             EMAIL_ADDRESS, COMMENTS, SUPPLIER_TYPE_ID)
          values(x.SUPPLIER_ID, x.NAME, x.PHONE1, 
                 x.PHONE2, x.ADDRESS1, x.ADDRESS2, 
                 x.CITY, x.STATE, x.ZIPCODE, 
                 x.EMAIL_ADDRESS, x.COMMENTS, 1);
      exception
        when DUP_VAL_ON_INDEX then 
           dbms_output.put_line('Dublicate index with SUPPLIER_ID '||x.SUPPLIER_ID);                 
      end;
  end loop;            
  
  commit; 
end;
/