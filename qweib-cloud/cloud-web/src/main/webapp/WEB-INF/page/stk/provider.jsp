<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>企微宝</title>

		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="resource/loadDiv.js"></script>
		<script type="text/javascript" src="resource/dtree.js"></script>
		<style>
		.file-box{position:relative;width:70px;height: auto;}
		.uploadBtn{background-color:#FFF; border:1px solid #CDCDCD;height:22px;line-height: 22px;width:70px;}
		.uploadFile{ position:absolute; top:0; right:0; height:22px; filter:alpha(opacity:0);opacity: 0;width:70px;}
	    </style>
	</head>

	<body>
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="false"
			url="manager/providerPage" border="false"
			rownumbers="true" fitColumns="true" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
			<thead>
				<tr>
					<th field="ck" checkbox="true"></th>
				    <th field="id" width="50" align="center" hidden="true">
						proId
					</th>
					<th field="proNo" width="80" align="center">
						供应商编码
					</th>
					<th field="proName" width="120" align="center">
						供应商名称
					</th>
					<th field="proTypeName" width="120" align="center">
						供应商类别
					</th>
					<th field="contact" width="120" align="center" >
						联系人
					</th>
					<th field="tel" width="120" align="center" >
						联系电话
					</th>
					<th field="mobile" width="120" align="center" >
						手机
					</th>
					<th field="uscCode" width="120" align="center" >
						社会信用统一代码
					</th>
					<th field="address" width="200" align="center" >
						地址
					</th>
					<th field="remarks" width="120" align="center" >
						备注
					</th>
					<th field="status" width="80" align="center" formatter="formatterSt3">
						是否禁用
					</th>
					
					
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
		     名称: <input name="proName" id="proName" style="width:100px;height: 20px;" onkeydown="toQuery(event);"/>
			
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryprovider();">查询</a>
			<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:toaddprovider();">添加</a>
			<a class="easyui-linkbutton" iconCls="icon-edit" plain="true" href="javascript:getSelected();">修改</a>
			<a class="easyui-linkbutton" iconCls="icon-remove" plain="true" href="javascript:toDel();">删除</a>
			<a class="easyui-linkbutton" iconCls="icon-redo" plain="true" href="javascript:toProvierModel();">下载模板</a>
			<a class="easyui-linkbutton" iconCls="icon-edit" plain="true" href="javascript:toUpProvier();">上传供应商</a>
			
		</div>
		
		<!-- 上传框 -->
		<div class="file-box">
		  	<form action="manager/uploadtemp" name="uploadfrm" id="uploadfrm" method="post" enctype="multipart/form-data">
		  		<input type="hidden" name="width" value="${width}"/>
				<input type="hidden" name="height" value="${height}"/>
				<input type="button" class="uploadBtn" value="上传客户" />
				<input type="file" name="upFile" id="upFile" onchange="toUpProvier(this);" class="uploadFile"/>
		  	</form>
	  	</div>
  	    <div id="upDiv" class="easyui-window" style="width:500px;height:100px;padding:10px;" 
			minimizable="false" maximizable="false" collapsible="false" closed="true">
			<form action="manager/toUpProviderExcel" id="upFrm" method="post" enctype="multipart/form-data">
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr height="30px">
						<td >选择文件：</td>
						<td>
						<input type="file" name="upFile" id="upFile" title="check"/>
						</td>
						<td><input type="button" onclick="toUpProviderExcel();" style="width: 50px" value="上传" /></td>
					</tr>
				</table>
			</form>
		</div>
		<script type="text/javascript">
		  var dataTp = "${dataTp}";
		   function formatterSt(val,row){
				if(val=="1"){
					return "是";
				}else{
					return "否";
				}
			}
			function formatterSt1(val,row){
				if(val=="1"){
					return "是";
				}else{
					return "否";
				}
			}
			function queryprovider(){

				$("#datagrid").datagrid('load',{
					url:"manager/providerPage",
					proName:$("#proName").val()
				});

			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					queryprovider();
				}
			}
			//添加
			function toaddprovider(){
				location.href="${base}/manager/toprovideredit";
			}
			//修改
			function getSelected(){
			    var row = $('#datagrid').datagrid('getSelected');
				if (row){
					location.href="${base}/manager/toprovideredit?Id="+row.id;
				 }else{
					alert("请选择要修改的行！");
				}
			}
			 //删除
		    function toDel() {
				var ids = [];
				var rows = $("#datagrid").datagrid("getSelections");
				for ( var i = 0; i < rows.length; i++) {
					ids.push(rows[i].id);
				}
				if (ids.length > 0) {
					$.messager.confirm('确认', '您确认想要删除记录吗？', function(r) {
						if (r) {
							$.ajax( {
								url : "manager/deleteprovider",
								data : "ids=" + ids,
								type : "post",
								success : function(json) {
									if (json == 1) {
										showMsg("删除成功");
										$("#datagrid").datagrid("reload");
									}else if (json == -2) {
										showMsg("供应商名称已存在！");
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
		   function formatterSt3(val,row){
		      if(val==2){
		      		if (dataTp=='3') {
		      			return "<input style='width:60px;height:27px' type='button' value='是' onclick='updateIsTy(this, "+row.id+",1)' disabled='disabled'/>";
		      		} else {
		      			return "<input style='width:60px;height:27px' type='button' value='是' onclick='updateIsTy(this, "+row.id+",1)'/>";
		      		}
		       }else{
		       		if (dataTp=='3') {
		       			 return "<input style='width:60px;height:27px' type='button' value='否' onclick='updateIsTy(this, "+row.id+",2)' disabled='disabled'/>";
		       		} else {
		       			 return "<input style='width:60px;height:27px' type='button' value='否' onclick='updateIsTy(this, "+row.id+",2)'/>";
		       		}
		            
		       }
		   } 
		   function updateIsTy(_this,id,isTy){
				$.ajax({
					url:"manager/updateProviderIsUse",
					type:"post",
					data:"id="+id+"&status=" + isTy,
					success:function(data){
						if(data=='1'){
						    alert("操作成功");
							$('#datagrid').datagrid('reload');
						}else{
							alert("操作失败");
							return;
						}
					}
				});
		   }
		 //下载模板
	    function toProvierModel() {
              if(confirm("是否下载供应商上传需要的文档?")){
				window.location.href="manager/toProvierModel";
			}
       }
       //显示上传框
		function toUpProvier(){
			$("#upDiv").window({title:'上传',modal:true});
			$("#upDiv").window('open');
		}
		//上传文件
		function toUpProviderExcel(){
		       $("#upFrm").form('submit',{
				success:function(data){
					if(data=='1'){
						alert("上传成功");
						$("#upDiv").window('close');
						window.location.href="${base}/manager/queryprovider?dataTp=1";
					}else {
						alert(data);
					}
					onclose();
				},
				onSubmit:function(){
					DIVAlert("<img src='resource/images/loading.gif' width='50px' height='50px'/>");
				}
			});
	    }
		</script>
	</body>
</html>
