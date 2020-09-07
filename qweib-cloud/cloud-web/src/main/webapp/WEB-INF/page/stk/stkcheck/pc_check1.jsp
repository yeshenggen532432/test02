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
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/stkstyle/css/stkcheck.css"/>		
		<script type="text/javascript" src="resource/loadDiv.js"></script>
		<script type="text/javascript" src="<%=basePath %>resource/WdatePicker.js"></script>
		<script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
	</head>

	<body onload="formload()">
		<form action="<%=basePath %>/manager/downloadCheckDataToExcel" method="post" id="dataForm" name="dataForm">
			<textarea  name="wareStr" id="wareStr" style="display:none "></textarea>
		</form>
		<input type="hidden" name="wtype" id="wtype" value="${wtype}"/>
		<input type="hidden" id="billId" value="${billId}"/>
		<input type="hidden" id="stkId" value="${stkId}"/>
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
			border="false"
			rownumbers="true" fitColumns="true" pagination="false" pagePosition=3
			 toolbar="#tb" data-options="onClickRow: onClickRow1">
			<thead>
				<tr>
				<th field="id" width="10" align="center" hidden="true">
						商品id
					</th>
				    <th field="wareId" width="10" align="center" hidden="true">
						商品id
					</th>
					<th field="wareCode" width="80" align="left">
						商品编码
					</th>
					<th field="wareNm" width="100" align="left">
						商品名称
					</th>
					<th field="wareGg" width="80" align="center">
						规格
					</th>
					<th field="stkQty" width="60" align="center" formatter="amtformatter">
						账面数量
					</th>
					<th field="unitName" width="60" align="center">
						大单位
					</th>
					<th data-options="field:'qty',width:80,align:'center',editor:{type:'text'}" formatter="amtformatter"> 
						大单位数量
					</th>
					<th field="minUnit" width="60" align="center">
						小单位
					</th>
					<th field="minQty" width="80" align="center" editor="{type:'text'}" formatter="amtformatter">
						小单位数量
					</th>
					<th field="hsNum" width="60" align="center"  hidden="true">
						换算数量
					</th>
					<th field="disQty" width="60" align="center" formatter="amtformatter">
						差量
					</th>
					<th field="productDate" width="60" align="center" formatter="amtformatterDate">
						生产日期
					</th>
				</tr>
			</thead>
			
		</table>
		<div id="tb" style="padding:5px;height:auto">
		 盘点时间:
		
		 <input name="sdate" id="checkDate"  onClick="WdatePicker({skin:'whyGreen',dateFmt: 'yyyy-MM-dd HH:mm:ss'});" style="width: 100px;" value="${checkTime}" readonly="readonly"/>
            <img onclick="WdatePicker({skin:'whyGreen',dateFmt: 'yyyy-MM-dd HH:mm:ss'});" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
		盘点仓库: <select name="stkId" id="stksel" value="${stkId}" onchange="changeStorage(this)">
            </select>
	    盘点人: <input name="edtstaff" id="edtstaff" style="width:120px;height: 20px;" readonly="readonly" value="${staff}"/>
			<a class="easyui-linkbutton" iconCls="icon-search" plain="true" href="javascript:showStaffForm();">选择人员</a>
			<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:dialogSelectWare();">选择商品</a>
            <a class="easyui-linkbutton" iconCls="icon-save" id="dragesave" plain="true" href="javascript:drageSaveStk();">暂存</a>
            <c:if test="${billId eq 0}">
			<a class="easyui-linkbutton" iconCls="icon-save" id="saveaudit" plain="true" href="javascript:submitStk();">保存并审批</a>
            </c:if>
			<a class="easyui-linkbutton" iconCls="icon-redo"  plain="true" href="javascript:toDownloadDataExcel();">下载数据</a>
			<a class="easyui-linkbutton" iconCls="icon-redo"  plain="true" href="javascript:toUpWare();">上传数据</a>

			<a class="easyui-linkbutton" iconCls="icon-redo"  plain="true" href="javascript:toDownloadCheckCustomTemplate();">下载自定义数据模版</a>
			<a class="easyui-linkbutton" iconCls="icon-redo"  plain="true" href="javascript:toUpCustomWare();">上传自定义数据</a>
			（账面数量-大单位数量-小单位数量=差量）

		</div>
		
		<!-- 上传框 -->
  	    <div id="upDiv" class="easyui-window" style="width:500px;height:100px;padding:10px;"
			minimizable="false" maximizable="false" collapsible="false" closed="true">
			<form action="manager/toUpCheckData" id="upFrm" method="post" enctype="multipart/form-data">
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr height="30px">
						<td >选择文件：</td>
						<td>
						<input type="file" name="upFile" id="upFile" title="check"/>
						</td>
						<td><input type="button" onclick="toUpWareExcel();" style="width: 50px" value="加载数据" /></td>
					</tr>
				</table>
			</form>
		</div>

		<div id="upCustomDiv" class="easyui-window" style="width:500px;height:100px;padding:10px;"
			 minimizable="false" maximizable="false" collapsible="false" closed="true">
			<form action="manager/toUpCheckCustomData" id="upCustomFrm" method="post" enctype="multipart/form-data">
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr height="30px">
						<td >选择文件：</td>
						<td>
							<input type="file" name="upFile" id="upFile" title="check"/>
							<input type="hidden" name="upStkId" id="upStkId"/>
						</td>
						<td><input type="button" onclick="toUpWareCustomExcel();" style="width: 50px" value="上传数据" /></td>
					</tr>
				</table>
			</form>
		</div>


		
		<!-- 业务员 -->
		<div class="chose_people pcl_chose_people" style="" id="staffForm">
			<div class="mask"></div>
			<div class="cp_list2">
				<!--<a href="javascript:;" class="pcl_close_button"><img src="style/img/lightbox-btn-close.jpg"/></a>-->
				<div class="pcl_box_left">
					<div class="cp_src">
						<div class="cp_src_box">
							<img src="<%=basePath %>/resource/stkstyle/img/src_icon2.jpg"/>
							<input type="text" placeholder="模糊查询"/>
						</div>
						<input type="button" class="cp_btn" value="查询"/>
						<input type="button" class="cp_btn2 close_btn2" value="取消"/>
					</div>					
				</div>
				<div class="pcl_3box" id="memdiv">
					
					<div class="pcl_switch clearfix">
						<div class="pcl_3box2">
							<h2>部门分类树</h2>
							<div class="pcl_l2" id="departTree">
								<a href="#">员工</a>
								<a href="#">员工</a>
								<a href="#">员工</a>
								<div class="pcl_infinite">
									<p><i></i>综合部</p>
									<div class="pcl_file">
										<a href="#">员工</a>
										<a href="#">员工</a>
										<a href="#">员工</a>
										<div class="pcl_infinite">
											<p><i></i>综合部</p>
											<div class="pcl_file">
												<a href="#">员工</a>
												<a href="#">员工</a>
												<a href="#">员工</a>
											</div>
										</div>
									</div>
								</div>
								<div class="pcl_file">
									<div class="pcl_infinite">
										<p><i></i>综合部</p>
										<div class="pcl_file">
											<a href="#">员工</a>
											<a href="#">员工</a>
											<a href="#">员工</a>
										</div>
									</div>
								</div>
							</div>
						</div>
						
						<div class="pcl_rf_box">
						<div style="height: 400px;overflow: auto;text-align: center">
							<table class="pcl_table" >
								<thead>
									<tr>
										<td>姓名</td>
										<td>电话</td>
									</tr>
								</thead>
								<tbody id="memberList">
									<tr>
										<td>客户1</td>
										<td>人事经理</td>
									</tr>
								</tbody>
							</table>
							</div>
						</div>
					</div>
					
				</div>
				
			</div>
		</div>	
		 <div id="wareDlg" closed="true" class="easyui-dialog" style="width:500px; height:200px;" title="商品选择" iconCls="icon-edit">
        </div>
		<div id="dialogUpdateWares" closed="true" closable="false" class="easyui-dialog" style="width:700px; height:400px;"
			 title="商品信息设置" iconCls="icon-edit" data-options="
				iconCls: 'icon-save',
				buttons: [{
					text:'确定',
					iconCls:'icon-ok',
					handler:function(){
						refreshCheckWare();
						$('#dialogUpdateWares').dialog('close');
					}
				}]
			">
			<input name="wareIds" id="wareIds" type="hidden">
			<iframe name="dialogUpdateWaresfrm" id="dialogUpdateWaresfrm" frameborder="0" marginheight="0" marginwidth="0"
					width="100%" height="100%"></iframe>
		</div>
		<script type="text/javascript">
		var editstatus = 0;
		
		var orderlist;
		var gwareList;
		    function formload()
		    {
		    	orderlist="";
		    	if(gwareList==undefined){
		    		gwareList="";
		    	}
		    	querystorage();
		    	querydepart();
		    	var billId = $("#billId").val();
		    	if(billId == 0)
		    	{
		    	var myDate = new Date();    
				var seperator1 = "-";
			    
			    var month = myDate.getMonth() + 1;
			    var strDate = myDate.getDate();
			    if (month >= 1 && month <= 9) {
			        month = "0" + month;
			    }
			    if (strDate >= 0 && strDate <= 9) {
			        strDate = "0" + strDate;
			    }
			    var hour = myDate.getHours();
			    if(hour < 10)hour = '0' + hour;
			    var minute = myDate.getMinutes();
			    if(minute<10)minute = '0' + minute;
			   
				var dateStr = myDate.getFullYear() + seperator1 + month + seperator1 + strDate + " " + hour + ":" + minute;		
				$("#checkDate").val(dateStr);
				//queryCheckWare();
		    	}
		    	else
		    	{
		    		displaySub();	
		    	}
				
		    }
		
			//显示上传框
			function toUpWare(){
				$("#upDiv").window({title:'加载数据',modal:true});
				$("#upDiv").window('open');
			}
			//上传文件
			function toUpWareExcel(){
			       $("#upFrm").form('submit',{
					success:function(data){
						var json = eval("("+data+")");
						if(json.state){
							var size = json.list.length;
							var rows = $('#datagrid').datagrid('getRows');
			        	    for(var i=rows.length-1;i>=0;i--){
			        	        $("#datagrid").datagrid('deleteRow',i);
			        	    }
							gwareList=="";
							gwareList = new Array();
			        		for(var i = 0;i < size; i++)
			        			{
			        				var d = {  
		            						waretypePath:json.list[i].waretypePath,
		            						wareId:json.list[i].wareId,
					        				wareNm:json.list[i].wareNm,
					        				wareGg:json.list[i].wareGg,
					        				wareCode:json.list[i].wareCode,
					        				unitName:json.list[i].unitName,
					        				stkQty:formatterNumber(json.list[i].stkQty),
					        				qty:formatterNumber(json.list[i].qty),
					        				minQty:formatterNumber(json.list[i].minQty),
					        				minUnit:json.list[i].minUnit,
					        				hsNum:json.list[i].hsNum,
					        				disQty:json.list[i].disQty,
					        				productDate:json.list[i].produceDate			
		    		        			};
			        				$('#datagrid').datagrid("appendRow",d);
			        				gwareList.push(d);
			        		}
						}
						else{
							alert(json.msg);
						}
						$("#upDiv").window('close');
						onclose();
					},
					onSubmit:function(){
						DIVAlert("<img src='resource/images/loading.gif' width='50px' height='50px'/>");
					}
				});
		    }

		//上传文件
		function toUpWareCustomExcel(){
			var stkId = $("#stksel").val();
			if(stkId==""){
				alert("请选择仓库");
				return;
			}
			$("#upStkId").val(stkId);
			$("#wareIds").val("");
			$("#upCustomFrm").form('submit',{
				success:function(data){
					var json = eval("("+data+")");
					if(json.state){
						var size = json.list.length;
						var wareIds = json.wareIds;
						if(wareIds!=""){
							if(window.confirm("导入商品信息中有新新增的商品是否去完善")){
								showUpdateWares(wareIds);
							}
						}
						$("#wareIds").val(wareIds);
						var rows = $('#datagrid').datagrid('getRows');
						for(var i=rows.length-1;i>=0;i--){
							$("#datagrid").datagrid('deleteRow',i);
						}
						gwareList=="";
						gwareList = new Array();
						for(var i = 0;i < size; i++)
						{
							var d = {
								waretypePath:json.list[i].waretypePath,
								wareId:json.list[i].wareId,
								wareNm:json.list[i].wareNm,
								wareGg:json.list[i].wareGg,
								wareCode:json.list[i].wareCode,
								unitName:json.list[i].unitName,
								stkQty:formatterNumber(json.list[i].stkQty),
								qty:formatterNumber(json.list[i].qty),
								minQty:formatterNumber(json.list[i].minQty),
								minUnit:json.list[i].minUnit,
								hsNum:json.list[i].hsNum,
								disQty:json.list[i].disQty,
								productDate:json.list[i].produceDate
							};
							$('#datagrid').datagrid("appendRow",d);
							gwareList.push(d);
						}
					}
					else{
						alert(json.msg);
					}
					$("#upCustomDiv").window('close');
					onclose();
				},
				onSubmit:function(){
					DIVAlert("<img src='resource/images/loading.gif' width='50px' height='50px'/>");
				}
			});
		}

		//显示上传框
		function toUpCustomWare(){
			$("#upCustomDiv").window({title:'加载数据',modal:true});
			$("#upCustomDiv").window('open');
		}


			//下载模板
		    function toWareModel() {
                  if(confirm("是否下载商品上传需要的文档?")){
					window.location.href="manager/toWareModel";
				}
	
           }
			
		    $(".pcl_close_button").click(function(){
				$(this).parents('.chose_people').hide();
			});
		    
		    $("#staff").on('click',function(){
				
				if(editstatus == 0)return;
				$("#staffForm").show();
				$("#memdiv").show();
				$(".pcl_3box .pcl_switch").show();
			});
			
			function close_box(box,btn){
				btn.click(function(){
					box.hide();
				});
			}
			close_box($(".pcl_chose_people"),$(".close_button"));
			close_box($(".pcl_chose_people"),$(".close_btn2"));
			
			$("#staff").on('click',function(){
				$("#staffForm").show();
				$("#memdiv").show();
				$(".pcl_3box .pcl_switch").show();
			});
			
			function showStaffForm()
			{
				$("#staffForm").show();
				$("#memdiv").show();
				$(".pcl_3box .pcl_switch").show();
			}
			
			function querystorage(){
				var path = "manager/queryBaseStorage";
				$.ajax({
			        url: path,
			        type: "POST",
			        data : {"token11":""},
			        dataType: 'json',
			        async : false,
			        success: function (json) {
			        	if(json.state){
			        		var size = json.list.length;
			        		var objSelect = document.getElementById("stksel");
			        		objSelect.options.add(new Option(''),'');
			        		var billId = $("#billId").val();
			        		for(var i = 0;i < size; i++)
			        			{
			        				objSelect.options.add( new Option(json.list[i].stkName,json.list[i].id));
			        				if(i == 0)
			    					{
			    						if(billId == 0)
			    							{
			    							$("#stksel").val(json.list[i].id);
			    							storageId=json.list[i].id;
			    							}
			    					}
			        			}
			        		if(billId >0)$("#stksel").val($("#stkId").val());
			        	}
			        }
			    });
			}
			
			function querydepart(){
				
				var path = "manager/queryStkDepart";
				var token = $("#tmptoken").val();
				//alert(token);
				$.ajax({
			        url: path,
			        type: "POST",
			        data : {"dataTp":"1"},
			        dataType: 'json',
			        async : false,
			        success: function (json) {
			        	if(json.state){
			        		var size = json.list.length;
			        		var text = "";
			        		var firstId = 0;
			        		for(var i = 0;i < size; i++)
			        			{
			        				if(firstId == 0 && json.list[i].ischild == "2")firstId = json.list[i].branchId;
			        				if(json.list[i].ischild == "0")continue;
			        				text += makeDepartTree(json.list,json.list[i]) ;
									
			        			}
			        		$("#departTree").html(text);
			        		if(firstId != 0)queryMember(firstId);
			        	}
			        }
			    });
			}

			function makeDepartTree(departList,obj)
			{
				if(obj.ischild == "2")//没有子部门
				{
					var retStr = "<a href='javascript:queryMember(" + obj.branchId + ");'>" + obj.branchName + "</a>";
					obj.ischild = 0;
					return retStr;
				}
				if(obj.ischild == "1")
				{
					var retStr = "<div class='pcl_infinite'>";
						retStr += "<p><i></i>" + obj.branchName + "</p>";
						retStr += "<div class='pcl_file'>";
						obj.ischild = 0;
						for(var i = 0;i<departList.length;i++)
							{
								if(departList[i].parentId == obj.branchId)
									{
										retStr += makeDepartTree(departList,departList[i]);
									}
							}
						retStr += "</div>";
						retStr += "</div>";
						return retStr;
				}
				return "";
			}

			function queryMember(branchId){
				var path = "manager/stkMemberPage";
				var token = $("#tmptoken").val();
				//alert(token);
				$.ajax({
			        url: path,
			        type: "POST",
			        data : {"token":token,"page":1,"rows":50,"branchId":branchId},
			        dataType: 'json',
			        async : false,
			        success: function (json) {
			        	if(json.state){
			        		displayMember(json);	
			        	}
			        }
			    });
			}

			function queryMemberByName(memberNm)
			{
				var path = "manager/stkMemberPage";
				var token = $("#tmptoken").val();
				//alert(token);
				$.ajax({
			        url: path,
			        type: "POST",
			        data : {"token":token,"page":1,"rows":50,"memberNm":memberNm},
			        dataType: 'json',
			        async : false,
			        success: function (json) {
			        	if(json.state){
			        		displayMember(json);	
			        	}
			        }
			    });
			}

			function displayMember(json)
			{
				var size = json.rows.length;
				var text = "";
				for(var i = 0;i < size; i++)
					{
						text += "<tr onclick=\"memberClick(this)\">" ;
						text += "<td>" + json.rows[i].memberNm + "<input  type=\"hidden\" name=\"memberId\" value=\"" + json.rows[i].memberId + "\"/></td>	";  
						text += "<td>" + json.rows[i].memberMobile + "</td>";	
						text += "</tr>";
					}
				$("#memberList").html(text);
			}
			function memberClick(trobj)
			{
				var tel = $(trobj.cells[1]).text();
				var memberNm = $(trobj.cells[0]).text();
				$("#edtstaff").val(memberNm);
				$(".pcl_chose_people").hide();
			}

			function queryCheckWare()
			{
				var path = "manager/queryCheckWare";
				stkId = $("#stksel").val();
				if(stkId == "")stkId = 0;
				$.ajax({
			        url: path,
			        type: "POST",
			        data : {"stkId":stkId},
			        dataType: 'json',
			        async : false,
			        success: function (json) {
			        	if(json.state){
			        		var size = json.list.length;
			        		$("#chooselist").text("");
			        		for(var i = 0;i < size; i++)
			        			{
			        			if(gwareList==""){
			        				$('#datagrid').datagrid("appendRow", {  
				        				wareId:json.list[i].wareId,
				        				wareNm:json.list[i].wareNm,
				        				wareGg:json.list[i].wareGg,
				        				wareCode:json.list[i].wareCode,
				        				unitName:json.list[i].wareDw,
				        				stkQty:formatterNumber(json.list[i].stkQty),
				        				minQty:formatterNumber(json.list[i].minQty),
				        				minUnit:json.list[i].minUnit,
				        				hsNum:json.list[i].hsNum,
				        				qty:formatterNumber(json.list[i].stkQty),
				        				disQty:0,
				        				productDate:json.list[i].productDate				
				        			});
			        			}else{
			        				var flag = checkGwareIsExist(json.list[i].wareId);
			        				if(flag==0){
				        				var row = {  
						        				wareId:json.list[i].wareId,
						        				wareNm:json.list[i].wareNm,
						        				wareGg:json.list[i].wareGg,
						        				wareCode:json.list[i].wareCode,
						        				unitName:json.list[i].wareDw,
						        				stkQty:formatterNumber(json.list[i].stkQty),
						        				qty:formatterNumber(json.list[i].stkQty),
						        				minQty:formatterNumber(json.list[i].minQty),
						        				minUnit:json.list[i].minUnit,
						        				hsNum:json.list[i].hsNum,
						        				disQty:0,
						        				productDate:json.list[i].productDate
						        			};
				        				var data = json.list[i];
				        				$('#datagrid').datagrid("appendRow", row);
				        				 gwareList.push(data);
				        			}
			        			}
			        		}
			        		if(gwareList==""){
			        			gwareList = json.list;
			        		}else{//校验是否有删除商品
			        			var len = gwareList.length;
			        			var tempArr = new Array();
			        			var k=0;
			        		    while(k<len){
			        		    	var data = gwareList[k];
			        		    	var flag = checkWareIsDelete(json.list,data.wareId);
			        		    	if(flag==0){
			        		    		deleteNoExistWareRow(data.wareId);
			        		    	}else{
			        		    		tempArr.push(data);	
			        		    	}
			        		    	k++;
			        		    }
			        		    gwareList = tempArr;
			        		    len = gwareList.length;
			        		}
			        }
			        }
			    });
			}
			
			function setCheckWareData(json)
			{
	        		var size = json.list.length;
	        		$("#chooselist").text("");
	        		for(var i = 0;i < size; i++)
	        			{
	        			if(gwareList==""){
	        				$('#datagrid').datagrid("appendRow", {  
	        					waretypePath:json.list[i].waretypePath,
		        				wareId:json.list[i].wareId,
		        				wareNm:json.list[i].wareNm,
		        				wareGg:json.list[i].wareGg,
		        				wareCode:json.list[i].wareCode,
		        				unitName:json.list[i].wareDw,
		        				stkQty:formatterNumber(json.list[i].stkQty),
		        				minQty:formatterNumber(json.list[i].minQty),
		        				minUnit:json.list[i].minUnit,
		        				hsNum:json.list[i].hsNum,
		        				qty:formatterNumber(json.list[i].stkQty),
		        				disQty:0,
		        				productDate:json.list[i].productDate				
		        			});
	        			}else{
	        				var flag = checkGwareIsExist(json.list[i].wareId);
	        				if(flag==0){
		        				var row = {  
		        						waretypePath:json.list[i].waretypePath,
				        				wareId:json.list[i].wareId,
				        				wareNm:json.list[i].wareNm,
				        				wareGg:json.list[i].wareGg,
				        				wareCode:json.list[i].wareCode,
				        				unitName:json.list[i].wareDw,
				        				stkQty:formatterNumber(json.list[i].stkQty),
				        				qty:formatterNumber(json.list[i].stkQty),
				        				minQty:formatterNumber(json.list[i].minQty),
				        				minUnit:json.list[i].minUnit,
				        				hsNum:json.list[i].hsNum,
				        				disQty:0,
				        				productDate:json.list[i].productDate				
				        			};
		        				var data = json.list[i];
		        				$('#datagrid').datagrid("appendRow", row);
		        				 gwareList.push(row);
		        			}
	        			}
	        		}
	        		if(gwareList==""){
	            			gwareList = new Array();
	            			for(var i=0;i<size;i++){
	            				var data = {  
	            						waretypePath:json.list[i].waretypePath,
	            						wareId:json.list[i].wareId,
				        				wareNm:json.list[i].wareNm,
				        				wareGg:json.list[i].wareGg,
				        				wareCode:json.list[i].wareCode,
				        				unitName:json.list[i].wareDw,
				        				stkQty:formatterNumber(json.list[i].stkQty),
				        				qty:formatterNumber(json.list[i].stkQty),
				        				minQty:formatterNumber(json.list[i].minQty),
				        				minUnit:json.list[i].minUnit,
				        				hsNum:json.list[i].hsNum,
				        				disQty:0,
				        				productDate:json.list[i].productDate			
	    		        			};
	            				gwareList.push(data);
	            			}
	        		}
			}
			
			/*
			  检查产品是否存在，如果存在则不添加
			*/
			function checkGwareIsExist(wareId){
				if(gwareList!=""&&gwareList.length>0){
					for(var i=0;i<gwareList.length;i++){
						if(gwareList[i].wareId==wareId){
							return 1;
						}
					}
				}
				return 0;
			}
			/**
			检查是否有删除商品，如果有则删除
		**/
		function checkWareIsDelete(arr,wareId){
			if(arr!=""&&arr.length>0){
				for(var i=0;i<arr.length;i++){
					if(arr[i].wareId==wareId){
						return 1;
					}
				}
			}
			return 0;
		}
		
		/**
		   删除已经删除的商品行
		**/
		function deleteNoExistWareRow(wareId){
			var rows =  $('#datagrid').datagrid('getRows');
			for(var i=0;i<rows.length;i++){
				var data = rows[i];
				if(data.wareId==wareId){
					$('#datagrid').datagrid('deleteRow', i); 
					break;
				}
			}
			
		}
			 var editIndex = undefined;
				function endEditing(){
					if (editIndex == undefined){return true}
					if ($('#datagrid').datagrid('validateRow', editIndex)){
						$('#datagrid').datagrid('acceptChanges');
						editIndex = undefined;
						return true;
					} else {
						return false;
					}
				}
			   function onClickRow1(index){
				   var editor=	$('#datagrid').datagrid('selectRow', index)
					.datagrid('beginEdit', index); 
				  var billId= $("#billId").val();
				 // if(billId > 0)return;
					if (editIndex != index){
						if (endEditing()){
							var editor=	$('#datagrid').datagrid('selectRow', index)
									.datagrid('beginEdit', index);
						} else {
							$('#datagrid').datagrid('selectRow', editIndex);
							 var editor=	$('#datagrid').datagrid('selectRow', index)
								.datagrid('beginEdit', index); 
						}
						editIndex = index;
					}else{
						endEditing();
						 var editor=	$('#datagrid').datagrid('selectRow', index)
							.datagrid('beginEdit', index); 
					}
					  var minQtyEvent = $('#datagrid').datagrid('getEditor', {index:index,field:'minQty' });
					  minQtyEvent.target.change(function(){
						        var minQty=minQtyEvent.target.val(); 
						        if(minQty==""){
						        	minQty=0;
						        }
						        var qty =$('#datagrid').datagrid('getRows')[index]['qty'];
								var stkQty = $('#datagrid').datagrid('getRows')[index]['stkQty'];
								var disQty = qty - stkQty;
								disQty = numeral(disQty).format("0.0000000000");

								var hsNum = $('#datagrid').datagrid('getRows')[index]['hsNum'];
								if(hsNum==0||hsNum==null||hsNum==undefined){
									hsNum = 1;
								}
								var hsQty = minQty/hsNum;
								disQty = parseFloat(disQty) + parseFloat(hsQty);
								var wareId = $('#datagrid').datagrid('getRows')[index]['wareId'];
								disQty = formatterNumber(disQty);
								$('#datagrid').datagrid('getRows')[index]['disQty'] = disQty;
								$('#datagrid').datagrid('updateRow',{index:index,row:{qty:qty,disQty:disQty,minQty:minQty}});
								updateWareList(wareId,qty,disQty,minQty);
								$('#datagrid').datagrid('endEdit', index);
					  });
					  var qtyEvent = $('#datagrid').datagrid('getEditor', {index:index,field:'qty' });
					  qtyEvent.target.focus();
					  qtyEvent.target.change(function(){
						    var minQty = $('#datagrid').datagrid('getRows')[index]['minQty'];
						    if(minQty==""){
					        	minQty=0;
					        }
						    var qty =qtyEvent.target.val();
							var stkQty = $('#datagrid').datagrid('getRows')[index]['stkQty'];
							var disQty = qty - stkQty;
							disQty = numeral(disQty).format("0.0000000000");
							var hsNum = $('#datagrid').datagrid('getRows')[index]['hsNum'];
							if(hsNum==0||hsNum==null||hsNum==undefined){
								hsNum = 1;
							}
							var hsQty = minQty/hsNum;
							disQty = parseFloat(disQty) + parseFloat(hsQty);
							var wareId = $('#datagrid').datagrid('getRows')[index]['wareId'];
							disQty = formatterNumber(disQty);
							$('#datagrid').datagrid('getRows')[index]['disQty'] = disQty;
							$('#datagrid').datagrid('updateRow',{index:index,row:{qty:qty,disQty:disQty,minQty:minQty}});
							updateWareList(wareId,qty,disQty,minQty);
							$('#datagrid').datagrid('endEdit', index);
					  });
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
				
				function updateWareList(wareId,qty,disQty,minQty)
				{
					for(var i = 0;i<gwareList.length;i++)
						{
						if(gwareList[i].wareId==wareId)
							{
							gwareList[i].qty = qty;
							gwareList[i].minQty = minQty;
							gwareList[i].disQty = disQty;
							break;
							}
						}
				}
				function submitStk(){
					var billId = $("#billId").val();
					if(billId > 0)
						{
						alert("盘点单不能修改");
						return;
						}
					var stkId = $("#stksel").val();	
					var remarks = "";
					var checkTime = $("#checkDate").val();
					var staff = $("#edtstaff").val();
					var billId = 0;
					var wareList = new Array();
					for(var i = 0;i<gwareList.length;i++){
					    var wareId =  gwareList[i].wareId;
					    var qty =  gwareList[i].qty;
					    var minQty =  gwareList[i].minQty;
					    var disQty =  gwareList[i].disQty;
					    var stkQty = gwareList[i].stkQty;
					    if(qty == ""){
					    	qty=0;
					    }
					    if(minQty==""){
					    	minQty=0;
					    }
					    if(wareId == 0)continue;
					    var produceDate =document.getElementById("produceDate"+wareId).value;
					    var subObj = {
								wareId: wareId,				
								qty:formatterNumber(qty),
								minQty:formatterNumber(minQty),
								minUnit:gwareList[i].minUnit,
								hsNum:gwareList[i].hsNum,
								produceDate:produceDate,
								disQty:disQty,
								stkQty:stkQty
						};
					    wareList.push(subObj);
					}
					if(wareList.length == 0)
						{
							alert("请选择商品");
							return;
						}
					if(stkId == 0)
						{
							alert("请选择仓库");
							return;
						}
					var path = "manager/addStkCheck";
					var token = $("#tmptoken").val();
					//alert(JSON.stringify(wareList));
					$.messager.confirm('确认', '保存后将不能修改，是否确定保存？?',function(r){
						if(r){
							$.ajax({
						        url: path,
						        type: "POST",
						        data : {"token":token,"id":billId,"staff":staff,"stkId":stkId,"remarks":remarks,"checkTimeStr":checkTime,"wareStr":JSON.stringify(wareList)},
						        dataType: 'json',
						        async : false,
						        success: function (json) {
						        	if(json.state){
						        		$("#billId").val(json.id);
						        		$("#dragesave").hide();
						        		window.parent.location.href='manager/showStkcheck?billId=' + json.id;
						        	}
						        }
						    });}
					});
				}

        function drageSaveStk(){
            var billId = $("#billId").val();
            var stkId = $("#stksel").val();
            var remarks = "";
            var checkTime = $("#checkDate").val();
            var staff = $("#edtstaff").val();
            var wareList = new Array();
            for(var i = 0;i<gwareList.length;i++){
                var wareId =  gwareList[i].wareId;
                var qty =  gwareList[i].qty;
                var minQty =  gwareList[i].minQty;
                var disQty =  gwareList[i].disQty;
                var stkQty = gwareList[i].stkQty;
                if(qty == ""){
                    qty=0;
                }
                if(minQty==""){
                    minQty=0;
                }
                if(wareId == 0)continue;
                var produceDate =document.getElementById("produceDate"+wareId).value;
                var subObj = {
                    wareId: wareId,
                    qty:formatterNumber(qty),
                    minQty:formatterNumber(minQty),
                    minUnit:gwareList[i].minUnit,
                    hsNum:gwareList[i].hsNum,
                    produceDate:produceDate,
                    disQty:disQty,
                    stkQty:stkQty
                };
                wareList.push(subObj);
            }
            if(wareList.length == 0)
            {
                alert("请选择商品");
                return;
            }
            if(stkId == 0)
            {
                alert("请选择仓库");
                return;
            }
            var path = "manager/drageStkCheck";
            var token = $("#tmptoken").val();
            $.messager.confirm('确认', '暂存后将不能修改，审批后影响库存？',function(r){
                if(r){
                    $.ajax({
                        url: path,
                        type: "POST",
                        data : {"token":token,"id":billId,"staff":staff,"stkId":stkId,"remarks":remarks,"checkTimeStr":checkTime,"wareStr":JSON.stringify(wareList)},
                        dataType: 'json',
                        async : false,
                        success: function (json) {
                            if(json.state){
                                $("#billId").val(json.id);
								$("#saveaudit").hide();
                                alert(json.msg);
                                //window.parent.location.href='manager/showStkcheck?billId=' + json.id;
                            }else{
                                alert(json.msg);
                            }
                        }
                    });}
            });
        }

			function displaySub()
			{
				
				var path = "manager/queryCheckSub";
				var billId = $("#billId").val(); 
				$.ajax({
			        url: path,
			        type: "POST",
			        data : {"billId":billId},
			        dataType: 'json',
			        async : false,
			        success: function (json) {
			        	if(json.state){
                            var size = json.list.length;
                            var rows = $('#datagrid').datagrid('getRows');
                            for(var i=rows.length-1;i>=0;i--){
                                $("#datagrid").datagrid('deleteRow',i);
                            }
                            gwareList=="";
                            gwareList = new Array();
                            for(var i = 0;i < size; i++)
                            {
                                var d = {
                                    waretypePath:json.list[i].waretypePath,
                                    wareId:json.list[i].wareId,
                                    wareNm:json.list[i].wareNm,
                                    wareGg:json.list[i].wareGg,
                                    wareCode:json.list[i].wareCode,
                                    unitName:json.list[i].unitName,
                                    stkQty:formatterNumber(json.list[i].stkQty),
                                    qty:formatterNumber(json.list[i].qty),
                                    minQty:formatterNumber(json.list[i].minQty),
                                    minUnit:json.list[i].minUnit,
                                    hsNum:json.list[i].hsNum,
                                    disQty:json.list[i].disQty,
                                    productDate:json.list[i].produceDate
                                };
                                $('#datagrid').datagrid("appendRow",d);
                                gwareList.push(d);
                            }
			        }
			        }
			    });
				
			}
			
			function chooseWareType(wareType)
			{
				//queryCheckWare();
				editIndex = undefined;
				var rows = $('#datagrid').datagrid('getRows');
        	    for(var i=rows.length-1;i>=0;i--){
        	        $("#datagrid").datagrid('deleteRow',i);
        	    }
        	    
        	    var size = gwareList.length;
        		//$("#chooselist").text("");
        		for(var i = 0;i < size; i++)
        		{
        			var flag = 0;
        			var ss = gwareList[i].waretypePath.split('-');		
        			for(var j = 0;j<ss.length;j++)
        				{
        					if(ss[j] == wareType)
        						{
        							flag = 1;
        							break;
        						}
        				}
        			if(flag == 0)continue;
        			$('#datagrid').datagrid("appendRow", {  
        				wareId:gwareList[i].wareId,
        				wareNm:gwareList[i].wareNm,
        				wareGg:gwareList[i].wareGg,
        				wareCode:gwareList[i].wareCode,
        				unitName:gwareList[i].wareDw,
        				stkQty:formatterNumber(gwareList[i].stkQty),
        				qty:formatterNumber(gwareList[i].qty),
        				minQty:formatterNumber(gwareList[i].minQty),
        				minUnit:gwareList[i].minUnit,
        				hsNum:gwareList[i].hsNum,
        				disQty:formatterNumber(gwareList[i].disQty),
        				productDate:gwareList[i].productDate			
        			});
        		}		
			}
		  function chooseWare()
		    {
		    	parent.parent.add('选择商品','manager/stkChooseWare');
			}
		  
		  function amtformatter(v,row)
			{
				if (row != null) {
                  return numeral(v).format("0.0000000000");
              }
			}
		  
		  function amtformatterDate(v,row){
			 var date= ' <input name="productDate" id="produceDate'+row.wareId+'"  value="'+row.productDate+'" onchange="updateProductDate('+row.wareId+',this.value)"  onClick="WdatePicker({skin:\'whyGreen\',dateFmt: \'yyyy-MM-dd\'});" style="width: 90px;" class="pcl_i2"  readonly="readonly"/>';
			 return date;
		  }
		  
		  function formatterNumber(v,f)
			{
				if (v != null&&(f==null ||f==undefined)) {
                return numeral(v).format("0.0000000000");
            	}else if(v !=null&&f!=null){
            		 return numeral(v).format(f);
            	}else{
            		return 0;
            	}
			}
		  function dialogSelectWare(){
				  stkId = $("#stksel").val();
				if(stkId == "")stkId = 0;
		    	$('#wareDlg').dialog({
		            title: '商品选择',
		            iconCls:"icon-edit",
		            width: 800,
		            height: 400,
		            modal: true,
		            href: "manager/pcstkchecktypeselect?stkId="+stkId,
		            onClose: function(){
		            	//formload();
		            }
		        });
		    	$('#wareDlg').dialog('open');
	  }
		 var storageId=0;
		function changeStorage(o){
			if(o.value == 0)
			{
				alert("请选择仓库");
				o.value=storageId;
				return;
			}
			$.messager.confirm('确认', '仓库改变后，以下数据将会重新加载?',function(r){
				if(r){
				 gwareList="";
				 var rows = $('#datagrid').datagrid('getRows');
	     	     for(var i=rows.length-1;i>=0;i--){
	     	        $("#datagrid").datagrid('deleteRow',i);
	     	    }
				 //queryCheckWare();
				 storageId = o.value; 
				}
				else{
					o.value=storageId;
				}
				
			});
		}  
		
		function updateProductDate(wareId,date)
		{
			for(var i = 0;i<gwareList.length;i++)
				{
				if(gwareList[i].wareId==wareId)
					{
					gwareList[i].productDate = date;
					break;
					}
				}
		}
		 
		function toDownloadDataExcel() {
			
			var wareList = new Array();
			for(var i = 0;i<gwareList.length;i++){
			    var wareId =  gwareList[i].wareId;
			    var qty =  gwareList[i].qty;
			    var minQty =  gwareList[i].minQty;
			    if(qty == ""){
			    	qty=0;
			    }
			    if(minQty==""){
			    	minQty=0;
			    }
			    if(wareId == 0)continue;
			    var produceDate =document.getElementById("produceDate"+wareId).value;
			    var subObj = {
			    		waretypePath:gwareList[i].waretypePath,
						wareId: wareId,				
						qty:formatterNumber(qty),
						minQty:formatterNumber(minQty),
						minUnit:gwareList[i].minUnit,
						hsNum:gwareList[i].hsNum,
						produceDate:produceDate,
						wareNm:gwareList[i].wareNm,
						wareCode:gwareList[i].wareCode,
						stkQty:gwareList[i].stkQty,
						unitName:gwareList[i].unitName,
						disQty:gwareList[i].disQty,
						wareGg:gwareList[i].wareGg
				};
			    wareList.push(subObj);
			}
			if(wareList.length == 0)
				{
					alert("请选择商品");
					return;
				}
          if(confirm("是否下载数据?")){
        	  $("#wareStr").val(JSON.stringify(wareList));
        	  document.getElementById("dataForm").submit();
			}
   }

   function toDownloadCheckCustomTemplate(){
		   if (confirm("是否确定下载自定义模版?")) {
			   window.location.href = "manager/downloadCheckCustomTemplate";
		   }
   }

		function showUpdateWares(ids){
			document.getElementById("dialogUpdateWaresfrm").src = "<%=basePath%>/manager/toWareRepair?ids="+ids;
			$('#dialogUpdateWares').dialog('open');
		}

		function refreshCheckWare(){
			var wareIds = $("#wareIds").val();
			$.ajax({
				url: "<%=basePath %>/manager/getWareByIds",
				type: "POST",
				data : {"ids":wareIds},
				dataType: 'json',
				async : false,
				success: function (json) {
					if(json!=undefined&&json.state){
						var wareDatas = json.rows;
						var rows = $('#datagrid').datagrid('getRows');
						for(var i=rows.length-1;i>=0;i--){
							$("#datagrid").datagrid('deleteRow',i);
						}
						for(var i = 0;i<gwareList.length;i++)
						{
							var newWare =getNewWare(gwareList[i].wareId,wareDatas);
							var d = gwareList[i];
							if(newWare!=""){
								var minQty=d.minQty;
								if(minQty==""){
									minQty=0;
								}
								var qty =d.qty;
								var stkQty = d.stkQty;
								var disQty = qty - stkQty;
								disQty = numeral(disQty).format("0.0000000000");
								var hsNum = newWare.hsNum;
								if(hsNum==0||hsNum==null||hsNum==undefined){
									hsNum = 1;
								}
								var hsQty = minQty/hsNum;
								disQty = parseFloat(disQty) + parseFloat(hsQty);
								disQty = formatterNumber(disQty);
								d.disQty = disQty;
								d.hsNum = hsNum;
								d.unitName =newWare.wareDw;
								d.minUnit = newWare.minUnit;
								gwareList[i] = d;
							}
							$('#datagrid').datagrid("appendRow",d);
						}
					}
				}
			});
		}
		function getNewWare(wareId,wareDatas){
			var newWare="";
			for(var i=0;i<wareDatas.length;i++){
				var data = wareDatas[i];
				if(wareId==data.wareId){
					newWare = data;
					break;
				}
			}
			return newWare;
		}
		</script>
	</body>
</html>
