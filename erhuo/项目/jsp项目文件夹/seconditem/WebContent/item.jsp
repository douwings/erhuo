<%@ page language="java" pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" import="java.sql.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="css/main.css" />
<title>物品交换系统</title>
<style>

</style>
<link rel="stylesheet" media="screen" href="css/form.css" >
<%@include file="/head.html"%>
<style type="text/css">
.contact_form{border:1px solid #DDDDDD;padding:10px;width:760px;margin:40px auto 0 auto;}
</style>
</head>
<body>

<%@include file="/search.jsp"%>
<%@include file="/top.jsp"%>
<%@include file="/chat_reply.jsp"%>
<%@include file="/chat_pop.jsp"%>
<main class="cd-main-content">
	<!-- your content here -->
	<div class="content-center">
		<!-- <h1>Advanced Search Form</h1> -->
		<header class="htmleaf-header">
		
<%
//列出书目详情

request.setCharacterEncoding("UTF-8");
String type = request.getParameter("type");

if(type==null)
{
	out.print("参数为空");
	return;
}

if(type.equals("detail"))
{
	String itemid = request.getParameter("id");
	
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	Connection conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;DatabaseName=seconditem","chris","123456");
	Statement stmt=conn.createStatement();
	ResultSet rs=stmt.executeQuery("select [item].*,[user].* from [item] full join [user] on [item].userid=[user].userid where itemid="+itemid);

	if(rs.next())
	{
		out.print("<img src=\""+"/img"+rs.getString("imgpath")+"\" style=\"max-width:100%;\"/>");
		out.print("<table id=\"mytable\"> <tr> <th colspan = \"2\">详情</th> </tr>");
		out.print("<tr> <td>物品ID</td> <td>"+rs.getString("itemid")+"</td> </tr>");
		out.print("<tr class=\"alt\">  <td>名称</td> <td>"+rs.getString("itemname")+"</td> </tr>");
		out.print("<tr>  <td>价格</td> <td>"+rs.getString("price")+"</td> </tr>");
		out.print("<tr class=\"alt\">  <td>详情</td> <td>"+rs.getString("description")+"</td> </tr>");

		stmt=conn.createStatement();
		ResultSet rs2=stmt.executeQuery("select b from classification where a="+rs.getString("classification"));
		rs2.next();
		out.print("<tr>  <td>分类</td> <td>"+rs2.getString("b")+"</td> </tr>");
		out.print("<tr class=\"alt\">  <td>上架日期</td> <td>"+rs.getString("onlisttime")+"</td> </tr>");
		//out.print("<tr> <td colspan = \"2\" ><img src=\""+"/img"+rs.getString("imgpath")+"\" style=\"max-width:100%;\"/></td> </tr>");
		
		if(!rs.getString("userid").equals(userid))
		{	
			out.print("<tr> <td>归属</td> <td>"+rs.getString("username")+"</td> </tr>");
			out.print("<tr class=\"alt\"> <td>购买</td> <td><a href=\"deal.jsp?type=adddeal&buyer="+userid+"&seller=" + rs.getString("itemid") + "\">是</a></td> </tr>");
		}	
	}
	
	rs.close();
	stmt.close();
	conn.close();
}else if (type.equals("additem"))
{
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	Connection conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;DatabaseName=seconditem","chris","123456");
	Statement stmt=conn.createStatement();
	ResultSet rs=stmt.executeQuery("select * from classification");
	response.setContentType("text/html;charset=utf-8");
	out.print("<form class=\"contact_form\" action=\"handle.jsp?type=additem\" enctype=\"multipart/form-data\" method=\"post\">\n<ul>");
	out.print("<li><h2>添加物品</h2></li>\n");
	out.print("<li><label for=\"name\">物品名称：</label><input required type=\"text\" name=\"itemname\" /></li>\n");
	out.print("<li><label for=\"name\">价格：</label><input required name=\"price\" ><span class=\"form_hint\">正确格式为：xx.xx</span></li>\n");
	out.print("<li><label for=\"name\">分类：</label><select name=\"classification\">");
    while(rs.next())
   	out.print("<option value="+rs.getString("a")+">"+rs.getString("b")+"</option>");
   	out.print("</select></li>\n");
   	
   	out.print("<li><label for=\"name\">详情：</label><textarea type=\"text\" name=\"description\" style=\"width:220px;height:80px;\"></textarea></li>\n");
   	//out.print("<li><label for=\"name\">详情：</label><input required type=\"text\" name=\"description\" /></li>\n");
	out.print("<li><label for=\"name\">实物照片：</label><input type=\"file\" style=\"border:0px;box-shadow:none\" name=\"file1\"></li>\n");
	
   	out.print("<li><button class=\"submit\" type=\"submit\">确定</button></li>\n");
	out.print("</ul>\n</form>");
}else if (type.equals("selitem")) {
	String id = request.getParameter("id");
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	Connection conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;DatabaseName=seconditem","chris","123456");
	Statement stmt=conn.createStatement();
	ResultSet rs=stmt.executeQuery("select [item].*,[user].* from [item] full join [user] on [item].userid=[user].userid where itemid="+id);
	response.setContentType("text/html;charset=utf-8");
	if(rs.next())
	{
		out.print("<form class=\"contact_form\" action=\"handle.jsp?type=updateitem\" method=\"post\" name=\"contact_form\">");
		out.print("<ul><li><h2>修改物品信息</h2></li>");
		
		out.print("<input name=\"itemid\" type=\"hidden\" value=\""+rs.getString("itemid")+"\" required /></li>");

		
		out.print("<li><label for=\"name\">物品名称：</label><input required type=\"text\" value=\""+rs.getString("itemname")+"\" name=\"itemname\" /></li>\n");
		out.print("<li><label for=\"name\">价格：</label><input required value=\""+rs.getString("price")+"\" name=\"price\" ><span class=\"form_hint\">正确格式为：xx.xx</span></li>\n");
		//stmt=conn.createStatement();
		//ResultSet rs2=stmt.executeQuery("select b from classification where a="+rs.getString("classification"));
		//rs2.next();
		out.print("<li><label for=\"name\">分类：</label><select name=\"classification\">");
		stmt=conn.createStatement();
		ResultSet rs3=stmt.executeQuery("select * from classification");
		while(rs3.next())
	   		out.print("<option value="+rs3.getString("a")+">"+rs3.getString("b")+"</option>");
	   	out.print("</select></li>\n");
	   	
	   	out.print("<li><label for=\"name\">详情：</label><textarea type=\"text\" name=\"description\" style=\"width:220px;height:80px;\">"+rs.getString("description")+"</textarea></li>\n");
		//out.print("<li><label for=\"name\">实物照片：</label><input type=\"file\" style=\"border:0px;box-shadow:none\" name=\"file1\"></li>\n");
		
	   	out.print("<li><button class=\"submit\" type=\"submit\">修改</button></li>\n");
		out.print("</ul>\n</form>");
	}
}
%>
</header>
	</div>
</main>

</body>
</html>