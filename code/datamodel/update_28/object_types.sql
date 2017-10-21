CREATE OR REPLACE
TYPE T_SUMMARY_REC3 AS 
OBJECT(
        PROPERTY_ID        NUMBER,
        ADDRESS1           VARCHAR (60), 
        BUSINESS_ID        NUMBER, 
        INCOME_AMOUNT      NUMBER,
        EXPENSE_AMOUNT     NUMBER,
        CASH_FLOW          NUMBER,
        OWED_AMOUNT        NUMBER,
        UNCOLLECTED_INCOME NUMBER,
        INVOICED_AMOUNT    NUMBER,
        UNPAID_INVOICES    NUMBER,
        NOI_VALUE          NUMBER,
        CAP_RATE_VALUE     NUMBER
      )
/
      
SHOW ERRORS;
      
CREATE OR REPLACE
type  T_SUMMARY_TABLE_3 as table of T_SUMMARY_REC3
/
 
SHOW ERRORS;       