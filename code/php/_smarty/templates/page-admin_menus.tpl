{include file="top.tpl"}
  <!-- begin main -->
  <div id="main">
    <!-- begin content -->
    <div id="content">
      <!-- begin left part -->

<div id="left_part">
<div id="nav">

{literal}



<script src="html/jqTreeview/lib/jquery.js" type="text/javascript"></script>
<script src="html/jqTreeview/lib/jquery.cookie.js" type="text/javascript"></script>
<script src="html/jqTreeview/jquery.treeview.js" type="text/javascript"></script>
<script type="text/javascript">
jQuery.noConflict();

jQuery(document).ready(function(){    
    jQuery("#browser").treeview({
        collapsed: true,
        unique: true,
        persist: "location"
    });
    jQuery("#browser").addClass("filetree");
});
</script>
{/literal}

<h2 class="title"><a href="#">Menu Structure</a></h2>
<div class="treeview-header">{show_tree data=$menu_tree}</div>
<div class="treeview-footer"></div>


</div> <!-- end "nav" menu -->
</div> <!-- end left part -->

<!-- begin right part -->
<div id="right_part">  {*---right_part div is closed in footer.tpl---*}

{show_error info=$errorObj}

    <h3 style="color: #41464d;">Menu Item</h3>
    <form {$form_data.attributes}>
    <div class="col-md-4">
      {$form_data.hidden}
      <table class="datatable1" cellpadding="0" cellspacing="0" width="250px">
      <tbody>
      <tr>
        <th>{$form_data.TAB_TYPE.label}</th>
        <td>{$form_data.TAB_TYPE.html}</td>
      </tr>
      <tr>
        <th>{$form_data.PARENT_TAB.label}</th>
        <td>{$form_data.PARENT_TAB.html}</td>
      </tr>
      <tr>
        <th>{$form_data.DISPLAY_SEQ.label}</th>
        <td>
            {$form_data.DISPLAY_SEQ.html}
            {if @($form_data.DISPLAY_SEQ.error)}
                <br><span class="error">{$form_data.DISPLAY_SEQ.error}</span>
            {/if}
       </td>
      </tr>
      <tr>
        <th>{$form_data.TAB_NAME.label}<span class="error">*</span></th>
        <td>
            {$form_data.TAB_NAME.html}
            {if @($form_data.TAB_NAME.error)}
                <br><span class="error">{$form_data.TAB_NAME.error}</span>
            {/if}
        </td>
      </tr>
      <tr>
        <th>{$form_data.TAB_TITLE.label}<span class="error">*</span></th>
        <td>
            {$form_data.TAB_TITLE.html}
            {if @($form_data.TAB_TITLE.error)}
                <br><span class="error">{$form_data.TAB_TITLE.error}</span>
            {/if}
        </td>
      </tr>
      <tr>
        <th>{$form_data.TAB_HREF.label}</th>
        <td>{$form_data.TAB_HREF.html}</td>
      </tr>
      </tbody>
      </table>
      <br>
      {$form_data.action_new.html}
      {$form_data.action_save.html}
      {$form_data.action_cancel.html}
      {$form_data.action_delete.html}
    </div>
    <div class="col-md-4">
      <table class="datatable1" border="0" cellpadding="0" cellspacing="0" width="200px">
      <tbody>
      <tr>
        <th>Role</th>
        <th>Display</th>
      </tr>
      {foreach from=$form_data.TAB_ROLES item=element}
          <tr>
              <th>{$element.IS_ALLOWED_YN.label}</th>
              <td><center>{$element.IS_ALLOWED_YN.html}</center></td>
          </tr>
      {/foreach}
      </tbody>
      </table>
    </div>
    </form>
  </div>


{include file="footer.tpl"}