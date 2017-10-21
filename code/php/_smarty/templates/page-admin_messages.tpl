{include file="top.tpl"}
  <!-- begin main -->
  <div id="main">
    <!-- begin content -->
    <div id="content">
      <!-- begin left part -->
     <!-- end left part -->
     <!-- begin right part -->
     <div id="right_part">  {*---right_part div is closed in footer.tpl---*} 
<div class="colmd-12">
 <h1>{$header_title}</h1>
 {show_error info=$errorObj}
 {if ($is_form == "no")}
     <form {$form.attributes}>
        {$form.CATEGORY_NAME_SELECTED.label} {$form.CATEGORY_NAME_SELECTED.html}
        {$form.hidden}
     </form>
     <a href="?{$menuObj->getParam2()}&action=add&CATEGORY_NAME_SELECTED={$categoryName}" class="small">Add Message</a>
    {foreach from=$em_list item=element}
       <div style="max-width:500px;margin-top:20px">
            <a name="errorID{$element.ERROR_ID}"></a>
            <h4>[{$element.ERROR_CODE}] {$element.CLASSIFIED_DESCRIPTION}</h4>
            <div style="text-align:right"><a href="?{$menuObj->getParam2()}&ERROR_ID={$element.ERROR_ID}&action=edit&CATEGORY_NAME_SELECTED={$categoryName}" class="small">Edit</a>
                                          <a href="?{$menuObj->getParam2()}&ERROR_ID={$element.ERROR_ID}&action=delete&CATEGORY_NAME_SELECTED={$categoryName}" onclick="return confirm('Delete this message?');" class="small">Delete</a></div>
            <div class="shortd">{$element.SHORT_DESCRIPTION}</div>
            {if ($element.SHOW_LONG_DESCRIPTION_YN == "Y")}
                 <div class="longd">{$element.LONG_DESCRIPTION}</div>
            {/if}
       </div>
    {/foreach}
 {else}
    <form {$form.attributes}>
                <table class="datatable">
                {foreach from=$form item=element}
                    {if @(($element.type == "text" || $element.type == "textarea" || $element.type == "select" || $element.type == "checkbox") && ($element.name != "LONG_DESCRIPTION"))}
                        {if @(@$element.error)}
                            <tr>
                                <td colspan="2">
                                    <span class="error">{$element.error}</span>
                            </td>
                            </tr>
                        {/if}
                        <tr>
                            <th>{$element.label}{ if (@$element.required) } <span class="error">*</span> {/if}</th>
                            <td valign="middle">
                                {$element.html}
                            </td>
                        </tr>
                    {/if}
                {/foreach}
                        <tr>
                          <th colspan="2">Long Description</th>
                        </tr>
                        <tr>
                          <td colspan="2">{$fckEditor->Create()}</td>
                        </tr>
    
                        <tr>
                            <td colspan="2" align="right" style="text-align:right">
                            {foreach from=$form item=element}
                                {if @($element.type == 'submit')}
                                    {$element.html}
                                {/if}
                            {/foreach}
                            </td>
                        </tr>
                    </table>
                {$form.hidden}
        </form>
 {/if}
 </div>
{include file="footer.tpl"}