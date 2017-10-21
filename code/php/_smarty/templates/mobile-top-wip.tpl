<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="apple-touch-icon" href="http://visulate.com/images/twitter.jpg"/>
  <meta name="apple-mobile-web-app-capable" content="yes" />
  <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent" />
  
  <title>Visulate</title>
        <script src="http://code.jquery.com/jquery-1.7.1.min.js"></script>
{literal}
  <script type="text/javascript">
    function GetCurrentLocation() {
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(locateSuccess, locateFail);
        }
        else {
            alert('Geolocation is not supported in your current browser.');
        }
      }
    function locateSuccess(loc) {
      var lat = loc.coords.latitude;
      var lon = loc.coords.longitude;
      $("#gLAT").val(lat);
      $("#gLON").val(lon);
      $('#geoForm').submit();
     }

    function locateFail(geoPositionError) {
        switch (geoPositionError.code) {
                case 0: // UNKNOWN_ERROR
                    alert('An unknown error occurred, sorry');
                    break;
                case 1: // PERMISSION_DENIED
                    alert('Permission to use Geolocation was denied');
                    break;
                case 2: // POSITION_UNAVAILABLE
                    alert('Couldn\'t find you...');
                    break;
                case 3: // TIMEOUT
                    alert('The Geolocation request took too long and timed out');
                    break;
                default:
            }
      }
  </script>

  <script type="text/javascript">

     window._taboola = window._taboola || [];
    _taboola.push({article:'auto'});
    !function (e, f, u) {
        e.async = 1;
        e.src = u;
        f.parentNode.insertBefore(e, f);
    }(document.createElement('script'), document.getElementsByTagName('script')[0], 'http://cdn.taboola.com/libtrc/visulate-visulate/loader.js');

</script>
{/literal}

  <link rel="stylesheet" href="/rental/css/mobile-portrait.css" />
  <link rel="stylesheet" href="/rental/css/vis2008tables.css" />
</head>
<body>
<div id="container" class="">
<div id="header">
  <a id="logo" href="/"><span>Visulate.com</span></a>
  <a id="prefs" href="#"><span>Preferences</span></a>
  <a id="logout" href="#"><span>Logout</span></a>
  <ul id="menu-a">
     <li class="hide"></li>
{foreach from=$menuObj->menu_data1 item=value key=key name=menu1}
{if $smarty.foreach.menu1.first}
<li class="shown"><a id="dropdown-a" href="#"><span>{$value.title}</span></a></li>
{/if}
{if $smarty.foreach.menu1.last}
<li><a class="last"
{else}
<li><a
{/if}
{if $key eq $menuObj->current_level1}
      href="?{$menuObj->request_menu_level1}={$key}" class="current"><span>{$value.title}</span></a></li>
{else}
      href="?{$menuObj->request_menu_level1}={$key}{*value.href*}"><span>{$value.title}</span></a></li>
{/if}
{/foreach}
  <li class="hide"></li>
  </ul>
  
  <ul id="menu-a">
     <li class="hide"></li>
{foreach from=$menuObj->menu_data2 item=value key=key name=menu2}
{if $smarty.foreach.menu2.first}
<li class="shown"><a id="dropdown-a" href="#"><span>{$value.title}</span></a></li>
{/if}
{if $smarty.foreach.menu2.last}
<li><a class="last"
{else}
<li><a
{/if}
{if $key eq $menuObj->current_level2}
      href="?{$menuObj->request_menu_level1}={$key}" class="current"><span>{$value.title}</span></a></li>
{else}
      href="?{$menuObj->request_menu_level1}={$key}{*value.href*}"><span>{$value.title}</span></a></li>
{/if}
{/foreach}
  <li class="hide"></li>
  </ul>
  
<!--  
  <ul id="menu-b">
     <li class="hide"></li>
     <li class="shown"><a id="dropdown-b" href="#"><span>Find<span></a></li>
                        <li><a class="current" href="#"><span>Find</span></a></li>
                        <li><a href="#"><span>Investment</span></a></li>
                        <li><a href="#"><span>Management</span></a></li>
                        <li><a href="#"><span>REO Assets</span></a></li>
                        <li><a class="last" href="#"><span>Software</span></a></li>
                        <li class="hide"></li>
                </ul>
        
    -->   

	
	
</div>
