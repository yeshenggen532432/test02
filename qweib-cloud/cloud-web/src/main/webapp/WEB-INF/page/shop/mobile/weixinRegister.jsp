<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>微信绑定手机</title>
    <%@include file="/WEB-INF/page/shop/mobile/include/source2.jsp" %>
    <%--<title>收货地址</title>--%>
    <style>

        .mui-input-row label {
            font-size: 13px;
            width: 28%;
            margin-top: 3px;
        }

        .mui-input-row label ~ input {
            font-size: 13px;
            width: 50%;
            float: left;
        }

        .mui-input-row .mui-btn {
            font-size: 10px;
            width: 20%;
            float: left;
            padding: 10px 5px;
            margin-top: 3px;
        }

        .mui-btn-block {
            font-size: 16px;
            padding: 8px;
            margin-top: 20px;
        }

        .mui-input-row #check_code.mui-input-clear ~ .mui-icon-clear {
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
    <h1 class="mui-title">手机帐号绑定</h1>
</header>

<div class="mui-content">
    <form class="mui-input-group" action="" name="addfrm" id="addfrm" method="post">
        <%--<input name="wid" id="wid" type="text" hidden="true" value="${wid}"/>
        <input name="openId" id="openId" type="text" hidden="true" value="${openId}"/>
        <input name="token" id="token" type="text" hidden="true" value="${token}"/>--%>

        <%--<div class="mui-input-row">--%>
        <%--<label>姓名：</label>--%>
        <%--<input name="name" id="name" type="text" class="mui-input-clear" placeholder="请输入姓名" >--%>
        <%--</div>--%>
        <div class="mui-input-row">
            <label>手机号：</label>
            <input name="mobile" id="mobile" type="text" class="mui-input-clear" placeholder="请输入手机号"
                   oninput="value=value.replace(/[^\d]/g,'')" maxlength="11" value="${empty mobile?'':mobile}">
        </div>
        <div class="mui-input-row">
            <label>验证码：</label>
            <input name="check_code" id="check_code" type="text" class="mui-input-clear" placeholder="请输入验证码" maxlength="7">
            <button id="sendCode" type="button" class="mui-btn mui-btn-primary mui-pull-left">发送验证码</button>
        </div>
        <div class="mui-input-row">
            <label>商家备注</label>
            <input name="remark" id="remark" type="text" class="mui-input-clear" placeholder="方便商家后台查看" maxlength="50">
        </div>
    </form>

    <div class="mui-content-padded">
        <button id="save" type="button" class="mui-btn mui-btn-primary mui-btn-block">绑定手机</button>
    </div>
</div>

<script>
    mui.init();

    /*$(document).ready(function(){
        $.wechatShare();//分享
    })*/

    //检验手机号格式
    function checkMobile() {
        var mobile = $("#mobile").val();
        if ((mobile == null || mobile == undefined) || mobile.length != 11) {
            alert("请填写11位手机号！");
            return false;
        }
        return true;
    }

    var wait = 50;
    var timer = null;

    function time(o) {
        if (wait <= 0) {
            clearTimeout(timer);
            timer = null;
            wait = 30;
            o.text("获取验证码");
            $(o).removeAttr('disabled');
        } else {
            $(o).attr("disabled", true);
            o.text("重新发送(" + (wait--) + ")");
            timer = setTimeout(function () {
                time(o);
            }, 1000);
        }
    }

    $(function () {
        $("#sendCode").click(function () {
            var mobile = $("#mobile").val();
            if (!mobile || mobile.length != 11) {
                mui.alert("请填写11位手机号！");
                return false;
            }

            if (timer) {
                return;
            }
            time($(this));
            $.ajax({
                type: "POST",
                dataType: "json",
                url: "<%=basePath %>/web/getCode",
                data: {"token": "${token}", "mobile": mobile, "type": "6"},
                success: function (result) {
                    if (result != null) {
                        if (result.state) {
                            sessionId = result.sessionId;
                            mui.toast(result.msg);
                        } else {
                            mui.toast(result.msg);
                        }
                    } else {
                        mui.toast("发送失败");
                    }
                    mui("#sendCode").button('reset');
                },
                error: function () {
                    mui("#sendCode").button('reset');
                    mui.toast("发送失败");
                }
            });
        });
    });



    //保存
    var sessionId;
    document.getElementById("save").addEventListener('tap', function () {
        toWeixinBindTel(false);
    });

    function toWeixinBindTel(again) {
        var mobile = $("#mobile").val();
        var name = $("#name").val();
        var sendCode = $("#check_code").val();
        var remark = $("#remark").val();
        if ((mobile == null || mobile == undefined) || mobile.length != 11) {
            mui.alert("请填写11位手机号！");
            return false;
        }

        if ((sendCode == null || sendCode == undefined)) {
            mui.alert("请填写验证码");
            return false;
        }
        mui("#save").button('loading');
        $.ajax({
            type: "POST",
            dataType: "json",
            url: "<%=basePath%>/web/mainWeb/weixinBindTel",
            data: {again: again, "mobile": mobile, "sendCode": sendCode, "sessionId": sessionId, "remark": remark}, //提交的数据
            success: function (result) {
                if (result != null && result.state) {
                    mui.alert(result.message, function () {
                        mui.back();
                    });
                } else {
                    if (result.code) {
                        mui.confirm(result.message, '温馨提示', ['取消', '确认'], function (e) {
                            if (e.index == 1) {
                                toWeixinBindTel(true);
                            } else {
                                setTimeout(function () {
                                    //$.swipeoutClose(li);
                                }, 0);
                            }
                        });
                    } else {
                        mui.alert(result.message);
                    }
                }
                mui("#save").button('reset');
            },
            error: function () {
                mui("#save").button('reset');
                mui.alert("异常！");
            }
        });
    }

</script>

</body>
</html>
