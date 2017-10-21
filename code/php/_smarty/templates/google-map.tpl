{if ($lat && $lon)}
<script type="text/javascript">
var map;
function initMap() {ldelim}
  var currentLoc =  {ldelim} lat: {$lat}, lng:{$lon} {rdelim};

  map = new google.maps.Map(document.getElementById('map'), {ldelim}
    center: currentLoc,
    zoom: {$zoom}
  {rdelim});
  
  var contentString ='<div><p>{$map_desc}</p></div>';
  
  var infowindow = new google.maps.InfoWindow({ldelim}
    content: contentString
  {rdelim});

  var marker = new google.maps.Marker({ldelim}
    position: currentLoc,
    map: map,
    title: '{$map_title}',
    icon: '/images/map_pin.png'
  {rdelim});

  marker.addListener('click', function() {ldelim}
    infowindow.open(map, marker);
  {rdelim});


  {if ($mls_listings)}
     {foreach name=outer item=loc from=$mls_listings key=k}
       {if (isset($loc.LAT) && isset($loc.LON)) }
       var m{$k}=new google.maps.Marker({ldelim}
          position: {ldelim}lat:{$loc.LAT}, lng:{$loc.LON} {rdelim},
          map: map,
          title: "{$loc.ADDRESS1|escape:'html'}, {$loc.PRICE}",
       {rdelim});

       var i{$k}=new google.maps.InfoWindow({ldelim}
        content:  '<div><a href="/rental/visulate_search.php?REPORT_CODE=PROPERTY_DETAILS&PROP_ID={$loc.PROP_ID}"> <img style="width: 220px; border: none;" src="/rental/php/resizeImg.php?w=220&h=165&src={if (isset($loc.PHOTO))}{$loc.PHOTO|escape:'url'}{else}{$loc.PHOTO_URL|escape:'url'}{/if}"> <span style="display: block">{$loc.LINK_TEXT}</span> </a></div>'
      {rdelim});


      m{$k}.addListener('click', function() {ldelim}
       i{$k}.open(map, m{$k});
     {rdelim});
       {/if}
     {/foreach}
  {/if}

  {if ($searchResults)}
     {foreach name=outer item=loc from=$searchResults key=k}
       {if (isset($loc.LAT) && isset($loc.LON)) }
       var sm{$k}=new google.maps.Marker({ldelim}
          position: {ldelim}lat:{$loc.LAT}, lng:{$loc.LON} {rdelim},
          map: map,
          title: "{$loc.ADDRESS1|escape:'html'}, {$loc.PRICE}",
       {rdelim});

       var si{$k}=new google.maps.InfoWindow({ldelim}
        content:  '<div><a href="{$url}&MAX={$max}&ZCODE={$zcode}&PROP_ID={$loc.PROP_ID}"> <img style="width: 220px; border: none;" src="/rental/php/resizeImg.php?w=220&h=165&src={$loc.PHOTO_URL|escape:'url'}"> <span style="display: block">{$loc.ADDRESS1|escape:"html"}, {$loc.PRICE}</span> </a></div>'
      {rdelim});


      sm{$k}.addListener('click', function() {ldelim}
       si{$k}.open(map, sm{$k});
     {rdelim});
       {/if}
     {/foreach}
  {/if}

  {if ($companies)}
     {foreach name=outer item=loc from=$companies key=k}
      {if (isset($loc.LAT) && isset($loc.LON)) }
       var c{$k}=new google.maps.Marker({ldelim}
          position: {ldelim}lat:{$loc.LAT}, lng:{$loc.LON} {rdelim},
          map: map,
          title: "{$loc.NAME|escape:'html'}",
          icon: '/images/map_pin_red.png'
       {rdelim});

       {if (isset($loc.NAME))}
       var ci{$k}=new google.maps.InfoWindow({ldelim}
        content:  '<div><a href="/rental/visulate_search.php?CORP_ID={$loc.CORP_NUMBER}" target="_blank"> <span style="display: block">{$loc.NAME|escape:"html"}</span> </a></div>'
      {rdelim});
      {else}
       var ci{$k}=new google.maps.InfoWindow({ldelim}
        content:  '<div><a href="/rental/visulate_search.php?CORP_ID={$loc.CORP_NUMBER}"> <span style="display: block">{$loc.CORP_NAME|escape:"html"}</span> </a></div>'
        {rdelim});
      {/if}

      
      c{$k}.addListener('click', function() {ldelim}
       ci{$k}.open(map, c{$k});
     {rdelim});
      {/if}
      {/foreach}
  {/if}

  {if ($listings)}
     {foreach name=outer item=loc from=$listings key=k}
      {if (isset($loc.LAT) && isset($loc.LON)) }
       var l{$k}=new google.maps.Marker({ldelim}
          position: {ldelim}lat:{$loc.LAT}, lng:{$loc.LON} {rdelim},
          map: map,
          title: "{$loc.NAME|escape:'html'}",
          icon: '/images/map_pin.png'
       {rdelim});

       var li{$k}=new google.maps.InfoWindow({ldelim}
        content:  '<div><a href="/rental/visulate_search.php?REPORT_CODE=PROPERTY_DETAILS&PROP_ID={$loc.PROP_ID}" target="_blank"> <span style="display: block">{$loc.ADDRESS1|escape:"html"}</span> </a></div>'
      {rdelim});
      
      l{$k}.addListener('click', function() {ldelim}
       li{$k}.open(map, l{$k});
     {rdelim});
      {/if}
      {/foreach}
  {/if}

  {if ($cityDataValues.CITY_LIST)}

   {foreach from=$cityDataValues.CITY_LIST key=k item=loc name=clist}

      {if (isset($loc.LAT) && isset($loc.LON)) }
       var city{$k}=new google.maps.Marker({ldelim}
          position: {ldelim}lat:{$loc.LAT}, lng:{$loc.LON} {rdelim},
          map: map,
          title: "{$loc.DISPLAY_NAME|escape:'html'}",
          icon: '/images/map_pin.png'
       {rdelim});

       var cityi{$k}=new google.maps.InfoWindow({ldelim}
        content:  '<p><a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county={$loc.COUNTY}&city={$loc.NAME}&region_id={$region_id}">{$loc.DISPLAY_NAME}</a></p>'
      {rdelim});

      city{$k}.addListener('click', function() {ldelim}
       cityi{$k}.open(map, city{$k});
     {rdelim});
      {/if}
      {/foreach}

  {/if}
  
{rdelim}
</script>

<script async defer src="https://maps.googleapis.com/maps/api/js?key=AIzaSyB-sbC1QdRC2KWVmLPrMquE9rCM6jfvubQ&callback=initMap"></script>
{/if}
