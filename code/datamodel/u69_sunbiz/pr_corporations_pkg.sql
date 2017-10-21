create or replace package PR_CORPORATIONS_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007, 2011       All rights reserved worldwide
    Name:      PR_CORPORATIONS_PKG
    Purpose:   API's for PR_CORPORATIONS table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        13-JUN-11   Auto Generated   Initial Version
*******************************************************************************/
  function get_checksum( X_CORP_NUMBER IN PR_CORPORATIONS.CORP_NUMBER%TYPE)
            return PR_CORPORATIONS_V.CHECKSUM%TYPE;

  procedure update_row( X_CORP_NUMBER IN PR_CORPORATIONS.CORP_NUMBER%TYPE
                      , X_NAME IN PR_CORPORATIONS.NAME%TYPE
                      , X_STATUS IN PR_CORPORATIONS.STATUS%TYPE
                      , X_FILING_TYPE IN PR_CORPORATIONS.FILING_TYPE%TYPE
                      , X_FILING_DATE IN PR_CORPORATIONS.FILING_DATE%TYPE
                      , X_FEI_NUMBER IN PR_CORPORATIONS.FEI_NUMBER%TYPE
                      , X_CHECKSUM IN PR_CORPORATIONS_V.CHECKSUM%TYPE);

  procedure  insert_row( X_CORP_NUMBER IN PR_CORPORATIONS.CORP_NUMBER%TYPE
                     , X_NAME IN PR_CORPORATIONS.NAME%TYPE
                     , X_STATUS IN PR_CORPORATIONS.STATUS%TYPE
                     , X_FILING_TYPE IN PR_CORPORATIONS.FILING_TYPE%TYPE
                     , X_FILING_DATE IN PR_CORPORATIONS.FILING_DATE%TYPE
                     , X_FEI_NUMBER IN PR_CORPORATIONS.FEI_NUMBER%TYPE);

  procedure delete_row( X_CORP_NUMBER IN PR_CORPORATIONS.CORP_NUMBER%TYPE);

end PR_CORPORATIONS_PKG;
/
create or replace package body PR_CORPORATIONS_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007, 2011       All rights reserved worldwide
    Name:      PR_CORPORATIONS_PKG
    Purpose:   API's for PR_CORPORATIONS table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        13-JUN-11   Auto Generated   Initial Version

********************************************************************************/
-------------------------------------------------
--  Private Procedures and Functions
-------------------------------------------------


  procedure lock_row( X_CORP_NUMBER IN PR_CORPORATIONS.CORP_NUMBER%TYPE) is
     cursor c is
     select * from PR_CORPORATIONS
     where CORP_NUMBER = X_CORP_NUMBER
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
  function get_checksum( X_CORP_NUMBER IN PR_CORPORATIONS.CORP_NUMBER%TYPE)
            return PR_CORPORATIONS_V.CHECKSUM%TYPE is

    v_return_value               PR_CORPORATIONS_V.CHECKSUM%TYPE;
  begin
    select CHECKSUM
    into v_return_value
    from PR_CORPORATIONS_V
    where CORP_NUMBER = X_CORP_NUMBER;
    return v_return_value;
  end get_checksum;

  procedure update_row( X_CORP_NUMBER IN PR_CORPORATIONS.CORP_NUMBER%TYPE
                      , X_NAME IN PR_CORPORATIONS.NAME%TYPE
                      , X_STATUS IN PR_CORPORATIONS.STATUS%TYPE
                      , X_FILING_TYPE IN PR_CORPORATIONS.FILING_TYPE%TYPE
                      , X_FILING_DATE IN PR_CORPORATIONS.FILING_DATE%TYPE
                      , X_FEI_NUMBER IN PR_CORPORATIONS.FEI_NUMBER%TYPE
                      , X_CHECKSUM IN PR_CORPORATIONS_V.CHECKSUM%TYPE)
  is
     l_checksum          PR_CORPORATIONS_V.CHECKSUM%TYPE;
  begin
     lock_row(X_CORP_NUMBER);

      -- validate checksum
      l_checksum := get_checksum(X_CORP_NUMBER);
      if X_CHECKSUM != l_checksum then
         RAISE_APPLICATION_ERROR(-20002, 'Record has been changed another user.');
      end if;

     update PR_CORPORATIONS
     set NAME = X_NAME
     , STATUS = X_STATUS
     , FILING_TYPE = X_FILING_TYPE
     , FILING_DATE = X_FILING_DATE
     , FEI_NUMBER = X_FEI_NUMBER
     where CORP_NUMBER = X_CORP_NUMBER;

  end update_row;

  procedure  insert_row( X_CORP_NUMBER IN PR_CORPORATIONS.CORP_NUMBER%TYPE
                     , X_NAME IN PR_CORPORATIONS.NAME%TYPE
                     , X_STATUS IN PR_CORPORATIONS.STATUS%TYPE
                     , X_FILING_TYPE IN PR_CORPORATIONS.FILING_TYPE%TYPE
                     , X_FILING_DATE IN PR_CORPORATIONS.FILING_DATE%TYPE
                     , X_FEI_NUMBER IN PR_CORPORATIONS.FEI_NUMBER%TYPE)
  is
     x          number;
  begin

     insert into PR_CORPORATIONS
     ( CORP_NUMBER
     , NAME
     , STATUS
     , FILING_TYPE
     , FILING_DATE
     , FEI_NUMBER)
     values
     ( X_CORP_NUMBER
     , X_NAME
     , X_STATUS
     , X_FILING_TYPE
     , X_FILING_DATE
     , X_FEI_NUMBER);

  end insert_row;

  procedure delete_row( X_CORP_NUMBER IN PR_CORPORATIONS.CORP_NUMBER%TYPE) is

  begin
    delete from PR_CORPORATIONS
    where CORP_NUMBER = X_CORP_NUMBER;

  end delete_row;

end PR_CORPORATIONS_PKG;
/

show errors package PR_CORPORATIONS_PKG
show errors package body PR_CORPORATIONS_PKG