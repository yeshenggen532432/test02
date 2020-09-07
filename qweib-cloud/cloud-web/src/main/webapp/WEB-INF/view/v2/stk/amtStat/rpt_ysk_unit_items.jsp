<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>付货款管理</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal query">
                <li>
                    <input type="hidden" uglcw-model="jz" value="1" uglcw-role="textbox">
                    <input type="hidden" uglcw-model="proType" value="${proType}" uglcw-role="textbox">
                    <input uglcw-model="khNm" uglcw-role="textbox" value="${khNm}" placeholder="往来单位" id="khNm">
                </li>
                <li style="display: none">
                    <select uglcw-model="timeType" id="timeType" uglcw-role="combobox">
                        <option value="2">销售时间</option>
                        <option value="1">发货时间</option>
                    </select>
                </li>
                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker" placeholder="开始时间" value="${sdate}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="orderNo" placeholder="单号">
                </li>
                <li style="display: none">

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
				    responsive:['.header',40],
                    id:'id',
                    dblclick: function(row){
                         if(row.outType === '应收往来单位初始化'){
                            return;
                         }
                         uglcw.ui.openTab('单据信息'+row.id, '${base}manager/showstkout?dataTp=1&billId='+row.id);
                    },
                    checkbox: true,
                    url: '${base}manager/stkOutPageForRec',
                    aggregate:[
                     {field: 'disAmt', aggregate: 'SUM'},
                     {field: 'disAmt1', aggregate: 'SUM'},
                     {field: 'needRec', aggregate: 'SUM'}
                    ],
                    loadFilter: {
                      data: function (response) {
                        var rows = response.rows || [];
                        rows.splice(rows.length - 1, 1);
                        return rows
                      },
                      total: function (response) {
                        return response.total;
                      },
                      aggregates: function (response) {
                        var aggregate = {
                        	disAmt: 0,
                        	disAmt1: 0,
                        	needRec:0
                        };
                        if (response.rows && response.rows.length > 0) {
                            aggregate = uglcw.extend(aggregate, response.rows[response.rows.length - 1]);
                        }
                        return aggregate;
                      }
                     },
                    criteria: '.query',
                    pageable: true,
                    ">
                <div data-field="billNo" uglcw-options="width:160,tooltip: true,
				 		template: uglcw.util.template($('#formatterEvent').html()),footerTemplate: '合计'">单号
                </div>
                <div data-field="khNm" uglcw-options="width:150, tooltip: true">往来单位</div>
                <div data-field="outDate" uglcw-options="width:130">单据日期</div>
                <div data-field="disAmt"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.disAmt,\'n2\')#'">
                    销售金额
                </div>
                <div data-field="disAmt1"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.disAmt1, \'n2\')#'">
                    发货金额
                </div>
                <div data-field="recAmt"
                     uglcw-options="width:120, format: '{0:n2}'">已收金额
                </div>
                <div data-field="freeAmt"
                     uglcw-options="width:120, format: '{0:n2}'">核销金额
                </div>
                <div data-field="needRec"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.needRec,\'n2\')#'">
                    未收金额
                </div>
                <div data-field="outType" uglcw-options="width:80">单据类型</div>
                <div data-field="stkName" uglcw-options="width:80">仓库</div>
                <div data-field="staff" uglcw-options="width:80">业务员</div>
                <div data-field="billStatus" uglcw-options="width:120">发货状态</div>
                <div data-field="recStatus" uglcw-options="width:120">收款状态</div>

            </div>
        </div>
    </div>
</div>
<script id="formatterEvent" type="text/x-uglcw-template">
    #if(data.outType=='应收往来单位初始化'){#
    #= data.billNo#
    #}else{#
    <a style="color:blue;" href="javascript:showSourceBill(#=data.id#)">#=data.billNo#</a>
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
            uglcw.ui.clear('.form-horizontal');
        })
        uglcw.ui.loaded()
    })
    function showSourceBill(sourceBillId) {
        uglcw.ui.openTab('销售单信息' + sourceBillId, '${base}manager/showstkout?dataTp=1&billId=' + sourceBillId);
    }
</script>
</body>
</html>
