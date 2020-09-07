<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>用户管理</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<link rel="stylesheet" type="text/css" href="resource/css/tab.css">
		<script type="text/javascript" src="<%=request.getContextPath()%>/resource/WdatePicker.js"></script>
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
				font-size: 12px;
			}
			.reds{
				color: red;
				font-size: 12px;
			}
		</style>
		
	<script type="text/javascript">
		/*作废 yyp by 20150715
		/* 作废 @author吴进 by 20150715 */
		/*
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
		}*/
	
		/* 作废 @author吴进 by 20150715 */
		/*
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
				$("<em id=\"fdiv"+js+"\"><input type=\"file\" name=\"file"+js+"\" id=\"img"+js+"\" class=\"btnor\" style=\"width: 450px;margin-top: 5px;\" onchange=\"yzimg()\"><a style=\"color: blue;\" href=\"javascript:delFile('"+js+"');\" ><u>删除</u></a></em>").appendTo($("#files"));
				js++;
			}
		}*/
		//提交
		var num3 = new RegExp("^[1-9]\\d*$");
		function save(type){
			//验证时间
			var vetystime =$("#vetystime").val();
			var vetyetime =$("#vetyetime").val();
			if(vetystime==0 || vetyetime==0){
				alert("请填写正确的开始或结束时间！");
				return;
			}
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
			var taskTitle = $("#taskTitle").val();
			var startTime = $("#startTime").val();
			var endTime = $("#endTime").val();
			var zreIds = $("#zreIds").val();
			if(taskTitle=='' || startTime=='' || endTime=='' || zreIds==''){
				alert("请填写必填项*");
				return;
			}
			$('#dd').dialog('open');
			$("#type").val(type);
			$('#myform').form('submit', {
				success:function(data){
					$('#dd').dialog('close');
					if(data=="1"){
						alert("修改成功");
						//window.location.reload();
					}else{
						alert("修改失败");
					}
					location.href="${base}/manager/toquerytaskall";
				}
			});
		}
		//清空责任人
		function resetMem(val){
			if(val=="1"){
				$("#zreIds").val("");
				$("#zreNames").text("");
			}else{
				$("#gzrIds").val("");
				$("#gzrNames").text("");
			}
		}
		//选择人员
		var memtype = 0;
		function addMem(val){
			memtype=val;
			if(val=="1"){
				//责任人只能一个，验证个数
				var zreIds = $("#zreIds").val();
				if(zreIds!=''){
					alert('责任人只能有一个');
					return;
				}
				showWindow("选择负责人");
				document.getElementById("windowifrm").src="<%=request.getContextPath()%>/manager/totaskmem";
			}else if(val=="2"){
				var gzrIds = $("#gzrIds").val();
				showWindow("选择关注人");
				document.getElementById("windowifrm").src="<%=request.getContextPath()%>/manager/totaskmem?gzrIds="+gzrIds;
			}else{
				showWindow("选择所属父任务");
				document.getElementById("windowifrm").src="<%=request.getContextPath()%>/manager/toTaskParent";
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
		//关闭弹窗层
		function closeUpdateWindow(taskTitle,id){
			$("#title"+id).html(taskTitle);
			$("#choiceUpdateWindow").window('close');
		}
		//子任务保存到父页面下
		var no=1;
		function setchildtask(str,taskTitle,num){
			$("#taskTitle"+num).val(taskTitle);
			$("#aa"+num).val(str);
			$("#choiceChildWindow").window('close');
			//追加子任务
			//$("#child"+(no-1)).find("u").innerHTML="修改";
			$("<em id=\"child"+no+"\"><input readonly type=\"text\" id=\"taskTitle"+no+"\" class=\"btnor\" style=\"width: 450px;margin-top: 5px;\">&nbsp;&nbsp;&nbsp;<a style=\"color: blue;\" href=\"javascript:addchild('"
					+no+"');\" ><u>添加</u></a>&nbsp;&nbsp;&nbsp;<a style=\"color: blue;\" href=\"javascript:delchild('"+no+"')\"><u>删除</u></a><input  type=\"hidden\" id=\"aa"+no+"\"  name=\"taskchild\"/></em>")
			.appendTo($("#childs"));
			no++;
		}

		//删除子任务delchild
		function delchild(num){
			var len = ($("#childs").find("input").length)/2;
			if(len==1){
				$("#aa"+num).val('');
				$("#taskTitle"+num).val('');
			}else{
				$("#child"+num).remove();
			}
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
		<form action="manager/updateDraft" method="post" id="myform"
			enctype="multipart/form-data">
			<div style="background-color: #f7f8fa; width: 100%; height: 100%;">
				<div style="text-align: center; margin-top: 10px;">
					<input type="hidden" id="id" name="id" value="${task.id }"/>
					<input type="hidden" id="parentId" name="parentId" value="${task.parentId }"/>
					<input type="hidden" id="createTime" name="createTime" value="${task.createTime }"/>
					<input type="hidden" id="createBy" name="createBy" value="${task.createBy }"/>
					<input type="hidden" id="status" name="status" value="${task.status }"/>
					<input type="hidden" id="percent" name="percent" value="${task.percent }"/>
					<table cellspacing="5px" class="table" id="tb1">
						<tr>
							<td width="100">标题：<span style="color: red;" id="title">*</span></td>
							<td>
								<input type="text" name="taskTitle" id="taskTitle" value="${task.taskTitle }"/>
							</td>
							<td width="100">开始时间：<span style="color: red;" id="stime">*</span></td>
							<td colspan="2">
								<input style="width: 200px;" type="text" class="Wdate" name="startTime" id="startTime" value="${task.startTime }"
									 onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm'})" readonly="readonly" onchange="javascript:vtime(this,'1');"/>
								<input type="hidden" value="${task.startTime !=''?'1':'0'}" id="vetystime"/>
							</td>
							<td width="100">结束时间：<span style="color: red;" id="etime">*</span></td>
							<td colspan="2">
								<input style="width: 200px;" type="text" class="Wdate" name="endTime" id="endTime" value="${task.endTime}"
									 onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm'})" readonly="readonly" onchange="javascript:vtime(this,'2');"/>
								<input type="hidden" value="${task.endTime !=''?'1':'0'}" id="vetyetime"/>
							</td>
						</tr>
						<tr>
							<td width="100">任务提醒1：</td>
							<td>
								<input name="remind1" id="remind1" value="${task.remind1 }" style="width: 80px;">%
								<span class="reds" id="tx1" style="display: none;">只能为数字(0-100之间)</span>
							</td>
							<td width="100">提醒2：</td>
							<td>
								<input name="remind2" id="remind2" value="${task.remind2 }" style="width: 80px;">%
								<span class="reds" id="tx2" style="display: none;">只能为数字(0-100之间)</span>
							</td>
							<td width="100">提醒3：</td>
							<td>
								<input name="remind3" id="remind3" value="${task.remind3 }" style="width: 80px;">%
								<span class="reds" id="tx3" style="display: none;">只能为数字(0-100之间)</span>
							</td>
							<td width="100">提醒4：</td>
							<td>
								<input name="remind4" id="remind4" value="${task.remind4 }" style="width: 80px;">%
								<span class="reds" id="tx4" style="display: none;">只能为数字(0-100之间)</span>
							</td>
						</tr>
						<tr>
							<td width="100">执行人：<span style="color: red;" id="zryz">*</span></td>
							<td colspan="6">
								<input name="zreIds" id="zreIds"  type="hidden" value="${task.memberIds}">&nbsp;
								<span id="zreNames" style="border:1px; background:#fff">${task.memberNm }</span>
							</td>
							<td>
								<a class="easyui-linkbutton" onclick="addMem(1);" style="font-size: 12px;">选择</a> 
	      						<a class="easyui-linkbutton" onclick="resetMem(1);">清空</a> 
							</td>
						</tr>
						<tr>
							<td width="100">关注人：</td>
							<td colspan="6">
								<input name="gzrIds" id="gzrIds" type="hidden" value="${task.supervisorIds }">&nbsp;
								<span id="gzrNames" style="border:1px; background:#fff">${task.supervisor }</span>
							</td>
							<td>
								<a class="easyui-linkbutton" onclick="addMem(2);">选择</a> 
	      						<a class="easyui-linkbutton" onclick="resetMem(2);">清空</a> 
							</td>
						</tr>
						<tr>
							<td width="100">内容描述：</td>
							<td colspan="7">
								<textarea name="taskMemo" rows="4" cols="130">${task.taskMemo }</textarea>
							</td>
						</tr>
						<tr>
							<td width="100">附件：</td>
							<td colspan="6">
								<table width="100%">
									<tr>
										<td style="color: gray;">温馨提示：附件不能为(.exe .rar .zip)文件
										</td>
									</tr>
									<tr>
										<td><select id="attachmentId" multiple="multiple" style="width: 100%; height: 60px;">
											<c:if test="${!empty atts}">
												<c:forEach items="${atts}" var="att">
													<option value="${att.id }">${att.attachName }</option>
												</c:forEach>
											</c:if>
										</select></td>
									</tr>
								</table>
							</td>
							<td>
								<a class="easyui-linkbutton" href="Javascript:doUpload();" id="doUploadId">上传附件</a>
								<br><br>
								<a class="easyui-linkbutton" href="Javascript:doUnloadFile();" id="doUnloadFileId">删除</a>
							</td>
						</tr>
						<tr>
							<td colspan="8" align="center" style="text-align: center;"><span class="bt" id="file_error" style="display: none;">文件不能为(.exe)文件</span></td>
						</tr>
					</table>
					
						<script type="text/javascript">
						//上传附件
						function doUpload(){
							var _id = $("#id").val();
							// 上传方法
							$.upload({
								// 上传地址
								url:"manager/uploadFileForUpdate",
								// 文件域名字
								fileName: 'file', 
								//参数
								params: {"id":_id},
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
							var _id = $("#id").val();
							if (_attachmentId != null) {
								$.post("manager/doUnloadFileByUpdate", "attachmentId="+_attachmentId+"&id="+_id, function(data) {
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
					
						<!-- 添加附件区域开始 -->
						<!-- <table cellspacing="5px" class="table">
							<tr>
								<td colspan="3">
									<table width="100%" border="0" style="border-collapse:separate;border-spacing:5px;">
										<tr>
											<td>附件：</td>
											<td width="70px" align="left" colspan="5">
												<span id="files">
													<em id="fdiv0">
													<input type="file" name="file0" id="img0" class="btnor" style="width: 450px;margin-top: 5px;" onchange="yzimg()">
													<a style="color: blue;" href="javascript:delFile('0');" ><u>删除</u></a>
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
						</table> -->
						
						<!-- 添加子任务开始 -->
						<table cellspacing="5px" class="table">
							<tr>
								<td colspan="3">
									<table width="100%" border="0" style="border-collapse:separate;border-spacing:5px;">
										<tr>
											<td width="100">添加子任务：</td>
											<td>
												<span id="childs">
													<em id="child0">
														<input readonly type="text" id="taskTitle0"  class="btnor" style="width: 450px;margin-top: 5px;">&nbsp;&nbsp;&nbsp; 
														<a style="color: blue;" href="javascript:addchild('0')" ><u>添加</u></a>&nbsp;&nbsp;&nbsp;
														<a style="color: blue;" href="javascript:delchild('0')" ><u>删除</u></a>
														<input id="aa0" type="hidden"  name="taskchild"/>
													</em>
												</span>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
						<script type="text/javascript">
							///////添加子任务//////
							function addchild(num){
								//验证时间
								var vetystime =$("#vetystime").val();
								var vetyetime =$("#vetyetime").val();
								if(vetystime==0 || vetyetime==0){
									alert("请先填写开始和结束时间！");
									return;
								}
								var stime = $("#startTime").val();
								var etime = $("#endTime").val();
								showchildWindow("添加子任务");
								document.getElementById("windowChildifrm").src="<%=request.getContextPath()%>/manager/toChildtaskPage?startTime="+stime+"&endTime="+etime+"&num="+num;
							}
							//显示弹出窗口
							function showchildWindow(title){
								$("#choiceChildWindow").window({
									title:title,
									top:getScrollTop()+50
								});
								$("#choiceChildWindow").window('open');
							}
						</script>
					<!-- 子任务显示 -->	
					<table cellspacing="5px" class="table">
						<!-- 已有附件/子任务操作区域开始
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
									<td width="30%">
										${att.attachName }
									</td>
									<td colspan="2">
										<a href="manager/download?path=${att.attacthPath }&filename=${att.attachName }">下载</a>
										&nbsp;&nbsp;
										<a href="javascript:delatt(${att.id })">删除</a>
									</td>
								</tr>
							</c:forEach>
						</c:if>	  -->
						<c:if test="${!empty childList}">
							<tr>
								<td colspan="4" class="cen">
									已添加子任务
								</td>
							</tr>
							<c:forEach items="${childList}" var="t">
								<tr>
									<td width="20%">
										标题:
									</td>
									<td width="30%">
										<span id="title${t.id }">${t.taskTitle }</span>
									</td>
									<td colspan="2">
										<a href="javascript:updateChild('${t.id }','${t.taskTitle }')">修改</a>
										&nbsp;&nbsp;
										<a href="javascript:delchild(${t.id })">删除</a>
									</td>
								</tr>
							</c:forEach>
						</c:if>	
					</table>
					<table cellspacing="5px" class="table">
						<tr>
							<td align="center">
								<a class="easyui-linkbutton" href="javascript:save('3');" id="bc">保存草稿</a>
								&nbsp;&nbsp;&nbsp;&nbsp;
								<a class="easyui-linkbutton" href="javascript:save('1');" id="bc">发布</a>
								&nbsp;&nbsp;&nbsp;&nbsp;
								<a class="easyui-linkbutton" href="${base }/manager/toquerytaskall" id="bc">返回</a>
								<input type="hidden" id="type" name="type"/>
							</td>
						</tr>
					</table>
				</div>
			</div>
		</form>
		
		<!-- 选择人员弹窗 -->
		<div id="choiceWindow" class="easyui-window" style="width:800px;height:400px;" 
			minimizable="false" maximizable="false" collapsible="false" closed="true" modal="true">
			<iframe name="windowifrm" id="windowifrm" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
		</div>
		<!--子任务弹窗-->
		<div id="choiceChildWindow" class="easyui-window" style="width:1024px;height:500px;" 
			minimizable="false" maximizable="false" collapsible="false" closed="true" modal="true">
			<iframe name="windowChildifrm" id="windowChildifrm" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
		</div>
		<!--子任务修改页面弹窗-->
		<div id="choiceUpdateWindow" class="easyui-window" style="width:1024px;height:500px;" 
			minimizable="false" maximizable="false" collapsible="false" closed="true" modal="true">
			<iframe name="windowUpdateifrm" id="windowUpdateifrm" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
		</div>
		<script type="text/javascript">
			//验证时间
			function vtime(obj,type){
				//var str = d.getFullYear()+"-"+((d.getMonth()+1)<10?'0':'')+(d.getMonth()+1)+"-"+(d.getDate()<10?'0':'')+d.getDate()+" "+(d.getHours()<10?'0':'')+d.getHours()+":"+(d.getMinutes()<10?'0':'')+d.getMinutes()+"分";
				if(type=='1'){//验证开始时间
					var etime = $("#endTime").val();
					if(etime!='' && obj.value>etime){
						alert("开始时间不能大于结束时间");
						$("#vetystime").val("0");
						return;
					}else{
						$("#vetystime").val("1");
					}
				}else if(type=='2'){//验证结束时间
					var stime = $("#startTime").val();
					if(stime!='' && obj.value<stime){
						alert("结束时间不能小于开始时间");
						$("#vetyetime").val("0");
						return;
					}else{
						$("#vetyetime").val("1");
					}
				}
			}
			//删除文件
			/*作废 yyp by 20150715
			function delFile(num){
				var len = $("#files").find("input").length;
				if(len==1){
					$("#img"+num).val('');
				}else{
					$("#fdiv"+num).remove();
				}
			}
			//显示弹出窗口
			function showchildWindow(title){
				$("#choiceChildWindow").window({
					title:title,
					top:getScrollTop()+50
				});
				$("#choiceChildWindow").window('open');
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
				}
				$("#choiceWindow").window('close');
			}*/
			//更新主任务开始/结束时间
			function updatesetime(stime,etime){
				if(stime!=''){
					$("#startTime").val(stime);
				}
				if(etime!=''){
					$("#endTime").val(etime);
				}
			}
			$("#choiceWindow").window('close');
		//}
		//删除附件及数据
		/*作废 yyp 20150716
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
					}*/
			//删除子任务
			function delchild(taskId){
				$.ajax({
					url:"manager/delchild",
					data:"taskId="+taskId,
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
			//修改子任务
			function updateChild(taskId,title){
				showUpdateWindow(title+"：修改子任务");
				document.getElementById("windowUpdateifrm").src="<%=request.getContextPath()%>/manager/toUpdateChild?taskId="+taskId;
			}
			//显示弹出窗口
			function showUpdateWindow(title){
				$("#choiceUpdateWindow").window({
					title:title,
					top:getScrollTop()+50
				});
				$("#choiceUpdateWindow").window('open');
			}
			
			//更新主任务开始/结束时间
			function updatesetime(stime,etime){
				if(stime!=''){
					$("#startTime").val(stime);
				}
				if(etime!=''){
					$("#endTime").val(etime);
				}
			}
			// 下载附件
			function doDownload() {
				var _attachmentId = $("#attachmentId").val();
				if (_attachmentId != null) {
					form1.action="manager/download?path=${att.attacthPath }&filename=${att.attachName }";
			      	form1.method="post";
			      	form1.submit();	
				}
			}
		</script>
	</body>
</html>
