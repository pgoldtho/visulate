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
       {if ($item.code eq "CITY")}
             <li class="{$l3class}"><a href="{$item.href}" class="active">{$item.title}</a></li>
		   {else}	 
             <li class="{$l3class}"><a href="{$item.href}">{$item.title}</a></li>
		   {/if} 
      {/foreach}
       </ul>
     
     {if $getCounty}
      <h3>County Sales History</h3>
       <ul class="left_menu">
         <li class="li_left_normal"><a class="active" href="rental/visulate_search.php?REPORT_CODE=SALES&county={$getCounty}">
            {$getCounty|lower|capitalize:true} County Sales</a></li>
         <li class="li_left_normal">
           <a href="rental/visulate_search.php?REPORT_CODE=COMMERCIAL&county={$getCounty}">
            Commercial Sales</a></li>
         <li class="li_left_normal"><a href="rental/visulate_search.php?REPORT_CODE=LAND&county={$getCounty}">
            Land Sales</a></li>
         <li class="li_left_last"><a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL">Select a Different County</a></li>
       </ul>
     {/if}
<fieldset>
{literal}
<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- MD160x600 -->
<ins class="adsbygoogle" style="display:inline-block;width:160px;height:600px" data-ad-client="ca-pub-9857825912142719" data-ad-slot="6114888512"></ins>
<script>(adsbygoogle=window.adsbygoogle||[]).push({});</script>
{/literal}
</fieldset>
     
     </div> <!-- end nav -->
    </div> <!-- end left part -->
    <!-- begin right part -->
     <div id="right_part">  {*---right_part div is closed in footer.tpl---*} 

 {$report_text}  
 
<h1 id="page_header">{$pageTitle}</h1>
<p>{$pageText}</p>

<div class="col-md-6">

<div style="margin-bottom: 6px;">
{literal}
<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- MD728x90 -->
<ins class="adsbygoogle" style="display:inline-block;width:728px;height:90px" data-ad-client="ca-pub-9857825912142719" data-ad-slot="9282007715"></ins>
<script>(adsbygoogle=window.adsbygoogle||[]).push({});</script>
{/literal}
</div>


<span>
<a href="rental/visulate_search.php?REPORT_CODE=SALES&county={$getCounty}">Sales History</a> ->
{$smarty.request.YEAR|escape:'htmlall'}
</span>	
<table class="datatable">
<caption>{$pageTitle}</caption>
<tr><th scope="col">Month</th><th scope="col">City</th><th scope="col">Sales Count</th><th scope="col">Total Sales</th><th scope="col">Median Price</th></tr>
{foreach from=$data key=k item=item}
  <tr>
  <th scope="row">{$item.DISPLAY_DATE}</th>
  <th scope="row"><a href="rental/visulate_search.php?REPORT_CODE=SALES&MONTH_YEAR={$item.MONTH_YEAR}&CITY={$item.CITY}&county={$getCounty}">
       {$item.DISPLAY_CITY}</a></th>
  <td style="text-align: right">{$item.SALES_COUNT}</td>
  <td style="text-align: right">${$item.TOTAL_SALES|number_format:0:".":","}</td>
  <td style="text-align: right">${$item.AVG_PRICE|number_format:0:".":","}</td>
  </tr>
{/foreach}
</table>
</div>
{include file="google-analytics.tpl"}
{include file="footer.tpl"}
