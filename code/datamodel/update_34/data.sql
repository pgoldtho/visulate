SET DEFINE OFF;
Insert into RNT_ERROR_DESCRIPTION
   (ERROR_ID, ERROR_CODE, SHORT_DESCRIPTION, LONG_DESCRIPTION, SHOW_LONG_DESCRIPTION_YN, CLASSIFIED_DESCRIPTION, DISPLAY_SHORT_DESCRIPTION_YN)
 Values
   (23, 20030, 'Unknown recurring period type.', '<strong>What does this mean?</strong><br />
This is an internal error that is not normally issued.<br />
<br />
<strong>How do i fix it?</strong><br />
Please send an email to support@visulate.com with instructions for how to reproduce the error.'
, 'Y', 'accounts_payable', 'Y');

Insert into RNT_ERROR_DESCRIPTION
   (ERROR_ID, ERROR_CODE, SHORT_DESCRIPTION, LONG_DESCRIPTION, SHOW_LONG_DESCRIPTION_YN, CLASSIFIED_DESCRIPTION, DISPLAY_SHORT_DESCRIPTION_YN)
 Values
   (21, 20001, 'Cannot changed record. Record is locked.', '<strong>What does this mean?</strong><br />
<span lang="EN-US" style="background: white none repeat scroll 0%; font-size: 10pt; font-family: Arial; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial;">Another user 
is making changes to the same information that you are working on.  Visulate has locked the database record that 
the information is stored in.  It will release the lock when the other user''s change has completed.<br />
</span><br />
<strong>How do i fix it?</strong><br />
Try again later.<br />
<br />', 'Y', 'common', 'Y');

Insert into RNT_ERROR_DESCRIPTION
   (ERROR_ID, ERROR_CODE, SHORT_DESCRIPTION, LONG_DESCRIPTION, SHOW_LONG_DESCRIPTION_YN, CLASSIFIED_DESCRIPTION, DISPLAY_SHORT_DESCRIPTION_YN)
 Values
   (22, 20002, 'This information has been changed another user. Please requery', '<strong>What does this mean?</strong><br />
<span lang="EN-US" style="background: white none repeat scroll 0%; font-size: 10pt; font-family: Arial; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial;">The information
that is recorded in the Visulate database is different to the information you originally queried when you opened this
screen.  This probably means another user has changed some of the information on this screen.  You need to requery the
information to prevent your changes overwriting the changes that the other user has made.<br />
</span><br />
<strong>How do i fix it?</strong><br />
Refresh screen. And try again.<br />
<br />
<strong>What would happen if I ignore it?</strong><br />
You won''t be able to save your changes.', 'Y', 'common', 'Y');

Insert into RNT_ERROR_DESCRIPTION
   (ERROR_ID, ERROR_CODE, SHORT_DESCRIPTION, LONG_DESCRIPTION, SHOW_LONG_DESCRIPTION_YN, CLASSIFIED_DESCRIPTION, DISPLAY_SHORT_DESCRIPTION_YN)
 Values
   (24, 20031, 'Can’t delete payment records that have been marked as paid.', '<strong>What does this mean?<br />
</strong><span lang="EN-US" style="background: white none repeat scroll 0% 50%; font-size: 10pt; font-family: Arial; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial;">
You are attempting to delete a payment that has been marked as paid.</span><br />
<br />
<strong>How do i fix it?<br />
</strong>Unset the &quot;Payment Date&quot; and try again.<strong><br />
</strong>', 'Y', 'accounts_payable', 'Y');

Insert into RNT_ERROR_DESCRIPTION
   (ERROR_ID, ERROR_CODE, SHORT_DESCRIPTION, LONG_DESCRIPTION, SHOW_LONG_DESCRIPTION_YN, CLASSIFIED_DESCRIPTION, DISPLAY_SHORT_DESCRIPTION_YN)
 Values
   (25, 20060, 'Use message from database. Original message:
New amount paid is more than the amount owed on (''||
to_char(X_PAYMENT_DATE, ''MM/DD/RRRR'')||''). Max value for payment = ''||(x_payment)', '<strong>Cause<br />
</strong>&nbsp;&nbsp; The amount paid is greater than the amount owed.  Visulate does not support overpayment
of accounts receivable.<br />
<strong>Action</strong><br />
&nbsp; Set the amount paid to be less than or equal to amount the amount owed for this date.  The remaining balance
can be added to the tenants deposit or last months balance.', 'Y', 'accounts_receivable', 'N');

Insert into RNT_ERROR_DESCRIPTION
   (ERROR_ID, ERROR_CODE, SHORT_DESCRIPTION, LONG_DESCRIPTION, SHOW_LONG_DESCRIPTION_YN, CLASSIFIED_DESCRIPTION, DISPLAY_SHORT_DESCRIPTION_YN)
 Values
   (27, 20090, 'This action has already been recorded.', '<strong>What does this mean?</strong><br />
<span lang="EN-US" style="background: white none repeat scroll 0% 50%; font-size: 10pt; font-family: Arial; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial;">Action values must be unique. A record with the same attributes (&lt;Action Date&gt;, &lt;Action Type&gt;) already exists in 
the database.<br />
</span><br />
<strong>How do i fix it?</strong><br />
Change date or type of action.', 'Y', 'agreement_actions', 'Y');


Insert into RNT_ERROR_DESCRIPTION
   (ERROR_ID, ERROR_CODE, SHORT_DESCRIPTION, LONG_DESCRIPTION, SHOW_LONG_DESCRIPTION_YN, CLASSIFIED_DESCRIPTION, DISPLAY_SHORT_DESCRIPTION_YN)
 Values
   (28, 20091, 'Cannot update action record. Cause: find record about payment allocation.', '<strong>What does this mean?</strong><br />
<span lang="EN-US" style="background: white none repeat scroll 0%; font-size: 10pt; font-family: Arial; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial;">Cannot update action record. Cause: find record about payment allocation.<br />
</span><br />
<strong>How do i fix it?</strong><br />
Delete receivables recrods from receivable screen for this agreement action.', 'Y', 'agreement_actions', 'Y');

Insert into RNT_ERROR_DESCRIPTION
   (ERROR_ID, ERROR_CODE, SHORT_DESCRIPTION, LONG_DESCRIPTION, SHOW_LONG_DESCRIPTION_YN, CLASSIFIED_DESCRIPTION, DISPLAY_SHORT_DESCRIPTION_YN)
 Values
   (29, 20092, 'Use database message. Original message:
''Please set the recoverable amount to be greater than or equal to ''||NVL(x_alloc_payment, 0)||''.''', '<strong>
What does this mean?</strong><br />
An amount paid has been recorded for this action on the Accounts Receivable screen.<br />
<br />
<strong>How do i fix it?</strong><br />
Remove the payment for this action or set the amount owed to be greater than or equal to it.<br />', 'Y', 'agreement_actions', 'N');

Insert into RNT_ERROR_DESCRIPTION
   (ERROR_ID, ERROR_CODE, SHORT_DESCRIPTION, LONG_DESCRIPTION, SHOW_LONG_DESCRIPTION_YN, CLASSIFIED_DESCRIPTION, DISPLAY_SHORT_DESCRIPTION_YN)
 Values
   (30, 20093, 'This action cannot be deleted because a payment has been recorded against it.', 
'<strong>What does this mean?</strong><br />
A payment has been recorded on the Accounts Receivable screen for this action.<br />
<br />
<strong>How do i fix it?<br />
</strong>Remove the payment on the Accounts Receivable screen or cancel the deletion of the 
Action.<br />', 'Y', 'agreement_actions', 'Y');

Insert into RNT_ERROR_DESCRIPTION
   (ERROR_ID, ERROR_CODE, SHORT_DESCRIPTION, LONG_DESCRIPTION, SHOW_LONG_DESCRIPTION_YN, CLASSIFIED_DESCRIPTION, DISPLAY_SHORT_DESCRIPTION_YN)
 Values
   (31, 20120, 'Access denied.  You cannot create sub units for this business unit.', '<strong>What does this mean?</strong><br />
<span lang="EN-US" style="background: white none repeat scroll 0%; font-size: 10pt; font-family: Arial; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial;">You do not have
the required permissions to modify this business unit.<br />
</span><br />
<strong>How do i fix it?</strong><br />
Contact the Business Owner.<br />', 'Y', 'business_units', 'Y');

Insert into RNT_ERROR_DESCRIPTION
   (ERROR_ID, ERROR_CODE, SHORT_DESCRIPTION, LONG_DESCRIPTION, SHOW_LONG_DESCRIPTION_YN, CLASSIFIED_DESCRIPTION, DISPLAY_SHORT_DESCRIPTION_YN)
 Values
   (32, 20121, 'Name of business unit must be unique in parent business unit.', '<strong>What does this mean?</strong>
<br />
The business unit you are attempting to insert has already been created.
<br />
<strong>How do i fix it?</strong>
Requery the screen to see the complete list of business units.
<br />
', 'N', 'business_units', 'Y');

Insert into RNT_ERROR_DESCRIPTION
   (ERROR_ID, ERROR_CODE, SHORT_DESCRIPTION, LONG_DESCRIPTION, SHOW_LONG_DESCRIPTION_YN, CLASSIFIED_DESCRIPTION, DISPLAY_SHORT_DESCRIPTION_YN)
 Values
   (33, 20122, 'You cannot update this unit. Access denied.', '<strong>What does this mean?</strong><br />
You do not have permissions to update this business unit.
<br />
<strong>How do i fix it?</strong>
Contact the Business Owner and request permissions.
<br />
<br />
', 'N', 'business_units', 'Y');

Insert into RNT_ERROR_DESCRIPTION
   (ERROR_ID, ERROR_CODE, SHORT_DESCRIPTION, LONG_DESCRIPTION, SHOW_LONG_DESCRIPTION_YN, CLASSIFIED_DESCRIPTION, DISPLAY_SHORT_DESCRIPTION_YN)
 Values
   (34, 20123, 'This business unit cannot be deleted because it contains properties.',
 '<strong>What does this mean?</strong><br />
You are attempting to delete a business unit that contains property records.
<br />
<strong>How do i fix it?</strong><br />
You cannot delete this record. 
<br />
', 'N', 'business_units', 'Y');

Insert into RNT_ERROR_DESCRIPTION
   (ERROR_ID, ERROR_CODE, SHORT_DESCRIPTION, LONG_DESCRIPTION, SHOW_LONG_DESCRIPTION_YN, CLASSIFIED_DESCRIPTION, DISPLAY_SHORT_DESCRIPTION_YN)
 Values
   (35, 20124, 'Cannot delete record. Find assigned owners for this record.', '<strong>What does this mean?</strong><br />
<br />
<strong>How do i fix it?</strong><br />
<br />
<strong>What would happen if I ignore it?</strong>', 'N', 'business_units', 'Y');

Insert into RNT_ERROR_DESCRIPTION
   (ERROR_ID, ERROR_CODE, SHORT_DESCRIPTION, LONG_DESCRIPTION, SHOW_LONG_DESCRIPTION_YN, CLASSIFIED_DESCRIPTION, DISPLAY_SHORT_DESCRIPTION_YN)
 Values
   (37, 20150, 'Error code must be unique.', '<strong>What does this mean?</strong><br />
<br />
<strong>How do i fix it?</strong><br />
<br />
<strong>What would happen if I ignore it?</strong>', 'N', 'error_description', 'Y');

Insert into RNT_ERROR_DESCRIPTION
   (ERROR_ID, ERROR_CODE, SHORT_DESCRIPTION, LONG_DESCRIPTION, SHOW_LONG_DESCRIPTION_YN, CLASSIFIED_DESCRIPTION, DISPLAY_SHORT_DESCRIPTION_YN)
 Values
   (38, 20180, 'Position in property must be unique.', '<strong>What does this mean?</strong><br />
Position of loan in property must be unique.<br />
<strong>How do i fix it?<br />
</strong>Change value of position.', 'Y', 'loans', 'Y');

Insert into RNT_ERROR_DESCRIPTION
   (ERROR_ID, ERROR_CODE, SHORT_DESCRIPTION, LONG_DESCRIPTION, SHOW_LONG_DESCRIPTION_YN, CLASSIFIED_DESCRIPTION, DISPLAY_SHORT_DESCRIPTION_YN)
 Values
   (39, 20181, 'Cannot delete record. For loan exists accounts receivable.', '<strong>What does this mean?</strong><br />
Cannot delete record. For loan exists receivable records on receivable screen.<br />', 'Y', 'loans', 'Y');

Insert into RNT_ERROR_DESCRIPTION
   (ERROR_ID, ERROR_CODE, SHORT_DESCRIPTION, LONG_DESCRIPTION, SHOW_LONG_DESCRIPTION_YN, CLASSIFIED_DESCRIPTION, DISPLAY_SHORT_DESCRIPTION_YN)
 Values
   (40, 20182, 'Cannot delete record. For loan exists accounts payable.', '<strong>What does this mean?</strong><br />
Cannot delete record. For loan exists payable records on payable screen.', 'Y', 'loans', 'Y');

Insert into RNT_ERROR_DESCRIPTION
   (ERROR_ID, ERROR_CODE, SHORT_DESCRIPTION, LONG_DESCRIPTION, SHOW_LONG_DESCRIPTION_YN, CLASSIFIED_DESCRIPTION, DISPLAY_SHORT_DESCRIPTION_YN)
 Values
   (48, 20430, 'Update values ("BusinessName", "Supplier Name") must be unique.', '<strong>What does this mean?</strong><br />
Already exists record with attribute values (&lt;BusinessUnit&gt;, &lt;Supplier Name&gt;).<br />
<br />
<strong>How do i fix it?</strong><br />
Change Supplier Name attribute.', 'Y', 'suppliers', 'Y');

Insert into RNT_ERROR_DESCRIPTION
   (ERROR_ID, ERROR_CODE, SHORT_DESCRIPTION, LONG_DESCRIPTION, SHOW_LONG_DESCRIPTION_YN, CLASSIFIED_DESCRIPTION, DISPLAY_SHORT_DESCRIPTION_YN)
 Values
   (50, 20460, 'Date available for unit must be unique.', '<strong>What does this mean?</strong><br />
One and only one agreement can be conslusion in Date Available for Unit. <br />
<br />
<strong>How do i fix it?<br />
</strong>Change Data Available.', 'Y', 'tenancy_agreement', 'Y');

Insert into RNT_ERROR_DESCRIPTION
   (ERROR_ID, ERROR_CODE, SHORT_DESCRIPTION, LONG_DESCRIPTION, SHOW_LONG_DESCRIPTION_YN, CLASSIFIED_DESCRIPTION, DISPLAY_SHORT_DESCRIPTION_YN)
 Values
   (36, 20125, 'Cannot delete record. Find sub units for business unit.', '<strong>What does this mean?</strong><br />
<span lang="EN-US" style="background: white none repeat scroll 0%; font-size: 10pt; font-family: Arial; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial;">Cannot delete record. Find sub units for business unit.<br />
</span><br />
<strong>How do i fix it?</strong><br />
Delete subunits for this parent business unit', 'Y', 'business_units', 'Y');

Insert into RNT_ERROR_DESCRIPTION
   (ERROR_ID, ERROR_CODE, SHORT_DESCRIPTION, LONG_DESCRIPTION, SHOW_LONG_DESCRIPTION_YN, CLASSIFIED_DESCRIPTION, DISPLAY_SHORT_DESCRIPTION_YN)
 Values
   (26, 20370, 'Unit name must be unique for property.', '<strong>What does this mean?</strong><br />
Unit name must be unique for property.<br />
<br />
<strong>How do i fix it?</strong><br />
Change unit name for unique in property.', 'Y', 'properties', 'Y');

Insert into RNT_ERROR_DESCRIPTION
   (ERROR_ID, ERROR_CODE, SHORT_DESCRIPTION, LONG_DESCRIPTION, SHOW_LONG_DESCRIPTION_YN, CLASSIFIED_DESCRIPTION, DISPLAY_SHORT_DESCRIPTION_YN)
 Values
   (41, 20220, 'Update values must be unique.', '<strong>What does this mean?</strong><br />
<br />
<strong>How do i fix it?</strong><br />
<br />
<strong>What would happen if I ignore it?</strong>', 'N', 'payments', 'Y');
Insert into RNT_ERROR_DESCRIPTION
   (ERROR_ID, ERROR_CODE, SHORT_DESCRIPTION, LONG_DESCRIPTION, SHOW_LONG_DESCRIPTION_YN, CLASSIFIED_DESCRIPTION, DISPLAY_SHORT_DESCRIPTION_YN)
 Values
   (42, 20221, 'Insert values must be unique.', '<strong>What does this mean?</strong><br />
<br />
<strong>How do i fix it?</strong><br />
<br />
<strong>What would happen if I ignore it?</strong>', 'N', 'payments', 'Y');

Insert into RNT_ERROR_DESCRIPTION
   (ERROR_ID, ERROR_CODE, SHORT_DESCRIPTION, LONG_DESCRIPTION, SHOW_LONG_DESCRIPTION_YN, CLASSIFIED_DESCRIPTION, DISPLAY_SHORT_DESCRIPTION_YN)
 Values
   (49, 20431, 'Insert values ("BusinessName", "Supplier Name") must be unique.', '<strong>What does this mean?</strong><br />
Combination of attributes (&lt;BusinessName&gt;, &lt;Supplier Name&gt;) must be unique.<br />
<br />
<strong>How do i fix it?</strong><br />
Change Supplier Name.', 'Y', 'suppliers', 'Y');
Insert into RNT_ERROR_DESCRIPTION
   (ERROR_ID, ERROR_CODE, SHORT_DESCRIPTION, LONG_DESCRIPTION, SHOW_LONG_DESCRIPTION_YN, CLASSIFIED_DESCRIPTION, DISPLAY_SHORT_DESCRIPTION_YN)
 Values
   (51, 20461, 'Cannot delete agreement. For agreement exists accounts receivable.', '<strong>What does this mean?</strong><br />
&nbsp;Can not delete agreement.<br />
<strong>How do i fix it?<br />
</strong>&nbsp;Delete records for this agreeement from Receivable screen.', 'Y', 'tenancy_agreement', 'Y');

Insert into RNT_ERROR_DESCRIPTION
   (ERROR_ID, ERROR_CODE, SHORT_DESCRIPTION, LONG_DESCRIPTION, SHOW_LONG_DESCRIPTION_YN, CLASSIFIED_DESCRIPTION, DISPLAY_SHORT_DESCRIPTION_YN)
 Values
   (52, 20472, 'Is special non database exception for description exceptions 
-20462..-20471)
-20462	The agreement does not have a primary tenant.
-20463	The agreement has a primary tenant but the agreement start date is null.
-20464	The agreement has a primary tenant but the agreement start date is in the future.
-20465	The agreement dates overlap with another agreement.
-20466	The agreement end date is less than 30 days in the future.
-20467	The agreement end date is less than 60 days in the future.
-20468	The agreement has expired.
-20469	The agreement end date is earlier than the agreement start date.
-20470	Section 8 office has been selected by tenant pays is null.
-20471	A value has been entered in one of the late fee fields but one of the other fields is null.', '<strong>The agreement does not have a primary tenant.<br />
</strong>&nbsp; In this case system can not generate receivable records.<br />
<br />
<strong>The agreement has a primary tenant but the agreement start date is null.<br />
</strong>&nbsp; In this case system can not generate receivable records.<br />
<br />
<strong>The agreement has a primary tenant but the agreement start date is in the future.<br />
&nbsp; </strong>&nbsp; In this case system can start generate receivable records only from agreement start date.<br />
<br />
<strong>The agreement dates overlap with another agreement.<br />
</strong>&nbsp;&nbsp; In this case system can not define records generate receivable records.<br />
<br />
<strong>The agreement end date is less than 30 days in the future.<br />
</strong>&nbsp;&nbsp; Very short period for agreement.<br />
<br />
<strong>The agreement end date is less than 60 days in the future.<br />
</strong>&nbsp;&nbsp; Short period for agreement.<br />
<br />
<strong>The agreement has expired.<br />
</strong>&nbsp;&nbsp; Need new agreement.<br />
<br />
<strong>The agreement end date is earlier than the agreement start date.<br />
&nbsp;&nbsp;</strong> Very short period for agreement.<strong> <br />
</strong><br />
<strong>Section 8 office has been selected by tenant pays is null.<br />
</strong>&nbsp;&nbsp; If tenant pays is null then must be defined Section 8 Office.<br />
<br />
<strong>A value has been entered in one of the late fee fields but one of the other fields is null.</strong><br />
&nbsp;&nbsp; If one late fee field is not empty then all late fee fields must be filled.', 'Y', 'tenancy_agreement', 'N');

Insert into RNT_ERROR_DESCRIPTION
   (ERROR_ID, ERROR_CODE, SHORT_DESCRIPTION, LONG_DESCRIPTION, SHOW_LONG_DESCRIPTION_YN, CLASSIFIED_DESCRIPTION, DISPLAY_SHORT_DESCRIPTION_YN)
 Values
   (53, 20490, 'People for agreement must be unique.', '<strong>What does this mean?</strong><br />
Tenant for agreement must be unique. In one agreement can not be two identical tenants.<br />', 'Y', 'tenant', 'Y');

Insert into RNT_ERROR_DESCRIPTION
   (ERROR_ID, ERROR_CODE, SHORT_DESCRIPTION, LONG_DESCRIPTION, SHOW_LONG_DESCRIPTION_YN, CLASSIFIED_DESCRIPTION, DISPLAY_SHORT_DESCRIPTION_YN)
 Values
   (54, 20492, 'Tenant with status "Current - Primary", must be one in agreement.', '<strong>What does this mean?</strong><br />
Tenant with status &quot;Current - Primary&quot;, must be one in agreement.', 'Y', 'tenant', 'Y');

Insert into RNT_ERROR_DESCRIPTION
   (ERROR_ID, ERROR_CODE, SHORT_DESCRIPTION, LONG_DESCRIPTION, SHOW_LONG_DESCRIPTION_YN, CLASSIFIED_DESCRIPTION, DISPLAY_SHORT_DESCRIPTION_YN)
 Values
   (58, 20550, 'User must have unique role and business unit.', '<strong>What does this mean?</strong><br />
<br />
<strong>How do i fix it?</strong><br />
<br />
<strong>What would happen if I ignore it?</strong>', 'N', 'user_assignments', 'Y');

Insert into RNT_ERROR_DESCRIPTION
   (ERROR_ID, ERROR_CODE, SHORT_DESCRIPTION, SHOW_LONG_DESCRIPTION_YN, CLASSIFIED_DESCRIPTION, DISPLAY_SHORT_DESCRIPTION_YN)
 Values
   (56, 20521, 'Password not changed', 'N', 'users', 'Y');

Insert into RNT_ERROR_DESCRIPTION
   (ERROR_ID, ERROR_CODE, SHORT_DESCRIPTION, LONG_DESCRIPTION, SHOW_LONG_DESCRIPTION_YN, CLASSIFIED_DESCRIPTION, DISPLAY_SHORT_DESCRIPTION_YN)
 Values
   (57, 20522, 'User login must be unique.', '<strong>What does this mean?</strong><br />
<br />
<strong>How do i fix it?</strong><br />
<br />
<strong>What would happen if I ignore it?</strong>', 'N', 'users', 'Y');

Insert into RNT_ERROR_DESCRIPTION
   (ERROR_ID, ERROR_CODE, SHORT_DESCRIPTION, LONG_DESCRIPTION, SHOW_LONG_DESCRIPTION_YN, CLASSIFIED_DESCRIPTION, DISPLAY_SHORT_DESCRIPTION_YN)
 Values
   (55, 20520, 'Cannot change password. Old password is a not valid.', '<strong><br />
</strong>', 'N', 'users', 'Y');

Insert into RNT_ERROR_DESCRIPTION
   (ERROR_ID, ERROR_CODE, SHORT_DESCRIPTION, LONG_DESCRIPTION, SHOW_LONG_DESCRIPTION_YN, CLASSIFIED_DESCRIPTION, DISPLAY_SHORT_DESCRIPTION_YN)
 Values
   (43, 20371, 'Unit name must be unique for property.', '<strong>What does this mean?</strong><br />
<span lang="EN-US" style="background: white none repeat scroll 0%; font-size: 10pt; font-family: Arial; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial;">Property already consists unit name.<br />
</span><br />
<strong>How do i fix it?</strong><br />
Change unit name.<br />', 'Y', 'properties', 'Y');

Insert into RNT_ERROR_DESCRIPTION
   (ERROR_ID, ERROR_CODE, SHORT_DESCRIPTION, LONG_DESCRIPTION, SHOW_LONG_DESCRIPTION_YN, CLASSIFIED_DESCRIPTION, DISPLAY_SHORT_DESCRIPTION_YN)
 Values
   (44, 20372, 'Security error. You cannot insert this unit.', '<strong>What does this mean?</strong><br />
You have not privilege for insert unit.', 'Y', 'properties', 'Y');

Insert into RNT_ERROR_DESCRIPTION
   (ERROR_ID, ERROR_CODE, SHORT_DESCRIPTION, LONG_DESCRIPTION, SHOW_LONG_DESCRIPTION_YN, CLASSIFIED_DESCRIPTION, DISPLAY_SHORT_DESCRIPTION_YN)
 Values
   (45, 20373, 'Cannot delete record. For unit exists agreement record.', '<strong>What does this mean?</strong><br />
Already exists agreement record(s) for this unit.<br />
<br />
<strong>How do i fix it?</strong><br />
Delete agreements from agreement screen.<br />', 'Y', 'properties', 'Y');

Insert into RNT_ERROR_DESCRIPTION
   (ERROR_ID, ERROR_CODE, SHORT_DESCRIPTION, LONG_DESCRIPTION, SHOW_LONG_DESCRIPTION_YN, CLASSIFIED_DESCRIPTION, DISPLAY_SHORT_DESCRIPTION_YN)
 Values
   (46, 20374, 'Cannot delete record. For unit exists property expenses.', '<strong>What does this mean?<br />
</strong> Exists property expenses records on Property Expenses ssreen.<br />
<br />
<strong>How do i fix it?<br />
</strong> Delete records for unit from Property Expenses screen.', 'Y', 'properties', 'Y');

Insert into RNT_ERROR_DESCRIPTION
   (ERROR_ID, ERROR_CODE, SHORT_DESCRIPTION, LONG_DESCRIPTION, SHOW_LONG_DESCRIPTION_YN, CLASSIFIED_DESCRIPTION, DISPLAY_SHORT_DESCRIPTION_YN)
 Values
   (47, 20400, 'Cannot delete record. For Section8 exists tenant.', '<strong>What does this mean?</strong><br />
Cannot delete record. For Section8 exists tenant.<br />
<br />
<strong>How do i fix it?<br />
</strong>Delete tenants from Tenant screen for this Section8 record.<br />', 'Y', 'section8', 'Y');
COMMIT;
