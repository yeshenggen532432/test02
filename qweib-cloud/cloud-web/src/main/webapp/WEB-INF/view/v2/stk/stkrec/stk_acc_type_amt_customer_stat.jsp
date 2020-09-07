<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
	<title>按资金类型统计收款情况-客户</title>
	<%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
	<div class="layui-card header">
		<div class="layui-card-body">
			<ul class="uglcw-query form-horizontal query">
				<li>
						<input type="hidden" uglcw-model="accType" uglcw-role="textbox"value="${accType}" >
						<input uglcw-model="sdate" uglcw-role="datepicker" placeholder="开始时间" value="${sdate}" id="sdate">
				</li>
				<li>
						<input uglcw-model="edate" uglcw-role="datepicker" value="${edate}" id="edate">
				</li>
				<li >
						<button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
				</li>
			</ul>
		</div>
	</div>
	<div class="layui-card">
		<div class="layui-card-body full">
			<div id="grid" uglcw-role="grid"
				 uglcw-options="
                    url: '${base}manager/accTypeAmtCustomerStat',
                    criteria: '.query',
                     dblclick: function(row){
				    	  var q = uglcw.ui.bind('.uglcw-query');
				    	  q.accType = row.acc_type;
				    	  q.proId = row.pro_id;
				    	  q.proName = row.pro_name;
				    	  if(row.pro_name=='合计'){
				    	    return;
				    	  }
				    	  uglcw.ui.openTab(q.proName+'_回款明细', '${base}manager/toAccTypeAmtCustomerStatPage?' + $.map(q, function(v, k){
                            return k+'='+(v||'');
                        }).join('&'));
                     }
                    ">
				<div data-field="pro_name" uglcw-options="width:160">往来客户</div>
				<div data-field="sum_amt" uglcw-options="width:160">金额</div>
				<div data-field=""></div>
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
		});
		uglcw.ui.loaded()
	});
</script>
</body>
</html>
