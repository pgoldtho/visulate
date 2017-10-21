declare

begin


    insert into RNT_MENUS
     ( TAB_NAME
	 , PARENT_TAB
     , MENU_NAME
     , MENU_TITLE
     , DISPLAY_SEQ)
     values
     ( 'find'
	 , 'public'
     , 'items'
     , 'Items'
     , 1);
  				  

  rnt_menu_pages_pkg.insert_row
                    ( X_TAB_NAME        => 'find'
                     , X_MENU_NAME      => 'items'
                     , X_PAGE_NAME      => 'homePage'
                     , X_SUB_PAGE       => 'Welcome'
                     , X_PAGE_TITLE     => 'Home Page'
                     , X_DISPLAY_SEQ    => 1.1
                     , X_HEADER_CONTENT =>
xmltype('<head>
  <title>Visulate  - Investment and Property Management Software</title>
  <meta http-equiv="content-type" content="text/html; charset=iso-8859-1" />
  <meta name="keywords" content="Property Management Software, Rental Management Software, Section 8, Hosted Property Management Software" /> 
  <meta name="description" content="Visulate is a web based software system for managing rental properties and real estate investments."/>
</head>')
                     , X_BODY_CONTENT   =>
'<h1>Central Florida Real Estate Investment Services </h1>
<div class="column span-60">

<img src="/images/banner_sm.jpg"/>
</div>

<div class="column span-30">
<h4>Brevard County Property Search</h4>
<p>Search Brevard County, Florida property records. Enter an address line e.g. "16 South St" and a city then press Search</p>
<form action="rental/visulate_search.php?REPORT_CODE=PROPERTY_DETAILS" method="post">
	<table >
				<tr>	  
				  <th><b>Address:</b></th>
				  <td><input size="30" maxlength="80" name="ADDRESS1" type="text" /></td>

				</tr><tr>
				  <th style="text-align:right"><b>City:</b></th><td ><input size="30" name="CITY" type="text" /></td>
			</tr><tr>
<td colspan="2" style="text-align:right"> <input name="submit_html" value="Search" type="submit" /></td></tr>
		</table>  
		</form>
</div>

<div class="column span-100">
<p>
Visulate is a web based software system for managing rental properties and real 
estate investments.  It was designed in by Sue and Peter Goldthorp in 2007.  
They have been using it since then to manage their real estate investment 
portfolio.  Visulate supports investment analysis, mailing list production, 
property listings, tenancy agreements, events and evictions, repairs and 
maintenance, repair estimates, accounts payable, accounts receivable and general
 ledger.  We offer 3 levels of service at Visulate:</p>

<ol>
<li><a href="/cgi-bin/manage_p.cgi?TF=full_service">Full service property management</a> 
we manage your properties in Cocoa, Cocoa Beach, Cape Canaveral, Merritt 
Island or Titusville using our web based software which gives you 24/7 
access to your information.</li>
<li><a href="/cgi-bin/manage_p.cgi?TF=shoe_box">A shoe box bookkeeping service</a>,  
send us your receipts (in a shoe box if that''s where you keep them) and we''ll  
enter them into Visulate so that you can keep track of your expenses and income 
throughout the year. Reports for tax purposes can be provided for your 
accountant. (includes 24/7 access to your information)</li>
<li><a href="/cgi-bin/manage_p.cgi?TF=self_service">Self service<a>, 
a subscription to visulate provides a login enabling you to enter your 
own information and keep track of everything related to your properties.
Each person using the system needs a subscription, but there is no limit to
the number of properties that can be entered. Training will be provided.</li>
</ol>
<p>
We make this process easy and understandable.  Have a look around this website 
and click on the different tabs to see what we have to offer.  If  you have any 
questions or would like a demonstration then contact Sue Goldthorp at 
<b>321 698 5198</b>. We are based in Merritt Island,  Brevard County Florida  and can 
offer Property Management services locally.  However, you can sign up for the 
subscription to the web based software service where ever you are. Contact 
Sue if you are interested in getting started in real estate investing.  She 
has a real estate license and can act as your buyers agent.
</p> 
'					 );

  rnt_menu_pages_pkg.insert_row
                    ( X_TAB_NAME        => 'find'
                     , X_MENU_NAME      => 'items'
                     , X_PAGE_NAME      => 'homePage'
                     , X_SUB_PAGE       => 'Contact Us'
                     , X_PAGE_TITLE     => 'Home Page'
                     , X_DISPLAY_SEQ    => 1.2
                     , X_HEADER_CONTENT =>
xmltype('<head>
  <title>Visulate -  Contact Visulate</title>
  <meta http-equiv="content-type" content="text/html; charset=iso-8859-1" />
  <meta name="keywords" content="Property Management Software, Rental Management Software, Section 8, Hosted Property Management Software" /> 
<meta name="description" content=" Enter your email address, subject line, phone number and message then press the Submit button to send us an email.
Alternatively you can call us on (321) 698 5198. "/>
</head>')					 
                     , X_BODY_CONTENT   => 
'<h1>Contact Us</h1>

<p>
Enter your email address, subject line, phone number and message then press the Submit button
to send us an email. <br/> Alternatively you can call us on (321) 698 5198.
</p>
<img class="vga_img" src="/images/contact2.jpg"/>
' );

					 
  rnt_menu_links_pkg.insert_row
                    ( X_TAB_NAME     => 'find'
                     , X_MENU_NAME   => 'items'
                     , X_LINK_TITLE  => 'Brevard County Sales History'
                     , X_LINK_URL    => 'visulate_search.php?REPORT_CODE=SALES'
                     , X_DISPLAY_SEQ => 2);

  rnt_menu_links_pkg.insert_row
                    ( X_TAB_NAME     => 'find'
                     , X_MENU_NAME   => 'items'
                     , X_LINK_TITLE  => 'Commercial Sales History'
                     , X_LINK_URL    => 'visulate_search.php?REPORT_CODE=COMMERCIAL'
                     , X_DISPLAY_SEQ => 3);
					 
  			 
							  
end;
/
