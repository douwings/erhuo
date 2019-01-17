<%@ page language="java" pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" import="java.sql.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="css/main.css" />
<link rel="stylesheet" type="text/css" href="css/pop.css" />
<%@include file="/head.html"%>
<title>物品交换系统</title>
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
/*
	交换的订单
*/
request.setCharacterEncoding("UTF-8");
String type = request.getParameter("type");

if(type==null)
{
	out.print("参数为空");
	return;
}
if(type.equals("adddeal")){
	
		String buyer = request.getParameter("buyer");
		String seller = request.getParameter("seller");
		int i=0;
		Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
		Connection conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;DatabaseName=seconditem","chris","123456");
		String sql = "if not exists (select * from [deal] where buyer='"+buyer+"' and seller='"+seller+"')"+"insert into [deal] (buyer,seller,state) values('"+buyer+"','"+seller+"',0)";
		Statement stmt=conn.createStatement();
		//out.print(sql);
	    i = stmt.executeUpdate(sql);
	    
	    stmt.close();
		conn.close();
	    if(i==1)
	    	out.print("订单已发送");  
	    else
	    	out.print("订单已存在，请等待对方处理");
	    stmt.close();
		conn.close();
		out.println(",5秒后为您转到首页");
		out.print("</div>");
		response.setHeader("refresh", "5;url='deal.jsp?type=listdeal'");
	
}else if(type.equals("listdeal")) {
	
	try{
		out.print("<br>您发出的订单：<br>");
		out.print("<table id=\"mytable\"> <tr>  <th>商品名称</th> <th>价格</th> <th>归属</th> <th>订单状态</th> <th>操作</th> </tr>");
		Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
		Connection conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;DatabaseName=seconditem","chris","123456");
		Statement stmt=conn.createStatement();
		ResultSet rs=stmt.executeQuery(
				"select * from item where itemid in(select seller from deal where buyer="+userid+")");
		int i=0;
		while(rs.next()){
			if((i++)%2==0)
				out.print("<tr> <td>");//行头
			else
				out.print("<tr class=\"alt\"> <td>");//行头
			out.print(rs.getString("itemname"));
			out.print("</td> <td>");//行中
			out.print(rs.getString("price"));
			out.print("</td> <td>");//行中
			Statement stmt2=conn.createStatement();
			ResultSet rs2=stmt2.executeQuery("select * from [user] where userid ="+rs.getString("userid"));
			rs2.next();
			out.print(rs2.getString("username"));
			out.print("</td> <td>");//行中
			Statement stmt4=conn.createStatement();
			ResultSet rs4=stmt4.executeQuery("select * from deal where (seller="+rs.getString("itemid")+" and buyer="+userid+")");
			rs4.next();
			if(rs4.getInt("state")==1)
			{
				out.print("对方已接受，请联系该用户进行交换，邮箱：");//行中
				out.print(rs2.getString("email"));
				out.print("或&nbsp<a href=\"javascript:popchat("+userid+","+rs2.getString("userid")+",'"+rs2.getString("username")+"');\">在线交流</a>");
			}else if(rs4.getInt("state")==2)
				out.print("对方已拒绝");
			else if(rs4.getInt("state")==3)
				out.print("等待付款");
			else
				out.print("等待卖家处理");//行中
			out.print("</td> <td>");//行中
			Statement stmt3=conn.createStatement();
			ResultSet rs3=stmt3.executeQuery("select dealid from [deal] where buyer="+userid);
			for(int j=0;j<i;j++)
				rs3.next();
			out.print("<a href=\"handle.jsp?type=deldeal&id="+rs3.getInt("dealid")+"\">不想买了</a>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp");//行中
			
			out.print("</td> </tr>");//行尾
		}
		if(i==0)
			out.print("<tr> <td colspan=\"5\">您未发出任何订单！</td> </tr>");
		out.print("</table>");//表尾
		
	}catch (Exception e) {
		out.print("获取订单列表失败");
		e.printStackTrace();
	}
	
	try{
		out.print("<br>您收到的订单：<br>");
		out.print("<table id=\"mytable\"> <tr>  <th>购买人</th> <th>商品名称</th> <th>商品ID</th> <th>订单状态</th> <th>操作</th> </tr>");
		Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
		Connection conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;DatabaseName=seconditem","chris","123456");
		Statement stmt=conn.createStatement();
		ResultSet rs=stmt.executeQuery(
				"select [item].itemname,[item].itemid,[deal].buyer,[user].username,[deal].dealid,[deal].state from [item] " +
				"inner join [user] on [item].userid=[user].userid " +
				"inner join [deal] on [item].itemid=[deal].seller " +
				"where username = N'" + username + "'");
		int i=0;
		while(rs.next())
		{
			if((i++)%2==0)
				out.print("<tr> <td>");//行头
			else
				out.print("<tr class=\"alt\"> <td>");//行头
			Statement stmt2=conn.createStatement();
			ResultSet rs2=stmt2.executeQuery("select * from [user] where userid= "+rs.getString("buyer"));
			rs2.next();
			out.print(rs2.getString("username"));
			out.print("</td> <td>");//行中
			out.print(rs.getString("itemname"));
			out.print("</td> <td>");//行中
			out.print(rs.getString("itemid"));
			out.print("</td> <td>");//行中
			if(rs.getInt("state")==1){
				out.print("您已接受，请联系该用户进行交换，邮箱：");//行中
				out.print(rs2.getString("email"));
				out.print("或&nbsp<a href=\"javascript:popchat("+userid+","+rs2.getString("userid")+",'"+rs2.getString("username")+"');\">在线交流</a>");
				out.print("</td> <td>");//行中
			}else if(rs.getInt("state")==2){
				out.print("您已拒绝");//行中
				out.print("</td> <td>");//行中
			}else
			{
				out.print("待处理");//行中
				out.print("</td> <td>");//行中
				out.print("<a href=\"handle.jsp?type=refusedeal&id="+rs.getInt("dealid")+"\">拒绝</a>&nbsp&nbsp&nbsp&nbsp");//行中
				out.print("<a href=\"handle.jsp?type=acceptdeal&id="+rs.getInt("dealid")+"\">接受</a>&nbsp&nbsp&nbsp&nbsp");//行中
			}
			out.print("<a href=\"handle.jsp?type=deldeal&id="+rs.getInt("dealid")+"\">不想卖了</a>&nbsp&nbsp&nbsp&nbsp");
			out.print("</td> </tr>");//行尾
		}
		if(i==0)
			out.print("<tr> <td colspan=\"5\">您未收到任何订单！</td> </tr>");
		out.print("</table>");//表尾
	}catch (Exception e) {
		out.print("获取订单列表失败");
		e.printStackTrace();
	}
	
}else{
	out.print("未知参数：type="+type);//表尾
}
%>
</header>
	</div>
</main>

</body>
</html>