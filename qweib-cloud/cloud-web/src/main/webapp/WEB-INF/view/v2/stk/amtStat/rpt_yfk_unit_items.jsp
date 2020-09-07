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
            <div class="form-horizontal query">
                <div class="form-group" style="margin-bottom: 0px;">
                    <div class="col-xs-4">
                        <input type="hidden" uglcw-model="jz" value="1" uglcw-role="textbox">
                        <input type="hidden" uglcw-model="proType" value="${proType}" uglcw-role="textbox">
                        <input uglcw-model="orderNo" uglcw-role="textbox" placeholder="采购单号">
                    </div>
                    <div class="col-xs-4">
                        <input uglcw-model="proName" value="${proName}" uglcw-role="textbox" placeholder="供应商名称">
                    </div>
                    <div class="col-xs-4">
                        <input uglcw-model="sdate" id="sdate" uglcw-role="datepicker" placeholder="开始时间" value="${sdate}">
                    </div>
                    <div class="col-xs-4">
                        <input uglcw-model="edate" id="edate" uglcw-role="datepicker" value="${edate}">
                    </div>
                    <div class="col-xs-4" style="display: none">
                        <select uglcw-role="combobox" uglcw-model="isPay" placeholder="付款状况">
                            <option value="0">未付款</option>
                            <option value="">全部</option>
                            <option value="1">已付款</option>
                            <option value="2">作废</option>
                        </select>
                    </div>
                    <div class="col-xs-4">
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
                    id:'id',
                    dblclick: function(row){
                         if(row.inType === '应付往来单位初始化'){
                            return;
                         }
                         uglcw.ui.openTab('待付款单据'+row.id, '${base}manager/showstkin?dataTp=1&billId='+row.id);
                    },
                    checkbox: true,
                    url: '${base}manager/stkInForPayPage',
                    aggregate:[
                     {field: 'disAmt', aggregate: 'SUM'},
                     {field: 'payAmt', aggregate: 'SUM'},
                     {field: 'freeAmt', aggregate: 'SUM'},
                     {field: 'needPay', aggregate: 'SUM'}
                    ],
                    loadFilter: {
                      data: function (response) {
                        response.rows.splice(response.rows.length - 1, 1);
                        return response.rows || []
                      },
                      total: function (response) {
                        return response.total;
                      },
                      aggregates: function (response) {
                        var aggregate = {
                        	disAmt: 0,
                        	payAmt: 0,
                        	freeAmt: 0,
                        	needPay:0
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
                <div data-field="billNo" uglcw-options="width:180,tooltip: true, footerTemplate: '合计'">单号</div>
                <div data-field="inDate" uglcw-options="width:150, format: '{0:n2}'">日期</div>
                <div data-field="proName" uglcw-options="width:120, format: '{0:n2}'">付款对象</div>
                <div data-field="disAmt" uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#=uglcw.util.toString(data.disAmt,\'n2\') #'">
                    金额
                </div>
                <div data-field="payAmt"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.payAmt,\'n2\')#'">已付款
                </div>
                <div data-field="freeAmt"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.freeAmt, \'n2\')#'">
                    核销金额
                </div>
                <div data-field="needPay"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#=uglcw.util.toString(data.needPay,\'n2\') #'">未付金额
                </div>
                <div data-field="inType" uglcw-options="width:120, format: '{0:n2}'">入库类型</div>
                <div data-field="billStatus" uglcw-options="width:120">收货状态</div>
                <div data-field="payStatus" uglcw-options="width:120">付款状态</div>

            </div>
        </div>
    </div>
</div>

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

    function showInfo() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (!selection || selection.length < 1) {
            return uglcw.ui.warning('请选择要查看的记录');
        }
        var valid = true;
        $(selection).each(function (i, row) {
            if (row.inType === '应付往来单位初始化') {
                valid = false;
                return false;
            }
        })
        if (!valid) {
            return;
        }
        uglcw.ui.openTab('采购入库' + selection[0].id, '${base}manager/showstkin?dataTp=1&billId=' + selection[0].id);
    }

</script>
</body>
</html>
