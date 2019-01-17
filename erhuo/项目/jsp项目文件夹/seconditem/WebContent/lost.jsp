<%@ page language="java" pageEncoding="UTF-8" import="java.sql.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<%@include file="/head.html"%>
<title>物品交换系统</title>
<link rel="stylesheet" type="text/css" href="css/main.css" />
<link rel="stylesheet" media="screen" href="css/form.css" >
<link rel="stylesheet" media="screen" href="css/content.css" >
<style type="text/css">
.contact_form{border:1px solid #DDDDDD;padding:10px;width:760px;margin:40px auto 0 auto;}
</style>
</head>
<body>
<%@include file="/search.jsp"%>
<%@include file="/top.jsp"%>

<%
request.setCharacterEncoding("UTF-8");
String username2 = request.getParameter("username2");

if(username2!=null){
	out.print("<main class=\"cd-main-content\"><div class=\"content-center\"><header class=\"htmleaf-header\"><div id=\"content\"><p>");
	String email = request.getParameter("email");
	int i;
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	Connection conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;DatabaseName=seconditem","chris","123456");
	Statement stmt = conn.createStatement();
	ResultSet rs=stmt.executeQuery("select * from [user] where (email='"+email+"' and username='"+username2+"')");
	if(rs.next()){
		out.print("您的密码为："+rs.getString("password"));
	}else{
		out.print("账号或邮箱错误");
	}
	out.print("</p></div></header></div></main>");
	return;
}
%>
<form class="contact_form" action="lost.jsp" method="post" >
<ul>
	<li>
		<h2>找回密码</h2>
	</li>
	
	<li>
		<label for="name">用户名:</label>
		<input name="username2" type="text" required /></p>
	</li>
	<li>
		<label for="email">邮箱:</label>
		<input type="email" name="email" required />
		<span class="form_hint">正确格式为：xxxxxx@xx.xxx</span>
	</li>
	<li>
		<button class="submit" type="submit">找回</button>
	</li>
</ul>
</form>
</body>
</html>