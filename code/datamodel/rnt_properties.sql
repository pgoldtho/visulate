create or replace package rnt_property_mgt as

   notm_mismatch            exception;              

  function CREATE_BUSINESS_UNIT
    ( P_BUSINESS_NAME in RNT_BUSINESS_UNITS.BUSINESS_NAME%TYPE
    ) return RNT_BUSINESS_UNITS.BUSINESS_ID%TYPE;

  procedure UPDATE_BUSINESS_UNIT
    ( P_BUSINESS_ID       in RNT_BUSINESS_UNITS.BUSINESS_ID%TYPE
    , P_BUSINESS_NAME     in RNT_BUSINESS_UNITS.BUSINESS_NAME%TYPE
    , P_NOTM              in RNT_PROPERTIES.NOTM%TYPE);

  procedure DELETE_BUSINESS_UNIT
    ( P_BUSINESS_ID       in RNT_BUSINESS_UNITS.BUSINESS_ID%TYPE
    , P_NOTM              in RNT_PROPERTIES.NOTM%TYPE);


function CREATE_PROPERTY
    ( P_BUSINESS_ID        in RNT_PROPERTIES.BUSINESS_ID%TYPE
    , P_UNITS              in RNT_PROPERTIES.UNITS%TYPE
    , P_ADDRESS1           in RNT_PROPERTIES.ADDRESS1%TYPE
    , P_ADDRESS2           in RNT_PROPERTIES.ADDRESS2%TYPE
    , P_CITY               in RNT_PROPERTIES.CITY%TYPE
    , P_STATE              in RNT_PROPERTIES.STATE%TYPE
    , P_ZIPCODE            in RNT_PROPERTIES.ZIPCODE%TYPE
    , P_DATE_PURCHASED     in RNT_PROPERTIES.DATE_PURCHASED%TYPE
    , P_PURCHASE_PRICE     in RNT_PROPERTIES.PURCHASE_PRICE%TYPE
    , P_LAND_VALUE         in RNT_PROPERTIES.LAND_VALUE%TYPE
    , P_DEPRECIATION_TERM  in RNT_PROPERTIES.DEPRECIATION_TERM%TYPE
    , P_YEAR_BUILT         in RNT_PROPERTIES.YEAR_BUILT%TYPE     default null
    , P_BUILDING_SIZE      in RNT_PROPERTIES.BUILDING_SIZE%TYPE  default null
    , P_LOT_SIZE           in RNT_PROPERTIES.LOT_SIZE%TYPE       default null
    , P_DATE_SOLD          in RNT_PROPERTIES.DATE_SOLD%TYPE      default null
    , P_SALE_AMOUNT        in RNT_PROPERTIES.SALE_AMOUNT%TYPE    default null
    , P_NOTE_YN            in RNT_PROPERTIES.NOTE_YN%TYPE        default null
    ) return RNT_PROPERTIES.PROPERTY_ID%TYPE;

 procedure UPDATE_PROPERTY 
    ( P_PROPERTY_ID       in RNT_PROPERTIES.PROPERTY_ID%TYPE
    , P_BUSINESS_ID       in RNT_PROPERTIES.BUSINESS_ID%TYPE
    , P_UNITS             in RNT_PROPERTIES.UNITS%TYPE
    , P_NOTM              in RNT_PROPERTIES.NOTM%TYPE
    , P_ADDRESS1          in RNT_PROPERTIES.ADDRESS1%TYPE
    , P_ADDRESS2          in RNT_PROPERTIES.ADDRESS2%TYPE
    , P_CITY              in RNT_PROPERTIES.CITY%TYPE
    , P_STATE             in RNT_PROPERTIES.STATE%TYPE
    , P_ZIPCODE           in RNT_PROPERTIES.ZIPCODE%TYPE
    , P_DATE_PURCHASED    in RNT_PROPERTIES.DATE_PURCHASED%TYPE
    , P_PURCHASE_PRICE    in RNT_PROPERTIES.PURCHASE_PRICE%TYPE
    , P_LAND_VALUE        in RNT_PROPERTIES.LAND_VALUE%TYPE
    , P_DEPRECIATION_TERM in RNT_PROPERTIES.DEPRECIATION_TERM%TYPE
    , P_YEAR_BUILT        in RNT_PROPERTIES.YEAR_BUILT%TYPE     default null
    , P_BUILDING_SIZE     in RNT_PROPERTIES.BUILDING_SIZE%TYPE  default null
    , P_LOT_SIZE          in RNT_PROPERTIES.LOT_SIZE%TYPE       default null
    , P_DATE_SOLD         in RNT_PROPERTIES.DATE_SOLD%TYPE      default null
    , P_SALE_AMOUNT       in RNT_PROPERTIES.SALE_AMOUNT%TYPE    default null
    , P_NOTE_YN           in RNT_PROPERTIES.NOTE_YN%TYPE        default null
    );

  procedure DELETE_PROPERTY
    ( P_PROPERTY_ID       in RNT_PROPERTIES.PROPERTY_ID%TYPE
    , P_NOTM              in RNT_PROPERTIES.NOTM%TYPE);

  function RECORD_PROPERTY_UNITS
    ( P_PROPERTY_ID in RNT_PROPERTY_UNITS.PROPERTY_ID%TYPE
    , P_UNIT_NAME   in RNT_PROPERTY_UNITS.UNIT_NAME%TYPE
    , P_NOTM        in RNT_PROPERTY_UNITS.NOTM%TYPE
    , P_UNIT_SIZE   in RNT_PROPERTY_UNITS.UNIT_SIZE%TYPE
    , P_BEDROOMS    in RNT_PROPERTY_UNITS.BEDROOMS%TYPE
    , P_BATHROOMS   in RNT_PROPERTY_UNITS.BATHROOMS%TYPE
    ) return RNT_PROPERTY_UNITS.UNIT_ID%TYPE;

  function RECORD_PROPERTY_VALUE
    ( P_PROPERTY_ID      in RNT_PROPERTY_VALUE.PROPERTY_ID%TYPE
    , P_VALUE_DATE       in RNT_PROPERTY_VALUE.VALUE_DATE%TYPE
    , P_VALUE_METHOD     in RNT_PROPERTY_VALUE.VALUE_METHOD%TYPE
    , P_NOTM             in RNT_PROPERTY_VALUE.NOTM%TYPE
    , P_VALUE            in RNT_PROPERTY_VALUE.VALUE%TYPE
    , P_CAP_RATE         in RNT_PROPERTY_VALUE.CAP_RATE%TYPE
    ) return RNT_PROPERTY_VALUE.VALUE_ID%TYPE;

  function RECORD_PROPERTY_EXPENSES
    ( P_PROPERTY_ID        in RNT_PROPERTY_EXPENSES.PROPERTY_ID%TYPE
    , P_EVENT_DATE         in RNT_PROPERTY_EXPENSES.EVENT_DATE%TYPE
    , P_DESCRIPTION        in RNT_PROPERTY_EXPENSES.DESCRIPTION%TYPE
    , P_NOTM               in RNT_PROPERTY_EXPENSES.NOTM%TYPE
    , P_RECURRING_YN       in RNT_PROPERTY_EXPENSES.RECURRING_YN%TYPE
    , P_RECURRING_PERIOD   in RNT_PROPERTY_EXPENSES.RECURRING_PERIOD%TYPE
    , P_RECURRING_ENDDATE  in RNT_PROPERTY_EXPENSES.RECURRING_ENDDATE%TYPE
    , P_UNIT_ID            in RNT_PROPERTY_EXPENSES.UNIT_ID%TYPE
    ) return RNT_PROPERTY_EXPENSES.EXPENSE_ID%TYPE;

  function RECORD_LOANS
    ( P_PROPERTY_ID        in RNT_LOANS.PROPERTY_ID%TYPE
    , P_POSITION           in RNT_LOANS.POSITION%TYPE
    , P_NOTM               in RNT_LOANS.NOTM%TYPE
    , P_LOAN_DATE          in RNT_LOANS.LOAN_DATE%TYPE
    , P_LOAN_AMOUNT        in RNT_LOANS.LOAN_AMOUNT%TYPE
    , P_TERM               in RNT_LOANS.TERM%TYPE
    , P_INTEREST_RATE      in RNT_LOANS.INTEREST_RATE%TYPE
    , P_CREDIT_LINE_YN     in RNT_LOANS.CREDIT_LINE_YN%TYPE
    , P_ARM_YN             in RNT_LOANS.ARM_YN%TYPE
    , P_BALLOON_DATE       in RNT_LOANS.BALLOON_DATE%TYPE
    , P_AMORTIZATION_START in RNT_LOANS.AMORTIZATION_START%TYPE
    , P_SETTLEMENT_DATE    in RNT_LOANS.SETTLEMENT_DATE%TYPE
    ) return RNT_LOANS.LOAN_ID%TYPE;



end rnt_property_mgt;
/



create or replace package body rnt_property_mgt as

  function CREATE_BUSINESS_UNIT
    ( P_BUSINESS_NAME in RNT_BUSINESS_UNITS.BUSINESS_NAME%TYPE
    ) return RNT_BUSINESS_UNITS.BUSINESS_ID%TYPE is

    l_return_value                  RNT_BUSINESS_UNITS.BUSINESS_ID%TYPE;

  begin

       select RNT_BUSINESS_UNITS_SEQ.NEXTVAL
       into l_return_value
       from dual;

      insert into RNT_BUSINESS_UNITS
      ( BUSINESS_ID
      , BUSINESS_NAME
      , NOTM )
      values
      ( l_return_value
      , P_BUSINESS_NAME
      , 1);

     return l_return_value;
  end CREATE_BUSINESS_UNIT;


  procedure UPDATE_BUSINESS_UNIT
    ( P_BUSINESS_ID       in RNT_BUSINESS_UNITS.BUSINESS_ID%TYPE
    , P_BUSINESS_NAME     in RNT_BUSINESS_UNITS.BUSINESS_NAME%TYPE
    , P_NOTM              in RNT_PROPERTIES.NOTM%TYPE) is

      l_notm              RNT_BUSINESS_UNITS.NOTM%TYPE;
  begin
      select notm
      into l_notm
      from rnt_business_units
      where business_id = p_business_id
      for update;

      if l_notm != p_notm 
        then raise notm_mismatch;
      end if;

     update RNT_BUSINESS_UNITS
     set BUSINESS_NAME = P_BUSINESS_NAME
     ,   NOTM          = P_NOTM + 1
     where BUSINESS_ID = P_BUSINESS_ID;

  end UPDATE_BUSINESS_UNIT;

  procedure DELETE_BUSINESS_UNIT
    ( P_BUSINESS_ID       in RNT_BUSINESS_UNITS.BUSINESS_ID%TYPE
    , P_NOTM              in RNT_PROPERTIES.NOTM%TYPE) is

      l_notm              RNT_BUSINESS_UNITS.NOTM%TYPE;
  begin
      select notm
      into l_notm
      from rnt_business_units
      where business_id = p_business_id
      for update;

      if l_notm != p_notm 
        then raise notm_mismatch;
      end if;

     delete from RNT_BUSINESS_UNITS
     where BUSINESS_ID = P_BUSINESS_ID;

  end DELETE_BUSINESS_UNIT;

function CREATE_PROPERTY
    ( P_BUSINESS_ID        in RNT_PROPERTIES.BUSINESS_ID%TYPE
    , P_UNITS              in RNT_PROPERTIES.UNITS%TYPE
    , P_ADDRESS1           in RNT_PROPERTIES.ADDRESS1%TYPE
    , P_ADDRESS2           in RNT_PROPERTIES.ADDRESS2%TYPE
    , P_CITY               in RNT_PROPERTIES.CITY%TYPE
    , P_STATE              in RNT_PROPERTIES.STATE%TYPE
    , P_ZIPCODE            in RNT_PROPERTIES.ZIPCODE%TYPE
    , P_DATE_PURCHASED     in RNT_PROPERTIES.DATE_PURCHASED%TYPE
    , P_PURCHASE_PRICE     in RNT_PROPERTIES.PURCHASE_PRICE%TYPE
    , P_LAND_VALUE         in RNT_PROPERTIES.LAND_VALUE%TYPE
    , P_DEPRECIATION_TERM  in RNT_PROPERTIES.DEPRECIATION_TERM%TYPE
    , P_YEAR_BUILT         in RNT_PROPERTIES.YEAR_BUILT%TYPE     default null
    , P_BUILDING_SIZE      in RNT_PROPERTIES.BUILDING_SIZE%TYPE  default null
    , P_LOT_SIZE           in RNT_PROPERTIES.LOT_SIZE%TYPE       default null
    , P_DATE_SOLD          in RNT_PROPERTIES.DATE_SOLD%TYPE      default null
    , P_SALE_AMOUNT        in RNT_PROPERTIES.SALE_AMOUNT%TYPE    default null
    , P_NOTE_YN            in RNT_PROPERTIES.NOTE_YN%TYPE        default null
    ) return RNT_PROPERTIES.PROPERTY_ID%TYPE is


    l_return_value                  RNT_PROPERTIES.PROPERTY_ID%TYPE;

  begin

       select RNT_PROPERTIES_SEQ.NEXTVAL
        into l_return_value
       from dual;

       insert into RNT_PROPERTIES
        ( PROPERTY_ID
        , BUSINESS_ID
        , UNITS
        , ADDRESS1
        , ADDRESS2
        , CITY
        , STATE
        , ZIPCODE
        , DATE_PURCHASED
        , PURCHASE_PRICE
        , LAND_VALUE
        , DEPRECIATION_TERM
        , YEAR_BUILT
        , BUILDING_SIZE
        , LOT_SIZE
        , DATE_SOLD
        , SALE_AMOUNT
        , NOTE_YN
        , NOTM
        ) values
        ( l_return_value
        , P_BUSINESS_ID
        , P_UNITS
        , P_ADDRESS1
        , P_ADDRESS2
        , P_CITY
        , P_STATE
        , P_ZIPCODE
        , P_DATE_PURCHASED
        , P_PURCHASE_PRICE
        , P_LAND_VALUE
        , P_DEPRECIATION_TERM
        , P_YEAR_BUILT
        , P_BUILDING_SIZE
        , P_LOT_SIZE
        , P_DATE_SOLD
        , P_SALE_AMOUNT
        , P_NOTE_YN
        , 1
        );

     return l_return_value;
  end CREATE_PROPERTY;

 procedure UPDATE_PROPERTY 
    ( P_PROPERTY_ID       in RNT_PROPERTIES.PROPERTY_ID%TYPE
    , P_BUSINESS_ID       in RNT_PROPERTIES.BUSINESS_ID%TYPE
    , P_UNITS             in RNT_PROPERTIES.UNITS%TYPE
    , P_NOTM              in RNT_PROPERTIES.NOTM%TYPE
    , P_ADDRESS1          in RNT_PROPERTIES.ADDRESS1%TYPE
    , P_ADDRESS2          in RNT_PROPERTIES.ADDRESS2%TYPE
    , P_CITY              in RNT_PROPERTIES.CITY%TYPE
    , P_STATE             in RNT_PROPERTIES.STATE%TYPE
    , P_ZIPCODE           in RNT_PROPERTIES.ZIPCODE%TYPE
    , P_DATE_PURCHASED    in RNT_PROPERTIES.DATE_PURCHASED%TYPE
    , P_PURCHASE_PRICE    in RNT_PROPERTIES.PURCHASE_PRICE%TYPE
    , P_LAND_VALUE        in RNT_PROPERTIES.LAND_VALUE%TYPE
    , P_DEPRECIATION_TERM in RNT_PROPERTIES.DEPRECIATION_TERM%TYPE
    , P_YEAR_BUILT        in RNT_PROPERTIES.YEAR_BUILT%TYPE     default null
    , P_BUILDING_SIZE     in RNT_PROPERTIES.BUILDING_SIZE%TYPE  default null
    , P_LOT_SIZE          in RNT_PROPERTIES.LOT_SIZE%TYPE       default null
    , P_DATE_SOLD         in RNT_PROPERTIES.DATE_SOLD%TYPE      default null
    , P_SALE_AMOUNT       in RNT_PROPERTIES.SALE_AMOUNT%TYPE    default null
    , P_NOTE_YN           in RNT_PROPERTIES.NOTE_YN%TYPE        default null
    ) is

      l_notm             RNT_PROPERTIES.NOTM%TYPE;
  begin
      select notm
      into l_notm
      from rnt_properties
      where property_id = P_PROPERTY_ID
      for update;

      if l_notm != p_notm 
        then raise notm_mismatch;
      end if;
      
      update RNT_PROPERTIES set
           BUSINESS_ID       = P_BUSINESS_ID
         , UNITS             = P_UNITS
         , ADDRESS1          = P_ADDRESS1
         , ADDRESS2          = P_ADDRESS2
         , CITY              = P_CITY
         , STATE             = P_STATE
         , ZIPCODE           = P_ZIPCODE
         , DATE_PURCHASED    = P_DATE_PURCHASED
         , PURCHASE_PRICE    = P_PURCHASE_PRICE
         , LAND_VALUE        = P_LAND_VALUE
         , DEPRECIATION_TERM = P_DEPRECIATION_TERM
         , YEAR_BUILT        = P_YEAR_BUILT
         , BUILDING_SIZE     = P_BUILDING_SIZE
         , LOT_SIZE          = P_LOT_SIZE
         , DATE_SOLD         = P_DATE_SOLD
         , SALE_AMOUNT       = P_SALE_AMOUNT
         , NOTE_YN           = P_NOTE_YN
         , NOTM              = P_NOTM + 1
      where property_id = P_PROPERTY_ID;

  end UPDATE_PROPERTY;

  procedure DELETE_PROPERTY
    ( P_PROPERTY_ID       in RNT_PROPERTIES.PROPERTY_ID%TYPE
    , P_NOTM              in RNT_PROPERTIES.NOTM%TYPE) is

      l_notm             RNT_PROPERTIES.NOTM%TYPE;
  begin
      select notm
      into l_notm
      from rnt_properties
      where property_id = P_PROPERTY_ID
      for update;


      if l_notm != p_notm 
        then raise notm_mismatch;
      end if;

      delete from rnt_properties
      where property_id = P_PROPERTY_ID;

  end DELETE_PROPERTY;




  function RECORD_PROPERTY_UNITS
    ( P_PROPERTY_ID in RNT_PROPERTY_UNITS.PROPERTY_ID%TYPE
    , P_UNIT_NAME   in RNT_PROPERTY_UNITS.UNIT_NAME%TYPE
    , P_NOTM        in RNT_PROPERTY_UNITS.NOTM%TYPE
    , P_UNIT_SIZE   in RNT_PROPERTY_UNITS.UNIT_SIZE%TYPE
    , P_BEDROOMS    in RNT_PROPERTY_UNITS.BEDROOMS%TYPE
    , P_BATHROOMS   in RNT_PROPERTY_UNITS.BATHROOMS%TYPE
    ) return RNT_PROPERTY_UNITS.UNIT_ID%TYPE is

    cursor cur_update_lock( P_PROPERTY_ID in RNT_PROPERTY_UNITS.PROPERTY_ID%TYPE
                          , P_UNIT_NAME   in RNT_PROPERTY_UNITS.UNIT_NAME%TYPE) is
      SELECT UNIT_ID
      ,  UNIT_SIZE
      ,  BEDROOMS
      ,  BATHROOMS
      ,  NOTM
      FROM RNT_PROPERTY_UNITS
      WHERE PROPERTY_ID = P_PROPERTY_ID
      AND     UNIT_NAME = P_UNIT_NAME
      for UPDATE ;

    l_return_value                  RNT_PROPERTY_UNITS.UNIT_ID%TYPE;

  begin
    l_return_value := null;
    for c_rec in cur_update_lock( P_PROPERTY_ID => P_PROPERTY_ID
                                , P_UNIT_NAME   => P_UNIT_NAME) loop
      if c_rec.notm != p_notm 
        then raise notm_mismatch;
      end if;

      l_return_value := c_rec.UNIT_ID;
      update RNT_PROPERTY_UNITS set
           UNIT_SIZE = P_UNIT_SIZE
         , BEDROOMS  = P_BEDROOMS
         , BATHROOMS = P_BATHROOMS
         , NOTM = P_NOTM + 1
      where PROPERTY_ID = P_PROPERTY_ID
      AND     UNIT_NAME = P_UNIT_NAME;

    end loop;

    if l_return_value is null then
       select RNT_PROPERTY_UNITS_SEQ.NEXTVAL
              into l_return_value
       from dual;

       insert into RNT_PROPERTY_UNITS
        ( UNIT_ID
        , PROPERTY_ID
        , UNIT_NAME
        , UNIT_SIZE
        , BEDROOMS
        , BATHROOMS
        , NOTM
        ) values
        ( l_return_value
        , P_PROPERTY_ID
        , P_UNIT_NAME
        , P_UNIT_SIZE
        , P_BEDROOMS
        , P_BATHROOMS
        , 1
        );
    end if;
     return l_return_value;
  end RECORD_PROPERTY_UNITS;


  function RECORD_PROPERTY_VALUE
    ( P_PROPERTY_ID      in RNT_PROPERTY_VALUE.PROPERTY_ID%TYPE
    , P_VALUE_DATE       in RNT_PROPERTY_VALUE.VALUE_DATE%TYPE
    , P_VALUE_METHOD     in RNT_PROPERTY_VALUE.VALUE_METHOD%TYPE
    , P_NOTM             in RNT_PROPERTY_VALUE.NOTM%TYPE
    , P_VALUE            in RNT_PROPERTY_VALUE.VALUE%TYPE
    , P_CAP_RATE         in RNT_PROPERTY_VALUE.CAP_RATE%TYPE
    ) return RNT_PROPERTY_VALUE.VALUE_ID%TYPE is

    cursor cur_update_lock( P_PROPERTY_ID      in RNT_PROPERTY_VALUE.PROPERTY_ID%TYPE
                          , P_VALUE_DATE       in RNT_PROPERTY_VALUE.VALUE_DATE%TYPE
                          , P_VALUE_METHOD     in RNT_PROPERTY_VALUE.VALUE_METHOD%TYPE) is
      SELECT VALUE_ID
      ,  NOTM
      ,  VALUE
      FROM RNT_PROPERTY_VALUE
      WHERE PROPERTY_ID  = P_PROPERTY_ID
      AND   VALUE_DATE   = P_VALUE_DATE  
      AND   VALUE_METHOD = P_VALUE_METHOD     
      for UPDATE ;

    l_return_value                  RNT_PROPERTY_VALUE.VALUE_ID%TYPE;

  begin
    l_return_value := null;

    for c_rec in cur_update_lock( P_PROPERTY_ID  => P_PROPERTY_ID
                                , P_VALUE_DATE   => P_VALUE_DATE 
                                , P_VALUE_METHOD => P_VALUE_METHOD) loop
      l_return_value := c_rec.VALUE_ID;

      if c_rec.notm != p_notm 
         then raise notm_mismatch;
      end if;

      update RNT_PROPERTY_VALUE set
           NOTM          = P_NOTM + 1
         , VALUE         = P_VALUE
         , CAP_RATE      = P_CAP_RATE
      where PROPERTY_ID  = P_PROPERTY_ID
      AND   VALUE_DATE   = P_VALUE_DATE  
      AND   VALUE_METHOD = P_VALUE_METHOD;

    end loop;

    if l_return_value is null then
       select RNT_PROPERTY_VALUE_SEQ.NEXTVAL
              into l_return_value
       from dual;
       insert into RNT_PROPERTY_VALUE
        ( VALUE_ID
        , NOTM
        , PROPERTY_ID
        , VALUE_DATE
        , VALUE_METHOD
        , VALUE
        , CAP_RATE
        ) values
        ( l_return_value 
        , 1
        , P_PROPERTY_ID
        , P_VALUE_DATE
        , P_VALUE_METHOD
        , P_VALUE
        , P_CAP_RATE
        );
    end if;
     return l_return_value;
  end RECORD_PROPERTY_VALUE;



  function RECORD_PROPERTY_EXPENSES
    ( P_PROPERTY_ID        in RNT_PROPERTY_EXPENSES.PROPERTY_ID%TYPE
    , P_EVENT_DATE         in RNT_PROPERTY_EXPENSES.EVENT_DATE%TYPE
    , P_DESCRIPTION        in RNT_PROPERTY_EXPENSES.DESCRIPTION%TYPE
    , P_NOTM               in RNT_PROPERTY_EXPENSES.NOTM%TYPE
    , P_RECURRING_YN       in RNT_PROPERTY_EXPENSES.RECURRING_YN%TYPE
    , P_RECURRING_PERIOD   in RNT_PROPERTY_EXPENSES.RECURRING_PERIOD%TYPE
    , P_RECURRING_ENDDATE  in RNT_PROPERTY_EXPENSES.RECURRING_ENDDATE%TYPE
    , P_UNIT_ID            in RNT_PROPERTY_EXPENSES.UNIT_ID%TYPE
    ) return RNT_PROPERTY_EXPENSES.EXPENSE_ID%TYPE is

    cursor cur_update_lock( P_PROPERTY_ID        in RNT_PROPERTY_EXPENSES.PROPERTY_ID%TYPE
                          , P_EVENT_DATE         in RNT_PROPERTY_EXPENSES.EVENT_DATE%TYPE
                          , P_DESCRIPTION        in RNT_PROPERTY_EXPENSES.DESCRIPTION%TYPE) is
      SELECT EXPENSE_ID
      ,      NOTM
      FROM RNT_PROPERTY_EXPENSES
      WHERE PROPERTY_ID = P_PROPERTY_ID
      and  EVENT_DATE   = P_EVENT_DATE
      and  DESCRIPTION  = P_DESCRIPTION
      for UPDATE ;

    l_return_value                  RNT_PROPERTY_EXPENSES.EXPENSE_ID%TYPE;

  begin
    l_return_value := null;
    for c_rec in cur_update_lock( P_PROPERTY_ID  => P_PROPERTY_ID
                                , P_EVENT_DATE   => P_EVENT_DATE
                                , P_DESCRIPTION  => P_DESCRIPTION) loop
      l_return_value := c_rec.EXPENSE_ID ;

      if c_rec.notm != p_notm 
         then raise notm_mismatch;
      end if;

      update RNT_PROPERTY_EXPENSES set
           NOTM               = P_NOTM + 1 
         , UNIT_ID            = P_UNIT_ID
         , RECURRING_YN       = P_RECURRING_YN
         , RECURRING_PERIOD   = P_RECURRING_PERIOD
         , RECURRING_ENDDATE = P_RECURRING_ENDDATE
      where PROPERTY_ID = P_PROPERTY_ID
      and  EVENT_DATE   = P_EVENT_DATE
      and  DESCRIPTION  = P_DESCRIPTION;

    end loop;

    if l_return_value is null then
       select RNT_PROPERTY_EXPENSES_SEQ.NEXTVAL
              into l_return_value
       from dual;
       insert into RNT_PROPERTY_EXPENSES
        ( EXPENSE_ID
        , NOTM
        , PROPERTY_ID
        , EVENT_DATE
        , DESCRIPTION
        , UNIT_ID
        , RECURRING_YN
        , RECURRING_PERIOD
        , RECURRING_ENDDATE
        ) values
        ( l_return_value
        , 1
        , P_PROPERTY_ID
        , P_EVENT_DATE
        , P_DESCRIPTION
        , P_UNIT_ID
        , P_RECURRING_YN
        , P_RECURRING_PERIOD
        , P_RECURRING_ENDDATE
        );
    end if;
     return l_return_value;
  end RECORD_PROPERTY_EXPENSES;


  function RECORD_LOANS
    ( P_PROPERTY_ID        in RNT_LOANS.PROPERTY_ID%TYPE
    , P_POSITION           in RNT_LOANS.POSITION%TYPE
    , P_NOTM               in RNT_LOANS.NOTM%TYPE
    , P_LOAN_DATE          in RNT_LOANS.LOAN_DATE%TYPE
    , P_LOAN_AMOUNT        in RNT_LOANS.LOAN_AMOUNT%TYPE
    , P_TERM               in RNT_LOANS.TERM%TYPE
    , P_INTEREST_RATE      in RNT_LOANS.INTEREST_RATE%TYPE
    , P_CREDIT_LINE_YN     in RNT_LOANS.CREDIT_LINE_YN%TYPE
    , P_ARM_YN             in RNT_LOANS.ARM_YN%TYPE
    , P_BALLOON_DATE       in RNT_LOANS.BALLOON_DATE%TYPE
    , P_AMORTIZATION_START in RNT_LOANS.AMORTIZATION_START%TYPE
    , P_SETTLEMENT_DATE    in RNT_LOANS.SETTLEMENT_DATE%TYPE
    ) return RNT_LOANS.LOAN_ID%TYPE is

    cursor cur_update_lock( P_PROPERTY_ID  in RNT_LOANS.PROPERTY_ID%TYPE
                          , P_POSITION     in RNT_LOANS.POSITION%TYPE) is
      SELECT LOAN_ID
      ,  NOTM
      ,  LOAN_DATE
      ,  LOAN_AMOUNT
      ,  TERM
      ,  INTEREST_RATE
      ,  CREDIT_LINE_YN
      ,  ARM_YN
      ,  BALLOON_DATE
      ,  PROPERTY_ID
      ,  POSITION
      ,  AMORTIZATION_START
      FROM RNT_LOANS
      WHERE PROPERTY_ID = P_PROPERTY_ID
      and   POSITION    = P_POSITION
      for UPDATE ;

    l_return_value                  RNT_LOANS.LOAN_ID %TYPE;

  begin
    l_return_value := null;
    for c_rec in cur_update_lock( P_PROPERTY_ID => P_PROPERTY_ID
                                , P_POSITION    => P_POSITION) loop


      if c_rec.notm != p_notm 
         then raise notm_mismatch;
      end if;

      l_return_value := c_rec.LOAN_ID;
      update RNT_LOANS set
           NOTM               = P_NOTM + 1
         , LOAN_DATE          = P_LOAN_DATE
         , LOAN_AMOUNT        = P_LOAN_AMOUNT
         , TERM               = P_TERM
         , INTEREST_RATE      = P_INTEREST_RATE
         , CREDIT_LINE_YN     = P_CREDIT_LINE_YN
         , ARM_YN             = P_ARM_YN
         , BALLOON_DATE       = P_BALLOON_DATE
         , AMORTIZATION_START = P_AMORTIZATION_START
         , SETTLEMENT_DATE    = P_SETTLEMENT_DATE
      where PROPERTY_ID       = P_PROPERTY_ID
      and   POSITION          = P_POSITION;

    end loop;

    if l_return_value is null then
       select RNT_LOANS_SEQ.NEXTVAL
              into l_return_value
       from dual;
       insert into RNT_LOANS
        ( LOAN_ID
        , NOTM
        , LOAN_DATE
        , LOAN_AMOUNT
        , TERM
        , INTEREST_RATE
        , CREDIT_LINE_YN
        , ARM_YN
        , BALLOON_DATE
        , PROPERTY_ID
        , POSITION
        , AMORTIZATION_START
        , SETTLEMENT_DATE
        ) values
        ( l_return_value 
        , 1
        , P_LOAN_DATE
        , P_LOAN_AMOUNT
        , P_TERM
        , P_INTEREST_RATE
        , P_CREDIT_LINE_YN
        , P_ARM_YN
        , P_BALLOON_DATE
        , P_PROPERTY_ID
        , P_POSITION
        , P_AMORTIZATION_START
        , P_SETTLEMENT_DATE
        );
    end if;
     return l_return_value;
  end RECORD_LOANS;


end RNT_PROPERTY_MGT;
/

show errors package RNT_PROPERTY_MGT
show errors package body RNT_PROPERTY_MGT
