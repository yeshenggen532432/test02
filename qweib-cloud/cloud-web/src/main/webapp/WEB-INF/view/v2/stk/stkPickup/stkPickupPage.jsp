<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>生产领料</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .row-color-blue{
            color:blue!important;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal query">
                <li>
                    <input type="textbox" uglcw-role="textbox" uglcw-model="billNo" placeholder="订单编号"/>
                </li>
                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker" placeholder="开始时间" value="${sdate}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                </li>
                <li>
                    <select uglcw-model="status" placeholder="单据状态" uglcw-options="value: ''" uglcw-role="combobox" id="status">
                        <option value="-2">暂存</option>
                        <option value="1">已审批</option>
                        <option value="2">已作废</option>
                    </select>
                </li>
                <li style="width: 150px;">
                    <tag:select2 name="stkId" id="stkId" tableName="stk_storage"
                                 whereBlock="status=1 or status is null"
                                 headerKey="" headerValue="请选择仓库"
                                 displayKey="id" displayValue="stk_name"/>
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
                        responsive:['.header',40],
                        checkbox: true,
                        toolbar: uglcw.util.template($('#toolbar').html()),
                        id:'id',
                        dblclick: function(row){
                          showDetail(row.id);
                        },
                        url: '${base}manager/stkPickup/page',
                        criteria: '.query',
                        pageable: true
                    ">
                <div data-field="billNo" uglcw-options="width:200, template: uglcw.util.template($('#bill-no').html())">
                    单据单号
                </div>
                <div data-field="billName" uglcw-options="width:100">单据类型</div>
                <div data-field="inDate" uglcw-options="width:140">单据日期</div>
                <div data-field="stkName" uglcw-options="width:120">仓库</div>
                <div data-field="proName" uglcw-options="width:120">车间</div>
                <div data-field="count"
                     uglcw-options="width:450, hidden: true, template: uglcw.util.template($('#product-tpl').html()) ">商品信息
                </div>
                <div data-field="status" uglcw-options="width:120, template: uglcw.util.template($('#status-tpl').html())">
                    单据状态
                </div>
                <div data-field="operator" uglcw-options="width:120">创建人</div>
                <div data-field="remarks" uglcw-options="width:150, tooltip:true">备注</div>
            </div>
        </div>
    </div>

</div>
<script id="bill-no" type="text/x-uglcw-template">
    <a href="javascript:showDetail(#= data.id#);" <%--style="color: \\#3343a4;font-size: 12px; font-weight: bold;"--%>>#=
        data.billNo#</a>
</script>
<script id="product-tpl" type="text/x-uglcw-template">
    <table class="product-grid" style="border-bottom:1px \\#3343a4 solid;padding-left: 5px;">
        <tbody>
        <tr style="font-weight: bold;">
            <td style="width: 120px;">商品名称</td>
            <td style="width: 60px;">单位</td>
            <td style="width: 80px;">规格</td>
            <td style="width: 60px;">数量</td>
        </tr>
        #var list = data.subList#
        #for (var i=0; i< list.length; i++) { #
        <tr>
            <td>#= list[i].wareNm #</td>
            <td>#= list[i].unitName #</td>
            <td>#= list[i].wareGg #</td>
            <td>#= list[i].qty #</td>
        </tr>
        # }#
        </tbody>
    </table>
</script>

<script id="status-tpl" type="text/x-uglcw-template">
    #if(data.status == -2){#
    暂存
    #}else if (data.status == 1){#
    已审批
    #}else if(data.status == 2){#
    已作废
    #}#
</script>

<script type="text/x-uglcw-template" id="toolbar">
    <a role="button" class="k-button k-button-icontext"
       href="javascript:add();">
        <span class="k-icon k-i-file-add"></span>领料出库
    </a>
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
        })

        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal', {sdate: '${sdate}', edate: '${edate}'});
        })

        uglcw.ui.loaded()
    })


    function showDetail(id) {
        uglcw.ui.openTab('领料出库' + id, '${base}manager/stkPickup/show?billId=' + id)
    }

    function add() {
        uglcw.ui.openTab('领料出库', '${base}manager/stkPickup/add?bizType=LLCK');
    }
</script>
</body>
</html>
