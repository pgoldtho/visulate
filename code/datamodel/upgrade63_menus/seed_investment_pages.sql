declare

begin


    insert into RNT_MENUS
     ( TAB_NAME
     , PARENT_TAB
     , MENU_NAME
     , MENU_TITLE
     , DISPLAY_SEQ)
     values
     ( 'investment'
     , 'public'
     , 'resources'
     , 'Resources'
     , 1);
  				  

  rnt_menu_pages_pkg.insert_row
                    ( X_TAB_NAME        => 'investment'
                     , X_MENU_NAME      => 'resources'
                     , X_PAGE_NAME      => 'goals'
                     , X_SUB_PAGE       => 'Goals'
                     , X_PAGE_TITLE     => 'Identify Goals'
                     , X_DISPLAY_SEQ    => 1
                     , X_HEADER_CONTENT =>
xmltype('<head>
  <title>Visulate  - Real Estate Investment Goals</title>
  <meta http-equiv="content-type" content="text/html; charset=iso-8859-1" />
  <meta name="keywords" content="Property Management Software, Rental Management Software, Section 8, Hosted Property Management Software" /> 
  <meta name="description" content="Visulate is a web based software system for managing rental properties and real estate investments."/>
</head>')
                     , X_BODY_CONTENT   =>
'<h1>Should I Invest in Real Estate?</h1>
<p>
Investing in real estate can be a great way to accumulate wealth but its also
possible to lose money in real estate.<br/> <i>Sue Goldthorp</i>
from Visulate has developed a series of questions to help first time
investors evaluate their goals.
</p>
<img class="vga_img" src="/images/goals.jpg"/>
<ol>
<li>Examine your current investments.  How many do you have and how are they performing?  What were your goals when you invested in them?  Have they achieved this?  Is it time to sell some of them and reinvest the proceeds?</li>

<li>How much debt do you have?  Is it being used to generate income?  What rates are you paying?  Should you pay down existing debts before you start investing in real estate?</li>
<li>What are your investment goals?  Are they long term or short term?</li>
<li>How much cash do you have to invest?  Do you own properties with equity that you could borrow against?  Do you own other assets that you could borrow against?</li>
<li>How much cash do you need to retain for emergencies - e.g. lost income, new roof or medical bills?</li>
<li>What are your cash flow requirements?  Does the property need to pay for itself?  If not where will the other income come from?  How secure is that income?</li>
<li>Set an investment budget based on your investable cash, cash flow requirements and comfort level.  More leverage typically produces greater appreciation  but less cash flow.</li>
</ol>');


  rnt_menu_pages_pkg.insert_row
                    ( X_TAB_NAME        => 'investment'
                     , X_MENU_NAME      => 'resources'
                     , X_PAGE_NAME      => 'find'
                     , X_SUB_PAGE       => 'Find'
                     , X_PAGE_TITLE     => 'Find Properties'
                     , X_DISPLAY_SEQ    => 2
                     , X_HEADER_CONTENT =>
xmltype('<head>
  <title>Visulate -  How to Locate Real Estate Investment Properties</title>
  <meta http-equiv="content-type" content="text/html; charset=iso-8859-1" />
  <meta name="keywords" content="Property Management Software, Rental Management Software, Section 8, Hosted Property Management Software" /> 
  <meta name="description" content="Visulate is a web based software system for managing rental properties and real estate investments."/>
</head>')
                     , X_BODY_CONTENT   =>
'<h1>Identify and Research Candidate Properties</h1>
<img class="vga_img" src="/images/findProperties.jpg"/>
<p>
Call Sue Goldthorp on (321) 698 5198 and explain your <a href="invest_p.cgi?TF=goals">investment goals</a>. 
She will help identify potential properties that will meet them.  
You can also search <a href="http://loopnet.com">Loopnet</a> for commercial 
properties and <a href="http://realtor.com">Realtor.com</a> 

or <a href="http://zillow.com">Zillow</a> for residential listings.  
Once you''ve identified a potential property we''ll help you query your local 
county court and tax records to find additional information.
</p>
<ol>
<li>Research the rental market in your target area.  What kind of properties are easy to rent?  What''s difficult to rent?  How long do properties typically remain vacant?  Are there any "price points" that are particularly attractive to tenants (e.g. single family homes for less than $900 per month or office accommodation at $15 sq ft) </li>
<li>Research property values by examining listings and recent sales.</li>
<li>Identify and review potential properties to create a short list.</li>
<li>Arrange property viewing.  Take a digital camera and a notepad to record impressions of each property.</li>
<li>Estimate the income potential and any repair costs for each property.</li>
<li>See if you can talk to the current tenant if the property is rented.  Would you be happy doing business with them?  Are they happy in the building?  Does anything need fixing?</li>

<li>Identify one or more candidate properties.</li>
<li>Find the tax record and legal descriptions for each candidate property.  How long has the current owner owned the property?  What did they pay for it?</li>
<li>Is the property zoned correctly for it''s current use?  Does the zoning allow other uses? Are there any planned developments or zoning changes nearby?  Could these affect the value of the property?</li>
<li>Check county court records for the current owner.  Are there any lis pendens (pending law suits) recorded against them?  These could be an indication that the property is going into foreclosure.  Identify the value of any loans that the current owner has secured against the property.  How many tenants has the current owner evicted from the property?</li>
</ol>');


  rnt_menu_pages_pkg.insert_row
                    ( X_TAB_NAME        => 'investment'
                     , X_MENU_NAME      => 'resources'
                     , X_PAGE_NAME      => 'worksheet'
                     , X_SUB_PAGE       => 'Cash Flow'
                     , X_PAGE_TITLE     => 'Investment Analysis'
                     , X_DISPLAY_SEQ    => 3
                     , X_HEADER_CONTENT =>
xmltype('<head>
  <title>Visulate -  Real Estate Investment Analysis</title>
  <meta http-equiv="content-type" content="text/html; charset=iso-8859-1" />
  <meta name="keywords" content="Property Management Software, Rental Management Software, Section 8, Hosted Property Management Software" /> 
  <meta name="description" content="Visulate is a web based software system for managing rental properties and real estate investments."/>

  <script language="JavaScript" 
        id="cap_calc"
        src="/include/cap_calc.js" 
				type="text/javascript">
  </script>

</head>')
                     , X_BODY_CONTENT   =>
'<p>
This worksheet is designed to help evaluate potential real estate investements.
It calculates the net operating income (NOI), capitalization rate (CAP Rate)
 and cash on 
cash return figures for a property.  It also estimates the cost of finance to
provide a cash flow summary for the investment.
 <a href="invest_p.cgi?TF=cap_calc">[Hide Descriptions]</a>
 <a href="invest_p.cgi?TF=download">[Download Code]</a>
</p>
<h3>Property</h3>

<p>
Enter the monthly rental income that the property would generate if it was 
fully rented (i.e. no vacancies).  Then estimate the annual income from other 
sources (e.g. a coin operated laundry or vending machines).  The monthly rental 
income is multiplied by 12 and added to the other income to calculate the 
potential gross income for the property.
</p>
<p>
Next, estimate the running costs for the property.  These should include an 
allowance for vacancies.  These will vary depending on the expected use.  
A figure of 5% is reasonable for residential rental property, a seasonal 
vacation rental could have a vacancy rate as high as 60 or 80%.  Make an 
allowance for repairs and maintenance. The worksheet allows you to calculate
and fund a replacement reserve.  Enter the estimated costs for items that 
typically require replacement at 3,5, and 12 year intervals (e.g. carpet, paint,
roof or furnace). The worksheet calculates how much money you have to save each 
year to fund your replacements. Enter annual values for maintenance, utilities, 
taxes, insurance and management fees.
</p>

<h3>NOI and CAP Rate</h3>
<form name="prop">
<table class="layouttable">
<tr>
<td><img src="/images/cash5.jpg"/></td>
<td>
<table class="datatable">
<tr><th>Monthly Rent</th><td><input name="rent" value="1,800" size="10"/></td></tr>

<tr><th>Annual Rent</th><td><input name="gross" disabled value="" size="10"/></td></tr>
<tr><th>Other Income</th><td><input name="other" value="" size="10"/></td></tr>
<tr><th>Total Gross </th><td><input name="total_gross" disabled value="" size="10"/></td></tr>
</table>

</td><td>
<table class="datatable">
<tr><th>Vacancy <input name="vc_pct" value="5" size="2"/> %
</th><td><input name="vc_act" disabled value="" size="10"/></td></tr>

<tr><th>3 Year Replacements</th><td>

  <input name="impr3"  value="800" size="10"/></td></tr>
<tr><th>5 Year Replacements</th><td>
  <input name="impr5"  value="1,200" size="10"/></td></tr>
<tr><th>12 Year Replacements</th><td>

  <input name="impr12" value="10,000" size="10"/></td></tr>

<tr><th>Reserve Fund</th><td><input name="impr" disabled  value="" size="10"/></td></tr>
<tr><th>Maintenance</th><td><input name="maint" value="1,000" size="10"/></td></tr>
<tr><th>Utilities</th><td><input name="util" value="200" size="10"/></td></tr>

<tr><th>Property Taxes</th><td><input name="tax" value="3,200" size="10"/></td></tr>
<tr><th>Insurance</th><td><input name="ins" value="2,750" size="10"/></td></tr>
<tr><th>Management Fees</th><td><input name="mgt" value="" size="10"/></td></tr>
<tr><th>Net Operating Income</th><td><input name="noi" disabled value="" size="10"/></td></tr>

</table>
</td><td>

<table class="datatable">
<tr><th>Purchase Price</th><td><input name="cur_value" value="195,000" size="10"/></td></tr>
<tr><th>Down Payment</th><td><input name="down_payment" value="40,000" size="10"/></td></tr>

<tr><th>Closing Costs</th><td><input name="c_costs" value="3,200" size="10"/></td></tr>

<tr><th><INPUT TYPE=button NAME=Button VALUE=" Calculate" onclick="compute_value(this.form)"></th>
<tr><th>Cash on Cash Return</th><td><input name="cash_on_cash" disabled value="" size="10"/></td>

<tr><th>CAP Rate</th><td><input name="cap_rate" value="" size="10"/></td></tr>
</table>
</td>
</tr>
</table>
</form>

<p>
Enter the purchase price, down payment and closing costs then press the
calculate button to generate an analysis.  Alternatively, leave the purchase
price blank and enter a desired CAP rate to calculate an offer price.  The cap
rate is calculated as the NOI/Purchase Price * 100.  Compare the cap rate for 
your candidate property with the cap rates for comparable properties to 
determine whether you are paying too much for the property.  A cap rate that is 
equal to or greater than the cap rate for comparable properties in your market 
is good.

</p>
<p>Cash on cash measures the return on cash invested in property (i.e. the
down payment).  It shows your effective rate of interest for the cash you
are investing in the property.
</p>


<h3>Finance</h3>
<p>
The following tables provide an estimate for the finance costs associated with
the figures entered above.  The 1st loan amount defaults to the purchase price 
less down payment.  If all closing costs are to be included in the financing, 
change the loan amount to add the closing costs and enter 0 for the Closing 
Costs amount in the previous section.  The property tax and insurance are copied
from the payments entered above.  The term of the 1st loan is calculated as a 
30 year, fixed rate amortizing loan with an interest rate of 8%.  You can modify these
values as required.  The form will automatically recaluate the monthly total 
when the values change.  
</p>

<table class="layouttable">
<tr>
<td>
<FORM NAME="temps">
<TABLE class="datatable">
<tr><th>1st Loan Amount</th>

<td><INPUT TYPE="TEXT" NAME="LA" onChange="dosum()" SIZE="6" VALUE="100000"></td></tr>
<tr><th>Type</th><td>
<select name="loantype" onChange="dosum()">
  <option value="Amortizing" selected> Amortizing</option>
  <option value="Interest Only" >Interest Only</option>
</select>

</td></tr>
<tr><th>Term</th>
<td><INPUT TYPE="TEXT" NAME="YR" onChange="dosum()" SIZE="6" VALUE="30"></td></tr>

<tr><th>Interest Rate</th>
<td><INPUT TYPE="TEXT" NAME="IR" onChange="dosum()" SIZE="6" VALUE="8.0"></td></tr>
<tr><th>Property Tax (Annual)</th>
<td><INPUT TYPE="TEXT" NAME="AT" onChange="dosum()" SIZE="6" VALUE="1000"></td></tr>
<tr><th>Insurance(Annual)</th>
<td><INPUT TYPE="TEXT" NAME="AI" onChange="dosum()" SIZE="6" VALUE="300"></td></tr>
</td>
<TR>
<th>Monthly Prin + Int<Td><INPUT TYPE="TEXT" disabled NAME="PI" SIZE="10">

<TR>
<th>Monthly Tax <Td><INPUT TYPE="TEXT" disabled NAME="MT" SIZE="10">

<TR>
<th>Monthly Ins <Td><INPUT TYPE="TEXT" disabled  NAME="MI" SIZE="10">
<tr>
<th>Monthly Total <Td><INPUT TYPE="TEXT"   NAME="MP" SIZE="10">
</TABLE>
</FORM>
</td>
<td>
<FORM NAME="temps2">
<TABLE class="datatable">
<tr><th>2nd Loan Amount</th>
<td><INPUT TYPE="TEXT" NAME="LA" onChange="dosum2()" SIZE="6" VALUE="0"></td></tr>
<tr><th>Type</th><td>

<select name="loantype" onChange="dosum2()">
       <option value="Amortizing">Amortizing</option>
			 <option value="Interest Only" selected >Interest Only</option>
</select>
</td></tr>
<tr><th>Term</th>
<td><INPUT TYPE="TEXT" NAME="YR" disabled onChange="dosum2()" SIZE="6" VALUE=""></td></tr>
<tr><th>Interest Rate</th>
<td><INPUT TYPE="TEXT" NAME="IR" onChange="dosum2()" SIZE="6" VALUE="8.0"></td></tr>
</td>
<TR>

<th>Monthly Prin + Int<Td><INPUT TYPE="TEXT" NAME="PI" SIZE="10">
</TABLE>
</FORM>
</td>
<td><img src="/images/cash6.jpg"/></td>
</tr>
</table>
<p>
The final table shows annual and monthly cash flow summaries based on the 
calculated NOI and loan payments.
</p>
<h3>Cash Flow</h3>
<table class="layouttable">
<tr><td><img src="/images/cash7.jpg"/></td>
<td>
<form name="cf">

<table class="datatable">
<tr><th></th><th>Annual</th><th>Monthly</th></tr>
<tr><th>Net Operating Income</th>
<td><input type="text" name="a_noi" size="6" disabled value=""></td>
<td><input type="text" name="m_noi" size="6" disabled value=""></td></tr>
<tr><th>1st Loan</th>
<td><input type="text" name="a_loan1" size="6" disabled value=""></td>
<td><input type="text" name="m_loan1" size="6" disabled value=""></td>
</tr>
<tr><th>2nd Loan</th>
<td><input type="text" name="a_loan2" size="6" disabled value=""></td>
<td><input type="text" name="m_loan2" size="6" disabled value=""></td>

</tr>
<tr><th>Cash Flow</th>
<td><input type="text" name="a_cf" size="6" value=""></td>
<td><input type="text" name="m_cf" size="6" value=""></td>
</tr>
</tr>
</table>
</form>
</td></tr>
</table>
<a href="http://visulate.com">home</a>
');

 rnt_menu_pages_pkg.insert_row
                    ( X_TAB_NAME        => 'investment'
                     , X_MENU_NAME      => 'resources'
                     , X_PAGE_NAME      => 'caprate'
                     , X_SUB_PAGE       => 'Cap Rates'
                     , X_PAGE_TITLE     => 'Cap Rate Calculator'
                     , X_DISPLAY_SEQ    => 4
                     , X_HEADER_CONTENT =>
xmltype('<head>
  <title>Visulate -  Capitalization Rate Calculator</title>
  <meta http-equiv="content-type" content="text/html; charset=iso-8859-1" />
  <meta name="keywords" content="Property Management Software, Rental Management Software, Section 8, Hosted Property Management Software" /> 
  <meta name="description" content="Visulate is a web based software system for managing rental properties and real estate investments."/>

  <script language="JavaScript" 
        id="cap_calc"
        src="/include/cap_calc.js" 
				type="text/javascript">
  </script>
  
  <script language="JavaScript">
<!-- hide script contents from old browsers

function addCommas(nStr)
{
	nStr += '''';
	x = nStr.split(''.'');
	x1 = x[0];
	x2 = x.length > 1 ? ''.'' + x[1] : '''';
	var rgx = /(\d+)(\d{3})/;
	while (rgx.test(x1)) {
		x1 = x1.replace(rgx, ''\$1'' + '','' + ''\$2'');
	}
	return x1 + x2;
}

function stripCommas(nStr)
{
  return nStr.replace('','', '''') *1;
}

function compute_pvalue(form)
{
// Calculate total gross income
  var gross = 0;
  gross = stripCommas(form.rent.value) * 12;
  form.gross.value =  addCommas(gross);


  var other = stripCommas(form.other.value) * 1;
  var total_gross = gross + other;

    vc = gross * form.vc_pct.value/100;
    form.vc_act.value = addCommas(vc);

  form.total_gross.value =  addCommas(total_gross);

  var noi = total_gross - vc
                  - stripCommas(form.impr.value)
                  - stripCommas(form.maint.value)
                  - stripCommas(form.util.value)
                  - stripCommas(form.tax.value)
                  - stripCommas(form.ins.value)
                  - stripCommas(form.mgt.value);
  form.noi.value = addCommas(noi);

  var cap_rate = form.cap_rate.value   * 1;
  var cur_value = stripCommas(form.cur_value.value) * 1;

  if (cur_value != 0) 
   {
    cap_rate = (noi * 100)/cur_value;
    form.cap_rate.value = cap_rate.toFixed(2);
   }

  if (cap_rate == 0)
      {cap_rate = 7.5;
       form.cap_rate.value = cap_rate;
      }

   
    cur_value = (noi * 100)/cap_rate;
    form.cur_value.value = addCommas(cur_value.toFixed(0));

   
}
-->
</script>


</head>')
                     , X_BODY_CONTENT   =>
'<h1>Capitalization Rate Calculator</h1>
<img  class="vga_img" src="/images/cap_rate.jpg"/>
<form>
<p>
The capitalization (cap) rate of a building measures its rate of return based 
on the value of the building and the income stream that it generates.  Cap rates
are calculated using the following formula:
</p><p><i>
value = annual income/ cap rate
</i></p>
<p>The calculator on this page can be used to calculate the current cap rate for a property.</p>

<table class="datatable">
<tr><th>Monthly Rent</th><td><input name="rent" value="800" size="10"/></td>
<td>Enter the total monthly rent you receive</td></tr>
<tr><th>Gross Annual Income</th><td><input name="gross" disabled value="" size="10"/></td>
<td>Calculated as monthly rent * 12</td></tr>
<tr><th>Other Income</th><td><input name="other" value="" size="10"/></td>
<td>Enter the annual amount of any other income (e.g. Laundry)</td></tr>
<tr><th>Total Gross </th><td><input name="total_gross" disabled value="" size="10"/></td>
<td>Calculated as the annual rent plus other income.</td></tr>

<tr><th>Vacancy <input name="vc_pct" value="5" size="2"/> %
</th><td><input name="vc_act" disabled value="" size="10"/></td>
<td>Estimate a value for expected vacancies (5% is typical)</td></tr>
<tr><th>Amortized Costs</th><td><input name="impr" value="1,000" size="10"/></td>
<td>Estimate an annual amortized value for repairs and capital improvements (e.g. a $10,000 roof
amortized over 10 years = $1,000)</td></tr>
<tr><th>Maintenance</th><td><input name="maint" value="1,000" size="10"/></td>
<td>Enter the amount spent on routine maintenance this year.</td></tr>
<tr><th>Utilities</th><td><input name="util" value="200" size="10"/></td>
<td>Enter the amount spent on utilities this year.</td></tr>

<tr><th>Property Taxes</th><td><input name="tax" value="1,200" size="10"/></td>
<td>Enter the annual property tax amount for the building.</td></tr>
<tr><th>Insurance</th><td><input name="ins" value="750" size="10"/></td>
<td>Enter the annual property insurance  premium.</td></tr>
<tr><th>Management Fees</th><td><input name="mgt" value="" size="10"/></td>
<td>Enter the cost of management fees</td></tr>
<tr><th>Net Operating Income</th><td><input name="noi" disabled value="" size="10"/></td>
<td>Calculated as the annual gross income minus expenses</td></tr>
<tr><th>Market Value</th><td><input name="cur_value" value="" size="10"/></td>

<td>Enter the current market value <u>and leave the CAP Rate blank</u> to calculate the CAP Rate</td></tr>
<tr><th>CAP Rate</th><td><input name="cap_rate" value="" size="10"/></td>
<td>Enter a CAP Rate <u>and leave the purchase price blank</u> to calulate the property value
</td></tr>
<tr><th><INPUT TYPE=button NAME=Button VALUE=" Calculate" onclick="compute_pvalue(this.form)"></th>
<td></td><td></td>
</table>
</form>
<h3>What Cap Rate Should I Use to Value a Property?</h3>

<p>Cap rates can be used to calculate the value of commercial and other income
producing properties.  Compare the cap rate for a candidate property with the 
cap rates for comparable properties to determine its value.  Look for properties
that have the same use (e.g. Multi-Family, Office or Industrial) and and class.
Commercial buildings are usually classified as A, B, C or D properties where A = good and
D = poor.  Market conditions also influence cap rates.  For example, cap rates in 
New York City are lower than cap rates in Orlando because land is scarce in NYC.  
The following table shows typical cap rates for Florida multi-family properties in late 2009.</p>
<table class="datatable">
<tr><th>Class</th><th>Property and Tenant Profile</th><th>Cap Rate</th></tr>
<tr><td>A</td><td>Less than 10 years old, white collar workers in a good area with strong demographics</td><td>7.5 and below</td></tr>
<tr><td>B</td><td>Less than 20 years old, mixture of white and blue collar workers decent neighborhood</td><td>7.5 to 8.25</td></tr>
<tr><td>C</td><td>Around 30 years old in decent condition, blue collar and Section 8 in an OK neighborhood</td><td>9 to 10</td></tr>

<tr><td>D</td><td>Over 40 years old with deferred maintenance, Section 8 and unemployed tenants in a rough area</td><td>Over 12</td></tr>
</table>
');


   insert into RNT_MENUS
     ( TAB_NAME
     , PARENT_TAB
     , MENU_NAME
     , MENU_TITLE
     , DISPLAY_SEQ)
     values
     ( 'investment'
     , 'public'
     , 'links'
     , 'Links'
     , 2);
  	

					 
  rnt_menu_links_pkg.insert_row
                    ( X_TAB_NAME     => 'investment'
                     , X_MENU_NAME   => 'links'
                     , X_LINK_TITLE  => 'IRS Rental Property Rules'
                     , X_LINK_URL    => 'http://www.irs.gov/publications/p527/index.html'
                     , X_DISPLAY_SEQ => 1);

  rnt_menu_links_pkg.insert_row
                    ( X_TAB_NAME     => 'investment'
                     , X_MENU_NAME   => 'links'
                     , X_LINK_TITLE  => '1031 Exchange Overview'
                     , X_LINK_URL    => 'http://en.wikipedia.org/wiki/1031_exchange'
                     , X_DISPLAY_SEQ => 2);
					 
  			 
							  
end;
/
