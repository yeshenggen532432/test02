<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>驰用T3</title>
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
                    <input uglcw-role="textbox" uglcw-model="proName" placeholder="付款对象">
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
                       q.proName=row.proName;
                       uglcw.ui.openTab(q.proName+'_报销单据', '${base}manager/toCostGroupPayItemsPage?'+$.map(q, function(v, k){
                        return k+'='+(v||'');
                       }).join('&'));
                     },
                    responsive:['.header',40],
                    id:'id',
                    url: 'manager/queryCostGroupProNamePayPage',
                    criteria: '.form-horizontal',
                      aggregate:[
                     {field: 'payAmt', aggregate: 'SUM'},
                    ],
                    }">

                <div data-field="proName"
                     uglcw-options="width:160,footerTemplate: '合计'">报销对象
                </div>
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

        uglcw.ui.get('#search').on('click', function () {   //搜索（查询）
            uglcw.ui.get('#grid').k().dataSource.read();
        })

        uglcw.ui.get('#reset').on('click', function () {    //重置
            uglcw.ui.clear('.form-horizontal');
        })
        uglcw.ui.loaded()
    })

</script>
</body>
</html>
