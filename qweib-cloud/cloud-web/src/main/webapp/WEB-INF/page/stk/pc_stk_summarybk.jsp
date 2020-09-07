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
		<script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
		<script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
	</head>

	<body class="easyui-layout" onload="initGrid()" >
	<div data-options="region:'west',split:true,title:'商品分类树'"
			style="width:150px;padding-top: 5px;">
			<ul id="waretypetree" class="easyui-tree"
				data-options="url:'manager/companyWaretypes',animate:true,dnd:true,onClick: function(node){
					toShowWare(node.id);
				},onDblClick:function(node){
					$(this).tree('toggle', node.target);
				}">
			</ul>
		</div>
		<div id="wareTypeDiv" data-options="region:'center'" >
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
			url="manager/stkSummaryPage" title="" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="false" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" data-options="onClickCell: onClickCell,onDblClickRow: onDblClickRow,onLoadSuccess:onLoadSuccess">
			
		</table>
		<div id="tb" style="padding:5px;height:auto">
		时间: <input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
	         	   <img onclick="WdatePicker({el:'stime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         	   -
	         	<input name="edate" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
	         	   <img onclick="WdatePicker({el:'etime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
		     商品名称: <input type="text" name="wareNm" id="wareNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
			
	        仓库: <select name="wareStk" id="stkId">
	   <option value="0">全部</option>                 
	                    
	                </select>	  		  
	         
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryClick();">查询</a>
			<!--<a class="easyui-linkbutton" iconCls="icon-add" href="javascript:chooseWare();">选择商品</a>-->
			<!--  <a class="easyui-linkbutton" iconCls="icon-print" href="javascript:myexport();">导出</a>-->
			<a class="easyui-linkbutton" iconCls="icon-redo" plain="true" href="javascript:toLoadExcel();">导出</a>
			
			<span style="display: ${permission:checkUserFieldDisplay('stk.wareSfcStat.showamt')}">
			显示金额否：<input type="checkbox" id="chkshowamt" onchange="chooseRight(this)"/>
			过滤数量为0的记录否：<input type="checkbox" id="hideZero" onchange="querydata()"/>
			</span>
			<input type="hidden" id="waretype" value="0"/>
		</div>
		</div>
		<div>
		  	<form action="manager/orderExcel" name="loadfrm" id="loadfrm" method="post">
		  		<input type="text" name="orderNo2" id="orderNo2"/>
				<input type="text" name="khNm2" id="khNm2"/>
				<input type="text" name="memberNm2" id="memberNm2"/>
				<input type="text" name="sdate2" id="sdate2"/>
				<input type="text" name="edate2" id="edate2"/>
				<input type="text" name="orderZt2" id="orderZt2"/>
				<input type="text" name="pszd2" id="pszd2"/>
		  	</form>
	  	</div>
		<%@include file="/WEB-INF/page/export/export.jsp"%>
		<script type="text/javascript">
		    var database="${database}";
		    queryBasestorage();
		   
		    //initGrid();
			   function initGrid()
			   {
				   var cols = new Array(); 
				   var col = {
							field: 'stkId',
							title: 'stkId',
							width: 100,
							align:'center',
							hidden:true				
					};
				   cols.push(col);	
				   
				   var col = {
							field: 'wareId',
							title: 'wareId',
							width: 100,
							align:'center',
							hidden:true
							
											
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
							field: 'unitName',
							title: '单位',
							width: 50,
							align:'center'
							
											
					};
		    	    cols.push(col);
                    
		    	    var showDisplay='${permission:checkUserFieldDisplay("stk.wareSfcStat.showamt")}';
		    	    var showHidden = false;
		    	    if(showDisplay=='none'){
		    	    	showHidden = true;
		    	    }
		    	    
					if(${stkRight.qtyFlag} == 1)
						{
		    	    		var col = {
							field: 'initQty',
							title: '期初数量',
							width: 80,
							align:'center',
							formatter:amtformatter
							
											
							};
		    	    		cols.push(col);

		    	   
						}
					if(${stkRight.amtFlag} == 1)
						{
							var col = {
							field: 'initAmt',
							title: '期初金额',
							width: 100,
							align:'center',
							formatter:amtformatter,
							hidden:showHidden
											
							};
		    	    		cols.push(col);
		    	    
		    	    		var col = {
							field: 'avgPrice',
							title: '平均价格',
							width: 100,
							align:'center',
							formatter:amtformatter,
							hidden:showHidden
							
											
							};
		    	    		cols.push(col);
		    	    		$("#chkshowamt").attr("checked","checked");
		    	    		//alert(11);
		    	    		
						}
					
					if(${stkRight.qtyFlag} == 1)
					{
	    	    		var col = {
						field: 'inQty',
						title: '采购入库',
						width: 80,
						align:'center',
						formatter:function(v,row,index){
							if(v==""){
								v = "0.00";
							}
							if(v=="0E-7"){
								v =  "0.00";
							}
							if (row != null) {
								v =  numeral(v).format("0,0.00");
			                } 
							return  '<u style="color:blue;cursor:pointer">'+v+'</u>';
								 }
						
										
						};
	    	    		cols.push(col);
	    	    	
					}
				if(${stkRight.amtFlag} == 1)
				{
					var col = {
					field: 'inAmt',
					title: '采购金额',
					width: 100,
					align:'center',
					formatter:amtformatter,
					hidden:showHidden
					};
    	    		cols.push(col);
				}
				if(${stkRight.qtyFlag} == 1)
				{
	    	    	var col = {
						field: 'inQty1',
						title: '其它入库',
						width: 80,
						align:'center',
						formatter:function(v,row,index){
								if(v==""){
									v = "0.00";
								}
								if(v=="0E-7"){
									v =  "0.00";
								}
								if (row != null) {
									v =  numeral(v).format("0,0.00");
				                } 
								return  '<u style="color:blue;cursor:pointer">'+v+'</u>';
						 }
					};
	    	   		 cols.push(col);
				}
				if(${stkRight.amtFlag} == 1)
				{
					var col = {
					field: 'inAmt1',
					title: '其它入库金额',
					width: 100,
					align:'center',
					formatter:amtformatter,
					hidden:showHidden
					
									
					};
    	    		cols.push(col);
				}
				if(${stkRight.qtyFlag} == 1)
				{
	    	    	var col = {
						field: 'outQty11',
						title: '正常销售',
						width: 80,
						align:'center',
						formatter:function(v,row,index){
							if(v==""){
								v = "0.00";
							}
							if(v=="0E-7"){
								v =  "0.00";
							}
							if (row != null) {
								v =  numeral(v).format("0,0.00");
			                } 
							
							return  '<u style="color:blue;cursor:pointer">'+v+'</u>';
							 }
						
										
					};
	    	    	cols.push(col); 
				}
				
				if(${stkRight.amtFlag} == 1)
				{
					var col = {
					field: 'outAmt',
					title: '销售金额',
					width: 100,
					align:'center',
					formatter:amtformatter,
					hidden:showHidden
					
									
					};
    	    		cols.push(col);
				}
				if(${stkRight.qtyFlag} == 1)
				{
	    	    	var col = {
						field: 'outQty15',
						title: '其它出库',
						width: 80,
						align:'center',
						formatter:function(v,row,index){
							if(v==""){
								v = "0.00";
							}
							if(v=="0E-7"){
								v =  "0.00";
							}
							if (row != null) {
								v =  numeral(v).format("0,0.00");
			                } 
							
							return  '<u style="color:blue;cursor:pointer">'+v+'</u>';
							 }
						
										
					};
	    	    	cols.push(col);
				}
				if(${stkRight.amtFlag} == 1)
				{
					var col = {
					field: 'outAmt1',
					title: '其它出库金额',
					width: 100,
					align:'center',
					formatter:amtformatter,
					hidden:showHidden
					
									
					};
    	    		cols.push(col);
				}
	    	    var col = {
						field: 'endQty',
						title: '期末数量',
						width: 80,
						align:'center',
						formatter:amtformatter
						
										
				};
	    	    cols.push(col);

	    	   
					
				if(${stkRight.amtFlag} == 1)
					{
				var col = {
						field: 'endAmt',
						title: '期末金额',
						width: 100,
						align:'center',
						formatter:amtformatter,
						hidden:showHidden
						
										
				};
	    	    cols.push(col);

	    	    var col = {
						field: 'avgPrice1',
						title: '平均单价',
						width: 100,
						align:'center',
						formatter:amtformatter,
						hidden:showHidden
						
										
				};
	    	    cols.push(col);
					}
					
					
					$('#datagrid').datagrid({
	    	    		columns:[
	    	    		  		cols
	    	    		  	]}
	    	    );
	    	    $('#datagrid').datagrid('reload'); 
			   }
		    //查询物流公司
		    function toShowWare(waretype)
		    {
		    	$("#waretype").val(waretype);
		    	querydata();
		    }
		    function queryClick()
		    {
		    	$("#waretype").val(0);
		    	querydata();
		    }
			function querydata(){
		    	var wareNm = $("#wareNm").val();
		    	
		    	var sdate = $("#sdate").val();
		    	var edate = $("#edate").val();
		    	var stkId = $("#stkId").val();
		    	var waretype = $("#waretype").val();
		    	var hideZero = 0;
		    	if(document.getElementById("hideZero").checked)hideZero = 1;
				$("#datagrid").datagrid('load',{
					url:"manager/stkSummaryPage?wareNm1="+wareNm,
					wareNm:wareNm,
					stkId:stkId,
					startDate:sdate,
					endDate:edate,
					waretype:waretype,
					hideZero:hideZero
					
				});
			}
		    
			function queryBasestorage(){
		    	var path = "manager/queryBaseStorage";
		    	//var token = $("#tmptoken").val();
		    	
		    	
		    	$.ajax({
		            url: path,
		            type: "POST",
		            data : {"token11":""},
		            dataType: 'json',
		            async : false,
		            success: function (json) {
		            	if(json.state){
		            		
		            		var size = json.list.length;
		            		//gstklist = json.list;
		            		
		            		var objSelect = document.getElementById("stkId");
		            		//objSelect.options.add(new Option('合部','0'));
		            		
		            		for(var i = 0;i < size; i++)
		            			{
		            				objSelect.options.add( new Option(json.list[i].stkName,json.list[i].id));
		            				
		            			}
		    				
		            		
		            	}
		            }
		        });
		    }
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					querystorage();
				}
			}
			//导出
			function myexport(){
			     exportData('StkQueryService','queryStorageWarePage','com.cnlife.stk.model.StkStorageVo;',"{wareNm:'"+$("#wareNm").val()+"',stkId:'"+$("#stkId").val()+"',database:'"+database+"}","库存记录");
  			}
			
			function amtformatter(v,row)
			{
				if(v==""){
					return "";
				}
				if(v=="0E-7"){
					return "0.00";
				}
				if (row != null) {
                    return numeral(v).format("0,0.00");
                } 
			}
			function formatterSt(v,row){
				var hl='<table>';
				if(row.list.length>0){
			        hl +='<tr>';
			        hl +='<td width="120px;"><b>入库日期</b></td>';
			        if(${stkRight.priceFlag} == 1)
			        hl +='<td width="80px;"><b>价格</b></td>';
			        if(${stkRight.qtyFlag} == 1)
			        hl +='<td width="60px;"><b>数量</font></b></td>';
			       
			       
			        hl +='</tr>';
		        }
		        for(var i=0;i<row.list.length;i++){
		            hl +='<tr>';
			        hl +='<td>'+row.list[i].inTimeStr+'</td>';
			        if(${stkRight.priceFlag} == 1)
			        hl +='<td>'+row.list[i].inPrice+'</td>';
			        if(${stkRight.qtyFlag} == 1)
			        hl +='<td>'+row.list[i].qty+'</td>';
			        
			        hl +='</tr>';
		        }
		        hl +='</table>';
  			    return hl;
			}
			function todetail(title,id){
				window.parent.add(title,"manager/queryBforderDetailPage?orderId="+id);
			}
			function formatterSt2(val,row){
			  if(row.list.length>0){
			    if(val=='未审核'){
		            return "<input style='width:60px;height:27px' type='button' value='未审核' onclick='updateOrderSh(this, "+row.id+")'/>";
			     }else{
			        return val;   
			     }
			  }
		    } 
		    //修改审核
		    function updateOrderSh(_this,id){
		      $.messager.confirm('确认', '您确认要审核吗？', function(r) {
			  if (r) {
				$.ajax({
					url:"manager/updateOrderSh",
					type:"post",
					data:"id="+id+"&sh=审核",
					success:function(data){
						if(data=='1'){
						    alert("操作成功");
							queryorder();
						}else{
							alert("操作失败");
							return;
						}
					}
				});
			  }
			 });
			 }
			 //导出成excel
		    function toLoadExcel(){
		        $('#orderNo2').val($('#orderNo').val());
				$('#khNm2').val($('#khNm').val());
				$('#memberNm2').val($('#memberNm').val());   
				$('#sdate2').val($('#sdate').val()); 
				$('#edate2').val($('#edate').val());
				$('#orderZt2').val($('#orderZt').val());  
				$('#pszd2').val($('#pszd').val()); 
				$('#loadfrm').form('submit',{
					success:function(data){
						alert(data);
					}
				});
			}
			//删除
		    function toDel() {
				var ids = [];
				var rows = $("#datagrid").datagrid("getSelections");
				for ( var i = 0; i < rows.length; i++) {
					ids.push(rows[i].id);
					if(rows[i].orderZt=='审核'){
					   alert("该订单审核了，不能删除");
					   return;
					}
				}
				if (ids.length > 0) {
					$.messager.confirm('确认', '您确认想要删除记录吗？', function(r) {
						if (r) {
							$.ajax( {
								url : "manager/deleteOrder",
								data : "id=" + ids,
								type : "post",
								success : function(json) {
									if (json == 1) {
										showMsg("删除成功");
										$("#datagrid").datagrid("reload");
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
			//作废
		    function toZf() {
				var ids = [];
				var rows = $("#datagrid").datagrid("getSelections");
				for ( var i = 0; i < rows.length; i++) {
					ids.push(rows[i].id);
					if(rows[i].orderZt=='未审核'){
					   alert("该订单未审核，不能作废");
					   return;
					}
					if(rows[i].orderZt=='已作废'){
					   alert("该订单已作废，不能再作废");
					   return;
					}
				}
				if (ids.length > 0) {
					$.messager.confirm('确认', '您确认想要作废该记录吗？', function(r) {
						if (r) {
							$.ajax( {
								url : "manager/updateOrderZf",
								data : "id=" + ids,
								type : "post",
								success : function(json) {
									if (json == 1) {
										showMsg("作废成功");
										$("#datagrid").datagrid("reload");
									} else if (json == -1) {
										showMsg("作废失败");
									}
								}
							});
						}
					});
				} else {
					showMsg("请选择要作废的数据");
				}
			}
		    function queryBasestorage(){
		    	var path = "manager/queryBaseStorage";
		    	//var token = $("#tmptoken").val();
		    	//alert(token);
		    	
		    	$.ajax({
		            url: path,
		            type: "POST",
		            data : {"token11":""},
		            dataType: 'json',
		            async : false,
		            success: function (json) {
		            	if(json.state){
		            		
		            		var size = json.list.length;
		            		//gstklist = json.list;
		            		
		            		var objSelect = document.getElementById("stkId");
		            		objSelect.options.add(new Option(''),'');
		            		for(var i = 0;i < size; i++)
		            			{
		            				objSelect.options.add( new Option(json.list[i].stkName,json.list[i].id));
		            				
		            			}
		    				
		            		
		            	}
		            }
		        });
		    }
		    function onClickCell(index, field, value){
		    	var rows = $("#datagrid").datagrid("getRows");
		    	var row = rows[index];
		    	var sdate = $("#sdate").val();
		    	var edate = $("#edate").val();
		    	var stkId = $("#stkId").val();
		    	parent.closeWin('出入库明细');
		    	if(field == "inQty")
		    	{
		    		var billName = "采购入库";
		    		parent.add('出入库明细','manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
		    	}
		    	if(field == "outQty11")
		    	{
		    		var billName = "正常销售";
		    		
		    		parent.add('出入库明细','manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
		    	}
		    	if(field == "outQty12")
		    	{
		    		var billName = "促销折让";
		    		parent.add('出入库明细','manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
		    	}
		    	if(field == "outQty13")
		    	{
		    		var billName = "消费折让";
		    		parent.add('出入库明细','manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
		    	}
		    	if(field == "outQty14")
		    	{
		    		var billName = "费用折让";
		    		parent.add('出入库明细','manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
		    	}
		    	if(field == "outQty15")
		    	{
		    		var billName = "其它1";
		    		parent.add('出入库明细','manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
		    	}
		    	if(field == "inQty1")
		    	{
		    		var billName = "其它入库";
		    		parent.add('出入库明细','manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
		    	}
		    	if(field == "outQty1")
		    	{
		    		var billName = "其它1";
		    		parent.add('出入库明细','manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
		    	}
		    }
		    
		    function onDblClickRow(rowIndex, rowData)
		    {
				//parent.add('销售开票信息' + rowData.id,'manager/showstkout?dataTp=1&billId=' + rowData.id);
		    	//parent.add('付款记录' + rowData.id,'manager/queryPayPageByBillId?dataTp=1&billId=' + rowData.id);
		    	var sdate = $("#sdate").val();
		    	var edate = $("#edate").val();
		    	var stkId = $("#stkId").val();
		    	parent.closeWin('出入库明细');
		    	parent.add('出入库明细','manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + rowData.wareId + '&stkId=' + stkId + "&billName=全部");
				
		    }
		    function chooseWare()
		    {
		    	parent.add('选择商品','manager/stkChooseWare');
			}
		    
		    function submitRight(qtyFlag)
			{
				
				$.ajax( {
					url : "manager/saveOneStkRight",
					data : {"menuId":129,"qtyFlag":qtyFlag},
					type : "post",
					success : function(json) {
						if (json.state) {
							showMsg("保存成功");
							//$("#datagrid").datagrid("reload");
							location = 'manager/querystksummary';
						} else{
							showMsg("提交失败");
						}
					}
				});
				
			}
		    
		    function chooseRight(chk)
		    {
		    	if(chk.checked)submitRight(1);
		    	else submitRight(0);
		    }

		    function onLoadSuccess()
		    {
		    	
		    	
		    }
		</script>
	</body>
</html>
