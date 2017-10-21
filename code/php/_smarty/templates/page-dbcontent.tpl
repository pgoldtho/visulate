{include file="top.tpl"}
<script src="{$PATH_FROM_ROOT}/html/peoples.js" language="javascript"></script>
{if $is_editor}

{literal}
<style>
.local_block {
    text-align:right;
    padding-right:25px;
}
.local_block a:active {
    color: blue;
}
.local_block a:visited {
    color: blue;
}
.highlight {
    background-color: #489A1B;
}

.ajax-loading {
background:url("html/spinners/spinner.gif") no-repeat scroll center center transparent;
padding:20px 0;
}
</style>

<script type="text/javascript">
   function show_block(p_block_id)
   {
       var blocks = new Array('dbcontent_container', 'dbcontent_editor', 'menu_editor');
       var block_style = "";
       for(i in blocks) {
           if (typeof blocks[i] == 'string') {
               block_style = (blocks[i] == p_block_id) ? 'block' : 'none';
               document.getElementById(blocks[i]).style.display = block_style;
           }
       }
   };

   function show_menu_editor()
   {
       show_block("menu_editor");
       $('menus').empty();
       $('menu_items').empty()
       refresh_menu();
       
       return false;
   }

   /**
    * Convert data of the DOM element to JSON object
    * Note: data is the values in input, select and textarea child elements.
    * 
    * @param  object  obj  the DOM element
    * @return object  a JSON object
    */
   function toJSON(obj)
   {
       var selector = new Array();
       selector.extend($(obj).getElements('input'));
       selector.extend($(obj).getElements('select'));
       selector.extend($(obj).getElements('textarea'));
       
       var json = {};
       $$(selector).each(
           function(item, index)
           {
               if (   item.name
                   && item.type != "reset"
                   && item.type != "submit"
                   && item.type != "button")
               {
                   if (json[item.name]) {
                       if (!json[item.name].push) {
                           json[item.name] = [json[item.name]];
                       }
                       json[item.name].push(escape(item.value) || '');
                   } else {
                       json[item.name] = escape(item.value) || '';
                   }
               }
           }
       );

       return json;
   }
   
   /**
    * Convert form data to JSON
    *
    * @param  object  obj  the DOM element
    * @return object  a JSON object
    */
   function formToJSON(obj)
   {
       return toJSON(obj.form);
   }

   /**
    * Highlight row in menus table
    *
    * @event  object  event that was fired on any of row's element
    */
   var g_activerow = null;
   function highlight_row(event)
   {
       event = event || window.event
       var clickedElem = event.target || event.srcElement;
       var row = thisRow(clickedElem);
        
       if (row) {
           if (row != g_activerow && row.id != "highlight_ignore") {
               if (g_activerow) {
                   $(g_activerow).removeClass('highlight')
               }
			   $(row).addClass('highlight');
			   g_activerow = row;
           }
       }
   }

   // Refresh menus page block
   function refresh_menu()
   {
	  var menus = $('menus');
	  
      // send takes care of encoding and returns the Ajax instance.
      // onSuccess removes the spinner.
      var tab_name = $(document).getElement('input[name=m2]').value;
      var params = "tab_name=" + tab_name;
      var myXHR = new XHR({
          onRequest: function() {
               // empties the menus div and shows the spinning indicator
               $(menus).empty().addClass('ajax-loading');
          },
          onSuccess: function(responseJson){
              $(menus).removeClass('ajax-loading');
              var response = Json.evaluate(responseJson);
              $(menus).innerHTML = response.menus_html;
          }
      }).send("php/admin_menu-ajax.php", params);
   }
   
   // Refresh menu items page block
   function refresh_menu_items()
   {
       var menu_items = $('menu_items');
       
       var tab_name  = $(document).getElement('input[name=m2]').value;
       var menu_name = "";
              
       if (g_activerow == null || g_activerow == "") {
           return;
       }
       var es = $(g_activerow).getElements('input');
       es.each(function(el, index){
           if (el.name.contains("MENU_NAME")) {
               menu_name = el.value;
           }
       });
       
       // send takes care of encoding and returns the Ajax instance.
       // onSuccess removes the spinner.
       var params = "tab_name=" + tab_name + "&menu_name=" + menu_name;
       var myXHR = new XHR({
           onRequest: function() {
               // empties the menus div and shows the spinning indicator
               $(menu_items).empty().addClass('ajax-loading');
           },
           onSuccess: function(responseJSON){
               $(menu_items).removeClass('ajax-loading');
               var response = Json.evaluate(responseJSON);
               $(menu_items).innerHTML = response.menu_items_html;
           }
       }).send("php/admin_menu-ajax.php", params);
   }
   
   /**
    * Show attributes for new element by type
    *
    * @param  object  obj   must be an element from new menu elements 
    * @param  string  kind  type of menu element: one from {page | link}
    */
   function set_menu_element_attrs(obj, kind)
   {
       var row = thisRow(obj);
       if (row) {
           var tbls = $(row).getElements('table');
           var tbl_style = "";
           tbls.each(function(tbl, index){
			   tbl_style = (tbl.id == kind) ? 'block' : 'none';
			   $(tbl).setStyle('display', tbl_style);
		   });
       }
   }
   
   /**
    * Save all data changes of menus and menu items on page
    *
    * @param  object  obj  the element of saved form
    */
   function save_menu(obj)
   {
       var data = formToJSON(obj);
       data["action"] = "SAVE_DATA";
       
       var jsonRequest = new Json.Remote(
           "php/admin_menu-ajax.php",
           {
               async: false, // ATTENTION: USED SYNCHRONOUS MODE OF REQUEST!
               onSuccess: function(responseJSON){
                   var response = Json.evaluate(responseJSON);
                   if (response.errmsg) {
                       alert(response.errmsg);
                   }
                   refresh_menu();
                   refresh_menu_items();                                  
               }
           }
       ).send(data);
   }
   
   /**
    * Delete menu
    *
    * @param  object  obj  the element of the row in menus table
    */
   function delete_menu(obj)
   {
       var row = thisRow(obj);
       if (row) {
           var data = toJSON(row);
           data["action"] = "DELETE_MENU";
           
           var jsonRequest = new Json.Remote(
               "php/admin_menu-ajax.php",
               {
                   onSuccess: function(responseJSON){
                       var response = Json.evaluate(responseJSON);
                       if (response.errmsg) {
                           alert(response.errmsg);
                       }
                       refresh_menu();
                       refresh_menu_items()
                   }
               }
           ).send(data);
       }
   }

   /**
    * Delete menu item
    *
    * @param  object  obj  the element of the row in menu items table
    */
   function delete_menu_item(obj)
   {
       var row = thisRow(obj);
       if (row) {
           var data = toJSON(row);
           data["action"] = "DELETE_MENU_ELEMENT";
       
           var jsonRequest = new Json.Remote(
               "php/admin_menu-ajax.php",
               {
                   onSuccess: function(responseJSON){
                       var response = Json.evaluate(responseJSON);
                       if (response.errmsg) {
                           alert(response.errmsg);
                       }
                       refresh_menu();
                       refresh_menu_items();
                   }
               }
           ).send(data);
       }
   }
   
   
   function save_and_redraw(obj)
   {
       save_menu(obj);
       redraw(obj);
   }
   
   function redraw(obj)
   {
       window.location.reload();
   }
   
   // Look up the hierarchy to locate the containing element type
   // Note: If the specified element is not contained this routine returns null;
   function thisNode(obj, kind)
   {
       var node = obj;
       while (node && node.nodeName != kind) {
           node = node.parentNode;
       }

       return node;
   }

   // Look up the hierarchy to locate the containing TR
   // Note: If the specified element is not contained this routine returns null;
   function thisRow(obj)
   {
       return thisNode(obj, 'TR');
   }

   // Look up the hierarchy to locate the containing TABLE
   // Note: If the specified element is not contained this routine returns null;
   function thisTable(obj)
   {
       return thisNode(obj, 'TABLE');;
   }

   // Determine which row of the table we are using
   // Note: If the element  not within a TR this routine returns -1;
   function rowNum(obj)
   {
       var row    = thisRow(obj);      // Locate containing row
       var result = -1;

       if (row) {
           var tbl = thisTable(row);   // Locate containing table
           if (tbl) {
               for (var num = 0; num < tbl.rows.length; num++) {
                   if (tbl.rows[num] == row) {
                       return num;
                   }
               }
           }
       }

       return result;
   }
</script>
{/literal}
{else}
{literal}
 <script language="JavaScript" src="/rental/html/jquery.min.js" type="text/javascript"></script>
  <script type="text/javascript">
    function GetCurrentLocation() {
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(locateSuccess, locateFail);
        }
        else {
            alert('Geolocation is not supported in your current browser.');
        }
      }
    function locateSuccess(loc) {
      var lat = loc.coords.latitude;
      var lon = loc.coords.longitude;
      $("#gLAT").val(lat);
      $("#gLON").val(lon);
      $('#geoForm').submit();
     }

    function locateFail(geoPositionError) {
        switch (geoPositionError.code) {
                case 0: // UNKNOWN_ERROR
                    alert('An unknown error occurred, sorry');
                    break;
                case 1: // PERMISSION_DENIED
                    alert('Permission to use Geolocation was denied');
                    break;
                case 2: // POSITION_UNAVAILABLE
                    alert('Couldn\'t find you...');
                    break;
                case 3: // TIMEOUT
                    alert('The Geolocation request took too long and timed out');
                    break;
                default:
            }
      }
  </script>
{/literal}
{/if} {* is user role admin? *}

  <!-- begin main -->
  <div id="main">
    <!-- begin content -->
    <div id="content">
      <!-- begin left part -->

<div id="left_part">
<div id="nav">
  {if $is_editor}
     <div class="local_block">
       <a href="#" onclick="show_menu_editor(); return false;">Edit</a>
     </div>
  {/if}


  
{foreach from=$menu_tree_l3 item=element name=ml3}


<!--         {if $smarty.foreach.ml3.last }
            {assign var="l3class" value="li_left_last"}       
         {else}
            {assign var="l3class" value="li_left_normal"}
         {/if}
-->

    {if ($element.LEVEL_MENU == 1) }
    
        {if $smarty.foreach.ml3.first}
    <h3>{$element.TITLE}</h3>
        <ul class="left_menu">
        {else}
       	</ul>
    <h3>{$element.TITLE}</h3>        
        <ul class="left_menu">
        {/if}
          
    {else}
    
        {assign var="active" value=""}
        {if ($element.PARENT_MENU eq $menu) && (strpos($element.HREF, $page) !== false)}
           {assign var="active" value="active"}
        {/if}

        {assign var="next_item" value=$smarty.foreach.ml3.index+1}
        {assign var="li_left_class" value="li_left_normal"}
        {if $smarty.foreach.ml3.last || ($menu_tree_l3[$next_item].LEVEL_MENU == 1)}
            {assign var="li_left_class" value="li_left_last"}
        {/if}

        <li class="{$li_left_class}">
            <a href="{$element.HREF}" class="{$active} ">{$element.TITLE}</a>
        </li>


    {/if}
{/foreach}
</ul>

</div> <!-- end "nav" menu -->
</div> <!-- end left part -->

<!-- begin right part -->
<div id="right_part">  {*---right_part div is closed in footer.tpl---*}
{include file="visulate-submenu.tpl"}

{show_error info=$errorObj}

<div class="col-md-12">
  {if $is_editor}
     
     <div class="local_block">
       <a href="#" onclick="show_block('dbcontent_editor'); return false;">Edit page</a>
       |
       <a href="#" onclick="show_block('dbcontent_container'); return false;">View page</a>
     </div>

     <div id="menu_editor" style="display:none;">
     <form id="frmMenu" name="frmMenu">
        <div id="menus"></div>
        <div id="menu_items"></div>
        <input type="button" name="ok_menu_btn" value="Ok" onclick="save_and_redraw(this);">
        <input type="button" name="cancel_menu_btn" value="Cancel" onclick="redraw(this);">
        <input type="button" name="save_menu_btn" value="Apply" onclick="save_menu(this);">
     </form>
     </div> <!-- end menu_editor -->     

     <div id="dbcontent_editor" style="display:none;">
     <form {$form_data.attributes}>

     <div class="local_block">
       {$form_data.ACTION_SAVE.html}
       {$form_data.ACTION_CANCEL.html}
     </div>

       <div>
         {$ckEditor->editor('BODY_CONTENT', $body_content, $cke_config)}
       </div>

       <h3>Header content</h3>
       <div>
         {$form_data.HEADER_CONTENT.html}
       </div>

       {$form_data.hidden}
       {$form_data.ACTION_SAVE.html}
       {$form_data.ACTION_CANCEL.html}
     </form>
     </div>  <!-- end dbcontent_editor -->
     
  {/if} {* is user role admin? *}

  <div id="dbcontent_container">
    {$body_content}
  </div> <!-- end dbcontent_container -->
  
  
</div> <!-- end col-md-12 -->
{include file="google-analytics.tpl"}
{include file="footer.tpl"}
