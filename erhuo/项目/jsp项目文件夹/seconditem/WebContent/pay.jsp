<%@ page language="java" pageEncoding="UTF-8" import="java.sql.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<%@include file="/head.html"%>
<link rel="stylesheet" type="text/css" href="css/main.css" />
<title>物品交换系统</title>
<link rel="stylesheet" media="screen" href="css/form.css" >
<%
request.setCharacterEncoding("UTF-8");
String buyer = request.getParameter("buyer");//userid
String seller = request.getParameter("seller");//itemid

String url = "http://192.168.191.1:8080/seconditem/pay2.jsp?a="+buyer+";"+seller;

%>
<script type="text/javascript">
window.onload=function()
{
	var timer = window.setInterval("ispay()",1000); 
}

function ispay()
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
    //document.getElementById("div1").innerHTML=xmlhttp.responseText;
    if(xmlhttp.responseText.indexOf("N")<=-1)//N不存在即付款成功
    {	
    	document.getElementById("div1").innerHTML=xmlhttp.responseText;
    	window.clearInterval(timer);
    }
    
    }
  }
xmlhttp.open("GET","ispay.jsp?type=adddeal&buyer=<%=buyer%>&seller=<%=seller%>",true);
xmlhttp.send();
}
</script>
</head>
<body>
<%@include file="/search.jsp"%>
<%@include file="/top.jsp"%>
<main class="cd-main-content">
	<!-- your content here -->
	<div class="content-center">
		<!-- <h1>Advanced Search Form</h1> -->
		<header class="htmleaf-header">
		<div id="div1">
<%

Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
Connection conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;DatabaseName=seconditem","chris","123456");

String sql = "if not exists (select * from [deal] where buyer='"+buyer+"' and seller='"+seller+"')"+"insert into [deal] (buyer,seller,state) values('"+buyer+"','"+seller+"',3)";
Statement stmt=conn.createStatement();
//out.print(sql);
int i = stmt.executeUpdate(sql);

if(i==1)
	out.print("<p>订单发送成功请付款<p>");
else
	out.print("<p>订单已存在<p>");

Statement stmt2 = conn.createStatement();
ResultSet rs = stmt2.executeQuery("select * from [item] where itemid ="+seller);
rs.next();

//out.print("<img src=\"/img"+rs.getString("imgpath")+"\" />");//商品图片
out.print("<p>商品名称："+rs.getString("itemname")+"<p>");//名字
out.print("<p>商品价格："+rs.getString("price")+"</p>");
out.print("<p>商品描述："+rs.getString("description")+"</p>");
out.print("<p>支付宝付款码：</p>");

out.print("<img src=\"http://www.2d-code.cn/2dcode/api.php?key=c_ecbaagDWmlqLrNg45OlbTU/w5cbuc/d6pqvvD2Z/IwU&text="+url+"\" />");//图片
out.print("<p>其他付款方式：<a href=\"deal.jsp?type=adddeal&buyer="+ buyer +"&seller=" + seller + "\">当面付款</a>&nbsp&nbsp<a href=\"#a\">银行卡</a>&nbsp&nbsp<a href=\"#a\">微信支付</a></p>");


%>
</div>
</header>
	</div>
</main>
</body>
</html>