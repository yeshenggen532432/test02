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
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query" id="derive">
                <li>
                    <input type="hidden" uglcw-model="jz" value="1" uglcw-role="textbox">
                    <input uglcw-model="orderNo" uglcw-role="textbox" placeholder="退货订单号">
                </li>
                <li>
                    <input uglcw-model="khNm" uglcw-role="textbox" placeholder="客户名称">
                </li>
                <li>
                    <input uglcw-model="memberNm" uglcw-role="textbox" placeholder="业务员名称">
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="pszd" placeholder="配送指定">
                        <option value="">全部</option>
                        <option value="公司直送">公司直送</option>
                        <option value="直供转单二批">直供转单二批</option>
                    </select>
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="orderZt" placeholder="订单状态"
                            uglcw-options="index:-1">
                        <option value="">全部</option>
                        <option value="审核">审核</option>
                        <option value="未审核">未审核</option>
                        <option value="已作废">已作废</option>
                    </select>
                </li>
                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
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
                    url: '${base}/manager/thorder/thorderPage?database=${database}&dataTp=${dataTp }',
                    criteria: '.uglcw-query',
                    pageable: true,
                    ">

                <div data-field="orderNo" uglcw-options="width:150">退货订单号</div>
                <div data-field="pszd" uglcw-options="width:100">配送指定</div>
                <div data-field="oddate" uglcw-options="width:120">下单日期</div>
                <div data-field="odtime" uglcw-options="width:120">时间</div>
                <div data-field="shTime" uglcw-options="width:120">退货时间</div>
                <div data-field="khNm" uglcw-options="width:120,tooltip: true">客户名称</div>
                <div data-field="memberNm" uglcw-options="width:120">业务员名称</div>
                <div data-field="count" uglcw-options="width:700,
                         template: function(data){
                            return kendo.template($('#product-list').html())(data.list);
                         }
                        ">商品信息
                </div>
                <div data-field="zje" uglcw-options="width:80">总金额</div>
                <div data-field="zdzk" uglcw-options="width:80">整单折扣</div>
                <div data-field="cjje" uglcw-options="width:80">退货金额</div>
                <div data-field="orderZt"
                     uglcw-options="width:100, template: uglcw.util.template($('#formatterSt2').html())">订单状态
                </div>
                <div data-field="remo" uglcw-options="width:200">备注</div>
                <div data-field="shr" uglcw-options="width:80">收货人</div>
                <div data-field="tel" uglcw-options="width:120">电话</div>
                <div data-field="address" uglcw-options="width:260,tooltip: true">地址</div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:toZf();" class="k-button k-button-icontext">
        <span class="k-icon k-i-cancel"></span>作废
    </a>
    <a role="button" href="javascript:toDel();" class="k-button k-button-icontext">
        <span class="k-icon k-i-trash"></span>删除</a>
</script>
<script type="text/x-kendo-template" id="formatterSt2">
    #if(data.list.length>0){#
    # if(data.orderZt=='未审核'){ #
    <button class="k-button k-error" onclick="updateOrderSh(#= data.id#)">未审核</button>
    #}else{#
    #= data.orderZt#
    #}#
    #}#
</script>
<script id="product-list" type="text/x-kendo-template">
    <table class="product-grid" style="padding-left: 5px;">
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
            <td>#= data[i].wareDj #</td>
            <td>#= data[i].wareZj #</td>
            <td>#= data[i].productDate #</td>
        </tr>
        # }#
        </tbody>
    </table>
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        uglcw.ui.init();
        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
            ;
        })
        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.uglcw-query');
        })

        uglcw.ui.loaded()
    })


    function updateOrderSh(id) {
        uglcw.ui.confirm('您确认要审核吗？', function () {
            $.ajax({
                url: "manager/thorder/updateOrderSh",
                type: "post",
                data: "id=" + id + "&sh=审核",
                success: function (data) {
                    if (data == "1") {
                        uglcw.ui.success('操作成功');
                        uglcw.ui.get('#grid').reload();
                    } else {
                        uglcw.ui.error('操作失败');
                        return;
                    }
                }
            });
        });
    }


    function toDel() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) { //判断是否为空
            if (selection[0].orderZt == '审核') {
                uglcw.ui.warning('该订单审核了，不能删除！');
                return;
            }
            uglcw.ui.confirm('您确认想要删除记录吗?', function () {
                $.ajax({
                    url: '${base}/manager/thorder/deleteOrder',
                    data: {
                        id: selection[0].id
                    },
                    type: 'post',
                    dataType: 'json',
                    success: function (json) {
                        if (json) {
                            if (json == '1') {
                                uglcw.ui.success('删除成功');//错误提示
                                uglcw.ui.get('#grid').reload();
                            }
                        } else if (json == -1) {
                            uglcw.ui.error('删除失败');
                        }
                    }
                })
            })
        } else {
            uglcw.ui.warning('请选择要删除的数据！');
        }

    }

    function toZf() {//作废
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) { //判断是否为空
            if (selection[0].orderZt == '未审核') {
                uglcw.ui.warning('该订单未审核了，不能作废！');
                return;
            }
            if (selection[0].orderZt == '已作废') {
                uglcw.ui.warning('该订单已作废，不能再作废！');
                return;
            }
            uglcw.ui.confirm('您确认想要作废该记录吗?', function () {
                $.ajax({
                    url: '${base}/manager/thorder/updateOrderZf',
                    data: {
                        id: selection[0].id
                    },
                    type: 'post',
                    dataType: 'json',
                    success: function (json) {
                        if (json) {
                            if (json == '1') {
                                uglcw.ui.success('作废成功');//错误提示
                                uglcw.ui.get('#grid').reload();
                            }
                        } else if (json == -1) {
                            uglcw.ui.error('作废失败');
                        }
                    }
                })
            })
        } else {
            uglcw.ui.warning('请选择要作废的数据！');
        }

    }

</script>
</body>
</html>
