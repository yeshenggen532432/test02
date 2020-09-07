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
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal" id="export">
                <li>
                    <input type="hidden" uglcw-model="jz" value="1" uglcw-role="textbox">
                    <input type="hidden" uglcw-model="status" value="0" uglcw-role="textbox">
                    <input uglcw-role="textbox" uglcw-model="billNo" placeholder="付款单号">
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="costNo" placeholder="报销单号">
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="proName" placeholder="付款对象">
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="itemName" placeholder="明细科目名称">
                </li>
                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="remarks" placeholder="备注信息">
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
                        dblclick:function(row){
                       uglcw.ui.openTab('费用付款凭证'+row.id, '${base}manager/showFinPayEdit?billId='+ row.id+$.map( function(v, k){
                        return k+'='+(v||'');
                       }).join('&'));
                     },
                      responsive:['.header',40],
                    id:'id',
                    pageable: true,
                    rowNumber: true,
                    criteria: '.form-horizontal',
                    url: 'manager/queryFinPayPage?database=${database}',
                    criteria: '.form-horizontal',
                    }">
                <div data-field="billNo" uglcw-options="width:160">付款单号</div>
                <div data-field="costNo" uglcw-options="width:160">报销单号</div>
                <div data-field="payTimeStr" uglcw-options="width:140">付款日期</div>
                <div data-field="proName" uglcw-options="width:140">付款对象</div>
                <div data-field="payAmt" uglcw-options="width:100">付款金额</div>
                <div data-field="operator" uglcw-options="width:100">经办人</div>
                <div data-field="status"
                     uglcw-options="width:100, template: uglcw.util.template($('#formatterStatus').html())">状态
                </div>
                <div data-field="count"
                     uglcw-options="width:200,template: function(data){
                            return kendo.template($('#formatterSt').html())(data.list);
                         }">科目信息
                </div>
                <div data-field="_operator"
                     uglcw-options="width:180, template: uglcw.util.template($('#formatterSt3').html())">操作
                </div>

                <div data-field="remarks" uglcw-options="width:140">备注</div>
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
<script type="text/x-kendo-template" id="formatterSt3">
    # if(data.status ==1 || data.status ==0){ #
    <button class="k-button k-error" onclick="cancelBill(#= data.id#)"><i class="k-icon "></i>作废</button>
    # } #

    # if(data.status == 0){ #
    <button class="k-button k-info" onclick="auditBill(#= data.id#)"><i class="k-icon "></i>审核</button>
    # } #


</script>
<script id="formatterSt" type="text/x-kendo-template">
    <table class="product-grid">
        <tbody>
        <tr style="font-weight: bold;">
            <td style="width: 10px;">明细科目名称</td>
            <td style="width: 5px;">付款金额</td>
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

        uglcw.ui.get('#search').on('click', function () {   //搜索（查询）
            uglcw.ui.get('#grid').k().dataSource.read();
        })

        uglcw.ui.get('#reset').on('click', function () {    //重置
            uglcw.ui.clear('.form-horizontal');
        })
        uglcw.ui.loaded()
    })


    function cancelBill(id) {
        uglcw.ui.confirm('您确认要作废吗？', function () {
            $.ajax({
                url: "manager/cancelFinPay",
                type: "post",
                data: "billId=" + id,
                success: function (json) {
                    if (json.state) {
                        uglcw.ui.success('操作成功');
                        uglcw.ui.get('#grid').reload();
                    } else {
                        uglcw.ui.error('操作成功' + json.msg);
                        return;
                    }
                }
            });
        });
    }

    function auditBill(id) {
        uglcw.ui.confirm('您确认要审核吗？', function () {
            $.ajax({
                url: "manager/updatePayAudit",
                type: "post",
                data: "billId=" + id,
                success: function (json) {
                    if (json.state) {
                        uglcw.ui.success('操作成功');
                        uglcw.ui.get('#grid').reload();
                    } else {
                        uglcw.ui.error('操作成功' + json.msg);
                        return;
                    }
                }
            });
        });
    }

    function finPay() {//付款
        top.layui.index.openTabsPage('${base}manager/toFinPayEdit?costBillId=' + id, '付款凭证');
    }

    function newBill() {
        top.layui.index.openTabsPage('${base}manager/toFinPayEdit?costBillId=0', '费用报销付款开单');

    }
</script>
</body>
</html>
