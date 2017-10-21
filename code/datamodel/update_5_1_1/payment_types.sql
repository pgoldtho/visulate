SET DEFINE OFF;
Insert into RNT_PAYMENT_TYPES
   (PAYMENT_TYPE_ID, PAYMENT_TYPE_NAME)
 Values
   (7, 'Rent');
Insert into RNT_PAYMENT_TYPES
   (PAYMENT_TYPE_ID, PAYMENT_TYPE_NAME)
 Values
   (8, 'Discount rent');
Insert into RNT_PAYMENT_TYPES
   (PAYMENT_TYPE_ID, PAYMENT_TYPE_NAME)
 Values
   (9, 'Recoverable');
Insert into RNT_PAYMENT_TYPES
   (PAYMENT_TYPE_ID, PAYMENT_TYPE_NAME)
 Values
   (10, 'Late Fee');
Insert into RNT_PAYMENT_TYPES
   (PAYMENT_TYPE_ID, PAYMENT_TYPE_NAME, DEPRECIATION_TERM, DESCRIPTION)
 Values
   (1, 'Utilites', 111, '1111');
Insert into RNT_PAYMENT_TYPES
   (PAYMENT_TYPE_ID, PAYMENT_TYPE_NAME, DEPRECIATION_TERM, DESCRIPTION)
 Values
   (2, 'Tax', 123, '123123');
Insert into RNT_PAYMENT_TYPES
   (PAYMENT_TYPE_ID, PAYMENT_TYPE_NAME)
 Values
   (3, 'Insurance');
Insert into RNT_PAYMENT_TYPES
   (PAYMENT_TYPE_ID, PAYMENT_TYPE_NAME)
 Values
   (4, '3 Year Amortization');
Insert into RNT_PAYMENT_TYPES
   (PAYMENT_TYPE_ID, PAYMENT_TYPE_NAME)
 Values
   (5, '5 Year Amortization');
Insert into RNT_PAYMENT_TYPES
   (PAYMENT_TYPE_ID, PAYMENT_TYPE_NAME)
 Values
   (6, '10 Year Amortization');
COMMIT;
