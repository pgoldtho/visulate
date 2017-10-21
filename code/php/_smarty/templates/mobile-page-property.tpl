	{include file="mobile-top.tpl"}
	<div class="content">
		{include file="mobile-prop-select.tpl"}	

         <h1>{$header_title}</h1>
                <h2 class="title">Pictures</h2>
                <ul>
                    {foreach from=$photos_list item=value name="l3menu"}
                     
                        <li>
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



  </div>
	{include file="mobile-footer.tpl"}
  	            
