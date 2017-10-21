declare 
  x NUMBER;
BEGIN
   DBMS_JOB.SUBMIT
      (job  => x
      ,what => 'begin RNT_ACCOUNTS_PAYABLE_PKG.GENERATE_PAYMENT_LIST; RNT_ACCOUNTS_RECEIVABLE_PKG.GENERATE_PAYMENT_LIST; end;'
      ,next_date => trunc(SYSDATE) + 1
      ,interval => 'trunc(SYSDATE) + 1');
  commit;      
END;

