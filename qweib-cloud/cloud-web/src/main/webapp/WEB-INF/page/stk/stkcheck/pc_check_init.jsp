<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>初始化库存</title>

		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/stkstyle/css/stkcheck.css"/>		
		<script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
		<script type="text/javascript" src="resource/loadDiv.js"></script>
		<script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
	</head>
	<body onload="formload()">
		<input type="hidden" name="wtype" id="wtype" value="${wtype}"/>
		<input type="hidden" id="billId" value="${billId}"/>
		<input type="hidden" id="stkId" value="${stkId}"/>
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
			border="false"
			rownumbers="true" pagination="false" pagePosition=3
			 toolbar="#tb" >
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
					<th field="unitName" width="60" align="center">
						大单位
					</th>
					<th  width="120"  formatter="amtformatterQty">
						初始大单位数量
					</th>
					<th field="inPrice" width="80" align="center" formatter="amtformatterInPrice">
						大单位价格
					</th>
					<th field="minUnit" width="60" align="center">
						小单位
					</th>
					<th field="minQty" width="120" align="center" formatter="amtformatterMinQty">
						初始小单位数量
					</th>
					<th field="sunitPrice" width="90" align="center" formatter="amtformatterSunitPrice">
						小单位价格
					</th>
					<th field="hsNum" width="60" align="center"  hidden="true">
						换算数量
					</th>
					<th field="disQty" width="80" align="center" formatter="amtformatterDisQty">
						初始数量
					</th>
					<th field="productDate" width="90" align="center" formatter="amtformatterDate">
						生产日期
					</th>
				</tr>
			</thead>
			
		</table>
		<div id="tb" style="padding:5px;height:auto">
		 初始化时间:
		 <input name="sdate" id="checkDate"  onClick="WdatePicker({skin:'whyGreen',dateFmt: 'yyyy-MM-dd HH:mm:ss'});" style="width: 100px;" value="${checkTime}" readonly="readonly"/>
	     <img onclick="WdatePicker({skin:'whyGreen',dateFmt: 'yyyy-MM-dd HH:mm:ss'});" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
		初始化仓库: <select name="stkId" id="stksel" value="${stkId}">
	              </select>
	    盘点人: <input name="edtstaff" id="edtstaff" style="width:120px;height: 20px;" readonly="readonly" value="${staff}"/>	  
			<a class="easyui-linkbutton" iconCls="icon-search" plain="true" href="javascript:showStaffForm();">选择人员</a>
			<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:dialogSelectWare();">选择商品</a>
			<a class="easyui-linkbutton" iconCls="icon-save" plain="true" href="javascript:drageSaveStk();">暂存</a>
			<c:if test="${billId eq 0}">
				<a class="easyui-linkbutton" iconCls="icon-save" plain="true" href="javascript:submitStk();">保存并审批</a>
			</c:if>
			（大单位数量+小单位数量=初始化数量）
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
		<script type="text/javascript">
		var editstatus = 0;
		var gwareList;
		    function formload()
		    {
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
		    	}else{
					displaySub();
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
				        				minQty:"",
				        				minUnit:json.list[i].minUnit,
				        				hsNum:json.list[i].hsNum,
				        				qty:"",
				        				disQty:"",
										inPrice:json.list[i].inPrice,
										sunitPrice:json.list[i].sunitPrice,
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
						        				qty:"",
						        				minQty:"",
						        				minUnit:json.list[i].minUnit,
						        				hsNum:json.list[i].hsNum,
						        				disQty:"",
											    inPrice:json.list[i].inPrice,
												sunitPrice:json.list[i].sunitPrice,
						        				productDate:json.list[i].productDate					
						        			};
				        				var data = row;
				        				$('#datagrid').datagrid("appendRow", row);
				        				 gwareList.push(data);
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
					        				qty:"",
					        				minQty:"",
					        				minUnit:json.list[i].minUnit,
					        				hsNum:json.list[i].hsNum,
					        				disQty:0,
										    inPrice:json.list[i].inPrice,
											sunitPrice:json.list[i].sunitPrice,
					        				productDate:json.list[i].productDate					
					        			};
			        				gwareList.push(data);
			        			}
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
	        				minQty:"",
	        				minUnit:json.list[i].minUnit,
	        				hsNum:json.list[i].hsNum,
	        				qty:"",
	        				disQty:"",
							inPrice:json.list[i].inPrice,
							sunitPrice:json.list[i].sunitPrice,
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
			        				qty:"",
			        				minQty:"",
			        				minUnit:json.list[i].minUnit,
			        				hsNum:json.list[i].hsNum,
			        				disQty:"",
								    inPrice:json.list[i].inPrice,
									sunitPrice:json.list[i].sunitPrice,
			        				productDate:json.list[i].productDate					
			        			};
	        				var data = row;
	        				$('#datagrid').datagrid("appendRow", row);
	        				 gwareList.push(data);
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
		        				qty:"",
		        				minQty:"",
		        				minUnit:json.list[i].minUnit,
		        				hsNum:json.list[i].hsNum,
		        				disQty:0,
								inPrice:json.list[i].inPrice,
								sunitPrice:json.list[i].sunitPrice,
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
						$("#chooselist").text("");
						var size = json.list.length;
						gwareList = new Array();
						/*
						waretypePath:json.list[i].waretypePath,
								wareId:json.list[i].wareId,
								wareNm:json.list[i].wareNm,
								wareGg:json.list[i].wareGg,
								wareCode:json.list[i].wareCode,
								unitName:json.list[i].wareDw,
								minQty:"",
								minUnit:json.list[i].minUnit,
								hsNum:json.list[i].hsNum,
								qty:"",
								disQty:"",
								inPrice:json.list[i].inPrice,
								sunitPrice:json.list[i].sunitPrice,
								productDate:json.list[i].productDate*/
						for(var i = 0;i < size; i++)
						{
							var data = {
								waretypePath:json.list[i].waretypePath,
								wareId:json.list[i].wareId,
								wareNm:json.list[i].wareNm,
								wareGg:json.list[i].wareGg,
								wareCode:json.list[i].wareCode,
								unitName:json.list[i].unitName,
								qty:formatterNumber(json.list[i].qty),
								minQty:formatterNumber(json.list[i].minQty),
								minUnit:json.list[i].minUnit,
								hsNum:json.list[i].hsNum,
								disQty:formatterNumber(json.list[i].disQty),
								inPrice:json.list[i].price,
								sunitPrice:formatterNumber(json.list[i].sunitPrice),
								productDate:json.list[i].produceDate
							};
							$('#datagrid').datagrid("appendRow", data);
							gwareList.push(data);
						}
						/*
						var size = json.list.length;
						for(var i = 0;i < size; i++)
						{
							$('#datagrid').datagrid("appendRow", {
								wareId:json.list[i].wareId,
								wareNm:json.list[i].wareNm,
								wareGg:json.list[i].wareGg,
								wareCode:json.list[i].wareCode,
								unitName:json.list[i].unitName,
								qty:formatterNumber(json.list[i].qty),
								price:json.list[i].price,
								sunitPrice:json.list[i].sunitPrice,
								minQty:formatterNumber(json.list[i].minQty),
								minUnit:json.list[i].minUnit,
								hsNum:json.list[i].hsNum,
								produceDate:json.list[i].produceDate,
								disQty:formatterNumber(json.list[i].disQty)
							});
						}
						*/
					}

				}
			});

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
				  // var billId= $("#billId").val();
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
						        if(qty==""){
						        	qty=0;
						        }
								var disQty = qty;
								disQty = numeral(disQty).format("0.00");
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
							var disQty = qty;
							disQty = numeral(disQty).format("0.00");
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
						alert("已提交不能修改！");
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
					    //var qty =  gwareList[i].qty;
					    //var minQty =  gwareList[i].minQty;
					    if(wareId == 0)continue;
					    var produceDate = $("#produceDate"+wareId).val();
						var inPrice = $("#inPrice"+wareId).val();
						var sunitPrice = $("#sunitPrice"+wareId).val();
						var qty =  $("#qty"+wareId).val();
						var minQty =  $("#minQty"+wareId).val();
					    var subObj = {
								wareId: wareId,				
								qty:formatterNumber(qty),
								minQty:formatterNumber(minQty),
								minUnit:gwareList[i].minUnit,
								hsNum:gwareList[i].hsNum,
								produceDate:produceDate,
								price:inPrice,
								sunitPrice:sunitPrice
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
					var path = "manager/addStkCheckInit";
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
						        		window.parent.location.href='manager/showStkcheckInit?billId=' + json.id;
						        	}
						        }
						    });
						}});
				}

		function drageSaveStk(){
			var stkId = $("#stksel").val();
			var remarks = "";
			var checkTime = $("#checkDate").val();
			var staff = $("#edtstaff").val();
			var billId = $("#billId").val();
			var wareList = new Array();
			for(var i = 0;i<gwareList.length;i++){
				var wareId =  gwareList[i].wareId;
				//var qty =  gwareList[i].qty;
				//var minQty =  gwareList[i].minQty;
				if(wareId == 0)continue;
				var produceDate = $("#produceDate"+wareId).val();
				var inPrice = $("#inPrice"+wareId).val();
				var sunitPrice = $("#sunitPrice"+wareId).val();
				var qty =  $("#qty"+wareId).val();
				var minQty =  $("#minQty"+wareId).val();
				var disQty =  gwareList[i].disQty;
				var subObj = {
					wareId: wareId,
					qty:formatterNumber(qty),
					minQty:formatterNumber(minQty),
					minUnit:gwareList[i].minUnit,
					hsNum:gwareList[i].hsNum,
					produceDate:produceDate,
					price:inPrice,
					sunitPrice:sunitPrice,
					disQty:disQty
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
			var path = "manager/dragStkCheckInit";
			var token = $("#tmptoken").val();
			//alert(JSON.stringify(wareList));

			$.messager.confirm('确认', '是否确定暂暂存？?',function(r){
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
								alert(json.msg);
								//window.parent.location.href='manager/showStkcheckInit?billId=' + json.id;
							}
						}
					});
				}});
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
        				unitName:gwareList[i].unitName,
        				qty:gwareList[i].qty,
        				minQty:gwareList[i].minQty,
        				minUnit:gwareList[i].minUnit,
        				hsNum:gwareList[i].hsNum,
        				disQty:gwareList[i].disQty,
						inPrice:gwareList[i].inPrice,
						sunitPrice:gwareList[i].sunitPrice,
						productDate:gwareList[i].productDate
        			});
        		}		
			}
		  function chooseWare()
		    {
		    	parent.parent.add('选择商品','manager/pcstkchecktypeselect');
			}
		  
		  function amtformatter(v,row)
			{
				if (row != null) {
                  return numeral(v).format("0.00");
              }
			}
		  function formatterNumber(v,f)
			{
				if (v != null&&(f==null ||f==undefined)) {
                return numeral(v).format("0.00");
            	}else if(v !=null&&f!=null){
            		 return numeral(v).format(f);
            	}else{
            		return 0;
            	}
			}
		  
		function amtformatterDate(v,row){
			var date= ' <input name="productDate" id="produceDate'+row.wareId+'"  value="'+row.productDate+'" onchange="updateProductDate('+row.wareId+',this.value)"  onClick="WdatePicker({skin:\'whyGreen\',dateFmt: \'yyyy-MM-dd\'});" style="width: 80px;" class="pcl_i2"  readonly="readonly"/>';
			return date;
		}

		function amtformatterQty(v,row){
			var qty= ' <input name="qty" id="qty'+row.wareId+'" onkeyup="CheckInFloat(this)"  value="'+row.qty+'"  onchange="updateQty('+row.wareId+',this.value)"  style="width: 85px;" class="pcl_i2"  />';
			return qty;
		}

		function amtformatterMinQty(v,row){
			var minQty= ' <input name="minQty" id="minQty'+row.wareId+'" onkeyup="CheckInFloat(this)"  value="'+row.minQty+'"  onchange="updateMinQty('+row.wareId+',this.value)"  style="width: 90px;" class="pcl_i2"  />';
			return minQty;
		}

		function amtformatterInPrice(v,row){
			var inPrice= ' <input name="inPrice" id="inPrice'+row.wareId+'" onkeyup="CheckInFloat(this)"  value="'+row.inPrice+'"  onchange="updateInPrice('+row.wareId+',this.value)"  style="width: 60px;" class="pcl_i2"  />';
			return inPrice;
		}

		function amtformatterSunitPrice(v,row){
			var sunitPrice= ' <input name="sunitPrice" id="sunitPrice'+row.wareId+'" onkeyup="CheckInFloat(this)"  value="'+row.sunitPrice+'" onchange="updateSunitPrice('+row.wareId+',this.value)"  style="width: 60px;" class="pcl_i2" />';
			return sunitPrice;
		}

		function amtformatterDisQty(v,row){
			var disQty= ' <input name="disQty" id="disQty'+row.wareId+'" onkeyup="CheckInFloat(this)"  value="'+row.disQty+'" onchange="updateDisQty('+row.wareId+',this.value)"  style="width: 60px;" class="pcl_i2" />';
			return disQty;
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
		  
		  function updateInPrice(wareId,inPrice)
			{
				for(var i = 0;i<gwareList.length;i++)
					{
					if(gwareList[i].wareId==wareId)
						{
						gwareList[i].inPrice = inPrice;
						break;
						}
					}
			}

		function updateQty(wareId,qty)
		{
			for(var i = 0;i<gwareList.length;i++)
			{
				if(gwareList[i].wareId==wareId)
				{
					gwareList[i].qty = qty;
					minQty = gwareList[i].minQty
					if(minQty==undefined||minQty==""){
						minQty = 0;
					}
					if(qty==""){
						qty = 0;
					}

					var hsNum = 1;
					var row = $('#datagrid').datagrid('getSelected');
					if(row){
						hsNum = row.hsNum;
					}
					if(hsNum==0||hsNum==null||hsNum==undefined){
						hsNum = 1;
					}
					var minQty = minQty/hsNum;
					var disQty = parseFloat(minQty)+parseFloat(qty);
					gwareList[i].disQty = disQty;
					document.getElementById("disQty"+wareId).value=disQty;
					break;
				}
			}
		}

		function updateMinQty(wareId,minQty)
		{
			for(var i = 0;i<gwareList.length;i++)
			{
				if(gwareList[i].wareId==wareId)
				{
					gwareList[i].minQty = minQty;
					qty = gwareList[i].qty;
					if(minQty==undefined||minQty==0){
						minQty =0;
					}
					if(qty==undefined||qty==0){
						qty = 0;
					}
					var hsNum = 1;
					var row = $('#datagrid').datagrid('getSelected');
                    if(row){
						hsNum = row.hsNum;
					}
					if(hsNum==0||hsNum==null||hsNum==undefined){
						hsNum = 1;
					}
					var minQty = minQty/hsNum;
					var disQty = parseFloat(minQty)+parseFloat(qty);
					gwareList[i].disQty = disQty;
					document.getElementById("disQty"+wareId).value=disQty;
					break;
				}
			}
		}

		function updateSfrontPrice(wareId,sunitPrice)
		{
			for(var i = 0;i<gwareList.length;i++)
			{
				if(gwareList[i].wareId==wareId)
				{
					gwareList[i].sunitPrice = sunitPrice;
					break;
				}
			}
		}
		</script>
	</body>
</html>
