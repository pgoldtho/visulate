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
                                                   {if ($isEdit == "true")}
                             {$value.linkDel}
                                  {/if}
                        </li>
                    {/foreach}
                </ul>                
            </div>
        </div>
        
        <!-- begin right part -->
        <div id="right_part">   {*---right_part div is closed in footer.tpl---*}
        {include file="visulate-submenu.tpl"}
         <h1>{$header_title}</h1>



<div class="col-md-12">
         <img id="mainPicture" src="{$first_img}" class="vga_img"/>
</div>

  <div class="col-md-6">
  <a name="photos"></a>
  {if ($isEdit == "true" && $action != 'INSERT_PROPERTY')}
  <form action="{$PATH_FROM_ROOT}index.php#upload" method=POST enctype="multipart/form-data" >  
     <input type=hidden name=PROPERTY_ID value='{$property_id}'>
     <input type=hidden name=IS_PHOTO_UPLOAD value='true'>    
     <input type=hidden name=type value='map'>    
     <input type=hidden name=MAX_FILE_SIZE value='2000000'>    
     <input type=hidden name='{$menuObj->request_menu_level2}' value='{$menuObj->current_level2}' />
     <table class="datatable1">
        <tr>
           <th colspan=2> Upload Photos</th>
        <tr>
           <th>File<span class=error>*</span></th>
           <td><input size=50 type=file name=photoFile value=""> <span class=error>{$uploadPhotoFileError}</span></td>
        </tr>
        <tr>
        </tr>
        <tr>
           <th>Title<span class=error>*</span></th>
           <td><input type=text size=50 maxlength="300" name=photoTitle value="{$uploadPhotoTitle}"> <span class=error>{$uploadPhotoTitleError}</span></td>
        </tr>
           <td colspan="2" style="text-align:right"><input type=submit name=uploadPhoto value='Save Photo'></td>
        </tr>
     </table>
  </form>   
  {/if}


 {show_error info=$errorObj}
<br class="clear" />
 
{if ($role != "ADVERTISE")}

<br class="clear" />
  <h3>Documents</h3>
  
  {if (!$doc_list)}  
      <b>No documents</b> 
    <br>  <br>
  {else}    
      <table class="datatable">
         <tr>
            <th></th>
            <th>Creation date</th>
            <th>Title</th>
            {if ($isEdit == "true")}
            <th></th>
            {/if}
         </tr>
         {foreach from=$doc_list item=item}
             <tr>
                <td>{$item.order}</td>
                <td>{$item.CREATION_DATE}</td>
                <td><a href="{$item.LINK_URL}" target="_blank">{$item.LINK_TITLE}</a></td>
                  {if ($isEdit == "true")}
                  <td>{$item.linkDel}</td>
                {/if}
             </tr>
         {/foreach}
      </table>
  {/if}

  <a name="upload"></a>
  {if ($isEdit == "true" && $action != 'INSERT_PROPERTY')}
  <span class=error>{$uploadError}</span>
  <form action="{$PATH_FROM_ROOT}index.php#upload" method=POST enctype="multipart/form-data" >
     <input type=hidden name=PROPERTY_ID value='{$property_id}'>
     <input type=hidden name=IS_UPLOAD value='true'>    
     <input type=hidden name=type value='map'>    
     <input type=hidden name='{$menuObj->request_menu_level2}' value='{$menuObj->current_level2}' />
     <table class="datatable1">
        <tr>
           <th colspan=2> Upload Documents</th>
        </tr>
        <tr>
           <th>Title<span class=error>*</span></th>
           <td><input type=text size=50 name=uploadTitle value="{$uploadTitle}"> <span class=error>{$uploadTitleError}</span></td>
        </tr>
        <tr>
           <th>Hypertext Link<span class=error>*</span></th>
           <td><input size=50 type=text name=uploadFile value="{$uploadFile}"> <span class=error>{$uploadFileError}</span></td>
        </tr>
        <tr>
           <td colspan="2" style="text-align:right"><input type=submit name=upload value='Save Link'></td>
        </tr>
     </table>
  </form>
  {/if}
  
{/if}{*---role != ADVERTISE---*}
</div>

<div class="col-md-6 actionDiv">
{if ($role == "ADVERTISE")}
<h3>Instructions (page 2 of 4)</h3>
    <p>Click on the Browse button in the Upload Photos region to select a
        picture to display in your advertisment.  Enter a title for the photo and
        press the Save button.  Visulate allows images of type
        'jpg', 'jpeg', 'gif', 'png' and 'bmp' to be uploaded.  Uploaded pictures are
        displayed on the left of the page in the order that they where loaded.
        Mouse over the thumbnail images to display it above.  Click on the thumbnail
        to open a full size copy in another window.  Click on the red "x" under the
        thumbnail to delete the image.
        </p>
        <p>{$advertise_prev}{$advertise_next}</p>
   <div class="clear"><br/></div>
{else}
<h3>Instructions</h3>
    <p>Click on the Browse button in the Upload Photos region to select a
        picture to display in your advertisment.  Enter a title for the photo and
        press the Save button.  Visulate allows images of type
        'jpg', 'jpeg', 'gif', 'png' and 'bmp' to be uploaded.  Uploaded pictures are
        displayed on the left of the page in the order that they where loaded.
        Mouse over the thumbnail images to display it above.  Click on the thumbnail
        to open a full size copy in another window.  Click on the red "x" under the
        thumbnail to delete the image.
        </p>
  <p>You should see a map displayed under the Upload photos region.  This is
    rendered automatically based on the property address.  This may have caused
    warning to appear when you entered the page.  </p>
    <p>The documents section can be used to record hypertext links to documents
    that relate to the property.  Enter a title and the complete url for the page
    you want to reference (e.g. http://google.com) then press the Save Link
    button. </p>
{/if}
</div>


{include file="footer.tpl"}
