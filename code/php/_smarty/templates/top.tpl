{config_load file="default.conf"}
<!DOCTYPE html>
<html>
<head>
{if $extra_head}
{$extra_head}
{else}
<title>{#pageTitle#}</title>
{/if}
<base href="{$PATH_FROM_ROOT}">
<meta http-equiv="content-type" content="text/html; charset=iso-8859-1" >
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" media="screen" type="text/css" href="css/vis2016layout.css" >
<link rel="stylesheet" media="screen" type="text/css" href="css/vis2016tables.css" >
<link rel="stylesheet" media="print" type="text/css" href="css/print2013.css" >
<link rel="stylesheet" type="text/css" href="{$PATH_FROM_ROOT}html/calendar/styles/calendar.css">
<link rel="apple-touch-icon" href="http://visulate.com/images/twitter.jpg"/>
<script language="JavaScript" src="{$PATH_FROM_ROOT}html/calendar/javascript/simplecalendar.js" type="text/javascript"></script>
<script language="JavaScript" src="{$PATH_FROM_ROOT}js/mootools.js" type="text/javascript"></script>
<script language="JavaScript" src="{$PATH_FROM_ROOT}html/util.js" type="text/javascript"></script>
<link rel="stylesheet" href="{$PATH_FROM_ROOT}html/jqTreeview/jquery.treeview.css">

<link rel="stylesheet" type="text/css"  href="/rental/html/jquery-ui-1.10.4.custom/css/smoothness/jquery-ui-1.10.4.custom.css" />
<script  type="text/javascript" src="/rental/html/jquery-1.11.3.min.js"></script>

<script type="text/javascript" src="/rental/html/bootstrap-3.3.6-dist/js/bootstrap.min.js"></script>
<link rel="stylesheet" type="text/css" href="/rental/html/bootstrap-3.3.6-dist/css/bootstrap.min.css" >

<script type="text/javascript" src="/rental/html/jquery-ui-1.10.4.custom/js/jquery-ui-1.10.4.custom.js"></script>
<script>
var $j = jQuery.noConflict();
</script>

</head>
<body>

<div id="container" class="container-fluid">
<nav class="navbar navbar-default navbar-fixed-top" id="nav_bar">
  <div >
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

      <ul class="nav navbar-nav navbar-right">
        <li class="dropdown">
          <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Login/Out <span class="caret"></span></a>
          <ul class="dropdown-menu">
            <li> <a href="/rental/login.php?destroy=On">Login/out</a></li>
            <li role="separator" class="divider"></li>
            <li><a href="pref.php">Preferences</a></li>
      {if ($manyRoles == "true")}
        <li><a href="/rental/login2.php">{ldelim}{$role}{rdelim} Change role</a> </li>
      {/if}
          </ul>
        </li>
      </ul>
    </div><!-- /.navbar-collapse -->
  </div><!-- /.container-fluid -->
</nav>


