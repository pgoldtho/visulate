{config_load file="default.conf"}
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
       "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
  <title>{#pageTitle#}</title>
  <base href="{$PATH_FROM_ROOT}">  
  <meta http-equiv="content-type" content="text/html; charset=iso-8859-1" >
  <!--link rel="stylesheet" media="screen" type="text/css" href="/rental/css/vis2013layout.css" -->
  <link rel="stylesheet" media="screen" type="text/css" href="/rental/css/vis2015tables.css" >
  <link rel="stylesheet" media="screen" type="text/css" href="/rental/css/vis2016layout.css" >
  <link rel="stylesheet" media="print" type="text/css" href="/rental/css/print2013.css" >
  <script  type="text/javascript" src="/rental/html/jquery-1.11.3.min.js"></script>
  <script type="text/javascript" src="/rental/html/bootstrap-3.3.6-dist/js/bootstrap.min.js"></script>
<link rel="stylesheet" type="text/css" href="/rental/html/bootstrap-3.3.6-dist/css/bootstrap.min.css" >
<!--link rel="stylesheet" type="text/css" href="/rental/html/sidebar/sidebar.css" /-->

  <script> var $j = jQuery.noConflict();</script>
  <!--
  <script type="text/javascript" src="/rental/html/zoom.js"></script>
  -->
</head>
<body >
<div id="container" style="background: url(https://s3.amazonaws.com/visulate.cities/704x440/palm_bay-5.jpg); background-size: cover; background-repeat: no-repeat;">

<nav class="navbar navbar-default">
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
                                            style="float: left; margin-top: -14px; margin-left: -10px; margin-right: 8px;"> Visulate</a>
    </div>

    <!-- Collect the nav links, forms, and other content for toggling -->
    <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">


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
