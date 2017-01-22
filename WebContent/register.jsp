<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="format-detection" content="telephone=no">
<meta name="renderer" content="webkit">
<meta http-equiv="Cache-Control" content="no-siteapp" />
<link rel="alternate icon" type="image/png" href="assets/i/favicon.png">
<link rel="stylesheet" href="assets/css/amazeui.min.css" />
<title>Register</title>
<style>
.header {
	text-align: center;
}

.header h1 {
	font-size: 200%;
	color: #333;
	margin-top: 30px;
}

.header p {
	font-size: 14px;
}
</style>
</head>
<body>
	<script language="javascript">
	console.log("小瓜子的网页聊天室\n如果你看到了这段信息\n希望你对本网页手下留情\n毕竟这只是小瓜子的Java课作业\n");
	console.log("%c发现任何问题可联系小瓜子: gzj@syzc.net.cn","color:red");
		var msg1 = "${requestScope.error}";
		if (msg1 != "") {
			alert(msg1);
		}
		function check() {
			
			var userid = document.getElementById("userid").value;
			var username = document.getElementById("username").value;
			var upass = document.getElementById("password").value;
			var checkpass = document.getElementById("checkpass").value;
			if (userid == "" || userid == null) {
				alert("请输入用户ID");
				return false;
			}
			if (username == "" || username == null) {
				alert("请输入昵称");
				return false;
			}
			if (upass == "" || upass == null) {
				alert("请输入密码");
				return false;
			}
			if (checkpass == "" || checkpass == null) {
				alert("请确认密码");
				return false;
			}
			if (checkpass != upass) {
				alert("两次输入密码不一致");
				return false;
			}
			return true;
		}
	</script>
	<div class="header">
		<div class="am-g">
			<h1>Web Chatting</h1>
			<p>
				网页聊天室完成版<br />By.小瓜子
			</p>
		</div>
		<hr />
	</div>
	<div class="am-g">
		<div class="am-u-lg-6 am-u-md-8 am-u-sm-centered">
			<h3>注册</h3>
			<hr>
			<div class="am-btn-group">
				<a href="https://github.com/" class="am-btn am-btn-primary am-btn-sm" target="blank"><i
					class="am-icon-github am-icon-sm"></i> Github</a> <a href="http://www.w3school.com.cn/html5/index.asp"
					class="am-btn am-btn-success am-btn-sm"  target="blank"><i
					class="am-icon-html5 am-icon-sm"></i> HTML5</a> 
					<a href="http://www.w3school.com.cn/css3/index.asp" class="am-btn am-btn-primary am-btn-sm"  target="blank"> <i
					class="am-icon-css3 am-icon-sm"></i> CSS3</a>
					<a href="http://www.firefox.com.cn/"
					class="am-btn am-btn-success am-btn-sm" target="blank"> <i
					class="am-icon-firefox am-icon-sm"></i> Firefox
				</a> 
			</div>
			<br> <br>

			<form method="post" class="am-form" action="/WebSocketTest/RegisterAction">
				<label for="email">用户ID:</label> 
				<input type="text" name="uid"id="userid" value=""> <br> 
				<label for="email">昵称:</label> 
				<input type="text" name="uname"id="username" value=""> <br> 
				<label for="password">密码:</label>
				<input type="password" name="upass" id="password" value="">
				<br> 
				<label for="password">确认密码:</label> 
				<input type="password" id="checkpass" value="">
				<br>
				<div class="am-cf">
					<input type="submit" value="注 册" class="am-btn am-btn-primary am-btn-sm am-fl" onClick="return check()"> 
						<input type="button" value="回到首页 ^_^" class="am-btn am-btn-default am-btn-sm am-fr" onclick="window.location.href='index.jsp'">
				</div>
			</form>
			<hr>
			<p>© 2016 AllMobilize, Inc. Jack's WebSocketTest</p>
		</div>
	</div>
</body>
</html>