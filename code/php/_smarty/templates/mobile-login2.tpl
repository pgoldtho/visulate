{include file="mobile-top.tpl"}
  <div class="content">
	  <form {$values.attributes}>
		   <table>
			 {if @(!$error) }
			  <tr> 
			   <td>{$values.role.label}</td>
			   <td>{$values.role.html}</td>
			 </tr>
			 {/if}
		     	 <tr>
				   <td colspan="2">
				   {if (@$error)}
				       <span class="error">
					   {$error}
					   </span>
    		       {/if}
				   </td>
				  </tr>
                <tr>
			     <td colspan="2">
    			   {if @(!$error) } 
  	                 {$values.submit.html}
				   {/if}	 
				   {$values.logout.html}
			   </td>
			 </tr>				  
			</table>   
		 </form>
	</div>
{include file="mobile-footer.tpl"}
