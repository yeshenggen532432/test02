<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>微信公众号支付配置</title>
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
		<form action="manager/weixinPay/updatePayConfig" name="weixinPayConfigForm" id="weixinPayConfigForm" method="post" >
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
			        <td style="height:10px;"></td>
			     </tr>
				<tr>
      				<td  style="text-align:right;">公众号appID：</td>
      				<td>
      					 <input type='hidden' id="id" value="${shopWxset.id }"  name='id'/>
						 <input type='text' id="appid" value="${shopWxset.appid }"  name='appid' style="width:500px;"/>
      				</td>
      				<td>
      					 <input type='button' id="cleanAppId" value="清空"  onclick="clean_app_id()" style="width:80px;"/>
      				</td>
	        	</tr>
	        	<!-- 表格行间距 --><tr><td style="height:10px;"></td></tr>
	        	<tr>
      				<td  style="text-align:right;">公众号子AppID：</td>
      				<td>
						 <input type='text' id="subAppid" value="${shopWxset.subAppid}"  name='subAppid' style="width:500px;"/>
      				</td>
      				<td>
      					 <input type='button' id="cleanSubAppId" value="清空"  onclick="clean_sub_appId()" style="width:80px;"/>
      				</td>
	        	</tr>
	        	<!-- 表格行间距 --><tr><td style="height:10px;"></td></tr>
	        	<tr>
      				<td style="text-align:right;">公众号appSecret：</td>
      				<td>
      					 <input type='text' id="appsecret" value="${shopWxset.appsecret}"  name='appsecret' style="width:500px;"/>
      				</td>
      				<td>
      					 <input type='button' id="cleanAppSecret" value="清空"  onclick="clean_app_secret()" style="width:80px;"/>
      				</td>
	        	</tr>
	        	<!-- 表格行间距 --><tr><td style="height:10px;"></td></tr>
	        	<tr>
      				<td style="text-align:right;">商户号：</td>
      				<td>
      					 <input type='text' id="mchId" value="${shopWxset.mchId}"  name='mchId' style="width:500px;"/>
      				</td>
      				<td>
      					 <input type='button' id="cleanMchId" value="清空"  onclick="clean_mch_id()" style="width:80px;"/>
      				</td>
	        	</tr>
	        	<!-- 表格行间距 --><tr><td style="height:10px;"></td></tr>
	        	<tr>
      				<td style="text-align:right;">子商户号：</td>
      				<td>
      					 <input type='text' id="subMchId" value="${shopWxset.subMchId}"  name='subMchId' style="width:500px;"/>
      				</td>
      				<td>
      					 <input type='button' id="cleanSubMchId" value="清空"  onclick="clean_sub_mch_id()" style="width:80px;"/>
      				</td>
	        	</tr>
	        	<!-- 表格行间距 --><tr><td style="height:10px;"></td></tr>
	        	<tr>
      				<td style="text-align:right;">支付key：</td>
      				<td>
      					 <input type='text' id="wxkey" value="${shopWxset.wxkey}"  name='wxkey' style="width:500px;"/>
      				</td>
      				<td>
      					 <input type='button' id="cleanWxKey" value="清空"  onclick="clean_wx_key()" style="width:80px;"/>
      				</td>
	        	</tr>
	        	<!-- 表格行间距 --><tr><td style="height:10px;"></td></tr>
	        	<tr hidden="true">
      				<td style="text-align:right;">shopNo：</td>
      				<td>
      					 <input type='text' id="shopNo" readonly="readonly" value="${shopWxset.shopNo}"  name='shopNo' style="width:500px;"/>
      				</td>
	        	</tr>
	        	<tr>
      				<td style="text-align:right;">回调地址：</td>
      				<td>
      					 <input type='text' id="backUrl" value="${shopWxset.backUrl}"  name='backUrl' style="width:500px;"/>
      				</td>
      				<td>
      					 <input type='button' id="cleanBackUrl" value="清空"  onclick="clean_back_url()" style="width:80px;"/>
      				</td>
	        	</tr>
	        	<!-- 表格行间距 --><tr><td style="height:10px;"></td></tr>
	        	<tr>
      				<td style="text-align:right;">开启状态：</td>
      				<td>
      				<c:if test="${shopWxset.status==null || shopWxset.status==0}">
      					<input type='text' id="status" value="0"  name='status' style="width:500px;" hidden="true"/>
						<input type='checkbox' id="status" name="status" style="height:20px;width:20px;" onclick="checkStatus()"/> 
					</c:if>
      				<c:if test="${shopWxset.status==1}">
      					<input type='text' id="status" value="1"  name='status' style="width:500px;" hidden="true"/>
						<input type='checkbox' id="status" name="status" checked="checked" style="height:20px;width:20px"  onclick="checkStatus()"/>
					</c:if>
      				</td>
	        	</tr>
	        	<!-- 表格行间距 --><tr><td style="height:10px;"></td></tr>
	        	<tr><td style="height:10px;"></td><!-- 表格行间距 --></tr>
	        	  <tr>
			        <td colspan="3" style="text-align:center;">
			           <button  onclick="return savePayConfig()" style="width:80px;">保存</button>
			        </td>
			      </tr>
			</table>
			</dd>
			</dl>	
		</form>
		</div>
		<script type="text/javascript">
		function checkStatus(){
			if($("input[type='checkbox']").attr("checked")=="checked"){
				$("#status").val("1");
			}else{
				$("#status").val("0");
			}

		}
		   function savePayConfig(){
			   $("#weixinPayConfigForm").form('submit',{
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
		   function clean_app_id(){
			   $("#appid").val("");
			   $("#appid").focus();
		   }
		   function clean_sub_appId(){
			   $("#subAppid").val("");
			   $("#subAppid").focus();
		   }
		   function clean_app_secret(){
			   $("#appsecret").val("");
			   $("#appsecret").focus();
		   }
		   function clean_mch_id(){
			   $("#mchId").val("");
			   $("#mchId").focus();
		   }
		   function clean_sub_mch_id(){
			   $("#subMchId").val("");
			   $("#subMchId").focus();
		   }
		   function clean_wx_key(){
			   $("#wxkey").val("");
			   $("#wxkey").focus();
		   }
		   function clean_back_url(){
			   $("#backUrl").val("");
			   $("#backUrl").focus();
		   }
		</script>
	</body>
</html>
