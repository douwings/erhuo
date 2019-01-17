<%@ page language="java" pageEncoding="UTF-8" import="java.sql.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel='stylesheet' href='css/grad.css' media='screen' />
<%@include file="/head.html"%>
<script src="js/blocksit.min.js"></script>
<script>
$(document).ready(function() {
	//vendor script
	$('#header')
	.css({ 'top':-50 })
	.delay(1000)
	.animate({'top': 0}, 800);
	
	$('#footer')
	.css({ 'bottom':-15 })
	.delay(1000)
	.animate({'bottom': 0}, 800);
	
	//blocksit define
	$(window).load( function() {
		$('#container').BlocksIt({
			numOfCol: 5,
			offsetX: 8,
			offsetY: 8
		});
	});
	
	//window resize
	var currentWidth = 1100;
	$(window).resize(function() {
		var winWidth = $(window).width();
		var conWidth;
		if(winWidth < 660) {
			conWidth = 440;
			col = 2
		} else if(winWidth < 880) {
			conWidth = 660;
			col = 3
		} else if(winWidth < 1100) {
			conWidth = 880;
			col = 4;
		} else {
			conWidth = 1100;
			col = 5;
		}
		
		if(conWidth != currentWidth) {
			currentWidth = conWidth;
			$('#container').width(conWidth);
			$('#container').BlocksIt({
				numOfCol: col,
				offsetX: 8,
				offsetY: 8
			});
		}
	});
});
</script>
<script type="text/javascript">
function chat()
{
var xmlhttp;
if (window.XMLHttpRequest)
  {// code for IE7+, Firefox, Chrome, Opera, Safari
  xmlhttp=new XMLHttpRequest();
  }
else
  {// code for IE6, IE5
  xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
  }
xmlhttp.onreadystatechange=function()
  {
  if (xmlhttp.readyState==4 && xmlhttp.status==200)
    {
    	document.getElementById("chat").innerHTML=xmlhttp.responseText;
    }
  }
xmlhttp.open("GET","test.jsp",true);
xmlhttp.send();
}
</script>
<style>
.ac, .ac:visited {
	outline:none;
	color:#389dc1;
}

.ac:hover{
	text-decoration:none;
}
.a{
	list-style:none;
}


.a .b{
	display: inline-block;
}

.a .b:hover{
	opacity: 0.9;
}

.a .b .ac{
	color:#000000 !important;
	text-decoration: blink !important;
	font-size:10px;
	display: inline-block;
	padding:2px 8px;
	border-radius:3px;
	box-shadow: 0 1px 3px rgba(34,25,25,0.4);
}

.a .a:nth-child(1) .a{
	background-color: #FFF;
}
</style>
<title>物品交换系统</title>
<script>
function a(a){
	location.href=a;
  }
</script>
</head>
<body>
<%@include file="/search.jsp"%>
<%@include file="/top.jsp"%>
<%@include file="/chat_reply.jsp"%>
<%@include file="/chat_pop.jsp"%>
<%
request.setCharacterEncoding("UTF-8");

String itemname = request.getParameter("itemname");

String text = request.getParameter("text");
if(text!=null)
{
	text = java.net.URLDecoder.decode(text,"iso8859_1");
	itemname = text;
	itemname = new String(itemname.getBytes("iso8859_1"),"UTF-8");
	//out.print(text);
}

String type = request.getParameter("type");
%>
<section id="wrapper">
<div class="a"><div class="b">
&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
&nbsp&nbsp<a class="ac" href="javascript:a('?text=<%=java.net.URLDecoder.decode(itemname,"UTF-8")%>')">默认排序</a>

&nbsp&nbsp<a class="ac" href="javascript:a('?text=<%=java.net.URLDecoder.decode(itemname,"UTF-8")%>&type=up')">价格升高</a>

&nbsp&nbsp<a class="ac" href="javascript:a('?text=<%=java.net.URLDecoder.decode(itemname,"UTF-8")%>&type=down')">价格降低</a>
</div></div>
<div id="container">
<%
/*
	列出书单
*/

if(itemname!=null)
{
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	Connection conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;DatabaseName=seconditem","chris","123456");
	Statement stmt=conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
	ResultSet rs =null;
	if(itemname!=null)
	{	
		String sql = "";
		if(type==null)
			sql= "select * from [item] where itemname like '%"+itemname+"%'";
		else if(type.equals("up"))
			sql= "select * from [item] where itemname like '%"+itemname+"%' order by price";
		else if(type.equals("down"))
			sql= "select * from [item] where itemname like '%"+itemname+"%' order by price DESC";
		rs=stmt.executeQuery(sql);
	
	}
	if(rs.next())
	{
		rs.beforeFirst();
		
		while(rs.next()){
			
			stmt=conn.createStatement();
			ResultSet rs3=stmt.executeQuery("select * from [user] where userid="+rs.getString("userid"));
			rs3.next();
			if(!rs3.getString("username").equals(username))//不显示自己的商品
			{
				out.print("<div class=\"grid\">");
				out.print("<div class=\"imgholder\">");
				out.print("<img src=\"/img"+rs.getString("imgpath")+"\" />");//图片
				out.print("</div>");
				out.print("<strong>"+rs.getString("itemname")+"</strong>");//名字
				
				out.print("<p>价格:"+rs.getString("price")+"</p>");
				
				out.print("<p><div class=\"a\"><div class=\"b\">归属:"+rs3.getString("username")+"&nbsp&nbsp<a class=\"ac\" href=\"javascript:popchat("+userid+","+rs.getString("userid")+",'"+rs3.getString("username")+"');\">联系卖家</a></div></div></p>");
				stmt=conn.createStatement();
				ResultSet rs2=stmt.executeQuery("select b from classification where a="+rs.getString("classification"));
				rs2.next();
				out.print("<p>分类:"+rs2.getString("b")+"</p>");
				out.print("<p>上架日期:"+rs.getString("onlisttime")+"</p>");
				out.print("<br><p>"+rs.getString("description")+"</p>");
				
				out.print("<div class=\"meta\">");
				//out.print("<a href=\"deal.jsp?type=adddeal&buyer="+userid+"&seller=" + rs.getString("itemid") + "\">购买</a>&nbsp&nbsp");
				out.print("<a href=\"pay.jsp?buyer="+userid+"&seller=" + rs.getString("itemid") + "\">购买</a>&nbsp&nbsp");
				out.print("</div></div>");
			}
		}
	
		rs.close();
		stmt.close();
		conn.close();
	}else{
		if(itemname!=null)
			out.print("未搜索到物品");
		else
			out.print("您尚未添加物品");
	}
}
%>
</div>
</section>

</body>
</html>