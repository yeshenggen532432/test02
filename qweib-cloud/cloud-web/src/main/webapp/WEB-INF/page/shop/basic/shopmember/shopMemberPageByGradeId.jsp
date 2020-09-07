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
	   url="manager/shopMember/shopMemberPageByGradeId?gradeId=${gradeId}" border="false"
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
		<th field="defaultAddress" width="200" align="center">
			地址
		</th>
		<th field="remark" width="100" align="center">
			备注
		</th>
		<th field="_oper" width="150" align="center" formatter="formatterOper">
			操作
		</th>
			<th field="hySource" width="100" align="center">
				会员来源
			</th>
		<th field="isXxzf" width="100" align="center" formatter="formatterIsXxzf">
			线下支付
		</th>
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
	</tr>
	</thead>
</table>
<div id="tb" style="padding:5px;height:auto">
	会员名称: <input name="name" id="name" style="width:100px;height: 20px;" />
	手机号: <input name="mobile" id="mobile" style="width:100px;height: 20px;"/>
	<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:query();">查询</a>
</div>

<%--js--%>
<script type="text/javascript">
	$(function () {
	})
	//查询会员
	function query(){
		$("#datagrid").datagrid('load',{
			url:"manager/shopMember/shopMemberPageByGradeId?gradeId=${gradeId}",
			name:$("#name").val(),
			mobile:$("#mobile").val(),
		});
	}
	//线下支付
	function formatterIsXxzf(val,row){
		console.log("val:"+val);
		var str = "";
		if(0 === val){
			str = "不显示";
		}else if(1 === val){
			str = "显示";
		}
		return str;
	}
	//显示会员启用状态
	function formatterOper(val,row){
		var html ="";
		if(row.status=='-2'){
			html ="";
		}else if(row.status=='-1'){
			html = "<input value='通过' type='button' onclick='updateStatus("+row.id+",1)'/>";
		}else if(row.status=='0'){
			html = "<input value='启用' type='button' onclick='updateStatus("+row.id+",1)'/>";
		}else if(row.status=='1'){
			html = "<input value='不启用' type='button' onclick='updateStatus("+row.id+",0)'/>";
		}
		html = html + "<input value='地址列表' type='button' onclick='showAddressList("+row.id+",\""+row.name+"\")'/>";
		return html;
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
</script>
</body>
</html>
