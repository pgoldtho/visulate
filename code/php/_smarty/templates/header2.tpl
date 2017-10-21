{include file="top.tpl"}
  <!-- begin main -->
  <div id="main">
    <!-- begin content -->
    <div id="content">
      <!-- begin left part -->
<div id="left_part">    {*---Business Units menu level 3---*} 
 <div id="nav">
  <h2 class="title">Business Unit</h2>
    <ul class="left_menu">
        {foreach from=$businessList item=item name=l3menu}
         {if $smarty.foreach.l3menu.last }
            {assign var="l3class" value="li_left_last"}       
         {elseif $smarty.foreach.l3menu.first }
            {assign var="l3class" value="li_left_first"}
         {else}
            {assign var="l3class" value="li_left_normal"}
         {/if}
           {if ($item.BUSINESS_ID eq $businessID)}
             <li class="{$l3class}"><a href="?{$menuObj->getParam2()}&BUSINESS_ID={$item.BUSINESS_ID}" class="active">{$item.BUSINESS_NAME}</a></li>
		   {else}	 
             <li class="{$l3class}"><a href="?{$menuObj->getParam2()}&BUSINESS_ID={$item.BUSINESS_ID}">{$item.BUSINESS_NAME}</a></li>
		   {/if} 
		  {/foreach} 
		</ul>
  </div> <!-- End of nav -->
</div>   <!-- End of left_part -->
     <!-- begin right part -->
     <div id="right_part">  {*---right_part div is closed in footer.tpl---*} 
{include file="visulate-submenu.tpl"}