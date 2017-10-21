{include file="mobile-top.tpl"}
<div class="content">
	  <form {$values.attributes}>
		   <table>
			  {if ($isFirst)}
				<tr><td colspan="2">
				 <h1>Account Registration</h1>
				 <p>Enter the account details from the email you received</p>
				 </td></tr>
			  {/if}
			  <tr> 
			   <td align="right">{$values.user.label}</td>
			   <td>{$values.user.html}</td>
			 </tr>
			  <tr> 
			   <td align="right">{$values.pass.label}</td>
			   <td>{$values.pass.html}</td>
			 </tr>
		     <tr>
			   <td colspan="2" align="right">
  	               {$values.submit.html}
				   <br>
			   </td>
			 </tr>
<!--			 <tr><td colspan="2">{$recover}</td></tr> -->
			 <tr>
				   <td colspan="2" align="center">
				   {if (@$error)}
				       <span class="error">
					   {$error}
				       {show_error info=$errorObj}
					   </span>
    		       {/if}
				   </td>
				  </tr>
			</table>   
            {$values.hidden}
		 </form>
  <script>
     document.formLogin.user.focus();
  </script>	 
</div>
{include file="mobile-footer.tpl"} 
