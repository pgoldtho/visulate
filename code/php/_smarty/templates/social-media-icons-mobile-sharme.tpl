<div id="shareme" data-url="http://visulate.com{$smarty.server.REQUEST_URI}" data-text="Visulate"></div>
<div style="clear:both;"></div>
{literal}
<script>
$('#shareme').sharrre({
  share: {
    googlePlus: true,
    facebook: true,
    twitter: true,
    digg: false,
    delicious: false,
    stumbleupon: false,
    linkedin: true,
    pinterest: false
  },
  buttons: {
    googlePlus: {size: 'tall', annotation:'bubble'},
    facebook: {layout: 'box_count'},
    twitter: {count: 'vertical'},
    linkedin: {counter: 'top'},
    
  },
  enableHover: false,
  enableCounter: false,
  enableTracking: false
});
</script>
<style type="text/css">

  .sharrre .button{
    float:left;
    width:60px;
  }
</style>
{/literal}