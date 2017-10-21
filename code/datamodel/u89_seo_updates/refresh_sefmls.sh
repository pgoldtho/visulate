#!/bin/bash
connect_str='rntmgr2/rntmgr2'
source /home/oracle/.bash_profile
echo Get BROWARD ResidentialProperty
/home/oracle/app/oracle/product/11.2.0/dbhome_1/bin/sqlplus $connect_str <<ENDOFSQL11
alter session set nls_date_format='dd-mon-yyyy';
exec mls_sef_pkg.get_by_type('ResidentialProperty', 'BROWARD', 'all')
exit;
ENDOFSQL11
echo Get DADE ResidentialProperty
/home/oracle/app/oracle/product/11.2.0/dbhome_1/bin/sqlplus $connect_str <<ENDOFSQL12
alter session set nls_date_format='dd-mon-yyyy';
exec mls_sef_pkg.get_by_type('ResidentialProperty', 'DADE', 'all')
exit;
ENDOFSQL12
echo Get PALMBCH ResidentialProperty
/home/oracle/app/oracle/product/11.2.0/dbhome_1/bin/sqlplus $connect_str <<ENDOFSQL13
alter session set nls_date_format='dd-mon-yyyy';
exec mls_sef_pkg.get_by_type('ResidentialProperty', 'PALMBCH', 'all')
exit;
ENDOFSQL13
echo Get BROWARD Condos
/home/oracle/app/oracle/product/11.2.0/dbhome_1/bin/sqlplus $connect_str <<ENDOFSQL21
alter session set nls_date_format='dd-mon-yyyy';
exec mls_sef_pkg.get_by_type('Condos', 'BROWARD', 'all')
exit;
ENDOFSQL21
echo Get DADE Condos
/home/oracle/app/oracle/product/11.2.0/dbhome_1/bin/sqlplus $connect_str <<ENDOFSQL22
alter session set nls_date_format='dd-mon-yyyy';
exec mls_sef_pkg.get_by_type('Condos', 'DADE', 'all')
exit;
ENDOFSQL22
echo Get PALMBCH Condos
/home/oracle/app/oracle/product/11.2.0/dbhome_1/bin/sqlplus $connect_str <<ENDOFSQL23
alter session set nls_date_format='dd-mon-yyyy';
exec mls_sef_pkg.get_by_type('Condos', 'PALMBCH', 'all')
exit;
ENDOFSQL23
echo Get BROWARD IncomeProperty
/home/oracle/app/oracle/product/11.2.0/dbhome_1/bin/sqlplus $connect_str <<ENDOFSQL31
alter session set nls_date_format='dd-mon-yyyy';
exec mls_sef_pkg.get_by_type('IncomeProperty', 'BROWARD', 'all')
exit;
ENDOFSQL31
echo Get DADE IncomeProperty
/home/oracle/app/oracle/product/11.2.0/dbhome_1/bin/sqlplus $connect_str <<ENDOFSQL32
alter session set nls_date_format='dd-mon-yyyy';
exec mls_sef_pkg.get_by_type('IncomeProperty', 'DADE', 'all')
exit;
ENDOFSQL32
echo Get PALMBCH IncomeProperty
/home/oracle/app/oracle/product/11.2.0/dbhome_1/bin/sqlplus $connect_str <<ENDOFSQL33
alter session set nls_date_format='dd-mon-yyyy';
exec mls_sef_pkg.get_by_type('IncomeProperty', 'PALMBCH', 'all')
exit;
ENDOFSQL33
echo Get BROWARD ResidentialLand
/home/oracle/app/oracle/product/11.2.0/dbhome_1/bin/sqlplus $connect_str <<ENDOFSQL41
alter session set nls_date_format='dd-mon-yyyy';
exec mls_sef_pkg.get_by_type('ResidentialLand', 'BROWARD', 'all')
exit;
ENDOFSQL41
echo Get DADE ResidentialLand
/home/oracle/app/oracle/product/11.2.0/dbhome_1/bin/sqlplus $connect_str <<ENDOFSQL42
alter session set nls_date_format='dd-mon-yyyy';
exec mls_sef_pkg.get_by_type('ResidentialLand', 'DADE', 'all')
exit;
ENDOFSQL42
echo Get PALMBCH ResidentialLand
/home/oracle/app/oracle/product/11.2.0/dbhome_1/bin/sqlplus $connect_str <<ENDOFSQL43
alter session set nls_date_format='dd-mon-yyyy';
exec mls_sef_pkg.get_by_type('ResidentialLand', 'PALMBCH', 'all')
exit;
ENDOFSQL43
echo Get BROWARD CommercialLand
/home/oracle/app/oracle/product/11.2.0/dbhome_1/bin/sqlplus $connect_str <<ENDOFSQL51
alter session set nls_date_format='dd-mon-yyyy';
exec mls_sef_pkg.get_by_type('CommercialLand', 'BROWARD', 'all')
exit;
ENDOFSQL51
echo Get DADE CommercialLand
/home/oracle/app/oracle/product/11.2.0/dbhome_1/bin/sqlplus $connect_str <<ENDOFSQL52
alter session set nls_date_format='dd-mon-yyyy';
exec mls_sef_pkg.get_by_type('CommercialLand', 'DADE', 'all')
exit;
ENDOFSQL52
echo Get PALMBCH CommercialLand
/home/oracle/app/oracle/product/11.2.0/dbhome_1/bin/sqlplus $connect_str <<ENDOFSQL53
alter session set nls_date_format='dd-mon-yyyy';
exec mls_sef_pkg.get_by_type('CommercialLand', 'PALMBCH', 'all')
exit;
ENDOFSQL53
echo Get BROWARD CommercialProperty
/home/oracle/app/oracle/product/11.2.0/dbhome_1/bin/sqlplus $connect_str <<ENDOFSQL61
alter session set nls_date_format='dd-mon-yyyy';
exec mls_sef_pkg.get_by_type('CommercialProperty', 'BROWARD', 'all')
exit;
ENDOFSQL61
echo Get DADE CommercialProperty
/home/oracle/app/oracle/product/11.2.0/dbhome_1/bin/sqlplus $connect_str <<ENDOFSQL62
alter session set nls_date_format='dd-mon-yyyy';
exec mls_sef_pkg.get_by_type('CommercialProperty', 'DADE', 'all')
exit;
ENDOFSQL62
echo Get PALMBCH CommercialProperty
/home/oracle/app/oracle/product/11.2.0/dbhome_1/bin/sqlplus $connect_str <<ENDOFSQL63
alter session set nls_date_format='dd-mon-yyyy';
exec mls_sef_pkg.get_by_type('CommercialProperty', 'PALMBCH', 'all')
exit;
ENDOFSQL63
echo Get BROWARD Business
/home/oracle/app/oracle/product/11.2.0/dbhome_1/bin/sqlplus $connect_str <<ENDOFSQL81
alter session set nls_date_format='dd-mon-yyyy';
exec mls_sef_pkg.get_by_type('Business', 'BROWARD', 'all')
exit;
ENDOFSQL81
echo Get DADE Business
/home/oracle/app/oracle/product/11.2.0/dbhome_1/bin/sqlplus $connect_str <<ENDOFSQL82
alter session set nls_date_format='dd-mon-yyyy';
exec mls_sef_pkg.get_by_type('Business', 'DADE', 'all')
exit;
ENDOFSQL82
echo Get PALMBCH Business
/home/oracle/app/oracle/product/11.2.0/dbhome_1/bin/sqlplus $connect_str <<ENDOFSQL83
alter session set nls_date_format='dd-mon-yyyy';
exec mls_sef_pkg.get_by_type('Business', 'PALMBCH', 'all')
exit;
ENDOFSQL83
echo Update MLS Search Entries
/home/oracle/app/oracle/product/11.2.0/dbhome_1/bin/sqlplus $connect_str <<ENDOFSQL
alter session set nls_date_format='dd-mon-yyyy';
exec mls_sef_pkg.update_mls
exit;
ENDOFSQL

    
