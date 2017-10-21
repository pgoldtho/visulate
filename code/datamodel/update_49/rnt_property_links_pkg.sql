CREATE OR REPLACE PACKAGE rnt_property_links_pkg
AS
/*******************************************************************************
   Copyright (c) Visulate 2007        All rights reserved worldwide
    Name:      RNT_PROPERTY_LINKS_PKG
    Purpose:   API's for RNT_PROPERTY_LINKS table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        14-APR-08   Auto Generated   Initial Version
*******************************************************************************/
   FUNCTION insert_row (
      x_property_id   IN   rnt_property_links.property_id%TYPE,
      x_link_title    IN   rnt_property_links.link_title%TYPE,
      x_link_url      IN   rnt_property_links.link_url%TYPE
   )
      RETURN rnt_property_links.property_link_id%TYPE;

   PROCEDURE delete_row (
      x_property_link_id   IN   rnt_property_links.property_link_id%TYPE
   );
END rnt_property_links_pkg;
/

SHOW ERRORS;

CREATE OR REPLACE 
PACKAGE BODY rnt_property_links_pkg
AS
/**********************************************************************
   Copyright (c) Visulate 2007        All rights reserved worldwide
    Name:      RNT_PROPERTY_LINKS_PKG
    Purpose:   API's for RNT_PROPERTY_LINKS table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        14-APR-08   Auto Generated   Initial Version
************************************************************************/
-------------------------------------------------
--  Private Procedures and Functions
-------------------------------------------------
   PROCEDURE lock_row (
      x_property_link_id   IN   rnt_property_links.property_link_id%TYPE
   )
   IS
      CURSOR c
      IS
         SELECT     *
               FROM rnt_property_links
              WHERE property_link_id = x_property_link_id
         FOR UPDATE NOWAIT;
   BEGIN
      OPEN c;

      CLOSE c;
   EXCEPTION
      WHEN OTHERS
      THEN
         IF SQLCODE = -54
         THEN
            raise_application_error
                                  (-20001,
                                   'Cannot changed record. Record is locked.'
                                  );
         END IF;
   END lock_row;

-------------------------------------------------
--  Public Procedures and Functions
-------------------------------------------------
   FUNCTION insert_row (
      x_property_id   IN   rnt_property_links.property_id%TYPE,
      x_link_title    IN   rnt_property_links.link_title%TYPE,
      x_link_url      IN   rnt_property_links.link_url%TYPE
   )
      RETURN rnt_property_links.property_link_id%TYPE
   IS
      x   NUMBER;
   BEGIN
      INSERT INTO rnt_property_links
                  (property_link_id, property_id,
                   link_title, link_url, creation_date
                  )
           VALUES (rnt_property_links_seq.NEXTVAL, x_property_id,
                   x_link_title, x_link_url, SYSDATE
                  )
        RETURNING property_link_id
             INTO x;

      RETURN x;
   END insert_row;

   PROCEDURE delete_row (
      x_property_link_id   IN   rnt_property_links.property_link_id%TYPE
   )
   IS
   BEGIN
      lock_row (x_property_link_id);

      DELETE FROM rnt_property_links
            WHERE property_link_id = x_property_link_id;
   END delete_row;
END rnt_property_links_pkg;
/

SHOW ERRORS;
