{foreach  from=$mls item=m key=mk}
  <h1 class="addrhead">For {$m.TYPE} - {$m.LINK_TEXT}</h2>
{if ($m.IMG)}

<div id="myCarousel" class="carousel slide" data-ride="carousel" style="width: 800px; margin: auto;">
  <!-- Wrapper for slides -->
  <div class="carousel-inner">
   {foreach from=$m.IMG item=img2 key=k name=imgLoop}
    <div class="item  {if $smarty.foreach.imgLoop.first}active{/if} ">
      <img  src="/rental/php/resizeImg.php?w=800&h=600&src={$img2.PHOTO|escape:'url'}" >
    </div>
   {/foreach}
   </div>


  <!-- Left and right controls -->
  <a class="left carousel-control" href="#myCarousel" data-slide="prev">
    <span class="glyphicon glyphicon-chevron-left"></span>
    <span class="sr-only">Previous</span>
  </a>
  <a class="right carousel-control" href="#myCarousel" data-slide="next">
    <span class="glyphicon glyphicon-chevron-right"></span>
    <span class="sr-only">Next</span>
  </a>
</div>
<div class="top-info">
 

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

<img class="IDElogo" src="/images/idx_brevard_small.gif"/>
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
</div><!--top-info-->
{/foreach}

