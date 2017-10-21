{include file="top.tpl"}
{show_error info=$errorObj}
  <!-- begin main -->
  <div id="main">
    <!-- begin content -->
    <div id="content">
      <!-- begin left part -->
     <!-- end left part -->
     <!-- begin right part -->
     <div id="right_part">  {*---right_part div is closed in footer.tpl---*} 
<div class="col-md-12">
<h1>User List</h1>

{if ($action == "INSERT")}
             <form {$form_data.attributes}>
             <table class="datatable">
                 <tr>
                   <th colspan="2">
                       Add User
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
{else}
 <p><a title="Add user" href="?{$menuObj->getParam2()}&action=INSERT">Add user</a></p>
{/if} 

<table class="datatable">
  <th>User Name</th>
  <th>User E-mail (login)</th>  
  <th>Is active?</th>  
  <th>Is subscribed?</th>
  <th>Reset password</th>  
  {foreach from=$userList item=item}
     {if ( ($action == "UPDATE") && ($currentUserID == $item.USER_ID) )}
        <tr>
          <td colspan="6" style="text-align:center" align="center">
             <br>
             <form {$form_data.attributes}>
             <table class="datatable">
                 <tr>
                   <th colspan="2">
                       Edit User "{$item.USER_LASTNAME} {$item.USER_NAME}"
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
          </td>
        </tr>
     {else}
       <tr>
          <td><a name="user{$item.USER_ID}" title="Edit user" href="?{$menuObj->getParam2()}&USER_ID={$item.USER_ID}&action=UPDATE">
              {$item.USER_LASTNAME} {$item.USER_NAME}</a>
          </td>
          <td>{$item.USER_LOGIN}</td>
          <td style="text-align:center"><a onclick="return confirm('Change active for user?')" href="?{$menuObj->getParam2()}&USER_ID={$item.USER_ID}&action=changeActive">{$item.IS_ACTIVE_YN}</a></td>
          <td style="text-align:center">{$item.IS_SUBSCRIBED_YN}</td>
          <td style="text-align:center"><a onclick="return confirm('Reset password for user?')" href="?{$menuObj->getParam2()}&USER_ID={$item.USER_ID}&action=resetPassword">Reset</a></td>
        </tr>
     {/if}
  {/foreach}
</table>
</div>
{include file="footer.tpl"}
