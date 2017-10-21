SET DEFINE OFF;
Insert into RNT_PAYMENT_TYPES
   (PAYMENT_TYPE_ID, PAYMENT_TYPE_NAME)
 Values
   (13, 'Remaining Rent');
Insert into RNT_PAYMENT_TYPES
   (PAYMENT_TYPE_ID, PAYMENT_TYPE_NAME)
 Values
   (14, 'Section 8 Rent');
COMMIT;


SET DEFINE OFF;
update RNT_LOOKUP_VALUES
set LOOKUP_VALUE = 'Current - Primary'
where LOOKUP_VALUE_ID = 11;

Insert into RNT_LOOKUP_VALUES
   (LOOKUP_VALUE_ID, LOOKUP_CODE, LOOKUP_VALUE, LOOKUP_TYPE_ID)
 Values
   (27, 'CURRENT_SECONDARY', 'Current - Secondary', 4);
COMMIT;
