{include file="top.tpl"}
  <!-- begin main -->
  <div id="main">
    <!-- begin content -->
    <div id="content">
      <!-- begin left part -->
<div id="left_part"> 
<div id="nav">
  
  
{show_error info=$errorObj}
{foreach from=$bu_tree item=element name=bu}

   
        {if ($element.LEVEL_BUSINESS == 1) }   
          {if $smarty.foreach.bu.first}
                      <h2 class="title">{$element.BUSINESS_NAME}</h2>
                      <ul class="left_menu">
            {else}
                    <li class="li_left_last"/>
                    </ul>
                      <h2 class="title">{$element.BUSINESS_NAME}</h2>
                      <ul class="left_menu">
          {/if}
              {if ($role == "BUSINESS_OWNER" || $role == "MANAGER_OWNER")}
                   <li class="li_left_first">
                <a class="small" href="?{$menuObj->request_menu_level2}={$menuObj->current_level2}&action=ins&parent={$element.BUSINESS_ID}">
                   <b> Create New Business Unit</b></a>
             </li>
              {/if}
        {else}
          {if $smarty.foreach.bu.last}
           <li class="li_left_last">
          {else}
             <li class="li_left_normal">
          {/if}
    
            {if ($element.LEVEL_BUSINESS > 1) }
              {if ($role == "BUSINESS_OWNER" || $role == "MANAGER_OWNER")}
                {if ($element.BUSINESS_ID == $id )}
                    <a class="active" href="?{$menuObj->request_menu_level2}={$menuObj->current_level2}&action=upd&id={$element.BUSINESS_ID}">{$element.BUSINESS_NAME}</a>
                {else}
                  <a href="?{$menuObj->request_menu_level2}={$menuObj->current_level2}&action=upd&id={$element.BUSINESS_ID}">{$element.BUSINESS_NAME}</a>
                {/if}
              {else}
                  {$element.BUSINESS_NAME}
               {/if}
            {/if}
            </li>
        {/if}
{/foreach}
   


</ul></div>      
</div>      
      
     <!-- end left part -->
     <!-- begin right part -->
     <div id="right_part">  {*---right_part div is closed in footer.tpl---*} 
<div class="col-md-12">
 <h1>{$header_title}</h1>
 

{foreach from=$bu_tree item=element}
{show_error info=$errorObj}
        {if ($isForm == "true" && ($action == "INSERT" || $action == "UPDATE") && $element.BUSINESS_ID == $id)
                               && ($role == "BUSINESS_OWNER" || $role == "MANAGER_OWNER")}
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
    
            <h3>Agreement Templates</h3>
            <table class="datatable">
             {if @($form_data.TEMPLATE_NAME.error)}
                <tr><td colspan="2"><span class="error">{$form_data.TEMPLATE_NAME.error}</span></td></tr>
             {/if}
            <tr><th>{$form_data.TEMPLATE.html}</th><th>{$form_data.edit_template.html}</th></tr>
            <tr><th>Template: {$form_data.TEMPLATE_NAME.html}{ if (@$form_data.TEMPLATE_NAME.required) } <span class="error">*</span> {/if}</th>
                <th>{$form_data.save_template.html}{$form_data.cancel_template.html}</th></tr>
            <tr><td colspan="2" style="text-align:center;background-color:#eeeeee">
              {$ckEditor->editor('T_CONTENT', $t_content, $cke_config)}
               </td></tr>

            </table>
    
         {/if}


         </form> 
   

{/foreach}


</div>
{include file="footer.tpl"}