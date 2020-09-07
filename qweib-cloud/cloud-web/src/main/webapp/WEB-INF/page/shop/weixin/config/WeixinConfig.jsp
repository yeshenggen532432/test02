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
		<script type="text/javascript" src="resource/jquery.upload.js"></script>
		<style type="text/css">
		#tb{
			//background-color:#F4F4F4;
			background-color:rgb(224,236,255);
		}
		</style>
	</head>
	<body class="easyui-layout" fit="true">
		<div data-options="region:'north',plit:true"  id="tb" style="padding:5px;height:40px" >
			<a class="easyui-linkbutton" iconCls="icon-edit" plain="true" href="javascript:toWeixinLogin();">注册/登录微信公众平台</a>
			<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:uploadWeixinValidateText();">上传商城网页授权域名文件</a>
			<a class="easyui-linkbutton" iconCls="icon-search" plain="true" href="javascript:showMaterial();">素材管理</a>
			<a class="easyui-linkbutton" iconCls="icon-edit" plain="true" href="javascript:toMenuConfigPage();">自定义菜单</a>
			<a class="easyui-linkbutton" iconCls="icon-edit" plain="true" href="javascript:toReplyConfigPage();">自定义回复</a>
		</div>
		<div data-options="region:'west',split:true,title:'功能导航'" style="width:200px;">
			<iframe name="leftframe" id="leftframe" src="/manager/WeixinConfig/WeixinConfigLeft" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%">
			</iframe>
		</div>
		<div data-options="region:'center'">
			<iframe name="mainiframe" id="mainiframe" src="" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
		</div>
		<script type="text/javascript">
		  $(function(){
			  toUpdateConfig();
		  })  
		  function toWeixinLogin(){
			var get_url="/manager/getWeixinLoginUrl?getWeixinLoginUrl=1";
			var msg=$.ajax({url:get_url,async:false});
			var json=$.parseJSON(msg.responseText);
			var url=json.url;
		    parent.add('微信公众平台',url);
		   }
		   function showMaterial(){				
				 //素材管理
			    var url="/manager/WeixinConfig/materialManager";
			    parent.add('素材管理',url);				
		   }
		   function toMenuConfigPage(){
			   //自定义菜单
			    var url="/manager/toMenuConfigPage";
			    parent.add('自定义菜单',url);		
		   }
		   function toReplyConfigPage(){
			   //自定义回复
			    var url="/manager/toReplyConfigPage";
			    parent.add('自定义回复',url);		
		   }
		   function toUpdateConfig(){
		       var hostname=location.hostname;
			   //公众号配置
			   var url="/manager/WeixinConfig/toUpdateConfig?QwbUrl="+hostname;
			   mainiframe.location.href=url;
		   }
		   function toUpdatePayConfig(){
			   //公众号支付配置
			   var url="/manager/weixinPay/toUpdatePayConfig";
			   mainiframe.location.href=url;
		   }
          function toSetCustomerService(){
              //客服人员分配
              var url="/manager/WeixinConfig/toSetCustomerService";
              mainiframe.location.href=url;
          }
		   function registerWeixinHelp(){
			   var url="/manager/WeixinConfig/registerWeixinHelp";
			   mainiframe.location.href=url;
		   }
		   function configAppidAppsecretHelp(){
			   var url="/manager/WeixinConfig/configAppidAppsecretHelp";
			   mainiframe.location.href=url;
		   }
		   function configUrlTokenHelp(){
			   var url="/manager/WeixinConfig/configUrlTokenHelp";
			   mainiframe.location.href=url;
		   }
			// 上传商城网页授权域名文件
			function uploadWeixinValidateText(){
				var postText_Url="/manager/postWeixinText";
					$.upload({
						// 上传地址
						url:postText_Url,
						// 文件域名字
						fileName: 'uploadText', 
						// 上传完成后, 返回json, text
						dataType: 'json',
						// 上传之前回调,return true表示可继续上传
						onSend: function() {
							return true;
						},
				 		// 上传之后回调
						 onComplate:function(data){		
							if(data.state){
								alert(data.msg);
							}else{
								alert(data.msg);
							}
						},  
					});						
				}	
		</script>
	</body>
</html>
