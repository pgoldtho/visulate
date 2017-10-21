REM Copyright Visulate 2007
set echo on
set feedback on
spool install.lst
@@schema.sql
conn rntmgr/rntmgr
@@visulate_ddl.sql
@@sequences.sql
@@1_1_tables.sql
@@1_3_RNT_SYS_CHECKSUM_REC_PKG.sql
@@1_4_RNT_PROPERTIES_PKG.sql
@@1_2_views.sql
@@1_5_data.sql
@@2._1_drop_NOTM.sql
@@2_4_RNT_PROPERTIES_PKG.pks
@@2_4_RNT_PROPERTIES_PKG.pkb
@@2_6_RNT_PROPERTY_UNITS_PKG.pks
@@2_6_RNT_PROPERTY_UNITS_PKG.pkb
@@4_1_RNT_LOANS_V.vw
@@4_2_RNT_LOOKUP_VALUES_V.vw
@@4_3_RNT_PROPERTIES_V.vw
@@4_4_RNT_PROPERTY_UNITS_V.vw
@@4_5_RNT_TENANCY_AGREEMENT_V.vw
@@4_6_RNT_TENANCY_AGREEMENT_PKG.pkb
@@4_6_RNT_TENANCY_AGREEMENT_PKG.pks
@@4_7_RNT_LOANS_PKG.pkb
@@4_7_RNT_LOANS_PKG.pks

spool off

