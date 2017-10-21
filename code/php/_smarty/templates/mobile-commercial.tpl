{include file="homeTop.tpl"}
  <!-- begin main -->
  <div id="main">
    <!-- begin content -->
    <div id="content">
      <!-- begin left part -->
      <div id="left_part">
      <div id="nav">


      

   <h2 class="title">Items</h2>
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
 
<h1 id="page_header">Brevard County Florida Commercial Sales History</h1>
<p>
This page shows commercial property sales data for Brevard County Florida.  It 
displays sales data recorded in the Visulate database and shows
a breakdown by year of the number of properties sold, total sales volume and
median price.  The data was sourced from public records and is deemed reliable 
but not guaranteed.  It should be independently verified. Click on the year to 
see the details for each year.</p>

<div class="column span-50">	


<table class="datatable">
<tr><th>Year</th><th>Sales Count</th><th>Total Sales</th><th>Median Price</th></tr>
{foreach from=$data key=k item=item}
  <tr>
  <td><a href="rental/visulate_search.php?REPORT_CODE=COMMERCIAL&YEAR={$k}">{$k}</a></td>
  <td>{$item.SALES_COUNT}</td>
  <td>{show_number number=$item.TOTAL_SALES}</td>
  <td>{show_number number=$item.AVG_PRICE}</td>
  </tr>
{/foreach}
</table>
</div>
<div class="column span-40">	
<img src="/images/sales_history.jpg" alt="Sales History" style="border: 1px solid #949494;"/>
</div>


{include file="google-analytics.tpl"}
{include file="footer.tpl"}