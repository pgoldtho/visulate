{include file="loginTop.tpl"}

{literal}
<script type="text/javascript">
function hideDiv(section)
{
  document.getElementById(section).style.display = 'none';
}
function showDiv(section)
{
  hideDiv('banner');
	hideDiv('overview');
	hideDiv('35-dollar');
  hideDiv('sign-up');
  document.getElementById(section).style.display = 'block';
}
</script>
{/literal}

  <!-- begin main -->
  <div id="main">
    <!-- begin content -->
    <div id="content">
      <!-- begin left part -->
      <div id="left_part">
      <div id="nav">    
      <h2 class="title"><a href="#" class="active">Actions</a></h2>
       <ul class="left_menu">
        <li><a href="{$PATH_FORM_ROOT}login.php">Login</a></li>
        <li><a href="#" class="active">Try Visulate FREE for 30 days</a></li> 
        <li class="li_left_last"><a href="http://visulate.com/cgi-bin/home.cgi?TF=contact">Contact Visulate</a></li>
      </ul>
     </div> <!-- end nav -->
     <div id="nav">    
      <h2 class="title"><a href="#" >Information</a></h2>
       <ul class="left_menu">
        <li><a onclick="showDiv('overview');">Visulate Overview Video</a></li>
        <li><a onclick="showDiv('35-dollar');">What's Included for $35/month</a></li>
        <li class="li_left_last"><a onclick="showDiv('sign-up');">Why Sign Up Video</a></li> 
        
      </ul>
     </div> <!-- end nav -->

     
    </div> <!-- end left part -->
    <!-- begin right part -->
     <div id="right_part">  {*---right_part div is closed in footer.tpl---*} 


<h1>Try Visulate FREE for 30 days!</h1>

<div id="banner" style="display:block">
<img src="/images/banner.jpg"/>
</div>

<div id="overview"  style="border: 1px solid #949494;  width:  640px; display:none">
<object width="640" height="385">
<param name="movie" value="http://www.youtube.com/v/qHWxv69kUe0&rel=0&color1=0xb1b1b1&color2=0xcfcfcf&feature=player_profilepage&fs=1"></param>
<param name="allowFullScreen" value="true"></param><param name="allowScriptAccess" value="always"></param>
<embed src="http://www.youtube.com/v/qHWxv69kUe0&rel=0&color1=0xb1b1b1&color2=0xcfcfcf&feature=player_profilepage&fs=1" type="application/x-shockwave-flash" allowfullscreen="true" allowScriptAccess="always" width="640" height="385">
</embed>
</object>
</div>

<div id="35-dollar" style="display:none">
<img src="/images/banner.jpg"/>
<h3>Investment Analysis</h3>
<p>
Looking for an investment property but not sure how it will cash flow? 
Visulate allows you to analyze prospective properties by entering property 
details such as projected market rent and expected annual expenses. 
</p>
<p>Calculate cash flow, cap rate and cash on cash return estimates for properties
you own or are planning to buy.  Monitor income and expenses to compare estimates
with actual returns.  Estimate and track rehab costs.  Share estimates with other
members of your business network.  
</p>
<h3>Advertize Vacancies</h3>
<p>Advertize your vacancies on the Visulate website and Google Base.  Visulate
generates "For Rent" listings automatically each time a property becomes vacant
and submits the listing to Google Base for maximum exposure.</p>

<h3>Property Management</h3>
<p>Need to find a better way to track your tenants without having to use cumbersome accounting software?
Visulate provides its users with a streamlined approach to 
property management. By entering pertinent leasing information such as tenant’s 
contact information, lease term and rates, and special conditions 
(such as pets and appliances) Visulate users are able to track their 
leases efficiently.</p>
<p>
With Visulate the tenant’s account includes a ledger, which shows charges and 
payments that allows you to always be aware of which tenants are on time or 
running late. Users also have the ability to record personalized notes in the 
tenant’s account such as a lease violation or charge a tenant for a repair 
that is the tenant’s responsibility.</p>
<p>
<i>"I manage sixty-five rental properties and I've been using Visulate for over a year. 
I can't begin to tell you the time it has saved me on accounting, invoice billing, 
construction management and preparing monthly reports for my clients."</i>  
Vito Raymond - Property Manager</p>

<h3>Administration and Accounting</h3>
<p>
Tracking the costs involved with repairing and rehabilitating your investment 
property has just gotten easier with Visulate. Visulate users are able to enter 
personalized descriptions for repairs, as well as the expense amounts, vendor 
information, invoice numbers and also record when an invoice is paid and the 
method of payment. Visulate also provides you with the ability to depreciate 
capital improvements according to your specific needs. With Visulate you will 
always have a clear view of the work done on your property and also a snap shot 
f your investments financial stability and cash flow.</p>

<p>
<i>"After starting a new job I found Visulate a refreshing change to some other 
more complicated systems I have used. It was very easy to learn and I was up and 
running in no time. I can see exactly what my expenses are at a quick glance. It 
gives me the flexibility to enter separate expense categories that are custom to 
the way I like to run my books.</i> Robin Buckley  - Admin Assistant</p>


</div>


<div id="sign-up"  style="border: 1px solid #949494;  width:  640px; display:none">
<object width="640" height="505">
<param name="movie" value="http://www.youtube.com/v/dclGYVr0u9o&hl=en&fs=1&rel=0"></param>
<param name="allowFullScreen" value="true"></param>
<param name="allowscriptaccess" value="always"></param>
<embed src="http://www.youtube.com/v/dclGYVr0u9o&hl=en&fs=1&rel=0" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="640" height="505"></embed></object>
</div>

 

{if (@$success)}
<p>
  Your account request has been submitted.  Please check your email for account
  details and login instructions.  Check your spam folder if you don't see an 
  email titled 'Visulate Account Details' in your Inbox.
</p>      
{else}
	  <div style="text-align:center;width:40%">
		  {if (@$userAlreadyExists) }
			<p><span class="error">This user already exists in system.</span>
			  If you have forgotton your password please go to the
				<a href="{$PATH_FORM_ROOT}recover.php?USER_NAME={$form_data.LOGIN_EMAIL.value|urlencode}">recover password page</a>.
			  <br><br></p>
		  {/if}
	  </div>

<h3>$35/month - No Credit Card Required for Trial Period.</h3>
<p>
Try Visulate risk free.  We don't ask for credit card details as part of
the sign up so there's nothing to cancel if you decide it's not for you.  We 
won't sell your email address to anyone and we promise not to spam you with 
an endless series of "valuable offers".</p>
<p>
We charge $35 per month for a Visulate account and $35 an hour for related services like bookkeeping, 
tax preparation, investment analysis and property management.  
Click the links on the left of this page for additional details. 
When you're ready to start, complete the information in the fields below and press 
the "Request Account" button. </p>
			

	  {show_error info=$errorObj}
	  <form {$form_data.attributes}>
		   <table align="center">
		    {foreach from=$form_data item=item}
			  {if @($item.type == "text" || $item.type == "checkbox" || $item.type == "select" || $item.type == "lov")}
					 {if @(@$item.error)}
						<tr>
						   <td></td>
						   <td >
 					          <br />
							 <span class="error">{$item.error}</span>
						   </td>
						</tr>
					 {/if}		  			
					  <tr> 
					   <td align="right">{$item.label}</td>
					   <td>{$item.html}
					       { if (@$item.required) } <span class="error">*</span> {/if}
					   </td>
					 </tr>
			  {/if}		 
   		    {/foreach}
		     <tr>
			   <td colspan="2" align="right">
  	               {$form_data.submit.html}
				   <br>
			   </td>
			 </tr>
			</table>   
		 </form>
  <script>
     document.formRegister.LOGIN_EMAIL.focus();
  </script>	 
{/if}
{include file="google-analytics.tpl"}
{include file="footer.tpl"}
