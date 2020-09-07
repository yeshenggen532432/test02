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
		<script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
		<style>
		.file-box{position:relative;width:70px;height: auto;}
		.uploadBtn{background-color:#FFF; border:1px solid #CDCDCD;height:22px;line-height: 22px;width:70px;}
		.uploadFile{ position:absolute; top:0; right:0; height:22px; filter:alpha(opacity:0);opacity: 0;width:70px;}
	    </style>
	</head>

	<body>
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="false"
			url="manager/pos/queryPosShopInfoPage" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="true" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
			<thead>
				<tr>
					<th field="ck" checkbox="true"></th>
				    <th field="id" width="50" align="center" hidden="true">
						id
					</th>
					<th field="shopNo" width="80" align="center">
						店号
					</th>
					<th field="shopName" width="120" align="center">
						店名
					</th>
					<th field="contact" width="80" align="center">
						联系人
					</th>
					<th field="tel" width="80" align="center">
						联系电话
					</th>
					<th field="address" width="120" align="center">
						地址
					</th>
					<th field="stkName" width="120" align="center">
						仓库名称
					</th>
					<th field="canInput" width="60" align="center"  formatter="formatterSt1">
						可充值否
					</th>
					<th field="canCost" width="60" align="center"  formatter="formatterSt2">
						可消费否
					</th>
					<th field="status" width="60" align="center" formatter="formatterSt3">
						状态
					</th>
					
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
		     门店名称: <input name="shopName" id="shopName" style="width:100px;height: 20px;" onkeydown="toQuery(event);"/>
			
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryShopPage();">查询</a>
			<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:toaddShop();">添加</a>
			
				
				
				
				  <a class="easyui-linkbutton" iconCls="icon-edit" plain="true" href="javascript:getSelected();">修改</a>
				  <a class="easyui-linkbutton" iconCls="icon-remove" plain="true" href="javascript:toDel();">删除</a>
				  
				  
				
			
		</div>
	
		<script type="text/javascript"><!--

		    //查询商品
			function queryShopPage(){
			  
				$("#datagrid").datagrid('load',{
					url:"manager/pos/queryPosShopInfoPage?",
							shopName:$("#shopName").val()
					
					
				});
			  
			  
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					queryShopPage();
				}
			}
			//添加
			function toaddShop(){
				location.href="${base}/manager/pos/toPosShopInfoEdit?id=0";
			}
			//修改
			function getSelected(){
			    var row = $('#datagrid').datagrid('getSelected');
				if (row){
					
					  location.href="${base}/manager/pos/toPosShopInfoEdit?id="+row.id;
				 }else{
					alert("请选择要修改的行！");
				}
			}

		    //删除
		    function toDel() {
				var ids = 0;
				var rows = $("#datagrid").datagrid("getSelections");
				for ( var i = 0; i < rows.length; i++) {
					ids = rows[i].id;
					break;
				}
				if (ids.length > 0) {
					$.messager.confirm('确认', '您确认想要删除记录吗？', function(r) {
						if (r) {
							$.ajax( {
								url : "manager/pos/deletePosShopInfo",
								data : "id=" + ids,
								type : "post",
								success : function(json) {
									if (json.state) {
										showMsg("删除成功");
										$("#datagrid").datagrid("reload");
									}else{
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
		    
		    function formatterSt1(val,row){
		    	if(val == 0)return "不可充值";
		    	if(val ==  1)return "可充值";
		    }
		    function formatterSt2(val,row){
		    	if(val == 0)return "不可消费";
		    	if(val ==  1)return "可消费";
		    }
		   
		    function formatterSt3(val,row){
			      if(val==2){
			      		
			      		
			      			return "<input style='width:60px;height:27px' type='button' value='停用' onclick='updateIsTy("+row.id+",1)'/>";
			      		
			       }else{
			       		
			       			 return "<input style='width:60px;height:27px' type='button' value='启用' onclick='updateIsTy("+row.id+",2)'/>";
			       		
			            
			       }
			   }

			   function updateIsTy(id,status) {
				   $.ajax( {
					   url : "manager/pos/updateShopStatus",
					   data : "id=" + id+"&status=" + status,
					   type : "post",
					   success : function(json) {
						   if (json.state) {
							   //showMsg("删除成功");
							   $("#datagrid").datagrid("reload");
						   }else{
							   showMsg("修改失败");
						   }
					   }
				   });

			   }

		</script>
	</body>
</html>
