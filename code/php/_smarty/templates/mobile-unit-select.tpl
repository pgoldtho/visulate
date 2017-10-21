    <form >
    
      <input name="{$menuObj->request_menu_level2}" value="{$menuObj->current_level2}" type="hidden"/>
      
      <select name="{$menu3Obj->request_property_id}">
    {foreach from=$menu3Obj->data item=value key=key name=businessUnits}
       {foreach from=$value item=value1 name=l3menu}

         {if $value1.id eq $menu3Obj->current_property_id}
         <option value={$value1.id} selected>{$key} - {$value1.address}</option>
           {else}
         <option value={$value1.id}>{$key} - {$value1.address}</option>
           {/if}
      {/foreach}
    {/foreach}
		  </select><br/>
		  

 {foreach from=$menu3Obj->data item=value key=key name=businessUnits}
   {foreach from=$value item=value1 name="l3menu"}
    {if $value1.id eq $menu3Obj->current_property_id}

			 <select name="UNIT_ID">
			 
			 {foreach from=$unit_list item=uitem}
			     {if ($uitem.UNIT_UNIT_ID == $currentUnitID)}
				   <option value={$uitem.UNIT_UNIT_ID} selected>{$uitem.UNIT_UNIT_NAME}</option>
               {counter assign=current_exists}
				 {else}
			     <option value={$uitem.UNIT_UNIT_ID}>{$uitem.UNIT_UNIT_NAME}</option>
				 {/if}
			 {/foreach}
			 </select>
	  {/if}		 
	  
       {/foreach}{*---Property---*}
    {/foreach} {*---Business Units---*}
    {if $current_exists =="0"}
	  <p>Select a unit for the property then press "GO"</p>
	  {/if}
		  
		    <input value="Go" type="submit" />
		</form>
		
		

