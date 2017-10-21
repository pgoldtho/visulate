
{foreach  from=$mls item=m key=mk}
{* {$m|@print_r}*}
  {if ($m.IMG)}
<div class="photo-cont">
    
   <ul class="current-photo">
   {foreach from=$m.IMG item=img2 key=k name=imgLoop}
     <li><img class="img-bg" src="/rental/php/resizeImg.php?w=1024&h=768&src={$img2.PHOTO|escape:'url'}"></li>
   {/foreach}
  </ul>

</div>


{literal}
  <script type="text/javascript">
     $j(document).ready(function(){
      $j('.current-photo li:not(:first)').addClass('hidden');
      $j('.current-photo li').first().addClass('showing');
      //$j('.current-photo li').first().addClass('hidden');
      $j('.indicator').html('1/'+$j('.current-photo li').length);

      function nextPhoto(){
        var current = $j('.showing');
        var next = current.next();
        var thumbindex = current.index() + 1;
        $j('.indicator').html(thumbindex+1+'/'+$j('.current-photo li').length);
        if(current.is($j('.current-photo li').last())) {
          next = $j('.current-photo li').first();
          $j('.indicator').html('1/'+$j('.current-photo li').length);
        }
        next.addClass('showing').removeClass('hidden');
        current.addClass('hidden').removeClass('showing');
      }

      function prevPhoto(){
        var current = $j('.showing');
        var next = current.prev();
        var thumbindex = current.index() + 1;
        $j('.indicator').html(thumbindex-1+'/'+$j('.current-photo li').length);
        if(current.is($j('.current-photo li').first())) {
          next = $j('.current-photo li').last();
          $j('.indicator').html($j('.current-photo li').length + '/' + $j('.current-photo li').length);
        }
        next.addClass('showing').removeClass('hidden');
        current.addClass('hidden').removeClass('showing');
      }

      $j('.current-photo').on('swipeleft', nextPhoto);
      $j('.current-photo').on('swiperight', prevPhoto);
      $j('#photo-right').click(nextPhoto);
      $j('#photo-left').click(prevPhoto);

    });
  </script>
{/literal}
{/if}

{literal}
<style>
  .top-info {
    bottom: 0;
    padding: 0 10px 50px 10px;
    position: absolute;
    background-color: rgba(0,0,0,0.5);
    color: white;
    margin: 0;
  }
  .photo-cont {
   height: 100%;
  }
  .current-photo {
      height: 100%;
      padding: 0;
  }
  .showing {
      height: 100%;
  }
  .ind-wrap {
   // bottom: 50%;
   // position: absolute;
  }
  .img-bg {
      height: 100%;
  }
</style>
{/literal}


<div  class="top-info">
      <div class="ind-wrap">
    <img class="photo-button" id="photo-left" src="/rental/html/jquery.mobile-1.4.5/images/icons-svg/carat-l-black.svg"/>
    <span class="indicator"></span>
    <img class="photo-button" id="photo-right" src="/rental/html/jquery.mobile-1.4.5/images/icons-svg/carat-r-black.svg"/>
  </div>
  <h2>For {$m.TYPE} - {$m.LINK_TEXT}</h2>
  <p>{$m.DESCRIPTION}</p>
<img src="/images/idx_brevard_small.gif"/>
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
   <button style="color: black">I'm interested in this property</button>
</div>
{/foreach}