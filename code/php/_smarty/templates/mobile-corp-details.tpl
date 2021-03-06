{include file="mobile-top.tpl"}
 <div id="content">
 {$report_text}  
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

<h2 id="page_header">{$report_item.NAME}</h2>

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
on {$report_item.FILING_DATE|date_format}.</span></p>

{if ($streetview)}

<img id="mainPicture" src="{$streetview}" style="border: 1px solid #949494; width:100%"
  alt="Google Street View for {$report_item.NAME}'s Principal Location"/>
<p>Principal Address: {$report_item.ADDR.ADDRESS1}, {$report_item.ADDR.CITY}</p>

{/if}

<p>
{if ($report_item.NAME ne 'Visulate LLC')}
<strong>Visulate.com is an independent website and is not affiliated with, nor has it been authorized, sponsored, or
otherwise approved by {$report_item.NAME}</strong>
{/if}
</p>

<h3>Florida Sunbiz Corporation Details</h3>
<table class="datatable  ui-responsive table-stroke">
<tr><th>Corporation Number</th><td>
<form action="http://search.sunbiz.org/Inquiry/CorporationSearch/ByDocumentNumber" method="post" target="_blank">
<input class="SearchTermInputField" id="SearchTerm" name="SearchTerm" type="hidden" value="{$report_item.CORP_NUMBER}" />
<input type="submit" name="Search" value="{$report_item.CORP_NUMBER}" />
</form></td></tr>
<tr><th>Status</th><td>{if $report_item.STATUS == 'I'}Inactive{else}Active{/if}</td></tr>  
<tr><th>Filing Type</th><td>{$report_item.FILING_TYPE}</td></tr>  
<tr><th>Filing Date</th><td>{$report_item.FILING_DATE|date_format}</td></tr>  
<tr><th>FEI Number</th><td>{$report_item.FEI_NUMBER}</td></tr>  
<tr><th>Principal Address</th><td>

{if $report_item.ADDR.PROP_ID > 0}
<a href="/property/{$report_item.ADDR.PROP_ID}"> {$report_item.ADDR.ADDRESS1}</a>
{else}
{$report_item.ADDR.ADDRESS1}
{/if}

{$report_item.ADDR.ADDRESS2}<br/>
{$report_item.ADDR.CITY}<br/>
{$report_item.ADDR.STATE} {$report_item.ADDR.ZIPCODE}<br/>
</td></tr>
</table>

{if  ($corpStatus!='H')}
{include file="adsense-mobile320x100.tpl"}
{/if}

{assign var="lat" value=$report_item.ADDR.LAT} 
{assign var="lon" value=$report_item.ADDR.LON} 
{assign var="geo_found" value=$report_item.ADDR.GEO_FOUND} 

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
{if  ($corpStatus!='H')}
{include file="adsense-mobile320x100.tpl"}
{/if}
<table class="datatable">
<tr><th>Name/Position</th><th>Possible Address</th><th>Possible Related Companies</th></tr>
{foreach name=outer from=$data item=report_item key=report_key}
{if ($report_key != 'SUNBIZ-ID')&&($report_key != 'NEARBY')}
<tr>
<td>{$report_item.NAME} - 

{if $report_item.TITLE_CODE == 'P'}President
{elseif $report_item.TITLE_CODE == 'T'}Treasurer
{elseif $report_item.TITLE_CODE == 'C'}Chairman
{elseif $report_item.TITLE_CODE == 'V'}Vice Pres
{elseif $report_item.TITLE_CODE == 'S'}Secretary
{elseif $report_item.TITLE_CODE == 'D'}Director
{elseif $report_item.TITLE_CODE == 'R'}Registered Agent
{else}Officer ({$report_item.TITLE_CODE}){/if}
</td><td>
{foreach name=inner from=$report_item.ADDR item=addr_item}
<a target=”_blank” href="http://www.spokeo.com/name-search/search?q={$report_item.FIRST_NAME}+{$report_item.LAST_NAME}+{$addr_item.CITY|escape:'html'}+{$addr_item.STATE}&g=name_A1255495659" rel="nofollow">
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
</tr>
{/if}
{/foreach}
</table>
{/if}


{/if}
{if ($report_key == 'NEARBY')}
<h3>Principal Location</h3>
<p>{$corpName} is located at {$addr1} in {$corpCity}.</p>

  {assign var="companies" value=$report_item}
  {assign var="zoom" value="16"}
  {assign var="map_title" value=$report_element.ADDRESS1|escape:'html'}
  {assign var="map_desc" value=$map_title|cat:" location"}
<div id="map" style="width: 100%; height: 280px;"></div>
  {include file="google-map.tpl"}


{if  ($corpStatus!='H')}
{include file="adsense-mobile320x100.tpl"}
{/if}
<h4>Companies Located Nearby</h4>
<ul data-role="listview" data-inset="true">
{foreach from=$report_item item=c}
<li><a href="/rental/visulate_search.php?CORP_ID={$c.CORP_NUMBER}">{$c.CORP_NAME}</a> </li>
{/foreach}
</ul>
{/if}


<fieldset>
        <legend>Disclaimers and Disclosures</legend>
        <p>The information on this page was compiled from public records.   It is deemed reliable but is not guaranteed to be an accurate snapshot of the company at that time.  All information should be independently verified.</p>
<p>The Visulate site was produced from data and information compiled from recorded documents and/or outside public and private sources. Visulate is not the custodian of public records and does not assume responsibility for errors or omissions in the data it displays or for its misuse by any individual.</p>
<p>In the event of either error or omission, Visulate and any 3rd party data provider shall be held harmless from any damages arising from the use of records displayed on the site.
 </p>
        </fieldset>
</div>
{include file="mobile-footer-pub.tpl"}