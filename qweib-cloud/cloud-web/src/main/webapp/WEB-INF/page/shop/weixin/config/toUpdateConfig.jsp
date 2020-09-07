<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>微信公众号配置</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script src="<%=basePath%>/resource/clipboard.min.js"></script>
		<style type="text/css">
		#tb{
			background-color:#F4F4F4;
		}
		</style>
	</head>
	<body>
		<div class="box" style="width:100%;">
		<form action="manager/WeixinConfig/updateConfig" name="weixinConfigForm" id="weixinConfigForm" method="post" >
		  <dl id="dl">
		  <dd >
			<table  style="margin-top:20px;margin-left:20px;border-collapse:   separate;   border-spacing:   10px;">
			     <tr>
			        <td colspan="3" >
			           <span style="width:100px;padding-top:20px;">登录微信公众平台,在基础设置的公众号开发信息下把开发者ID(AppID)、开发者密码(AppSecret)填到这里的appID和appsecret：
			           </span>
			        </td>
			     </tr>
			      <tr>
			        <td style="height:5px;"></td>
			     </tr>
				<tr>
      				<td  style="text-align:right;">appID：</td>
      				<td>
      					 <input type='hidden' id="id" value="${config.id }"  name='id'/>
						 <input type='text' id="appId" value="${config.appId }"  name='appId' style="width:500px;"/>
      				</td>
      				<td>
      					 <input type='button' id="cleanAppId" value="清空"  onclick="cleanId()" style="width:80px"/>
      				</td>
	        	</tr>
	        	 <tr>
			        <td style="height:5px;"></td>
			     </tr>
	        	<tr>
      				<td style="text-align:right;">appsecret：</td>
      				<td>
      					 <input type='text' id="appSecret" value="${config.appSecret }"  name='appSecret' style="width:500px;"/>
      				</td>
      				<td>
      					 <input type='button' id="cleanAppSecret" value="清空"  onclick="cleanSecret()" style="width:80px"/>
      				</td>
	        	</tr>
	        	<tr>
			        <td style="height:5px;"></td>
			     </tr>
	        	<tr>
			        <td colspan="3" >
			           <span style="width:100px;padding-top:20px;">复制这里的url和token到微信公众平台的基本配置的服务器配置的url和token(响应微信回复配置)：</span>
			        </td>
			     </tr>
			      <tr>
			        <td colspan="3" style="height:5px;">
			        </td>
			     </tr>
	        	<tr>
      				<td style="text-align:right;">url：</td>
      				<td>
      					 <input type='text' id="url" name='url' readonly="readonly" value="${config.url }" style="width:500px;"/>
      				</td>
      				<td>
      					 <input type='button' id="copyUrl"  value="复制"  data-clipboard-action="copy" data-clipboard-target="#url" style="width:80px"/>
      				</td>
	        	</tr>
	        	 <tr>
			        <td colspan="3" style="height:5px;">
			        </td>
			     </tr>
	        	<tr>
      				<td style="text-align:right;">token：</td>
      				<td>
      					  <input type='text' id="token" name='token' readonly="readonly" value="${config.token }"   style="width:500px;"/>
      				</td>
      				<td>
      					 <input type='button' id="copyToken" value="复制"  data-clipboard-action="copy" data-clipboard-target="#token" style="width:80px"/>
      				</td>
	        	</tr>
				<tr>
					<td colspan="3" style="height:5px;">
					</td>
				</tr>
				<tr>
					<td colspan="3" >
						<span style="width:100px;padding-top:20px;">复制这里的白名单IP到微信公众平台的基本配置的IP白名单：</span>
					</td>
				</tr>
				<tr>
					<td colspan="3" style="height:5px;">
					</td>
				</tr>
				<tr>
					<td style="text-align:right;">白名单IP：</td>
					<td>
						<input type='text' id="qwbIp" name='qwbIp' readonly="readonly" value="${qwbIp}"   style="width:500px;"/>
					</td>
					<td>
						<input type='button' id="copyQwbIp" value="复制"  data-clipboard-action="copy" data-clipboard-target="#qwbIp" style="width:80px"/>
					</td>
				</tr>
	        	<tr>
			        <td style="height:5px;"></td>
			     </tr>
	        	  <tr>
			        <td colspan="3" style="text-align:center;">
			           <button  onclick="return saveConfig()" style="width:80px">保存</button>
			        </td>
			       </tr>
			</table>
			</dd>
			</dl>	
		</form>
		</div>
		<script type="text/javascript">
			$(function () {
				  var clipboard = new ClipboardJS('#copyUrl');
				    clipboard.on('success', function(e) {
				       alert("复制成功！");
				    });
				    clipboard.on('error', function(e) {
				    	 alert("复制失败：浏览器不支持,请手动复制！");
				    });
				    
				    var clipboard1 = new ClipboardJS('#copyToken');
				    clipboard1.on('success', function(e) {
				       alert("复制成功！");
				    });
				    clipboard1.on('error', function(e) {
				    	 alert("复制失败：浏览器不支持,请手动复制！");
				    });

					var clipboard2 = new ClipboardJS('#copyQwbIp');
					clipboard2.on('success', function(e) {
						alert("复制成功！");
					});
					clipboard2.on('error', function(e) {
						alert("复制失败：浏览器不支持,请手动复制！");
					});
			});
		   function saveConfig(){
			   $("#weixinConfigForm").form('submit',{
					success:function(data){
						var dataJson = JSON.parse(data);
						if(dataJson.state){
							$.messager.alert('消息','保存成功!','info');
							$("#id").val(dataJson.id);
						}else{
							$.messager.alert('消息','保存失败!','info');
						}
					}
				});
			   return false;
		  }
		   function cleanId(){
			   $("#appId").val("");
			   $("#appId").focus();
		   }
		   function cleanSecret(){
			   $("#appSecret").val("");
			   $("#appSecret").focus();
		   }
		</script>
	</body>
</html>
