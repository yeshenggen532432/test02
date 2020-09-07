<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>采购单查询列表</title>
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
            <ul class="uglcw-query">

                <li>
                    <input uglcw-model="sdate" id="sdate" uglcw-role="datepicker" value="${sdate}">
                    <input type="hidden" uglcw-model="timeType" id="timeType" value="2">
                </li>
                <li>
                    <input uglcw-model="edate" id="edate" uglcw-role="datepicker" value="${edate}">
                </li>


                <li>
                    <select uglcw-role="combobox" uglcw-model="inType" id="inType" placeholder="单据类型">
                        <option value="">--单据类型--</option>
                        <option value="采购入库">采购入库</option>
                        <option value="其它入库">其它入库</option>
                        <option value="采购退货">采购退货</option>
                    </select>
                </li>
                <li>
                    <input uglcw-model="proName" uglcw-role="textbox" placeholder="往来单位">
                </li>

                <li>
                    <input class="k-textbox" uglcw-role="textbox" id="wareNm" uglcw-model="wareNm" placeholder="商品名称">
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
                    autoBind: false,
                    responsive: ['.header', 40],
                    checkbox: true,
                    rowNumber: true,
                    id:'id',
                    url: '${base}manager/queryInPageStat',
                    criteria: '.uglcw-query',
                    pageable: true,
                     dblclick:function(row){
                        uglcw.ui.openTab('采购单统计详情', '${base}manager/in_page_stat/detail/page?beginDate=' + uglcw.ui.get('#sdate').value() +
                        '&endDate=' + uglcw.ui.get('#edate').value() + '&inType=' + uglcw.ui.get('#inType').value() +
                        '&wareName=' + uglcw.ui.get('#wareNm').value() +
                        '&proId=' + row.pro_id + '&proType=' + row.pro_type + '&proName=' + row.pro_name);
                     },
                    aggregate:[
                     {field: 'total_qty', aggregate: 'sum'}
                    ],
                    loadFilter: {
                      data: function (response) {
                        var rows = response.rows || [];
                        if(rows.length > 0){
                            rows.splice(rows.length - 1, 1);
                        }
                        return rows;
                      },
                      total: function (response) {
                        return response.total || 0;
                      },
                      aggregates: function (response) {
                        var aggregate = {total_qty: 0, dis_amt:0, total_in_qty:0,dis_amt1:0,pay_amt:0,free_amt:0,un_pay_amt:0};
                        if (response.rows && response.rows.length > 0) {
                            aggregate = uglcw.extend(aggregate, response.rows[response.rows.length - 1])
                        }
                        return aggregate;
                      }
                     }
                    ">
                <div data-field="pro_name" uglcw-options="
                          width:160,

                          footerTemplate: '合计'
                        ">往来单位
                </div>
                <div data-field="total_qty" uglcw-options="width:100, footerTemplate: '#= uglcw.util.toString(data.total_qty.sum != undefined ? data.total_qty.sum : data.total_qty,\'n2\')#'">单据数量
                </div>
                <div data-field="dis_amt" uglcw-options="width:100, footerTemplate: '#= uglcw.util.toString(data.dis_amt || 0, \'n2\')#'">单据金额
                </div>
                <div data-field="total_in_qty" uglcw-options="width:100, footerTemplate: '#= uglcw.util.toString( data.total_in_qty ||0,\'n2\')#'">收货数量
                </div>
                <div data-field="dis_amt1" uglcw-options="width:100, footerTemplate: '#= uglcw.util.toString( data.dis_amt1 || 0, \'n2\')#'">收货金额
                </div>


                <div data-field="count" uglcw-options="width:700, hidden: true,
                         template: function(data){
                            return kendo.template($('#product-list').html())(data.subList);
                         }
                        ">商品明细
                </div>
                <div data-field="pay_amt" uglcw-options="width:100, footerTemplate: '#=  uglcw.util.toString(data.pay_amt || 0, \'n2\')#'">
                    已付款
                </div>
                <div data-field="free_amt" uglcw-options="width:100, footerTemplate: '#=  uglcw.util.toString(data.free_amt || 0, \'n2\')#'">
                    核销金额
                </div>

                <div data-field="un_pay_amt" uglcw-options="width:100, footerTemplate: '#=  uglcw.util.toString(data.un_pay_amt || 0, \'n2\')#'">未付金额
                </div>

            </div>
        </div>
    </div>
</div>

<script id="product-list" type="text/x-kendo-template">
    <table class="product-grid">
        <tbody>
        <tr style="font-weight: bold;">
            <td style="width: 120px;">商品名称</td>
            <td style="width: 60px;">单位</td>
            <td style="width: 60px;">单价</td>
            <td style="width: 60px;">单据数量</td>

            <td style="width: 60px;">单据金额</td>
            <td style="width: 60px;">已收数量</td>
            <td style="width: 60px;">已收金额</td>
        </tr>
        #for (var i=0; i< data.length; i++) { #
        <tr>
            <td>#= data[i].ware_nm #</td>
            <td>#= data[i].unit_name #</td>
            <td>#= data[i].price #</td>
            <td>#= data[i].qty #</td>
            <td>#= data[i].amt #</td>
            <td>#= data[i].in_qty #</td>
            <td>#= data[i].in_amt #</td>
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
        uglcw.ui.get('[uglcw-model=inType]').value('');

        //显示商品
        uglcw.ui.get('#showProducts').on('change', function () {
            var checked = uglcw.ui.get('#showProducts').value();
            var grid = uglcw.ui.get('#grid');
            if (checked) {
                grid.showColumn('count')
            } else {
                grid.hideColumn('count');
            }
        })

        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
            ;
        })

        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.uglcw-query', {sdate: '${sdate}', edate: '${edate}'});
        })

        uglcw.ui.loaded()
    });

    function getSelection() {
        var rows = uglcw.ui.get("#grid").selectedRow();
        if (rows && rows.length > 0) {
            return rows;
        } else {
            uglcw.ui.warning('请先选择数据');
            return false;
        }
    }

    function invalid() {
        var selection = getSelection();
        if (selection) {
            if (selection[0].status != 0) {
                return uglcw.ui.error('单据[' + selection[0].billNo + ']不能作废');
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
        uglcw.ui.openTab('采购开单', '${base}manager/pcstkin');
    }

    function addOther() {
        uglcw.ui.openTab('其它入库开单', '${base}manager/pcotherstkin');
    }

    function addPurchaseReturn() {
        uglcw.ui.openTab('采购退货', '${base}manager/pcinthin');
    }

    function showDetail(id) {
        if (id) {
            uglcw.ui.openTab('采购订单' + id, '${base}manager/showstkin?dataTp=${dataTp}&billId=' + id);
        } else {
            var selection = uglcw.ui.get('#grid').selectedRow();
            if (selection) {
                var id = selection[0].id;
                uglcw.ui.openTab('采购订单' + id, '${base}manager/showstkin?dataTp=${dataTp}&billId=' + id);
            } else {
                uglcw.ui.warning('请选择单据');
            }
        }
    }

    function showProductInfo() {
        var selection = getSelection();
        if (selection) {
            uglcw.ui.openTab('购货商品信息', '${base}manager/inWareListForGs?billNo=' + $.map(selection, function (row) {
                return "'" + row.billNo + "'";
            }).join(','));
        }
    }
</script>
</body>
</html>
