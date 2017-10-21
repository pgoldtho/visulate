{if ($is_pdf_report)}
   {include file="reports/report-header.tpl"}
{else}  
	<style>
	.total {ldelim}font-weight:bold;
			padding-bottom:30px;
			border-top:1px black solid;
		   {rdelim}
	</style>
{/if}
<h2>{$PrmBusinessName} Balance Sheet</h2>
<table>
  <tr><th colspan="2"><b>Parameters:</b></th></tr>
  <tr><td align="right">Business Unit:</td><td>{$PrmBusinessName}</td></tr>
  <tr><td align="right">Effective Date:</td><td>{$PrmEffectiveDate}</td></tr>
</table>

<table>
  <tr>
    <td><b>Current Assets:</b></td>
    <td></td>
    <td></td>
  </tr>
{foreach from=$data.CURRENT_ASSETS key=k item=item}
  <tr>
    <td>{$k}</td>
    <td>{show_number number=$item}</td>
    <td></td>
  </tr>
{/foreach}

  <tr>  
    <td><i>Total Current Assets</i></td>
    <td></td>
    <td>{show_number number=$data.CURRENT_ASSET_TOTAL}</td>  
  </tr>

  <tr>
    <td><b>Long-Term Assets:</b></td>
    <td></td>
    <td></td>
  </tr>
{foreach from=$data.LONG_TERM_ASSETS key=k item=item}
  <tr>
    <td>{$k}</td>
    <td>{show_number number=$item}</td>
    <td></td>
  </tr>
{/foreach}

  <tr>  
    <td><i>Total Long-Term Assets</i></td>
    <td></td>
    <td>{show_number number=$data.LONG_TERM_ASSET_TOTAL}</td>  
  </tr>
  <tr>  
    <td><i>Total Assets</i></td>
    <td></td>
    <td>{show_number number=$data.ASSET_TOTAL}</td>  
  </tr>
  
  <tr>
    <td><b>Current Liabilities:</b></td>
    <td></td>
    <td></td>
  </tr>
{foreach from=$data.CURRENT_LIABILITIES key=k item=item}
  <tr>
    <td>{$k}</td>
    <td>{show_number number=$item}</td>
    <td></td>
  </tr>
{/foreach}

  <tr>  
    <td><i>Total Current Liabilities</i></td>
    <td></td>
    <td>{show_number number=$data.CURRENT_LIABILITY_TOTAL}</td>  
  </tr>

  <tr>
    <td><b>Long-Term Liabilities:</b></td>
    <td></td>
    <td></td>
  </tr>
{foreach from=$data.LONG_TERM_LIABILITIES key=k item=item}
  <tr>
    <td>{$k}</td>
    <td>{show_number number=$item}</td>
    <td></td>
  </tr>
{/foreach}

  <tr>  
    <td><i>Total Long-Term Liabilities</i></td>
    <td></td>
    <td>{show_number number=$data.LONG_TERM_LIABILITY_TOTAL}</td>  
  </tr>
  <tr>  
    <td><i>Total Liabilities</i></td>
    <td></td>
    <td>{show_number number=$data.LIABILITY_TOTAL}</td>  
  </tr>
  <tr>
    <td><b>Equity:</b></td>
    <td></td>
    <td></td>
  </tr>
{foreach from=$data.EQUITY key=k item=item}
  <tr>
    <td>{$k}</td>
    <td>{show_number number=$item}</td>
    <td></td>
  </tr>
{/foreach}

  <tr>  
    <td>Retained Earnings</td>
    <td>{show_number number=$data.RETAINED_EARNINGS}</td>
    <td></td>  
  </tr> 
  <tr>  
    <td><i>Total Equity</i></td>
    <td></td>
    <td>{show_number number=$data.EQUITY_TOTAL}</td>  
  </tr>  
  <tr>  
    <td><i>Total Liabilities and Equity</i></td>
    <td></td>
    <td>{show_number number=$data.TOTAL_EQUITY_LIABILITIES}</td>  
  </tr>  

  
</table>

{if ($is_pdf_report)}
   {include file="reports/report-footer.tpl"}
{/if}
