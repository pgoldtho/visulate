Prompt Check if have necessary permissions 

set serveroutput on size unlimited

WHENEVER SQLERROR EXIT FAILURE;

DECLARE
   TYPE    t_privs IS TABLE OF VARCHAR2(30);
   v_privs t_privs := t_privs('CREATE PROCEDURE','CREATE TABLE','CREATE TRIGGER','CREATE TYPE','CREATE VIEW');
   v_priv  user_sys_privs.privilege%type;
   v_OK    boolean := TRUE;
BEGIN
   FOR i IN v_privs.FIRST..v_privs.LAST LOOP
   BEGIN
      SELECT privilege
        INTO v_priv
        FROM user_sys_privs
       WHERE privilege = v_privs(i);
      dbms_output.put_line(USER || ' has required "' || v_privs(i) || '" privilege.');
      EXCEPTION 
         WHEN NO_DATA_FOUND THEN
              dbms_output.put_line(USER || ' does NOT have required "' || v_privs(i) || '" privilege.');
              v_OK := FALSE;
   END;
   END LOOP;
   IF ( NOT v_OK ) THEN
      RAISE_APPLICATION_ERROR(-20000, USER || ' does not have all required privileges - check LOG.');
   END IF;
END;
/
SHOW ERRORS

Prompt Check grants....
Prompt Checking select on dba_registry permission...
SELECT count(*) FROM dba_registry WHERE comp_id = 'SDO';
Prompt Checking select on dba_recyclebin permission...
SELECT count(*) FROM dba_recyclebin WHERE owner = 'CODESYS';
Prompt Checking execute on mdsys.md package ...
SELECT mdsys.md.hhlevels(0,10,2) FROM dual;  

Prompt Checking execute on mdsys.sdo_3gl package 
declare
  v_Minx   number;
  v_Maxx   number;
  v_miny   number;
  v_maxy   number;
  v_length number;
  v_area   number;
  v_diminfo mdsys.sdo_dim_array := MDSYS.SDO_DIM_ARRAY(MDSYS.SDO_DIM_ELEMENT('X', 0, 10, 0.005),
                                                       MDSYS.SDO_DIM_ELEMENT('Y', 0, 10, 0.005));
Begin
    mdsys.sdo_3gl.length_area(v_diminfo,
        sdo_geometry(2002,null,null,sdo_elem_info_array(1,2,1),sdo_ordinate_array(0,0,1,1)),
        1, /* 2 is area; 1 is length */
        /*v_units, Seems to be flakey */
        v_length,
        v_area);
    dbms_output.put_line('sdo_3gl.length_area length=' || v_length);
    MDSYS.SDO_3GL.EXTENT_OF_OBJECT(
                  MDSYS.SDO_DIM_ARRAY(
                        MDSYS.SDO_DIM_ELEMENT('X',0,100,0.05),
                        MDSYS.SDO_DIM_ELEMENT('Y',0,100,0.05)),
                  mdsys.sdo_geometry(2003,null,null,mdsys.sdo_elem_info_array(1,1003,3),mdsys.sdo_ordinate_array(0,0,10,10)),
                  v_Minx,
                  v_Maxx,
                  v_miny,
                  v_maxy );
    dbms_output.put_line('sdo_3gl.extent_of_object is MBR ' || v_minx || ',' || v_miny ||','|| v_maxx || ',' || v_maxy);
end;
/
show errors

exit;
