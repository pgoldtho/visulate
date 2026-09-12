-- =============================================================================
-- Trigger: MLS_LISTINGS_BUR_TRG
-- Schema:  RNTMGR2
-- Table:   MLS_LISTINGS
-- Database: pdb21
-- Purpose: Populates the LAST_ACTIVE column with SYSDATE when LISTING_STATUS 
--          transitions from 'ACTIVE' to any non-active status (case-insensitive).
-- =============================================================================
CREATE OR REPLACE TRIGGER rntmgr2.mls_listings_bur_trg
BEFORE UPDATE OF listing_status ON rntmgr2.mls_listings
FOR EACH ROW
BEGIN
 -- Trigger condition:
 -- 1. Evaluates case-insensitive transition away from 'ACTIVE' status.
 -- 2. Defensive fallback: If LAST_ACTIVE is NULL and new status is not 'ACTIVE'.
 IF (
      (UPPER(NVL(:OLD.listing_status, '~')) = 'ACTIVE' AND UPPER(NVL(:NEW.listing_status, '~')) != 'ACTIVE')
      OR
      (:OLD.last_active IS NULL AND UPPER(NVL(:NEW.listing_status, '~')) != 'ACTIVE')
    ) THEN
   -- Assign current timestamp (SYSDATE) unless the updating process explicitly
   -- provided a custom LAST_ACTIVE value distinct from the existing value.
   IF :NEW.last_active IS NULL OR :NEW.last_active = :OLD.last_active THEN
     :NEW.last_active := SYSDATE;
   END IF;
 END IF;
END mls_listings_bur_trg;
/
-- Verify compilation status
SHOW ERRORS TRIGGER rntmgr2.mls_listings_bur_trg;