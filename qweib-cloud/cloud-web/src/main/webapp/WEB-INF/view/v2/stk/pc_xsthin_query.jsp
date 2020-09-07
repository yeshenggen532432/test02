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
<div class="layui-fluid page-list">
    <div class="layui-card header">
        <div class="layui-card-header actionbar btn-group">
            <c:if test="${permission:checkUserButtonPdm('stk.stkThIn.createth')}">
                <a role="button" href="javascript:add(0);" class="primary k-button k-button-icontext">
                    <span class="k-icon k-i-file-add"></span>销售退货开单
                </a>
            </c:if>
            <c:if test="${permission:checkUserButtonPdm('stk.stkThIn.cancel')}">
                <a role="button" class="k-button k-button-icontext" href="javascript:invalid();">
                    <span class="k-icon k-i-cancel"></span>作废
                </a>
            </c:if>
            <a role="button" class="k-button k-button-icontext"
               href="javascript:pendingOrders();">
                <span class="k-icon k-i-search"></span>待处理退货订单
            </a>
        </div>
        <div class="layui-card-body full" style="padding-left: 5px;">
            <ul class="uglcw-query">
                <li>
                    <input uglcw-model="billNo" uglcw-role="textbox" placeholder="单号">
                </li>
                <li>
                    <input type="hidden" uglcw-model="jz" value="1" uglcw-role="textbox">
                    <input type="hidden" uglcw-model="inType" value="销售退货" uglcw-role="textbox"/>
                    <input uglcw-model="proName" uglcw-role="textbox" placeholder="往来单位">
                </li>
                <li>
                    <input uglcw-model="memberNm" uglcw-role="textbox" placeholder="业务员名称">
                </li>
                <li>
                    <input class="k-textbox" uglcw-role="textbox" uglcw-model="wareNm" placeholder="商品名称">
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="billStatus" placeholder="状态"
                            uglcw-options="value: ''"
                    >
                        <option selected value="暂存">暂存</option>
                        <option value="已收货">已收货</option>
                        <option value="未收货">未收货</option>
                        <option value="作废">作废</option>
                    </select>
                </li>
                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                </li>
                <li>
                    <input type="checkbox" uglcw-role="checkbox" id="showProducts">
                    <label style="margin-top: 10px;" class="k-checkbox-label" for="showProducts">显示商品</label>
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
                            responsive: ['.header', 40],
                            id:'id',
                            checkbox: true,
                            rowNumber: true,
                            url: '${base}manager/stkXsThInPage',
                            criteria: '.uglcw-query',
                            pageable: true,
                            dblclick:function(row){
                                showDetail(row.id);
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
                                    aggregate = uglcw.extend(aggregate,response.rows[response.rows.length - 1]);
                                }
                                return aggregate;
                              }
                             }
                    ">
                <div data-field="billNo" uglcw-options="
                          width:160,
                          template: function(dataItem){
                           return kendo.template($('#bill-no').html())(dataItem);
                          },
                          footerTemplate: '合计'
                        ">单号
                </div>
                <div data-field="inDate" uglcw-options="width:140">入库日期</div>
                <div data-field="inType" uglcw-options="width:100">入库类型</div>
                <div data-field="proName" uglcw-options="width:140">往来单位</div>
                <div data-field="empNm" uglcw-options="width:100">业务员</div>

                <div data-field="count" uglcw-options="width:700, hidden: true,
                         template: function(data){
                            return kendo.template($('#product-list').html())(data.list);
                         }
                        ">商品信息
                </div>
                <c:if test="${permission:checkUserFieldPdm('stk.stkSend.lookamt')}">
                    <div data-field="totalAmt" uglcw-options=" width:120,format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.totalAmt,\'n2\')#',
                             ">
                        合计金额
                    </div>
                    <div data-field="discount"
                         uglcw-options="width:120, format: '{0:n2}',footerTemplate: '#= uglcw.util.toString(data.discount,\'n2\')#'">
                        整单折扣
                    </div>
                    <div data-field="disAmt"
                         uglcw-options="width:120, format: '{0:n2}',footerTemplate: '#=uglcw.util.toString(data.disAmt,\'n2\') #'">
                        单据金额
                    </div>
                    <div data-field="payAmt"
                         uglcw-options="width:120,format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.payAmt,\'n2\')#'">
                        已付金额
                    </div>
                    <div data-field="freeAmt"
                         uglcw-options="width:120,format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.freeAmt,\'n2\')#'">
                        核销金额
                    </div>
                </c:if>
                <div data-field="billStatus" uglcw-options="width:70">单据状态</div>
                <div data-field="remarks" uglcw-options="width:200, tooltip: true">备注</div>
            </div>
        </div>
    </div>
</div>

<script id="modified" type="text/x-uglcw-template">
    # if(data.outType){ #
    <span>#= data.newTime ? '已修改' : '未修改' #</span>
    # } #
</script>

<script id="product-list" type="text/x-kendo-template">
    <table class="product-grid">
        <tbody>
        <tr style="font-weight: bold;">
            <td style="width: 120px;">商品名称</td>
            <td style="width: 60px;">单位</td>
            <td style="width: 80px;">规格</td>
            <td style="width: 60px;">数量</td>
            <td style="width: 60px;">单价</td>
            <td style="width: 60px;">总价</td>
            <td style="width: 60px;">已收数量</td>
            <td style="width: 60px;">未收数量</td>
        </tr>
        #for (var i=0; i< data.length; i++) { #
        <tr>
            <td>#= data[i].wareNm #</td>
            <td>#= data[i].unitName #</td>
            <td>#= data[i].wareGg #</td>
            <td>#= data[i].qty #</td>
            <td>#= data[i].price #</td>
            <td>#= uglcw.util.toString(data[i].amt, "n") #</td>
            <td>#= data[i].inQty #</td>
            <td>#= data[i].inQty1 #</td>
        </tr>
        # }#
        </tbody>
    </table>
</script>
<script id="bill-no" type="text/x-kendo-template">
    <a href="javascript:showDetail(#= data.id#);" style="color: \\#337ab7;font-size: 12px; font-weight: bold;">#=
        data.billNo#</a>
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        uglcw.ui.init();
        //显示商品
        uglcw.ui.get('#showProducts').on('change', function () {
            var checked = uglcw.ui.get('#showProducts').value();
            var grid = uglcw.ui.get('#grid');
            if (checked) {
                grid.showColumn('count');
            } else {
                grid.hideColumn('count');
            }
        });

        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        });

        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.uglcw-query', {sdate: '${sdate}', edate: '${edate}'});
        });
        uglcw.ui.loaded()
    });

    function add(orderId) {
        uglcw.ui.openTab('销售退货单', "${base}manager/pcxsthin?orderId=" + orderId)
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
        uglcw.ui.openTab('销售退货单[' + id + ']', "${base}manager/showstkin?dataTp=1&billId=" + id)
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


</script>
</body>
</html>
