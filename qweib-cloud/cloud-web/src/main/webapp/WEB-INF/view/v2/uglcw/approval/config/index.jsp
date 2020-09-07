<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>驰用T3</title>
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
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md12">
            <div class="layui-card header">
                <div class="layui-card-body">
                    <ul class="uglcw-query form-horizontal" id="export">
                        <li>
                            <select uglcw-role="combobox" uglcw-model="status">
                                <option value="">全部</option>
                                <option value="0">未配置</option>
                                <option value="1">已配置</option>
                                <%--<option value="2">已禁用</option>--%>
                            </select>
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
                            id:'id',
                            toolbar: kendo.template($('#toolbar').html()),
                            url: 'manager/approval/config',
                            criteria: '.uglcw-query',
                            loadFilter:{
                                data: function(response){
                                return response.data || [];
                            },
                        }
                    }">
                        <div data-field="no" uglcw-options="width:100">编码</div>
                        <div data-field="approvalName" uglcw-options="width:100">审批名称</div>
                        <div data-field="approvalTypeLabel" uglcw-options="{width:100}">模板类型</div>
                        <div data-field="transferOrderLabel" uglcw-options="{width:120}">转换单据</div>
                        <div data-field="subjectTypeLabel" uglcw-options="{width:200}">科目</div>
                        <div data-field="statusLabel" uglcw-options="{width:120}">状态</div>
                        <div data-field="updatedName" uglcw-options="{width:100}">更新人</div>
                        <div data-field="updatedTime" uglcw-options="{width:160}">更新时间</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:editConfigOnClick();" class="k-button k-button-icontext">
        <span class="k-icon k-i-pencil"></span>修改配置
    </a>
    <%--<a role="button" href="javascript:statusConfigOnClick(1);" class="k-button k-button-icontext">--%>
        <%--<span class="k-icon k-i-checkmark-circle"></span>启用--%>
    <%--</a>--%>
    <%--<a role="button" href="javascript:statusConfigOnClick(2);" class="k-button k-button-icontext">--%>
        <%--<span class="k-icon k-i-cancel"></span>禁用--%>
    <%--</a>--%>
</script>

<script id="configuration" type="text/uglcw-template">
    <div class="layui-card">
        <div class="layui-card-body">
            <div class="form-horizontal" uglcw-role="validator" id="approval_process">
                <input uglcw-role="textbox" id="modelId" uglcw-model="modelId" type="hidden">
                <div class="form-group">
                    <label class="control-label col-xs-6">编码</label>
                    <div class="col-xs-14">
                        <input uglcw-role="textbox" uglcw-model="no" disabled>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">类型</label>
                    <div class="col-xs-14">
                        <input uglcw-role="textbox" uglcw-model="approvalTypeLabel" disabled>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">审批名称</label>
                    <div class="col-xs-14">
                        <input uglcw-role="textbox" uglcw-model="approvalName" disabled>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">付款账户</label>
                    <div class="control-label col-xs-14">
                        <select uglcw-role="combobox" uglcw-model="paymentAccount"
                                uglcw-options="
                                  url: '${base}manager/queryAccountList/',
                                  loadFilter:{
                                    data: function(response){return response.rows ||[];}
                                  },
                                  dataTextField: 'accName',
                                  dataValueField: 'id'
                                "
                        >
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label class="control-label col-xs-6">转换单据</label>
                    <div class="col-xs-14">
                        <select id="transfer_order" uglcw-model="transferOrder" uglcw-validate="required" disabled
                                uglcw-role="combobox"
                                uglcw-options="
                                    dataSource:[{text:'报销单开单', value: 1},{text:'其他收入开单', value: 2},{text:'采购付款(批量付)', value: 3},{text:'费用支付开单', value: 4},
                                    {text:'往来还款', value: 5},{text:'往来回款', value: 6},{text:'往来借出开单', value: 7},{text:'往来借入开单', value: 8}],
                                    change: onTransferOrderLabelChange
                                "
                        >
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">科目</label>
                    <div class="col-xs-9">
                        <select id="config_subject_type" uglcw-model="accountSubjectType" uglcw-role="combobox"
                                uglcw-validate="required"
                                uglcw-options="
                                    dataTextField: 'subjectTypeName',
                                    dataValueField: 'subjectType',
                                    change: onAccountSubjectTypeChange
                                    "
                        >
                        </select>
                        <input type="hidden" uglcw-model="id" uglcw-role="textbox">
                        <input type="hidden" uglcw-model="approvalType" uglcw-role="textbox">
                        <input type="hidden" uglcw-model="approvalId" uglcw-role="textbox">
                    </div>
                    <div class="col-xs-9">
                        <select id="config_subject_item" uglcw-model="accountSubjectItem" uglcw-role="combobox"
                                uglcw-options="
                                    dataTextField: 'subjectItemName',
                                    dataValueField: 'subjectItem',
                                "
                        >
                            <option value="">--请选择--</option>
                        </select>
                    </div>

                </div>
            </div>
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
        uglcw.ui.loaded()
    })


    //科目类型:subject_type
    function onTransferOrderLabelChange(row) {//根据转换单据获取科目信息
        var modelId = uglcw.ui.get('#modelId').value();
            $.ajax({
                url: '${base}manager/workflow/config/subject/subjectType',
                type: 'post',
                dataType: 'json',
                data: {
                    workflowId:modelId
                },
                success: function (response) { //返回的数据
                    var data = response.data || [];
                    uglcw.ui.get('#config_subject_type').k().setDataSource(
                        new kendo.data.DataSource({
                            data: data
                        })
                    );
                    if (data && data.length > 0) {
                        uglcw.ui.get('#config_subject_type').k().select(0);
                        data.map(function(value,index){
                            if (row.accountSubjectType == value.subjectType) {
                                uglcw.ui.get('#config_subject_type').k().select(index);
                            }
                        })
                        onAccountSubjectTypeChange(row)  //触发第二个下拉框
                    }
                }
            })
        // }
    }

    //科目明细：subject_item
    function onAccountSubjectTypeChange(row) {
        var type = uglcw.ui.get('#config_subject_type').value();
        var modelId = uglcw.ui.get('#modelId').value();
        $.ajax({
            url: '${base}manager/workflow/config/subject/subjectItem',
            type: "post",
            data:{workflowId:modelId,subjectType:type},
            success: function (response) {
                var data = response.data || [];
                uglcw.ui.get('#config_subject_item').k().setDataSource(
                    new kendo.data.DataSource({
                        data: data
                    })
                );
                if (data && data.length > 0) {
                    uglcw.ui.get('#config_subject_item').k().select(0);
                    data.map(function(value,index){
                        if (row.accountSubjectItem == value.subjectItem) {
                            uglcw.ui.get('#config_subject_item').k().select(index);
                        }
                    })
                }
                if(row.isNormal == 1){
                    uglcw.ui.get("#config_subject_type").enable(false)
                    uglcw.ui.get("#config_subject_item").enable(false)
                }else{
                    uglcw.ui.get("#config_subject_type").enable(true)
                    uglcw.ui.get("#config_subject_item").enable(true)
                }
            }
        });

    }

    //状态：启用和禁用
    function statusConfigOnClick(status) {  //启用/禁用
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) { //判断是否为空
            var msg;
            if (status == 1) {
                msg = '确定要启用该配置吗？';
            } else if (status == 2) {
                msg = '确定要禁用该配置吗？';
            }
            uglcw.ui.confirm(msg, function () {
                id = selection[0].id;
                var params = {};
                params.id = id;
                params.status = status;
                $.ajax({
                    url: 'manager/approval/config/' + id + '/status',
                    type: "post",
                    contentType: "application/json",
                    dataType: "json",
                    data: JSON.stringify(params),
                    success: function (response) {
                        if (response.code == 200) {
                            uglcw.ui.get('#grid').k().dataSource.read();//刷新页面
                            uglcw.ui.success("更新成功");
                        } else {
                            uglcw.ui.error("该配置已经是该状态，不需要修改");

                        }
                    }
                });
            })
        } else {
            uglcw.ui.warning('请先选择数据行！');
        }
    }

    //修改配置
    function editConfigOnClick() {  //修改配置
        var selection = uglcw.ui.get('#grid').selectedRow();//获取选中行
        if (selection) {
            uglcw.ui.Modal.open({
                area: '500px',
                content: $('#configuration').html(),
                success: function (container) {
                    var row = selection[0];
                    console.log(row)
                    uglcw.ui.init($(container));//初始化
                    uglcw.ui.bind($(container), row);//表示选中第一行
                    onTransferOrderLabelChange(row);
                },
                yes: function (container) {
                    var valid = uglcw.ui.get($(container).find('.form-horizontal')).validate();
                    var form = uglcw.ui.bind('#approval_process');
                    var data = {
                        transferOrder: form.transferOrder,
                        accountSubjectType: form.accountSubjectType,
                        accountSubjectItem: form.accountSubjectItem,
                        paymentAccount: form.paymentAccount
                    }
                    if (form.id) {
                        data.id = form.id
                    } else {
                        data.approvalType = form.approvalType;
                        data.approvalId = form.approvalId;
                    }
                    if (valid) {
                        $.ajax({
                            url: '${base}manager/approval/config/' + (data.id||''),
                            type: 'post',
                            contentType: "application/json",
                            dataType: "json",
                            data: JSON.stringify(data),
                            success: function (response) {
                                if (response.code == 200) {
                                    uglcw.ui.info(response.message);
                                    uglcw.ui.get('#grid').reload();//刷新页面

                                } else {
                                    uglcw.ui.warning(response.message);
                                }
                            }
                        });

                    } else {
                        uglcw.ui.error('校验失败');
                        return false;
                    }
                }
            });
        } else {
            uglcw.ui.warning('请选择数据行！');
        }
    }


</script>
</body>
</html>
