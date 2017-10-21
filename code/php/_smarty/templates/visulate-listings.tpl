{* $mls|@print_r *}

{if ($skey==1)}
  {include file="homeTop.tpl" noindex="y"}
{else}
  {include file="homeTop.tpl"}
{/if}
  <!-- begin main -->
  <div id="main">
    <!-- begin content -->
    <div id="content">
      <!-- begin left part -->


     
      
<!-- begin right part -->
<div id="prop-top" style="height: 100%;">
{include file="visulate-submenu.tpl"}

       {foreach item=r from=$searchResults key=k}
         {if ($r.PROP_ID == $prop_id)}
           {assign var="nextk" value=$k+1}
           {assign var="prevk" value=$k-1}
           {assign var="nextlisting" value=$searchResults.$nextk.PROP_ID}
           {assign var="previouslisting" value=$searchResults.$prevk.PROP_ID}
         {/if}
       {/foreach}

  <div class="row topnav">
    <a href="{$url}&MAX={$max}&ZCODE={$zcode}&PROP_ID={$previouslisting}" class="col-sm-4"><span class="glyphicon glyphicon-chevron-left"></span>previous listing</a>
    <a href="#" class="col-sm-4"><span class="glyphicon glyphicon-home"></span></a>
    <a href="{$url}&MAX={$max}&ZCODE={$zcode}&PROP_ID={$nextlisting}" class="col-sm-4">next listing<span class="glyphicon glyphicon-chevron-right"></span></a>
  </div>
  {if ($mls.1.IMG)}
      
      <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.touchswipe/1.6.18/jquery.touchSwipe.min.js"></script>

<div class="photo-cont">
   {foreach from=$mls.1.IMG item=img2 key=k name=imgLoop}
     <img class="photo photobg" src="{$img2.PHOTO}"/>
   {/foreach}
   
    <span id="imgindicator"></span>
    {else}
        <p style="color: white; position: absolute; width: 100%; text-align: center; top: 50%;">Sorry, we're still waiting on the photos for this listing.</p>
  {/if}
</div>



{assign var="displayLocation" value=$data.PROPERTY.CITY}


<div class="text-cont">
  <div class="text">
    <span id="hidetext" class="glyphicon glyphicon-chevron-down"></span>
    
    <h1>For {$mls.1.TYPE} - {$data.PROPERTY.ADDRESS1}, {$displayLocation} - {$mls.1.PRICE}</h1>
    <div class="details">
      <h3>{$mls.1.TITLE}</h3>
      {$mls.1.DESCRIPTION}
    </div>
  </div>

  <div class="row bottomnav">
      <a id="previmg" class="col-sm-4 btmnav-pt"><span class="glyphicon glyphicon-chevron-left"></span>previous image</a>
      <a id="moreinfo" class="col-sm-4 btmnav-pt">more info</a>
      <a id="lessinfo" class="col-sm-4 btmnav-pt">less info</a>
      <span id="showtext" class="col-sm-4 glyphicon glyphicon-chevron-up"></span>
      <a id="nextimg" class="col-sm-4 btmnav-pt">next image<span class="glyphicon glyphicon-chevron-right"></span></a>
  </div>
</div>

<div id="popup" style="display: none;">
    <h1>{$data.PROPERTY.ADDRESS1}, {$data.PROPERTY.CITY}<span id="closepopup" class="glyphicon glyphicon-remove"></span></h1>
    <div class="popupcontent">
       <div id="gmap" class="col-sm-12"></div>
       
         <h3 class="listingtitle">{$mls.1.TITLE}</h3>
         <h3 class="listingprice">{$mls.1.PRICE}</h3>
       
         {$mls.1.DESCRIPTION}
         <p>Listing provided by {$mls.1.BROKER}. Copyright 2017 Multiple Listing Service of South Brevard, Inc. and Space Coast Association of REALTORS, Inc. All rights reserved.</p>



{literal}
<style>
  .int-cont {
    text-align: center;
    position: absolute;
    width: 100%;
    bottom: 5px;
    left: 0;
    padding: 0 15px;
  }

  .bottombutton {
    display: inline-block;
    background-color: #98c593;
    color: #fff;
    /*margin: 50px;*/
    padding: 10px;
    border-radius: 5px;
    cursor: pointer; 
  }

  #lead {
    display: none;
  }

  #intback {
    display: none;
    float: left;
  }

  #intmore {
    display: none;
    float: right;
  }

  #intmore a {
    color: #fff; 
  }
</style>
{/literal}

<fieldset style="margin-top: 15px;">
  <legend>Disclaimers and Disclosures</legend>
  <h4>Public Records Data</h4>
  <p>The information on this page was compiled from public records.
       It is deemed reliable but not guaranteed to be an accurate snapshot of the
     property details at the time the snapshot was taken.  All information should be independently verified.</p>
<p>The Visulate site was produced from data and information compiled from recorded documents and/or outside public and private sources. Visulate is not the custodian of public records and does not assume responsibility for errors or omissions in the data it displays or for its misuse by any individual.</p>
<p>In the event of either error or omission, Visulate and any 3rd party data provider shall be held harmless from any damages arising from the use of records displayed on the site.
 </p>
 {if ($mls)}
 <h4>MLS Data</h4>
  <p>Visulate participates in My Flordia Regional, South East Florida MLS and the Brevard County Broker Reciprocity programs,
    allowing us to display other broker's listings on our site. Listing data supplied by
    other brokers is deemed reliable but not guaranteed.  It is provided exclusively for
    personal, non-commercial use and may not be used for any purpose other than to identify
    prospective properties to buy, lease or rent.</p>
 <p>
 The data relating to real estate for sale on this web site comes in part from the
 Broker Reciprocity Programs of My Flordia Regional, South East Florida MLS
 and Brevard County, Florida. Real estate listings held
 by brokerage firms other than Visulate are marked with the Broker Reciprocity logo
 or the Broker Reciprocity thumbnail logo (a little black house) and detailed information
 about them includes the name of the listing brokers.</p>
 <img src="/images/idx_brevard_large.gif" style="float: right;"/>
 {/if}
</fieldset>
          
    {assign var="lat" value=$data.PROPERTY.LAT}
    {assign var="lon" value=$data.PROPERTY.LON}
    
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyB-sbC1QdRC2KWVmLPrMquE9rCM6jfvubQ"></script>
    <script>
      function initializeMap() {ldelim}
        latlng = {ldelim}lat: {$lat}, lng: {$lon}{rdelim};
        var map = new google.maps.Map(document.getElementById('gmap'), {ldelim}
          center: latlng,
          zoom: 15
        {rdelim});
        var marker = new google.maps.Marker({ldelim}
          position: latlng,
          map: map,
          title: '{$data.PROPERTY.ADRESS1}'
      {rdelim});
      {rdelim}
    </script>
    </div>
    <div id="lead">

    <form method="post" action="/rental/contact.php" name="contact" >
       <div class="col-md-1"></div>
       <div class="col-sm-12 col-md-10">
           <h2>Interested in this Property?</h3>
           <img src="/images/sue_sm.png" style="border: 1px solid #949494; 
                float: left; margin-right: 5px; margin-bottom: 12px;" alt="Sue Goldthorp"/>

          <h4 style="margin-top:0; font-size: 28px;">I'm here to help</h4>
          <p>My name is Sue Goldthorp.  I am a real estate broker and co-founder of Visulate.
            Drop me a line if you would like me to help you buy or sell a property in {$displayLocation}.</p>
          <p><input required type="text" name="name" placeholder="Name" aria-label="Name"/>
            <input type="text" name="honeypot" style="display:none" value=""/></p>

          <p><input required type="tel" name="phone" 
                  {literal}pattern="(?:\(\d{3}\)|\d{3})[- ]?\d{3}[- ]?\d{4}" {/literal}
                  title='Format: (321) 453 7389'
                  placeholder="Phone" aria-label="Phone number"/></p>
           <p><input required type="email" name="email" placeholder="Email Address" 
                  {literal} pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,3}$"{/literal}
                  title="Enter a valid email address"
                  aria-label="Email address"/></p>
         </div>
        <div class="col-md-1"></div>

        <div style="clear: both;" class="col-md-1"></div>
        <div class="col-sm-12 col-md-10">
           <p><input required type="text" name="subject" placeholder="Subject" 
                  style="width: 100%;" aria-label="Subject"/></p>
            <p><textarea required name="message" placeholder="Message" rows="6" minlength="20"
                     style="width: 100%;" aria-label="Message"></textarea></p>
           <input type="submit" value="Send Message"
               style="-moz-appearance: none;
               background-color: #98c593;
               border: 0 none;
               border-radius: 3.5em;
               color: #fff;
               cursor: pointer;
               display: inline-block;
               height: 3.5em;
               line-height: 3.5em;
               outline: 0 none;
               padding: 0 2em;
               position: relative;
               text-align: center;
               text-decoration: none;"/>
       </div>

       <input type="hidden" name="url" value="http://{$smarty.server.HTTP_HOST}{$smarty.server.REQUEST_URI}"/>
       <input type="hidden" name="contactType" value="{$displayLocation}"/>
    </form>
    </div>

    <div class="int-cont">
      <h2 id="interested" class="bottombutton">I'm Interested in this Property</h2>
      <h2 id="intback" class="bottombutton"><span class="glyphicon glyphicon-chevron-left"></span>Back</h2>
      <h2 id="intmore" class="bottombutton"><a href="/property/{$prop_id}">I'll do my own research<span class="glyphicon glyphicon-chevron-right"></span></a></h2>
    </div>
</div>

{literal}
    
<script>
  $j(document).ready(function(){
   
    $j('#interested').click(function(){
      $j('.popupcontent').css('display', 'none');
      $j('#interested').css('display', 'none');
      $j('#intback').css('display', 'inline-block');
      $j('#lead').css('display', 'block');
      $j('.int-cont').css('text-align', '-webkit-auto');
      $j('#intmore').css('display', 'inline-block');
    });

    $j('#intback').click(function(){
      $j('.popupcontent').css('display', 'block');
      $j('#interested').css('display', 'inline-block');
      $j('#intback').css('display', 'none');
      $j('#lead').css('display', 'none');
      $j('.int-cont').css('text-align', 'center');
      $j('#intmore').css('display', 'none');
    });
  });

</script>


    
<style>
    html {
        height: 100%;
    }
    body {
        height: 100%;
        background-color: #424242;
    }
    #main {
        height: 100%;
    }
    #content {
        height: 100%;
    }
    #prop-top {
        padding: 0;
    }
    .topnav {
        position: absolute;
        top: 51px;
        width: 100%;
        background-color: rgba(33, 33, 33, 0.3);
        border-bottom: 1px solid #bfbfbf;
        text-align: center;
        font-size: 30px;
        margin: 0;
        padding: 6px 0;
    }
    .topnav a {
        color: white;
    }
    .topnav .glyphicon {
        margin-top: 3px;
    }
    .photo-cont {
        height: 100%;
    }
    .photo {
        z-index: -1;
    }
    .photobg {
        object-fit: cover;
        width: 100%;
        height: 100%;
    }
    .photocol {
        position: fixed;
        top: 0;
        bottom: 0;
        left: 0;
        right: 0;
        max-width: 98%;
        max-height: calc(100% - 215px);
        margin: auto;
        overflow: auto;
    }

    #imgindicator {
        display: none;
        font-size: 45px;
        color: white;
        position: absolute;
        bottom: 50px;
        right: 5px;
    }
 
    .text-cont {
        position: absolute;
        bottom: 0;
        width: 100%;
        color: white;
        background-color: rgba(33, 33, 33, 0.3);
    }
    .details table {
        display: none;
    }
    .details h3 {
        margin-top: 15px;
    }
    .text-cont a {
        color: white;
    }
    #popup {
        position: absolute;
        color: #636363;
        margin: auto;
        background-color: white;
        top: 115px;
        bottom: 65px;
        left: 50px;
        right: 50px;
        /*overflow: scroll;*/
        border: #bfbfbf 1px solid;
        padding: 0 10px 10px 10px;
    }
    .listingtitle {
        display: inline;
    }
    .listingprice {
        display: inline;
        float: right;
        margin: 0;
    }
    .popupcontent {
        position: absolute;
        top: 55px;
        right: 10px;
        bottom: 80px;
        left: 10px;       
        overflow-y: scroll;
        border-bottom: 1px solid #cecece;
    }
    #lead {
        position: absolute;
        top: 55px;
        right: 10px;
        bottom: 80px;
        left: 10px;
        overflow-y: scroll;
        border-bottom: 1px solid #cecece;
    }
    .popupcontent p {
        margin-top: 5px;
    }
    #popup h1 {
        margin-top: 10px;
    }
    #closepopup {
        float: right;
    }
    #gmap {
        height: 45%;
        margin-bottom: 15px;
    }

    .bottomnav {
        width: 100%;
        background-color: rgba(33, 33, 33, 0.3);
        position: fixed;
        bottom: 0;
        margin: 0;
        border-top: #bfbfbf solid 1px;
    }
    .bottomnav a {
        font-size: 30px;
        text-align: center;
        padding: 6px 0;
    }
    .btmnav-pt {
	cursor: pointer;
    }
    .text {
        margin: 10px;
        padding-bottom: 50px;
    }
    #lessinfo {
        display: none;
    }
    #hidetext {
        width: 50px;
        float: right;
        margin-top: -7px;
        font-size: 50px;
    }
    #showtext {
        display: none;
        font-size: 50px;
        text-align: center;
    }
</style>
    
<script type="text/javascript">
  $j(document).ready(function(){
    $j('.photo').first().addClass('showing');
    $j('.photo:not(:first)').addClass('hidden');
    
    nphotos = $j('.photo-cont .photo').length;
    
    function showinfo() {
         $j('#popup').css('display', 'block'); 
         $j('.text').css('display', 'none');
         $j('#moreinfo').css('display', 'none');
         $j('#lessinfo').css('display', 'block');
         initializeMap();
    }
    
    if(nphotos < 2) {
        $j('#nextimg').css('display', 'none');
        $j('#previmg').css('display', 'none');
        $j('#moreinfo').addClass('col-sm-12').removeClass('col-sm-4');
        $j('#lessinfo').addClass('col-sm-12').removeClass('col-sm-4');
    }
    
    if(nphotos < 1) {     
        $j('#hidetext').css('visibility', 'hidden');
        showinfo();
    }
    
    
    $j('#imgindicator').html('1/'+nphotos);
    
    function nextimg() {
	if($j('.text').css('display') === 'block') {
	  $j('.text').css('display', 'none');
          $j('#hidetext').css('display', 'none');
          $j('#showtext').css('display', 'block');
          $j('.photo').removeClass('photobg').addClass('photocol');
          $j('#imgindicator').css('display', 'block');
          $j('#moreinfo').css('display', 'none');
	}	

        current = $j('.showing');
        currentidx = current.index() + 1;
        if (current.is(':nth-last-child(2)')) {
            next = $j('.photo').first();
            $j('#imgindicator').html('1/'+nphotos)
        } else {
            next = current.next();
            $j('#imgindicator').html(currentidx+1+'/'+nphotos);
        }
        current.removeClass('showing').addClass('hidden');
        next.addClass('showing').removeClass('hidden');
    }
    function previmg() {
	if($j('.text').css('display') === 'block') {
          $j('.text').css('display', 'none');
          $j('#hidetext').css('display', 'none');
          $j('#showtext').css('display', 'block');
          $j('.photo').removeClass('photobg').addClass('photocol');
          $j('#imgindicator').css('display', 'block');
          $j('#moreinfo').css('display', 'none');
        } 

        current = $j('.showing');
        currentidx = current.index() + 1;
        if (current.is(':first-child')) {
            next = $j('.photo').last();
            $j('#imgindicator').html(nphotos+'/'+nphotos)
        } else {
            next = current.prev();
            $j('#imgindicator').html(currentidx-1+'/'+nphotos);
        }
        current.removeClass('showing').addClass('hidden');
        next.addClass('showing').removeClass('hidden');
    }
    
    $j('.photo-cont').ready(function(){
        $j('#nextimg').click(nextimg);
        $j('#previmg').click(previmg);
        $j('.photo-cont').swipe({
           swipeLeft:function(){
               nextimg();
           }
        });
        $j('.photo-cont').swipe({
           swipeRight:function(){
               previmg();
           }
        });
        
      $j('#hidetext').click(function(){
        $j('.text').css('display', 'none');
        $j('#hidetext').css('display', 'none');
        $j('#showtext').css('display', 'block');
        $j('.photo').removeClass('photobg').addClass('photocol');
        $j('#imgindicator').css('display', 'block');
        $j('#moreinfo').css('display', 'none');
      });
      $j('#showtext').click(function(){
        $j('.text').css('display', 'block');
        $j('#hidetext').css('display', 'block');
        $j('#showtext').css('display', 'none');
        $j('.photo').removeClass('photocol').addClass('photobg');
        $j('#imgindicator').css('display', 'none');
        $j('#moreinfo').css('display', 'block');
      });
      
    });
    
      
      
      $j('#moreinfo').click(showinfo);
      
      
      
      function closeinfo() {
         $j('#popup').css('display', 'none'); 
         $j('.text').css('display', 'block');
         $j('#moreinfo').css('display', 'block');
         $j('#lessinfo').css('display', 'none');
      }
      
      $j('#closepopup').click(closeinfo);
      $j('#lessinfo').click(closeinfo);
    
  });
</script>
{/literal}



<div id="right_part">  {*---right_part div is closed in footer.tpl---*}
{*    <div id="footer">
    <p>Copyright &copy; Visulate &reg; LLC 2007, 2016.
    <span style="float: right;">
    <a data-ajax="false"href="/privacy.html">Privacy Policy</a>, <a data-ajax="false"href="/terms.html">Terms and Conditions</a>.
    </span>
    </p>
    </div>*}
    
 {$report_text}  

{*<h2 id="page_header">{$data.PROPERTY.ADDRESS1}, {$data.PROPERTY.CITY}</h2>*}



{include file="google-analytics.tpl"}

{*{include file="footer.tpl"}*}
 
</div> <!-- end right part -->
</div> <!-- end content -->
</div>  <!-- end main -->
</body>
</html>
