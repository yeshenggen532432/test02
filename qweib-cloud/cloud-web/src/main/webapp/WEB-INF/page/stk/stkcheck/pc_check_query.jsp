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

	<body>
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
			 title="" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="false" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" data-options="onDblClickRow: onDblClickRow">
			
		</table>
		<div id="tb" style="padding:5px;height:auto">
		<div style="margin-bottom:5px">
		<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:newBill();">盘点开单</a>
		<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:checkinit();">初始化入库</a>
		</div>
		     单据号: <input name="orderNo" id="orderNo" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
			盘点日期: <input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         			-
	         		  <input name="edate" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
			单据状态: <select name="status" id="status">
					<option value="">全部</option>
					<option value="-2">暂存</option>
					<option value="0">已审批</option>
					<option value="2">已作废</option>
					</select>
			仓库: <select name="wareStk" id="stkId">
	                    <option value="0">全部</option>
	                    
	                </select>	    		  
	        	
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryorder();">查询</a>
			
		</div>
		<script type="text/javascript">
		    var database="${database}";
		    initGrid();
		    function initGrid()
		    {
		    	    var cols = new Array();
		    	    var col = {
							field: 'id',
							title: 'id',
							width: 50,
							align:'center',
							hidden:'true'
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: '_biztype',
							title: '类型',
							width: 140,
							align:'center',
							formatter:formatterSt
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'billNo',
							title: '单据号',
							width: 140,
							align:'center'
											
					};
		    	    cols.push(col);
		    	   
		    	    
		    	    var col = {
							field: 'checkTimeStr',
							title: '盘点日期',
							width: 100,
							align:'center'
											
					};
		    	    cols.push(col);
		    	    
		    	    var col = {
							field: 'stkName',
							title: '盘点仓库',
							width: 80,
							align:'center'
											
					};
		    	    cols.push(col);



				var col = {
							field: 'staff',
							title: '盘点人员',
							width: 80,
							align:'center'
											
					};
		    	    cols.push(col);
					var col = {
						field: 'status',
						title: '单据状态',
						width: 80,
						align:'center',
						formatter:formatterStatus

					};
					cols.push(col);

				var col = {
					field: '_oper',
					title: '操作',
					width: 140,
					align:'center',
					formatter:formatterOper

				};
				cols.push(col);
		    	    $('#datagrid').datagrid({
		    	    	url:"manager/stkCheckPage",
		    	    	queryParams:{
		    	    		jz:"1",
							billNo:$("#orderNo").val(),
							stkId:$("#stkId").val(),
							status:$("#status").val(),
							sdate:$("#sdate").val(),
							edate:$("#edate").val()
			    	    	},
		    	    		columns:[
		    	    		  		cols
		    	    		  	]}
		    	    );
		    	    $('#datagrid').datagrid('reload'); 
			}
			function queryorder(){
		    	
				$("#datagrid").datagrid('load',{
					url:"manager/stkCheckPage?database="+database,
					billNo:$("#orderNo").val(),
					stkId:$("#stkId").val(),
					status:$("#status").val(),
					sdate:$("#sdate").val(),
					edate:$("#edate").val()
				});
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
			        		var objSelect = document.getElementById("stkId");
			        		objSelect.options.add(new Option(''),'');
			        		for(var i = 0;i < size; i++)
			        		{
		        				objSelect.options.add( new Option(json.list[i].stkName,json.list[i].id));
		        				if(i == 0)
		    					{
	    							$("#stkId").val(json.list[i].id);
		    					}
			        		}
			        	}
			        }
			    });
			}
			
			function amtformatter(v,row)
			{
				if (row != null) {
                    return numeral(v).format("0,0.00");
                }
			}
			
			function newBill()
			{
				parent.closeWin('库存盘点开单');
				parent.add('库存盘点开单','manager/pcstkchecktype');
			}
			
			function checkinit()
			{
				parent.closeWin('初始化入库');
				parent.add('初始化入库','manager/pcstkcheckinittype');
			}
		    function formatterSt(v,row){
		    	if(row.billNo.indexOf("CSHRK")!=-1){
		    		return "初始化入库单";
		    	}else{
		    		return "盘点单";
		    	}
		    }
			function formatterStatus(v,row){
			 	if(v==-2){
			 		return "暂存";
				}else if(v==0){
			 		return "已审批";
				}else if(v==2){
					return "已作废";
				}
			}
			function formatterOper(v,row){
				var ret ="";
				if(row.status==-2||row.status==0){
					ret = "<input style='width:60px;height:27px' id='print" + row.id + "' type='button' value='作废' onclick='cancelBill(\"" + row.id + "\",\"" + row.billNo + "\")'/>";
				}
				if (row.status == -2) {
					ret += "<input style='width:60px;height:27px' type='button' value='审批' onclick='auditBill(\"" + row.id + "\",\"" + row.billNo + "\")'/>";
				}
				return ret;
			}

			function auditBill(billId, billNo) {
				$.messager.confirm('确认', '是否确定审核' + billNo + '?', function (r) {
					if (r) {
						var path = "manager/auditCheck";
						$.ajax({
							url: path,
							type: "POST",
							data: {"token": "", "billId": billId},
							dataType: 'json',
							async: false,
							success: function (json) {
								if (json.state) {
									alert(json.msg);
									queryorder();
								} else {
									$.messager.alert('消息', json.msg, 'info');
								}
							}
						});
					}
				});
			}

			function cancelBill(billId, billNo) {
				$.messager.confirm('确认', '是否确定作废' + billNo + '?', function (r) {
					if (r) {
						var path = "manager/cancelCheck";
						$.ajax({
							url: path,
							type: "POST",
							data: {"token": "", "billId": billId},
							dataType: 'json',
							async: false,
							success: function (json) {
								if (json.state) {
									alert(json.msg);
									queryorder();
								} else {
									$.messager.alert('消息', json.msg, 'info');
								}
							}
						});
					}
				});
			}


		    function onDblClickRow(rowIndex, rowData)
		    {
		    	if(rowData.billNo.indexOf("CSHRK")!=-1){
		    		parent.closeWin('初始化入库信息' + rowData.id);
			    	parent.add('初始化入库信息' + rowData.id,'manager/showStkcheckInit?billId=' + rowData.id);
		    	}else{
		    	parent.closeWin('盘点开票信息' + rowData.id);
		    	parent.add('盘点开票信息' + rowData.id,'manager/showStkcheck?billId=' + rowData.id);
		    	}
		    }
		    querystorage();
		</script>
	</body>
</html>
