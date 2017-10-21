	{include file="mobile-top.tpl"} 
	<div class="content">
	 		{counter start=0 assign=current_exists}
		{include file="mobile-unit-select.tpl"}	
     {counter  assign=current_exists}

{if ($current_exists == 2)}	  

   <table class="datatable1">
      {foreach from=$form_data item=element}
		  {if @($element.type == "text" || $element.type == "checkbox" || $element.type == "select")}
             {if @(@$element.error)}
		        <tr>
			       <td colspan="2">
				     <span class="error">{$element.error}</span>
				   </td>
			    </tr>
		     {/if}	{*---element.error---*}	  
            <tr>		  
		      <th>{$element.label}</th>
  	  	      <td class="{$element.name}">
			     {$element.html}
				 {calendar elements=$dates current=$element.name} 
				 { if (@$element.required) } <span class="error">*</span> {/if}
			  </td></tr>
    	    </tr>
		   {/if}	{*---element type---*}	  
    {/foreach}    
   </table>	 

{/if} {*---is_exists---*}	  



{$form_data.hidden}


</div>
{include file="mobile-footer.tpl"}
