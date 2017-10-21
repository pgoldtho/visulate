{include file="rss-header.tpl"}
{foreach name=outer item=item from=$listings key=k}
<item>
{foreach item=lst from=$item key=k1}
  {if $k1 == 'AGREEMENT'}
  <title>{$lst.AD_TITLE}</title>
  <g:id>{$lst.AGREEMENT_ID}</g:id>
  <g:agent>{$lst.AD_CONTACT}</g:agent>
  <g:area>{$lst.UNIT_SIZE} square ft.</g:area>
  <g:bedrooms>{$lst.BEDROOMS}</g:bedrooms>
  <g:bathrooms>{$lst.BATHROOMS}</g:bathrooms>
  <description>{$lst.UNIT_DESC} {$lst.PROPERTY_DESC}</description>
  <g:listing_type>for rent</g:listing_type> 
  <g:location>{$lst.LOCATION}, USA</g:location>
  <g:price>{$lst.AMOUNT}</g:price>
  <link>http://www.visulate.net/rental/visulate_search.php?REPORT_CODE=RENTALS&amp;state={$lst.STATE}&amp;county={$lst.COUNTY}&amp;agreement={$lst.AGREEMENT_ID}</link>
{else}
{foreach item=photo from=$lst key=k2}
  <g:image_link>http://www.visulate.net{$photo.PHOTO_FILENAME|replace:' ':'%20'|replace:'&':'&amp;'}</g:image_link>
 {/foreach}  
{/if}
{/foreach}
</item>
{/foreach}
{include file="rss-footer.tpl"}