CREATE TYPE "RNTMGR2"."T2REC_DATE"   AS OBJECT(START_DATE DATE, END_DATE DATE);
/
CREATE TYPE "RNTMGR2"."T_SUMMARY_REC1" AS
OBJECT(
        MONTH_DATE         DATE,
        BUSINESS_ID        NUMBER,
        INCOME_AMOUNT      NUMBER,
        EXPENSE_AMOUNT     NUMBER,
        CASH_FLOW          NUMBER,
        OWED_AMOUNT        NUMBER,
        UNCOLLECTED_INCOME NUMBER,
        INVOICED_AMOUNT    NUMBER,
        UNPAID_INVOICES    NUMBER);
/        
CREATE TYPE "RNTMGR2"."T_SUMMARY_REC2" AS
OBJECT(
        PROPERTY_ID NUMBER,
        ADDRESS1    VARCHAR (60),
        NOI_VALUE NUMBER,
        CAP_RATE_VALUE NUMBER
      );
/      
CREATE TYPE "RNTMGR2"."T_SUMMARY_REC3" AS
OBJECT(
        PROPERTY_ID        NUMBER,
        ADDRESS1           VARCHAR (60),
        BUSINESS_ID        NUMBER,
        INCOME_AMOUNT      NUMBER,
        EXPENSE_AMOUNT     NUMBER,
        CASH_FLOW          NUMBER,
        OWED_AMOUNT        NUMBER,
        UNCOLLECTED_INCOME NUMBER,
        INVOICED_AMOUNT	   NUMBER,
        UNPAID_INVOICES	   NUMBER,
        NOI_VALUE	   NUMBER,
        CAP_RATE_VALUE 	   NUMBER);
/
CREATE TYPE "RNTMGR2"."PROPERTY_REC" as object
    ( prop_id           number
    , address1          varchar2(60));
/

CREATE TYPE "RNTMGR2"."T_SUMMARY_ALERT_REC" as object
 (PROPERTY_ID	    NUMBER,
 UNIT_ID	    NUMBER,
 AGREEMENT_ID	    NUMBER,
 TENANT_ID	    NUMBER,
 BUSINESS_ID	    NUMBER,
 RECORD_TYPE	    VARCHAR2(3),
 DESCRIPTION	    VARCHAR2(1200),
 PAYMENT_DUE_MONTH  VARCHAR2(6));
 /


CREATE TYPE "RNTMGR2"."T2REC_DATE_TABLE" as table of T2REC_DATE;
/
CREATE TYPE "RNTMGR2"."T_SUMMARY_TABLE_2" as table of T_SUMMARY_REC2;
/
CREATE TYPE "RNTMGR2"."T_SUMMARY_TABLE_1"  as table of T_SUMMARY_REC1;
/
CREATE TYPE "RNTMGR2"."T_SUMMARY_ALERT_TABLE" as table of T_SUMMARY_ALERT_REC;
/
CREATE TYPE "RNTMGR2"."T_SUMMARY_TABLE_3" as table of T_SUMMARY_REC3;
/
CREATE TYPE "RNTMGR2"."PROPERTY_LIST_T"   is table of property_rec;
/
create or replace type pr_corp_loc_type as object 
( corp_number   varchar2(12)
, corp_name     varchar2(192)
, loc_type      varchar2(4)
, loc_id        number
, prop_id       number
, address1      varchar2(60)
, address2      varchar2(42)
, city          varchar2(28)
, state          varchar2(2)
, zipcode       number(5)
, lat           number
, lon           number
);
/
create or replace type pr_corp_loc_set as table of pr_corp_loc_type; 
/
