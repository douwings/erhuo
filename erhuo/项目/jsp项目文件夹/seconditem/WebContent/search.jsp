<%@ page language="java" pageEncoding="UTF-8"%>
<div id="search" class="cd-main-search">
	<form action="grad.jsp" method="post">
		<input type="search" name="itemname" placeholder="输入物品名称..."/>
	</form>

	<div class="cd-search-suggestions">
		<div class="news">
			<h3>广告</h3>
			<ul>
				<li>
					<a class="image-wrapper" href="#0"><img src="img/placeholder.png" alt="News image"></a>
					<h4><a class="cd-nowrap" href="#0">广告一</a></h4>
					<time datetime="2016-01-12">广告一</time>
				</li>

				<li>
					<a class="image-wrapper" href="#0"><img src="img/placeholder.png" alt="News image"></a>
					<h4><a class="cd-nowrap" href="#0">广告二</a></h4>
					<time datetime="2016-01-12">广告二</time>
				</li>

				<li>
					<a class="image-wrapper" href="#0"><img src="img/placeholder.png" alt="News image"></a>
					<h4><a class="cd-nowrap" href="#0">广告三</a></h4>
					<time datetime="2016-01-12">广告三</time>
				</li>
			</ul>
		</div> <!-- .news -->

		<div class="quick-links">
			<h3>物品</h3>
			<ul>
				<li><a href="#0">物品名1</a></li>
				<li><a href="#0">物品名2</a></li>
				<li><a href="#0">物品名3</a></li>
				<li><a href="#0">物品名4</a></li>
				<li><a href="#0">物品名5</a></li>
			</ul>
		</div> <!-- .quick-links -->
	</div> <!-- .cd-search-suggestions -->

	<a href="#0" class="close cd-text-replace">Close Form</a>
</div> <!-- .cd-main-search -->
<div class="cd-cover-layer"></div> <!-- cover main content when search form is open -->