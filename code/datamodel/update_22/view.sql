CREATE OR REPLACE FORCE VIEW RNT_LOANS_V
(LOAN_ID, PROPERTY_ID, POSITION, LOAN_DATE, LOAN_AMOUNT, 
 TERM, INTEREST_RATE, CREDIT_LINE_YN, ARM_YN, BALLOON_DATE, 
 CLOSING_COSTS, SETTLEMENT_DATE, CHECKSUM)
AS 
select    LOAN_ID, PROPERTY_ID, POSITION,    LOAN_DATE, LOAN_AMOUNT, 
   TERM, INTEREST_RATE, CREDIT_LINE_YN, 
   ARM_YN, BALLOON_DATE, CLOSING_COSTS, 
   SETTLEMENT_DATE, RNT_LOANS_PKG.GET_CHECKSUM(LOAN_ID) as CHECKSUM
from RNT_LOANS;