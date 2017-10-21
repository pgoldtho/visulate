declare

  procedure  set_seq( v_id   in number
                    , v_seq  in number
                    , v_name in varchar2) is
    v_increment  number;
    v_text       varchar2(256);
  begin
    v_increment := v_id - v_seq - 2;
    if v_increment > 0 then
      v_text := 'alter sequence '||v_name||' increment by '||v_increment||';';
      dbms_output.put_line(v_text);
   end if;
 end set_seq;

  procedure process_sequences is
    v_id   number;
    v_seq  number;
  begin
   select max( mls_id)
     into v_id
     from MLS_LISTINGS;

   select MLS_LISTINGS_SEQ.nextval
     into v_seq
     from dual;
     
     set_seq(v_id, v_seq, 'MLS_LISTINGS_SEQ');
---------------
     select max( building_id)
     into v_id
     from PR_BUILDINGS;

     select PR_BUILDINGS_SEQ.nextval
     into v_seq
     from dual;
     
     set_seq(v_id, v_seq, 'PR_BUILDINGS_SEQ');
-------------
     select max( loc_id)
     into v_id
     from PR_LOCATIONS;
     select PR_LOCATIONS_SEQ.nextval
     into  v_seq
     from dual;

     set_seq(v_id, v_seq, 'PR_LOCATIONS_SEQ');

     select max( owner_id)
     into v_id
     from PR_OWNERS;
     select PR_OWNERS_SEQ.nextval
     into v_seq
     from dual;
     
     set_seq(v_id, v_seq, 'PR_OWNERS_SEQ');

     select max( pn_id)
     into v_id
     from PR_PRINCIPALS;
     select PR_PRINCIPALS_SEQ.nextval
     into v_seq
     from dual;
     
     set_seq(v_id, v_seq, 'PR_PRINCIPALS_SEQ');

     select max( prop_id)
     into v_id
     from PR_PROPERTIES;
     select PR_PROPERTIES_SEQ.nextval
     into v_seq
     from dual;
     
     set_seq(v_id, v_seq, 'PR_PROPERTIES_SEQ');

     select max( source_id)
     into v_id
     from PR_SOURCES;
     select PR_SOURCES_SEQ.nextval
     into v_id
     from dual;
     
     set_seq(v_id, v_seq, 'PR_SOURCES_SEQ');

     select max( ap_id)
     into v_id
     from RNT_ACCOUNTS_PAYABLE;
     select RNT_ACCOUNTS_PAYABLE_SEQ.nextval
     into v_seq
     from dual;
     
     set_seq(v_id, v_seq, 'RNT_ACCOUNTS_PAYABLE_SEQ');


     select max(ar_id)
     into v_id
     from RNT_ACCOUNTS_RECEIVABLE;
     select RNT_ACCOUNTS_RECEIVABLE_SEQ.nextval
     into v_seq
     from dual;
     
     set_seq(v_id, v_seq, 'RNT_ACCOUNTS_RECEIVABLE_SEQ');


     select max( account_id)
     into v_id
     from RNT_ACCOUNTS;
     select RNT_ACCOUNTS_SEQ.nextval
     into v_seq
     from dual;
     
     set_seq(v_id, v_seq, 'RNT_ACCOUNTS_SEQ');

     select max( period_id)
     into v_id
     from RNT_ACCOUNT_PERIODS;
     select RNT_ACCOUNT_PERIODS_SEQ.nextval
     into v_seq
     from dual;
     
     set_seq(v_id, v_seq, 'RNT_ACCOUNT_PERIODS_SEQ');


     select max( action_id)
     into v_id
     from RNT_AGREEMENT_ACTIONS;
     select RNT_AGREEMENT_ACTIONS_SEQ.nextval
     into v_seq
     from dual;
     
     set_seq(v_id, v_seq, 'RNT_AGREEMENT_ACTIONS_SEQ');


     select max( business_id)
     into v_id
     from RNT_BUSINESS_UNITS;
     select RNT_BUSINESS_UNITS_SEQ.nextval
     into v_seq
     from dual;
     
     set_seq(v_id, v_seq, 'RNT_BUSINESS_UNITS_SEQ');


     select max( bu_supplier_id)
     into v_id
     from RNT_BU_SUPPLIERS;
     select RNT_BU_SUPPLIERS_SEQ.nextval
     into v_seq
     from dual;
     
     set_seq(v_id, v_seq, 'RNT_BU_SUPPLIERS_SEQ');


     select max( city_id)
     into v_id
     from RNT_CITIES;
     select  RNT_CITIES_SEQ.nextval
     into  v_seq
     from dual;
     
     set_seq(v_id, v_seq, 'RNT_CITIES_SEQ');

     select max( template_id)
     into v_id
     from RNT_DOC_TEMPLATES;
     select RNT_DOC_TEMPLATES_SEQ.nextval
     into v_seq
     from dual;
     
     set_seq(v_id, v_seq, 'RNT_DOC_TEMPLATES_SEQ');


     select max( error_id)
     into v_id
     from RNT_ERROR_DESCRIPTION;
     select RNT_ERROR_DESCRIPTION_SEQ.nextval
     into v_seq
     from dual;
     
     set_seq(v_id, v_seq, 'RNT_ERROR_DESCRIPTION_SEQ');


     select max( expense_item_id)
     into v_id
     from RNT_EXPENSE_ITEMS;
     select RNT_EXPENSE_ITEMS_SEQ.nextval
     into v_seq
     from dual;
     
     set_seq(v_id, v_seq, 'RNT_EXPENSE_ITEMS_SEQ');


     select max( ledger_id)
     into v_id
     from RNT_LEDGER_ENTRIES;
     select RNT_LEDGER_ENTRIES_SEQ.nextval
     into v_seq
     from dual;
     
     set_seq(v_id, v_seq, 'RNT_LEDGER_ENTRIES_SEQ');


     select max( loan_id)
     into v_id
     from RNT_LOANS;
     select RNT_LOANS_SEQ.nextval
     into v_seq
     from dual;
     
     set_seq(v_id, v_seq, 'RNT_LOANS_SEQ');

     select max( payment_id)
     into v_id
     from RNT_PAYMENTS;
     select RNT_PAYMENTS_SEQ.nextval
     into v_seq
     from dual;
     
     set_seq(v_id, v_seq, 'RNT_PAYMENTS_SEQ');

     select max( pay_alloc_id)
     into v_id
     from RNT_PAYMENT_ALLOCATIONS;
     select RNT_PAYMENT_ALLOCATIONS_SEQ.nextval
     into v_seq
     from dual;
     
     set_seq(v_id, v_seq, 'RNT_PAYMENT_ALLOCATIONS_SEQ');


     select max( payment_type_id)
     into v_id
     from RNT_PAYMENT_TYPES;
     select  RNT_PAYMENT_TYPES_SEQ.nextval
     into  v_seq
     from dual;
     
     set_seq(v_id, v_seq, 'RNT_PAYMENT_TYPES_SEQ');


     select max( people_business_id)
     into v_id
     from RNT_PEOPLE_BU;
     select  RNT_PEOPLE_BU_SEQ.nextval
     into  v_seq
     from dual;
     
     set_seq(v_id, v_seq, 'RNT_PEOPLE_BU_SEQ');

     select max( people_id)
     into v_id
     from RNT_PEOPLE;
     select  RNT_PEOPLE_SEQ.nextval
     into  v_seq
     from dual;
     
     set_seq(v_id, v_seq, 'RNT_PEOPLE_SEQ');

     select max( property_id)
     into v_id
     from RNT_PROPERTIES;
     select  RNT_PROPERTIES_SEQ.nextval
     into  v_seq
     from dual;
     
     set_seq(v_id, v_seq, 'RNT_PROPERTIES_SEQ');
/*
     select max( property_estimate_id)
     into v_id
     from RNT_PROPERTY_ESTIMATES;
     select RNT_PROPERTY_ESTIMATES_SEQ.nextval
     into v_seq
     from dual;
     
     set_seq(v_id, v_seq, 'RNT_PROPERTY_ESTIMATES_SEQ');
*/

     select max( expense_id)
     into v_id
     from RNT_PROPERTY_EXPENSES;
     select  RNT_PROPERTY_EXPENSES_SEQ.nextval
     into v_seq
     from dual;
     
     set_seq(v_id, v_seq, 'RNT_PROPERTY_EXPENSES_SEQ');


     select max( property_link_id)
     into v_id
     from RNT_PROPERTY_LINKS;
     select  RNT_PROPERTY_LINKS_SEQ.nextval
     into v_seq
     from dual;
     
     set_seq(v_id, v_seq, 'RNT_PROPERTY_LINKS_SEQ');


     select max( photo_id)
     into v_id
     from RNT_PROPERTY_PHOTOS;
     select RNT_PROPERTY_PHOTOS_SEQ.nextval
     into  v_seq
     from dual;
     
     set_seq(v_id, v_seq, 'RNT_PROPERTY_PHOTOS_SEQ');


     select max( unit_id)
     into v_id
     from RNT_PROPERTY_UNITS;
     select  RNT_PROPERTY_UNITS_SEQ.nextval
     into v_seq
     from dual;
     
     set_seq(v_id, v_seq, 'RNT_PROPERTY_UNITS_SEQ');


     select max( value_id)
     into v_id
     from RNT_PROPERTY_VALUE;
     select  RNT_PROPERTY_VALUE_SEQ.nextval
     into  v_seq
     from dual;
     
     set_seq(v_id, v_seq, 'RNT_PROPERTY_VALUE_SEQ');


     select max( section8_business_id)
     into v_seq
     from RNT_SECTION8_OFFICES_BU; 
     select RNT_SECTION8_OFFICES_BU_SEQ.nextval
     into  v_seq
     from dual;
     
     set_seq(v_id, v_seq, 'RNT_SECTION8_OFFICES_BU_SEQ');


     select max( section8_id)
     into v_id
     from RNT_SECTION8_OFFICES; 
     select  RNT_SECTION8_OFFICES_SEQ.nextval
     into  v_seq
     from dual;
     
     set_seq(v_id, v_seq, 'RNT_SECTION8_OFFICES_SEQ');


     select max( supplier_id)
     into v_id
     from RNT_SUPPLIERS_ALL; 
     select  RNT_SUPPLIERS_SEQ.nextval
     into  v_seq
     from dual;
     
     set_seq(v_id, v_seq, 'RNT_SUPPLIERS_SEQ');

     select max( agreement_id)
     into v_id
     from RNT_TENANCY_AGREEMENT; 
     select RNT_TENANCY_AGREEMENT_SEQ.nextval
     into v_seq
     from dual;
     
     set_seq(v_id, v_seq, 'RNT_TENANCY_AGREEMENT_SEQ');


     select max( tenant_id)
     into v_id
     from RNT_TENANT;
     select RNT_TENANT_SEQ.nextval
     into v_seq
     from dual;
     
     set_seq(v_id, v_seq, 'RNT_TENANT_SEQ');

     select max( user_id)
     into v_id
     from RNT_USERS;
     select RNT_USERS_SEQ.nextval
     into  v_seq
     from dual;
     
     set_seq(v_id, v_seq, 'RNT_USERS_SEQ');

     select max( user_assign_id)
     into v_id
     from RNT_USER_ASSIGNMENTS;
     select  RNT_USER_ASSIGNMENTS_SEQ.nextval
     into  v_seq
     from dual;
     
     set_seq(v_id, v_seq, 'RNT_USER_ASSIGNMENTS_SEQ');


     select max( USER_REGISTRY_ID)
     into v_id
     from RNT_USER_REGISTRY;
     select  RNT_USER_REGISTRY_SEQ.nextval
     into  v_seq
     from dual;
     
     set_seq(v_id, v_seq, 'RNT_USER_REGISTRY_SEQ');


     select max( role_id)
     into v_id
     from RNT_USER_ROLES;
     select  RNT_USER_ROLES_SEQ.nextval
     into v_seq
     from dual;
     
     set_seq(v_id, v_seq, 'RNT_USER_ROLES_SEQ');

     
  end process_sequences;

begin
  process_sequences;
end;
/
