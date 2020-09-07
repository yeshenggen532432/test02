<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>用户管理</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="<%=request.getContextPath()%>/resource/WdatePicker.js"></script>
		<link rel="stylesheet" type="text/css" href="resource/css/tab.css">
		<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
		<script type="text/javascript" src="resource/area_zh.js"></script>
		<style type="text/css">
			.btnor {
				width: 80px;
				height: 25px;
			}
			span{
				font-size: 10px;
			}
			.bt{
				font-size: 10px;
			}
			.reds{
				color: red;
				font-size: 10px;
			}
		</style>
	</head>
	<body style="background-color: #f7f8fa;">
			<div style="background-color: #f7f8fa; width: 100%; height: 100%;">
				<div style="text-align: center; margin-top: 10px;">
					<input type="hidden" name="taskId" id="taskId" value="${taskId }"/>
					<input type="hidden" name="percent" id="percent" value="${percent }"/>
					<input type="hidden" name="title" id="title" value="${title }"/>
					<table cellspacing="5px" class="table" id="tb1">
						<tr>
							<td colspan="4" class="cen">
								进度详情
							</td>
						</tr>
						<c:if test="${empty list}">
							<tr>
								<td colspan="4" align="center">
									暂无进度详情
								</td>
							</tr>
						</c:if>
						<c:if test="${!empty list}">
							<tr>
								<td width="20%" rowspan="${fn:length(feed.atts)+1}" >
									进度值:
								</td>
								<td width="30%">
									创建时间:
								</td>
								<td width="30%">
									描述:
								</td>
							</tr>
						<c:forEach items="${list}" var="feed">
							<tr>
								<td width="20%">
									${feed.persent}%
								</td>
								<td width="30%">
									${feed.dtDate }
								</td>
								<td width="30%" colspan="3">
									${feed.remarks}
								</td>
							</tr>
							<c:forEach items="${feed.atts}" var="att" varStatus="i">
								<tr>
								<c:if test="${i.index==0}">
								<td rowspan="2">
									附件
								</td>
								</c:if>
								<td>
									${att.attachName }
								</td>
								<td>
									<a href="manager/download?path=${att.attacthPath }&filename=${att.attachName }">下载</a>
								</td>
								</tr>
							</c:forEach>
							<tr></tr>
							<tr>
								<td class="cen" colspan="4" style="height: 20px;">
								  &nbsp;
								</td>
							</tr>
						</c:forEach>
						</c:if>
						<!--<c:if test="${userId eq psnId}">-->
							<c:if test="${percent<100}">
								<tr align="center">
									<td colspan="6">
										<a class="easyui-linkbutton" href="javascript:addFeed();" id="bc" ><span style="font-size: 12px;">添加任务反馈</span></a>&nbsp;&nbsp;&nbsp;
									</td>
								</tr>
							</c:if>
						<!--</c:if>-->
					</table>
				</div>
			</div>
			<!-- 任务反馈弹窗 -->
			<div id="feedWindow" class="easyui-window" style="width:800px;height:400px;"
				minimizable="false" maximizable="false" collapsible="false" closed="true" modal="true">
				<iframe name="windowfeedifrm" id="windowfeedifrm" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
			</div>
	</body>
	<script type="text/javascript">
		//添加任务反馈
		function addFeed(){
			var userId = "${userId}";
			var psnId = "${psnId}";
			if(userId!=psnId){
				alert("不是执行人，不能添加反馈");
				return;
			}
			showFeedWindow("增加任务反馈");
			var taskId = $("#taskId").val();
			var percent = $("#percent").val();
			document.getElementById("windowfeedifrm").src="<%=request.getContextPath()%>/manager/toAddFeed?taskId="+taskId+"&percent="+percent;
		}
		//显示弹出窗口
		function showFeedWindow(title){
			$("#feedWindow").window({
				title:title,
				top:getScrollTop()+50
			});
			$("#feedWindow").window('open');
		}
		function closeFeedWindow(persent){
			$("#percent").val(persent);
			$("#feedWindow").window('close');
			window.location.reload();
		}
	</script>
</html>
