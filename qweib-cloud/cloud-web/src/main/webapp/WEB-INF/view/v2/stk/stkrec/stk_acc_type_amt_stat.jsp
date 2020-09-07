<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
	<title>按资金类型统计收款情况</title>
	<%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
	<div class="layui-card header">
		<div class="layui-card-body">
			<ul class="uglcw-query form-horizontal query">
				<li>
						<input uglcw-model="sdate" uglcw-role="datepicker" placeholder="开始时间" value="${sdate}" id="sdate">
				</li>
				<li>
						<input uglcw-model="edate" uglcw-role="datepicker" value="${edate}" id="edate">
				</li>
				<li>
						<button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
				</li>
			</ul>
		</div>
	</div>
	<div class="layui-card">
		<div class="layui-card-body full">
			<div id="grid" uglcw-role="grid"
				 uglcw-options="
                    id:'id',
                    url: '${base}manager/accTypeAmtStat',
                    criteria: '.query',
				    dblclick: function(row){
				    	  var q = uglcw.ui.bind('.uglcw-query');
				    	  q.accType = row.acc_type;
				    	  if(row.acc_type=='合计'){
				    	    return;
				    	  }
				    	  var text=getAccTypeText(row.acc_type);
				    	  uglcw.ui.openTab(text+'_收货款按客户统计', '${base}manager/toAccTypeAmtCustomerStat?' + $.map(q, function(v, k){
                            return k+'='+(v||'');
                        }).join('&'));
                     }
                    ">
				<div data-field="acc_type" uglcw-options="width:200,template:uglcw.util.template($('#accTypeTpl').html())">资金类型</div>
				<div data-field="sum_amt" uglcw-options="width:240">金额</div>
				<div data-field=""></div>
			</div>
		</div>
	</div>
</div>
<script id="accTypeTpl" type="text/x-uglcw-template">
	# if(data.acc_type==0){ #
	<span>现金</span>
	# }else if(data.acc_type==1){ #
	<span>微信</span>
	# }else if(data.acc_type==2){ #
	<span>支付宝</span>
	# }else if(data.acc_type==3){ #
	<span>银行卡</span>
	# }else if(data.acc_type==4){ #
	<span>无卡现金</span>
	# }else if(data.acc_type==6){ #
	<span>核销款</span>
	# }else if(data.acc_type==7){ #
	<span>预收抵扣款</span>
	# }else{ #
	<span>合计</span>
	#}#
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
	$(function () {
		uglcw.ui.init();
		uglcw.ui.get('#search').on('click', function () {
			uglcw.ui.get('#grid').reload();
		});
		uglcw.ui.loaded()
	});

	function getAccTypeText(accType) {
		var text = "";
		if(accType==0){
			text="现金";
			}else if(accType==1){
				text="微信";
			 }else if(accType==2){
				text="支付宝";
			 }else if(accType==3){
				text="银行卡";
			 }else if(accType==4){
				text="无卡现金";
			 }else if(accType==6){
				text="核销款";
			 }else if(accType==7){
				text="预收抵扣款";
			 }else{
				text="合计";
			}
		return text;
	}

</script>
</body>
</html>
