create or replace package MLS_LISTINGS_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007, 2011       All rights reserved worldwide
    Name:      MLS_LISTINGS_PKG
    Purpose:   API's for MLS_LISTINGS table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        11-DEC-11   Auto Generated   Initial Version
*******************************************************************************/
  function get_checksum( X_MLS_ID IN MLS_LISTINGS.MLS_ID%TYPE)
            return MLS_LISTINGS_V.CHECKSUM%TYPE;

  procedure update_row( X_MLS_ID         IN MLS_LISTINGS.MLS_ID%TYPE
                      , X_PROP_ID        IN MLS_LISTINGS.PROP_ID%TYPE
                      , X_SOURCE_ID      IN MLS_LISTINGS.SOURCE_ID%TYPE
                      , X_MLS_NUMBER     IN MLS_LISTINGS.MLS_NUMBER%TYPE
                      , X_QUERY_TYPE     IN MLS_LISTINGS.QUERY_TYPE%TYPE
                      , X_LISTING_TYPE   IN MLS_LISTINGS.LISTING_TYPE%TYPE
                      , X_LISTING_STATUS IN MLS_LISTINGS.LISTING_STATUS%TYPE
                      , X_PRICE          IN MLS_LISTINGS.PRICE%TYPE
                      , X_IDX_YN         IN MLS_LISTINGS.IDX_YN%TYPE
                      , X_LISTING_BROKER IN MLS_LISTINGS.LISTING_BROKER%TYPE
                      , X_LISTING_DATE   IN MLS_LISTINGS.LISTING_DATE%TYPE
                      , X_SHORT_DESC     IN MLS_LISTINGS.SHORT_DESC%TYPE
                      , X_LINK_TEXT      IN MLS_LISTINGS.LINK_TEXT%TYPE
                      , X_DESCRIPTION    IN MLS_LISTINGS.DESCRIPTION%TYPE
                      , X_LAST_ACTIVE    IN MLS_LISTINGS.LAST_ACTIVE%TYPE
                      , X_CHECKSUM       IN MLS_LISTINGS_V.CHECKSUM%TYPE);

  function  insert_row( X_PROP_ID        IN MLS_LISTINGS.PROP_ID%TYPE
                     , X_SOURCE_ID       IN MLS_LISTINGS.SOURCE_ID%TYPE
                     , X_MLS_NUMBER      IN MLS_LISTINGS.MLS_NUMBER%TYPE
                     , X_QUERY_TYPE      IN MLS_LISTINGS.QUERY_TYPE%TYPE
                     , X_LISTING_TYPE    IN MLS_LISTINGS.LISTING_TYPE%TYPE
                     , X_LISTING_STATUS  IN MLS_LISTINGS.LISTING_STATUS%TYPE
                     , X_PRICE           IN MLS_LISTINGS.PRICE%TYPE
                     , X_IDX_YN          IN MLS_LISTINGS.IDX_YN%TYPE
                     , X_LISTING_BROKER  IN MLS_LISTINGS.LISTING_BROKER%TYPE
                     , X_LISTING_DATE    IN MLS_LISTINGS.LISTING_DATE%TYPE
                     , X_SHORT_DESC      IN MLS_LISTINGS.SHORT_DESC%TYPE
                     , X_LINK_TEXT       IN MLS_LISTINGS.LINK_TEXT%TYPE
                     , X_DESCRIPTION     IN MLS_LISTINGS.DESCRIPTION%TYPE
                     , X_LAST_ACTIVE     IN MLS_LISTINGS.LAST_ACTIVE%TYPE
					 , X_GEO_LOCATION    IN MLS_LISTINGS.GEO_LOCATION%TYPE)
              return MLS_LISTINGS.MLS_ID%TYPE;
			  
  function get_mls_id( X_SOURCE_ID       IN MLS_LISTINGS.SOURCE_ID%TYPE
                     , X_MLS_NUMBER      IN MLS_LISTINGS.MLS_NUMBER%TYPE)
			  return MLS_LISTINGS.MLS_ID%TYPE;

  procedure delete_row( X_MLS_ID IN MLS_LISTINGS.MLS_ID%TYPE);

end MLS_LISTINGS_PKG;
/
create or replace package body MLS_LISTINGS_PKG as
/*******************************************************************************
   Copyright (c) Visulate 2007, 2011       All rights reserved worldwide
    Name:      MLS_LISTINGS_PKG
    Purpose:   API's for MLS_LISTINGS table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        11-DEC-11   Auto Generated   Initial Version

********************************************************************************/
-------------------------------------------------
--  Private Procedures and Functions
-------------------------------------------------
  function check_unique( X_MLS_ID     IN MLS_LISTINGS.MLS_ID%TYPE
                       , X_SOURCE_ID  IN MLS_LISTINGS.SOURCE_ID%TYPE
                       , X_MLS_NUMBER IN MLS_LISTINGS.MLS_NUMBER%TYPE) return boolean is
        cursor c is
        select MLS_ID
        from MLS_LISTINGS
        where SOURCE_ID = X_SOURCE_ID
    and MLS_NUMBER = X_MLS_NUMBER;

      begin
         for c_rec in c loop
           if (X_MLS_ID is null OR c_rec.MLS_ID != X_MLS_ID) then
             return false;
           end if;
         end loop;
         return true;
      end check_unique;

  procedure lock_row( X_MLS_ID IN MLS_LISTINGS.MLS_ID%TYPE) is
     cursor c is
     select * from MLS_LISTINGS
     where MLS_ID = X_MLS_ID
     for update nowait;

  begin
    open c;
    close c;
  exception
    when OTHERS then
      if SQLCODE = -54 then
        RAISE_APPLICATION_ERROR(-20001, 'Cannot changed record. Record is locked.');
      end if;
  end lock_row;

-------------------------------------------------
--  Public Procedures and Functions
-------------------------------------------------
  function get_checksum( X_MLS_ID IN MLS_LISTINGS.MLS_ID%TYPE)
            return MLS_LISTINGS_V.CHECKSUM%TYPE is

    v_return_value               MLS_LISTINGS_V.CHECKSUM%TYPE;
  begin
    select CHECKSUM
    into v_return_value
    from MLS_LISTINGS_V
    where MLS_ID = X_MLS_ID;
    return v_return_value;
  end get_checksum;

  procedure update_row( X_MLS_ID         IN MLS_LISTINGS.MLS_ID%TYPE
                      , X_PROP_ID        IN MLS_LISTINGS.PROP_ID%TYPE
                      , X_SOURCE_ID      IN MLS_LISTINGS.SOURCE_ID%TYPE
                      , X_MLS_NUMBER     IN MLS_LISTINGS.MLS_NUMBER%TYPE
                      , X_QUERY_TYPE     IN MLS_LISTINGS.QUERY_TYPE%TYPE
                      , X_LISTING_TYPE   IN MLS_LISTINGS.LISTING_TYPE%TYPE
                      , X_LISTING_STATUS IN MLS_LISTINGS.LISTING_STATUS%TYPE
                      , X_PRICE          IN MLS_LISTINGS.PRICE%TYPE
                      , X_IDX_YN         IN MLS_LISTINGS.IDX_YN%TYPE
                      , X_LISTING_BROKER IN MLS_LISTINGS.LISTING_BROKER%TYPE
                      , X_LISTING_DATE   IN MLS_LISTINGS.LISTING_DATE%TYPE
                      , X_SHORT_DESC     IN MLS_LISTINGS.SHORT_DESC%TYPE
                      , X_LINK_TEXT      IN MLS_LISTINGS.LINK_TEXT%TYPE
                      , X_DESCRIPTION    IN MLS_LISTINGS.DESCRIPTION%TYPE
                      , X_LAST_ACTIVE    IN MLS_LISTINGS.LAST_ACTIVE%TYPE
                      , X_CHECKSUM       IN MLS_LISTINGS_V.CHECKSUM%TYPE)
  is
     l_checksum          MLS_LISTINGS_V.CHECKSUM%TYPE;
  begin
     lock_row(X_MLS_ID);

      -- validate checksum
      l_checksum := get_checksum(X_MLS_ID);
      if X_CHECKSUM != l_checksum then
         RAISE_APPLICATION_ERROR(-20002, 'Record has been changed another user.');
      end if;

         if not check_unique(X_MLS_ID, X_SOURCE_ID, X_MLS_NUMBER) then
             RAISE_APPLICATION_ERROR(-20006, 'Update values must be unique.');
         end if;
     update MLS_LISTINGS
     set PROP_ID = X_PROP_ID
     , SOURCE_ID = X_SOURCE_ID
     , MLS_NUMBER = X_MLS_NUMBER
     , QUERY_TYPE = X_QUERY_TYPE
     , LISTING_TYPE = X_LISTING_TYPE
     , LISTING_STATUS = X_LISTING_STATUS
     , PRICE = X_PRICE
     , IDX_YN = X_IDX_YN
     , LISTING_BROKER = X_LISTING_BROKER
     , LISTING_DATE = X_LISTING_DATE
     , SHORT_DESC = X_SHORT_DESC
     , LINK_TEXT = X_LINK_TEXT
     , DESCRIPTION = X_DESCRIPTION
     , LAST_ACTIVE = X_LAST_ACTIVE
     where MLS_ID = X_MLS_ID;

  end update_row;

  function  insert_row( X_PROP_ID       IN MLS_LISTINGS.PROP_ID%TYPE
                     , X_SOURCE_ID      IN MLS_LISTINGS.SOURCE_ID%TYPE
                     , X_MLS_NUMBER     IN MLS_LISTINGS.MLS_NUMBER%TYPE
                     , X_QUERY_TYPE     IN MLS_LISTINGS.QUERY_TYPE%TYPE
                     , X_LISTING_TYPE   IN MLS_LISTINGS.LISTING_TYPE%TYPE
                     , X_LISTING_STATUS IN MLS_LISTINGS.LISTING_STATUS%TYPE
                     , X_PRICE          IN MLS_LISTINGS.PRICE%TYPE
                     , X_IDX_YN         IN MLS_LISTINGS.IDX_YN%TYPE
                     , X_LISTING_BROKER IN MLS_LISTINGS.LISTING_BROKER%TYPE
                     , X_LISTING_DATE   IN MLS_LISTINGS.LISTING_DATE%TYPE
                     , X_SHORT_DESC     IN MLS_LISTINGS.SHORT_DESC%TYPE
                     , X_LINK_TEXT      IN MLS_LISTINGS.LINK_TEXT%TYPE
                     , X_DESCRIPTION    IN MLS_LISTINGS.DESCRIPTION%TYPE
                     , X_LAST_ACTIVE    IN MLS_LISTINGS.LAST_ACTIVE%TYPE
					 , X_GEO_LOCATION   IN MLS_LISTINGS.GEO_LOCATION%TYPE)
              return MLS_LISTINGS.MLS_ID%TYPE
  is
     x          number;
  begin
if not check_unique(NULL, X_SOURCE_ID, X_MLS_NUMBER) then
         RAISE_APPLICATION_ERROR(-20006, 'Insert values must be unique.');
     end if;

     insert into MLS_LISTINGS
     ( MLS_ID
     , PROP_ID
     , SOURCE_ID
     , MLS_NUMBER
     , QUERY_TYPE
     , LISTING_TYPE
     , LISTING_STATUS
     , PRICE
     , IDX_YN
     , LISTING_BROKER
     , LISTING_DATE
     , SHORT_DESC
     , LINK_TEXT
     , DESCRIPTION
     , LAST_ACTIVE
	 , GEO_LOCATION)
     values
     ( MLS_LISTINGS_SEQ.NEXTVAL
     , X_PROP_ID
     , X_SOURCE_ID
     , X_MLS_NUMBER
     , X_QUERY_TYPE
     , X_LISTING_TYPE
     , X_LISTING_STATUS
     , X_PRICE
     , X_IDX_YN
     , X_LISTING_BROKER
     , X_LISTING_DATE
     , X_SHORT_DESC
     , X_LINK_TEXT
     , X_DESCRIPTION
     , X_LAST_ACTIVE
	 , X_GEO_LOCATION)
     returning MLS_ID into x;

     return x;
  end insert_row;

  procedure delete_row( X_MLS_ID IN MLS_LISTINGS.MLS_ID%TYPE) is

  begin
    delete from MLS_LISTINGS
    where MLS_ID = X_MLS_ID;

  end delete_row;

  function get_mls_id( X_SOURCE_ID       IN MLS_LISTINGS.SOURCE_ID%TYPE
                     , X_MLS_NUMBER      IN MLS_LISTINGS.MLS_NUMBER%TYPE)
			  return MLS_LISTINGS.MLS_ID%TYPE is
	v_return     MLS_LISTINGS.MLS_ID%TYPE;
  begin
    select mls_id
	into v_return
	from mls_listings
	where source_id = x_source_id
	and mls_number = x_mls_number;
	
	return v_return;
  exception
    when no_data_found then return null;
	when others then raise;
  end get_mls_id;
  
end MLS_LISTINGS_PKG;
/

show errors package MLS_LISTINGS_PKG
show errors package body MLS_LISTINGS_PKG