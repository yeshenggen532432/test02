<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>其它应付款科目台账</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }

        .row-color-blue {
            color: blue;
            text-decoration: line-through;
            font-weight: bold;
        }

        .row-color-pink {
            color: #FF00FF;
            font-weight: bold;
        }

        .row-color-red {
            color: red;
            font-weight: bold;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal" id="export">
                <li>
                    <input uglcw-role="textbox" uglcw-model="itemName" placeholder="明细科目名称">
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="proName" placeholder="往来单位">
                </li>
                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                </li>
                <li>
                    <select uglcw-model="showGroupType" id="showGroupType" uglcw-role="combobox"
                            uglcw-options="placeholder:'显示数据',value: '1'">
                        <option value="1">只显示科目分组</option>
                        <option value="2">展开单位明细</option>
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
						 pageable: true,
                         rowNumber: true,
                         criteria: '.form-horizontal',
                         loadFilter: {
                         data: function (response) {
                         response.rows.splice( response.rows.length - 1, 1);
                         return response.rows || []
                       },
                       aggregates: function (response) {
                         var aggregate = {};
                       if (response.rows && response.rows.length > 0) {
                            aggregate = response.rows[response.rows.length - 1]
                       }
                        return aggregate;
                       }
                     },
                     dblclick:function(row){
                       var q = uglcw.ui.bind('.form-horizontal');
                       q.itemName=row.itemName;
                       uglcw.ui.openTab(q.itemName+'_待还款单据', '${base}manager/toInGroupPayItemsPage?'+$.map(q, function(v, k){
                        return k+'='+(v||'');
                       }).join('&'));
                     },
                      responsive:['.header',40],
                    id:'id',
                    url: 'manager/queryInGroupItemNamePayPage',
                    mergeBy:'typeName,itemName',
                    criteria: '.form-horizontal',
                      aggregate:[
                     {field: 'payAmt', aggregate: 'SUM'},
                    ],
                    }">

                <div data-field="typeName"
                     uglcw-options="merge:true, width:160,footerTemplate: '合计'">科目名称
                </div>
                <div data-field="itemName" uglcw-options=" merge:true, width:160">明细科目名称</div>
                <div data-field="proName" uglcw-options="width:160,hidden:true">往来单位</div>
                <div data-field="restAmt"
                     uglcw-options="width:120,footerTemplate: '#= uglcw.util.toString(data.restAmt,\'n2\')#'">待付款金额
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
            grid.showColumn('proName');
        }else {
            grid.hideColumn('proName');
        }
    }


</script>
</body>
</html>
