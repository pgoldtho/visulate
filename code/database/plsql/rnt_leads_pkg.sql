create or replace package RNT_LEADS_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007, 2012       All rights reserved worldwide
    Name:      RNT_LEADS_PKG
    Purpose:   API's for RNT_LEADS table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        24-JAN-13   Auto Generated   Initial Version
*******************************************************************************/
  function get_checksum( X_LEAD_ID IN RNT_LEADS.LEAD_ID%TYPE)
            return RNT_LEADS_V.CHECKSUM%TYPE;

  procedure update_row( X_LEAD_ID IN RNT_LEADS.LEAD_ID%TYPE
                      , X_PEOPLE_BUSINESS_ID IN RNT_LEADS.PEOPLE_BUSINESS_ID%TYPE
                      , X_LEAD_DATE IN RNT_LEADS.LEAD_DATE%TYPE
                      , X_LEAD_STATUS IN RNT_LEADS.LEAD_STATUS%TYPE
                      , X_LEAD_TYPE IN RNT_LEADS.LEAD_TYPE%TYPE
                      , X_REF_PROP_ID IN RNT_LEADS.REF_PROP_ID%TYPE
                      , X_FOLLOW_UP IN RNT_LEADS.FOLLOW_UP%TYPE
                      , X_UCODE IN RNT_LEADS.UCODE%TYPE
                      , X_CITY IN RNT_LEADS.CITY%TYPE
                      , X_MIN_PRICE IN RNT_LEADS.MIN_PRICE%TYPE
                      , X_MAX_PRICE IN RNT_LEADS.MAX_PRICE%TYPE
                      , X_LTV_TARGET IN RNT_LEADS.LTV_TARGET%TYPE
                      , X_LTV_QUALIFIED_YN IN RNT_LEADS.LTV_QUALIFIED_YN%TYPE
                      , X_DESCRIPTION IN RNT_LEADS.DESCRIPTION%TYPE
                      , X_CHECKSUM IN RNT_LEADS_V.CHECKSUM%TYPE);

  function  insert_row( X_PEOPLE_BUSINESS_ID IN RNT_LEADS.PEOPLE_BUSINESS_ID%TYPE
                     , X_LEAD_DATE IN RNT_LEADS.LEAD_DATE%TYPE
                     , X_LEAD_STATUS IN RNT_LEADS.LEAD_STATUS%TYPE
                     , X_LEAD_TYPE IN RNT_LEADS.LEAD_TYPE%TYPE
                     , X_REF_PROP_ID IN RNT_LEADS.REF_PROP_ID%TYPE
                     , X_FOLLOW_UP IN RNT_LEADS.FOLLOW_UP%TYPE
                     , X_UCODE IN RNT_LEADS.UCODE%TYPE
                     , X_CITY IN RNT_LEADS.CITY%TYPE
                     , X_MIN_PRICE IN RNT_LEADS.MIN_PRICE%TYPE
                     , X_MAX_PRICE IN RNT_LEADS.MAX_PRICE%TYPE
                     , X_LTV_TARGET IN RNT_LEADS.LTV_TARGET%TYPE
                     , X_LTV_QUALIFIED_YN IN RNT_LEADS.LTV_QUALIFIED_YN%TYPE
                     , X_DESCRIPTION IN RNT_LEADS.DESCRIPTION%TYPE)
              return RNT_LEADS.LEAD_ID%TYPE;

  procedure delete_row( X_LEAD_ID IN RNT_LEADS.LEAD_ID%TYPE);

end RNT_LEADS_PKG;
/

create or replace package body RNT_LEADS_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007, 2012       All rights reserved worldwide
    Name:      RNT_LEADS_PKG
    Purpose:   API's for RNT_LEADS table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        24-JAN-13   Auto Generated   Initial Version

********************************************************************************/
-------------------------------------------------
--  Private Procedures and Functions
-------------------------------------------------


  procedure lock_row( X_LEAD_ID IN RNT_LEADS.LEAD_ID%TYPE) is
     cursor c is
     select * from RNT_LEADS
     where LEAD_ID = X_LEAD_ID
     for update nowait;

  begin
    open c;
    close c;
  exception
    when OTHERS then
      if SQLCODE = -54 then
        RAISE_APPLICATION_ERROR(-20001, 'Cannot changed record. Record is locked.');
      end if;
  end lock_row;

-------------------------------------------------
--  Public Procedures and Functions
-------------------------------------------------
  function get_checksum( X_LEAD_ID IN RNT_LEADS.LEAD_ID%TYPE)
            return RNT_LEADS_V.CHECKSUM%TYPE is

    v_return_value               RNT_LEADS_V.CHECKSUM%TYPE;
  begin
    select CHECKSUM
    into v_return_value
    from RNT_LEADS_V
    where LEAD_ID = X_LEAD_ID;
    return v_return_value;
  end get_checksum;

  procedure update_row( X_LEAD_ID IN RNT_LEADS.LEAD_ID%TYPE
                      , X_PEOPLE_BUSINESS_ID IN RNT_LEADS.PEOPLE_BUSINESS_ID%TYPE
                      , X_LEAD_DATE IN RNT_LEADS.LEAD_DATE%TYPE
                      , X_LEAD_STATUS IN RNT_LEADS.LEAD_STATUS%TYPE
                      , X_LEAD_TYPE IN RNT_LEADS.LEAD_TYPE%TYPE
                      , X_REF_PROP_ID IN RNT_LEADS.REF_PROP_ID%TYPE
                      , X_FOLLOW_UP IN RNT_LEADS.FOLLOW_UP%TYPE
                      , X_UCODE IN RNT_LEADS.UCODE%TYPE
                      , X_CITY IN RNT_LEADS.CITY%TYPE
                      , X_MIN_PRICE IN RNT_LEADS.MIN_PRICE%TYPE
                      , X_MAX_PRICE IN RNT_LEADS.MAX_PRICE%TYPE
                      , X_LTV_TARGET IN RNT_LEADS.LTV_TARGET%TYPE
                      , X_LTV_QUALIFIED_YN IN RNT_LEADS.LTV_QUALIFIED_YN%TYPE
                      , X_DESCRIPTION IN RNT_LEADS.DESCRIPTION%TYPE
                      , X_CHECKSUM IN RNT_LEADS_V.CHECKSUM%TYPE)
  is
     l_checksum          RNT_LEADS_V.CHECKSUM%TYPE;
  begin
     lock_row(X_LEAD_ID);

      -- validate checksum
      l_checksum := get_checksum(X_LEAD_ID);
      if X_CHECKSUM != l_checksum then
         RAISE_APPLICATION_ERROR(-20002, 'Record has been changed another user.');
      end if;

     update RNT_LEADS
     set PEOPLE_BUSINESS_ID = X_PEOPLE_BUSINESS_ID
     , LEAD_DATE = X_LEAD_DATE
     , LEAD_STATUS = X_LEAD_STATUS
     , LEAD_TYPE = X_LEAD_TYPE
     , REF_PROP_ID = X_REF_PROP_ID
     , FOLLOW_UP = X_FOLLOW_UP
     , UCODE = X_UCODE
     , CITY = X_CITY
     , MIN_PRICE = X_MIN_PRICE
     , MAX_PRICE = X_MAX_PRICE
     , LTV_TARGET = X_LTV_TARGET
     , LTV_QUALIFIED_YN = X_LTV_QUALIFIED_YN
     , DESCRIPTION = X_DESCRIPTION
     where LEAD_ID = X_LEAD_ID;

  end update_row;

  function  insert_row( X_PEOPLE_BUSINESS_ID IN RNT_LEADS.PEOPLE_BUSINESS_ID%TYPE
                     , X_LEAD_DATE IN RNT_LEADS.LEAD_DATE%TYPE
                     , X_LEAD_STATUS IN RNT_LEADS.LEAD_STATUS%TYPE
                     , X_LEAD_TYPE IN RNT_LEADS.LEAD_TYPE%TYPE
                     , X_REF_PROP_ID IN RNT_LEADS.REF_PROP_ID%TYPE
                     , X_FOLLOW_UP IN RNT_LEADS.FOLLOW_UP%TYPE
                     , X_UCODE IN RNT_LEADS.UCODE%TYPE
                     , X_CITY IN RNT_LEADS.CITY%TYPE
                     , X_MIN_PRICE IN RNT_LEADS.MIN_PRICE%TYPE
                     , X_MAX_PRICE IN RNT_LEADS.MAX_PRICE%TYPE
                     , X_LTV_TARGET IN RNT_LEADS.LTV_TARGET%TYPE
                     , X_LTV_QUALIFIED_YN IN RNT_LEADS.LTV_QUALIFIED_YN%TYPE
                     , X_DESCRIPTION IN RNT_LEADS.DESCRIPTION%TYPE)
              return RNT_LEADS.LEAD_ID%TYPE
  is
     x          number;
  begin

     insert into RNT_LEADS
     ( LEAD_ID
     , PEOPLE_BUSINESS_ID
     , LEAD_DATE
     , LEAD_STATUS
     , LEAD_TYPE
     , REF_PROP_ID
     , FOLLOW_UP
     , UCODE
     , CITY
     , MIN_PRICE
     , MAX_PRICE
     , LTV_TARGET
     , LTV_QUALIFIED_YN
     , DESCRIPTION)
     values
     ( RNT_LEADS_SEQ.NEXTVAL
     , X_PEOPLE_BUSINESS_ID
     , X_LEAD_DATE
     , X_LEAD_STATUS
     , X_LEAD_TYPE
     , X_REF_PROP_ID
     , X_FOLLOW_UP
     , X_UCODE
     , X_CITY
     , X_MIN_PRICE
     , X_MAX_PRICE
     , X_LTV_TARGET
     , X_LTV_QUALIFIED_YN
     , X_DESCRIPTION)
     returning LEAD_ID into x;

     return x;
  end insert_row;

  procedure delete_row( X_LEAD_ID IN RNT_LEADS.LEAD_ID%TYPE) is
  begin
    delete from RNT_LEADS
    where LEAD_ID = X_LEAD_ID;

  end delete_row;

end RNT_LEADS_PKG;
/
show errors package RNT_LEADS_PKG
show errors package body RNT_LEADS_PKG
