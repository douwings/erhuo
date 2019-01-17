<%@ page language="java" pageEncoding="UTF-8" import="java.sql.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<%@include file="/head.html"%>
<title>物品交换系统</title>
<link rel="stylesheet" type="text/css" href="css/main.css" />
<link rel="stylesheet" media="screen" href="css/form.css" >
<link rel="stylesheet" type="text/css" href="css/content.css" />
<style type="text/css">
.contact_form{border:1px solid #DDDDDD;padding:10px;width:760px;margin:40px auto 0 auto;}
</style>
</head>
<body>

<jsp:useBean id="user" class ="seconditem.userBean" scope="page">
<jsp:setProperty name ="user" property="*"/>
</jsp:useBean>
<%@include file="/search.jsp"%>
<%@include file="/top.jsp"%>
<%

request.setCharacterEncoding("UTF-8");
String regist = request.getParameter("regist");
if(regist!=null)
{
	try{
		out.print("<main class=\"cd-main-content\"><div class=\"content-center\"><header class=\"htmleaf-header\"><div id=\"content\"><p>");
		int i = 0;
		Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
		Connection conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;DatabaseName=seconditem","chris","123456");
		Statement stmt = conn.createStatement();
		String sql = "if not exists(select * from [user] where username=N'"+user.getUsername()+"')" + "insert into [user] (username,password,email) values(N'"+user.getUsername()+"','"+user.getPassword()+"','"+user.getEmail()+"')";
		//out.print(sql);
		i = stmt.executeUpdate(sql);
		stmt.close();
		conn.close();
		if(i==1)
			out.print("注册成功！5秒后为您转到登录页面");
		else
			out.print("账号已存在！5秒后为您转到登录页面");
		response.setHeader("refresh", "5;url='login.jsp'");
		out.print("</p></div></header></div></main>");
		return;
	}catch (Exception e) {
		out.print("注册失败");
		response.setHeader("refresh", "5;url='login.jsp'");
		out.print("</p></div></header></div></main>");
		e.printStackTrace();
	}
}

%>
<form class="contact_form" action="regist.jsp?regist=1" method="post" >
<ul>
	<li>
		<h2>注册</h2>
	</li>
	
	<li>
		<label for="name">用户名:</label>
		<input name="username" type="text" required /></p>
	</li>
	
	<li>
		<label for="name">密 码:</label>
		<input type="password" name="password" required /></p>
	</li>

<!--<p>再次确认：<input type="password" name="password" ></p>-->
	<li>
		<label for="email">邮箱:</label>
		<input type="email" name="email" required pattern="^\S+@\S+\.\S+" />
		<span class="form_hint">正确格式为：xxxxxx@xx.xxx</span>
	</li>
	<li>
		<button class="submit" type="submit">注册</button>
	</li>
</ul>
</form>
</body>
</html>