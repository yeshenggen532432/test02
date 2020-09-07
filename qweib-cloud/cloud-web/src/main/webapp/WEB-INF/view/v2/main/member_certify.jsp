<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>用户密码修改</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        body {
            font-size: 14px;
            background-color: #f8f8f9;
            padding: 0;
            margin: 0
        }

        .header-logo {
            float: left;
            height: 45px;
            line-height: 43px;
        }

        .layout-content {
            margin-top: 66px;
        }

        .forget-box {
            margin-top: 50px;
            padding: 1px;
        }

        .forget-main {
            width: 400px;
            margin: 50px auto;
            padding: 0 16px;
        }

        .layout-header-bar {
            width: 100%;
            height: 50px;
            padding: 0 40px;
            box-sizing: border-box;
            position: fixed;
            top: 0;
            background-color: #fff;
            box-shadow: 0 1px 3px rgba(26, 26, 26, .1);
            font-size: 14px
        }

        .layout-footer {
            margin: 64px 32px 32px;
            text-align: center;
        }

        .layout-footer p {
            text-align: center;
            color: #b2b2b2;
            padding-top: 10px;
            text-shadow: 0 1px 1px #fff;
        }

        .layout-footer p img {
            width: 32px;
            -webkit-filter: grayscale(100%);
            filter: grayscale(100%);
            opacity: .5;
        }

        .layout-header-right {
            float: right;
        }

        .layout-header-right-sign {
            height: 50px;
            line-height: 48px;
        }

        .layout-header-right-sign-dot {
            display: inline-block;
            color: #2d8cf0;
            font-size: 18px;
        }

        a {
            color: #2d8cf0;
            background: 0 0;
            text-decoration: none;
            outline: 0;
            cursor: pointer;
            transition: color .2s ease;
        }

        .layout-header-menu {
            height: 45px;
            float: left;
            margin-left: 32px;
            line-height: 43px;
        }

        .layout-header-menu a {
            height: 50px;
            line-height: 48px;
            color: #808695;
            margin-right: 16px;
        }

        .dev-sign-verify {
            text-align: center;
            margin-top: 96px;
        }

        .form-group {
            margin-bottom: 15px !important;
        }
    </style>
</head>
<body>
<tag:mask/>
<div class="layout">
    <div class="layout-header-bar">
        <a class="header-logo">
            <img src="${base}static/img/logo.jpg" style="height: 30px; margin-top: 10px;"/>
        </a>
        <div class="layout-header-right">
            <div class="layout-header-right-sign">
                <a href="${base}manager/logout">退出</a>
            </div>
        </div>
    </div>
    <div class="layout-content">
        <div class="layui-card forget-box forget-main">
            <div class="layui-card-header">
                请验证您的手机号码
            </div>
            <div class="layui-card-body">
                <div class="form form-horizontal" uglcw-role="validator">
                    <div class="form-group">
                        <label class="control-label col-xs-6">姓&nbsp;&nbsp;&nbsp;名</label>
                        <div class="col-xs-18">
                            <input uglcw-role="textbox" disabled uglcw-model="name" value="${memberName}">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-xs-6">手机号</label>
                        <div class="col-xs-18">
                            <input uglcw-role="textbox" disabled uglcw-model="mobile" value="${memberMobile}"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-xs-6">验证码</label>
                        <div class="col-xs-9">
                            <input id="code" maxlength="6" uglcw-validate="required" uglcw-role="textbox" uglcw-model="code"/>
                        </div>
                        <div class="col-xs-9">
                            <button uglcw-role="button" type="button" onclick="getCode()" id="btn-send"
                                    style="width: 100%;" class="k-button k-info">获取验证码
                            </button>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="col-xs-24">
                            <button style="width: 100%;" onclick="submit()" type="button" class="k-button k-info">认&nbsp;证</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="layout-footer">
        <p> ©2019 <a>驰用T3</a>版权所有</p>
    </div>
</div>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script type="text/javascript">

    $(function () {
        uglcw.ui.init('body');
        checkCountdown();
        uglcw.ui.loaded();
    });

    var timer;
    var count = 60;
    var waiting = false;
    var sent = false;

    function getCode() {
        if (waiting) {
            return;
        }
        waiting = true;
        uglcw.ui.get('#btn-send').enable(false);
        $('#btn-send').text('发送中...');
        $.ajax({
            url: '${base}manager/member/certify/code',
            type: 'get',
            data: {date: new Date().getTime()},
            success: function (response) {
                waiting = false;
                if (response.code === 200) {
                    sent = true;
                    localStorage.setItem('_last_send_time', new Date().getTime());
                    startCountdown(60);
                } else {
                    sent = false;
                    uglcw.ui.error(response.message);
                    $('#btn-send').text('重新发送');
                    uglcw.ui.get('#btn-send').enable(true);
                }
            },
            error: function () {
                waiting = false;
                sent = false;
                $('#btn-send').text('重新发送');
                uglcw.ui.get('#btn-send').enable(true);
            }
        })
    }

    function checkCountdown() {
        var last = localStorage.getItem('_last_send_time');
        if (last) {
            sent = true;
            var diff = Number((new Date().getTime() - parseInt(last)) / 1000).toFixed(0);
            if (diff < 60) {
                var count = 60 - diff;
                startCountdown(count);
            }
        }

    }

    function startCountdown(countdown) {
        if (timer) {
            return;
        }
        count = countdown;
        uglcw.ui.get('#btn-send').enable(false);

        timer = setInterval(function () {
            count--;
            if (count < 0) {
                clearInterval(timer);
                count = 60;
                $('#btn-send').text('重新获取');
                uglcw.ui.get('#btn-send').enable(true);
                localStorage.removeItem('_last_send_time');
            } else {
                $('#btn-send').text('(' + count + ')');
            }
        }, 1000)
    }

    function submit() {
        if (!sent) {
            return uglcw.ui.error('请先获取验证码');
        }
        var validate = uglcw.ui.get('.form').validate();
        if (!validate) {
            return
        }
        var data = uglcw.ui.bind('.form');
        if (data.code.length < 6) {
            return uglcw.ui.error('请输入6位验证码');
        }
        uglcw.ui.loading();
        $.ajax({
            url: '${base}manager/member/certify',
            type: 'post',
            dataType: 'json',
            data: {code: data.code},
            success: function (response) {
                uglcw.ui.loaded();
                uglcw.ui.info(response.message);
                if (response.code === 200) {
                    setTimeout(function () {
                        window.location.href = '/';
                    }, 1000);
                }
            }
        })
    }

</script>
</body>
</html>