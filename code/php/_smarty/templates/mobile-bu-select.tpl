    <form >
      <input name="{$menuObj->request_menu_level2}" value="{$menuObj->current_level2}" type="hidden"/>
      <select name="BUSINESS_ID">
        <option value="">Select Business Unit</option>
        {foreach from=$businessList item=item name=l3menu}
           {if ($item.BUSINESS_ID eq $businessID)}
             <option value="{$item.BUSINESS_ID}" selected>{$item.BUSINESS_NAME}</option>
		   {else}	 
             <option value="{$item.BUSINESS_ID}">{$item.BUSINESS_NAME}</option>
		   {/if} 
		  {/foreach} 
		  </select>
		    <input value="Go" type="submit" />
		</form>
		
