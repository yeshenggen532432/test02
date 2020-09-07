<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>销售客户毛利统计表</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <div class="form-horizontal">
                <div class="form-group" style="margin-bottom: 10px;">
                    <input type="hidden" uglcw-model="stkUnit" uglcw-role="textbox" value="${stkUnit}"/>
                    <input type="hidden" uglcw-model="outType" uglcw-role="textbox" value="${outType}"/>
                    <input type="hidden" uglcw-model="wtype" uglcw-role="textbox" value="${wtype}"/>
                    <input type="hidden" uglcw-model="regionId" uglcw-role="textbox" value="${regionId}"/>
                    <input type="hidden" uglcw-model="timeType" uglcw-role="textbox" value="${timeType}"/>
                    <div class="col-xs-4" style="display: none">
                        <input type="hidden" uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}">
                    </div>
                    <div class="col-xs-4" style="display: none">
                        <input type="hidden" uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                    </div>
                    <div class="col-xs-4">
                        <input uglcw-role="textbox" uglcw-model="itemName" placeholder="费用科目"/>
                    </div>
                    <div class="col-xs-6">
                        <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                        <button id="reset" class="k-button" uglcw-role="button">重置</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options="
                    responsive:['.header',40],
                    url: '${base}manager/cstSaleInputAmtList',
                    criteria: '.form-horizontal',
                    pageable: true,

                    dblclick: function(row){
                        var q = uglcw.ui.bind('.form-horizontal');
                        q.typeId = row.typeId;
                        q.typeName = row.typeName;
                       	delete q['itemName'];
                        if( q.typeId == undefined){
                        return;
                        }
                        uglcw.ui.openTab(typeName+'费用明细项统计', '${base}manager/toFinRptCostTotalItems?'+ $.map(q, function(v, k){
                            return k+'='+(v||'');
                        }).join('&'));
                    },
                    loadFilter: {
                      data: function (response) {
                        if(!response || !response.rows || response.rows.length <1){
                            return [];
                        }
                        response.rows.splice(response.rows.length - 1, 1);
                        return response.rows;
                      },

                      aggregates: function (response) {
                        var aggregate = {
                            amt:0
                        };
                        if (response.rows && response.rows.length > 0) {
                            aggregate = uglcw.extend(aggregate, response.rows[response.rows.length - 1]);
                        }
                        return aggregate;
                      }
                     },
                     aggregate:[
                     {field: 'amt', aggregate: 'SUM'}
                    ],

                    ">
                <div data-field="pro_name" uglcw-options="width: 150">往来单位</div>
                <div data-field="biz_type" uglcw-options="width:120,
						template: uglcw.util.template($('#amtformatterType').html())">业务类型
                </div>
                <div data-field="bill_no" uglcw-options="width:120">单据号</div>
                <div data-field="item_name" uglcw-options="width:120">费用科目</div>
                <div data-field="amt"
                     uglcw-options="width:120, format: '{0:n2}',footerTemplate: '#= uglcw.util.toString(data.amt || 0, \'n2\')#'">
                    金额
                </div>
            </div>
        </div>
    </div>
</div>
<script id="amtformatterType" type="text/x-uglcw-template">
    #if(data.biz_type=="FYBX"){#
    费用报销
    #}else if(data.biz_type=="FYFK"){#
    费用付款
    #}else if(data.biz_type=="SHHK"){#
    收货货款核销
    #}else{#
    ""
    #}#
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        uglcw.ui.init();

        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        })

        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal', {sdate: '${sdate}', edate: '${edate}'});
        })

        uglcw.ui.loaded()
    })

</script>
</body>
</html>
