window.addEvent('domready', function() {
	$each($$("a.closed"), function (e, index){
	   e.addEvent('click', doExpandCollapse);								
	});
	
	$each($$("a.opened"), function (e, index){
	   e.addEvent('click', doExpandCollapse);								
	});
});


function doExpandCollapse(){
    var h = $(this.getParent());
    var lst = $(h).getNext();
    var isOpen = $(this).hasClass('opened');
    var elmText = $(this).getText();
    if (isOpen){
        $(lst).setStyle('display', 'none');
        $(this).removeClass('opened');
        $(this).addClass('closed');
        $(this).setHTML(elmText.replace(String.fromCharCode(8595), String.fromCharCode(8594)));
    }
    else {
        $(lst).setStyle('display', 'block');
        $(this).addClass('opened');
        $(this).removeClass('closed');
        $(this).setHTML(elmText.replace(String.fromCharCode(8594), String.fromCharCode(8595)));
    }

    return false;
}