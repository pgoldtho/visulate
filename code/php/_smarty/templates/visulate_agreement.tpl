{include file="homeTop.tpl"}

  <!-- begin main -->
  <div id="main">
    <!-- begin content -->
    <div id="content">
      <!-- begin left part -->
      <div id="left_part">
      
      <div id="nav">    
   <h3>Items</h3>
       <ul class="left_menu">
       {foreach from=$ReportList item=item name=l3menu}
         {if $smarty.foreach.l3menu.last }
            {assign var="l3class" value="li_left_last"}       
         {elseif $smarty.foreach.l3menu.first }
            {assign var="l3class" value="li_left_first"}
         {else}
            {assign var="l3class" value="li_left_normal"}
         {/if}
       {if ($item.code eq $reportCode)}
             <li class="{$l3class}"><a href="{$item.href}" class="active">{$item.title}</a></li>
       {else}
             <li class="{$l3class}"><a href="{$item.href}">{$item.title}</a></li>
       {/if}
      {/foreach}
       </ul>
       
      <h3><a href="#" class="active">Pictures</a></h3>
      <ul class="left_menu">
      {foreach item=photo from=$pictures key=k}
          <li ><a href="javascript:void(0);" 
               onmouseover="document.getElementById('mainPicture').src='{$photo.VGA_FILENAME}';"
               onclick="window.open('{$photo.PHOTO_FILENAME}', '_blank', 'toolbar=no');">
               <img class="thumbnail_img"
                    alt="{$photo.PHOTO_TITLE}"
                    title="{$photo.PHOTO_TITLE}"
                    src="{$photo.PHOTO_THUMBNAIL}" /></a></li>
        {if $k == 0}
          {assign var='main_picture' value=`$photo.VGA_FILENAME`}
        {/if}
      {/foreach}
        <li class="li_left_last"><a href="#"></a></li>
      </ul>
      <h3><a href="#" class="active">Properties</a></h3>
       <ul class="left_menu">
        {foreach name=outer item=loc from=$locations key=k}       
          {if $smarty.get.agreement == $loc.AGREEMENT_ID}
            <li><a class="active" href="/rental/visulate_search.php?REPORT_CODE=RENTALS&state={$loc.STATE}&county={$loc.COUNTY}&agreement={$loc.AGREEMENT_ID}">
              {$loc.DISPLAY_LOCATION}: {$loc.LOCATION_COUNT}</a></li>
          {else}
            <li><a href="/rental/visulate_search.php?REPORT_CODE=RENTALS&state={$loc.STATE}&county={$loc.COUNTY}&agreement={$loc.AGREEMENT_ID}">
              {$loc.DISPLAY_LOCATION}: {$loc.LOCATION_COUNT}</a></li>
          {/if}
        {/foreach}   
        <li class="li_left_last"><a href="/rental/visulate_search.php?REPORT_CODE=RENTALS">All US Properties</a></li>
      </ul>
     </div> <!-- end nav -->
    </div> <!-- end left part -->
    <!-- begin right part -->
     <div id="right_part">  {*---right_part div is closed in footer.tpl---*} 




{foreach name=outer item=agmt from=$agreement key=k} 

<h1>{$agmt.AD_TITLE}</h1>
<p>Mouse over the thumbnails in the Pictures menu to change the image below.  Click
on an entry in the Properties menu to view a different property.</p>
<img id="mainPicture" src="{$main_picture}"  class="vga_img"/>
<h3>{$agmt.DISPLAY_LOCATION}</h3>
<p>{$agmt.PROPERTY_DESC}</p>
<p>{$agmt.UNIT_DESC}</p>
<br/>
<div class="col-md-4">
<table class="datatable">
<tr><th>Unit Size</th><td>{$agmt.UNIT_SIZE} sq ft</td></tr>
<tr><th>Bedrooms</th><td>{$agmt.BEDROOMS}</td></tr>
<tr><th>Bathrooms</th><td>{$agmt.BATHROOMS}</td></tr>
<tr><th>Rent</th><td>${$agmt.AMOUNT} / {$agmt.AMOUNT_PERIOD}</td></tr>
<tr><th>Deposit</th><td>${$agmt.DEPOSIT}</td></tr>  
</table>
</div>
<div class="col-md-4">
<table class="datatable">
<tr><th>Contact</th><td>{$agmt.AD_CONTACT}</td></tr>
<tr><th>Phone</th><td>{$agmt.AD_PHONE}</td></tr>
<tr><th>E-Mail</th><td>{mailto address=$agmt.AD_EMAIL encode='javascript' subject='Rental Property'}</td></tr>  
</table>
</div>
{/foreach}

{include file="google-analytics.tpl"}
{include file="footer.tpl"}