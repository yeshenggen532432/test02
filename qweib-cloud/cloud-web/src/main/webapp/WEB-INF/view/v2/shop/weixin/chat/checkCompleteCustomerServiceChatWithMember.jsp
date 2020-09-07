<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<title>微信会员已完成聊天</title>
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
								<button  uglcw-role="button" class="k-button k-primary" onclick="exitWebSocketChat();" style="margin-left: 20px;"><i class="k-icon k-i-undo"></i>退出</button>
								<button  uglcw-role="button" class="k-button k-primary" onclick="refreshTab();" style="margin-left: 20px;"><i class="k-icon k-i-refresh"></i>刷新</button>
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

					</div>
				</div>
			</div>
			<%--表格：end--%>
		</div>
		<%--2右边：表格end--%>
	</div>
</div>


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

    function msgSenderFormatter(val,row){
        var name=$("#name").val();
        if(val==memberOpenId){
            return name;
        }else{
            return "客服 "+val+":";
        }
    }

    // 返回
    function exitWebSocketChat(){
        uglcw.ui.closeCurrentTab();//关闭当前页
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
                                strs+="<div class='memberMsgContentDiv'>"+memberMsgList[i].content;
                                strs+="</div>";
                                strs+="<div class='clear' ></div>";
                                $("#msgDiv").append(strs);
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
                    alert("查找未读聊天消息失败");
                }
            }
        });



    }

function refreshTab() {
    /*var jq = top.jQuery;
	 var tab = jq('#mainTab').tabs('getSelected');
	 tab.panel('refresh');*/
    uglcw.ui.reload();
}

</script>
</body>
</html>
