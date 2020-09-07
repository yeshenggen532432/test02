<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>企微宝</title>

    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <%@include file="/WEB-INF/page/include/source.jsp" %>
</head>

<body>
<div id="toolbar" class="easyui-panel" style="padding:10px; vertical-align: center;">
    <a class="easyui-linkbutton" iconCls="icon-edit" plain="true" href="javascript:void(0);"
       onclick="editConfigOnClick()">修改配置</a>
    <a class="easyui-linkbutton" iconCls="icon-remove" plain="true" href="javascript:void(0);"
       onclick="statusConfigOnClick(1);">启用</a>
    <a class="easyui-linkbutton" iconCls="icon-remove" plain="true" href="javascript:void(0);"
       onclick="statusConfigOnClick(2);">禁用</a>
</div>
<div id="datagrid"></div>
<div id="config_dialog" class="easyui-dialog" title="审批配置面板"
     data-options="buttons: [{text:'提交', handler:configSubmitHandler}, {text:'取消', handler:configCancelHandler}]"
     style="width: 500px; height: 400px; padding: 10px;">
    <form id="config_form">
        <table>
            <tr>
                <td style="min-height: 22px; line-height: 22px; text-align: right;">编码：</td>
                <td>
                    <input type="text" id="config_no" style="min-height: 22px; line-height: 22px; min-width: 300px;"
                           readonly/>
                </td>
            </tr>
            <tr>
                <td style="min-height: 22px; line-height: 22px; text-align: right;">类型：</td>
                <td style="padding-top: 5px;">
                    <input type="text" id="config_approval_type"
                           style="min-height: 22px; line-height: 22px; min-width: 300px;" readonly/>
                </td>
            </tr>
            <tr>
                <td style="min-height: 22px; line-height: 22px;">审批名称：</td>
                <td style="padding-top: 5px;">
                    <input type="text" id="config_approval_name"
                           style="min-height: 22px; line-height: 22px; min-width: 300px;" readonly/>
                </td>
            </tr>
            <tr>
                <td style="min-height: 22px; line-height: 22px;">收款帐户：</td>
                <td style="padding-top: 5px;">
                    <select id="payment_account" name="paymentAccount" style="min-height: 26px; line-height: 26px; min-width: 300px;">
                        <option value="">--请选择--</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td style="min-height: 22px; line-height: 22px;">转换单据：</td>
                <td style="padding-top: 5px;">
                    <select id="transfer_order" name="transferOrder" onchange="querySubjectType()"
                            style="min-height: 26px; line-height: 26px; min-width: 300px;">
                        <option value="">--请选择--</option>
                        <option value="1">报销单据</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td style="min-height: 26px; line-height: 26px; text-align: right;">科目：</td>
                <td style="padding-top: 5px;">
                    <select id="config_subject_type" name="accountSubjectType" onchange="querySubjectItem()"
                            style="min-height: 26px; line-height: 26px; min-width: 140px;">
                        <option value="">--请选择--</option>
                    </select>
                    <select id="config_subject_item" name="accountSubjectItem"
                            style="min-height: 26px; line-height: 26px; min-width: 155px;">
                        <option value="">--请选择--</option>
                    </select>
                    <input type="hidden" id="config_id" name="id">
                    <input type="hidden" id="approval_type" name="approvalType">
                    <input type="hidden" id="approval_id" name="approvalId">
                </td>
            </tr>
        </table>
    </form>
</div>
<script type="text/javascript">
    var dataGrid, configDialog;

    $(function () {
        configDialog = $('#config_dialog').dialog('close');
        dataGrid = $('#datagrid').datagrid({
            url: 'manager/approval/config',
            method: 'get',
            loading: true,
            queryParams: {},
            rownumbers: true,
            fit: true,
            idField: "id",
            fitColumns: true,
            border: false,
            striped: true,
            singleSelect: true,
            autoRowHeight: true,
            pagination: false,
            columns: [[
                {field: "id", title: "id", hidden: true},
                {field: "no", title: "编码", align: "center", width: 20},
                {field: "approvalName", title: "审批名称", width: 50},
                {field: "approvalTypeLabel", title: "审批类型", align: "center", width: 30},
                {field: "transferOrderLabel", title: "转换单据", align: "center", width: 30},
                {field: "subjectTypeLabel", title: "科目", align: "center", width: 30},
                {field: "statusLabel", title: "状态", align: "center", width: 30},
                {field: "updatedName", title: "更新人", align: "center", width: 30},
                {field: "updatedTime", title: "更新时间", align: "center", width: 30}
            ]],
            toolbar: '#toolbar',
            loadFilter: function (response) {
                if (response.code == 200) {
                    return {rows: response.data};
                } else {
                    alert(response.message);
                    return {rows: []};
                }
            }
        });

        paymentAccount();
    });

    function editConfigOnClick() {
        var selectRow = dataGrid.datagrid('getSelected');
        if (!selectRow) {
            $.messager.alert('错误消息', '请先选择数据行', 'error');
            return;
        }

        clearDialog();


        var configId = selectRow.id;
        if (configId) {
            $.ajax({
                url: 'manager/approval/config/' + configId,
                type: "get",
                success: function (response) {
                    if (response.code == 200) {
                        var data = response.data;

                        $('#config_id').val(configId);
                        $('#config_no').val(data.no);
                        $('#config_approval_type').val(data.approvalTypeLabel);
                        $('#config_approval_name').val(data.approvalName);
                        $('#approval_type').val(data.approvalType);
                        $('#approval_id').val(data.approvalId);
                        $('#transfer_order').val(data.transferOrder);
                        $('#payment_account').val(data.paymentAccount);
                        querySubjectType(data.accountSubjectType, data.accountSubjectItem);

                        configDialog.dialog('open');
                    } else {
                        $.messager.alert('错误消息', response.message, 'error');
                    }
                }
            });
        } else {
            $('#config_approval_type').val(selectRow.approvalTypeLabel);
            $('#config_approval_name').val(selectRow.approvalName);
            $('#approval_id').val(selectRow.approvalId);
            $('#approval_type').val(selectRow.approvalType);


            configDialog.dialog('open');
        }
    }

    function statusConfigOnClick(status) {
        var selectRow = dataGrid.datagrid('getSelected');
        if (!selectRow) {
            $.messager.alert('错误消息', '请先选择数据行', 'error');
            return;
        }

        if (!selectRow.id) {
            $.messager.alert('错误消息', '请先进行配置', 'error');
            return;
        }

        var msg;
        if (status == 1) {
            msg = '确定要启用该配置吗？';
        } else if (status == 2) {
            msg = '确定要禁用该配置吗？';
        }

        $.messager.confirm("提示消息", msg, function (value) {
            if (!value) {
                return;
            }

            updateStatus(selectRow.id, status);
        });
    }
    
    function updateStatus(id, status) {
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
                    dataGrid.datagrid('reload');
                    $.messager.alert('提示消息', response.message, 'info');
                } else {
                    $.messager.alert('错误消息', response.message, 'error');
                }
            }
        });
    }

    function configSubmitHandler() {
        var params = {};
        var id = $('#config_id').val();
        if (!id) {
            params.approvalType = $('#approval_type').val();
            params.approvalId = $('#approval_id').val();
        } else {
            params.id = id;
        }

        var transferOrder = $('#transfer_order').val();
        if (!transferOrder) {
            $.messager.alert('错误消息', '请选择转换单据', 'error');
            return;
        }
        params.transferOrder = transferOrder;

        var subjectType = $('#config_subject_type').val();
        var subjectItem = $('#config_subject_item').val();
        if (!subjectType || !subjectItem) {
            $.messager.alert('错误消息', '请选择科目', 'error');
            return;
        }
        params.accountSubjectType = subjectType;
        params.accountSubjectItem = subjectItem;
        params.paymentAccount = $('#payment_account').val();

        $.ajax({
            url: 'manager/approval/config/' + id,
            type: "post",
            contentType: "application/json",
            dataType: "json",
            data: JSON.stringify(params),
            success: function (response) {
                if (response.code == 200) {
                    $.messager.alert('提示消息', response.message, 'info');
                    dataGrid.datagrid('reload');

                    configDialog.dialog('close');
                } else {
                    $.messager.alert('错误消息', response.message, 'error');
                }
            }
        });
    }

    function configCancelHandler() {
        configDialog.dialog('close');
        clearDialog();
    }

    function clearDialog() {
        $('#config_id').val('');
        $('#config_no').val('');
        $('#config_approval_type').val('');
        $('#config_approval_name').val('');
        $('#approval_type').val('');
        $('#approval_id').val('');
        $('#transfer_order').val('');
        $('#config_subject_type').html('<option value="">--请选择--</option>');
        $('#config_subject_item').html('<option value="">--请选择--</option>');
        $('#payment_account').val('');
    }

    function paymentAccount() {
        $.ajax({
            url: 'manager/queryAccountList',
            type: "get",
            success: function (response) {
                if (response.state) {
                    var data = response.rows;
                    var length = data.length;
                    var paymentAccount = $('#payment_account');
                    for (var i = 0; i < length; i++) {
                        paymentAccount.append('<option value="' + data[i].id + '">' + data[i].accName + '</option>');
                    }
                }
            }
        });
    }

    function querySubjectType(selectTypeId, selectItemId) {
        var transferOrder = $('#transfer_order').val();
        if (!transferOrder) {
            $('#config_subject_type').html('<option value="">--请选择--</option>');
            $('#config_subject_item').html('<option value="">--请选择--</option>');
            return;
        }
        $.ajax({
            url: 'manager/approval/config/subject_type?orderId=' + transferOrder,
            type: "get",
            success: function (response) {
                if (response.code == 200) {
                    var data = response.data;
                    var length = data.length;
                    var subjectType = $('#config_subject_type').html('');
                    for (var i = 0; i < length; i++) {
                        subjectType.append('<option value="' + data[i].id + '">' + data[i].typeName + '</option>');
                    }

                    if (selectTypeId) {
                        subjectType.val(selectTypeId);
                        if (selectItemId) {
                            querySubjectItem(selectItemId);
                        }
                    } else {
                        querySubjectItem();
                    }
                } else {
                    $.messager.alert('错误消息', response.message, 'error');
                }
            }
        });
    }

    function querySubjectItem(selectItemId) {
        var costType = $('#config_subject_type').val();
        if (!costType) {
            $('#config_subject_item').html('<option value="">--请选择--</option>');
            return;
        }
        var transferOrder = $('#transfer_order').val();
        $.ajax({
            url: 'manager/approval/config/subject_type/' + costType + '/subject_item?orderId=' + transferOrder,
            type: "get",
            success: function (response) {
                if (response.code == 200) {
                    var data = response.data;
                    var length = data.length;

                    var subjectItem = $('#config_subject_item').html('');
                    for (var i = 0; i < length; i++) {
                        subjectItem.append('<option value="' + data[i].id + '">' + data[i].itemName + '</option>');
                    }

                    if (selectItemId) {
                        subjectItem.val(selectItemId);
                    }

                    configDialog.dialog('open');
                } else {
                    $.messager.alert('错误消息', response.message, 'error');
                }
            }
        });
    }
</script>
</body>
</html>