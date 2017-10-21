{include file="atom-gmaps-header.tpl"}
{if $listings}
{foreach name=outer item=i from=$listings key=k}
<entry>
  <title>{$i.ADDRESS1}</title>
  <description><![CDATA[
  <a href="http://visulate.com/property/{$i.PROP_ID}">{$i.SQ_FT} sq ft, {$i.DESCRIPTION}</a>
  ]]></description>
  <geo:lat>{$i.LAT}</geo:lat>
  <geo:long>{$i.LON}</geo:long>
  <georss:point>{$i.LAT} {$i.LON}</georss:point>
</entry>
{/foreach}
{else}
<entry>
  <title>No Properties Found</title>
  <description><![CDATA[
  No properties were found within 200m of this location
  ]]></description>
  <geo:lat>{$lat}</geo:lat>
  <geo:long>{$long}</geo:long>
  <georss:point>{$lat} {$long}</georss:point>
</entry>
{/if}
{include file="atom-footer.tpl"}