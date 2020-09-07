<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>短信模板管理</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <%@include file="/WEB-INF/view/v2/include/progress.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }

        .query .k-widget.k-numerictextbox {
            display: none;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="target-container" uglcw-role="tabs"
         uglcw-options="
            activate: function(e){
                    if($(e.contentElement).find('.uglcw-grid').hasClass('k-grid')){
                        var grid = uglcw.ui.get($(e.contentElement).find('.uglcw-grid'));
                        if(grid && grid.k() && !grid._loaded){
                            grid.reload()
                            grid._loaded = true;
                        }
                   }
                }
        "
    >
        <ul>
            <li>短信列表</li>
            <li>群发模板</li>
        </ul>
        <div>
            <div class="layui-card header">
                <div class="layui-card-body">
                    <ul class="uglcw-query form-horizontal query">
                        <li>
                            <input uglcw-model="title" uglcw-role="textbox" placeholder="模板名称">
                        </li>
                        <li>
                            <select uglcw-role="combobox" uglcw-model="delFlag" placeholder="状态">
                                <option value="0" selected="selected">正常</option>
                                <option value="1">删除</option>
                            </select>
                        </li>
                        <li>
                            <input uglcw-model="startDate" id="startDate" uglcw-role="datepicker" value="${startDate}">
                        </li>
                        <li>
                            <input uglcw-model="endDate" id="endDate" uglcw-role="datepicker" value="${endDate}">
                        </li>
                        <li>
                            <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                            <button id="reset" class="k-button" uglcw-role="button">重置</button>
                        </li>
                    </ul>
                </div>
            </div>
            <div class="layui-card">
                <div class="layui-card-body full">
                    <div id="grid" class="uglcw-grid-compact" uglcw-role="grid"
                         uglcw-options="
                    responsive:['.header',40],
                    id:'id',
                    toolbar: uglcw.util.template($('#toolbar').html()),
                    url: '${base}manager/sms/template',
                    criteria: '.query',
                    pageable: true,
                    checkbox: true,
                    dblclick: function(row){
                        uglcw.ui.openTab(row.title, '${base}manager/sms/send_record/index?templateId=' + row.id);
                    },
                    loadFilter: {
                      data: function (response) {
                        if(response.code != 200) {
                            uglcw.ui.error(response.message);
                            return [];
                        } else {
                            return response.data.rows;
                        }
                      }
                     }
                    ">
                        <div data-field="title" uglcw-options="width:150">模板名称</div>
                        <div data-field="templateContent" uglcw-options="width:280, tooltip: true">模板内容</div>
                        <div data-field="delFlag"
                             uglcw-options="width: 100, template: uglcw.util.template($('#formatterDelFlag').html())">状态
                        </div>
                        <div data-field="successCount" uglcw-options="width:100">成功</div>
                        <div data-field="failureCount" uglcw-options="width:100">失败</div>
                        <div data-field="lastSendTime"
                             uglcw-options="width:160, schema: {type: 'timestamp', format: 'yyyy-MM-dd HH:mm:ss'}">上次发送时间
                        </div>
                        <div data-field="updatedTime"
                             uglcw-options="width:160, schema: {type: 'timestamp', format: 'yyyy-MM-dd HH:mm:ss'}">更新时间
                        </div>
                        <div data-field="opts" uglcw-options="width: 100, template: uglcw.util.template($('#opts').html())">
                            操作
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div>
            <div class="layui-card header">
                <div class="layui-card-body">
                    <ul class="uglcw-query form-horizontal template-query">
                        <li>
                            <input uglcw-model="title" uglcw-role="textbox" placeholder="模板名称">
                        </li>
                        <li>
                            <select uglcw-role="combobox" uglcw-model="delFlag" placeholder="状态">
                                <option value="0" selected="selected">正常</option>
                                <option value="1">删除</option>
                            </select>
                        </li>
                        <li>
                            <select uglcw-role="combobox" uglcw-model="auditStatus" placeholder="审核状态">
                                <option value="">全部</option>
                                <option value="UNCOMMITTED">未提交</option>
                                <option value="CHECKING">审核中</option>
                                <option value="SUCCESS">审核成功</option>
                                <option value="FAIL">审核失败</option>
                            </select>
                        </li>
                        <li>
                            <button id="template-search" uglcw-role="button" class="k-button k-info">搜索</button>
                            <button id="template-reset" class="k-button" uglcw-role="button">重置</button>
                        </li>
                    </ul>
                </div>
            </div>
            <div class="layui-card">
                <div class="layui-card-body full">
                    <div id="template-grid" class="uglcw-grid-compact" uglcw-role="grid"
                         uglcw-options="
                    responsive:['.header',40],
                    id:'id',
                    autoBind: false,
                    toolbar: uglcw.util.template($('#template-toolbar').html()),
                    url: '${base}manager/sms/template/plat',
                    criteria: '.template-query',
                    pageable: true,
                    checkbox: true,
                    loadFilter: {
                      data: function (response) {
                        if(response.code != 200) {
                            uglcw.ui.error(response.message);
                            return [];
                        } else {
                            return response.data.data;
                        }
                      }
                     }
                    ">
                        <div data-field="title" uglcw-options="width:150">模板名称</div>
                        <div data-field="content" uglcw-options="width:280, tooltip: true">模板内容</div>
                        <div data-field="delFlag"
                             uglcw-options="width: 100, template: uglcw.util.template($('#formatterDelFlag').html())">状态
                        </div>
                        <div data-field="auditStatus" uglcw-options="width:100, template: uglcw.util.template($('#formatterAuditStatus').html())">审核状态</div>
                        <div data-field="reason" uglcw-options="width:200">失败原因</div>
                        <div data-field="sort" uglcw-options="width:100">排序</div>
                        <div data-field="updatedTime"
                             uglcw-options="width:160, schema: {type: 'timestamp', format: 'yyyy-MM-dd HH:mm:ss'}">更新时间
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>


<script type="text/x-uglcw-template" id="formatterDelFlag">
    #if(data.delFlag == 0){#
    正常
    #}else{#
    删除
    #}#
</script>
<script type="text/x-uglcw-template" id="formatterAuditStatus">
    #if(data.auditStatus == 'UNCOMMITTED'){#
    未提交
    #} else if(data.auditStatus == 'CHECKING') {#
    审核中
    #} else if(data.auditStatus == 'SUCCESS') {#
    审核成功
    #} else if(data.auditStatus == 'FAIL') {#
    审核失败
    #}else{#
    #}#
</script>
<script type="text/uglcw-template" id="toolbar">
    <a role="button" href="javascript:add();"
       class="k-button k-button-icontext">
        <span class="k-icon k-i-plus-outline"></span>添加
    </a>
    <a role="button" href="javascript:toedit();"
       class="k-button k-button-icontext">
        <span class="k-icon k-i-pencil"></span>修改</a>
    <a role="button" class="k-button k-button-icontext"
       href="javascript:toDel();">
        <span class="k-icon k-i-trash"></span>删除
    </a>
    <a role="button" class="k-button k-button-icontext"
       href="javascript:toRecover();">
        <span class="k-icon k-i-undo"></span>恢复
    </a>
    <span id="sms-total-text" style="color: red; font-size: 16px"></span>
</script>
<script type="text/x-uglcw-template" id="form">
    <div class="layui-card">
        <div class="layui-card-body">
            <form class="form-horizontal" uglcw-role="validator">
                <input uglcw-role="textbox" id="variables" uglcw-model="variables" type="hidden">
                <div class="form-group">
                    <input type="hidden" uglcw-model="id" uglcw-role="textbox"/>
                    <label class="control-label col-xs-8">模板名称:</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="title" uglcw-role="textbox" uglcw-validate="required">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">发送模板:</label>
                    <div class="col-xs-16">
                        <select style="width: 200px;" uglcw-role="combobox" uglcw-model="platTemplateId,templateName"
                                uglcw-options="
                                expandable: function(node){
                                    node.branchId = node.id;
                                    node.branchName = node.title;
                                },
                                change: function() {
                                    uglcw.ui.get('\\#templateContent').value(this.dataItem().content);
                                    uglcw.ui.get('\\#variables').value(this.dataItem().variables);
                                },
                                dataTextField: 'title',
                                dataValueField: 'id',
                                url: '${base}manager/sms/template/plat/select',
                                loadFilter: {
                                    data: function (response) {
                                        if(response.code != 200) {
                                            uglcw.ui.error(response.message);
                                            return [];
                                        } else {
                                            return response.data;
                                        }
                                    }
                                }">
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">模板内容:</label>
                    <div class="col-xs-14">
                        <textarea style="width: 400px;" id="templateContent" uglcw-model="templateContent"
                                  uglcw-role="textbox" readonly></textarea>
                    </div>
                </div>
            </form>
        </div>
    </div>
</script>
<script type="text/x-uglcw-template" id="opts">
    <button class="k-button k-primary" onclick="send(this)">发送短信</button>
</script>
<script type="text/x-uglcw-template" id="target-selector">
    <div class="target-container" uglcw-role="tabs"
         uglcw-options="
            activate: function(e){
                    if($(e.contentElement).find('.uglcw-grid').hasClass('k-grid')){
                        var grid = uglcw.ui.get($(e.contentElement).find('.uglcw-grid'));
                        if(grid && grid.k() && !grid._loaded){
                            grid.reload()
                            grid._loaded = true;
                        }
                   }
                },
        "
    >
        <ul>
            <li data-type="1" data-member-name="memberNm" data-mobile="memberMobile">员工</li>
            <li data-type="2" data-member-name="proName" data-mobile="tel">供应商</li>
            <li data-type="3" data-member-name="khNm" data-mobile="tel">客户</li>
            <li data-type="4" data-member-name="proName" data-mobile="mobile">往来单位</li>
            <li data-type="5" data-member-name="name" data-mobile="mobile">商城会员</li>
        </ul>
        <div>
            <div class="criteria criteria-provider" style="margin-bottom: 5px;">
                <input class="query" style="width:200px;" placeholder="输入关键字" uglcw-model="memberNm"
                       uglcw-role="textbox">
                <button class="k-info search" uglcw-role="button"><i class="k-icon k-i-search"></i>搜索</button>
            </div>
            <div uglcw-role="grid" id="grid-provider" uglcw-options="
                url: '${base}manager/stkMemberPage',
				size:'small',
				criteria: '.criteria-provider',
				id:'memberId',
				persistSelection: true,
				checkbox:true,
				lockable:false,
				pageable: true,
				persistSelection: true,
				height: 300
			">
                <div data-field="memberNm">姓名</div>
                <div data-field="memberMobile">电话</div>
            </div>
        </div>
        <div>
            <div class="criteria criteria-grid1" style="margin-bottom: 5px;">
                <input class="query" style="width:200px;" placeholder="输入关键字" uglcw-model="proName"
                       uglcw-role="textbox">
                <button class="k-info search" uglcw-role="button"><i class="k-icon k-i-search"></i>搜索</button>
            </div>
            <div uglcw-role="grid" uglcw-options="
                url: '${base}manager/stkprovider',
				size:'small',
				autoBind: false,
				criteria: '.criteria-grid1',
				id:'id',
				persistSelection: true,
				checkbox:true,
				lockable:false,
				pageable: true,
				persistSelection: true,
				height: 300
			">
                <div data-field="proName">供应商</div>
                <div data-field="tel">联系电话</div>
                <div data-field="address">地址</div>
            </div>
        </div>
        <div>
            <div class="criteria criteria-grid2" style="margin-bottom: 5px;">
                <input class="query" style="width:200px;" placeholder="输入关键字" uglcw-model="khNm"
                       uglcw-role="textbox">
                <button class="k-info search" uglcw-role="button"><i class="k-icon k-i-search"></i>搜索</button>
            </div>
            <div uglcw-role="grid" uglcw-options="
                url: '${base}manager/stkchoosecustomer',
				size:'small',
				autoBind: false,
				criteria: '.criteria-grid2',
				id:'id',
				persistSelection: true,
				checkbox:true,
				lockable:false,
				pageable: true,
				persistSelection: true,
				height: 300
			">
                <div data-field="khNm">客户名称</div>
                <div data-field="tel">联系电话</div>
                <div data-field="address">地址</div>
            </div>
        </div>
        <div>
            <div class="criteria criteria-grid3" style="margin-bottom: 5px;">
                <input class="query" style="width:200px;" placeholder="输入关键字" uglcw-model="proName"
                       uglcw-role="textbox">
                <button class="k-info search" uglcw-role="button"><i class="k-icon k-i-search"></i>搜索</button>
            </div>
            <div uglcw-role="grid" uglcw-options="
                url: '${base}manager/queryFinUnit',
				size:'small',
				autoBind: false,
				criteria: '.criteria-grid3',
				id:'id',
				persistSelection: true,
				checkbox:true,
				lockable:false,
				pageable: true,
				persistSelection: true,
				height: 300
			">
                <div data-field="proName">供应商</div>
                <div data-field="mobile">联系电话</div>
                <div data-field="address">地址</div>
            </div>

        </div>
        <div>
            <div class="criteria criteria-grid4" style="margin-bottom: 5px;">
                <input class="query" style="width:200px;" placeholder="输入关键字" uglcw-model="name"
                       uglcw-role="textbox">
                <button class="k-info search" uglcw-role="button"><i class="k-icon k-i-search"></i>搜索</button>
            </div>
            <div uglcw-role="grid" uglcw-options="
                url: '${base}manager/shopMember/dialogShopMemberPage2',
				size:'small',
				autoBind: false,
				criteria: '.criteria-grid4',
				id:'id',
				persistSelection: true,
				checkbox:true,
				lockable:false,
				pageable: true,
				persistSelection: true,
				height: 300
			">
                <div data-field="name">姓名</div>
                <div data-field="mobile">手机号码</div>
                <div data-field="defaultAddress">地址</div>
            </div>

        </div>
    </div>
</script>
<script type="text/x-uglcw-template" id="target-confirm-custom">
    <div class="target-container">
        <div>
            模板内容：<br/>
            <input id="confirm-template-custom" uglcw-role="textbox" readonly>
        </div>
        <div>
            <div id="confirm-grid-custom" uglcw-role="grid" uglcw-options="
				size:'small',
				id:'memberId',
				persistSelection: true,
				checkbox:true,
				lockable:false,
				pageable: false,
				persistSelection: true,
				height: 300
			">
                <div data-field="memberType"
                     uglcw-options="width: 100, template: uglcw.util.template($('#formatterMemberType').html())">会员类型
                </div>
                <div data-field="memberName">姓名</div>
                <div data-field="mobile">电话</div>
            </div>
        </div>
    </div>
</script>
<script type="text/x-uglcw-template" id="target-confirm-group">
    <div class="target-container" style="padding: 8px;">
        <div>
            模板内容：<br/>
            <input id="confirm-template-group" uglcw-role="textbox" readonly>
        </div>
        <div id="confirm-text-group" style="color: red; font-size: 18px;">
        </div>
    </div>
</script>
<script type="text/x-uglcw-template" id="formatterMemberType">
    #if(data.memberType == 1){#
    员工
    #}else if(data.memberType == 2){#
    供应商
    #}else if(data.memberType == 3){#
    客户
    #}else if(data.memberType == 4){#
    往来单位
    #}else if(data.memberType == 5){#
    商城会员
    #}else{#
    未识别类型
    #}#
</script>


<script type="text/uglcw-template" id="template-toolbar">
    <a role="button" href="javascript:templateAdd();"
       class="k-button k-button-icontext">
        <span class="k-icon k-i-plus-outline"></span>添加
    </a>
    <a role="button" href="javascript:toTemplateEdit();"
       class="k-button k-button-icontext">
        <span class="k-icon k-i-pencil"></span>修改</a>
    <a role="button" class="k-button k-button-icontext"
       href="javascript:toTemplateDel(1);">
        <span class="k-icon k-i-trash"></span>删除
    </a>
    <a role="button" class="k-button k-button-icontext"
       href="javascript:toTemplateDel(0);">
        <span class="k-icon k-i-undo"></span>恢复
    </a>
    <a role="button" class="k-button k-button-icontext"
       href="javascript:applyAudit();">
        <span class="ionicons arrow-up-circle-outline"></span>提交审核
    </a>
</script>
<script type="text/x-uglcw-template" id="template-form">
    <div class="layui-card">
        <div class="layui-card-body">
            <form class="form-horizontal" uglcw-role="validator">
                <input uglcw-role="textbox" id="templateId" uglcw-model="id" type="hidden"/>
                <input uglcw-role="textbox" uglcw-model="type" value="1" type="hidden"/>
                <div class="form-group">
                    <input type="hidden" uglcw-model="id" uglcw-role="textbox"/>
                    <label class="control-label col-xs-8">模板名称:</label>
                    <div class="col-xs-16">
                        <input style="width: 300px;" uglcw-model="title" uglcw-role="textbox" uglcw-validate="required">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">模板内容:</label>
                    <div class="col-xs-14">
                        <textarea style="width: 400px;" uglcw-model="content"
                                  uglcw-role="textbox"></textarea>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">变量数组:</label>
                    <div class="col-xs-14">
                        <input style="width: 300px;" uglcw-model="variables" uglcw-role="textbox" readonly>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">排序:</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="sort" value="30" uglcw-role="textbox"
                               uglcw-validate="required">
                    </div>
                </div>
            </form>
        </div>
    </div>
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();

        uglcw.ui.get('#search').on('click', function () {   //搜索（查询）
            uglcw.ui.get('#grid').k().dataSource.read();
        })

        uglcw.ui.get('#reset').on('click', function () {    //重置
            uglcw.ui.clear('.form-horizontal');
        })

        uglcw.ui.get('#template-search').on('click', function () {   //搜索（查询）
            uglcw.ui.get('#template-grid').k().dataSource.read();
        })

        uglcw.ui.get('#template-reset').on('click', function () {    //重置
            uglcw.ui.clear('.form-horizontal');
        })

        uglcw.ui.loaded()
        getTotalSms();
    });

    function getTotalSms() {
        $.ajax({
            url: '${base}manager/sms/template/total',
            type: 'get',
            async: true,
            success: function (response) {
                if (response.success) {
                    $('#sms-total-text').text('当前可发送 ' + response.data + ' 条短信，充值请联系客服人员');
                }
            }
        })
    }

    function add() {
        edit()
    }

    function toedit() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            edit(selection[0]);
        } else {
            uglcw.ui.warning('请选择要修改的行');
        }
    }

    function edit(item) {
        var i = uglcw.ui.Modal.open({
            title: '编辑模板',
            area: ['650px', '240px'],
            content: $('#form').html(),
            success: function (container) {
                uglcw.ui.init($(container));
                uglcw.ui.bind($(container), item);
            },
            yes: function (container) {
                var valid = uglcw.ui.get($(container).find('form')).validate();
                if (!valid) {
                    return false;
                }
                var data = uglcw.ui.bind($(container).find('form'));

                if (!data.title) {
                    uglcw.ui.warning('请填写模板名称');
                    return false;
                }
                if (!data.platTemplateId) {
                    uglcw.ui.warning('请选择发送模板');
                    return false;
                }
                uglcw.ui.loading();
                $.ajax({
                    url: '${base}manager/sms/template',
                    type: 'post',
                    data: JSON.stringify(data),
                    contentType: 'application/json',
                    async: false,
                    success: function (response) {
                        uglcw.ui.loaded();
                        if (response.success) {
                            uglcw.ui.success(response.message);
                            uglcw.ui.get('#grid').reload();
                            uglcw.ui.Modal.close(i);
                        } else {
                            uglcw.ui.error(response.message);
                        }
                    }
                })
                return false;
            }
        })
    }

    function toDel() {//删除
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            uglcw.ui.confirm('您确认想要删除记录吗？', function () {
                $.ajax({
                    url: "${base}manager/sms/template/del_flag",
                    type: "put",
                    contentType: 'application/json',
                    data: JSON.stringify({
                        id: selection[0].id,
                        delFlag: 1
                    }),
                    success: function (response) {
                        if (response.success) {
                            uglcw.ui.success('删除成功');
                            uglcw.ui.get('#grid').reload();
                        } else {
                            uglcw.ui.warning(response.message);
                        }
                    }
                });
            });
        } else {
            uglcw.ui.warning('请选择要删除的数据')
        }
    }

    function toRecover() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            uglcw.ui.confirm('您确认想要恢复该记录吗？', function () {
                $.ajax({
                    url: "${base}manager/sms/template/del_flag",
                    type: "put",
                    contentType: 'application/json',
                    data: JSON.stringify({
                        id: selection[0].id,
                        delFlag: 0
                    }),
                    success: function (response) {
                        if (response.success) {
                            uglcw.ui.success('恢复成功');
                            uglcw.ui.get('#grid').reload();
                        } else {
                            uglcw.ui.warning(response.message);
                        }
                    }
                });
            });
        } else {
            uglcw.ui.warning('请选择要删除的数据')
        }
    }

    function send(btn) {
        event.preventDefault();
        var row = uglcw.ui.get('#grid').k().dataItem($(btn).closest('tr'));
        var modal = uglcw.ui.Modal.open({
            id: 'selector',
            title: '请选择发送对象',
            area: ['700px', '470px'],
            content: $('#target-selector').html(),
            btns: ['发送', '发送本组全部', '取消'],
            success: function (c) {
                uglcw.ui.init(c);
                $(c).find('.criteria .search').each(function (i, btn) {
                    $(btn).on('click', function () {
                        var grid = uglcw.ui.get($(c).find('.uglcw-grid:eq(' + i + ')'));
                        grid.reload();
                    })
                })
            },
            yes: function (c) {
                //按挑选发送
                var recordList = []
                $('.target-container').find('.uglcw-grid').each(function (index, el) {
                    var grid = uglcw.ui.get(el);
                    var type = $('.target-container .k-tabstrip-items li:eq(' + index + ')').data('type');
                    var nameType = $('.target-container .k-tabstrip-items li:eq(' + index + ')').data('member-name');
                    var mobileType = $('.target-container .k-tabstrip-items li:eq(' + index + ')').data('mobile');
                    var selection = grid.selectedRow();
                    if (!!selection && selection.length > 0) {
                        recordList = recordList.concat($.map(selection, function (item) {
                            var mobile = item[mobileType];
                            if (!!mobile) {
                                return {
                                    memberId: item[grid.k().options.id],
                                    memberName: item[nameType],
                                    mobile: mobile,
                                    memberType: type
                                }
                            }
                        }))
                    }
                })

                if (recordList.length <= 0) {
                    uglcw.ui.warning("请选择要发送的带手机号的会员");
                    return;
                }

                sendConfirmCustom(row, recordList);
            },
            btn2: function (c) {
                //发送本组全部
                var type = $(c).find('[uglcw-role=tabs] li.k-state-active').data('type');

                var index = uglcw.ui.get($(c).find('.uglcw-tabstrip')).k().select().index();
                var total = uglcw.ui.get($(c).find('.uglcw-grid').eq(index)).k().dataSource.total();

                sendConfirmGroup(row, type, total)
            }
        })
    }

    function sendConfirmCustom(row, selectedList) {
        var modal = uglcw.ui.Modal.open({
            title: '请选择发送对象',
            area: ['700px', '470px'],
            content: $('#target-confirm-custom').html(),
            success: function (c) {
                uglcw.ui.init(c);
                uglcw.ui.get('#confirm-grid-custom').bind(selectedList);
                uglcw.ui.get('#confirm-template-custom').value(row.templateContent);
                uglcw.ui.get('#confirm-grid-custom').k().select($('#confirm-grid-custom tr'));
            },
            yes: function (c) {
                var selection = uglcw.ui.get($(c).find('.uglcw-grid')).selectedRow();
                if (!selection || selection.length <= 0) {
                    uglcw.ui.warning("请选择要发送的会员");
                    return;
                }

                var recordList = $.map(selection, function (item) {
                    return {
                        memberId: item.memberId,
                        memberType: item.memberType
                    }
                });

                var data = {
                    smsTemplateId: row.id,
                    recordList: recordList
                };

                submitSendData(data);
            }
        })
    }

    function sendConfirmGroup(row, type, count) {
        var modal = uglcw.ui.Modal.open({
            title: '请选择发送对象',
            area: ['700px', '200px'],
            content: $('#target-confirm-group').html(),
            success: function (c) {
                uglcw.ui.init(c);
                uglcw.ui.get('#confirm-template-group').value(row.templateContent);
                $('#confirm-text-group').text('确定要发送本组全部 ' + count + ' 名会员吗？')
            },
            yes: function (c) {
                var data = {
                    smsTemplateId: row.id,
                    memberType: type
                };

                submitSendData(data);
            }
        })
    }

    function submitSendData(data) {
        $.ajax({
            url: "${base}manager/sms/template/send",
            type: "post",
            contentType: 'application/json',
            data: JSON.stringify(data),
            success: function (response) {
                if (response.success) {
                    uglcw.ui.success('开始发送中');
                    showProgress(response.data, function (data) {
                        hideProgress();
                        uglcw.ui.success(data.remark);
                        uglcw.ui.get('#grid').reload();
                        getTotalSms();
                    })
                } else {
                    uglcw.ui.warning(response.message);
                }
            }
        });
    }

    /**
     * 模板相关
     */

    function templateAdd() {
        templateEdit()
    }

    function toTemplateEdit() {
        var selection = uglcw.ui.get('#template-grid').selectedRow();
        if (selection) {
            templateEdit(selection[0]);
        } else {
            uglcw.ui.warning('请选择要修改的行');
        }
    }

    function templateEdit(item) {
        var i = uglcw.ui.Modal.open({
            title: '编辑模板',
            area: ['650px', '270px'],
            content: $('#template-form').html(),
            success: function (container) {
                uglcw.ui.init($(container));
                uglcw.ui.bind($(container), item);
            },
            yes: function (container) {
                var valid = uglcw.ui.get($(container).find('form')).validate();
                if (!valid) {
                    return false;
                }
                var data = uglcw.ui.bind($(container).find('form'));

                if (!data.title) {
                    uglcw.ui.warning('请填写模板名称');
                    return false;
                }
                if (!data.content) {
                    uglcw.ui.warning('请填写模板内容');
                    return false;
                }
                if (!data.sort) {
                    uglcw.ui.warning('请填写排序');
                    return false;
                }
                uglcw.ui.loading();
                if (!!data.id) {
                    $.ajax({
                        url: '${base}manager/sms/template/plat/' + data.id,
                        type: 'put',
                        data: JSON.stringify(data),
                        contentType: 'application/json',
                        async: false,
                        success: function (response) {
                            uglcw.ui.loaded();
                            if (response.success) {
                                uglcw.ui.success(response.message);
                                uglcw.ui.get('#template-grid').reload();
                                uglcw.ui.Modal.close(i);
                            } else {
                                uglcw.ui.error(response.message);
                            }
                        }
                    })
                } else {
                    $.ajax({
                        url: '${base}manager/sms/template/plat',
                        type: 'post',
                        data: JSON.stringify(data),
                        contentType: 'application/json',
                        async: false,
                        success: function (response) {
                            uglcw.ui.loaded();
                            if (response.success) {
                                uglcw.ui.success(response.message);
                                uglcw.ui.get('#template-grid').reload();
                                uglcw.ui.Modal.close(i);
                            } else {
                                uglcw.ui.error(response.message);
                            }
                        }
                    })
                }
                return false;
            }
        })
    }

    function toTemplateDel(delFlag) {//删除
        var selection = uglcw.ui.get('#template-grid').selectedRow();
        if (selection) {
            var text = (delFlag == 1 ? '删除' : '恢复');
            uglcw.ui.confirm('您确认想要' + text + '记录吗？', function () {
                $.ajax({
                    url: "${base}manager/sms/template/plat/del_flag",
                    type: "put",
                    contentType: 'application/json',
                    data: JSON.stringify({
                        id: selection[0].id,
                        delFlag: delFlag
                    }),
                    success: function (response) {
                        if (response.success) {
                            uglcw.ui.success(text + '成功');
                            uglcw.ui.get('#template-grid').reload();
                        } else {
                            uglcw.ui.warning(response.message);
                        }
                    }
                });
            });
        } else {
            uglcw.ui.warning('请选择要删除的数据')
        }
    }

    function applyAudit() {
        var selection = uglcw.ui.get('#template-grid').selectedRow();
        if (selection) {
            uglcw.ui.confirm('您确认想要提交审核吗？', function () {
                $.ajax({
                    url: "${base}manager/sms/template/plat/apply_audit/" + selection[0].id,
                    type: "post",
                    contentType: 'application/json',
                    success: function (response) {
                        if (response.success) {
                            uglcw.ui.success(response.message);
                            uglcw.ui.get('#template-grid').reload();
                        } else {
                            uglcw.ui.warning(response.message);
                        }
                    }
                });
            });
        } else {
            uglcw.ui.warning('请选择要删除的数据')
        }
    }
</script>
</body>
</html>
