{include file="top.tpl"}
  <!-- begin main -->
  <div id="main">
    <!-- begin content -->
    <div id="content">
      <!-- begin left part -->
<div id="left_part">    {*---Business Units menu level 3---*} 
 <div id="nav">
  <h2 class="title">Business Unit</h2>
    <ul class="left_menu">
        {foreach from=$businessList item=item name=l3menu}
         {if $smarty.foreach.l3menu.last }
            {assign var="l3class" value="li_left_last"}       
         {elseif $smarty.foreach.l3menu.first }
            {assign var="l3class" value="li_left_first"}
         {else}
            {assign var="l3class" value="li_left_normal"}
         {/if}
           {if ($item.BUSINESS_ID eq $businessID)}
             <li class="{$l3class}"><a href="?{$menuObj->getParam2()}&BUSINESS_ID={$item.BUSINESS_ID}" class="active">{$item.BUSINESS_NAME}</a></li>
           {else}
             <li class="{$l3class}"><a href="?{$menuObj->getParam2()}&BUSINESS_ID={$item.BUSINESS_ID}">{$item.BUSINESS_NAME}</a></li>
           {/if}
          {/foreach}
        </ul>
  
{if ($data)}
  <h2 class="title">Properties</h2>
    <ul class="left_menu">
      {foreach from=$data key=k item=item name=prop}
         {if $smarty.foreach.l3menu.first }
            {assign var="l3class" value="li_left_first"}
         {else}
            {assign var="l3class" value="li_left_normal"}
         {/if}
         <li class="{$l3class}"><a href="?m2=property_sales&FORM_ACTION=UPDATE&PROP_ID={$item.PROP_ID}">{$item.ADDRESS1}, {$item.CITY}</a></li>
          {/foreach}
          <li><a href="?m2=property_sales&FORM_ACTION=CANCEL">Search for a Property</a></li>
          <li class="li_left_last"><a href="?m2=property_sales&FORM_ACTION=INSERT">Enter a New Property</a></li>
        </ul>
{elseif ($data0)}
<h2 class="title">Properties</h2>
    <ul class="left_menu">
      <li><a href="?m1=property">Try Another Search</a></li>
          <li class="li_left_last"><a href="?m2=property_sales&FORM_ACTION=INSERT">Enter a New Property</a></li>
        </ul>

{/if}


    
    </div> <!-- End of nav -->
</div>   <!-- End of left_part -->
     <!-- begin right part -->
     <div id="right_part">  {*---right_part div is closed in footer.tpl---*} 

  <h1>Record Sales Listings</h1>
  
  {if ($user_hint)}
    <p>{$user_hint}</p>
  {/if}
  
  <div class="col-md-6">
  <form {$form_data.attributes}>
   <table class="datatable1">
    {show_error info=$errorObj}
      {foreach from=$form_data item=element}
          {if @($element.type == "text"
             || $element.type == "link"
               || $element.type == "checkbox"
               || $element.type == "select"
                 || $element.type == "lov")}
        {if @($element.error)}
                <tr>
                   <td colspan="2">
                     <span class="error">{$element.error}</span>
                   </td>
                </tr>
             {/if}
                <tr>
                  <th>{$element.label} {if (@$element.required) } <span class="error">*</span> {/if}</th>
                  <td>{$element.html}
                        {calendar form="formPL" elements=$dates current=$element.name}
                    </td>
                </tr>
           {/if}
       {/foreach}
       <tr><th>{$form_data.PL_DESCRIPTION.label}</th><td>{$form_data.PL_DESCRIPTION.html}</td></tr>
       <tr><td colspan="2" >{$form_data.btnFind.html}{$form_data.btnNew.html}{$form_data.btnSubmit.html}{$form_data.btnCancel.html}</td></tr>
   </table>  
      
    
        {$form_data.hidden}

</div>
<div class="col-md-6">


</div>




      </form>
{include file="footer.tpl"}