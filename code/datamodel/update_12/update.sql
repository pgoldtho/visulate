CREATE OR REPLACE FORCE VIEW RNT_BUSINESS_UNITS_V
(BUSINESS_ID, BUSINESS_NAME, PARENT_BUSINESS_ID, CHECKSUM)
AS 
select BUSINESS_ID, BUSINESS_NAME, PARENT_BUSINESS_ID, RNT_BUSINESS_UNITS_PKG.GET_CHECKSUM(BUSINESS_ID) as CHECKSUM
from RNT_BUSINESS_UNITS
start with (PARENT_BUSINESS_ID = 0
            and BUSINESS_ID in (select BUSINESS_ID
                                from RNT_USER_ASSIGNMENTS_V
                                where USER_ID = RNT_USERS_PKG.GET_USER()
                                  and ROLE_CODE = RNT_USERS_PKG.GET_ROLE()
                                )
           )
         or (BUSINESS_ID in (select BUSINESS_ID
                             from RNT_USER_ASSIGNMENTS_V
                             where USER_ID = RNT_USERS_PKG.GET_USER()
                             and ROLE_CODE = RNT_USERS_PKG.GET_ROLE()
                            )
             )
connect by prior BUSINESS_ID = PARENT_BUSINESS_ID
/