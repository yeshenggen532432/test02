<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>企微宝</title>
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
		<script type="text/javascript" src="resource/md5.js"></script>
		<script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
	</head>
	<body>

		<div class="box">
  			    <dl id="dl">
	      			<dd>
	      				<span class="title">收款单号：</span>
	        			<input class="reg_input" name="billNo" readonly="readonly" id="cstName" value="${model.billNo}" style="width: 130px"/>
	        		</dd>
	        		<dd>
	      				<span class="title">发票单号：</span>
	        			<input class="reg_input" name="sourceBillNo" readonly="readonly" id="cstName" value="${model.sourceBillNo}" style="width: 130px"/>
	        			<a href="javascript:;;" onclick="showSourceBill(${model.billId})">查看</a>
	        		</dd>
	        		<dd>
	      				<span class="title">单据状态：</span>
	      				<c:if test="${model.status eq 0 }">正常单</c:if>
	      				<c:if test="${model.status eq 2 }"><span style="color:blue;text-decoration:line-through;font-weight:bold;">作废单</span></c:if>
	      				<c:if test="${model.status eq 3 }"><span style="color:#FF00FF;font-weight:bold;">被冲红单</span></c:if>
	      				<c:if test="${model.status eq 4 }"><span style="color:red;font-weight:bold;">冲红单</span></c:if>
	        		</dd>
	        		<dd>
	      				<span class="title">往来单位：</span>
	        			<input class="reg_input" name="cstName" readonly="readonly" id="cstName" value="${model.khNm}" style="width: 130px"/>
	        		</dd>
	        		<dd>
	      				<span class="title" >已收款：</span>
	      				<input class="reg_input" name="sumAmt" readonly="readonly" id="sumAmt" value="${model.sumAmt}" />
	        		</dd>
	        		<dd>
	        		<span class="title">收款时间：</span>
	        		<input name="sdate" class="reg_input" id="recTime"  onClick="WdatePicker({dateFmt: 'yyyy-MM-dd HH:mm'});" style="width: 120px;" value="${model.recTime}" readonly="readonly"/>
	        		</dd>
	        		<c:if test="${not empty model.preNo }">
	        		<dd>
	      				<span class="title">往来预收款单：</span>
	        			<input type="text" class="reg_input"  name="preNo" id="preNo" value="${model.preNo }"  readonly="readonly" />
	        			<a href="javascript:;;" onclick="showPreBill(${model.preId})">查看</a>
	        		</dd>
	        		<dd>
	        			<span class="title">抵扣款金额：</span>
	        			<input class="reg_input" name="preAmt" id="preAmt" readonly="readonly"  value="${model.preAmt}"  style="width: 80px"/>
	        		</dd>
	        		<dd>
	      				<span class="title">实际收款金额：</span>
	        			<input class="reg_input" name="retAmt" id="retAmt" readonly="readonly" value="${model.sumAmt-model.preAmt}" style="width: 120px"/>
	        		</dd>
	        		</c:if>
	        		<dd>
	      				<span class="title">备注：</span>
	        			<textarea rows="4" cols="50" name="remarks" id="remarks" >${model.remarks }</textarea>
	        		</dd>
	        	</dl>

		</div>
	</body>
	<script type="text/javascript">
	   function showSourceBill(sourceBillId){
			parent.closeWin('发票信息');
	    	parent.add('发票信息','manager/showstkout?dataTp=1&billId=' + sourceBillId);
	 }
	   function showPreBill(preId){
			parent.closeWin('往来预收信息');
	    	parent.add('往来预收信息','manager/showFinPreInEdit?billId=' + preId);
	 }
	</script>
</html>
