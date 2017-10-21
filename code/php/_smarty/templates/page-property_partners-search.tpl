{include file="top.tpl"}
  <!-- begin main -->
  <div id="main">
    <!-- begin content -->
    <div id="content">
      <!-- begin left part -->

     <!-- end left part -->
     <!-- begin right part -->
     <div id="right_part">  {*---right_part div is closed in footer.tpl---*} 
     
<script language="javascript">
  function addBU(user_id){ldelim}
    var divName = 'answer__'+user_id;
	$(divName).innerHTML = "<span style='color:blue'>In progress...</span>";
	var business_id = (document.getElementsByName("ROLE_BUSINESS["+user_id+"][1]")[0]).value;
	var role_id = (document.getElementsByName("ROLE_BUSINESS["+user_id+"][0]")[0]).value;
    var url = '{$PATH_FROM_ROOT}php/addBU-partner-search.php?'+Object.toQueryString({ldelim}business_id: business_id, role_id : role_id, user_id : user_id{rdelim});
    var myAjax = new Ajax(url, {ldelim}method: 'get', 
	                                   update: divName
						       {rdelim} );
	myAjax.request();
  {rdelim}
</script>
<h1>Partner Search</h1>
<p>
The Partner Search screen allow business owners to find existing Visulate users
and grant them access to a business unit.
Enter the partner's email address then press find.</p>
<div style="width:100%;padding-top:50px">
<form {$form_data.attributes}>
  <table align="center">
    <tr>
	   <td><b>{$form_data.searchValue.label}</b> {$form_data.searchValue.html} {$form_data.find.html} {$form_data.hidden} </td>
	</tr>
  </table>
</form>
</div>
<center>
{if ($warning neq "")}
  <b>{$warning}</b>
{/if}

<table width="600px" cellpadding="1">
{foreach from=$data item=item key=key}
   <tr><td colspan="2" style="border-bottom:1px dotted #006600"><br><b style="font-size:120%">{$key+1}. {$item.USER_NAME} [ {$item.USER_EMAIL} ] </b></td></tr>
   {foreach from=$item.BUSINESS_UNITS item=item1}
        <tr bgcolor="{cycle values="#eeeeee,#d0d0d0"}" valign="top">
 		   <td ><span style="color:#aaaaaa">{$item1.ROLE_NAME}<span></td>
		   <td><span style="color:#aaaaaa">{$item1.BUSINESS_NAMES}<span></td>
		 </tr>
	{/foreach}	 
	<tr><td colspan="2">
	<div id="div_{$item.USER_ID}">
	   <form action="javascript:addBU({$item.USER_ID});" name="UserForm{$data.USER_ID}">
       <b>{$form_data.ROLE_BUSINESS[$item.USER_ID].label}: </b>{$form_data.ROLE_BUSINESS[$item.USER_ID].html} {$form_data.add.html}
	   </form>
	   	<div id="answer__{$item.USER_ID}"></div>
	</div>
    </td></tr> 
		
{/foreach}
</table>
</center>
{include file="footer.tpl"}