{include file="homeTop.tpl" noindex="y"}
  <!-- begin main -->
  <div id="main">
    <!-- begin content -->
    <div id="content">
      <!-- begin left part -->
      <div id="left_part">
      <div id="nav">
      

   <h3>Items</h3>
       <ul class="left_menu">
       {foreach from=$ReportList item=item name=l3menu}
         {if $smarty.foreach.l3menu.last }
            {assign var="l3class" value="li_left_last"}       
         {elseif $smarty.foreach.l3menu.first }
            {assign var="l3class" value="li_left_first"}
         {else}
            {assign var="l3class" value="li_left_normal"}
         {/if}
       {if ($item.code eq $reportCode)}
             <li class="{$l3class}"><a href="{$item.href}" class="active">{$item.title}</a></li>
       {else}
             <li class="{$l3class}"><a href="{$item.href}">{$item.title}</a></li>
       {/if}
      {/foreach}
       </ul>
     
<fieldset>
{literal}
<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- owner160x600 -->
<ins class="adsbygoogle"
     style="display:inline-block;width:160px;height:600px"
     data-ad-client="ca-pub-9857825912142719"
     data-ad-slot="2573849319"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
{/literal}
</fieldset>

     </div> <!-- end nav -->
    </div> <!-- end left part -->
    <!-- begin right part -->
     <div id="right_part">  {*---right_part div is closed in footer.tpl---*} 

 {$report_text}  
 
<h1 id="page_header">Property Owner Details</h1>

<div class="col-md-8">

{if ($data)}
{foreach name=outer from=$data item=report_element key=report_key}
 
  {if ($report_key == 'MAILING_ADDRESS')}
  <h4>Mailing Address</h4>
  {foreach from=$report_element key=k item=item}
  <p>  
  {if $publicUser}
    {$item.OWNER_NAME}<br/>
  {else}
    {$item.OWNER_NAME}<br/>
  {/if}
    <a href="rental/visulate_search.php?REPORT_CODE=PROPERTY_DETAILS&PROP_ID={$k}">  
    {$item.ADDRESS1}</a><br/>
    {if ($item.ADDRESS2)}{$item.ADDRESS2}<br/>{/if}
    {$item.CITY}<br/>
    {$item.STATE_ZIP}<br/>
  </p>
  {/foreach}
  {include file="florida-appraiser.tpl"}

  {elseif ($report_key == 'TRANSACTIONS')}
  <h4>Transaction History</h4>
  <table class="datatable">
  <tr><th>Date</th><th>Buy/Sell</th><th>Property</th><th>Deed Type</th><th>Price</th></tr>
  {foreach from=$report_element key=t item=t_item name=trans}
  <tr>
  <td>{$t_item.SALE_DATE}</td>
  <td>{$t_item.BUY_SELL}</td>
  <td><a href="rental/visulate_search.php?REPORT_CODE=PROPERTY_DETAILS&PROP_ID={$t_item.PROP_ID}">  
    {$t_item.ADDRESS1}, {$t_item.CITY}</a>
  </td>
  <td>{$t_item.DEED_DESC}</td>
  <td>{show_number number=$t_item.PRICE}</td>
  </tr>
  {/foreach}
  </table>
  {elseif ($report_key == 'PROPERTIES')}
  <h4>Current Properties</h4>
  <table class="datatable">
  <tr><th>Property</th><th>Purchased</th><th>Purchase Price</th></tr>
  {foreach from=$report_element key=t item=p_item name=props}
  <tr>
  <td><a href="rental/visulate_search.php?REPORT_CODE=PROPERTY_DETAILS&PROP_ID={$t}">  
  {$p_item.ADDRESS1}, {$p_item.CITY}</a>
  </td>
  <td>{$p_item.SALE_DATE}</td>
  <td>{show_number number=$p_item.PRICE}</td>
  </tr>
  {/foreach}
  </table>
  

  {/if}

{/foreach}
{else}
<p>
Visulate has property records for over 8 million properties in Florida.  
<p>
{/if}
</div>

<div class="col-md-4">
{literal}
<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- owner160x600 -->
<ins class="adsbygoogle"
     style="display:inline-block;width:160px;height:600px"
     data-ad-client="ca-pub-9857825912142719"
     data-ad-slot="2573849319"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
{/literal}
</div>

{include file="google-analytics.tpl"}
{include file="footer.tpl"}
