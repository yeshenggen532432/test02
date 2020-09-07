<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>驰用T3</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }

        .row-color-blue {
            color: blue;
            text-decoration: line-through;
            font-weight: bold;
        }

        .row-color-pink {
            color: #FF00FF;
            font-weight: bold;
        }

        .row-color-red {
            color: red;
            font-weight: bold;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal" id="export">
                <li style="width: 250px;">
                    <span style="background-color:#FF00FF;border: 1;color:white ">&nbsp;被冲红单&nbsp;</span>
                    &nbsp;<span style="background-color:red;border: 1;color:white">&nbsp;&nbsp;&nbsp;冲红单&nbsp;&nbsp;&nbsp;</span>
                    &nbsp;<span style="background-color:blue;border: 1;color:white">&nbsp;&nbsp;&nbsp;作废单&nbsp;&nbsp;&nbsp;</span>
                </li>
            </ul>
        </div>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options="{
                    responsive:['.header',40],
                    id:'id',
                    pageable: true,
                    rowNumber: true,
                    criteria: '.form-horizontal',
                    url: 'manager/queryFinPreOutRecPage?sourceBillId=${billId}',
                    criteria: '.form-horizontal',
                      dataBound: function(){
                        var data = this.dataSource.view();
                        $(data).each(function(idx, row){
                            var clazz = ''
                            if(row.status == 2){
                                clazz = 'row-color-blue';
                            }else if(row.status == 3){
                                clazz = 'row-color-pink';
                            }else if(row.status == 4){
                                clazz = 'row-color-red';
                            }
                            $('#grid tr[data-uid='+row.uid+']').addClass(clazz);
                        })
                    },
                    }">
                <div data-field="billNo" uglcw-options="width:170">回款单号</div>
                <div data-field="sourceBillNo" uglcw-options="width:170">预付单号</div>
                <div data-field="billTimeStr" uglcw-options="width:160">付款日期</div>
                <div data-field="proName" uglcw-options="width:160">往来单位</div>
                <div data-field="_operator"
                     uglcw-options="width:100, template: uglcw.util.template($('#formatterSt3').html())">操作
                </div>
                <div data-field="accName" uglcw-options="width:160">账户名称</div>
                <div data-field="sumAmt" uglcw-options="width:120">回款/核销金额</div>
                <div data-field="billType" uglcw-options="width:120,template: uglcw.util.template($('#formatterType').html())">类型</div>
                <div data-field="status"
                     uglcw-options="width:80,template:uglcw.util.template($('#formatterStatus').html())">状态
                </div>
                <div data-field="remarks" uglcw-options="width:120">备注</div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-kendo-template" id="formatterSt3">
    # if(data.status =='1' || data.status ==0){ #
    <button class="k-button k-error" onclick="cancelBill(#= data.id#, 1)"><i class="k-icon"></i>作废</button>
    # } #
</script>
<script type="text/x-kendo-template" id="formatterStatus">
    #if(data.status==0){#
    未审批
    #}else if(data.status==1){#
    已审批
    #}else if(data.status==2){#
    作废
    #}else if(data.status==3){#
    被冲红单
    #}else if(data.status==4){#
    冲红单
    #}#
</script>
<script type="text/x-kendo-template" id="formatterType">
    #if(data.billType==0){#
    回款
    #}else if(data.billType==1){#
    核销
    #}#
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();
        uglcw.ui.loaded()
    })
    function cancelBill(id) {
        uglcw.ui.confirm('您确认要作废吗？', function () {
            $.ajax({
                url: "manager/cancelOutBack",
                type: "post",
                data: "recId=" + id,
                success: function (json) {
                    if (json.state) {
                        uglcw.ui.success('操作成功');
                        uglcw.ui.get('#grid').reload();
                    } else {
                        uglcw.ui.error('操作失败' + json.msg);
                        return;
                    }
                }
            });
        });
    }
</script>
</body>
</html>
