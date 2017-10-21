--------------------------------------------------------------------------
-- Play this script in TESTRNTMGR@XE to make it look like RNTMGR@XE
--                                                                      --
-- Please review the script before using it to make sure it won't       --
-- cause any unacceptable data loss.                                    --
--                                                                      --
-- TESTRNTMGR@XE Schema Extracted by User TESTRNTMGR 
-- RNTMGR@XE Schema Extracted by User RNTMGR 
ALTER PACKAGE RNT_ERROR_DESCRIPTION_PKG COMPILE;

ALTER PACKAGE RNT_ERROR_DESCRIPTION_PKG COMPILE BODY;

@@rnt_tenancy_agreement_pkg.sql 
SHOW ERRORS;

ALTER PACKAGE RNT_ACCOUNTS_RECEIVABLE_PKG COMPILE BODY;

ALTER PACKAGE RNT_AGREEMENT_ACTIONS_PKG COMPILE BODY;

@@rnt_properties_pkg.sql

SHOW ERRORS;

ALTER PACKAGE RNT_ACCOUNTS_PAYABLE_PKG COMPILE BODY;

-- Difference: Status (no action taken since target is valid).
CREATE OR REPLACE FORCE VIEW RNT_ACCOUNTS_PAYABLE_V
(AP_ID, PAYMENT_DUE_DATE, AMOUNT, PAYMENT_TYPE_ID, EXPENSE_ID, 
 LOAN_ID, SUPPLIER_ID, PAYMENT_PROPERTY_ID, CHECKSUM, BUSINESS_ID, 
 RECORD_TYPE, INVOICE_NUMBER, SUPPLIER_NAME, PAYMENT_TYPE_NAME, PROPERTY_NAME)
AS 
select ap.AP_ID
,      ap.PAYMENT_DUE_DATE
,      ap.AMOUNT
,      ap.PAYMENT_TYPE_ID
,      ap.EXPENSE_ID
,      ap.LOAN_ID
,      ap.SUPPLIER_ID
,      ap.PAYMENT_PROPERTY_ID
,      ap.CHECKSUM
,      ap.BUSINESS_ID
,      ap.RECORD_TYPE
,      ap.INVOICE_NUMBER
,      s.NAME as SUPPLIER_NAME
,      pt.PAYMENT_TYPE_NAME
,      p.ADDRESS1 as PROPERTY_NAME    
from RNT_ACCOUNTS_PAYABLE_ALL_V ap,
     RNT_SUPPLIERS s,
     RNT_PAYMENT_TYPES pt,
     RNT_PROPERTIES p
where ap.SUPPLIER_ID = s.SUPPLIER_ID
  and pt.PAYMENT_TYPE_ID = ap.PAYMENT_TYPE_ID
  and p.PROPERTY_ID = ap.PAYMENT_PROPERTY_ID
  and ap.RECORD_TYPE = RNT_ACCOUNTS_PAYABLE_PKG.CONST_EXPENSE_TYPE_VAL();

CREATE OR REPLACE FORCE VIEW RNT_ACCNTS_PAYABLE_EXPENSES_V
(AP_ID, PAYMENT_DUE_DATE, AMOUNT, PAYMENT_TYPE_ID, EXPENSE_ID, 
 LOAN_ID, SUPPLIER_ID, PAYMENT_PROPERTY_ID, CHECKSUM, SUPPLIER_NAME, 
 PROPERTY_ID, PROPERTY_NAME, BUSINESS_ID, PAYMENT_TYPE_NAME, PAYMENT_DATE, 
 RECORD_TYPE, INVOICE_NUMBER)
AS 
select ap.AP_ID
,      ap.PAYMENT_DUE_DATE
,      ap.AMOUNT
,      ap.PAYMENT_TYPE_ID
,      ap.EXPENSE_ID
,      ap.LOAN_ID
,      ap.SUPPLIER_ID
,      ap.PAYMENT_PROPERTY_ID
,      ap.CHECKSUM
,      s.NAME as SUPPLIER_NAME
,      ex.PROPERTY_ID
,      p.ADDRESS1 as PROPERTY_NAME
,      ap.BUSINESS_ID
,      pt.PAYMENT_TYPE_NAME
,      pa.PAYMENT_DATE
,      ap.RECORD_TYPE
,      ap.INVOICE_NUMBER
from RNT_ACCOUNTS_PAYABLE_ALL_V ap,
     RNT_SUPPLIERS s,
     RNT_PROPERTY_EXPENSES ex,
     RNT_PROPERTIES p,
     RNT_PAYMENT_TYPES pt,
     RNT_PAYMENT_ALLOCATIONS pa 
where s.SUPPLIER_ID = ap.SUPPLIER_ID
  and ap.EXPENSE_ID = ex.EXPENSE_ID 
  and p.PROPERTY_ID = ex.PROPERTY_ID
  and pt.PAYMENT_TYPE_ID = ap.PAYMENT_TYPE_ID
  and pa.AP_ID(+) = ap.AP_ID
  and ap.RECORD_TYPE in (RNT_ACCOUNTS_PAYABLE_PKG.CONST_EXPENSE_TYPE_VAL(), RNT_ACCOUNTS_PAYABLE_PKG.CONST_GENERATE_TYPE_VAL());