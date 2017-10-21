{include file="top.tpl"}
  <!-- begin main -->
  <div id="main">
    <!-- begin content -->
    <div id="content">
      <!-- begin left part -->
     <!-- end left part -->
     <!-- begin right part -->
     <div id="right_part">  {*---right_part div is closed in footer.tpl---*} 
<div class="col-md-12">
 <h1>{$header_title}</h1>
{show_error info=$errorObj}
{foreach from=$bu_tree item=element}
   <div style="margin-left:{$element.LEVEL_BUSINESS*20}px">
        {if ($element.LEVEL_BUSINESS == 1 ) }   
              <b>{$element.BUSINESS_NAME}</b>&nbsp;&nbsp;&nbsp;
        {else}
                {if (!($element.BUSINESS_ID == $id && $action == "UPDATE"))}
                   <a title="Edit Business unit" href="?{$menuObj->getParam2()}&action=upd&id={$element.BUSINESS_ID}">
                                {$element.BUSINESS_NAME}</a>
                  <a href="?{$menuObj->getParam2()}&action=del&id={$element.BUSINESS_ID}" onclick="return confirm('Delete this business unit?')">
                            <img class="nomargin" border="0" width="14" height="14" src="images/delete.gif"></a>
              {/if}
        {/if}
    
        {if ($element.LEVEL_BUSINESS != 3 && !($element.BUSINESS_ID == $id && $action == "UPDATE")) }
                <a class="small" href="?{$menuObj->request_menu_level2}={$menuObj->current_level2}&action=ins&parent={$element.BUSINESS_ID}">
                                    create sub unit</a>
        {/if}
    
        {if ($isForm == "true" && ($action == "INSERT" || $action == "UPDATE") && $element.BUSINESS_ID == $id)}
            <br>
            <form {$form_data.attributes}>
            <table class="datatable">
                     {if @($form_data.BUSINESS_NAME.error)}
                        <tr>
                           <td colspan="3">
                             <span class="error">{$form_data.BUSINESS_NAME.error}</span>
                           </td>
                        </tr>
                     {/if}
                    <tr>
                      <th>{$form_data.BUSINESS_NAME.label}</th>
                      <td>
                         {$form_data.BUSINESS_NAME.html}{ if (@$form_data.BUSINESS_NAME.required) } <span class="error">*</span> {/if}
                      </td>
                      <td>
                         {$form_data.accept.html}  {$form_data.cancel.html}
                      </td>
                    </tr>
             </table>
             {$form_data.hidden}
            </form>
         {/if}
   </div>

{/foreach}
</div>
{include file="footer.tpl"}