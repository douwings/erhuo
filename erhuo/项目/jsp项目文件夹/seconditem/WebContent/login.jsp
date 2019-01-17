<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="/head.html"%>
<title>二货-二手交易</title>
<link rel="stylesheet" type="text/css" href="css/main.css" />
<link rel="stylesheet" media="screen" href="css/form.css" >
<style type="text/css">
.contact_form{border:1px solid #DDDDDD;padding:10px;width:760px;margin:40px auto 0 auto;}
</style>
</head>
<body>
<%@include file="/search.jsp"%>
<%@include file="/top.jsp"%>
<form class="contact_form" action="handle.jsp?type=login" method="post" name="contact_form">
<ul>
	<li>
		<h2>登录</h2>
	</li>
	
	<li>
		<label for="name">用户名:</label>
		<input name="username" type="text" required /></p>
	</li>
	
	<li>
		<label for="name">密 码:</label>
		<input type="password" name="password" required /></p>
	</li>
	
	<li>
		<button class="submit" type="submit">登录</button>
		&nbsp&nbsp&nbsp&nbsp<a class="b" href="lost.jsp">忘记密码</a>
		&nbsp&nbsp&nbsp&nbsp<a class="b" href="regist.jsp">注册</a>
	</li>
</ul>	
</form>

</body>
</html>