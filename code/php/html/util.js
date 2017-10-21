
function getElementByName(name)
{
  var arr = document.getElementsByName(name); 
  if (arr.length > 1 || arr.length == 0)
    alert("Error: cannot find element by name "+name+" ");

  return arr[0];
}

function getElementByName2(name)
{
  var arr = document.getElementsByName(name); 
  if (arr.length > 1)
     alert("Found many elements");
  else if (arr.length == 0)
    return null;

  return arr[0];
}

function helptext(helpElementID)
{
  var elementSelector = 'td.' + helpElementID;
  var helpSelector    = '#' + helpElementID + '_help';
  
  if ($E(elementSelector)){
  $E(elementSelector).addEvent('mouseenter', function(){
     $E(helpSelector).setStyle('display', 'block');
     });

  $E(elementSelector).addEvent('mouseleave', function(){
     $E(helpSelector).setStyle('display', 'none');
     });
  }
}

function showLov(fieldID, fieldCode, fieldDisplay, arrayName, isDisplay){
  var w = window.open("about:blank", 'winLov', 'scrollbars=1,resizable=1,width=400,height=450');
text = 
"<html>\n"+
"  <head>\n"+
"     <title>MyLov</title>\n"+
"	 <script language=\"javascript\" src=\"mootools.js\"></script>\n"+
"  </head>\n"+
"<body>\n"+
"  <script language=\"javascript\">\n"+
"    var ldata = opener."+arrayName+";\n"+
"	 var isDisplay = "+(isDisplay ? "true":"false") + ";\n"+
"	 var fieldID = \""+fieldID+"\";\n"+
"	 var fieldCode = \""+fieldCode+"\";\n"+
"	 var fieldDisplay = \""+fieldDisplay+"\";\n"+
"    var gUID = opener.gUID;\n"+
"\n"+
"	function do_c(index){\n"+
//"	   if (opener.gUID != gUID){\n"+
//"	      alert(\"Parent window changed\");\n"+
//"		  return;\n"+
//"	   }\n"+
"\n"+
"	   opener.document.getElementById(fieldID).value = ldata[index][1];\n"+
"	   opener.document.getElementById(fieldCode).value = ldata[index][2];\n"+
"	   if (isDisplay)\n"+
"   	   opener.document.getElementById(fieldDisplay).value = ldata[index][3];\n"+
"	   window.close();\n"+
"	}\n"+
"\n"+
"	function findRows(fText){\n"+
"	    text = \"\";\n"+
"	    var textExpr = '^'+fText.replace(/\\" + "*/g, '.*')+'$';\n"+
"		var re = new RegExp().compile(textExpr, \"i\");\n"+
"		var count = 0;\n"+
"	    for(i=0; i < ldata.length; i++){\n"+
"		   ds = ldata[i][2];\n"+
"		   if (isDisplay)\n"+
"		      ds += \" - \"+ldata[i][3];\n"+
"		   if (fText != '')\n"+
"		     if (!ds.match(re))\n"+
"			    continue;\n"+
"		   text += \"<a href='javascript: do_c(\"+i+\")'>\"+ds+\"</a><br>\";\n"+
"		   count++;\n"+
"		}\n"+
"		if (count ==0)\n"+
"		  text = '<b>No result</b>';\n"+
"		document.getElementById('result').innerHTML = text;\n"+
"	}\n"+
" </script>\n"+
"  <b>Search :</b>\n"+
"  <input type=\"text\" name=\"searchString\" id=\"searchString\" value=\"*\" onkeyup=\"findRows(document.getElementById('searchString').value)\">\n"+
"  <input type=\"button\" name=\"go\" value=\"Find\" onclick=\"findRows($('searchString').value)\">\n"+
"  <div id=\"result\">\n"+
"  </div>\n"+
"  <script language=\"javascript\">\n"+
"     findRows(\"*\");\n"+
"  </script>\n"+
"</body>\n"+
"</html>";
;
w.document.write(text);
w.document.close();
}