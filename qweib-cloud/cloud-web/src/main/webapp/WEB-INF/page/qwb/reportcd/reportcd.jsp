<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>企微宝</title>
		<%@include file="/WEB-INF/page/include/source.jsp"%>
	</head>
	<body>
	
		<div class="box">
  			<form action="manager/updatereportcd" name="reportCdfrm" id="reportCdfrm" method="post">
  				<dl id="dl">
	      			       <input id="id" name="id" value="${reportCd.id}" type="hidden"/>
	      			       <c:if test="${reportCd.id==1}">
		        		      <dt class="f14 b">日报（最少字数限制）</dt>
		        		       <dd>
				  					今日完成工作文字长度：
				  					<input id="gzNrcd" name="gzNrcd" value="${reportCd.gzNrcd}" class="reg_input" style="width: 150px"/>
				         			<span id="gzNrcdTip" class="onshow"></span>
							   </dd>
							   <dd>
				  					&nbsp;&nbsp;&nbsp;未完成工作文字长度：
				  					<input id="gzZjcd" name="gzZjcd" value="${reportCd.gzZjcd}" class="reg_input" style="width: 150px"/>
				         			<span id="gzZjcdTip" class="onshow"></span>
							   </dd>
							   <input type="hidden" id="gzJhcd" name="gzJhcd" value="0"/>
		        		   </c:if>
		        		    <c:if test="${reportCd.id==2}">
		        		      <dt class="f14 b">周报（最少字数限制）</dt>
		        		      <dd>
				  					本周完成工作文字长度：
				  					<input id="gzNrcd" name="gzNrcd" value="${reportCd.gzNrcd}" class="reg_input" style="width: 150px"/>
				         			<span id="gzNrcdTip" class="onshow"></span>
							   </dd>
							   <dd>
				  					本周工作总结文字长度：
				  					<input id="gzZjcd" name="gzZjcd" value="${reportCd.gzZjcd}" class="reg_input" style="width: 150px"/>
				         			<span id="gzZjcdTip" class="onshow"></span>
							   </dd>
							   <dd>
				  					下周工作计划文字长度：
				  					<input id="gzJhcd" name="gzJhcd" value="${reportCd.gzJhcd}" class="reg_input" style="width: 150px"/>
				         			<span id="gzJhcdTip" class="onshow"></span>
							   </dd>
		        		   </c:if>
		        		    <c:if test="${reportCd.id==3}">
		        		      <dt class="f14 b">月报（最少字数限制）</dt>
		        		      <dd>
				  					本月工作内容文字长度：
				  					<input id="gzNrcd" name="gzNrcd" value="${reportCd.gzNrcd}" class="reg_input" style="width: 150px"/>
				         			<span id="gzNrcdTip" class="onshow"></span>
							   </dd>
							   <dd>
				  					本月工作总结文字长度：
				  					<input id="gzZjcd" name="gzZjcd" value="${reportCd.gzZjcd}" class="reg_input" style="width: 150px"/>
				         			<span id="gzZjcdTip" class="onshow"></span>
							   </dd>
							   <dd>
				  					下月工作计划文字长度：
				  					<input id="gzJhcd" name="gzJhcd" value="${reportCd.gzJhcd}" class="reg_input" style="width: 150px"/>
				         			<span id="gzJhcdTip" class="onshow"></span>
							   </dd>
		        		   </c:if>
		        		   <dd>
			  					需帮助与支持文字长度：
			  					<input id="gzBzcd" name="gzBzcd" value="${reportCd.gzBzcd}" class="reg_input" style="width: 150px"/>
			         			<span id="gzBzcdTip" class="onshow"></span>
						   </dd>
						   <dd>
			  					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;备注文字长度：
			  					<input id="remocd" name="remocd" value="${reportCd.remocd}" class="reg_input" style="width: 150px"/>
			         			<span id="remocdTip" class="onshow"></span>
						   </dd>
						   
				</dl>
	    		<div class="f_reg_but">
	    			<input type="button" value="保存" class="l_button" onclick="toSubmit();"/>
	      		</div>
	  		</form>
		</div>
		<script type="text/javascript">
		  function toSubmit(){
		      var gzNrcd=$("#gzNrcd").val();
		      var gzZjcd=$("#gzZjcd").val();
		      var gzJhcd=$("#gzJhcd").val();
		      var gzBzcd=$("#gzBzcd").val();
		      var remocd=$("#remocd").val();
		      if(parseInt(gzNrcd)>500){
		        alert("工作内容文字长度不能大于500");
		        return;
		      }
		      if(parseInt(gzZjcd)>500){
		        alert("工作总结文字长度不能大于500");
		        return;
		      }
		      if(parseInt(gzJhcd)>500){
		        alert("工作计划文字不能大于500");
		        return;
		      }
		      if(parseInt(gzBzcd)>500){
		        alert("帮助支持文字长度不能大于500");
		        return;
		      }
		      if(parseInt(remocd)>500){
		        alert("备注文字长度不能大于500");
		        return;
		      }
		      if ($.formValidator.pageIsValid()==true){
					$("#reportCdfrm").form('submit',{
						success:function(data){
							if(data=="1"){
								alert("修改成功");
								toback();
							}else{
								alert("操作失败");
							}
						}
					});
				}
			}
			function toback(){
				location.href="${base}/manager/toreportcd?id=${reportCd.id}";
			}
			$(function(){
			    var id="${reportCd.id}";
			    $.formValidator.initConfig();
				$("#gzNrcd").formValidator({onShow:"请输数值",onFocus:"请输数值"}).regexValidator({regExp:"money",dataType:"enum",onError:"数值格式不正确"});
				$("#gzZjcd").formValidator({onShow:"请输数值",onFocus:"请输数值"}).regexValidator({regExp:"money",dataType:"enum",onError:"数值格式不正确"});
				if(id!=1){
				    $("#gzJhcd").formValidator({onShow:"请输数值",onFocus:"请输数值"}).regexValidator({regExp:"money",dataType:"enum",onError:"数值格式不正确"});
				}
				$("#gzBzcd").formValidator({onShow:"请输数值",onFocus:"请输数值"}).regexValidator({regExp:"money",dataType:"enum",onError:"数值格式不正确"});
				$("#remocd").formValidator({onShow:"请输数值",onFocus:"请输数值"}).regexValidator({regExp:"money",dataType:"enum",onError:"数值格式不正确"});
			});
		</script>
	</body>
</html>

