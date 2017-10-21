<div id="l3_subtab_container">
	  <div id="l3_subtab">
  	   <ul id="navlist3">
	    {*---menu level 3 - as submenu for level2---*} 
        {foreach from=$submenu2_1 item=value key=key name=menu2}
               {if $key eq $skey}
                    <li><a class="active" href="{$value.href}" >{$value.value} </a></li>
               {else}
                    <li><a href="{$value.href}" >{$value.value} </a></li>
               {/if}
        {/foreach}
    </ul>
   </div>
  </div>