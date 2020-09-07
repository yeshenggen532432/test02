<%@ page language="java" pageEncoding="UTF-8"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>企微宝管理</title>
		<%@include file="/WEB-INF/page/include/source.jsp"%>
    </head>
	<body>
		<div class="box">
  			<form  name="questionnairefrm" id="questionnairefrm" method="post">
  			     <dl id="dl">
  				    <dt class="f14 b">问卷信息</dt>
	      			<dd>
	      				<span class="title">标题：</span>
	        			<input  name="title" id="title" value="${questionnaire.title}" style="width: 240px;height:25px" readonly="readonly"/>
	        			
	        		</dd>
	        		<dd>
	      				<span class="title">单多选项：</span>
	        			<c:if test="${questionnaire.dsck==1}">
	        			     单选项
	        			</c:if>
	        			<c:if test="${questionnaire.dsck!=1}">
	        			     ${questionnaire.dsck}选项
	        			</c:if>
	        		</dd>
	        		<dd>
	      				<span class="title">内容：</span>
	        			<textarea style="width:400px;height:180px;" name="content" id="content" readonly="readonly">${questionnaire.content}</textarea>
	        		</dd>
	        		<dd>
	      				<span class="title">截止时间：</span>
	        			<input  name="etime" id="etime" value="${questionnaire.etime}"  style="width: 150px;height:25px" readonly="readonly"/>
	         			
	        		</dd>
	        		<dd>
	        			<span class="title">部门：</span>
	        			<input name="branchName" id="branchName" value="${questionnaire.branchName}" style="width: 150px;height:25px" readonly="readonly"/>
	        		</dd>
	        		<dt class="f14 b">选项内容</dt>
	        		<c:if test="${!empty details}">
	        		<c:forEach items="${details}" var="detail" varStatus="s">
	        			<dd>
		         			<span class="title">${detail.no}.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
		         			<input  name="lsQuestionnaireDetail[${s.count-1}].no" id="no[${s.count-1}]" value="${detail.no}" type="hidden"/>
		         			<input  name="lsQuestionnaireDetail[${s.count-1}].content" id="content[${s.count-1}]" value="${detail.content}" style="width: 240px;height:25px;" readonly="readonly"/>
		         		</dd>
		  			</c:forEach>
	        		</c:if>
	    		</dl>
	    		<div class="f_reg_but">
	    			<input type="button" value="返回" class="b_button" onclick="toback();"/>
	     		</div>
	  		</form>
		</div>
		
		<script type="text/javascript">
			function toback(){
			    location.href="${base}/manager/queryquestionnaire";
			}
		</script>
	</body>
</html>
