CREATE OR REPLACE PACKAGE RNTMGR.RNT_LOANS_PKG AS
/******************************************************************************
   NAME:       RNT_LOANS_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        08.04.2007             1. Created this package.
******************************************************************************/

function get_checksum(X_LOAN_ID RNT_LOANS.LOAN_ID%TYPE) return VARCHAR2;

procedure update_row(X_LOAN_ID            RNT_LOANS.LOAN_ID%TYPE,
                     X_PROPERTY_ID        RNT_LOANS.PROPERTY_ID%TYPE,
                     X_POSITION           RNT_LOANS.POSITION%TYPE,
                     X_LOAN_DATE          RNT_LOANS.LOAN_DATE%TYPE,
                     X_LOAN_AMOUNT        RNT_LOANS.LOAN_AMOUNT%TYPE,
                     X_TERM               RNT_LOANS.TERM%TYPE,
                     X_INTEREST_RATE      RNT_LOANS.INTEREST_RATE%TYPE,
                     X_CREDIT_LINE_YN     RNT_LOANS.CREDIT_LINE_YN%TYPE,
                     X_ARM_YN             RNT_LOANS.ARM_YN%TYPE,
                     X_BALLOON_DATE       RNT_LOANS.BALLOON_DATE%TYPE,
                     X_AMORTIZATION_START RNT_LOANS.AMORTIZATION_START%TYPE,
                     X_SETTLEMENT_DATE    RNT_LOANS.SETTLEMENT_DATE%TYPE,
                     X_CHECKSUM           VARCHAR2
                    ); 

function insert_row( X_PROPERTY_ID        RNT_LOANS.PROPERTY_ID%TYPE,
                     X_POSITION           RNT_LOANS.POSITION%TYPE,
                     X_LOAN_DATE          RNT_LOANS.LOAN_DATE%TYPE,
                     X_LOAN_AMOUNT        RNT_LOANS.LOAN_AMOUNT%TYPE,
                     X_TERM               RNT_LOANS.TERM%TYPE,
                     X_INTEREST_RATE      RNT_LOANS.INTEREST_RATE%TYPE,
                     X_CREDIT_LINE_YN     RNT_LOANS.CREDIT_LINE_YN%TYPE,
                     X_ARM_YN             RNT_LOANS.ARM_YN%TYPE,
                     X_BALLOON_DATE       RNT_LOANS.BALLOON_DATE%TYPE,
                     X_AMORTIZATION_START RNT_LOANS.AMORTIZATION_START%TYPE,
                     X_SETTLEMENT_DATE    RNT_LOANS.SETTLEMENT_DATE%TYPE
                    ) return RNT_LOANS.LOAN_ID%TYPE; 
END RNT_LOANS_PKG; 
/

