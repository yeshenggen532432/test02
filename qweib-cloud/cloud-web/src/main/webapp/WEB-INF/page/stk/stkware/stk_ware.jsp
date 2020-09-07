<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>企微宝</title>

		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="resource/loadDiv.js"></script>
	</head>

	<body>
		<input type="hidden" name="wtype" id="wtype" value="${wtype}"/>
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
			url="manager/queryStkWares?wtype=${wtype}" border="false"
			rownumbers="true" fitColumns="true" pagination="true" pagePosition=3
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
			<thead>
				<tr>
				<th field="id" width="10" align="center" hidden="true">
						商品id
					</th>
				    <th field="wareId" width="10" align="center" hidden="true">
						商品id
					</th>
					<th field="wareCode" width="80" align="center">
						商品编码
					</th>
					<th field="wareNm" width="100" align="center">
						商品名称
					</th>
					
					<th field="wareGg" width="80" align="center">
						规格
					</th>
					<th data-options="field:'inPrice',width:80,align:'center',editor:{type:'text'}">
						采购单价
					</th>
					<th field="wareDw" width="60" align="center">
						单位
					</th>
					<th field="py" width="60" align="center">
						助记码
					</th>
					<%--
					<th field="status" width="80" align="center" formatter="formatterSt3">
						是否禁用
					</th>
					 --%>
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
		    查询(商品名称/商品编码): <input name="wareNm" id="wareNm" style="width:156px;height: 20px;" onkeydown="queryWare();"/>
			<input type="hidden" name="wtype" id="wtypeid" value="${wtype}"/>	
			<%-- 
			状态: <select name="status" id="wareStatus">
	   		<option value="0">全部</option>                 
	        <option value="1">正常</option>   
	        <option value="2">禁用</option>            
	        </select>	
	        --%>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryWare();">查询</a>
			<%-- <a class="easyui-linkbutton" iconCls="icon-save" plain="true" href="javascript:submitWare();">保存</a>--%>
			<%--
			<a class="easyui-linkbutton" iconCls="icon-redo" plain="true" href="javascript:toWareModel();">下载模板</a>
			<a class="easyui-linkbutton" iconCls="icon-edit" plain="true" href="javascript:toUpWare();">上传商品</a>
			 --%>
		</div>
		
		<!-- 上传框 -->
		<div class="file-box">
		  	<form action="manager/uploadtemp" name="uploadfrm" id="uploadfrm" method="post" enctype="multipart/form-data">
		  		<input type="hidden" name="width" value="${width}"/>
				<input type="hidden" name="height" value="${height}"/>
				<input type="button" class="uploadBtn" value="上传客户" />
				<input type="file" name="upFile" id="upFile" onchange="toUpWare(this);" class="uploadFile"/>
		  	</form>
	  	</div>
  	    <div id="upDiv" class="easyui-window" style="width:500px;height:100px;padding:10px;" 
			minimizable="false" maximizable="false" collapsible="false" closed="true">
			<form action="manager/toUpWareExcel" id="upFrm" method="post" enctype="multipart/form-data">
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr height="30px">
						<td >选择文件：</td>
						<td>
						<input type="file" name="upFile" id="upFile" title="check"/>
						</td>
						<td><input type="button" onclick="toUpWareExcel();" style="width: 50px" value="上传" /></td>
					</tr>
				</table>
			</form>
		</div>
		
		<script type="text/javascript">
		    //查询
		    function initGrid()
		    {
		    	//manager/queryStkWares?wtype=${wtype}
		    	/*$('#datagrid').datagrid({
	    	    	url:"manager/queryStkWares",
	    	    	queryParams:{
	    	    		jz:"1",
	    	    		wtype:${wtype},
	    	    		
						billNo:$("#orderNo").val(),
						proName:$("#proName").val(),
						memberNm:$("#memberNm").val(),
						billStatus:$("#billStatus").val(),
						inType:$("#inType").val(),
						sdate:$("#sdate").val(),
						edate:$("#edate").val()
		    	    	
		    	    	},
	    	    		columns:[
	    	    		  		cols
	    	    		  	]}
	    	    );*/
		    }
			function queryWare(){
				$("#datagrid").datagrid('load',{
					url:"manager/queryStkWares",
					   wareNm:$("#wareNm").val(),
					   status:$("#wareStatus").val()
				});
			}		
			
			
		  
		   
		   var editIndex = undefined;
			function endEditing(){
				if (editIndex == undefined){return true}
				if ($('#datagrid').datagrid('validateRow', editIndex)){
					//var ed = $('#datagrid').datagrid('getEditor', {index:editIndex,field:'menuId'});
					//var productname = $(ed.target).combobox('getText');
					//$('#datagrid').datagrid('getRows')[editIndex]['productname'] = productname;
					$('#datagrid').datagrid('endEdit', editIndex);
					editIndex = undefined;
					return true;
				} else {
					return false;
				}
			}
		   
		   function onClickRow1(index){
			  
				if (editIndex != index){
					if (endEditing()){
						$('#datagrid').datagrid('selectRow', index)
								.datagrid('beginEdit', index);
						editIndex = index;
						
					} else {
						$('#datagrid').datagrid('selectRow', editIndex);
						
					}
				}
			}
		   
		   function accept(){
				if (endEditing()){
					$('#datagrid').datagrid('acceptChanges');
				}
			}
			function reject(){
				$('#datagrid').datagrid('rejectChanges');
				editIndex = undefined;
			}
			function getChanges(){
				var rows = $('#datagrid').datagrid('getChanges');
				alert(rows.length+' rows are changed!');
			}
			
			function submitWare()
			{
				accept();
				var arr =  $('#datagrid').datagrid('getData');
				
				
				var wareList = new Array();
				for (var i=0;i<arr.rows.length;i++) {				
					if(arr.rows[i].inPrice == null)continue;
					if(arr.rows[i].inPrice == "")continue;
					 var subObj = {
								wareId: arr.rows[i].wareId,
								inPrice: arr.rows[i].inPrice
												
						};
					wareList.push(subObj);
				}
				
				$.ajax( {
					url : "manager/updateWareInfo",
					data : {"wareStr":JSON.stringify(wareList)},
					type : "post",
					success : function(json) {
						if (json.state) {
							showMsg("保存成功");
							$("#datagrid").datagrid("reload");
						} else{
							showMsg("提交失败");
						}
					}
				});
				
			}
			
			//显示上传框
			function toUpWare(){
				$("#upDiv").window({title:'上传',modal:true});
				$("#upDiv").window('open');
			}
			//上传文件
			function toUpWareExcel(){
			       $("#upFrm").form('submit',{
					success:function(data){
						if(data=='1'){
							alert("上传成功");
							$("#upDiv").window('close');
							//window.location.href="${base}/manager/querycustomer2";
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
			
			//下载模板
		    function toWareModel() {
                  if(confirm("是否下载商品上传需要的文档?")){
					window.location.href="manager/toWareModel";
				}
	
           }
			
		    function formatterSt3(val,row){
			      if(val==2){
			      		
			      			return "<input style='width:60px;height:27px' type='button' value='已禁用' onclick='updateIsTy(this, "+row.wareId+",1)'/>";
			      		} else {
			      			return "<input style='width:60px;height:27px' type='button' value='未禁用' onclick='updateIsTy(this, "+row.wareId+",2)'/>";
			      		}
			       
			       
			   } 
		    
		    
		    function updateIsTy(_this,id,isTy){
		    	
				
				
				$.ajax( {
					url : "manager/updateWareStatus",
					data : {"wareId":id,"status":isTy},
					type : "post",
					success : function(json) {
						if (json.state) {
							showMsg("保存成功");
							$("#datagrid").datagrid("reload");
						} else{
							showMsg("提交失败");
						}
					}
				});
		   }

		</script>
	</body>
</html>
