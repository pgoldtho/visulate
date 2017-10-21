{include file="top.tpl"}
  <!-- begin main -->
  <div id="main">
    <!-- begin content -->
    <div id="content">
      <!-- begin left part -->
<div id="left_part">    {*---menu level 3---*} 
 <div id="nav">
   <h2 class="title">Business Report</h2>
       <ul class="left_menu">
       {foreach from=$ReportList item=item name=l3menu}
         {if $smarty.foreach.l3menu.last }
            {assign var="l3class" value="li_left_last"}       
         {elseif $smarty.foreach.l3menu.first }
            {assign var="l3class" value="li_left_first"}
         {else}
            {assign var="l3class" value="li_left_normal"}
         {/if}
       {if ($item.code eq $reportCode)}
             <li class="{$l3class}"><a href="{$item.href}" class="active">{$item.title}</a></li>
       {else}
             <li class="{$l3class}"><a href="{$item.href}">{$item.title}</a></li>
       {/if}
      {/foreach}
       </ul>
  </div> <!-- End of nav -->
</div>   <!-- End of left_part -->
    <div id="right_part">  {*---right_part div is closed in footer.tpl---*} 
<div class="col-md-12">
  <h1>{$header_title}</h1>
  
  {if ($isReport) }
  <form {$form_data.attributes}>  
    <table class="datatable1">
      {foreach from=$form_data item=element}
        {if @($element.type == "text" || $element.type == "checkbox" || $element.type == "select" || $element.type == "lov" || $element.type == "hierselect" )}
         {if @(@$element.error)}
          <tr>
             <td colspan="2">
             <span class="error">{$element.error}</span>
             </td>
          </tr>
         {/if}
        <tr>
          <th>{$element.label}</th>
          <td valign="middle">
           {$element.html}
           {calendar form="reports" elements=$dates current=$element.name}
           { if (@$element.required) } <span class="error">*</span> {/if}
          </td>
        </tr>
         {/if}
       {/foreach}
       <tr><td colspan="2" style="text-align:right">{$form_data.submit_pdf.html} {$form_data.submit_html.html}</td></tr>
    </table>
       {$form_data.hidden}
  </form>
  {$report_text}  
  {/if}
</div>  
{include file="footer.tpl"}
