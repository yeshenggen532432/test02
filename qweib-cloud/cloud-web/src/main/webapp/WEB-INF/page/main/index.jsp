<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<style type="text/css">
    .layout-panel-north a {
        text-decoration: none;
        cursor: pointer;
    }

    .layout-panel-north .new-dot {
        margin-left: -15px;
        margin-top: -10px;
        position: absolute;
        top: 50%;
        width: 8px;
        height: 8px;
        border-radius: 50%;
        background-color: #ff5722;
    }

    .layout-panel-north a:hover {
        font-weight: bold;
    }

    .customerServiceMsgCount {
        position: absolute;
        right: 20px;
        top: 1px;
        text-align: right;
        display: none;
    }

    #weixinMsgMemberCountLabel {
        color: red;
    }

    #weixinMsgChatMemberCountLabel {
        color: red;
    }
</style>
<head>
    <title>驰用T3-商业管理系统</title>
    <%@include file="/WEB-INF/page/include/source.jsp" %>
    <link rel="stylesheet" type="text/css" href="resource/css/dtree.css">
    <script type="text/javascript" src="resource/dtree.js"></script>
    <link rel="stylesheet" type="text/css" href="resource/login/css/nav.css"/>
    <script type="text/javascript" src="resource/md5.js"></script>
    <script src="${base}/static/qwb/qwb.core.min.js"></script>
    <script type="text/javascript">
        function toUpdateUsr(msg) {
            document.getElementById("windowChildifrm").src = "${base}/manager/toUpdateUsr?usrId=${usr.idKey}&msg=" + msg;
            showUpdateWindow("修改用户密码");
        }

        //显示弹出窗口
        function showUpdateWindow(title) {
            $("#choiceUpdateWindow").window({
                title: title,
                top: getScrollTop() + 30
            });
            //manager/toUpdateUsr?usrId=${usr.idKey}
            $("#choiceUpdateWindow").window('open');
        }

        function close(memberNm) {
            $(".unm").text(memberNm);
            $("#choiceUpdateWindow").window('close');
        }

        //刷新页面
        function freshMenu(pId, index) {
            window.leftframe.location.href = "${base}/manager/getNewMunus?pId=" + pId + "&optype=${optype}";
            $(".selected").removeClass("selected");
            $("#mainMenu" + index).addClass("selected")
        }

        /**********************
         切换公司
         ***********************/
        function changeCompany() {
            var companyId = $("#companyId").val();
            var dogUser = $("#dogUser").val();
            var idKey = $("#idKey").val();
            var EncData = $("#EncData").val();

            window.location.href = "${base}/manager/changeCompany?companyId=" + companyId + "&optype=${optype}&dogUser=" + dogUser + "&idKey=" + idKey + "&EncData=" + EncData;
        }

        function settingAdmin(msg) {
            document.getElementById("windowChildifrm").src = "${base}/manager/admin/setting?msg=" + msg;
            showUpdateWindow("指定管理员");
        }

        function relogin() {
            //document.getElementById("reLoginWindowfrm").src = "${base}/manager/relogin";
            setTimeout(function(){
                $("#reLoginWindow").window('open');
                initLoginForm();
            }, 200)
            return false;
        }

    </script>
</head>
<body class="easyui-layout">
<input type="hidden" name="idKey" id="idKey"/>
<input type="hidden" name="EncData" id="EncData"/>
<input type="hidden" name="dogUser" id="dogUser"/>
<input type="hidden" name="srvRnd" id="srvRnd" value="${rnd}"/>
<div data-options="region:'north',border:false" class="head">
    <div style="line-height: 56px;padding-right: 25px;">
        <a href="javascript:;;" onclick="quickEnter()" style="text-decoration: none;">单据查询</a>&nbsp;&nbsp;
        <script type="text/javascript">
            function quickEnter() {
                this.closeWin('单据查询');
                this.add('单据查询', 'manager/toBusinessBillRpt');
            }

        </script>
        <c:if test="${fn:contains(usr.usrRoleIds,'1')==true}">
            <a href="javascript:toUpdateUsr('');" style="text-decoration: none;"><span
                    style="font-size: 12px">当前用户</span>：${usr.usrNm}</a>
            <a href="javascript:toUpdateUsr('');" style="text-decoration: none;">&nbsp;修改密码</a>
        </c:if>
        <c:if test="${fn:contains(usr.usrRoleIds,'1')==false}">
            <span style="font-size: 12px;color: white;">当前用户：${usr.usrNm}</span>
            <a href="javascript:toUpdateUsr('');" style="text-decoration: none;">&nbsp;修改密码</a>
        </c:if>
        <a style="text-decoration: none;margin-right: 8px; font-weight: bold" href="javascript:switchToNewVersion();">切换至新版</a>
        <i class="new-dot"></i>

        <span style="font-size: 12px;color: white;">当前企业：<select id="companyId" onchange="checkDog()">
				<c:forEach items="${usr.companyList }" var="map">
                    <option value="${map['companyId'] }">${map['companyName'] }</option>
                </c:forEach>
			</select></span>

        <script type="text/javascript">
            document.getElementById("companyId").value = '${usr.fdCompanyId}';
        </script>
        <input value="全屏" type='button' onclick='toggleFullScreen();'/>
        <a class="easyui-linkbutton" iconCls="icon-back" plain="true"
           href="javascript:loginout();" style="font-size: 12px;color: blue;">退出</a>
    </div>
</div>
<div data-options="region:'center'">
    <div class="easyui-layout" data-options="fit:true">
        <div data-options="region:'north',border:false">
            <div id="navMenu">
                <c:if test="${!empty topmenus}">
                    <ul>
                        <c:forEach items="${topmenus}" var="mnue" varStatus="s">
                            <li class="${mnue.id_key==pId?'selected':'' }" id="mainMenu${s.index }">
                                <a class="mainMenu"
                                   href="javascript:freshMenu('${mnue.id_key }','${s.index }')"><span>${mnue.menu_nm }</span></a>
                            </li>
                        </c:forEach>
                    </ul>
                </c:if>
                <!-- <a href="#" class="easyui-linkbutton" data-options="plain:true">应用管理</a> -->
            </div>
        </div>
        <div data-options="region:'west',split:true,title:'功能导航'" style="width:150px;">
            <%-- 	<div class="easyui-accordion" id="easyui-accordion" height="100%" style="width:150px;border:0;" data-options="fit:true">
                    <c:if test="${!empty pmenus}">
                        <c:forEach items="${pmenus}" var="menuObj">
                            <div title="${menuObj.menu_nm}" data-options="href:'manager/nextmenu?id=${menuObj.id_key}&optype=${optype }'" style="overflow:auto;"></div>
                        </c:forEach>
                    </c:if>
                </div>
                --%>
            <iframe name="leftframe" id="leftframe" src="manager/getNewMunus?&optype=${optype }" frameborder="0"
                    marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
        </div>
        <div data-options="region:'center'">
            <div id="mainTab" class="easyui-tabs" data-options="fit:true,border:false">
                <div title="首页" style="padding:10px">
                    <iframe name="mainiframe" id="mainiframe" src="manager/dashboard?_sticky=v2" frameborder="0" marginheight="0" style="width: 100%;height: 100%;"
                            marginwidth="0"></iframe>
                </div>
            </div>
            <div id="customerServiceMsgCount" class="customerServiceMsgCount">
                <a class="easyui-linkbutton" iconCls="icon-email" plain="false"
                   href="javascript:checkWeixinMemberMsgAndChat();">
                    <label id="weixinMsgMemberCountLabel"></label>条&nbsp;,&nbsp;<img
                        src="resource/shop/weixin/images/customerService/chat.png"/> &nbsp;<label
                        id="weixinMsgChatMemberCountLabel"></label>人&nbsp;<label
                        id="weixinMsgChatWebSocketState">,连接关闭</label>
                </a>
            </div>
        </div>
    </div>
</div>

<div data-options="region:'south',border:false" class="bottom">
    ©2019 网络科技有限公司
    <div style="width:120px;height:28px;border-color: rgb(149, 184, 231);border-width: 1px;border-style: solid;background-color: #D1EEEE;position:absolute;right:0;bottom:0;color: #000000;opacity:0.8;">
        <div id="messageTitle" style="float: left;height:22px;width: 60px;position:absolute;left:0;bottom:0">暂无新消息</div>
        <div style="float: right;width: 60px;height:30px;position:absolute;right:0;bottom:0">
            <input type="checkbox" id="autoOpenTip" onclick="autoOpenTip()" value="1"/>&nbsp;<a
                href="javascript:queryMessages();" style="color: red;font-size: 14px">▲</a></div>
    </div>
</div>

<%--
<div style="width:100px;height:28px;border-color: rgb(149, 184, 231);border-width: 1px;border-style: solid;background-color: #D1EEEE;position:absolute;right:0;bottom:0" id="messageTitleHeader">
        <div id="messageTitle" style="float: left;width: 450px;padding-left: 5px;padding-top: 5px;">暂无新消息</div>
        <div class="panel-tool">
        <input type="checkbox" id="autoOpenTip" onclick="autoOpenTip()" value="1"/>
        <a class="panel-tool-collapse" href="javascript:showMessageWin();"></a></div>
    </div>
 --%>
<div id="treeDiv" class="easyui-window" style="width:400px;height:580px;"
     minimizable="false" modal="true" collapsible="false" closed="true">
    <form name="rolemenufrm" id="rolemenufrm" method="post">
        <input type="hidden" name="roleid" id="roleid"/>
        <input type="hidden" name="opertype" id="opertype"/>
        <div id="divHYGL" class="menuTree" data-options="region:'north'"
             style="width: 380px;height:510px;overflow: auto;padding-left: 5px;">
            <div id="divHYGL_tree" class="dtree"></div>
        </div>
        <div style="text-align: center;" data-options="region:'south',border:false">
            <a class="easyui-linkbutton" href="javascript:saverolepri();">保存</a>
            &nbsp;&nbsp;
            <a class="easyui-linkbutton" href="javascript:closetreewin();">关闭</a>
        </div>
    </form>
</div>
<div id="treeDiv2" class="easyui-window" style="width:400px;height:580px;"
     minimizable="false" modal="true" collapsible="false" closed="true">
    <form name="rolemenufrm2" id="rolemenufrm2" method="post">
        <input type="hidden" name="roleid2" id="roleid2"/>
        <input type="hidden" name="cdid" id="cdid"/>
        <input type="hidden" name="usrid2" id="usrid2"/>
        <div id="divHYGL2" class="menuTree" data-options="region:'north'"
             style="width: 380px;height:510px;overflow: auto;padding-left: 5px;">
            <div id="divHYGL_tree2" class="dtree"></div>
        </div>
        <div style="text-align: center;" data-options="region:'south',border:false">
            <a class="easyui-linkbutton" href="javascript:saverolepri2();">保存</a>
            &nbsp;&nbsp;
            <a class="easyui-linkbutton" href="javascript:closetreewin3();">关闭</a>
        </div>
    </form>
</div>
<div id="treeDivNews" class="easyui-window" style="width:400px;height:580px;"
     minimizable="false" modal="true" collapsible="false" closed="true">
    <form name="deptmenufrm" id="deptmenufrm" method="post">
        <input type="hidden" name="tpId" id="tpId"/>
        <div id="divHYGLNews" class="menuTree" data-options="region:'north'"
             style="width: 380px;height:510px;overflow: auto;padding-left: 5px;">
            <div id="divHYGLNews_tree" class="dtree"></div>
        </div>
        <div style="text-align: center;" data-options="region:'south',border:false">
            <a class="easyui-linkbutton" href="javascript:saveNewsDept();">保存</a>
            &nbsp;&nbsp;
            <a class="easyui-linkbutton" href="javascript:closetreewin2();">关闭</a>
        </div>
    </form>
</div>
<div id="treeDiv_creator" class="easyui-window" style="width:400px;height:580px;"
     minimizable="false" modal="true" collapsible="false" closed="true">
    <form name="rolemenufrm_creator" id="rolemenufrm_creator" method="post">
        <input type="hidden" name="roleid_creator" id="roleid_creator"/>
        <input type="hidden" name="opertype_creator" id="opertype_creator"/>
        <div id="divHYGL_creator" class="menuTree" data-options="region:'north'"
             style="width: 380px;height:510px;overflow: auto;padding-left: 5px;">
            <div id="divHYGL_tree_creator" class="dtree"></div>
        </div>
        <div style="text-align: center;" data-options="region:'south',border:false">
            <a class="easyui-linkbutton" href="javascript:deleteCreator();">移除</a>
            &nbsp;&nbsp;
            <a class="easyui-linkbutton" href="javascript:closeCreatorTreeWin();">关闭</a>
        </div>
    </form>
</div>

<div id="treeDiv_manager" class="easyui-window" style="width:400px;height:580px;"
     minimizable="false" modal="true" collapsible="false" closed="true">
    <form name="rolemenufrm_manager" id="rolemenufrm_manager" method="post">
        <input type="hidden" name="roleid_manager" id="roleid_manager"/>
        <input type="hidden" name="opertype_manager" id="opertype_manager"/>
        <div id="divHYGL_manager" class="menuTree" data-options="region:'north'"
             style="width: 380px;height:510px;overflow: auto;padding-left: 5px;">
            <div id="divHYGL_tree_manager" class="dtree"></div>
        </div>
        <div style="text-align: center;" data-options="region:'south',border:false">
            <a class="easyui-linkbutton" href="javascript:deleteManager();">移除</a>
            &nbsp;&nbsp;
            <a class="easyui-linkbutton" href="javascript:closeManagerTreeWin();">关闭</a>
        </div>
    </form>
</div>

<div id="treeDiv_transfer_manager" class="easyui-window" style="width:400px;height:580px;"
     minimizable="false" modal="true" collapsible="false" closed="true">
    <form name="rolemenufrm_transfer_manager" id="rolemenufrm_transfer_manager" method="post">
        <input type="hidden" name="roleid_transfer_manager" id="roleid_transfer_manager"/>
        <input type="hidden" name="opertype_transfer_manager" id="opertype_transfer_manager"/>
        <div id="divHYGL_transfer_manager" class="menuTree" data-options="region:'north'"
             style="width: 380px;height:510px;overflow: auto;padding-left: 5px;">
            <div id="divHYGL_tree_transfer_manager" class="dtree"></div>
        </div>
        <div style="text-align: center;" data-options="region:'south',border:false">
            <a class="easyui-linkbutton" href="javascript:transferManager();">转移</a>
            &nbsp;&nbsp;
            <a class="easyui-linkbutton" href="javascript:closeTransferManagerTreeWin();">关闭</a>
        </div>
    </form>
</div>

<div id="treeDiv_manager" class="easyui-window" style="width:400px;height:580px;"
     minimizable="false" modal="true" collapsible="false" closed="true">
    <form name="rolemenufrm_manager" id="rolemenufrm_manager" method="post">
        <input type="hidden" name="roleid_manager" id="roleid_manager"/>
        <input type="hidden" name="opertype_manager" id="opertype_manager"/>
        <div id="divHYGL_manager" class="menuTree" data-options="region:'north'"
             style="width: 380px;height:510px;overflow: auto;padding-left: 5px;">
            <div id="divHYGL_tree_manager" class="dtree"></div>
        </div>
        <div style="text-align: center;" data-options="region:'south',border:false">
            <a class="easyui-linkbutton" href="javascript:deleteManager();">移除</a>
            &nbsp;&nbsp;
            <a class="easyui-linkbutton" href="javascript:closeManagerTreeWin();">关闭</a>
        </div>
    </form>
</div>

<div id="rcmenu" class="easyui-menu" style="display: none; width: 100px;background-color: #87CEFF;">
    <div id="closecurrent">
        关闭当前窗口
    </div>
    <div id="closeall">
        关闭全部
    </div>
    <div id="closeother">
        关闭其他
    </div>
</div>
<div id="choiceUpdateWindow" class="easyui-window" style="width:550px;height:300px;" data-options="title:'设置',zIndex:8999"
     minimizable="false" maximizable="false" collapsible="false" closed="true" modal="true">
    <iframe name="windowUpdateifrm" src="manager/toUpdateUsr?usrId=${usr.idKey}" id="windowChildifrm" frameborder="0"
            marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
</div>
<div id="messageWindow" style="opacity:0.9;">
    <ul id="messageUl"></ul>
</div>

<div id="reLoginWindow" class="easyui-window" style="width:450px;height:220px;" data-options="showHeader:true, top: 150"
     title="重新登录"
     minimizable="false" maximizable="false" collapsible="false" closed="true" modal="true">
    <form id="loginForm">
    <div class="box" style="width: 100%;">
        <dl id="dl">
            <dd>
                <span class="title" style="width:100px;">公司:</span>
                <input name="company" type="hidden" value="${principal.fdCompanyId}"/>
                <input name="username" readonly  style="width: 200px" value="${principal.fdCompanyNm}"
                       class="reg_input">
            </dd>
            <dd>
                <span class="title" style="width:100px;">用户名:</span>
                <input name="company" type="hidden" value="${principal.fdCompanyId}"/>
                <input name="username" readonly value="${principal.fdMemberMobile}"
                       style="width: 200px"
                       class="reg_input">
            </dd>
            <dd>
                <span class="title" style="width:100px;">密码:</span>
                <input id="loginPwd" type="password" name="password"
                       style="width: 200px"
                       class="reg_input">
                <span id="loginPwdTip" class="onshow" style="display: block;margin-left: 116px;margin-top: 5px;"></span>
            </dd>
        </dl>
        <div style="text-align: center;margin-top:15px;">
            <button type="button"  class="easyui-linkbutton" style="width: 200px; color:#fff;border-color:#4b72a4;background:linear-gradient(to bottom,#698cba 0,#577eb2 100%);"
                    onclick="doLogin();">登录</button>
        </div>
    </div>
    </form>
</div>

<div id="soundDiv"></div>
<script type="text/javascript">
    $(function () {
        $(".tabs-header").bind('contextmenu', function (e) {
            e.preventDefault();
            $('#rcmenu').menu('show', {
                left: e.pageX,
                top: e.pageY
            });
        });
        //关闭当前窗口
        $("#closecurrent").bind("click", function () {
            var tab = $('#mainTab').tabs('getSelected');
            var index = $('#mainTab').tabs('getTabIndex', tab);
            $('#mainTab').tabs('close', index);
        });
        //关闭所有标签页
        $("#closeall").bind("click", function () {
            var tablist = $('#mainTab').tabs('tabs');
            for (var i = tablist.length - 1; i >= 0; i--) {
                $('#mainTab').tabs('close', i);
            }
        });
        //关闭非当前标签页（先关闭右侧，再关闭左侧）
        $("#closeother").bind("click", function () {
            var tablist = $('#mainTab').tabs('tabs');
            var tab = $('#mainTab').tabs('getSelected');
            var index = $('#mainTab').tabs('getTabIndex', tab);
            for (var i = tablist.length - 1; i > index; i--) {
                $('#mainTab').tabs('close', i);
            }
            var num = index - 1;
            for (var i = num; i >= 0; i--) {
                $('#mainTab').tabs('close', 0);
            }
        });

        //密码过于简单，弹出修改密码
        if ('${usr.usrPwd}' == hex_md5("123456")) {
            //$.messager.alert('消息','密码不能为123456,请修改密码!','info');
            toUpdateUsr('密码不能为123456,请修改密码!');
        }
    });

    function initLoginForm(){
        $.formValidator.initConfig();
        $('#loginPwd').formValidator({
            onShow: '请输入当前用户密码',
            onFocus: '请输入当前用户密码',
            onCorrect: '通过'
        }).inputValidator({
            min: 4,
            max: 25,
            onError: '请输入4-25位密码'
        })
    }

    function doLogin(){
        var param = $('#loginForm').serializeObject();
        if(!param.password){
            return;
        }
        param.password = hex_md5(param.password);
        $.ajax({
            url: '/manager/login',
            type: 'post',
            dataType: 'json',
            contentType: 'application/json',
            data: JSON.stringify(param),
            success: function (response) {
                if (response.code === 200) {
                    $("#reLoginWindow").window('close');
                } else {
                    $.messager.alert('登录失败',response.message);
                }
            }
        })
    }

    window.openTab = function (title, url, refresh) {
        add(title, url);
    }

    function add(title, operUrl) {
        /*$.ajaxSettings.async = false;
        var bool = handleLogin();
        if (!bool) {
            return false;
        }*/
        if ($("#mainTab").tabs('exists', title)) {
            $("#mainTab").tabs("select", title);
        } else {
            var content = '<iframe src="' + operUrl + '" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>';
            $('#mainTab').tabs('add', {
                title: title,
                content: content,
                closable: true
            });
        }
    }

    function editOrder(orderNo) {
        var operUrl = "manager/queryBforderPage?dataTp=1&orderNo=" + orderNo;
        var content = '<iframe src="' + operUrl + '" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>';
        closeWin('销售订单信息');
        $('#mainTab').tabs('add', {
            title: "销售订单信息",
            content: content,
            closable: true
        });
    }


    function closeWin(title) {
        $('#mainTab').tabs('close', title);
    }

    //退出
    function loginout() {
        if (confirm("是否退出?")) {
            if ($("#mainTab").tabs("exists", "客服聊天")) {//客服打开了聊天窗口
                closeChatTab();//退出当前客服与会员的聊天
            }
            window.location.href = "${base}/manager/loginout";
        }
    }

    //分配权限
    function torolemenu(idKey) {
        $("#divHYGL_tree").empty();
        $("#roleid").val(idKey);
        $("#opertype").val("menu");
        $.ajax({
            type: "post",
            url: "manager/menutree",
            data: "id=" + idKey,
            success: function (data) {
                if (data) {
                    loadTree_menu("divHYGL", "divHYGL_tree", "分配权限", data);
                }
            }
        });
        $("#treeDiv").window('open');
    }

    //分配用户
    function toroleusr(idKey) {
        $("#divHYGL_tree").empty();
        $("#roleid").val(idKey);
        $("#opertype").val("usr");
        $.ajax({
            type: "post",
            url: "manager/usrtree_company",
            data: "id=" + idKey,
            success: function (data) {
                if (data) {
                    loadTree_usr("divHYGL", "divHYGL_tree", "分配用户", data);
                }
            }
        });
        $("#treeDiv").window({title: "分配用户"});
        $("#treeDiv").window('open');
    }

    //分配用户2
    function toroleusr2(roleid, cdid, mids) {
        $("#divHYGL_tree2").empty();
        $("#roleid2").val(roleid);
        $("#cdid").val(cdid);
        $.ajax({
            type: "post",
            url: "manager/usrtree_company2",
            data: "roleid=" + roleid + "&cdid=" + cdid + "&mids=" + mids,
            success: function (data) {
                if (data) {
                    loadTree_usr2("divHYGL2", "divHYGL_tree2", "选择用户", data);
                }
            }
        });
        $("#treeDiv2").window({title: "选择用户"});
        $("#treeDiv2").window('open');
    }

    //移除创建者
    function toRoleCreator(idKey) {
        $("#divHYGL_tree_creator").empty();
        $("#roleid_creator").val(idKey);
        $("#opertype_creator").val("usr");
        $.ajax({
            type: "post",
            url: "manager/usrtree_company",
            data: "id=" + idKey,
            success: function (data) {
                if (data) {
                    loadTree_creator("divHYGL_creator", "divHYGL_tree_creator", "移除创建者", data);
                }
            }
        });
        $("#treeDiv_creator").window({title: "移除创建者"});
        $("#treeDiv_creator").window('open');
    }

    //移除管理员
    function toRoleManager(idKey) {
        $("#divHYGL_tree_manager").empty();
        $("#roleid_manager").val(idKey);
        $("#opertype_manager").val("usr");
        $.ajax({
            type: "post",
            url: "manager/usrtree_company",
            data: "id=" + idKey,
            success: function (data) {
                if (data) {
                    loadTree_manager("divHYGL_manager", "divHYGL_tree_manager", "移除管理员", data);
                }
            }
        });
        $("#treeDiv_manager").window({title: "移除管理员"});
        $("#treeDiv_manager").window('open');
    }

    //转移管理员
    function toRoleTransferManager(idKey) {
        $("#divHYGL_tree_transfer_manager").empty();
        $("#roleid_transfer_manager").val(idKey);
        $("#opertype_transfer_manager").val("usr");
        $.ajax({
            type: "post",
            url: "manager/usrtree_company",
            data: "id=" + idKey,
            success: function (data) {
                if (data) {
                    loadTree_transfer_manager("divHYGL_transfer_manager", "divHYGL_tree_transfer_manager", "转移管理员", data);
                }
            }
        });
        $("#treeDiv_transfer_manager").window({title: "转移管理员"});
        $("#treeDiv_transfer_manager").window('open');
    }


    function closetreewin2() {
        $("#treeDivNews").window('close');
    }


    //显示用户树
    function loadTree_usr(treeName, objDiv, title, data) {
        var treeName = treeName + "_d";
        var objTree = treeName;
        objTree = new dTree(treeName);
        objTree.add(0, -1, title);
        if (data) {
            for (var i = 0; i < data.length; i++) {
                var nodeid = data[i].usrid;
                var nodevl = data[i].usrnm;
                var parid = 0;
                var isuse = data[i].isuse;
                var chosevalue;
                if (isuse == "0") {
                    chosevalue = "<input type=\"checkbox\" name=\"usrid\" value=\"" + nodeid + "\" />";
                } else {
                    chosevalue = "<input type=\"checkbox\" name=\"usrid\" checked=\"checked\" value=\"" + nodeid + "\" />";
                }
                objTree.add(nodeid, parid, nodevl + chosevalue, "javascript:void();");
            }
            eval(treeName + "= objTree");
            document.getElementById(objDiv).innerHTML = objTree;
        }
    }

    //显示用户树2
    function loadTree_usr2(treeName, objDiv, title, data) {
        var treeName = treeName + "_d";
        var objTree = treeName;
        objTree = new dTree(treeName);
        objTree.add(0, -1, title);
        if (data) {
            for (var i = 0; i < data.length; i++) {
                var nodeid = data[i].usrid;
                var nodevl = data[i].usrnm;
                var parid = data[i].pid;
                var isuse = data[i].isuse;
                var chosevalue;
                if (isuse == "0") {
                    chosevalue = "<input type=\"checkbox\" name=\"usrid5\" value=\"" + nodeid + "\" id=\"" + nodeid + "_" + parid + "_4\" onclick=\"setCheckboxSelected(this,'" + parid + "','4')\"/>";
                } else {
                    chosevalue = "<input type=\"checkbox\" name=\"usrid5\" checked=\"checked\" value=\"" + nodeid + "\" id=\"" + nodeid + "_" + parid + "_4\" onclick=\"setCheckboxSelected(this,'" + parid + "','4')\"/>";
                }
                objTree.add(nodeid, parid, nodevl + chosevalue, "javascript:void();");
            }
            eval(treeName + "= objTree");
            document.getElementById(objDiv).innerHTML = objTree;
        }
    }

    //显示创建者用户树
    function loadTree_creator(treeName, objDiv, title, data) {
        var treeName = treeName + "_d";
        var objTree = treeName;
        objTree = new dTree(treeName);
        objTree.add(0, -1, title);
        if (data) {
            for (var i = 0; i < data.length; i++) {
                if (data[i].isuse == "1") {
                    var nodeid = data[i].usrid;
                    var nodevl = data[i].usrnm;
                    var parid = 0;
                    var isuse = data[i].isuse;
                    var chosevalue;
                    chosevalue = "<input type=\"checkbox\" name=\"usrid\" value=\"" + nodeid + "\" />";
                    objTree.add(nodeid, parid, nodevl + chosevalue, "javascript:void();");
                }
            }
            eval(treeName + "= objTree");
            document.getElementById(objDiv).innerHTML = objTree;
        }
    }

    //显示管理员用户树
    function loadTree_manager(treeName, objDiv, title, data) {
        var treeName = treeName + "_d";
        var objTree = treeName;
        objTree = new dTree(treeName);
        objTree.add(0, -1, title);
        if (data) {
            for (var i = 0; i < data.length; i++) {
                if (data[i].isuse == "1") {
                    var nodeid = data[i].usrid;
                    var nodevl = data[i].usrnm;
                    var parid = 0;
                    var isuse = data[i].isuse;
                    var chosevalue;
                    chosevalue = "<input type=\"checkbox\" name=\"usrid\" value=\"" + nodeid + "\" />";
                    objTree.add(nodeid, parid, nodevl + chosevalue, "javascript:void();");
                }
            }
            eval(treeName + "= objTree");
            document.getElementById(objDiv).innerHTML = objTree;
        }
    }

    //显示转移管理员用户树
    function loadTree_transfer_manager(treeName, objDiv, title, data) {
        var treeName = treeName + "_d";
        var objTree = treeName;
        objTree = new dTree(treeName);
        objTree.add(0, -1, title);
        if (data) {
            for (var i = 0; i < data.length; i++) {
                if (data[i].isuse == "0") {
                    var nodeid = data[i].usrid;
                    var nodevl = data[i].usrnm;
                    var parid = 0;
                    var isuse = data[i].isuse;
                    var chosevalue;
                    chosevalue = "<input type=\"radio\" name=\"usrid\" value=\"" + nodeid + "\" />";
                    objTree.add(nodeid, parid, nodevl + chosevalue, "javascript:void();");
                }
            }
            eval(treeName + "= objTree");
            document.getElementById(objDiv).innerHTML = objTree;
        }
    }


    //保存角色分配功能
    function saverolepri() {
        var opertype = $("#opertype").val();
        var url = opertype == "menu" ? "manager/saverolemenu" : "manager/saveCompanyroleusr";
        $("#rolemenufrm").form('submit', {
            url: url,
            success: function (data) {
                if (opertype != 'menu') {
                    var response = JSON.parse(data);
                    alert(response.message);
                } else {
                    showMsg(data);
                }
                closetreewin();
                /*if (opertype=='usr') {
                    //document.frames('mainiframe').location.reload();
                    //mainiframe.window.location.reload();
                    $("#mainiframe").attr("src",'manager/queryrole_company');
                }*/
            }
        });
    }

    //保存角色分配功能2
    function saverolepri2() {
        var userIds = [];
        var baseTreeDiv = document.getElementById("baseTreeDiv");
        var inputObjs = baseTreeDiv.getElementsByTagName("input");
        for (var i = 0; i < inputObjs.length; i++) {
            var tempId_1 = inputObjs[i].id;
            var tempIndex_1 = tempId_1.indexOf("_");
            //菜单id
            var tempId_2 = tempId_1.substring(tempIndex_1 + 1);
            var tempIndex_2 = tempId_2.indexOf("_");
            //父id
            var tempPId = tempId_2.substring(0, tempIndex_2);
            if (tempPId != '0' && inputObjs[i].checked) {
                userIds.push(inputObjs[i].value);
            }
        }
        $('#usrid2').val(userIds.join(','));
        var url = "manager/updateUsrByjc";
        $("#rolemenufrm2").form('submit', {
            url: url,
            success: function (data) {
                if (data != '-1') {
                    alert("选择用户成功");
                    closetreewin3();
                    // window.parent.torolemenuapply(data, 2);
                }


            }
        });
    }

    //移除创建者
    function deleteCreator() {
        var url = "manager/company/role/creator/delete";
        $("#rolemenufrm_creator").form('submit', {
            url: url,
            success: function (data) {
                var jsonData = JSON.parse(data);
                showMsg(jsonData.message);
                closeCreatorTreeWin();
            }
        });
    }

    //移除管理员
    function deleteManager() {
        var url = "manager/company/role/admin/delete";
        $("#rolemenufrm_manager").form('submit', {
            url: url,
            success: function (data) {
                var jsonData = JSON.parse(data);
                showMsg(jsonData.message);
                closeManagerTreeWin();
            }
        });
    }

    //转移管理员
    function transferManager() {
        var url = "manager/company/role/admin/assign";
        $("#rolemenufrm_transfer_manager").form('submit', {
            url: url,
            success: function (data) {
                var jsonData = JSON.parse(data);
                showMsg(jsonData.message);
                closeTransferManagerTreeWin();
            }
        });
    }

    function closetreewin() {
        $("#treeDiv").window('close');
    }

    function closetreewin3() {
        $("#treeDiv2").window('close');
    }

    function closeCreatorTreeWin() {
        $("#treeDiv_creator").window('close');
    }

    function closeManagerTreeWin() {
        $("#treeDiv_manager").window('close');
    }

    function closeTransferManagerTreeWin() {
        $("#treeDiv_transfer_manager").window('close');
    }

    //显示菜单树
    function loadTree_menu(treeName, objDiv, title, data) {
        var treeName = treeName + "_d";
        var objTree = treeName;
        objTree = new dTree(treeName);
        objTree.add(0, -1, title);
        if (data) {
            for (var i = 0; i < data.length; i++) {
                var nodeid = data[i].idKey;
                var nodevl = data[i].menuNm;
                var parid = data[i].PId;
                var menuTp = data[i].menuTp;
                var menuSeq = data[i].menuSeq;
                var chosevalue;
                if (menuSeq == "0") {
                    chosevalue = "<input type=\"checkbox\" name=\"menuid\" value=\"" + nodeid + "\" id=\"" + nodeid + "_" + parid + "_" + menuTp + "\" onclick=\"setCheckboxSelected(this,'" + parid + "','" + menuTp + "')\"/>";
                } else {
                    chosevalue = "<input type=\"checkbox\" name=\"menuid\" checked=\"checked\" value=\"" + nodeid + "\" id=\"" + nodeid + "_" + parid + "_" + menuTp + "\" onclick=\"setCheckboxSelected(this,'" + parid + "','" + menuTp + "')\"/>";
                }
                objTree.add(nodeid, parid, nodevl + chosevalue, "javascript:void();");
            }
            eval(treeName + "= objTree");
            document.getElementById(objDiv).innerHTML = objTree;
        }
    }

    //订阅单位
    function toNewsDept(tpId) {
        $("#divHYGLNews_tree").empty();
        $("#tpId").val(tpId);
        $.ajax({
            type: "post",
            url: "manager/deptTree",
            data: "id=" + tpId,
            success: function (data) {
                if (data) {
                    loadTree_News("divHYGLNews", "divHYGLNews_tree", "订阅单位", data);
                }
            }
        });
        $("#treeDivNews").window({title: "订阅单位"});
        $("#treeDivNews").window('open');
    }

    //显示订阅单位树
    function loadTree_News(treeName, objDiv, title, data) {
        var treeName = treeName + "_d";
        var objTree = treeName;
        objTree = new dTree(treeName);
        objTree.add(0, -1, title);
        if (data) {
            for (var i = 0; i < data.length; i++) {
                var nodeid = data[i].deptId;
                var nodevl = data[i].deptNm;
                var isUse = data[i].useCount;
                var parid = 0;
                var chosevalue;
                if (isUse == 0) {
                    chosevalue = "<input type=\"checkbox\" name=\"deptId\" value=\"" + nodeid + "\" />";
                } else {
                    chosevalue = "<input type=\"checkbox\" name=\"deptId\" checked=\"checked\" value=\"" + nodeid + "\" />";
                }
                objTree.add(nodeid, parid, nodevl + chosevalue, "javascript:void();");
            }
            eval(treeName + "= objTree");
            document.getElementById(objDiv).innerHTML = objTree;
        }
    }

    //保存订阅单位
    function saveNewsDept() {
        $("#deptmenufrm").form('submit', {
            url: "manager/saveNewsDept",
            success: function (data) {
                showMsg(data);
                closetreewin2();
            }
        });
    }

    //设置复选框选中状态
    function setCheckboxSelected(obj, parentId, menuTp) {
        //如果是父级菜单只向上选
        if (parentId == 0) {
            //向下选
            setChecked(obj, 1);
        } else {
            setChecked(obj, 0);
            if (menuTp == 0) {
                //向下选
                setChecked(obj, 1);
            }
        }
    }

    //向上、向下选
    function setChecked(obj, tp) {
        var objId_1 = obj.id;
        var index_1 = objId_1.indexOf("_");
        //菜单id
        var menuId = objId_1.substring(0, index_1);
        var objId_2 = objId_1.substring(index_1 + 1);
        var index_2 = objId_2.indexOf("_");
        //父id
        var pId = objId_2.substring(0, index_2);
        //菜单类型
        var menuTp = objId_2.substring(index_2 + 1);
        if (tp == 1) {
            if (menuTp == 1) {
                return;
            }
        } else if (tp == 0) {
            var xzCount = getCheckedCount(pId);
            var dqChecked = obj.checked;
            if (dqChecked) {
                if (xzCount != 1) {
                    return;
                }
            } else {
                if (xzCount != 0) {
                    return;
                }
            }
            if (pId == 0) {
                return;
            }
        }
        var baseTreeDiv = document.getElementById("baseTreeDiv");
        var inputObjs = baseTreeDiv.getElementsByTagName("input");
        for (var i = 0; i < inputObjs.length; i++) {
            var tempId_1 = inputObjs[i].id;
            var tempIndex_1 = tempId_1.indexOf("_");
            //菜单id
            var tempMenuId = tempId_1.substring(0, tempIndex_1);
            var tempId_2 = tempId_1.substring(tempIndex_1 + 1);
            var tempIndex_2 = tempId_2.indexOf("_");
            //父id
            var tempPId = tempId_2.substring(0, tempIndex_2);
            //菜单类型
            var tempMenuTp = tempId_2.substring(tempIndex_2 + 1);
            if (tp == 1) {
                if (tempPId == menuId) {
                    inputObjs[i].checked = obj.checked;
                    if (tempMenuTp != 1) {
                        setChecked(inputObjs[i], tp)
                    }
                }
            } else if (tp == 0) {
                if (tempMenuId == pId) {
                    inputObjs[i].checked = obj.checked;
                    if (pId != 0) {
                        setChecked(inputObjs[i], tp);
                    }
                }
            }

        }
    }

    //获取当前级别选中的个数
    function getCheckedCount(pId) {
        //当前级别已选中的个数
        var xzCount = 0;
        var baseTreeDiv = document.getElementById("baseTreeDiv");
        var inputObjs = baseTreeDiv.getElementsByTagName("input");
        for (var i = 0; i < inputObjs.length; i++) {
            var tempId_1 = inputObjs[i].id;
            var tempIndex_1 = tempId_1.indexOf("_");
            //菜单id
            var tempMenuId = tempId_1.substring(0, tempIndex_1);
            var tempId_2 = tempId_1.substring(tempIndex_1 + 1);
            var tempIndex_2 = tempId_2.indexOf("_");
            //父id
            var tempPId = tempId_2.substring(0, tempIndex_2);
            if (tempPId == pId) {
                if (inputObjs[i].checked)
                    xzCount++;
            }
        }
        return xzCount;
    }

    function queryMessages() {
        messageUl.innerHTML = "";
        $.ajax({
            url: "manager/queryBforderMsgls",
            data: "time=" + new Date().getTime() + "&" + Math.random(),
            success: function (data) {
                if (data.state == 1) {
                    var rows = data.rows;
                    if (rows && rows.length > 0) {
                        var messageUl = document.getElementById("messageUl");
                        for (var i = 0; i < rows.length; i++) {

                            var li = document.createElement("li");
                            var row = rows[i];
                            li.id = "li" + row.id;
                            var str = "<div style=\"float: left;line-height: 25px;width: 390px;\"><img src='resource/images/new.gif'/>";
                            str += "<a href=\"javascript:updateIsread('li" + row.id + "','" + row.id + "'),editOrder('" + row.orderNo + "');\" style='color:green'>" + row.orderNo + "</a> 【<font color='red'>业:</font>" + row.memberNm + " <font color='blue'>客:</font>" + row.khNm + "】 (" + row.msgtime + ")</div>"
                            str += "<a class=\"easyui-linkbutton l-btn l-btn-plain\" iconcls=\"icon-remove\" plain=\"true\" href=\"javascript:updateIsread('li" + row.id + "','" + row.id + "');\"><span class=\"l-btn-left\"><span class=\"l-btn-text icon-remove l-btn-icon-left\">知道了</span></span></a>";
                            li.style.cssText = "margin-top: 3px;margin-bottom: 3px;padding-left: 3px;";
                            li.innerHTML = str;
                            if (messageUl.childNodes && messageUl.childNodes.length > 0) {
                                messageUl.insertBefore(li, messageUl.childNodes[0]);
                            } else {
                                messageUl.appendChild(li);
                            }
                            if ((i + 1) == rows.length) {
                                document.getElementById("messageTitle").innerHTML = "<img src='resource/images/new.gif'/>";
                            }
                        }
                        sound();
                        showMessageWin();
                    }
                }
            }
        });

    }

    function autoOpenTip() {
        var isCheck = $('#autoOpenTip').attr('checked');
        if (isCheck) {
            setTimeout(showMessage, 60000);
        } else {

        }
    }

    function showMessage() {
        setTimeout(showMessage, 60000);
        var isCheck = $('#autoOpenTip').attr('checked');
        if (isCheck) {
            queryMessages();
        }
    }

    function updateIsread(id, msgId) {
        $.ajax({
            url: "manager/updateBforderMsgisRead",
            data: "id=" + msgId + "&time=" + new Date().getTime() + "&" + Math.random(),
            success: function (data) {
                if (data == "1") {
                    $("#" + id).remove();
                    setMessageTitle();
                }
            }
        });
    }

    function setMessageTitle() {
        var messageUl = document.getElementById("messageUl");
        if (messageUl.childNodes && messageUl.childNodes.length > 0) {
            document.getElementById("messageTitle").innerHTML = "<img src='resource/images/new.gif'/>";
        } else {
            document.getElementById("messageTitle").innerHTML = "暂无新消息";
        }
    }

    function showMessageWin() {
        $("#messageWindow").window("open");
    }

    function sound() {
        var div = document.getElementById('soundDiv');
        div.innerHTML = "<embed src=\"resource/audio-player.swf?audioUrl=resource/msg.mp3&autoPlay=true\" hidden=\"true\"></embed>";
    }

    var i = 0;
    $(document).ready(function () {
        //定义消息框
        $("#messageWindow").window({
            width: 500,
            height: 200,
            title: '订单信息提示',
            maximizable: false,
            //closable:false,
            collapsible: false,
            iconCls: 'icon-new',
            closable: false,
            top: document.body.clientHeight - 200,
            left: document.body.clientWidth - 505,
            onClose: function () {
                if (i == 1) {
                    gb();
                }
                i = 1;
            }

        });
        //document.getElementById("messageTitleHeader").style.top=document.body.clientHeight-28;
        //document.getElementById("messageTitleHeader").style.left=document.body.clientWidth-100;
        //获取消息
        var messageUl = document.getElementById("messageUl");
        if (!messageUl.childNodes || messageUl.childNodes.length == 0) {
            $("#messageWindow").window("close");
        }
        // queryMessages();
    });

    function gb() {
        //document.cookie="1";
        //var timeout=setTimeout(queryMessages,60000);
        // clearTimeout(timeout);
        document.getElementById("messageTitle").innerHTML = "暂无新消息";
        $("#messageWindow").window("close");
    }

    var nms = "'收款窗口','付款窗口','收货款管理','其它收入收款','往来借入','往来回款收入','付货款管理','费用支付凭证','往来借出','往来还款支出'";

    function checkChuNaMenus() {
        $.ajax({
            type: "post",
            url: "manager/checkChuNaMunus",
            data: "nms=" + nms + "&optype=${optype}",
            success: function (data) {
                if (data == "1") {

                    //<li class="${mnue.id_key==pId?'selected':'' }" id="mainMenu${s.index }">
                    //	<a class="mainMenu" href="javascript:freshMenu('${mnue.id_key }','${s.index }')"><span>${mnue.menu_nm }</span></a>
                    //</li>
                    $("#navMenu ul").append("<li id=\"mainMenu99\"><a class=\"mainMenu\" href=\"javascript:freshMenuChuNa()\"><span>出纳管理</span></a></li>");
                    //alert($("#navMenu").children("ul:first"));
                }
            }
        });
    }

    function freshMenuChuNa() {
        window.leftframe.location.href = "${base}/manager/getChuNaMunus?nms=" + nms + "&optype=${optype}";
        $(".selected").removeClass("selected");
        $("#mainMenu99").addClass("selected")
    }

    checkChuNaMenus();
    var bConnect = 0;

    function load() {

        //如果是IE10及以下浏览器，则跳过不处理
        if (navigator.userAgent.indexOf("MSIE") > 0 && !navigator.userAgent.indexOf("opera") > -1) return;
        try {
            var s_pnp = new SoftKey3W();
            s_pnp.Socket_UK.onopen = function () {
                bConnect = 1;//代表已经连接，用于判断是否安装了客户端服务
            }

            //在使用事件插拨时，注意，一定不要关掉Sockey，否则无法监测事件插拨
            s_pnp.Socket_UK.onmessage = function got_packet(Msg) {
                var PnpData = JSON.parse(Msg.data);
                if (PnpData.type == "PnpEvent")//如果是插拨事件处理消息
                {
                    if (PnpData.IsIn) {
                        //alert("UKEY已被插入，被插入的锁的路径是："+PnpData.DevicePath);
                    } else {
                        //alert("UKEY已被拨出，被拨出的锁的路径是："+PnpData.DevicePath);
                    }
                }
            }

            s_pnp.Socket_UK.onclose = function () {

            }
        } catch (e) {
            alert(e.name + ": " + e.message);
            return false;
        }
    }

    var digitArray = new Array('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f');

    function toHex(n) {

        var result = ''
        var start = true;

        for (var i = 32; i > 0;) {
            i -= 4;
            var digit = (n >> i) & 0xf;

            if (!start || digit != 0) {
                start = false;
                result += digitArray[digit];
            }
        }

        return (result == '' ? '0' : result);
    }

    function checkDog() {
        //如果是IE10及以下浏览器，则使用AVCTIVEX控件的方式
        if (navigator.userAgent.indexOf("MSIE") > 0 && !navigator.userAgent.indexOf("opera") > -1) return Handle_IE10();

        //判断是否安装了服务程序，如果没有安装提示用户安装
        if (bConnect == 0) {
            //window.alert ( "未能连接服务程序，请确定服务程序是否安装。");return false;
            //$("#loginFrm").submit();
            changeCompany();
            return false;
        }

        var DevicePath, ret, n, mylen, ID_1, ID_2, addr;
        try {

            //由于是使用事件消息的方式与服务程序进行通讯，
            //好处是不用安装插件，不分系统及版本，控件也不会被拦截，同时安装服务程序后，可以立即使用，不用重启浏览器
            //不好的地方，就是但写代码会复杂一些
            var s_simnew1 = new SoftKey3W(); //创建UK类

            s_simnew1.Socket_UK.onopen = function () {
                s_simnew1.ResetOrder();//这里调用ResetOrder将计数清零，这样，消息处理处就会收到0序号的消息，通过计数及序号的方式，从而生产流程
            }


            //写代码时一定要注意，每调用我们的一个UKEY函数，就会生产一个计数，即增加一个序号，较好的逻辑是一个序号的消息处理中，只调用我们一个UKEY的函数
            s_simnew1.Socket_UK.onmessage = function got_packet(Msg) {
                var UK_Data = JSON.parse(Msg.data);
                // alert(Msg.data);
                if (UK_Data.type != "Process") return;//如果不是流程处理消息，则跳过
                switch (UK_Data.order) {
                    case 0: {
                        s_simnew1.FindPort(0);//发送命令取UK的路径
                    }
                        break;//!!!!!重要提示，如果在调试中，发现代码不对，一定要注意，是不是少了break,这个少了是很常见的错误
                    case 1: {
                        if (UK_Data.LastError != 0) {
                            //window.alert ( "未发现加密锁，请插入加密锁");
                            s_simnew1.Socket_UK.close();
                            changeCompany();
                            return false;
                        }
                        DevicePath = UK_Data.return_value;//获得返回的UK的路径
                        s_simnew1.GetID_1(DevicePath); //发送命令取ID_1
                    }
                        break;
                    case 2: {
                        if (UK_Data.LastError != 0) {
                            window.alert("返回ID号错误，错误码为：" + UK_Data.LastError.toString());
                            s_simnew1.Socket_UK.close();
                            return false;
                        }
                        ID_1 = UK_Data.return_value;//获得返回的UK的ID_1
                        s_simnew1.GetID_2(DevicePath); //发送命令取ID_2
                    }
                        break;
                    case 3: {
                        if (UK_Data.LastError != 0) {
                            window.alert("取得ID错误，错误码为：" + UK_Data.LastError.toString());
                            s_simnew1.Socket_UK.close();
                            return false;
                        }
                        ID_2 = UK_Data.return_value;//获得返回的UK的ID_2

                        var idKey = toHex(ID_1) + toHex(ID_2);
                        $("#idKey").val(idKey);
                        s_simnew1.ContinueOrder();//为了方便阅读，这里调用了一句继续下一行的计算的命令，因为在这个消息中没有调用我们的函数，所以要调用这个
                    }
                        break;
                    case 4: {
                        //获取设置在锁中的用户名
                        //先从地址0读取字符串的长度,使用默认的读密码"FFFFFFFF","FFFFFFFF"
                        addr = 0;
                        s_simnew1.YReadEx(addr, 1, "ffffffff", "ffffffff", DevicePath);//发送命令取UK地址0的数据
                    }
                        break;
                    case 5: {
                        if (UK_Data.LastError != 0) {
                            window.alert("读数据时错误，错误码为：" + UK_Data.LastError.toString());
                            s_simnew1.Socket_UK.close();
                            return false;
                        }
                        s_simnew1.GetBuf(0);//发送命令从数据缓冲区中数据
                    }
                        break;
                    case 6: {
                        if (UK_Data.LastError != 0) {
                            window.alert("调用GetBuf时错误，错误码为：" + UK_Data.LastError.toString());
                            s_simnew1.Socket_UK.close();
                            return false;
                        }
                        mylen = UK_Data.return_value;//获得返回的数据缓冲区中数据

                        //再从地址1读取相应的长度的字符串，,使用默认的读密码"FFFFFFFF","FFFFFFFF"
                        addr = 1;
                        s_simnew1.YReadString(addr, mylen, "ffffffff", "ffffffff", DevicePath);//发送命令从UK地址1中取字符串
                    }
                        break;
                    case 7: {
                        if (UK_Data.LastError != 0) {
                            window.alert("读取字符串时错误，错误码为：" + UK_Data.LastError.toString());
                            s_simnew1.Socket_UK.close();
                            return false;
                        }
                        var dogUser = UK_Data.return_value;//获得返回的UK地址1的字符串
                        $("#dogUser").val(dogUser);
                        //这里返回对随机数的HASH结果
                        var str = "" + $("#srvRnd").val();
                        s_simnew1.EncString(str, DevicePath);//发送命令让UK进行加密操作
                    }
                        break;

                    case 8: {
                        if (UK_Data.LastError != 0) {
                            window.alert("进行加密运行算时错误，错误码为：" + UK_Data.LastError.toString());
                            s_simnew1.Socket_UK.close();
                            return false;
                        }
                        var EncData = UK_Data.return_value;//获得返回的加密后的字符串
                        $("#EncData").val(EncData);
                        //!!!!!注意，这里一定要主动提交，
                        changeCompany();

                        //所有工作处理完成后，关掉Socket
                        s_simnew1.Socket_UK.close();
                    }
                        break;
                }
            }
            s_simnew1.Socket_UK.onclose = function () {

            }
            return true;
        } catch (e) {
            alert(e.name + ": " + e.message);
        }

    }

    function Handle_IE10() {
        var DevicePath, ret, n, mylen;
        try {

            //建立操作我们的锁的控件对象，用于操作我们的锁
            var s_simnew1;
            //创建控件

            s_simnew1 = new ActiveXObject("Syunew3A.s_simnew3");


            //查找是否存在锁,这里使用了FindPort函数
            DevicePath = s_simnew1.FindPort(0);
            if (s_simnew1.LastError != 0) {
                //window.alert ( "未发现加密锁，请插入加密锁。");
                changeCompany();
                return false;
            }

            //'读取锁的ID
            var idKey = toHex(s_simnew1.GetID_1(DevicePath)) + toHex(s_simnew1.GetID_2(DevicePath));
            if (s_simnew1.LastError != 0) {
                window.alert("返回ID号错误，错误码为：" + s_simnew1.LastError.toString());
                return false;
            }
            $("#idKey").val(idKey);
            //获取设置在锁中的用户名
            //先从地址0读取字符串的长度,使用默认的读密码"FFFFFFFF","FFFFFFFF"
            ret = s_simnew1.YReadEx(0, 1, "ffffffff", "ffffffff", DevicePath);
            mylen = s_simnew1.GetBuf(0);
            //再从地址1读取相应的长度的字符串，,使用默认的读密码"FFFFFFFF","FFFFFFFF"
            var dogUser = s_simnew1.YReadString(1, mylen, "ffffffff", "ffffffff", DevicePath);
            if (s_simnew1.LastError != 0) {
                window.alert("读取用户名时错误，错误码为：" + s_simnew1.LastError.toString());
                return false;
            }
            $("#dogUser").val(dogUser);

            //这里返回对随机数的HASH结果
            var str = "" + $("#srvRnd").val();
            var EncData = s_simnew1.EncString(str, DevicePath);
            if (s_simnew1.LastError != 0) {
                window.alert("进行加密运行算时错误，错误码为：" + s_simnew1.LastError.toString());
                return false;
            }
            $("#EncData").val(EncData);
            changeCompany();

            return true;

        } catch (e) {
            alert(e.name + ": " + e.message + "。可能是没有安装相应的控件或插件");
        }
    }

    load();

    function toggleFullScreen() {
        if (!document.fullscreenElement && // alternative standard method
            !document.mozFullScreenElement && !document.webkitFullscreenElement) {// current working methods
            if (document.documentElement.requestFullscreen) {
                document.documentElement.requestFullscreen();
            } else if (document.documentElement.mozRequestFullScreen) {
                document.documentElement.mozRequestFullScreen();
            } else if (document.documentElement.webkitRequestFullscreen) {
                document.documentElement.webkitRequestFullscreen(Element.ALLOW_KEYBOARD_INPUT);
            }
        } else {
            if (document.cancelFullScreen) {
                document.cancelFullScreen();
            } else if (document.mozCancelFullScreen) {
                document.mozCancelFullScreen();
            } else if (document.webkitCancelFullScreen) {
                document.webkitCancelFullScreen();
            }
        }
    }

    //-------------------------------微信客服开始：-------------------------------------------

    $(function () {
        //查看当前员工是否客服
        if ('${usr.datasource}' == '') {
            return;
        }
        var queryIsCustomerService_url = "/manager/weiXinChat/queryIsCustomerService";
        $.ajax({
            url: queryIsCustomerService_url,
            data: {"memberId":${usr.idKey}},
            type: "POST",
            success: function (json) {
                if (json.state) {
                    if (json.isCustomerService == 1) {//是客服
                        //客服查看微信公众号未读消息
                        var queryWeiXinMsgMemberList_url = "/manager/weiXinChat/queryWeiXinMsgMemberList";
                        $.ajax({
                            url: queryWeiXinMsgMemberList_url,
                            data: {},
                            type: "GET",
                            success: function (json) {
                                if (json.state) {
                                    $("#weixinMsgMemberCountLabel").html(json.weiXinMsgNotCustomerServiceMemberCount); // 未读消息会员数
                                    $("#weixinMsgChatMemberCountLabel").html(json.weiXinMsgHasCustomerServiceMemberCount); // 与客服聊天的会员数
                                } else {
                                    $("#weixinMsgMemberCountLabel").html(0);
                                    $("#weixinMsgChatMemberCountLabel").html(0);
                                    alert(json.msg);
                                }
                            }
                        });
                        //显示客服未读消息
                        $("#customerServiceMsgCount").show();
                    } else {//不是客服，不显示客服未读消息
                    }
                } else {
                    alert(json.msg);
                }
            }

        });

    })

    //打开客服聊天窗口
    function checkWeixinMemberMsgAndChat() {
        this.add('客服聊天', '${base}/manager/toCheckWeixinMemberMsgAndChatPage');
    }

    function closeChatTab() {
        $("#mainTab").tabs("close", "客服聊天");
    }


    function handleLogin() {
        $.ajaxSettings.async = false;
        var bool = false;
        $.ajax({
            url: '<%=basePath %>/manager/checkLogin',
            type: "POST",
            dataType: 'json',
            async: false,
            success: function (json) {
                if (json.state) {
                    bool = true;
                    return true;
                } else {
                    relogin();
                    bool = false;
                }
            }
        });
        if (!bool) {
            return false;
        } else {
            return true;
        }
    }


    //-------------------------------微信客服结束：-------------------------------------------
</script>
<%@include file="/WEB-INF/page/publicplat/corporation/corporationApplyMenu.jsp" %>
<%@include file="/WEB-INF/page/companyPlat/role/roleApplyMenu.jsp" %>
<%@include file="/WEB-INF/page/companyPlat/role/memberAuthority.jsp" %>
<%@include file="/WEB-INF/page/companyPlat/depart/deptPower.jsp" %>
<script>
    function switchToNewVersion() {
        $.messager.confirm('切换至新版本', '切换后页面将刷新，请确定数据已保存!!!', function (r) {
            if (r) {
                setTimeout(function () {
                    window.location.href = '${base}/manager/switch?v=v2'
                }, 500)
            }
        });
    }
</script>
</body>
</html>
