<%@ page language="java" pageEncoding="UTF-8"%>

<link rel="stylesheet" type="text/css" href="css/jquery.notify.css">

<script type="text/javascript">
function chat()
{
var xmlhttp;
if (window.XMLHttpRequest)
  {// code for IE7+, Firefox, Chrome, Opera, Safari
  xmlhttp=new XMLHttpRequest();
  }
else
  {// code for IE6, IE5
  xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
  }
xmlhttp.onreadystatechange=function()
  {
  if (xmlhttp.readyState==4 && xmlhttp.status==200)
    {
    	document.getElementById("chat").innerHTML=xmlhttp.responseText;
    }
  }
xmlhttp.open("GET","test.jsp?from=1&to=2",true);
xmlhttp.send();
}
</script>
<script src="js/jquery-1.11.0.min.js" type="text/javascript"></script>
<script type="text/javascript" src="js/jquery.notify.js"></script>
<script>
$.notifySetup({sound: 'audio/notify.wav'});
$(function(){
	$("#btn").click(function(){
		$('<p>aaaaaaaaaaaaaaaaaaa</p>').notify({sticky: true});
	});
});

</script>

<body>

</body>
</html>