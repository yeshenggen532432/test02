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
			url="manager/bc/queryKqBcPage" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="true" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
			<thead>
				<tr>
					<th field="ck" checkbox="true"></th>
				    <th field="id" width="50" align="center" hidden="true">
						id
					</th>
					<th field="bcCode" width="80" align="center">
						班次编码
					</th>
					<th field="bcName" width="120" align="center">
						班次名称
					</th>
					
					<th field="count" width="120" align="center" formatter="formatterStTime">
						时间信息
					</th>
					<th field="earlyMinute" width="80" align="center" >
						上班弹性时间
					</th>
					<th field="lateMinute" width="80" align="center" >
						下班弹性时间
					</th>
					<th field="beforeMinute" width="100" align="center" >
						最早上班签到时间
					</th>
					<th field="afterMinute" width="100" align="center" >
						最晚下班签到时间
					</th>
					<th field="address" width="120" align="center" >
						考勤位置
					</th>
					<th field="outOf" width="80" align="center" formatter="formatterSt4">
						可超出否
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
		     班次名称: <input name="bcName" id="bcName" style="width:100px;height: 20px;" onkeydown="toQuery(event);"/>
			
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryBcPage();">查询</a>
			<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:toaddbc();">添加</a>
			
				
				
				
				  <a class="easyui-linkbutton" iconCls="icon-edit" plain="true" href="javascript:getSelected();">修改</a>
				  <a class="easyui-linkbutton" iconCls="icon-remove" plain="true" href="javascript:toDel();">删除</a>
				  
				  
				
			
		</div>
	
		<script type="text/javascript"><!--
		    var id="${info.datasource}";
		    var dataTp = "${dataTp}";
		    function formatterSt(val,row){
				if(val=="1"){
					return "外勤制";
				}else{
					return "固定班制";
				}
			}
			
			function formatterStTime(v,row){
				if(row.id==""||row.id==null||row.id==undefined){
					return "";
				}
				var hl='<table>';
				if(row.subList.length>0){
			        hl +='<tr>';
			        hl +='<td width="120px;"><b>上班时间</b></td>';
			        hl +='<td width="120px;"><b>下班时间</b></td>';
			        
			        hl +='</tr>';
		        }
		        for(var i=0;i<row.subList.length;i++){
		            hl +='<tr>';
			        hl +='<td>'+row.subList[i].startTime+'</td>';
			        hl +='<td>'+row.subList[i].endTime+'</td>';
			        
			        hl +='</tr>';
		        }
		        hl +='</table>';
  			    return hl;
			}
			
		    //查询商品
			function queryBcPage(){
			  
				$("#datagrid").datagrid('load',{
					url:"manager/bc/queryKqBcPage",
							bcName:$("#bcName").val()
					
					
				});
			  
			  
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					queryBcPage();
				}
			}
			//添加
			function toaddbc(){
				location.href="${base}/manager/bc/toBaseBcNew";
			}
			//修改
			function getSelected(){
			    var row = $('#datagrid').datagrid('getSelected');
				if (row){
					
					  location.href="${base}/manager/bc/toBaseBcEdit?id="+row.id;
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
								url : "manager/bc/deleteKqBc",
								data : "ids=" + ids,
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
		   function formatterSt3(val,row){
		      if(val==2){
		      		if (dataTp=='2') {
		      			return "<input style='width:60px;height:27px' type='button' value='是' onclick='updateStatus(this, "+row.id+",1)' disabled='disabled'/>";
		      		} else {
		      			return "<input style='width:60px;height:27px' type='button' value='是' onclick='updateStatus(this, "+row.id+",1)'/>";
		      		}
		       }else{
		       		if (dataTp=='1') {
		       			 return "<input style='width:60px;height:27px' type='button' value='否' onclick='updateStatus(this, "+row.id+",2)' disabled='disabled'/>";
		       		} else {
		       			 return "<input style='width:60px;height:27px' type='button' value='否' onclick='updateStatus(this, "+row.id+",2)'/>";
		       		}
		            
		       }
		   } 
		   function formatterSt4(val,row){
			      if(val==0){
			      		
			      			return "否";
			      		} else {
			      			return "是";
			      		}
			      		
			   } 
		   //修改停用
		   function updateStatus(_this,id,isTy){
				$.ajax({
					url:"manager/bc/updateBcStatus",
					type:"post",
					data:"id="+id+"&status="+isTy,
					success:function(data){
						if(data.state){
						    alert("操作成功");
							$('#datagrid').datagrid('reload');
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
