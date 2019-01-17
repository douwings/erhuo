<%@ page language="java" pageEncoding="UTF-8" import="java.sql.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Insert title here</title>
</head>
<body>
<%
request.setCharacterEncoding("UTF-8");
String a = request.getParameter("a");//userid
String[] b = a.split(";");
String buyer = b[0];
String seller = b[1];

Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
Connection conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;DatabaseName=seconditem","chris","123456");

String sql = "UPDATE deal SET state = 0 WHERE (buyer = "+buyer+" AND seller = "+seller+")";
Statement stmt=conn.createStatement();
//out.print(sql);
int i = stmt.executeUpdate(sql);
if(i==1)
	out.print("您通过支付宝付款成功<br>（这仅仅是个付款的demo，因为付款需要申请支付宝API，并且需要营业执照，作为学生申请不来。）");
else
	out.print("wrong");
%>
</body>
</html>