<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>审批模板类型明细编辑</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal" id="export">
                <li>
                    <input uglcw-model="name" uglcw-role="textbox" placeholder="模板名称">
                    <input uglcw-model="delFlag" uglcw-role="textbox" value="0" type="hidden">
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
            <div id="grid" uglcw-role="grid"
                 uglcw-options="{
                            <%--checkbox:'true',--%>
                            responsive:['.header',40],
                            id:'id',
                            toolbar: kendo.template($('#toolbar').html()),
                            url: 'manager/queryAuditTypeList',
                            criteria: '.uglcw-query',
                            <%--pageable: true,--%>
                        }">
                <div data-field="typeName" uglcw-options="width:80,tooltip:true">类型</div>
                <div data-field="name" uglcw-options="width:150,tooltip:true">模板名称</div>
                <div data-field="oper"
                     uglcw-options="width:220,tooltip:true, template: uglcw.util.template($('#formatterOper').html())">
                    科目相关操作
                </div>
            </div>
        </div>
    </div>
</div>

<%--科目相关操作--%>
<script id="formatterOper" type="text/x-uglcw-template">
    #if(data.typeName != '行政类型'){#
    <button onclick="javascript:addSubject(#= data.id#);" class="k-button k-info">添加</button>
    <button onclick="javascript:delSubject(#= data.id #);" class="k-button k-info">移除</button>
    <button onclick="javascript:querySubject(#=data.id#);" class="k-button k-info">查看</button>
    #}#
</script>

<script type="text/x-kendo-template" id="toolbar">
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
        uglcw.ui.loaded()
    })

    //添加科目
    function addSubject(id) {
       var index = uglcw.ui.Modal.showTreeGridSelector({
            tree: {
                loadFilter: function (response) {
                    return response.data || [];
                },
                url: '${base}manager/workflow/model/subject/querySubjectTypeTree?workflowId=' + id,
                model: 'subjectType',
                dataTextField: 'subjectTypeName',
                id: 'subjectType'
            },
            id:'id',
            btns: ['确定', '取消'],
            width: 900,
            persistSelection: false,
            pageable: false,
            checkbox: true,
            url: '${base}manager/workflow/model/subject/querySubjectItemList?workflowId=' + id,
            criteria: '<input uglcw-role="textbox" placeholder="输入关键字" uglcw-model="keyword">',
            columns: [
                {field: 'subjectItemName', title: '费用明细科目', width: 400},
            ],
            yes: function (data) {
                if(data){
                    $.ajax({
                        url: "${base}manager/workflow/model/subject/save",
                        data: JSON.stringify({modelId: id, subjectList: $.map(data, function(item){
                                return {
                                    subjectType: item.subjectType,
                                    subjectItem: item.subjectItem
                                }
                            })}),
                        type: "post",
                        contentType:"application/json",
                        success: function (json) {
                            if (json != "-1") {
                                uglcw.ui.success('添加成功');
                                uglcw.ui.Modal.close(index);
                            } else {
                                uglcw.ui.error('操作失败');
                            }
                        }
                    });
                }
            }
        })
    }

    //移除科目
    function delSubject(id) {
        uglcw.ui.Modal.showGridSelector({
            btns:['确定','取消'],
            closable: false,
            title: false,
            url: '${base}manager/workflow/model/subject/page',
            query: function (params) {
                params.workflowId = id;//额外参数
                params.page = params.page - 1;
                return params;
            },
            checkbox: true,
            width: 650,
            height: 400,
            criteria: '<input placeholder="请输入关键字" uglcw-role="textbox" uglcw-model="keyword">',
            columns: [
                {field: 'subjectTypeName', title: '科目',width: 200, tooltip:true},
                {field: 'subjectItemName', title: '科目明细',width: 200, tooltip:true},
            ],
            yes: function (data) {
                if (data) {
                    var ids = $.map(data, function (row) {
                        return row.id;
                    });
                    $.ajax({
                        url: "${base}manager/workflow/model/subject/delete",
                        data:JSON.stringify({ workflowId:id, ids: ids}),
                        type: "post",
                        contentType:"application/json",
                        success: function (data) {
                            if (data.code == 200) {
                                uglcw.ui.success(data.message);
                                uglcw.ui.Modal.close();
                            } else {
                                uglcw.ui.error(data.message);
                            }
                        }
                    });
                }
            }
        })
    }

    //查询科目
    function querySubject(id) {
        uglcw.ui.Modal.showGridSelector({
            btns:[],
            closable: true,
            title: false,
            url: '${base}manager/workflow/model/subject/page',
            query: function (params) {
                params.workflowId = id;//额外参数
                params.page-=1;
                return params;
            },
            checkbox: false,
            width: 650,
            height: 400,
            criteria: '<input placeholder="请输入关键字" uglcw-role="textbox" uglcw-model="keyword">',
            columns: [
                {field: 'subjectTypeName', title: '科目',width: 200, tooltip:true},
                {field: 'subjectItemName', title: '科目明细',width: 200, tooltip:true},
            ],
        })
    }


</script>
</body>
</html>
