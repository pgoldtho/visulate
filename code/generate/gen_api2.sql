set serveroutput off
set lines 32767
set define ^
set serveroutput on format wrapped

declare

cursor cur_primary_key(cv_table_name in dba_constraints.table_name%type
                     , c_owner in dba_objects.owner%type)
  -- List the primary key
  is select uc.constraint_name
     from dba_constraints uc
     where uc.table_name = cv_table_name
     and uc.owner = c_owner
     and uc.constraint_type = 'P'
     order by uc.constraint_name;
--
cursor cur_unique_keys(cv_table_name in dba_constraints.table_name%type
                     , c_owner in dba_objects.owner%type)
  -- List the unique key constraints
  is select uc.constraint_name
     from dba_constraints uc
     where uc.table_name = cv_table_name
     and uc.constraint_type = 'U'
     and uc.owner = c_owner
     order by uc.constraint_name;
--

--
cursor cur_list_cons_columns(cv_cons_name in dba_cons_columns.constraint_name%type
                           , c_owner in dba_objects.owner%type)
  -- list the columns for a given constraint
  is select cc.column_name
     from dba_cons_columns cc
     where cc.constraint_name = cv_cons_name
     and cc.owner = c_owner
     order by cc.position;          



  cursor cur_columns(c_name dba_tab_columns.table_name%type
                   , c_owner dba_tab_columns.owner%type)
  is select col.column_name
     ,      col.data_type
     ,      col.data_length
     ,      nvl(to_char(col.data_precision), '<br>') data_precision
     ,      nvl(decode(col.nullable, 'N', 'Yes'), '<br>')  nullable
     from dba_tab_columns col
     where col.table_name = c_name
     and   col.owner = c_owner
     order by col.column_id;

  v_header_start  varchar2(2000) := '
/*********************************************************************';

  v_header_end  varchar2(2000) := '
*********************************************************************/';

  v_copyright     varchar2(2000) := 
'  Copyright (c) Visulate 2007, 2013       All rights reserved worldwide';


  type  v_column_rec is record
        ( col_name       dba_tab_columns.column_name%type
        , arg_name       dba_tab_columns.column_name%type);

  type v_col_tab     is  table of v_column_rec index by pls_integer;

  v_tab_columns             v_col_tab;
  v_pk_columns              v_col_tab;
  v_unk_columns             v_col_tab;

  v_view_text               varchar2(32767);
  v_spec_text               varchar2(32767);
  v_body_text               varchar2(32767);

  v_select                  varchar2(4000);
  v_where                   varchar2(4000);
  v_order_by                varchar2(512);
  v_if                      varchar2(4000);

  v_checksum_api            varchar2(4000);
  v_update_api              varchar2(4000);
  v_insert_api              varchar2(4000);
  v_delete_api              varchar2(4000);
  v_api_columns             varchar2(4000);
  v_checksum_call           varchar2(4000);

  v_update_code             varchar2(4000);
  v_checksum_code           varchar2(4000);
  v_insert_code             varchar2(4000);
  v_delete_code             varchar2(4000);
  v_lock_code               varchar2(4000);
  v_check_unique_code       varchar2(4000);



  v_pk_column               varchar2(30);


  c_name                    varchar2(30);
  c_owner                   varchar2(30);
  v_first                   boolean;
  v_first2                  boolean;
  n                         pls_integer;

  v_insert_end              varchar2(200);


begin

  c_name  := upper('^1');
  c_owner := upper('^2');
  n := 0;
  for key_rec in cur_primary_key(c_name, c_owner) loop
     for key_col in cur_list_cons_columns(key_rec.constraint_name, c_owner) loop
        n := n + 1;
        v_pk_columns(n).col_name := key_col.column_name;
        v_pk_columns(n).arg_name := 'X_'||key_col.column_name;
     end loop;
   end loop;

   v_first  := TRUE;
   n := 0;
   for key_rec in cur_unique_keys(c_name, c_owner) loop
      if v_first then -- we only want the first unique key
      v_first := FALSE;
      for key_col in cur_list_cons_columns(key_rec.constraint_name, c_owner) loop
         n := n + 1;
         v_unk_columns(n).col_name := key_col.column_name;
         v_unk_columns(n).arg_name := 'X_'||key_col.column_name;
      end loop;
      end if;
   end loop;

   n := 0;
   v_first := TRUE;
   for col_rec in cur_columns(c_name, c_owner) loop
       n := n + 1;
       v_tab_columns(n).col_name := col_rec.column_name;
       v_tab_columns(n).arg_name := 'X_'||col_rec.column_name;
   end loop;

----------------------------------------------------
-- View Definition
----------------------------------------------------
   n := v_tab_columns.FIRST;

   v_view_text :=
'create or replace view '||c_name||'_V as
select '||v_tab_columns(n).col_name||chr(10);

   v_checksum_call := ',      rnt_sys_checksum_rec_pkg.get_checksum(';
   v_checksum_call := v_checksum_call||''''||v_tab_columns(n).col_name||'=''||'
                                           ||v_tab_columns(n).col_name;

   n := v_tab_columns.NEXT(n);
   loop exit when n is null;
      v_view_text  := v_view_text   ||',      ' ||v_tab_columns(n).col_name ||chr(10);
      v_checksum_call := v_checksum_call||'||'''||v_tab_columns(n).col_name||'=''||'
                                                ||v_tab_columns(n).col_name;
      n := v_tab_columns.NEXT(n);
   end loop;
   
 -- if  present unique columns
 if v_unk_columns.COUNT > 0 then
       n := v_unk_columns.FIRST;
       if n is not null then
          v_order_by := 'order by '||v_unk_columns(n).col_name;
       end if;

       n := v_unk_columns.NEXT(n);
       loop exit when n is null;
          v_order_by  := v_order_by ||', ' ||v_unk_columns(n).col_name;
          n := v_unk_columns.NEXT(n);
       end loop;
  end if;

   v_view_text := v_view_text ||v_checksum_call||') as CHECKSUM'||chr(10);
   v_view_text := v_view_text ||'from '||c_name||chr(10);
   v_view_text := v_view_text ||v_order_by||';'||chr(10);


-- dbms_output.put_line(v_view_text);

-----------------------------------------------------------
--  get_checksum function
-----------------------------------------------------------
   n := v_pk_columns.FIRST;
   v_checksum_api := '  function get_checksum( '||v_pk_columns(n).arg_name|| ' IN '
                                                ||c_name||'.'
                                                ||v_pk_columns(n).col_name||'%TYPE';

   v_where := v_pk_columns(n).col_name||' = '||v_pk_columns(n).arg_name;

   n := v_pk_columns.NEXT(n);
   loop exit when n is null;
      v_checksum_api := v_checksum_api|| chr(10)||'                       , '
                                                ||v_pk_columns(n).arg_name|| ' IN '
                                                ||c_name||'.'
                                                ||v_pk_columns(n).col_name||'%TYPE';
      v_where := v_where||chr(10) ||'    and '||v_pk_columns(n).col_name||' = '
                                              ||v_pk_columns(n).arg_name;
      n := v_pk_columns.NEXT(n);
   end loop;

   v_checksum_api := v_checksum_api||')'||chr(10)
                     ||'            return '||c_name||'_V.CHECKSUM%TYPE';

   v_checksum_code := v_checksum_api||' is '||chr(10)||chr(10)||
'    v_return_value               '||c_name||'_V.CHECKSUM%TYPE;
  begin
    select CHECKSUM
    into v_return_value
    from '||c_name||'_V
    where '||v_where||';
    return v_return_value;
  end get_checksum;';

-- dbms_output.put_line(v_checksum_code);

-----------------------------------------------------------
-- check_unique function
-----------------------------------------------------------
   -- if present unique columns
   if v_unk_columns.COUNT > 0 then
       n := v_pk_columns.FIRST;
       v_check_unique_code := '  function check_unique( '
                                                    ||v_pk_columns(n).arg_name|| ' IN '
                                                    ||c_name||'.'
                                                    ||v_pk_columns(n).col_name||'%TYPE';
       v_select := v_pk_columns(n).col_name;
       v_if := v_pk_columns(n).arg_name||' is null OR c_rec.'
                       ||v_pk_columns(n).col_name
                       ||' != '||v_pk_columns(n).arg_name;

       n := v_pk_columns.NEXT(n);
       dbms_output.put_line(n);
       loop exit when n is null;
          v_checksum_api := v_checksum_api|| chr(10)||'                       , '
                                                    ||v_pk_columns(n).arg_name|| ' IN '
                                                    ||c_name||'.'
                                                    ||v_pk_columns(n).col_name||'%TYPE';
          v_select := v_select ||', '|| v_pk_columns(n).col_name;
          v_if := chr(10)||'and c_rec.'||v_pk_columns(n).col_name
                         ||' = '||v_pk_columns(n).arg_name;

          n := v_tab_columns.NEXT(n);
       end loop;

       n := v_unk_columns.FIRST;
       v_check_unique_code := v_check_unique_code|| chr(10)||'                       , '
                                                 ||v_unk_columns(n).arg_name|| ' IN '
                                                 ||c_name||'.'
                                                 ||v_unk_columns(n).col_name||'%TYPE';

       v_where := v_unk_columns(n).col_name||' = '||v_unk_columns(n).arg_name;

       n := v_unk_columns.NEXT(n);
       loop exit when n is null;
         v_check_unique_code := v_check_unique_code|| chr(10)||'                       , '
                                                   ||v_unk_columns(n).arg_name|| ' IN '
                                                   ||c_name||'.'
                                                   ||v_unk_columns(n).col_name||'%TYPE';

         v_where := v_where||chr(10) ||'    and '||v_unk_columns(n).col_name||' = '
                                                 ||v_unk_columns(n).arg_name;

         n := v_unk_columns.NEXT(n);
       end loop;

       v_check_unique_code := v_check_unique_code||') return boolean is
        cursor c is
        select '||v_select||'
        from '  ||c_name||'
        where ' ||v_where||';

      begin
         for c_rec in c loop
           if ('||v_if||') then
             return false;
           end if;
         end loop;
         return true;
      end check_unique;';
 end if;
-- dbms_output.put_line(v_check_unique_code);

---------------------------------------------------------------------
-- Lock row code
---------------------------------------------------------------------
   n := v_pk_columns.FIRST;

   v_lock_code    := '  procedure lock_row( '||v_pk_columns(n).arg_name|| ' IN '
                                              ||c_name||'.'
                                              ||v_pk_columns(n).col_name||'%TYPE';

   v_where := v_pk_columns(n).col_name||' = '||v_pk_columns(n).arg_name;

   n := v_pk_columns.NEXT(n);
   loop exit when n is null;
      v_lock_code := v_lock_code|| chr(10)||'                       , '
                                ||v_pk_columns(n).arg_name|| ' IN '
                                ||c_name||'.'
                                ||v_pk_columns(n).col_name||'%TYPE';
      v_where := v_where||chr(10) ||'    and '||v_pk_columns(n).col_name||' = '
                                              ||v_pk_columns(n).arg_name;
      n := v_pk_columns.NEXT(n);
   end loop;

   v_lock_code := v_lock_code||') is 
     cursor c is
     select * from '||c_name||'
     where '||v_where||'
     for update nowait;

  begin
    open c;
    close c;
  exception
    when OTHERS then
      if SQLCODE = -54 then
        RAISE_APPLICATION_ERROR(-20001, ''Cannot changed record. Record is locked.'');
      end if;
  end lock_row;';

-- dbms_output.put_line(v_lock_code);

----------------------------------------------------------------------
-- insert_row function
----------------------------------------------------------------------
-- Note: Table must have a system generated surrogate key

  n := v_pk_columns.FIRST;
  v_pk_column := v_pk_columns(n).col_name;

  n := v_tab_columns.FIRST;
  if v_pk_column like ('%_ID') then -- Table has system generated surrogate key
    n := v_tab_columns.NEXT(n);  -- Assume first column = PK column
    v_insert_api := '  function ';
    v_insert_end := ')
              return '||c_name||'.'||v_pk_column||'%TYPE';
  else
    v_insert_api := '  procedure ';
    v_insert_end := ')';
  end if;
    

  v_insert_api := v_insert_api||' insert_row( '||v_tab_columns(n).arg_name|| ' IN '
                                           ||c_name||'.'
                                           ||v_tab_columns(n).col_name||'%TYPE';

  if v_pk_column like ('%_ID') then
    v_select := v_pk_column||chr(10)||'     , '||v_tab_columns(n).col_name;
    v_where  := c_name||'_SEQ.NEXTVAL'||chr(10)||'     , '||v_tab_columns(n).arg_name;
  else
    v_select := v_tab_columns(n).col_name;
    v_where  := v_tab_columns(n).arg_name;
  end if;

  n := v_tab_columns.NEXT(n);
  loop exit when n is null;
     v_insert_api := v_insert_api|| chr(10)||'                     , '
                                 ||v_tab_columns(n).arg_name|| ' IN '
                                 ||c_name||'.'
                                 ||v_tab_columns(n).col_name||'%TYPE';

     v_select := v_select||chr(10)||'     , '||v_tab_columns(n).col_name;
     v_where  := v_where ||chr(10)||'     , '||v_tab_columns(n).arg_name;
     n := v_tab_columns.NEXT(n);
  end loop;

  v_insert_api := v_insert_api||v_insert_end;

  v_order_by := 'NULL';
  n := v_unk_columns.FIRST;
   loop exit when n is null;
      v_order_by  := v_order_by ||', ' ||v_unk_columns(n).arg_name;
      n := v_unk_columns.NEXT(n);
   end loop;

  v_insert_code := v_insert_api||'
  is
     x          number;
  begin
';
  if v_unk_columns.COUNT > 0 then  
     v_insert_code := v_insert_code||
     'if not check_unique('||v_order_by||') then
         RAISE_APPLICATION_ERROR(-20006, ''Insert values must be unique.'');
     end if;
  ';
  end if;

  if v_pk_column like ('%_ID') then  
  v_insert_code := v_insert_code ||'
     insert into '||c_name ||'
     ( '||v_select||')
     values
     ( '||v_where||')
     returning '||v_pk_column||' into x;

     return x;
  end insert_row;';
  else
  v_insert_code := v_insert_code ||'
     insert into '||c_name ||'
     ( '||v_select||')
     values
     ( '||v_where||');

  end insert_row;';
  end if;


--  dbms_output.put_line(v_insert_code);

----------------------------------------------------------------------
-- update_row function
----------------------------------------------------------------------
-- Note: Table must have a system generated surrogate key

  n := v_pk_columns.FIRST;
  v_pk_column := v_pk_columns(n).col_name;
  v_where := v_pk_columns(n).col_name ||' = '||v_pk_columns(n).arg_name ;

  n := v_tab_columns.FIRST;
  v_update_api := '  procedure update_row( '||v_tab_columns(n).arg_name|| ' IN '
                                            ||c_name||'.'
                                            ||v_tab_columns(n).col_name||'%TYPE';

  v_first := TRUE;
  n := v_tab_columns.NEXT(n);
  loop exit when n is null;
     v_update_api := v_update_api|| chr(10)||'                      , '
                                 ||v_tab_columns(n).arg_name|| ' IN '
                                 ||c_name||'.'
                                 ||v_tab_columns(n).col_name||'%TYPE';

     if v_first = TRUE then
        v_select := v_tab_columns(n).col_name||' = '
                                             || v_tab_columns(n).arg_name;
        v_first := FALSE;
     else
        v_select := v_select||chr(10)||'     , '||v_tab_columns(n).col_name
                            ||' = '|| v_tab_columns(n).arg_name;
     end if;
 
     n := v_tab_columns.NEXT(n);
  end loop;

  v_update_api := v_update_api|| chr(10)||'                      , '
                              ||'X_CHECKSUM IN '
                              ||c_name||'_V.CHECKSUM%TYPE)';

  v_order_by := 'X_'||v_pk_column;
  n := v_unk_columns.FIRST;
   loop exit when n is null;
      v_order_by  := v_order_by ||', ' ||v_unk_columns(n).arg_name;
      n := v_unk_columns.NEXT(n);
   end loop;

  v_update_code := v_update_api||'
  is
     l_checksum          '||c_name||'_V.CHECKSUM%TYPE;
  begin
     lock_row(X_'||v_pk_column||');

      -- validate checksum
      l_checksum := get_checksum(X_'||v_pk_column||');
      if X_CHECKSUM != l_checksum then
         RAISE_APPLICATION_ERROR(-20002, ''Record has been changed another user.'');
      end if;
     ';
  
  if v_unk_columns.COUNT > 0 then
      v_update_code := v_update_code||'  
         if not check_unique('||v_order_by||') then
             RAISE_APPLICATION_ERROR(-20006, ''Update values must be unique.'');
         end if;';
  end if;
    
  v_update_code := v_update_code||'
     update '||c_name ||'
     set '||v_select||'
     where '||v_where||';

  end update_row;';

--   dbms_output.put_line(v_update_code);
-----------------------------------------------------------
--  delete_row procedure
-----------------------------------------------------------
   n := v_pk_columns.FIRST;
   v_delete_api := '  procedure delete_row( '||v_pk_columns(n).arg_name|| ' IN '
                                             ||c_name||'.'
                                             ||v_pk_columns(n).col_name||'%TYPE';

   v_where := v_pk_columns(n).col_name||' = '||v_pk_columns(n).arg_name;

   n := v_pk_columns.NEXT(n);
   loop exit when n is null;
      v_delete_api := v_delete_api|| chr(10)||'                       , '
                                            ||v_pk_columns(n).arg_name|| ' IN '
                                            ||c_name||'.'
                                            ||v_pk_columns(n).col_name||'%TYPE';
      v_where := v_where||chr(10) ||'    and '||v_pk_columns(n).col_name||' = '
                                              ||v_pk_columns(n).arg_name;
      n := v_pk_columns.NEXT(n);
   end loop;

   v_delete_api := v_delete_api||')';

   v_delete_code := v_delete_api||' is

  begin
    delete from '||c_name||'
    where '||v_where||';
    
  end delete_row;';

-- dbms_output.put_line(v_delete_code);

--------------------------------------------------------------------
-- Package Spec and Body
--------------------------------------------------------------------
     v_spec_text :=
'create or replace package '||c_name||'_PKG as
/*******************************************************************************
 ' ||v_copyright||'
    Name:      '||c_name||'_PKG
    Purpose:   API''s for '||c_name||' table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        '||sysdate||'   Auto Generated   Initial Version
*******************************************************************************/
'||v_checksum_api||';'||chr(10)||chr(10)
 ||v_update_api  ||';'||chr(10)||chr(10)
 ||v_insert_api  ||';'||chr(10)||chr(10)
 ||v_delete_api  ||';'||chr(10)||chr(10)
||'end '||c_name||'_PKG;
/';

    v_body_text :=
'create or replace package body '||c_name||'_PKG as
/*******************************************************************************
 ' ||v_copyright||'
    Name:      '||c_name||'_PKG
    Purpose:   API''s for '||c_name||' table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        '||sysdate||'   Auto Generated   Initial Version

********************************************************************************/
-------------------------------------------------
--  Private Procedures and Functions
-------------------------------------------------
'
 ||v_check_unique_code||chr(10)||chr(10)
 ||v_lock_code||chr(10)
||'
-------------------------------------------------
--  Public Procedures and Functions
-------------------------------------------------
'
 ||v_checksum_code||chr(10)||chr(10)
 ||v_update_code  ||chr(10)||chr(10)
 ||v_insert_code  ||chr(10)||chr(10)
 ||v_delete_code  ||chr(10)||chr(10)
 ||'end '||c_name||'_PKG;'||chr(10)
 ||'/'||chr(10);

dbms_output.put_line(v_view_text);
dbms_output.put_line(v_spec_text);
dbms_output.put_line(v_body_text);

dbms_output.put_line('show errors package '||c_name||'_PKG');
dbms_output.put_line('show errors package body '||c_name||'_PKG');

end;
/
