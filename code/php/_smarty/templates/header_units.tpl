{include file="top.tpl"}
  <!-- begin main -->
  <div id="main">
<div id="content">
<!-- begin left part -->
<div id="left_part">    {*---menu level 3---*} 
<div id="nav">
    <script src="{$PATH_FROM_ROOT}/html/peoples.js" language="javascript"></script>
    {foreach from=$menu3Obj->data item=value key=key name=businessUnits}
        {assign var="class"      value="closed"}
        {assign var="display"    value="none"}
        {assign var="arrow"      value="&rarr;"}
        {assign var="is_present" value="false"}
        {foreach from=$value item=value1 name=l3menu}
            {assign var="is_present" value="true"}
            {if $value1.id eq $menu3Obj->current_property_id}
                {assign var="class"   value="opened"}
                {assign var="display" value="block"}
                {assign var="arrow"   value="&darr;"}
            {/if}
        {/foreach}
        <h2 class="title">
            {if $is_present == "false"}
                {$key}
            {else}
                <a href="javascript:void(0)" class="{$class}">{$arrow} {$key}</a>
            {/if}
        </h2>
        <ul class="left_menu" style="display:{$display}">
            {foreach from=$value item=value1 name="l3menu"}
                {if $smarty.foreach.l3menu.last }
                    {assign var="l3class" value="li_left_last"}
                {elseif $smarty.foreach.l3menu.first }
                    {assign var="l3class" value="li_left_first"}
                {else}
                    {assign var="l3class" value="li_left_normal"}
                {/if}
    
                {if $value1.id eq $menu3Obj->current_property_id}
                    <li class="{$l3class}"><a href="?{$menuObj->request_menu_level2}={$menuObj->current_level2}&{$menu3Obj->request_property_id}={$value1.id}" class="active">{$value1.address}</a>
			        <ul class="sublist">
			            {foreach from=$unit_list item=uitem}
			                {if ($uitem.UNIT_UNIT_ID == $currentUnitID)}
				                <li><a href="?{$menuObj->request_menu_level2}={$menuObj->current_level2}&{$menu3Obj->request_property_id}={$value1.id}&UNIT_ID={$uitem.UNIT_UNIT_ID}" class="active"> - {$uitem.UNIT_UNIT_NAME}</a></li>
				            {else}
			                    <li><a href="?{$menuObj->request_menu_level2}={$menuObj->current_level2}&{$menu3Obj->request_property_id}={$value1.id}&UNIT_ID={$uitem.UNIT_UNIT_ID}"> - {$uitem.UNIT_UNIT_NAME}</a></li>
				            {/if}
			            {/foreach}
			        </ul>
                {else}
                    <li class="{$l3class}"><a href="?{$menuObj->request_menu_level2}={$menuObj->current_level2}&{$menu3Obj->request_property_id}={$value1.id}">{$value1.address}</a></li>
                {/if}
            {/foreach}{*---Property---*}
            {if ($is_present == 'false')}
                <li class='li_left_last'></li>
            {/if}
        </ul>
    {/foreach} {*---Business Units---*}
</div>
</div>
<div id="right_part">  {*---right_part div is closed in footer.tpl---*} 