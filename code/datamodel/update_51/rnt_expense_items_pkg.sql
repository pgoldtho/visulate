CREATE OR REPLACE package        RNT_EXPENSE_ITEMS_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007        All rights reserved worldwide
    Name:      RNT_EXPENSE_ITEMS_PKG
    Purpose:   API's for RNT_EXPENSE_ITEMS table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        31-MAY-08   Auto Generated   Initial Version
*******************************************************************************/
  function get_checksum( X_EXPENSE_ITEM_ID IN RNT_EXPENSE_ITEMS.EXPENSE_ITEM_ID%TYPE)
            return RNT_EXPENSE_ITEMS_V.CHECKSUM%TYPE;

  procedure update_row( X_EXPENSE_ID IN RNT_EXPENSE_ITEMS.EXPENSE_ID%TYPE
                      , X_SUPPLIER_ID IN RNT_EXPENSE_ITEMS.SUPPLIER_ID%TYPE
                      , X_ITEM_NAME IN RNT_EXPENSE_ITEMS.ITEM_NAME%TYPE
                      , X_ITEM_COST IN RNT_EXPENSE_ITEMS.ITEM_COST%TYPE
                      , X_ESTIMATE IN RNT_EXPENSE_ITEMS.ESTIMATE%TYPE
                      , X_ACTUAL IN RNT_EXPENSE_ITEMS.ACTUAL%TYPE
                      , X_EXPENSE_ITEM_ID IN RNT_EXPENSE_ITEMS.EXPENSE_ITEM_ID%TYPE
                      , X_CHECKSUM IN RNT_EXPENSE_ITEMS_V.CHECKSUM%TYPE);

  function insert_row( X_SUPPLIER_ID IN RNT_EXPENSE_ITEMS.SUPPLIER_ID%TYPE
                     , X_ITEM_NAME IN RNT_EXPENSE_ITEMS.ITEM_NAME%TYPE
                     , X_ITEM_COST IN RNT_EXPENSE_ITEMS.ITEM_COST%TYPE
                     , X_ESTIMATE IN RNT_EXPENSE_ITEMS.ESTIMATE%TYPE
                     , X_ACTUAL IN RNT_EXPENSE_ITEMS.ACTUAL%TYPE
                     , X_EXPENSE_ID IN RNT_EXPENSE_ITEMS.EXPENSE_ID%TYPE
                     )
              return RNT_EXPENSE_ITEMS.EXPENSE_ITEM_ID%TYPE;

  procedure delete_row( X_EXPENSE_ITEM_ID IN RNT_EXPENSE_ITEMS.EXPENSE_ITEM_ID%TYPE);

end RNT_EXPENSE_ITEMS_PKG;
/

SHOW ERRORS;

CREATE OR REPLACE package body        RNT_EXPENSE_ITEMS_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007        All rights reserved worldwide
    Name:      RNT_EXPENSE_ITEMS_PKG
    Purpose:   API's for RNT_EXPENSE_ITEMS table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        31-MAY-08   Auto Generated   Initial Version

********************************************************************************/
-------------------------------------------------
--  Private Procedures and Functions
-------------------------------------------------


  procedure lock_row( X_EXPENSE_ITEM_ID IN RNT_EXPENSE_ITEMS.EXPENSE_ITEM_ID%TYPE) is
     cursor c is
     select * from RNT_EXPENSE_ITEMS
     where EXPENSE_ITEM_ID = X_EXPENSE_ITEM_ID
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

/*
function check_unique(X_EXPENSE_ITEM_ID  RNT_EXPENSE_ITEMS.EXPENSE_ITEM_ID%TYPE,
                      X_EXPENSE_ID  RNT_EXPENSE_ITEMS.EXPENSE_ID%TYPE,
                      X_SUPPLIER_ID  RNT_EXPENSE_ITEMS.SUPPLIER_ID%TYPE
                      ) return boolean
is
  x NUMBER;
begin
   select 1 
   into x
   from DUAL
   where exists (
                   select 1
                   from RNT_EXPENSE_ITEMS
                   where (EXPENSE_ITEM_ID != X_EXPENSE_ITEM_ID or X_EXPENSE_ITEM_ID is null) 
                     and EXPENSE_ID = X_EXPENSE_ID
                     and SUPPLIER_ID = X_SUPPLIER_ID
                 );
  return false;
exception
  when NO_DATA_FOUND then
     return true;                        
end;
*/
-------------------------------------------------
--  Public Procedures and Functions
-------------------------------------------------
  function get_checksum( X_EXPENSE_ITEM_ID IN RNT_EXPENSE_ITEMS.EXPENSE_ITEM_ID%TYPE)
            return RNT_EXPENSE_ITEMS_V.CHECKSUM%TYPE is 

    v_return_value               RNT_EXPENSE_ITEMS_V.CHECKSUM%TYPE;
  begin
    select CHECKSUM
    into v_return_value
    from RNT_EXPENSE_ITEMS_V
    where EXPENSE_ITEM_ID = X_EXPENSE_ITEM_ID;
    return v_return_value;
  end get_checksum;

  procedure update_row( X_EXPENSE_ID IN RNT_EXPENSE_ITEMS.EXPENSE_ID%TYPE
                      , X_SUPPLIER_ID IN RNT_EXPENSE_ITEMS.SUPPLIER_ID%TYPE
                      , X_ITEM_NAME IN RNT_EXPENSE_ITEMS.ITEM_NAME%TYPE
                      , X_ITEM_COST IN RNT_EXPENSE_ITEMS.ITEM_COST%TYPE
                      , X_ESTIMATE IN RNT_EXPENSE_ITEMS.ESTIMATE%TYPE
                      , X_ACTUAL IN RNT_EXPENSE_ITEMS.ACTUAL%TYPE
                      , X_EXPENSE_ITEM_ID IN RNT_EXPENSE_ITEMS.EXPENSE_ITEM_ID%TYPE
                      , X_CHECKSUM IN RNT_EXPENSE_ITEMS_V.CHECKSUM%TYPE)
  is
     l_checksum          RNT_EXPENSE_ITEMS_V.CHECKSUM%TYPE;
  begin
     lock_row(X_EXPENSE_ITEM_ID);

      -- validate checksum
      l_checksum := get_checksum(X_EXPENSE_ITEM_ID);
      if X_CHECKSUM != l_checksum then
         RAISE_APPLICATION_ERROR(-20002, 'Record has been changed another user.');
      end if;
      
  /*    if not check_unique(X_EXPENSE_ITEM_ID, X_EXPENSE_ID, X_SUPPLIER_ID) then
        RAISE_APPLICATION_ERROR(-20620, 'Item Name must be unique for supplier.');                      
      end if;
    */ 
     update RNT_EXPENSE_ITEMS
     set SUPPLIER_ID = X_SUPPLIER_ID
     , ITEM_NAME = X_ITEM_NAME
     , ITEM_COST = X_ITEM_COST
     , ESTIMATE = X_ESTIMATE
     , ACTUAL = X_ACTUAL
     , EXPENSE_ITEM_ID = X_EXPENSE_ITEM_ID
     where EXPENSE_ITEM_ID = X_EXPENSE_ITEM_ID;

  end update_row;
  
  function insert_row( X_SUPPLIER_ID IN RNT_EXPENSE_ITEMS.SUPPLIER_ID%TYPE
                     , X_ITEM_NAME IN RNT_EXPENSE_ITEMS.ITEM_NAME%TYPE
                     , X_ITEM_COST IN RNT_EXPENSE_ITEMS.ITEM_COST%TYPE
                     , X_ESTIMATE IN RNT_EXPENSE_ITEMS.ESTIMATE%TYPE
                     , X_ACTUAL IN RNT_EXPENSE_ITEMS.ACTUAL%TYPE
                     , X_EXPENSE_ID IN RNT_EXPENSE_ITEMS.EXPENSE_ID%TYPE
                     )
              return RNT_EXPENSE_ITEMS.EXPENSE_ITEM_ID%TYPE
  is
     x          number;
  begin
  /*
     if not check_unique(NULL, X_EXPENSE_ID, X_SUPPLIER_ID) then
        RAISE_APPLICATION_ERROR(-20620, 'Item Name must be unique for supplier.');                      
     end if;
    */ 
     insert into RNT_EXPENSE_ITEMS
     ( EXPENSE_ITEM_ID
     , SUPPLIER_ID
     , ITEM_NAME
     , ITEM_COST
     , ESTIMATE
     , ACTUAL
     , EXPENSE_ID)
     values
     ( RNT_EXPENSE_ITEMS_SEQ.NEXTVAL
     , X_SUPPLIER_ID
     , X_ITEM_NAME
     , X_ITEM_COST
     , X_ESTIMATE
     , X_ACTUAL
     , X_EXPENSE_ID)
     returning EXPENSE_ITEM_ID into x;

     return x;
  end insert_row;

  procedure delete_row( X_EXPENSE_ITEM_ID IN RNT_EXPENSE_ITEMS.EXPENSE_ITEM_ID%TYPE) is

  begin
    delete from RNT_EXPENSE_ITEMS
    where EXPENSE_ITEM_ID = X_EXPENSE_ITEM_ID;

  end delete_row;

end RNT_EXPENSE_ITEMS_PKG;
/

SHOW ERRORS;
