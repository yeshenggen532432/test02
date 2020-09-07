<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>会员等级分页</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="resource/loadDiv.js"></script>
	</head>
  
  <body>
    <table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="false"
			url="manager/shopMemberGrade/page" border="false"
			rownumbers="true" fitColumns="false" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
			<thead>
				<tr>
					<th  field="id" checkbox="true"></th>
					<th field="gradeName" width="80" align="center" >
						名称
					</th>
					<th field="gradeNo" width="100" align="center">
						级别
					</th>
					<th field="isXxzf" width="100" align="center" formatter="formatterIsXxzf">
						线下支付
					</th>
					<th field="isJxc" width="120" align="center" formatter="formatterIsJxc">
						进销存客户会员使用
					</th>
					<th field="status" width="100" align="center" formatter="formatterStatus">
						状态
					</th>
					<%--<th field="_oper" width="150" align="center" formatter="formatterOper">--%>
						<%--操作--%>
					<%--</th>--%>
					<th field="hy_oper" width="150" align="center" formatter="formatterHyOper">
						会员相关操作
					</th>
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
		     等级名称: <input name="gradeName" id="gradeName" style="width:156px;height: 20px;" />
			<select name="status" id="status">
				<option value="-1">全部</option>
				<option value="1" selected>启用</option>
				<option value="0">未启用</option>
			</select>
			<a class="easyui-linkbutton" iconCls="icon-search" plain="true" href="javascript:query();">查询</a>
			<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:toadd();">添加</a>
			<a class="easyui-linkbutton" iconCls="icon-edit" plain="true" href="javascript:toedit();">修改</a>
			<%--<a class="easyui-linkbutton" iconCls="icon-remove" plain="true" href="javascript:todel();">删除</a>--%>
			<a class="easyui-linkbutton" iconCls="icon-edit" plain="true" href="javascript:setGradePrice();">会员等级价格设置</a>
		</div>

	<%--选择会员对话框--%>
	<div id="memberDlg" closed="true" class="easyui-dialog" style="width:500px; height:200px;" title="会员选择" iconCls="icon-edit"></div>
		
		
		<!-- ===================================以下是js========================================= -->
		<script type="text/javascript">
			//====================增删改查：start==========================
		    //查询
			function query(){
				$("#datagrid").datagrid('load',{
					url:"manager/shopMemberGrade/page",
					gradeName:$("#gradeName").val(),
					status:$("#status").val(),
				});
			}
			
			//添加
			function toadd(){
				  window.location.href="${base}/manager/shopMemberGrade/add";
			}
			
			//删除
			function todel(){
				var row = $('#datagrid').datagrid('getSelected');
				if (row){
					if(confirm("是否要删除选中的会员等级?")){
						$.ajax({
							url:"manager/shopMemberGrade/delete",
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
			
			//修改
			function toedit(){
				var row = $('#datagrid').datagrid('getSelected');
				if (row){
				    var id = row.id;
					window.location.href="${base}/manager/shopMemberGrade/edit?id="+id;
				}else{
					alert("请选择行");
				}
			}

			//====================增删改查：end=========================

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

			function updateStatus(id,status){
					if(confirm("是否确定操作?")){
						$.ajax({
							url:"manager/shopMemberGrade/updateStatus",
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

			function formatterStatus(val,row){
				var html ="";
				if(row.status=='1'){
					html= "<input value='不启用' style='width:50px;' type='button' onclick='updateStatus("+row.id+",0)'/>";
				}else if(row.status=='0'){
					html="<input value='启用' style='width:50px;' type='button' onclick='updateStatus("+row.id+",1)'/>";
				}
				return html;
			}

			function formatterOper(val,row){
			}

			function formatterIsJxc(val,row){
				 if(row.isJxc === 1){
					 return '是';
			     }
			}
			//按会员等级设置商品销售价格
			function setGradePrice(){
				var row = $('#datagrid').datagrid('getSelected');
				if (row){
					window.parent.add("会员等级价格设置_"+row.gradeName,"manager/shopMemberGrade/gradePriceWaretype?gradeId="+row.id);
				}else{
					alert("请选择行");
				}
			}


			var gradeId;
			var mType;//1：添加；2：删除
			function formatterHyOper(val,row){
				var gradeId = row.id;
				var gradeName = row.gradeName;
				var isJxc = row.isJxc;
				var html = "<button onclick='dialogSelectMember("+gradeId+","+isJxc+",1,1)'>添加</button>";
				html += "<button onclick='dialogSelectMember("+gradeId+","+isJxc+",2,1)'>移除</button>";
				html += "<button onclick='dialogSelectMember("+gradeId+","+isJxc+",2,0)'>查看</button>";
				return html;
			}

			//按gradeId查询会员
			function queryShopMemberByGradeId(gradeId,gradeName){
				parent.closeWin(gradeName+"_会员列表");
				window.parent.add(gradeName+"_会员列表","manager/shopMember/toShopMemberByGradeId?gradeId="+gradeId);
			}

			//弹出“选择会员”对话框
			function dialogSelectMember(id,isJxc,type,showBotton){
				gradeId = id;
				mType = type;
				if(isJxc!=null && isJxc!=undefined && isJxc=='1'){
					isJxc = 1;
				}else{
					isJxc = 0;
				}
				var title='移除会员';
				if(!showBotton)
					title='查看会员';
				$('#memberDlg').dialog({
					title: title,
					iconCls:"icon-edit",
					width: 800,
					height: 400,
					modal: true,
					href: "${base}/manager/shopMember/toDialogShopMember2?gradeId="+gradeId+"&isJxc="+isJxc+"&type="+type+"&showBotton="+showBotton,
					onClose: function(){
					}
				});
				$('#memberDlg').dialog('open');
			}

			//选择会员-回调
			function callBackFunSelectMemeber(ids){
				if(mType==2){
					gradeId = null;
				}
				$.ajax({
					url:"manager/shopMember/batchUpdateShopMemberGrade",
					data:"ids="+ids+"&gradeId="+gradeId,
					type:"post",
					success:function(json){
						if(json!="-1"){
							alert('操作成功');
						}else{
							alert('操作失败');
						}
					}
				});
			}


			
		</script>
  </body>
</html>
