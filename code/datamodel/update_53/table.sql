alter table RNT_EXPENSE_ITEMS add (ITEM_UNIT VARCHAR2(2));

update RNT_EXPENSE_ITEMS
set ITEM_UNIT = 'FT';

commit;

alter table RNT_EXPENSE_ITEMS modify (ITEM_UNIT VARCHAR2(2) not null);