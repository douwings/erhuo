<%@ page language="java" pageEncoding="UTF-8" import="java.sql.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="css/main.css" />
<link rel="stylesheet" type="text/css" href="css/button.css" />
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
	列出书单
*/
request.setCharacterEncoding("UTF-8");
String itemname = request.getParameter("itemname");
String Spage = request.getParameter("page");
String buyitemid= request.getParameter("buyitemid");
int pageNow = 0;
if(Spage!=null)
{
pageNow = Integer.parseInt(Spage);
}
int eachPageCount = 10;

Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
Connection conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;DatabaseName=seconditem","chris","123456");
Statement stmt=conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
ResultSet rs =null;
int n=0;
if(itemname!=null)
{
	rs=stmt.executeQuery("select * from [item] where itemname like '%"+itemname+"%'");
}else{
	rs=stmt.executeQuery("select * from [item] where userid ="+userid);
	if(buyitemid==null)
		out.print("<a class=\"button medium green\" href=item.jsp?type=additem>添加物品</a><br>");
}
if(rs.next())
{
	rs.last();
	int rowCount =rs.getRow();//记录总数
	//out.print("记录总数"+rowCount);
	int pageCount = (rowCount+eachPageCount-1) / eachPageCount;//页总数
	if(pageNow==0)
	{
		pageNow=1;
	}
	if(pageNow==pageCount)
		n=rowCount - (pageCount-1)*eachPageCount;
	else
		n=eachPageCount;
	out.print("<br>");
	//out.print("n:"+n);
	//out.print("页总数"+pageCount);
	
	//out.print("pageNow:"+pageNow);
	rs.absolute((pageNow-1) * eachPageCount);
	out.print("<table id=\"mytable\"> <tr> <th>商品名</th> <th>价格</th> <th>分类</th> <th>上架时间</th> <th></th>");
	if(buyitemid!=null)
		out.print("<th>选择</th>");
	out.print(" </tr>");
	int j=0;
	for(int i =0;i<n;i++){
		rs.next();
		if((j++)%2==0)
			out.print("<tr> <td>");//行头
		else
			out.print("<tr class=\"alt\"> <td>");//行头
		out.print(rs.getString("itemname"));
		out.print("</td> <td>");//行中
		out.print(rs.getString("price"));
		out.print("</td> <td>");//行中
		stmt=conn.createStatement();
		ResultSet rs2=stmt.executeQuery("select b from classification where a="+rs.getString("classification"));
		rs2.next();
		out.print(rs2.getString("b"));
		out.print("</td> <td>");//行中
		out.print(rs.getString("onlisttime"));
		out.print("</td> <td>");//行中
		out.print("<a href=\"item.jsp?type=detail&id="+rs.getInt("itemid")+"\">详情</a>&nbsp&nbsp");//行中
		if(!rs.getString("userid").equals(userid))
			out.print("<a href=\"deal.jsp?type=adddeal&buyer="+userid+"&seller=" + rs.getString("itemid") + "\">购买</a>&nbsp&nbsp");
		if(itemname==null && buyitemid==null)
		{
			out.print("<a href=\"item.jsp?type=selitem&id="+rs.getInt("itemid")+"\">修改</a>&nbsp&nbsp");//行中
			out.print("<a href=\"handle.jsp?type=delitem&id="+rs.getInt("itemid")+"\">删除</a>&nbsp&nbsp");//行中
		}
		out.print("</td> </tr>");//行尾 
	}
	out.print("</table>");//表尾

	rs.close();
	stmt.close();
	conn.close();
	out.print("<br>第"+pageNow+"页/共"+pageCount+"页&nbsp;&nbsp");
	if(itemname!=null)
	{
		if(pageNow>1)
    		out.print("<a href=itemlist.jsp?page="+(pageNow-1)+"&itemname="+itemname+">上一页</a>&nbsp;");
		if(pageNow<pageCount)
    		out.print("<a href=itemlist.jsp?page="+(pageNow+1)+"&itemname="+itemname+">下一页</a>&nbsp;");
	}else{
		if(pageNow>1)
    		out.print("<a href=itemlist.jsp?page="+(pageNow-1)+">上一页</a>&nbsp;");
		if(pageNow<pageCount)
    		out.print("<a href=itemlist.jsp?page="+(pageNow+1)+">下一页</a>&nbsp;");
	}
}else{
	if(buyitemid!=null)
		out.print("<a class=\"c\" href=item.jsp?type=additem>添加物品</a><br>");
	if(itemname!=null)
		out.print("<br>未搜索到物品");
	else
		out.print("<br>您尚未添加物品");
}
%>

</header>
	</div>
</main>

</body>
</html>