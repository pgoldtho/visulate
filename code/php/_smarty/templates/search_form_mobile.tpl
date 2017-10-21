<p>Enter a street address then press Search or</p>
<p><a href="javascript:GetCurrentLocation();">Use your current location</a></p>
<form id="geoForm" action="/rental/visulate_search.php?REPORT_CODE=PROPERTY_DETAILS" method="post">
  <input id="gLAT" name="LAT" type="hidden" />
  <input id="gLON" name="LON" type="hidden" />
</form>

  <form id="searchForm"
        action="/rental/visulate_search.php?REPORT_CODE=PROPERTY_DETAILS" method="post">
    <table >
     <tr>
         <td><input size="36" maxlength="80" name="ADDR" type="text" value=""/></td>
         <td><input name="submit_html" value="Search" type="submit" /></td>
         <td></td>
     </tr>
    </table>
  </form>
<hr/>