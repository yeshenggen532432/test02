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
            <a role="button" href="javascript:add(0);" class="primary k-button k-button-icontext">
                <span class="k-icon k-i-file-add"></span>销售退货开单
            </a>
            <a role="button" class="k-button k-button-icontext" href="javascript:invalid();">
                <span class="k-icon k-i-cancel"></span>作废
            </a>
            <a role="button" class="k-button k-button-icontext"
               href="javascript:historyOrders();">
                <span class="k-icon k-i-search"></span>历史退货
            </a>
        </div>
        <div class="layui-card-body full" style="padding-left: 5px;">
            <ul class="uglcw-query form-horizontal">
                <li>
                    <input type="hidden" uglcw-model="jz" value="1" uglcw-role="textbox">
                    <input type="hidden" uglcw-model="inType" value="销售退货" uglcw-role="textbox"/>
                    <input uglcw-model="khNm" uglcw-role="textbox" placeholder="客户名称">
                </li>
                <li>
                    <input uglcw-model="memberNm" uglcw-role="textbox" placeholder="业务员名称">
                </li>
                <li>
                    <input class="k-textbox" uglcw-role="textbox" uglcw-model="wareNm" placeholder="商品名称">
                </li>


                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                </li>
                <li>
                    <input type="checkbox" uglcw-role="checkbox" id="showProducts">
                    <label style="margin-top: 7px" class="k-checkbox-label" for="showProducts">显示商品</label>
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
                    checkbox: true,
                    url: '${base}manager/queryThOrderDatas',
                    criteria: '.form-horizontal',
                    pageable: true,
                    dblclick:function(row){
                        showDetail(row.id);
                    },
                    aggregate:[
                     {field: 'wareNum', aggregate: 'SUM'},
                     {field: 'wareZj', aggregate: 'SUM'},
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
                        	wareNum: 0,
                        	wareZj: 0
                        };
                        if (response.rows && response.rows.length > 0) {
                            aggregate = response.rows[response.rows.length - 1].list[0]
                        }
                        return aggregate;
                      }
                     }

                    ">
                <div data-field="orderNo" uglcw-options="
                          width:180,
                          locked: true,
                          footerTemplate: '合计'
                        ">退货单号
                </div>
                <div data-field="pszd" uglcw-options="width:100">配送指定</div>
                <div data-field="oddate"
                     uglcw-options="width:160, template: '#= data.oddate + \' \' + data.odtime #'">下单日期
                </div>
                <div data-field="shTime" uglcw-options="width:160">退货时间</div>
                <div data-field="khNm" uglcw-options="width:160, tooltip:true">客户名称</div>
                <div data-field="memberNm" uglcw-options="width:160">业务员</div>
                <div data-field="count" uglcw-options="width:700, hidden: true,
                         template: function(data){
                            return kendo.template($('#product-list').html())(data.list);
                         }
                        ">商品信息
                </div>
                <div data-field="zje" uglcw-options=" width:120, format: '{0:n2}', footerTemplate: '#= kendo.toString(data.wareZj, \'n2\')#',
                             ">
                    总金额
                </div>
                <div data-field="cjje" uglcw-options="width:120, format: '{0:n2}',">
                    退货金额
                </div>
                <div data-field="orderZt"
                     uglcw-options="width:120, template: uglcw.util.template($('#status-tp').html())">订单状态
                </div>
                <div data-field="remo" uglcw-options="width:200, tooltip: true">备注</div>
                <div data-field="shr" uglcw-options="width:120">收货人</div>
                <div data-field="tel" uglcw-options="width:120">电话</div>
                <div data-field="address" uglcw-options="width:160, tooltip: true">地址</div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:add(0);" class="k-button k-button-icontext">
        <span class="k-icon k-i-file-add"></span>销售退货开单
    </a>
    <a role="button" class="k-button k-button-icontext" href="javascript:invalid();">
        <span class="k-icon k-i-cancel"></span>作废
    </a>
    <a role="button" class="k-button k-button-icontext"
       href="javascript:historyOrders();">
        <span class="k-icon k-i-search"></span>历史退货
    </a>
</script>

<script id="modified" type="text/x-uglcw-template">
    # if(data.outType){ #
    <span>#= data.newTime ? '已修改' : '未修改' #</span>
    # } #
</script>

<script id="product-list" type="text/x-kendo-template">
    <table class="product-grid" style="border-bottom:1px \\#3343a4 solid;padding-left: 5px;">
        <tbody>
        <tr style="font-weight: bold;">
            <td style="width: 120px;">商品名称</td>
            <td style="width: 60px;">销售类型</td>
            <td style="width: 60px;">单位</td>
            <td style="width: 80px;">规格</td>
            <td style="width: 60px;">数量</td>
            <td style="width: 60px;">单价</td>
            <td style="width: 60px;">总价</td>
            <td style="width: 60px;">生产日期</td>
        </tr>
        #for (var i=0; i< data.length; i++) { #
        <tr>
            <td>#= data[i].wareNm #</td>
            <td>#= data[i].xsTp #</td>
            <td>#= data[i].wareDw #</td>
            <td>#= data[i].wareGg #</td>
            <td>#= data[i].wareNum #</td>
            <td>#= uglcw.util.toString(data[i].wareDj, 'n2') #</td>
            <td>#= uglcw.util.toString(data[i].wareZj, "n2") #</td>
            <td>#= data[i].productDate #</td>
        </tr>
        # }#
        </tbody>
    </table>
</script>
<script id="status-tp" type="text/x-uglcw-template">
    # if(data.orderZt == '未审核'){ #
    <button class="k-button k-info" onclick="audit(#=data.id#)">未审核</button>
    # } else { #
    <span>#=data.orderZt#</span>
    # } #
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
            uglcw.ui.clear('.form-horizontal', {sdate: '${sdate}', edate: '${edate}'});
        });


        uglcw.ui.loaded();
    });

    function add(orderId) {
        uglcw.ui.openTab('销售退货单', "${base}manager/pcxsthin")
    }

    function showDetail(id) {
        uglcw.ui.openTab('销售退货单[' + id + ']', "${base}manager/pcstkthin?orderId=" + id)
    }

    function invalid() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection && selection.length > 0) {
            var row = selection[0];
            if (row.orderZt === '未审核') {
                return uglcw.ui.error('该订单未审核，无法作废！');
            } else if (row.orderZt === '已作废') {
                return uglcw.ui.warning('该订单已作废！');
            }
            uglcw.ui.confirm('确定作废吗？', function () {
                uglcw.ui.loading();
                $.ajax({
                    url: '${base}manager/thorder/updateOrderZf',
                    data: {id: row.id},
                    type: 'post',
                    success: function (response) {
                        uglcw.ui.loaded();
                        if (response == 1) {
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

    function historyOrders() {
        uglcw.ui.openTab('历史退货', '${base}manager/queryStkXsThInPage')
    }

    function audit(id) {
        uglcw.ui.confirm('确定审核该单据吗？', function () {
            $.ajax({
                url: '${base}manager/updateOrderSh',
                type: 'post',
                data: {
                    id: id,
                    sh: '审核'
                },
                success: function (response) {
                    if (response === '1') {
                        uglcw.ui.success('审核成功！');
                        uglcw.ui.get('#grid').reload();
                    } else {
                        uglcw.ui.error('操作失败');
                    }
                }
            })
        })
    }


</script>
</body>
</html>
