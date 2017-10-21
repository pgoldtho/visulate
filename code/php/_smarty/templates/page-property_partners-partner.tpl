{include file="top.tpl"}
  <!-- begin main -->
  <div id="main">
    <!-- begin content -->
    <div id="content">
      <!-- begin left part -->
<div id="left_part">    {*---menu level 3---*} 
    <div id="nav">
        <script src="{$PATH_FROM_ROOT}/html/peoples.js" language="javascript"></script>
        {foreach from=$businessList item=item}
            {if (false)}
                {if ($item.BUSINESS_ID eq $businessID)}
                    <h2 class="title"><a href="?{$menuObj->getParam2()}&BUSINESS_ID={$item.BUSINESS_ID}" class="active">{$item.BUSINESS_NAME}</a></h2>
                {else}
                    <h2 class="title"><a href="?{$menuObj->getParam2()}&BUSINESS_ID={$item.BUSINESS_ID}">{$item.BUSINESS_NAME}</a></h2>
                {/if}
            {/if}

            {assign var="class"   value="closed"}
            {assign var="display" value="none"}
            {assign var="arrow"   value="&rarr;"}
            {if ($item.BUSINESS_ID eq $businessID)  }
                {assign var="class"   value="opened"}
                {assign var="display" value="block"}
                {assign var="arrow"   value="&darr;"}
            {/if}
            <h2 class="title">
                <a href="javascript:void(0)" class="{$class}">{$arrow} {$item.BUSINESS_NAME}</a>
            </h2>
            <ul class="left_menu" style="display:{$display}">
                {if ($isEdit eq "true")}
                    {assign var="l3class" value="li_left_last"}
                    {if (is_array($item.PARTNERS) && count($item.PARTNERS) > 0)}
                        {assign var="l3class" value="li_left_first"}
                    {/if}
                    <li class="{$l3class}">
                        <a class="small" href="?{$menuObj->getParam2()}&BUSINESS_ID={$item.BUSINESS_ID}&action=INSERT">
                            <b>Partner - New</b>
                        </a>
                    </li>
                {else}
                    {if (is_array($item.PARTNERS) && count($item.PARTNERS) == 0)}
                        <li class="li_left_last"></li>
                    {/if}
                {/if}
                {foreach from=$item.PARTNERS item=item1 name=l3menu}
                    {if $smarty.foreach.l3menu.last }
                        {assign var="l3class" value="li_left_last"}
                    {elseif $smarty.foreach.l3menu.first }
                        {assign var="l3class" value="li_left_first"}
                    {else}
                        {assign var="l3class" value="li_left_normal"}
                    {/if}
                    {if ($item1.USER_ID eq $userID && $item.BUSINESS_ID eq $businessID)}
                        <li class="{$l3class}"><a href="?{$menuObj->getParam2()}&USER_ID={$item1.USER_ID}&BUSINESS_ID={$item.BUSINESS_ID}" class="active">{$item1.USER_FULLNAME}</a></li>
                    {else}
                        <li class="{$l3class}"><a href="?{$menuObj->getParam2()}&USER_ID={$item1.USER_ID}&BUSINESS_ID={$item.BUSINESS_ID}">{$item1.USER_FULLNAME}</a></li>
                    {/if}
                {/foreach}
            </ul>
        {/foreach}
    </div> <!-- End of nav -->
</div>   <!-- End of left_part -->
     <!-- begin right part -->
     <div id="right_part">  {*---right_part div is closed in footer.tpl---*} 

<div class="col-md-12">
    <h1>{$header_title}</h1>
    {show_error info=$errorObj}
    <form {$form_data.attributes}>
        <table cellpadding=0 cellspacing=0>
            <tr valign=top>
                <td>
                    <table class="datatable1">
                        {foreach from=$form_data item=element}
                            {if @($element.type == "text" || $element.type == "textarea" || $element.type == "select" || $element.type == "checkbox")}
                                {if @(@$element.error)}
                                    <tr><td colspan="2"><span class="error">{$element.error}</span></td> </tr>
                                {/if}
                                <tr>
                                    <th>{$element.label}</th>
                                    <td valign="middle">
                                        {$element.html}
                                        {if (@$element.required) } <span class="error">*</span> {/if}
                                    </td>
                                </tr>
                            {/if}
                        {/foreach}
                        {if ($isEdit eq "true")}
                            <tr>
                                <td colspan="2" align="right" style="text-align:right">
                                    {$form_data.new.html}
                                </td>
                            </tr>
                        {/if}
                    </table>
                    {$form_data.hidden}
                </td>
                <td>&nbsp;</td>
                <td>
                    <table class="datatable">
                        <tr>
                            <th>Role</th>
                            <th>Business Name</th>
                            {if ($isEdit eq "true")}
                                <th></th>
                            {/if}
                        </tr>
                        {foreach from=$userRolesList item=item}
                            <tr>
                                <td>{$item.ROLE_NAME}</td>
                                <td>{$item.BUSINESS_NAME}</td>
                                {if ($isEdit eq "true")}
                                    <td>{$item.DELETE_LINK}</td>
                                {/if}
                            </tr>
                        {/foreach}
                        {if (@$form_data.ROLE_BUSINESS)}
                            <tr>
                                <td colspan="3">{$form_data.ROLE_BUSINESS.html}</td>
                            </tr>
                        {/if}
                        {if ($isEdit eq "true")}
                            <tr>
                                <td colspan="3" style="text-align:right">{$form_data.newRole.html}</td>
                            </tr>
                            <tr>
                                <td colspan="3">
                                    <h4>Actions:</h4>
                                    <ul>
                                        {foreach from=$actionList item=item}
                                            <li><a href="{$item.href}" title="{$item.alt}">{$item.text}</a>
                                        {/foreach}
                                    </ul>
                                </td>
                            </tr>
                        {/if}
                    </table>
                </td>
            </tr>
            {if ($isEdit eq "true")}
                <tr>
                    <td colspan="3" style="text-align:right">
                        {$form_data.cancel.html}
                        {$form_data.accept.html}
                    </td>
                </tr>
            {/if}
        </table>
    </form>
</div>
{include file="footer.tpl"}