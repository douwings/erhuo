package seconditem;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.sql.*;
import java.text.*;
import java.util.*;

/**
 * Servlet implementation class funcation
 */
@WebServlet("/funcation")
public class admin extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public admin() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setHeader("Content-Type", "text/html;charset=UTF-8");
		response.getWriter().append(
				"<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">");
		response.getWriter().append("<html>");
		response.getWriter().append("<head>");
		response.getWriter().append("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">");
		response.getWriter().append("<link rel=\"stylesheet\" type=\"text/css\" href=\"css/main.css\" />");
		response.getWriter().append("<link rel=\"stylesheet\" media=\"screen\" href=\"css/form.css\" >");
		response.getWriter().append("<link rel=\"stylesheet\" type=\"text/css\" href=\"css/pop.css\" />");
		response.getWriter().append("<style type=\"text/css\">");
		response.getWriter().append(".contact_form{border:1px solid #DDDDDD;padding:10px;width:760px;margin:40px auto 0 auto;}");
		response.getWriter().append("</style>");
		response.getWriter().append("<title>书籍交换系统</title>");
		response.getWriter().append("</head>");
		response.getWriter().append("<body>");
		
		try {
			
			
			
			request.setCharacterEncoding("UTF-8");
			String type = request.getParameter("type");
			String userid = request.getParameter("userid");
			if (type == null) {
				response.getWriter().append("未知参数type="+type);
				response.getWriter().append("</body>");
				response.getWriter().append("</html>");
				return;
			}

			if (type.equals("listuser")) {
				top(request,response);
				Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
				Connection conn = DriverManager
						.getConnection("jdbc:sqlserver://localhost:1433;DatabaseName=seconditem", "chris", "123456");
				Statement stmt = conn.createStatement();
				ResultSet rs = stmt.executeQuery("select * from [user]");
				boolean flag = false;
				response.getWriter().append(
						"<table id=\"mytable\"> <tr> <th>id</th> <th>用户名</th> <th>密码</th> <th>邮箱</th> <th>操作</th> </tr>");
				int i = 0;
				while (rs.next()) {
					if ((i++) % 2 == 0)
						response.getWriter().append("<tr> <td>");// 行头
					else
						response.getWriter().append("<tr class=\"alt\"> <td>");// 行头
					response.getWriter().append(rs.getString("userid"));
					response.getWriter().append("</td> <td>");// 行中
					response.getWriter().append(rs.getString("username"));
					response.getWriter().append("</td> <td>");// 行中
					response.getWriter().append(rs.getString("password"));
					response.getWriter().append("</td> <td>");// 行中
					response.getWriter().append(rs.getString("email"));
					response.getWriter().append("</td> <td>");//行中
					response.getWriter().append("<a href=\"admin.php?type=seluser&id="+rs.getInt("userid")+"\">修改</a>");
					response.getWriter().append("<a href=\"admin.php?type=deluser&id="+rs.getInt("userid")+"\">删除</a>");
					response.getWriter().append("</td> </tr>");// 行尾
				}
				response.getWriter().append("</table>");// 表尾
				rs.close();
				stmt.close();
				conn.close();
				return;
			}else if (type.equals("listitem")) {
				top(request,response);
				Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
				Connection conn = DriverManager
						.getConnection("jdbc:sqlserver://localhost:1433;DatabaseName=seconditem", "chris", "123456");
				Statement stmt = conn.createStatement();
				ResultSet rs = stmt.executeQuery("select * from [item]");
				boolean flag = false;
				response.getWriter().append(
						"<table id=\"mytable\"> <tr> <th>id</th> <th>书名</th> <th>出版社</th> <th>印刷日期</th> <th>作者</th> <th>分类</th> <th>上架时间</th> <th>归属</th> <th>操作</th>");
				int i = 0;
				while (rs.next()) {
					if ((i++) % 2 == 0)
						response.getWriter().append("<tr> <td>");// 行头
					else
						response.getWriter().append("<tr class=\"alt\"> <td>");// 行头
					response.getWriter().append(""+rs.getInt("itemid"));
					response.getWriter().append("</td> <td>");//行中
					response.getWriter().append(rs.getString("itemname"));
					response.getWriter().append("</td> <td>");//行中
					response.getWriter().append(rs.getString("pressname"));
					response.getWriter().append("</td> <td>");//行中
					response.getWriter().append(rs.getString("printdate"));
					response.getWriter().append("</td> <td>");//行中
					response.getWriter().append(rs.getString("author"));
					response.getWriter().append("</td> <td>");//行中
					stmt=conn.createStatement();
					ResultSet rs2=stmt.executeQuery("select b from classification where a="+rs.getString("classification"));
					rs2.next();
					response.getWriter().append(rs2.getString("b"));
					response.getWriter().append("</td> <td>");//行中
					response.getWriter().append(rs.getString("onlisttime"));
					response.getWriter().append("</td> <td>");//行中
					stmt=conn.createStatement();
					ResultSet rs3=stmt.executeQuery("select username from [user] where userid="+rs.getString("userid"));
					rs3.next();
					response.getWriter().append(rs3.getString("username"));
					response.getWriter().append("</td> <td>");//行中
					response.getWriter().append("<a href=\"admin.php?type=selitem&id="+rs.getInt("itemid")+"\">修改</a>");
					response.getWriter().append("<a href=\"admin.php?type=delitem&id="+rs.getInt("itemid")+"\">删除</a>");
					response.getWriter().append("</td> </tr>");// 行尾
				}
				response.getWriter().append("</table>");// 表尾
				rs.close();
				stmt.close();
				conn.close();
				return;
			} else if (type.equals("delitem")) {
				response.getWriter().append("<div class=\"speech-bubble speech-bubble-left\">");
				String id = request.getParameter("id");
				int i = 0;
				Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
				Connection conn = DriverManager
						.getConnection("jdbc:sqlserver://localhost:1433;DatabaseName=seconditem", "chris", "123456");
				Statement stmt = conn.createStatement();
				i = stmt.executeUpdate("delete from [item] where itemid = " + id);
				if(i==1)
				{
					response.getWriter().append("删除成功");
					response.getWriter().append(",5秒后返回");
					response.setHeader("refresh", "5;url='index.jsp'");
				}else{
					response.getWriter().append("删除失败");
					response.getWriter().append(",5秒后返回");
					response.setHeader("refresh", "5;url='index.jsp'");
				}
			} else if (type.equals("deluser")) {
				response.getWriter().append("<div class=\"speech-bubble speech-bubble-left\">");
				String id = request.getParameter("id");
				int i = 0;
				Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
				Connection conn = DriverManager
						.getConnection("jdbc:sqlserver://localhost:1433;DatabaseName=seconditem", "chris", "123456");
				Statement stmt = conn.createStatement();
				i = stmt.executeUpdate("delete from [user] where userid = " + id);
				if(i==1)
				{
					response.getWriter().append("删除成功");
					response.getWriter().append(",5秒后返回");
					response.setHeader("refresh", "5;url='index.jsp'");
				}else{
					response.getWriter().append("删除失败");
					response.getWriter().append(",5秒后返回");
					response.setHeader("refresh", "5;url='index.jsp'");
				}
			}else if (type.equals("seluser")) {
				String id = request.getParameter("id");
				Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
				Connection conn = DriverManager
						.getConnection("jdbc:sqlserver://localhost:1433;DatabaseName=seconditem", "chris", "123456");
				Statement stmt = conn.createStatement();
				ResultSet rs = stmt.executeQuery("select * from [user] where userid = " + id);
				if(rs.next())
				{
					response.getWriter().append("<form class=\"contact_form\" action=\"admin.php?type=updateuser\" method=\"post\" name=\"contact_form\">");
					response.getWriter().append("<ul><li><h2>修改用户信息</h2></li>");
					
					response.getWriter().append("<input name=\"userid\" type=\"hidden\" value=\""+rs.getString("userid")+"\" required /></li>");

					
					response.getWriter().append("<li><label for=\"name\">用户名:</label>");
					response.getWriter().append("<input name=\"username\" type=\"text\" value=\""+rs.getString("username")+"\" required /></li>");
					
					response.getWriter().append("<li><label for=\"name\">密码:</label>");
					response.getWriter().append("<input name=\"password\" type=\"text\" value=\""+rs.getString("password")+"\" required /></li>");
					
					response.getWriter().append("<li><label for=\"name\">邮箱:</label>");
					response.getWriter().append("<input name=\"email\" type=\"text\" value=\""+rs.getString("email")+"\" required /></li>");
					
					response.getWriter().append("<li><button class=\"submit\" type=\"submit\">修改</button></li></ul>	</form>");
				}
			}else if (type.equals("updateuser")) {
				response.getWriter().append("<div class=\"speech-bubble speech-bubble-left\">");
				String username = request.getParameter("username");
				String password = request.getParameter("password");
				String email = request.getParameter("email");
				String id = request.getParameter("userid");
				
				int i = 0;
				Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
				Connection conn = DriverManager
						.getConnection("jdbc:sqlserver://localhost:1433;DatabaseName=seconditem", "chris", "123456");
				Statement stmt = conn.createStatement();
				i = stmt.executeUpdate("UPDATE [user] SET username = N'"+username+"', password = '"+password+"', email ='"+email+"' WHERE userid = " + id);
				if(i==1)
				{
					response.getWriter().append("修改成功");
					response.getWriter().append(",5秒后返回");
					response.setHeader("refresh", "5;url='index.jsp'");
				}else{
					response.getWriter().append("修改失败");
					response.getWriter().append(",5秒后返回");
					response.setHeader("refresh", "5;url='index.jsp'");
				}
			}else if (type.equals("selitem")) {
				String id = request.getParameter("id");
				Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
				Connection conn = DriverManager
						.getConnection("jdbc:sqlserver://localhost:1433;DatabaseName=seconditem", "chris", "123456");
				Statement stmt = conn.createStatement();
				ResultSet rs = stmt.executeQuery("select * from [item] where itemid = " + id);
				if(rs.next())
				{
					response.getWriter().append("<form class=\"contact_form\" action=\"admin.php?type=updateitem\" method=\"post\" name=\"contact_form\">");
					response.getWriter().append("<ul><li><h2>修改书籍信息</h2></li>");
					
					response.getWriter().append("<input name=\"itemid\" type=\"hidden\" value=\""+rs.getString("itemid")+"\" required /></li>");

					
					response.getWriter().append("<li><label for=\"name\">书名:</label>");
					response.getWriter().append("<input name=\"itemname\" type=\"text\" value=\""+rs.getString("itemname")+"\" required /></li>");
					
					response.getWriter().append("<li><label for=\"name\">出版社名:</label>");
					response.getWriter().append("<input name=\"pressname\" type=\"text\" value=\""+rs.getString("pressname")+"\" required /></li>");
					
					response.getWriter().append("<li><label for=\"name\">作者:</label>");
					response.getWriter().append("<input name=\"author\" type=\"text\" value=\""+rs.getString("author")+"\" required /></li>");
					
					response.getWriter().append("<li><label for=\"name\">印刷日期:</label>");
					response.getWriter().append("<input name=\"printdate\" type=\"text\" value=\""+rs.getString("printdate")+"\" required pattern=\"^((((19|20)\\d{2})-(0?[13-9]|1[012])-(0?[1-9]|[12]\\d|30))|(((19|20)\\d{2})-(0?[13578]|1[02])-31)|(((19|20)\\d{2})-0?2-(0?[1-9]|1\\d|2[0-8]))|((((19|20)([13579][26]|[2468][048]|0[48]))|(2000))-0?2-29))$\"name=\"printdate\" ><span class=\"form_hint\">正确格式为：2016-01-01</span></li>");
					
					stmt=conn.createStatement();
					ResultSet rs2=stmt.executeQuery("select * from classification");
					response.getWriter().append("<li><label for=\"name\">分类：</label><select name=\"classification\">");
				    while(rs2.next())
				    	response.getWriter().append("<option value="+rs2.getString("a")+">"+rs2.getString("b")+"</option>");
				    response.getWriter().append("</select></li>\n");
				   	
					response.getWriter().append("<li><button class=\"submit\" type=\"submit\">修改</button></li></ul>	</form>");
				}
			}else if (type.equals("updateitem")) {
				response.getWriter().append("<div class=\"speech-bubble speech-bubble-left\">");
				String itemname = request.getParameter("itemname");
				String classification = request.getParameter("classification");
				String price = request.getParameter("price");
				String description = request.getParameter("description");
				
				String id = request.getParameter("itemid");
				
				int i = 0;
				Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
				Connection conn = DriverManager
						.getConnection("jdbc:sqlserver://localhost:1433;DatabaseName=seconditem", "chris", "123456");
				Statement stmt = conn.createStatement();
				i = stmt.executeUpdate(
						"UPDATE [item] SET itemname = N'"+itemname+"', classification = '"+classification+"', price ='"+price+"', description =N'"+description+"' WHERE itemid = " + id);
				if(i==1)
				{
					response.getWriter().append("修改成功");
					response.getWriter().append(",5秒后返回");
					response.setHeader("refresh", "5;url='index.jsp'");
				}else{
					response.getWriter().append("修改失败");
					response.getWriter().append(",5秒后返回");
					response.setHeader("refresh", "5;url='index.jsp'");
				}
			}else {
				response.getWriter().append("未知参数：type=" + type);// 表尾
			}

			
			
		} catch (ClassNotFoundException | SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		response.getWriter().append("</div>");
		response.getWriter().append("</body>");
		response.getWriter().append("</html>");
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

	protected void top(HttpServletRequest request, HttpServletResponse response) throws IOException{
		String username="";
		String userid="";
		String userroot="";
		Cookie[] cookies_top = request.getCookies();
		Cookie usernameCookie = null;
		Cookie useridCookie = null;
		if(cookies_top !=null)
		{
			int i;
			for(i=0;i<cookies_top.length;i++)
			{
				if(cookies_top[i].getName().equals("username"))
				{
					usernameCookie = cookies_top[i];
					username = java.net.URLDecoder.decode(usernameCookie.getValue().toString(),"UTF-8");
				}else if (cookies_top[i].getName().equals("userid"))
				{
					useridCookie = cookies_top[i];
					userid = java.net.URLDecoder.decode(useridCookie.getValue().toString(),"UTF-8");
				}else if (cookies_top[i].getName().equals("userroot"))
				{
					useridCookie = cookies_top[i];
					userroot = java.net.URLDecoder.decode(useridCookie.getValue().toString(),"UTF-8");
				}
			}
			if(usernameCookie==null)
			{
				response.sendRedirect("login.jsp");
				return;
			}
		}else{
			response.sendRedirect("login.jsp");
			return;
		}
	
		response.getWriter().append("<div class=\"left\">");
				response.getWriter().append("<a class=\"c\" href= \"javascript:history.back(); \">返回 </a>");
		response.getWriter().append("&nbsp&nbsp&nbsp");
				response.getWriter().append("<a class=\"c\" href= \"index.jsp\">首页 </a>");
						response.getWriter().append("</div>");
								response.getWriter().append("<div class=\"right\">");
										response.getWriter().append("<a class=\"c\" href=\"user.jsp?username="+username+"\">"+username+"</a>");
										response.getWriter().append("&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp");
												response.getWriter().append("<a class=\"c\" href=\"handle.jsp?type=logout\">退出登录</a>");
														response.getWriter().append("</div>");

																response.getWriter().append("<br>");
	}
}
