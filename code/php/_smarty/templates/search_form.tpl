<form id="geoForm" action="/rental/visulate_search.php?REPORT_CODE=PROPERTY_DETAILS" method="post">
  <input id="gLAT" name="LAT" type="hidden" />
  <input id="gLON" name="LON" type="hidden" />
</form>

  <form id="searchForm"
        action="rental/visulate_search.php?REPORT_CODE=PROPERTY_DETAILS" method="post">
    <table class="datatable" style="width: 100%">
    <caption>Enter Street Address then Press Search</caption>
     <tr><th><b>Address:</b></th>
         <td><input size="80" maxlength="80" name="ADDR" type="text" value="1116 Ocean Dr, Miami Beach, FL 33139" aria-label="Enter street address"/></td>
         <td><input name="submit_html" value="Search" type="submit" /></td>
     </tr>
    </table>
  </form>
