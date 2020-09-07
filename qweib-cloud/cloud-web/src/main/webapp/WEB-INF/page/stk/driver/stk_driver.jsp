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
			url="manager/queryDriverPage" title="" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="true" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
			<thead>
				<tr>
					<th field="ck" checkbox="true"></th>
				    <th field="id" width="50" align="center" hidden="true">
						driverId
					</th>
					<th field="driverName" width="80" align="center">
						姓名
					</th>
					<th field="tel" width="120" align="center">
						联系电话
					</th>
					<th field="memberName" width="120" align="center">
						关联员工
					</th>

					<th field="status" width="80" align="center" formatter="formatterSt3">
						是否禁用
					</th>
					
					
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
		     姓名: <input name="driverName" id="driverName" style="width:100px;height: 20px;" onkeydown="toQuery(event);"/>
			
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:querydriver();">查询</a>
			<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:toadddriver();">添加</a>
			
				
				
				
				  <a class="easyui-linkbutton" iconCls="icon-edit" plain="true" href="javascript:getSelected();">修改</a>
				  <a class="easyui-linkbutton" iconCls="icon-remove" plain="true" href="javascript:toDel();">删除</a>
				 
				  
				  
				
			
		</div>
		<div class="file-box">
		  	<form action="manager/uploadtemp" name="uploadfrm" id="uploadfrm" method="post" enctype="multipart/form-data">
		  		<input type="hidden" name="width" value="${width}"/>
				<input type="hidden" name="height" value="${height}"/>
				<input type="button" class="uploadBtn" value="上传成员" />
				<input type="file" name="upFile" id="upFile" onchange="toupload(this);" class="uploadFile"/>
		  	</form>
	  	</div>
  	    <div id="upDiv" class="easyui-window" style="width:500px;height:100px;padding:10px;" 
			minimizable="false" maximizable="false" collapsible="false" closed="true">
			<form action="manager/toUpExcel" id="upFrm" method="post" enctype="multipart/form-data">
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr height="30px">
						<td >选择文件：</td>
						<td>
						<input type="file" name="upFile" id="upFile" title="check"/>
						</td>
						<td><input type="button" onclick="toUpExcel();" style="width: 50px" value="上传" /></td>
					</tr>
				</table>
			</form>
		</div>
		<div id="choiceWindow" class="easyui-window" style="width:800px;height:400px;" 
			minimizable="false" maximizable="false" collapsible="false" closed="true" modal="true">
			<iframe name="windowifrm" id="windowifrm" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
		</div>
		<div id="treeDiv" class="easyui-window" style="width:300px;height:400px;" 
			minimizable="false" modal="true" collapsible="false" closed="true">
			<form name="rolemenufrm" id="rolemenufrm" method="post">
				<input type="hidden" name="zusrId" id="zusrId"/>
				<div id="divHYGL" class="menuTree" data-options="region:'north'" style="width: 280px;height:330px;overflow: auto;padding-left: 5px;">
					<div id="divHYGL_tree" class="dtree"></div>
				</div>
				<div style="text-align: center;" data-options="region:'south',border:false">
				    <input type="checkbox" id="checkbox1" name="checkbox1" onclick="qxfx();"/>
				    &nbsp;&nbsp;
					<a class="easyui-linkbutton" href="javascript:saverolepri();">保存</a>
					&nbsp;&nbsp;
					<a class="easyui-linkbutton" href="javascript:closetreewin();">关闭</a>
				</div>
			</form>
		</div>
		<script type="text/javascript"><!--
		    var id="${info.datasource}";
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
			function formatterSt2(val,row){
				if(val=="0"){
					return "普通成员";
				}else if(val=="1"){
					return "公司创建者";
				}else if(val=="2"){
					return "公司管理员";
				}else if(val=="3"){
					return "部门管理员";
				}else{
					return "-";
				}
			}
		    //查询商品
			function querydriver(){
				$("#datagrid").datagrid('load',{
					url:"manager/queryDriverPage?dataType=1&driverName="+$("#driverName").val()
					
					
				});
			  
			  
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					querydriver();
				}
			}
			//添加
			function toadddriver(){
				location.href="${base}/manager/toDriverEdit";
			}
			//修改
			function getSelected(){
			    var row = $('#datagrid').datagrid('getSelected');
				if (row){
					
					  location.href="${base}/manager/toDriverEdit?Id="+row.id;
				 }else{
					alert("请选择要修改的行！");
				}
			}
			//显示上传框
			function toUpLoad(){
				$("#upDiv").window({title:'上传',modal:true});
				$("#upDiv").window('open');
			}
			//上传文件
			function toUpExcel(){
			       $("#upFrm").form('submit',{
					success:function(data){
						if(data=='1'){
							alert("上传成功");
							$("#upDiv").window('close');
							querymember();
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
		    //下载上传成员的excel模板
		    function toLoadModel(){
		    	if(confirm("是否下载成员上传需要的文档?")){
					window.location.href="${base}/manager/toLoadModel";
				}
			}
		    
		    function test()
		    {
		    	$.ajax( {
					url : "manager/testadd",
					data : "ids=" + "11",
					type : "post",
					success : function(json) {
						if (json == 1) {
							showMsg("删除成功");
							$("#datagrid").datagrid("reload");
						}else if (json == -2) {
							showMsg("包含有当前登陆用户，不能删除！");
						} else if (json == -1) {
							showMsg("删除失败");
						}
					}
				});
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
								url : "manager/deleteDriver",
								data : "ids=" + ids,
								type : "post",
								success : function(json) {
									if (json == 1) {
										showMsg("删除成功");
										$("#datagrid").datagrid("reload");
									}else if (json == -2) {
										showMsg("包含有当前登陆用户，不能删除！");
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
		   //修改停用
		   function updateIsTy(_this,id,isTy){
				$.ajax({
					url:"manager/updateDriverStatus",
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
		   function formatterSt4(val,row){
		      if(val){
		        if(val=='1'){
		        	if (dataTp=='3') {
		           		return "<input style='width:60px;height:27px' type='button' value='绑定' onclick='updateUnId(this, "+row.memberId+",1)' disabled='disabled'/>";
		        	} else {
		           		return "<input style='width:60px;height:27px' type='button' value='绑定' onclick='updateUnId(this, "+row.memberId+",1)'/>";
		        	}
		        }else{
		        	if (dataTp=='3') {
		          		 return "<input style='width:60px;height:27px' type='button' value='解绑设备' onclick='updateUnId(this, "+row.memberId+",2)' disabled='disabled'/>";
		        	} else {
		           		return "<input style='width:60px;height:27px' type='button' value='解绑设备' onclick='updateUnId(this, "+row.memberId+",2)'/>";
		        	}
		        }
		      }else{
		      	if (dataTp=='3') {
		       	 return "<input style='width:60px;height:27px' type='button' value='不绑定' onclick='updateUnId(this, "+row.memberId+",3)' disabled='disabled'/>";
		      	} else {
		       	 return "<input style='width:60px;height:27px' type='button' value='不绑定' onclick='updateUnId(this, "+row.memberId+",3)'/>";
		      	}
		      }
		   } 
		   //解绑设备
		   function updateUnId(_this,id,isTy){
				$.ajax({
					url:"manager/updateUnId",
					type:"post",
					data:"id="+id+"&isTy="+isTy,
					success:function(data){
						if(data=='1'){
						    alert("解绑设备成功");
							$('#datagrid').datagrid('reload');
						}else if(data=='2'){
						    alert("操作成功");
							$('#datagrid').datagrid('reload');
						}else{
							alert("解绑设备失败");
							return;
						}
					}
				});
		   }
		   function formatterSt5(val,row){
		      if(row.memberUse==2){
		       	if (dataTp=='3') {
		        	return "<input style='width:60px;height:27px' type='button' value='转让客户' onclick='choicemember("+row.memberId+");' disabled='disabled'/>";
		       	} else {
		        	return "<input style='width:60px;height:27px' type='button' value='转让客户' onclick='choicemember("+row.memberId+");'/>";
		       	}
		      }
		   } 
		  
		   
		   //显示弹出窗口
			function showWindow(title){
				$("#choiceWindow").window({
					title:title,
					top:getScrollTop()+50
				});
				$("#choiceWindow").window('open');
			}
			
			
			//显示用户树
			function loadTree_usr(treeName,objDiv,title,data){
				var treeName=treeName+"_d";
				var objTree =treeName;
				objTree = new dTree(treeName);
				objTree.add(0,-1,title);
				if(data){
				    for(var i=0;i<data.length;i++){
						var nodeid  = data[i].usrid;
						var nodevl  = data[i].usrnm;
						var parid   = 0;
						var isuse   = data[i].isuse;
		   				var chosevalue;
		   				if(isuse=="0"){
					    	chosevalue="<input type=\"checkbox\" name=\"cusrIds\" value=\""+nodeid+"\" />";
					    }else{
					    	chosevalue="<input type=\"checkbox\" name=\"cusrIds\" checked=\"checked\" value=\""+nodeid+"\" />";
					    }
						objTree.add(nodeid,parid,nodevl+chosevalue,"javascript:void();");	
					}
				    eval(treeName +"= objTree");
				    document.getElementById(objDiv).innerHTML=objTree;
				}
			}
			//保存角色分配功能
			function saverolepri(){
				$("#rolemenufrm").form('submit',{
					url:"manager/addZcUsr",
					success:function(data){
					    showMsg(data);
						closetreewin();
					}
				});
			}
			function closetreewin(){
				$("#treeDiv").window('close');
			}
			function qxfx(){
			   var arrSon = document.getElementsByName("checkbox1");
			   var arrSon2 = document.getElementsByName("cusrIds");
			   for(var i=0; i<arrSon.length; i++) {
			     if(arrSon[i].checked) {
			          for(var j=0; j<arrSon2.length; j++) {
			            arrSon2[j].checked=true;
			          }
			     }else{
			         for(var j=0; j<arrSon2.length; j++) {
			            arrSon2[j].checked=false;
			          }
			     }
			   }
			}
		--></script>
	</body>
</html>
