{include file="top.tpl"}
<script src="{$PATH_FROM_ROOT}/html/suppliers.js" language="javascript"></script>
  <!-- begin main -->
  <div id="main">
    <!-- begin content -->
    <div id="content">
      <!-- begin left part -->
<div id="left_part">    {*---menu level 3---*} 
    <div id="nav">
        {foreach from=$businessList item=item}
            {assign var="class"      value="closed"}
            {assign var="display"    value="none"}
            {assign var="arrow"      value="&rarr;"}
            {if ($item.BUSINESS_ID eq $businessID)  }
                {assign var="class"   value="opened"}
                {assign var="display" value="block"}
                {assign var="arrow"   value="&darr;"}
            {/if}
            <h2 class="title">
                <a href="javascript:void(0)" class="{$class}">{$arrow} {$item.BUSINESS_NAME}</a>
            </h2>
            <ul class="left_menu" style="display:{$display}">
                {if ($isEdit eq "true")}
                    {assign var="l3class" value="li_left_last"}
                    {if (is_array($item.SUPPLIERS) && count($item.SUPPLIERS) > 0)}
                        {assign var="l3class" value="li_left_first"}
                    {/if}
                    <li class="{$l3class}">
                        <a class="small" href="?{$menuObj->getParam2()}&BUSINESS_ID={$item.BUSINESS_ID}&action=INSERT">
                            <b>Vendor - New</b>
                        </a>
                    </li>
                {else}
                    {if (is_array($item.SUPPLIERS) && count($item.SUPPLIERS) == 0)}
                        <li class="li_left_last"></li>
                    {/if}
                {/if}
                {foreach from=$item.SUPPLIERS item=item1 name=l3menu}
                    {if $smarty.foreach.l3menu.last }
                        {assign var="l3class" value="li_left_last"}
                    {elseif $smarty.foreach.l3menu.first }
                        {assign var="l3class" value="li_left_first"}
                    {else}
                        {assign var="l3class" value="li_left_normal"}
                    {/if}
         
                    {if ($item1.SUPPLIER_ID eq $supplierID && $item.BUSINESS_ID eq $businessID)}
                        <li class="{$l3class}"><a href="?{$menuObj->getParam2()}&SUPPLIER_ID={$item1.SUPPLIER_ID}&BUSINESS_ID={$item.BUSINESS_ID}&{$filter}" class="active">{$item1.SUPPLIER_NAME}</a></li>
                    {else}
                        <li class="{$l3class}"><a href="?{$menuObj->getParam2()}&SUPPLIER_ID={$item1.SUPPLIER_ID}&BUSINESS_ID={$item.BUSINESS_ID}&{$filter}">{$item1.SUPPLIER_NAME}</a></li>
                    {/if}
                {/foreach}
            </ul>
        {/foreach}
    </div> <!-- End of nav -->
</div>   <!-- End of left_part -->


     <!-- begin right part -->
     <div id="right_part">  {*---right_part div is closed in footer.tpl---*}
     {include file="visulate-submenu.tpl"}
<div class="col-md-12">
{$script}

    <form {$form_data.attributes}>
    {if ($isEdit eq "true")}
       <b>{$form_data.searchFilter.label}</b> {$form_data.searchFilter.html} <input type="submit" name="filterApply" value="Search"><br>    
    {/if}
    <h1>{$header_title}</h1>
    {show_error info=$errorObj}

    <table class="datatable1">
            {foreach from=$form_data item=element}
                  {if ( (@($element.type == "text" || $element.type == "textarea" || $element.type == "select" || $element.type == "lov")) && ($element.name != "searchFilter")) }
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
                             { if (@$element.required) } <span class="error">*</span> {/if}
                          </td>
                    </tr>
                   {/if}
               {/foreach}
            {if ($isEdit eq "true")}
                       <tr>
                         <td colspan="2" align="right" style="text-align:right">
                         {$form_data.new.html} {$form_data.delete.html}
                        </td>
                     </tr>
            {/if}
    </table>
            {$form_data.hidden}
    
   <table class="datatable">
            <tr>
              <th>Business Units</th>
              <th>SSN</th>
              <th>Notes</th>
              {if ($isEdit eq "true")}
                   <th></th>
              {/if}
            </tr>
            {foreach from=$form_data.BUSINESS_UNITS item=element}
                 <tr>
                {foreach from=$element item=element2}
                    {if @($element2.type == "text" || $element2.type == "textarea" || $element2.type == "select" || $element2.type == "link" || $element2.type == "lov")}
                        <td valign="top">
                        {if @(@$element.error)}
                                <span class="error">{$element2.error}</span>
                        {/if}
                        {$element2.html}
                        </td>
                    {/if}
                {/foreach}
                </tr>
               {/foreach}
            {if ($isEdit eq "true")}
            <tr>
               <td style="text-align:right" colspan="4">
                 {$form_data.new_bu.html}
               </td>
            </tr>
            {/if}
        </table>

    {if ($isEdit eq "true")}
            {$form_data.cancel.html} {$form_data.accept.html}
    {/if}

    
    
<h3>Payments</h3>
            <table class="datatable">
                <tr height=30>
                       <td colspan=4><b>Year</b>&nbsp;&nbsp;
                           <select style="width:150px;" onchange="document.location.href='{$link}&YEAR='+this.value;">
            {foreach from=$arr_years item=year_}
                        <option value="{$year_}">{$year_}</option>
               {/foreach}
                           </select>
                       </td>
                </tr>
                <tr height=30>
                       <th colspan=2></th>
                       <th width=110>Amount Owed</th>
                       <th width=110>Amount Paid</th>
                </tr>
                <tr height=30>
                       <td colspan=2 style="color: #012e5c; font-weight: bold;">Total</td>
                       <td>{$total_amount_owed}</td>
                       <td>{$total_amount_paid}</td>
                </tr>
                <tr height=30>
                      <th width=70>Date</th>
                      <th width=100>Property</th>
                       <th width=100>Amount Owed</th>
                       <th width=100>Amount Paid</th>
                </tr>
            {foreach from=$form_data_ item=element}
                <tr height=30>
                       <td>{$element.DATE_}</td>
                       <td>{$element.PROPERTY_}</td>
                       <td>{$element.OWED_}</td>
                       <td>{$element.PAID_}</td>
                </tr>
               {/foreach}
            </table>
</form>    
    
</div>
{include file="footer.tpl"}