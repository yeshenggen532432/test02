<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<title>微信会员消息</title>
	<%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
	<style type="text/css">
		html,body{
			width: 100%;
			height: 100%;
		}
		#tb{
			background-color:#F4F4F4;
		}
		label{
			font-weight: normal;
		}
		#checkMsgMemberListDiv{
			position: absolute;
			top:0px;
			bottom:0;
			left:0px;
			width: 300px;
			overflow: auto;
		}
		#msgDiv{
			position: absolute;
			top:0px;
			bottom:0;
			left:300px;
			width: 520px;
			border:solid 1px #E7E7E7;
			background-color: #F5F5F5;
			overflow-y: auto;
			/*padding-right: 30px;*/
		}
		.checkMsgMemberListDl{
			width:100%;
		}
		.checkMsgMemberListDl dd{
			margin:0px;
			border-bottom:1px dotted #ccc;
		}
		.checkMsgMemberTable{
			width:270px ;
			height: 50px;
			font-size: 12px;
			font-family: Arial, "宋体";
		}
		.checkMsgMemberTable tr{
			height: 50px;
			width:200px ;
		}
		/*会员列表会员图片*/
		.checkMsgMemberImageTd{
			position:relative;
			height: 40px;
			width:70px ;
		}
		/*会员列表会员名称*/
		.checkMsgMemberNameTd{
			height: 40px;
			width:50px ;
			text-align: left;
		}
		/*会员列表客服图片*/
		.customerServiceImageTd{
			height: 40px;
			width:50px ;
		}
		/*会员列表客服图片边框*/
		.customerServiceImage{
			border:solid 1px #E7E7E7;
			padding: 0 0 0 0;
			/*border:solid 2px #9EEA6A;*/
			/*border:solid 2px #FA5151;*/
		}
		/*会员列表客服名称*/
		.customerServiceNameTd{
			height: 40px;
			width:100px ;
			text-align: left;
		}
		.weixinImage{
			margin-left: 10px;
		}
		.name{
			margin-left: 0px;
		}
		/*消息时间div*/
		.msgTimeDiv{
			width:490px;
			margin-top: 5px;
			margin-bottom: 5px;
			text-align: center;
		}
		/*消息时间label*/
		.msgTimeLabel{
			width:140px;
			background-color: #DADADA;
		}
		/*客服消息div*/
		.customerServiceMsgDiv{
			width:490px;
		}
		/*客服名称*/
		.customerServiceNameDiv{
			width:45px;
			text-align: left;
			line-height: 22px;
			font-size: 14px;
			margin-top: 10px;
			margin-left: 30px;
			margin-bottom: 10px;
			float: left;
		}
		/*客服聊天边框*/
		.customerServiceChatBorderDiv{
			margin-left: 0px;
			margin-top:25px;
			float: left;
			width:0;
			height:0;
			border-top:5px solid #F5F5F5;
			border-left:5px solid #F5F5F5;
			border-right:5px solid #FFFFFF;
			border-bottom:5px solid #F5F5F5;
		}
		/*客服消息内容div*/
		.customerServiceMsgContentDiv{
			background-color: #FFFFFF;
			margin-top: 10px;
			margin-bottom: 10px;
			margin-left: 0px;
			max-width: 245px;
			padding:10px 10px 10px 10px;
			border-radius: 5px;
			line-height: 22px;
			font-size: 14px;
			float: left;
			word-break: break-all;
		}
		.clear{
			clear: both;
		}
		/*聊天消息内容的会员消息div*/
		.memberMsgDiv{
			width:490px;
			margin-right: 10px;
		}
		/*聊天内容会员图片div*/
		.memberImageDiv{
			width:35px;
			height: 35px;
			margin-top: 10px;
			margin-bottom: 10px;
			float: right;
		}
		/*会员图片*/
		.image{
			padding: 0 0 0 0;
			max-width: 245px;
		}
		/*会员聊天边框*/
		.memberChatBorderDiv{
			margin-right: 0px;
			margin-top:25px;
			float: right;
			width:0;
			height:0;
			border-top:5px solid #F5F5F5;
			border-left:5px solid #9EEA6A;
			border-right:5px solid #F5F5F5;
			border-bottom:5px solid #F5F5F5;
		}
		/*会员消息内容div*/
		.memberMsgContentDiv{
			background-color: #9EEA6A;
			margin-top: 10px;
			margin-bottom: 10px;
			margin-right: 0px;
			max-width: 245px;
			padding:10px 10px 10px 10px;
			border-radius: 5px;
			line-height: 22px;
			font-size: 14px;
			float: right;
			word-break: break-all;
		}
		/*客服回复会员div*/
		.responseMsgDiv{
			position: absolute;
			top:0px;
			left:820px;
			width:310px;
			height:400px;
			display: none;
		}
		/*客服申请聊天div*/
		.requestChatDiv{
			position: absolute;
			top:0px;
			left:820px;
			width:310px;
			height:400px;
			display: none;
		}
		/*客服发送消息div*/
		.sendTextMsgDiv{
			position: absolute;
			top:0px;
			left:820px;
			width:285px;
			height:400px;
			display: none;
		}
		.memberNewMsgNo{
			padding: 0px 5px 0px 5px;
			position: absolute;
			top:5px;
			left:40px;
			background-color: #FA5151;
			color: white;
			text-align: center;
			line-height:20px;
			height: 20px;
			width: auto;
			min-width: 10px;
			border-radius: 20px;
			display: none;
		}
		.memberNewMsgNoShow{
			padding: 0px 5px 0px 5px;
			position: absolute;
			top:5px;
			left:40px;
			background-color: #FA5151;
			color: white;
			text-align: center;
			line-height:20px;
			height: 20px;
			width: auto;
			min-width: 10px;
			border-radius: 20px;
		}
		/*选择在线客服div*/
		.CustomerServiceDiv{
			width: 550px;
			height: 260px;
			border: solid 1px #95B8E7;
			overflow-y: auto;
			padding: 10px;
		}
		/*在线客服div*/
		.onlineCustomerServiceDiv{
			width: 500px;
			height: 30px;
		}
		.chooseCustomerServiceButton{
			width: 60px;
		}
		.chooseCustomerServiceNameLabel{
			width: 60px;
			display: inline-block;
		}
		.requestCustomerServiceIdLabel{
			display:none;
		}
		.customerServiceIdLabel{
			display:none;
		}
		.customerServiceNameLabel{
			display: inline-block;
			width: 40px;
		}
		.multyCustomerServiceLabel{
			display: none;
		}
		.greenBorder{
	//		border: solid 2px #9EEA6A;
		}
		.redBorder{
		//	border: solid 2px #FA5151;
		}
		.yellowBorder{
	//		border: solid 2px #FFEE4C;
		}
		.customerServiceImageDivHide{
			display: none;
		}

		/*图片消息大图*/
		#bigImage{
			max-width: 490px;
			max-height: 400px;
			overflow: scroll;
		}
	</style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
	<div class="layui-row layui-col-space15">
		<%--客服聊天div--%>
		<div class="layui-col-md12">
			<%--客服聊天菜单栏--%>
			<div class="layui-card header">
				<div class="layui-card-body">
					<div class="form-horizontal query">
						<div class="form-group" style="margin-bottom: 10px;">
							<div class="col-xs-24">
								<button id="exitWebSocketChatButton" uglcw-role="button" class="k-button k-primary" onclick="exitWebSocketChat();" style="margin-left: 20px;"><i class="k-icon k-i-undo"></i>退出</button>
								<button id="checkCompleteCustomerServiceChatWithMemberButton" uglcw-role="button" class="k-button k-primary" onclick="checkCompleteCustomerServiceChatWithMember();" style="margin-left: 20px;"><i class="k-icon k-i-search"></i>查看已完成的客服聊天</button>
							</div>
						</div>
					</div>
				</div>
			</div>
			<%--表格：头部end--%>

			<%--表格：start--%>
			<div class="layui-card">
				<div class="layui-card-body full">
					<div id="chatDiv">
						<!--未读消息会员列表-->
						<div id="checkMsgMemberListDiv">
							<dl class="checkMsgMemberListDl" id="checkMsgMemberListDl">
								<c:if test="${weiXinMsgMemberCount>0}">
									<c:forEach items="${weiXinMsgMemberList}" var="weiXinMsgMember" varStatus="s">
										<dd id="${weiXinMsgMember.openId}Dd" class="weiXinMsgMemberDd" onclick="memberChat(this.id,'${weiXinMsgMember.openId}')">
											<table class="checkMsgMemberTable" >
												<tr>
													<!--微信会员图片-->
													<td class="checkMsgMemberImageTd">
														<c:set var="openId" value="${weiXinMsgMember.openId}"></c:set>
														<!--微信会员消息未读消息数-->
														<!--无未读消息-->
														<c:if test="${shopMemberMsgMap[openId].memberMsgCount == 0}">
															<div class="memberNewMsgNo" id="${weiXinMsgMember.openId}memberNewMsgNoDiv">
																	${shopMemberMsgMap[openId].memberMsgCount}
															</div>
														</c:if>
														<!--有未读消息-->
														<c:if test="${shopMemberMsgMap[openId].memberMsgCount > 0}">
															<!--有客服-->
															<c:if test="${shopMemberMsgMap[openId].memberCustomerServiceCount > 0}">
																<!--当前客服是当前会员的客服-->
																<c:if test="${shopMemberMsgMap[openId].customerServiceId == customerServiceId }">
																	<c:if test="${shopMemberMsgMap[openId].memberCustomerServiceCount > 0}">
																		<div class="memberNewMsgNoShow" id="${weiXinMsgMember.openId}memberNewMsgNoDiv">
																				${shopMemberMsgMap[openId].memberMsgCount}
																		</div>
																	</c:if>
																</c:if>
															</c:if>
															<!--无客服-->
															<c:if test="${shopMemberMsgMap[openId].memberCustomerServiceCount == 0}">
																<div class="memberNewMsgNoShow" id="${weiXinMsgMember.openId}memberNewMsgNoDiv">
																		${shopMemberMsgMap[openId].memberMsgCount}
																</div>
															</c:if>
														</c:if>
														<input  type="image" id="${weiXinMsgMember.openId}Image" class="weixinImage" src="${weiXinMsgMember.pic}" height="40px" width="40px" />
													</td>
													<!--微信会员名称-->
													<td class="checkMsgMemberNameTd">
														<label class="name" id="${weiXinMsgMember.openId}memberName">
																${weiXinMsgMember.name}
														</label>
													</td>
													<!--客服图片-->
													<td class="customerServiceImageTd">
														<!--无客服-->
														<c:if test="${shopMemberMsgMap[openId].memberCustomerServiceCount == 0}">
															<div  id="${weiXinMsgMember.openId}customerServiceImageDiv" class="customerServiceImageDivHide">
																<input  type="image" id="${weiXinMsgMember.openId}customerServiceImage" class="customerServiceImage" src="resource/shop/weixin/images/customerService/customerService.png" height="36px" width="36px" />
															</div>
														</c:if>
														<!--单客服-->
														<c:if test="${shopMemberMsgMap[openId].memberCustomerServiceCount == 1}">
															<!--当前客服是当前会员的客服-->
															<c:if test="${shopMemberMsgMap[openId].customerServiceId == customerServiceId }">
																<div  id="${weiXinMsgMember.openId}customerServiceImageDiv">
																	<input  type="image" id="${weiXinMsgMember.openId}customerServiceImage" class="customerServiceImage greenBorder" src="resource/shop/weixin/images/customerService/customerService.png" height="36px" width="36px" />
																</div>
															</c:if>
															<!--当前客服不是当前会员的客服-->
															<c:if test="${shopMemberMsgMap[openId].customerServiceId != customerServiceId }">
																<div  id="${weiXinMsgMember.openId}customerServiceImageDiv">
																	<input  type="image" id="${weiXinMsgMember.openId}customerServiceImage" class="customerServiceImage redBorder" src="resource/shop/weixin/images/customerService/customerService.png" height="36px" width="36px" />
																</div>
															</c:if>
														</c:if>
														<!--多客服-->
														<c:if test="${shopMemberMsgMap[openId].memberCustomerServiceCount > 1}">
															<!--当前客服是当前会员的客服-->
															<c:if test="${shopMemberMsgMap[openId].customerServiceId == customerServiceId }">
																<div  id="${weiXinMsgMember.openId}customerServiceImageDiv">
																	<input  type="image" id="${weiXinMsgMember.openId}customerServiceImage" class="customerServiceImage yellowBorder" src="resource/shop/weixin/images/customerService/customerService.png" height="36px" width="36px" />
																</div>
															</c:if>
															<!--当前客服不是当前会员的客服-->
															<c:if test="${shopMemberMsgMap[openId].customerServiceId != customerServiceId }">
																<div  id="${weiXinMsgMember.openId}customerServiceImageDiv">
																	<input  type="image" id="${weiXinMsgMember.openId}customerServiceImage" class="customerServiceImage redBorder" src="resource/shop/weixin/images/customerService/customerService.png" height="36px" width="36px" />
																</div>
															</c:if>
														</c:if>
													</td>
													<!--客服名称和客服的平台id-->
													<td class="customerServiceNameTd">
														<!--客服名称-->
														<label class="customerServiceNameLabel" id="${weiXinMsgMember.openId}customerServiceName">
															<c:if test="${shopMemberMsgMap[openId].memberCustomerServiceCount > 0}">${shopMemberMsgMap[openId].customerServiceName}</c:if>
														</label>&nbsp&nbsp&nbsp
														<!--单客服-->
														<c:if test="${shopMemberMsgMap[openId].memberCustomerServiceCount <= 1}">
															<label class="multyCustomerServiceLabel" id="${weiXinMsgMember.openId}multyCustomerService">多客服</label>
														</c:if>
														<!--多客服-->
														<c:if test="${shopMemberMsgMap[openId].memberCustomerServiceCount > 1}">
															<label id="${weiXinMsgMember.openId}multyCustomerService">多客服</label>
														</c:if>
														<!--客服的平台id-->
														<label class="customerServiceIdLabel" id="${weiXinMsgMember.openId}customerServiceId">
															<c:if test="${shopMemberMsgMap[openId].memberCustomerServiceCount > 0}">${shopMemberMsgMap[openId].customerServiceId}</c:if>
														</label>
													</td>
												</tr>
											</table>
										</dd>
									</c:forEach>
								</c:if>
							</dl>
						</div>
						<!--未读消息窗口-->
						<div id="msgDiv">
						</div>


						<!--客服回复会员窗口-->
						<div id="responseMsgDiv" class="responseMsgDiv">
							<button  uglcw-role="button" class="k-button k-info" onclick="customerServiceChatWithCurrentMember();" style="margin-left: 20px;"><i class="k-icon ion-md-call"></i>&nbsp;接入聊天</button>
						</div>
						<!--客服申请聊天窗口-->
						<div id="requestChatDiv" class="requestChatDiv">
							<button  uglcw-role="button" class="k-button k-info" onclick="requestChatWithCurrentMember();" style="margin-left: 20px;"><i class="k-icon ion-md-call"></i>&nbsp;申请聊天</button>
						</div>
						<!--客服发送消息窗口-->
						<div id="sendTextMsgDiv" class="sendTextMsgDiv">
							<button  uglcw-role="button" class="k-button k-info" onclick="requestChangeCustomerService();" style="margin-left: 20px;"><i class="k-icon ion-md-call"></i>&nbsp;转接</button>
							<button  uglcw-role="button" class="k-button k-warning" onclick="quitCurrentMemberChat();" style="margin-left: 10px;"><i class="k-icon k-i-undo"></i>&nbsp;退出</button>
							<button  uglcw-role="button" class="k-button k-success" onclick="completeCurrentMemberChat();" style="margin-left: 10px;"><i class="k-icon k-i-check"></i>&nbsp;完成</button>
							<textarea uglcw-role="textbox" uglcw-model="sendMsgTextareea" id="sendMsgTextareea"  uglcw-validate="required" maxlength="500" uglcw-options="min: 1, max: 500" style="width:180px;height:200px;margin-left: 5px;margin-top: 60px;resize: none;"></textarea>
							<button  uglcw-role="button" class="k-button k-success" onclick="sendTextMsg();" style="text-align:center;margin-top: 60px;margin-left: 120px;width:100px;"><i class="k-icon k-i-check"></i>&nbsp;发送</button>
						</div>


					</div>
				</div>
			</div>
			<%--表格：end--%>
		</div>
		<%--2右边：表格end--%>
	</div>
</div>


<%--转接客服模板--%>
<script id="chooseRequestCustomerServiceDiv" type="text/x-uglcw-template">
	<div class="layui-col-md12">
		<div class="layui-card">
			<div class="layui-card-body">
				<input uglcw-role="textbox" uglcw-model="openIdKey" id="openIdKey" type="hidden">
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr height="20px">
					</tr>
					<tr>
						<div id="CustomerServiceDiv" class="CustomerServiceDiv">

						</div>
					</tr>
					<tr height="30px">
						<td>
							你选择客服是：<label id="requestCustomerServiceNameLabel"></label><label id="requestCustomerServiceIdLabel" class="requestCustomerServiceIdLabel"></label>
						</td>
					</tr>
					<tr height="40px">
						<td align="center" colspan="2">
							<button  uglcw-role="button" class="k-button k-success"
									 onclick="requestChangeCustomer();" style="margin-left: 20px;height: 30px;">
								<i class="k-icon ion-md-call"></i>&nbsp;申请</button>
							<button  uglcw-role="button" class="k-button k-error"
									 onclick="hideMsgWin();" style="margin-left: 20px;height: 30px;">
								<i class="k-icon k-i-close"></i>&nbsp;关闭</button>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</div>
</script>


<!--转接客服 选择在线客服模板-->
<script id="onlineCustomerServiceDiv" type="text/x-uglcw-template">
	<div class='onlineCustomerServiceDiv'>
		<!--客服名称-->
		客服:&nbsp;<label class='chooseCustomerServiceNameLabel'>#=data.memberNm#</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<!--客服手机号-->
		客服手机号:&nbsp;#=data.memberMobile#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<!--选择客服按钮-->
		<button uglcw-role="button" class='k-button k-info' onclick='setCustomerService("#=data.memberId#","#=data.memberNm#");'>选择</button>
	</div>
	<hr/>
</script>



<%--申请聊天客服模板--%>
<script id="chooseRequestCustomerServiceDiv_1" type="text/x-uglcw-template">
	<div class="layui-col-md12">
		<div class="layui-card">
			<div class="layui-card-body">
				<input uglcw-role="textbox" uglcw-model="openIdKey" id="openIdKey_1" type="hidden">
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr height="20px">
					</tr>
					<tr>
						<div id="CustomerServiceDiv_1" class="CustomerServiceDiv">

						</div>
					</tr>
					<tr height="30px">
						<td>
							你选择客服是：<label id="requestCustomerServiceNameLabel_1"></label><label id="requestCustomerServiceIdLabel_1" class="requestCustomerServiceIdLabel"></label>
						</td>
					</tr>
					<tr height="40px">
						<td align="center" colspan="2">
							<button  uglcw-role="button" class="k-button k-success"
									onclick="requestChangeCustomer_1();" style="margin-left: 20px;height: 30px;">
								<i class="k-icon ion-md-call"></i>&nbsp;申请</button>
							<button  uglcw-role="button" class="k-button k-error"
									 onclick="hideMsgWin_1();" style="margin-left: 20px;height: 30px;">
								<i class="k-icon k-i-close"></i>&nbsp;关闭</button>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</div>
</script>

<!-申请聊天客服 选择在线客服模板-->
<script id="onlineCustomerServiceDiv_1" type="text/x-uglcw-template">
	<div class='onlineCustomerServiceDiv'>
		<!--客服名称-->
		客服:&nbsp;<label class='chooseCustomerServiceNameLabel'>#=data.memberNm#</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<!--客服手机号-->
		客服手机号:&nbsp;#=data.memberMobile#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<!--选择客服按钮-->
		<button uglcw-role="button" class='k-button k-info' onclick='setCustomerService_1("#=data.memberId#","#=data.memberNm#");'>选择</button>
	</div>
	<hr/>
</script>

<%--<!--查看会员聊天图片消息的大图片窗口-->
<div id="bigImageDiv"  class="easyui-window" title="图片"
	 style="width: 600px;height: 400px;overflow: scroll"
	 minimizable="false" maximizable="false"  collapsible="false"
	 closed="true">
	<img  id="bigImage" alt=""/>
</div>--%>

<!--查看会员聊天图片消息的大图片模板-->
<script id="bigImageDivTemplate" type="text/x-uglcw-template">
	<div id="bigImageDiv" style="width: 600px;height: 400px;overflow: scroll">
		<img  id="bigImage" alt=""/>
	</div>
</script>



<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script type="text/javascript">
    var ddId="";//点击的会员的ddId
	var memberOpenId="";//点击的会员的openId
    var msgMemberOpenId="";//客服收到消息的会员的openId;
	var websocket=null;
	var hostName=location.hostname;
	var port=location.port;
	var protocol=location.protocol;
	var closeType="";//客服点击关闭按钮类型，quit:客服点击退出按钮

	if('WebSocket' in window){
		if(port==""){
		    if(protocol == "http:"){
                wsUrl="ws://"+hostName+"/weiXinChat/${wid}/${customerServiceId}/${customerServiceName}/${datasource}";
			}else{
                wsUrl="wss://"+hostName+"/weiXinChat/${wid}/${customerServiceId}/${customerServiceName}/${datasource}";
            }
		}else{
            if(protocol == "http:"){
                wsUrl="ws://"+hostName+":"+port+"/weiXinChat/${wid}/${customerServiceId}/${customerServiceName}/${datasource}";
            }else{
                wsUrl="wss://"+hostName+":"+port+"/weiXinChat/${wid}/${customerServiceId}/${customerServiceName}/${datasource}";
            }
        }
        websocket=new WebSocket(wsUrl);
	}else {
	    uglcw.ui.error("当前浏览器不支持websocket，无法与微信会员聊天，请升级浏览器!");
	}

	websocket.onerror=function () {
        uglcw.ui.error("websocket连接错误!");
    }

    websocket.onmessage=function (event) {
        var memberMsg=event.data;
        var memberMsgJson=JSON.parse(memberMsg);
        msgMemberOpenId=memberMsgJson.memberOpenId;
        var msgContentType=memberMsgJson.msgContentType;

        if(memberMsgJson.msgType == 0){//聊天消息
			if($("#"+msgMemberOpenId+"Dd").length>0){//聊天会员已经在客服聊天列表中
                <!--无客服-->
                if($("#"+msgMemberOpenId+"customerServiceId").html().trim()==""){
                    var memberMsgNo=$("#"+msgMemberOpenId+"memberNewMsgNoDiv").html().trim();
                    if(memberMsgNo=="" || memberMsgNo==0 ){
                        $("#"+msgMemberOpenId+"memberNewMsgNoDiv").html(1);
                        //显示未读消息背景
                        $("#"+msgMemberOpenId+"memberNewMsgNoDiv").show();
                    }else{
                        $("#"+msgMemberOpenId+"memberNewMsgNoDiv").html(parseInt(memberMsgNo)+1);
                    }
                    //发送聊天消息的会员是客服点击的当前会员
                    if(msgMemberOpenId == memberOpenId){
                        <!--显示会员消息div-->
                        var strs="<div  class='memberMsgDiv'>";
                        <!--会员的图片-->
                        strs+="<div id='memberImageDiv' class='memberImageDiv'>";
                        strs+="<input  type='image' class='image' src='"+$("#"+memberOpenId+"Image")[0].src+"' height='35px' width='35px' />";
                        strs+="</div>";
                        <!--会员聊天边框-->
                        strs+="<div class='memberChatBorderDiv'></div>";
                        <!--会员消息内容-->
						<!--文本消息-->
                        if(msgContentType == "text"){
                            strs+="<div class='memberMsgContentDiv'>"+memberMsgJson.memberMsg;
                            strs+="</div>";
                        }
                        <!--图片消息-->
                        if(msgContentType == "image"){
                            strs+="<div class='memberMsgContentDiv'>";
                            strs+="<input  type='image' id='"+memberMsgJson.msgId+"' class='image' src='"+"upload/"+memberMsgJson.memberMsg+"' onclick='toBigImage(\""+memberMsgJson.memberImageMsgBigImage+"\")'/>";
                            strs+="</div>";
                        }
                        strs+="<div class='clear' ></div>";
                        $("#msgDiv").append(strs);
                        $("#msgDiv")[0].scrollTop =$("#msgDiv")[0].scrollHeight;
                        $("#"+memberMsgJson.msgId).load(function(){
                            $("#msgDiv")[0].scrollTop =$("#msgDiv")[0].scrollHeight;
                        });

					}
				}else{<!--有客服-->
                    <!--更新会员离线消息数-->
                    if(msgMemberOpenId != memberOpenId){//发送聊天消息的会员不是客服聊天的当前会员
                        //当前会员的客服是当前客服
                        if($("#"+msgMemberOpenId+"customerServiceId").html().trim() == ${customerServiceId} ){
                            var memberMsgNo=$("#"+msgMemberOpenId+"memberNewMsgNoDiv").html().trim();
                            if(memberMsgNo=="" || memberMsgNo==0 ){
                                $("#"+msgMemberOpenId+"memberNewMsgNoDiv").html(1);
                                //显示未读消息背景
                                $("#"+msgMemberOpenId+"memberNewMsgNoDiv").show();
                            }else{
                                $("#"+msgMemberOpenId+"memberNewMsgNoDiv").html(parseInt(memberMsgNo)+1);
                            }
                        }
                    }else{//发送聊天消息的会员是客服聊天的当前会员
                        <!--显示会员消息div-->
                        var strs="<div  class='memberMsgDiv'>";
                        <!--会员的图片-->
                        strs+="<div id='memberImageDiv' class='memberImageDiv'>";
                        strs+="<input  type='image' class='image' src='"+$("#"+memberOpenId+"Image")[0].src+"' height='35px' width='35px' />";
                        strs+="</div>";
                        <!--会员聊天边框-->
                        strs+="<div class='memberChatBorderDiv'></div>";
                        <!--会员消息内容-->
                        <!--文本消息-->
                        if(msgContentType == "text"){
                            strs+="<div class='memberMsgContentDiv'>"+memberMsgJson.memberMsg;
                            strs+="</div>";
                        }
                        <!--图片消息-->
                        if(msgContentType == "image"){
                            strs+="<div class='memberMsgContentDiv'>";
                            strs+="<input  type='image' id='"+memberMsgJson.msgId+"' class='image' src='"+"upload/"+memberMsgJson.memberMsg+"' onclick='toBigImage("+memberMsgJson.memberImageMsgBigImage+")'/>";
                            strs+="</div>";
                        }
                        strs+="<div class='clear' ></div>";
                        $("#msgDiv").append(strs);
                        $("#msgDiv")[0].scrollTop =$("#msgDiv")[0].scrollHeight;
                        $("#"+memberMsgJson.msgId).load(function(){
                            $("#msgDiv")[0].scrollTop =$("#msgDiv")[0].scrollHeight;
                        });

                        //当前会员的客服是当前客服
                        if($("#"+msgMemberOpenId+"customerServiceId").html().trim() == ${customerServiceId} ){
                            //主客服设置当前会员的未读消息为已读
                            var updateMemberMsgIsReadTrue_url="/manager/weiXinChat/updateMemberMsgIsReadTrue";
                            $.ajax({
                                url:updateMemberMsgIsReadTrue_url,
                                data:{"memberOpenId":memberOpenId,"customerServiceId":"${customerServiceId}"},
                                type:"POST",
                                success:function(json) {
                                    if (json.state) {//更新未读消息数成功
                                    }else{
                                        uglcw.ui.success(json.msg);
                                    }
                                }
                            });
                        }else{//当前会员的客服不是当前客服
                            <!--更新会员离线消息数-->
                            if(msgMemberOpenId != memberOpenId){//发送聊天消息的会员不是客服聊天的当前会员
                                //当前会员的客服是当前客服
                                if($("#"+msgMemberOpenId+"customerServiceId").html().trim() == ${customerServiceId} ){
                                    var memberMsgNo=$("#"+msgMemberOpenId+"memberNewMsgNoDiv").html().trim();
                                    if(memberMsgNo=="" || memberMsgNo==0 ){
                                        $("#"+msgMemberOpenId+"memberNewMsgNoDiv").html(1);
                                        //显示未读消息背景
                                        $("#"+msgMemberOpenId+"memberNewMsgNoDiv").show();
                                    }else{
                                        $("#"+msgMemberOpenId+"memberNewMsgNoDiv").html(parseInt(memberMsgNo)+1);
                                    }
                                }
                       		 }
						}
					}
				}
			}else{//聊天会员不在客服聊天列表中
                //添加聊天会员到客服聊天列表中
                var strs="<dd id='"+msgMemberOpenId+"Dd' class='weiXinMsgMemberDd' onclick='memberChat("+msgMemberOpenId+"Dd,"+msgMemberOpenId+")'>";
                strs+= "<table class='checkMsgMemberTable' >";
                strs+="<tr>";
                <!--微信会员图片-->
                strs+="<td class='checkMsgMemberImageTd'>";
                <!--微信会员消息未读消息数-->
                strs+="<div class='memberNewMsgNo' id='"+msgMemberOpenId+"memberNewMsgNoDiv'>1</div>";
                strs+="<input  type='image' id='"+msgMemberOpenId+"Image' class='weixinImage' src='"+memberMsgJson.weixinUserImageUrl+"' height='40px' width='40px' />";
                strs+="</td>";
                <!--微信会员名称-->
                strs+="<td class='checkMsgMemberNameTd'>";
                strs+="<label class='name' id='"+msgMemberOpenId+"memberName'>"+memberMsgJson.weixinUserName+"</label>";
                strs+="</td>";
                <!--客服图片-->
                strs+="<td class='customerServiceImageTd'>";
                strs+="<div  id='"+msgMemberOpenId+"customerServiceImageDiv' class='customerServiceImageDivHide'>";
                strs+="<input  type='image' id='"+msgMemberOpenId+"customerServiceImage' class='customerServiceImage' src='resource/shop/weixin/images/customerService/customerService.png' height='36px' width='36px' />";
                strs+="</div>";
                strs+="</td>";
                <!--客服名称和客服的平台id-->
                strs+="<td class='customerServiceNameTd'>";
                strs+="<label class='customerServiceNameLabel' id='"+msgMemberOpenId+"customerServiceName'></label>&nbsp&nbsp&nbsp<label class='multyCustomerServiceLabel' id='"+msgMemberOpenId+"multyCustomerService'>多客服</label>";
                strs+="<label class='customerServiceIdLabel' id='"+msgMemberOpenId+"customerServiceId'></label>";
                strs+="</td>";
                strs+="</tr>";
                strs+="</table>";
                strs+="</dd>";
                $("#checkMsgMemberListDl").append(strs);
                $("#"+msgMemberOpenId+"Dd").click(function(){
                    memberChat(msgMemberOpenId+"Dd",msgMemberOpenId);
                });

            }
		}

        if(memberMsgJson.msgType == 1) {//平台消息,设置会员的接入聊天的在线客服图片边框颜色、客服名称、客服的平台id,
			//会员的聊天客服不是当前客服
			if(memberMsgJson.customerServiceId != ${customerServiceId}){
                //设置客服图片边框颜色为红色
				//$("#"+memberMsgJson.memberOpenId+"customerServiceImage").css("border","solid 2px #FA5151");
                //设置客服名称
                $("#"+memberMsgJson.memberOpenId+"customerServiceName").html(memberMsgJson.customerServiceName);
                //设置客服的平台id
                $("#"+memberMsgJson.memberOpenId+"customerServiceId").html(memberMsgJson.customerServiceId);
                //显示客服图片
                $("#"+memberMsgJson.memberOpenId+"customerServiceImageDiv").show();
						//客服点击的会员是平台消息相应的会员
                if(memberMsgJson.memberOpenId == memberOpenId){
                    $("#requestChatDiv").show();
                    $("#sendTextMsgDiv").hide();
                    $("#responseMsgDiv").hide();
                }
			}

        }

        if(memberMsgJson.msgType == 2) {//平台消息,设置退出聊天的客服的会员无客服

            //无客服
            if(memberMsgJson.customerServiceCount==0){
                //会员的聊天客服不是当前客服
                if(memberMsgJson.customerServiceId != ${customerServiceId}){
                    //设置客服图片为无边框
                    $("#"+memberMsgJson.memberOpenId+"customerServiceImage").css("border","");
                    //设置当前会员无客服
                    $("#"+memberMsgJson.memberOpenId+"customerServiceName").html("");
                    //设置当前会员无客服的平台id
                    $("#"+memberMsgJson.memberOpenId+"customerServiceId").html("");
                    //设置无客服图片
                    $("#"+memberMsgJson.memberOpenId+"customerServiceImageDiv").hide();
                    //设置"多客服"文字为无提示
                    $("#"+memberMsgJson.memberOpenId+"multyCustomerService").hide();
                }
                if(memberMsgJson.memberOpenId == memberOpenId){//客服点击的会员是平台消息相应的会员
                    $("#requestChatDiv").hide();
                    $("#sendTextMsgDiv").hide();
                    $("#responseMsgDiv").show();
                }
            }

            //单客服
            if(memberMsgJson.customerServiceCount==1){
                //会员的聊天客服不是当前客服
                if(memberMsgJson.customerServiceId != ${customerServiceId}){
                    //设置客服图片为无边框
                    $("#"+memberMsgJson.memberOpenId+"customerServiceImage").css("border","");
                    //设置当前会员无客服
                    $("#"+memberMsgJson.memberOpenId+"customerServiceName").html("");
                    //设置当前会员无客服的平台id
                    $("#"+memberMsgJson.memberOpenId+"customerServiceId").html("");
                    //设置无客服图片
                    $("#"+memberMsgJson.memberOpenId+"customerServiceImageDiv").hide();
                    //设置"多客服"文字为无提示
                    $("#"+memberMsgJson.memberOpenId+"multyCustomerService").hide();
                }
                if(memberMsgJson.memberOpenId == memberOpenId){//客服点击的会员是平台消息相应的会员
                    $("#requestChatDiv").hide();
                    $("#sendTextMsgDiv").hide();
                    $("#responseMsgDiv").show();
                }
            }

        }

        if(memberMsgJson.msgType == 3) {//平台消息,公司客服向当前会员的聊天客服申请与当前会员聊天
            //会员的聊天客服是当前客服
            if(memberMsgJson.customerServiceId == ${customerServiceId}){
                $.messager.confirm('提示框', '公司客服申请与当前会员聊天，你同意吗?',function(data){
                    if(data){//同意公司客服申请与当前会员聊天
                        var confirmRequestChatWithCurrentMember_url="/manager/weiXinChat/confirmRequestChatWithCurrentMember";
                        $.ajax({
                            url:confirmRequestChatWithCurrentMember_url,
                            async:false,
                            data:{"memberOpenId":memberMsgJson.memberOpenId,
                                  "memberName":memberMsgJson.memberName,
							      "customerServiceId":memberMsgJson.customerServiceId,
								  "customerServiceName":memberMsgJson.customerServiceName,
								  "requestCustomerServiceId":memberMsgJson.requestCustomerServiceId,
								  "requestCustomerServiceName":memberMsgJson.requestCustomerServiceName},
                            type:"post",
                            success:function(json){
                                if(json.state==1){
                                    //已经同意公司客服申请文当前会员的聊天客服！
                                    uglcw.ui.success(json.msg);
                                    // 设置客服图片边框颜色为黄色、多客服
                       //             $("#"+json.memberOpenId+"customerServiceImage").css("border","solid 2px #FFEE4C");
                                   /* //设置客服名称
                                    $("#"+json.memberOpenId+"customerServiceName").html(json.customerServiceName);
                                    //设置客服的平台id
                                    $("#"+json.memberOpenId+"customerServiceId").html(json.customerServiceId);*/
                                    //显示多客服
                                    $("#"+memberMsgJson.memberOpenId+"multyCustomerService").show();
								}else{
                                    if(json.state==0){
                                        uglcw.ui.error(json.msg);
                                    }else{
                                        uglcw.ui.error(json.msg);
                                    }
								}

                            }
                        })
                    }else{//不同意公司客服申请与当前会员聊天
                        var sendWebSocketMsgToCustomerService_url="/manager/weiXinChat/sendWebSocketMsgToCustomerService";
                        $.ajax({
                            url:sendWebSocketMsgToCustomerService_url,
                            async:false,
                            data:{"customerServiceId":memberMsgJson.requestCustomerServiceId,"msg":"客服拒绝了你与当前会员聊天的申请！"},
                            type:"post",
                            success:function(json){
                                if(json.state==0){
                                    uglcw.ui.success(json.msg);
                                }else{
                                    uglcw.ui.error(json.msg);
                                }
                   			 }
               			 })
           			 }
				})
   			 }
		}

        if(memberMsgJson.msgType == 4) {//平台消息,向公司的在线客服发送websocket消息
            //申请与会员聊天的在线客服是当前客服
            if(memberMsgJson.customerServiceId == ${customerServiceId}){
                uglcw.ui.success(memberMsgJson.msg);
            }
        }

        if(memberMsgJson.msgType == 5) {//平台消息,更新申请成为当前会员的聊天客服的图片框框的颜色和客服名称
            //申请成为当前会员的聊天客服是当前客服
            if(memberMsgJson.customerServiceId == ${customerServiceId}){
                //设置客服图片边框颜色为黄色多客服
    //            $("#"+memberMsgJson.memberOpenId+"customerServiceImage").css("border","solid 2px #FFEE4C");
                //设置客服名称
                $("#"+memberMsgJson.memberOpenId+"customerServiceName").html(memberMsgJson.customerServiceName);
                //设置客服的平台id
                $("#"+memberMsgJson.memberOpenId+"customerServiceId").html(memberMsgJson.customerServiceId);
                //显示多客服
                $("#"+memberMsgJson.memberOpenId+"multyCustomerService").show();
            }
        }

        if(memberMsgJson.msgType == 6) {//平台消息,清空当前会员的聊天客服的未读消息数
            // 申请成为当前会员的聊天客服不是当前客服
            if(memberMsgJson.customerServiceId != ${customerServiceId}){
                //清空未读消息数
                $("#"+memberMsgJson.memberOpenId+"memberNewMsgNoDiv").html("");
                //设置未读消息无背景颜色
                $("#"+memberMsgJson.memberOpenId+"memberNewMsgNoDiv").hide();
            }
        }

        if(memberMsgJson.msgType == 7) {//平台消息,会员客服向当前客服申请转接在线客服
            if(memberMsgJson.requestCustomerServiceId == ${customerServiceId}){
                $.messager.confirm('提示框', '公司客服向你申请转接客服与会员聊天，你同意吗?',function(data){
                    if(data){//当前客服同意成为转接客服
                        var confirmRequesetChangeOnlineCustomerService_url="/manager/weiXinChat/confirmRequesetChangeOnlineCustomerService";
                        $.ajax({
                            url:confirmRequesetChangeOnlineCustomerService_url,
                            async:false,
                            data:{"memberOpenId":memberMsgJson.memberOpenId,
                                "memberName":memberMsgJson.memberName,
                                "customerServiceId":memberMsgJson.customerServiceId,
                                "customerServiceName":memberMsgJson.customerServiceName,
                                "requestCustomerServiceId":memberMsgJson.requestCustomerServiceId,
                                "requestCustomerServiceName":memberMsgJson.requestCustomerServiceName},
                            type:"post",
                            success:function(json){
                                if(json.state==1){
                                    //已经同意公司客服申请文当前会员的聊天客服！
                                    uglcw.ui.success(json.msg);
                                    //设置客服图片边框颜色为绿色
             //                       $("#"+json.memberOpenId+"customerServiceImage").css("border","solid 2px #9EEA6A");
                                    //设置客服名称
                                    $("#"+json.memberOpenId+"customerServiceName").html(json.customerServiceName);
                                    //设置客服的平台id
                                    $("#"+json.memberOpenId+"customerServiceId").html(json.customerServiceId);
                                }else{
                                    if(json.state==0){
                                        uglcw.ui.success(json.msg);
                                    }else{
                                        uglcw.ui.error(json.msg);
                                    }
                                }

                            }
                        })
                    }else{//不当前客服同意成为转接客服
                        var sendWebSocketMsgToCustomerService_url="/manager/weiXinChat/sendWebSocketMsgToCustomerService";
                        $.ajax({
                            url:sendWebSocketMsgToCustomerService_url,
                            async:false,
                            data:{"customerServiceId":memberMsgJson.customerServiceId,"msg":"客服拒绝成为转接客服！"},
                            type:"post",
                            success:function(json){
                                if(json.state==0){
                                    uglcw.ui.success(json.msg);
                                }else{
                                    uglcw.ui.error(json.msg);
                                }
                            }
                        })
                    }
                })
            }

            if(memberMsgJson.customerServiceId != ${customerServiceId}){
                //清空未读消息数
                $("#"+memberMsgJson.memberOpenId+"memberNewMsgNoDiv").html("");
                //设置未读消息无背景颜色
                $("#"+memberMsgJson.memberOpenId+"memberNewMsgNoDiv").hide();
            }
        }

        if(memberMsgJson.msgType == 8) {//平台消息,审批转接客服
            // 申请转接客服的聊天客服是当前客服
            if(memberMsgJson.customerServiceId == ${customerServiceId}){
                //设置客服图片边框颜色为红色
          //      $("#"+memberMsgJson.memberOpenId+"customerServiceImage").css("border","solid 2px #FA5151");
                //设置客服名称
                $("#"+memberMsgJson.memberOpenId+"customerServiceName").html(memberMsgJson.requestCustomerServiceName);
                //设置客服的平台id
                $("#"+memberMsgJson.memberOpenId+"customerServiceId").html(memberMsgJson.requestCustomerServiceId);
            }
        }

        if(memberMsgJson.msgType == 9) {//平台消息,会员客服向当前客服申请聊天客服
            if(memberMsgJson.requestCustomerServiceId == ${customerServiceId}){
                $.messager.confirm('提示框', '公司客服向你申请聊天客服与会员聊天，你同意吗?',function(data){
                    if(data){//当前客服同意成为聊天客服
                        var confirmRequesetChatCustomerService_url="/manager/weiXinChat/confirmRequesetChatCustomerService";
                        $.ajax({
                            url:confirmRequesetChatCustomerService_url,
                            async:false,
                            data:{"memberOpenId":memberMsgJson.memberOpenId,
                                "memberName":memberMsgJson.memberName,
                                "customerServiceId":memberMsgJson.customerServiceId,
                                "customerServiceName":memberMsgJson.customerServiceName,
                                "requestCustomerServiceId":memberMsgJson.requestCustomerServiceId,
                                "requestCustomerServiceName":memberMsgJson.requestCustomerServiceName},
                            type:"post",
                            success:function(json){
                                if(json.state==1){
                                    //已经同意公司客服申请文当前会员的聊天客服！
                                    uglcw.ui.success(json.msg);
                                    //设置客服图片边框颜色为黄色
                 //                   $("#"+json.memberOpenId+"customerServiceImage").css("border","solid 2px #FFEE4C");
                                    //设置客服名称
                                    $("#"+json.memberOpenId+"customerServiceName").html(json.customerServiceName);
                                    //设置客服的平台id
                                    $("#"+json.memberOpenId+"customerServiceId").html(json.customerServiceId);
                                }else{
                                    if(json.state==0){
                                        uglcw.ui.success(json.msg);
                                    }else{
                                        uglcw.ui.error(json.msg);
                                    }
                                }

                            }
                        })
                    }else{//不同意当前客服成为聊天客服
                        var sendWebSocketMsgToCustomerService_url="/manager/weiXinChat/sendWebSocketMsgToCustomerService";
                        $.ajax({
                            url:sendWebSocketMsgToCustomerService_url,
                            async:false,
                            data:{"customerServiceId":memberMsgJson.customerServiceId,"msg":"客服拒绝成为聊天客服！"},
                            type:"post",
                            success:function(json){
                                if(json.state==0){
                                    uglcw.ui.success(json.msg);
                                }else{
                                    uglcw.ui.error(json.msg);
                                }
                            }
                        })
                    }
                })
            }

            if(memberMsgJson.customerServiceId != ${customerServiceId}){
                //清空未读消息数
                $("#"+memberMsgJson.memberOpenId+"memberNewMsgNoDiv").html("");
                //设置未读消息无背景颜色
                $("#"+memberMsgJson.memberOpenId+"memberNewMsgNoDiv").hide();
            }
        }

        if(memberMsgJson.msgType == 10) {//平台消息,审批聊天客服
            // 申请转接客服的聊天客服是当前客服
                if(memberMsgJson.customerServiceId == ${customerServiceId}){
                //设置客服图片边框颜色为黄色
    //            $("#"+memberMsgJson.memberOpenId+"customerServiceImage").css("border","solid 2px #FFEE4C");
                //设置客服名称
                $("#"+memberMsgJson.memberOpenId+"customerServiceName").html(memberMsgJson.customerServiceName);
                //设置客服的平台id
                $("#"+memberMsgJson.memberOpenId+"customerServiceId").html(memberMsgJson.customerServiceId);
                //显示多客服
                $("#"+memberMsgJson.memberOpenId+"multyCustomerService").show();
            }
        }

        if(memberMsgJson.msgType == 11) {//平台消息,公司其他客服收到多客服发送的消息
			if(memberOpenId !="" && memberOpenId == memberMsgJson.memberOpenId){//多客服发送的消息的会员为当前客服点击的会员
                //回复成功,回复消息显示在对话框
                $("#sendMsgTextareea").val("");
                <!--客服消息窗口-->
                var strs="<div class='customerServiceMsgDiv'>";
                <!--客服名称-->
                strs+="<div class='customerServiceNameDiv'>";
                strs+=" 客服：<br/>"+memberMsgJson.customerServiceName;
                strs+=" </div>";
                <!--客服聊天边框-->
                strs+="<div class='customerServiceChatBorderDiv'>";
                strs+="</div>";
                <!--客服消息内容-->
                strs+="<div class='customerServiceMsgContentDiv'>"+memberMsgJson.memberMsg;
                strs+="</div>";
                strs+=" <div class='clear' ></div>";
                strs+=" </div>";
                $("#msgDiv").append(strs);
                $("#msgDiv")[0].scrollTop =$("#msgDiv")[0].scrollHeight;
            }
        }

        if(memberMsgJson.msgType == 12) {//平台消息,设置完成聊天的会员从聊天列表中删除
            //会员的聊天客服不是当前客服
            if(memberMsgJson.customerServiceId != ${customerServiceId}){
                //设置无客服图片
                $("#"+memberMsgJson.memberOpenId+"customerServiceImageDiv").hide();
                //设置客服图片为无边框
                $("#"+memberMsgJson.memberOpenId+"customerServiceImage").css("border","");
                //设置当前会员无客服
                $("#"+memberMsgJson.memberOpenId+"customerServiceName").html("已完成聊天");
                //设置当前会员无客服的平台id
                $("#"+memberMsgJson.memberOpenId+"customerServiceId").html("");
            }
            //客服点击聊天的会员不是完成聊天的会员，设置完成聊天的会员从聊天列表中删除
			if( memberOpenId !=  memberMsgJson.memberOpenId){
                $("#"+memberMsgJson.memberOpenId+"Dd").remove();
            }
        }


	}





    websocket.onopen=function () {
	    var jq=top.jQuery;
        jq('#weixinMsgChatWebSocketState').html("连接成功");
    }
    websocket.onclose=function () {
        var jq=top.jQuery;
        jq('#weixinMsgChatWebSocketState').html("连接关闭");
    }
    window.onbeforeunload=function () {
	    websocket.close();
	}

    $(function () {
        //ui:初始化
        uglcw.ui.init();
        resize();
        $(window).resize(resize);
        uglcw.ui.loaded();
    })

    var delay;
    function resize() {
        if (delay) {
            clearTimeout(delay);
        }
        delay = setTimeout(function () {
            var padding = 15;
            var height = $(window).height() - padding - $('.header').height() - 40;
            $("#chatDiv").css("height",height);
        }, 200)
    }


    $(function(){
        //发送字数验证
      //  $.formValidator.initConfig();
        checkMsgWordCount();

       var jq = top.jQuery;
       /* jq('#mainTab').tabs({
           "onBeforeClose":function(title,index){

               if(title == "客服聊天"){
                   websocket.close();//关闭websocket
                   jq('#weixinMsgChatWebSocketState').html(",连接关闭");

                   if(closeType == "quit"){
                       closeType="";
				   }else{
                       // 客服关闭tab批量退出与会员的聊天
                       closeTabExitWebSocketChat();
				   }
			   }
            }
		});*/


		//选择聊天窗口tab
     //   jq('#mainTab').tabs('select','客服聊天');
    });

    function msgSenderFormatter(val,row){
        var name=$("#name").val();
        if(val==memberOpenId){
            return name;
        }else{
            return "客服 "+val+":";
        }
    }

    // 退出
    function exitWebSocketChat(){
        var jq = top.jQuery;
        //批量保存客服退出操作消息到数据库
        //批量退出当前客服与会员的聊天
        var multiAddCustomerServiceQuitStateMsg_url="/manager/weiXinChat/multiAddCustomerServiceQuitStateMsg";
        $.ajax({
            url:multiAddCustomerServiceQuitStateMsg_url,
            data:{"customerServiceName":"${customerServiceName}","customerServiceId":"${customerServiceId}"},
            type:"POST",
            success:function(json) {
                 if (json.state) {//保存客服的操作状态成功
                    //退出聊天
                    var quitCurrentCustomerServiceChat_url="/manager/weiXinChat/quitCurrentCustomerServiceChat";
                    $.ajax({
                        url:quitCurrentCustomerServiceChat_url,
                        async:false,
                        data:{"customerServiceId":"${customerServiceId}"},
                        type:"POST",
                        success:function(json) {
                            console.log(json);
                            if (json.state == 1) {
                                //退出当前会员聊天成功
                                uglcw.ui.success(json.msg);
                                closeType="quit";
                               /* jq("#mainTab").tabs("close","客服聊天");//关闭客服聊天窗口*/
                                uglcw.ui.closeCurrentTab();//关闭当前页
                            } else {
                                if(json.state == 0){
                                    uglcw.ui.success(json.msg);
                                      closeType="quit";
                                   /* jq("#mainTab").tabs("close","客服聊天");//关闭客服聊天窗口*/
                                    uglcw.ui.closeCurrentTab();//关闭当前页
                                }else{
                                    if(json.state == 2){
                                        uglcw.ui.success(json.msg);
                                        closeType="quit";
                                        /*jq("#mainTab").tabs("close","客服聊天");//关闭客服聊天窗口*/
                                        uglcw.ui.closeCurrentTab();//关闭当前页
                                    }else{
                                        closeType="quit";
                                       /* jq("#mainTab").tabs("close","客服聊天");//关闭客服聊天窗口*/
                                        uglcw.ui.closeCurrentTab();//关闭当前页
                                    }
                                }
                            }
                        }
                    });
                }else{
                     uglcw.ui.error(json.msg);
                     closeType="quit";
                    /* jq("#mainTab").tabs("close","客服聊天");//关闭客服聊天窗口*/
                     uglcw.ui.closeCurrentTab();//关闭当前页
                }
            }
        });
    }

    // 客服关闭tab批量退出与会员的聊天
    function  closeTabExitWebSocketChat(){
        //批量保存客服退出操作消息到数据库
        //批量退出当前客服与会员的聊天
        var multiAddCustomerServiceQuitStateMsg_url="/manager/weiXinChat/multiAddCustomerServiceQuitStateMsg";
        $.ajax({
            url:multiAddCustomerServiceQuitStateMsg_url,
            data:{"customerServiceName":"${customerServiceName}","customerServiceId":"${customerServiceId}"},
            type:"POST",
			async:false,
            success:function(json) {
                if (json.state) {//保存客服的操作状态成功
                    //退出聊天
                    var quitCurrentCustomerServiceChat_url="/manager/weiXinChat/quitCurrentCustomerServiceChat";
                    $.ajax({
                        url:quitCurrentCustomerServiceChat_url,
                        async:false,
                        data:{"customerServiceId":"${customerServiceId}"},
                        type:"POST",
                        success:function(json) {
                            console.log(json);
                            if (json.state == 1) {
                                //退出当前会员聊天成功
                                uglcw.ui.success(json.msg);
                            } else {
                                if(json.state == 0){
                                    uglcw.ui.error(json.msg);
                                }else{
                                    if(json.state == 2){
                                        uglcw.ui.error(json.msg);
                                    }else{
                                    }
                                }
                            }
                        }
                    });
                }else{
                    uglcw.ui.error(json.msg);
                }
            }
        });
    }

    //客服与会员聊天
    function memberChat(id,openId){
        memberOpenId=openId;
        //设置背景颜色
        if(id != ddId)
        {
            $("#"+id).css("background-color","#C0BFBF");
            if(ddId != ""){
                $("#"+ddId).css("background-color","");
            }
            ddId=id;
        }

        //未读聊天消息
		//查找这个公众号的openID的未读聊天消息
		var checkMemberMsg_url="/manager/checkMemberChatMsg";
        $.ajax({
            url:checkMemberMsg_url,
            data:{"openId":openId},
            type:"post",
            success:function(json){
                console.log(json);
                if(json.state){
                    $("#msgDiv").empty();
                    if(json.weiXinMemberChatMsgCount>0){
                        var memberMsgList=json.weiXinMemberChatMsgList;
                        for(var i=0;i<json.weiXinMemberChatMsgCount;i++){
                            //发送消息的时间
                            var strs="<div  class='msgTimeDiv'>";
                            <!--发送消息的时间-->
                            strs+="<label class='msgTimeLabel'>";
                            strs+=""+memberMsgList[i].msgTime+"";
                            strs+="</label>";
                            strs+="</div>";
                            $("#msgDiv").append(strs);
                            //会员消息
							if(memberMsgList[i].msgId>0 && memberMsgList[i].fromUserName==openId){
                                <!--会员消息div-->
                                var strs="<div  class='memberMsgDiv'>";
                                <!--会员的图片-->
                                strs+="<div id='memberImageDiv' class='memberImageDiv'>";
                                strs+="<input  type='image' class='image' src='"+$("#"+openId+"Image")[0].src+"' height='35px' width='35px' />";
                                strs+="</div>";
                                <!--会员聊天边框-->
                                strs+="<div class='memberChatBorderDiv'></div>";
                                <!--会员消息内容-->
                                <!--文本消息-->
                                if(memberMsgList[i].msgType == "" || memberMsgList[i].msgType == "text"){
                                    strs+="<div class='memberMsgContentDiv'>"+memberMsgList[i].content;
                                    strs+="</div>";
                                }
                                <!--图片消息-->
                                if(memberMsgList[i].msgType == "image"){
                                    strs+="<div class='memberMsgContentDiv'>";
                                    strs+="<input  type='image' id='"+memberMsgList[i].msgId+"' class='image' src='"+"upload/"+memberMsgList[i].picMini+"' onclick='toBigImage(\""+memberMsgList[i].content+"\")'/>";
                                    strs+="</div>";
                                }
                                strs+="<div class='clear' ></div>";
                                $("#msgDiv").append(strs);
                                $("#"+memberMsgList[i].msgId).load(function(){
                                    $("#msgDiv")[0].scrollTop =$("#msgDiv")[0].scrollHeight;
                                });
							}
							//客服消息
							if(memberMsgList[i].msgId==0 && memberMsgList[i].toUserName==openId){
                                <!--客服消息窗口-->
                                var strs="<div class='customerServiceMsgDiv'>";
                                <!--客服名称-->
                                strs+="<div class='customerServiceNameDiv'>";
                                strs+=" 客服：<br/>"+memberMsgList[i].fromUserName;
                                strs+=" </div>";
                                <!--客服聊天边框-->
                                strs+="<div class='customerServiceChatBorderDiv'>";
                                strs+="</div>";
                                <!--客服消息内容-->
                                strs+="<div class='customerServiceMsgContentDiv'>"+memberMsgList[i].content;
                                strs+="</div>";
                                strs+=" <div class='clear' ></div>";
                                strs+=" </div>";
                                $("#msgDiv").append(strs);
							}
						}
                        $("#msgDiv")[0].scrollTop =$("#msgDiv")[0].scrollHeight;
					}
                }else{
                    uglcw.ui.error("查找未读聊天消息失败");
                }
            }
        });



        //主客服设置当前会员的未读消息为已读
		if($("#"+memberOpenId+"customerServiceId").html().trim() == "${customerServiceId}"){//当前客服是当前会员的主客服
           if( $("#"+memberOpenId+"memberNewMsgNoDiv").html().trim() != "" ){//有未读消息
               var updateMemberMsgIsReadTrue_url="/manager/weiXinChat/updateMemberMsgIsReadTrue";
               $.ajax({
                   url:updateMemberMsgIsReadTrue_url,
                   data:{"memberOpenId":memberOpenId,"customerServiceId":"${customerServiceId}"},
                   type:"POST",
                   success:function(json) {
                       if (json.state) {//更新未读消息数成功
                           //清空未读消息数
                           $("#"+memberOpenId+"memberNewMsgNoDiv").html("");
                           //设置未读消息无背景颜色
                           $("#"+memberOpenId+"memberNewMsgNoDiv").hide();
                       }else{
                           uglcw.ui.error(json.msg);
                       }
                   }
               });
           }
        }

		//显示会员对应的客服窗口
		if($("#"+memberOpenId+"customerServiceId").html().trim() == ""){//无客服
            $("#requestChatDiv").hide();
            $("#sendTextMsgDiv").hide();
			$("#responseMsgDiv").show();//显示客服聊天按钮窗口
        }else{
		    if($("#"+memberOpenId+"customerServiceId").html().trim() == "${customerServiceId}"){//会员的聊天客服是当前客服
                $("#requestChatDiv").hide();
                $("#sendTextMsgDiv").show();//显示客服聊天发送消息窗口
                $("#responseMsgDiv").hide();
            }else{//会员的聊天客服不是当前客服
                $("#requestChatDiv").show();//显示客服申请聊天窗口
                $("#sendTextMsgDiv").hide();
                $("#responseMsgDiv").hide();
            }
        }



    }



    //客服回复会员未读信息聊天
	function customerServiceChatWithCurrentMember(){
        //查询当前微信会员的客服聊天
        if($("#"+memberOpenId+"customerServiceName").html().trim() == ""){
            var checkCurrentCustomerServiceChat_url="/manager/weiXinChat/checkCurrentCustomerServiceChat";
            $.ajax({
                url:checkCurrentCustomerServiceChat_url,
                data:{"openId":memberOpenId,"memberName":$("#"+memberOpenId+"memberName").html().trim()},
                type:"GET",
                async:false,
                success:function(json) {
                    if (json.state) {
                        if(json.isCurrentCustomerService){//是当前客服
                            // 设置客服图片边框颜色为绿色
                            // $("#"+memberOpenId+"customerServiceImage").css("border","solid 2px #9EEA6A");
                            // 设置客服名称
                            // $("#"+memberOpenId+"customerServiceName").html("${customerServiceName}");
                            $("#"+memberOpenId+"customerServiceName").html(json.CustomerServiceName);
                            // 设置客服的平台id
                            $("#"+memberOpenId+"customerServiceId").html(json.CustomerServiceId);
                            // 显示客服回复消息div
                            $("#requestChatDiv").hide();
                            $("#sendTextMsgDiv").show();
                            $("#responseMsgDiv").hide();//显示客服聊天按钮窗口
                            $("#"+memberOpenId+"customerServiceImageDiv").show();//显示客服图片

                        }else{// 不是当前客服
                            // 设置客服图片边框颜色为红色
                            // $("#"+memberOpenId+"customerServiceImage").css("border","solid 2px #FA5151");
                            // 设置客服名称CustomerServiceName
                            $("#"+memberOpenId+"customerServiceName").html(json.CustomerServiceName);
                            //设置客服的平台id
                            $("#"+memberOpenId+"customerServiceId").html(json.CustomerServiceId);
                        }

                    }else{
                        uglcw.ui.error("查询当前微信会员的客服聊天失败");
                    }
                }
            });

			//无客服设置当前会员的未读消息为已读
			if( $("#"+memberOpenId+"memberNewMsgNoDiv").html().trim() != "" ){//有未读消息
				var updateMemberMsgIsReadTrue_url="/manager/weiXinChat/updateMemberMsgIsReadTrue";
				$.ajax({
					url:updateMemberMsgIsReadTrue_url,
					data:{"memberOpenId":memberOpenId,"customerServiceId":"${customerServiceId}"},
					type:"POST",
					success:function(json) {
						if (json.state) {//更新未读消息数成功
							//清空未读消息数
							$("#"+memberOpenId+"memberNewMsgNoDiv").html("");
							//设置未读消息无背景颜色
							$("#"+memberOpenId+"memberNewMsgNoDiv").hide();
						}else{
                            uglcw.ui.error(json.msg);
						}
					}
				});
			}

			//保存客服操作状态消息到数据库，并发送到聊天窗口
            var addCustomerServiceStateMsg_url="/manager/weiXinChat/addCustomerServiceStateMsg";
            $.ajax({
                url:addCustomerServiceStateMsg_url,
                data:{"CustomerServiceName":"${customerServiceName}","memberOpenId":memberOpenId,"CustomerServiceState":1},
                type:"POST",
                success:function(json) {
                    if (json.state) {//保存客服的操作状态成功
                        <!--消息窗口发送客服消息-->
                        <!--发送消息的时间-->
                        var strs="<div  class='msgTimeDiv'>";
                        strs+="<label class='msgTimeLabel'>";
                        strs+=""+json.CustomerServiceStateMsgTime+"";
                        strs+="</label>";
                        strs+="</div>";
                        $("#msgDiv").append(strs);
						<!--客服消息窗口-->
                        var strs="<div class='customerServiceMsgDiv'>";
                        <!--客服名称-->
                        strs+="<div class='customerServiceNameDiv'>";
                        strs+=" 客服：<br/>"+json.CustomerServiceName;
                        strs+=" </div>";
                        <!--客服聊天边框-->
                        strs+="<div class='customerServiceChatBorderDiv'>";
                        strs+="</div>";
                        <!--客服消息内容-->
                        strs+="<div class='customerServiceMsgContentDiv'>"+json.CustomerServiceStateMsg;
                        strs+="</div>";
                        strs+=" <div class='clear' ></div>";
                        strs+=" </div>";
                        $("#msgDiv").append(strs);
                        $("#msgDiv")[0].scrollTop =$("#msgDiv")[0].scrollHeight;
                    }else{
                        uglcw.ui.error(json.msg);
                    }
                }
            });



        }


	}



    //发送字数验证
    function checkMsgWordCount(){
      //  $("#sendMsgTextareea").formValidator({onShow:"500个字以内",onFocus:"500个字以内",onCorrect:"通过"}).inputValidator({max:1000,onError:"500个字以内"});
    }

    //发送文本消息
    function sendTextMsg(){
        if(memberOpenId==""){
            uglcw.ui.error("没有选择会员!");
            return;
		}
        if($("#sendMsgTextareea").val().trim()==""){
            uglcw.ui.error("发送的消息不能为空!");
            return;
		}

            var textMsg=$("#sendMsgTextareea").val();
            websocket.send(textMsg);//发送websocket消息
            var textMsg_url="/manager/sendCustomerTextMsg";
            $.ajax({
                url:textMsg_url,
                async:false,
                data:{"sendTextMsg":1,"textMsg":textMsg,"openId":memberOpenId,"customerServiceId":"${customerServiceId}","customerServiceName":"${customerServiceName}"},
                type:"post",
                success:function(json){
                    if(json.errcode=="0"){
                        //回复成功,回复消息显示在对话框
                        $("#sendMsgTextareea").val("");
                        <!--客服消息窗口-->
                        var strs="<div class='customerServiceMsgDiv'>";
                        <!--客服名称-->
                        strs+="<div class='customerServiceNameDiv'>";
                        strs+=" 客服：<br/>${customerServiceName}";
                        strs+=" </div>";
                        <!--客服聊天边框-->
                        strs+="<div class='customerServiceChatBorderDiv'>";
                        strs+="</div>";
                        <!--客服消息内容-->
                        strs+="<div class='customerServiceMsgContentDiv'>"+textMsg;
                        strs+="</div>";
                        strs+=" <div class='clear' ></div>";
                        strs+=" </div>";
                        $("#msgDiv").append(strs);
                        $("#msgDiv")[0].scrollTop =$("#msgDiv")[0].scrollHeight;
                    }else{
                        if(json.errcode=="45047"){
                            uglcw.ui.error("回复失败! 已经发送20条消息！ 客户应答后才可以再发送消息！ ");
                        }else{
                            console.log(json);
                            uglcw.ui.error("回复失败!"+" json.errcode:"+json.errcode+" ,json.errmsg:"+json.errmsg);
                        }
                    }
                }
            });
    }

    //退出当前会员的聊天
	function quitCurrentMemberChat(){
		if(memberOpenId ==""){
            uglcw.ui.error("没有选择会员！");
		}else{
		    if($("#"+memberOpenId+"customerServiceId").html().trim() == ""){
                uglcw.ui.error("当前会员没有客服！");
			}else{
		        if($("#"+memberOpenId+"customerServiceId").html().trim() == "${customerServiceId}"){//当前会员的客服是当前客服

                    //保存客服操作状态消息到数据库，并发送到聊天窗口
                    var addCustomerServiceStateMsg_url="/manager/weiXinChat/addCustomerServiceStateMsg";
                    $.ajax({
                        url:addCustomerServiceStateMsg_url,
                        data:{"CustomerServiceName":"${customerServiceName}","memberOpenId":memberOpenId,"CustomerServiceState":4},
                        type:"POST",
                        success:function(json) {
                            if (json.state) {//保存客服的操作状态成功
                                <!--消息窗口发送客服消息-->
                                <!--发送消息的时间-->
                                var strs="<div  class='msgTimeDiv'>";
                                strs+="<label class='msgTimeLabel'>";
                                strs+=""+json.CustomerServiceStateMsgTime+"";
                                strs+="</label>";
                                strs+="</div>";
                                $("#msgDiv").append(strs);
                                <!--客服消息窗口-->
                                var strs="<div class='customerServiceMsgDiv'>";
                                <!--客服名称-->
                                strs+="<div class='customerServiceNameDiv'>";
                                strs+=" 客服：<br/>"+json.CustomerServiceName;
                                strs+=" </div>";
                                <!--客服聊天边框-->
                                strs+="<div class='customerServiceChatBorderDiv'>";
                                strs+="</div>";
                                <!--客服消息内容-->
                                strs+="<div class='customerServiceMsgContentDiv'>"+json.CustomerServiceStateMsg;
                                strs+="</div>";
                                strs+=" <div class='clear' ></div>";
                                strs+=" </div>";
                                $("#msgDiv").append(strs);
                                $("#msgDiv")[0].scrollTop =$("#msgDiv")[0].scrollHeight;
                            }else{
                                uglcw.ui.error(json.msg);
                            }
                        }
                    });

					//退出聊天
					var quitMemberChat_url="/manager/weiXinChat/quitCurrentMemberChat";
                    $.ajax({
                        url:quitMemberChat_url,
                        async:false,
                        data:{"openId":memberOpenId,"customerServiceId":"${customerServiceId}"},
                        type:"post",
                        success:function(json) {
                            console.log(json);
                            if (json.state == 1) {
                                //退出当前会员聊天成功
                                uglcw.ui.success(json.msg);
                                //设置无客服图片
                                $("#"+memberOpenId+"customerServiceImageDiv").hide();
                                //设置客服图片为无边框
                                $("#"+memberOpenId+"customerServiceImage").css("border","");
                                //设置当前会员无客服
                                $("#"+memberOpenId+"customerServiceName").html("");
                                //设置当前会员无客服的平台id
                                $("#"+memberOpenId+"customerServiceId").html("");
                                //显示接入聊天窗口
                                $("#requestChatDiv").hide();
                                $("#sendTextMsgDiv").hide();
                                $("#responseMsgDiv").show();
                            } else {
                                if(json.state == 0){
                                    uglcw.ui.success(json.msg);
                                }else{
                                    uglcw.ui.error(json.msg);
                                }
                            }
                        }
					});
				}else{//当前会员的客服不是当前客服
                    uglcw.ui.error("你不是当前会员的客服！");
                }
			}
		}
	}

	//完成当前会员的聊天
    function completeCurrentMemberChat(){
        if(memberOpenId ==""){
            uglcw.ui.error("没有选择聊天会员！");
        }else{
            if($("#"+memberOpenId+"customerServiceId").html().trim() == ""){
                uglcw.ui.error("当前会员没有客服！");
            }else{
                if($("#"+memberOpenId+"customerServiceId").html().trim() == "${customerServiceId}"){//当前会员的客服是当前客服

                    //保存客服操作状态消息到数据库，并发送到聊天窗口
                    var addCustomerServiceStateMsg_url="/manager/weiXinChat/addCustomerServiceStateMsg";
                    $.ajax({
                        url:addCustomerServiceStateMsg_url,
                        data:{"CustomerServiceName":"${customerServiceName}","memberOpenId":memberOpenId,"CustomerServiceState":5},
                        type:"POST",
                        success:function(json) {
                            if (json.state) {//保存客服的操作状态成功
                                <!--消息窗口发送客服消息-->
                                <!--发送消息的时间-->
                                var strs="<div  class='msgTimeDiv'>";
                                strs+="<label class='msgTimeLabel'>";
                                strs+=""+json.CustomerServiceStateMsgTime+"";
                                strs+="</label>";
                                strs+="</div>";
                                $("#msgDiv").append(strs);
                                <!--客服消息窗口-->
                                var strs="<div class='customerServiceMsgDiv'>";
                                <!--客服名称-->
                                strs+="<div class='customerServiceNameDiv'>";
                                strs+=" 客服：<br/>"+json.CustomerServiceName;
                                strs+=" </div>";
                                <!--客服聊天边框-->
                                strs+="<div class='customerServiceChatBorderDiv'>";
                                strs+="</div>";
                                <!--客服消息内容-->
                                strs+="<div class='customerServiceMsgContentDiv'>"+json.CustomerServiceStateMsg;
                                strs+="</div>";
                                strs+=" <div class='clear' ></div>";
                                strs+=" </div>";
                                $("#msgDiv").append(strs);
                                $("#msgDiv")[0].scrollTop =$("#msgDiv")[0].scrollHeight;
                                $("#msgDiv").empty();//清空消息
                            }else{
                                uglcw.ui.error(json.msg);
                            }
                        }
                    });

                    //完成聊天
                    var completeMemberChat_url="/manager/weiXinChat/completeCurrentMemberChat";
                    $.ajax({
                        url:completeMemberChat_url,
                        async:false,
                        data:{"openId":memberOpenId,"customerServiceId":"${customerServiceId}"},
                        type:"post",
                        success:function(json) {
                            console.log(json);
                            if (json.state == 1) {
                                //完成当前会员聊天成功
                                uglcw.ui.success(json.msg);
                                //设置客服图片为无边框
                                $("#"+memberOpenId+"customerServiceImage").css("border","");
                                //设置当前会员无客服
                                $("#"+memberOpenId+"customerServiceName").html("");
                                //设置当前会员无客服的平台id
                                $("#"+memberOpenId+"customerServiceId").html("");
                            } else {
                                if(json.state == 0){
                                    uglcw.ui.success(json.msg);
                                }else{
                                    uglcw.ui.error(json.msg);
                                }
                            }
                        }
                    });
                }else{//当前会员的客服不是当前客服
                    uglcw.ui.error("你不是当前会员的客服！");
                }
            }
        }

        // 完成聊天的会员从聊天列表中删除
		$("#"+memberOpenId+"Dd").remove();
        $("#requestChatDiv").hide();
        $("#sendTextMsgDiv").hide();
        $("#responseMsgDiv").hide();

	}

	//申请与当前会员聊天
	function requestChatWithCurrentMember() {
        if(memberOpenId ==""){
            uglcw.ui.error("没有选择聊天会员！");
        }else {
            if ($("#" + memberOpenId + "customerServiceId").html().trim() == "") {
                uglcw.ui.error("当前会员没有客服！");
            }else{
                if($("#"+memberOpenId+"customerServiceId").html().trim() == "${customerServiceId}") {//当前会员的客服是当前客服
                    uglcw.ui.error("你已经是当前会员的客服！");
                }else{//当前会员的客服不是当前客服

                    //保存客服操作状态消息到数据库，并发送到聊天窗口
                    var addCustomerServiceStateMsg_url="/manager/weiXinChat/addCustomerServiceStateMsg";
                    $.ajax({
                        url:addCustomerServiceStateMsg_url,
                        data:{"CustomerServiceName":"${customerServiceName}","memberOpenId":memberOpenId,"CustomerServiceState":2},
                        type:"POST",
                        success:function(json) {
                            if (json.state) {//保存客服的操作状态成功
                                <!--消息窗口发送客服消息-->
                                <!--发送消息的时间-->
                                var strs="<div  class='msgTimeDiv'>";
                                strs+="<label class='msgTimeLabel'>";
                                strs+=""+json.CustomerServiceStateMsgTime+"";
                                strs+="</label>";
                                strs+="</div>";
                                $("#msgDiv").append(strs);
                                <!--客服消息窗口-->
                                var strs="<div class='customerServiceMsgDiv'>";
                                <!--客服名称-->
                                strs+="<div class='customerServiceNameDiv'>";
                                strs+=" 客服：<br/>"+json.CustomerServiceName;
                                strs+=" </div>";
                                <!--客服聊天边框-->
                                strs+="<div class='customerServiceChatBorderDiv'>";
                                strs+="</div>";
                                <!--客服消息内容-->
                                strs+="<div class='customerServiceMsgContentDiv'>"+json.CustomerServiceStateMsg;
                                strs+="</div>";
                                strs+=" <div class='clear' ></div>";
                                strs+=" </div>";
                                $("#msgDiv").append(strs);
                                $("#msgDiv")[0].scrollTop =$("#msgDiv")[0].scrollHeight;
                            }else{
                                uglcw.ui.error(json.msg);
                            }
                        }
                    });

                    //向当前会员的聊天会员申请为当前会员的聊天客服
                    var requestChatWithCurrentMember_url="/manager/weiXinChat/requestChatWithCurrentMember";
                    $.ajax({
                        url:requestChatWithCurrentMember_url,
                        async:false,
                        data:{"openId":memberOpenId,"currentCustomerServiceId":$("#"+memberOpenId+"customerServiceId").html().trim(),"requestCustomerServiceId":"${customerServiceId}","requestCustomerServiceName":"${customerServiceName}"},
                        type:"post",
                        success:function(json) {
                            if (json.state == 1) {
                                // 单客服，已经申请与当前会员聊天
                                uglcw.ui.error(json.msg);
                            } else {
                                if(json.state == 2){//多客服,选择申请客服
                                    //申请聊天客服
                                    uglcw.ui.error(json.msg);
                                    uglcw.ui.Modal.open({
										title:'申请聊天客服',
                                        area: ['600px','420px'],
                                        content: $('#chooseRequestCustomerServiceDiv_1').html(),
                                        success: function (container) {
                                            uglcw.ui.init($(container));
                                            uglcw.ui.bind($(container).find('form'));
                                        },
										btns:[],
                                    })
                                    $("#CustomerServiceDiv_1").empty();//清空在线客服
                                    $("#requestCustomerServiceNameLabel_1").html("");//清空已选择客服
                                  //  showMsgWin_1("选择客服");//显示选择客服窗口
                                    var customerServiceList=json.customerServiceList;
                                    console.log("customerServiceList:"+customerServiceList);
                                    $.each(customerServiceList,function(n,value) {
                                        if(value.memberId != "${customerServiceId}"){//当前在线客服不是当前会员客服
                                            var html = uglcw.util.template($('#onlineCustomerServiceDiv_1').html())({
                                                memberNm: value.memberNm,
                                                memberMobile:value.memberMobile,
                                                memberId:value.memberId,
                                            });
                                           $("#CustomerServiceDiv_1").append(html);
                                        }
                                    });
                                }else{
                                    uglcw.ui.error(json.msg);
                                }
                            }
                        }
                    });
                }
			}
        }
    }



    //申请当前会员转接客服
    function requestChangeCustomerService() {
        if(memberOpenId ==""){
            uglcw.ui.error("没有选择聊天会员！");
        }else {
            if ($("#" + memberOpenId + "customerServiceId").html().trim() == "") {
                uglcw.ui.error("当前会员没有客服！");
            }else{
                if($("#"+memberOpenId+"customerServiceId").html().trim() != "${customerServiceId}") {//当前会员的客服不是当前客服
                    uglcw.ui.error("你不是当前会员的客服！");
                }else{//当前会员的客服是当前客服

                    //保存客服操作状态消息到数据库，并发送到聊天窗口
                    var addCustomerServiceStateMsg_url="/manager/weiXinChat/addCustomerServiceStateMsg";
                    $.ajax({
                        url:addCustomerServiceStateMsg_url,
                        data:{"CustomerServiceName":"${customerServiceName}","memberOpenId":memberOpenId,"CustomerServiceState":3},
                        type:"POST",
                        success:function(json) {
                            if (json.state) {//保存客服的操作状态成功
                                <!--消息窗口发送客服消息-->
                                <!--发送消息的时间-->
                                var strs="<div  class='msgTimeDiv'>";
                                strs+="<label class='msgTimeLabel'>";
                                strs+=""+json.CustomerServiceStateMsgTime+"";
                                strs+="</label>";
                                strs+="</div>";
                                $("#msgDiv").append(strs);
                                <!--客服消息窗口-->
                                var strs="<div class='customerServiceMsgDiv'>";
                                <!--客服名称-->
                                strs+="<div class='customerServiceNameDiv'>";
                                strs+=" 客服：<br/>"+json.CustomerServiceName;
                                strs+=" </div>";
                                <!--客服聊天边框-->
                                strs+="<div class='customerServiceChatBorderDiv'>";
                                strs+="</div>";
                                <!--客服消息内容-->
                                strs+="<div class='customerServiceMsgContentDiv'>"+json.CustomerServiceStateMsg;
                                strs+="</div>";
                                strs+=" <div class='clear' ></div>";
                                strs+=" </div>";
                                $("#msgDiv").append(strs);
                                $("#msgDiv")[0].scrollTop =$("#msgDiv")[0].scrollHeight;
                            }else{
                                uglcw.ui.error(json.msg);
                            }
                        }
                    });

					//查询公司在线客服
                    var queryOnlineCustomerService_url="/manager/weiXinChat/queryOnlineCustomerService";
                    $.ajax({
                        url:queryOnlineCustomerService_url,
                        async:false,
                        data:{},
                        type:"get",
                        success:function(json) {
                            if (json.state == 1) {//公司有其他在线客服!
                                //申请转接客服
                                uglcw.ui.error(json.msg);
                                uglcw.ui.Modal.open({
                                    title:'申请转接客服',
                                    area: ['600px','420px'],
                                    content: $('#chooseRequestCustomerServiceDiv').html(),
                                    success: function (container) {
                                        uglcw.ui.init($(container));
                                        uglcw.ui.bind($(container).find('form'));
                                    },
                                    btns:[],
                                })
                                $("#CustomerServiceDiv").empty();//清空在线客服
                                $("#requestCustomerServiceNameLabel").html("");//清空已选择客服
                                /*showMsgWin("选择客服");//显示选择客服窗口*/
								var customerServiceList=json.customerServiceList;
								console.log("customerServiceList:"+customerServiceList);
                                $.each(customerServiceList,function(n,value) {
                                    if(value.memberId != "${customerServiceId}"){//当前在线客服不是当前会员客服
                                       /* var strs="<div  class='onlineCustomerServiceDiv'>";
                                        <!--客服名称-->;
                                        strs+="客服:&nbsp"+"<label class='chooseCustomerServiceNameLabel'>"+value.memberNm+"</label>";
                                        strs+="&nbsp&nbsp&nbsp&nbsp&nbsp"
                                        <!--客服手机号-->;
                                        strs+="客服手机号:&nbsp"+value.memberMobile;
                                        strs+="&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp"
                                        <!--选择客服按钮-->;
                                        strs+="<input type='button' class='chooseCustomerServiceButton' value='选择'  onclick='setCustomerService("+value.memberId+",\""+value.memberNm+"\")'></input>";*/

                                        var html = uglcw.util.template($('#onlineCustomerServiceDiv').html())({
                                            memberNm: value.memberNm,
                                            memberMobile:value.memberMobile,
                                            memberId:value.memberId,
                                        });

                                        $("#CustomerServiceDiv").append(html);
									}
                                });
                                /*  //添加公司其他的在线客服
								var strs="<div  class='onlineCustomerServiceDiv'>";
								<!--客服的id-->
								strs+="<div id='memberImageDiv' class='memberImageDiv'>";
								strs+="</div>";
								<!--客服的name-->;
								strs+="<div class='clear' ></div>";


								$("#chooseRequestCustomerServiceDiv").append(strs);*/

                            } else {
                                if(json.state == 0){//公司没有其他在线客服!
                                    uglcw.ui.success(json.msg);
                                }else{
                                    uglcw.ui.error(json.msg);//查询公司在线客服出错！
                                }
                            }
                        }
                    });

                }
            }
        }
    }

    //显示角色框
    function showMsgWin(title){
        $("#chooseRequestCustomerServiceDiv").window({title:title,modal:true});
        $("#chooseRequestCustomerServiceDiv").window('open');
    }
    //申请客服聊天，显示角色框
    function showMsgWin_1(title){
        $("#chooseRequestCustomerServiceDiv_1").window({title:title,modal:true});
        $("#chooseRequestCustomerServiceDiv_1").window('open');
    }
    function hideMsgWin(){
        $("#requestCustomerServiceNameLabel").html("");
        $("#requestCustomerServiceIdLabel").html("");
        /*$("#chooseRequestCustomerServiceDiv").window('close');*/
        uglcw.ui.Modal.close();
    }
    function hideMsgWin_1(){
        $("#requestCustomerServiceNameLabel_1").html("");
        $("#requestCustomerServiceIdLabel_1").html("");
        /*$("#chooseRequestCustomerServiceDiv_1").window('close');*/
        uglcw.ui.Modal.close();
    }
    
    //选择客服按钮
	function setCustomerService(memberId,memberNm) {
        $("#requestCustomerServiceNameLabel").html(memberNm);//设置已选择客服
        $("#requestCustomerServiceIdLabel").html(memberId);//设置已选择客服
    }

    //申请聊天客服，选择客服按钮
    function setCustomerService_1(memberId,memberNm) {
        $("#requestCustomerServiceNameLabel_1").html(memberNm);//设置已选择客服
        $("#requestCustomerServiceIdLabel_1").html(memberId);//设置已选择客服
    }
    
    // 申请转接客服
	function requestChangeCustomer() {
        if($("#requestCustomerServiceIdLabel").html().trim() == ""){
            uglcw.ui.error("请选择客服！");
		}else{
            // 申请转接客服
			var requesetChangeOnlineCustomerService_url="/manager/weiXinChat/requesetChangeOnlineCustomerService";
            $.ajax({
                url:requesetChangeOnlineCustomerService_url,
                async:false,
                data:{"openId":memberOpenId,
					"memberName":$("#"+memberOpenId+"memberName").html().trim(),
					"currentCustomerServiceId":$("#"+memberOpenId+"customerServiceId").html().trim(),
					"customerServiceName":$("#"+memberOpenId+"customerServiceName").html().trim(),
					"requestCustomerServiceId":$("#requestCustomerServiceIdLabel").html().trim(),
					"requestCustomerServiceName":$("#requestCustomerServiceNameLabel").html().trim()},
                type:"post",
                success:function(json) {
                    if (json.state == 1) {
                        //已经申请与当前会员聊天
                        uglcw.ui.error(json.msg);
                    } else {
                        if(json.state == 0){
                            uglcw.ui.success(json.msg);
                        }else{
                            uglcw.ui.error(json.msg);
                        }
                    }
                }
            });
		}
    }

    /*//申请当前会员转接客服
    function requestChangeCustomerService() {
        if(memberOpenId ==""){
            alert("没有选择聊天会员！");
        }else {
            if ($("#" + memberOpenId + "customerServiceId").html().trim() == "") {
                alert("当前会员没有客服！");
            }else{
                if($("#"+memberOpenId+"customerServiceId").html().trim()== "${customerServiceId}") {//当前会员的客服是当前客服
                    //申请当前会员转接客服
                }else{//当前会员的客服不是当前客服
                    alert("你不是当前会员的客服！");
                }
            }
        }
    }*/

    // 申请聊天客服
    function requestChangeCustomer_1() {
        if($("#requestCustomerServiceIdLabel_1").html().trim() == ""){
            uglcw.ui.error("请选择客服！");
        }else{
            // 申请聊天客服
            var requesetChatCustomerService_url="/manager/weiXinChat/requesetChatCustomerService";
            $.ajax({
                url:requesetChatCustomerService_url,
                async:false,
                data:{"openId":memberOpenId,
                    "memberName":$("#"+memberOpenId+"memberName").html().trim(),
                    "currentCustomerServiceId":"${customerServiceId}",
                    "customerServiceName":"${customerServiceName}",
                    "requestCustomerServiceId":$("#requestCustomerServiceIdLabel_1").html().trim(),
                    "requestCustomerServiceName":$("#requestCustomerServiceNameLabel_1").html().trim()},
                type:"post",
                success:function(json) {
                    if (json.state == 1) {
                        //已经申请聊天客服
                        uglcw.ui.error(json.msg);
                    } else {
                        if(json.state == 0){
                            uglcw.ui.success(json.msg);
                        }else{
                            uglcw.ui.error(json.msg);
                        }
                    }
                }
            });
        }
    }
    
    //查看已完成的客服聊天
	function checkCompleteCustomerServiceChatWithMember() {
       // window.parent.add('已完成聊天','${base}/manager/weiXinChat/checkCompleteCustomerServiceChatWithMember');
        uglcw.ui.openTab('已完成聊天', '${base}/manager/weiXinChat/checkCompleteCustomerServiceChatWithMember');
	}
	
	//查询客服聊天报表
	function queryCustomerServiceChatWithMemberRpt() {
        window.parent.add('客服聊天报表','${base}/manager/weiXinChat/queryCustomerServiceChatWithMemberRpt');
    }

    //显示大图
    function toBigImage(bigImage) {
        uglcw.ui.Modal.open({
            title:'图片',
            area: ['600px','400px'],
            content: $('#bigImageDivTemplate').html(),
            success: function (container) {
                uglcw.ui.init($(container));
                uglcw.ui.bind($(container).find('form'));
            },
            btns:[],
        })
        $("#bigImage").attr("src","upload/"+bigImage);
       /* $("#bigImageDiv").window("open");*/
    }


</script>

<script>
	$(function(){
		uglcw.io.on('im.message', function(message){
			uglcw.ui.notice({
				title: '新的消息',
				message: message.data.content,
				audio: 1,
				timeout: 1000
			})
		})
		uglcw.io.on('im.ack', function(ack){
			uglcw.ui.success(ack)
		})
	})
</script>
</body>
</html>
