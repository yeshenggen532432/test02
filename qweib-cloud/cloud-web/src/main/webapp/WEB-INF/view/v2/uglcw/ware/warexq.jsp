<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>驰用T3</title>
		<%@include file="/WEB-INF/page/include/source.jsp"%>
	</head>
	<body>
	
		<div class="box">
  			<form action="manager/operware" name="warefrm" id="warefrm" method="post">
  			    <dl id="dl">
	      			<dt class="f14 b">商品信息</dt>
	      			<dd>
	      				<span class="title">商品编号：</span>
	        			<input class="reg_input" name="wareCode" id="wareCode" value="${ware.wareCode}" style="width: 100px" readonly="readonly"/>
	        		</dd>
	      			<dd>
	      				<span class="title">商品名称：</span>
	        			<input class="reg_input" name="wareNm" id="wareNm" value="${ware.wareNm}" style="width: 240px" readonly="readonly"/>
	        		</dd>
	        		<dd>
	      				<span class="title">规格：</span>
	        			<input class="reg_input" name="wareGg" id="wareGg" value="${ware.wareGg}" style="width: 100px" readonly="readonly"/>
	        		</dd>
	        		<dd>
	      				<span class="title">包装单位：</span>
	        			<input class="reg_input" name="wareDw" id="wareDw" value="${ware.wareDw}" style="width: 100px" readonly="readonly"/>
	        		</dd>
	        		<dd>
	      				<span class="title">单价：</span>
	        			<input class="reg_input" name="wareDj" id="wareDj" value="${ware.wareDj}" style="width: 100px" readonly="readonly"/>
	        		</dd>
	        		<dd>
	      				<span class="title">运输费用：</span>
	        			<input class="reg_input" name="tranAmt" id="tranAmt" value="${ware.tranAmt}" style="width: 100px"/>
	        			<span id="wareDjTip" class="onshow"></span>
	        		</dd>
	        		<dd>
	      				<span class="title">提成费用：</span>
	        			<input class="reg_input" name="tcAmt" id="tcAmt" value="${ware.tcAmt}" style="width: 100px"/>
	        			<span id="wareDjTip" class="onshow"></span>
	        		</dd>
	        		<dd>
		      			<span class="title">是否常用：</span>
		        		<input type="radio" name="isCy" <c:if test="${ware.isCy==1}">checked</c:if> value="1"/>是
		        		<input type="radio" name="isCy" <c:if test="${ware.isCy==2}">checked</c:if> value="2"/>否
		        	</dd>
	        	</dl>
	  		</form>
		</div>
	    <script type="text/javascript">
		   
		</script>
	</body>
</html>
