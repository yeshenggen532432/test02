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

        .row-color-blue {
            color: blue;
            font-weight: bold;
        }
    </style>
</head>
<body>
<tag:mask/>
<div class="layui-fluid page-list">
    <div class="layui-card header">
        <div class="layui-card-header actionbar btn-group">
            <c:if test="${permission:checkUserFieldPdm('stk.stkMove.open')}">
                <a role="button" href="javascript:add();" class="primary k-button k-button-icontext">
                    <span class="k-icon k-i-track-changes-accept"></span>移库开单
                </a>
            </c:if>
            <c:if test="${permission:checkUserFieldPdm('stk.stkMove.show')}">
                <a role="button" class="k-button k-button-icontext"
                   href="javascript:showDetail();">
                    <span class="k-icon k-i-preview"></span>查看
                </a>
            </c:if>
        </div>
        <div class="layui-card-body full" style="padding-left: 5px;">
            <ul class="uglcw-query">
                <li>
                    <input type="hidden" uglcw-model="jz" value="1" uglcw-role="textbox">
                    <input type="hidden" uglcw-model="billType" value="0" uglcw-role="textbox">
                    <input uglcw-model="billNo" uglcw-role="textbox" placeholder="单据号">
                </li>
                <li>
                    <select uglcw-model="status" uglcw-role="combobox" uglcw-options="placeholder:'单据状态'">
                        <option value="">--单据状态--</option>
                        <option value="-2">暂存</option>
                        <option value="1">已审批</option>
                        <option value="2">已作废</option>
                    </select>
                </li>
                <li>
                    <input class="k-textbox" uglcw-role="textbox" uglcw-model="wareNm" placeholder="商品名称">
                </li>
                <li>
                    <tag:select2 name="stkId" id="stkId" tableName="stk_storage" headerKey="" whereBlock="status is null or status=1"
                                 headerValue="" displayKey="id" displayValue="stk_name" placeholder="出库仓库"/>
                </li>
                <li>
                    <tag:select2 name="stkInId" id="stkInId" tableName="stk_storage" headerKey="" whereBlock="status is null or status=1"
                                 headerValue="" displayKey="id" displayValue="stk_name" placeholder="入库仓库"/>
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
                    responsive: ['.header', 20],
                    checkbox: true,
                    id:'id',
                        dataBound: function(){
                        var data = this.dataSource.view();
                        $(data).each(function(idx, row){
                            var clazz = ''
                            if(row.status == 2){
                                clazz = 'row-color-blue';
                            }
                            $('#grid tr[data-uid='+row.uid+']').addClass(clazz);
                        })
                    },
                     dblclick:function(row){
                       uglcw.ui.openTab('移库信息'+row.id, '${base}manager/stkMove/show?billId='+ row.id+$.map( function(v, k){  //只带id
                        return k+'='+(v||'');
                       }).join('&'));
                     },
                    url: '${base}manager/stkMove/page',
                    criteria: '.uglcw-query',
                    pageable: true,
                    ">
                <div data-field="billNo" uglcw-options="
                          width:160
                        ">单据单号
                </div>
                <div data-field="inDate" uglcw-options="width:140">单据日期</div>
                <div data-field="stkName" uglcw-options="width:130">出库仓库</div>
                <div data-field="stkInName" uglcw-options="width:130">入库仓库</div>
                <div data-field="status" uglcw-options="width:100,
                         template: uglcw.util.template($('#formatterStatus').html())">单据状态
                </div>
                <div data-field="operator" uglcw-options="width:120">创建人</div>
                <div data-field="count" uglcw-options="width:700, hidden: true,
                         template: function(data){
                            return kendo.template($('#product-list').html())(data.list);
                         }
                        ">商品信息
                </div>

                <div data-field="remarks" uglcw-options="width:200">备注</div>
            </div>
        </div>
    </div>

</div>
<script id="formatterStatus" type="text/x-uglcw-template">
    #if(data.status==0||data.status==-2){#
    暂存
    #}else if(data.status==1){#
    已审批
    #}else{#
    已作废
    #}#


</script>
<script id="product-list" type="text/x-uglcw-template">
    <table class="product-grid" style="border-bottom:1px \\#3343a4 solid;padding-left: 5px;">
        <tbody>
        <tr style="font-weight: bold;">
            <td style="width: 120px;">商品名称</td>
            <td style="width: 60px;">单位</td>
            <td style="width: 80px;">规格</td>
            <td style="width: 60px;">数量</td>
            <td style="width: 60px;">单价</td>
            <td style="width: 60px;">总价</td>
            <td style="width: 60px;">已收数量</td>
        </tr>
        #for (var i=0; i< data.length; i++) { #
        <tr>
            <td>#= data[i].wareNm #</td>
            <td>#= data[i].unitName #</td>
            <td>#= data[i].wareGg #</td>
            <td>#= data[i].qty #</td>
            <td>#= data[i].price #</td>
            <td>#= data[i].amt #</td>
            <td>#= data[i].inQty #</td>
        </tr>
        # }#
        </tbody>
    </table>
</script>
<script id="bill-no" type="text/x-uglcw-template">
    <a href="javascript:showDetail(#= data.id#);" style="color: \\#337ab7;font-size: 13px; font-weight: bold;">#=
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
        })

        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.uglcw-query');
        })

        uglcw.io.on('pcstkinreload', function () {
            uglcw.ui.get('#grid').reload();
        })
        uglcw.ui.loaded()
    })

    function add() {
        uglcw.ui.openTab('移库单', '${base}manager/stkMove/add');
    }

    function showDetail(id) {
        if (id) {
            uglcw.ui.openTab('移库单' + id, '${base}manager/stkMove/show?billId=' + id);
        } else {
            var selection = uglcw.ui.get('#grid').selectedRow();
            if (selection) {
                var id = selection[0].id;
                uglcw.ui.openTab('移库单' + id, '${base}manager/stkMove/show?billId=' + id);
            } else {
                uglcw.ui.warning('请选择单据');
            }
        }
    }
</script>
</body>
</html>
