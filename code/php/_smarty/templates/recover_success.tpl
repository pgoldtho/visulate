{include file="loginTop.tpl"}
  <!-- begin main -->
  <div id="main">
    <!-- begin content -->
    <div id="content">
      <!-- begin left part -->
      <div id="left_part">
      <div id="nav">    
      <h2 class="title"><a href="#" class="active">Actions</a></h2>
       <ul class="left_menu">
         <li><a href="{$link}">Login</a></li>
         <li><a href="#" class="active">Recover Password</a></li>
         <li class="li_left_last"><a href="/cgi-bin/home.cgi?TF=contact">Contact Visulate</a></li>
       </ul>
     </div> <!-- end nav -->
    </div> <!-- end left part -->
    <!-- begin right part -->
  <div id="right_part">  {*---right_part div is closed in footer.tpl---*}        
 <div style="text-align:center" class="clearfix">
	  <img  src="/images/price.jpg" vspace="30" />
	  <form {$values.attributes}>
		   <table align="center">
		      <tr>
			    <td colspan="2" align="center">

				  <p>An e-mail with your login details has been sent to {$user}.
					Please note automated emails are sometimes flagged as spam by email
					software.  Please check your spam folder if you do not see an email
					from Visulate in your in-box.</p>
				  <a href="{$href}">Login</a>
				</td>
			  </tr>
			</table>   
		 </form>
      </div>
{include file="footer.tpl"}