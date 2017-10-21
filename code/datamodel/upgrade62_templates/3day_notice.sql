declare
  v_agreement varchar2(32767) := 
'
<h1>3 Day Notice to Pay Rent or Quit</h1>

<p>
NOTICE TO: {{TENANT}} in possession  and all others:
</p>
<p>
TAKE NOTICE THAT:
</p>
<ol>
<li>Pursuant to a written Lease dated {{START}} you are obligated to pay certain rents on the premises described as: {{ADDRESS}}, {{CITY}}, {{STATE}}, {{ZIP}} ("The premises") of which you now hold possession.</li>

<li>You are late in  payments totaling {{UNPAID}}. This rent was due on {{UNPAID-DATE}} and relates to rent for the month of {{UNPAID-MONTH}}.</li>

<li>You are hereby required to EITHER (1) PAY the said rents, in full to the Landlord within 3 days after service of this notice OR (2) DELIVER possession of the premises to the Landlords.</li>

<li>If you do not pay the rent due or peaceably deliver possession of the premises by noon on {{TERMINATION-DATE}}, your Lease to the premises will be terminated as of that date.<li>
</ol>

<p>THIS NOTICE TO QUIT IS GIVEN PURSUANT OF THE APPLICABLE LAWS OF THE STATE OF FLORIDA AND IN NO WAY LIMITS OR IMPAIRS ANY OF THE OTHER REMEDIES OR RIGHT THAT THE LANDLORD MAY HAVE UNDER THE LEASE OR UNDER SAID LAWS.</p>

<p>
Issued on: {{SYSDATE}}
</p>
<br/>
<br/>
<br/>
<br/>
<br/>
<p>		
{{LANDLORD}}<br/>
Landlord<br/>
Contact phone number {{PHONE}}
</p>';

v_doc_id number;

begin
  v_doc_id := RNT_DOC_TEMPLATES_PKG.insert_row( X_NAME        => 'Florida 3-day Notice'
                                              , X_BUSINESS_ID => null
                                              , X_CONTENT     => v_agreement);
end;
/