<div id="prop-top">
{if ($mls)}

{foreach  from=$mls item=m key=mk}

  {if ($m.IMG)}

<div class="photos">
   {foreach from=$m.IMG item=img2 key=k name=imgLoop}
      {if $smarty.foreach.imgLoop.first}
         <img class="large"  src="/rental/php/resizeImg.php?w=800&h=600&src={$img2.PHOTO|escape:'url'}">
         <div class="thumbs">
      {/if}
      <div class=""><img class="small" src="/rental/php/resizeImg.php?w=800&h=600&src={$img2.PHOTO|escape:'url'}"></div>

   {/foreach}
        </div>
</div>
  <h1 class="addrhead">For {$m.TYPE} - {$m.LINK_TEXT}</h2>
  <img class="IDElogo" src="/images/idx_brevard_small.gif"/>
{literal}
      <script type="text/javascript">
      $j(document).ready(function(){
        $j('.small').click(function(){
          var smallsrc = $j(this).attr('src');
          $j('.large').attr('src', smallsrc);
        });
      });

      </script>


{/literal}
{/if}


  <h3>{$m.TITLE}</h3>
  <p>{$m.DESCRIPTION}</p>
       {assign var="mlsID" value=$m.MLS_NUMBER}
     <hr/>
    <table style="width: 100%;" class="layouttable">
    <tr><td style="font: 1.5em Tahoma Arial,Helvetica,sans-serif;">
    <h5>Contact Sue for additional details</h5>
        <ul>
          <li><b>Email:</b>
      {mailto address='sales@visulate.com' subject="I am interested in http://visulate.com/property/$propid (MLS# $mlsID)"
    encode='javascript'  text='sales@visulate.com'}</li>
      <li><b>Phone:</b> <a href="tel:+1-321-453-7389">(321) 453 7389</a></li>
          <li><b>Property ID:</b> {$data.PROP_ID}</li>


        </ul>
        <p>Please quote reference number: <b>{$propid}</b> when you call or email</p>
    </td>
    <td><img src="/images/sue_sm.png" style="float: right"/></td>
        </tr>
  </table>

     <hr/>


<p>Listing provided by {$m.BROKER}.  Copyright {'Y'|date}
{if ($m.SOURCE_ID == 6)}
Multiple Listing Service of South Brevard, Inc. and Space Coast Association of REALTORS, Inc.
{elseif ($m.SOURCE_ID == 8)}
Multiple Listing Service of South East Florida and Miami Association of Realtors.
{else}
My Florida Regional MLS.
{/if}
All rights reserved.
   </p>

{/foreach}
{else}
  {if ($report_element.STATE == 'FL') && ($hidden != 'Y')}
    <fieldset style="display: block; width: 680px;" >
  <legend>Welcome to Visulate</legend>
<table class="layouttable">
<tr><td>
<img src="/images/sue_sm.png" style="border: 1px solid #949494;"/>


</td><td>
{literal}
<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- prop336x280 -->
<ins class="adsbygoogle"
     style="display:inline-block;width:336px;height:280px"
     data-ad-client="ca-pub-9857825912142719"
     data-ad-slot="8664618513"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
{/literal}
</td></tr></table>
  <p>
     Visulate is a real estate brokerage based in Mims, Florida.
           We have assembled a database with details of every property in Florida.
           Finding the property on our site does not necessarily mean it is for sale or rent at this time.


<h4>Contact us if you want to buy or sell real estate in {$data.PROPERTY.CITY}:</h4>
        <ul>
          <li><b>Email:</b>
                  {mailto address='sales@visulate.com' subject="Please Help me buy or sell something like this - http://visulate.com/property/$propid "
                encode='javascript'  text='sales@visulate.com'}</li>
       </ul>
       <p>Please quote reference number: <b>{$propid}</b> in your email</p>

     </fieldset>
   {/if}
{/if}
</div><!--prop-top-->
