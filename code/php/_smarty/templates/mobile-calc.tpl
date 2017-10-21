{include file="mobile-top.tpl"}


{if ($menu2=="cash-flow")}
<script src="/include/cap_calc.js" type="text/javascript" > </script>

<script src="/rental/html/jquery.remember-state/jquery.remember-state.js" type="text/javascript" ></script>
<script>{literal}
    $(function() {
      $("#prop").rememberState({ objName: "calc-cashflow" }).submit(function() {
        localStorage.setObject("calc-cashflow", $(this).serializeArray());
        return false;
      });
    });
{/literal}</script>
{include file="mobile-calc-noi1.tpl"}
{include file="mobile-calc-noi2b.tpl"}
{include file="mobile-calc-fin1.tpl"}
{include file="mobile-calc-fin2.tpl"}
{include file="mobile-calc-cashflow.tpl"}

{elseif ($menu2=="repair")}
{include file="mobile-calc-repairs.tpl"}
{include file="adsense-mobile320x100.tpl"}
{elseif ($menu2=="mortgage")}
{include file="mobile-calc-fin1.tpl"}
{include file="adsense-mobile320x100.tpl"}
<div style="display: none;">
{include file="mobile-calc-noi1.tpl"}
{include file="mobile-calc-noi2a.tpl"}
{include file="mobile-calc-cashflow.tpl"}
{include file="mobile-calc-fin2.tpl"}
</div>

<script src="/include/cap_calc.js" type="text/javascript" > </script>

<script src="/rental/html/jquery.remember-state/jquery.remember-state.js" type="text/javascript" ></script>
<script>{literal}
    $(function() {
      $("#fin").rememberState({ objName: "calc-mortgage" }).submit(function() {
        localStorage.setObject("calc-mortgage", $(this).serializeArray());
        return false;
      });
    });
{/literal}</script>
{else}
{include file="mobile-calc-noi1.tpl"}
{include file="mobile-calc-noi2a.tpl"}
{include file="adsense-mobile320x100.tpl"}

<div style="display: none;">
{include file="mobile-calc-cashflow.tpl"}
{include file="mobile-calc-fin1.tpl"}
{include file="mobile-calc-fin2.tpl"}
</div>

<script src="/include/cap_calc.js" type="text/javascript" > </script>

<script src="/rental/html/jquery.remember-state/jquery.remember-state.js" type="text/javascript" ></script>
<script>{literal}
    $(function() {
      $("#prop").rememberState({ objName: "calc-noi" }).submit(function() {
        localStorage.setObject("calc-noi", $(this).serializeArray());
        return false;
      });
    });
{/literal}</script>
{/if}

<p>
  <a href="http://visulate.com" style="display: none;">home</a></p>

<script>
  var img = 'https://s3.amazonaws.com/visulate.cities/704x440/{$backgroundImg.NAME}';
  var imageLink = '<a style="color: white;" href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county={$backgroundImg.COUNTY}&city={$backgroundImg.CITY}&region_id={$backgroundImg.REGION_ID}">{$backgroundImg.CITY|lower|ucwords}, Florida</a>';

   document.getElementById("page1").style.backgroundImage = "url(" + img + ")";
   $("#page1").append('<div style="color: white;">'+imageLink+'</div>');
</script>

{include file="mobile-footer-pub.tpl"}