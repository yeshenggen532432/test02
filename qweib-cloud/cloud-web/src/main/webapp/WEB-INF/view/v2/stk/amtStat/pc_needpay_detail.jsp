<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
	<title>付款统计</title>
	<%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
	<div class="layui-card">
		<div class="layui-card-body full">
			<div class="query">
				<input type="hidden" uglcw-role="textbox" uglcw-model="sdate" value="${sdate}"/>
				<input type="hidden" uglcw-role="textbox" uglcw-model="edate" value="${edate}"/>
				<input type="hidden" uglcw-role="textbox" uglcw-model="inType" value="${ioType}"/>
				<input type="hidden" uglcw-role="textbox" uglcw-model="unitId" value="${unitId}"/>
			</div>
			<div id="grid" uglcw-role="grid"
				 uglcw-options="
                    dblclick: function(row){
                         uglcw.ui.openTab('销售开票信息'+row.id, '${base}manager//showstkin?dataTp=1&billId='+row.id);
                    },
                    url: '${base}manager/stkInPage1',
                    criteria: '.query',
                    aggregate:[
                       {field: 'sumAmt', aggregate: 'SUM'}
                    ],
                    loadFilter:{
                    	data: function (response) {
                    	if(response.rows && response.rows.length > 0){
                        	response.rows.splice(response.rows.length - 1, 1);
                        }
                        return response.rows || []
                      },
                      aggregates: function (response) {
                        var aggregate = {
                        	sumAmt: 0
                        };
                        if (response.rows && response.rows.length > 0) {
                            aggregate = uglcw.extend(aggregate, response.rows[response.rows.length - 1]);
                        }
                        return aggregate;
                      }
                    }
                    ">
				<div data-field="billNo" uglcw-options="footerTemplate: '合计:'">采购单号</div>
				<div data-field="inDate">采购日期</div>
				<div data-field="inType">入库类型</div>
				<div data-field="proName">付款对象</div>
				<c:if test="${stkRight.amtFlag == 1}">
					<div data-field="disAmt" uglcw-options="format:'{0:n2}'">单据金额</div>
					<div data-field="payAmt" uglcw-options="format:'{0:n2}'">已付款</div>
					<div data-field="freeAmt" uglcw-options="format:'{0:n2}'">核销金额</div>
					<div data-field="needPay" uglcw-options="format:'{0:n2}', footerTemplate: '#= uglcw.util.toString(data.needPay, \'n2\')#'">未付金额</div>
				</c:if>
				<div data-field="billStatus">收货状态</div>
				<div data-field="payStatus">付款状态</div>
			</div>
		</div>
	</div>
</div>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

	$(function () {
		uglcw.ui.init();
		uglcw.ui.loaded()
	});
</script>
</body>
</html>
