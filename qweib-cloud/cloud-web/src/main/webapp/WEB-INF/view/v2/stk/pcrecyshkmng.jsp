<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
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
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal query">
                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                </li>
                <li>
                    <input type="hidden" uglcw-model="jz" value="1" uglcw-role="textbox">
                    <input uglcw-model="orderNo" uglcw-role="textbox" placeholder="单据单号">
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="customerType" placeholder="渠道"
                            uglcw-options="
                                dataTextField: 'qdtpNm',
                                dataValueField: 'qdtpNm',
                                url: '${base}manager/queryarealist1',
                                loadFilter:{
                                    data: function(resp){
                                        return resp.list1 || [];
                                    }
                                }
                            "
                    ></select>
                </li>
                <li>
                    <input uglcw-model="khNm" value="${khNm}" uglcw-role="textbox" placeholder="往来单位">
                </li>

                <li>
                    <input uglcw-model="epCustomerName" value="${epCustomerName}" uglcw-role="textbox"
                           placeholder="所属二批">
                </li>
                <li>
                    <input class="k-textbox" uglcw-role="textbox" uglcw-model="wareNm" placeholder="商品名称">
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="outType" placeholder="单据类型">
                        <option value="销售出库">销售出库</option>
                        <option value="其它出库">其它出库</option>
                    </select>
                </li>
                <li style="display:none;">
                    <select uglcw-model="sendStatus" uglcw-role="combobox">
                        <option value="0">包含未发货</option>
                        <option value="1" selected="selected">已发货</option>
                    </select>
                    <select uglcw-model="isPay" uglcw-role="combobox" id="payStatus">
                        <option value="0">未收款</option>
                        <option value="-1">全部</option>
                        <option value="1">已收款</option>
                        <option value="2">作废</option>
                        <option value="需退款">需退款</option>
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
                 uglcw-options="
                    responsive:['.header',40],
                    id:'id',
                    url: '${base}manager/stkOutYshkPage',
                    criteria: '.query',
                    pageable: true,
                    dblclick: function(row){
                        uglcw.ui.openTab('收款记录', '${base}manager/queryRecPageByBillId?dataTp=1&billId='+row.id);
                    },
                    query: function(param){
                        if(param.isPay =='需退款'){
                            param.isPay == -1;
                            param.needRtn = 1;
                        }
                        return param;
                    },
                    aggregate:[
                     {field: 'totalAmt', aggregate: 'SUM'},
                     {field: 'discount', aggregate: 'SUM'},
                     {field: 'disAmt', aggregate: 'SUM'},
                     {field: 'payAmt', aggregate: 'SUM'},
                     {field: 'freeAmt', aggregate: 'SUM'}
                    ],
                    loadFilter: {
                      data: function (response) {
                        response.rows.splice(response.rows.length - 1, 1);
                        return response.rows || []
                      },
                      total: function (response) {
                        return response.total;
                      },
                      aggregates: function (response) {
                        var aggregate = {
                        	totalAmt: 0,
                        	discount: 0,
                        	disAmt: 0,
                        	payAmt:0,
                        	freeAmt:0
                        };
                        if (response.rows && response.rows.length > 0) {
                            aggregate = response.rows[response.rows.length - 1]
                        }
                        return aggregate;
                      }
                     }

                    ">
                <div data-field="billNo" uglcw-options="
                          width:180,
                          locked: true,
                          template: function(dataItem){
                           return kendo.template($('#bill-no').html())(dataItem);
                          },
                          footerTemplate: '合计'
                        ">单据单号
                </div>
                <div data-field="outDate" uglcw-options="width:180">单据日期</div>
                <div data-field="outType" uglcw-options="width:130">出库类型</div>
                <div data-field="khNm" uglcw-options="width:160">往来单位</div>
                <div data-field="disAmt" uglcw-options="width:120,footerTemplate: '#= data.disAmt#'">单据金额
                </div>
                <div data-field="recAmt" uglcw-options="width:120, footerTemplate: '#= data.recAmt#'">已收金额
                </div>
                <div data-field="disAmt1" uglcw-options="width:120, footerTemplate: '#= data.disAmt1#'">
                    已发货金额
                </div>
                <div data-field="needRec" uglcw-options="width:120, footerTemplate: '#= data.needRec#'">
                    未发货金额
                </div>
                <div data-field="freeAmt" uglcw-options="width:120, footerTemplate: '#= data.freeAmt#'">核销金额</div>
                <div data-field="billStatus" uglcw-options="width:120">发货状态</div>
                <div data-field="recStatus" uglcw-options="width:120">收款状态</div>
                <div data-field="epCustomerName" uglcw-options="width:160">所属二批</div>
                <div data-field="_operator" uglcw-options="width:120,
                        template: uglcw.util.template($('#formatterSt3').html())">操作
                </div>
            </div>
        </div>
    </div>
</div>

<script id="modified" type="text/x-uglcw-template">
    # if(data.outType){ #
    <span>#= data.newTime ? '已修改' : '未修改' #</span>
    # } #
</script>
<script id="formatterSt3" type="text/x-uglcw-template">
    #if(data.id==""||data.id==null||data.id==undefined){#
    #}else{#
    <button class="k-button k-info" onclick="showPayList(#= data.id#)">查看明细</button>
    #}#
</script>
<script id="bill-no" type="text/x-kendo-template">
    <a href="javascript:showDetail(#= data.id#);" style="color: \\#3343a4;font-size: 12px; font-weight: bold;">#=
        data.billNo#</a>
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        uglcw.ui.init();
        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        });

        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal');
        });

        uglcw.ui.loaded()
    });


    function add(orderId) {
        uglcw.ui.openTab('销售退货开单', "${base}manager/pcxsthin?orderId=" + orderId)
    }

    //销货商品信息
    function showProduct() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection && selection.length > 0) {
            var billNos = $.map(selection, function (row) {
                return row.billNo;
            })
            uglcw.ui.openTab('销货商品信息', '${base}manager/outWareListForGs?billNo=' + billNos);
        } else {
            uglcw.ui.warning('请勾选单据')
        }
    }

    function showDetail(id) {
        uglcw.ui.openTab('单据信息[' + id + ']', "${base}manager/showstkout?dataTp=1&billId=" + id)
    }

    function invalid() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection && selection.length > 0) {
            var row = selection[0];
            if (row.status !== 0) {
                return uglcw.ui.error('该订单无法作废！');
            }
            uglcw.ui.loading();
            uglcw.ui.confirm('确定作废吗？', function () {
                $.ajax({
                    url: '${base}manager/cancelProc',
                    data: {billId: row.id},
                    type: 'post',
                    dataType: 'json',
                    success: function (response) {
                        uglcw.ui.loaded();
                        if (response.state) {
                            uglcw.ui.success('作废成功');
                            uglcw.ui.get('#grid').reload();
                        } else {
                            uglcw.ui.error(response.msg || '作废失败');
                        }
                    },
                    error: function () {
                        uglcw.ui.loaded();
                        uglcw.ui.error('操作失败');
                    }
                })
            })
        } else {
            return uglcw.ui.warning('请选择要作废的单据');
        }
    }

    function pendingOrders() {
        uglcw.ui.openTab('销售退货订单列表', '${base}manager/queryPendThOrderPage')
    }

    function showPayList(billId) {
        uglcw.ui.openTab('收款记录' + billId, '${base}manager/queryRecPageByBillId?dataTp=1&billId=' + billId);
    }

</script>
</body>
</html>
