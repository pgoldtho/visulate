CREATE OR REPLACE PACKAGE RNT_USER_MAIL_PKG AS
/******************************************************************************
   NAME:       RNT_USER_MAIL_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        05.12.2007             1. Created this package.
******************************************************************************/

procedure email_enabled_account(X_USER_ID RNT_USERS.USER_ID%TYPE);

END RNT_USER_MAIL_PKG;
/

SHOW ERRORS;

CREATE OR REPLACE PACKAGE BODY RNT_USER_MAIL_PKG AS
/******************************************************************************
   NAME:       RNT_USER_MAIL_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        05.12.2007             1. Created this package body.
******************************************************************************/

procedure email_enabled_account(X_USER_ID RNT_USERS.USER_ID%TYPE)
is
  email_user RNT_USERS.USER_LOGIN%TYPE;
  x_name varchar2(300);
  x_template varchar2(4000);
begin
  update RNT_USERS
  set IS_ACTIVE_YN = 'Y'
  where USER_ID = X_USER_ID;
  commit;
  
  select USER_LOGIN, USER_NAME||' '||USER_LASTNAME
  into email_user, x_name
  from RNT_USERS
  where USER_ID = X_USER_ID; 
  
  x_template := '$NAME$. For you activated user account on Visulate Rentals.'||CHR(10)||
                '  You login $LOGIN$. '||CHR(10)||
                '  Address link: http://visulate.com/login.php?login=$LOGIN$' ;
  
  x_template := replace(x_template, '$NAME$', x_name);
  x_template := replace(x_template, '$LOGIN$', email_user);
  send_mail (pSender    => 'admin@visulate.net',
             pRecipient => email_user,
             pSubject   => 'Visulate Renal - Activation Account',
             pMessage   => x_template);
end;

END RNT_USER_MAIL_PKG;
/

SHOW ERRORS;
