{include file="header2.tpl"}

{$script}

<form {$form_data.attributes}>
    <div class="col-md-6">
        <h3>Current Status</h3>

        {$form_data.hidden}

        {show_error info=$errorObj}

        <table class="datatable" style="font-size:12px">
        <tr>
            <td width="450" style="background-color:#7bb347;color:#ffffff">
                <b>Property</b>
            </td>
            <td width="150" style="background-color:#7bb347;color:#ffffff;text-align:center">
                <b>Status</b>
            </td>
        </tr>
        {foreach from=$form_data.PROPERTIES item=element}
		    {*if ($element.type == "text" || $element.type == "lov")*}
                <tr>
                    <td>
                        {$element.STATUS.label}
                    </td>
                    <td>
                        {$element.STATUS.html}
                    </td>
                </tr>
            {*/if*}
        {/foreach}
        </table>
    </div>

    <div class="col-md-4">
        <h3>&nbsp;</h3>
        <div class="actionDiv">
            <h3>Actions</h3>
            {$form_data.cancel.html} {$form_data.save.html}

        </div>
    </div>
</form>


<div class="col-md-4">
    <div class="actionDiv">
        <h3>Spreadsheet <sup><a href="?{$menuObj->getParam2()}&type=status&BUSINESS_ID={$businessID}&IS_SPREADSHEET_DOWNLOAD=1" target="_blank"><img heigth="16" width="16" src="{$PATH_FROM_ROOT}images/excel-icon-16.gif"></a></sup></h3>
        {if ($downloadSpreadsheetFileError)}
            <span class="error">{$downloadSpreadsheetFileError}</span>
        {/if}
        <form action="" method="POST" enctype="multipart/form-data">
            <input type="hidden" name="IS_SPREADSHEET_UPLOAD" value="1" />
            <input type="hidden" name="MAX_FILE_SIZE" value="2000000" />
            <input type="hidden" name="{$menuObj->request_menu_level2}" value="{$menuObj->current_level2}" />
            <input type="hidden" name="type" value="status" />
            <input type="hidden" name="BUSINESS_ID" value="{$businessID}" />
            <table class="datatable1" width="97%">
                {if ($uploadSpreadsheetFileError)}
                    <tr>
                        <td colspan="2">
                            <span class="error">{$uploadSpreadsheetFileError}</span>
                        </td>
                    </tr>
                {elseif ($uploadSpreadsheetFileOk)}
                    <tr>
                        <td colspan="2">
                            <span style="color: #529214;">{$uploadSpreadsheetFileOk}</span>
                        </td>
                    </tr>
                {/if}
                <tr>
                    <th>
                        File<span class="error">*</span>
                    </th>
                    <td style="text-align:right">
                        <input size="30" type="file" name="spreadsheetFile" value="">
                    </td>
                </tr>
                <tr>
                    <td colspan="2" style="text-align:right">
                        <input type="submit" name="uploadSpreadsheet" value="Upload">
                    </td>
                </tr>
            </table>
        </form>
    </div>
</div>

{include file="footer.tpl"}
