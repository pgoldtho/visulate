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
<!-- zipcode160x600 -->
<ins class="adsbygoogle"
     style="display:inline-block;width:160px;height:600px"
     data-ad-client="ca-pub-9857825912142719"
     data-ad-slot="8480782110"></ins>
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

{if ($agent)}

<h1>{$agent.NAME}</h1>
<div class="col-md-4">
<table class="datatable">
<tr><th>License Type</th><td>{$agent.LICENSE_TYPE}</td></tr>
<tr><th>Doing Business As</th><td>{$agent.DBA_NAME}</td></tr>
<tr><th>License Date</th> <td>{$agent.LICENSE_DATE|date_format:"%Y-%m-%d"}</td></tr>
<tr><th>City</th><td>{$agent.CITY}</td></tr>
<tr><th>State</th><td>{$agent.STATE}</td></tr>
<tr><th>Zipcode</th><td><a href="/rental/visulate_search.php?REPORT_CODE=AGENT&ZIPCODE={$agent.ZIPCODE}">{$agent.ZIPCODE}</a></td></tr>
<tr><th>Primary License Status</th><td>{$agent.PRIMARY_STATUS}</td></tr>
<tr><th>Secondary License Status</th><td>{$agent.SECONDARY_STATUS}</td></tr>
<tr><th>Sole Proprietor</th><td>{$agent.SOLE_PROPRIETOR}</td></tr>
<tr><th>Office</th><td><a href="/rental/visulate_search.php?REPORT_CODE=AGENT&LICENSE={$agent.EMPLOYER_LICENSE_NUMBER}">{$agent.BROKERAGE}</a></td></tr>
</table>
</div>
<div class="col-md-8">

{if $agent.LICENSE_TYPE=='CQ RE Corp.'}
<h3>Office Address:</h3>
<ul>
<li>{$agent.ADDRESS1}, {$agent.CITY}, {$agent.STATE} {$agent.ZIPCODE}</li>
</ul>
{/if}

<h3>Contact Details:</h3>
<ul>
{if $agent.LICENSE_TYPE=='CQ RE Corp.'}
<li><a href="http://www.yellowpages.com/{$agent.CITY}-{$agent.STATE}/{$agent.NAME}" target="_blank">Yellow Pages</a></li>
<li><a target=”_blank” href="http://www.whitepages.com/business?key={$agent.NAME}&where={$agent.CITY}%2C+{$agent.STATE}">White Pages</a></li>
<li><a target=”_blank” href="http://www.ziplocal.com/list.jsp?na={$agent.NAME}&ct={$agent.ZIPCODE}">Zip Local</a></li>
{else}
<li><a href="http://www.whitepages.com/name/{$agent.FIRST_NAME}-{$agent.LAST_NAME}/{$agent.CITY}-{$agent.STATE}/" target="_blank">White Pages</a></li>
<li><a href="http://www.spokeo.com/search?q={$agent.FIRST_NAME}+{$agent.LAST_NAME},{$agent.CITY}+{$agent.STATE}/" target="_blank">Spokeo</a></li>
{/if}
<li><a href="http://www.google.com/search?q={$agent.NAME}+{$agent.CITY}+real+estate" target="_blank">Search Google</a></li>
<li><a href="http://www.realtor.com/realestateagents/{$agent.CITY}_{$agent.STATE}/agentname-{if $agent.LAST_NAME}{$agent.LAST_NAME}{else}{$agent.NAME}{/if}" target="_blank">Search Realtors</a></li>

</ul>
</div>
<div class="col-md-12">
  {if ($agent.AGENTS)}
    <h3>Agents</h3>
    <table class="datatable">
    <tr><th>Name</th><th>License Type</th><th>License Date</th><th>City</th><th>Primary Status</th><th>Secondary Status</th></tr>
    {foreach from=$agent.AGENTS item=a}
    <tr><td><a href="/rental/visulate_search.php?REPORT_CODE=AGENT&LICENSE={$a.LICENSE_NUMBER}">{$a.NAME}</a></td>
        <td>{$a.LICENSE_TYPE}</td>
        <td>{$a.LICENSE_DATE|date_format:"%Y-%m-%d"}</td>
        <td>{$a.CITY}</td>
        <td>{$a.PRIMARY_STATUS}</td>
        <td>{$a.SECONDARY_STATUS}</td>
    </tr>
    {/foreach}
    </table>
  {/if}

  {if ($agent.COURSES)}
    <h3>Completed Training</h3>
    <table class="datatable">
    <tr><th>Date</th><th>Course Name</th><th>Hours</th></tr>
    {foreach from=$agent.COURSES item=c}
    <tr>
        <td>{$c.COURSE_DATE|date_format:"%Y-%m-%d"}</td>
        <td><a href="/rental/visulate_search.php?REPORT_CODE=AGENT&ZIPCODE={$agent.ZIPCODE}&COURSE={$c.COURSE_NUMBER}">
        {$c.COURSE_NAME}</a></td>
        <td>{$c.COURSE_CREDIT_HOURS}</td>
    </tr>
    {/foreach}
    </table>
  {/if}

  
</div>
{else}
<h1 id="page_header">Zipcode {$zipcode}, {$zipdata.PLACE_NAME}</h1>

<div id="zipdata" class="col-md-12">
  <div id="map" style="width: 318px; height: 280px; float: right;"></div>
  <h3>Zipcode Data</h3>
  <p>Zipcode {$zipcode} is {$zipdata.PLACE_NAME} in {$zipdata.COUNTY} County, {$zipdata.STATE_NAME}.
  {if $zipdata.COUNTY_WT}
   Properties in this zipcode sell for {$zipdata.COUNTY_WT}% of the median for {$zipdata.COUNTY} County
  and {$zipdata.CITY_WT}% of the median for {$zipdata.PLACE_NAME}.{/if}</p>
  <p>There are {$zipdata.ZIPCODES|@count} zipcodes in {$zipdata.PLACE_NAME}:
    {foreach from=$zipdata.ZIPCODES item=zp name=codes}
      {if $smarty.foreach.codes.last} and {/if}
      {if $zp.ZIPCODE == $zipcode}
        {$zp.ZIPCODE}
      {else}
        <a href="/rental/visulate_search.php?REPORT_CODE=AGENT&ZIPCODE={$zp.ZIPCODE}">{$zp.ZIPCODE}</a>
      {/if}
  {/foreach}
<p>
  There are {$zipdata.AGENT_COUNT} real estate professionals with active licenses in this zipcode.
  The table below shows a list of the training courses that they have completed.  Click on a courses
  to see a list of people who have completed the training.
  </p>
 <h3>Zipcode Links</h3>
  <ul><li><a href="http://www.city-data.com/zips/{$zipcode}.html" target="_blank">
   Review demographic Data for Zipcode {$zipcode} on City-Data.com</a></li>
     <li><a href="http://www.hours-locations.com/search/?q=&where={$zipcode}" target="_blank">
        Phone numbers and opening hours for local businesses</a></li>

   
   </ul>
</div>

<div class="col-md-6">
<h3>Courses Completed by Agents Based in {$zipcode}</h3>
{if ($data)}
<table  class="datatable">
<tr><th>Course Name</th><th>Count</th></tr>
{foreach name=outer from=$data item=r key=rkey}
 <tr>
  <td><a href="/rental/visulate_search.php?REPORT_CODE=AGENT&ZIPCODE={$zipcode}&COURSE={$r.COURSE_NUMBER}">{$r.COURSE_NAME}</a></td>
  <td>{$r.COURSE_COUNT}</td></tr>
{/foreach}
</table>
{else}
<p>
Visulate has property records for over 8 million properties in Florida.  
<p>
{/if}
</div>


<div class="col-md-6">
{if ($agentdata)}
<h3>{$agentdata[0].COURSE_NAME}</h3>
<table  class="datatable">
<tr><th>Name</th><th>Date Taken</th></tr>

  {assign var="cname" value="makeMeDiff"}
  {foreach name=outer from=$agentdata item=a}
 <tr>
  {if $a.LICENSEE_NAME != $cname}
  <td><a href="/rental/visulate_search.php?REPORT_CODE=AGENT&LICENSE={$a.LICENSE_NUMBER}">{$a.LICENSEE_NAME}</a></td>
  <td>{$a.COURSE_DATE|date_format:"%Y-%m-%d"}</td></tr>
  {assign var="cname" value=$a.LICENSEE_NAME}
  {/if}
{/foreach}
{else}
<div style="margin-top: 26px;">
{literal}
<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- zipcode160x600 -->
<ins class="adsbygoogle"
     style="display:inline-block;width:160px;height:600px"
     data-ad-client="ca-pub-9857825912142719"
     data-ad-slot="8480782110"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
{/literal}
</div>
{/if}
</table>
</div>
{/if}
{include file="google-analytics.tpl"}
{include file="footer.tpl"}
