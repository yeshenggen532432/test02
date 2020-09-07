<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
	<title>按资金类型统计收款情况-客户明细</title>
	<%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
	<div class="layui-card header">
		<div class="layui-card-body">
			<ul class="uglcw-query form-horizontal query" style="display: none">
				<li>
						<input uglcw-model="accType" uglcw-role="textbox"value="${accType}" >
					    <input type="hidden" uglcw-model="proId" uglcw-role="textbox"value="${proId}" >
					   <input type="hidden" uglcw-model="proName" uglcw-role="textbox"value="${proName}" >
						<input uglcw-model="sdate" uglcw-role="datepicker" placeholder="开始时间" value="${sdate}" id="sdate">
				</li>
				<li>
						<input uglcw-model="edate" uglcw-role="datepicker" value="${edate}" id="edate">
				</li>

				<li style="width: 300px;">
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
                       pageable: true,
                    url: '${base}manager/accTypeAmtCustomerStatPage',
                    criteria: '.query',
  					  dblclick:function(row){
                      showDetail(row);
                    },
                     loadFilter:{
                        data: function(resp){
                            var rows = resp.rows || [];
                            rows.splice(rows.length - 1, 1);
                            return rows;
                        },
                        aggregates: function(resp){
                            var agg = {sum_amt: 0};
                            if(resp.rows && resp.rows.length>0){
                                agg = uglcw.extend(agg, resp.rows[resp.rows.length - 1]);
                            }
                            return agg;
                        }
                    },
                    aggregate:[
                        {field: 'sum_amt', aggregate: 'SUM'},
                    ],

                    ">
				<div data-field="bill_no" uglcw-options="width:160">收款单号</div>
				<div data-field="source_bill_no" uglcw-options="width:170,
                        template: uglcw.util.template($('#formatterEvent').html())">销售单号
				</div>
				<div data-field="rec_time" uglcw-options="width:160">收款时间</div>
				<div data-field="sum_amt"
					 uglcw-options="width:140, footerTemplate: '#= uglcw.util.toString(data.sum_amt,\'n2\')#'">总收款/核销金额
				</div>
				<div data-field="cash"
					 uglcw-options="width:100, footerTemplate: '#= uglcw.util.toString(data.cash,\'n2\')#'">现金
				</div>
				<div data-field="bank"
					 uglcw-options="width:100, footerTemplate: '#= uglcw.util.toString(data.bank,\'n2\')#'">银行转账
				</div>
				<div data-field="wx"
					 uglcw-options="width:100, footerTemplate: '#= uglcw.util.toString(data.wx,\'n2\')#'">微信
				</div>
				<div data-field="zfb"
					 uglcw-options="width:100, footerTemplate: '#= uglcw.util.toString(data.zfb,\'n2\')#'">支付宝
				</div>
				<div data-field="pre_amt" uglcw-options="width:100">抵扣预收款</div>
				<div data-field="xsth_amt" uglcw-options="width:100">退货金额</div>
				<div data-field="status"
					 uglcw-options="width:80, template: uglcw.util.template($('#formatterStatus').html())">状态
				</div>
			</div>
		</div>
	</div>
</div>
<script type="text/x-kendo-template" id="formatterStatus">
	#if(data.status==0){#
	正常
	#}else if(data.status==2){#
	作废
	#}else if(data.status==3){#
	被冲红单
	#}else if(data.status==4){#
	冲红单
	#}#
</script>
<script type="text/x-kendo-template" id="formatterEvent">
	#if(data.billNo=='合计:'){#
	#}else{#
	<a style="color: blue" href="javascript:showSourceBill('#=data.bill_id#','#=data.source_bill_no#')">#=data.source_bill_no#</a>
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

	function showSourceBill(sourceBillId, sourceBillNo) {
		if (sourceBillNo.indexOf("CSH") != -1) {
		} else {
			uglcw.ui.openTab('发票信息' + sourceBillId, 'manager/showstkout?dataTp=1&billId=' + sourceBillId);
		}
	}

	function showDetail(row) {
		uglcw.ui.openTab('收货款单信息', '${base}manager/showStkpay?billId=' + row.id);
	}

</script>
</body>
</html>
