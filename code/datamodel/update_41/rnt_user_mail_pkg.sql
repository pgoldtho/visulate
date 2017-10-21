CREATE OR REPLACE PACKAGE        RNT_USER_MAIL_PKG AS
/******************************************************************************
   NAME:       RNT_USER_MAIL_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        05.12.2007             1. Created this package.
******************************************************************************/

procedure email_enabled_account(X_USER_ID RNT_USERS.USER_ID%TYPE);

procedure recover_password(X_USER_LOGIN RNT_USERS.USER_LOGIN%TYPE, X_USER_PASSWORD RNT_USERS.USER_PASSWORD%TYPE);

procedure register_account_msg(X_USER_REGISTRY_ID RNT_USER_REGISTRY.USER_REGISTRY_ID%TYPE);

END RNT_USER_MAIL_PKG;
/

SHOW ERRORS;

CREATE OR REPLACE PACKAGE BODY        RNT_USER_MAIL_PKG AS
/******************************************************************************
   NAME:       RNT_USER_MAIL_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        05.12.2007             1. Created this package body.
******************************************************************************/
X_ADMIN_MAIL CONSTANT  varchar2(100) := 'aguk@idknet.com';
X_SERVER_ROOT CONSTANT varchar2(200) := 'http://rental.visulate.com:7777/rental'; 

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
                '  Address link: '||X_SERVER_ROOT||'/login.php?login=$LOGIN$' ;
  
  x_template := replace(x_template, '$NAME$', x_name);
  x_template := replace(x_template, '$LOGIN$', email_user);
  utl_mail.send(sender       => X_ADMIN_MAIL,
                recipients   => email_user,
                subject      => 'Visulate Renal - Activation Account',
                message      => x_template);
end;

procedure recover_password(X_USER_LOGIN RNT_USERS.USER_LOGIN%TYPE, X_USER_PASSWORD RNT_USERS.USER_PASSWORD%TYPE)
is
  x_template varchar2(4000);
  x_name varchar2(200);
begin
  select USER_NAME||' '||USER_LASTNAME
  into x_name
  from RNT_USERS
  where upper(USER_LOGIN) = upper(X_USER_LOGIN);   

  x_template := 'Visulate Password Recover for $NAME$.'||CHR(10)||
                '  You login: $LOGIN$ '||CHR(10)||
                '  You password: $PASSWORD$ '||CHR(10)||
                '  Address link: '||X_SERVER_ROOT||'/login.php?login=$LOGIN$' ;
  
  x_template := replace(x_template, '$NAME$', x_name);
  x_template := replace(x_template, '$LOGIN$', X_USER_LOGIN);
  x_template := replace(x_template, '$PASSWORD$', X_USER_PASSWORD);

  utl_mail.send(sender       => X_ADMIN_MAIL,
                recipients   => X_USER_LOGIN,
                subject      => 'Visulate Renal - Password Recover',
                message      => x_template);
end;

procedure register_account_msg(X_USER_REGISTRY_ID RNT_USER_REGISTRY.USER_REGISTRY_ID%TYPE)
is
  t RNT_USER_REGISTRY%ROWTYPE;
  X_INVITE_MAIL varchar2(1024) := X_ADMIN_MAIL;
  --x_template :=
  iu RNT_USERS%ROWTYPE;
  x_template varchar2(10000);
  x_invite_string varchar2(300);
begin
  select *
  into t
  from RNT_USER_REGISTRY
  where USER_REGISTRY_ID = X_USER_REGISTRY_ID;
  
  if t.INVITE_USER_ID is not null then
     select *
     into iu
     from RNT_USERS
     where USER_ID = t.INVITE_USER_ID;
     x_invite_string := 'You have been invited from '||iu.USER_NAME||' '||iu.USER_LASTNAME||' ('||iu.USER_LOGIN||').'||CHR(10); 
  end if;   
  
    
  x_template := CHR(10)||CHR(10)||'Created account for $NAME$.'||CHR(10)||CHR(10)||CHR(10)||
                x_invite_string||
                '  You login: $LOGIN$ '||CHR(10)||
                '  You password: $PASSWORD$ '||CHR(10)||
                '  Go to address link: '||X_SERVER_ROOT||'/login.php?hash=$HASH$ and enter login and password.' ;  

  x_template := replace(x_template, '$NAME$', t.USER_NAME||' '||t.USER_LAST_NAME);
  x_template := replace(x_template, '$LOGIN$', t.USER_LOGIN_EMAIL);
  x_template := replace(x_template, '$PASSWORD$', RNT_OBFURCATION_PASSWORD_PKG.DECRYPT(t.USER_PASSWORD));
  x_template := replace(x_template, '$HASH$', t.USER_HASH_VALUE);
     
  utl_mail.send(sender       => X_ADMIN_MAIL,
                recipients   => t.USER_LOGIN_EMAIL,
                subject      => 'Visulate Renal - Creation Account',
                message      => x_template);
   
end;

END RNT_USER_MAIL_PKG;
/

SHOW ERRORS;
