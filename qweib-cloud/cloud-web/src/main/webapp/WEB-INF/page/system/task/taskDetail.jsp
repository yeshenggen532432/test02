<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>任务详情</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="<%=request.getContextPath()%>/resource/WdatePicker.js"></script>
		<link rel="stylesheet" type="text/css" href="resource/css/tab.css">
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
		
	<script type="text/javascript">
		function delatt(id){
			$.ajax({
				url:"manager/deltaskatt",
				data:"id="+id,
				type:"post",
				success:function(json){
					if(json=="1"){
						alert("删除成功");
						window.location.reload();
					}else{
						alert("删除失败");
					}
				}
			});
		}
	
		//验证图片
		var js=1;
		var exeyz = true;
		function yzimg(){
			var flag = true;
			exeyz = true;
			for(var i=0;i<js;i++){
				var imgName = document.getElementById("img"+i).value;
				if(imgName==""){
					flag=false;
					continue;
				}
				imgName = imgName.substring(imgName.length-4,imgName.leng);
				if(imgName == ".exe"){
					$("#file_error").show();
					flag=false;
					exeyz =false;
				}else{
					$("#file_error").hide();
				}
			}
			if(flag){
				$("<input type=\"file\" name=\"file"+js+"\" id=\"img"+js+"\" class=\"btnor\" style=\"width: 450px;margin-top: 5px;\" onchange=\"yzimg()\">").appendTo($("#files"));
				js++;
			}
		}
		
		var num3 = new RegExp("^[1-9]\\d*$");
		function save(){
			var remind1 = $("#remind1").val();
			var remind2 = $("#remind2").val();
			var remind3 = $("#remind3").val();
			var remind4 = $("#remind4").val();
			if(!num3.test(remind1)){
				$("#tx1").show();
				return;
			}else{
				if(remind1>100){
					$("#tx1").show();
					return;
				}
				$("#tx1").hide();
			}
			if(!num3.test(remind2)){
				$("#tx2").show();
				return;
			}else{
				if(remind2>100){
					$("#tx2").show();
					return;
				}
				$("#tx2").hide();
			}
			if(!num3.test(remind3)){
				$("#tx3").show();
				return;
			}else{
				if(remind3>100){
					$("#tx3").show();
					return;
				}
				$("#tx3").hide();
			}
			if(!num3.test(remind4)){
				$("#tx4").show();
				return;
			}else{
				if(remind4>100){
					$("#tx4").show();
					return;
				}
				$("#tx4").hide();
			}
			if(exeyz==false){
				return;
			}
			$('#dd').dialog('open');
			$('#myform').form('submit', {
				success:function(data){
					$('#dd').dialog('close');
					if(data=="1"){
						alert("修改成功");
						window.location.reload();
					}else{
						alert("修改失败");
					}
				}
			});
		}
		//清空责任人
		function resetMem(val){
			if(val=="1"){
				$("#zreIds").val("");
				$("#zreNames").text("");
			}else if(val=="2"){
				$("#gzrIds").val("");
				$("#gzrNames").text("");
			}else{
				$("#parentId").val("");
				$("#parentName").text("");
			}
		}
		//选择人员
		var memtype = 0;
		function addMem(val){
			memtype=val;
			var taskId = '${task.id}';
			if(val=="1"){
				showWindow("选择负责人");
				document.getElementById("windowifrm").src="<%=request.getContextPath()%>/manager/totaskmem";
			}else if(val=="2"){
				showWindow("选择关注人");
				document.getElementById("windowifrm").src="<%=request.getContextPath()%>/manager/totaskmem";
			}else{
				showWindow("选择所属父任务");
				document.getElementById("windowifrm").src="<%=request.getContextPath()%>/manager/toTaskParent?taskId="+taskId;
			}
		}
		//设置人员
		function setMem(id,name){
			if(memtype=="1"){
				var ids = $("#zreIds").val();
				if(ids==""){
					$("#zreIds").val(id);
				}else{
					$("#zreIds").val(ids + ","+id);
				}
				var names = $("#zreNames").text();
				if(names==""){
					$("#zreNames").text(name);
				}else{
					$("#zreNames").text(names+","+name);
				}	
			}else if(memtype=="2"){
				var ids = $("#gzrIds").val();
				if(ids==""){
					$("#gzrIds").val(id);
				}else{
					$("#gzrIds").val(ids + ","+id);
				}
				var names = $("#gzrNames").text();
				if(names==""){
					$("#gzrNames").text(name);
				}else{
					$("#gzrNames").text(names+","+name);
				}
			}else{
				$("#parentId").val(id);
				$("#parentName").text(name);
			}
			$("#choiceWindow").window('close');
		}
		//显示弹出窗口
		function showWindow(title){
			$("#choiceWindow").window({
				title:title,
				top:getScrollTop()+50
			});
			$("#choiceWindow").window('open');
		}
		//后退
		function toback(){
			location.href="querymerchant.do";
		}
	</script>
	</head>
	<body style="background-color: #f7f8fa;">
		<div id="dd" class="easyui-dialog" title="" style="width:200px;height:70px;margin: 0 auto;text-align: center;"   
		    closed="true"    data-options="iconCls:'icon-save',resizable:true,modal:true">   
		     <table style="margin: 0 auto;">
		     	<tr>
		     		<td><img src="resource/img/loading.gif" style="margin-top: 10px;"></td>
		     		<td><div style="margin:0 auto;margin-top: 10px;">正在保存中，请稍后...</div></td>
		     	</tr>
		     </table>
		</div>
		<form action="manager/savetask" method="post" id="myform"
			enctype="multipart/form-data">
			<div style="background-color: #f7f8fa; width: 100%; height: 100%;">
				<div style="text-align: center; margin-top: 10px;">
					<table cellspacing="5px" class="table" id="tb1" style="height: 400px;">
						<tr>
							<td colspan="4" class="cen">
								${task.taskTitle }详情
								<input type="hidden" name="id" id="id" value="${task.id }" />
							</td>
						</tr>
						<tr>
							<td width="20%">
								标题：
							</td>
							<td width="35%">
								${task.taskTitle }
							</td>
							<td width="20%">
								任务状态：
							</td>
							<td width="35%">
									${task.status=="1"?"完成":(task.status=="2"?"未完成":"草稿")}
							</td>
						</tr>
						<tr>
							<td width="20%">
								开始时间：
							</td>
							<td width="35%">
							${task.startTime}
							</td>
							<td width="20%">
								结束时间时间：
							</td>
							<td width="35%">
							${task.startTime}
							</td>
						</tr>
						<tr>
							<td width="20%">
								任务剩余进度提醒1：
							</td>
							<td width="35%">
								${task.remind1 }
							</td>
							<td width="20%">
								任务剩余进度提醒2：
							</td>
							<td width="35%">
								${task.remind2 }
							</td>
						</tr>
						<tr>
							<td width="20%">
								任务剩余进度提醒3：
							</td>
							<td width="35%">
								${task.remind3 }
							</td>
							<td width="20%">
								任务剩余进度提醒4：
							</td>
							<td width="35%">
								${task.remind4 }
							</td>
						</tr>
						<tr>
							<td width="20%">
								实际完成时间：
							</td>
							<td width="35%">
								${task.actTime==''?'/':task.actTime }
							</td>
							<td width="20%">
								完成进度：
							</td>
							<td width="35%">
								${task.percent==''?'/':task.percent }
							</td>
						</tr>
						<tr>
							<td width="20%"  valign="top">
								所属父任务：
							</td>
							<td >
								<input name="parentId" id="parentId"  type="hidden" value="${task.parentId }">&nbsp;
								<span id="parentName" style="border:1px; background:#fff;font-size: 12px;">${task.parentTitle }</span>
							</td>
						</tr>
						<tr>
							<td width="20%" valign="top">
								责任人：
							</td>
							<td colspan="3">
								<input name="zreIds" id="zreIds"  type="hidden" value="${task.memberIds}">&nbsp;
								<span id="zreNames" style="border:1px; background:#fff;font-size: 12px;">${task.memberNm }</span>
							</td>
						</tr>
						<tr>
							<td width="20%" valign="top">
								关注人：
							</td>
							<td colspan="3">
								<input name="gzrIds" id="gzrIds" type="hidden" value="${task.supervisorIds }">&nbsp;
								<span id="gzrNames" style="border:1px; background:#fff;font-size: 12px;">${task.supervisor }</span>
							</td>
						</tr>
						<tr>
							<td width="20%" valign="top">
								任务内容：
							</td>
							<td width="35%" colspan="3">${task.taskMemo }
							</td>
						</tr>
						</table>
						<table cellspacing="5px" class="table">
						<c:if test="${!empty atts}">
							<tr>
								<td colspan="4" class="cen">
									已添加附件
								</td>
							</tr>
							<c:forEach items="${atts}" var="att">
								<tr>
									<td width="20%">
										文件名:
									</td>
									<td width="35%">
										${att.attachName }
									</td>
									<td colspan="2">
										<a href="manager/download?path=${att.attacthPath }&filename=${att.attachName }">下载</a>
									</td>
								</tr>
							</c:forEach>
						</c:if>	
					</table>
				</div>
				<div style="height: 40px;">&nbsp;<br><br></div>
			</div>
			<div id="choiceWindow" class="easyui-window" style="width:800px;height:400px;" 
				minimizable="false" maximizable="false" collapsible="false" closed="true" modal="true">
				<iframe name="windowifrm" id="windowifrm" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
			</div>
		</form>
	</body>
</html>
