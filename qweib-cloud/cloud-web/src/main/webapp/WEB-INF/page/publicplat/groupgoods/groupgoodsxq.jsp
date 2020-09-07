<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>企微宝</title>
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
	</head>
	<body>
	
		<div class="box">
  			<form name="groupgoodsfrm" id="groupgoodsfrm" method="post">
  			   <dl id="dl">
	      			<dt class="f14 b">商品信息</dt>
	      			<dd>
	      				<span class="title">商品图片：</span>
	        			<img id="photoImg" alt="" style="width: 210px;height: 220px;" src="upload/groupgoods/${groupgoods.pic}"/>
	     			</dd>
	      			<dd>
	      				<span class="title">商品名称：</span>
	        			<input class="reg_input" name="gname" id="gname" value="${groupgoods.gname}" style="width: 240px" readonly="readonly"/>
	        		</dd>
	        		<dd>
	      				<span class="title">原价：</span>
	        			<input class="reg_input" name="yprice" id="yprice" value="${groupgoods.yprice}" style="width: 100px" readonly="readonly"/>
	        		</dd>
	        		<dd>
	      				<span class="title">现价：</span>
	        			<input class="reg_input" name="xprice" id="xprice" value="${groupgoods.xprice}" style="width: 100px" readonly="readonly"/>
	        		</dd>
	        		<dd>
	      				<span class="title">库存：</span>
	        			<input class="reg_input" name="stock" id="stock" value="${groupgoods.stock}" style="width: 100px" readonly="readonly"/>
	        		</dd>
	        		<dd>
	      				<span class="title">销售量：</span>
	        			<input class="reg_input" name="salesvolume" id="salesvolume" value="${groupgoods.salesvolume}" style="width: 100px" readonly="readonly"/>
	        		</dd>
	        		<dd>
	      				<span class="title">是否热销：</span>
	      				<input type="radio" name="isrx" id="isrx2" value="2" disabled="disabled"/>否
	        			<input type="radio" name="isrx" id="isrx1" value="1" disabled="disabled"/>是
	        		</dd>
	        		<dd>
	      				<span class="title">开始时间：</span>
	        			<input name="stime" id="stime" value="${groupgoods.stime}"  style="width: 150px;" readonly="readonly"/>
	         		</dd>
	        		<dd>
	      				<span class="title">结束时间：</span>
	        			<input name="etime" id="etime" value="${groupgoods.etime}" onClick="WdatePicker();" style="width: 150px;" readonly="readonly"/>
	         		</dd>
	        		<dd>
	      				<span class="title">淘宝网址：</span>
	        			<input class="reg_input" name="url" id="url" value="${groupgoods.url}" style="width: 240px" readonly="readonly"/>
	        		</dd>
	        		<dd>
	      				<span class="title">商品介绍：</span>
	        			<textarea style="width: 350px;;height: 150px;" name="remark" id="remark" readonly="readonly">${groupgoods.remark}</textarea>
	        		</dd>
	        		<dt class="f14 b">图片详情</dt>
	        		<c:if test="${!empty details}">
	        		<c:forEach items="${details}" var="detail" varStatus="s">
	        			<dd id="ddphoto${s.count}">
		         			<span class="title">${s.count}.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;照片：</span>
		         			<c:if test="${!empty detail.pic}">
		         				<img id="photoImg${s.count}" alt="" style="width: 150px;height: 160px;" src="upload/groupgoodsdetail/${detail.pic}"/>
		         			</c:if>
		         			<c:if test="${empty detail.pic}">
		         				<img id="photoImg${s.count}" alt="" style="width: 150px;height: 160px;" src="resource/images/login_bg.jpg"/>
		         			</c:if>
		     				
		 				</dd>
		  			</c:forEach>
	        		</c:if>
	        	</dl>
	    	</form>
		</div>
		<script type="text/javascript">
		   $(function(){
			    var isrx="${groupgoods.isrx}";
			    if(!isrx){
			      document.getElementById("isrx2").checked=true;
			    }else{
			      document.getElementById("isrx"+isrx).checked=true;
			    }
				
			});
		</script>
	</body>
</html>
