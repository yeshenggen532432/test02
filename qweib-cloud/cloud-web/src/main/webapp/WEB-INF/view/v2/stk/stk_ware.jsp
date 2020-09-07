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
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md12">
            <div class="layui-card header">
                <div class="layui-card-body">
                    <div class="form-horizontal">
                        <div class="form-group" style="margin-bottom: 10px;">
                            <div class="col-xs-4">
                                <input type="hidden" uglcw-model="jz" value="1" uglcw-role="textbox">
                                <input uglcw-model="billNo" uglcw-role="textbox" placeholder="单号">
                            </div>
                            <div class="col-xs-4">
                                <input uglcw-model="proName" uglcw-role="textbox" placeholder="供应商">
                            </div>
                            <div class="col-xs-4">
                                <input class="k-textbox" uglcw-role="textbox" uglcw-model="wareNm" placeholder="商品名称">
                            </div>
                            <div class="col-xs-4">
                                <select uglcw-role="combobox" uglcw-model="inType" placeholder="单据类型">
                                    <option value="采购入库">采购入库</option>
                                    <option value="其他入库">其他入库</option>
                                    <option value="采购退货">采购退货</option>
                                </select>
                            </div>
                            <div class="col-xs-4">
                                <select uglcw-role="combobox" uglcw-model="billStatus" placeholder="状态"
                                        uglcw-options="index:-1">
                                    <option value="暂存">暂存</option>
                                    <option value="已收货">已收货</option>
                                    <option value="未收货">未收货</option>
                                    <option value="作废">作废</option>
                                </select>
                            </div>
                            <div class="col-xs-4">
                                <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                                <button id="reset" class="k-button" uglcw-role="button">重置</button>
                            </div>
                        </div>
                        <div class="form-group" style="margin-bottom: 0px;">
                            <div class="col-xs-4">
                                <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}">
                            </div>
                            <div class="col-xs-4">
                                <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                            </div>
                            <div class="col-xs-4 col-xs-offset-4" style="margin-top: 10px;">
                                <input type="checkbox" uglcw-role="checkbox" id="showProducts">
                                <label class="k-checkbox-label" for="showProducts">显示商品</label>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="layui-card">
                <div class="layui-card-body full">
                    <div id="grid" uglcw-role="grid"
                         uglcw-options="
                    toolbar: kendo.template($('#toolbar').html()),
                    id:'id',
                    url: '${base}manager/stkInHisPage',
                    criteria: '.form-horizontal',
                    pageable: true,
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
                        var aggregate = {};
                        if (response.rows && response.rows.length > 0) {
                            aggregate = response.rows[response.rows.length - 1]
                        }
                        return aggregate;
                      }
                     }

                    ">
                        <div data-field="inDate" uglcw-options="
                        width:50, selectable: true, type: 'checkbox', locked: true,
                        headerAttributes: {'class': 'uglcw-grid-checkbox'}
                        "></div>
                        <div data-field="billNo" uglcw-options="
                          width:180,
                          locked: true,
                          template: function(dataItem){
                           return kendo.template($('#bill-no').html())(dataItem);
                          },
                          footerTemplate: '合计'
                        ">单号
                        </div>
                        <div data-field="inDate" uglcw-options="width:180">入库日期</div>
                        <div data-field="operator" uglcw-options="width:160">创建人</div>
                        <div data-field="inType" uglcw-options="width:160">入库类型</div>
                        <div data-field="billStatus" uglcw-options="width:160">状态</div>
                        <div data-field="proName" uglcw-options="width:200">供应商</div>
                        <div data-field="count" uglcw-options="width:700, hidden: true,
                         template: function(data){
                            return kendo.template($('#product-list').html())(data.list);
                         }
                        ">商品信息
                        </div>
                        <c:if test="${stkRight.amtFlag == 1}">
                            <div data-field="totalAmt" uglcw-options="width:120, footerTemplate: '#= data.totalAmt#'">
                                合计金额
                            </div>
                            <div data-field="discount" uglcw-options="width:120, footerTemplate: '#= data.discount#'">
                                整单折扣
                            </div>
                            <div data-field="disAmt" uglcw-options="width:120, footerTemplate: '#= data.disAmt#'">单据金额
                            </div>
                            <div data-field="payAmt" uglcw-options="width:120, footerTemplate: '#= data.payAmt#'">已付金额
                            </div>
                            <div data-field="freeAmt" uglcw-options="width:120, footerTemplate: '#= data.freeAmt#'">
                                核销金额
                            </div>
                        </c:if>
                        <div data-field="remarks" uglcw-options="width:200">备注</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:addPurchase();" class="k-button k-button-icontext">
        <span class="k-icon k-i-track-changes-accept"></span>采购开单
    </a>
    <a role="button" class="k-button k-button-icontext">
        <span class="k-icon k-i-add"></span>其他入库</a>
    <a role="button" class="k-button k-button-icontext">
        <span class="k-icon k-i-track-changes-reject"></span>采购退货
    </a>
    <a role="button" class="k-button k-button-icontext"
       href="javascript:showDetail();">
        <span class="k-icon k-i-preview"></span>查看
    </a>
    <a role="button" href="javascript:invalid();" class="k-button k-button-icontext k-grid-add-other">
        <span class="k-icon k-i-delete"></span>作废</a>
</script>

<script id="product-list" type="text/x-kendo-template">
    <table class="product-grid" style="border:2px \\#3343a4 dashed;padding-left: 5px;">
        <tbody>
        <tr style="font-weight: bold;">
            <td style="width: 120px;">商品名称</td>
            <td style="width: 60px;">单位</td>
            <td style="width: 80px;">规格</td>
            <td style="width: 80px;">采购类型</td>
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
            <td>#= data[i].inTypeName #</td>
            <td>#= data[i].qty #</td>
            <td>#= data[i].price #</td>
            <td>#= data[i].amt #</td>
            <td>#= data[i].inQty #</td>
            <td>#= data[i].inQty1 #</td>
        </tr>
        # }#
        </tbody>
    </table>
</script>
<script id="bill-no" type="text/x-kendo-template">
    <a href="javascript:showDetail(#= data.id#);" style="color: \\#337ab7;font-size: 13px; font-weight: bold;">#=
        data.billNo#</a>
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        uglcw.ui.init();
        uglcw.ui.get('[uglcw-model=billStatus]').value('');
        uglcw.ui.get('[uglcw-model=inType]').value('');

        //显示商品
        uglcw.ui.get('#showProducts').on('change', function () {
            var checked = uglcw.ui.get('#showProducts').value();
            var grid = uglcw.ui.get('#grid').k();
            var index = grid.options.columns.findIndex(function (column) {
                return column.field == 'count';
            })
            if (checked) {
                grid.showColumn(index)
            } else {
                grid.hideColumn(index);
            }
        })

        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').k().dataSource.read();
        })

        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal');
        })


        resize();
        $(window).resize(resize)
        uglcw.ui.loaded()
    })

    var delay;

    function resize() {
        if (delay) {
            clearTimeout(delay);
        }
        delay = setTimeout(function () {
            var grid = uglcw.ui.get('#grid').k();
            var padding = 15;
            var height = $(window).height() - padding - $('.header').height() - $('.k-grid-toolbar').height();
            grid.setOptions({
                height: height,
                autoBind: true
            })
        }, 200)
    }

    function getSelection() {
        var result = [], grid = $('#order-list').data('kendoGrid');
        var rows = grid.element.find('.k-grid-content tr.k-state-selected');
        if (rows.length > 0) {
            $(rows).each(function (idx, item) {
                result.push(grid.dataItem(item))
            })
            return result;
        } else {
            layer.msg('请先选择数据');
            return false;
        }
    }

    function invalid() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            var flag = true;
            $(selection).each(function (idx, item) {
                if (item.status != 0) {
                    uglcw.ui.error('订单[' + item.billNo + ']不能作废');
                    flag = false;
                }
            })
            if (!flag) {
                return;
            }
            uglcw.ui.confirm('确定作废所选订单吗', function () {
                $.ajax({
                    url: '${base}manager/cancelProc',
                    data: {
                        billId: selection[0].id
                    },
                    type: 'post',
                    dataType: 'json',
                    success: function (response) {
                        if (response.state) {
                            uglcw.ui.success(response.msg);
                            uglcw.ui.get('#grid').k().dataSource.read();
                        } else {
                            uglcw.ui.error(response.msg);
                        }
                    }
                })
            })
        }
    }

    function addPurchase() {
        top.layui.index.openTabsPage('${base}manager/pcstkin', '采购开单');
    }

    function showDetail(id) {
        if (id) {
            top.layui.index.openTabsPage('${base}manager/showstkin?dataTp=${dataTp}&billId=' + id, '采购订单' + id);
        } else {
            var selection = uglcw.ui.get('#grid').selectedRow();
            if (selection) {
                var id = selection[0].id;
                top.layui.index.openTabsPage('${base}manager/showstkin?dataTp=${dataTp}&billId=' + id, '采购订单' + id);
            } else {
                uglcw.ui.warning('请选择单据');
            }
        }
    }
</script>
</body>
</html>
