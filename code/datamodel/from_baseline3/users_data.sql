SET DEFINE OFF;
Insert into RNT_USERS
   (USER_ID, USER_LOGIN, USER_NAME, USER_PASSWORD, IS_ACTIVE_YN)
 Values
   (1, 'test@visulate.com', 'Test', '098f6bcd4621d373cade4e832627b4f6', 'Y');
Insert into RNT_USERS
   (USER_ID, USER_LOGIN, USER_NAME, USER_PASSWORD, IS_ACTIVE_YN)
 Values
   (2, 'ownerX@visulate.com', 'Owner X', '098f6bcd4621d373cade4e832627b4f6', 'Y');
COMMIT;

SET DEFINE OFF;
Insert into RNT_USER_ROLES
   (ROLE_ID, ROLE_CODE, ROLE_NAME)
 Values
   (3, 'ADMIN', 'Administrator');
Insert into RNT_USER_ROLES
   (ROLE_ID, ROLE_CODE, ROLE_NAME)
 Values
   (1, 'MANAGER', 'Manager');
Insert into RNT_USER_ROLES
   (ROLE_ID, ROLE_CODE, ROLE_NAME)
 Values
   (2, 'OWNER', 'Owner ');
COMMIT;

SET DEFINE OFF;
Insert into RNT_USER_ASSIGNMENTS
   (USER_ASSIGN_ID, ROLE_ID, USER_ID, BUSINESS_ID)
 Values
   (2, 3, 1, 0);
Insert into RNT_USER_ASSIGNMENTS
   (USER_ASSIGN_ID, ROLE_ID, USER_ID, BUSINESS_ID)
 Values
   (1, 1, 1, 1);
Insert into RNT_USER_ASSIGNMENTS
   (USER_ASSIGN_ID, ROLE_ID, USER_ID, BUSINESS_ID)
 Values
   (3, 2, 1, 16);
COMMIT;

SET DEFINE OFF;
Insert into RNT_BUSINESS_UNITS
   (BUSINESS_ID, BUSINESS_NAME, PARENT_BUSINESS_ID)
 Values
   (0, 'Root business unit', -1);
Insert into RNT_BUSINESS_UNITS
   (BUSINESS_ID, BUSINESS_NAME, PARENT_BUSINESS_ID)
 Values
   (1, 'Manager for X and Y owner', 0);
Insert into RNT_BUSINESS_UNITS
   (BUSINESS_ID, BUSINESS_NAME, PARENT_BUSINESS_ID)
 Values
   (16, 'Business Unit for owner X', 1);
Insert into RNT_BUSINESS_UNITS
   (BUSINESS_ID, BUSINESS_NAME, PARENT_BUSINESS_ID)
 Values
   (17, 'Business Unit for owner Y', 1);
COMMIT;

SET DEFINE OFF;
Insert into RNT_USER_ASSIGNMENTS
   (USER_ASSIGN_ID, ROLE_ID, USER_ID, BUSINESS_ID)
 Values
   (2, 3, 1, 0);
Insert into RNT_USER_ASSIGNMENTS
   (USER_ASSIGN_ID, ROLE_ID, USER_ID, BUSINESS_ID)
 Values
   (17, 2, 1, 16);
Insert into RNT_USER_ASSIGNMENTS
   (USER_ASSIGN_ID, ROLE_ID, USER_ID, BUSINESS_ID)
 Values
   (15, 1, 1, 1);
COMMIT;
