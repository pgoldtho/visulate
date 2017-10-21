declare new_id NUMBER;
begin
for x in (            
            select distinct t.SECTION8_ID, bu.PARENT_BUSINESS_ID, s8.SECTION_NAME
            from RNT_TENANT t,
                 RNT_TENANCY_AGREEMENT ta,
                 RNT_PROPERTY_UNITS u, 
                 RNT_PROPERTIES p,
                 RNT_SECTION8_OFFICES s8,
                 RNT_BUSINESS_UNITS bu
            where t.SECTION8_ID is not null
              and t.AGREEMENT_ID = ta.AGREEMENT_ID
              and ta.UNIT_ID = u.UNIT_ID 
              and u.PROPERTY_ID = p.PROPERTY_ID
              and s8.SECTION8_ID = t.SECTION8_ID
              and bu.BUSINESS_ID = p.BUSINESS_ID              
              and not exists (select 1
                              from RNT_SECTION8_OFFICES s
                              where SECTION8_ID = s8.SECTION8_ID
                                and s.BUSINESS_ID = bu.PARENT_BUSINESS_ID) 
         ) loop
    insert into RNT_SECTION8_OFFICES (
       SECTION8_ID, SECTION_NAME, BUSINESS_ID) 
     values (RNT_SECTION8_OFFICES_SEQ.NEXTVAL, x.SECTION_NAME, x.PARENT_BUSINESS_ID)
     returning SECTION8_ID into new_id;
     
     update RNT_TENANT
     set SECTION8_ID = new_id
     where SECTION8_ID = x.SECTION8_ID;            
end loop;
  commit;
end;                     
/
       
      

  
 