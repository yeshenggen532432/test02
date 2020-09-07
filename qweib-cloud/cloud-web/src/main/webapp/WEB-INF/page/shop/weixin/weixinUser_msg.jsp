<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>微信会员消息</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="resource/loadDiv.js"></script>
	</head>
	<body>
		<input type="hidden" name="openIdKey" id="openIdKey" value=${openId} />
		<input type="hidden"  id="name" value=${name} />
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="false"
			url="/manager/weixinMemberTextMsg?openId=${openId}" border="false"
			rownumbers="true" fitColumns="false" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
			<thead>
				<tr>
					<th field="fromUserName" width="100" align="center" formatter="msgSenderFormatter">
						消息发送者
					</th>
					<th field="content" width="300" align="center" >
						消息
					</th>
					<th field="msgTime" width="120" align="center">
						消息时间
					</th> 
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
			<a style="margin-left: 30px;" class="easyui-linkbutton"  plain="true" iconCls="icon-back" href="javascript:toback();">返回</a>
		</div>
		<script type="text/javascript">	
		 function msgSenderFormatter(val,row){	
			 var openId=$("#openIdKey").val();
			 var name=$("#name").val();
			 if(val==openId){
				 return name;
			 }else{
				 return "客服 "+val+":";
			 }
		}
		// 返回
         function toback(){
             location.href="${base}/manager/shopMember/toPage?dataTp=1";
         }
		</script>
	</body>
</html>
