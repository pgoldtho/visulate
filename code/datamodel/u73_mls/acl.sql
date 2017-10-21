revoke execute on utl_http from public;
grant  execute on utl_http to rntmgr;
grant execute on dbms_crypto to rntmgr;
grant SCHEDULER_ADMIN to rntmgr;

BEGIN
   DBMS_NETWORK_ACL_ADMIN.CREATE_ACL (
    acl          => 'visulate-acl.xml',
    description  => 'Permissions to access MLS and Property Appraiser sites',
    principal    => 'RNTMGR',
    is_grant     => TRUE,
    privilege    => 'connect');
   COMMIT;
END;
/
create role webaccess;
BEGIN
   DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE (
    acl          => 'visulate-acl.xml',
    principal    => 'WEBACCESS',
    is_grant     => TRUE, 
    privilege    => 'connect',
    position     => null);
   COMMIT;
END;
/

BEGIN
   DBMS_NETWORK_ACL_ADMIN.ASSIGN_ACL (
    acl          => 'visulate-acl.xml',
    host         => '*.offutt-innovia.com',
    lower_port   => 1,
    upper_port   => 9999); 

   DBMS_NETWORK_ACL_ADMIN.ASSIGN_ACL (
    acl          => 'visulate-acl.xml',
    host         => '*.brevardpropertyappraiser.com',
    lower_port   => 1,
    upper_port   => 9999);

   DBMS_NETWORK_ACL_ADMIN.ASSIGN_ACL (
    acl          => 'visulate-acl.xml',
    host         => '*.rets.interealty.com',
    lower_port   => 1,
    upper_port   => 9999);

   DBMS_NETWORK_ACL_ADMIN.ASSIGN_ACL (
    acl          => 'visulate-acl.xml',
    host         => '*.myfloridahomesmls.com',
    lower_port   => 1,
    upper_port   => 9999);
    
   DBMS_NETWORK_ACL_ADMIN.ASSIGN_ACL (
    acl          => 'visulate-acl.xml',
    host         => 'myfloridahomesmls.com',
    lower_port   => 1,
    upper_port   => 9999);
   COMMIT;
END;
/

-----------------------
-- Open ACL for development only!!!!!!!!!!!
--------------------------------------------
BEGIN
  DBMS_NETWORK_ACL_ADMIN.create_acl (
    acl          => 'open_acl_file.xml', 
    description  => 'A test of the ACL functionality',
    principal    => 'RNTMGR1',
    is_grant     => TRUE, 
    privilege    => 'connect',
    start_date   => SYSTIMESTAMP,
    end_date     => NULL);

  DBMS_NETWORK_ACL_ADMIN.assign_acl (
    acl         => 'open_acl_file.xml',
    host        => '*', 
    lower_port  => 1,
    upper_port  => 9999); 

  COMMIT;
END;
/
