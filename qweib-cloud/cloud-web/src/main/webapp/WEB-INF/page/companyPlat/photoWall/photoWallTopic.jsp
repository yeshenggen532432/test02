<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
		<title>卡宝包</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript">
			//保存
			function save(){
				if($.formValidator.pageIsValid()==true){
				    if($("#deptId").val()==''){
				        alert("请选择单位");
				        return;
				    }
					$("#adform").form('submit',{
						success:function(data){
							if(!data || data=="-1"){
								showMsg("4");
							}
							else{
								alert("保存成功");
								location.href="${base}/manager/queryForum";
							}
						}
					});
				}
			}
			
			$(function(){
				$.formValidator.initConfig();
				$("#forumNm").formValidator({onShow:"2-50个字符",onFocus:"2-50个字符",onCorrect:"通过"}).inputValidator({min:2,max:50,onError:"请输入2-50个字符"});
			});
		</script>
</head>
<body>
	<div class="box">
		<form action="manager/addForum" id="adform" method="post">
			<dl>
				<dt class="f14 b">讨论区基本信息</dt>
				<c:if test="${addFlag == 'true' }">
				<dd>
	      				<span class="title">单位名称：</span>
	        			<select name="deptId" id="deptId" >
	        			   <option value="">
	        			     ---请选择---
	        			   </option> 
	        			   <c:forEach var="deptls" items="${deptlist}">
	        			   <option value="${deptls.deptId}">
	        			     ${deptls.deptNm}
	        			   </option>
	        			   </c:forEach>
	        			</select>
	        			
	        	</dd>
	        	</c:if>
				<dd>
					<span class="title">讨论区名称：</span>
					<input class="reg_input" name="forumNm" id="forumNm" style="width:156px;height: 20px;" />
					<span id="forumNmTip" class="onshow"></span>
				</dd>
				<dd>
					<span class="title">可发布主题：</span>
					<input name="publishTp" type="radio" value="1" onchange="everyBody();" />所有人
					<input name="publishTp" type="radio" value="2" onchange="someOne();" checked />指定人
				</dd>
				<dd id="merberList">
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;所有成员列表：<br/><br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<c:forEach items="${userList}" var="user">
						<input type="checkbox" name="merberIds" value ="${user.memberId}">${user.memberNm} &nbsp;
					</c:forEach>
				</dd>	
			</dl><br/>
			<div class="f_reg_but">
    			<a class="easyui-linkbutton" href="javascript:save();">保存</a>
				<a href="javascript:history.go(-1);" class="easyui-linkbutton" >关闭</a>
     		</div>
		</form>
	</div>
	<script type="text/javascript">
		//所有人
		function everyBody(){
			var checkbox = $("#merberList input[type=checkbox]").prop("checked", false);
			$("#merberList").hide();
		}
		//指定人
		function someOne(){
			$("#merberList").show();
		}
	</script>
</body>
</html>