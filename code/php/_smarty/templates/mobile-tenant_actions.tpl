	{include file="mobile-top.tpl"} 
	<div class="content">
	 		{counter start=0 assign=current_exists}
		{include file="mobile-unit-select.tpl"}	
     {counter  assign=current_exists}

{if ($current_exists == 2)}	  



{$header_title}
	
			 
 		      <form action="index.php" method="POST" id="postVals" name="postVals">
 		      
					 {$hidden_fields} 
					 {if ($isEdit eq "true")}
					   <input type="submit" name="s_new_action" value="New action">
					   {$form_data.TEMPLATE.html}
					 {/if}
					 {if ($prev_agreement) }
					    <input type="submit" name="s_prev_agreement" value="Prev agreement">
					 {else}
					   	<input type="submit" name="s_prev_agreement" value="Prev agreement" disabled="disabled">
					 {/if}
					 
					 {if ($next_agreement)}
					    <input type="submit" name="s_next_agreement" value="Next agreement">
					 {else}
					   	<input type="submit" name="s_next_agreement" value="Next agreement" disabled="disabled">
					 {/if}
				   </form>

			  <table class="datatable" width="100%">
					   <tr>
					      {if ($isEdit eq "true")}
						  <th></th>
						  {/if}
						  <th>Date <span class="error">*</span></th>
						  <th>Action <span class="error">*</span></th>
						  <th>Cost <span class="error">*</span></th>
						  <th>Recoverable</th>						  
					      {if ($isEdit eq "true")}
						  <th></th>
						  {/if}
					   </tr>
			  {foreach from=$actionList item=element}
				{if ($element.ACTION_ID == $currentActionID) }
				  <form {$form_data.attributes}>
				   <tr>
					  <td style="background-color:#eeeeee"></td>
						  {foreach from=$form_data item=element}
							{if @($element.type == "text" 
							   || $element.type == "checkbox" 
								 || $element.type == "select")&& ($element.name != "TEMPLATE")}
							  <td style="background-color:#eeeeee">
								{if @(@$element.error)}
								   <span class="error">{$element.error}</span>
								{/if}		  
								{$element.html}
								{calendar elements=$dates current=$element.name} 
								</td>
							 {/if}	
						   {/foreach}  
					  <td style="background-color:#eeeeee"></td>					     			
					</tr>
					<tr>
					   <td colspan="6" style="background-color:#eeeeee">
						   {foreach from=$form_data item=element}
							 {if @($element.type == "submit")}
								{$element.html}
							 {/if}
						   {/foreach}	
					   </td>
					</tr>
					{$form_data.hidden}
				   </form>	
				{else}	 
					  <tr>	
   					    {if ($isEdit eq "true")}
	  					  <td>{$element.EDIT_LINK}</td>						   
						{/if}
						<td>{$element.ACTION_DATE}</td>   		   
						<td>{$element.ACTION_TYPE_NAME}</td>   		
						<td>{$element.ACTION_COST}</td>
						<td style="text-align:center">
							{if ($element.RECOVERABLE_YN eq 'Y') }
							   [ X ]
							{else}  
							   [ &nbsp; ]
							{/if}   
						</td>   		   				
   					    {if ($isEdit eq "true")}
                             <td>{$element.DELETE_LINK}</td>						   	  					
						{/if}
					  </tr>
				  {/if}	 				  
			  {/foreach}
			  </table>			 
 {/if}
</div>
{include file="mobile-footer.tpl"}
