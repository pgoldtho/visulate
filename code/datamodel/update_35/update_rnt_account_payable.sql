begin
    for x in (
            SELECT
               s.BUSINESS_ID, sa.SUPPLIER_ID, s.SUPPLIER_ID as OLD_SUPPLIER_ID 
            FROM RNT_SUPPLIERS s,
                 RNT_SUPPLIERS_ALL sa
            where not exists (select 1
                              from RNT_SUPPLIERS_ALL
                              where SUPPLIER_ID = s.SUPPLIER_ID)
              and NVL(s.NAME, '-') = NVL(sa.NAME, '-')
              and NVL(s.CITY, '-') = NVL(sa.CITY, '-')
              and NVL(s.PHONE1, '-') = NVL(sa.PHONE1, '-')) loop
       update RNT_ACCOUNTS_PAYABLE
       set SUPPLIER_ID = x.SUPPLIER_ID
       where SUPPLIER_ID = x.OLD_SUPPLIER_ID;
   
    end loop;
    commit;
end;           
/