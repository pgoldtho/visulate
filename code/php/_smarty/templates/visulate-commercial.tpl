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
     

     </div> <!-- end nav -->
    </div> <!-- end left part -->
    <!-- begin right part -->
     <div id="right_part">  {*---right_part div is closed in footer.tpl---*} 

 {$report_text}  
 
<h1 id="page_header">Florida Commercial Sales History</h1>
<p>
This page shows commercial property sales data for Florida.  It
displays sales data recorded in the Visulate database and shows
a breakdown by year of the number of properties sold, total sales volume and
median price.  The data was sourced from public records and is deemed reliable 
but not guaranteed.  It should be independently verified. Click on the year to 
see the details for each year.</p>

<div class="col-md-6">


<table class="datatable">
<tr><th>Year</th><th>Sales Count</th><th>Total Sales</th><th>Median Price</th></tr>
{foreach from=$data key=k item=item}
  <tr>
  <td><a href="rental/visulate_search.php?REPORT_CODE=COMMERCIAL&YEAR={$k}">{$k}</a></td>
  
  <td style="text-align: right">{$item.SALES_COUNT|number_format:0:".":","}</td>
  <td style="text-align: right">${$item.TOTAL_SALES|number_format:0:".":","}</td>
  <td style="text-align: right">${$item.AVG_PRICE|number_format:0:".":","}</td>
  </tr>
{/foreach}
</table>
</div>

<div class="col-md-6" style="margin-top: 14px;">
{literal}
<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- MD336x280 -->
<ins class="adsbygoogle"
     style="display:inline-block;width:336px;height:280px"
     data-ad-client="ca-pub-9857825912142719"
     data-ad-slot="1758740915"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
{/literal}
</div>
{include file="google-analytics.tpl"}
{include file="footer.tpl"}
