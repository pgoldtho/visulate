--------------------------------------------------------------------------
-- Play this script in TESTRNTMGR@XE to make it look like RNTMGR@XE
--                                                                      --
-- Please review the script before using it to make sure it won't       --
-- cause any unacceptable data loss.                                    --
--                                                                      --
-- TESTRNTMGR@XE Schema Extracted by User TESTRNTMGR 
-- RNTMGR@XE Schema Extracted by User RNTMGR 
CREATE OR REPLACE TYPE T2REC_DATE AS OBJECT(START_DATE DATE, END_DATE DATE)
/

SHOW ERRORS;

CREATE OR REPLACE type T2REC_DATE_TABLE as table of T2REC_DATE
/

SHOW ERRORS;

CREATE OR REPLACE FORCE VIEW RNT_LOANS_V
(LOAN_ID, PROPERTY_ID, POSITION, LOAN_DATE, LOAN_AMOUNT, 
 TERM, INTEREST_RATE, CREDIT_LINE_YN, ARM_YN, BALLOON_DATE, 
 CLOSING_COSTS, SETTLEMENT_DATE, CHECKSUM)
AS 
select 
   LOAN_ID, PROPERTY_ID, POSITION, 
   LOAN_DATE, LOAN_AMOUNT, 
   TERM, INTEREST_RATE, CREDIT_LINE_YN, 
   ARM_YN, BALLOON_DATE, CLOSING_COSTS, 
   SETTLEMENT_DATE, RNT_LOANS_PKG.GET_CHECKSUM(LOAN_ID) as CHECKSUM
from RNT_LOANS;


SHOW ERRORS;

