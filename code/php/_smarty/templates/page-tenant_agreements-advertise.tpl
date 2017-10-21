{include file="top.tpl"}

{literal}
<script type="text/javascript">
    function set_image(img_name) {
        document.getElementById('mainPicture').src = img_name;
    }
</script>
{/literal}

<!-- begin main -->
<div id="main">
    <div id="content">
        <!-- begin left part -->
        <div id="left_part">    {*---menu level 3---*}
            <div id="nav">
                <h2 class="title">Pictures</h2>
                <ul class="left_menu">
                    {foreach from=$photos_list item=value name="l3menu"}
                        {if $smarty.foreach.l3menu.last }
                            {assign var="l3class" value="li_left_last"}
                        {elseif $smarty.foreach.l3menu.first }
                            {assign var="l3class" value="li_left_first"}
                            {assign var="first_img" value=$value.VGA_FILENAME}
                        {else}
                            {assign var="l3class" value="li_left_normal"}
                        {/if}

                        <li class="{$l3class}">
                            &nbsp;&nbsp;&nbsp;&nbsp;
                             <a href="javascript:void(0);"
                               onclick="window.open('{$value.LARGE_PHOTO_FILENAME}', '_blank', 'toolbar=no')"
                                                           onmouseover="set_image('{$value.VGA_FILENAME}');">
                                                          <img class="thumbnail_img"
                                                                 alt="{$value.PHOTO_TITLE}"
                                                                     title="{$value.PHOTO_TITLE}"
                                                                     src="{$value.PHOTO_FILENAME}"></a>
                        </li>
                    {/foreach}
                </ul>
            </div>
        </div>

        <!-- begin right part -->
        <div id="right_part">   {*---right_part div is closed in footer.tpl---*}
        {include file="visulate-submenu.tpl"}
{show_error info=$errorObj}
<form {$form_data.attributes}>
    {$form_data.hidden}
    <br>

    <div class="col-md-12">
        {if ($isEdit == "true")}
        {*---- Property title ----*}
        {if ($form_data.ad_title.error)}
            <span class="error">{$form_data.ad_title.error}</span>
        {/if}
           <h2>{$form_data.ad_title.label}{$form_data.ad_title.html}
               {if ($form_data.ad_title.required) } <span class="error">*</span> {/if}
           </h2>
           <img id="mainPicture" src="{$first_img}"  class="vga_img"/>

           {*---- Action ----*}
           <div class="actionDiv" style="width:640px; margin-top: 5px;">
           {if ($role == "ADVERTISE")}
            <h3>Instructions (page 4 of 4)</h3>
        {else}
            <h3>Instructions</h3>
        {/if}
            <p>
                Enter the the title, property description, unit description
                and contact details that you want to display in your advertisement.
                Check the "Publish" Action and press "Save" to publish your
                advertisement.  Check "Don't Publish" to hide your listing.
                <p>
                Mouse over the pictures on the left of the page to see a larger version
                displayed above.  Click on the picture to see a full size image.</p>
            </p>
            <p>{$advertise_home}{$advertise_view}</p>
            <div style="clear: both"><br/></div>
        </div>

        {*---- Property and Unit description ----*}
        <br>
        <h3>{$unit_info.UNIT_BEDROOMS} bedroom, {$unit_info.UNIT_BATHROOMS} bathroom - ${$agreement_info.AGR_AMOUNT} per {$agreement_info.AGR_AMOUNT_PERIOD|lower}</h3>
        <p>
            {if ($form_data.property_description.error)}
                <span class="error">{$form_data.property_description.error}</span> <br />
            {/if}
            <strong>{$form_data.property_description.label}</strong>
                    {if ($form_data.property_description.required) } <span class="error">*</span> {/if}
            <br>{$form_data.property_description.html}
        </p>
        <p>
            <strong>{$form_data.unit_description.label}</strong>
            <br>{$form_data.unit_description.html}
        </p>

        {*---- Contact information ----*}
        <div class="col-md-6">
            <table class="datatable">
                {foreach from=$form_data item=element}
                    {if  ($element.name == "ad_contact" || $element.name == "ad_phone" || $element.name == "ad_email")}
                        {if ($element.error)}
                              <tr>
                                  <td colspan="2">
                                    <span class="error">{$element.error}</span>
                                </td>
                            </tr>
                        {/if}    {*---element.error---*}
                        <tr>
                            <th>{$element.label}</th>
                            <td>
                                {$element.html}
                                { if ($element.required) } <span class="error">*</span> {/if}
                            </td>
                        </tr>
                    {/if}    {*---element name---*}
                {/foreach}
            </table>
        </div>
        <div class="col-md-4">
            <table class="datatable">
            <tr>
                <th>Actions</th>
                <td>{$form_data.action.html}</td>
            </tr>
            <tr>
                <th></th>
                <td>{$form_data.save.html} {$form_data.cancel.html} </td>
            </tr>
            </table>
        </div>
        {else} {*---isEdit---*}
            <img id="mainPicture" src="{$first_img}"  class="vga_img"/>

            <div class="actionDiv" style="width:640px; margin-top: 5px;">
                <h3>Instructions and Actions</h3>
                <p>
                  This page is used to advertise tenancy agreements on the Visulate
                  website.  Your user role does not allow you to do this.  Click on the
                  "Change Role" link at the top of the page and select a different role
                  if you need to advertise this agreement.     Mouse over
                  the pictures on the left of the page to see a larger version
                  displayed above.  Click on the picture to see a full size image.
                </p>
                <p>{$advertise_home}{if $publish_flag eq "Y"}{$advertise_view}{/if}</p>
                <div style="clear: both"><br/></div>
            </div>
        {/if} {*--- isEdit ----*}
    </div>
</form>

{include file="footer.tpl"}