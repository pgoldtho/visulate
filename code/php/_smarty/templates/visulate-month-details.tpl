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
      <h3>County Sales History</a></h3>
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
 
<h1 id="page_header"> {$pageTitle}</h1>
<p>
{$pageText}
</p>

<span>
<a href="rental/visulate_search.php?REPORT_CODE=SALES&county={$getCounty}"> County Sales History</a> ->
<a href="rental/visulate_search.php?REPORT_CODE=SALES&YEAR={$year}&county={$getCounty}">{$year}</a> ->
{$smarty.request.CITY|escape:'htmlall'|lower|capitalize}, Flordia Property Sales - {$month} {$year}
</span>

{if $count_r >= 51}
<span>{$count_r} properties sold.  The first 50 were plotted on the map. Full details appear below.</span>
{/if}

<h3>Sales Details</h3>
<div class="col-md-6">


<table class="datatable">
<caption>{$pageTitle}</caption>
<tr><th scope="col">Date</th><th scope="col">Address</th><th scope="col">Price</th></tr>
{foreach from=$data key=k item=item}
  <tr>
  <th scope="row">{$item.SALE_DATE}</th>
  <td><a href="rental/visulate_search.php?REPORT_CODE=PROPERTY_DETAILS&PROP_ID={$k}">{$item.ADDRESS}</td>
  <td style="text-align: right">${$item.PRICE|number_format:0:".":","}</td>
  </tr>
{/foreach}
</table>
</div>

<div class="col-md-6" >
{literal}
<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- MD160x600 -->
<ins class="adsbygoogle" style="display:inline-block;width:160px;height:600px" data-ad-client="ca-pub-9857825912142719" data-ad-slot="6114888512"></ins>
<script>(adsbygoogle=window.adsbygoogle||[]).push({});</script>
{/literal}
</div>


{include file="google-analytics.tpl"}
{include file="footer.tpl"}
