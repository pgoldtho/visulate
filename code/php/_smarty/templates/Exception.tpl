{include file="top.tpl"}
 <!-- begin main -->
  <div id="main">
    <!-- begin content -->
    <div id="content">
      <!-- begin left part -->
       <div id="left_part">
       <div id="nav">
       </div>
      </div>
     <!-- end left part -->
     <!-- begin right part -->
     <div id="right_part">  {*---right_part div is closed in footer.tpl---*} 
  <h1>{$header_title}</h1>

     <h3>Oops!</h3>
     <p>We encountered an issue while processing your request.</p>
    <div style="width:300;height:300;overflow:auto;border:1px solid #808080">
    {if $ExceptionMessage|strstr:'ORA-'}
    An internal error occurred.  If this condition persists copy the url (web address) from your browser and use the contact us form to send it to us in an email.  Please include a summary of what you were doing before the error occurred and any additional information that you think would be helpful to debug the problem.
    {else}
      {$ExceptionMessage}
    {/if}
        {foreach from=$alertList item=item}
           {$item}<br/>
        {/foreach}
    </div>

{include file="footer.tpl"}
