<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<title>微信公众号配置</title>
	<meta name="renderer" content="webkit">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<meta name="viewport"
		  content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
	<link rel="icon" href="${base }/resource/ico/favicon.ico" type="image/x-icon"/>
	<link rel="shortcut icon" href="${base }/resource/ico/favicon.ico" type="image/x-icon"/>
	<%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
	<link rel="stylesheet" href="${base}/static/uglcs/layui/css/layui.css" media="all">
	<link rel="stylesheet" href="${base}/static/uglcs/style/admin.css" media="all">
	<style type="text/css">
		cite{
			color:black;
		}
		.layui-side{
			background-color:rgba(255,255,255,1);
			height:100%;
			!important;
		}
		.layui-side-menu{
			background-color:rgba(255,255,255,1);
			height:100%;
			!important;
		}
		.layui-side-scroll{
			background-color:rgba(255,255,255,1);
			height:100%;
			!important;
			background-image : none !important;
		}
		.layui-nav{
			background-color:rgba(255,255,255,1);
			height:100%;
			!important;
		}
		.layui-nav-tree{
			background-color:rgba(255,255,255,1);
			height:100%;
			!important;
		}
		.layui-layout-admin .layui-header {
			background-color: #FFFFFF !important;
			background-image : none !important;
		}
		.layui-nav-itemed{
			background-color:rgba(255,255,255,1);
			height:100%;
			!important;
		}
		.layui-nav-child{
			background-color:rgba(255,255,255,1);
			height:100%;
			!important;
		}

		.layui-nav-itemed>.layui-nav-child {
			display: block;
			padding: 0;
			background-color: rgba(255,255,255,1)!important;
		}
		.layui-header a {
			color: #333 !important;
		}
		.layui-header button{
			font-size:13px;
			margin-top: 2px;
		}
		a{
			text-decoration:none !important;
		}

	</style>
</head>
<body class="layui-layout-body">

<div id="LAY_app">
	<div class="layui-layout layui-layout-admin">
		<div class="layui-header">
			<!-- 头部区域 -->
			<ul class="layui-nav layui-layout-left">
				<!-- 上边菜单 -->
				<!-- 侧边伸缩 -->
				<li class="layui-nav-item layadmin-flexible" lay-unselect>
					<a href="javascript:;" layadmin-event="flexible" title="侧边伸缩">
						<i class="layui-icon layui-icon-shrink-right" id="LAY_app_flexible"></i>
					</a>
				</li>
				<!-- 刷新 -->
				<li class="layui-nav-item " lay-unselect>
					<button class="k-button k-info uglcw-role="button" layadmin-event="refresh">
						<i class="k-icon k-i-refresh"></i>刷新</button>
				</li>
				<!-- 菜单 -->
				<li class="layui-nav-item menu-top layui-this"
					style="font-weight: bold; margin: 0 10px;" lay-unselect>
					<%--<a href="javascript:toWeixinLogin();">
						<cite>注册/登录微信公众平台</cite>
					</a>--%>
					<button class="k-button k-info" uglcw-role="button" onclick="toWeixinLogin();">
						注册/登录微信公众平台</button>
				</li>
				<li class="layui-nav-item menu-top layui-this"
					style="font-weight: bold; margin: 0 10px;" lay-unselect>
					<%--<a href="javascript:uploadWeixinValidateText();">
						<cite>上传商城网页授权域名文件</cite>
					</a>--%>
					<button class="k-button k-info" uglcw-role="button" onclick="uploadWeixinValidateText();">
						上传商城网页授权域名文件</button>
				</li>
				<li class="layui-nav-item menu-top layui-this"
					style="font-weight: bold; margin: 0 10px;" lay-unselect>
					<%--<a href="javascript:showMaterial();">
						<cite>素材管理</cite>
					</a>--%>
					<button class="k-button k-info" uglcw-role="button" onclick="showMaterial();">
						素材管理</button>
				</li>
				<li class="layui-nav-item menu-top layui-this"
					style="font-weight: bold; margin: 0 10px;" lay-unselect>
					<%--<a href="javascript:toMenuConfigPage();">
						<cite>自定义菜单</cite>
					</a>--%>
					<button class="k-button k-info" uglcw-role="button" onclick="toMenuConfigPage();">
						自定义菜单</button>
				</li>
				<li class="layui-nav-item menu-top layui-this"
					style="font-weight: bold; margin: 0 10px;" lay-unselect>
					<%--<a href="javascript:toReplyConfigPage();">
						<cite>自定义回复</cite>
					</a>--%>
					<button class="k-button k-info" uglcw-role="button" onclick="toReplyConfigPage();">
						自定义回复</button>
				</li>
			</ul>
		</div>
		<!-- 侧边菜单 -->

		<div class="layui-side layui-side-menu">
			<%--<div class="layui-logo">
				<div style="background-color: #00AD76;width: 100%;">
				功能导航
				</div>
			</div>--%>
			<div>
				<ul class="layui-nav layui-nav-tree" lay-shrink="all" id="LAY-system-side-menu"
					lay-filter="layadmin-system-side-menu">
					<li data-name="功能导航"
						class="layui-nav-item layui-nav-itemed">
						<dl class="layui-nav-child">
							<dd data-name="公众号配置">
								<a href="javascript:toUpdateConfig()">
									<%--<i class="layui-icon layui-icon-component"
									   style="left: 25px;"></i>--%>
									<cite>公众号配置</cite>
								</a>
							</dd>
							<dd data-name="公众号支付配置">
								<a href="javascript:toUpdatePayConfig()">
									<%--<i class="layui-icon layui-icon-component"
									   style="left: 25px;"></i>--%>
									<cite>公众号支付配置</cite>
								</a>
							</dd>
							<dd data-name="小程序配置">
								<a href="javascript:toUpdateMiniConfig()">
									<%--<i class="layui-icon layui-icon-component"
									   style="left: 25px;"></i>--%>
									<cite>小程序配置</cite>
								</a>
							</dd>
							<dd data-name="客服人员分配">
								<a href="javascript:toSetCustomerService()">
									<%--<i class="layui-icon layui-icon-component"
									   style="left: 25px;"></i>--%>
									<cite>客服人员分配</cite>
								</a>
							</dd>
							<dd data-name="如何注册微信公众平台账号" style="width: 260px">
								<a href="javascript:registerWeixinHelp()">
									<%--<i class="layui-icon layui-icon-component"
									   style="left: 25px;"></i>--%>
									<cite>如何注册微信公众平台账号</cite>
								</a>
							</dd>
							<dd data-name="如何配置appid、appsecret" style="width: 260px">
								<a href="javascript:configAppidAppsecretHelp()">
									<%--<i class="layui-icon layui-icon-component"
									   style="left: 25px;"></i>--%>
									<cite>如何配置appid、appsecret</cite>
								</a>
							</dd>
							<dd data-name="如何配置url、token">
								<a href="javascript:configUrlTokenHelp()">
									<%--<i class="layui-icon layui-icon-component"
                                           style="left: 25px;"></i>--%>
									<cite class="cite">如何配置url、token</cite>
								</a>
							</dd>
						</dl>
					</li>
				</ul>
			</div>
		</div>

		<!-- 主体内容 -->
		<div class="layui-body" id="LAY_app_body" style="position: absolute;top:50px;">
			<div class="layadmin-tabsbody-item layui-show">
				<iframe id="mainiframe" name="mainiframe" frameborder="0" class="layadmin-iframe"></iframe>
			</div>
		</div>

	</div>
</div>
<%--<script src="${base}/static/uglcs/jquery/jquery.min.js"></script>
<script src="${base}/static/uglcu/uglcw.core.min.js"></script>
<script src="${base}/static/uglcs/layui/layui.js"></script>--%>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script src="${base}/static/uglcs/layui/layui.js"></script>
<script type="text/javascript" src="${base }/resource/stkstyle/js/Syunew3.js"></script>
<script type="text/javascript" src="${base }/resource/jquery.upload.js"></script>


<script>
    $(function(){
        uglcw.ui.init();
        uglcw.ui.loaded();
        toUpdateConfig();
    });
    layui.config({
        base: '/static/uglcs/' //静态资源所在路径
    }).extend({
        index: 'lib/index' //主入口模块
    }).use('index', function () {
        this.index.showSubMenu(0);
        this.index.init();
    });

    function onLoad() {
        if (layui && layui.index) {
            layui.index.onFrameLoaded();
        }
    }

    function toUpdateConfig(){
        var hostname=location.hostname;
        //公众号配置
        var url="/manager/WeixinConfig/toUpdateConfig?uglcwUrl="+hostname;
        mainiframe.location.href=url;
    }
    function toUpdatePayConfig(){
        //公众号支付配置
        var url="/manager/weixinPay/toUpdatePayConfig";
        mainiframe.location.href=url;
    }
    //小程序配置
    function toUpdateMiniConfig() {
		var url="/manager/miniWeixinConfig/toUpdateMiniConfig";
		mainiframe.location.href=url;
	}
    //客服人员分配
    function toSetCustomerService(){
        var url="/manager/WeixinConfig/toSetCustomerService";
        mainiframe.location.href=url;
    }
    //如何注册微信公众平台账号
    function registerWeixinHelp(){
        var url="/manager/WeixinConfig/registerWeixinHelp";
        mainiframe.location.href=url;
    }
    //如何配置appid与appsecret
    function configAppidAppsecretHelp(){
        var url="/manager/WeixinConfig/configAppidAppsecretHelp";
        mainiframe.location.href=url;
    }
    //如何配置url与token
    function configUrlTokenHelp(){
        var url="/manager/WeixinConfig/configUrlTokenHelp";
        mainiframe.location.href=url;
    }
    //注册/登录微信公众平台
    function toWeixinLogin() {
        var get_url = "/manager/getWeixinLoginUrl?getWeixinLoginUrl=1";
        var msg = $.ajax({url: get_url, async: false});
        var json = $.parseJSON(msg.responseText);
        var url = json.url;
        uglcw.ui.openTab('微信公众平台', url);

    }
        // 上传商城网页授权域名文件
        function uploadWeixinValidateText(){
            var postText_Url="/manager/postWeixinText";
            $.upload({
                // 上传地址
                url:postText_Url,
                // 文件域名字
                fileName: 'uploadText',
                // 上传完成后, 返回json, text
                dataType: 'json',
                // 上传之前回调,return true表示可继续上传
                onSend: function() {
                    return true;
                },
                // 上传之后回调
                onComplate:function(data){
                    if(data.state){
                        uglcw.ui.success(data.msg);
                        layer.msg(data.msg);
                    }else{
                        uglcw.ui.error(data.msg);
                        layer.msg(data.msg);
                    }
                },
            });
        }

    //自定义回复
    function toReplyConfigPage() {
        var url="/manager/toReplyConfigPage";
        uglcw.ui.openTab('自定义回复', url);
    }

    //自定义回复
    function toReplyConfigPage() {
        var url="/manager/toReplyConfigPage";
        uglcw.ui.openTab('自定义回复', url);
    }

    //素材管理
    function showMaterial(){
        var url="/manager/WeixinConfig/materialManager";
        uglcw.ui.openTab('素材管理', url);
    }

    //自定义菜单
    function toMenuConfigPage(){
        var url="/manager/toMenuConfigPage";
        uglcw.ui.openTab('自定义菜单', url);
    }
</script>
</body>
</html>



