CREATE OR REPLACE PACKAGE RNT_PROPERTY_VALUE_PKG AS
/******************************************************************************
   NAME:       RNT_PROPERTY_VALUE_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        29.03.2009                   1. Created this package.
******************************************************************************/

function get_checksum(p_value_id    RNT_PROPERTY_VALUE.VALUE_ID%TYPE) return VARCHAR2;

procedure lock_row(X_VALUE_ID RNT_PROPERTY_VALUE.VALUE_ID%TYPE);

procedure update_row(X_VALUE_ID        RNT_PROPERTY_VALUE.VALUE_ID%TYPE,
                     X_PROPERTY_ID     RNT_PROPERTY_VALUE.PROPERTY_ID%TYPE,
                     X_VALUE_DATE      RNT_PROPERTY_VALUE.VALUE_DATE%TYPE,
                     X_VALUE_METHOD    RNT_PROPERTY_VALUE.VALUE_METHOD%TYPE,
                     X_VALUE           RNT_PROPERTY_VALUE.VALUE%TYPE,
                     X_CAP_RATE        RNT_PROPERTY_VALUE.CAP_RATE%TYPE,
                     X_CHECKSUM        VARCHAR2);

function insert_row(X_PROPERTY_ID     RNT_PROPERTY_VALUE.PROPERTY_ID%TYPE,
                    X_VALUE_DATE      RNT_PROPERTY_VALUE.VALUE_DATE%TYPE,
                    X_VALUE_METHOD    RNT_PROPERTY_VALUE.VALUE_METHOD%TYPE,
                    X_VALUE           RNT_PROPERTY_VALUE.VALUE%TYPE,
                    X_CAP_RATE        RNT_PROPERTY_VALUE.CAP_RATE%TYPE
                    ) return RNT_PROPERTY_VALUE.VALUE_ID%TYPE;

procedure delete_row(X_VALUE_ID    RNT_PROPERTY_VALUE.VALUE_ID%TYPE);

END RNT_PROPERTY_VALUE_PKG;
/


CREATE OR REPLACE PACKAGE BODY RNT_PROPERTY_VALUE_PKG AS
/******************************************************************************
   NAME:       RNT_PROPERTY_VALUE_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        29.03.2009                   1. Created this package body.
******************************************************************************/

function get_checksum(p_value_id    RNT_PROPERTY_VALUE.VALUE_ID%TYPE)
return   VARCHAR2
is
begin
    for x in (select VALUE_ID, PROPERTY_ID,
                     VALUE_DATE, VALUE_METHOD,
                     VALUE, CAP_RATE
              from   RNT_PROPERTY_VALUE
              where  VALUE_ID = p_value_id)
    loop
        RNT_SYS_CHECKSUM_REC_PKG.INIT;
        RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.VALUE_ID);
        RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.PROPERTY_ID);
        RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.VALUE_DATE);
        RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.VALUE_METHOD);
        RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.VALUE);
        RNT_SYS_CHECKSUM_REC_PKG.APPEND(x.CAP_RATE);
        --
        return RNT_SYS_CHECKSUM_REC_PKG.GET_CHECKSUM;
    end loop;
    --
    raise NO_DATA_FOUND;
end get_checksum;


procedure lock_row(X_VALUE_ID    RNT_PROPERTY_VALUE.VALUE_ID%TYPE)
is
  cursor c
  is     select VALUE_ID,   PROPERTY_ID,
                VALUE_DATE, VALUE_METHOD,
                VALUE,      CAP_RATE
         from   RNT_PROPERTY_VALUE
         where  VALUE_ID = X_VALUE_ID
         for update of VALUE_ID nowait;
begin
    open c;
    close c;
exception
    when OTHERS then
       if SQLCODE = -54 then
           RAISE_APPLICATION_ERROR(-20001, 'Cannot changed record. Record is locked.');
       end if;
end lock_row;


function check_allowed_access(X_PROPERTY_ID RNT_PROPERTIES.PROPERTY_ID%TYPE)
return   boolean
is
  x NUMBER;
begin
    select 1
    into   x
    from   DUAL
    where  exists(select 1
                  from   RNT_BUSINESS_UNITS_V bu,
                         RNT_PROPERTIES p
                  where  p.PROPERTY_ID  = X_PROPERTY_ID
                  and    bu.BUSINESS_ID = p.BUSINESS_ID);
    --
    return TRUE;
exception
    when NO_DATA_FOUND then
         return FALSE;
end check_allowed_access;


procedure update_row(X_VALUE_ID        RNT_PROPERTY_VALUE.VALUE_ID%TYPE,
                     X_PROPERTY_ID     RNT_PROPERTY_VALUE.PROPERTY_ID%TYPE,
                     X_VALUE_DATE      RNT_PROPERTY_VALUE.VALUE_DATE%TYPE,
                     X_VALUE_METHOD    RNT_PROPERTY_VALUE.VALUE_METHOD%TYPE,
                     X_VALUE           RNT_PROPERTY_VALUE.VALUE%TYPE,
                     X_CAP_RATE        RNT_PROPERTY_VALUE.CAP_RATE%TYPE,
                     X_CHECKSUM        VARCHAR2)
is
  l_checksum varchar2(32);
begin
    lock_row(X_VALUE_ID);
 
    -- validate checksum
    l_checksum := get_checksum(X_VALUE_ID);
    if X_CHECKSUM != l_checksum then
        RAISE_APPLICATION_ERROR(-20002, 'Record was changed another user.');
    end if;

    if not check_allowed_access(X_PROPERTY_ID) then
        RAISE_APPLICATION_ERROR(-20010, 'Security error. You cannot update this unit.');
    end if;
    
    update RNT_PROPERTY_VALUE
    set    PROPERTY_ID  = X_PROPERTY_ID,
           VALUE_DATE   = X_VALUE_DATE,
           VALUE_METHOD = X_VALUE_METHOD,
           VALUE        = X_VALUE,
           CAP_RATE     = X_CAP_RATE
    where  VALUE_ID     = X_VALUE_ID;
end update_row;


function insert_row(X_PROPERTY_ID     RNT_PROPERTY_VALUE.PROPERTY_ID%TYPE,
                    X_VALUE_DATE      RNT_PROPERTY_VALUE.VALUE_DATE%TYPE,
                    X_VALUE_METHOD    RNT_PROPERTY_VALUE.VALUE_METHOD%TYPE,
                    X_VALUE           RNT_PROPERTY_VALUE.VALUE%TYPE,
                    X_CAP_RATE        RNT_PROPERTY_VALUE.CAP_RATE%TYPE
                    ) return RNT_PROPERTY_VALUE.VALUE_ID%TYPE
is
  x    RNT_PROPERTY_VALUE.VALUE_ID%TYPE := 0;
begin
    if not check_allowed_access(X_PROPERTY_ID) then
        RAISE_APPLICATION_ERROR(-20372, 'Security error. You cannot insert this unit.');
    end if;
    --
    insert into RNT_PROPERTY_VALUE
           (VALUE_ID, PROPERTY_ID, VALUE_DATE,
            VALUE_METHOD, VALUE, CAP_RATE)
    values (RNT_PROPERTY_VALUE_SEQ.NEXTVAL, X_PROPERTY_ID, X_VALUE_DATE,
            X_VALUE_METHOD, X_VALUE, X_CAP_RATE)
    returning VALUE_ID into x;
    --
    return x;
end insert_row;


procedure delete_row(X_VALUE_ID    RNT_PROPERTY_VALUE.VALUE_ID%TYPE)
is
begin
    delete from RNT_PROPERTY_VALUE
    where  VALUE_ID = X_VALUE_ID;
end;


END RNT_PROPERTY_VALUE_PKG;
/

