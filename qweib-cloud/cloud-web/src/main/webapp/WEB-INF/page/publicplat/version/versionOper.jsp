<%@ page language="java" pageEncoding="UTF-8"%>
<%@page import="com.qweib.cloud.core.domain.SysLoginInfo"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>系统客户端版本操作页面</title>

		<meta http-equiv="pragma" content="no-cache"/>
		<meta http-equiv="cache-control" content="no-cache"/>
		<meta http-equiv="expires" content="0"/>
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3"/>
		<meta http-equiv="description" content="This is my page"/>
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="resource/md5.js"></script>
		<script type="text/javascript" src="resource/WdatePicker.js"></script>
		<script type="text/javascript" src="resource/loadDiv.js"></script>
		<style>
			#myTable td{border: 1px solid rgb(193, 193, 193);}
		</style>
		<% SysLoginInfo info = (SysLoginInfo)session.getAttribute("usr"); %>
	</head>
<body >
	<div class="box" >
			<form action="manager/saveVersion" name="verfrm" id="verfrm" method="post" enctype="multipart/form-data">
				<dl>
					<dt class="f14 b"></dt>
					<dd>
						<input value="${version.id }" type="hidden"  name="id" id="id"/>
	      				<span class="title">版本名称：</span>
	        			<input class="reg_input" name="versionName" id="versionName"  
	        				type="text" maxlength="30" value="${version.versionName }" />
	        			<span id="versionNameTip" class="onshow"></span>
	        		</dd>
	        		<dd>
	      				<span class="title">版本类型：</span>
		      				<select name="versionType" id="versionType"  >
		      					<option value="0" ${version.versionType=='0'?'selected':'' }>Android版本</option>
		      					<option value="1" ${version.versionType=='1'?'selected':'' }>IOS版本</option>
		      					<option value="2" ${version.versionType=='2'?'selected':'' }>IOS市场版本</option>
								<option value="4" ${version.versionType=='4'?'selected':'' }>Android市场版本</option>
		      				</select>
	        		</dd>
	        		
					<dd>
	         			<span class="title">应用地址：</span>
	        			<input  name="applycationUrl" id="applycationUrl"  
	        				type="file" maxlength="30" />
	        			<span id="applycationUrlTip" class="onshow"></span>
	 				</dd>
	 				<%--<dd>
	         			<span class="title">ios配置文件：</span>
	        			<input  name="configUrl" id="configUrl"  
	        				type="file" maxlength="30" />
	        			<span id="configUrlTip" class="onshow"></span>
	 				</dd>--%>
	 				<dd>
	         			<span class="title">下载地址：</span>
	        			<input class="reg_input" name="versionUrl" id="versionUrl"  
	        				type="text" maxlength="100"  value="${version.versionUrl }"/>
	        			<span id="versionUrlTip" class="onshow"></span>
	 				</dd>
	 				<dd>
	      				<span class="title">是否强制更新：</span>
	        			<input type="radio" name="isQz" id="isQz1" value="1" />是
	        			<input type="radio" name="isQz" id="isQz2" value="2" checked="checked"/>否
	        		</dd>
				</dl>
				<dl>
					<dt class="f14 b"></dt>
					<dd>
	      				<span class="title">版本更新信息：</span>
	      				<textarea name="versionContent" id="versionContent" style="width: 700px;height: 150px;">${version.versionContent }</textarea>
	        			<span id="versionContentTip" class="onshow" ></span>
	        		</dd>
					</dl>
				<div class="f_reg_but">
	    			<input type="button" value="发布" class="l_button" onclick="save();"/>
	      			<input type="reset" value="重置" class="r_button"/>
	      			<input type="button" value="返回" class="b_button" onclick="toback();"/>
	     		</div>
			</form>
	</div>
		
		<script type="text/javascript">
		$(function(){
			$.formValidator.initConfig();
			toformyz();
			 var height = document.body.clientHeight/2;
			 var width = document.body.clientWidth/2;
			 $("#loading").css({"margin-left":width,"margin-top":height});
			 //性别
			 var isQz = "${version.isQz}";
			 if(isQz!=""){
				document.getElementById("isQz"+isQz).checked=true;
			 }
		});
		function toformyz(){
			$("#versionName").formValidator({onShow:"2-40个字符",onFocus:"2-40个字符",onCorrect:"通过"}).inputValidator({min:2,max:40,onError:"版本名称输入有误"});
			$("#versionUrl").formValidator({onShow:"不能为空",onFocus:"不能为空",onCorrect:"通过"}).inputValidator({min:1,onError:"版本地址输入有误"});
		}
		//保存客户端版本
		function save(){
			var appName = ($("#applycationUrl").val()).substring(($("#applycationUrl").val()).indexOf(".")+1);
			var appType = $("#versionType").val();
			var versionId = $("#id").val();
			if(versionId==''){
				if(appType == 0&&appName != 'apk'){
				    alert('android应用类型错误不是标准的apk文件');
				    return false;
				}
				if(appType == 1&&appName != 'ipa'){
				    alert('ios应用类型错误不是标准的ipa文件');
				    return false;
				}
			}else if(appName!=''){
				if(appType == 0&&appName != 'apk'){
				    alert('android应用类型错误不是标准的apk文件');
				    return false;
				}
				if(appType == 1&&appName != 'ipa'){
				    alert('ios应用类型错误不是标准的ipa文件');
				    return false;
				}
			}
			//验证下载地址
			 var versionUrl = $("#versionUrl").val();
			 var RegUrl = new RegExp();
			    //RegUrl.compile("^[A-Za-z]+://[A-Za-z0-9-_]+\\.[A-Za-z0-9-_%&\?\/.=]+$");
			    RegUrl.compile("^(https?|ftp|file)://[-a-zA-Z0-9+&@#/%?=~_|!:,.;]*[-a-zA-Z0-9+&@#/%=~_|]");
			    if (!RegUrl.test(versionUrl)) {
			    	 alert("下载地址格式不正确");
			        return false;
			    }
			if($.formValidator.pageIsValid()==true){
				$("#verfrm").form('submit',{
					success:function(data){
						if(data=='1'){
							window.location.href="${base}/manager/queryVersion";
						}else{
							alert("保存失败");
						}
						onclose();
					},
					onSubmit:function(){
						DIVAlert("<img src='resource/images/loading.gif' width='50px' height='50px'/>");
					}
				
				});
			}
		}
		//返回
		function toback(){
			location.href="<%=request.getContextPath()%>/manager/queryVersion";
		}
		</script>
</body>
</html>