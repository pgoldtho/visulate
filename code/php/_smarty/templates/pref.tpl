{include file="loginTop.tpl"}
  <!-- begin main -->
  <div id="main">
    <!-- begin content -->
    <div id="content">
      <!-- begin left part -->
      <div id="left_part">
      <div id="nav">    
      <h2 class="title"><a href="#" class="active">Actions</a></h2>
       <ul class="left_menu">
        <li><a href="login2.php">Select Role</a></li>
        <li class="li_left_last"><a href="pref.php" class="active">Change Password</a></li>
      </ul>
     </div> <!-- end nav -->
    </div> <!-- end left part -->
    <!-- begin right part -->
     <div id="right_part">  {*---right_part div is closed in footer.tpl---*} 
     
     <div class="col-md-8">
     <h3>Account Details</h3>

    <form {$values.attributes}>
       <table class="datatable">
       {if (!@$success_message)}
         <tbody>
          {foreach from=$values item=element}
            {if @($element.type == "text" || $element.type == "checkbox" || $element.type == "select" || $element.type == "password")}
             {if @(@$element.error)}
              <tr>
                 <td colspan="2">
                 <span class="error">{$element.error}</span>
                 </td>
              </tr>
             {/if}
            <tr>
              <th align="right">{$element.label}</th>
              <td valign="middle">
               {$element.html}
               { if (@$element.required) } <span class="error">*</span> {/if}
              </td>
            </tr>
             {/if}
           {/foreach}
              <tr>
          <td colspan="2" align="right">
           {$values.submit.html} {$values.cancel.html}
           {$values.hidden}
          </td>
         </tr>
      {else}
        <tr><td colspan="2"><div class="success">{$success_message}</div></td></tr>
        <tr><td colspan="2" ><button>OK</button></td></tr>  
       {/if}
       </tbody>
      </table>
     </form>
     </div>
  
{include file="footer.tpl"}  
