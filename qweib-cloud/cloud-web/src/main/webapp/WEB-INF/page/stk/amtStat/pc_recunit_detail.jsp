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
	</head>

	<body onload="initGrid()">
	<input type="hidden" id="ioType" value="${ioType}"/>
			<input type="hidden" id="amtType" value="${amtType}"/>
			<input type="hidden" id="unitId" value="${unitId}"/>
			<input type="hidden" id="sdate" value="${sdate}"/>
			<input type="hidden" id="edate" value="${edate}"/>
	<input type = "hidden" id="billId" value="0"/>
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
			title="收款单查询" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="true" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" showFooter="true" data-options="onDblClickRow: onDblClickRow">
			
		</table>
		<div id="tb" style="padding:5px;height:auto">
		 
		</div>
		<script type="text/javascript">
		   //查询
		   initGrid();
			   function initGrid()
			   {
				   var cols = new Array(); 
				   var col = {
							field: 'id',
							title: 'id',
							width: 100,
							align:'center',
							hidden:true
							
							
											
					};
		    	    cols.push(col);
		    	    
		    	    var col = {
							field: 'billId',
							title: 'id',
							width: 100,
							align:'center',
							hidden:true
							
							
											
					};
		    	    cols.push(col);
				  
		    	    var col = {
							field: 'khNm',
							title: '客户名称',
							width: 100,
							align:'center'
							
											
					};
		    	    cols.push(col);
		    	    
		    	    var col = {
							field: 'recTimeStr',
							title: '收款日期',
							width: 100,
							align:'center'
							
											
					};
				   cols.push(col);

		    	    var col = {
							field: 'memberNm',
							title: '付款人',
							width: 100,
							align:'center'
							
											
					};
		    	    cols.push(col);

		    	   
					
					if(${stkRight.amtFlag} == 1)
						{
						
						var col = {
								field: 'sumAmt',
								title: '总收款/核销金额',
								width: 100,
								align:'center'
								
												
						};
			    	    cols.push(col);
					var col = {
							field: 'cash',
							title: '现金',
							width: 100,
							align:'center'
							
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'bank',
							title: '银行转账',
							width: 100,
							align:'center'
							
											
					};
		    	    cols.push(col);

		    	    var col = {
							field: 'wx',
							title: '微信',
							width: 100,
							align:'center'
							
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'zfb',
							title: '支付宝',
							width: 100,
							align:'center'
							
											
					};
		    	    cols.push(col);
						}
					
		    	    var col = {
							field: 'billTypeStr',
							title: '类型',
							width: 100,
							align:'center'
							
							
											
					};
		    	    cols.push(col);
		    	    
		    	    var col = {
							field: 'billStatus',
							title: '状态',
							width: 80,
							align:'center'
							
							
											
					};
		    	    cols.push(col);
		    	    var ioType = $("#ioType").val();
					$('#datagrid').datagrid({
						url:"manager/queryRecDetailPage",
		    	    	queryParams:{							
		    	    		sdate:$("#sdate").val(),
							edate:$("#edate").val(),
							ioType:ioType,
							amtType:$("#amtType").val(),
							cstId:$("#unitId").val()
			    	    	},
	    	    		columns:[
	    	    		  		cols
	    	    		  	]}
	    	    );
	    	    $('#datagrid').datagrid('reload'); 
			   }
			function queryrecdetail(){
				$("#datagrid").datagrid('load',{
					url:"manager/queryRecDetailPage",
					sdate:$("#sdate").val(),
					edate:$("#edate").val(),
					ioType:$("#ioType").val(),
					amtType:$("#amtType").val(),
					cstId:$("#unitId").val()
				});
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					queryrecdetail();
				}
			}
			
			
			
			function cancelPay()
			{
				var ids = [];
				var rows = $("#datagrid").datagrid("getSelections");
				for ( var i = 0; i < rows.length; i++) {
					ids.push(rows[i].id);
					if(rows[i].billStatus=='作废'){
					   alert("该单已经作废");
					   return;
					}
				}
				if (ids.length > 0) {
					$.messager.confirm('确认', '是否确认作废收款单？', function(r) {
						if (r) {
							$.ajax( {
								url : "manager/cancelRec",
								data : "id=" + ids[0],
								type : "post",
								success : function(json) {
									if (json.state) {
										showMsg("作废成功");
										$("#datagrid").datagrid("reload");
									} else{
										showMsg("作废失败:" + json.msg);
									}
								}
							});
						}
					});
				} else {
					showMsg("请选择要删除的数据");
				}
			}
			
			function onDblClickRow(rowIndex, rowData)
		    {
				parent.closeWin('销售开票信息' + rowData.billId);
		    	parent.add('销售开票信息' + rowData.billId,'manager/showstkout?dataTp=1&billId=' + rowData.billId);
					
		    }
		</script>
	</body>
</html>
