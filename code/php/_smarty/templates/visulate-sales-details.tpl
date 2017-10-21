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
 
<h1 id="page_header">Brevard County Florida Annual Property Sales History</h1>
<p>
This page shows property sales data for all properties sold in Brevard County Florida.  
It displays sales data recorded in the Visulate database and shows
a breakdown by year of the number of properties sold, total sales volume and
median price.  The data is sourced from public records and is deemed reliable but not guaranteed.  It
should be independently verified.  Click on the year to see sales details for each year.</p>

<div class="col-md-6">	


<table class="datatable">
<tr><th>Year</th><th>Sales Count</th><th>Total Sales</th><th>Median Price</th></tr>
{foreach from=$data key=k item=item}
  <tr>
  <td><a href="rental/visulate_search.php?REPORT_CODE=SALES&YEAR={$k}">{$k}</a></td>
  <td>{$item.SALES_COUNT}</td>
  <td>{show_number number=$item.TOTAL_SALES}</td>
  <td>{show_number number=$item.AVG_PRICE}</td>
  </tr>
{/foreach}
</table>
</div>
{if $publicUser}
<div class="col-md-4" style="margin-top: 14px;">
<script type="text/javascript"><!--
google_ad_client = "pub-9857825912142719";
/* 300x250, created 5/30/10 */
google_ad_slot = "3313230659";
google_ad_width = 300;
google_ad_height = 250;
//-->
</script>
<script type="text/javascript"
src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
</script>
</div>
{else}
<div class="col-md-6">
<img src="/images/sales_history.jpg" alt="Sales History" style="border: 1px solid #949494;"/>
</div>
{/if}
{include file="google-analytics.tpl"}
{include file="footer.tpl"}