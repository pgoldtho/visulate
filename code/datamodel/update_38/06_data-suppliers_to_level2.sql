INSERT INTO RNT_BU_SUPPLIERS (
   BU_SUPPLIER_ID, BUSINESS_ID, SUPPLIER_ID, 
   TAX_IDENTIFIER, NOTES) 
select 
   RNT_BU_SUPPLIERS_SEQ.NEXTVAL, bu.BUSINESS_ID, bus.SUPPLIER_ID, 
   bus.TAX_IDENTIFIER, bus.NOTES
from RNT_BU_SUPPLIERS bus,
     RNT_BUSINESS_UNITS bu
where bus.BUSINESS_ID = bu.PARENT_BUSINESS_ID
/

commit
/     

delete from RNT_BU_SUPPLIERS bus
where exists (select 1
              from RNT_BUSINESS_UNITS bu
              where bus.BUSINESS_ID = bu.BUSINESS_ID
                and bu.PARENT_BUSINESS_ID = 0)
/

commit
/     