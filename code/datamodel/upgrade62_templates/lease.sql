set define ^
declare
  v_agreement varchar2(32767) := 
'<P STYLE="margin-left: 2in; text-indent: 0.5in; margin-bottom: 0in">
<FONT SIZE=4>HOUSE, DUPLEX OR TRIPLEX LEASE</FONT></P>

<P STYLE="margin-left: 1.5in; text-indent: 0.5in; margin-bottom: 0in">LANDLORD:
{{LANDLORD}} 
</P>
<P STYLE="margin-left: 1.5in; text-indent: 0.5in; margin-bottom: 0in">Address
{{L_ADDRESS}}</P>
<P STYLE="margin-left: 1.5in; text-indent: 0.5in; margin-bottom: 0in">
<BR>
</P>
<P STYLE="margin-left: 1.5in; text-indent: 0.5in; margin-bottom: 0in">

<BR>
</P>
<P STYLE="margin-left: 1.5in; text-indent: 0.5in; margin-bottom: 0in">
<BR>
</P>
<P STYLE="margin-left: 1.5in; text-indent: 0.5in; margin-bottom: 0in">
<BR>
</P>
<P STYLE="margin-left: 1.5in; text-indent: 0.5in; margin-bottom: 0in">
TENANT:  
{{TENANT}}
</P>
<P STYLE="margin-left: 1.5in; text-indent: 0.5in; margin-bottom: 0in">
SS# {{SSN}} D/L# {{DL}}			</P>
<P STYLE="margin-left: 1.5in; text-indent: 0.5in; margin-bottom: 0in">
PROPERTY:  {{ADDRESS}}, {{CITY}}, {{STATE}}, {{ZIP}}

</P>

<P STYLE="margin-left: 1.5in; text-indent: 0.5in; margin-bottom: 0in">
<BR>
</P>
<P STYLE="margin-bottom: 0in">This Lease imposes important legal
obligations. Many rights and responsibilities of the parties are
governed by chapter 83, Part II residential landlord and tenant act,
{{STATE}} Statutes. IN CONSIDERATION of the mutual covenants and
agreements herein contained, Landlord hereby leases to Tenant and
Tenant hereby leases from Landlord the above-described property under
the following terms:</P>
<P STYLE="margin-bottom: 0in"><BR>
</P>
<OL >
	<LI><P STYLE="margin-bottom: 0in">TERM: The initial term of this
	lease will be for no more than One Year beginning {{START}} and
	ending on {{END}}.<br/>
        <B>HOLDOVER:</B> If Tenant maintains
	possession of the Premises for any period after the termination of
	this Lease (&quot;Holdover Period&quot;) Tenant shall pay to
	Landlord lease payment(s) during the Holdover Period at a rate equal
	to the rate preceding the Holdover Period or as reviewed by the
	Landlord in writing. Such holdover shall constitute a month-to-month
	extension of this lease until the return of the property keys. 
	</P>

	<LI><P STYLE="margin-bottom: 0in">RENT: The rent shall be ${{RENT}}
	per {{PERIOD}}. If it is paid by the 5th day of each month there will be
	a deduction of ${{LATE_FEE}}. The full amount will be due on the 6th day and
	thereafter, regardless of holidays or weekends.(therefore if the 5th
	falls on a Saturday or Sunday it needs to be received on the Friday
	before).  After the 10<SUP>th  </SUP> day a three day notice  will
	be posted and eviction proceedings will be started.  THE COST IS
	APPROXIMATLY $250.00. THIS WILL BE ADDED TO THE AMOUNT DUE and taken
	from any security deposit. In the event Tenant makes a rent payment
	with a worthless check an eviction(3 day) notice may be posted,
	Tenant agrees to pay a $25.00 charge.	<br/>			 									Initial____ 
	</P>
	<LI><P STYLE="margin-bottom: 0in">PAYMENT: Payment must be deposited
	in {{BANK}} account #{{ACCOUNT}} ON or BEFORE the FIFTH of the month,
	to receive the ${{LATE_FEE}} reduction in rent.  Any money deposited MUST be
	in the bank by 2:00pm or it will post the next day. (If bank is
	closed the next bank open day is OK). The burden of proof lies with
	the Resident as to the date rent is paid, keep your receipt as proof
	of deposit or canceled check. Note the value of the contract equals
	the monthly rate times the term of the lease. Tenant understands
	that payment by check may require early mailing to {{L_ADDRESS}}. 
	Returned checks must be replaced within 48 hours with a money order
	or certified funds plus $30.00. <br/>												 Initial_____ 
	</P>
	<LI><P STYLE="margin-bottom: 0in">SECURITY: Landlord will require
	receipt of the sum of ${{LAST}} as the last month''s rent under this
	lease plus ${{SECURITY}} as a refundable cleaning/security for Tenant''s
	fulfillment of the conditions of this agreement. All prorated
	amounts or payment agreements are set forth in the attached SECURITY
	DEPOSIT ADDENDUM. Deposits will be returned to Tenant within 14 days
	after the property is vacated if:</P>
        <ol>
	<LI><P STYLE="margin-bottom: 0in">		Lease term has expired or
	agreement has been terminated by both parties with the terms of this
	lease 
	</P>

	<LI><P STYLE="margin-bottom: 0in">		Tenant has given 30 day written
	notice of intent to vacate 
	</P>
	<LI><P STYLE="margin-bottom: 0in">		All monies due by Tenant have
	been paid  
	</P>
	<LI><P STYLE="margin-bottom: 0in">		Property is not damaged and is
	cleaned and is left in its original condition, minimal wear and tear
	expected.</P>

</ol>
	<P STYLE="margin-bottom: 0in">Deposit money may not be deducted
	from any rent payment. Deposit may be applied by Landlord to satisfy
	all or part of Tenants obligation and to compensate for any damage
	to the Dwelling, and such shall not prevent Landlord from claiming
	damages in excess of the deposit.</P>

	<P STYLE="margin-bottom: 0in">Security Received $__________________</p>
	<P STYLE="margin-bottom: 0in">Rent Received     $__________________</p>				
<p>

	Signed Landlord __________________ date ______  Initial
	_______________Tenant</P>
	
	<LI><P STYLE="margin-bottom: 0in">USE: Property shall be used for
	residential purposes solely and shall be occupied by the persons
	named in the Tenant''s application to lease. All occupants shall
	comply with all applicable laws or ordinances. Resident shall not
	use the premises or permit it to be used for any disorderly or
	unlawful purpose or in any manner so as to interfere with other
	resident''s or neighbor&rsquo;s peace and quiet enjoyment. Tenant
	shall not use the premises for any illegal purpose, which will
	increase the rate of insurance and shall not cause a nuisance for
	Landlord or neighbors. Tenant shall not create any environmental
	hazards on the premises. IMPORTANT: Any evidence of drug activity on
	the Premises is cause for immediate cancellation of the lease and
	immediate eviction of the Tenant and there will be no refund of any
	money in case of eviction due to illegal drugs. Repeated noise
	violations will result in lease termination or eviction. The
	practice of illegal activities is grounds for eviction. See Drug
	Free/Criminal Free Housing Addendum. Termination of payment by
	Section 8(if applicable) deems the contract cancelled.</P>

	<li><P STYLE="margin-bottom: 0in">Home Owners Association. If
	Premises has an HOA. Tenant must comply with all Home Owners
	Associations Ordinances and regulations. These may be subject to
	change by the HOA at any time. Initial______________</P>

	<LI><P STYLE="margin-bottom: 0in">OCCUPANCY: Premises shall be
	occupied only by the Tenant and the persons named on the
	application. Guests are welcome, however guests should limit their
	stay to one week per visit unless prior written approval has been
	received.  You are responsible for the conduct of your visitors.</P>
	<LI><P STYLE="margin-bottom: 0in">PETS: NO pets shall be allowed on
	the premises. Visiting pets are not permitted at any time 	Initial
	__________</P>

	<LI><P STYLE="margin-bottom: 0in">UTILITIES: Tenant agrees to pay
	ALL utility charges connection fees and security deposits required
	by the providers of the utilities on the property excluding: (x)
	None  Utilities must be transferred into the Tenant&rsquo;s name on
	the day of the commencement of this lease. These MUST be transferred
	and paid in a timely manner or a FEE of ${{LATE_FEE}} will be charged by
	Landlord.<B>	</B>				Initial_____</P>

	<LI><P STYLE="margin-bottom: 0in"> MAINTENANCE: Tenant has examined
	the property, acknowledges it to be in good repair. Tenant has been
	given a unit inspection report and agrees it is true and accurate
	account of the premises. It is understood this will be used at check
	out as a guide of any existing damage to the premises. Tenant agrees
	to keep the premises in good repair and to do all minor maintenance
	promptly (under $50.00 excluding labor) and provide extermination
	service.  Tenant is responsible for any Code Enforcement violations,
	which are due to the Tenants'' property. All requests for service
	should be made at the Telephone number <B>{{PHONE}}</B>.  Any
	plumbing leak of a serious nature, or electrical failure should be
	considered emergencies in which case Landlord should be notified
	immediately.  Air conditioning not working will be considered an
	emergency if outside temperature exceeds 90 degrees. Landlord shall
	be responsible for compliance with {{STATE}} Statutes,
	and shall be responsible for maintenance and repairs of the
	premises.  Tenant is responsible for all costs pertaining to but
	not limited to : __ A/C filter - size (_    __) must be replaced
	monthly.  Failure to do this will increase your utility bill and
	cost YOU for a service call and cleaning ($100.00+).		__ Screen
	damage</P>

	<P STYLE="margin-bottom: 0in">__ Extermination of rats, mice,
	roaches ands and bedbugs			__ Lawn/shrubbery</P>
	<P STYLE="margin-bottom: 0in">__ Garbage removal/outside
	receptacles					__ Interior wall damage</P>
	<LI><P STYLE="margin-bottom: 0in">ASSIGNMENT: This lease may not
	be assigned or sub-let by Tenant without the written consent of the
	Landlord</P>
	<LI><P STYLE="margin-bottom: 0in">DEFAULT: In the event Tenant
	defaults under any terms of this lease, Landlord may recover
	possession provided by Law and seek monetary damages. 
	</P>
	<LI><P STYLE="margin-bottom: 0in">ABANDONMENT: In the event
	Tenant              abandons the property prior to the expiration of
	the lease, Landlord may re-let the premises and hold Tenant liable
	for any costs, lost rent or damage to the premises. Lessor may
	dispose of any property abandoned by the Tenant.	Initial ______</P>
	<LI><P STYLE="margin-bottom: 0in">SURRENDER OF PREMISES. At the
	expiration of the term of this lease, or should Tenant&rsquo;s
	Section 8 Housing assistance be terminated. Tenant shall immediately
	surrender the premises in as good condition as at the start of the
	lease as listed in the attached schedule. Tenant allows Landlord to
	place a sign on the premises to advertise the Premises status 30
	days before termination of the Lease.  The property may be shown by
	appointment. 
	</P>

	<LI><P STYLE="margin-bottom: 0in">PARKING Tenant agrees that no
	parking is allowed on the premises except 2 cars. No boats,
	recreation vehicles, disassembled automobiles nor vehicles without a
	current tag may be stored on the premises. Parking is available on
	concrete driveways only.</P>
	<LI><P STYLE="margin-bottom: 0in">LOCKS: Tenant may add or
	changes locks on premises only with written consent of the Landlord.
	Landlord shall be given 2 copies of each lock. Landlord shall at all
	times have keys for access to the premises in case of emergencies.
	If Tenant becomes locked out of the Premises, Tenant will be charged
	$30.00 to regain entry. The charge will be applied to your account
	and be paid in full the following business day. Landlord has
	furnished ___ garage door openers ___ keys to home______. 
	</P>
	<LI><P STYLE="margin-bottom: 0in">LAWN: Tenant agrees to maintain
	the lawn and shrubbery on the premises at the Tenant''s expense.
	Parking on lawn resulting in damage will be charged to the Tenant
	and is recoverable through the security deposit.  NO TRAMPOLINES,
	PLAYGROUNDS OR POOLS.					Initial___________</P>
	<LI><P STYLE="margin-bottom: 0in">ACCESS: Landlord reserves the
	right to enter the premises, without notice, for the purpose of
	inspection and to show prospective purchasers during reasonable
	hours, or in case of emergency. Landlord may terminate this lease
	upon 60 days written notice to Tenant that the premises is sold. 
	</P>
	<LI><P STYLE="margin-bottom: 0in">TENANT''S APPLIANCES. Tenant
	agrees not to use any heaters, air-conditioners, fixtures or
	appliances drawing excessive current without the consent of the
	Landlord.</P>
	<LI><P STYLE="margin-bottom: 0in">FURNISHINGS: Any articles
	provided to Tenant and listed on attached Inspection schedule are to
	be returned in good condition at the termination of the lease.</P>

	<LI><P STYLE="margin-bottom: 0in">ENTIRE AGREEMENT. This lease
	constitutes the entire agreement between parties and may not be
	modified except in writing signed by both parties.</P>
	<LI><P STYLE="margin-bottom: 0in">ALTERATIONS AND IMPROVEMENTS.
	Tenant shall make no alterations to the property without the written
	consent of the Landlord and any such alterations or improvements
	shall become the property of the Landlord.  It has been agreed that
	a Fence may be erected on the property at the Tenant&rsquo;s cost
	which complies to all HOA requirements. Tenant has a copy of the HOA
	guidelines. If consent is given the following general rule will
	apply: upon vacating the property the Tenant must leave the
	improvement within the premises.  INTERIOR: It has been agreed that
	the Tenant may paint the interior walls, however it will be an
	agreement should the Option to Purchase not be excersised that the
	Landlord may execute their right to have all walls returned to the
	original (or acceptable alternative) color.Damage to the walls or
	property will be charged back to the Tenant to the manner in which
	it was inspected at move-in. EXTERIOR: No alterations may be made
	without written consent. Upon vacating the premises the Tenant has
	no right of ownership nor leave any mechanic lien on the property. 
	</P>
	<LI><P STYLE="margin-bottom: 0in">HARRASSMENT: Tenant shall not
	do any acts to intentionally harass the Landlord or other tenants.</P>
	<LI><P STYLE="margin-bottom: 0in">ATTORNEY''S FEES. In the event
	it becomes necessary to enforce this Agreement through the services
	of an attorney, Tenant shall be required to pay Landlord''s
	attorney''s fees.</P>
	<LI><P STYLE="margin-bottom: 0in">SEVERABILITY. In the event any
	section of this Agreement shall be held to be invalid, all remaining
	provisions shall remain in full force and effect.</P>
	<LI><P STYLE="margin-bottom: 0in">RECORDING. The lease shall not
	be recorded in any public records. 
	</P>

	<LI><P STYLE="margin-bottom: 0in">WAIVER: Any failure by
	Landlord to exercise any rights under this Agreement shall not
	constitute a waiver of the Landlord''s rights.</P>
	<LI><P STYLE="margin-bottom: 0in">LIENS: The estate of Landlord
	shall not be subject to any liens for improvement contracted by
	Tenant.</P>
	<LI><P STYLE="margin-bottom: 0in">TERMINATION OF LEASE: Tenant
	may terminate this agreement before expiration of the original term
	by:</P>

<OL>
	<LI><P STYLE="margin-bottom: 0in"> Giving Landlord written notice
	of the termination 60 days prior to the date</P>
	<LI><P STYLE="margin-bottom: 0in"> Paying the Termination Fee of $
	{{TERM_FEE}} prior to vacating. This amount is solely determined as
	a fee and is in no way to be considered as rental payment although
	amounts may be similar.</P>

	<LI><P STYLE="margin-bottom: 0in">Paying rent and all monies due
	through the date of termination plus</P>
	<LI><P STYLE="margin-bottom: 0in"> All deposits are forfeited due
	to breach of contract</P>

</OL>
<P STYLE="margin-bottom: 0in">The foregoing shall not relieve
	the Tenant of responsibilities and obligations regarding any damage
	to the property.</P>

<P STYLE="margin-bottom: 0in"><BR>The Landlord has up to 15 days to
return the security deposit to the Tenant, or in which to give the
Tenant written notice by certified mail of his or her intention to
impose a claim on the deposit and the reason for imposing it.
Tenant''s Deposits will be deposited by ____________ at _____________. Initial _____</P>
<P STYLE="margin-bottom: 0in"><BR>
</P>

<li><P STYLE="margin-bottom: 0in"> LIABILITY: Landlord and Tenant
shall each be responsible to maintain appropriate insurance for their
respected interests in the premises and property located on the
Premises. The Landlord advises Tenant to take out <B>Renters
Insurance</B> for the contents of the premises in addition to
liability coverage for major occurrences <B>including hurricanes</B>.
Waterbeds are permitted provided a copy of your current Renter''s
Insurance is given to the Landlord prior to installation of such
furniture. Tenant expressly releases Landlord from liability for, and
indemnifies the Landlord any and all damage to the property or injury
to person suffered by Tenant/and or Tenant''s family, invitees or
licensees, unless caused by or resulting from the sole negligence of
the Landlord. This release and indemnity shall also be effective if
damage or injury is due to failure of Tenant to provide Landlord
notice of any necessary maintenance or repairs of any defective
conditions. Tenant shall be responsible for procuring and maintaining
any insurance coverage desired by Tenant, including Tenant''s
possessions in the property. Initial ____</P>

<li><P STYLE="margin-bottom: 0in">SUBORDINATION: Tenant''s interest in
the property shall be subordinate to any encumbrances now or
hereafter placed on the premises, to any advances made under such
encumbrances, and to any extensions or renewals thereof. Tenant
agrees to sign any documents indicating such subordination, which may
be required by lenders.</P>

<li><P STYLE="margin-bottom: 0in">SMOKE DETECTORS. Tenant shall be
responsible for keeping smoke detectors operational and for changing
battery when needed.								Initial__________</P>

<li><P STYLE="margin-bottom: 0in">RADON GAS: Radon is a naturally
occurring radioactive gas that, when it has accumulated in a building
in sufficient quantities, may present health risks to persons who are
exposed to it over time. Levels of radon that exceed federal and
state guidelines have been found in buildings in {{STATE}}. Additional
information regarding radon and radon testing may be obtained from
your county public health unit.</P>

</OL>
</ol>
<P STYLE="margin-bottom: 0in"><BR>
</P>
<P STYLE="margin-bottom: 0in"><BR>
</P>
<P STYLE="margin-bottom: 0in"><BR>
</P>
<P STYLE="margin-bottom: 0in"><BR>
</P>
<P STYLE="margin-bottom: 0in"><BR>
</P>
<P STYLE="margin-bottom: 0in"><BR>
</P>
<P STYLE="margin-bottom: 0in">WITNESS the hands and seals of the
parties hereto as of this date ___________________.</P>
<P STYLE="margin-bottom: 0in"><BR>

</P>
<P STYLE="margin-bottom: 0in"><BR>
</P>
<P STYLE="margin-bottom: 0in">LANDLORD:___________________________________ 		TENANT: ______________________________________
</P>

<P STYLE="margin-bottom: 0in; page-break-before: always"><BR>
</P>
<P STYLE="margin-bottom: 0in"><BR>
</P>
<P STYLE="margin-bottom: 0in"><BR>
</P>
<P STYLE="margin-bottom: 0in"><BR>
</P>';

v_doc_id number;

begin
  v_doc_id := RNT_DOC_TEMPLATES_PKG.insert_row( X_NAME        => 'Residental Lease - Discount'
                                              , X_BUSINESS_ID => null
                                              , X_CONTENT     => v_agreement);
end;
/