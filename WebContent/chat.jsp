<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport"
	content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
<title>Chat Page</title>

<!-- Set render engine for 360 browser -->
<meta name="renderer" content="webkit">

<!-- No Baidu Siteapp-->
<meta http-equiv="Cache-Control" content="no-siteapp" />

<link rel="alternate icon" href="assets/i/favicon.ico">
<link rel="stylesheet" href="assets/css/amazeui.min.css">
<link rel="stylesheet" href="assets/css/app.css">

<!-- umeditor css -->
<link href="umeditor/themes/default/css/umeditor.css" rel="stylesheet">

<!-- select3 css -->
<link rel="stylesheet" type="text/css" href="selectBox/css/default.css">
<link rel="stylesheet" type="text/css" media="screen"
	href="selectBox/css/stylesheet.css">
<link rel="stylesheet" type="text/css" media="screen"
	href="selectBox/css/select3.css">
<link rel="stylesheet" href="selectBox/css/font-awesome.min.css">

<style>
.title {
	text-align: center;
}

.chat-content-container {
	margin-top: 10px;
	height: 29rem;
	overflow-y: scroll;
	background-image: url(assets/images/bg.png);
	background-size : cover;
}
</style>

</head>
<body>
	<!-- title start -->
	<div class="title">
		<div class="am-g am-g-fixed">
			<div class="am-u-sm-12">
				<h1 class="am-text-primary"
					style="margin-top: 20px; font-size: 35px">网页聊天室 V3.0</h1>
				<p style="height: 30px">
					<span
						style="float: left; vertical-align: bottom; line-height: 32px; color: #888888"
						id="timeShow"></span><span style="float: right"><%="欢迎您，" + session.getAttribute("uname")%><a
						href=/WebSocketTest/LogoutAction
						style="margin-left: 20px; font-size: 20px">注销</a></span>
				</p>
			</div>

		</div>
	</div>
	<!-- title end -->

	<!-- chat content start -->
	<div class="chat-content">
		<div class="am-g am-g-fixed chat-content-container">
			<div class="am-u-sm-12">
				<ul id="message-list" class="am-comments-list am-comments-list-flip"></ul>
			</div>
		</div>
    </div>
	<!-- chat content start -->

	<!-- message input start -->
	<div class="message-input am-margin-top">
		<div class="am-g am-g-fixed">
			<div class="am-u-sm-12" style="margin-left: 0px">
				<form class="am-form" style="background-color: #fff">
					<div class="am-form-group">
						<script type="text/plain" id="myEditor"
							style="width: 100%; height: 8rem;"></script>
					</div>
				</form>
			</div>
		</div>
		<div class="am-g am-g-fixed am-margin-top">
			<div style="margin-left: 27px; font-size: 18px">
				共有<span id='numOfUser' style="font-size: 25px; color: #0e90d2">1</span>位在线用户
			</div>
			<div class="am-u-sm-6" style="width: 300px">
				<div id="message-input-nickname"
					class="am-input-group am-input-group-primary">
					<div class="select3-input example-input" id="receiverid"
						style="z-index: 9999;">
						<div class="select3-single-select">
							<div class="select3-single-result-container">
								<div class="select3-placeholder">No user selected</div>
							</div>
							<i class="fa fa-sort-desc select3-caret"> </i>
						</div>
					</div>
				</div>
			</div>
			<button id="send" type="button" class="am-btn am-btn-primary"
				style="height: 40px; font-size: 20px; margin-left: 50px">
				<i class="am-icon-send"></i> Send
			</button>
		</div>
	</div>
	<br />
	<hr>
	<p align="center">© 2016 AllMobilize, Inc. Jack's WebSocketTest</p>
	<!-- message input end -->

	<!--[if (gte IE 9)|!(IE)]><!-->
	<script src="assets/js/jquery.min.js"></script>
	<!--<![endif]-->
	<!--[if lte IE 8 ]>
    <script src="http://libs.baidu.com/jquery/1.11.1/jquery.min.js"></script>
    <![endif]-->

	<!-- umeditor js -->
	<script charset="utf-8" src="umeditor/umeditor.config.js"></script>
	<script charset="utf-8" src="umeditor/umeditor.min.js"></script>
	<script src="umeditor/lang/zh-cn/zh-cn.js"></script>

	<!-- select3 js -->
	<script src="selectBox/js/select3-full.js"></script>
	<!--<script src="js/main.js"></script> -->

	<script>
	console.log("小瓜子的网页聊天室\n如果你看到了这段信息\n希望你对本网页手下留情\n毕竟这只是小瓜子的Java课作业\n");
	console.log("%c发现任何问题可联系小瓜子: gzj@syzc.net.cn","color:red");
	uid = "<%=session.getAttribute("uid")%>";
    uname = "<%=session.getAttribute("uname")%>";
		var time = parseInt("${requestScope.time}");
		var msg = "<%=request.getAttribute("msg")%>";
		showOnlineTime();
		items = [ '所有人' ];
		$(function() {
			// 初始化消息输入框
			um = UM.getEditor('myEditor');
			// 使昵称框获取焦点
			$('#receiverid')[0].focus();
		});
		// 初始化发送者选择下拉列表
		$('#receiverid').select3({
			allowClear : true,
			items : items,
			placeholder : 'No user selected'
		});

		window.onload = function() {
			setInterval(function() {
				showOnlineTime();
			}, 60000);
		}

		// 显示在线时间
		function showOnlineTime() {
			time += 60;
			var hour, min;
			var content;
			if (time >= 3600) {
				hour = Math.round(time / 3600);
				min = Math.round((time % 3600) / 60);
				content = "您已在线" + hour + "小时" + min + "分钟";
			} else if (time >= 60) {
				min = Math.round(time / 60);
				content = "您已在线" + min + "分钟";
			} else {
				content = "您已在线0分钟";
			}
			$('#timeShow').html(content);
		}

		// 添加在线用户
		function addOnlineUser(userInfo) {
			'use strict';
			var myInfo = uname + '(' + uid + ')';
			var flag = 0;
			// alert(myInfo);
			if (userInfo == myInfo) {
				return;
			} else {
				for (var i = 0; i < items.length; i++) {
					if (items[i] == userInfo) {
						flag = 1;
						break;
					}
				}
				if (!flag) {
					items.push(userInfo);
				}
				// alert(items);
				$('#receiverid').select3({
					allowClear : true,
					items : items,
					placeholder : 'No user selected'
				});
			}
			$('#numOfUser').html(items.length);
		}

		function removeOnlineUser(userInfo) {
			// alert("In remove!" + items);
			for (var i = 0; i < items.length; i++) {
				if (items[i] == userInfo) {
					items.splice(i, 1);
					// alert("remove " + userInfo);
					break;
				}
			}
			$('#receiverid').select3({
				allowClear : true,
				items : items,
				placeholder : 'No user selected'
			});
			// alert(items);
			$('#numOfUser').html(items.length);
		}

		function addAllOnlineUser(usersInfo) {
			for (var i = 0; i < usersInfo.length; i++) {

				items.push(usersInfo[i].user);
			}
			// alert(items);
			$('#receiverid').select3({
				allowClear : true,
				items : items,
				placeholder : 'No user selected'
			});
			$('#numOfUser').html(items.length);
		}

		// 新建WebSocket对象，最后的/websocket对应服务器端的@ServerEndpoint("/websocket")
		var socket = new WebSocket(
				"ws://" + window.location.hostname + ":" + window.location.port + "/WebSocketTest/WebsocketAction");
		// 处理服务器端发送的数据
		socket.onmessage = function(event) {
			// var message = JSON.parse(event.data);
			// alert(event.data);
			var message = eval('(' + event.data + ')');
			var type = parseInt(message.type);
			// alert(type);
			switch (type) {
			case 0: {
				if (message.message == "您的账号已在另一地点登录！") {
					alert("您的账号已在另一地点登录！");
					window.location.href = "/WebSocketTest/LogoutAction?repeatLogin=1";
					break;
				}
				if (message.message == "illegal login!") {
					alert("非法登录！");
					window.location.href = "index.jsp";
					break;
				}
				alert(message.message);
				break;
			}
			case 1: {
				addOnlineUser(message.user);
				break;
			}
			case 2: {
				removeOnlineUser(message.user);
				break;
			}
			case 3: {
				addMessage(message, false);
				break;
			}
			case 4: {
				// alert(message.sender + "," + uname);
				if (message.sender != uname) {
					addMessage(message, true);
					break;
				}
				break;
			}
			case 5: {
				addAllOnlineUser(message.users);
			}
			}

		};

		// 点击Send按钮时的操作
		$('#send')
				.on(
						'click',
						function() {
							var nickname = $('div#receiverid').children()
									.children().children().text();
							var notext = 'No user selected';

							var nowTime = new Date();
							var timeStr = nowTime.getFullYear() + "-"
									+ (nowTime.getMonth() + 1) + "-"
									+ nowTime.getDate() + "-"
									+ (nowTime.getHours() + 1) + ":"
									+ (nowTime.getMinutes() + 1) + ":"
									+ (nowTime.getSeconds() + 1);
							if (!um.hasContents()) { // 判断消息输入框是否为空
								// 消息输入框获取焦点
								um.focus();
								// 添加抖动效果
								$('.edui-container').addClass(
										'am-animation-shake');
								setTimeout(
										"$('.edui-container').removeClass('am-animation-shake')",
										1000);
							}

							else if (nickname == 'No user selected'
									|| nickname == null) { // 判断昵称框是否为空
								//昵称框获取焦点
								$('#receiverid')[0].focus();
								// 添加抖动效果
								$('#message-input-nickname').addClass(
										'am-animation-shake');
								setTimeout(
										"$('#message-input-nickname').removeClass('am-animation-shake')",
										1000);
							} else {
								// 发送消息
								// 判断是否广播消息
								if (nickname == '所有人') {
									socket.send(JSON.stringify({
										type : "4",
										message : um.getContent(),
										sender : uname,
										date : timeStr
									}));
									addSelf(true, nickname);
								} else {
									socket.send(JSON.stringify({
										type : "3",
										message : um.getContent(),
										receiver : nickname,
										sender : uname,
										date : timeStr
									}));
									addSelf(false, nickname);
								}
								// 清空消息输入框
								um.setContent('');
								// 消息输入框获取焦点
								um.focus();
							}

						});

		// 把自己的消息添加到聊天内容中
		function addSelf(isBroadcast, nickname) {
			var nowTime = new Date();
			var timeStr = nowTime.getFullYear() + "-"
					+ (nowTime.getMonth() + 1) + "-" + nowTime.getDate() + "-"
					+ (nowTime.getHours() + 1) + ":"
					+ (nowTime.getMinutes() + 1) + ":"
					+ (nowTime.getSeconds() + 1);
			var messageInfo = isBroadcast ? '大家' : nickname.split("(")[0];
			var messageItem = '<li class="am-comment '
                                + 'am-comment-flip'
                                + '">'
					+ '<a href="javascript:void(0)" ><img src="assets/images/'
                                + 'self.png'
                                + '" alt="" class="am-comment-avatar" width="48" height="48"/></a>'
					+ '<div class="am-comment-main"><header class="am-comment-hd"><div class="am-comment-meta">'
					+ '<a href="javascript:void(0)" class="am-comment-author">'
					+ '您对'
					+ messageInfo
					+ '说</a> <time>'
					+ timeStr
					+ '</time></div></header>'
					+ '<div class="am-comment-bd">'
					+ um.getContent() + '</div></div></li>';
			$(messageItem).appendTo('#message-list');
			// 把滚动条滚动到底部
			$(".chat-content-container").scrollTop(
					$(".chat-content-container")[0].scrollHeight);
		}

		// 把消息添加到聊天内容中
		function addMessage(message, isBroacast) {
			// alert(message.message);
			var messageInfo = isBroacast ? '对大家说' : '对您说';
			var icon = isBroacast ? 'group.png' : 'others.png';
			var messageItem = '<li class="am-comment '
                                + 'am-comment'
                                + '">'
					+ '<a href="javascript:void(0)" ><img src="assets/images/'
                                + icon
                                + '" alt="" class="am-comment-avatar" width="48" height="48"/></a>'
					+ '<div class="am-comment-main"><header class="am-comment-hd"><div class="am-comment-meta">'
					+ '<a href="javascript:void(0)" class="am-comment-author">'
					+ message.sender
					+ messageInfo
					+ '</a> <time>'
					+ message.date
					+ '</time></div></header>'
					+ '<div class="am-comment-bd">'
					+ message.message
					+ '</div></div></li>';
			$(messageItem).appendTo('#message-list');
			// 把滚动条滚动到底部
			$(".chat-content-container").scrollTop(
					$(".chat-content-container")[0].scrollHeight);
		}
	</script>
</body>
</html>