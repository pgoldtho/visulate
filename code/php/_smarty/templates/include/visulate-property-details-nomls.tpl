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
     Visulate is a real estate brokerage based in Merrit Island, Florida.
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

