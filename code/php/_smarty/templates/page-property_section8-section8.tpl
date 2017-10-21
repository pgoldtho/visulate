{include file="top.tpl"}
  <!-- begin main -->
  <div id="main">
    <!-- begin content -->
    <div id="content">
      <!-- begin left part -->
<div id="left_part">    {*---menu level 3---*} 
 <div id="nav">
     <script src="{$PATH_FROM_ROOT}/html/peoples.js" language="javascript"></script>
    {foreach from=$businessList item=item}
        {assign var="class"      value="closed"}
        {assign var="display"    value="none"}
        {assign var="arrow"      value="&rarr;"}
        {if ($item.BUSINESS_ID eq $businessID)  }
            {assign var="class"   value="opened"}
            {assign var="display" value="block"}
            {assign var="arrow"   value="&darr;"}
        {/if}
        <h2 class="title">
            <a href="javascript:void(0)" class="{$class}">{$arrow} {$item.BUSINESS_NAME}</a>
        </h2>
        <ul class="left_menu" style="display:{$display}">
            {if ($isEdit)}
                {assign var="l3class" value="li_left_last"}
                {if (is_array($item.SECTION8_LIST) && count($item.SECTION8_LIST) > 0)}
                    {assign var="l3class" value="li_left_first"}
                {/if}
                <li class="{$l3class}">
                    <a class="small" href="?{$menuObj->getParam2()}&BUSINESS_ID={$item.BUSINESS_ID}&action=INSERT">
                        <b>Section 8 Offices - New</b>
                    </a>
                </li>
            {else}
                {if (is_array($item.SECTION8_LIST) && count($item.SECTION8_LIST) == 0)}
                    <li class="li_left_last"></li>
                {/if}
            {/if}
	        {foreach from=$item.SECTION8_LIST item=item1 name=l3menu}
                {if $smarty.foreach.l3menu.last }
                    {assign var="l3class" value="li_left_last"}
                {elseif $smarty.foreach.l3menu.first }
                    {assign var="l3class" value="li_left_first"}
                {else}
                    {assign var="l3class" value="li_left_normal"}
                {/if}
                {if ($item1.SECTION8_BUSINESS_ID eq $s8BU_ID)}
                    <li class="{$l3class}"><a href="?{$menuObj->getParam2()}&SECTION8_ID={$item1.SECTION8_ID}&BUSINESS_ID={$item.BUSINESS_ID}&SECTION8_BUSINESS_ID={$item1.SECTION8_BUSINESS_ID}" class="active">{$item1.SECTION_NAME}</a></li>
                {else}
                    <li class="{$l3class}"><a href="?{$menuObj->getParam2()}&SECTION8_ID={$item1.SECTION8_ID}&BUSINESS_ID={$item.BUSINESS_ID}&SECTION8_BUSINESS_ID={$item1.SECTION8_BUSINESS_ID}">{$item1.SECTION_NAME}</a></li>
                {/if}
  	        {/foreach}
       </ul>
    {/foreach}
  </div> <!-- End of nav -->
</div>   <!-- End of left_part -->      
<div id="right_part">  {*---right_part div is closed in footer.tpl---*} 



 <h1>{$header_title}</h1>

{show_error info=$errorObj}
 
 <form {$form_data.attributes}>
 <table class="datatable1">
      {foreach from=$form_data item=element}
		  {if @($element.type == "text" || $element.type == "checkbox" || $element.type == "select")}
             {if @(@$element.error)}
		        <tr>
			       <td colspan="2">
				     <span class="error">{$element.error}</span>
				   </td>
			    </tr>
		     {/if}		  
            <tr>		  
		      <th>{$element.label}</th>
  	  	      <td valign="middle">
			     {$element.html}
				 { if (@$element.required) } <span class="error">*</span> {/if}
			  </td>
			</tr>
		   {/if}	
       {/foreach}  
	   {if ($isEdit)}  
	   <tr>
	     <td colspan="2" align="right" style="text-align:right">
		 {foreach from=$form_data item=element}
		     {if @($element.type == "submit")}
		     {$element.html}
		  {/if}
		 {/foreach} 
		 </td>
	   </tr>
	   {/if}
	   {if ($warning.flag != "")}
			<tr>
			 <td colspan="2" align="left">
			 {if ($warning.flag == "!")}
			    <span style="color:red">
			 {else if ($warning.flag == "-")}	
			    <span style="color:green">
			 {/if}
			 {$warning.message}
			 </span>
			 </td>
		   </tr>	   
	   {/if}
  </table>
  {$form_data.hidden}
 </form>
{include file="footer.tpl"}