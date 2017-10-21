<div id="shareme" data-url="http://visulate.com{$smarty.server.REQUEST_URI}" data-text="Visulate"></div>
{literal}
<script>
$j('#shareme').sharrre({
  share: {
    digg: true,
    delicious: true,
    stumbleupon: true,
    linkedin: true,
    googlePlus: true,
    twitter: true,
    facebook: true,
    pinterest: false
  },
  buttons: {
    googlePlus: {size: 'tall', annotation:'bubble'},
    facebook: {layout: 'box_count'},
    digg: {type: 'DiggMedium'},
    delicious: {size: 'tall'},
    stumbleupon: {layout: '5'},
    linkedin: {counter: 'top'},
    twitter: {count: 'vertical'},
  },
  enableHover: false,
  enableCounter: false,
  enableTracking: true
});
</script>
<style type="text/css">
  .sharrre .button{
    float:right;
    width:60px;
  }
  
.fb-like{
  z-index:90;
}
  
</style>
{/literal}