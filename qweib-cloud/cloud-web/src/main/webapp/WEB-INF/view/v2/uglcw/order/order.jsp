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
            <ul class="uglcw-query query">
               <li>
                   <input type="hidden" uglcw-model="jz" value="1" uglcw-role="textbox">
                   <input uglcw-model="orderNo" uglcw-role="textbox" placeholder="订单号" uglcw-options="tooltip:'订单号'">
               </li>
                <li>
                    <input uglcw-model="khNm" uglcw-role="textbox" placeholder="客户名称" uglcw-options="tooltip:'客户名称'">
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="pszd" placeholder="配送指定" uglcw-options="value: '', tooltip: '配送指定'">
                        <option value="公司直送">公司直送</option>
                        <option value="转二批配送">转二批配送</option>
                    </select>
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="orderZt" placeholder="订单状态"
                            uglcw-options="tooltip: '订单状态',value:'${not empty param.orderZt ? param.orderZt: ''}'">
                        <option value="审核">审核</option>
                        <option value="未审核" ${orderZt eq '未审核'?'selected':''}>未审核</option>
                        <option value="已作废">已作废</option>
                    </select>
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="orderLb" placeholder="订单类别"
                            uglcw-options="value:'', tooltip: '订单类别'">
                        <option value="拜访单">拜访单</option>
                        <option value="电话单">电话单</option>
                        <option value="车销单">车销单</option>
                    </select>
                </li>
                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker" value="${not empty param.from ? param.sdate : sdate}" uglcw-options="tooltip:'开始时间'">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}" uglcw-options="tooltip:'结束时间'">
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="memberNm" placeholder="业务员名称" uglcw-options="tooltip: '业务员名称'">
                </li>
                <li>
                    <tag:select2 name="stkId" id="stkId" tableName="stk_storage"
                                 tooltip="仓库"
                                 whereBlock="status=1 or status is null"
                                 displayKey="id" displayValue="stk_name" placeholder="仓库"/>
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
                    checkbox: true,
                    toolbar: uglcw.util.template($('#toolbar').html()),
                     dblclick:function(row){
                       uglcw.ui.openTab('销售订单', '${base}manager/showorder?id='+ row.id+$.map( function(v, k){
                        return k+'='+(v||'');
                       }).join('&'));
                     },
                    responsive:['.header',40],
                    id:'id',
                    url: '${base}manager/bforderPage',
                    criteria: '.uglcw-query',
                    pageable: true,
                    ">
                <div data-field="orderNo" uglcw-options="width:160">订单号</div>
                <div data-field="orderZt"
                     uglcw-options="width:100, template: uglcw.util.template($('#formatterSt2').html())">订单状态
                </div>
                <div data-field="pszd" uglcw-options="width:120">配送指定</div>
                <div data-field="oddate" uglcw-options="width:120">下单日期</div>
                <div data-field="odtime" uglcw-options="width:120">时间</div>
                <div data-field="shTime" uglcw-options="width:120">送货时间</div>
                <div data-field="khNm" uglcw-options="width:120,tooltip: true">客户名称</div>
                <div data-field="memberNm" uglcw-options="width:120">业务员名称</div>
                <div data-field="count" uglcw-options="width:700,
                         template: function(data){
                            return uglcw.util.template($('#product-list').html())({data: data.list||[]});
                         }
                        ">商品信息
                </div>
                <div data-field="zje" uglcw-options="width:80">总金额</div>
                <div data-field="zdzk" uglcw-options="width:80">整单折扣</div>
                <div data-field="cjje" uglcw-options="width:80">成交金额</div>
                <div data-field="remo" uglcw-options="width:120">备注</div>
                <div data-field="shr" uglcw-options="width:120,tooltip:true">收货人</div>
                <div data-field="tel" uglcw-options="width:120">电话</div>
                <div data-field="address" uglcw-options="width:240,tooltip: true">地址</div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-kendo-template" id="formatterSt2">
    # if(data.orderZt=='未审核'){ #
    <button class="k-button k-info" onclick="updateOrderSh(#= data.id#)">未审核</button>
    #}else{#
    #= data.orderZt#
    #}#
</script>
<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:toZf();" class="k-button k-button-icontext">
        <span class="k-icon k-i-cancel"></span>作废
    </a>
    <a role="button" href="javascript:toDel();" class="k-button k-button-icontext">
        <span class="k-icon k-i-trash"></span>删除</a>

    <a role="button" class="k-button k-button-icontext"
       href="javascript:addorder();">
        <span class="k-icon k-i-plus"></span>新增

    </a>
    <a role="button" class="k-button k-button-icontext"
       href="javascript:toShow();">
        <span class="k-icon k-i-edit"></span>修改
    </a>
    <a role="button" href="javascript:toExport();"
       class="k-button k-button-icontext k-grid-add-other" style="display: none">
        <span class="k-icon k-i-redo"></span>导出
    </a>
    <a role="button" href="javascript:toPrint();"
       class="k-button k-button-icontext k-grid-add-other">
        <span class="k-icon k-i-print"></span>打印
    </a>
</script>

<script id="product-list" type="text/x-kendo-template">
    <table class="product-grid">
        <tbody>
        <tr style="font-weight: bold;">
            <td style="width: 20px;">商品名称</td>
            <td style="width: 10px;">销售类型</td>
            <td style="width: 10px;">单位</td>
            <td style="width: 10px;">规格</td>
            <td style="width: 10px;">数量</td>
            <td style="width: 10px;">单价</td>
            <td style="width: 10px;">总价</td>
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
        </tr>
        # }#
        </tbody>
    </table>
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<tag:exporter service="sysBforderService" method="queryBforderPage"
              bean="com.cnlife.uglcw.model.SysBforder"
              condition=".query" description="销售订单记录"

/>
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
                url: "manager/updateOrderSh",
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
                    url: '${base}/manager/deleteOrder',
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
                    url: '${base}/manager/updateOrderZf',
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

    function addorder() {//新增
        uglcw.ui.openTab('销售订单', '${base}manager/addorder');

    }

    function toShow() {//修改
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            var id = selection[0].id;
            uglcw.ui.openTab('销售订单', '${base}manager/showorder?id=' + id);
        } else {
            uglcw.ui.warning('请选择一条记录！');
        }


    }

    function toPrint() {//打印
        var selection = uglcw.ui.get('#grid').selectedRow();//选中当前行数据
        if (selection) {
            if (selection.length > 1) {
                return uglcw.ui.warning('只能选择一张单据！')
            }
            var ids = selection[0].id;
            if (ids) {
                uglcw.ui.openTab('订单打印', '${base}manager/showorderprint?billId=' + ids);

            }
        } else {
            uglcw.ui.warning('请选择要打印的数据');
        }


    }
</script>
</body>
</html>
