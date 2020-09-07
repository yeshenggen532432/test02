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
		<script type="text/javascript" src="resource/stkstyle/js/Syunew3.js"></script>
		<style>
		.file-box{position:relative;width:70px;height: auto;}
		.uploadBtn{background-color:#FFF; border:1px solid #CDCDCD;height:22px;line-height: 22px;width:70px;}
		.uploadFile{ position:absolute; top:0; right:0; height:22px; filter:alpha(opacity:0);opacity: 0;width:70px;}
	    </style>
	</head>

	<body onload="load()">
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
			url="manager/memberPage?dataTp=${dataTp }" title="成员列表" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="false" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
			<thead>
				<tr>
					<%--hidden="true"--%>
					<th field="ck" checkbox="true"></th>
				    <th field="memberId" width="60" align="center" >
						memberId
					</th>
					<th field="memberNm" width="80" align="center">
						姓名
					</th>
					<th field="firstChar" width="50" align="center">
						首字母
					</th>
					<th field="memberMobile" width="80" align="center" >
						手机号码
					</th>
					<th field="rzMobile" width="128" align="center" formatter="formatRzMobile">
						<span onclick="javascript:editRzMobile();">认证手机✎</span>
					</th>
					<th field="memberCompany" width="120" align="center" >
						公司
					</th>
					<c:if test="${!empty info.datasource}">
					<th field="branchName" width="80" align="center" >
						部门
					</th>
					</c:if>
					<th field="memberJob" width="50" align="center" >
						职位
					</th>
					<th field="memberTrade" width="50" align="center" >
						行业
					</th>
					<th field="memberHometown" width="120" align="center" >
						家乡
					</th>
					<th field="isLead" width="60" align="center" formatter="formatterSt">
						是否领导
					</th>
					<th field="isAdmin" width="90" align="center" formatter="formatterSt1">
						是否超级管理员
					</th>
					<c:if test="${!empty info.datasource}">
						<th field="memberUse" width="60" align="center" formatter="formatterSt3">
							在职状态
						</th>
						<th field="oper1" width="70" align="center" formatter="formatterSt5">
							转让客户
						</th>
						<th field="unId" width="70" align="center" formatter="formatterSt4">
							设备操作
						</th>
						<%-- <c:if test="${dataTp!='3'}"> --%>
							<th field="oper" width="90" align="center" formatter="formaterrusr">
						<%-- </c:if> --%>
							分配实时查岗
						</th>
					</c:if>

				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
		     姓名: <input name="memberNm" id="memberNm" style="width:100px;height: 20px;" onkeydown="toQuery(event);"/>
			手机号码: <input name="memberMobile" id="memberMobile" style="width:100px;height: 20px;" onkeydown="toQuery(event);"/>
			<c:if test="${!empty info.datasource}">
			在职状态：<select id="memberUse" name="memberUse">
						<option value="">全部</option>
						<option value="1">在职</option>
						<option value="2">离职</option>
					</select>
			</c:if>
			<c:if test="${empty info.datasource}">
			公司: <input name="memberCompany" id="memberCompany" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
			</c:if>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:querymember();">查询</a>
			<c:if test="${dataTp!=3}">
				<a class="easyui-linkbutton" iconCls="icon-remove" plain="true" href="javascript:toDel();">删除</a>
				<a class="easyui-linkbutton" iconCls="icon-edit" plain="true" href="javascript:getSelected();">修改</a>
				<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:toaddmember();">添加</a>
				<a class="easyui-linkbutton" iconCls="icon-redo" plain="true" href="javascript:transferCreator();">转移创建者</a>
				<a class="easyui-linkbutton" iconCls="icon-redo" plain="true" href="javascript:transferManager();">转移管理员</a>
				<c:if test="${!empty info.datasource}">

				  <a class="easyui-linkbutton" iconCls="icon-redo" plain="true" href="javascript:toLoadModel();">下载模板</a>
				  <a class="easyui-linkbutton" iconCls="icon-edit" plain="true" href="javascript:toUpLoad();">上传成员</a>
				</c:if>
			</c:if>
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
		
		<!-- 位置上传 方式-->
		<div id="addressUploadDiv" class="easyui-window" style="width:400px;height:150px;padding:10px;" 
			minimizable="false" maximizable="false" collapsible="false" closed="true">
			<form action="manager/updateAddressUpload" id="addressUploadlFrm" name="addressUploadlFrm" method="post">
				<input type="hidden" name="memId" id="memId"/>
				<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center">
				    <tr height="30px">
				    	<td >
							<label class="title" >上传方式：</label>
			        		<input type="radio" name="upload" checked="checked" value="0"/>不上传
			        		<input type="radio" name="upload"  value="1"/>上传
		        		</td>
					</tr>
				    <tr height="30px">
						<td >
							<label class="title" >间隔分钟：</label>
						    <select id="min" name="min">
								<option value="1" selected="selected">1</option>
								<option value="2">2</option>
								<option value="3">3</option>
								<option value="4">4</option>
								<option value="5">5</option>
							</select>
						</td>
					</tr>
				    <tr height="40px">
						<td >
							<a class="easyui-linkbutton" href="javascript:updateAddressUpload();">保存</a>
							<a class="easyui-linkbutton" href="javascript:hideAddressUpload();">关闭</a>
						</td>
					</tr>
				</table>
			</form>
		</div>
		<script type="text/javascript">
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
			function querymember(){
			  if(!id){
				$("#datagrid").datagrid('load',{
					url:"manager/memberPage?dataTp="+dataTp,
					memberCompany:$("#memberCompany").val(),
					memberNm:$("#memberNm").val(),
					memberMobile:$("#memberMobile").val()
				});
			  }else{
				 $("#datagrid").datagrid('load',{
					url:"manager/memberPage?dataTp="+dataTp,
					memberNm:$("#memberNm").val(),
					memberMobile:$("#memberMobile").val(),
					memberUse:$("#memberUse").val()
				});
			  }
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					querymember();
				}
			}
			//添加
			function toaddmember(){
				location.href="${base}/manager/company/role/admin/toopermember";
			}
			//修改
			function getSelected(){
			    var row = $('#datagrid').datagrid('getSelected');
				if (row){
					$.ajax( {
						url : "manager/member/can_edit",
						data : {member_id: row.memberId},
						type : "GET",
						dataType: "json",
						success : function(response) {
							if (response.code == 200) {
								location.href="${base}/manager/toopermember?Id="+row.memberId+"&branchName="+row.branchName;
							} else {
								alert(response.message);
							}
						}
					});
				 }else{
					alert("请选择要修改的行！");
				}
			}
			//转移创建者
			function transferCreator(){
                var row = $('#datagrid').datagrid('getSelected');
                if(row){
                    $.ajax( {
                        url : "manager/company/role/creator/change",
                        data : "member_id=" + row.memberId,
                        type : "post",
                        success : function(json) {
                            showMsg(json.message);
                        }
                    });
				}else {
                    alert("请选择要修改的行！");
				}
			}


			//转移管理者
            function transferManager(){
                var row = $('#datagrid').datagrid('getSelected');
                if(row){
                    $.ajax( {
                        url : "manager/company/role/admin/assign",
                        data : "usrid=" + row.memberId,
                        type : "post",
                        success : function(json) {
                            showMsg(json.message);
                        }
                    });
                }else {
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
		    //删除
		    function toDel() {
				var ids = [];
				var rows = $("#datagrid").datagrid("getSelections");
				for ( var i = 0; i < rows.length; i++) {
					ids.push(rows[i].memberId);
				}
				if (ids.length > 0) {
					$.messager.confirm('确认', '您确认想要删除记录吗？', function(r) {
						if (r) {
							$.ajax( {
								url : "manager/delMember",
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
		      			return "<input style='width:60px;height:27px' type='button' value='已离职' onclick='updateIsTy(this, "+row.memberId+",1)' disabled='disabled'/>";
		      		} else {
		      			return "<input style='width:60px;height:27px' type='button' value='已离职' onclick='updateIsTy(this, "+row.memberId+",1)'/>";
		      		}
		       }else{
		       		if (dataTp=='3') {
		       			 return "<input style='width:60px;height:27px' type='button' value='在职' onclick='updateIsTy(this, "+row.memberId+",2)' disabled='disabled'/>";
		       		} else {
		       			 return "<input style='width:60px;height:27px' type='button' value='在职' onclick='updateIsTy(this, "+row.memberId+",2)'/>";
		       		}
		            
		       }
		   } 
		   //修改停用
		   function updateIsTy(_this,id,isTy){
				$.ajax({
					url:"manager/updateIsTy",
					type:"post",
					data:"id="+id+"&isTy="+isTy,
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
		       	 return "<input style='width:60px;height:27px' type='button' value='永不绑定' onclick='updateUnId(this, "+row.memberId+",3)' disabled='disabled'/>";
		      	} else {
		       	 return "<input style='width:60px;height:27px' type='button' value='永不绑定' onclick='updateUnId(this, "+row.memberId+",3)'/>";
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
		   
		   function formatterSt6(val,row){
			    if(row.useDog==1){
		        	ret= "<input style='width:60px;height:27px' type='button' value='写加密锁' onclick='writeDogProc("+row.memberId+"," + row.memberMobile+");'/>";
		        	return ret + "<input style='width:60px;height:27px' type='button' value='取消验证' onclick='updateDog("+row.memberId + ",0"+");'/>";
			    }else{
			    	ret= "<input style='width:60px;height:27px' type='button' value='写加密锁' onclick='writeDogProc("+row.memberId+"," + row.memberMobile+");'/>";
			    	return ret;
			    }
			      
			} 
		   //位置上传方式
		   function formatterSt7(val,row){
		      if(1==row.upload){
		      		return "上传";
		        	//return "<input style='width:60px;height:27px' type='button' value='上传' />";
		      }else{
		      		return "不上传";
		    	    //return "<input style='width:60px;height:27px' type='button' value='不上传' />";
		      }
		   } 
		   //业务员位置上传方式
		   function formatterSt10(val,row){
		   		console.log(row.memUpload);
		      if('0'==row.memUpload){
		      		return "永不上报";
		      }else{
		      		return "始终上报";
		      }
		   } 
		   function formatterSt8(val,row){
		      if(1==row.upload){
		        	return row.min;
		      }else{
		    	    return "";
		      }
		   } 
		   //位置上传方式
		   function formatterSt9(val,row){
		   	  var html="";
		   	  html= html+"<input style='width:40px;height:27px' type='button' value='设置' onclick='toUpdateAddressUpload("+row.memberId+"," + 0+");'/>";
		      return html;
		   } 
		   	
			function toUpdateAddressUpload(val,row) {
				$("#memId").val(val);
				toreset('addressUploadlFrm');
				showAddressUpload("修改位置上传方式");
			}
			//显示位置上传框
			function showAddressUpload(title){
				$("#addressUploadDiv").window({title:title});
				$("#addressUploadDiv").window('open');
			}
			function hideAddressUpload(){
				$("#addressUploadDiv").window('close');
			}
			//添加客户等级
			function updateAddressUpload(){
				$('#addressUploadlFrm').form('submit', {
					success:function(data){
						$("#addressUploadDiv").window('close');
						if(data=="1"){
						    alert("操作成功");
							$('#datagrid').datagrid('reload');
						}else{
							alert("操作失败");
						}
					}
				});
			}
			
			//选择业务员
			function choicemember(mid1) {
				document.getElementById("windowifrm").src = "manager/querychoicememberzr?mid1="
						+ mid1;
				showWindow("选择业务员");
			}
			//转让客户
			function setMember(mid1, mid2) {
				$.ajax({
					url : "manager/updateZrKh",
					type : "post",
					data : "mid1=" + mid1 + "&mid2=" + mid2,
					success : function(data) {
						if (data == '1') {
							alert("转让客户成功");
							$('#datagrid').datagrid('reload');
						} else {
							alert("转让客户失败");
							return;
						}
					}
				});
				$("#choiceWindow").window('close');
			}
			//显示弹出窗口
			function showWindow(title) {
				$("#choiceWindow").window({
					title : title,
					top : getScrollTop() + 50
				});
				$("#choiceWindow").window('open');
			}
			//格式分配用户
			function formaterrusr(val, row) {
				var html="<a class=\"easyui-linkbutton l-btn l-btn-plain\" iconcls=\"icon-add\" plain=\"true\" href=\"javascript:toroleusr("+row.memberId+");\" >"; 
				html += "<span class=\"l-btn-left\"> <span class=\"l-btn-text icon-add l-btn-icon-left\">设置</span></span>";
				html += "</a>";
		        return html;
				/* return '<a class="easyui-linkbutton l-btn l-btn-plain" iconcls="icon-add" plain="true" href="javascript:toroleusr('
						+ row.memberId
						+ ');"><span class="l-btn-left"><span class="l-btn-text icon-add l-btn-icon-left"></span></span></a>'; */
			}
			//分配用户
			function toroleusr(idKey) {
				$("#divHYGL_tree").empty();
				$("#zusrId").val(idKey);
				$.ajax({
					type : "post",
					url : "manager/queryUsrForRole",
					data : "id=" + idKey,
					success : function(data) {
						if (data) {
							loadTree_usr("divHYGL", "divHYGL_tree", "分配用户",
									data);
						}
					}
				});
				$("#treeDiv").window({
					title : "分配用户"
				});
				$("#treeDiv").window('open');
			}
			//显示用户树
			function loadTree_usr(treeName, objDiv, title, data) {
				var treeName = treeName + "_d";
				var objTree = treeName;
				objTree = new dTree(treeName);
				objTree.add(0, -1, title);
				if (data) {
					for (var i = 0; i < data.length; i++) {
						var nodeid = data[i].usrid;
						var nodevl = data[i].usrnm;
						var parid = 0;
						var isuse = data[i].isuse;
						var chosevalue;
						if (isuse == "0") {
							chosevalue = "<input type=\"checkbox\" name=\"cusrIds\" value=\""+nodeid+"\" />";
						} else {
							chosevalue = "<input type=\"checkbox\" name=\"cusrIds\" checked=\"checked\" value=\""+nodeid+"\" />";
						}
						objTree.add(nodeid, parid, nodevl + chosevalue,
								"javascript:void();");
					}
					eval(treeName + "= objTree");
					document.getElementById(objDiv).innerHTML = objTree;
				}
			}
			//保存角色分配功能
			function saverolepri() {
				$("#rolemenufrm").form('submit', {
					url : "manager/addZcUsr",
					success : function(data) {
						showMsg(data);
						closetreewin();
					}
				});
			}
			function closetreewin() {
				$("#treeDiv").window('close');
			}
			function qxfx() {
				var arrSon = document.getElementsByName("checkbox1");
				var arrSon2 = document.getElementsByName("cusrIds");
				for (var i = 0; i < arrSon.length; i++) {
					if (arrSon[i].checked) {
						for (var j = 0; j < arrSon2.length; j++) {
							arrSon2[j].checked = true;
						}
					} else {
						for (var j = 0; j < arrSon2.length; j++) {
							arrSon2[j].checked = false;
						}
					}
				}
			}
			var keyid = "";//软件狗系列号
			var gMemId = 0;
			var gMobile = "";
			function writeDogProc(memberId, mobile) {
				gMemId = memberId;
				gMobile = mobile;
				writeDog();

				//alert("设置成功");
			}
			function updateDog(memberId, useDog) {
				$.ajax({
					url : "manager/updateUseDog",
					type : "post",
					data : "memberId=" + memberId + "&useDog=" + useDog
							+ "&idKey=" + keyid,
					success : function(data) {
						if (data == '1') {
							alert("设置成功");
							$('#datagrid').datagrid('reload');
						} else {
							alert("设置失败");
							return;
						}
					}
				});
			}

			//软件狗操作

			var bConnect = 0;

			function load()

			{

				//如果是IE10及以下浏览器，则跳过不处理，

				if (navigator.userAgent.indexOf("MSIE") > 0
						&& !navigator.userAgent.indexOf("opera") > -1)
					return;

				try

				{

					var s_pnp = new SoftKey3W();

					s_pnp.Socket_UK.onopen = function()

					{

						bConnect = 1;//代表已经连接，用于判断是否安装了客户端服务

					}

					//在使用事件插拨时，注意，一定不要关掉Sockey，否则无法监测事件插拨

					s_pnp.Socket_UK.onmessage = function got_packet(Msg)

					{

						var PnpData = JSON.parse(Msg.data);

						if (PnpData.type == "PnpEvent")//如果是插拨事件处理消息

						{

							if (PnpData.IsIn)

							{

								alert("UKEY已被插入");

							}

							else

							{

								alert("UKEY已被拨出");

							}

						}

					}

					s_pnp.Socket_UK.onclose = function()

					{

					}

				}

				catch (e)

				{

					alert(e.name + ": " + e.message);

					return false;

				}

			}

			var digitArray = new Array('0', '1', '2', '3', '4', '5', '6', '7',
					'8', '9', 'a', 'b', 'c', 'd', 'e', 'f');

			function toHex(n) {

				var result = ''
				var start = true;

				for (var i = 32; i > 0;) {
					i -= 4;
					var digit = (n >> i) & 0xf;

					if (!start || digit != 0) {
						start = false;
						result += digitArray[digit];
					}
				}

				return (result == '' ? '0' : result);
			}
			function writeDog() {
				//如果是IE10及以下浏览器，则使用AVCTIVEX控件的方式

				if (navigator.userAgent.indexOf("MSIE") > 0
						&& !navigator.userAgent.indexOf("opera") > -1)
					return Handle_IE10();

				//判断是否安装了服务程序，如果没有安装提示用户安装

				if (bConnect == 0)

				{

					window.alert("未能连接服务程序，请确定服务程序是否安装。");
					return false;

				}
				try {
					var DevicePath, mylen, ret, username, mykey, outstring, address, mydata, i, InString, versionex, version, seed;
					var ProduceDate, macAddr;

					//由于是使用事件消息的方式与服务程序进行通讯，

					//好处是不用安装插件，不分系统及版本，控件也不会被拦截，同时安装服务程序后，可以立即使用，不用重启浏览器

					//不好的地方，就是但写代码会复杂一些

					var s_simnew1 = new SoftKey3W(); //创建UK类

					s_simnew1.Socket_UK.onopen = function() {

						s_simnew1.ResetOrder();//这里调用ResetOrder将计数清零，这样，消息处理处就会收到0序号的消息，通过计数及序号的方式，从而生产流程

					}

					//写代码时一定要注意，每调用我们的一个UKEY函数，就会生产一个计数，即增加一个序号，较好的逻辑是一个序号的消息处理中，只调用我们一个UKEY的函数

					s_simnew1.Socket_UK.onmessage = function got_packet(Msg)

					{

						var UK_Data = JSON.parse(Msg.data);

						if (UK_Data.type != "Process")
							return;//如果不是流程处理消息，则跳过

						//alert(Msg.data);

						switch (UK_Data.order)

						{

						case 0:

						{

							s_simnew1.FindPort(0);//查找加密锁

						}

							break;//!!!!!重要提示，如果在调试中，发现代码不对，一定要注意，是不是少了break,这个少了是很常见的错误
						case 1: {
							if (UK_Data.LastError != 0) {
								window.alert("sWriteEx_2让加密锁进行普通解密运算时错误，错误码为："
										+ UK_Data.LastError.toString());
								s_simnew1.Socket_UK.close();
								return false;
							}
							//window.alert ("对数据3456进行使用普通算法二普通解密运算后的结果是："+UK_Data.return_value.toString());
							DevicePath = UK_Data.return_value;//获得返回的UK的路径
							s_simnew1.GetID_1(DevicePath); //'读取锁的ID
						}
							break;
						case 2: {
							if (UK_Data.LastError != 0) {
								window.alert("读取锁的ID时错误，错误码为："
										+ UK_Data.LastError.toString());
								s_simnew1.Socket_UK.close();
								return false;
							}
							keyid = toHex(UK_Data.return_value);
							s_simnew1.GetID_2(DevicePath); //'读取锁的ID
						}
							break;
						case 3: {
							if (UK_Data.LastError != 0) {
								window.alert("读取锁的ID时错误，错误码为："
										+ UK_Data.LastError.toString());
								s_simnew1.Socket_UK.close();
								return false;
							}
							keyid = keyid + toHex(UK_Data.return_value);
							//window.alert ("锁的ID是："+keyid);
							InString = "" + gMobile;
							//写入字符串到UK的地址1中
							address = 1;
							s_simnew1.YWriteString(InString, address,
									"ffffffff", "ffffffff", DevicePath); //写入字符串带长度,使用默认的读密码
						}
							break;

						case 4: {
							if (UK_Data.LastError != 0) {
								window.alert("写入字符串(带长度)错误。错误码为："
										+ UK_Data.LastError.toString());
								s_simnew1.Socket_UK.close();
								return false;
							}
							nlen = UK_Data.return_value;

							//设置字符串长度到缓冲区中,
							s_simnew1.SetBuf(nlen, 0);
						}
							break;
						case 5: {
							if (UK_Data.LastError != 0) {
								window.alert("SetBuf设置缓冲区时错误，错误码为："
										+ UK_Data.LastError.toString());
								s_simnew1.Socket_UK.close();
								return false;
							}
							//将缓冲区的数据即字符串长度写入到UK的地址0中

							address = 0;

							s_simnew1.YWriteEx(address, 1, "ffffffff",
									"ffffffff", DevicePath);//写入字符串的长度到地址0
						}
							break;

						case 6: {
							//window.alert("初始化加密锁成功");
							updateDog(gMemId, 1, keyid);
						}
							break;

						}
					}

					s_simnew1.Socket_UK.onclose = function() {

					}

					return true;
				}

				catch (e) {
					alert(e.name + ": " + e.message);
					return false;
				}

			}

			function Handle_IE10() {

				try {
					var DevicePath, mylen, ret, username, mykey, outstring, address, mydata, i, InString, versionex, version, seed;

					//建立操作我们的锁的控件对象，
					s_simnew1 = new ActiveXObject("Syunew3A.s_simnew3");

					DevicePath = s_simnew1.FindPort(0);//'查找加密锁
					//DevicePath = s_simnew1.FindPort_2(0,1,  70967193);//'查找指定的加密锁（使用普通算法）
					if (s_simnew1.LastError != 0) {
						window.alert("未发现加密锁，请插入加密锁");
						return false;
					} else {
						keyid = toHex(s_simnew1.GetID_1(DevicePath))
								+ toHex(s_simnew1.GetID_2(DevicePath));
						if (s_simnew1.LastError != 0) {
							window.alert("获取ID错误,错误码是"
									+ s_simnew1.LastError.toString());
							return false;
						}

						InString = gMobile;

						//写入字符串到地址1
						nlen = s_simnew1.YWriteString(InString, 1, "ffffffff",
								"ffffffff", DevicePath);
						if (s_simnew1.LastError != 0) {
							window.alert("写入字符串(带长度)错误。");
							return false;
						}
						//写入字符串的长度到地址0
						s_simnew1.SetBuf(nlen, 0);
						ret = s_simnew1.YWriteEx(0, 1, "ffffffff", "ffffffff",
								DevicePath);
						if (ret != 0) {
							window.alert("写入字符串长度错误。错误码：");
							return false;
						}

						updateDog(gMemId, 1, keyid);

					}

					return true;
				}

				catch (e) {
					alert(e.name + ": " + e.message);
					return false;
				}

			}

			//------------------手机认证相关：start--------------------
			function formatRzMobile(val,row){
				var rzMobile = row.rzMobile;
				if(rzMobile == null || rzMobile == undefined || rzMobile === ''){
					rzMobile = "";
				}
				return "<input type='text' style='display:none;width:75px' size='11' name='rzMobileInput' id='rzMobileInput"+row.memberId+"' value='" + rzMobile + "' maxlength='11'/>" +
						"<button style='display:none;width:35px;height:20px;font-size:12px;margin-left:5px' name='rzMobileButton' id='rzMobileButton"+row.memberId+"' onclick='javaScript:rzMobile("+row.memberId+");'>认证</button>" +
						"<span name='rzMobileSpan' id='rzMobileSpan"+row.memberId+"' >" + rzMobile + "</span>";
			}
			// onclick='javaScript:upDateRzMobile("+row.memberId+");'

			// function upDateRzMobile(memberId) {
			// 	var rzMobileInput = $("#rzMobileInput"+memberId);
			// 	var rzMobileButton = $("#rzMobileButton"+memberId);
			// 	var rzMobileSpan = $("#rzMobileSpan"+memberId);
			// 	rzMobileInput.show();
			// 	rzMobileButton.show();
			// 	rzMobileSpan.hide();
			// 	rzMobileInput.val(rzMobileSpan.text());
			// 	rzMobileButton.text("修改")
			// }
			var k1 = true;
			function editRzMobile() {
				var rzMobileInput = document.getElementsByName("rzMobileInput");
				var rzMobileButton = document.getElementsByName("rzMobileButton");
				var rzMobileSpan = document.getElementsByName("rzMobileSpan");
				//获取当前页的数据
                var rows = $('#datagrid').datagrid('getRows');
				for (var i = 0; i < rzMobileInput.length; i++) {
				    var row = rows[i];
                    if (k1) {
                        var rzMobile = row.rzMobile;
                        if(rzMobile==null || rzMobile == undefined || rzMobile ==''){
                            rzMobileInput[i].style.display = '';
                            rzMobileButton[i].style.display = '';
                            rzMobileSpan[i].style.display = 'none';
                        }
                    } else {
                        rzMobileInput[i].style.display = 'none';
                        rzMobileButton[i].style.display = 'none';
                        rzMobileSpan[i].style.display = '';
                    }
				}
                k1 = !k1;
			}

			function rzMobile(memberId){
				var rzMobile = $("#rzMobileInput"+memberId).val();
				if((rzMobile==null || rzMobile==undefined) || rzMobile.length!=11){
					alert("请填写11位手机号！");
					return false;
				}
				$.messager.confirm("确认", "认证后不能修改，确认此操作吗？", function (r) {
					if (r) {
						$.ajax({
							url: "manager/updateByRzMobile",
							type: "post",
							data:{
								"memberId":memberId,
								"rzMobile":rzMobile,
							},
							success: function (data) {
								//1.认证成功；2.该手机号已认证过；3.该手机号已在客户管理中认证过
								if (data == '1') {
									//刷新当前页
									$("#datagrid").datagrid("reload");
									alert("认证成功");
								}else if(data == '2') {
									alert("该手机号已认证过");
								}else if(data == '3') {
									alert("该手机号已在客户管理中认证过");
								}else if(data == '4') {
									alert("该手机号已在会员表存在");
								}else{
									alert("操作失败");
								}
							}
						});
						return true;
					}
				});
				return false;
            }
			//------------------手机认证相关：end--------------------
		</script>
	</body>
</html>
