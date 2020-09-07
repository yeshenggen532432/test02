<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<title>会员分页</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<%@include file="/WEB-INF/page/include/source.jsp"%>
	<script type="text/javascript" src="resource/loadDiv.js"></script>
	<style type="text/css">
	</style>
</head>
<body>
<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="false"
	   url="manager/shopMember/shopMemberPage?source=${source}" border="false"
	   rownumbers="true" fitColumns="false" pagination="true"
	   pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
	<thead>
	<tr>
		<th  field="id" checkbox="true"></th>
		<th field="name" width="80" align="center" >
			会员名称
		</th>
		<th field="mobile" width="100" align="center">
			电话
		</th>
		<th field="gradeName" width="100" align="center">
			会员等级
		</th>
		<th field="customerName" width="100" align="center">
			客户
		</th>
		<th field="defaultAddress" width="200" align="center">
			地址
		</th>
		<th field="status" width="100" align="center" formatter="formatterStatus">
			状态
		</th>
		<th field="_oper" width="150" align="center" formatter="formatterOper">
			操作
		</th>
		<c:if test="${source=='1'}">
			<th field="hySource" width="100" align="center">
				会员来源
			</th>
		</c:if>
		<th field="isXxzf" width="100" align="center" formatter="formatterIsXxzf">
			线下支付
		</th>
		<c:if test="${source=='3'}">
			<th field="khClose" width="100" align="center" formatter="formatterKhClose">
				关闭进销存客户
			</th>
		</c:if>
		<th field="pic" width="60" align="center" formatter="imgFormatter">
			微信头像
		</th>
		<th field=nickname width="80" align="center" >
			微信昵称
		</th>
		<th field="sex" width="50" align="center">
			性别
		</th>
		<th field="country" width="60" align="center">
			国家
		</th>
		<th field="province" width="60" align="center">
			省份
		</th>
		<th field="city" width="60" align="center">
			城市
		</th>
		<th field="remark" width="100" align="center">
			备注
		</th>
	</tr>
	</thead>
</table>
<div id="tb" style="padding:5px;height:auto">
	会员名称: <input name="name" id="name" style="width:100px;height: 20px;" />
	手机号: <input name="mobile" id="mobile" style="width:100px;height: 20px;"/>

	会员等级：<tag:select name="gradeId" id="gradeId" tableName="shop_member_grade" whereBlock="status=1 ${source==3?'':' and is_jxc is null'}" headerKey="" headerValue="--请选择--" displayKey="id" displayValue="grade_name" value="${model.spMemGradeId}" tclass="selectClass"/>
	<c:if test="${source=='3'}">
	关闭进销存客户: <select name="khClose" id="khClose">
					<option value="">全部</option>
					<option value="0">不关闭</option>
					<option value="1">关闭</option>
				</select>
	</c:if>
	<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:query();">查询</a>
	<a class="easyui-linkbutton" iconCls="icon-edit" plain="true" href="javascript:toedit();">修改</a>
	<c:if test="${source=='1'}">
		<a class="easyui-linkbutton" iconCls="icon-remove" plain="true" href="javascript:todel();">删除</a>
	</c:if>
	<c:if test="${source=='1' || source=='4'}">
		<a class="easyui-linkbutton" iconCls="icon-edit" plain="true"  href="javascript:openDialogXxzf();">批量设置线下支付</a>
	</c:if>
	<a class="easyui-linkbutton" iconCls="icon-edit" plain="true"  href="javascript:openDialogShopMemberGrade();">批量设置会员等级</a>
	<c:if test="${source=='3'}">
		<a class="easyui-linkbutton" iconCls="icon-edit" plain="true"  href="javascript:openDialogKhClose();">批量关闭进销存客户</a>
	</c:if>
</div>
<%--对话框：批量设置会员等级--%>
<div id="dialogShopMemberGrade" closed="true" class="easyui-dialog" title="批量设置会员等级" style="width:250px;height:130px;padding:10px;"
	 data-options="
				iconCls: 'icon-save',
				buttons: [{
					text:'确定',
					iconCls:'icon-ok',
					handler:function(){
						<%--批量修改会员等级--%>
						batchShopMemberGrade();
					}
				},{
					text:'取消',
					handler:function(){
						$('#dialogShopMemberGrade').dialog('close');
					}
				}]
			">
	<input class="easyui-combobox" name="updateSpMemGradeComb" id="updateSpMemGradeComb"
		   data-options="
					url:'manager/shopMemberGrade/list${source==3?'':'2'}?source=${source}&status=1',
					method:'post',
					valueField:'id',
					textField:'gradeName',
					multiple:false,
					panelHeight:'auto'
			">
</div>
<%--对话框：批量设置线下支付--%>
<div id="dialogXxzf" closed="true" class="easyui-dialog" title="批量设置线下支付" style="width:250px;height:130px;padding:10px;"
	 data-options="
				iconCls: 'icon-save',
				buttons: [{
					text:'确定',
					iconCls:'icon-ok',
					handler:function(){
						<%--批量设置线下支付--%>
						batchXxzf();
					}
				},{
					text:'取消',
					handler:function(){
						$('#dialogXxzf').dialog('close');
					}
				}]
			">
	<div>
		<div style="display: inline-block;margin-right: 10px">
			<label for="isXxzf_0">不显示:</label>
			<input type="radio" name="isXxzf" value="0" id="isXxzf_0">
		</div>
		<div style="display: inline-block;margin-right: 10px">
			<label for="isXxzf_1">显示:</label>
			<input type="radio" name="isXxzf" value="1" id="isXxzf_1">
		</div>
		<br>
		<span style="color: #3388FF;font-size: 10px;">说明:会员下单选择支付方式是否显示“线下支付”</span>
	</div>
</div>
<%--对话框：批量关闭进销存客户--%>
<div id="dialogKhClose" closed="true" class="easyui-dialog" title="批量关闭进销存客户" style="width:250px;height:130px;padding:10px;"
	 data-options="
				iconCls: 'icon-save',
				buttons: [{
					text:'确定',
					iconCls:'icon-ok',
					handler:function(){
						batchKhClose();
					}
				},{
					text:'取消',
					handler:function(){
						$('#dialogKhClose').dialog('close');
					}
				}]
			">
	<div>
		<div style="display: inline-block;margin-right: 10px">
			<label for="khClose-0">不关闭:</label>
			<input type="radio" name="khClose" value="0" id="khClose-0">
		</div>
		<div style="display: inline-block;margin-right: 10px">
			<label for="khClose-1">关闭:</label>
			<input type="radio" name="khClose" value="1" id="khClose-1">
		</div>
		<br>
		<span style="color: #3388FF;font-size: 10px;">说明:关闭之后只会享受'常规会员'的价格</span>
	</div>
</div>

<%--js--%>
<script type="text/javascript">
	//=====================删：改：查 start===============================
	//查询会员
	function query(){
		//source:1常规会员（有会员等级过滤）；2员工会员；3进销存会员
		var khClose = "";
		var source = "${source}";
		if("3"==source){
			khClose = $("#khClose").val();
		}
		$("#datagrid").datagrid('load',{
			url:"manager/shopMemberPage?source=${source}",
			name:$("#name").val(),
			mobile:$("#mobile").val(),
			spMemGradeId:$("#gradeId").val(),
			khClose:khClose,
		});
	}
	//修改会员
	function toedit(){
		var row = $('#datagrid').datagrid('getSelected');
		if (row){
			var id = row.id;
			window.location.href="${base}/manager/shopMember/edit?id="+id+"&source=${source}";
		}else{
			alert("请选择行");
		}
	}
	//删除会员
	function todel(){
		var row = $('#datagrid').datagrid('getSelected');
		if (row){
			if(confirm("是否要删除选中的会员?")){
				$.ajax({
					url:"manager/shopMember/delete",
					data:"id="+row.id,
					type:"post",
					success:function(json){
						if(json=="1"){
							alert("删除成功");
							query();
						}else{
							alert("删除失败");
							return;
						}
					}
				});
			}
		}
	}
	//=====================删：改：查 start===============================


	//========================table:start=================================
	//显示会员来源
	function formatterShopNo(val,row){
		if(val!=null && val!=undefined && val!=""){
			if(val=='9997'){
				return "app";
			}else if(val=='9999'){
				return "微信公众号";
			}else if(val=='9998'){
				return "员工";
			}else{
				return "门店";
			}
		}
	}
	//线下支付
	function formatterIsXxzf(val,row){
		var str = "";
		if(0 === val){
			str = "不显示";
		}else if(1 === val){
			str = "显示";
		}
		return str;
	}
	//关闭进销存客户
	function formatterKhClose(val,row){
		var str = "";
		if(1 === val){
			str = "关闭";
		}
		return str;
	}
	//操作会员启用；不启用
	function updateStatus(id,status){
		if(confirm("是否确定操作?")){
			$.ajax({
				url:"manager/shopMember/updateStatus",
				data:"id="+id+"&status="+status,
				type:"post",
				success:function(json){
					if(json=="1"){
						alert("操作成功!");
						query();
					}else{
						alert("操作失败");
						return;
					}
				}
			});
		}
	}

	//显示会员启用状态
	function formatterStatus(val,row){
		// if(val=='-2'){
		// 	return "已取消关注";
		// }else if(val=='-1'){
		// 	return "申请中";
		// }else if(val=='0'){
		// 	return "未启用";
		// }else if(val=='1'){
		// 	return "已启用";
		// }
		var html ="";
		if(row.status=='-2'){
			html ="已取消关注";
		}else if(row.status=='-1'){
			html = "<input value='申请中' style='width:50px' type='button' onclick='updateStatus("+row.id+",1)'/>";
		}else if(row.status=='0'){
			html = "<input value='未启用' style='width:50px' type='button' onclick='updateStatus("+row.id+",1)'/>";
		}else if(row.status=='1'){
			html = "<input value='启用'  style='width:50px' type='button' onclick='updateStatus("+row.id+",0)'/>";
		}
		return html;
	}
	//显示会员启用状态
	function formatterOper(val,row){
		// var html ="";
		// if(row.status=='-2'){
		// 	html ="";
		// }else if(row.status=='-1'){
		// 	html = "<input value='通过' type='button' onclick='updateStatus("+row.id+",1)'/>";
		// }else if(row.status=='0'){
		// 	html = "<input value='启用' type='button' onclick='updateStatus("+row.id+",1)'/>";
		// }else if(row.status=='1'){
		// 	html = "<input value='不启用' type='button' onclick='updateStatus("+row.id+",0)'/>";
		// }
		var html="<input value='地址列表' type='button' onclick='showAddressList("+row.id+",\""+row.name+"\")'/>";
		if(row.openId)
			html+="&nbsp;<input value='解绑微信' type='button' onclick='unbindWx("+row.id+",this)'/>";
		return html;
	}

	function unbindWx(id,th) {
		$.messager.confirm("确认", "确认解绑微信操作吗？", function (r) {
			if (r) {
				$.ajax({
					url:"manager/shopMember/unbindWx",
					data:{"id":id,"name":name},
					type:"post",
					success:function(json){
						if(json==1){
							$(th).css('display',"none");
						}else{
							alert('解绑失败');
						}
					}
				});
			}
		});
	}
	//地址列表
	function showAddressList(id,name){
		parent.parent.closeWin(name+'_地址列表');
		parent.parent.add(name+'_地址列表','manager/shopMemberAddress/toPage?hyId='+id);
	}
	//微信头像
	function imgFormatter(val,row){
		if(val!=""){
			return "<input  type=\"image\" src=\""+val+"\" height=\"30\" width=\"30\" align=\"middle\" />";
		}
	}
	//========================table:end=================================


	//===========================对话框：start=================================
	//打开对话框：批量设置会员等级
	function openDialogShopMemberGrade(){
		var rows = $('#datagrid').datagrid('getSelections');
		var ids = "";
		for(var i=0;i<rows.length;i++){
			ids=ids+","+rows[i].wareId;
		}
		$('#updateSpMemGradeComb').combobox('setValues', []);
		$('#dialogShopMemberGrade').dialog('open');
	}
	//打开对话框：批量设置会员等级
	function openDialogKhClose(){
		var rows = $('#datagrid').datagrid('getSelections');
		var ids = "";
		for(var i=0;i<rows.length;i++){
			ids=ids+","+rows[i].wareId;
		}
		if(ids==""){
			alert('请选择会员！');
			return;
		}
		$("input:radio[name=khClose]").attr("checked",false);//清空上次的选中
		$('#dialogKhClose').dialog('open');
	}
	//打开对话框：批量设置线下支付
	function openDialogXxzf(){
		var rows = $('#datagrid').datagrid('getSelections');
		var ids = "";
		for(var i=0;i<rows.length;i++){
			if(ids!=''){
				ids=ids+",";
			}
			ids=ids+rows[i].id;
		}
		if(ids==""){
			alert('请选择会员！');
			return;
		}
		$("input:radio[name=isXxzf]").attr("checked",false);//清空上次的选中
		$('#dialogXxzf').dialog('open');
	}
	//批量设置会员等级
	function batchShopMemberGrade(){
		var rows = $('#datagrid').datagrid('getSelections');
		var ids = "";
		for(var i=0;i<rows.length;i++){
			if(ids!=''){
				ids=ids+",";
			}
			ids=ids+rows[i].id;
		}
		if(ids==""){
			alert('请选择会员！');
			return;
		}
		var gradeId=$("#updateSpMemGradeComb").combobox("getValues");
		$.ajax({
			url:"manager/shopMember/batchUpdateShopMemberGrade",
			data:"ids="+ids+"&gradeId="+gradeId,
			type:"post",
			success:function(json){
				if(json=="1"){
					$('#dialogShopMemberGrade').dialog('close');
					query();
				}else{
					alert('批量修改会员等级更新失败');
				}
			}
		});

	}
	//批量设置会员等级
	function batchXxzf(){
		var rows = $('#datagrid').datagrid('getSelections');
		var ids = "";
		for(var i=0;i<rows.length;i++){
			if(ids!=''){
				ids=ids+",";
			}
			ids=ids+rows[i].id;
		}
		var isXxzf=$("input[name=isXxzf]:checked").val();
		$.ajax({
			url:"manager/shopMember/batchUpdateXxzf",
			data:"ids="+ids+"&isXxzf="+isXxzf,
			type:"post",
			success:function(json){
				if(json === "1"){
					$('#dialogXxzf').dialog('close');
					query();
				}else{
					alert('批量修改线下支付失败');
				}
			}
		});
	}
	//批量设置会员等级
	function batchKhClose(){
		var rows = $('#datagrid').datagrid('getSelections');
		var ids = "";
		for(var i=0;i<rows.length;i++){
			if(ids!=''){
				ids=ids+",";
			}
			ids=ids+rows[i].id;
		}
		var khClose=$("input[name=khClose]:checked").val();
		$.ajax({
			url:"manager/shopMember/batchKhClose",
			data:"ids="+ids+"&khClose="+khClose,
			type:"post",
			success:function(json){
				if(json === "1"){
					$('#dialogKhClose').dialog('close');
					query();
				}else{
					alert('批量关闭进销存客户失败');
				}
			}
		});
	}
	//===========================对话框：end=================================
</script>
</body>
</html>
