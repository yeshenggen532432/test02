<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>驰用T3</title>

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
			url="manager/stkInSubPage2?dataTp=${dataTp }&sdate=${sdate}&edate=${edate}&stkId=${stkId}&wareId=${wareId}&proName=${proName}&memberNm=${memberNm}&inType=${inType}&proId=${proId}" title="产品入库统计表" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="true" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" showFooter="true"
			data-options="onDblClickRow: onDblClickRow">
			
		</table>
		<input type= "hidden" id = "wareId" value="${wareId}"/>
		 <input type= "hidden" id = "sdate" value="${sdate}"/>
		 <input type= "hidden" id = "edate" value="${edate}"/>
		 <input type= "hidden" id = "stkId" value="${stkId}"/>
		 <input type= "hidden" id = "proId" value="${proId}"/>
		 <input type= "hidden" id = "memberNm" value="${memberNm}"/>
		<div id="tb" style="padding:5px;height:auto">
		<!--     时间: <input name="stime" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
	         	   <img onclick="WdatePicker({el:'stime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         	   -
	         	<input name="etime" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
	         	   <img onclick="WdatePicker({el:'etime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	        入库类型:<select name="inType" id="inType">
	                  <option value="">全部</option>
	                  
	               </select>
	        入库仓库:<select name="stkid" id="stkId">
	                  <option value="0">全部</option>
	                  
	            </select>        
	        供应商名称: <input name="proName" id="proName" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
		   业务员名称: <input name="memberNm" id="memberNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>   
	               <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryindetail();">查询</a>-->
		</div>
		<script type="text/javascript">
		   //查询
		   //queryDict();
		   //querystorage();
		   initGrid();
		   function initGrid()
		   {
			   var cols = new Array(); 
			   
			   var col = {
						field: 'mastId',
						title: 'mastid',
						width: 100,
						align:'center',
						hidden:true
						
										
				};
	    	    cols.push(col);
			   
			   var col = {
						field: 'proName',
						title: '往来单位',
						width: 100,
						align:'center'
						
										
				};
	    	    cols.push(col);
	    	    
	    	    var col = {
						field: 'billNo',
						title: '单号',
						width: 100,
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
						field: 'unitName',
						title: '单位',
						width: 80,
						align:'center'
						
										
				};
	    	    cols.push(col);
				if(${stkRight.qtyFlag} == 1)
					{
	    	   

	    	    var col = {
						field: 'inQty',
						title: '收货数量',
						width: 80,
						align:'center',
						formatter:amtformatter
						
										
				};
	    	    cols.push(col);
					}
				if(${stkRight.priceFlag} == 1)
					{
				var col = {
						field: 'price',
						title: '单价',
						width: 80,
						align:'center'
						
										
				};
	    	    cols.push(col);
					}
				if(${stkRight.amtFlag} == 1)
					{
	    	    var col = {
						field: 'amt',
						title: '收货金额',
						width: 80,
						align:'center',
						formatter:amtformatter
						
										
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
			function queryindetail(){
				$("#datagrid").datagrid('load',{
					url:"manager/stkInSubPage2",
					sdate:$("#sdate").val(),
					edate:$("#edate").val(),
					inType:$("#inType").val(),
					stkId:$("#stkId").val(),					
					memberNm:$("#memberNm").val()
				});
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					querycpddtj();
				}
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
			
			function queryDict(){
				var path = "manager/querystkdict";
				var token = $("#tmptoken").val();
				//alert(token);
				$.ajax({
			        url: path,
			        type: "POST",
			        data : {"token":token,"ioType":0},
			        dataType: 'json',
			        async : false,
			        success: function (json) {
			        	if(json.state){
			        		
			        		var size = json.rows.length;
			        		
			        		
			        		var objSelect = document.getElementById("inType");
			        		objSelect.options.add(new Option(''),'');
			        		for(var i = 0;i < size; i++)
			        			{
			        				
			        				objSelect.options.add( new Option(json.rows[i].typeName,json.rows[i].typeName));
			        				
			        			}
							
			        		
			        	}
			        }
			    });
			}
			
			function querystorage(){
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
			        		gstklist = json.list;
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
			
			function onDblClickRow(rowIndex, rowData)
		    {
		    //alert(rowData.inQty);
				//if(rowData.inQty == 0)
		    	//parent.add('销售开票信息' + rowData.billId,'manager/showstkout?dataTp=1&billId=' + rowData.billId);
				//else
					parent.closeWin('采购开单信息' + rowData.mastId);
					parent.add('采购开单信息' + rowData.mastId,'manager/showstkin?dataTp=1&billId=' + rowData.mastId);
		    }
		</script>
	</body>
</html>
