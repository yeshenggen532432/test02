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
	<div class="layui-card">
		<div class="layui-card-body full">
			<div class="query" style="display: none;">
				<input type="hidden" uglcw-role="textbox" uglcw-model="ioType" value="${ioType}"/>
				<input type="hidden" uglcw-role="textbox" uglcw-model="amtType" value="${amtType}"/>
				<input type="hidden" uglcw-role="textbox" uglcw-model="titleName" value="${titleName}"/>
				<input type="hidden" uglcw-role="textbox" uglcw-model="sdate" value="${sdate}"/>
				<input type="hidden" uglcw-role="textbox" uglcw-model="edate" value="${edate}"/>
			</div>
			<div id="grid" uglcw-role="grid"
				 uglcw-options="
				     aggregate:[
                     {field: 'sumAmt', aggregate: 'SUM'}
                    ],
                    loadFilter:{
                    	data: function(response){
                    	 response.rows.splice(response.rows.length - 1, 1);
                         return response.rows || []
                    	},
                    	aggregates: function (response) {
                        var aggregate = {
                        	sumAmt: 0,
                        };
                        if (response.rows && response.rows.length > 0) {
                            aggregate = uglcw.extend(aggregate, response.rows[response.rows.length - 1]);
                        }
                        return aggregate;
                      }
                    },
                    dblclick: function(row){
                         var query = uglcw.ui.bind('.query');
                         query.unitId=row.unitId
                         uglcw.ui.openTab('客户收款明细', '${base}manager/toRecUnitDetail?' + $.map(query, function (v, k) {
                            return k + '=' + (v || '');
                        }).join('&'));
                    },
                    url: '${base}manager/queryRecUnitStat',
                    criteria: '.query'
                    ">
				<div data-field="unitName" uglcw-options="footerTemplate:'合计:'">往来单位</div>
				<div data-field="sumAmt" uglcw-options="format:'{0:n2}', footerTemplate: '#=uglcw.util.toString(data.sumAmt, \'n2\')#'">${titleName}</div>
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
