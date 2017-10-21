  <div class="jumbotron" id="banner"
            style="background-size:cover;
                   background-position:center;
                   padding-top:150px;
                   margin-bottom:0;
                   padding-bottom:0;
                   border-bottom: 1px solid #ccc">
  <div class="container-fluid" style="margin-bottom:0;">
    <h1 style="color:#e6e6e6; padding-top: 70px; float:left;">Visulate</h1>
    <div style="width: 50%; float: right;">
    <form role="search" action="rental/visulate_search.php?REPORT_CODE=PROPERTY_DETAILS" method="post" style="width:100%; float:right; padding-bottom:0; margin-bottom:0;">
      <div style="padding-top: 120px;">
          <button type="submit" class="btn btn-default" style="float:right; position: absolute; right: 10px;">Search</button>
          <div class="form-group" style="float:right;  margin-right: 65px;">
            <input id="search" type="text" class="form-control" size="47%" name="ADDR" placeholder="Address Search: (e.g. 1116 Ocean Dr, Miami Beach)" style="float:right;" aria-label="Address Search: (e.g. 1116 Ocean Dr, Miami Beach)">
          </div>
      </div>
    </form>
  </div>
  </div>
</div>
<script type="text/javascript">
  var x = Math.floor((Math.random() * 53) + 1);
  document.getElementById("banner").style.backgroundImage = "url(https://visulate.com/images/1x5/letterbox-"+ x +".jpg)";
</script>
