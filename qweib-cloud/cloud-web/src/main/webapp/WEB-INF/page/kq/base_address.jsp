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

	<body class="easyui-layout" fit="true">
	<div data-options="region:'west',split:true,title:'地址(请在APP端“考勤-班次设置”下采集相应考勤位置)'"
			style="width:350px;padding-top: 5px;">
			
				<table id="datagrid1" class="easyui-datagrid" fit="true" singleSelect="false"
			url="manager/bc/queryAddressList" border="false"
			rownumbers="true" fitColumns="true" data-options="onClickCell: onClickCell"
			>
			<thead>
				<tr>
				

					<th field="address" width="250" align="center">
						地址
					</th>
					
					<th field="ope" width="120" align="center" formatter="formatterSt3">
						操作
					</th>
					
				</tr>
			</thead>
			</table>
			
		</div>
		<div id="departDiv" data-options="region:'center'" title="班次信息">
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="false"
			iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="true" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" >
			<thead>
				<tr>
					
				    <th field="id" width="50" align="center" hidden="true">
						id
					</th>
					<th field="bcCode" width="80" align="center">
						班次编码
					</th>
					<th field="bcName" width="120" align="center">
						班次名称
					</th>
					
					
					
				</tr>
			</thead>
		</table>
		</div>
		<div id="dlg" closed="true" class="easyui-dialog" title="修改地址" style="width:500px;height:300px;padding:10px"
			data-options="
				iconCls: 'icon-save',
				
				buttons: [{
					text:'确定',
					iconCls:'icon-ok',
					handler:function(){
						updateAddress();
					}
				},{
					text:'取消',
					handler:function(){
						$('#dlg').dialog('close');
					}
				}]
			">
		<div class="box">
		<dd>
		<input type="hidden" id="address1"  />
		
		</dd>
		
	    
		<dd>
		<span class="title">新地址：</span>
	       			<input class="reg_input" name="address" id="address"  style="width: 220px"/>
	       			</dd>
		</div>
		</div>
	
		<script type="text/javascript"><!--
		    var id="${info.datasource}";
		    var dataTp = "${dataTp}";
		    
			
			
			
		    //查询商品
			function queryBcPage(address){
			  
				$('#datagrid').datagrid({
					url:"manager/bc/queryKqBcPage",
					queryParams:{					
						address:address
					
					}
					
				});
				
			  
			  
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					queryBcPage();
				}
			}
			
			
		    
		   function formatterSt3(val,row){
			   return "<input style='width:60px;height:27px' type='button' value='修改' onclick='showAddressEdit("+row.address+")'/>"; 
		      
		   } 
		   function onClickCell(index, field) { 
		    
			   if(field == "address")
				   {
				   var rows = $("#datagrid1").datagrid("getRows");
			   queryBcPage(rows[index].address);
				   }
			   if(field == "ope")
				   {
				   var rows = $("#datagrid1").datagrid("getRows");
				   showAddressEdit(rows[index].address);
				   }
		    }
		   
		   function showAddressEdit(address)
		   {
			   $("#address1").val(address);
			   $("#address").val(address);
			   $('#dlg').dialog('open');
		   }
		   //修改停用
		   function updateAddress(){
			   var address = $("#address").val();
			   var address1 = $("#address1").val();
				$.ajax({
					url:"manager/bc/updateKqAddress",
					type:"post",
					data:"address="+address + "&address1=" + address1,
					success:function(data){
						if(data.state){
						    alert("操作成功");
							$('#datagrid1').datagrid('reload');
							$('#dlg').dialog('close');
						}else{
							alert("操作失败");
							return;
						}
					}
				});
		   }

		</script>
	</body>
</html>
