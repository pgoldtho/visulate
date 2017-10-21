{if $submenu2_1|@count > 1}
      <ul class="tablist" style="margin: 0; padding: 0; width: 100%; border-radius: 0;">
        {foreach from=$submenu2_1 item=value key=key name=menu2}
        {if $key eq $skey}<li class="navtab active">{else}<li class="navtab">{/if}
         <a href="{$value.href}" class="tablink">{$value.value} </a></li>
        {/foreach}
      </ul>
{/if}

{if $submenu2_1|@count > 2}
  {literal}<style>.navtab{width: auto;}</style>{/literal}
{else}
  {literal}<style>.navtab{width: 50%;}</style>{/literal}
{/if}

{literal}
<style>
.tablist {
    list-style-type: none;
    margin: 0;
    padding: 0;
    overflow: hidden;
}

.navtab {
    float: left;
    border-left: 1px solid #ccc;
    border-right: 1px solid #ccc;
    border-bottom: 1px solid #ccc;
    background-color: #e7e7e7;
}

.navtab a {
    display: block;
    color: #808080;
    text-align: center;
    padding: 14px 16px;
    text-decoration: none;
}

.navtab.active a, .navtab a:hover {
    background-color: #d9d9d9;
    color: #333;
}

</style>
{/literal}
