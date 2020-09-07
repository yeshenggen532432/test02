<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>找回密码 | 驰用T3</title>
    <link rel="icon" href="${base }/resource/ico/favicon.ico" type="image/x-icon"/>
    <link rel="shortcut icon" href="${base }/resource/ico/favicon.ico" type="image/x-icon"/>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <link rel="stylesheet" href="${base}/static/uglcs/style/pwd.css" media="all">
    <style type="text/css">
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

        .forget-main .layui-card-header {
            text-align: center;
            font-weight: 700;
            font-size: 16px;
            color: #444;
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

        .control-label.col-xs-6 {
            padding-left: 0;
            padding-right: 5px;
        }

        .control-label.col-xs-6:after {
            content: ':'
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
                <a href="${base}manager/login">立即登录</a>
            </div>
        </div>
    </div>
    <div class="layout-content">
        <div class="layui-card forget-box forget-main">
            <div class="layui-card-header">
                找回密码
            </div>
            <div class="layui-card-body">
                <div class="form form-horizontal" uglcw-role="validator">
                    <div class="form-group">
                        <label class="control-label col-xs-6">手机号</label>
                        <div class="col-xs-18">
                            <input uglcw-role="textbox" uglcw-model="mobile" uglcw-validate="required|mobile"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-xs-6">验证码</label>
                        <div class="col-xs-9">
                            <input id="captcha" maxlength="4" data-required-msg="请输入验证码"
                                   uglcw-validate="required|numeric|length:4" uglcw-role="textbox" uglcw-model="captcha"/>
                        </div>
                        <div class="col-xs-9">
                            <img onclick="refreshCaptcha()" src="/captcha?h=35&w=105" id="captcha-image">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-xs-6">短信验证码</label>
                        <div class="col-xs-9">
                            <input id="code" maxlength="6" data-validate-msg="请输入验证码" uglcw-validate="required"
                                   uglcw-role="textbox" uglcw-model="code"/>
                        </div>
                        <div class="col-xs-9">
                            <button uglcw-role="button" type="button" onclick="getCode()" id="btn-send"
                                    style="width: 100%;" class="k-button k-info">获取验证码
                            </button>
                        </div>
                    </div>
                    <div class="form-group" style="margin-bottom: 5px!important;">
                        <label class="control-label col-xs-6">新密码</label>
                        <div class="col-xs-18">
                            <input id="newPassword" type="password"
                                   autocomplete="new-password"
                                   onkeyup="checkPassword(this)"
                                   uglcw-role="textbox" uglcw-model="newPassword"
                                   uglcw-validate="required"/>
                            <div class="password-validation">
                                <div style="display:inline-block;margin-left:-22px">
                                    <span style="float:right;margin-left: 5px;" id="strengthflag">弱</span>
                                    <span id="strengthHigh" class="passwordStrength"></span>
                                    <span id="strengthMid" class="passwordStrength"></span>
                                    <span id="strengthLow" class="passwordStrength"></span>
                                    <span style="display: inline-block;float:left;margin-left:27px;">密码强度：</span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-xs-6">确认密码</label>
                        <div class="col-xs-18">
                            <input id="password" type="password" uglcw-role="textbox" uglcw-model="password"
                                   uglcw-validate="required"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="col-xs-24">
                            <button style="width: 100%;" onclick="submit()" type="button" class="k-button k-info">重置密码
                            </button>
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
<%--<div class="iziToast-wrapper iziToast-wrapper-topCenter"><div class="iziToast-capsule" style="height: auto;"><div data-izitoast-ref="1567421973549" class="iziToast bounceInDown iziToast-theme-light iziToast-opened" id="eHhhc2RmYXNkZg" style="padding-right: 18px;"><div class="iziToast-body" style="padding-left: 33px;"><i class="iziToast-icon ico-success"></i><div class="iziToast-texts"><p class="iziToast-message">xxasdfasdf</p><div></div></div></div></div></div></div>--%>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script type="text/javascript" src="${base }/resource/md5.js"></script>
<script type="text/javascript">

    $(function () {
        uglcw.ui.init('body');
        checkCountdown();
        uglcw.ui.loaded();
    });

    function checkPassword(e){
        var password = $(e).val();
        var score = passwordScore(password);
        var strength = -1;
        if (score > 80) {
            strength = 2;
        } else if (score >= 60) {
            strength = 1;
        } else if (score >= 30) {
            strength = 0;
        }
        console.log(strength);
        var blocks = $('.password-validation .passwordStrength');
        blocks.removeAttr('class');
        blocks.addClass('passwordStrength');
        if (strength < 1) {
            $('#strengthLow').addClass('passwordLow');
            $('#strengthflag').html('弱');
        } else if (strength === 1) {
            $('#strengthLow').addClass('passwordMid');
            $('#strengthMid').addClass('passwordMid');
            $('#strengthflag').html('中');
        } else if (strength === 2) {
            blocks.addClass('passwordHigh');
            $('#strengthflag').html('强');
        }
    }

    function passwordScore(password) {
        var score = 0;
        if (!password)
            return score;

        // award every unique letter until 5 repetitions
        var letters = new Object();
        for (var i = 0; i < password.length; i++) {
            letters[password[i]] = (letters[password[i]] || 0) + 1;
            score += 5.0 / letters[password[i]];
        }

        // bonus points for mixing it up
        var variations = {
            digits: /\d/.test(password),
            lower: /[a-z]/.test(password),
            upper: /[A-Z]/.test(password),
            nonWords: /\W/.test(password),
        }

        var variationCount = 0;
        for (var check in variations) {
            variationCount += (variations[check] == true) ? 1 : 0;
        }
        score += (variationCount - 1) * 10;

        return parseInt(score);
    }

    function validateCaptcha(callback) {
        var $captcha = $('#captcha');
        if (!$captcha.val()) {
            return uglcw.ui.warning('请输入验证码');
        }
        $.ajax({
            url: '/captcha',
            type: 'post',
            data: {
                code: $captcha.val()
            },
            success: function (response) {
                if (!response.data) {
                    uglcw.ui.error('验证码错误');
                    $captcha.val('');
                    refreshCaptcha();
                    $captcha.focus();
                }
                callback(response.data || false)
            }
        })
    }

    function refreshCaptcha() {
        $('#captcha-image').attr('src', '/captcha?h=35&w=105&r=' + Math.random());
    }

    var timer;
    var count = 60;
    var waiting = false;
    var sent = false;

    function getCode() {
        if (waiting) {
            return;
        }
        validateCaptcha(function (valid) {
            if (valid) {
                waiting = true;
                uglcw.ui.get('#btn-send').enable(false);
                var data = uglcw.ui.bind('body');
                $('#btn-send').text('发送中...');
                $.ajax({
                    url: '${base}forget/code',
                    type: 'post',
                    contentType: 'application/json',
                    data: JSON.stringify({
                        mobile: data.mobile,
                        captcha: data.captcha
                    }),
                    success: function (response) {
                        waiting = false;
                        if (response.code === 200) {
                            sent = true;
                            localStorage.setItem('_last_send_time', new Date().getTime());
                            startCountdown(60);
                        } else {
                            refreshCaptcha();
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
            return uglcw.ui.warning('请先获取验证码');
        }
        var validate = uglcw.ui.get('.form').validate();
        if (!validate) {
            return
        }
        var data = uglcw.ui.bind('.form');
        if (data.code.length < 4) {
            return uglcw.ui.error('请输入4位验证码');
        }

        var score = passwordScore(data.newPassword);
        if (score <= 30) {
            return uglcw.ui.error('密码强度太低，数字、大小写字母及特殊符号至少包含2种');
        }

        if (data.newPassword != data.password) {
            return uglcw.ui.error('两次密码不匹配');
        }

        validateCaptcha(function (valid) {
            if (valid) {
                uglcw.ui.loading();
                $.ajax({
                    url: '${base}forget/reset',
                    type: 'post',
                    dataType: 'json',
                    contentType: 'application/json',
                    data: JSON.stringify({
                        code: data.code,
                        mobile: data.mobile,
                        captcha: data.captcha,
                        password: hex_md5(data.password)
                    }),
                    success: function (response) {
                        uglcw.ui.loaded();
                        uglcw.ui.info(response.message);
                        if (response.code === 200) {
                            setTimeout(function () {
                                window.location.href = '/manager/login';
                            }, 2000);
                        } else {
                            refreshCaptcha();
                        }
                    }
                })
            }
        })
    }

</script>
</body>
</html>