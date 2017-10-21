create or replace type property_rec as object
    ( prop_id           number
    , address1          varchar2(60));
/  

create or replace type  property_list_t is table of property_rec ;
/