<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>T3</title>
		<%@include file="/WEB-INF/page/include/source.jsp"%>
	</head>
	<body>
	
		<div class="box">
  			<form action="manager/updateCljccjMdLs" name="cljccjMdfrm" id="cljccjMdfrm" method="post">
  			    <dl id="dl">
	      			<dt class="f14 b">库存检查模板设置</dt>
	      			<c:forEach items="${list}" var="list" varStatus="s">
	      			<input type="hidden" name="cljccjMdLs[${s.count-1}].id"  value="${list.id}"/>
		      			<dd>
		      				<span class="title"><font color="red">名称：</font></span>
		        			<input class="reg_input" name="cljccjMdLs[${s.count-1}].mdNm" value="${list.mdNm}" style="width: 200px"/>
		        		</dd>
		        		<dd>
		      				<span class="title">货架排面数：</span>
		        			<input type="radio" name="cljccjMdLs[${s.count-1}].isHjpms" <c:if test="${list.isHjpms==1}">checked</c:if> value="1"/>显示
		        			<input type="radio" name="cljccjMdLs[${s.count-1}].isHjpms" <c:if test="${list.isHjpms==2}">checked</c:if> value="2"/>不显示
		        		</dd>
		        		<dd>
		      				<span class="title">端架排面数：</span>
		        			<input type="radio" name="cljccjMdLs[${s.count-1}].isDjpms" <c:if test="${list.isDjpms==1}">checked</c:if> value="1"/>显示
		        			<input type="radio" name="cljccjMdLs[${s.count-1}].isDjpms" <c:if test="${list.isDjpms==2}">checked</c:if> value="2"/>不显示
		        		</dd>
		        		<dd>
		      				<span class="title">收银台围栏：</span>
		        			<input type="radio" name="cljccjMdLs[${s.count-1}].isSytwl" <c:if test="${list.isSytwl==1}">checked</c:if> value="1"/>显示
		        			<input type="radio" name="cljccjMdLs[${s.count-1}].isSytwl" <c:if test="${list.isSytwl==2}">checked</c:if> value="2"/>不显示
		        		</dd>
		        		<dd>
		      				<span class="title">冰点数：</span>
		        			<input type="radio" name="cljccjMdLs[${s.count-1}].isBds" <c:if test="${list.isBds==1}">checked</c:if> value="1"/>显示
		        			<input type="radio" name="cljccjMdLs[${s.count-1}].isBds" <c:if test="${list.isBds==2}">checked</c:if> value="2"/>不显示
		        		</dd>
	        		</c:forEach>
	        	</dl>
	    		<div class="f_reg_but">
	    			<input type="button" value="保存" class="l_button" onclick="toSubmit();"/>
	      		</div>
	  		</form>
		</div>
		
		
		<script type="text/javascript">
	        function toSubmit() {
			   if ($.formValidator.pageIsValid() == true) {
			    $("#cljccjMdfrm").form('submit', {
						success : function(data) {
							if (data == "1") {
								alert("修改成功");
								toback();
							}else{
								alert("操作失败");
							}
						}
					});
				}
			}
			function toback() {
				location.href = "${base}/manager/queryCljccjMdls";
				//location.href = '${base}/manager/queryCljccjMdls';
			}
			$(function() {
			    $.formValidator.initConfig();
				
			});
	  </script>
	</body>
</html>
