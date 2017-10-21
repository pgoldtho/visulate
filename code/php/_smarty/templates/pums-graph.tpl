{if ($data.PROPERTY.PUMA_PERCENTILE)}
  {assign var="i" value=$data.PROPERTY.PUMA_PERCENTILE}
{/if}

<h3>Local Household Income</h3>
<p>The median household income in this part of Florida is ${$puma.INCOME.50|number_format:0:".":","}.
The bottom 10% of the population earn less than ${$puma.INCOME.10|number_format:0:".":","} per year.
The top 10% earn more than ${$puma.INCOME.90|number_format:0:".":","} per year.  The top 1%
earn more than ${$puma.INCOME.99|number_format:0:".":","} per year.
Most renters earn
between ${$puma.RENTER.20*12|number_format:0:".":","} (20th percentile)
and ${$puma.RENTER.80*12|number_format:0:".":","} (80th percentile) per year.
Someone earning the median household income in this area is likely to qualify for a mortgage between
${math|number_format:0:".":"," equation="x * 2" x=$puma.INCOME.50 } and
${math|number_format:0:".":"," equation="x * 2.5" x=$puma.INCOME.50}.
</p>
{if ($i)}
<p>
The tax assessed value of this property
places it in percentile {$i} of all properties in this area.
{if ($i < 100)}
This suggests it would appeal to someone earning
around ${$puma.INCOME.$i|number_format:0:".":","} per year who should qualify for a mortgage between
${math|number_format:0:".":"," equation="x * 2" x=$puma.INCOME.$i } and
${math|number_format:0:".":"," equation="x * 2.5" x=$puma.INCOME.$i}.
{/if}
</p>
{/if}
<div id="chartdiv" style="height:300px; width:720px;"></div>
<p>Source: US Census American Community Survey - <a href="http://www.census.gov/acs/www/data_documentation/2012_release/" target="_blank">
2008-2012 ACS 5-year PUMS estimates</a></p>

<h3>Local Rents</h3>
<p>
The median monthly rent in this part of Florida is ${$puma.RENT.50|number_format:0:".":","}.
Most renters earn
between ${$puma.RENTER.20|number_format:0:".":","} 
and ${$puma.RENTER.80|number_format:0:".":","}  per month.  

They typically spend {$puma.PUMA.RENT_INCOME_RATIO}% of their monthly income on rent.

Most rents fall in the ${$puma.RENT.20|number_format:0:".":","} (20th percentile)
to ${$puma.RENT.80|number_format:0:".":","} (80th percentile) range.
The residential vacancy rate is {$puma.PUMA.VACANCY_RATE}%.</p>
{if (($i) and ($i < 100))}
<p>This property falls in percentile {$i} of all properties in this area.  This corresponds to a rent of ${$puma.RENT.$i|number_format:0:".":","} per month and a monthly household income of ${$puma.RENTER.$i|number_format:0:".":","}
(${math|number_format:0:".":"," equation="x * 12" x=$puma.RENTER.$i} per year)

</p>
{/if}
<div id="chartdiv2" style="height:300px; width:720px;"></div>

{literal}

<script type="text/javascript" src="/rental/html/jquery.jqplot/dist/plugins/jqplot.highlighter.min.js"></script>
<script type="text/javascript" src="/rental/html/jquery.jqplot/dist/plugins/jqplot.pointLabels.js"></script>
<script type="text/javascript">
jQuery(document).ready(function(){


{/literal}

  {foreach name=g item=p from=$puma.INCOME key=k}
  {if $smarty.foreach.g.first }
  var hh = [
  {elseif $smarty.foreach.g.last }
    [{$k}, {$p}]]; 
  {else}
    [{$k}, {$p}], 
  {/if}
  {/foreach}

  {foreach name=g item=p from=$puma.RENTER key=k}
  {if $smarty.foreach.g.first }
  var rh = [
  {elseif $smarty.foreach.g.last }
    [{$k}, {$p*12}]];
  {else}
    [{$k}, {$p*12}],
  {/if}
  {/foreach}

  {foreach name=g item=p from=$puma.RENT key=k}
  {if $smarty.foreach.g.first }
  var rr = [
  {elseif $smarty.foreach.g.last }
    [{$k}, {$p}]];
  {else}
    [{$k}, {$p}],
  {/if}
  {/foreach}

  {foreach name=g item=p from=$puma.RENTER key=k}
  {if $smarty.foreach.g.first }
  var ri = [
  {elseif $smarty.foreach.g.last }
    [{$k}, {$p}]]; 
  {else}
    [{$k}, {$p}], 
  {/if}
  {/foreach}

{if !($i)}{assign var="i" value="50"}{/if}

  var line1 = [[{$i}, 0], [{$i}, {$puma.RENTER.$i}]];
  var line2 = [[{$i}, {$puma.RENT.$i}],[0,{$puma.RENT.$i}]];
  var line3 = [[{$i}, {$puma.RENTER.$i}],[0,{$puma.RENTER.$i}]];

  var line4 = [[{$i}, 0], [{$i}, {$puma.INCOME.$i}]];
  var line5 = [[{$i}, {$puma.INCOME.$i}], [0, {$puma.INCOME.$i}]];


{literal}
jQuery.jqplot('chartdiv',  [hh, rh, line4, line5],

{ title:'Annual Income Distribution - All Households (Brown), Renters (Blue)',
  axes:{yaxis:{tickOptions:{formatString:"$%'d"}, min:{/literal}{$puma.INCOME.0},
         max:{if ($i < 80)}{$puma.INCOME.80}{else}{$puma.INCOME.99}{/if}{literal}},
        xaxis:{min:0, max:100}},
        highlighter: {show: true,sizeAdjust: 5.5 },
  series:[{showMarker:false, color:'#996633'}, {showMarker:false, color:'#6699ff'},
          {showMarker:false, color:'#efefef'},
          {showMarker:false, color:'#efefef',  pointLabels: {show: true,  edgeTolerance: 5 }}
  ]
});

jQuery.jqplot('chartdiv2',  [rr, ri, line1, line3, line2],
{ title:'Rent Range - Gross Monthly Income (Blue), Gross Rent (Green)',
  axes:{yaxis:{tickOptions:{formatString:"$%'d"}, min:{/literal}{$puma.RENT.0}, max:{$puma.RENTER.99}{literal}},
        xaxis:{min:0, max:100}},
        highlighter: {show: true,sizeAdjust: 5.5 },
  series:[{showMarker:false, color:'#5FAB78'}, {showMarker:false, color:'#6699ff'},
          {showMarker:false, color:'#efefef'},
          {showMarker:false, color:'#efefef',  pointLabels: {show: true,  edgeTolerance: 5 }},
          {showMarker:false, color:'#efefef',  pointLabels: {show: true,  edgeTolerance: 5 }}
  ]
}); 
});
</script>
{/literal}