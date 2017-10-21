{include file="loginTop.tpl"}
  <!-- begin main -->
  <div id="main">
    <!-- begin content -->
    <div id="content" >
      <!-- begin left part -->
      <div id="left_part">
      <div id="nav">    

    <fieldset><legend>Warning</legend>
    Unauthorized use of this site is
                    prohibited and may be subject to civil and criminal prosecution
    </fieldset>
     </div> <!-- end nav -->
    </div> <!-- end left part -->
    <!-- begin right part -->
     <div id="right_part">  {*---right_part div is closed in footer.tpl---*}



    <div style="text-align:center; padding: 300px;" >

      <form {$values.attributes}>
           <table align="center;" class="datatable">
              {if ($isFirst)}
                <tr><td colspan="2">
                 <h1>Account Registration</h1>
                 <p>Enter the account details from the email you received</p>
                 </td></tr>
              {/if}
              <tr>
               <td align="right" style="background-color: white;">{$values.user.label}</td>
               <td>{$values.user.html}</td>
             </tr>
              <tr>
               <td align="right" style="background-color: white;">{$values.pass.label}</td>
               <td>{$values.pass.html}</td>
             </tr>
             <tr>
               <td colspan="2" align="right">
                     {$values.submit.html}
                   <br>
               </td>
             </tr>
             
             <tr>
                   <td colspan="2" align="center">
                   {if (@$error)}
                       <span class="error">
                       {$error}
                       {show_error info=$errorObj}
                       </span>
                   {/if}
                   </td>
                  </tr>
            </table>
            {$values.hidden}
         </form>
  <script>
     document.formLogin.user.focus();
  </script>    
  </div>
 
{include file="footer.tpl"}