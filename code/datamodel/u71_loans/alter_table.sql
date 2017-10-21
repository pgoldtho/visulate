alter table rnt_property_expenses
add loan_id    number;

alter table rnt_property_expenses
add constraint rnt_property_expenses_r3
foreign key (loan_id) references rnt_loans (loan_id);

create index rnt_property_expenses_n3 on rnt_property_expenses (loan_id);

create or replace view RNT_PROPERTY_EXPENSES_V as
select EXPENSE_ID
,      PROPERTY_ID
,      EVENT_DATE
,      DESCRIPTION
,      RECURRING_YN
,      RECURRING_PERIOD
,      RECURRING_ENDDATE
,      UNIT_ID
,      LOAN_ID
,      rnt_sys_checksum_rec_pkg.get_checksum('EXPENSE_ID='||EXPENSE_ID||'PROPERTY_ID='||PROPERTY_ID
                                            ||'EVENT_DATE='||EVENT_DATE||'DESCRIPTION='||DESCRIPTION
											||'RECURRING_YN='||RECURRING_YN||'RECURRING_PERIOD='||RECURRING_PERIOD
											||'RECURRING_ENDDATE='||RECURRING_ENDDATE||'UNIT_ID='||UNIT_ID
											||'LOAN_ID='||LOAN_ID) as CHECKSUM,
,      u.UNIT_NAME
from RNT_PROPERTY_EXPENSES e,
     RNT_PROPERTY_UNITS u
where e.UNIT_ID = u.UNIT_ID(+);