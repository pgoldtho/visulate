-- insert data with no doubles
INSERT INTO RNT_BU_SUPPLIERS (
   BU_SUPPLIER_ID, BUSINESS_ID, SUPPLIER_ID, 
   TAX_IDENTIFIER, NOTES)
SELECT
   RNT_BU_SUPPLIERS_SEQ.NEXTVAL,  
   BUSINESS_ID, SUPPLIER_ID, SSN, NULL as NOTES 
FROM RNT_SUPPLIERS s
where exists (select 1
              from RNT_SUPPLIERS_ALL
              where SUPPLIER_ID = s.SUPPLIER_ID);

-- insert business for doubles 
INSERT INTO RNT_BU_SUPPLIERS (
   BU_SUPPLIER_ID, BUSINESS_ID, SUPPLIER_ID, 
   TAX_IDENTIFIER, NOTES)
select RNT_BU_SUPPLIERS_SEQ.NEXTVAL,
       BUSINESS_ID, SUPPLIER_ID, SSN, NOTES 
from (
        SELECT
           s.BUSINESS_ID, sa.SUPPLIER_ID, s.SSN, NULL as NOTES 
        FROM RNT_SUPPLIERS s,
             RNT_SUPPLIERS_ALL sa
        where not exists (select 1
                          from RNT_SUPPLIERS_ALL
                          where SUPPLIER_ID = s.SUPPLIER_ID)
          and NVL(s.NAME, '-') = NVL(sa.NAME, '-')
          and NVL(s.CITY, '-') = NVL(sa.CITY, '-')
          and NVL(s.PHONE1, '-') = NVL(sa.PHONE1, '-') 
        group by s.BUSINESS_ID, sa.SUPPLIER_ID, s.SSN                    
     ) s
;

commit;     
     
