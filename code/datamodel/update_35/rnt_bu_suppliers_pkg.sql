CREATE OR REPLACE package        RNT_BU_SUPPLIERS_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007        All rights reserved worldwide
    Name:      RNT_BU_SUPPLIERS_PKG
    Purpose:   API's for RNT_BU_SUPPLIERS table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        01-DEC-07   Auto Generated   Initial Version
*******************************************************************************/
  function get_checksum( X_BU_SUPPLIER_ID IN RNT_BU_SUPPLIERS.BU_SUPPLIER_ID%TYPE)
            return RNT_BU_SUPPLIERS_V.CHECKSUM%TYPE;

  procedure update_row( X_BU_SUPPLIER_ID IN RNT_BU_SUPPLIERS.BU_SUPPLIER_ID%TYPE
                      , X_BUSINESS_ID IN RNT_BU_SUPPLIERS.BUSINESS_ID%TYPE
                      , X_SUPPLIER_ID IN RNT_BU_SUPPLIERS.SUPPLIER_ID%TYPE
                      , X_TAX_IDENTIFIER IN RNT_BU_SUPPLIERS.TAX_IDENTIFIER%TYPE
                      , X_NOTES IN RNT_BU_SUPPLIERS.NOTES%TYPE
                      , X_CHECKSUM IN RNT_BU_SUPPLIERS_V.CHECKSUM%TYPE);

  function insert_row( X_BUSINESS_ID IN RNT_BU_SUPPLIERS.BUSINESS_ID%TYPE
                     , X_SUPPLIER_ID IN RNT_BU_SUPPLIERS.SUPPLIER_ID%TYPE
                     , X_TAX_IDENTIFIER IN RNT_BU_SUPPLIERS.TAX_IDENTIFIER%TYPE
                     , X_NOTES IN RNT_BU_SUPPLIERS.NOTES%TYPE)
              return RNT_BU_SUPPLIERS.BU_SUPPLIER_ID%TYPE;

  procedure delete_row( X_BU_SUPPLIER_ID IN RNT_BU_SUPPLIERS.BU_SUPPLIER_ID%TYPE);

end RNT_BU_SUPPLIERS_PKG;
/

SHOW ERRORS;

CREATE OR REPLACE package body        RNT_BU_SUPPLIERS_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007        All rights reserved worldwide
    Name:      RNT_BU_SUPPLIERS_PKG
    Purpose:   API's for RNT_BU_SUPPLIERS table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        01-DEC-07   Auto Generated   Initial Version

********************************************************************************/
-------------------------------------------------
--  Private Procedures and Functions
-------------------------------------------------
  function check_unique( X_BU_SUPPLIER_ID IN RNT_BU_SUPPLIERS.BU_SUPPLIER_ID%TYPE
                       , X_BUSINESS_ID IN RNT_BU_SUPPLIERS.BUSINESS_ID%TYPE
                       , X_SUPPLIER_ID IN RNT_BU_SUPPLIERS.SUPPLIER_ID%TYPE) return boolean is
        cursor c is
        select BU_SUPPLIER_ID
        from RNT_BU_SUPPLIERS
        where BUSINESS_ID = X_BUSINESS_ID
    and SUPPLIER_ID = X_SUPPLIER_ID;

      begin
         for c_rec in c loop
           if (X_BU_SUPPLIER_ID is null OR c_rec.BU_SUPPLIER_ID != X_BU_SUPPLIER_ID) then
             return false;
           end if;
         end loop;
         return true;
      end check_unique;

  procedure lock_row( X_BU_SUPPLIER_ID IN RNT_BU_SUPPLIERS.BU_SUPPLIER_ID%TYPE) is
     cursor c is
     select * from RNT_BU_SUPPLIERS
     where BU_SUPPLIER_ID = X_BU_SUPPLIER_ID
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
  function get_checksum( X_BU_SUPPLIER_ID IN RNT_BU_SUPPLIERS.BU_SUPPLIER_ID%TYPE)
            return RNT_BU_SUPPLIERS_V.CHECKSUM%TYPE is 

    v_return_value               RNT_BU_SUPPLIERS_V.CHECKSUM%TYPE;
  begin
    select CHECKSUM
    into v_return_value
    from RNT_BU_SUPPLIERS_V
    where BU_SUPPLIER_ID = X_BU_SUPPLIER_ID;
    return v_return_value;
  end get_checksum;

  procedure update_row( X_BU_SUPPLIER_ID IN RNT_BU_SUPPLIERS.BU_SUPPLIER_ID%TYPE
                      , X_BUSINESS_ID IN RNT_BU_SUPPLIERS.BUSINESS_ID%TYPE
                      , X_SUPPLIER_ID IN RNT_BU_SUPPLIERS.SUPPLIER_ID%TYPE
                      , X_TAX_IDENTIFIER IN RNT_BU_SUPPLIERS.TAX_IDENTIFIER%TYPE
                      , X_NOTES IN RNT_BU_SUPPLIERS.NOTES%TYPE
                      , X_CHECKSUM IN RNT_BU_SUPPLIERS_V.CHECKSUM%TYPE)
  is
     l_checksum          RNT_BU_SUPPLIERS_V.CHECKSUM%TYPE;
  begin
     lock_row(X_BU_SUPPLIER_ID);

      -- validate checksum
      l_checksum := get_checksum(X_BU_SUPPLIER_ID);
      if X_CHECKSUM != l_checksum then
         RAISE_APPLICATION_ERROR(-20002, 'Record has been changed another user.');
      end if;
     
         if not check_unique(X_BU_SUPPLIER_ID, X_BUSINESS_ID, X_SUPPLIER_ID) then
             RAISE_APPLICATION_ERROR(-20433, 'Update values must be unique.');
         end if;
     update RNT_BU_SUPPLIERS
     set BUSINESS_ID = X_BUSINESS_ID
     , SUPPLIER_ID = X_SUPPLIER_ID
     , TAX_IDENTIFIER = X_TAX_IDENTIFIER
     , NOTES = X_NOTES
     where BU_SUPPLIER_ID = X_BU_SUPPLIER_ID;

  end update_row;

  function insert_row( X_BUSINESS_ID IN RNT_BU_SUPPLIERS.BUSINESS_ID%TYPE
                     , X_SUPPLIER_ID IN RNT_BU_SUPPLIERS.SUPPLIER_ID%TYPE
                     , X_TAX_IDENTIFIER IN RNT_BU_SUPPLIERS.TAX_IDENTIFIER%TYPE
                     , X_NOTES IN RNT_BU_SUPPLIERS.NOTES%TYPE)
              return RNT_BU_SUPPLIERS.BU_SUPPLIER_ID%TYPE
  is
     x          number;
  begin
if not check_unique(NULL, X_BUSINESS_ID, X_SUPPLIER_ID) then
         RAISE_APPLICATION_ERROR(-20433, 'Insert values must be unique.');
     end if;
  
     insert into RNT_BU_SUPPLIERS
     ( BU_SUPPLIER_ID
     , BUSINESS_ID
     , SUPPLIER_ID
     , TAX_IDENTIFIER
     , NOTES)
     values
     ( RNT_BU_SUPPLIERS_SEQ.NEXTVAL
     , X_BUSINESS_ID
     , X_SUPPLIER_ID
     , X_TAX_IDENTIFIER
     , X_NOTES)
     returning BU_SUPPLIER_ID into x;

     return x;
  end insert_row;

  function check_exists_other(X_BU_SUPPLIER_ID IN RNT_BU_SUPPLIERS.BU_SUPPLIER_ID%TYPE) return boolean
  is
    x NUMBER;
  begin
    select 1
    into x
    from DUAL
    where exists (select 1
                  from RNT_BU_SUPPLIERS
                  where BU_SUPPLIER_ID != X_BU_SUPPLIER_ID
                    and SUPPLIER_ID = (select SUPPLIER_ID from RNT_BU_SUPPLIERS where BU_SUPPLIER_ID = X_BU_SUPPLIER_ID)
                 );
   return TRUE;
  exception
    when NO_DATA_FOUND then
       return FALSE;                      
  end;

  procedure delete_row( X_BU_SUPPLIER_ID IN RNT_BU_SUPPLIERS.BU_SUPPLIER_ID%TYPE) is

  begin
    if not check_exists_other(X_BU_SUPPLIER_ID) then
       RAISE_APPLICATION_ERROR(-20434, 'Can not delete record about supplier business unit. Cause: supplier must have one or more business units.');    
    end if;
    
    delete from RNT_BU_SUPPLIERS
    where BU_SUPPLIER_ID = X_BU_SUPPLIER_ID;

  end delete_row;

end RNT_BU_SUPPLIERS_PKG;
/

SHOW ERRORS;
