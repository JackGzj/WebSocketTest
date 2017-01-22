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
<script src="assets/js/jquery.min.js"></script>

<title>Login Page</title>
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
			<h3>登录</h3>
			<hr>
			<div class="am-btn-group">
				<a href="https://github.com/"
					class="am-btn am-btn-primary am-btn-sm" target="blank"><i
					class="am-icon-github am-icon-sm"></i> Github</a> <a
					href="http://www.w3school.com.cn/html5/index.asp"
					class="am-btn am-btn-success am-btn-sm" target="blank"><i
					class="am-icon-html5 am-icon-sm"></i> HTML5</a> <a
					href="http://www.w3school.com.cn/css3/index.asp"
					class="am-btn am-btn-primary am-btn-sm" target="blank"> <i
					class="am-icon-css3 am-icon-sm"></i> CSS3
				</a> <a href="http://www.firefox.com.cn/"
					class="am-btn am-btn-success am-btn-sm" target="blank"> <i
					class="am-icon-firefox am-icon-sm"></i> Firefox
				</a>

			</div>
			<br> <br>

			<form method="post" class="am-form"
				action="/WebSocketTest/UserAction">
				<label for="email">用户ID:</label> <input type="text" name="uid"
					id="userid" value=""> <br> <label for="password">密码:</label>
				<input type="password" name="upass" id="password" value="">
				<br> <label for="remember-me"> <input id="remember-me"
					type="checkbox"> 记住密码
				</label> <br />
				<div class="am-cf">
					<input type="submit" value="登 录"
						class="am-btn am-btn-primary am-btn-sm am-fl"
						onClick="return check()" id="loginBtn"> <input
						type="button" value="还不是用户 ^_^? "
						class="am-btn am-btn-default am-btn-sm am-fr"
						onclick="window.location.href='register.jsp'">

				</div>

			</form>
			<span style="vertical-align: middle; color: red" id="remind"></span>
			<hr>
			<p>© 2016 AllMobilize, Inc. Jack's WebSocketTest</p>
		</div>
	</div>
	<script language="javascript">
	    uid = "<%=session.getAttribute("uid")%>";
        uname = "<%=session.getAttribute("uname")%>";
        console.log("小瓜子的网页聊天室\n如果你看到了这段信息\n希望你对本网页手下留情\n毕竟这只是小瓜子的Java课作业\n");
        console.log("%c发现任何问题可联系小瓜子: gzj@syzc.net.cn","color:red");
		if (uid != "null" && uname != "null") {
			$('#remind').html("需要重新登录请关闭该浏览器中另一聊天窗口");
			$('#loginBtn').attr("disabled", "disabled");
		}
		var error = "${requestScope.error}";
		if (error != "") {
			alert(error);
		}
		var msg = "${requestScope.msg}";
		if (msg != "") {
			alert(msg);
		}

		function check() {
			var userid = document.getElementById("userid").value;
			var upass = document.getElementById("password").value;
			if (userid == "" || userid == null) {
				alert("请输入用户ID");
				return false;
			}
			if (upass == "" || upass == null) {
				alert("请输入密码");
				return false;
			}
			return true;
		}
	</script>
</body>
</html>
