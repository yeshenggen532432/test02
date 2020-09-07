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
				<input uglcw-role="textbox" type="hidden" uglcw-model="ioType" value="${ioType}"/>
				<input uglcw-role="textbox" type="hidden" uglcw-model="amtType" value="${amtType}"/>
				<input uglcw-role="textbox" type="hidden" uglcw-model="titleName" value="${titleName}"/>
				<input uglcw-role="textbox" type="hidden" uglcw-model="sdate" value="${sdate}"/>
				<input uglcw-role="textbox" type="hidden" uglcw-model="edate" value="${edate}"/>
			</div>
			<div id="grid" uglcw-role="grid"
				 uglcw-options="
                    dblclick: function(row){
                    	 var q = uglcw.ui.bind('.query');
                    	 q.unitId = row.unitId;
                         uglcw.ui.openTab('供应商应付款明细', '${base}manager/toNeedPayUnitDetail?'+ $.map(q, function(v, k){
                         	return k+'='+ v;
                         }).join('&'));
                    },
                    url: '${base}manager/queryNeedPayUnitStat',
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
				<div data-field="unitName" uglcw-options="footerTemplate: '合计:'">往来单位</div>
				<div data-field="sumAmt" uglcw-options="footerTemplate: '#= uglcw.util.toString(data.sumAmt, \'n2\')#'">应付金额</div>

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
