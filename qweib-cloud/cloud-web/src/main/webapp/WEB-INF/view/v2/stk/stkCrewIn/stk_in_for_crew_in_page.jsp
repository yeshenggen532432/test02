<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>待生成库位入库的采购列表</title>
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
                    <input type="hidden" uglcw-model="jz" value="1" uglcw-role="textbox">
                    <input uglcw-model="billNo" uglcw-role="textbox" placeholder="发票单号">
                </li>
                <li>
                    <input uglcw-model="proName" uglcw-role="textbox" placeholder="供应商">
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
                    <input class="k-textbox" uglcw-role="textbox" uglcw-model="remarks" placeholder="备注">
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
                    checkbox: true,
                    rowNumber: true,
                    id:'id',
                    url: '${base}manager/queryPageForCrew',
                    criteria: '.uglcw-query',
                    pageable: true,
                     dblclick:function(row){
                        uglcw.ui.openTab('入库发票信息'+row.id,'${base}manager/showstkin?dataTp=1&billId='+row.id);
                     },

                    loadFilter: {
                      data: function (response) {
                        var rows = response.rows || [];

                        return rows;
                      }
                     }
                    ">
                <div data-field="billNo" uglcw-options="
                          width:160,
                          template: function(dataItem){
                           return kendo.template($('#bill-no').html())(dataItem);
                          }
                        ">单号
                </div>
                <div data-field="inDate" uglcw-options="width:140">单据日期</div>
                <div data-field="operator" uglcw-options="width:100">创建人</div>
                <div data-field="inType" uglcw-options="width:80">入库类型</div>
                <div data-field="proName" uglcw-options="width:130,tooltip: true">供应商</div>
                <div data-field="operation" uglcw-options="width:120, template: uglcw.util.template($('#opt-tpl').html())">操作
                </div>

                <%--<div data-field="op" uglcw-options="width:200,hidden:${(fns:checkFieldDisplay('sys_config','*','code=\'CONFIG_CGFP_OPEN_ZFJS\'  and status=1') eq '')?'false':'true'}, template: uglcw.util.template($('#opt-tpl').html())">操作</div>--%>
                <div data-field="count" uglcw-options="width:700, hidden: true,
                         template: function(data){
                            return kendo.template($('#product-list').html())(data.list);
                         }
                        ">商品信息
                </div>
                <%--<div data-field="totalAmt" uglcw-options="width:100, hidden:!${permission:checkUserFieldPdm('stk.stkIn.lookamt')}, footerTemplate: '#= data.totalAmt#'">--%>
                    <%--合计金额--%>
                <%--</div>--%>
                <%--<div data-field="discount" uglcw-options="width:100, hidden:!${permission:checkUserFieldPdm('stk.stkIn.lookamt')}, footerTemplate: '#= data.discount#'">--%>
                    <%--整单折扣--%>
                <%--</div>--%>
                <%--<div data-field="disAmt" uglcw-options="width:100, hidden:!${permission:checkUserFieldPdm('stk.stkIn.lookamt')}, footerTemplate: '#= data.disAmt#'">发票金额--%>
                <%--</div>--%>
                <%--<div data-field="payAmt" uglcw-options="width:100, hidden:!${permission:checkUserFieldPdm('stk.stkIn.lookamt')}, footerTemplate: '#= data.payAmt#'">已付金额--%>
                <%--</div>--%>
                <%--<div data-field="freeAmt" uglcw-options="width:100, hidden:!${permission:checkUserFieldPdm('stk.stkIn.lookamt')}, footerTemplate: '#= data.freeAmt#'">--%>
                    <%--核销金额--%>
                <%--</div>--%>
                <div data-field="billStatus" uglcw-options="width:100">状态</div>
                <div data-field="remarks" uglcw-options="width:150, tooltip:true">备注</div>
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
            <td style="width: 80px;">规格</td>
            <td style="width: 80px;">采购类型</td>
            <td style="width: 60px;display: ${permission:checkUserFieldDisplay('stk.stkIn.lookqty')}">数量</td>
            <td style="width: 60px;display: ${permission:checkUserFieldDisplay('stk.stkIn.lookprice')}">单价</td>
            <td style="width: 60px;display: ${permission:checkUserFieldDisplay('stk.stkIn.lookamt')}">总价</td>
            <td style="width: 60px;display: ${permission:checkUserFieldDisplay('stk.stkIn.lookqty')}">已收数量</td>
            <td style="width: 60px;display: ${permission:checkUserFieldDisplay('stk.stkIn.lookqty')}">未收数量</td>
        </tr>
        #for (var i=0; i< data.length; i++) { #
        <tr>
            <td>#= data[i].wareNm #</td>
            <td>#= data[i].unitName #</td>
            <td>#= data[i].wareGg #</td>
            <td>#= data[i].inTypeName #</td>
            <td style='display: ${permission:checkUserFieldDisplay('stk.stkIn.lookqty')}'>#= data[i].qty #</td>
            <td style='display: ${permission:checkUserFieldDisplay('stk.stkIn.lookprice')}'>#= data[i].price #</td>
            <td style='display: ${permission:checkUserFieldDisplay('stk.stkIn.lookamt')}'>#= data[i].amt #</td>
            <td style='display: ${permission:checkUserFieldDisplay('stk.stkIn.lookqty')}'>#= data[i].inQty #</td>
            <td style='display: ${permission:checkUserFieldDisplay('stk.stkIn.lookqty')}'>#= data[i].inQty1 #</td>
        </tr>
        # }#
        </tbody>
    </table>
</script>

<script id="opt-tpl" type="text/x-uglcw-template">
    #if(data.id && data.billStatus !== '作废'){#
    <button class="k-button k-info" onclick="add(#= data.id#)"><i
            class="k-icon k-i-success"></i>入仓
    </button>
    #}#
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

    function add(id) {
        uglcw.ui.openTab('商品入仓单', '${base}manager/stkCrewIn/add?sourceId='+id);
    }



    function showDetail(id) {
        if (id) {
            uglcw.ui.openTab('入库发票信息' + id, '${base}manager/showstkin?dataTp=${dataTp}&billId=' + id);
        } else {
            var selection = uglcw.ui.get('#grid').selectedRow();
            if (selection) {
                var id = selection[0].id;
                uglcw.ui.openTab('入库发票信息' + id, '${base}manager/showstkin?dataTp=${dataTp}&billId=' + id);
            } else {
                uglcw.ui.warning('请选择单据');
            }
        }
    }
</script>
</body>
</html>
