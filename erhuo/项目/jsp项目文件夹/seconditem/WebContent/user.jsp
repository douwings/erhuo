<%@ page language="java" pageEncoding="UTF-8" import="java.sql.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="/head.html"%>
<link rel="stylesheet" type="text/css" href="css/main.css" />
<title>物品交换系统</title>
<link rel="stylesheet" media="screen" href="css/form.css" >
<style type="text/css">
.contact_form{border:1px solid #DDDDDD;padding:10px;width:760px;margin:40px auto 0 auto;}
</style>
</head>
<body>
<%@include file="/search.jsp"%>
<jsp:useBean id="user" class ="seconditem.userBean" scope="page">
<jsp:setProperty name ="user" property="*"/>
</jsp:useBean>
<%@include file="/top.jsp"%>
<%@include file="/chat_reply.jsp"%>
<%@include file="/chat_pop.jsp"%>
<%
/*
	更改用户信息
*/
request.setCharacterEncoding("UTF-8");

Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
Connection conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;DatabaseName=seconditem","chris","123456");
String sql = "select * from [user] where username=N'"+user.getUsername()+"'";
Statement stmt=conn.createStatement();
ResultSet rs=stmt.executeQuery(sql);
if(rs.next())
{
	out.print("<form class=\"contact_form\" action=\"handle.jsp?type=changepassword\" method=\"post\" >\n<ul>");
	out.print("<li><h2>修改密码</h2></li>\n");
	out.print("<li><label for=\"name\">原密码：</label><input required type=\"password\" name=\"passwordold\"></li>\n");
	out.print("<li><label for=\"name\">新密码：</label><input required type=\"password\" name=\"password\"></li>\n");
	out.print("<li><button class=\"submit\" type=\"submit\">更改密码</button></li>\n");
	out.print("</ul>\n</form>");

	//out.print("<form class=\"contact_form\" action=\"handle.jsp?type=changeemail\" method=\"post\" >\n<p>原邮箱：<input required name=\"emailold\"></p><p>新邮箱：<input name=\"email\"></p>\n<p><input required type=\"submit\" value=\"更改邮箱\"></p>\n</form>");

	out.print("<form class=\"contact_form\" action=\"handle.jsp?type=changeemail\" method=\"post\" >\n<ul>");
	out.print("<li><h2>修改邮箱</h2></li>\n");
	out.print("<li><label for=\"name\">原邮箱：</label><input required name=\"emailold\"></li>\n");
	out.print("<li><label for=\"name\">新邮箱：</label><input required name=\"email\"></li>\n");
	out.print("<li><button class=\"submit\" type=\"submit\">更改邮箱</button></li>\n");
	out.print("</ul>\n</form>");
}
else
{
	out.print("内部错误");
}


%>
</body>
</html>