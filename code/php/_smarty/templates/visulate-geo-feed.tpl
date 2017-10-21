{include file="rss-ymaps-header.tpl"}
{foreach name=outer item=i from=$listings key=k}
<item>
  <title>{$i.ADDRESS1}</title>
  <link><![CDATA[http://visulate.com/property/{$i.PROP_ID}]]></link>
  <description>{$i.SQ_FT} sq ft, {$i.DESCRIPTION}</description>
  <geo:lat>{$i.LAT}</geo:lat>
  <geo:long>{$i.LON}</geo:long>
</item>
{/foreach}
{include file="rss-footer.tpl"}