ALTER TABLE RNT_USER_ROLES
MODIFY(ROLE_CODE VARCHAR2(20))
/


Insert into RNT_USER_ROLES
   (ROLE_ID, ROLE_CODE, ROLE_NAME)
 Values
   (4, 'MANAGER_OWNER', 'Manager and owner')
/   

commit
/
