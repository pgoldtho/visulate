{* $data|@print_r *}

{if ($skey!=0)}
  {include file="homeTop.tpl" noindex="y"}
{else}
  {include file="homeTop.tpl"}
{/if}
{include file="letterbox-img.tpl"}
  <!-- begin main -->
  <div id="main">
    <!-- begin content -->
    <div>
      <!-- begin left part -->


<!-- begin right part -->

{include file="visulate-submenu.tpl"}
{if ($skey==0)}
  {if ($mls)}
    {include file="include/visulate-property-details-mls.tpl"}
  {else}
    {include file="include/visulate-property-details-nomls.tpl"}
  {/if}
{/if}


<div >  {*---right_part div is closed in footer.tpl---*}
<h2 id="page_header">{$data.PROPERTY.ADDRESS1}, {$data.PROPERTY.CITY}</h2>

{if ($data)}
{assign var="propid" value=$data.PROP_ID}
{assign var="hidden" value=$data.PROPERTY.HIDDEN}


{if ($skey==2)}
  {include file="visulate-property-details-cashflow.tpl"}
{elseif ($key==1)}
  {include file="visulate-property-details-location.tpl"}
{else}
  {include file="visulate-property-details-main.tpl"}
{/if}






<div class="col-xs-12">
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
 and Brevard County, Florida. Real estate listings held 
 by brokerage firms other than Visulate are marked with the Broker Reciprocity logo 
 or the Broker Reciprocity thumbnail logo (a little black house) and detailed information 
 about them includes the name of the listing brokers.</p>
 <img src="/images/idx_brevard_large.gif" style="float: right;"/>
 {/if}
</fieldset>
{/if}
</div>
{include file="google-analytics.tpl"}
{literal}
<script type="text/javascript">
  (function() {
    var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
    po.src = 'https://apis.google.com/js/plusone.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
  })();
</script>
{/literal}
{include file="footer.tpl"}
