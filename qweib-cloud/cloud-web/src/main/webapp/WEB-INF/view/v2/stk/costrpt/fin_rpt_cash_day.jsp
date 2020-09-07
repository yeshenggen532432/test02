<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>驰用T3</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }
        .uglcw-query .k-checkbox-label, .k-radio-label{
            padding-left: 20px;
        }
        .uglcw-query ul.uglcw-radio.horizontal li{
            margin-left: 5px;
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
                    <input uglcw-model="sdate" uglcw-role="datepicker" id="sdate" value="${sdate}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" id="edate" value="${edate}">
                </li>
                <li style="width: 380px!important;">
                    <ul id="typeId" uglcw-role="radio" uglcw-model="typeId"
                        uglcw-options='"layout":"horizontal",
									"dataSource":[{"text":"全部","value":""},
												 {"text":"现金","value":"0"},
 												 {"text":"微信","value":"1"},
												 {"text":"支付宝","value":"2"},
												 {"text":"银行卡","value":"3"},
												 {"text":"无卡账号","value":"4"}]'>
                    </ul>
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
                        response.rows.splice(response.rows.length - 1, 1);
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
                       q.accId = row.acc_id;
                       delete q['typeId']
                       uglcw.ui.openTab('账户明细', '${base}manager/toFinAccIo?'+ $.map(q, function(v, k){
                        return k+'='+(v||'');
                       }).join('&'));
                    },
                     responsive:['.header',40],
                    id:'id',
                    url: 'manager/finRptCashDay',
                    criteria: '.form-horizontal',
                     aggregate:[
                     {field: 'qcamt', aggregate: 'SUM'},
                     {field: 'inamt', aggregate: 'SUM'},
                     {field: 'outamt', aggregate:'SUM'},
                     {field: 'qmamt', aggregate: 'SUM'},
                    ],

                    }">

                <div data-field="acc_type"
                     uglcw-options="width:140, template: uglcw.util.template($('#formatterType').html()),">账号类型
                </div>
                <div data-field="acc_no"
                     uglcw-options="width:160,footerTemplate: '合  计'">账号
                </div>
                <div data-field="qcamt"
                     uglcw-options="width:120,format: '{0:n2}',footerTemplate: '#= uglcw.util.toString(data.qcamt,\'n2\')#'">
                    期初余额
                </div>
                <div data-field="inamt"
                     uglcw-options="width:120,format: '{0:n2}',footerTemplate: '#= uglcw.util.toString(data.inamt,\'n2\')#'">
                    本期增加
                </div>
                <div data-field="outamt"
                     uglcw-options="width:120,format: '{0:n2}',footerTemplate: '#= uglcw.util.toString(data.outamt,\'n2\')#'">
                    本期减少
                </div>
                <div data-field="qmamt"
                     uglcw-options="width:120, format: '{0:n2}',footerTemplate: '#= uglcw.util.toString(data.qmamt,\'n2\')#'">
                    期末余额
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/x-kendo-template" id="formatterType">
    #if(data.acc_type ==0){#
    现金
    #}#
    #if(data.acc_type ==1){#
    微信
    #}#
    #if(data.acc_type ==2){#
    支付宝
    #}#
    #if(data.acc_type ==3){#
    银行卡
    #}#
    #if(data.acc_type ==4){#
    无卡账号
    #}#
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();
        uglcw.ui.get('#search').on('click', function () {   //搜索（查询）
            uglcw.ui.get('#grid').reload();
        })

        uglcw.ui.get('#reset').on('click', function () {    //重置
            uglcw.ui.clear('.form-horizontal', {sdate: '${sdate}', edate: '${edate}'});
        })

        uglcw.ui.get('#typeId').on('change', function () {//即时刷新
            uglcw.ui.get('#grid').reload();
        })
        uglcw.ui.loaded()
    })


</script>
</body>
</html>
