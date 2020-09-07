<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<title>修改密码</title>
	<%@include file="/WEB-INF/page/shop/mobile/include/source2.jsp"%>
	<%--<title>收货地址</title>--%>
	<style>

		.mui-input-row label{
			font-size: 13px;
			width: 28%;
            margin-top: 3px;
		}

		.mui-input-row label ~ input{
			font-size: 13px;
			width: 50%;
			float: left;
		}

		.mui-input-row .mui-btn{
			font-size: 10px;
			width:20%;
			float: left;
			padding: 10px 5px;
            margin-top: 3px;
		}

		.mui-btn-block{
            font-size: 16px;
			padding: 8px;
			margin-top: 20px;
		}

        .mui-input-row #check_code.mui-input-clear ~ .mui-icon-clear{
            font-size: 20px;
            position: absolute;
            z-index: 1;
            top: 10px;
            right: 23%;
            width: 38px;
            height: 38px;
            text-align: center;
            color: #999;
        }
	</style>
</head>

<!-- --------body开始----------- -->
<body>
<header class="mui-bar mui-bar-nav">
	<a class="mui-action-back mui-icon mui-icon-left-nav mui-pull-left"></a>
	<h1 class="mui-title">余额支付密码</h1>
</header>

<div class="mui-content">
	<form class="mui-input-group" action="" name="addfrm" id="addfrm" method="post">
		<input name="id" id="id" type="text" hidden="true" value="${id}"/>
		<div class="mui-input-row">
			<label>手机号：</label>
			<input name="mobile" id="mobile" type="text" class="mui-input-clear" placeholder="请输入手机号" oninput = "value=value.replace(/[^\d]/g,'')" maxlength="11">
		</div>
		<div class="mui-input-row">
			<label>新密码：</label>
			<input name="pwd" id="pwd" type="password" class="mui-input-password" placeholder="请输入6位数字密码" oninput = "value=value.replace(/[^\d]/g,'')" maxlength="6" minlength="6">
		</div>
		<div class="mui-input-row">
			<label>验证码：</label>
			<input name="check_code" id="check_code" type="text" class="mui-input-clear"  placeholder="请输入验证码">
			<button id="sendCode" type="button" class="mui-btn mui-btn-primary mui-pull-left" >发送验证码</button>
		</div>
	</form>

	<div class="mui-content-padded">
		<button id="save" type="button" class="mui-btn mui-btn-primary mui-btn-block" >保存</button>
	</div>
</div>

<script>
	mui.init();

	/*$(document).ready(function(){
		$.wechatShare();//分享
	})*/

    //检验手机号格式
    function checkMobile() {
        var mobile=$("#mobile").val();
        if((mobile==null || mobile==undefined) || mobile.length!=11){
            alert("请填写11位手机号！");
            return false;
        }
        return true;
    }

    /**
     * 发送验证码
     */
    document.getElementById("sendCode").addEventListener('tap', function (evt) {
        var mobile=$("#mobile").val();
        if((mobile==null || mobile==undefined) || mobile.length!=11){
            mui.alert("请填写11位手机号！");
            return false;
        }
        mui("#sendCode").button('loading');
        $.ajax({
            type: "POST",
            dataType: "json",
            url: "<%=basePath %>/web/getCode",
            data:{"token":"${token}","mobile":mobile,"type":"5"},
            success: function (result) {
                if(result!=null){
                    if(result.state){
                        sessionId = result.sessionId;
                        mui.toast("获取成功,注意查收短信");
                    }else{
                        mui.toast(result.msg);
                    }
                }else{
                    mui.toast("发送失败");
                }
                mui("#sendCode").button('reset');
            },
            error:function () {
                mui("#sendCode").button('reset');
                mui.toast("发送失败");
            }
        });
    });

    //重置支付密码
    var sessionId;
    document.getElementById("save").addEventListener('tap', function(){
        var mobile=$("#mobile").val();
        var pwd=$("#pwd").val();
        var sendCode=$("#check_code").val();

        if((mobile==null || mobile==undefined) || mobile.length!=11){
            mui.alert("请填写11位手机号！");
            return false;
        }

        if((pwd==null || pwd==undefined) || pwd.length!=6){
            mui.alert("请填写6位数字密码！");
            return false;
        }

        mui("#save").button('loading');
        $.ajax({
            type: "POST",
            dataType: "json",
            url: "<%=basePath %>/web/shopRechargeMobile/updatePayPwd",
            data: {"token":"${token}","mobile":mobile,"sendCode":sendCode,"pwd":pwd,"sessionId":sessionId},
            success: function (result) {
                if(result!=null && result.state){
                    mui.alert("修改成功",function () {
                        mui.back();
                        //history.back();
                    });
                }else{
                    mui.alert(result.msg);
                }
                mui("#save").button('reset');
            },
            error : function() {
                mui("#save").button('reset');
                mui.alert("异常！");
            }
        });
    });

</script>

</body>
</html>
