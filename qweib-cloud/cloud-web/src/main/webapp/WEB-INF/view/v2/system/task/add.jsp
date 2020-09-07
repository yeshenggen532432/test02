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
		<script type="text/javascript" src="resource/area_zh.js"></script>
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
				$("<br/><input type=\"file\" name=\"file"+js+"\" id=\"img"+js+"\" class=\"btnor\" style=\"width: 450px;margin-top: 5px;\" onchange=\"yzimg()\"><a style=\"color: blue;\" ><u>删除</u></a>").appendTo($("#files"));
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
						alert("添加成功");
						window.location.reload();
					}else{
						alert("添加失败");
					}
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
				showWindow("选择负责人");
				document.getElementById("windowifrm").src="<%=request.getContextPath()%>/manager/totaskmem";
			}else if(val=="2"){
				showWindow("选择关注人");
				document.getElementById("windowifrm").src="<%=request.getContextPath()%>/manager/totaskmem";
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
		<form action="manager/addtask" method="post" id="myform"
			enctype="multipart/form-data">
			<div style="background-color: #f7f8fa; width: 100%; height: 100%;">
				<div style="text-align: center; margin-top: 10px;">
					<table cellspacing="5px" class="table" id="tb1">
						<tr>
							<td width="15%" >
								标题：
							</td>
							<td width="10%" >
								<input type="text" name="taskTitle" id="taskTitle"/>
							</td>
							<td width="10%" >
								开始时间：
							</td>
							<td width="10%" colspan="2">
								<input style="width: 200px;" type="text" class="Wdate" name="startTime" id="startTime"
									 onClick="WdatePicker({dateFmt:'yyyy年MM月dd日 HH时mm分'})" readonly="readonly" onchange="javascript:stime(this);"/>
							</td>
							<td width="10%">
								结束时间：
							</td>
							<td width="10%" colspan="2">
								<input style="width: 200px;" type="text" class="Wdate" name="endTime" id="endTime"
									 onClick="WdatePicker({dateFmt:'yyyy年MM月dd日 HH时mm分'})" readonly="readonly"/>
							</td>
						</tr>
						<tr>
							<td width="15%">
								任务提醒1：
							</td>
							<td width="10%">
								<input name="remind1" id="remind1" value="5" style="width: 80px;">%
								<span class="reds" id="tx1" style="display: none;">只能为数字(0-100之间)</span>
							</td>
							<td width="10%">
								提醒2：
							</td>
							<td width="10%">
								<input name="remind2" id="remind2" value="10" style="width: 80px;">%
								<span class="reds" id="tx2" style="display: none;">只能为数字(0-100之间)</span>
							</td>
							<td width="10%">
								提醒3：
							</td>
							<td width="10%">
								<input name="remind3" id="remind3" value="20" style="width: 80px;">%
								<span class="reds" id="tx3" style="display: none;">只能为数字(0-100之间)</span>
							</td>
							<td width="10%">
								提醒4：
							</td>
							<td width="10%">
								<input name="remind4" id="remind4" value="30" style="width: 80px;">%
								<span class="reds" id="tx4" style="display: none;">只能为数字(0-100之间)</span>
							</td>
						</tr>
						<c:if test="${!empty parentId}">
						<tr>
							<td width="15%">
								所属父任务：
							</td>
							<td colspan="5">
								<input name="parentId" id="parentId"  type="hidden" value="${parentId }">&nbsp;
								<input name="parentName" id="parentName"  type="text" value="${parentName }" class="read">&nbsp;
							</td>
						</tr>
						</c:if>
						<tr>
							<td width="15%" rowspan="2" valign="top">
								责任人：
							</td>
							<td colspan="5" width="75%">
								<input name="zreIds" id="zreIds"  type="hidden">&nbsp;
								<span id="zreNames" style="border:1px; background:#fff"></span>
							</td>
						</tr>
						<tr>
							<td colspan="5"  width="75%">
								<a class="easyui-linkbutton" onclick="addMem(1);" style="font-size: 12px;">选择</a> 
	      						<a class="easyui-linkbutton" onclick="resetMem(1);">清空</a> 
							</td>
						</tr>
						<tr>
							<td width="15%" rowspan="2" valign="top">
								关注人：
							</td>
							<td colspan="5"  width="75%">
								<input name="gzrIds" id="gzrIds" type="hidden">&nbsp;
								<span id="gzrNames" style="border:1px; background:#fff"></span>
							</td>
						</tr>
						<tr>
							<td colspan="5">
								<a class="easyui-linkbutton" onclick="addMem(2);">选择</a> 
	      						<a class="easyui-linkbutton" onclick="resetMem(2);">清空</a> 
							</td>
						</tr>
						<tr>
							<td width="15%" valign="top">
								内容描述：
							</td>
							<td width="75%" colspan="5">
								<textarea name="taskMemo" rows="2" cols="106"></textarea>
							</td>
						</tr>
						</table>
						<table cellspacing="5px" class="table">
							<tr>
								<td colspan="3">
									<table width="100%" border="0" style="border-collapse:separate;border-spacing:5px;">
										<tr>
											<td>附件：</td>
											<td width="70px" align="left" colspan="5"><span id="files"><input type="file" name="file0" id="img0" class="btnor" style="width: 450px;margin-top: 5px;" onchange="yzimg()"><a style="color: blue;" ><u>删除</u></a></span>
												
											</td>
										</tr>
										<tr>
											<td align="center" style="text-align: center;"><span class="bt" id="file_error" style="display: none;">文件不能为(.exe)文件</span></td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
						
						<table cellspacing="5px" class="table">
							<tr>
								<td colspan="3">
									<table width="100%" border="0" style="border-collapse:separate;border-spacing:5px;">
										<tr>
											<td>添加子任务：</td>
											<td width="70px" align="left" colspan="5">
												<span id="files">
													<input type="text" name="file0" id="img0" class="btnor" style="width: 450px;margin-top: 5px;" onchange="yzimg()">&nbsp;&nbsp;&nbsp; 
														<a style="color: blue;" ><u>添加</u></a>&nbsp;&nbsp;&nbsp;
														<a style="color: blue;" ><u>删除</u></a>
												</span>
												
											</td>
										</tr>
									</table>
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
						</c:if>	
						
						
						<tr align="center">
							<td colspan="6">
								<a class="easyui-linkbutton" href="javascript:save();" id="bc">存为草稿</a>&nbsp;&nbsp;&nbsp;
								<a class="easyui-linkbutton" href="javascript:save();" id="bc">发布</a>
							</td>
						</tr>
					</table>
					
				</div>
			</div>
			<div id="choiceWindow" class="easyui-window" style="width:800px;height:400px;" 
				minimizable="false" maximizable="false" collapsible="false" closed="true" modal="true">
				<iframe name="windowifrm" id="windowifrm" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
			</div>
		</form>
		<script type="text/javascript">
		//开始时间验证
			function stime(obj){
				var stime = obj.value;
				var d = new Date();
				var str = d.getFullYear()+"年"+((d.getMonth()+1)<10?'0':'')+(d.getMonth()+1)+"月"+(d.getDate()<10?'0':'')+d.getDate()+"日 "+(d.getHours()<10?'0':'')+d.getHours()+"时"+(d.getMinutes()<10?'0':'')+d.getMinutes()+"分";
				if(stime<str){
					alert("开始时间不能小于当前时间");
				}
			}
			//结束时间验证
			function etime(obj){
				var etime = obj.value;
				var stime = $("#startTime").val();
				if(stime<str){
					alert("开始时间不能小于当前时间");
				}
			}
		</script>
	</body>
</html>
