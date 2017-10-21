	{include file="mobile-top.tpl"}
	<div class="content">
		{include file="mobile-bu-select.tpl"}	
	
	 <h3>Alerts</h3>
    <div style="width:300; overflow:auto;border:1px solid #808080">
    {$ExceptionMessage}
		{foreach from=$alertList item=item}
		    {$item}<br/>
		{/foreach} 
		</div>
  </div>
	{include file="mobile-footer.tpl"}