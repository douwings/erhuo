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
		
<%!
String uploadimg(HttpServletRequest request){
	
	//得到上传文件的保存目录，将上传的文件存放于WEB-INF目录下，不允许外界直接访问，保证上传文件的安全
                String a="W:";
				String savePath = a+"/upload";
                //上传时生成的临时文件保存目录
                String tempPath = a+"/temp";
                File tmpFile = new File(tempPath);
                if (!tmpFile.exists()) {
                    //创建临时目录
                    tmpFile.mkdir();
                }
                
                //消息提示
                String message = "";
                String result="";
                try{
                    //使用Apache文件上传组件处理文件上传步骤：
                    //1、创建一个DiskFileItemFactory工厂
                    DiskFileItemFactory factory = new DiskFileItemFactory();
                    //设置工厂的缓冲区的大小，当上传的文件大小超过缓冲区的大小时，就会生成一个临时文件存放到指定的临时目录当中。
                    factory.setSizeThreshold(1024*100);//设置缓冲区的大小为100KB，如果不指定，那么缓冲区的大小默认是10KB
                    //设置上传时生成的临时文件的保存目录
                    factory.setRepository(tmpFile);
                    //2、创建一个文件上传解析器
                    ServletFileUpload upload = new ServletFileUpload(factory);
                    //监听文件上传进度
                    upload.setProgressListener(new ProgressListener(){
                        public void update(long pBytesRead, long pContentLength, int arg2) {
                            //System.out.println("文件大小为：" + pContentLength + ",当前已处理：" + pBytesRead);
                            /**
                             * 文件大小为：14608,当前已处理：4096
                                                                                   文件大小为：14608,当前已处理：7367
                                                                                   文件大小为：14608,当前已处理：11419
                                                                                   文件大小为：14608,当前已处理：14608
                             */
                        }
                    });
                     //解决上传文件名的中文乱码
                    upload.setHeaderEncoding("UTF-8"); 
                    //3、判断提交上来的数据是否是上传表单的数据
                    if(!ServletFileUpload.isMultipartContent(request)){
                        //按照传统方式获取数据
                        return "提交数据非二进制";
                    }
                    //设置上传单个文件的大小的最大值，目前是设置为1024*1024字节，也就是1MB
                    upload.setFileSizeMax(1024*1024);
                    //设置上传文件总量的最大值，最大值=同时上传的多个文件的大小的最大值的和，目前设置为10MB
                    upload.setSizeMax(1024*1024*10);
                    //4、使用ServletFileUpload解析器解析上传数据，解析结果返回的是一个List<FileItem>集合，每一个FileItem对应一个Form表单的输入项
                    List<FileItem> list = upload.parseRequest(request);
                    for(FileItem item : list){
                        //如果fileitem中封装的是普通输入项的数据
                        if(item.isFormField()){
                            String name = item.getFieldName();
                            //解决普通输入项的数据的中文乱码问题
                            String value = item.getString("UTF-8");
                            //value = new String(value.getBytes("iso8859-1"),"UTF-8");
                            //System.out.println(name + "=" + value);
                            result+=name+";="+value+";;";
                        }else{//如果fileitem中封装的是上传文件
                            //得到上传的文件名称，
                            String filename = item.getName();
                            System.out.println(filename);
                            if(filename==null || filename.trim().equals("")){
                                continue;
                            }
                            //注意：不同的浏览器提交的文件名是不一样的，有些浏览器提交上来的文件名是带有路径的，如：  c:\a\b\1.txt，而有些只是单纯的文件名，如：1.txt
                            //处理获取到的上传文件的文件名的路径部分，只保留文件名部分
                            filename = filename.substring(filename.lastIndexOf("\\")+1);
                            //得到上传文件的扩展名
                            String fileExtName = filename.substring(filename.lastIndexOf(".")+1);
                            //如果需要限制上传的文件类型，那么可以通过文件的扩展名来判断上传的文件类型是否合法
                            System.out.println("上传的文件的扩展名是："+fileExtName);
                            //获取item中的上传文件的输入流
                            InputStream in = item.getInputStream();
                            //得到文件保存的名称
                            String saveFilename = makeFileName(filename);
                            //得到文件的保存目录
                            String realSavePath = makePath(saveFilename, savePath);
                            String filename_databse = realSavePath+"/"+saveFilename;
                            filename_databse=filename_databse.replace("\\", "/");
                            //System.out.println(filename_databse);
                            //filename_databse=filename_databse.replace(savePath, "");
                            //System.out.println(filename_databse);
                            //创建一个文件输出流
                            FileOutputStream out = new FileOutputStream(realSavePath + "\\" + saveFilename);
                            //创建一个缓冲区
                            byte buffer[] = new byte[1024];
                            //判断输入流中的数据是否已经读完的标识
                            int len = 0;
                            //循环将输入流读入到缓冲区当中，(len=in.read(buffer))>0就表示in里面还有数据
                            while((len=in.read(buffer))>0){
                                //使用FileOutputStream输出流将缓冲区的数据写入到指定的目录(savePath + "\\" + filename)当中
                                out.write(buffer, 0, len);
                            }
                            //关闭输入流
                            in.close();
                            //关闭输出流
                            out.close();
                            //删除处理文件上传时生成的临时文件
                            //item.delete();
                            message = filename_databse;
                            System.out.println("文件上传成功");
                            filename_databse = filename_databse.replace(a, "");
                            filename_databse = filename_databse.replace("/upload", "");
                            result+=filename_databse;
							return result;
                        }
                    }
                }catch (FileUploadBase.FileSizeLimitExceededException e) {
                    e.printStackTrace();
                    request.setAttribute("message", "单个文件超出最大值！！！");
                    System.out.println("单个文件超出最大值！！！");
                    return "单个文件超出最大值";
                }catch (FileUploadBase.SizeLimitExceededException e) {
                    e.printStackTrace();
                    request.setAttribute("message", "上传文件的总的大小超出限制的最大值！！！");
                    System.out.println("上传文件的总的大小超出限制的最大值！！！");
                    return "上传文件的总的大小超出限制的最大值";
                }catch (Exception e) {
                    message= "文件上传失败！";
                    System.out.println("文件上传失败");
                    e.printStackTrace();
                    return "文件上传失败";
                }
                request.setAttribute("message",message);
                System.out.println(message);
                return "文件上传出错";
	}
	
	 /**
    * @Method: makeFileName
    * @Description: 生成上传文件的文件名，文件名以：uuid+"_"+文件的原始名称
    * @param filename 文件的原始名称
    * @return uuid+"_"+文件的原始名称
    */ 
    String makeFileName(String filename){  //2.jpg
        //为防止文件覆盖的现象发生，要为上传文件产生一个唯一的文件名
        return UUID.randomUUID().toString() + "_" + filename;
    }
    
    /**
     * 为防止一个目录下面出现太多文件，要使用hash算法打散存储
    * @Method: makePath
    * @Description: 
    * @param filename 文件名，要根据文件名生成存储目录
    * @param savePath 文件存储路径
    * @return 新的存储目录
    */ 
    String makePath(String filename,String savePath){
        //得到文件名的hashCode的值，得到的就是filename这个字符串对象在内存中的地址
        int hashcode = filename.hashCode();
        int dir1 = hashcode&0xf;  //0--15
        int dir2 = (hashcode&0xf0)>>4;  //0-15
        //构造新的保存目录
        String dir = savePath + "\\" + dir1 + "\\" + dir2;  //upload\2\3  upload\3\5
        //File既可以代表文件也可以代表目录
        File file = new File(dir);
        //如果目录不存在
        if(!file.exists()){
            //创建目录
            file.mkdirs();
        }
        return dir;
    }
%>
<div id="content"><p>
<%
request.setCharacterEncoding("UTF-8");
String type = request.getParameter("type");

if(type==null)
{
	out.print("参数为空");
	out.print("</p></div>");
	return;
}

if(type.equals("isexist"))
{
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	Connection conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;DatabaseName=seconditem","chris","123456");
	Statement stmt=conn.createStatement();
	ResultSet rs=stmt.executeQuery("select * from [user]");
	boolean flag = false;
	while(rs.next()){
		if(rs.getString("username").equals(user.getUsername()))
	    {
	    	flag=true;
	    	break;
	    }
	}
	
	 if(flag)
		 out.print("1");
	 else
		 out.print("0");

	rs.close();
	stmt.close();
	conn.close();
	return;
}else if(type.equals("logout"))
{
	Cookie[] cookies = request.getCookies();
	Cookie cookie_response = null;
	int i;
	boolean f1=false;
	boolean f2=false;
	for(i=0;i<cookies.length;i++)
	{
		if(cookies[i].getName().equals("username"))
		{
			cookie_response=cookies[i];
			cookie_response.setMaxAge(0);
			response.addCookie(cookie_response);
			f1=true;
		}else if(cookies[i].getName().equals("userid"))
		{
			cookie_response=cookies[i];
			cookie_response.setMaxAge(0);
			response.addCookie(cookie_response);
			f2=true;
		}
	}
	if(f1&&f2)
	{
		out.println("退出成功！5秒后为您转到登录界面");
		response.setHeader("refresh", "5;url='login.jsp'");
	}
	else
	{	
		out.println("退出失败！5秒后为您转到登录界面");
		response.setHeader("refresh", "5;url='login.jsp'");
	}
	out.print("</p></div>");
	return;
}else if(type.equals("listuser"))
{
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	Connection conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;DatabaseName=seconditem","chris","123456");
	Statement stmt=conn.createStatement();
	ResultSet rs=stmt.executeQuery("select * from [user]");
	boolean flag = false;
	out.print("<table border=\"1\"> <tr> <th>userid</th> <th>username</th> <th>password</th> <th>email</th> </tr>");
	while(rs.next()){
		out.print("<tr> <td>");//行头
		out.print(rs.getString("userid"));
		out.print("</td> <td>");//行中
		out.print(rs.getString("username"));
		out.print("</td> <td>");//行中
		out.print(rs.getString("password"));
		out.print("</td> <td>");//行中
		out.print(rs.getString("email"));
		out.print("</td> </tr>");//行尾
	}
	out.print("</table>");//表尾
	rs.close();
	stmt.close();
	conn.close();
	return;
}else if(type.equals("login"))
{
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	Connection conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;DatabaseName=seconditem","chris","123456");
	String sql = "select * from [user] where (username=? and password=?)";
	//out.print(user.getUsername());
	PreparedStatement pstmt=conn.prepareStatement(sql);
	pstmt.setString(1, user.getUsername());
    pstmt.setString(2, user.getPassword());
    ResultSet rs=pstmt.executeQuery();
	if(rs.next())
	{
		Cookie cookie_response = null;
		cookie_response = new Cookie("username",java.net.URLEncoder.encode(user.getUsername(),"UTF-8"));
		response.addCookie(cookie_response);
		cookie_response = new Cookie("userid",java.net.URLEncoder.encode(rs.getString("userid"),"UTF-8"));
		response.addCookie(cookie_response);
		out.print("登陆成功，5秒后为您转到首页");
		response.setHeader("refresh", "5;url='index.jsp'");
	}
	else
	{
		out.print("登陆失败，账号或密码错误，5秒后为您转到登录页面");
		response.setHeader("refresh", "5;url='login.jsp'");
	}
	out.print("</p></div>");
	return;
}
%>

<%


if(type.equals("deldeal")){
	String id = request.getParameter("id");
	int i = 0;
	
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	Connection conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;DatabaseName=seconditem","chris","123456");
	Statement stmt=conn.createStatement();
    i = stmt.executeUpdate("delete from [deal] where dealid = "+id);
    out.print("删除订单成功");
    out.println(",5秒后返回");
	response.setHeader("refresh", "5;url='deal.jsp?type=listdeal'");
}else if(type.equals("acceptdeal")){
	String dealid = request.getParameter("id");
	int i = 0;
	
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	Connection conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;DatabaseName=seconditem","chris","123456");
	Statement stmt=conn.createStatement();
    i = stmt.executeUpdate("update [deal] set state = '1' where dealid =" + dealid);
    out.print("已接受购买订单");
    out.println(",5秒后返回");
	response.setHeader("refresh", "5;url='deal.jsp?type=listdeal'");
}else if(type.equals("refusedeal")){
	String dealid = request.getParameter("id");
	int i = 0;
	
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	Connection conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;DatabaseName=seconditem","chris","123456");
	Statement stmt=conn.createStatement();
    i = stmt.executeUpdate("update [deal] set state = '2' where dealid =" + dealid);
    out.print("已拒绝购买订单");
    out.println(",5秒后返回");
	response.setHeader("refresh", "5;url='deal.jsp?type=listdeal'");
}else if(type.equals("changepassword")){
	String passwordold = request.getParameter("passwordold");
	String password = request.getParameter("password");
	
	int i;
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	Connection conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;DatabaseName=seconditem","chris","123456");
	Statement stmt = conn.createStatement();
    i = stmt.executeUpdate("update [user] set password = '"+password+"' where (userid = '"+userid+"' and password='"+passwordold+"')");
    if(i!=0)
    	out.print("修改密码成功");
    else
    	out.print("原密码错误，修改密码失败");
    stmt.close();
	conn.close();
	out.println(",5秒后为您转到首页");
	response.setHeader("refresh", "5;url='index.jsp'");
}else if(type.equals("changeemail")){
	String emailold = request.getParameter("emailold");
	String email = request.getParameter("email");
	
	int i;
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	Connection conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;DatabaseName=seconditem","chris","123456");
	Statement stmt = conn.createStatement();
    i = stmt.executeUpdate("update [user] set email = '"+email+"' where (userid = '"+userid+"' and email='"+emailold+"')");
    if(i!=0)
    	out.print("修改邮箱成功");
    else
    	out.print("原邮箱错误，修改密码失败");
    stmt.close();
	conn.close();
	out.println(",5秒后为您转到首页");
	response.setHeader("refresh", "5;url='index.jsp'");
}else if(type.equals("additem"))
{
	String date=new SimpleDateFormat("yyyy-MM-dd").format(Calendar.getInstance().getTime());
	String sql="";
	String result = uploadimg(request);
	String[] tem1 = result.split(";;");
	String[] tem2 = new String[4];
	for(int j=0;j<3;j++)
	{
		String[] tem3 = tem1[j].split(";=");
		tem2[j]=tem3[1];
	}
	String[] tem3 = tem1[3].split(";=");
	if(tem3.length==2)
		tem2[3]=tem3[1];
	else
		tem2[3]="";
	String imgpath=tem1[4];
	/* for(int j=0;j<4;j++)
		System.out.println(tem2[j]); */
	System.out.println(imgpath);
	System.out.println(tem2[3].isEmpty());
	String itemname = tem2[0];
	String classification = tem2[2];
	String price = tem2[1];
	String description = tem2[3];
	sql = "if not exists(select * from [item] where userid='"+userid+"' and itemname=N'"+itemname+"')"+"insert into [item] ("
			+"itemname,classification,price,onlisttime,userid,imgpath,description,state) values("
			+"N'"+itemname+"','"+classification+"','"+price+"','"+date+"','"+userid+"',"; 
	if(!imgpath.isEmpty()){
		System.out.println(imgpath);
		sql += "'"+imgpath+"'";
	}else{
		sql +="NULL";
	} 
	
	sql += ",";
	
	if(!description.isEmpty()){
		sql += "N'"+description+"'";
	}else{
		sql +="NULL";
	} 
	sql += ",0)";
	
	System.out.println(sql);
	
	try{
		int i = 0;
		Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
		Connection conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;DatabaseName=seconditem","chris","123456");
		Statement stmt = conn.createStatement();
	    i = stmt.executeUpdate(sql);

	    stmt.close();
		conn.close();
		 if(i==1)
			out.print("添加成功！5秒后返回");
		else
			out.print("物品已存在！5秒后返回"); 
		
		response.setHeader("refresh", "5;url='itemlist.jsp'");
	}catch (Exception e) {
		out.print("添加失败");
		e.printStackTrace();
	}
	
}else if(type.equals("delitem")){
	String id = request.getParameter("id");
	int i = 0;
	
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	Connection conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;DatabaseName=seconditem","chris","123456");
	Statement stmt=conn.createStatement();
    i = stmt.executeUpdate("delete from [item] where itemid = "+id);
    out.print("删除成功");
    out.println(",5秒后返回");
	response.setHeader("refresh", "5;url='itemlist.jsp'");
}else if (type.equals("listuser")) {
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	Connection conn = DriverManager
			.getConnection("jdbc:sqlserver://localhost:1433;DatabaseName=seconditem", "chris", "123456");
	Statement stmt = conn.createStatement();
	ResultSet rs = stmt.executeQuery("select * from [user]");
	boolean flag = false;
	out.println(
			"<table id=\"mytable\"> <tr> <th>id</th> <th>用户名</th> <th>密码</th> <th>邮箱</th> <th>操作</th> </tr>");
	int i = 0;
	while (rs.next()) {
		if ((i++) % 2 == 0)
			out.println("<tr> <td>");// 行头
		else
			out.println("<tr class=\"alt\"> <td>");// 行头
		out.println(rs.getString("userid"));
		out.println("</td> <td>");// 行中
		out.println(rs.getString("username"));
		out.println("</td> <td>");// 行中
		out.println(rs.getString("password"));
		out.println("</td> <td>");// 行中
		out.println(rs.getString("email"));
		out.println("</td> <td>");//行中
		out.println("<a href=\"admin.php?type=seluser&id="+rs.getInt("userid")+"\">修改</a>");
		out.println("<a href=\"admin.php?type=deluser&id="+rs.getInt("userid")+"\">删除</a>");
		out.println("</td> </tr>");// 行尾
	}
	out.println("</table>");// 表尾
	rs.close();
	stmt.close();
	conn.close();
	return;
}else if (type.equals("listitem")) {
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	Connection conn = DriverManager
			.getConnection("jdbc:sqlserver://localhost:1433;DatabaseName=seconditem", "chris", "123456");
	Statement stmt = conn.createStatement();
	ResultSet rs = stmt.executeQuery("select * from [item]");
	boolean flag = false;
	out.println(
			"<table id=\"mytable\"> <tr> <th>id</th> <th>书名</th> <th>出版社</th> <th>印刷日期</th> <th>作者</th> <th>分类</th> <th>上架时间</th> <th>归属</th> <th>操作</th>");
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
		out.println(rs.getString("pressname"));
		out.println("</td> <td>");//行中
		out.println(rs.getString("printdate"));
		out.println("</td> <td>");//行中
		out.println(rs.getString("author"));
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
		out.println("<a href=\"admin.php?type=selitem&id="+rs.getInt("itemid")+"\">修改</a>");
		out.println("<a href=\"admin.php?type=delitem&id="+rs.getInt("itemid")+"\">删除</a>");
		out.println("</td> </tr>");// 行尾
	}
	out.println("</table>");// 表尾
	rs.close();
	stmt.close();
	conn.close();
	return;
} else if (type.equals("delitem")) {
	out.println("<div class=\"speech-bubble speech-bubble-left\">");
	String id = request.getParameter("id");
	int i = 0;
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	Connection conn = DriverManager
			.getConnection("jdbc:sqlserver://localhost:1433;DatabaseName=seconditem", "chris", "123456");
	Statement stmt = conn.createStatement();
	i = stmt.executeUpdate("delete from [item] where itemid = " + id);
	if(i==1)
	{
		out.println("删除成功");
		out.println(",5秒后返回");
		response.setHeader("refresh", "5;url='index.jsp'");
	}else{
		out.println("删除失败");
		out.println(",5秒后返回");
		response.setHeader("refresh", "5;url='index.jsp'");
	}
} else if (type.equals("deluser")) {
	String id = request.getParameter("id");
	int i = 0;
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	Connection conn = DriverManager
			.getConnection("jdbc:sqlserver://localhost:1433;DatabaseName=seconditem", "chris", "123456");
	Statement stmt = conn.createStatement();
	i = stmt.executeUpdate("delete from [user] where userid = " + id);
	if(i==1)
	{
		out.println("删除成功");
		out.println(",5秒后返回");
		response.setHeader("refresh", "5;url='index.jsp'");
	}else{
		out.println("删除失败");
		out.println(",5秒后返回");
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
}else if (type.equals("updateuser")) {
	String username2 = request.getParameter("username");
	String password = request.getParameter("password");
	String email = request.getParameter("email");
	String id = request.getParameter("userid");
	
	int i = 0;
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	Connection conn = DriverManager
			.getConnection("jdbc:sqlserver://localhost:1433;DatabaseName=seconditem", "chris", "123456");
	Statement stmt = conn.createStatement();
	i = stmt.executeUpdate("UPDATE [user] SET username = N'"+username2+"', password = '"+password+"', email ='"+email+"' WHERE userid = " + id);
	if(i==1)
	{
		out.println("修改成功");
		out.println(",5秒后返回");
		response.setHeader("refresh", "5;url='index.jsp'");
	}else{
		out.println("修改失败");
		out.println(",5秒后返回");
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
		out.println("<form class=\"contact_form\" action=\"handle.jsp?type=updateitem\" method=\"post\" name=\"contact_form\">");
		out.println("<ul><li><h2>修改书籍信息</h2></li>");
		
		out.println("<input name=\"itemid\" type=\"hidden\" value=\""+rs.getString("itemid")+"\" required /></li>");

		
		out.println("<li><label for=\"name\">书名:</label>");
		out.println("<input name=\"itemname\" type=\"text\" value=\""+rs.getString("itemname")+"\" required /></li>");
		
		out.println("<li><label for=\"name\">出版社名:</label>");
		out.println("<input name=\"pressname\" type=\"text\" value=\""+rs.getString("pressname")+"\" required /></li>");
		
		out.println("<li><label for=\"name\">作者:</label>");
		out.println("<input name=\"author\" type=\"text\" value=\""+rs.getString("author")+"\" required /></li>");
		
		out.println("<li><label for=\"name\">印刷日期:</label>");
		out.println("<input name=\"printdate\" type=\"text\" value=\""+rs.getString("printdate")+"\" required pattern=\"^((((19|20)\\d{2})-(0?[13-9]|1[012])-(0?[1-9]|[12]\\d|30))|(((19|20)\\d{2})-(0?[13578]|1[02])-31)|(((19|20)\\d{2})-0?2-(0?[1-9]|1\\d|2[0-8]))|((((19|20)([13579][26]|[2468][048]|0[48]))|(2000))-0?2-29))$\"name=\"printdate\" ><span class=\"form_hint\">正确格式为：2016-01-01</span></li>");
		
		stmt=conn.createStatement();
		ResultSet rs2=stmt.executeQuery("select * from classification");
		out.println("<li><label for=\"name\">分类：</label><select name=\"classification\">");
	    while(rs2.next())
	    	out.println("<option value="+rs2.getString("a")+">"+rs2.getString("b")+"</option>");
	    out.println("</select></li>\n");
	   	
		out.println("<li><button class=\"submit\" type=\"submit\">修改</button></li></ul>	</form>");
	}
}else if (type.equals("updateitem")) {
	String itemname = request.getParameter("itemname");
	String classification = request.getParameter("classification");
	String price = request.getParameter("price");
	String description = request.getParameter("description");
	
	itemname = new String(itemname.getBytes("iso8859_1"),"UTF-8");
	description = new String(description.getBytes("iso8859_1"),"UTF-8");
	
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
		out.println("修改成功");
		out.println(",5秒后返回");
		response.setHeader("refresh", "5;url='index.jsp'");
	}else{
		out.println("修改失败");
		out.println(",5秒后返回");
		response.setHeader("refresh", "5;url='index.jsp'");
	}
}else {
	out.println("未知参数：type=" + type);// 表尾
}

%>

</header>
	</div>
</main>
</body>
</html>