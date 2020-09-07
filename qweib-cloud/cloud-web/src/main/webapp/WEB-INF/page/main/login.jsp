<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>驰用T3-商业管理系统 | 请登录</title>
		<%@include file="/WEB-INF/page/include/source.jsp" %>
		<script type="text/javascript" src="resource/md5.js"></script>
		
		<script type="text/javascript">
			$(document).ready(function(){
				$.formValidator.initConfig({formID:"loginFrm"});
				$("#usrNo").formValidator({onShow:"请输入账号",onFocus:"请输入账号",onCorrect:"请输入账号"}).inputValidator({min:1,empty:{leftEmpty:false,rightEmpty:false,emptyError:"账号两边不能有空符号"},onError:"账号不能为空,请输入"});
				$("#tempPwd").formValidator({onShow:"请输入密码",onFocus:"请输入密码",onCorrect:"请输入密码"}).inputValidator({min:1,empty:{leftEmpty:false,rightEmpty:false,emptyError:"密码两边不能有空符号"},onError:"密码不能为空,请输入"});
				$("#usrNo").focus();
				showMsg("${showMsg}");
			});
			//注册
			function toRegister(){
				alert("暂不提供注册");
			}
			//登陆
			function toSubmit(){
				
				var tempPwd = $("#tempPwd").val();
				$("#usrPwd").val(hex_md5(tempPwd));
				$("#loginFrm").submit();
			}
			//回车登陆
			function tologinSubmit(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					toSubmit();
				}
			}
		</script>
	</head>
	<body class="login_bg" style="background-color: #126aca;">
		<div class="login">
			<form action="manager/dologin" method="post" name="loginFrm" id="loginFrm">
				<input type="hidden" name="usrPwd" id="usrPwd"/>
				<table class="login_table">
					<tr>
						<th>账号：</th>
						<td>
							<div>
								<input name="usrNo" id="usrNo" value="${usrNo}" style="border:0;height:38px;line-height: 38px;" 
								    onkeydown="tologinSubmit(event);"/>
							</div>
						</td>
						<td >
							<span id="usrNoTip" class="onshow"></span>
						</td>
					</tr>
					<tr>
						<th>密码：</th>
						<td>
							<div>
								<input type="password" name="tempPwd" id="tempPwd" style="border:0;height:38px;line-height: 38px;"
									onkeydown="tologinSubmit(event);"/>
							</div>
						</td>
						<td>
							<span id="tempPwdTip" class="onshow"></span>
						</td>
					</tr>
					<tr>
						<th></th>
						<td style="padding-top:10px;text-align: right">
						<input type="button" class="btn1" title="登录" onclick="toSubmit()"/>
						</td>
						<td style="padding-left: 10px;">
							
						</td>
					</tr>
				</table>
					<div style="display: none;z-index: 999" id="onloadDiv"><img src="resource/loadpage/image/onload.png"/></div>
			</form>
		</div>
		<div class="copyright" style="color: black;">©2019 厦门企微宝网络科技有限公司
			<span style="font-size:12px; padding:0 10px;"><a style="color:#000" href="http://www.miitbeian.gov.cn" target="_blank">闽ICP备16015739号-1</a></span>
		</div>
	</body>
</html>
