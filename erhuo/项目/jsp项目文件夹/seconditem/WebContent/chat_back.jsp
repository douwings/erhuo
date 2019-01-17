<%@ page language="java" pageEncoding="UTF-8" import="java.sql.*" import="java.text.SimpleDateFormat" import="java.util.Date"%><%
request.setCharacterEncoding("UTF-8");
String type = request.getParameter("type");
if(type.equals("getmess"))
{
	String from = request.getParameter("from");//自己的id
	String to = request.getParameter("to");
	
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	Connection conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;DatabaseName=seconditem","chris","123456");
	Statement stmt = conn.createStatement();
	ResultSet rs=stmt.executeQuery("select * from chat where (([from] ="+from+" AND [to]="+to+") OR ([from] ="+to+" AND [to]="+from+")) ORDER BY time");
	
	Statement stmt2 = conn.createStatement();
	ResultSet rs2=stmt2.executeQuery("select * from [user] where userid = "+to);
	rs2.next();
	String nameTo = rs2.getString("username");
	out.println("chat with "+nameTo);
	while(rs.next())
	{
		String time = rs.getString("time");
		time=time.substring(0,time.length()-8);
		Date d = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");  
	    String dateNowStr = sdf.format(d);
	    //time = time.replace(dateNowStr+" ", "");
	    
		if(rs.getInt("from")==Integer.parseInt(from))
		{
			//out.println("<div id=\"green\">你 "+time+"</div>");
			out.println("<div class=\"talk_recordboxme\">");
			out.println("<div class=\"user\"><img src=\"images/thumbs/15.jpg\"/>我</div>");
			out.println("<div class=\"talk_recordtextbg\">&nbsp;</div><div class=\"talk_recordtext\"><h3>");
		}else
		{
			out.println("<div class=\"talk_recordbox\">");
			out.println("<div class=\"user\"><img src=\"images/thumbs/11.jpg\"/>他</div>");
			out.println("<div class=\"talk_recordtextbg\">&nbsp;</div><div class=\"talk_recordtext\"><h3>");
		}
		out.println(rs.getString("message"));
		out.println("</h3><span class=\"talk_time\">");
		out.println(dateNowStr);
		out.println("</span></div></div>");
	}
}else if(type.equals("sendmess"))
{
	String from = request.getParameter("from");//自己的id
	String to = request.getParameter("to");
	String mess = request.getParameter("mess");
	
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	Connection conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;DatabaseName=seconditem","chris","123456");
	Statement stmt = conn.createStatement();
	int i = stmt.executeUpdate("INSERT INTO chat ([from], [to] ,message,state) VALUES ('"+from+"', '"+to+"', '"+mess+"' ,'0')");
	if(i==1)
		out.print("success");
	else
		out.print("fail");

}else if(type.equals("newmess"))
{
	String to = request.getParameter("to");
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	Connection conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;DatabaseName=seconditem","chris","123456");
	Statement stmt = conn.createStatement();
	ResultSet rs=stmt.executeQuery("select * from chat where (state = '0' and [to] = '"+to+"')");
	
	if(rs.next())
	{
		out.print("Y");
	}else
		out.print("N");
}else if(type.equals("mess"))
{
	String to = request.getParameter("to");
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	Connection conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;DatabaseName=seconditem","chris","123456");
	Statement stmt = conn.createStatement();
	ResultSet rs=stmt.executeQuery("select * from chat where (state = '0' and [to] = '"+to+"')");
	
	
    
	if(rs.next())
	{
		String time = rs.getString("time");
		time=time.substring(0,time.length()-8);
		Date d = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");  
	    String dateNowStr = sdf.format(d);
	    time = time.replace(dateNowStr+" ", "");
	    
		Statement stmt3 = conn.createStatement();
		ResultSet rs3=stmt3.executeQuery("select * from [user] where userid = "+rs.getString("from"));
		rs3.next();
		String nameTo = rs3.getString("username");
		
		out.print(nameTo+";"+rs.getString("from")+";<p>来自:"+nameTo+"&nbsp"+rs.getString("message")+"&nbsp"+time+"</p>");
		Statement stmt2=conn.createStatement();
	    int i = stmt2.executeUpdate("update [chat] set state = '1' where chatid = " + rs.getString("chatid"));
	}
}

%>