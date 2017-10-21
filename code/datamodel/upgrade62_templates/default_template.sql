delete from  rnt_doc_templates  where template_id = 0;
 insert into rnt_doc_templates 
  (TEMPLATE_ID, name, content) 
 values
 (0, 'Default Template', 
 'Edit this document to create a template for tenancy agreements or standard letters.
  The template will appear in the Tenant-Actions screen for your business unit.
  Substitution codes can be entered to populate values in the template automatically 
  for a tenancy agreement.  Visulate supports the following codes:
 <ul>
 <li><strong>Today''s Date:</strong> {{SYSDATE}}</li>
 <li><strong>Tenant'' Name:</strong> {{TENANT}}</li>
 <li><strong>Agreement Start Date:</strong> {{START}}</li>
 <li><strong>Agreement End Date:</strong> {{END}}</li>
 <li><strong>Rent Amount:</strong> {{RENT}}</li>
 <li><strong>Rental Period (week, month.. etc):</strong> {{PERIOD}}</li>
 <li><strong>Security Deposit:</strong> {{SECURITY}}</li>
 <li><strong>Last Month:</strong> {{LAST}}</li>
 <li><strong>Agreement Term:</strong> {{TERM}}</li>
 <li><strong>Late Fee Amount:</strong> {{LATE_FEE}}</li>
 <li><strong>Late Fee Period:</strong> {{LF_PERIOD}}</li>
 <li><strong>Current Unpaid Balance:</strong> {{UNPAID}}</li>
 <li><strong>Property Address:</strong> {{ADDRESS}}</li>
 <li><strong>Property City:</strong> {{CITY}}</li>
 <li><strong>Property State:</strong> {{STATE}}</li>
 <li><strong>Property Zipcode:</strong> {{ZIP}}</li>
</ul>
For example, to include the tenant''s name and current unpaid balance amount in a standard 
letter: {{TENANT}}, you are late in payments totaling {{UNPAID}}');                                                        