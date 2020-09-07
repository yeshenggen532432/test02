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
		<script src="<%=basePath %>/resource/stkstyle/js/easyui-lang-zh_CN.js" type="text/javascript" charset="utf-8"></script>
		<script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
	</head>

	<body onload="formload()">
	<input type="hidden" id="billId" value="${billId}" />
		<input type="hidden" name="wtype" id="wtype" value="${wtype}"/>
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
			 border="false"
			rownumbers="true" fitColumns="true" pagination="true" pagePosition=3
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" data-options="onClickRow: onClickRow1">
			<thead>
				<tr>
				
					
					
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
		
		   备注: <input name="remarks" id="remarks" style="width:120px;height: 20px;" value="${remarks}"/>	  
			<a class="easyui-linkbutton" iconCls="icon-save" href="javascript:submitStk();">保存</a>
			
			
			显示计划促销否：<input type="checkbox" id="checkshow" onchange="showDiscount(this)"/>
			
		</div>
		
		<div id="dlg" closed="true" class="easyui-dialog" title="设置" style="width:400px;height:200px;padding:10px"
			data-options="
				iconCls: 'icon-save',
				
				buttons: [{
					text:'确定',
					iconCls:'icon-ok',
					handler:function(){
						saveParams();
					}
				},{
					text:'取消',
					handler:function(){
						$('#dlg').dialog('close');
					}
				}]
			">
		促销类型数量: <input name="disQty" id="disQty" value="${disQty}" style="width:120px;height: 20px;"/> 1~4
		
		</div>
		
		<script type="text/javascript">
		var gwareList;

		function initGrid(flag)
	    {
		    var isHidden = 'true';
		    //if(flag == 1)isHidden = 'false';
	    	///alert(isHidden);
	    	    var cols = new Array(); 
	    	    var col = {
						field: 'wareId',
						title: 'id',
						width: 150,
						align:'center',
						hidden:'true'
										
				};
	    	    cols.push(col);
	    	    
	    	    var cols = new Array(); 
	    	    var col = {
						field: 'id',
						title: 'id',
						width: 150,
						align:'center',
						hidden:'true'
										
				};
	    	    cols.push(col);
	    	    
	    	    var col = {
						field: 'wareCode',
						title: '商品编码',
						width: 80,
						align:'center'
										
				};
	    	    cols.push(col);
	    	    
	    	    
	    	    
	    	    var col = {
						field: 'wareNm',
						title: '商品名称',
						width: 100,
						align:'center'
										
				};
	    	    cols.push(col);
	    	    
	    	    var col = {
						field: 'price',
						title: '计划倍价',
						width: 80,
						align:'center',
						editor:{type:'text'}
										
				};
	    	    cols.push(col);
	    	    
	    	    var col = {
						field: 'inPrice',
						title: '计划进价',
						width: 80,
						align:'center',
						editor:{type:'text'}
										
				};
	    	    cols.push(col);
	    	    
	    	    var col = {
						field: 'discount',
						title: '计划促销',
						width: 80,
						align:'center',
						editor:{type:'text'}
										
				};
	    	    cols.push(col);
	    	    
	    	    var col = {
						field: 'discount2',
						title: '计划促销2',
						width: 80,
						align:'center',
						editor:{type:'text'},
						hidden:isHidden
										
				};
	    	    cols.push(col);
	    	    
	    	    var col = {
						field: 'discount3',
						title: '计划促销3',
						width: 80,
						align:'center',
						editor:{type:'text'},
						hidden:isHidden
										
				};
	    	    cols.push(col);
	    	    
	    	    var col = {
						field: 'discount4',
						title: '计划促销4',
						width: 80,
						align:'center',
						editor:{type:'text'},
						hidden:isHidden
										
				};
	    	    cols.push(col);
	    	    
	    	    var col = {
						field: 'startTime',
						title: '开始日期',
						width: 80,
						align:'center',
						editor:{type:'datebox'}
										
				};
	    	    cols.push(col);
	    	    
	    	    var col = {
						field: 'endTime',
						title: '结束日期',
						width: 80,
						align:'center',
						editor:{type:'datebox'}
										
				};
	    	    cols.push(col);
				
	    	    
	    	    var col = {
						field: 'disAmt',
						title: '计划毛利',
						width: 80,
						align:'center'
										
				};
	    	    cols.push(col);    
	    	    

	    	    
		    	
	    	    $('#datagrid').datagrid({
	    	    	
	    	    		columns:[
	    	    		  		cols
	    	    		  	]}
	    	    );
	    	    //$('#datagrid').datagrid('reload'); 
		}
		    //查询
			function queryWare(){
				$("#datagrid").datagrid('load',{
					url:"manager/queryStkWares",
					   wareNm:$("#wareNm").val()
				});
			}	
		    
			function formload()
		    {
		    	initGrid(0);
		    	var billId = $("#billId").val();
		    	if(billId == 0)
		    	{
		    	
			    
				queryPlanWare();
		    	}
		    	else
		    	{
		    		displaySub();	
		    	}
				
		    }
			
			function paramClick()
			{
				
				$('#dlg').dialog('open');
			}
		    
			function saveParams()
			{
				var qty = $("#disQty").val();
				if(qty == "")
					{
					 	alert("请输入数量");
					 	return ;
					}
				if(qty<1)qty = 1;
				if(qty>4)qty = 4;
				var paramName = "促销类型数量";
				
				$.ajax( {
					url : "manager/saveParam",
					data : 'paramName=' + paramName + '&paramValue=' + qty,
					type : "post",
					success : function(json) {
						if (json.state) {
							showMsg("保存成功");
							$('#dlg').dialog('close');
							
						} else{
							showMsg("保存失败" + json.msg);
						}
					}
				});
			}
		    
			function queryPlanWare()
			{
				var path = "manager/queryPlanWare1";
				//var token = $("#tmptoken").val();
				//alert(token);
				
				
				$.ajax({
			        url: path,
			        type: "POST",
			        data : {"stkId":0},
			        dataType: 'json',
			        async : false,
			        success: function (json) {
			        	if(json.state){
			        		
			        		var size = json.list.length;
			        		//$("#chooselist").text("");
			        		gwareList = json.list;
			        		for(var i = 0;i < size; i++)
			        			{
			        			var price = 0;
			        			if(json.list[i].price!= ""&&json.list[i].price !== undefined &&json.list[i].price!=null)price = json.list[i].price;
			        			var inPrice = 0;
			        			if(json.list[i].inPrice != ""&&json.list[i].inPrice !== undefined &&json.list[i].inPrice!=null)inPrice = json.list[i].inPrice;
			        			var discount = 0;
			        			if(json.list[i].discount != ""&&json.list[i].discount !== undefined &&json.list[i].discount!=null)discount = json.list[i].discount;
			        			var discount2 = 0;
			        			if(json.list[i].discount2 != ""&&json.list[i].discount2 !== undefined &&json.list[i].discount2!=null)discount2 = json.list[i].discount2;
			        			var discount3 = 0;
			        			if(json.list[i].discount3 != ""&&json.list[i].discount3 !== undefined &&json.list[i].discount3!=null)discount3 = json.list[i].discount3;
			        			var startTime = "";
			        			if(json.list[i].startTime != ""&&json.list[i].startTime !== undefined &&json.list[i].startTime!=null)startTime = json.list[i].startTime;
			        			var endTime = "";
			        			if(json.list[i].endTime != ""&&json.list[i].endTime !== undefined &&json.list[i].endTime!=null)endTime = json.list[i].endTime;
			        			var disAmt = 0;
			        			if(json.list[i].disAmt != ""&&json.list[i].disAmt !== undefined &&json.list[i].disAmt!=null)disAmt = json.list[i].disAmt;
			        			$('#datagrid').datagrid("appendRow", {  
			        				
			        				wareId:json.list[i].wareId,
			        				wareNm:json.list[i].wareNm,
			        				wareCode:json.list[i].wareCode,
			        				//unitName:json.list[i].unitName,
			        				price:price,
			        				inPrice:inPrice,
			        				discount:discount,
			        				discount2:discount2,
			        				discount3:discount3,
			        				discount4:json.list[i].discount4,
			        				startTime:startTime,
			        				endTime:endTime,
			        				disAmt:disAmt
			        				
			        			
			        			});
			        				

			        	}
			        }
			        }
			    });
			}
			
			function displaySub()
			{
				
				var path = "manager/queryPlanSub";
				//var token = $("#tmptoken").val();
				//alert(token);
				
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
			        		//$("#chooselist").text("");
			        		gwareList = json.list;
			        		for(var i = 0;i < size; i++)
			        			{
			        			
			        			$('#datagrid').datagrid("appendRow", {  
			        				
			        				wareId:json.list[i].wareId,
			        				wareNm:json.list[i].wareNm,
			        				wareCode:json.list[i].wareCode,
			        				//unitName:json.list[i].unitName,
			        				price:json.list[i].price,
			        				inPrice:json.list[i].inPrice,
			        				discount:json.list[i].discount,
			        				discount2:json.list[i].discount2,
			        				discount3:json.list[i].discount3,
			        				discount4:json.list[i].discount4,
			        				startTime:json.list[i].startTime,
			        				endTime:json.list[i].endTime,
			        				disAmt:json.list[i].disAmt			
			        				
			        			
			        			});
			        				

			        	}
			        }
			        }
			    });
				
			}
			function myformatter(date){
	            var y = date.getFullYear();
	            var m = date.getMonth()+1;
	            var d = date.getDate();
	            return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	        }
	        function myparser(s){
	            if (!s) return new Date();
	            var ss = (s.split('-'));
	            var y = parseInt(ss[0],10);
	            var m = parseInt(ss[1],10);
	            var d = parseInt(ss[2],10);
	            if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
	                return new Date(y,m-1,d);
	            } else {
	                return new Date();
	            }
	        }
		    
			var editIndex = undefined;
			function endEditing(){
				if (editIndex == undefined){return true}
				if ($('#datagrid').datagrid('validateRow', editIndex)){
					//var ed = $('#datagrid').datagrid('getEditor', {index:editIndex,field:'qty'});
					$('#datagrid').datagrid('acceptChanges');
					var inPrice =$('#datagrid').datagrid('getRows')[editIndex]['inPrice'];
					var price = $('#datagrid').datagrid('getRows')[editIndex]['price'];
					var discount = $('#datagrid').datagrid('getRows')[editIndex]['discount'];
					var discount2 = $('#datagrid').datagrid('getRows')[editIndex]['discount2'];
					var discount3 = $('#datagrid').datagrid('getRows')[editIndex]['discount3'];
					var discount4 = $('#datagrid').datagrid('getRows')[editIndex]['discount4'];
					var disAmt = price - inPrice - discount - discount2 - discount3 - discount4;
					var wareId = $('#datagrid').datagrid('getRows')[editIndex]['wareId'];
					//var productname = $(ed.target).combobox('getText');
					var startTime = $('#datagrid').datagrid('getRows')[editIndex]['startTime']; 
					var endTime = $('#datagrid').datagrid('getRows')[editIndex]['endTime'];
					$('#datagrid').datagrid('getRows')[editIndex]['disAmt'] = disAmt;
					
					disAmt = numeral(disAmt).format("0,0.00")
					$('#datagrid').datagrid('updateRow',{index:editIndex,row:{disAmt:disAmt}});
					updateWareList(wareId,price,inPrice,discount,discount2,discount3,discount4,startTime,endTime,disAmt);
					$('#datagrid').datagrid('endEdit', editIndex);
					editIndex = undefined;
					return true;
				} else {
					return false;
				}
			}
			function updateWareList(wareId,price,inPrice,discount,discount2,discount3,discount4,startTime,endTime,disAmt)
			{
				for(var i = 0;i<gwareList.length;i++)
					{
					if(gwareList[i].wareId==wareId)
						{
						gwareList[i].price = price;
						gwareList[i].inPrice = inPrice;
						gwareList[i].discount = discount;
						gwareList[i].discount2 = discount2;
						gwareList[i].discount3 = discount3;
						gwareList[i].discount4 = discount4;
						gwareList[i].startTime = startTime;
						gwareList[i].endTime = endTime;
						gwareList[i].disAmt = disAmt;
						break;
						}
					}
			}
			function onClickRow1(index){
				  var billId= $("#billId").val();
				  //if(billId > 0)return;
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
		  
		   
function submitStk(){
					
					
					var billId = $("#billId").val();
					var remarks = $("#remarks").val();
					/*if(billId > 0)
						{
						alert("不能修改");
						return;
						}*/
					
					
					
					
					
					//alert(outTime);
					
					var wareList = new Array();
					var arr =  $('#datagrid').datagrid('getData');
					for(var i = 0;i<gwareList.length;i++) {		
					   
					    var wareId =  gwareList[i].wareId;
					    var price = 0;
	        			if(gwareList[i].price!= ""&&gwareList[i].price !== undefined &&gwareList[i].price!=null)price = gwareList[i].price;
	        			var inPrice = 0;
	        			if(gwareList[i].inPrice != ""&&gwareList[i].inPrice !== undefined &&gwareList[i].inPrice!=null)inPrice = gwareList[i].inPrice;
	        			var discount = 0;
	        			if(gwareList[i].discount != ""&&gwareList[i].discount !== undefined &&gwareList[i].discount!=null)discount = gwareList[i].discount;
	        			var startTime = "";
	        			if(gwareList[i].startTime != ""&&gwareList[i].startTime !== undefined &&gwareList[i].startTime!=null)startTime = gwareList[i].startTime;
	        			var endTime = "";
	        			if(gwareList[i].endTime != ""&&gwareList[i].endTime !== undefined &&gwareList[i].endTime!=null)endTime = gwareList[i].endTime;
	        			var disAmt = 0;
	        			if(gwareList[i].disAmt != ""&&gwareList[i].disAmt !== undefined &&gwareList[i].disAmt!=null)disAmt = gwareList[i].disAmt;
	        			var discount2 = 0;
	        			if(gwareList[i].discount2 != ""&&gwareList[i].discount2 !== undefined &&gwareList[i].discount2!=null)discount2 = gwareList[i].discount2;
	        			var discount3 = 0;
	        			if(gwareList[i].discount3 != ""&&gwareList[i].discount3 !== undefined &&gwareList[i].discount3!=null)discount3 = gwareList[i].discount3;
	        			var discount4 = 0;
	        			if(gwareList[i].discount4 != ""&&gwareList[i].discount4 !== undefined &&gwareList[i].discount4!=null)discount4 = gwareList[i].discount4;
					    if(wareId == 0)continue;
					    var subObj = {
								wareId: wareId,				
								price: price,
								inPrice:inPrice,
								discount:discount,
								discount2:discount2,
								discount3:discount3,
								discount4:discount4,
								startTime:startTime,
								endTime:endTime,
								disAmt:disAmt
												
						};
					    wareList.push(subObj);
					    
					    
					}
					
					if(wareList.length == 0)
						{
							alert("请选择商品");
							return;
						}
					
					
					
					var path = "manager/addStkPlan";
					var token = $("#tmptoken").val();
					//alert(JSON.stringify(wareList));
					//if(!confirm('保存后将不能修改，是否确定保存？'))return;
					$.ajax({
				        url: path,
				        type: "POST",
				        data : {"token":token,"remarks":remarks,"id":billId,"wareStr":JSON.stringify(wareList)},
				        dataType: 'json',
				        async : false,
				        success: function (json) {
				        	
				        	if(json.state){
				        		$("#billId").val(json.id);
				        		alert("提交成功");
				        		statuschg(0);
				        		//window.location.href='stkoutQuery?token=' + token;
				        	}
				        }
				    });
				}


function chooseWareType(wareType)
{
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
				if(ss[j] == wareType||wareType==0)
					{
						flag = 1;
						break;
					}
			}
		if(flag == 0)continue;
		$('#datagrid').datagrid("appendRow", {  
			wareId:gwareList[i].wareId,
			wareNm:gwareList[i].wareNm,
			wareCode:gwareList[i].wareCode,
			//unitName:json.list[i].unitName,
			price:gwareList[i].price,
			inPrice:gwareList[i].inPrice,
			discount:gwareList[i].discount,
			discount2:gwareList[i].discount2,
			discount3:gwareList[i].discount3,
			discount4:gwareList[i].discount4,
			startTime:gwareList[i].startTime,
			endTime:gwareList[i].endTime,
			disAmt:gwareList[i].disAmt					
			
		
		});
			

	}		
}

function showDiscount(chk)
{
	if(chk.checked)
		{
		$('#datagrid').datagrid('showColumn','discount2');
		$('#datagrid').datagrid('showColumn','discount3');
		$('#datagrid').datagrid('showColumn','discount4');
		}
	else 
		{
		$('#datagrid').datagrid('hideColumn','discount2');
		$('#datagrid').datagrid('hideColumn','discount3');
		$('#datagrid').datagrid('hideColumn','discount4');
		}
	chooseWareType(0);
}

		</script>
	</body>
</html>
