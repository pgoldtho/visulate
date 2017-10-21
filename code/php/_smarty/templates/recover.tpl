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
     <h2 class="title">Warning</h2>     
      <ul class="left_menu">
        <li class="li_left_last"><a>Unauthorized use of this site is 
		    prohibited and may be subject to civil and criminal prosecution</a></li>  	  
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
				  <h2>{$header_title}</h2>
				</td>
			  </tr>
			  <tr> 
			   <td align="right">{$values.user.label}</td>
			   <td>{$values.user.html}</td>
			 </tr>
  	        <tr>
			   <td colspan="2" align="right">
  	               {$values.submit.html}
			   </td>
			 </tr>
				 <tr>
				   <td colspan="2" align="center">
				   {if (@$error)}
				       <span class="error">
					   {$error}
					   </span>
    		       {/if}<br>
			   	   {show_error info=$errorObj}<br>
   				   <a href="{$link}">Login</a>
					   
				   </td>
				  </tr>
			</table>   
		 </form>
  <script>
     document.formLogin.user.focus();
  </script>	 
  </div>
{include file="footer.tpl"}