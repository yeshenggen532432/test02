<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>待生成销售单——销售订单列表</title>
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
            <ul class="uglcw-query form-horizontal">
                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                </li>
                <li>
                    <input uglcw-model="orderNo" uglcw-role="textbox" placeholder="订单单号">
                </li>
                <li>
                    <input uglcw-model="khNm" uglcw-role="textbox" placeholder="客户名称">
                </li>
                <li>
                    <input uglcw-model="memberNm" uglcw-role="textbox" placeholder="业务员名称">
                </li>
                <li>
                    <tag:select2 name="stkId" id="stkId" tableName="stk_storage"
                                 index="-1"
                                 whereBlock="status=1 or status is null"
                                 displayKey="id" displayValue="stk_name" placeholder="仓库"/>
                </li>
                <li>
                    <select id="saleCar" uglcw-model="saleCar" uglcw-role="combobox" uglcw-options="placeholder:'仓库类型', value:''">
                        <option value="0">正常仓库</option>
                        <option value="1">车销仓库</option>
                        <option value="2">门店仓库</option>
                    </select>
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="remarks" placeholder="备注">
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="wareNm" placeholder="商品名称">
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
                    responsive:['.header',40],
                    toolbar: kendo.template($('#toolbar').html()),
                    id:'id',
                    checkbox: true,
                    url: '${base}manager/willOutPage?dataTp=${dataTp}',
                    criteria: '.form-horizontal',
                    pageable: true,
                    dblclick: function(row){
                        newOut(row.id);
                    },
                    aggregate:[
                     {field: 'zje', aggregate: 'SUM'},
                     {field: 'zdzk', aggregate: 'SUM'},
                     {field: 'cjje', aggregate: 'SUM'}
                    ],
                    loadFilter: {
                      data: function (response) {
                        if(response.rows && response.rows.length>0){
                            response.rows.splice(response.rows.length - 1, 1);
                        }
                        return response.rows || []
                      },
                      total: function (response) {
                        return response.total;
                      },
                      aggregates: function (response) {
                        var aggregate = {
                            totalAmt: 0,
                            discount: 0,
                            disAmt:0,
                            recAmt: 0,
                            freeAmt: 0
                        };
                        if (response.rows && response.rows.length > 0) {
                            aggregate = uglcw.extend(aggregate, response.rows[response.rows.length - 1]);
                        }
                        return aggregate;
                      }
                     }
                    ">
                <div data-field="orderNo" uglcw-options="width:170">订单单号</div>
                <div data-field="pszd" uglcw-options="width:90">配送指定</div>
                <div data-field="oddate" uglcw-options="width:120">下单日期</div>
                <div data-field="odtime" uglcw-options="width:90">时间</div>
                <div data-field="shTime" uglcw-options="width:120">送货时间</div>
                <div data-field="khNm" uglcw-options="width:180, tooltip: true">客户名称</div>
                <div data-field="memberNm" uglcw-options="width:100">业务员名称</div>
                <div data-field="count" uglcw-options="width:700, hidden: true,
                         template: function(data){
                            return kendo.template($('#product-list').html())(data.list);
                         }
                        ">商品信息
                </div>
                <div data-field="zje" uglcw-options="width:80">总金额</div>
                <div data-field="zdzk" uglcw-options="width:80">整单折扣</div>
                <div data-field="cjje" uglcw-options="width:80">成交金额</div>
                <div data-field="orderZt" uglcw-options="width:80">订单状态</div>
                <div data-field="remo" uglcw-options="width:80">备注</div>
                <div data-field="shr" uglcw-options="width:80">收货人</div>
                <div data-field="tel" uglcw-options="width:80">电话</div>
                <div data-field="address" uglcw-options="width:80">地址</div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-kendo-template" id="toolbar">
    <c:if test="${permission:checkUserButtonPdm('stk.stkOut.createxs')}">
        <a role="button" href="javascript:newOut(0);" class="k-button k-button-icontext">
            <span class="k-icon k-i-file-add"></span>销售开单
        </a>
    </c:if>
    <a role="button" class="k-button k-button-icontext" href="javascript:hisBill();">
        <span class="k-icon k-i-paste-plain-text"></span>历史单据</a>
    <a role="button" class="k-button k-button-icontext" href="javascript:toZf();">
        <span class="k-icon k-i-cancel"></span>作废
    </a>
    <a role="button" class="k-button k-button-icontext" href="javascript:toPrint();">
        <span class="k-icon k-i-print"></span>打印
    </a>
</script>
<script id="product-list" type="text/x-kendo-template">
    <table class="product-grid">
        <tbody>
        <tr style="font-weight: bold;">
            <td style="width: 120px;">商品名称</td>
            <td style="width: 60px;">单位</td>
            <td style="width: 80px;">规格</td>
            <td style="width: 80px;">销售类型</td>
            <td style="width: 60px;">数量</td>
            <td style="width: 60px;">单价</td>
            <td style="width: 60px;">总价</td>
        </tr>
        #for (var i=0; i< data.length; i++) { #
        <tr>
            <td>#= data[i].wareNm #</td>
            <td>#= data[i].wareDw #</td>
            <td>#= data[i].wareGg #</td>
            <td>#= data[i].xsTp #</td>
            <td>#= data[i].wareNum #</td>
            <td>#= data[i].wareDj #</td>
            <td>#= data[i].wareZj #</td>
        </tr>
        # }#
        </tbody>
    </table>
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
        })

        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        })

        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal', {sdate: '${sdate}', edate: '${edate}'});
        })

        uglcw.ui.loaded()
    })

    function newOut(orderId) {
        if (orderId == 0) {
            uglcw.ui.openTab('销售单', "${base}manager/pcstkout?orderId=" + orderId);
            return;
        }
        $.ajax({
            url: "manager/checkOrderIsUse",
            type: "post",
            data: "orderId=" + orderId,
            success: function (data) {
                if (!data.state) {
                    uglcw.ui.openTab('销售出库', "${base}manager/pcstkout?orderId=" + orderId)
                } else {
                    $.messager.alert('消息', '该订单已经生成过销售单!', 'info');
                    return;
                }
            }
        });
    }

    function hisBill() {
        uglcw.ui.openTab('历史单据', '${base}manager/queryStkOutHis');
    }

    //作废
    function toZf() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection.length > 1) {
            uglcw.ui.warning('只能选择一张单据');
            return;
        }
        if (selection.length == 0) {
            uglcw.ui.warning('请勾选行');
            return;
        }
        var orderId = 0;
        if (selection && selection.length > 0) {
            $.map(selection, function (row) {
                orderId = row.id;
            })
        }
        uglcw.ui.confirm('您确认想要作废该订单吗？', function () {
            $.ajax({
                url: "manager/updateOrderZf",
                data: "id=" + orderId,
                type: "post",
                success: function (json) {
                    if (json == 1) {
                        uglcw.ui.success('作废成功！');
                        uglcw.ui.get('#grid').reload();
                    } else if (json == -1) {
                        uglcw.ui.error('审核失败！');
                    }
                }
            });
        })
    }

    //打印
    function toPrint() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection.length > 1) {
            uglcw.ui.warning('只能选择一张单据');
            return;
        }
        if (selection.length == 0) {
            uglcw.ui.warning('请勾选行');
            return;
        }
        var orderId = 0;
        if (selection && selection.length > 0) {
            $.map(selection, function (row) {
                orderId = row.id;
            })
        }
        uglcw.ui.openTab('销货商品信息', '${base}manager/showorderprint?billId=' + orderId);
    }

</script>
</body>
</html>
