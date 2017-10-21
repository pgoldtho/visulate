{include file="rss-header.tpl"}
<atom:link href="http://www.visulate.net/feeds/sales_feed.xml" rel="self" type="application/rss+xml" />
{foreach name=outer item=item from=$listings key=k}
<item>
{foreach item=lst from=$item key=k1}
{if $k1 == 'LISTING'}
  <title>{$lst.TITLE}</title>
  <guid>http://www.visulate.net/rental/visulate_search.php?REPORT_CODE=LISTINGS&amp;state={$lst.STATE}&amp;county={$lst.COUNTY}&amp;agreement={$lst.PROP_ID}</guid>
  <description>{$lst.DESCRIPTION|replace:'&':'&amp;'}</description>
  <g:listing_type>for sale</g:listing_type> 
  <g:location>{$lst.LOCATION}, USA</g:location>
  <g:price>{$lst.PRICE}</g:price>
  <link>http://www.visulate.net/rental/visulate_search.php?REPORT_CODE=LISTINGS&amp;state={$lst.STATE}&amp;county={$lst.COUNTY}&amp;agreement={$lst.PROP_ID}</link>
{else}
{foreach item=photo from=$lst key=k2}
  <g:image_link>{$photo.URL}</g:image_link>
 {/foreach}  
{/if}
{/foreach}
</item>
{/foreach}
{include file="rss-footer.tpl"}