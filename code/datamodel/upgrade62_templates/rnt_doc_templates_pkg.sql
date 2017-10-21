create or replace package RNT_DOC_TEMPLATES_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007, 2010        All rights reserved worldwide
    Name:      RNT_DOC_TEMPLATES_PKG
    Purpose:   API's for RNT_DOC_TEMPLATES table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        24-JAN-10   Auto Generated   Initial Version
*******************************************************************************/
  function get_checksum( X_TEMPLATE_ID IN RNT_DOC_TEMPLATES.TEMPLATE_ID%TYPE)
            return RNT_DOC_TEMPLATES_V.CHECKSUM%TYPE;

  procedure update_row( X_TEMPLATE_ID    IN RNT_DOC_TEMPLATES.TEMPLATE_ID%TYPE
                      , X_NAME           IN RNT_DOC_TEMPLATES.NAME%TYPE
                      , X_BUSINESS_ID    IN RNT_DOC_TEMPLATES.BUSINESS_ID%TYPE
                      , X_CONTENT        IN RNT_DOC_TEMPLATES.CONTENT%TYPE
                      , X_CHECKSUM       IN RNT_DOC_TEMPLATES_V.CHECKSUM%TYPE);

  function insert_row( X_NAME            IN RNT_DOC_TEMPLATES.NAME%TYPE
                     , X_BUSINESS_ID     IN RNT_DOC_TEMPLATES.BUSINESS_ID%TYPE
                     , X_CONTENT         IN RNT_DOC_TEMPLATES.CONTENT%TYPE)
              return RNT_DOC_TEMPLATES.TEMPLATE_ID%TYPE;

  procedure delete_row( X_TEMPLATE_ID    IN RNT_DOC_TEMPLATES.TEMPLATE_ID%TYPE);

end RNT_DOC_TEMPLATES_PKG;
/
create or replace package body RNT_DOC_TEMPLATES_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007, 2010        All rights reserved worldwide
    Name:      RNT_DOC_TEMPLATES_PKG
    Purpose:   API's for RNT_DOC_TEMPLATES table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        24-JAN-10   Auto Generated   Initial Version

********************************************************************************/
-------------------------------------------------
--  Private Procedures and Functions
-------------------------------------------------


  procedure lock_row( X_TEMPLATE_ID IN RNT_DOC_TEMPLATES.TEMPLATE_ID%TYPE) is
     cursor c is
     select * from RNT_DOC_TEMPLATES
     where TEMPLATE_ID = X_TEMPLATE_ID
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
  function get_checksum( X_TEMPLATE_ID IN RNT_DOC_TEMPLATES.TEMPLATE_ID%TYPE)
            return RNT_DOC_TEMPLATES_V.CHECKSUM%TYPE is

    v_return_value               RNT_DOC_TEMPLATES_V.CHECKSUM%TYPE;
  begin
    select CHECKSUM
    into v_return_value
    from RNT_DOC_TEMPLATES_V
    where TEMPLATE_ID = X_TEMPLATE_ID;
    return v_return_value;
  end get_checksum;

  procedure update_row( X_TEMPLATE_ID      IN RNT_DOC_TEMPLATES.TEMPLATE_ID%TYPE
                      , X_NAME             IN RNT_DOC_TEMPLATES.NAME%TYPE
                      , X_BUSINESS_ID      IN RNT_DOC_TEMPLATES.BUSINESS_ID%TYPE
                      , X_CONTENT          IN RNT_DOC_TEMPLATES.CONTENT%TYPE
                      , X_CHECKSUM         IN RNT_DOC_TEMPLATES_V.CHECKSUM%TYPE)
  is
     l_checksum          RNT_DOC_TEMPLATES_V.CHECKSUM%TYPE;
  begin
     lock_row(X_TEMPLATE_ID);

      -- validate checksum
      l_checksum := get_checksum(X_TEMPLATE_ID);
      if X_CHECKSUM != l_checksum then
         RAISE_APPLICATION_ERROR(-20002, 'Record has been changed another user.');
      end if;

     update RNT_DOC_TEMPLATES
     set NAME = X_NAME
     , BUSINESS_ID = X_BUSINESS_ID
     , CONTENT = X_CONTENT
     where TEMPLATE_ID = X_TEMPLATE_ID;

  end update_row;

  function insert_row( X_NAME           IN RNT_DOC_TEMPLATES.NAME%TYPE
                     , X_BUSINESS_ID    IN RNT_DOC_TEMPLATES.BUSINESS_ID%TYPE
                     , X_CONTENT        IN RNT_DOC_TEMPLATES.CONTENT%TYPE)
              return RNT_DOC_TEMPLATES.TEMPLATE_ID%TYPE
  is
     x          number;
  begin

     insert into RNT_DOC_TEMPLATES
     ( TEMPLATE_ID
     , NAME
     , BUSINESS_ID
     , CONTENT)
     values
     ( RNT_DOC_TEMPLATES_SEQ.NEXTVAL
     , X_NAME
     , X_BUSINESS_ID
     , X_CONTENT)
     returning TEMPLATE_ID into x;

     return x;
  end insert_row;

  procedure delete_row( X_TEMPLATE_ID IN RNT_DOC_TEMPLATES.TEMPLATE_ID%TYPE) is

  begin
    delete from RNT_DOC_TEMPLATES
    where TEMPLATE_ID = X_TEMPLATE_ID;

  end delete_row;

end RNT_DOC_TEMPLATES_PKG;
/

show errors package RNT_DOC_TEMPLATES_PKG
show errors package body RNT_DOC_TEMPLATES_PKG