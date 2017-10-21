{assign var="report_element" value=$data.PROPERTY}
{assign var="address1" value=$data.PROPERTY.ADDRESS1}

<div class="container col-sm-12">

{if ($report_element.GEO_FOUND_YN == 'Y')}
  {assign var="lat" value=$report_element.LAT}
  {assign var="lon" value=$report_element.LON}
  {assign var="zoom" value="16"}
  {assign var="map_title" value=$report_element.ADDRESS1|escape:'html'}
  {assign var="map_desc" value=$map_title|cat:" location"}
<div id="map"  class="col-md-6" style="height: 380px;" ></div>
  {include file="google-map.tpl"}
{/if}



{if (!($mls) && ($photos))}
<div class="col-md-6">
<img id="mainPicture" src="{$main_picture}"  class="vga_img" alt="{$smarty.capture.streetAddress}"/>
{elseif (!($mls) && ($streetview))}
<img id="mainPicture" src="{$streetview}" style="border: 1px solid #949494;" alt="Google Street View  of {$smarty.capture.streetAddress}"/>
</div>
{/if}
</div>


<div class="container col-sm-6">

<h3>Links</h3>
<ul  class="list-group">

{if ($report_element.PROPERTY_URL)}
<li class="list-group-item"><a href="{$report_element.PROPERTY_URL}" target="_new">{$report_element.SOURCE} entry for {$address1}</a></li>
{/if}
{if ($report_element.TAX_URL)}
<li class="list-group-item"><a href="{$report_element.TAX_URL}" target="_new">{$report_element.SOURCE|replace:'Property Appraiser':' '} Tax Record for {$address1}</a></li>
{/if}
{if ($report_element.PHOTO_URL)}
<li class="list-group-item">{$report_element.PHOTO_URL}</li>
{/if}

<li class="list-group-item"><a href="mailto:?subject={$data.PROPERTY.ADDRESS1}&body=http%3A%2F%2Fvisulate.com/property/{$data.PROP_ID}">Email a Link to This Page</a></li>
</ul>

</div>

{if !($mls)}
{literal}
<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- prop728x90 -->
<ins class="adsbygoogle"
     style="display:inline-block;width:728px;height:90px"
     data-ad-client="ca-pub-9857825912142719"
     data-ad-slot="1803623317"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
{/literal}

{/if}





<div class="container col-sm-2">
  <div class="panel panel-default ">
    <div class="panel-heading">Summary</div>
    <div class="panel-body">
    {$report_element.ADDRESS1} is a {$report_element.SQ_FT|number_format:0:".":","} sq ft {$useType} in {$report_element.CITY}.
 {if  ($report_element.YEAR_BUILT)}It was built in {$report_element.YEAR_BUILT}.  {/if}
{if ($report_element.ACREAGE)}{$address1} sits on {show_number number=$report_element.ACREAGE} acres of land.  {/if}
 </div>
  </div>
</div>



{if (!($mls))}
<div class="container col-sm-2">
  <div class="panel panel-default ">
    <div class="panel-heading">Not Offered for Sale</div>
    <div class="panel-body">
<p>This property is not currently for sale by Visulate{if ($hidden != 'Y')} but we may be
able to find something similar.{/if}.</p>
 </div>
  </div>
</div>
{/if}

  
{if $listing}    
  {foreach from=$listing item=listing_element key=listing_key}
  

  {if ($listing_key == 'LISTING')&& ($listing_element|@count gt 0)}
  <h4>Sales Listing</h4>
  <table class="datatable">
   {foreach from=$listing_element item=e key=k}
   <tr><th>Listng Date</th><td>{$e.LISTING_DATE}</td></tr>
   <tr><th>Price</th><td>{show_number number=$e.PRICE}</td></tr>
   <tr><th>Source</th><td>{$e.SOURCE}</td></tr>
   <tr><th>Listing Broker</th><td>{$e.AGENT_NAME}</td></tr>
   <tr><th>Broker Phone</th><td>{$e.AGENT_PHONE}</td></tr>
   <tr><th>Broker Email</th><td>{mailto address=$e.AGENT_EMAIL encode='javascript' subject=$data.PROPERTY.ADDRESS1}</td></tr>
   <tr><th>Broker Website</th><td><a rel="nofollow" target="new" href="{$e.AGENT_WEBSITE}">{$e.AGENT_WEBSITE}</a> </td></tr>
   <tr><th>Notes</th><td>{$e.DESCRIPTION}</td></tr>
   {/foreach}
  </table>  
{/if}

  {if ($listing_key == 'LINKS')&& ($listing_element|@count gt 0)}  
  <h4>Documents</h4>
  <ol>
   {foreach from=$listing_element item=l key=k}
    <li><a href="{$l.LINK_URL}" target="_blank">{$l.LINK_TITLE}</a></li>
   {/foreach}
  </ol>
  {/if}

  
  {if ($listing_key == 'CASHFLOW')&& ($listing_element|@count gt 0)}
  <h4>Cash Flow Estimates</h4>
  <p>Contact {mailto address='sales@visulate.com' encode='javascript' subject=$data.PROPERTY.ADDRESS1}
     for a detailed breakdown of these estimates.</p>
  <table class="datatable">
     <tr align="center">
       <th width="20%"><strong>Estimate Type</strong></th>
       <th width="10%" style="text-align:center"><strong>Price</strong></th>
       <th width="10%" style="text-align:center"><strong>Monthly Rent</strong></th>
       <th width="10%" style="text-align:center"><strong>Annual Rent</strong></th>
       <th width="10%" style="text-align:center"><strong>Operating Expenses</strong></th>
       <th width="10%" style="text-align:center"><strong>NOI</strong></th>
       <th width="10%" style="text-align:center"><strong>Cap Rate</strong></th>
       <th width="10%" style="text-align:center"><strong>Cash Invested</strong></th>
       <th width="10%" style="text-align:center"><strong>Cash on Cash</strong></th>
    </tr>

   {foreach from=$listing_element item=ee key=k}
               <tr>
                 <td width="20%">{$ee.TITLE}</td>
                 <td style="text-align:right">{show_number number=$ee.PRICE}</td>
                 <td style="text-align:right">{show_number number=$ee.MONTHLY_RENT}</td>
                 <td style="text-align:right">{show_number number=$ee.ANNUAL_RENT}</td>
                 <td style="text-align:right">{show_number number=$ee.EXPENSE_AMOUNT}</td>
                 <td style="text-align:right">{show_number number=$ee.NOI}</td>
                 <td style="text-align:right">{show_number number=$ee.CAP_RATE}</td>
                 <td style="text-align:right">{show_number number=$ee.CASH_INVESTED}</td>
                 <td style="text-align:right">{show_number number=$ee.CASH_ON_CASH}</td>
             </tr>
 
   {/foreach}
   </table>
  {/if}

  {if ($listing_key == 'REPAIRS')&& ($listing_element|@count gt 0)}  
  <h4>Repair Estimates</h4>
    <p>Contact {mailto address='sales@visulate.com' encode='javascript' subject=$data.PROPERTY.ADDRESS1}
     for additional details for these estimates.</p>
  <table class="datatable">
     <tr><th>Asking Price</th><th>Offer Price</th><th>Cost Estimates</th>
         <th>Cost Basis</th><th>Price/Sq Ft</th><th>Price/Acre</th>
         <th>ARV</th><th>Projected Profit/Loss</th></tr>

   {foreach from=$listing_element item=re key=k}
               <tr>
                 
                 <td style="text-align:right">{show_number number=$re.ASKING_PRICE}</td>
                 <td style="text-align:right">{show_number number=$re.OFFER_PRICE}</td>
                 <td style="text-align:right">{show_number number=$re.COST_ESTIMATES}</td>
                 <td style="text-align:right">{show_number number=$re.COST_BASIS}</td>
                 <td style="text-align:right">{show_number number=$re.PRICE_SQFT}</td>
                 <td style="text-align:right">{show_number number=$re.PRICE_ACRE}</td>
                 <td style="text-align:right">{show_number number=$re.ARV}</td>
                 <td style="text-align:right">{show_number number=$re.PROFIT_LOSS}</td>
             </tr>
 
   {/foreach}
   </table>
  {/if}
  
  {/foreach}
{/if}



 

{if !($mls)}
{if ($mls_listings)}
{literal}
<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- prop728x90 -->
<ins class="adsbygoogle"
     style="display:inline-block;width:728px;height:90px"
     data-ad-client="ca-pub-9857825912142719"
     data-ad-slot="1803623317"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
{/literal}
{/if}
{/if}
