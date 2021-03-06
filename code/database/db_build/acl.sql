grant  execute on utl_http to rntmgr1;
grant execute on dbms_crypto to rntmgr1;
grant SCHEDULER_ADMIN to rntmgr1;

BEGIN
   DBMS_NETWORK_ACL_ADMIN.CREATE_ACL (
    acl          => 'visulate1-acl.xml',
    description  => 'Permissions to access MLS and Property Appraiser sites',
    principal    => 'RNTMGR1',
    is_grant     => TRUE,
    privilege    => 'connect');
   COMMIT;
END;
/
create role webaccess;
BEGIN
   DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE (
    acl          => 'visulate1-acl.xml',
    principal    => 'WEBACCESS',
    is_grant     => TRUE, 
    privilege    => 'connect',
    position     => null);
   COMMIT;
END;
/

BEGIN
   DBMS_NETWORK_ACL_ADMIN.ASSIGN_ACL (
    acl          => 'visulate1-acl.xml',
    host         => '*.offutt-innovia.com',
    lower_port   => 1,
    upper_port   => 9999); 
    
   DBMS_NETWORK_ACL_ADMIN.ASSIGN_ACL (
    acl          => 'visulate1-acl.xml',
    host         => '*.brevardmls.com',
    lower_port   => 1,
    upper_port   => 9999); 
    
   DBMS_NETWORK_ACL_ADMIN.ASSIGN_ACL (
    acl          => 'visulate1-acl.xml',
    host         => '*.brevardpropertyappraiser.com',
    lower_port   => 1,
    upper_port   => 9999);

   DBMS_NETWORK_ACL_ADMIN.ASSIGN_ACL (
    acl          => 'visulate1-acl.xml',
    host         => '*.rets.interealty.com',
    lower_port   => 1,
    upper_port   => 9999);

   DBMS_NETWORK_ACL_ADMIN.ASSIGN_ACL (
    acl          => 'visulate1-acl.xml',
    host         => '*.myfloridahomesmls.com',
    lower_port   => 1,
    upper_port   => 9999);
    
   DBMS_NETWORK_ACL_ADMIN.ASSIGN_ACL (
    acl          => 'visulate1-acl.xml',
    host         => 'myfloridahomesmls.com',
    lower_port   => 1,
    upper_port   => 9999);
   COMMIT;
END;
/

