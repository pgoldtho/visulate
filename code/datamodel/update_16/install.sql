REM Copyright Visulate 2007
set echo on
set feedback on
spool install.lst
conn rntmgr/rntmgr

@@payment_types.sql
@@receivable.sql
@@rnt_accounts_receivable_pkg.sql
@@rnt_acc_receivable_const_pkg.sql
@@rnt_agreement_actions_pkg.sql
@@synch.sql

spool off

