<!DOCTYPE html>
<head>
  <title>{$pageTitle}</title>
  <base href="{$PATH_FROM_ROOT}">
  {if ($canonical)}
    {if ($canonical == "/")}
  <link rel="canonical" href="https://visulate.com/" />
  {literal}
<script type="application/ld+json">
{
   "@context": "https://schema.org",
   "@type": "WebSite",
   "url": "https://visulate.com/",
   "potentialAction": {
     "@type": "SearchAction",
     "target": "https://visulate.com/rental/visulate_search.php?REPORT_CODE=SEARCH&q={search_term}",
     "query-input": "required name=search_term"
   }
}
</script>
  {/literal}
    {else}
  <link rel="canonical" href="{$PATH_FROM_ROOT}{$canonical}"/>
    {/if}
  {/if}
{if ($noindex == "y" || $noindex=="Y")}
  <meta name="robots" content="noindex">
{/if}
  <meta http-equiv="Content-Type" content="application/xhtml+xml; charset=UTF-8" />
  <meta name="description" content="{$pageDesc}"/>
  <meta name="google-site-verification" content="QRXTMUW_Ofy0KMp1D2RT7kQBXakem2wEgBEG4yXkhho" />
  <meta name="msvalidate.01" content="FF521F768467CD97CD03947530A54A1E" />

  <link rel="stylesheet" media="screen" type="text/css" href="/rental/css/vis2016layout.css">
  <link rel="stylesheet" media="screen" type="text/css" href="/rental/css/vis2016tables.css">
  <link rel="stylesheet" media="print" type="text/css" href="/rental/css/print2013.css" >
  <link rel="stylesheet" type="text/css" href="/rental/html/jquery.jqplot/dist/jquery.jqplot.css" />
  <link rel="shortcut icon" href="/images/favicon.ico" type="image/x-icon">
  <link rel="icon" href="/images/favicon.ico" type="image/x-icon">

  <link rel="apple-touch-icon" href="https://visulate.com/images/twitter.jpg"/>

<script  type="text/javascript" src="/rental/html/jquery-1.11.3.min.js"></script>

<script type="text/javascript" src="/rental/html/bootstrap-3.3.6-dist/js/bootstrap.min.js"></script>
<link rel="stylesheet" type="text/css" href="/rental/html/bootstrap-3.3.6-dist/css/bootstrap.min.css" >

<script  language="javascript" type="text/javascript"
               src="/rental/html/jquery.jqplot/dist/jquery.jqplot.min.js"></script>
<script async language="javascript" type="text/javascript"
        src="/rental/html/jquery.jqplot/dist/plugins/jqplot.pieRenderer.min.js"></script>
<script async language="javascript" type="text/javascript"
        src="/rental/html/jquery.jqplot/dist/plugins/jqplot.cursor.min.js"></script>
<link rel="stylesheet" href="/rental/html/nivo-slider/nivo-slider.css" type="text/css" />
<script  src="/rental/html/nivo-slider/jquery.nivo.slider.pack.js" type="text/javascript"></script>

<link rel="stylesheet" href="/rental/html/jquery.SimpleSelect/jquery.simpleselect.css" type="text/css" />
<script src="/rental/html/jquery.SimpleSelect/jquery.simpleselect.js" type="text/javascript"></script>

<!--link rel="stylesheet" href="/rental/html/sidebar/sidebar.css" type="text/css" /-->
<link rel="stylesheet" href="/rental/css/mobile-photos.css" />

{literal}

<script>
  var $j = jQuery.noConflict();
</script>
<script type="text/javascript">

  function executeQuery() {
    var input = document.getElementById('searchBox');
    var element = google.search.cse.element.getElement('searchresults-only0');
    if (input.value == '') {
      element.clearAllResults();
    } else {
      element.execute(input.value);
      }
    return false;
  }
</script>

{/literal}



<link rel="stylesheet" type="text/css" href="/rental/css/mls-listings.css">



</head>
<body>

<nav class="navbar navbar-default navbar-fixed-top" id="nav_bar" style="margin-bottom: 0;">
  <div class="container-fluid">
    <!-- Brand and toggle get grouped for better mobile display -->
    <div class="navbar-header">
      <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>
     <a class="navbar-brand" href="#"><img alt="Visulate" src="/images/visulate-tiny.jpg"
                                            style="float: left; margin-top: -15px; margin-left: -10px; margin-right: 8px;"> Visulate</a>
    </div>

    <!-- Collect the nav links, forms, and other content for toggling -->
    <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
      <ul class="nav navbar-nav">
      {foreach from=$menuObj->menu_data1 item=value key=key name=menu1}
          {if $key eq $menuObj->current_level1} <li class="dropdown active">{else}<li>{/if}
              <a href="#"  class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">{$value.title} <span class="caret"></span></a>
              <ul class="dropdown-menu">
                  {foreach from=$value.items item=v key=k name=menu2}
                   <li><a href="/rental/?{$menuObj->request_menu_level2}={$k}" {*value.href*} >{$v.title}</a></li>
                  {/foreach}
              </ul>
           </li>
      {/foreach}
    </ul>
      <!--span class="glyphicon glyphicon-search" aria-hidden="true">Search Florida</span-->

      <ul class="nav navbar-nav navbar-right">
            <li> <a href="/rental/login.php?destroy=On">Login/out</a></li>
      </ul>
    </div><!-- /.navbar-collapse -->
  </div><!-- /.container-fluid -->
</nav>
