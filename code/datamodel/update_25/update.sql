--------------------------------------------------------------------------
-- Play this script in TESTRNTMGR@XE to make it look like RNTMGR@XE
--                                                                      --
-- Please review the script before using it to make sure it won't       --
-- cause any unacceptable data loss.                                    --
--                                                                      --
-- TESTRNTMGR@XE Schema Extracted by User TESTRNTMGR 
-- RNTMGR@XE Schema Extracted by User RNTMGR 
DROP INDEX RNT_ERROR_DESCRIPTION_PK;

CREATE UNIQUE INDEX RNT_ERROR_DESCRIPTION_PK ON RNT_ERROR_DESCRIPTION
(ERROR_ID)
LOGGING
NOPARALLEL;

CREATE OR REPLACE FORCE VIEW RNT_ERROR_DESCRIPTION_V
(ERROR_ID, ERROR_CODE, SHORT_DESCRIPTION, LONG_DESCRIPTION, SHOW_LONG_DESCRIPTION_YN, 
 CLASSIFIED_DESCRIPTION, CHECKSUM)
AS 
select ERROR_ID
,      ERROR_CODE
,      SHORT_DESCRIPTION
,      LONG_DESCRIPTION
,      SHOW_LONG_DESCRIPTION_YN
,      CLASSIFIED_DESCRIPTION
,      rnt_sys_checksum_rec_pkg.get_checksum('ERROR_ID='||ERROR_ID||'ERROR_CODE='||ERROR_CODE||'SHORT_DESCRIPTION='||SHORT_DESCRIPTION||'LONG_DESCRIPTION='||LONG_DESCRIPTION||'SHOW_LONG_DESCRIPTION_YN='||SHOW_LONG_DESCRIPTION_YN||'CLASSIFIED_DESCRIPTION='||CLASSIFIED_DESCRIPTION) as CHECKSUM
from RNT_ERROR_DESCRIPTION;


@@rnt_error_description_pkg.sql
SHOW ERRORS;

ALTER PACKAGE RNT_PAYMENT_ALLOCATIONS_PKG COMPILE BODY;

@@rnt_properties_pkg.sql
SHOW ERRORS;

ALTER TABLE RNT_ERROR_DESCRIPTION
 ADD CONSTRAINT RNT_ERROR_DESCRIPTION_PK
 PRIMARY KEY
 (ERROR_ID);
