SET DEFINE OFF;

UPDATE RNT_ERROR_DESCRIPTION
SET    
       SHORT_DESCRIPTION            = 'Update values ("Supplier Name", "Supplier Type", "City", "Phone1") must be unique.',
       LONG_DESCRIPTION             = '<strong>What does this mean?</strong><br />
Already exists record with attribute values (&lt;Supplier Name&gt;, &lt;Supplier Type&gt;, &lt;City&gt;, &lt;Phone1&gt;).<br />
<br />
<strong>How do i fix it?</strong><br />
Change Supplier Name attribute.'
WHERE  ERROR_CODE                     = 20430
/

UPDATE RNT_ERROR_DESCRIPTION
SET    
       SHORT_DESCRIPTION            = 'Update values ("Supplier Name", "Supplier Type", "City", "Phone1") must be unique.',
       LONG_DESCRIPTION             = '<strong>What does this mean?</strong><br />
Already exists record with attribute values (&lt;Supplier Name&gt;, &lt;Supplier Type&gt;, &lt;City&gt;, &lt;Phone1&gt;).<br />
<br />
<strong>How do i fix it?</strong><br />
Change Supplier Name attribute.'
WHERE  ERROR_CODE                     = 20431
/

Insert into RNT_ERROR_DESCRIPTION
   (ERROR_ID, ERROR_CODE, SHORT_DESCRIPTION, LONG_DESCRIPTION, SHOW_LONG_DESCRIPTION_YN, CLASSIFIED_DESCRIPTION, DISPLAY_SHORT_DESCRIPTION_YN)
 Values
   (60, 20433, 'Business unit for supplier must be unique.', '<strong>What does this mean?</strong><br />
<br />
<strong>How do i fix it?</strong><br />
<br />
<strong>What would happen if I ignore it?</strong>', 'N', 'suppliers', 'Y');
Insert into RNT_ERROR_DESCRIPTION
   (ERROR_ID, ERROR_CODE, SHORT_DESCRIPTION, LONG_DESCRIPTION, SHOW_LONG_DESCRIPTION_YN, CLASSIFIED_DESCRIPTION, DISPLAY_SHORT_DESCRIPTION_YN)
 Values
   (59, 20434, 'Can not delete record about supplier business unit. Cause: supplier must have one or more business units.', '<strong>What does this mean?</strong><br />
<br />
<strong>How do i fix it?</strong><br />
<br />
<strong>What would happen if I ignore it?</strong>', 'N', 'suppliers', 'Y');
COMMIT;
