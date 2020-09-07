<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>借出回款明细</title>
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
                <li>
                    <input type="hidden" uglcw-model="sourceBillId" value="${sourceBillId}" uglcw-role="textbox">
                    <input type="hidden" uglcw-model="sourceBillNo" value="${sourceBillNo}" uglcw-role="textbox">
                </li>
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
                    url: 'manager/finOutReturnPage',
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

                <div data-field="billNo" uglcw-options="width:160">还款单号</div>
                <div data-field="billTimeStr" uglcw-options="width:140">单据日期</div>
                <div data-field="proName" uglcw-options="width:130">往来单位</div>
                <div data-field="accName" uglcw-options="width:140">账户名称</div>
                <div data-field="itemName" uglcw-options="width:140">核销科目</div>
                <div data-field="sumAmt" uglcw-options="width:100">回款金额</div>
                <div data-field="_operator"
                     uglcw-options="width:200, template: uglcw.util.template($('#formatterSt3').html())">操作
                </div>
                <div data-field="status"
                     uglcw-options="width:80, template: uglcw.util.template($('#formatterStatus').html())">状态
                </div>
                <div data-field="billType"
                     uglcw-options="width:80, template: uglcw.util.template($('#formatterType').html())">类型
                </div>
                <div data-field="count"
                     uglcw-options="width:200,template: function(data){
                            return kendo.template($('#formatterSt').html())(data.list);
                         }">科目信息
                </div>

                <div data-field="remarks" uglcw-options="width:120">备注</div>
            </div>
        </div>
    </div>
</div>
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
<script type="text/x-kendo-template" id="formatterSt3">
    # if(data.status =='1' || data.status ==0){ #
    <button class="k-button k-error" onclick="cancelBill(#= data.id#)"><i class="k-icon "></i>作废</button>
    # } #

</script>
<script id="formatterSt" type="text/x-kendo-template">
    <table class="product-grid">
        <tbody>
        <tr style="font-weight: bold;">
            <td style="width: 10px;">明细科目名称</td>
            <td style="width: 5px;">借出金额</td>
        </tr>
        #for (var i=0; i< data.length; i++) { #
        <tr>
            <td>#= data[i].itemName #</td>
            <td>#= data[i].amt #</td>
        </tr>
        # }#
        </tbody>
    </table>
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();
        // uglcw.ui.get('#search').on('click', function () {   //搜索（查询）
        //     uglcw.ui.get('#grid').k().dataSource.read();
        // })
        //
        // uglcw.ui.get('#reset').on('click', function () {    //重置
        //     uglcw.ui.clear('.form-horizontal');
        // })
        uglcw.ui.loaded()
    })

    function cancelBill(id) {

        uglcw.ui.confirm('是否确认作废该单据？', function () {
            uglcw.ui.loading();
            $.ajax({
                url: "${base}manager/cancelOutReturn",
                type: "post",
                data: {
                    billId: id
                },
                success: function (json) {
                    uglcw.ui.loaded();
                    if (json.state) {
                        uglcw.ui.success('操作成功');
                        uglcw.ui.get('#grid').reload();
                    } else {
                        uglcw.ui.error('操作失败：' + json.msg);
                    }
                },
                error: function () {
                    uglcw.ui.error('操作失败');
                    uglcw.ui.loaded();
                }
            });
        });
    }

</script>
</body>
</html>
