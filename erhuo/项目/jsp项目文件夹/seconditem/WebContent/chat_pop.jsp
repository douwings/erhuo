<%@ page language="java" pageEncoding="UTF-8" import="java.sql.*" import="java.text.SimpleDateFormat" import="java.util.Date"%>
<%
	String username2="";
	String userid2="";
	Cookie[] cookies_top2 = request.getCookies();
	Cookie usernameCookie2 = null;
	Cookie useridCookie2 = null;
	if(cookies_top2 !=null)
	{
		int i;
		for(i=0;i<cookies_top2.length;i++)
		{
			if(cookies_top2[i].getName().equals("username"))
			{
				usernameCookie2 = cookies_top2[i];
				username2 = java.net.URLDecoder.decode(usernameCookie2.getValue().toString(),"UTF-8");
			}else if (cookies_top2[i].getName().equals("userid"))
			{
				useridCookie2 = cookies_top2[i];
				userid2 = java.net.URLDecoder.decode(useridCookie2.getValue().toString(),"UTF-8");
			}
		}
		String path = request.getRequestURI();
		//out.print(path);
		if(usernameCookie2==null && !path.contains("login")&&!path.contains("regist")&&!path.contains("handle")&&!path.contains("lost"))//没cookie 并且不在登录/注册/找回密码界面
		{
			response.sendRedirect("login.jsp");
			return;
		}else if(usernameCookie2!=null && (path.contains("login")||path.contains("regist")||path.contains("lost")))//有cookie 并且在登录/注册/找回密码界面
		{
			response.sendRedirect("index.jsp");
		}
	}else{
		response.sendRedirect("login.jsp");
		return;
	}
	
%>
<link rel="stylesheet" type="text/css" href="css/jquery.notify.css">
<script type="text/javascript" src="js/jquery.notify.js"></script>
<script>
$.notifySetup({sound: 'audio/notify.wav'});
function pop(a,b,n,c){
		$(n).notify({sticky: true, afrom:a, bto:b , name:c});
}
</script>
<script type="text/javascript">
var tempStr;
window.onload=function()
{
	var timer = window.setInterval("newmess()",1000); 
}

function newmess()
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
	  //如果是Y，则弹出气泡
		var tempStr = xmlhttp.responseText;
		if(tempStr.indexOf("Y")!=-1)
		{
			mess();
		}
    }
  }
xmlhttp.open("GET","chat_back.jsp?type=newmess&to=<%=userid2%>",true);
xmlhttp.send();
}

function mess(){
    $.get("chat_back.jsp?type=mess&to=<%=userid2%>",function(data,status){
    	var array = data.split(";");
    	var tem = [];
    	for (var i=0 ; i< array.length ; i++)
    	{
    		tem.push(array[i]);
    	}
    	pop(tem[1],<%=userid2%>,tem[2],tem[0]);
    });
  }
</script>