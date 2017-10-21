create or replace package rnt_tenant_mgt
as
   notm_mismatch            exception;  

 function RNT_TENANT_DETAILS
    ( P_FIRST_NAME           in RNT_TENANT.FIRST_NAME%TYPE
    , P_LAST_NAME            in RNT_TENANT.LAST_NAME%TYPE
    , P_NOTM                 in RNT_TENANT.NOTM%TYPE
    , P_UNIT_APPLIED_FOR     in RNT_TENANT.UNIT_APPLIED_FOR%TYPE
    , P_AGREEMENT_ID         in RNT_TENANT.AGREEMENT_ID%TYPE
    , P_STATUS               in RNT_TENANT.STATUS%TYPE
    , P_DEPOSIT_BALANCE      in RNT_TENANT.DEPOSIT_BALANCE%TYPE
    , P_LAST_MONTH_BALANCE   in RNT_TENANT.LAST_MONTH_BALANCE%TYPE
    , P_PHONE1               in RNT_TENANT.PHONE1%TYPE
    , P_PHONE2               in RNT_TENANT.PHONE2%TYPE
    , P_EMAIL_ADDRESS        in RNT_TENANT.EMAIL_ADDRESS%TYPE
    , P_SSN                  in RNT_TENANT.SSN%TYPE
    , P_DRIVERS_LICENSE      in RNT_TENANT.DRIVERS_LICENSE%TYPE
    ) return RNT_TENANT.TENANT_ID%TYPE;

  function RECORD_TENANCY_AGREEMENTS
    ( P_UNIT_ID              in RNT_TENANCY_AGREEMENT.UNIT_ID%TYPE
    , P_AGREEMENT_DATE       in RNT_TENANCY_AGREEMENT.AGREEMENT_DATE%TYPE
    , P_NOTM                 in RNT_TENANCY_AGREEMENT.NOTM%TYPE
    , P_TERM                 in RNT_TENANCY_AGREEMENT.TERM%TYPE
    , P_AMOUNT               in RNT_TENANCY_AGREEMENT.AMOUNT%TYPE
    , P_AMOUNT_PERIOD        in RNT_TENANCY_AGREEMENT.AMOUNT_PERIOD%TYPE
    , P_EFFECTIVE_DATE       in RNT_TENANCY_AGREEMENT.EFFECTIVE_DATE%TYPE
    , P_DEPOSIT              in RNT_TENANCY_AGREEMENT.DEPOSIT%TYPE
    , P_LAST_MONTH           in RNT_TENANCY_AGREEMENT.LAST_MONTH%TYPE
    , P_DISCOUNT_AMOUNT      in RNT_TENANCY_AGREEMENT.DISCOUNT_AMOUNT%TYPE
    , P_DISCOUNT_TYPE        in RNT_TENANCY_AGREEMENT.DISCOUNT_TYPE%TYPE
    , P_DISCOUNT_PERIOD      in RNT_TENANCY_AGREEMENT.DISCOUNT_PERIOD%TYPE
    ) return RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE;

  function RNT_AGREEMENT_ACTIONS_DETAILS
    ( P_AGREEMENT_ID      in RNT_AGREEMENT_ACTIONS.AGREEMENT_ID%TYPE
    , P_ACTION_DATE       in RNT_AGREEMENT_ACTIONS.ACTION_DATE%TYPE
    , P_ACTION_TYPE       in RNT_AGREEMENT_ACTIONS.ACTION_TYPE%TYPE
    , P_NOTM              in RNT_AGREEMENT_ACTIONS.NOTM%TYPE
    , P_COMMENTS          in RNT_AGREEMENT_ACTIONS.COMMENTS%TYPE
    ) return RNT_AGREEMENT_ACTIONS.ACTION_ID%TYPE;

end rnt_tenant_mgt;
/

create or replace package body rnt_tenant_mgt
as

 function RNT_TENANT_DETAILS
    ( P_FIRST_NAME           in RNT_TENANT.FIRST_NAME%TYPE
    , P_LAST_NAME            in RNT_TENANT.LAST_NAME%TYPE
    , P_NOTM                 in RNT_TENANT.NOTM%TYPE
    , P_UNIT_APPLIED_FOR     in RNT_TENANT.UNIT_APPLIED_FOR%TYPE
    , P_AGREEMENT_ID         in RNT_TENANT.AGREEMENT_ID%TYPE
    , P_STATUS               in RNT_TENANT.STATUS%TYPE
    , P_DEPOSIT_BALANCE      in RNT_TENANT.DEPOSIT_BALANCE%TYPE
    , P_LAST_MONTH_BALANCE   in RNT_TENANT.LAST_MONTH_BALANCE%TYPE
    , P_PHONE1               in RNT_TENANT.PHONE1%TYPE
    , P_PHONE2               in RNT_TENANT.PHONE2%TYPE
    , P_EMAIL_ADDRESS        in RNT_TENANT.EMAIL_ADDRESS%TYPE
    , P_SSN                  in RNT_TENANT.SSN%TYPE
    , P_DRIVERS_LICENSE      in RNT_TENANT.DRIVERS_LICENSE%TYPE
    ) return RNT_TENANT.TENANT_ID%TYPE is

    cursor cur_update_lock( P_FIRST_NAME           in RNT_TENANT.FIRST_NAME%TYPE
                          , P_LAST_NAME            in RNT_TENANT.LAST_NAME%TYPE) is
      SELECT TENANT_ID
      ,  NOTM
      ,  UNIT_APPLIED_FOR
      ,  AGREEMENT_ID
      ,  STATUS
      ,  DEPOSIT_BALANCE
      ,  LAST_MONTH_BALANCE
      ,  PHONE1
      ,  PHONE2
      ,  EMAIL_ADDRESS
      ,  SSN
      ,  DRIVERS_LICENSE
      FROM RNT_TENANT
      WHERE FIRST_NAME = P_FIRST_NAME
      and    LAST_NAME = P_LAST_NAME 
      for UPDATE ;

    l_return_value                  RNT_TENANT.TENANT_ID%TYPE;

  begin
    l_return_value := null;
    for c_rec in cur_update_lock( P_FIRST_NAME => P_FIRST_NAME
                                , P_LAST_NAME  => P_LAST_NAME) loop

      if c_rec.notm != p_notm 
        then raise notm_mismatch;
      end if;


      l_return_value := c_rec.TENANT_ID;
      update RNT_TENANT set
           NOTM               = P_NOTM + 1
         , UNIT_APPLIED_FOR   = P_UNIT_APPLIED_FOR
         , AGREEMENT_ID       = P_AGREEMENT_ID
         , STATUS             = P_STATUS
         , DEPOSIT_BALANCE    = P_DEPOSIT_BALANCE
         , LAST_MONTH_BALANCE = P_LAST_MONTH_BALANCE
         , PHONE1             = P_PHONE1
         , PHONE2             = P_PHONE2
         , EMAIL_ADDRESS      = P_EMAIL_ADDRESS
         , SSN                = P_SSN
         , DRIVERS_LICENSE    = P_DRIVERS_LICENSE
      where FIRST_NAME = P_FIRST_NAME
      and    LAST_NAME = P_LAST_NAME;

    end loop;

    if l_return_value is null then
       select RNT_TENANT_SEQ.NEXTVAL
              into l_return_value
       from dual;
       insert into RNT_TENANT
        ( TENANT_ID
        , NOTM
        , FIRST_NAME
        , LAST_NAME
        , UNIT_APPLIED_FOR
        , AGREEMENT_ID
        , STATUS
        , DEPOSIT_BALANCE
        , LAST_MONTH_BALANCE
        , PHONE1
        , PHONE2
        , EMAIL_ADDRESS
        , SSN
        , DRIVERS_LICENSE
        ) values
        ( l_return_value
        , 1
        , P_FIRST_NAME
        , P_LAST_NAME
        , P_UNIT_APPLIED_FOR
        , P_AGREEMENT_ID
        , P_STATUS
        , P_DEPOSIT_BALANCE
        , P_LAST_MONTH_BALANCE
        , P_PHONE1
        , P_PHONE2
        , P_EMAIL_ADDRESS
        , P_SSN
        , P_DRIVERS_LICENSE
        );
    end if;
     return l_return_value;
  end RNT_TENANT_DETAILS;





  function RECORD_TENANCY_AGREEMENTS
    ( P_UNIT_ID              in RNT_TENANCY_AGREEMENT.UNIT_ID%TYPE
    , P_AGREEMENT_DATE       in RNT_TENANCY_AGREEMENT.AGREEMENT_DATE%TYPE
    , P_NOTM                 in RNT_TENANCY_AGREEMENT.NOTM%TYPE
    , P_TERM                 in RNT_TENANCY_AGREEMENT.TERM%TYPE
    , P_AMOUNT               in RNT_TENANCY_AGREEMENT.AMOUNT%TYPE
    , P_AMOUNT_PERIOD        in RNT_TENANCY_AGREEMENT.AMOUNT_PERIOD%TYPE
    , P_EFFECTIVE_DATE       in RNT_TENANCY_AGREEMENT.EFFECTIVE_DATE%TYPE
    , P_DEPOSIT              in RNT_TENANCY_AGREEMENT.DEPOSIT%TYPE
    , P_LAST_MONTH           in RNT_TENANCY_AGREEMENT.LAST_MONTH%TYPE
    , P_DISCOUNT_AMOUNT      in RNT_TENANCY_AGREEMENT.DISCOUNT_AMOUNT%TYPE
    , P_DISCOUNT_TYPE        in RNT_TENANCY_AGREEMENT.DISCOUNT_TYPE%TYPE
    , P_DISCOUNT_PERIOD      in RNT_TENANCY_AGREEMENT.DISCOUNT_PERIOD%TYPE
    ) return RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE is

    cursor cur_update_lock( P_UNIT_ID              in RNT_TENANCY_AGREEMENT.UNIT_ID%TYPE
                          , P_AGREEMENT_DATE       in RNT_TENANCY_AGREEMENT.AGREEMENT_DATE%TYPE) is
      SELECT AGREEMENT_ID
      ,  NOTM
      FROM RNT_TENANCY_AGREEMENT
      WHERE  UNIT_ID     = P_UNIT_ID
      and AGREEMENT_DATE = P_AGREEMENT_DATE  
      for UPDATE ;

    l_return_value                  RNT_TENANCY_AGREEMENT.AGREEMENT_ID%TYPE;

  begin
    l_return_value := null;
    for c_rec in cur_update_lock( P_UNIT_ID        => P_UNIT_ID
                                , P_AGREEMENT_DATE => P_AGREEMENT_DATE) loop

      if c_rec.notm != p_notm 
        then raise notm_mismatch;
      end if;

      l_return_value := c_rec.AGREEMENT_ID;
      update RNT_TENANCY_AGREEMENT set
         AGREEMENT_ID = l_return_value 
         , NOTM            = P_NOTM + 1
         , TERM            = P_TERM
         , AMOUNT          = P_AMOUNT
         , AMOUNT_PERIOD   = P_AMOUNT_PERIOD
         , EFFECTIVE_DATE  = P_EFFECTIVE_DATE
         , DEPOSIT         = P_DEPOSIT
         , LAST_MONTH      = P_LAST_MONTH
         , DISCOUNT_AMOUNT = P_DISCOUNT_AMOUNT
         , DISCOUNT_TYPE   = P_DISCOUNT_TYPE
         , DISCOUNT_PERIOD = P_DISCOUNT_PERIOD
      where  UNIT_ID     = P_UNIT_ID
      and AGREEMENT_DATE = P_AGREEMENT_DATE ;

    end loop;
    if l_return_value is null then
       select RNT_TENANCY_AGREEMENT_SEQ.NEXTVAL
              into l_return_value
       from dual;
       insert into RNT_TENANCY_AGREEMENT
        ( AGREEMENT_ID
        , NOTM
        , UNIT_ID
        , AGREEMENT_DATE
        , TERM
        , AMOUNT
        , AMOUNT_PERIOD
        , EFFECTIVE_DATE
        , DEPOSIT
        , LAST_MONTH
        , DISCOUNT_AMOUNT
        , DISCOUNT_TYPE
        , DISCOUNT_PERIOD
        ) values
        ( l_return_value
        , 1
        , P_UNIT_ID
        , P_AGREEMENT_DATE
        , P_TERM
        , P_AMOUNT
        , P_AMOUNT_PERIOD
        , P_EFFECTIVE_DATE
        , P_DEPOSIT
        , P_LAST_MONTH
        , P_DISCOUNT_AMOUNT
        , P_DISCOUNT_TYPE
        , P_DISCOUNT_PERIOD
        );
    end if;
     return l_return_value;
  end RECORD_TENANCY_AGREEMENTS;


  function RNT_AGREEMENT_ACTIONS_DETAILS
    ( P_AGREEMENT_ID      in RNT_AGREEMENT_ACTIONS.AGREEMENT_ID%TYPE
    , P_ACTION_DATE       in RNT_AGREEMENT_ACTIONS.ACTION_DATE%TYPE
    , P_ACTION_TYPE       in RNT_AGREEMENT_ACTIONS.ACTION_TYPE%TYPE
    , P_NOTM              in RNT_AGREEMENT_ACTIONS.NOTM%TYPE
    , P_COMMENTS          in RNT_AGREEMENT_ACTIONS.COMMENTS%TYPE
    ) return RNT_AGREEMENT_ACTIONS.ACTION_ID%TYPE is

    cursor cur_update_lock( P_AGREEMENT_ID      in RNT_AGREEMENT_ACTIONS.AGREEMENT_ID%TYPE
                          , P_ACTION_DATE       in RNT_AGREEMENT_ACTIONS.ACTION_DATE%TYPE
                          , P_ACTION_TYPE       in RNT_AGREEMENT_ACTIONS.ACTION_TYPE%TYPE) is
      SELECT ACTION_ID
      ,  NOTM
      ,  COMMENTS
      FROM RNT_AGREEMENT_ACTIONS
      WHERE AGREEMENT_ID = P_AGREEMENT_ID
      and    ACTION_DATE = P_ACTION_DATE
      and    ACTION_TYPE = P_ACTION_TYPE
      for UPDATE ;

    l_return_value                  RNT_AGREEMENT_ACTIONS.ACTION_ID%TYPE;

  begin
    l_return_value := null;
    for c_rec in cur_update_lock( P_AGREEMENT_ID => P_AGREEMENT_ID
                                , P_ACTION_DATE  => P_ACTION_DATE
                                , P_ACTION_TYPE  => P_ACTION_TYPE) loop

      if c_rec.notm != p_notm 
        then raise notm_mismatch;
      end if;

      l_return_value := c_rec.ACTION_ID;
      update RNT_AGREEMENT_ACTIONS set
           NOTM     = P_NOTM + 1
         , COMMENTS = P_COMMENTS
      WHERE AGREEMENT_ID = P_AGREEMENT_ID
      and    ACTION_DATE = P_ACTION_DATE
      and    ACTION_TYPE = P_ACTION_TYPE;

    end loop;

    if l_return_value is null then
       select RNT_AGREEMENT_ACTIONS_SEQ.NEXTVAL
              into l_return_value
       from dual;
       insert into RNT_AGREEMENT_ACTIONS
        ( ACTION_ID
        , NOTM
        , AGREEMENT_ID
        , ACTION_DATE
        , ACTION_TYPE
        , COMMENTS
        ) values
        ( l_return_value
        , 1
        , P_AGREEMENT_ID
        , P_ACTION_DATE
        , P_ACTION_TYPE
        , P_COMMENTS
        );
    end if;
     return l_return_value;
  end RNT_AGREEMENT_ACTIONS_DETAILS;

end rnt_tenant_mgt;
/
show errors package  rnt_tenant_mgt
show errors package body rnt_tenant_mgt
