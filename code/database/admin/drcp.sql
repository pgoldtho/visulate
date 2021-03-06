begin
  dbms_connection_pool.configure_pool
     (null,
      minsize=>10,
      maxsize=>150,
      inactivity_timeout=>300,
      max_think_time=>600);
end;
/

execute dbms_connection_pool.start_pool;
 SELECT connection_pool, status, maxsize FROM dba_cpool_info;


vim /usr/local/zend/etc/php.ini
oci8.connection_class=VISULATE

vim /usr/local/zend/share/pear/creole/drivers/oracle/OCI8Connection.php
set connection type to pconnect

restart apache


vim config.php
server=pooled

define("DB_PASS", "rntmgr2");
define("DB_TNS", "(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=centos-pc)
       (PORT=1521))(CONNECT_DATA=(SERVER=POOLED)(SERVICE_NAME=vis11)))");


select num_requests, num_hits, num_misses, num_waits from v$cpool_stats;

monitor num_hits, num_waits
