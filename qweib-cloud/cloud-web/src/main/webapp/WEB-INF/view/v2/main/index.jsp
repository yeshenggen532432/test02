<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>驰用T3-商业管理系统</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <link rel="icon" href="${base }/resource/ico/favicon.ico" type="image/x-icon"/>
    <link rel="shortcut icon" href="${base }/resource/ico/logo.ico" type="image/x-icon"/>
    <link rel="stylesheet" href="${base}/static/uglcs/layui/css/layui.css" media="all">
    <link rel="stylesheet" href="${base}/static/uglcs/style/admin.css?v=20200417" media="all">
    <link rel="stylesheet" href="${base}/static/uglcs/style/pwd.css" media="all">
    <link rel="stylesheet" href="${base}/static/uglcu/iconfont/iconfont.css?v=20190712" media="all">
    <script>
        var ua = window.navigator.userAgent.toLowerCase();
        var isIE = ua.indexOf('msie') > -1;
        var safariVersion;
        if (isIE) {
            safariVersion = ua.match(/msie ([\d.]+)/)[1];
        }
        if (safariVersion < 9.0) {
            alert('系统检测到您正在使用ie9以下内核的浏览器，为了更好的体验，推荐您使用谷歌浏览器或者360浏览器极速模式');
        }
    </script>
    <style>
        .layui-laypage .layui-laypage-curr em {
            padding: 0 0 !important;
        }

        .layui-layout-admin .layui-logo {
            background-color: #2154a3 !important;
        }

        .highlighter {
            background: yellow;
        }

        #jiaxin-mcs-fixed-btn {
            display: none !important;
        }

        #pageChat .header .agent-name {
            max-width: 185px;
        }
    </style>
</head>
<body class="layui-layout-body">

<div id="LAY_app" class="layadmin-side-shrink">
    <div class="layui-layout layui-layout-admin">
        <div class="layui-header">
            <!-- 头部区域 -->
            <input type="hidden" name="idKey" id="idKey"/>
            <input type="hidden" name="EncData" id="EncData"/>
            <input type="hidden" name="dogUser" id="dogUser"/>
            <input type="hidden" name="srvRnd" id="srvRnd" value="${rnd}"/>
            <input type="hidden" name="optype" id="optype" value="${optype}"/>
            <ul class="layui-nav layui-layout-left">
                <li class="layui-nav-item menu-top layui-hide-xs" lay-unselect id="refreshPage">
                    <a href="javascript:layui.index.refreshPage();" lay-tips="刷新"
                       class="tiny-icon">
                        <i class="layui-icon layui-icon-refresh"></i>
                    </a>
                </li>
                <li class="layui-nav-item menu-top layui-hide-xs" lay-unselect id="searchBill">
                    <a href="javascript:openTab('单据查询', '${base}manager/toBusinessBillRpt');" lay-tips="单据查询"
                       class="tiny-icon">
                        <i class="layui-icon layui-icon-search"></i>
                    </a>
                </li>
                <c:if test="${!empty menuItems}">
                    <c:forEach items="${menuItems}" var="menu" varStatus="s">
                        <li id="top-menu-${s.index}"
                            class="layui-nav-item menu-top <c:if test="${s.index==0}">layui-this</c:if> "
                            style="font-weight: bold; margin: 0 10px;" lay-unselect>
                            <a href="javascript:layui.index.showSubMenu('${s.index}');">
                                <cite>${menu.menu_nm}</cite>
                            </a>
                            <script id="sub-menu-${s.index}" type="qweib/template">
                                    <c:if test="${!empty menu.children}">
                                        <c:forEach items="${menu.children}" var="secondaryMenu" varStatus="s">
                                            <li data-name="${secondaryMenu.menu_cd}"
                                                class="layui-nav-item">
                                                <a href="javascript:;"
                                                        <c:if test="${not empty secondaryMenu.menu_url}">
                                                            <c:choose>
                                                                <c:when test="${fn:startsWith(secondaryMenu.menu_url,'@/')}">
                                                                    lay-href="${fn:substringAfter(secondaryMenu.menu_url,'@')}"
                                                                </c:when>
                                                                <c:otherwise>
                                                                    lay-href="${base}manager/${secondaryMenu.menu_url}"
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:if>
                                                   lay-direction="2">
                                                    <i class="layui-icon
                                                     <c:choose>
                                                        <c:when test="${not empty secondaryMenu.menu_cls}">icon v-icon v-icon-${secondaryMenu.menu_cls}</c:when>
                                                        <c:otherwise>layui-icon-app</c:otherwise>
                                                     </c:choose>"
                                                    ></i>
                                                    <cite>${secondaryMenu.menu_nm}</cite>
                                                </a>
                                                <c:if test="${!empty secondaryMenu.children}">
                                                    <dl class="layui-nav-child">
                                                        <c:forEach items="${secondaryMenu.children}" var="ternaryMenu">
                                                            <dd data-name="${ternaryMenu.menu_cd}">
                                                                <c:choose>
                                                                    <c:when test="${fn:startsWith(ternaryMenu.menu_url,'@/')}">
                                                                        <a lay-href="${fn:substringAfter(ternaryMenu.menu_url, '@')}">
                                                                            <cite>${ternaryMenu.menu_nm}</cite>
                                                                        </a>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <a lay-href="${base}/manager/${ternaryMenu.menu_url}">
                                                                            <cite>${ternaryMenu.menu_nm}</cite>
                                                                        </a>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </dd>
                                                        </c:forEach>
                                                    </dl>
                                                </c:if>
                                            </li>
                                        </c:forEach>
                                    </c:if>
                            </script>
                        </li>
                    </c:forEach>
                </c:if>
                <li class="layui-nav-item menu-more" style="display: none;">
                    <a href="javascript:;">
                        <cite>更多</cite>
                    </a>
                    <dl class="layui-nav-child">
                        <dd><a lay-href="set/user/info.html">基本资料</a></dd>
                    </dl>
                </li>
            </ul>
            <ul class="layui-nav layui-layout-right" lay-filter="layadmin-layout-right">
                <li class="layui-nav-item" style="margin: 0 10px;">
                    <a href="javascript:startIM()" class="uglcw-im">
                        <cite onmouseover="onlineServer()" onmouseleave="onlineServerDis()">
                            <span>在线客服</span>
                            <div class="code-v hidden" id="div3" style="display: none;position: absolute;">
                                <img src="/static/img/onlinewx.jpg" width="141px"/>
                            </div>
                        </cite>
                        <i class="layui-icon layui-icon-dialogue"></i>
                    </a>
                </li>
                <li class="layui-nav-item" lay-unselect>
                    <a href="javascript:;" class="company-info">
                        <cite>${principal.fdCompanyNm}</cite>
                    </a>

                </li>
                <li class="layui-nav-item uglcw-nav-more" lay-unselect>
                    <a href="javascript:;" class="tiny-icon"><cite><i
                            class="layui-icon layui-icon-more-vertical"></i></cite></a>
                    <dl class="layui-nav-child">
                        <dd>
                            <a href="javascript:;" class="tiny-icon"
                               lay-href="${base}manager/toBusinessBillRpt">
                                <i class="layui-icon layui-icon-search"></i>单据查询
                            </a>
                        </dd>
                        <dd>
                            <a href="javascript:;" layadmin-event="about" class="tiny-icon">
                                <i class="layui-icon layui-icon-about"></i>帮助文档</a>
                        </dd>
                        <dd>
                            <a href="javascript:;" class="tiny-icon" layadmin-event="fullscreen">
                                <i class="layui-icon layui-icon-screen-full"></i>全屏切换
                            </a>
                        </dd>
                        <dd>
                            <a href="javascript:layui.index.showOrders();" class="tiny-icon" layadmin-event="message"
                               lay-text="消息中心">
                                <i class="layui-icon layui-icon-notice"></i>消息中心
                                <!-- 如果有新消息，则显示小圆点 -->
                                <span id="order-notice-dot" class="layui-badge-dot"></span>
                            </a>
                        </dd>

                    </dl>
                </li>
            </ul>
        </div>
        <!-- 侧边菜单 -->
        <div class="layui-side layui-side-menu">
            <div class="layui-logo" lay-href="${base}/manager/dashboard">
                <ul class="layui-nav" style="margin-top: 0;">
                    <li class="layui-nav-item account-info" lay-unselect>
                        <a href="javascript:;">
                            <cite><i class="layui-icon layui-icon-username"></i>${usr.usrNm}</cite>
                        </a>
                        <dl class="layui-nav-child">
                            <dd><a href="javascript:layui.index.password.open();">修改密码</a></dd>
                            <hr>
                            <dd layadmin-event="logout" style="text-align: center;"><a>退出</a></dd>
                        </dl>
                    </li>

                </ul>
            </div>
            <div class="layui-side-scroll">
                <ul class="layui-nav layui-nav-tree layui-anim" lay-shrink="all" id="LAY-system-side-menu"
                    lay-filter="layadmin-system-side-menu">
                </ul>
            </div>
        </div>

        <!-- 页面标签 -->
        <div class="layadmin-pagetabs chat-service" id="LAY_app_tabs">
            <div class="layui-icon layadmin-tabs-control layui-icon-prev" layadmin-event="leftPage"></div>
            <div class="layui-icon layadmin-tabs-control layui-icon-next" layadmin-event="rightPage"></div>
            <div class="layui-icon layadmin-tabs-control layui-icon-down">
                <ul class="layui-nav layadmin-tabs-select" lay-filter="layadmin-pagetabs-nav">
                    <li class="layui-nav-item" lay-unselect>
                        <a href="javascript:;"></a>
                        <dl class="layui-nav-child layui-anim-fadein">
                            <dd layadmin-event="closeThisTabs"><a href="javascript:;">关闭当前标签页</a></dd>
                            <dd layadmin-event="closeOtherTabs"><a href="javascript:;">关闭其它标签页</a></dd>
                            <dd layadmin-event="closeAllTabs"><a href="javascript:;">关闭全部标签页</a></dd>
                        </dl>
                    </li>
                </ul>
            </div>
            <div id="chat" style="color: #4DAF29;" class="chat-icon layui-icon layadmin-tabs-control layui-icon-dialogue
             layui-anim layui-anim-scaleSpring" onclick="goServicePage();">
            </div>
            <div id="nav-tabs">
                <div class="layui-tab" lay-unauto lay-allowClose="true" lay-filter="layadmin-layout-tabs">
                    <ul class="layui-tab-title" id="LAY_app_tabsheader">
                        <li lay-id="/manager/dashboard" lay-attr="/manager/dashboard" class="layui-this"><i
                                class="layui-icon layui-icon-home"></i></li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- 主体内容 -->
        <div class="layui-body" id="LAY_app_body">
            <div class="layadmin-tabsbody-item layui-show">
                <iframe src="${base}/manager/dashboard" frameborder="0" class="layadmin-iframe"
                        onload="onLoad();"></iframe>
            </div>
        </div>
        <%--<div class="layui-footer">©2019 版权所有. <span class="pull-right">Version 2.0</span>--%>
    </div>
    <!-- 辅助元素，一般用于移动设备下遮罩 -->
    <div class="layadmin-body-shade" layadmin-event="shade"></div>
</div>
<script id="login-dialog" type="text/x-uglcw-template">
    <div class="layui-card">
        <div class="layui-card-body" pad15>
            <form class="layui-form" lay-filter="login-form">
                <div class="layui-form-item">
                    <label class="layui-form-label">公司</label>
                    <div class="layui-input-inline">
                        <input name="company" type="hidden" value="${principal.fdCompanyId}"/>
                        <input name="username" readonly value="${principal.fdCompanyNm}" lay-verType="tips"
                               class="layui-input">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">用户名</label>
                    <div class="layui-input-inline">
                        <input name="company" type="hidden" value="${principal.fdCompanyId}"/>
                        <input name="username" readonly value="${principal.usrNo}" lay-verify="required"
                               lay-verType="tips"
                               class="layui-input">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">密码</label>
                    <div class="layui-input-inline">
                        <input id="login-password" type="password" name="password" lay-verify="required"
                               lay-verType="tips"
                               autocomplete="off" class="layui-input">
                    </div>
                </div>
                <button class="login-btn" lay-submit lay-filter="login" style="display: none;"></button>
            </form>
        </div>
    </div>
</script>
<div id="update-password-dialog" style="display: none">
    <div class="layui-card">
        <div class="layui-card-body" pad15>
            <div class="layui-form" lay-filter="change-pwd-form">
                <div class="layui-form-item">
                    <label class="layui-form-label">当前密码</label>
                    <div class="layui-input-inline">
                        <input type="password" autocomplete="off" name="oldPassword" lay-verify="required"
                               lay-verType="tips"
                               class="layui-input">
                    </div>
                </div>
                <div class="layui-form-item new-password">
                    <label class="layui-form-label">新密码</label>
                    <div class="layui-input-inline">
                        <input type="password" autocomplete="new-password" name="newPassword" lay-verify="required|pass"
                               lay-verType="tips"
                               onkeyup="layui.index.password.check(this)"
                               id="password" class="layui-input">
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
                    <div class="layui-form-mid layui-word-aux">6到16个字符</div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">确认新密码</label>
                    <div class="layui-input-inline">
                        <input type="password" name="repassword" lay-verify="required|pass|checkRepeat"
                               data-check="password" lay-verType="tips"
                               autocomplete="new-password"
                               class="layui-input">
                    </div>
                </div>
                <button class="btn-change-pwd" lay-submit lay-filter="change-pwd" style="display: none;"></button>
            </div>
        </div>
    </div>
</div>


<div id="weixin-dialog" style="display: none">
    <div class="layui-card">
        <div class="layui-card-body" pad15>
            <div class="layui-form" lay-filter="change-pwd-form">




            </div>
        </div>
    </div>
</div>
<div id="company-switching" style="display: none;">
    <div class="company-switching" style="line-height: 22px; color: #fff; font-weight: 300;">
        <ul class="layui-nav layui-nav-tree layui-inline" style="width: 100%;border-radius:0px; text-align: center;">
            <li class="layui-nav-item layui-nav-itemed">
                <a href="javascript:;">当前公司： ${usr.fdCompanyNm}</a>
                <c:forEach items="${usr.companyList}" var="company">
                    <dl class="layui-nav-child">
                        <dd><a data-id="${company.companyId}"
                               <c:if test="${usr.fdCompanyNm eq company.companyName }">class="layui-this layui-disabled"</c:if>
                               href="javascript:void(0);">${company.companyName}</a>
                        </dd>
                    </dl>
                </c:forEach>
            </li>
        </ul>
    </div>
</div>
<script>

    if (typeof module === 'object') {
    window.module = module;
    module = undefined;
}
</script>
<script src="${base}/static/uglcs/jquery/jquery.min.js"></script>
<script src="${base}/static/uglcu/uglcw.core.js?v=20191016"></script>
<script src="${base}/static/uglcs/layui/layui.js"></script>
<script type="text/javascript" src="${base }/resource/md5.js"></script>
<script src="${base}/static/uglcu/im/uuid.js"></script>
<script src="${base}/static/uglcu/im/socket.io.js"></script>
<script src="${base}/static/uglcu/im/uglcw.im.js"></script>

<script>


    layui.config({
        version: '20200622',
        base: '/static/uglcs/' //静态资源所在路径
    }).extend({
        index: 'lib/index' //主入口模块
    }).use(['index', 'form'], function () {
        $ = layui.$, layer = layui.layer;
        this.index.showSubMenu(0);
        this.index.init();
        $(window.document).ajaxSuccess(function (event, xhr, settings, data) {
            if (data) {
                if (data.code == 413) {
                    //window.top.openLoginDialog();
                }
            }
        })
        if ('${usr.usrPwd}' == hex_md5("123456AAAAAA")) {
            var t = layer.confirm('密码不能为123456,请修改密码!', {
                top: '200px',
                btn: ['立即修改', '下次再说']
            }, function () {
                layer.close(t);
                layui.index.password.open();
            })

        }
        initIM(layer);
    });
    var delay;
    $(function () {
        var i, j, k;

        $('.uglcw-company.layui-nav-child').on('mouseenter', 'a:not(.logout)', function () {
            k = layer.tips('切换至【' + $(this).text() + '】', $(this), {
                maxWidth: 300
            });
        });

        $('.layui-logo .layui-nav-child').on('mouseleave', 'a', function () {
            layer.close(k);
        });

        $('#chat').on('mouseenter', function () {
            i = layer.tips('客服消息', '#chat', {
                tips: [1, '#78BA32']
            })
        });
        $('#chat').on('mouseleave', function () {
            layer.close(i);
        });
        $('#back_in_time').on('mouseenter', function () {
            j = layer.tips('切换至旧版', '#back_in_time', {tips: 3});
        });
        $('#back_in_time').on('mouseleave', function () {
            layer.close(j);
        });
        resize();
        $(window).resize(resize)
        checkService();
    });

    function checkService() {
        $.ajax({
            url: '${base}manager/im/service',
            type: 'get',
            dataType: 'json',
            success: function (response) {
                var services = response.data || []
                var hit = false;
                $(services).each(function (i, service) {
                    if (service.userId == '${principal.idKey}') {
                        hit = true;
                    }
                })
                if (hit) {
                    $('#LAY_app_tabs').addClass('chat-service');
                } else {
                    $('#LAY_app_tabs').removeClass('chat-service');
                }
            }
        })
    }
    function onlineServer(){
        var $div3 = $('#div3');
        $div3.show();
    }

    function onlineServerDis(){
        //alert(111);
        var $div3 = $('#div3');
        $div3.hide();
    }

    function resize() {
        if (delay) {
            clearTimeout(delay);
        }
        delay = setTimeout(function () {
            var sideWidth = $('.layui-side.layui-side-menu').width();
            var rightWidth = $('.layui-nav.layui-layout-right').width();
            var headerWidth = $('.layui-header').width();
            if (headerWidth < 992) {
                sideWidth = 0;
            }
            var availableWidth = $('.layui-header').width() - sideWidth - rightWidth - 350;
            var topMenuWidth = $('.layui-nav.layui-layout-left').width();
            var stay = Math.floor(availableWidth / 60);
            var total = $('.menu-top').length;
            //console.log('availableWidth:' + availableWidth, 'topMenuWidth:' + topMenuWidth, 'sideWidth:' + sideWidth, 'rightWidth:' + rightWidth, 'stay:' + stay);
            if (stay < total) {
                var more = [];
                $('.menu-top').each(function (idx, menu) {
                    if (idx <= stay) {
                        $(menu).removeClass('hide');
                    } else {
                        $(menu).addClass('hide');
                        more.push('<dd>' + $(menu).find('a')[0].outerHTML + '</dd>');
                    }
                    $('.menu-more .layui-nav-child').html(more.join(''));
                    $('.menu-more').show();
                })
            } else {
                $('.menu-top.hide').each(function (idx, menu) {
                    $(this).removeClass('hide')
                });
                $('.menu-more').hide();
            }
        });
    }

    function onLoad() {
        if (layui && layui.index) {
            layui.index.onFrameLoaded();
        }
    }

    function goServicePage() {
        getToken(function (token) {
            openTab('客服消息', '${base}/uglcwim/?token=' + token + '#/service/chat')
        })
    }

    function getToken(callback) {
        $.ajax({
            url: '${base}manager/im/token',
            type: 'get',
            dataType: 'json',
            success: function (response) {
                if (response.success) {
                    callback(response.data)
                }
            }
        })
    }

    var imLayer, states = {
        NONE: 0,
        NORMAL: 1,
        MINSIZE: 2,
        MAXSIZE: 3
    }, imState = states.NONE;

    function startIM() {
        layer.open({
            type: 1,
            title:'请扫码添加客服微信'
            ,offset: 'auto' //具体配置参考：http://www.layui.com/doc/modules/layer.html#offset
            ,id: 'layerDemo' //防止重复弹出
            ,content: '<div style="padding: 100px 150px;"><img src="/static/img/客户等级.png"></img></div>'
            ,btn: '关闭'
            ,btnAlign: 'c' //按钮居中
            ,shade: 0 //不显示遮罩
            ,yes: function(){
                layer.closeAll();
            }
        });
    }

    var IM_TOKEN;

    function initIM(layer) {
        var im = new IM();
        var userId;
        getToken(function (token) {
            window.localStorage.setItem('uglcw.im.token', token)
            im.init({
                autoStart: true,
                url: '//${conf["im.ws.server"]}',
                token: function () {
                    return {
                        token: token,
                        tokenType: 'token',
                        device: {
                            type: 0,
                            description: 'client'
                        }
                    }
                },
                onConnect: function (response) {
                    if (response) {
                        //layer.msg('欢迎您,' + response.data.name + '!');
                        userId = response.data.id
                    }
                },
                onMessage: function (message) {
                    if (message.from != userId && message.dest == userId && message.fromType == 'service') {
                        playAudio();
                        scrollTitle('您有新的消息', 2000);
                        startIM();
                        uglcw.io.emit('im.message', message);
                    }
                }
            })
            IM_TOKEN = token
        })

        uglcw.io.on('im.send', function (message) {
            im.sendMessage(message, message.type, {
                success: function () {
                    uglcw.io.on('im.ack', message.packetId)
                }
            })
        })
    }

    var audio = new Audio();

    function playAudio() {
        audio.pause();
        audio.currentTime = 0;
        audio.src = '${base}static/uglcu/notice/1.wav';
        audio.play();
    }

    var titleScrollTimer;

    function scrollTitle(title, duration, speed) {
        duration = duration || 0;
        speed = speed || 250;
        var title_ref = window.document.getElementsByTagName('title')[0];
        var old_title = title_ref.text;
        var i = 0, last = 0;
        clearInterval(titleScrollTimer);

        titleScrollTimer = setInterval(function () {
            title_ref.text = title.substr(i, title.length) + "  ---  " + title.substr(0, i);
            i++;
            if (i === title.length) {
                i = 0;
            }
            last += speed;
            if (duration > 0 && last >= duration) {
                clearInterval(titleScrollTimer);
                title_ref.text = old_title;
                last = 0
            }
        }, speed);
    }

    function refreshPage() {


    }

</script>
</body>
</html>



