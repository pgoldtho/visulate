{include file="homeTop.tpl"}
{include file="letterbox-img.tpl"}
  <!-- begin main -->
  <div id="main">
    <!-- begin content -->
    <div>

{if ($data)}
{foreach name=outer from=$data item=report_item key=report_key}

{if ($report_key eq 'SUNBIZ-ID')}
  {assign var="corpID"    value=$report_item.CORP_NUMBER} 
  {assign var="corpStatus"    value=$report_item.STATUS} 
  {assign var="corpName"  value=$report_item.NAME} 
  {assign var="addr1"     value=$report_item.ADDR.ADDRESS1}
  {assign var="corpCity"  value=$report_item.ADDR.CITY} 
  {assign var="corpState" value=$report_item.ADDR.STATE}
  {assign var="corpCounty" value=$report_item.ADDR.COUNTY}



    <!-- begin right part -->
     <div >  {*---right_part div is closed in footer.tpl---*}

 {$report_text}  
 


<div class="col-md-12" itemscope itemtype="http://schema.org/LocalBusiness" >

<h1 id="page_header"><span itemprop="name">{$report_item.NAME}</span></h1>

<p><span itemprop="description">{$report_item.NAME} is a 
{if $report_item.FILING_TYPE == "DOMP"} Florida for profit corporation
{elseif $report_item.FILING_TYPE == "DOMNP"} Florida non profit corporation
{elseif $report_item.FILING_TYPE == "FORP"} Foreign (non Florida) for profit corporation
{elseif $report_item.FILING_TYPE == "FORNP"} Foreign (non Florida) non profit corporation
{elseif $report_item.FILING_TYPE == "DOMLP"} Florida limited partnership
{elseif $report_item.FILING_TYPE == "FORLP"} Foreign (non Florida) limited partnership
{elseif $report_item.FILING_TYPE == "FLAL"} Florida limited liability company
{elseif $report_item.FILING_TYPE == "FORL"} Foreign (non Florida) limited liability company
{elseif $report_item.FILING_TYPE == "NPREG"} non profit, regulated entity
{elseif $report_item.FILING_TYPE == "TRUST"} declaration of trust entity
{elseif $report_item.FILING_TYPE == "AGENT"} declaration of registered agent entity
{else} business, or non profit entity {/if}
based in {$report_item.ADDR.CITY}.  
They registered with the Florida Department of State's Division of Corporations
on {$report_item.FILING_DATE|date_format}.</p>
{if ($streetview)}
 <figure>
  <img id="mainPicture" src="{$streetview}" style="border: 1px solid #949494;"
      alt="Google Street View for {$report_item.NAME}'s Principal Location"/>
  <figcaption>Principal Address: {$report_item.ADDR.ADDRESS1}, {$report_item.ADDR.CITY}</figcaption>
</figure>
{/if}

<p>
Visulate is a real estate brokerage based in Mims, Florida.
We have assembled a directory of Florida companies as a research resource to assist in commercial real estate transactions.
{if ($report_item.NAME ne 'Visulate LLC')}
<strong>Visulate.com is an independent website and is not affiliated with, nor has it been authorized, sponsored, or
otherwise approved by {$report_item.NAME}</strong>
{/if}
</span></p>

<h3>Florida Sunbiz Corporation Details</h3>
{if $is_editor}
{$errorMsg2}

 <form {$form_data.attributes}>
{$form_data.hidden}

<table class="datatable">
<tr><th>Corporation Number</th><td>{$report_item.CORP_NUMBER}</td></tr>
<tr><th>{$form_data.NAME.label}</th><td>{$form_data.NAME.html}</td></tr>
<tr><th>{$form_data.STATUS.label}</th><td>{$form_data.STATUS.html}</td></tr>
<tr><th>{$form_data.FILING_TYPE.label}</th><td>{$form_data.FILING_TYPE.html}</td></tr>
<tr><th>{$form_data.FILING_DATE.label}</th><td>{$form_data.FILING_DATE.html}</td></tr>
<tr><th>{$form_data.FEI_NUMBER.label}</th><td>{$form_data.FEI_NUMBER.html}</td></tr>
</table>


<h3>Principal Address</h3>
<table class="datatable">
<tr><th>{$form_data.ADDRESS1.label}</th><td>{$form_data.ADDRESS1.html}</td></tr>
<tr><th>{$form_data.ADDRESS2.label}</th><td>{$form_data.ADDRESS2.html}</td></tr>
<tr><th>{$form_data.CITY.label}</th><td>{$form_data.CITY.html}</td></tr>
<tr><th>{$form_data.STATE.label}</th><td>{$form_data.STATE.html}</td></tr>
<tr><th>{$form_data.ZIPCODE.label}</th><td>{$form_data.ZIPCODE.html}</td></tr>
<tr><th>{$form_data.CPROP_ID.label}</th><td>{$form_data.CPROP_ID.html}</td></tr>
<tr><th>{$form_data.LAT.label}</th><td>{$form_data.LAT.html}</td></tr>
<tr><th>{$form_data.LON.label}</th><td>{$form_data.LON.html}</td></tr>

</table>


      {$form_data.action_save.html}
      {$form_data.action_cancel.html}

{else}
</div>
<div class="col-md-6">

<table class="table">
<tr><th>Corporation Number</th><td>
<form action="http://search.sunbiz.org/Inquiry/CorporationSearch/ByDocumentNumber" method="post" target="_blank">
<input class="SearchTermInputField" id="SearchTerm" name="SearchTerm" type="hidden" value="{$report_item.CORP_NUMBER}" />
<input type="submit" name="Search" value="{$report_item.CORP_NUMBER}" />
</form></tr>
<tr><th>Status</th><td>{if $report_item.STATUS == 'I'}Inactive{else}Active{/if}</td></tr>  
<tr><th>Filing Type</th><td>{$report_item.FILING_TYPE}</td></tr>  
<tr><th>Filing Date</th><td>{$report_item.FILING_DATE|date_format}</td></tr>  
<tr><th>FEI Number</th><td>{$report_item.FEI_NUMBER}</td></tr>  
<tr><th>Principal Address</th><td>
<div itemprop="address" itemscope itemtype="http://schema.org/PostalAddress">
<span itemprop="streetAddress">
{if $report_item.ADDR.PROP_ID > 0}
<a href="/property/{$report_item.ADDR.PROP_ID}"> {$report_item.ADDR.ADDRESS1}</a>
{else}
{$report_item.ADDR.ADDRESS1}
{/if}
</span>
{$report_item.ADDR.ADDRESS2}<br/>
<span itemprop="addressLocality">{$report_item.ADDR.CITY}</span><br/>
<span itemprop="addressRegion">{$report_item.ADDR.STATE}</span>  <span itemprop="postalCode">{$report_item.ADDR.ZIPCODE}</span><br/>
</div></td></tr>  
</table>
</div>
<div class="col-md-6">
{if  ($corpStatus!='H')}
{literal}
<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- corp336x280 -->
<ins class="adsbygoogle"
     style="display:inline-block;width:336px;height:280px"
     data-ad-client="ca-pub-9857825912142719"
     data-ad-slot="1280952517"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
{/literal}
{/if}
</div>
<div class="col-md-12">
{/if}

{assign var="lat" value=$report_item.ADDR.LAT} 
{assign var="lon" value=$report_item.ADDR.LON} 
{assign var="geo_found" value=$report_item.ADDR.GEO_FOUND} 
{if $geo_found == 'Y'}
<div  itemprop="geo" itemscope itemtype="http://schema.org/GeoCoordinates">
  <meta itemprop="latitude"  content="{$lat}" />
  <meta itemprop="longitude" content="{$lon}" />
</div>
{/if}


{foreach from=$report_item.PROPERTIES item=prop name=i}
{if  $smarty.foreach.i.first}
 <h4>Properties Owned by {$report_item.NAME}</h4>
{/if}
<p>
<a href="/property/{$prop.PROP_ID}"> {$prop.ADDRESS1}</a> {$prop.ADDRESS2}<br/>
{$prop.CITY}<br/>
{$prop.STATE} {$prop.ZIPCODE}
</p>
{/foreach}

{if $report_item.STATUS == 'I'}<p class="error">{$corpName} is no longer active.</p>{/if}

{/if}
{/foreach}

{if ($corpStatus=='A')||($is_editor)}

<h3>{$corpName} Directors and Officers</h3>
<p>
The following table lists the directors and officers for {$corpName}.
It shows their name and position within the company.  It also shows possible
addresses and related companies for the officer based on their name.  These
are addresses and companies associated with a person of that name.  Their 
inclusion in the table does not indicate anything more than a potential relationship between {$corpName}
and the address or company.  
</p>
<table class="table">
<tr><th>Name</th><th>Position</th><th>Possible Address</th><th>Possible Related Companies</th></tr>
{foreach name=outer from=$data item=report_item key=report_key}
{if ($report_key != 'SUNBIZ-ID')&&($report_key != 'NEARBY')}
<tr><div itemprop="contactPoint" itemscope itemtype="http://schema.org/ContactPoint">
<td><a href="http://search.sunbiz.org/Inquiry/CorporationSearch/SearchResults/OfficerRegisteredAgentName/{$report_item.NAME|escape:'url'}/Page1"
       target=”_blank”><span itemprop="name">{$report_item.NAME}</span></a>
</td>
<td><span itemprop="contactType">
{if $is_editor}
<a href="/rental/visulate_search.php?CORP_ID={$corpID}&PN_ID={$report_item.PN_ID}&action=DEL_OFFICER" 
   onclick="return confirm('Delete this assignment?')">
  <img border="0" width="14" height="14" src="/rental/images/delete.gif">
</a>
{/if}
{if $report_item.TITLE_CODE == 'P'}President
{elseif $report_item.TITLE_CODE == 'T'}Treasurer
{elseif $report_item.TITLE_CODE == 'C'}Chairman
{elseif $report_item.TITLE_CODE == 'V'}Vice Pres
{elseif $report_item.TITLE_CODE == 'S'}Secretary
{elseif $report_item.TITLE_CODE == 'D'}Director
{elseif $report_item.TITLE_CODE == 'R'}Registered Agent
{else}Officer ({$report_item.TITLE_CODE}){/if}</span>
</td><td>
{foreach name=inner from=$report_item.ADDR item=addr_item}
<a target=”_blank” rel="nofollow" href="http://www.spokeo.com/name-search/search?q={$report_item.FIRST_NAME}+{$report_item.LAST_NAME}+{$addr_item.CITY|escape:'html'}+{$addr_item.STATE}&g=name_A1255495659">
{$report_item.FIRST_NAME|capitalize} {$report_item.LAST_NAME|capitalize}</a><br/>
{if $addr_item.PROP_ID > 0}
<a href="/property/{$addr_item.PROP_ID}"> {$addr_item.ADDRESS1}</a><br/>
{else}
{$addr_item.ADDRESS1}<br/>
{/if}
{$addr_item.CITY}<br/>
{$addr_item.STATE} {$addr_item.ZIPCODE}<br/>
({$addr_item.COUNTY} County)<br/><br/>
{/foreach}
</td><td>
{if ($report_item.CORP)}
The following companies have a director or officer called {$report_item.FIRST_NAME|capitalize} {$report_item.LAST_NAME|capitalize}<br/>
{/if}
{foreach name=inner from=$report_item.CORP item=corp_item}
<a href="/rental/visulate_search.php?CORP_ID={$corp_item.CORP_NUMBER}"> {$corp_item.NAME}</a> -
{if $corp_item.TITLE_CODE == 'P'}President
{elseif $corp_item.TITLE_CODE == 'T'}Treasurer
{elseif $corp_item.TITLE_CODE == 'C'}Chairman
{elseif $corp_item.TITLE_CODE == 'V'}Vice Pres
{elseif $corp_item.TITLE_CODE == 'S'}Secretary
{elseif $corp_item.TITLE_CODE == 'D'}Director
{elseif $corp_item.TITLE_CODE == 'R'}Registered Agent
{else}Officer ({$corp_item.TITLE_CODE}){/if}
<br/>
{/foreach}
</td>
</div></tr>
{/if}
{/foreach}
</table>
{/if}
{if $is_editor}
<h5>Add Officer</h5>
{$errorMsg}
<table class="datatable">
<tr><th>{$form_data.ONAME.label}</th><td>{$form_data.ONAME.html}</td></tr>
<tr><th>{$form_data.OTYPE.label}</th><td>{$form_data.OTYPE.html}</td></tr>
<tr><th>{$form_data.OPOSITION.label}</th><td>{$form_data.OPOSITION.html}</td></tr>
<tr><th>{$form_data.OADDRESS1.label}</th><td>{$form_data.OADDRESS1.html}</td></tr>
<tr><th>{$form_data.OADDRESS2.label}</th><td>{$form_data.OADDRESS2.html}</td></tr>
<tr><th>{$form_data.OCITY.label}</th><td>{$form_data.OCITY.html}</td></tr>
<tr><th>{$form_data.OSTATE.label}</th><td>{$form_data.OSTATE.html}</td></tr>
<tr><th>{$form_data.OZIPCODE.label}</th><td>{$form_data.OZIPCODE.html}</td></tr>
</table>
      {$form_data.action_add.html}
      {$form_data.action_cancel.html}
</form>      
{/if}

{/if}
{if  ($corpStatus!='H')}
{literal}
<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- corp728x90 -->
<ins class="adsbygoogle"
     style="display:inline-block;width:728px;height:90px"
     data-ad-client="ca-pub-9857825912142719"
     data-ad-slot="9099890914"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
{/literal}
{/if}

{if ($report_key == 'NEARBY')}
<h3>Principal Location</h3>
<p>{$corpName} is located at {$addr1} in {$corpCity}.</p>


  {assign var="companies" value=$report_item}
  {assign var="zoom" value="17"}
  {assign var="map_title" value=$report_element.ADDRESS1|escape:'html'}
  {assign var="map_desc" value=$map_title|cat:" location"}
<div id="map"></div>
  {include file="google-map.tpl"}







<h4>Companies Located Nearby</h4>
<ul>
{foreach from=$report_item item=c}
{if ($corpID != $c.CORP_NUMBER)}
<li>{$c.ADDRESS1} - <a href="/rental/visulate_search.php?CORP_ID={$c.CORP_NUMBER}">{$c.CORP_NAME}</a> </li>
{/if}
{/foreach}
</ul>

{if ($mls_listings)&& ($corpStatus!='H')}
{literal}
<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- corp728x90 -->
<ins class="adsbygoogle"
     style="display:inline-block;width:728px;height:90px"
     data-ad-client="ca-pub-9857825912142719"
     data-ad-slot="9099890914"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
{/literal}
{/if}

{/if}

{if !($corpName)}
<h1>Not Found</h1>
<p>
No company was found with this reference number.  It could be the company is no longer active.
Visulate does not maintain records for inactive companies.  Try searching
<a href="http://www.sunbiz.org/search.html" target="_blank">Sunbiz.org</a>
</p>
{/if}



{include file="florida-appraiser.tpl"}
<p>The principal address for {$corpName} is in
<a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county={$corpCounty|upper}">
{$corpCounty} County</a> {$corpState}.</p>

  <fieldset>
  <legend>Disclaimers and Disclosures</legend>
  <p>The information on this page was compiled from public records.   It is deemed reliable but is not guaranteed to be an accurate snapshot of the company at that time.  All information should be independently verified.</p>
<p>The Visulate site was produced from data and information compiled from recorded documents and/or outside public and private sources. Visulate is not the custodian of public records and does not assume responsibility for errors or omissions in the data it displays or for its misuse by any individual.</p>
<p>In the event of either error or omission, Visulate and any 3rd party data provider shall be held harmless from any damages arising from the use of records displayed on the site.
 </p>
  </fieldset>
</div>
{include file="google-analytics.tpl"}
{include file="footer.tpl"}
