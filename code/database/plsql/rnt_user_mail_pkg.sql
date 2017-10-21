set define ^

CREATE OR REPLACE PACKAGE        RNT_USER_MAIL_PKG AS
/******************************************************************************
   NAME:       RNT_USER_MAIL_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        05.12.2007  aguk             Created this package.
   1.1        09.06.2008  pgoldtho         Modified message templates          
******************************************************************************/
X_ADMIN_MAIL    CONSTANT  varchar2(100) := 'donotreply@visulate.net';
X_NOTIFICATION  CONSTANT  varchar2(100) := 'peter@goldthorp.com';
X_SERVER_ROOT   CONSTANT varchar2(200)  := 'https://www.visulate.net/rental'; 

x_welcome_message      varchar2(4000) :=
'$NAME$, your Visulate account has been activated.'||CHR(10)||
                'Please go to '||X_SERVER_ROOT||'/login.php?login=$LOGIN$' ||
                ' and login as: $LOGIN$ '||CHR(10)||
                ' with a password of: $PASSWD$'||chr(10)||chr(10)||chr(10)||
                'Please do not reply to this email.  '||
                ' It was sent from an automated account that is not monitored.' ;

x_password_message      varchar2(4000) :=
'Visulate Password for $NAME$.'||CHR(10)||
                '  Your login: $LOGIN$ '||CHR(10)||
                '  Your password: $PASSWORD$ '||CHR(10)||
                '  Address: '||X_SERVER_ROOT||'/login.php?login=$LOGIN$'||chr(10)||chr(10)||
                'Please do not reply to this email.  '||
                ' It was sent from an automated account that is not monitored.' ;

x_register_message      varchar2(4000) :=
                'Please read the Application Services Agreement printed below and CONFIRM YOUR AGREEMENT'||
                ' with its terms by clicking on the following link:'||chr(10)||chr(10)||
                X_SERVER_ROOT||'/login.php?hash=$HASH$">'||chr(10)||chr(10)||
                'This should take you to the Visulate website where you can login with the following:'||chr(10)||chr(10)||
                '  Username: $LOGIN$ '      ||CHR(10)||
                '  Password: $PASSWORD$ '||CHR(10)||chr(10)||
                'Once logged in you can change your password by clicking on the preferences link at the top of the page'
                ||CHR(10)||chr(10)||
                'Please do not reply to this email.  '||
                ' It was sent from an automated account that is not monitored.'||
                ' Please delete this email if you do not agree to the terms of the Application Services Agreement';



x_service_agreement    varchar2(32000) :=
'
=====================================================================



APPLICATION SERVICES AGREEMENT

THIS AGREEMENT ("Agreement") is entered into on $DATE$, between Visulate LLC (Licensor, we, us, or our), with its principal place of business located at Merritt Island, Florida and $NAME$ (Licensee, you or your), and shall be effective as of $DATE$ (the "Effective Date").

The parties will indicate their acceptance of this Agreement in one of the following manners:

(i) Your requesting a Visulate account and acknowledging receipt of the request by Visulate; 
or
(ii) Signing below as indicated. 

RECITALS
WHEREAS, Licensor is engaged in the business of providing access to Software and Licensor''s application server; WHEREAS, Licensee desires to retain Licensor to perform the services provided for in this agreement. NOW, THEREFORE, Licensor and Licensee agree as follows:

1.         Grant of License
            Subject to the terms and conditions herein, Licensor hereby grants Licensee a nonexclusive license to (i) access and execute Visulate (the "Software") on Licensor''s application server over the Internet, and (ii) transmit data related to Licensee''s use of the Software over the Internet.

2.         Use and Access
            A.         Subject to the restrictions on use as set forth herein, Licensee will have access to the Software and Licensor''s application server for the purpose of using the software for its intended purpose and in accordance with the specifications set forth in any documentation relating to the Software provided by Licensor. Such use and access will be continuous on a 24/ basis except for interruptions by reason of maintenance or downtime beyond Licensor''s reasonable control.

            B.         Licensee will use the Software only for its internal business operations and will not permit the Software to be used by or for the benefit of anyone other than Licensee. Licensee will not have the right to re-license or sell rights to access and/or use the Licensed Software or to transfer or assign rights to access or use the Software, except as expressly provided herein. Licensee may not modify, translate, reverse engineer, decompile or create derivative works based upon the Software. Licensee agrees to use the Software in a manner that complies with all applicable laws including intellectual property and copyright laws. Licensor expressly reserves all rights not expressly granted to Licensee herein.

            C.         Licensee will not: (i) transmit or share identification or password codes to persons other than authorized users (ii) permit the identification or password codes to be cached in proxy servers and accessed by individuals who are not authorized users, or (iii) permit access to the software through a single identification or password code being made available to multiple users on a network.

            D.         Licensor will provide Fifty (50) Megabytes of space on the application server for Licensee to use for storage of data necessary for use of the Software. If Licensee''s use exceeds the base storage space allotted, Licensee will pay a rate of $1 per megabyte over the allotted storage. Such incremental fees will be calculated on the average monthly storage overage and invoiced quarterly.

3.         Price and Payment

             A.  During the Term and any Renewal Terms, Licensor may periodically review your credit history.  This review may consist of a review of your payment history with us, your broader credit history as reported elsewhere, and the amount of fraud reported to us as originating with your account.  By entering into this Agreement, you consent to this review, and the disclosure of your credit history, at our option, to recognized credit agencies.

             B.  You must pay any non-recurring charges, such as set up fees, as set out on our web site.  Payment of these non-recurring charges is a pre-requisite to our obligation to provide services to you.

             C.  If you provide us with a credit card, we will bill all charges authorized by this Agreement to that credit card. In addition, we reserve the right to bill that credit card for past due services regardless of whether we regularly billed that credit card in the past. If you choose monthly billing, you are required to keep a valid credit card on file. Should you choose to remove this credit card, you will be required to choose a billing cycle for which recurring automatic charges are not required. We reserve the right to bill you for fees charged to us by our credit card processor, plus $200 special processing fee, for disputes initiated by you, which are resolved in our favor.

Unless otherwise set out on an individual Service Attachment, you agree to pay all charges by the due date indicated on the invoice ("Due Date"). You will pay us interest on payments made following the Due Date at the rate of 1.5% per month or the maximum rate allowable by law. You may be assessed a processing fee on late payments, at our sole discretion, if we incur administrative and/or legal costs associated with your late payment. Those costs are calculated on an hourly basis, rounded up to the next full hour, and are based on our current hourly rates. If your check is returned by your bank, you will be billed any return check fee charged to us plus a $25 special handling & processing fee. If you do not pay all undisputed amounts by the Due Date, we reserve the right to disconnect services and refuse to continue to provide them to you.

            D.  We have calculated our fees based on the Term.  Accordingly, fees will only be refunded as is expressly set out in this Agreement.  Regardless of the Guarantee, Effective Date, Term, or Renewal Term, should you be required to make advance payment for certain services, or pay certain service fees, those fees are not refundable should you choose to terminate the Agreement for any reason.

            E.  We reserve the right to bill you retroactively for any services provided to you for which we had not previously billed.  We also reserve the right to bill you retroactively for the costs of the removal and storage of equipment you have placed in our facility if this Agreement is terminated and this equipment is not removed by you.  We also reserve the right to sell your equipment to satisfy your outstanding storage charges.

            F. You have up to 25 days (commencing five days after the date of our bill, or on the date on which your credit card is charged) to initiate a dispute over charges or to receive credits, if applicable.  In order to dispute your bill, you must send us a written itemized description of the specific items you dispute in your bill.  This itemization must be in sufficient detail for us to identify the items in dispute.  We must receive this information prior to the date set out above.  You agree to pay by the Due Date all charges not specifically itemized in your written notice of dispute.

            G.         The fees for the license of the Software do not include taxes. If Licensor is required to pay or collect any federal, state, local, or value-added tax on any fees charged under this Agreement, or any other similar taxes or duties levied by any governmental authority, excluding taxes levied on Licensor''s net income, then such taxes and/or duties will be billed to and paid by Licensee immediately upon receipt of Licensor''s invoice and supporting documentation for the taxes or duties charged.

4.         Technical Support
            Licensor will supply telephone support regarding the Software to Licensee on a reasonable and necessary basis during normal weekday business hours, excluding legal holidays. Additionally, Licensor will, if necessary, provide reasonable support to Licensee through electronic and/or written correspondence.

5.         Term and Termination

            A.         The initial term of this Agreement will commence the day the web site interface for the Software is accessible via the Internet, (within a commercially reasonable time after payment is received) and will continue for a period of one (1) year. Thereafter this Agreement will automatically renew for successive one (1) year periods unless either party gives the other party not fewer than thirty (30) days notice of its intent not to renew, or unless terminated earlier under the terms contained within this Agreement.

            B.         Either party may terminate this agreement for material breach, provided, however, that the terminating party has given the other party at least twenty-one (21) days written notice of and the opportunity to cure the breach. Termination for breach will not preclude the terminating party from exercising any other remedies for breach.

6.         Ownership of Intellectual Property
            Title to any proprietary rights in the Software or Licensor''s web site will remain in and be the sole and exclusive property of Licensor. Licensee will be the owner of all content created and posted by Licensee.

7.         Confidentiality

            A.         Licensee acknowledges that the Software and other data on Licensor''s application server embodies logic, design and coding methodology that constitute valuable confidential information that is proprietary to Licensor. Licensee will safeguard the right to access the Software and other software installed on Licensor''s application server using the same standard of care that Licensee uses for its own confidential materials.

            B.         All data pertaining to Licensee disclosed to Licensor in connection with the performance of this Agreement and residing on Licensor''s application server will be held as confidential by Licensor and will not, without the prior written consent of Licensee, be disclosed or be used for any purposes other than the performance of this Agreement. Licensor will safeguard the confidentiality of such data using the same standard of care that Licensor uses for its own confidential materials. This obligation does not apply to data that: (i) is or becomes, through no act or failure to act on the part of Licensor, generally known or available; (ii) is known by Licensor at the time of receiving such information as evidenced by its written records; (iii) is hereafter furnished to Licensor by a third party, as a matter of right and without restriction on disclosure; (iv) is independently developed by Licensor as evidenced by its written and dated records and without any breach of this Agreement; or (v) is the subject of a written permission to disclose provided by Licensee. Further notwithstanding the forgoing, disclosure of data will not be precluded if such disclosure: (i) is in response to a valid order of a court or other governmental body of the United States; (ii) is otherwise required by law; or (iii) is otherwise necessary to establish rights or enforce obligations under this Agreement, but only to the extent that any such disclosure is necessary.

8.         Warranty and Disclaimer
            Licensor warrants the Software is developed and will be provided in conformity with generally prevailing industry standards. Licensee must report any material deficiencies in the Software to Licensor in writing within thirty (30) days of Licensee''s discovery of the defect. Licensor''s exclusive remedy for the breach of the above warranty will be for Licensor to provide access to replacement Software within a commercially reasonable time. THIS WARRANTY IS EXCLUSIVE AND IS IN LIEU OF ALL OTHER WARRANTIES, WHETHER EXPRESS OR IMPLIED, INCLUDING ANY WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE AND ANY ORAL OR WRITTEN REPRESENTATIONS, PROPOSALS OR STATEMENTS MADE ON OR PRIOR TO THE EFFECTIVE DATE OF THIS AGREEMENT. DEVELOPER EXPRESSLY DISCLAIMS ALL OTHER WARRANTIES.

9.         Limitation of Liability, Indemnification
            Neither party will be liable to the other for special, indirect or consequential damages incurred or suffered by the other arising as a result of or related to the use of the Software, whether in contract, tort or otherwise, even if the other has been advised of the possibility of such loss or damages. Licensee will indemnify and hold Licensor harmless against any claims incurred by Licensor arising out of or in conjunction with Licensee''s breach of this Agreement, as well as all reasonable costs, expenses and attorneys'' fees incurred therein. Licensor''s total liability under this Agreement with respect to the Software, regardless of cause or theory of recovery, will not exceed the total amount of fees paid by Licensee to Licensor during the twelve month period immediately preceding the occurrence or act or omission giving rise to the claim.

10.       Relation of Parties
            Nothing in this Agreement will create or imply an agency relationship between the parties, nor will this Agreement be deemed to constitute a joint venture or partnership between the parties.

11.       Non-assignment
            Neither party will assign this Agreement, in whole or in part, without the prior written consent of the other party, and such consent will not be unreasonably withheld. This Agreement will inure to the benefit of, and be binding upon the parties hereto, together with their respective legal representatives, successors, and assigns, as permitted herein.

12.       Arbitration
            Any dispute arising under this Agreement will be subject to binding arbitration by a single Arbitrator with the American Arbitration Association (AAA), in accordance with its relevant industry rules, if any. The parties agree that this Agreement will be governed by and construed and interpreted in accordance with the laws of the State of Florida. The arbitration will be held in Florida. The Arbitrator will have the authority to grant injunctive relief and specific performance to enforce the terms of this Agreement. Judgment on any award rendered by the Arbitrator may be entered in any Court of competent jurisdiction.

13.       Attorneys'' Fees
            If any litigation or arbitration is necessary to enforce the terms of this Agreement, the prevailing party will be entitled to reasonable attorneys'' fees and costs.

14.       Severability
            If any term of this Agreement is found to be unenforceable or contrary to law, it will be modified to the least extent necessary to make it enforceable, and the remaining portions of this Agreement will remain in full force and effect.

15.       Force Majeure
            Neither party will be held responsible for any delay or failure in performance of any part of this Agreement to the extent that such delay is caused by events or circumstances beyond the delayed party''s reasonable control.

16.       Waiver and Modification
            The waiver by any party of any breach of covenant will not be construed to be a waiver of any succeeding breach or any other covenant. All waivers must be in writing, and signed by the party waiving its rights. This Agreement may be modified only by a written instrument executed by authorized representatives of the parties hereto.

17.       Entire Agreement
            This Agreement constitutes the entire agreement between the parties with respect to its subject matter, and supersedes all prior agreements, proposals, negotiations, representations or communications relating to the subject matter. Both parties acknowledge that they have not been induced to enter into this Agreement by any representations or promises not specifically stated herein.
            IN WITNESS WHEREOF, the parties have executed this Agreement by their duly authorized representatives.


Provider: Visulate LLC              Client: $NAME$


      By:_____________________          By: __________________________


  Title:______________________       Title:___________________________
';








procedure email_enabled_account(X_USER_ID in RNT_USERS.USER_ID%TYPE);

procedure recover_password( X_USER_LOGIN    in RNT_USERS.USER_LOGIN%TYPE
                          , X_USER_PASSWORD in RNT_USERS.USER_PASSWORD%TYPE);

procedure register_account_msg(X_USER_REGISTRY_ID in RNT_USER_REGISTRY.USER_REGISTRY_ID%TYPE);


END RNT_USER_MAIL_PKG;
/

SHOW ERRORS;

CREATE OR REPLACE PACKAGE BODY        RNT_USER_MAIL_PKG AS
/******************************************************************************
   NAME:       RNT_USER_MAIL_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        05.12.2007             1. Created this package body.
******************************************************************************/
procedure email_enabled_account(X_USER_ID in RNT_USERS.USER_ID%TYPE)
is
  email_user       RNT_USERS.USER_LOGIN%TYPE;
  x_name           varchar2(300);
  x_passwd         rnt_users.user_password%type;
  x_template       varchar2(4000);
begin
  update RNT_USERS
  set IS_ACTIVE_YN = 'Y'
  where USER_ID    = X_USER_ID;
  commit;
  
  select USER_LOGIN
  ,      USER_NAME||' '||USER_LASTNAME
  ,      RNT_OBFURCATION_PASSWORD_PKG.DECRYPT(USER_PASSWORD)
  into email_user
  ,    x_name
  ,    x_passwd
  from RNT_USERS
  where USER_ID = X_USER_ID; 
  
  x_template := x_welcome_message;
  
  x_template := replace(x_template, '$NAME$', x_name);
  x_template := replace(x_template, '$LOGIN$', email_user);
  x_template := replace(x_template, '$PASSWD$', x_passwd);

  utl_mail.send(sender       => X_ADMIN_MAIL,
                recipients   => email_user,
                subject      => 'Visulate Account Activation',
                message      => x_template);
end;

procedure recover_password( X_USER_LOGIN    in RNT_USERS.USER_LOGIN%TYPE
                          , X_USER_PASSWORD in RNT_USERS.USER_PASSWORD%TYPE)
is
  x_template varchar2(4000);
  x_name varchar2(200);
begin
  select USER_NAME||' '||USER_LASTNAME
  into x_name
  from RNT_USERS
  where upper(USER_LOGIN) = upper(X_USER_LOGIN);   

  x_template := x_password_message;
  
  x_template := replace(x_template, '$NAME$', x_name);
  x_template := replace(x_template, '$LOGIN$', X_USER_LOGIN);
  x_template := replace(x_template, '$PASSWORD$', X_USER_PASSWORD);

  utl_mail.send(sender       => X_ADMIN_MAIL,
                recipients   => X_USER_LOGIN,
                subject      => 'Visulate Password',
                message      => x_template);
end;


procedure register_account_msg(X_USER_REGISTRY_ID in RNT_USER_REGISTRY.USER_REGISTRY_ID%TYPE)
is
  t                  RNT_USER_REGISTRY%ROWTYPE;
  X_INVITE_MAIL      varchar2(1024) := X_ADMIN_MAIL;
  iu                 RNT_USERS%ROWTYPE;
  x_template         varchar2(10000);
  x_invite_string    varchar2(300) := 'Your Visulate account request has been processed. ';
begin
  select *
  into t
  from RNT_USER_REGISTRY
  where USER_REGISTRY_ID = X_USER_REGISTRY_ID;
  
  if t.INVITE_USER_ID is not null then
     select *
     into iu
     from RNT_USERS
     where USER_ID = t.INVITE_USER_ID;
     x_invite_string := 'A Visulate account has been created for you by '
                        ||iu.USER_NAME||' '||iu.USER_LASTNAME||
                        ' ('||iu.USER_LOGIN||').'||CHR(10); 
  end if;   
      
  x_template := x_invite_string||x_register_message;  

  x_template := replace(x_template, '$NAME$', t.USER_NAME||' '||t.USER_LAST_NAME);
  x_template := replace(x_template, '$LOGIN$', t.USER_LOGIN_EMAIL);
  x_template := replace(x_template, '$PASSWORD$', RNT_OBFURCATION_PASSWORD_PKG.DECRYPT(t.USER_PASSWORD));
  x_template := replace(x_template, '$HASH$', t.USER_HASH_VALUE);

  x_service_agreement := replace(x_service_agreement, '$NAME$',  t.USER_NAME||' '||t.USER_LAST_NAME);
  x_service_agreement := replace(x_service_agreement, '$DATE$',  to_char(sysdate, 'Month dd, yyyy'));
     
  utl_mail.send(sender       => X_ADMIN_MAIL,
                recipients   => t.USER_LOGIN_EMAIL,
                subject      => 'Visulate Account Details',
                message      => x_template||x_service_agreement);

  x_template := 'An account request has been received from $NAME$, email $LOGIN$, telephone $PHONE$';
  x_template := replace(x_template, '$NAME$', t.USER_NAME||' '||t.USER_LAST_NAME);
  x_template := replace(x_template, '$LOGIN$', t.USER_LOGIN_EMAIL);
  x_template := replace(x_template, '$PHONE$', t.TELEPHONE);

  utl_mail.send(sender       => X_ADMIN_MAIL,
                recipients   => X_NOTIFICATION,
                subject      => 'Visulate Account Request',
                message      => x_template);

   
end;

END RNT_USER_MAIL_PKG;
/

SHOW ERRORS;
