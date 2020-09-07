<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
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
                    <ul class="uglcw-query form-horizontal" id="export">
                        <li>
                            <input type="hidden" uglcw-model="jz" value="1" uglcw-role="textbox">
                            <input type="hidden" uglcw-model="isNeedPay" value="0" uglcw-role="textbox">
                            <input uglcw-role="textbox" uglcw-model="proName" placeholder="往来单位">
                        </li>
                        <li>
                            <input uglcw-role="textbox" uglcw-model="itemName" placeholder="明细科目名称">
                        </li>
                        <li>
                            <input uglcw-model="sdate" uglcw-role="datepicker">
                        </li>
                        <li>
                            <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                        </li>
                        <li>
                            <select uglcw-model="showGroupType" id="showGroupType" uglcw-role="combobox"
                                    uglcw-options="placeholder:'显示数据',value: '1'">
                                <option value="1">只显示单位分组</option>
                                <option value="2">展开科目明细</option>
                            </select>
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
                         uglcw-options="{
					loadFilter: {
                      data: function (response) {
                        response.rows.splice(0, 1);
                        return response.rows || []
                      },
                      aggregates: function (response) {
                        var aggregate = {};
                        if (response.rows && response.rows.length > 0) {
                            aggregate = response.rows[0]
                        }
                        return aggregate;
                      }
                     },
                      dblclick:function(row){
                       var q = uglcw.ui.bind('.form-horizontal');
                       q.proId = row.proId;
                       q.proName = row.proName;
                       uglcw.ui.openTab('应还款统计明细'+q.proId, '${base}manager/toFinInTotalItem?'+ $.map(q, function(v, k){
                        return k+'='+(v||'');
                       }).join('&'));
                     },
                     responsive:['.header',40],
                    id:'id',
                    mergeBy:'proName',
                    url: 'manager/queryFinInTotal',
                    criteria: '.form-horizontal',
                     aggregate:[
                     {field: 'needPay', aggregate: 'SUM'}
                    ],

                    }">

                        <div data-field="proName" uglcw-options="merge:true, width:200,footerTemplate: '合  计'">往来单位</div>
                        <div data-field="itemName" uglcw-options="width:200,hidden:true">明细科目</div>
                        <div data-field="needPay"
                             uglcw-options="width:200, format: '{0:n2}',footerTemplate: '#= uglcw.util.toString(data.needPay,\'n2\')#'">
                            应还款金额
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>


<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();
        //显示分组
        uglcw.ui.get('#showGroupType').on('change', function () {
            uglcw.ui.get('#grid').reload();
            filterField();
        });
        uglcw.ui.get('#search').on('click', function () {   //搜索（查询）
            uglcw.ui.get('#grid').k().dataSource.read();
        })

        uglcw.ui.get('#reset').on('click', function () {    //重置
            uglcw.ui.clear('.form-horizontal');
        })
        filterField();
        uglcw.ui.loaded()
    })
    function filterField(){
        var grid = uglcw.ui.get('#grid');
        var showGroupType = uglcw.ui.get("#showGroupType").value();
        if(showGroupType==2){
            grid.showColumn('itemName');
        }else {
            grid.hideColumn('itemName');
        }
    }


</script>
</body>
</html>
