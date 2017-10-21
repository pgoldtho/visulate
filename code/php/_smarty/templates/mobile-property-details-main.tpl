{$report_text}
{if ($mls)}
{foreach  from=$mls item=m key=mk}
<div >
 {if ($m.IMG)}

<div class="photos">
   <ul class="current-photo">
   {foreach from=$m.IMG item=img2 key=k name=imgLoop}
     <li><img class="listImg" src="/rental/php/resizeImg.php?w=800&h=600&src={$img2.PHOTO|escape:'url'}"></li>
   {/foreach}
  </ul>
  <div class="ind-wrap">
    <img class="photo-button" id="photo-left" src="/rental/html/jquery.mobile-1.4.5/images/icons-svg/carat-l-black.svg"/>
    <span class="indicator"></span>
    <img class="photo-button" id="photo-right" src="/rental/html/jquery.mobile-1.4.5/images/icons-svg/carat-r-black.svg"/>
  </div>
</div>


{literal}
  <script type="text/javascript">
     $(document).ready(function(){
      $('.current-photo li:not(:first)').addClass('hidden');
      $('.current-photo li').first().addClass('showing');
      $('.indicator').html('1/'+$('.current-photo li').length);
     
      function nextPhoto(){
        var current = $('.showing');
        var next = current.next();
        var thumbindex = current.index() + 1;
        $('.indicator').html(thumbindex+1+'/'+$('.current-photo li').length);
        if(current.is($('.current-photo li').last())) {
          next = $('.current-photo li').first();
          $('.indicator').html('1/'+$('.current-photo li').length);
        } 
        next.addClass('showing').removeClass('hidden');
        current.addClass('hidden').removeClass('showing');
      }

      function prevPhoto(){
        var current = $('.showing');
        var next = current.prev();
        var thumbindex = current.index() + 1;
        $('.indicator').html(thumbindex-1+'/'+$('.current-photo li').length);
        if(current.is($('.current-photo li').first())) {
          next = $('.current-photo li').last();
          $('.indicator').html($('.current-photo li').length + '/' + $('.current-photo li').length);
        }
        next.addClass('showing').removeClass('hidden');
        current.addClass('hidden').removeClass('showing');
      }

      $('.current-photo').on('swipeleft', nextPhoto);
      $('.current-photo').on('swiperight', prevPhoto);
      $('#photo-right').click(nextPhoto);
      $('#photo-left').click(prevPhoto);
      
    });
  </script>
{/literal}


  <h2>For {$m.TYPE} - {$m.LINK_TEXT}</h2>

<img src="/images/idx_brevard_small.gif"/>
  <h4>For {$m.TYPE} - {$m.LINK_TEXT}</h4>

  {/if}


  <h3>{$m.TITLE}</h3>
  <p>{$m.DESCRIPTION}</p>
{assign var="mlsID" value=$m.MLS_NUMBER}
{include file="mobile-welcome.tpl"}


<p>Listing provided by {$m.BROKER}.  Copyright {'Y'|date}
{if ($m.SOURCE_ID == 6)}
Multiple Listing Service of South Brevard, Inc. and Space Coast Association of REALTORS, Inc.
{elseif ($m.SOURCE_ID == 8)}
Multiple Listing Service of South East Florida and Miami Association of Realtors.
{else}
My Florida Regional MLS.
{/if}
All rights reserved.
   </p>
<hr/>
</div>
{/foreach}
{else}
<h3>Not Offered for Sale</h3>
<p>This property is not currently offered for sale by Visulate{if ($hidden != 'Y')} but we may be
able to find something similar. Contact us for details{/if}.</p>

{include file="adsense-mobile320x100.tpl"}

<hr/>
{/if}


{if ($data)}
{foreach name=outer from=$data item=report_element key=report_key}

  {if ($report_key == 'PROPERTY_USAGE')}
    {foreach from=$report_element key=k item=item}
      <h3>Usage</h3>
      <p>{$item}</p>
    {/foreach}
  {elseif ($report_key == 'PROPERTY')}
{if ($photos)&& !($mls)}
     {foreach item=photo from=$photos key=k}
        {if $k == 1}
          {assign var=main_picture value=`$photo.URL`}
        {/if}
     {/foreach}
<img id="mainPicture" src="{$main_picture}" style="border: 1px solid #949494; width:316px;"/>
{elseif (!($mls) && ($streetview))}
<img id="mainPicture" src="{$streetview}" style="border: 1px solid #949494; width:316px" />
{/if}
<h3>Property Details</h3>
  <h4>Address</h4>
   {assign var="propid" value=$report_element.PROP_ID}
     <p>{$report_element.ADDRESS1}<br/>
                    {if ($report_element.ADDRESS2)}{$report_element.ADDRESS2}<br/>{/if}
                    {$report_element.CITY}<br/>
                    {$report_element.STATE}{$report_element.ZIPCODE}<br/>
                 </p>

        <table class="datatable">
          <tr><th>Property Size (sq ft)</th><td>{show_number number=$report_element.SQ_FT}</td></tr>
          <tr><th>Acreage</th><td>{show_number number=$report_element.ACREAGE}</td></tr>
        </table>

   {if ($report_element.GEO_FOUND_YN == 'Y')}
      {assign var="lat" value=$report_element.LAT}
      {assign var="lon" value=$report_element.LON}
   {/if}

{if !($mls) && ($hidden != 'Y')}
{include file="mobile-welcome.tpl"}
{/if}
{if (($hidden != 'Y') && ($pvalues.MEDIAN_MARKET_VALUE > 0))}
<fieldset>
<legend>Estimated Value</legend>
<h4>Market Value</h4>
<table class="datatable">
<tr><th></th><th>High</th><th>Median</th><th>Low</th></tr>
<tr><th>Value</th><td>{$pvalues.HIGH_MARKET_VALUE|number_format:0:".":","}</td>
<td><b>{$pvalues.MEDIAN_MARKET_VALUE|number_format:0:".":","}</b></td>
<td>{$pvalues.LOW_MARKET_VALUE|number_format:0:".":","}</td>
</tr>
</table>



<h4>Income Value - {$lease_type} Lease</h4>

{if $lease_type eq 'Triple Net'}
<p>
Net lease values for maintenance, property tax,
utilities and insurance are calculated as a percentage of the full amount based on the vacancy percentage.
</p>
{/if}
<table class="datatable">
<tr><th><a href="mailto:?subject=Real Estate Investment Spreadsheet for {$data.PROPERTY.ADDRESS1}&body=http%3A%2F%2Fvisulate.com/rental/pages/get_spreadsheet.php?PROP_ID={$data.PROP_ID}">Email a Spreadsheet for this Property</a><img height="16" width="16" src="/rental/images/excel-icon-16.gif" style="border: none;"></th><th>Amount</th></tr>
<tr><th>Monthly Rent</th><td>{$pvalues.MONTHLY_RENT|number_format:2:".":","}</td></tr>
<tr><th>Annual Rent per Sq Ft</th><td>{$pvalues.RENT|number_format:2:".":","}</td></tr>
<tr><th>Gross Annual Rent</th><td><b>{$pvalues.ANNUAL_RENT|number_format:2:".":","}</b></td></tr>
<tr><th>Vacancies and Bad Debt</th><td>{$pvalues.VACANCY_PERCENT|number_format:2:".":","}%</td></tr>
<tr><th>Vacancies Amount</th><td>{$pvalues.VACANCY_AMOUNT|number_format:2:".":","}</td></tr>
<tr><th>Maintenance</th><td>{$pvalues.MAINTENANCE|number_format:2:".":","}</td></tr>
<tr><th>Utilities</th><td>{$pvalues.UTILITIES|number_format:2:".":","}</td></tr>
<tr><th>Property Taxes</th><td>{$pvalues.TAX|number_format:2:".":","}</td></tr>
<tr><th>Insurance</th><td>{$pvalues.INSURANCE|number_format:2:".":","}</td></tr>
<tr><th>Management Fees</th><td>{$pvalues.MGT_AMOUNT|number_format:2:".":","}</td></tr>
<tr><th>NOI</th><td><b>{$pvalues.NOI|number_format:2:".":","}</b></td></tr>
<tr><th>Cap Rate</th><td>{$pvalues.CAP_RATE}</td></tr>
<tr><th>Estimated Value</th><td><b>{$pvalues.VALUE|number_format:2:".":","}</b></td></tr>
<tr><th>Edit Values and Estimate Cashflow</th>
<td><a href="/rental/visulate_search.php?REPORT_CODE=PROPERTY_DETAILS&PROP_ID={$data.PROP_ID}&MODE=cashflow&CLASS={$p_class}"><b>Estimate Cashflow</b></a></td></tr>
<tr><th>Save to Google Drive (Google login required)</th><td>
<script src="https://apis.google.com/js/plusone.js"></script>
<div class="g-savetodrive"
     data-src="/rental/pages/get_spreadsheet.php?PROP_ID={$data.PROP_ID}"
     data-filename="{$data.PROPERTY.ADDRESS1|replace:' ':'_'}.xls"
     data-sitename="Visulate"></div></td></tr>
</table>
</fieldset>
{/if}


{include file="adsense-mobile320x100.tpl"}



{if ($lat && $lon)}

<a class="ui-btn ui-btn-icon-left ui-icon-location" href="/rental/visulate_search.php?REPORT_CODE=SEARCH&lat={$lat}&lon={$lon}">Neighborhood Information</a>

  {assign var="lat" value=$report_element.LAT}
  {assign var="lon" value=$report_element.LON}
  {assign var="zoom" value="15"}
  {assign var="map_title" value=$report_element.ADDRESS1|escape:'html'}
  {assign var="map_desc" value=$map_title}
<div id="map" style="width: 100%; height: 280px;"></div>
  {include file="google-map.tpl"}
{/if}

{if ($mls_listings)}
<h4>Nearby Listings:</h4>
<ul data-role="listview" data-inset="true" id="mlsListings">

   {foreach name=rs item=r from=$mls_listings key=k}
   <li><a data-ajax="false" href="/rental/visulate_search.php?REPORT_CODE=PROPERTY_DETAILS&PROP_ID={$r.PROP_ID}" >
    <img src="/rental/php/resizeImg.php?w=80&h=80&src={$r.PHOTO|escape:'url'}" class="ui-li-thumb"/>
    <h2>{$r.PRICE}</h2>

    <p>{$r.ADDRESS1}
   </p></a>
   </li>
   {/foreach}
</ul>
<img src="/images/idx_brevard_small.gif" />
<h2> Broker Reciprocity</h2>
<p>The data relating to real estate for sale on this web site comes from the Broker Reciprocity Programs of South East, Mid and Brevard County, Florida. Detailed information for each listing including the name of the listing broker is available by clicking on the property.</p>
{else}
{include file="adsense-mobile320x100.tpl"}
{/if}


{if $report_element.PROPERTY_URL != ''}

<h4>{$report_element.SOURCE|replace:'Property Appraiser':' '} County, Florida</h4>
{$report_element.COUNTY_DESC}
<ul data-role="listview" data-inset="true">
{if ($report_element.PROPERTY_URL)}
<li><a href="{$report_element.PROPERTY_URL}" target="_new">{$report_element.SOURCE}</a></li>
{/if}
{if ($report_element.TAX_URL)}
<li><a href="{$report_element.TAX_URL}" target="_new">{$report_element.SOURCE|replace:'Property Appraiser':' '} Tax Record</a></li>
{/if}
{if ($report_element.PHOTO_URL)}
<li>{$report_element.PHOTO_URL}</li>
{/if}

<li><a href="mailto:?subject={$data.PROPERTY.ADDRESS1}&body=http%3A%2F%2Fvisulate.com/property/{$data.PROP_ID}">Email a Link to This Page</a></li>
</ul>        


  {/if}
{if ($comps)}
      <h4>Neighboring Properties</h4>
       <ul data-role="listview" data-inset="true">
        {foreach name=outer item=loc from=$comps key=k}
          <li><a href="/rental/visulate_search.php?REPORT_CODE=PROPERTY_DETAILS&PROP_ID={$loc.PROP_ID}">
                                            {$loc.ADDRESS1}</a></li>
        {/foreach}

      </ul>

{/if}


{elseif ($report_key == 'BUILDINGS')&& ($report_element|@count gt 0)}

  <h4>Buildings</h4>
  <table class="datatable">
  <tr><th>Building</th><th>Usage</th><th>Features</th><tr>
    {foreach from=$report_element key=b item=b_item name=building}
    <tr><td>{$b_item.BUILDING_NAME},<br/>
            {show_number number=$b_item.SQ_FT} sq ft,<br/>
                        Built: {$b_item.YEAR_BUILT}
        </td>
        <td>
        {foreach from=$b_item.USAGE key=bu item=bu_item name=bbu}
          {$bu_item}
        {/foreach}
                                </td>
        <td>
        {foreach from=$b_item.FEATURES key=bf item=bf_item name=bbf}
          {$bf_item},
        {/foreach}

                                </td></tr>
    {/foreach}
  </table>

        {elseif ($report_key == 'OWNER')&& ($report_element|@count gt 0)}
        <h4>Current Owner</h4>

    <p><a href="visulate_search.php?REPORT_CODE=OWNER_DETAILS&OWNER_ID={$report_element.OWNER_ID}">
      {if ($publicUser)}
      Owner: {$report_element.OWNER_ID}
      {else}
      {$report_element.OWNER}
      {/if}</a><br/>
       <a href="visulate_search.php?REPORT_CODE=PROPERTY_DETAILS&PROP_ID={$report_element.MAILING_ID}">
       {$report_element.ADDRESS1}</a><br>
       {if ($report_element.ADDRESS2)}{$report_element.ADDRESS2}<br/>{/if}
       {$report_element.CITY}<br/>
       {$report_element.STATE}{$report_element.ZIPCODE}<br/>
    </p>
  {elseif ($report_key == 'SALES_HISTORY')&& ($report_element|@count gt 0)}
  <h4>Sales History</h4>
  <table class="datatable">
  <tr><th>Transaction</th><th>Sold By Sold To</th><th>Price</th></tr>
  {foreach from=$report_element key=t item=t_item name=trasactions}
  <tr><td>{$t_item.SALE_DATE}<br/>
                {$t_item.DEED_DESC}</td>

      <td>{if $t_item.OLD_OWNER != 'Not Recorded'}
                            By: <a href="visulate_search.php?REPORT_CODE=OWNER_DETAILS&OWNER_ID={$t_item.OLD_OWNER_ID}">
          {if ($publicUser)}
          Seller: {$t_item.OLD_OWNER_ID}
          {else}
          {$t_item.OLD_OWNER}
                                        {/if}</a> <br/>{/if}
                                        {if $t_item.NEW_OWNER != 'Not Recorded'}
          To:<br/> <a href="visulate_search.php?REPORT_CODE=OWNER_DETAILS&OWNER_ID={$t_item.NEW_OWNER_ID}">
          {if ($publicUser)}
          Buyer: {$t_item.NEW_OWNER_ID}
          {else}
          {$t_item.NEW_OWNER}
                                        {/if}</a>{/if}</td>

      <td>{show_number number=$t_item.PRICE}</td></tr>
  {/foreach}
  </table>

  {/if}
{/foreach}
{/if}



{include file="adsense-mobile320x100.tpl"}
<a data-ajax="false" class="ui-btn ui-icon-arrow-u ui-btn-icon-left ui-corner-all" href="#top">Return to Top</a>


<fieldset>
        <legend>Disclaimers and Disclosures</legend>
        <h4>Public Records Data</h4>
        <p>The information on this page was compiled from public records.
       It is deemed reliable but not guaranteed to be an accurate snapshot of the
           property details at the time the snapshot was taken.  All information should be independently verified.</p>
<p>The Visulate site was produced from data and information compiled from recorded documents and/or outside public and private sources. Visulate is not the custodian of public records and does not assume responsibility for errors or omissions in the data it displays or for its misuse by any individual.</p>
<p>In the event of either error or omission, Visulate and any 3rd party data provider shall be held harmless from any damages arising from the use of records displayed on the site.
 </p>
 {if ($mls)}
 <h4>MLS Data</h4>
  <p>Visulate participates in My Flordia Regional, South East Florida MLS and the Brevard County Broker Reciprocity programs,
    allowing us to display other broker's listings on our site. Listing data supplied by
        other brokers is deemed reliable but not guaranteed.  It is provided exclusively for
        personal, non-commercial use and may not be used for any purpose other than to identify
        prospective properties to buy, lease or rent.</p>
 <p>
 The data relating to real estate for sale on this web site comes in part from the
 Broker Reciprocity Programs of My Flordia Regional, South East Florida MLS
 and Brevard County, Florida.  Real estate listings held
 by brokerage firms other than Visulate are marked with the Broker Reciprocity logo
 or the Broker Reciprocity thumbnail logo (a little black house) and detailed information
 about them includes the name of the listing brokers.</p>
 <img src="/images/idx_brevard_large.gif" style="float: right;"/>
 {/if}
</fieldset>
