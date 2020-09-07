<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>驰用T3</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="uglcw-layout-container">
        <div class="uglcw-layout-content">
            <%--表格：start--%>
            <div class="layui-card">
                <div class="layui-card-body full">
                    <div id="grid" uglcw-role="grid"
                         uglcw-options='
						    <%--toolbar: kendo.template($("#toolbar").html()),--%>
							id:"sysSubjectId",
							responsive: [".header", 40],
							checkbox:false,
							editable: true,
							pageable: false,
							autoMove: false,
							autoAppendRow: false,
                    		criteria: ".form-horizontal",
                    		dataBound: function(){
                    		    uglcw.ui.init("#grid .k-grid-content");
                    		},
							url: "/manager/sysMemberMsgSubscribe/subscribeData",
							loadFilter:{
                                data:function(response){
                                    return response || [];
                                }
                            }
                    	'>
                        <div data-field="sysSubjectName" uglcw-options="width:100">名称</div>
                        <div data-field="pushNotice" uglcw-options="width:100,hidden:true,
                            template: function(data){
                                var uuid = uglcw.util.uuid();
                                var data = {
                                    id: uuid,
                                    field: 'pushNotice',
                                    value: data.pushNotice
                                }
                                return uglcw.util.template($('#checkbox-tpl').html())(data);
                            }
                             ">推送
                        </div>
                        <div data-field="mobileNotice" uglcw-options="width:100,hidden:true,
                                   template: function(data){
                                var uuid = uglcw.util.uuid();
                                var data = {
                                    id: uuid,
                                    field: 'mobileNotice',
                                    value: data.mobileNotice,
                                    disabled: true
                                }
                                return uglcw.util.template($('#checkbox-tpl').html())(data);
                            }
                           ">短信
                        </div>
                        <div data-field="emailNotice" uglcw-options="width:100,hidden:true,
                                template: function(data){
                                var uuid = uglcw.util.uuid();
                                var data = {
                                    id: uuid,
                                    field: 'emailNotice',
                                    value: data.emailNotice,
                                    disabled: true
                                }
                                return uglcw.util.template($('#checkbox-tpl').html())(data);
                            }
                        ">邮件
                        </div>
                        <div data-field="wxNotice" uglcw-options="width:100,hidden:true,
                                template: function(data){
                                var uuid = uglcw.util.uuid();
                                var data = {
                                    id: uuid,
                                    field: 'wxNotice',
                                    value: data.wxNotice,
                                    disabled: true
                                }
                                return uglcw.util.template($('#checkbox-tpl').html())(data);
                            }">微信
                        </div>
                        <div data-field="hy_oper"
                             uglcw-options="width:100, template: uglcw.util.template($('#hy_oper').html())">推送对象
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%--员工相关操作--%>
<script id="hy_oper" type="text/x-uglcw-template">
    <button onclick="javascript:addMember(#= data.sysSubjectId#,'#= data.sysSubjectName#');" class="k-button k-info">
        添加订阅
    </button>
    <button onclick="javascript:delMember(#= data.sysSubjectId#,'#= data.sysSubjectName#',1);" class="k-button k-info">
        移除订阅
    </button>
    <button onclick="javascript:delMember(#= data.sysSubjectId#,'#= data.sysSubjectName#');" class="k-button k-info">
        查看订阅
    </button>
</script>

<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:update();" class="k-button k-button-icontext">
        <span class="k-icon k-i-track-changes-accept"></span>保存
    </a>
</script>
<script type="text/x-uglcw-template" id="checkbox-tpl">
    <input type="checkbox" id="#= data.id#" class="k-checkbox"
           #if(data.disabled){#
           disabled
           #}#
           # if(data.value){#
           checked
           # } #
           onchange="onConfigChange(this, '#= data.field#')"><label for="#= data.id#" class="k-checkbox-label"></label>
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        //ui:初始化
        uglcw.ui.init();
        uglcw.layout.init();
        uglcw.ui.loaded();
    })

    function onConfigChange(el, field) {
        //uglcw.ui.success(field + ':' + uglcw.util.toInt($(el).is(':checked')));
        var row = uglcw.ui.get('#grid').k().dataItem($(el).closest('tr'));
        row.set(field, uglcw.util.toInt($(el).is(':checked')));
    }

    function update() {
        $.ajax({
            url: '${base}manager/sysMemberMsgSubscribe/add',
            data: JSON.stringify(uglcw.ui.get("#grid").value()),
            contentType: "application/json", // 指定这个协议很重要
            type: "post",
            success: function (resp) {
                if (resp) {
                    uglcw.ui.success('操作成功');
                    uglcw.ui.get('#grid').reload();
                } else {
                    uglcw.ui.error('操作失败！');
                }
                return false;
            }
        });
    }

    //添加员工
    function addMember(sysSubjectId, sysSubjectName) {
        var url = '${base}manager/sysMemberMsgSubscribe/queryNotSubscribeMemberPage?sysSubjectId=' + sysSubjectId;
        var exeUrl = '${base}manager/sysMemberMsgSubscribe/addMember?sysSubjectId=' + sysSubjectId;
        showModal(url, undefined, sysSubjectName + '-添加订阅员工', exeUrl);
    }

    //移除员工
    function delMember(sysSubjectId, sysSubjectName, isDel) {
        var bottons = [];
        var title = '查看订阅员工';
        if (isDel) {
            bottons = undefined;
            title = '移除订阅员工';
        }
        var url = '${base}manager/sysMemberMsgSubscribe/querySubscribeMemberPage?sysSubjectId=' + sysSubjectId;
        var exeUrl = '';
        if (isDel) {
            exeUrl = '${base}manager/sysMemberMsgSubscribe/removeMember?sysSubjectId=' + sysSubjectId;
        }
        showModal(url, bottons, sysSubjectName + '-' + title, exeUrl);
    }

    function showModal(url, btns, title, exeUrl) {
        uglcw.ui.Modal.showGridSelector({
            closable: true,
            title: title,
            url: url,
            btns: btns,
            checkbox: true,
            width: 450,
            height: 600,
            criteria: '<input placeholder="请输入关键字" uglcw-role="textbox" uglcw-model="memberNm">',
            columns: [
                {field: 'memberNm', title: '姓名', width: 150},
                {field: 'memberMobile', title: '手机号码', width: 150}
            ],
            yes: function (nodes) {
                if (exeUrl) {
                    if (!nodes || nodes.length == 0) {
                        uglcw.ui.error('请选择');
                        return false;
                    }
                    var ids = nodes.map(function (node, index) {
                        return node.memberId;
                    });
                    uglcw.ui.loading('.layui-layer-page');
                    $.ajax({
                        url: exeUrl,
                        data: {mIds: ids.join(',')},
                        type: "post",
                        success: function (resp) {
                            uglcw.ui.loaded();
                            if (resp.state) {
                                uglcw.ui.success('操作成功');
                                if ($('.uglcw-selector-container .uglcw-grid').length>0)
                                    uglcw.ui.get($('.uglcw-selector-container .uglcw-grid')).reload();
                            } else {
                                uglcw.ui.error(resp.message || resp.msg);
                            }
                        },
                        error: function () {
                            uglcw.ui.loaded();
                        }
                    });
                }
            }
        })
    }
</script>
</body>
</html>
