{include file="top.tpl"}
  <!-- begin main -->
  <div id="main">
    <!-- begin content -->
    <div id="content">
      <!-- begin left part -->
     <!-- end left part -->
     <!-- begin right part -->
     <div id="right_part">  {*---right_part div is closed in footer.tpl---*} 

<script language="javascript">
  function addBU(business_id, section8_id){ldelim}
    var divName = 'div_'+business_id+'_'+section8_id;
    var url = '{$PATH_FROM_ROOT}php/addBU-section8-search.php?'+Object.toQueryString({ldelim}business_id: business_id, section8_id : section8_id{rdelim});
    var myAjax = new Ajax(url, {ldelim}method: 'get', 
	                                   update: divName
						       {rdelim} );
	myAjax.request();
  {rdelim}
</script>
<div style="width:100%;padding-top:50px">
<form {$form_data.attributes}>
  <table align="center">
    <tr><td>For search use "%" instead of any symbols.</td></tr>
    <tr>
	   <td><b>{$form_data.searchValue.label}</b> {$form_data.searchValue.html} {$form_data.find.html} {$form_data.hidden} </td>
	</tr>
    <tr><td>Click on link "Business Unit Name" for including Section8 for the Business Unit.</td></tr>	
  </table>
</form>
</div>
<center>
{if ($warning neq "")}
  <b>{$warning}</b>
{/if}
<table width="600px">
{foreach from=$data item=item key=key}
      <form>
   <tr><td colspan="2" style="border-bottom:1px dotted #006600"><br><b style="font-size:120%">{$key+1}. {$item.SECTION_NAME} </b></td></tr>
   {section name=bus loop=$item.BUSINESS_UNITS}
        {if ($smarty.section.bus.index is even)}
		   <tr>
		{/if}  
 		   <td>
		      {if ($item.BUSINESS_UNITS[bus].IS_INCLUDED eq "Y")}
   		        <span style="color:#aaaaaa">{$item.BUSINESS_UNITS[bus].BUSINESS_NAME}<span>
			  {else}
			  <div id="div_{$item.BUSINESS_UNITS[bus].BUSINESS_ID}_{$item.SECTION8_ID}">	
  			    <a href="javascript: void(0);" onclick="addBU({$item.BUSINESS_UNITS[bus].BUSINESS_ID}, {$item.SECTION8_ID})">{$item.BUSINESS_UNITS[bus].BUSINESS_NAME}</a></div>
			  {/if}
		   </td>
		{if ($smarty.section.bus.index is not even)}   
          </tr>
		{/if}
   {/section}
	{if ($smarty.section.bus.index is not even)}
	   <td></td></tr>
	{/if}   
   </form>	
		
{/foreach}
</table>
</center>
{include file="footer.tpl"}
