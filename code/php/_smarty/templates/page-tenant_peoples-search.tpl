{include file="top.tpl"}
<script language="javascript">
  function addBU_old(business_id, people_id){ldelim}
    var divName = 'div_'+business_id+'_'+people_id;
    var url = '{$PATH_FROM_ROOT}php/addBU-peoples-search.php?'+Object.toQueryString({ldelim}business_id: business_id, people_id : people_id{rdelim});
    var myAjax = new Ajax(url, {ldelim}method: 'get', 
	                                   update: divName
						       {rdelim} );
	myAjax.request();
  {rdelim}

  function addBU(e, business_id, people_id) {ldelim}
      e.preventDefault();
      var LEAD    = 'LEAD';
      var TENANT  = 'TENANT';
      var $form   = $('form_people_'+people_id);
      var inclusion_type =  $form.getElements('input[name=inclusion_type]').filterByAttribute('checked').getValue();
          inclusion_type =  String(inclusion_type).toUpperCase();
      var myAjax  = new Ajax(
          '{$PATH_FROM_ROOT}php/addBU-peoples-search.php',
          {ldelim}
              method: 'post',
              data:   {ldelim}
                  business_id:    business_id,
                  people_id:      people_id,
                  inclusion_type: inclusion_type
              {rdelim},
              onComplete: function(){ldelim}
                  if (inclusion_type.toUpperCase() == LEAD) {ldelim}
                      // clear other Lead labels
                      $$('div.buPeople_'+people_id).each(function(item){ldelim}
                          $(item).getElement('.leadLabel').setText('');
                      {rdelim});
                      // set Lead label
                      $('div_'+business_id+'_'+people_id).getElement('.leadLabel').setText(LEAD.toLowerCase().capitalize());
                  {rdelim}
                  else if (inclusion_type.toUpperCase() == TENANT) {ldelim}
                      var $item  = $('div_'+business_id+'_'+people_id);
                      var buName = $item.getElement('.buLabel').getFirst().getText();
                      // replace element <a> with element <span>
                      $item.getElement('.buLabel').getFirst().remove();
                      $item.getElement('.buLabel').setHTML("<span>"+buName+"</span>").setStyle("color","#aaaaaa");
                      // set Tenant label
                      $item.getElement('.tenantLabel').setText(TENANT.toLowerCase().capitalize());
                  {rdelim}
              {rdelim}
          {rdelim}
      );
      myAjax.request();
  {rdelim}


</script>
  <div id="main">
    <!-- begin content -->
    <div id="content">
      <!-- begin left part -->

     <!-- end left part -->
     <!-- begin right part -->
     <div id="right_part"> 
{include file="visulate-submenu.tpl"}
<div class="col-md-6">
    <form {$form_data.attributes}>
        <p>
        Use this screen to find people who are already recorded in Visulate.  Once
        found you can click on a link to include them in your business unit.
        </p>
        <table class="datatable">
            <tr>
                <th colspan="2">Tip: use "%" as a wildcard character.</th>
            </tr>
                {foreach from=$form_data item=element}
                    {if ($element.type == "text" || $element.type == "checkbox" || $element.type == "select" || $element.type == "lov")}
                        <tr>
                            <th style="text-align:right">{$element.label}</th>
                            <td valign="middle">
                                {$element.html}
                                {if ($element.required) }
                                    <span class="error">*</span>
                                {/if}
                            </td>
                        </tr>
                    {/if}
                {/foreach}
            <tr>
                <td colspan="2" style="text-align:right">
                    {$form_data.find.html}
                    {$form_data.new.html}
                    {$form_data.hidden}
                </td>
            </tr>
        </table>
    </form>
</div>

<div class="col-md-6">
    <small>Click on link "Business Unit Name"  to include person in Business Unit.</small><br>
    {if ($warning neq "")}
      <b>{$warning}</b>
    {/if}
    <table width="600px">
    {foreach from=$data item=item key=key}
            <tr>
                <td colspan="2" style="border-bottom:1px dotted #006600">
                    <form id="form_people_{$item.PEOPLE_ID}">
                        <br>
                        <b style="font-size:120%">{$key+1}. {$item.LAST_NAME} {$item.FIRST_NAME} </b>
                        {if ($item.EMAIL_ADDRESS neq "")}
                            <br>&nbsp;&nbsp;&nbsp;E-mail: <i>{$item.EMAIL_ADDRESS}</i>
                        {/if}
                        <strong>&nbsp;&nbsp;
                            <input type="radio" name="inclusion_type" value="Lead" checked="checked" style="vertical-align: middle;"/>&nbsp;Lead
                        </strong>
                        <strong>&nbsp;&nbsp;
                            <input type="radio" name="inclusion_type" value="Tenant" style="vertical-align: middle;"/>&nbsp;Tenant
                        </strong>
                    </form>
                </td>
            </tr>
            {section name=bus loop=$item.BUSINESS_UNITS}
                {if ($smarty.section.bus.index is even)}
                    <tr>
                {/if}
                <td>
                    <div class="buPeople_{$item.PEOPLE_ID}" id="div_{$item.BUSINESS_UNITS[bus].BUSINESS_ID}_{$item.PEOPLE_ID}">
                        <span class="buLabel">
                            {*{if ($item.BUSINESS_UNITS[bus].IS_INCLUDED eq "Y")}*}
                                {*<span style="color:#aaaaaa">{$item.BUSINESS_UNITS[bus].BUSINESS_NAME}</span>*}
                            {*{else}*}
                                {*<a href="#" onclick="return addBU(event, {$item.BUSINESS_UNITS[bus].BUSINESS_ID}, {$item.PEOPLE_ID});">{$item.BUSINESS_UNITS[bus].BUSINESS_NAME}</a>*}
                            {*{/if}*}
                            <a href="#" {if ($item.BUSINESS_UNITS[bus].IS_INCLUDED eq "Y")}style="color:#aaaaaa"{/if} onclick="return addBU(event, {$item.BUSINESS_UNITS[bus].BUSINESS_ID}, {$item.PEOPLE_ID});">{$item.BUSINESS_UNITS[bus].BUSINESS_NAME}</a>
                        </span>

                        <span class="tenantLabel" style="color:#141414;font-weight: bold;">
                            &nbsp;&nbsp;{if ($item.BUSINESS_UNITS[bus].IS_TENANT eq "Y")}Tenant{/if}
                        </span>

                        <span class="leadLabel" style="color:#141414;font-weight: bold;">
                            &nbsp;&nbsp;{if ($item.BUSINESS_UNITS[bus].IS_LEAD eq "Y")}Lead{/if}
                        </span>
                    </div>
                </td>
                {if ($smarty.section.bus.index is not even)}
                    </tr>
                {/if}
            {/section}
    {/foreach}
    </table>
</div>
{include file="footer.tpl"}
