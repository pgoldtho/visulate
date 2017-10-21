{include file="top.tpl"}

{literal}
<script type="text/javascript">
    jQuery(document).ready(function($) {
        $("#formLeadDetails").submit(function(event){
            // Get some values from elements on the page:
            var $form  = $('form[name="formPeople"]')
            ,   params = $form.serializeArray()
            ,   url    = $form.attr("action");

            // Send the data using sync post
            $.ajaxSetup({async:false});
            var posting = $.post(url, params);

            // Put the results in a div
            posting.done(function( data ) {
                $.ajaxSetup({async:true});
                var response = $.parseJSON(data);
            });
        });

        $("#property-search").click(function(event){
            event.preventDefault();
            event.stopPropagation();
            var w = window.open("about:blank", "_blank", "scrollbars=yes, resizable=yes, top=100, left=450, width=640, height=480");
            var text= "<html>\n"
                    + "  <head>\n"
                    + "     <title>Property Search</title>\n"
                    + "  </head>\n"
                    + "<body>\n"
                    + "<form action=\"visulate_search.php?REPORT_CODE=PROPERTY_DETAILS\" method=\"post\">\n"
                    + "<label for=\"ADDR\">Address:</label> <input size=\"30\" maxlength=\"80\" id=\"ADDR\" name=\"ADDR\" type=\"text\" />\n"
                    + "<input name=\"submit_html\" value=\"Search\" type=\"submit\" />\n"
                    + "</form>\n"
                    + "</body>\n"
                    + "</html>";
            w.document.write(text);
            w.document.close();
        });
    });
</script>
{/literal}

<!-- begin main -->
<div id="main">
    <!-- begin content -->
    <div id="content">
        <!-- begin left part -->
        <div id="left_part">    {*---menu level 3---*}
            <div id="nav">
                <script src="{$PATH_FROM_ROOT}/html/peoples.js" language="javascript"></script>
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
                    <ul  class="left_menu"  style="display:{$display}">
                        {assign var="l3class" value="li_left_last"}
                        {if (is_array($item.PEOPLES) && count($item.PEOPLES) > 0)}
                            {assign var="l3class" value="li_left_first"}
                        {/if}
                        <li class="{$l3class}">
                            <a class="small" href="?{$menuObj->getParam2()}&BUSINESS_ID={$item.BUSINESS_ID}&action=INSERT">
                                <b>People - New</b>
                            </a>
                        </li>
                        {foreach from=$item.PEOPLES item=item1 name=l3menu}
                            {if $smarty.foreach.l3menu.last }
                                {assign var="l3class" value="li_left_last"}
                            {elseif $smarty.foreach.l3menu.first }
                                {assign var="l3class" value="li_left_first"}
                            {else}
                                {assign var="l3class" value="li_left_normal"}
                            {/if}
                            {if ($item1.PEOPLE_ID eq $peopleID && $item.BUSINESS_ID eq $businessID)  }
                                <li class="{$l3class}"><a href="?{$menuObj->getParam2()}&PEOPLE_ID={$item1.PEOPLE_ID}&BUSINESS_ID={$item.BUSINESS_ID}" class="active">{$item1.PEOPLE_NAME}</a></li>
                            {else}
                                <li class="{$l3class}"><a href="?{$menuObj->getParam2()}&PEOPLE_ID={$item1.PEOPLE_ID}&BUSINESS_ID={$item.BUSINESS_ID}">{$item1.PEOPLE_NAME}</a></li>
                            {/if}
                        {/foreach}
                    </ul>
                {/foreach}
            </div> <!-- End of nav -->
        </div>   <!-- End of left_part -->

        <!-- begin right part -->
        <div id="right_part">  {*---right_part div is closed in footer.tpl---*}
        {include file="visulate-submenu.tpl"}
            <h1>{$header_title}</h1>

            {show_error info=$errorObj}

            <div class="col-md-6">
                <form {$form_data.attributes}>
                <table class="datatable1">
                    {foreach from=$form_data item=element}
                        {if ($element.type == "text" || $element.type == "checkbox" || $element.type == "select")}
                            {if ($element.error)}
                                <tr>
                                    <td colspan="2">
                                        <span class="error">{$element.error}</span>
                                    </td>
                                </tr>
                            {/if}
                            <tr>
                                <th>{$element.label}</th>
                                <td valign="middle">
                                    {$element.html}{calendar form="formPeople" elements=$dates current=$element.name}
                                    {if ($element.required) } <span class="error">*</span> {/if}
                                </td>
                            </tr>
                        {/if}
                    {/foreach}
                    <tr>
                        <td colspan="2" align="right" style="text-align:right">
                            {foreach from=$form_data item=element}
                                {if ($element.type == "submit")}
                                    {$element.html}
                                {/if}
                            {/foreach}
                        </td>
                    </tr>
                    {if ($warning.flag != "")}
                        <tr>
                            <td colspan="2" align="left">
                                {if ($warning.flag == "!")}
                                    <span style="color:red">
                                {else if ($warning.flag == "-")}
                                    <span style="color:green">
                                {/if}
                                {$warning.message}
                                </span>
                            </td>
                        </tr>
                    {/if}
                    </table>
                    {$form_data.hidden}
                </form>
            </div>

            <div class="col-md-6">
                {if (count($formFindPropertyErrors))}
                    <div class="notice">
                        {foreach from=$formFindPropertyErrors item=error}
                            <span class="error">{$error}</span><br/>
                        {/foreach}
                    </div>
                {/if}
                <form {$form_find_property_data.attributes}>
                    {$form_find_property_data.hidden}
                    <a id="property-search" href="#">Search Property Details</a>
                    <br/>
                    {foreach from=$form_find_property_data item=element}
                        {if ($element.type == "text" || $element.type == "checkbox" || $element.type == "select")}
                            <label for="{$element.name}">{$element.label}</label> {$element.html}
                        {/if}
                    {/foreach}
                    {$form_find_property_data.findPropertyByRefId.html}

                    {if ($form_find_property_data.REF_PROPERTY_ID.value)}
                        <div>
                            <a href="http://visulate.com/property/{$form_find_property_data.REF_PROPERTY_ID.value}" target="_blank">
                                http://visulate.com/property/{$form_find_property_data.REF_PROPERTY_ID.value}
                            </a>
                        </div>
                        <br/>
                        {if ($form_find_property_photos)}
                            <script type="text/javascript" src="{$PATH_FROM_ROOT}/html/noobSlide/noobSlide-min.js"></script>
                            {literal}
                                <script type="text/javascript">
                                    window.addEvent('domready',function(){
                                        var hs2 = new noobSlide({
                                            box: $('box2'),
                                            items: [1,2,3,4,5],
                                            size: 340,
                                            interval: 3000,
                                            fxOptions: {
                                                duration: 1000,
                                                transition: Fx.Transitions.Bounce.easeOut,
                                                wait: false
                                            },
                                            buttons: {
                                                previous: $('prev1'),
                                                play: $('play1'),
                                                stop: $('stop1'),
                                                next: $('next1')
                                            }
                                        });
                                    });
                                </script>
                                <style type="text/css">
                                    .sample{padding:20px 30px; margin:4px 0 25px 0; border:1px solid #e1e1e1}
                                    .buttons{padding:5px;}
                                    .buttons span{color:#0080FF;padding:0 5px;cursor:pointer;font:10px Verdana}
                                    .buttons span.active, .buttons span:hover{background:#0080FF;color:#fff}
                                    .mask2 { position:relative; width:340px; height:250px; overflow:hidden; }
                                    #box2 { position:absolute; }
                                    #box2 span { display:block; float:left; }
                                    #box2 span img { display:block; border:none; }
                                </style>
                            {/literal}

                            <div class="mask2">
                                <div id="box2">
                                    {foreach from=$form_find_property_photos item=photo}
                                        <span><img src="{$photo.URL}" style="width:340px; height:250px;" alt="Photo" /></span>
                                    {/foreach}
                                </div>
                            </div>
                            <p class="buttons">
                                <span id="prev1">&lt;&lt; Previous</span>
                                <span id="play1">Play &gt;</span>
                                <span id="stop1">Stop</span>
                                <span id="next1">Next &gt;&gt;</span>
                            </p>
                        {elseif ($street_view_url)}
                            <div>
                                <img src="{$street_view_url}" style="width:340px; height:250px;" alt="Google Street View" />
                            </div>
                        {/if}
                    {/if}
                </form>
            </div>
            <div class="col-md-12">


            <h1>Lead Details</h1>
            {if (count($leadDetailsErrors))}
                <div class="notice">
                    {foreach from=$leadDetailsErrors item=error}
                        <span class="error">{$error}</span><br/>
                    {/foreach}
                </div>
            {/if}
            </div>
            <form {$form_lead_details.attributes}>
                {$form_lead_details.hidden}
                <div class="col-md-4">
                    <div class="field-row">
                        <div class="label">{$form_lead_details.LEAD_TYPE.label}</div>
                        <div class="field">{$form_lead_details.LEAD_TYPE.html}</div>
                    </div>
                    <div class="field-row">
                        <div class="label">{$form_lead_details.status.label}</div>
                        <div class="field">{$form_lead_details.status.html}</div>
                    </div>
                    <div class="field-row">
                        <div class="label">{$form_lead_details.UCODE.label}</div>
                        <div class="field">{$form_lead_details.UCODE.html}</div>
                    </div>
                    <div class="field-row">
                        <div class="label">{$form_lead_details.CITY.label}</div>
                        <div class="field">{$form_lead_details.CITY.html}</div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="field-row">
                        <div class="label">{$form_lead_details.FOLLOW_UP.label}</div>
                        <div class="field">{$form_lead_details.FOLLOW_UP.html} Days</div>
                    </div>
                    <div class="field-row">
                        <div class="label">{$form_lead_details.MIN_PRICE.label}</div>
                        <div class="field">
                            {$form_lead_details.MIN_PRICE.html}
                            {$form_lead_details.MAX_PRICE.label}
                            {$form_lead_details.MAX_PRICE.html}
                        </div>
                    </div>
                    <div class="field-row">
                        <div class="label">{$form_lead_details.LTV_TARGET.label}</div>
                        <div class="field">
                            {$form_lead_details.LTV_TARGET.html}% &nbsp;&nbsp;&nbsp;&nbsp;
                            {$form_lead_details.LTV_QUALIFIED_YN.html}
                            {$form_lead_details.LTV_QUALIFIED_YN.label}
                        </div>
                    </div>
                </div>
                <div class="clear"></div>
                {$form_lead_details.DESCRIPTION.html}
                <div class="clear"></div>
                {$form_lead_details.saveLead.html}
            </form>


            <div class="col-md-12">
                <h1>Lead Actions</h1>
                {if (count($leadActionsToolbarFormErrors))}
                    <div class="notice">
                        {foreach from=$leadActionsToolbarFormErrors item=error}
                            <span class="error">{$error}</span><br/>
                        {/foreach}
                    </div>
                {/if}
                <form {$form_lead_actions_toolbar.attributes}>
                    {$form_lead_actions_toolbar.hidden}
                    {if ($isEdit eq "true")}
                        {$form_lead_actions_toolbar.TEMPLATE.html}
                        {$form_lead_actions_toolbar.s_new_action.html}
                    {/if}
                    {if ($prev_agreement) }
                        <input type="submit" name="s_prev_agreement" value="Prev agreement">
                    {else}
                        <input type="submit" name="s_prev_agreement" value="Prev agreement" disabled="disabled">
                    {/if}

                    {if ($next_agreement)}
                        <input type="submit" name="s_next_agreement" value="Next agreement">
                    {else}
                        <input type="submit" name="s_next_agreement" value="Next agreement" disabled="disabled">
                    {/if}
                </form>
                <table class="datatable" width="100%">
                    <tr>
                        {if ($isEdit eq "true")}
                            <th></th>
                        {/if}
                        <th>Date <span class="error">*</span></th>
                        <th>Action <span class="error">*</span></th>
                        <th>Broker <span class="error">*</span></th>
                        {if ($isEdit eq "true")}
                            <th></th>
                        {/if}
                    </tr>
                    {foreach from=$leadActionList item=element}
                        {if ($element.ACTION_ID == $currentLeadActionID) }
                            <form {$form_lead_actions.attributes}>
                                <tr>
                                    <td style="background-color:#eeeeee"></td>
                                    <td>{$form_lead_actions.ACTION_DATE.html}{calendar elements=$dates current=ACTION_DATE}</td>
                                    <td>{$form_lead_actions.ACTION_TYPE.html}</td>
                                    <td>{$form_lead_actions.BROKER_ID.html}</td>
                                    <td style="background-color:#eeeeee"></td>
                                </tr>
                                <tr>
                                    <td colspan="5" style="text-align:center;background-color:#eeeeee">
                                        {$ckEditor->editor('ACTION_DESCRIPTION', $leadActionText, $cke_config)}
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="5" style="background-color:#eeeeee">
                                        {$form_lead_actions.acceptLeadAction.html}
                                        {$form_lead_actions.cancelLeadAction.html}
                                    </td>
                                </tr>
                                {$form_lead_actions.hidden}
                            </form>
                        {else}
                            <tr>
                                {if ($isEdit eq "true")}
                                    <td>{$element.EDIT_LINK}</td>
                                {/if}
                                <td>{$element.ACTION_DATE}</td>
                                <td>{$element.ACTION_TYPE}</td>
                                <td>{$element.BROKER_ID}</td>
                                {if ($isEdit eq "true")}
                                    <td>{$element.DELETE_LINK}</td>
                                {/if}
                            </tr>
                        {/if}
                    {/foreach}
                </table>
            </div>

            <br/>
            <h1>Tenancy Agreements</h1>
            <table class="datatable">
            <tr align="center">
                 <th>Property</th>
                 <th>Unit name</th>
                 <th>Start date</th>
                 <th>End date</th>
                 <th>Amount due</th>
                 <th>Amount paid</th>
             </tr>
            {foreach from=$peopleAgreements item=item}
             <tr>
                 <td style="text-align:center">{$item.ADDRESS1}</td>
                 <td style="text-align:center">{$item.UNIT_NAME}</td>
                 <td style="text-align:center">
                     {if ($item.BUSINESS_ID eq $businessID)}
                         <a href="?m2=tenant_agreements&prop_id={$item.PROPERTY_ID}&AGR_AGREEMENT_ID={$item.AGREEMENT_ID}">
                             {$item.AGREEMENT_DATE|date_format:"%m/%d/%Y"}
                         </a>
                     {else}
                         {$item.AGREEMENT_DATE|date_format:"%m/%d/%Y"}
                     {/if}
                 </td>
                 <td style="text-align:center">{$item.END_DATE|date_format:"%m/%d/%Y"}</td>
                 <td style="text-align:right">
                     {if ($item.BUSINESS_ID eq $businessID)}
                         <a href="?m2=tenant_tenants&prop_id={$item.PROPERTY_ID}&TENANT_ID={$item.TENANT_ID}">
                             {show_number number=$item.AMOUNT_DUE}
                         </a>
                     {else}
                         {show_number number=$item.AMOUNT_DUE}
                     {/if}
                 </td>
                 <td style="text-align:right">
                     {show_number number=$item.AMOUNT_PAID}
                 </td>
             </tr>
            {/foreach}
             </table>

{include file="footer.tpl"}
