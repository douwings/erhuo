<%@ page language="java" pageEncoding="UTF-8"%>
<%
	String username="";
	String userid="";
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
			}
		}
		String path = request.getRequestURI();
		//out.print(path);
		if(usernameCookie==null && !path.contains("login")&&!path.contains("regist")&&!path.contains("handle")&&!path.contains("lost"))//没cookie 并且不在登录/注册/找回密码界面
		{
			response.sendRedirect("login.jsp");
			return;
		}else if(usernameCookie!=null && (path.contains("login")||path.contains("regist")||path.contains("lost")))//有cookie 并且在登录/注册/找回密码界面
		{
			response.sendRedirect("index.jsp");
		}
	}else{
		response.sendRedirect("login.jsp");
		return;
	}
	
%>
<header class="cd-main-header animate-search">
	<div class="cd-logo"><a href="#0"><img src="img/logo.png" alt="Logo"></a></div>

	<nav class="cd-main-nav-wrapper">
		<a href="#search" class="cd-search-trigger cd-text-replace">Search</a>
		
		<ul class="cd-main-nav">
			<li><a href= "javascript:history.back(); ">返回 </a></li>
			<li><a href= "index.jsp">首页 </a></li>
			<%if(!username.equals(""))
			{
				out.print("<li><a href=\"user.jsp?username=" + username + "\">" + username + "</a></li>");
				out.print("<li><a href=\"handle.jsp?type=logout\">退出登录</a></li>");
			}else{
				out.print("<li><a href=\"login.jsp\">登录</a></li>");
			}
			%>
		</ul> <!-- .cd-main-nav -->
	</nav> <!-- .cd-main-nav-wrapper -->

	<a href="#0" class="cd-nav-trigger cd-text-replace">Menu<span></span></a>
</header>