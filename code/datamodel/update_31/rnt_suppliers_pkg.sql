CREATE OR REPLACE package RNT_SUPPLIERS_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007        All rights reserved worldwide
    Name:      RNT_SUPPLIERS_PKG
    Purpose:   API's for RNT_SUPPLIERS table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        26-JUN-07   Auto Generated   Initial Version
*******************************************************************************/
  function get_checksum( X_SUPPLIER_ID IN RNT_SUPPLIERS.SUPPLIER_ID%TYPE)
            return RNT_SUPPLIERS_V.CHECKSUM%TYPE;

  procedure update_row( X_SUPPLIER_ID IN RNT_SUPPLIERS.SUPPLIER_ID%TYPE
                      , X_NAME IN RNT_SUPPLIERS.NAME%TYPE
                      , X_PHONE1 IN RNT_SUPPLIERS.PHONE1%TYPE
                      , X_PHONE2 IN RNT_SUPPLIERS.PHONE2%TYPE
                      , X_ADDRESS1 IN RNT_SUPPLIERS.ADDRESS1%TYPE
                      , X_ADDRESS2 IN RNT_SUPPLIERS.ADDRESS2%TYPE
                      , X_CITY IN RNT_SUPPLIERS.CITY%TYPE
                      , X_STATE IN RNT_SUPPLIERS.STATE%TYPE
                      , X_ZIPCODE IN RNT_SUPPLIERS.ZIPCODE%TYPE
                      , X_SSN IN RNT_SUPPLIERS.SSN%TYPE
                      , X_EMAIL_ADDRESS IN RNT_SUPPLIERS.EMAIL_ADDRESS%TYPE
                      , X_COMMENTS IN RNT_SUPPLIERS.COMMENTS%TYPE
                      , X_BUSINESS_ID IN RNT_SUPPLIERS.BUSINESS_ID%TYPE
                      , X_CHECKSUM IN RNT_SUPPLIERS_V.CHECKSUM%TYPE);

  function insert_row( X_NAME IN RNT_SUPPLIERS.NAME%TYPE
                     , X_PHONE1 IN RNT_SUPPLIERS.PHONE1%TYPE
                     , X_PHONE2 IN RNT_SUPPLIERS.PHONE2%TYPE
                     , X_ADDRESS1 IN RNT_SUPPLIERS.ADDRESS1%TYPE
                     , X_ADDRESS2 IN RNT_SUPPLIERS.ADDRESS2%TYPE
                     , X_CITY IN RNT_SUPPLIERS.CITY%TYPE
                     , X_STATE IN RNT_SUPPLIERS.STATE%TYPE
                     , X_ZIPCODE IN RNT_SUPPLIERS.ZIPCODE%TYPE
                     , X_SSN IN RNT_SUPPLIERS.SSN%TYPE
                     , X_EMAIL_ADDRESS IN RNT_SUPPLIERS.EMAIL_ADDRESS%TYPE
                     , X_COMMENTS IN RNT_SUPPLIERS.COMMENTS%TYPE
                     , X_BUSINESS_ID IN RNT_SUPPLIERS.BUSINESS_ID%TYPE)
              return RNT_SUPPLIERS.SUPPLIER_ID%TYPE;

  procedure delete_row( X_SUPPLIER_ID IN RNT_SUPPLIERS.SUPPLIER_ID%TYPE);

end RNT_SUPPLIERS_PKG;
/


CREATE OR REPLACE package body        RNT_SUPPLIERS_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007        All rights reserved worldwide
    Name:      RNT_SUPPLIERS_PKG
    Purpose:   API's for RNT_SUPPLIERS table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        26-JUN-07   Auto Generated   Initial Version

********************************************************************************/
-------------------------------------------------
--  Private Procedures and Functions
-------------------------------------------------
  function check_unique( X_SUPPLIER_ID IN RNT_SUPPLIERS.SUPPLIER_ID%TYPE
                       , X_NAME IN RNT_SUPPLIERS.NAME%TYPE
                       , X_BUSINESS_ID IN RNT_SUPPLIERS.BUSINESS_ID%TYPE) return boolean is
        cursor c is
        select SUPPLIER_ID
        from RNT_SUPPLIERS
        where NAME = X_NAME
          and BUSINESS_ID = X_BUSINESS_ID;

      begin
         for c_rec in c loop
           if (X_SUPPLIER_ID is null OR c_rec.SUPPLIER_ID != X_SUPPLIER_ID) then
             return false;
           end if;
         end loop;
         return true;
      end check_unique;

  procedure lock_row( X_SUPPLIER_ID IN RNT_SUPPLIERS.SUPPLIER_ID%TYPE) is
     cursor c is
     select * from RNT_SUPPLIERS
     where SUPPLIER_ID = X_SUPPLIER_ID
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
  function get_checksum( X_SUPPLIER_ID IN RNT_SUPPLIERS.SUPPLIER_ID%TYPE)
            return RNT_SUPPLIERS_V.CHECKSUM%TYPE is 

    v_return_value               RNT_SUPPLIERS_V.CHECKSUM%TYPE;
  begin
    select CHECKSUM
    into v_return_value
    from RNT_SUPPLIERS_V
    where SUPPLIER_ID = X_SUPPLIER_ID;
    return v_return_value;
  end get_checksum;

  procedure update_row( X_SUPPLIER_ID IN RNT_SUPPLIERS.SUPPLIER_ID%TYPE
                      , X_NAME IN RNT_SUPPLIERS.NAME%TYPE
                      , X_PHONE1 IN RNT_SUPPLIERS.PHONE1%TYPE
                      , X_PHONE2 IN RNT_SUPPLIERS.PHONE2%TYPE
                      , X_ADDRESS1 IN RNT_SUPPLIERS.ADDRESS1%TYPE
                      , X_ADDRESS2 IN RNT_SUPPLIERS.ADDRESS2%TYPE
                      , X_CITY IN RNT_SUPPLIERS.CITY%TYPE
                      , X_STATE IN RNT_SUPPLIERS.STATE%TYPE
                      , X_ZIPCODE IN RNT_SUPPLIERS.ZIPCODE%TYPE
                      , X_SSN IN RNT_SUPPLIERS.SSN%TYPE
                      , X_EMAIL_ADDRESS IN RNT_SUPPLIERS.EMAIL_ADDRESS%TYPE
                      , X_COMMENTS IN RNT_SUPPLIERS.COMMENTS%TYPE
                      , X_BUSINESS_ID IN RNT_SUPPLIERS.BUSINESS_ID%TYPE
                      , X_CHECKSUM IN RNT_SUPPLIERS_V.CHECKSUM%TYPE)
  is
     l_checksum          RNT_SUPPLIERS_V.CHECKSUM%TYPE;
  begin
     lock_row(X_SUPPLIER_ID);

      -- validate checksum
      l_checksum := get_checksum(X_SUPPLIER_ID);
      if X_CHECKSUM != l_checksum then
         RAISE_APPLICATION_ERROR(-20002, 'Record has been changed another user.');
      end if;
     
         if not check_unique(X_SUPPLIER_ID, X_NAME, X_BUSINESS_ID) then
             RAISE_APPLICATION_ERROR(-20430, 'Update values must be unique.');
         end if;
     update RNT_SUPPLIERS
     set NAME = X_NAME
     , PHONE1 = X_PHONE1
     , PHONE2 = X_PHONE2
     , ADDRESS1 = X_ADDRESS1
     , ADDRESS2 = X_ADDRESS2
     , CITY = X_CITY
     , STATE = X_STATE
     , ZIPCODE = X_ZIPCODE
     , SSN = X_SSN
     , EMAIL_ADDRESS = X_EMAIL_ADDRESS
     , COMMENTS = X_COMMENTS
     , BUSINESS_ID = X_BUSINESS_ID
     where SUPPLIER_ID = X_SUPPLIER_ID;

  end update_row;

  function insert_row( X_NAME IN RNT_SUPPLIERS.NAME%TYPE
                     , X_PHONE1 IN RNT_SUPPLIERS.PHONE1%TYPE
                     , X_PHONE2 IN RNT_SUPPLIERS.PHONE2%TYPE
                     , X_ADDRESS1 IN RNT_SUPPLIERS.ADDRESS1%TYPE
                     , X_ADDRESS2 IN RNT_SUPPLIERS.ADDRESS2%TYPE
                     , X_CITY IN RNT_SUPPLIERS.CITY%TYPE
                     , X_STATE IN RNT_SUPPLIERS.STATE%TYPE
                     , X_ZIPCODE IN RNT_SUPPLIERS.ZIPCODE%TYPE
                     , X_SSN IN RNT_SUPPLIERS.SSN%TYPE
                     , X_EMAIL_ADDRESS IN RNT_SUPPLIERS.EMAIL_ADDRESS%TYPE
                     , X_COMMENTS IN RNT_SUPPLIERS.COMMENTS%TYPE
                     , X_BUSINESS_ID IN RNT_SUPPLIERS.BUSINESS_ID%TYPE)
              return RNT_SUPPLIERS.SUPPLIER_ID%TYPE
  is
     x          number;
  begin
if not check_unique(NULL, X_NAME, X_BUSINESS_ID) then
         RAISE_APPLICATION_ERROR(-20431, 'Insert values must be unique.');
     end if;
  
     insert into RNT_SUPPLIERS
     ( SUPPLIER_ID
     , NAME
     , PHONE1
     , PHONE2
     , ADDRESS1
     , ADDRESS2
     , CITY
     , STATE
     , ZIPCODE
     , SSN
     , EMAIL_ADDRESS
     , COMMENTS
     , BUSINESS_ID)
     values
     ( RNT_SUPPLIERS_SEQ.NEXTVAL
     , X_NAME
     , X_PHONE1
     , X_PHONE2
     , X_ADDRESS1
     , X_ADDRESS2
     , X_CITY
     , X_STATE
     , X_ZIPCODE
     , X_SSN
     , X_EMAIL_ADDRESS
     , X_COMMENTS
     , X_BUSINESS_ID)
     returning SUPPLIER_ID into x;

     return x;
  end insert_row;

  procedure delete_row( X_SUPPLIER_ID IN RNT_SUPPLIERS.SUPPLIER_ID%TYPE) is

  begin
    delete from RNT_SUPPLIERS
    where SUPPLIER_ID = X_SUPPLIER_ID;

  end delete_row;

end RNT_SUPPLIERS_PKG;
/


