<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1  maximum-scale=1.0">
  <link rel="apple-touch-icon" href="http://visulate.com/images/twitter.jpg"/>
  <meta name="apple-mobile-web-app-capable" content="yes" />
  <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent" />
{if ($noindex == "y" || $noindex=="Y")}
  <meta name="robots" content="noindex">
{/if}
<title>{if $pageTitle}{$pageTitle}{else}Visulate - Florida on Your Phone{/if}</title>
{if $pageDesc} <meta name="description" content="{$pageDesc}"/>{/if}
<script  type="text/javascript" src="/rental/html/jquery-1.11.3.min.js"></script>
<script  type="text/javascript" src="/rental/html/jquery.mobile-1.4.5/jquery.mobile-1.4.5.min.js"></script>


{literal}
<style>
#page1.ui-page{
    background: no-repeat center center fixed;
    -webkit-background-size: cover;
    -moz-background-size: cover;
    -o-background-size: cover;
    background-size: cover;
}
/* Navmenu */
.jqm-navmenu-panel .ui-listview > li .ui-collapsible-heading {
        margin: 0;
}
.jqm-navmenu-panel .ui-collapsible.ui-li-static {
        padding: 0;
        border: none !important;
}
.jqm-navmenu-panel .ui-collapsible + li > .ui-btn,
.jqm-navmenu-panel .ui-collapsible + .ui-collapsible > .ui-collapsible-heading > .ui-btn,
.jqm-navmenu-panel .ui-panel-inner > .ui-listview > li.ui-first-child .ui-btn {
        border-top: none !important;
}
.jqm-navmenu-panel .ui-listview .ui-listview .ui-btn {
        padding-left: 1.5em;
        color: #999;
}
.jqm-navmenu-panel .ui-listview .ui-listview .ui-btn.ui-btn-active {
        color: #fff;
}
.jqm-navmenu-panel .ui-btn:after {
        opacity: .4;
        filter: Alpha(Opacity=40);
}

.jqm-navmenu-panel ul li:first-child a{
        border-top: none;
}
</style>


<script>
  $(document).bind("mobileinit", function(){
    $.mobile.pushStateEnabled = false;
    $.mobile.ignoreContentEnabled = true;

/* convert ul into listview */
$("[data-role=panel] ul").listview();

/* external panel is used in the demo
   therefore, it should be enhanced manually
   in addition to all contents inside it */
$("[data-role=panel]").enhanceWithin().panel();

});
</script>

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
  
<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
{/literal}

{if !($backgroundImg)}
{literal}
<script>
  (adsbygoogle = window.adsbygoogle || []).push({
    google_ad_client: "ca-pub-9857825912142719",
    enable_page_level_ads: true
  });
</script>
{/literal}
{/if}

<link rel="stylesheet" href="/rental/html/jquery.mobile-1.4.5/jquery.mobile-1.4.5.min.css" />
<link rel="stylesheet" href="/rental/css/mobile2015.css" />
<link rel="stylesheet" href="/rental/css/vis2015tables.css" />

<link rel="stylesheet" href="/rental/css/mobile-photos.css" />
</head>
<body>
<div id="page1" data-role="page" data-ajax="false" class="jqm-demo jqm-home" data-title="{if $pageTitle}{$pageTitle}{else}Visulate - Florida on Your Phone{/if}">
<div data-role="header" class="jqm-header">
<a href="#menu" data-rel="panel" class="ui-btn-left ui-btn ui-btn-icon-left ui-icon-bars ui-btn-icon-notext ui-corner-all ui-alt-icon ui-nodisc-icon"></a>
<h1 id="tophead">Visulate</h1>
<a href="#search" data-rel="panel" class="jqm-search-link ui-btn ui-btn-icon-notext ui-corner-all ui-icon-search ui-nodisc-icon ui-alt-icon ui-btn-right">Search</a>
</div><!-- /header -->
<div id="top" />




