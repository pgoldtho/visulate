{include file="mobile-top.tpl"}
<div id="MLS-Listings">
<ul data-role="listview" data-inset="true" id="mlsListings">
<li>Loading Data.  Please wait..</li>
</ul>
</div>
<script type="text/javascript">
 {if ($zcode)}
  jQuery("#MLS-Listings").load("/rental/visulate_search.php?REPORT_CODE=AJAX&qtype={$qtype}&state=FL&county={$current_county}&ZCODE={$zcode}&MAX={$max}");
 {elseif $current_county=="ANY"}
 jQuery("#MLS-Listings").load("/rental/visulate_search.php?REPORT_CODE=AJAX&qtype=HOMEPAGE&state=FL");
 {else}
  jQuery("#MLS-Listings").load("/rental/visulate_search.php?REPORT_CODE=AJAX&qtype=LATEST&state=FL&county={$current_county}");
 {/if}
</script>

{include file="mobile-footer-pub.tpl"}
