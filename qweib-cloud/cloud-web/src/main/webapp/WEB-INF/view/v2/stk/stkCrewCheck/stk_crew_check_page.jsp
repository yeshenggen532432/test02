<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>库位纠正单</title>
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
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
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
                        <%--<option value="2">已作废</option>--%>
                    </select>
                </li>
                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                </li>
                <%--<li>--%>
                    <%--<input type="checkbox" uglcw-role="checkbox" id="showProducts">--%>
                    <%--<label style="margin-top: 10px;" class="k-checkbox-label" for="showProducts">显示商品</label>--%>
                <%--</li>--%>
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
                    toolbar: uglcw.util.template($('#toolbar').html()),
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
                       uglcw.ui.openTab('库位纠正信息'+row.id, '${base}manager/stkCrewCheck/show?billId='+ row.id+$.map( function(v, k){  //只带id
                        return k+'='+(v||'');
                       }).join('&'));
                     },
                    url: '${base}manager/stkCrewCheck/page',
                    criteria: '.uglcw-query',
                    pageable: true,
                    ">
                <div data-field="billNo" uglcw-options="
                          width:160
                        ">纠正单号
                </div>
                <div data-field="inDate" uglcw-options="width:140">纠正日期</div>
                <div data-field="status" uglcw-options="width:100,
                         template: uglcw.util.template($('#formatterStatus').html())">单据状态
                </div>
                <div data-field="stkName" uglcw-options="width:120">仓库</div>
                <div data-field="createName" uglcw-options="width:120">创建人</div>
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
<script type="text/x-uglcw-template" id="toolbar">
    <a role="button" href="javascript:add();" class="k-button k-button-icontext">
        <span class="k-icon k-i-track-changes-accept"></span>纠正开单
    </a>
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
        // uglcw.ui.get('#showProducts').on('change', function () {
        //     var checked = uglcw.ui.get('#showProducts').value();
        //     var grid = uglcw.ui.get('#grid');
        //     if (checked) {
        //         grid.showColumn('count')
        //     } else {
        //         grid.hideColumn('count');
        //     }
        // })

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
        uglcw.ui.openTab('库存纠正开单', '${base}manager/stkHouseWare/tolistcorrect?r=' + new Date().getTime());
    }
</script>
</body>
</html>
