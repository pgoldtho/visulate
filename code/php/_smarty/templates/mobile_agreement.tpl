{include file="mobile-top.tpl"}
	<div class="content">

      

{foreach name=outer item=agmt from=$agreement key=k} 

<h1>{$agmt.AD_TITLE}</h1>

      <ul class="left_menu">
      {foreach item=photo from=$pictures key=k}
          <li >
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


<h3>{$agmt.DISPLAY_LOCATION}</h3>
<p>{$agmt.PROPERTY_DESC}</p>
<p>{$agmt.UNIT_DESC}</p>


<table class="datatable">
<tr><th>Unit Size</th><td>{$agmt.UNIT_SIZE} sq ft</td></tr>
<tr><th>Bedrooms</th><td>{$agmt.BEDROOMS}</td></tr>
<tr><th>Bathrooms</th><td>{$agmt.BATHROOMS}</td></tr>
<tr><th>Rent</th><td>${$agmt.AMOUNT} / {$agmt.AMOUNT_PERIOD}</td></tr>
<tr><th>Deposit</th><td>${$agmt.DEPOSIT}</td></tr>	  
</table>


<table class="datatable">
<tr><th>Contact</th><td>{$agmt.AD_CONTACT}</td></tr>
<tr><th>Phone</th><td>{$agmt.AD_PHONE}</td></tr>
<tr><th>E-Mail</th><td>{mailto address=$agmt.AD_EMAIL encode='javascript' subject='Rental Property'}</td></tr>	  
</table>

{/foreach}  

<h3>Other Properties</h3>
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
	

  </div>
	{include file="mobile-footer-pub.tpl"}
