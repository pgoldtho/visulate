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
         <li class="li_left_normal"><a href="rental/visulate_search.php?REPORT_CODE=SALES&county={$getCounty}">
            {$getCounty|lower|capitalize:true} County Sales</a></li>
         <li class="li_left_normal">
           <a {if $cclass} class="active" {/if} href="rental/visulate_search.php?REPORT_CODE=COMMERCIAL&county={$getCounty}">
            Commercial Sales</a></li>
         <li class="li_left_normal"><a {if $lclass} class="active" {/if} href="rental/visulate_search.php?REPORT_CODE=LAND&county={$getCounty}">
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

<div style="margin-bottom: 6px;">
{literal}
<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- MD728x90 -->
<ins class="adsbygoogle" style="display:inline-block;width:728px;height:90px" data-ad-client="ca-pub-9857825912142719" data-ad-slot="9282007715"></ins>
<script>(adsbygoogle=window.adsbygoogle||[]).push({});</script>
{/literal}
</div>


<span>
{if ($lclass)}
<a href="rental/visulate_search.php?REPORT_CODE=LAND&county={$getCounty}">Commercial Sales History</a> ->
<a href="rental/visulate_search.php?REPORT_CODE=LAND&YEAR={$smarty.request.CYEAR|escape:'htmlall'}&county={$getCounty}">
{else}
<a href="rental/visulate_search.php?REPORT_CODE=COMMERCIAL&county={$getCounty}">Commercial Sales History</a> ->
<a href="rental/visulate_search.php?REPORT_CODE=COMMERCIAL&YEAR={$smarty.request.CYEAR|escape:'htmlall'}&county={$getCounty}">
{/if}
{$smarty.request.CYEAR|escape:'htmlall'}</a> ->
{$display_class} Sales</span>





<div class="col-md-12">
<h3>Sales Records</h3>
<table class="datatable">
<caption>{$pageTitle}</caption>
<tr><th scope="col">Date</th><th scope="col">Address</th><th scope="col">Sq Ft</th><th scope="col">Acreage</th><th scope="col">Price</th></tr>
{foreach from=$data key=k item=item}
  <tr>
  <th scope="row">{$item.SALE_DATE}</th>
  <td><a href="rental/visulate_search.php?REPORT_CODE=PROPERTY_DETAILS&PROP_ID={$k}">{$item.ADDRESS}</td>
   <td style="text-align: right">{$item.SQ_FT|number_format:0:".":","}</td>
   <td style="text-align: right">{$item.ACREAGE|number_format:2:".":","}</td>
    <td style="text-align: right">${$item.PRICE|number_format:0:".":","}</td>
  </tr>
{/foreach}
</table>
</div>
{include file="google-analytics.tpl"}
{include file="footer.tpl"}
