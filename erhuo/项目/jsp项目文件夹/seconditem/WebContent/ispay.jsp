<%@ page language="java" pageEncoding="UTF-8" import="java.sql.*"%>
<%
request.setCharacterEncoding("UTF-8");
String buyer = request.getParameter("buyer");//userid
String seller = request.getParameter("seller");//itemid

Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
Connection conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;DatabaseName=seconditem","chris","123456");
Statement stmt=conn.createStatement();
ResultSet rs = stmt.executeQuery("SELECT * FROM deal WHERE (buyer = "+buyer+" AND seller = "+seller+")");
rs.next();

if(rs.getInt("state")==0)
{	
	out.print("<p><img src=\"img/pay_ok.png\"></p><br>");
	out.print("恭喜您已付款成功！");
	out.println("<p><a href= \"index.jsp\">返回首页 </a>&nbsp");
	out.println("<a href=\"deal.jsp?type=listdeal\">查看我的订单</a></p>");
}
else
	out.print("N");

%>