create or replace package PR_PROPERTY_LISTINGS_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007, 2009        All rights reserved worldwide
    Name:      PR_PROPERTY_LISTINGS_PKG
    Purpose:   API's for PR_PROPERTY_LISTINGS table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        25-NOV-09   Auto Generated   Initial Version
*******************************************************************************/
  function get_checksum( X_PROP_ID IN PR_PROPERTY_LISTINGS.PROP_ID%TYPE
                       , X_BUSINESS_ID IN PR_PROPERTY_LISTINGS.BUSINESS_ID%TYPE)
            return PR_PROPERTY_LISTINGS_V.CHECKSUM%TYPE;

  procedure update_row( X_PROP_ID IN PR_PROPERTY_LISTINGS.PROP_ID%TYPE
                      , X_BUSINESS_ID IN PR_PROPERTY_LISTINGS.BUSINESS_ID%TYPE
                      , X_LISTING_DATE IN PR_PROPERTY_LISTINGS.LISTING_DATE%TYPE
                      , X_PRICE IN PR_PROPERTY_LISTINGS.PRICE%TYPE
                      , X_PUBLISH_YN IN PR_PROPERTY_LISTINGS.PUBLISH_YN%TYPE
                      , X_SOLD_YN IN PR_PROPERTY_LISTINGS.SOLD_YN%TYPE
                      , X_DESCRIPTION IN PR_PROPERTY_LISTINGS.DESCRIPTION%TYPE
                      , X_SOURCE IN PR_PROPERTY_LISTINGS.SOURCE%TYPE
                      , X_AGENT_NAME IN PR_PROPERTY_LISTINGS.AGENT_NAME%TYPE
                      , X_AGENT_PHONE IN PR_PROPERTY_LISTINGS.AGENT_PHONE%TYPE
                      , X_AGENT_EMAIL IN PR_PROPERTY_LISTINGS.AGENT_EMAIL%TYPE
                      , X_AGENT_WEBSITE IN PR_PROPERTY_LISTINGS.AGENT_WEBSITE%TYPE
                      , X_CHECKSUM IN PR_PROPERTY_LISTINGS_V.CHECKSUM%TYPE);

  PROCEDURE insert_row( X_PROP_ID       IN PR_PROPERTIES.PROP_ID%TYPE
                     , X_BUSINESS_ID   IN PR_PROPERTY_LISTINGS.BUSINESS_ID%TYPE
                     , X_LISTING_DATE  IN PR_PROPERTY_LISTINGS.LISTING_DATE%TYPE
                     , X_PRICE         IN PR_PROPERTY_LISTINGS.PRICE%TYPE
                     , X_PUBLISH_YN    IN PR_PROPERTY_LISTINGS.PUBLISH_YN%TYPE
                     , X_SOLD_YN       IN PR_PROPERTY_LISTINGS.SOLD_YN%TYPE
                     , X_DESCRIPTION   IN PR_PROPERTY_LISTINGS.DESCRIPTION%TYPE
                     , X_SOURCE        IN PR_PROPERTY_LISTINGS.SOURCE%TYPE
                     , X_AGENT_NAME    IN PR_PROPERTY_LISTINGS.AGENT_NAME%TYPE
                     , X_AGENT_PHONE   IN PR_PROPERTY_LISTINGS.AGENT_PHONE%TYPE
                     , X_AGENT_EMAIL   IN PR_PROPERTY_LISTINGS.AGENT_EMAIL%TYPE
                     , X_AGENT_WEBSITE IN PR_PROPERTY_LISTINGS.AGENT_WEBSITE%TYPE);

  procedure delete_row( X_PROP_ID IN PR_PROPERTY_LISTINGS.PROP_ID%TYPE
                       , X_BUSINESS_ID IN PR_PROPERTY_LISTINGS.BUSINESS_ID%TYPE);

end PR_PROPERTY_LISTINGS_PKG;
/
create or replace package body PR_PROPERTY_LISTINGS_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007, 2009        All rights reserved worldwide
    Name:      PR_PROPERTY_LISTINGS_PKG
    Purpose:   API's for PR_PROPERTY_LISTINGS table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        25-NOV-09   Auto Generated   Initial Version

********************************************************************************/
-------------------------------------------------
--  Private Procedures and Functions
-------------------------------------------------


  procedure lock_row( X_PROP_ID IN PR_PROPERTY_LISTINGS.PROP_ID%TYPE
                    , X_BUSINESS_ID IN PR_PROPERTY_LISTINGS.BUSINESS_ID%TYPE) is
     cursor c is
     select * from PR_PROPERTY_LISTINGS
     where PROP_ID = X_PROP_ID
    and BUSINESS_ID = X_BUSINESS_ID
     for update nowait;

  begin
    open c;
    close c;
  exception
    when OTHERS then
      if SQLCODE = -54 then
        RAISE_APPLICATION_ERROR(-20001, 'Cannot change record. Record is locked.');
      end if;
  end lock_row;

-------------------------------------------------
--  Public Procedures and Functions
-------------------------------------------------
  function get_checksum( X_PROP_ID IN PR_PROPERTY_LISTINGS.PROP_ID%TYPE
                       , X_BUSINESS_ID IN PR_PROPERTY_LISTINGS.BUSINESS_ID%TYPE)
            return PR_PROPERTY_LISTINGS_V.CHECKSUM%TYPE is

    v_return_value               PR_PROPERTY_LISTINGS_V.CHECKSUM%TYPE;
  begin
    select CHECKSUM
    into v_return_value
    from PR_PROPERTY_LISTINGS_V
    where PROP_ID = X_PROP_ID
    and BUSINESS_ID = X_BUSINESS_ID;
    return v_return_value;
  end get_checksum;

  procedure update_row( X_PROP_ID IN PR_PROPERTY_LISTINGS.PROP_ID%TYPE
                      , X_BUSINESS_ID IN PR_PROPERTY_LISTINGS.BUSINESS_ID%TYPE
                      , X_LISTING_DATE IN PR_PROPERTY_LISTINGS.LISTING_DATE%TYPE
                      , X_PRICE IN PR_PROPERTY_LISTINGS.PRICE%TYPE
                      , X_PUBLISH_YN IN PR_PROPERTY_LISTINGS.PUBLISH_YN%TYPE
                      , X_SOLD_YN IN PR_PROPERTY_LISTINGS.SOLD_YN%TYPE
                      , X_DESCRIPTION IN PR_PROPERTY_LISTINGS.DESCRIPTION%TYPE
                      , X_SOURCE IN PR_PROPERTY_LISTINGS.SOURCE%TYPE
                      , X_AGENT_NAME IN PR_PROPERTY_LISTINGS.AGENT_NAME%TYPE
                      , X_AGENT_PHONE IN PR_PROPERTY_LISTINGS.AGENT_PHONE%TYPE
                      , X_AGENT_EMAIL IN PR_PROPERTY_LISTINGS.AGENT_EMAIL%TYPE
                      , X_AGENT_WEBSITE IN PR_PROPERTY_LISTINGS.AGENT_WEBSITE%TYPE
                      , X_CHECKSUM IN PR_PROPERTY_LISTINGS_V.CHECKSUM%TYPE)
  is
     l_checksum          PR_PROPERTY_LISTINGS_V.CHECKSUM%TYPE;
  begin
     lock_row(X_PROP_ID, X_BUSINESS_ID);

      -- validate checksum
      l_checksum := get_checksum(X_PROP_ID, X_BUSINESS_ID);
      if X_CHECKSUM != l_checksum then
         RAISE_APPLICATION_ERROR(-20002, 'Record has been changed another user.');
      end if;

     update PR_PROPERTY_LISTINGS
     set BUSINESS_ID = X_BUSINESS_ID
     , LISTING_DATE  = X_LISTING_DATE
     , PRICE         = X_PRICE
     , PUBLISH_YN    = X_PUBLISH_YN
     , SOLD_YN       = X_SOLD_YN
     , DESCRIPTION   = X_DESCRIPTION
     , SOURCE        = X_SOURCE
     , AGENT_NAME    = X_AGENT_NAME
     , AGENT_PHONE   = X_AGENT_PHONE
     , AGENT_EMAIL   = X_AGENT_EMAIL
     , AGENT_WEBSITE = X_AGENT_WEBSITE
     where PROP_ID    = X_PROP_ID
     and BUSINESS_ID  = X_BUSINESS_ID;

  end update_row;

  PROCEDURE insert_row( X_PROP_ID       IN PR_PROPERTIES.PROP_ID%TYPE
                     , X_BUSINESS_ID   IN PR_PROPERTY_LISTINGS.BUSINESS_ID%TYPE
                     , X_LISTING_DATE  IN PR_PROPERTY_LISTINGS.LISTING_DATE%TYPE
                     , X_PRICE         IN PR_PROPERTY_LISTINGS.PRICE%TYPE
                     , X_PUBLISH_YN    IN PR_PROPERTY_LISTINGS.PUBLISH_YN%TYPE
                     , X_SOLD_YN       IN PR_PROPERTY_LISTINGS.SOLD_YN%TYPE
                     , X_DESCRIPTION   IN PR_PROPERTY_LISTINGS.DESCRIPTION%TYPE
                     , X_SOURCE        IN PR_PROPERTY_LISTINGS.SOURCE%TYPE
                     , X_AGENT_NAME    IN PR_PROPERTY_LISTINGS.AGENT_NAME%TYPE
                     , X_AGENT_PHONE   IN PR_PROPERTY_LISTINGS.AGENT_PHONE%TYPE
                     , X_AGENT_EMAIL   IN PR_PROPERTY_LISTINGS.AGENT_EMAIL%TYPE
                     , X_AGENT_WEBSITE IN PR_PROPERTY_LISTINGS.AGENT_WEBSITE%TYPE)
  is
  begin

     insert into PR_PROPERTY_LISTINGS
     ( PROP_ID
     , BUSINESS_ID
     , LISTING_DATE
     , PRICE
     , PUBLISH_YN
     , SOLD_YN
     , DESCRIPTION
     , SOURCE
     , AGENT_NAME
     , AGENT_PHONE
     , AGENT_EMAIL
     , AGENT_WEBSITE)
     values
     ( X_PROP_ID
     , X_BUSINESS_ID
     , X_LISTING_DATE
     , X_PRICE
     , X_PUBLISH_YN
     , X_SOLD_YN
     , X_DESCRIPTION
     , X_SOURCE
     , X_AGENT_NAME
     , X_AGENT_PHONE
     , X_AGENT_EMAIL
     , X_AGENT_WEBSITE);
  end insert_row;

  procedure delete_row( X_PROP_ID IN PR_PROPERTY_LISTINGS.PROP_ID%TYPE
                       , X_BUSINESS_ID IN PR_PROPERTY_LISTINGS.BUSINESS_ID%TYPE) is

  begin
    delete from PR_PROPERTY_LISTINGS
    where PROP_ID = X_PROP_ID
    and BUSINESS_ID = X_BUSINESS_ID;

  end delete_row;

end PR_PROPERTY_LISTINGS_PKG;
/

show errors package PR_PROPERTY_LISTINGS_PKG
show errors package body PR_PROPERTY_LISTINGS_PKG