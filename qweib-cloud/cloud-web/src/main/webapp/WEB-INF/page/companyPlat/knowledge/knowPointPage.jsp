<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>知识点列表</title>

		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="resource/jquery.upload.js"></script>
		<script type="text/javascript" src="<%=request.getContextPath()%>/resource/WdatePicker.js"></script>
		<style>
			.urlspan,.ptitle{
				color:red;
			}
		</style>
	</head>
	<body>
		<table  id="datagrid" class="easyui-datagrid" fit="true" singleSelect="false"
			url="manager/pointPage?sortId=${sortId }" title="知识点列表" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="true" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
			<thead>
				<tr>
					<th field="ck" checkbox="true"></th>
					<th field="knowledgeId" width="50" align="center" hidden="true">
						knowledgeId
					</th>
					<th field="topicTitle" width="280" align="center">
						标题
					</th>
					<th field="topicTime" width="280" align="center">
						创建时间
					</th>
					<th field="memberNm" width="280" align="center" formatter="formmemNm">
						创建人
					</th>
					<th field="tp" width="280" align="center" formatter="formTp">
						类型
					</th>
					<th field="cz" width="300" align="center" formatter="vcz">
						操作
					</th>
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
			标题:<input name="topicTitle" id="topicTitle" style="width:76px;height: 20px;" onkeydown="toQuery(event);"/>
			<input type="hidden" value="${sortId }" id="sortId"/>
			<a class="easyui-linkbutton" iconCls="icon-search"  href="javascript:queryKnowpoint();">查询</a>
			<!--圈群主、圈管理员具有添加删除权限  -->
			<c:if test="${usrRole=='1' || usrRole=='2' }">
				<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:toaddpoint();">添加</a>
				<a class="easyui-linkbutton" iconCls="icon-remove" plain="true" href="javascript:toDel();">删除</a>
			</c:if>
		</div>
		<!-- 增加知识点弹窗 -->
		<div id="win" class="easyui-window" title="添加知识点" style="width:500px;height:320px;" closed="true">  
			    <form id="frm" method="post" action="manager/addPoint" style="padding:10px 20px 10px 40px;" style="width:450px;"> 
			    	<input type="hidden" value="${sortId }" name="sortId"/>
			    	类&nbsp;&nbsp;&nbsp;&nbsp;型:
			    	<label><input value="2" name="tp" type="radio" checked="checked"/>外部链接</label> &nbsp;&nbsp;&nbsp;
			    	<label><input value="3" name="tp" type="radio"/>上传文件</label> 
			    	<!-- <select name="tp" id="tp" onchange="tochangetp()">
			    		<option value="2" selected="selected">外部链接</option>
			    		<option value="3">上传文件</option>
			    	</select> --> 
			    	<br><br>
			       	<p class="purl">来源url: <input type="text" name="topiContent" id="topiContent" style="width: 200px">
			       		<span class="urlspan">*</span>
			       	</p>
			       	<br>
			       	<div class="tb" style="display: none;"><br>
			       		<p class="pttle">标题: <input type="text" name="topicTitle" style="width: 200px">
			       			<span class="ptitle">*</span>
			       		</p><br>
				       	文&nbsp;&nbsp;&nbsp;&nbsp;件: 
				       	<table width="100%" >
							<tr>
								<td style="color: gray;">温馨提示：附件不能为(.exe .rar .zip)文件
									<input type="hidden" value="${attTempId }" id="attTempId" name="attTempId"/>
								</td>
							</tr>
							<tr>
								<td><select id="attachmentId" multiple="multiple" style="width: 100%; height: 60px;"></select></td>
								<td style="text-align: center;">
									<a class="easyui-linkbutton" href="Javascript:doUpload();" id="doUploadId">上传附件</a>
									<br><br>
									<a class="easyui-linkbutton" href="Javascript:doUnloadFile();" id="doUnloadFileId">删除</a>
								</td>
							</tr>
						</table>
					</div>
					<input type="hidden" name="sortId"/>
			        <br>
			        <div style="padding:5px;text-align:center;">  
			            <a href="javascript:addSort();" class="easyui-linkbutton" icon="icon-ok">确定</a>  
			            <a href="javascript:closeWin();" class="easyui-linkbutton" icon="icon-cancel">取消</a>  
			        </div>  
			    </form>  
		</div> 
		<!--知识点详情-->
		<div id="choiceDetailWindow" class="easyui-window" style="width:window.screen.availWidth;height:window.screen.availHeight;" 
			minimizable="false" maximizable="false" collapsible="true" closed="true" modal="true" maximized="true">
			<iframe name="windowDetailifrm" id="windowDetailifrm" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
		</div>
		<script type="text/javascript">
		$(document).ready(function(){
			$("input[name='tp']").click(function(){
				var tp = $("input[type='radio']:checked").val();
				if(tp=='2'){
					$('.purl').show();
					$('.tb').hide();
					doUnloadFile();
					$("#attachmentId").html("");
					$(".pttle input").val('');
				}else if(tp=='3'){
					$('.purl').hide();
					$('.tb').show();
					$("#topiContent").val('');
				}
			});
		});
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					queryKnowpoint();
				}
			}
			//查询
			function queryKnowpoint(){
				$("#datagrid").datagrid('load',{
					url:"manager/pointPage",
					sortId:$("#sortId").val(),
					method:"post",
					topicTitle:$("#topicTitle").val()
				});
			}
			//操作
			function vcz(val,row){		
				var str = "<a href='javascript:;' onclick='javascript:toDetail("+row.knowledgeId+", "+row.tp+",\""+row.topiContent+"\")' style='text-decoration:none;'>详情</a>";
				return str;
			}
			function formTp(val){
				if(val=='1'){
					return "圈帖子";
				}else if(val=='2'){
					return "url";
				}else if(val=='3'){
					return "文件";
				}
			}
			function formmemNm(val,row){
				if(val==''){
					return row.operateNm;
				}else {
					return val;
				}
			}
			//详情
			function toDetail(kid,tp,url){
				if(tp=='2'){//url
					//showModalDialog("manager/toShowpic?url="+url,'','width=790,height=590'); 
					//window.showModalDialog(url,window,"dialogWidth=1000px;dialogHeight=500px;dialogLeft=200px;dialogTop=200px;");
				    //	window.location.href=url;
					//showDetailWindow("知识点详情");
					//document.getElementById("windowDetailifrm").src=url;
					//window.open (url,'newwindow','height=600,width=950,top=100,left=200,toolbar=no,menubar=no,scrollbars=yes, resizable=no,location=no, status=no');
					window.open(url,'_blank');
					//showDetailWindow("知识点详情");
					//document.getElementById("windowDetailifrm").src=url;
				}else{
					showDetailWindow("知识点详情");
					document.getElementById("windowDetailifrm").src="${base}/manager/queryKnowledgeDetail?knowledgeId="+kid;
					//window.open ("${base}/manager/queryKnowledgeDetail?knowledgeId="+kid,'newwindow','height=600,width=950,top=100,left=200,toolbar=no,menubar=no,scrollbars=yes, resizable=no,location=no, status=no');
					//window.open('${base}/manager/queryKnowledgeDetail?knowledgeId='+kid,'_blank');
				}
			}
			//显示弹出窗口------弹窗方式修改
			function showDetailWindow(title){
				$("#choiceDetailWindow").window({
					title:title,
					top:0,
					left:0
					//width:document.documentElement.clientWidth,
					//height:600
				});
				$("#choiceDetailWindow").window('open');
			}
			//删除
		    function toDel() {
				var ids = [];
				var rows = $("#datagrid").datagrid("getSelections");
				for ( var i = 0; i < rows.length; i++) {
					ids.push(rows[i].knowledgeId);
				}
				if (ids.length > 0) {
					$.messager.confirm('确认', '您确认想要删除记录吗？', function(r) {
						if (r) {
							$.ajax( {
								url : "manager/delknowledge",
								data : "ids=" + ids,
								type : "post",
								success : function(json) {
									if (json == 1) {
										showMsg("删除成功");
										$("#datagrid").datagrid("reload");
									} else if (json == -1) {
										showMsg("删除失败");
									}
								}
							});
						}
					});
				} else {
					showMsg("请选择要删除的数据");
				}
			}
			
			//添加
			function toaddpoint(){
				$("#win").window("open");
				$("#attTempId").val(new Date().getTime());
			}
			function addSort(){
				var tp = $("input[type='radio']:checked").val();
				if(tp=='2'){//url
					var topiContent = $("#topiContent").val();
					if(topiContent=='' || typeof(topiContent) == "undefined"){
						$(".urlspan").html("请填写来源url");
						return;
					}else {
						//var strRegex = '^((https|http|ftp|rtsp|mms)?://)'
						//	+ '?(([0-9a-z_!~*\'().&=+$%-]+: )?[0-9a-z_!~*\'().&=+$%-]+@)?' //ftp的user@
						//	+ '(([0-9]{1,3}.){3}[0-9]{1,3}' // IP形式的URL- 199.194.52.184
						//	+ '|' // 允许IP和DOMAIN（域名）
						//	+ '([0-9a-z_!~*\'()-]+.)*' // 域名- www.
						//	+ '([0-9a-z][0-9a-z-]{0,61})?[0-9a-z].' // 二级域名
						//	+ '[a-z]{2,6})' // first level domain- .com or .museum
						//	+ '(:[0-9]{1,4})?' // 端口- :80
						//	+ '((/?)|' // a slash isn't required if there is no file name
						//	+ '(/[0-9a-z_!~*\'().;?:@&=+$,%#-]+)+/?)$';
						var strRegex = /http(s)?:\/\/([\w-]+\.)+[\w-]+(\/[\w- .\/?%&=]*)?/;
							var re=new RegExp(strRegex);
							if (!re.test(topiContent)) {
								$(".urlspan").html("请填写正确的外部链接地址");
								return;
							}
					}
				}else if(tp=='3'){
					var titleinput = $(".pttle input").val();
					if(titleinput=='' || typeof(titleinput) == "undefined"){
						$(".ptitle").html("请填写标题");
						return;
					}
				}
				$('#frm').form('submit',{//表单提交
					success:function(data){
						if(data=='1'){
							alert("添加成功");
							document.getElementById("frm").reset();//数据重置
							$("#attachmentId").html("");//清空文件记录
							tochangetp();//变更类型为默认
							closeWin();//关闭窗口
							$("#datagrid").datagrid("reload");//数据重新加载
						}else if(data=='-1'){
							alert("添加失败");
						}else if(data=='-2'){
							alert('url解析出错');
						}
					}
				});
			}
			//关闭窗口
			function closeWin(){
				$("#win").window("close");
			}
			// 上传附件
			function doUpload(){
				var attTempId = $("#attTempId").val();
				// 上传方法
				$.upload({
					// 上传地址
					url:"manager/uploadFile",
					// 文件域名字
					fileName: 'file', 
					//参数
					params: {"attTempId":attTempId},
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
			//变更类型为默认
			function tochangetp(){
				$('.purl').show();
				$('.tb').hide();
				doUnloadFile();
				$("#attachmentId").html("");
				$(".pttle input").val('');
			}
		</script>
	</body>
</html>
