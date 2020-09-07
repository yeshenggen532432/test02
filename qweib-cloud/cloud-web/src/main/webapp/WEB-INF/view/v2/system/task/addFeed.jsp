<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>添加任务反馈</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="<%=request.getContextPath()%>/resource/WdatePicker.js"></script>
		<link rel="stylesheet" type="text/css" href="resource/css/tab.css">
		<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%> 
		<script type="text/javascript" src="resource/area_zh.js"></script>
		<script type="text/javascript" src="resource/jquery.upload.js"></script>
		<style type="text/css">
			.btnor {
				width: 80px;
				height: 25px;
			}
			span{
				font-size: 12px;
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
		<form action="manager/addFeed" method="post" id="myform"
			enctype="multipart/form-data">
			<div style="background-color: #f7f8fa; width: 100%; height: 100%;">
				<div style="margin-top: 10px;">
					<input value="${taskId }" type="hidden" name="nid" id="nid"/>
					<input value="${percent }" type="hidden" name="percent" id="percent"/>
					<table cellspacing="5px" class="table" id="tb1" style="width: 700px;">
							<tr>
								<td align="center">
									进度:
								</td>
								<td >
									<input value="${percent}" name="persent" id="persent" onkeyup="javascript:checkNum(this.value);" onchange="javascript:check();"/>%
								</td>
							</tr>
							<tr>
								<td align="center">
									描述:
								</td>
								<td >
									<textarea rows="2" cols="50" name="remarks" id="remarks"></textarea>
								</td>
							</tr>
							<tr>
							<td width="100px;" style="text-align: center;">附件:</td>
							<td>
								<table>
									<tr>
										<td style="color: gray;">温馨提示：附件不能为(.exe .rar .zip)文件
											<input type="hidden" value="${attTempId }" id="attTempId" name="attTempId"/>
										</td>
									</tr>
									<tr style="width: 300px; height: 60px;">
										<td><select id="attachmentId" multiple="multiple" style="width: 300px; height: 60px;"></select></td>
									</tr>
								</table>
							</td>
							<td>
								<%--
								<input type="file" id="f" name="f" onchange="doChange(this);" contentEditable="false" accept="text/html" style="disable:none"/>
								<a class="easyui-linkbutton" href="javascript:addFile();" id="bc">添加</a>--%>
								
								<a class="easyui-linkbutton" href="Javascript:doUpload();" id="doUploadId">上传附件</a>
								<br><br>
								<a class="easyui-linkbutton" href="Javascript:doUnloadFile();" id="doUnloadFileId">删除</a>
							</td>
						</tr>
						<tr align="center">
							<td colspan="6">
								<a class="easyui-linkbutton" href="javascript:addFeed();" id="bc" ><span style="font-size: 12px;">添加任务反馈</span></a>&nbsp;&nbsp;&nbsp;
							</td>
						</tr>
					</table>
					<!-- 添加附件区域 -->
						<%--<table cellspacing="5px" class="table">
							<tr>
								<td colspan="3">
									<table width="100%" border="0" style="border-collapse:separate;border-spacing:5px;">
										<tr>
											<td>附件：</td>
											<td width="70px" align="left" colspan="5">
												<span id="files">
													<em id="fdiv0">
													<input type="file" name="file0" id="img0" class="btnor" style="width: 450px;margin-top: 5px;" onchange="yzimg()">
													<a style="color: blue;" href="javascript:delFile('0');" ><u style="font-size: 12px">删除</u></a>
													</em>
												</span>
												
											</td>
										</tr>
										<tr>
											<td align="center" style="text-align: center;"><span class="bt" id="file_error" style="display: none;">文件不能为(.exe)文件</span></td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
				--%></div>
			</div>
		</form>
	</body>
	<script type="text/javascript">
		//添加任务反馈
		function addFeed(){
			var persent = $("#persent").val();
			var remarks = $("#remarks").val().trim();
			if(persent=='' || remarks==''){
				alert("进度和描述必填");
				return;
			}
			var percent = $("#percent").val();
			if(parseInt(persent)==parseInt(percent)){
				alert("进度值需大于已反馈的进度值");
				return;
			}
			if(parseInt(persent)<parseInt(percent) || persent>100 || !/^[0-9]+$/.test(persent)){
				alert("进度值请填写"+percent+"-101之间的数字");
				return;
			}
			$('#myform').form('submit', {
				success:function(data){
					if(data=="1"){
						alert("添加成功");
						var persent = $("#persent").val();
						window.parent.closeFeedWindow(persent);
					}else if(data=="-1"){
						alert("添加失败");
					}else if("2"){
						alert("请先完成子任务");
					}
				}
			});
		}
		//验证进度值
		function checkNum(obj){
			if(obj){
				if (/^[0-9]+$/.test(obj))
				{
					return true;
				}else{
					var percent = $("#percent").val();
					$("#persent").val(percent);
				} 
			}
		}
		//验证进度大小
		function check(){
			var persent = $("#persent").val();
			var percent = $("#percent").val();
			if(parseInt(persent)<parseInt(percent)){
				$("#persent").val(percent);
			}else if(persent>100){
				$("#persent").val(100);
			}
		}
		//附件上传
		function doUpload(){
			var attTempId = $("#attTempId").val();
			// 上传方法
			$.upload({
				// 上传地址
				url:"manager/uploadFile",
				//参数
				params: {"attTempId":attTempId},
				// 文件域名字
				fileName: 'file', 
				// 上传完成后, 返回json, text
				dataType: 'json',
				// 上传之前回调,return true表示可继续上传
				onSend: function() {
					return true;
				},
				// 上传之后回调
				onComplate: function(data) {
					if (data.status && data.info != null) {
						var _option = "";
						for (var i = 0, n = data.info.length; i < n; i++) {
							_option += "<option value='" + data.info[i].id +"'>"+ data.info[i].attachName +"</option>";
						}
						$("#attachmentId").html(_option);
						alert("上传成功");
					} else {
						alert(data.info);
					}
				}
			});
		}
		//删除附件
		function doUnloadFile() {
			var _attachmentId = $("#attachmentId").val();
			var attTempId = $("#attTempId").val();
			if (_attachmentId != null) {
				$.post("manager/doUnloadFile", "attachmentId="+_attachmentId+"&attTempId="+attTempId, function(data) {
					if (data.status && data.info != null) {
						var _option = "";
						for (var i = 0, n = data.info.length; i < n; i++) {
							_option += "<option value='" + data.info[i].id +"'>"+ data.info[i].attachName +"</option>";
						}
						$("#attachmentId").html(_option);
						alert("删除成功");
					} else {
						alert(data.info);
					}
				});
			}
		}
	</script>
</html>
