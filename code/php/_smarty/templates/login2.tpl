{include file="loginTop.tpl"}
  <!-- begin main -->
  <div id="main">
    <!-- begin content -->
    <div id="content">
      <!-- begin left part -->
      <div id="left_part">
      <div id="nav">    
      <h3 class="title">Actions</h3>
       <ul class="left_menu">
        <li><a href="#" class="active">Select Role</a></li>
        <li class="li_left_last"><a href="pref.php">Change Password</a></li>
      </ul>
     </div> <!-- end nav -->
    </div> <!-- end left part -->
    <!-- begin right part -->
     <div id="right_part">  {*---right_part div is closed in footer.tpl---*} 




    <div style="text-align:center; padding: 300px;" >
      <form {$values.attributes}>
           <table align="center" class="datatable">
             {if @(!$error) }
              <tr>
               <td align="right" style="background-color: white;">{$values.role.label}</td>
               <td style="background-color: white;">{$values.role.html}</td>
             </tr>
             {/if}
                  <tr>
                   <td colspan="2" align="center">
                   {if (@$error)}
                       <span class="error">
                       {$error}
                       </span>
                   {/if}
                   </td>
                  </tr>
                <tr>
                 <td colspan="2" align="right" style="background-color: white;">
                   {if @(!$error) }
                       {$values.submit.html}
                   {/if}
                   {$values.logout.html}
               </td>
             </tr>
            </table>
         </form>
        </div>
    
{include file="footer.tpl"}