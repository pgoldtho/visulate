insert into rnt_lookup_types
  (lookup_type_id, lookup_type_code, lookup_type_description)
values
  (7, 'PROPERTY_STATUS', 'Ownership status for a property within a business unit.');

insert into rnt_lookup_values
  (LOOKUP_VALUE_ID, LOOKUP_CODE, LOOKUP_VALUE, LOOKUP_TYPE_ID)
values
  ( 1057 , 'CANDIDATE', 'Candidate', 7);
insert into rnt_lookup_values
  (LOOKUP_VALUE_ID, LOOKUP_CODE, LOOKUP_VALUE, LOOKUP_TYPE_ID)
values
  ( 1058 , 'REJECTED', 'Rejected', 7);
insert into rnt_lookup_values
  (LOOKUP_VALUE_ID, LOOKUP_CODE, LOOKUP_VALUE, LOOKUP_TYPE_ID)
values
  ( 1059, 'OFFER_MADE', 'Offer Made',  7);
insert into rnt_lookup_values
  (LOOKUP_VALUE_ID, LOOKUP_CODE, LOOKUP_VALUE, LOOKUP_TYPE_ID)
values
  ( 1060, 'OFFER_ACCEPTED',  'Offer Accepted', 7);
insert into rnt_lookup_values
  (LOOKUP_VALUE_ID, LOOKUP_CODE, LOOKUP_VALUE, LOOKUP_TYPE_ID)
values
  ( 1061, 'PURCHASED',  'Purchased', 7);
insert into rnt_lookup_values
  (LOOKUP_VALUE_ID, LOOKUP_CODE, LOOKUP_VALUE, LOOKUP_TYPE_ID)
values
  ( 1062, 'SOLD',  'Sold', 7);





insert into rnt_lookup_types
  (lookup_type_id, lookup_type_code, lookup_type_description)
values
  (8, 'VALUATION_METHOD', 'Property valuation method');

insert into rnt_lookup_values
  (LOOKUP_VALUE_ID, LOOKUP_CODE, LOOKUP_VALUE, LOOKUP_TYPE_ID)
values
  ( 1063, 'ASK',  'Asking Price', 8);

insert into rnt_lookup_values
  (LOOKUP_VALUE_ID, LOOKUP_CODE, LOOKUP_VALUE, LOOKUP_TYPE_ID)
values
  ( 1064, 'OFFER',  'Offer Price', 8);
insert into rnt_lookup_values
  (LOOKUP_VALUE_ID, LOOKUP_CODE, LOOKUP_VALUE, LOOKUP_TYPE_ID)
values
  ( 1065, 'ARV',  'After Repair value', 8);
insert into rnt_lookup_values
  (LOOKUP_VALUE_ID, LOOKUP_CODE, LOOKUP_VALUE, LOOKUP_TYPE_ID)
values
  ( 1066, 'COST',  'Cost', 8);
insert into rnt_lookup_values
  (LOOKUP_VALUE_ID, LOOKUP_CODE, LOOKUP_VALUE, LOOKUP_TYPE_ID)
values
  ( 1067, 'MARKET',  'Market', 8);
insert into rnt_lookup_values
  (LOOKUP_VALUE_ID, LOOKUP_CODE, LOOKUP_VALUE, LOOKUP_TYPE_ID)
values
  ( 1068, 'INCOME',  'Income', 8);

commit;
