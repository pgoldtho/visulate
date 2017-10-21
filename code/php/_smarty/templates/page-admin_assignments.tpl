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
<h1>User Assignments List</h1>
{show_error info=$errorObj}
 {if (@$form_add_data)} 
   <form {$form_add_data.attributes}>
     <table class="datatable">
       <tr><th>{$form_add_data.role_id.label}</th><td>{$form_add_data.role_id.html}</td><td>{$form_add_data.create.html}</td></tr>
     </table>
    {$form_add_data.hidden}
   </form>    
 {else}
    {if @($form_data)}
         <form {$form_data.attributes}>
             <table class="datatable">
                 <tr>
                   <th colspan="2">
                       Add User Assignment
                   </th>
                 </tr>
               {foreach from=$form_data item=element}
                 {if @($element.type == "text" || $element.type == "checkbox" || $element.type == "select")}
                    {if @(@$element.error)}
                        <tr>
                        <td colspan="2"><span class="error">{$element.error}</span></td>
                       </tr>
                      {/if}
                  <tr>
                    <th>{$element.label}</th>
                    <td>
                        {$element.html}
                        { if (@$element.required) } <span class="error">*</span> {/if}
                    </td>
                  </tr>
                  {/if}
                {/foreach}
                 <tr>
                   <td colspan="2" style="text-align:right">
                       {$form_data.accept.html} {$form_data.cancel.html}
                   </td>
                 </tr>
             </table>
             {$form_data.hidden}
             </form>
        {/if}
   {/if} 
<table class="datatable">
  <th>User Name</th>
  <th>User E-mail (login)</th>  
  <th>Is active?</th>  
  <th>Is subscribed?</th>    
  <th>Business Name</th>
  <th>Role Name</th>  
  <th></th>
  {foreach from=$userAssignList item=item}
       <tr>
          <td>{$item.USER_LASTNAME} {$item.USER_NAME}</td>
          <td>{$item.USER_LOGIN}</td>
          <td style="text-align:center">{$item.IS_ACTIVE_YN}</td>
          <td style="text-align:center">{$item.IS_SUBSCRIBED_YN}</td>
          <td>{$item.BUSINESS_NAME}</td>
          <td>{$item.ROLE_NAME}</td>
          <td><a href="?{$menuObj->getParam2()}&USER_ASSIGN_ID={$item.USER_ASSIGN_ID}&action=DEL" onclick="return confirm('Delete this assignment?')"><img border="0" width="14" height="14" src="images/delete.gif"></a></td>
        </tr>
  {/foreach}
</table>
</div>
{include file="footer.tpl"}
