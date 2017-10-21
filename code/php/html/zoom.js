var minW = 1024;

$j(function () {
  CheckSizeZoom();
  });
$j(window).resize(CheckSizeZoom);

function CheckSizeZoom() {
  if ($j(window).width() > minW) 
  {
   var zoomLev = $j(window).width() / minW;
   var windowHeight = $j(window).height();
   windowHeight = windowHeight / zoomLev;
   $j(document.body).css('transform', 'scale(' + zoomLev + ')' ).css('transform-origin', '50% 0%');
   $j(window).css('height', windowHeight);
   
  }
  else
  {
   $j(document.body).css('transform', 'scale(1)' ).css('transform-origin', '50% 0%');
  }
}
