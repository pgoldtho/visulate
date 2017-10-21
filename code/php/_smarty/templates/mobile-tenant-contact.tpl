{include file="mobile-top.tpl"}
    <div class="content">

   {foreach from=$businessList item=item}
     <h2>{$item.BUSINESS_NAME}</h2>
	   
     <ul>
	   {foreach from=$item.PEOPLES item=item1 name=l3menu}
	       <li><a href="tel:{$item1.PHONE1|replace:' ':''}">{$item1.PEOPLE_NAME} - {$item1.PHONE1}</a></li>
 	   {/foreach}
     </ul>
   {/foreach}


  </div> <!-- End of content -->
{include file="mobile-footer.tpl"}  


