<%--
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="tag" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="permission" uri="/WEB-INF/tlds/permission.tld" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<meta name="format-detection" content="telephone=no" />
		<meta HTTP-EQUIV="pragma" CONTENT="no-cache"> 
		<meta HTTP-EQUIV="Cache-Control" CONTENT="no-cache, must-revalidate"> 
		<meta HTTP-EQUIV="expires" CONTENT="0">
		<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=2.0, user-scalable=no"/>
		<title>微信用户注册</title>
		<link rel="stylesheet" href="<%=basePath %>/resource/select/css/main.css">
		<script type="text/javascript" src="<%=basePath %>/resource/jquery-1.8.0.min.js"></script>
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/themes/icon.css">
		<link href="<%=basePath%>/resource/shop/mobile/css/reset.css" rel="stylesheet">
		<link href="<%=basePath%>/resource/shop/mobile/css/index.css" rel="stylesheet">
		<style>
   		 	 html{
            font-size: 20px;
        }
		</style>
	</head>
<script type="text/javascript">
var basePath = '<%=basePath %>';
</script>
	<body>
	<%
	     String openId=(request.getAttribute("openId")).toString();
         String wid=(request.getAttribute("wid")).toString();
         String token=(request.getAttribute("token")).toString();
	%>
		<div id="wrapper">
			<!-- --------标题开始----------- -->
			<div class="int_title"  >
				<span class="int_pic" onclick="onBack();">
					<img src="<%=basePath%>/resource/shop/mobile/images/jifen/left.png"/>
				</span>
			</div>
			<!-- --------标题结束----------- -->
			<div id="userInfo" style="display:none" >
		          你的wid:<label id="wid"><%=wid %></label><BR/>
				  你的openId：<label id="openId"><%=openId %></label><BR/>
			 	  你的token：<label id="token"><%=token %></label><BR/>
			</div>
			<div class="m_pwd balance topline">
				<div class="m_p_con" >
					<form action="" name="addfrm" id="addfrm" method="post" style="font-size:15px">
						<input name="id" id="id" type="text" hidden="true" value="${id}"/>
						<p class="balance_text" >姓名：</p>
						<p class="balance_register_border"><input name="name" id="name" type="text" placeholder="请输入姓名"/></p>
						<p class="balance_text" >手机号：</p>
						<p class="balance_register_border"><input name="mobile" id="mobile" type="text" placeholder="请输入手机号"/></p>
						<p class="balance_text" >验证码：</p>
						<p class="balance_register_checkCode_border" >
						<input name="check_code" id="check_code" type="text" placeholder="请输入验证码"/></p>
						<input type="button" value="发送验证码" id="btn_check_code" onclick="sendCode();" />
						<input type="button" value="注册" id="btn_register" onclick="checkUserInfo();"/>
					</form>
				</div>
			</div>
		</div>		
	</body>
	<script type="text/javascript">
	function onBack(){
    	history.back();
    }
	function register()
	{
		var wid=$("#wid").html();
		var openId=$("#openId").html();
		var name=$("#name").val();
		var mobile=$("#mobile").val();
		var token=$("#token").html();
		var check_code=$("#check_code").val();
		var checkCode_url="/manager/checkCode?checkCode=1";
		var msg=$.ajax({url:checkCode_url,async:false});
		var json=$.parseJSON( msg.responseText ) ;
		if (mobile=="" || mobile==null)
		{
			alert("手机号为空,请填写手机号！");
			return false;
		}
		if (check_code=="" || mobile==null)
		{
			alert("验证码为空,请填写验证码！");
			return false;
		}		
		if(!(mobile==json.mobile))
		{
			alert("此手机号不是发送验证码的手机号！");
			return false;
		}
		
		if(!(check_code==json.cnum))
		{
			alert("验证码不正确！");
			return false;
		}				
		$.ajax({
            type: "POST",                  //提交方式
            dataType: "json",              //预期服务器返回的数据类型
            url: "/manager/registerWeixinUser",
            data: {"wid":wid,"openId":openId,"name":name,"mobile":mobile,"token":token}, //提交的数据
            async:false,
            success: function (json) {
            	if(json.state){
            		alert("注册成功！");
            		history.back();
            	}else{
            		alert("注册失败！");
            	}
            }
    	});
		return true;
	}
	function checkUserInfo()
	{
		var name=$("#name").val();
		if (name=="" || name==null)
			{
				alert("姓名为空,请填写姓名！");
				return false;
			}		
		var mobile=$("#mobile").val();
		if (mobile=="" || mobile==null)
			{
				alert("手机号为空,请填写手机号！");
				return false;
			}		
		if(!checkMobile())
		{
			return false;
		}		
		var name_pattern = /^[\u4E00-\u9FA5]{2,6}$/;
		if(!name_pattern.test(name))
		{
			alert("请填写2~6个字的汉字！");
			return false;
		}		
		register();
		return true;
	}	
	function checkMobile()
	{
		var mobile=$("#mobile").val();
		var mobile_pattern = /^1[34578]\d{9}$/; 
		if( !mobile_pattern.test(mobile))
			{
				alert("请填写正确的手机号！");
				return false;
			}
		return true;	
	}	
	function sendCode()
	{

		if(!checkMobile())
		{
			return false;
		}	
		//手机号码
		var mobile=$("#mobile").val();
		var getCode_url="/manager/getCode?getCode=1"+"&mobile="+mobile;
		var msg=$.ajax({url:getCode_url,async:false});
		alert(msg.responseText);
		var json=$.parseJSON( msg.responseText ) ;
		alert(json.msg);
	}
	</script>	
</html>--%>
