<%@ page language="java" pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" 
import="java.sql.*" 
import="java.io.*" 
import="org.apache.commons.fileupload.*" 
import="java.text.*" 
import="java.util.*"
import="org.apache.commons.fileupload.servlet.ServletFileUpload"
import="org.apache.commons.fileupload.disk.DiskFileItemFactory"
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@include file="/head.html"%>
<link rel="stylesheet" type="text/css" href="css/main.css" />
<link rel="stylesheet" type="text/css" href="css/pop.css" />
<link rel="stylesheet" type="text/css" href="css/content.css" />
<link rel="stylesheet" media="screen" href="css/form.css" >
<title>二货</title>
</head>
<body>
<%@include file="/search.jsp"%>
<%@include file="/top.jsp"%>
<jsp:useBean id="user" class ="seconditem.userBean" scope="page">
<jsp:setProperty name ="user" property="*"/>
</jsp:useBean>

<main class="cd-main-content">
	<div class="content-center">
		<header class="htmleaf-header">
<%
request.setCharacterEncoding("UTF-8");
String type = request.getParameter("type");

if(type==null)
{
	out.print("参数为空");
	out.print("</p></div>");
	return;
}

if(type.equals("listuser"))
{
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	Connection conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;DatabaseName=seconditem","chris","123456");
	Statement stmt=conn.createStatement();
	ResultSet rs=stmt.executeQuery("select * from [user]");
	boolean flag = false;
	out.print("<table id=\"mytable\"> <tr> <th>用户id</th> <th>用户名</th> <th>密码</th> <th>邮箱</th> <th>操作</th> </tr>");
	int j=0;
	while(rs.next()){
		if((j++)%2==0)
			out.print("<tr> <td>");//行头
		else
			out.print("<tr class=\"alt\"> <td>");//行头
		out.print(rs.getString("userid"));
		out.print("</td> <td>");//行中
		out.print(rs.getString("username"));
		out.print("</td> <td>");//行中
		out.print(rs.getString("password"));
		out.print("</td> <td>");//行中
		out.print(rs.getString("email"));
		out.print("</td> <td>");//行中
		out.println("<a href=\"handle2.jsp?type=seluser&id="+rs.getInt("userid")+"\">修改</a>");
		out.println("<a href=\"handle.jsp?type=deluser&id="+rs.getInt("userid")+"\">删除</a>");
		out.print("</td> </tr>");//行尾
	}
	out.print("</table>");//表尾
	rs.close();
	stmt.close();
	conn.close();
	return;
}else if (type.equals("seluser")) {
	String id = request.getParameter("id");
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	Connection conn = DriverManager
			.getConnection("jdbc:sqlserver://localhost:1433;DatabaseName=seconditem", "chris", "123456");
	Statement stmt = conn.createStatement();
	ResultSet rs = stmt.executeQuery("select * from [user] where userid = " + id);
	if(rs.next())
	{
		out.println("<form class=\"contact_form\" action=\"handle.jsp?type=updateuser\" method=\"post\" name=\"contact_form\">");
		out.println("<ul><li><h2>修改用户信息</h2></li>");
		
		out.println("<input name=\"userid\" type=\"hidden\" value=\""+rs.getString("userid")+"\" required /></li>");

		
		out.println("<li><label for=\"name\">用户名:</label>");
		out.println("<input name=\"username\" type=\"text\" value=\""+rs.getString("username")+"\" required /></li>");
		
		out.println("<li><label for=\"name\">密码:</label>");
		out.println("<input name=\"password\" type=\"text\" value=\""+rs.getString("password")+"\" required /></li>");
		
		out.println("<li><label for=\"name\">邮箱:</label>");
		out.println("<input name=\"email\" type=\"text\" value=\""+rs.getString("email")+"\" required /></li>");
		
		out.println("<li><button class=\"submit\" type=\"submit\">修改</button></li></ul>	</form>");
	}
}else if (type.equals("listitem")) {
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	Connection conn = DriverManager
			.getConnection("jdbc:sqlserver://localhost:1433;DatabaseName=seconditem", "chris", "123456");
	Statement stmt = conn.createStatement();
	ResultSet rs = stmt.executeQuery("select * from [item]");
	boolean flag = false;
	out.println(
			"<table id=\"mytable\"> <tr> <th>物品id</th> <th>物品名</th> <th>价格</th> <th>分类</th> <th>上架时间</th> <th>归属</th> <th>操作</th> </tr>");
	int i = 0;
	while (rs.next()) {
		if ((i++) % 2 == 0)
			out.println("<tr> <td>");// 行头
		else
			out.println("<tr class=\"alt\"> <td>");// 行头
		out.println(""+rs.getInt("itemid"));
		out.println("</td> <td>");//行中
		out.println(rs.getString("itemname"));
		out.println("</td> <td>");//行中
		out.println(rs.getString("price"));
		out.println("</td> <td>");//行中
		stmt=conn.createStatement();
		ResultSet rs2=stmt.executeQuery("select b from classification where a="+rs.getString("classification"));
		rs2.next();
		out.println(rs2.getString("b"));
		out.println("</td> <td>");//行中
		out.println(rs.getString("onlisttime"));
		out.println("</td> <td>");//行中
		stmt=conn.createStatement();
		ResultSet rs3=stmt.executeQuery("select username from [user] where userid="+rs.getString("userid"));
		rs3.next();
		out.println(rs3.getString("username"));
		out.println("</td> <td>");//行中
		out.println("<a href=\"item.jsp?type=selitem&id="+rs.getInt("itemid")+"\">修改</a>");
		out.println("<a href=\"handle.jsp?type=delitem&id="+rs.getInt("itemid")+"\">删除</a>");
		out.println("</td> </tr>");// 行尾
	}
	out.println("</table>");// 表尾
	rs.close();
	stmt.close();
	conn.close();
	return;
} else {
	out.println("未知参数：type=" + type);// 表尾
}
%>
		</header>
	</div>
</main>
</body>
</html>