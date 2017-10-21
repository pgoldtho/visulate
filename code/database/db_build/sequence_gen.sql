select sequence_name from user_sequences;
select 'select ''create sequence '|| sequence_name|| ' start with ''||'||sequence_name||'.nextval||'';'' from dual;' from user_sequences;
select 'grant select on rntmgr_seq.'|| sequence_name|| ' to rntmgr1;' from user_sequences;
select 'create synonym '||sequence_name||' for rntmgr_seq.'||sequence_name||';' from user_sequences;


create user rntmgr_seq identified by R1venSeq
default tablespace users temporary tablespace temp;
grant create sequence to rntmgr_seq;
grant read, write on directory DPUMP_DIR1 to rntmgr_seq;
alter user rntmgr_seq quota unlimited on users;
grant create table to rntmgr_seq;


create sequence MLS_LISTINGS_SEQ start with 119144433848;
create sequence PR_BUILDINGS_SEQ start with 438124;
create sequence PR_LOCATIONS_SEQ start with 4369454;
create sequence PR_OWNERS_SEQ start with 7153380;
create sequence PR_PRINCIPALS_SEQ start with 3152156;
create sequence PR_PROPERTIES_SEQ start with 14936733;
create sequence PR_SOURCES_SEQ start with 24;
create sequence RNT_ACCOUNTS_PAYABLE_SEQ start with 8587632;
create sequence RNT_ACCOUNTS_RECEIVABLE_SEQ start with 61267;
create sequence RNT_ACCOUNTS_SEQ start with 7241;
create sequence RNT_ACCOUNT_PERIODS_SEQ start with 1861;
create sequence RNT_AGREEMENT_ACTIONS_SEQ start with 12656;
create sequence RNT_BUSINESS_UNITS_SEQ start with 240;
create sequence RNT_BU_SUPPLIERS_SEQ start with 1670;
create sequence RNT_CITIES_SEQ start with 29916;
create sequence RNT_DEFAULT_ACCOUNTS_SEQ start with 1;
create sequence RNT_DOC_TEMPLATES_SEQ start with 161;
create sequence RNT_ERROR_DESCRIPTION_SEQ start with 350;
create sequence RNT_EXPENSE_ITEMS_SEQ start with 192;
create sequence RNT_LEDGER_ENTRIES_SEQ start with 1665622;
create sequence RNT_LOANS_SEQ start with 641;
create sequence RNT_PAYMENTS_SEQ start with 33772;
create sequence RNT_PAYMENT_ALLOCATIONS_SEQ start with 757638;
create sequence RNT_PAYMENT_TYPES_SEQ start with 101;
create sequence RNT_PEOPLE_BU_SEQ start with 809;
create sequence RNT_PEOPLE_SEQ start with 562;
create sequence RNT_PROPERTIES_SEQ start with 4141;
create sequence RNT_PROPERTY_ESTIMATES_SEQ start with 292;
create sequence RNT_PROPERTY_EXPENSES_SEQ start with 65145;
create sequence RNT_PROPERTY_LINKS_SEQ start with 370;
create sequence RNT_PROPERTY_PHOTOS_SEQ start with 554;
create sequence RNT_PROPERTY_UNITS_SEQ start with 1290;
create sequence RNT_PROPERTY_VALUE_SEQ start with 1221;
create sequence RNT_SECTION8_OFFICES_BU_SEQ start with 5031;
create sequence RNT_SECTION8_OFFICES_SEQ start with 16;
create sequence RNT_SUPPLIERS_SEQ start with 8201;
create sequence RNT_TENANCY_AGREEMENT_SEQ start with 15908;
create sequence RNT_TENANT_SEQ start with 15636;
create sequence RNT_USERS_SEQ start with 123;
create sequence RNT_USER_ASSIGNMENTS_SEQ start with 405;
create sequence RNT_USER_REGISTRY_SEQ start with 247;
create sequence RNT_USER_ROLES_SEQ start with 20;

grant select on rntmgr_seq.MLS_LISTINGS_SEQ to rntmgr1;
grant select on rntmgr_seq.PR_BUILDINGS_SEQ to rntmgr1;
grant select on rntmgr_seq.PR_LOCATIONS_SEQ to rntmgr1;
grant select on rntmgr_seq.PR_OWNERS_SEQ to rntmgr1;
grant select on rntmgr_seq.PR_PRINCIPALS_SEQ to rntmgr1;
grant select on rntmgr_seq.PR_PROPERTIES_SEQ to rntmgr1;
grant select on rntmgr_seq.PR_SOURCES_SEQ to rntmgr1;
grant select on rntmgr_seq.RNT_ACCOUNTS_PAYABLE_SEQ to rntmgr1;
grant select on rntmgr_seq.RNT_ACCOUNTS_RECEIVABLE_SEQ to rntmgr1;
grant select on rntmgr_seq.RNT_ACCOUNTS_SEQ to rntmgr1;
grant select on rntmgr_seq.RNT_ACCOUNT_PERIODS_SEQ to rntmgr1;
grant select on rntmgr_seq.RNT_AGREEMENT_ACTIONS_SEQ to rntmgr1;
grant select on rntmgr_seq.RNT_BUSINESS_UNITS_SEQ to rntmgr1;
grant select on rntmgr_seq.RNT_BU_SUPPLIERS_SEQ to rntmgr1;
grant select on rntmgr_seq.RNT_CITIES_SEQ to rntmgr1;
grant select on rntmgr_seq.RNT_DEFAULT_ACCOUNTS_SEQ to rntmgr1;
grant select on rntmgr_seq.RNT_DOC_TEMPLATES_SEQ to rntmgr1;
grant select on rntmgr_seq.RNT_ERROR_DESCRIPTION_SEQ to rntmgr1;
grant select on rntmgr_seq.RNT_EXPENSE_ITEMS_SEQ to rntmgr1;
grant select on rntmgr_seq.RNT_LEDGER_ENTRIES_SEQ to rntmgr1;
grant select on rntmgr_seq.RNT_LOANS_SEQ to rntmgr1;
grant select on rntmgr_seq.RNT_PAYMENTS_SEQ to rntmgr1;
grant select on rntmgr_seq.RNT_PAYMENT_ALLOCATIONS_SEQ to rntmgr1;
grant select on rntmgr_seq.RNT_PAYMENT_TYPES_SEQ to rntmgr1;
grant select on rntmgr_seq.RNT_PEOPLE_BU_SEQ to rntmgr1;
grant select on rntmgr_seq.RNT_PEOPLE_SEQ to rntmgr1;
grant select on rntmgr_seq.RNT_PROPERTIES_SEQ to rntmgr1;
grant select on rntmgr_seq.RNT_PROPERTY_ESTIMATES_SEQ to rntmgr1;
grant select on rntmgr_seq.RNT_PROPERTY_EXPENSES_SEQ to rntmgr1;
grant select on rntmgr_seq.RNT_PROPERTY_LINKS_SEQ to rntmgr1;
grant select on rntmgr_seq.RNT_PROPERTY_PHOTOS_SEQ to rntmgr1;
grant select on rntmgr_seq.RNT_PROPERTY_UNITS_SEQ to rntmgr1;
grant select on rntmgr_seq.RNT_PROPERTY_VALUE_SEQ to rntmgr1;
grant select on rntmgr_seq.RNT_SECTION8_OFFICES_BU_SEQ to rntmgr1;
grant select on rntmgr_seq.RNT_SECTION8_OFFICES_SEQ to rntmgr1;
grant select on rntmgr_seq.RNT_SUPPLIERS_SEQ to rntmgr1;
grant select on rntmgr_seq.RNT_TENANCY_AGREEMENT_SEQ to rntmgr1;
grant select on rntmgr_seq.RNT_TENANT_SEQ to rntmgr1;
grant select on rntmgr_seq.RNT_USERS_SEQ to rntmgr1;
grant select on rntmgr_seq.RNT_USER_ASSIGNMENTS_SEQ to rntmgr1;
grant select on rntmgr_seq.RNT_USER_REGISTRY_SEQ to rntmgr1;
grant select on rntmgr_seq.RNT_USER_ROLES_SEQ to rntmgr1;

grant select on rntmgr_seq.MLS_LISTINGS_SEQ to rntmgr2;
grant select on rntmgr_seq.PR_BUILDINGS_SEQ to rntmgr2;
grant select on rntmgr_seq.PR_LOCATIONS_SEQ to rntmgr2;
grant select on rntmgr_seq.PR_OWNERS_SEQ to rntmgr2;
grant select on rntmgr_seq.PR_PRINCIPALS_SEQ to rntmgr2;
grant select on rntmgr_seq.PR_PROPERTIES_SEQ to rntmgr2;
grant select on rntmgr_seq.PR_SOURCES_SEQ to rntmgr2;
grant select on rntmgr_seq.RNT_ACCOUNTS_PAYABLE_SEQ to rntmgr2;
grant select on rntmgr_seq.RNT_ACCOUNTS_RECEIVABLE_SEQ to rntmgr2;
grant select on rntmgr_seq.RNT_ACCOUNTS_SEQ to rntmgr2;
grant select on rntmgr_seq.RNT_ACCOUNT_PERIODS_SEQ to rntmgr2;
grant select on rntmgr_seq.RNT_AGREEMENT_ACTIONS_SEQ to rntmgr2;
grant select on rntmgr_seq.RNT_BUSINESS_UNITS_SEQ to rntmgr2;
grant select on rntmgr_seq.RNT_BU_SUPPLIERS_SEQ to rntmgr2;
grant select on rntmgr_seq.RNT_CITIES_SEQ to rntmgr2;
grant select on rntmgr_seq.RNT_DEFAULT_ACCOUNTS_SEQ to rntmgr2;
grant select on rntmgr_seq.RNT_DOC_TEMPLATES_SEQ to rntmgr2;
grant select on rntmgr_seq.RNT_ERROR_DESCRIPTION_SEQ to rntmgr2;
grant select on rntmgr_seq.RNT_EXPENSE_ITEMS_SEQ to rntmgr2;
grant select on rntmgr_seq.RNT_LEDGER_ENTRIES_SEQ to rntmgr2;
grant select on rntmgr_seq.RNT_LOANS_SEQ to rntmgr2;
grant select on rntmgr_seq.RNT_PAYMENTS_SEQ to rntmgr2;
grant select on rntmgr_seq.RNT_PAYMENT_ALLOCATIONS_SEQ to rntmgr2;
grant select on rntmgr_seq.RNT_PAYMENT_TYPES_SEQ to rntmgr2;
grant select on rntmgr_seq.RNT_PEOPLE_BU_SEQ to rntmgr2;
grant select on rntmgr_seq.RNT_PEOPLE_SEQ to rntmgr2;
grant select on rntmgr_seq.RNT_PROPERTIES_SEQ to rntmgr2;
grant select on rntmgr_seq.RNT_PROPERTY_ESTIMATES_SEQ to rntmgr2;
grant select on rntmgr_seq.RNT_PROPERTY_EXPENSES_SEQ to rntmgr2;
grant select on rntmgr_seq.RNT_PROPERTY_LINKS_SEQ to rntmgr2;
grant select on rntmgr_seq.RNT_PROPERTY_PHOTOS_SEQ to rntmgr2;
grant select on rntmgr_seq.RNT_PROPERTY_UNITS_SEQ to rntmgr2;
grant select on rntmgr_seq.RNT_PROPERTY_VALUE_SEQ to rntmgr2;
grant select on rntmgr_seq.RNT_SECTION8_OFFICES_BU_SEQ to rntmgr2;
grant select on rntmgr_seq.RNT_SECTION8_OFFICES_SEQ to rntmgr2;
grant select on rntmgr_seq.RNT_SUPPLIERS_SEQ to rntmgr2;
grant select on rntmgr_seq.RNT_TENANCY_AGREEMENT_SEQ to rntmgr2;
grant select on rntmgr_seq.RNT_TENANT_SEQ to rntmgr2;
grant select on rntmgr_seq.RNT_USERS_SEQ to rntmgr2;
grant select on rntmgr_seq.RNT_USER_ASSIGNMENTS_SEQ to rntmgr2;
grant select on rntmgr_seq.RNT_USER_REGISTRY_SEQ to rntmgr2;
grant select on rntmgr_seq.RNT_USER_ROLES_SEQ to rntmgr2;

create synonym MLS_LISTINGS_SEQ for rntmgr_seq.MLS_LISTINGS_SEQ;
create synonym PR_BUILDINGS_SEQ for rntmgr_seq.PR_BUILDINGS_SEQ;
create synonym PR_LOCATIONS_SEQ for rntmgr_seq.PR_LOCATIONS_SEQ;
create synonym PR_OWNERS_SEQ for rntmgr_seq.PR_OWNERS_SEQ;
create synonym PR_PRINCIPALS_SEQ for rntmgr_seq.PR_PRINCIPALS_SEQ;
create synonym PR_PROPERTIES_SEQ for rntmgr_seq.PR_PROPERTIES_SEQ;
create synonym PR_SOURCES_SEQ for rntmgr_seq.PR_SOURCES_SEQ;
create synonym RNT_ACCOUNTS_PAYABLE_SEQ for rntmgr_seq.RNT_ACCOUNTS_PAYABLE_SEQ;
create synonym RNT_ACCOUNTS_RECEIVABLE_SEQ for rntmgr_seq.RNT_ACCOUNTS_RECEIVABLE_SEQ;
create synonym RNT_ACCOUNTS_SEQ for rntmgr_seq.RNT_ACCOUNTS_SEQ;
create synonym RNT_ACCOUNT_PERIODS_SEQ for rntmgr_seq.RNT_ACCOUNT_PERIODS_SEQ;
create synonym RNT_AGREEMENT_ACTIONS_SEQ for rntmgr_seq.RNT_AGREEMENT_ACTIONS_SEQ;
create synonym RNT_BUSINESS_UNITS_SEQ for rntmgr_seq.RNT_BUSINESS_UNITS_SEQ;
create synonym RNT_BU_SUPPLIERS_SEQ for rntmgr_seq.RNT_BU_SUPPLIERS_SEQ;
create synonym RNT_CITIES_SEQ for rntmgr_seq.RNT_CITIES_SEQ;
create synonym RNT_DEFAULT_ACCOUNTS_SEQ for rntmgr_seq.RNT_DEFAULT_ACCOUNTS_SEQ;
create synonym RNT_DOC_TEMPLATES_SEQ for rntmgr_seq.RNT_DOC_TEMPLATES_SEQ;
create synonym RNT_ERROR_DESCRIPTION_SEQ for rntmgr_seq.RNT_ERROR_DESCRIPTION_SEQ;
create synonym RNT_EXPENSE_ITEMS_SEQ for rntmgr_seq.RNT_EXPENSE_ITEMS_SEQ;
create synonym RNT_LEDGER_ENTRIES_SEQ for rntmgr_seq.RNT_LEDGER_ENTRIES_SEQ;
create synonym RNT_LOANS_SEQ for rntmgr_seq.RNT_LOANS_SEQ;
create synonym RNT_PAYMENTS_SEQ for rntmgr_seq.RNT_PAYMENTS_SEQ;
create synonym RNT_PAYMENT_ALLOCATIONS_SEQ for rntmgr_seq.RNT_PAYMENT_ALLOCATIONS_SEQ;
create synonym RNT_PAYMENT_TYPES_SEQ for rntmgr_seq.RNT_PAYMENT_TYPES_SEQ;
create synonym RNT_PEOPLE_BU_SEQ for rntmgr_seq.RNT_PEOPLE_BU_SEQ;
create synonym RNT_PEOPLE_SEQ for rntmgr_seq.RNT_PEOPLE_SEQ;
create synonym RNT_PROPERTIES_SEQ for rntmgr_seq.RNT_PROPERTIES_SEQ;
create synonym RNT_PROPERTY_ESTIMATES_SEQ for rntmgr_seq.RNT_PROPERTY_ESTIMATES_SEQ;
create synonym RNT_PROPERTY_EXPENSES_SEQ for rntmgr_seq.RNT_PROPERTY_EXPENSES_SEQ;
create synonym RNT_PROPERTY_LINKS_SEQ for rntmgr_seq.RNT_PROPERTY_LINKS_SEQ;
create synonym RNT_PROPERTY_PHOTOS_SEQ for rntmgr_seq.RNT_PROPERTY_PHOTOS_SEQ;
create synonym RNT_PROPERTY_UNITS_SEQ for rntmgr_seq.RNT_PROPERTY_UNITS_SEQ;
create synonym RNT_PROPERTY_VALUE_SEQ for rntmgr_seq.RNT_PROPERTY_VALUE_SEQ;
create synonym RNT_SECTION8_OFFICES_BU_SEQ for rntmgr_seq.RNT_SECTION8_OFFICES_BU_SEQ;
create synonym RNT_SECTION8_OFFICES_SEQ for rntmgr_seq.RNT_SECTION8_OFFICES_SEQ;
create synonym RNT_SUPPLIERS_SEQ for rntmgr_seq.RNT_SUPPLIERS_SEQ;
create synonym RNT_TENANCY_AGREEMENT_SEQ for rntmgr_seq.RNT_TENANCY_AGREEMENT_SEQ;
create synonym RNT_TENANT_SEQ for rntmgr_seq.RNT_TENANT_SEQ;
create synonym RNT_USERS_SEQ for rntmgr_seq.RNT_USERS_SEQ;
create synonym RNT_USER_ASSIGNMENTS_SEQ for rntmgr_seq.RNT_USER_ASSIGNMENTS_SEQ;
create synonym RNT_USER_REGISTRY_SEQ for rntmgr_seq.RNT_USER_REGISTRY_SEQ;
create synonym RNT_USER_ROLES_SEQ for rntmgr_seq.RNT_USER_ROLES_SEQ;



