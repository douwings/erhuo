<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="/head.html"%>
<title>二货</title>
</head>
<body>
<%@include file="/search.jsp"%>
<%@include file="/top.jsp"%>
<%@include file="/chat_reply.jsp"%>
<%@include file="/chat_pop.jsp"%>

<main class="cd-main-content">
	<div class="content-center">
		<header class="htmleaf-header">
<%
Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
Connection conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;DatabaseName=seconditem","chris","123456");
Statement stmt=conn.createStatement();
ResultSet rs=stmt.executeQuery("select * from [user] where userid="+userid);
rs.next();
String userroot = rs.getString("userroot");
if(userroot.equals("1"))
{
	out.print("<h1><a href=\"handle2.jsp?type=listuser\">管理用户</a></h1>");
	out.print("<h1><a href=\"handle2.jsp?type=listitem\">管理商品</a></h1></center></body></html>");
	out.print("</header></div></main></body></html>");
	return;
}
%>
		<h1><a href="user.jsp?username=<%=username%>">个人信息</a></h1>
		<h1><a href="itemlist.jsp">个人物品</a></h1>
		<h1><a href="deal.jsp?type=listdeal">我的订单</a></h1>
		<h1><span>二货：一个专注二手交易的网站，以更低的价格买到更好的商品是我们的宗旨。</span></h1>
		<h1><span>毕业了？你不用再苦恼大学四年东西太多</span></h1>
		<h1><span>摆摊卖？干嘛那么辛苦，挂到二货上，我们帮你搞定</span></h1>
	</header>
	</div>
</main>
</body>
</html>