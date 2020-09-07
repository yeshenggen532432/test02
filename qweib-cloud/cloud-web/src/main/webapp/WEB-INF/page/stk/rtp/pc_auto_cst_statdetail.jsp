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

	<body onload="initGrid()">
		<table id="datagrid" fit="true" singleSelect="true"
			 title="" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="false" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" showFooter="true" >
			
		</table>
		<div id="tb" style="padding:5px;height:auto">
		 时间类型:<select name="timeType" id="timeType">
			 		 <option value="2">发票时间</option>
	                 <option value="1">发货时间</option>
	           	   </select>  
		   时间: <input name="stime" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
	         	   <img onclick="WdatePicker({el:'stime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         	   -
	         	<input name="etime" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
	         	   <img onclick="WdatePicker({el:'etime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
			出库类型:<tag:outtype id="outType" name="outType" style="width:100px" onchange="changeOutType()"></tag:outtype>
			销售类型:<tag:saleType id="xsTp" name="xsTp"></tag:saleType>
	        <%--销售类型:<select name="xsTp" id="xsTp" >--%>
	                  <%--<option value="">全部</option>--%>
	                  <%--<option value="正常销售">正常销售</option>--%>
					  <%--<option value="促销折让">促销折让</option>--%>
					  <%--<option value="消费折让">消费折让</option>--%>
					  <%--<option value="费用折让">费用折让</option>--%>
					  <%--<option value="其他销售">其他销售</option>--%>
					   <%--<option value="其它出库">其它出库</option>--%>
	               <%--</select>--%>
	        客户类型: <select name="customerType" id="customerType" style="width: 100px;"></select>
			客户所属区域:
			<select id="regioncomb" class="easyui-combotree" style="width:200px;"
					data-options="url:'manager/sysRegions',animate:true,dnd:true,onClick: function(node){
							setRegion(node.id);
							}"></select>
			<input type="hidden" name="regionId" id="regionId" />

	        客户名称: <input name="khNm" id="khNm" style="width:120px;height: 20px;" value="${stkUnit}" />
	        所属二批: <input name="epCustomerName" id="epCustomerName" style="width:120px;height: 20px;" value="${epCustomerName }" />
			<input name="wtype" type="hidden" id="wtype" value="${wtype}"/>
	               <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryData();">查询</a>
	               <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:editRptData();">编辑</a>
	               <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:createRptData();">生成报表</a>
	               <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryRpt();">查询生成的报表</a>
	               
		</div>
			<div id="dlg" closed="true" class="easyui-dialog" title="生成报表" style="width:350px;height:150px;padding:10px"
			data-options="
				iconCls: 'icon-save',
				
				buttons: [{
					text:'确定',
					iconCls:'icon-ok',
					handler:function(){
						createRptData();
					}
				},{
					text:'取消',
					handler:function(){
						$('#dlg').dialog('close');
					}
				}]
			">
		报表名称: <input name="rptTitle" id="rptTitle" style="width:250px;height: 20px;"/>
	</div>
		<script type="text/javascript">
		 var autoTitleDatas = eval('${autoTitleJson}');
		 var autoPriceDatas = eval('${autoPriceJson}');
		 var sacpJsonDatas  = eval('${sacpJson}')
		   //查询
		   //
		   function initGrid()
		   {
			   var cols = new Array(); 
			   /*var col = {
						field: 'unitId',
						title: 'unitId',
						width: 100,
						align:'center',
						hidden:true
						
						
										
				};
	    	    cols.push(col);*/
			   
	    	   var col = {
						field: 'stkUnit',
						title: '客户名称',
						width: 140,
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
						field: 'sumQty',
						title: '销售数量',
						width: 100,
						align:'center',
						formatter:amtformatter
				};
	    	    cols.push(col);

	    	    var col = {
						field: 'sumAmt',
						title: '销售收入',
						width: 80,
						align:'center',
						formatter:amtformatter
				};
	    	    cols.push(col);
	    	    
	    	    var col = {
						field: 'avgPrice',
						title: '平均单位售价',
						width: 100,
						align:'center',
						formatter:amtformatter
						
										
				};
	    	    cols.push(col);
	    	    
	    	    
	    	    
	    	    var col = {
						field: 'sumCost',
						title: '销售成本',
						width: 100,
						align:'center',
						formatter:amtformatter
						
										
				};
	    	    cols.push(col);
	    	    
	    	    <%--
	    	    var col = {
						field: 'sumFree',
						title: '其它促销赠送',
						width: 100,
						align:'center',
						formatter:amtformatter
						
										
				};
	    	    cols.push(col);--%>
				
	    	    if(autoTitleDatas.length>0){
	    	    	for(var i=0;i<autoTitleDatas.length;i++){
	    	    		var json = autoTitleDatas[i];
	    	    		  var col = {
	  							field: 'auto'+json.name,
	  							title: ''+json.name,
	  							width: 100,
	  							align:'center',
	  							formatter:formatAutoAmt,
	  							value:json.id
	  					};
	  		    	    cols.push(col);
	    	    	}
				}
	    	    var col = {
						field: 'disAmt',
						title: '销售毛利',
						width: 100,
						align:'center',
						formatter:amtformattersumml
						
										
				};
	    	    cols.push(col);
	    	    
	    	    var col = {
						field: 'avgAmt',
						title: '平均单位毛利',
						width: 100,
						align:'center',
						formatter:amtformatterunitml
				};
	    	    cols.push(col);
	    	    
	    	    var col = {
						field: 'epCustomerName',
						title: '所属二批',
						width: 100,
						align:'center'
						
										
				};
	    	    cols.push(col);
				
				$('#datagrid').datagrid({
					url:"manager/queryAutoCstStatDetailPage",
					queryParams:{
						sdate:$("#sdate").val(),
						edate:$("#edate").val(),
						outType:$("#xsTp").val(),
						stkUnit:$("#khNm").val(),
						epCustomerName:$("#epCustomerName").val(),
						customerType:'${customerType}',
						timeType:'${timeType}',
						wtype:'${wtype}',
						regionId:$("#regionId").val()
						},
    	    		columns:[
    	    		  		cols
    	    		  	]}
    	    );
		   }
		
		   function queryData(){
			   var xsTp = $('#xsTp').combobox('getValues')+"";
			   $('#datagrid').datagrid({
					url:"manager/queryAutoCstStatDetailPage",
					queryParams:{
						sdate:$("#sdate").val(),
						edate:$("#edate").val(),
						xsTp:xsTp,
						outType:$("#outType").val(),
						stkUnit:$("#khNm").val(),
						epCustomerName:$("#epCustomerName").val(),
						customerType:$("#customerType").val(),
						timeType:$("#timeType").val(),
						wtype:'${wtype}',
						regionId:$("#regionId").val()
						}});
		   }
		 
		 
		   function amtformatter(v,row)
			{
			   if(v == null)return "";
				if(v=="0E-7"){
					return "0.00";
				}
				if (row != null) {
                   return numeral(v).format("0,0.00");
               } 
			}
			
			function amtformatterunitml(v,row)
			{
				if(v == null)return "";
				if(v=="0E-7"){
					return "0.00";
				}
				if (row != null) {
                    return numeral(v).format("0,0.00");
                }
			}
			
			function amtformattersumml(v,row,index)
			{
				if(v == null)return "";
				if(v=="0E-7"){
					return "0.00";
				}
				if (row != null) {
                    return numeral(v).format("0,0.00");
                }
			}
			function formatAutoAmt(val,row,index){
			    	var price = "";
			    	var beQty = row.sumQty;
			    	var html ="<input name='autoPrice"+index+"' value='"+price+"' type='hidden'/><span id='autoPrice"+index+"'>"+price+"</span>";
			    	
			    	if(sacpJsonDatas.length>0){
			    		for(var i=0;i<sacpJsonDatas.length;i++){
			    			var json = sacpJsonDatas[i];
			    			if(json.wareId==row.wareId&&json.autoId==this.value&&json.customerId==row.stkUnitId){
			    				price = json.price;
			    				var sumAmt = 0;
			    				if(price!=""){
			    					sumAmt = beQty*parseFloat(price);
			    				}
			    				html ="<input name='autoPrice"+index+"' value='"+sumAmt.toFixed(2)+"' type='hidden'/><span id='autoPrice"+index+"'>"+sumAmt.toFixed(2)+"</span>";
			    				return html;
			    			}
			    		}
			    	}
			    	if(autoPriceDatas.length>0){
			    		for(var i=0;i<autoPriceDatas.length;i++){
			    			var json = autoPriceDatas[i];
			    			if(json.wareId==row.wareId&&json.autoId==this.value){
			    				price = json.price;
			    				var sumAmt = 0;
			    				if(price!=""){
			    					sumAmt = beQty*parseFloat(price);
			    				}
			    				html ="<input name='autoPrice"+index+"' value='"+sumAmt.toFixed(2)+"' type='hidden'/><span id='autoPrice"+index+"'>"+sumAmt.toFixed(2)+"</span>";
			    				break;
			    			}
			    		}
			    	}
				  if(row.stkUnit=="合计:"){
					  var map = row.autoMap
				    	for(var key in map){
				    		  if(key==this.value){
				    			  html = map[key];
				    			  html = formatterMny(html);
				    		  }
				    	}
			    	}
			    	return html;
			    }
			
			
			function createRptData(){
				
				var sdate = $("#sdate").val();
		    	var edate = $("#edate").val();
		    	var outType = $("#xsTp").val();
		    	var stkUnit = $("#khNm").val();
		    	var epCustomerName = $("#epCustomerName").val();
		    	var customerType = $("#customerType").val();
		    	var rptTitle=$("#rptTitle").val();
		    	var timeType=$("#timeType").val();
		    	var wtype =$("#wtype").val();
				var	regionId=$("#regionId").val();
				//var path = "manager/createAutoCstStatListRpt";
				parent.closeWin('客户毛利费用统计表生成');
		    	parent.add('客户毛利费用统计表生成','manager/createAutoCstStatListRpt?sdate=' + sdate + '&regionId='+regionId+'&wtype='+wtype+'&timeType='+timeType+'&edate=' + edate +'&outType='+outType+'&stkUnit=' + stkUnit+'&customerType='+customerType+'&epCustomerName='+epCustomerName+"&rptTitle:"+rptTitle);
				
				/*
		    	 $.ajax({
		    	        url: path,
		    	        type: "POST",
		    	        data : {"sdate":sdate,"edate":edate,"outType":outType,"stkUnit":stkUnit,"epCustomerName":epCustomerName,"customerType":customerType,"rptTitle":rptTitle},
		    	        dataType: 'json',
		    	        async : false,
		    	        success: function (json) {
		    	        	var  data = eval(json)
		    	        	if(parseInt(data)>0){
		    	        		alert("生成报表成功!");
		    	        		$('#dlg').dialog('close');
		    	        		$("#rptTitle").val("");
		    	        	}
		    	        	else
		    	        	{
		    	        		alert("生成报表失败！");
		    	        	}
		    	        }
		    	    });*/
			   }
			 function formatterMny(v)
				{
					if (v != null) {
	                   return numeral(v).format("0,0.00");
	               }else{
	            	   return v;
	               }
				}
			function toCreateRpt()
			{
				var sdate = $("#sdate").val();
		    	var edate = $("#edate").val();
		    	$("#rptTitle").val(sdate+"-"+edate+"客户费用明细统计表");
				$('#dlg').dialog('open');
			}
			function editRptData()
		    {
				var sdate = $("#sdate").val();
		    	var edate = $("#edate").val();
		    	var outType = $("#xsTp").val();
		    	var stkUnit = $("#khNm").val();
		    	var epCustomerName = $("#epCustomerName").val();
		    	var customerType = $("#customerType").val();
		    	var timeType=$("#timeType").val();
				var wtype =$("#wtype").val();
				var regionId = $("#regionId").val();
		    	parent.closeWin('编辑客户毛利明细统计表');
		    	parent.add('编辑客户毛利明细统计表','manager/queryAutoCstStatDetailListToSave?sdate=' + sdate + '&regionId='+regionId+'&wtype='+wtype+'&edate=' + edate +'&timeType='+timeType+'&outType='+outType+'&stkUnit=' + stkUnit+'&customerType='+customerType+'&epCustomerName='+epCustomerName);
		    }
			function queryRpt()
		    {
		    	parent.closeWin('生成的统计表');
		    	parent.add('生成的统计表','manager/querySaveRptDataStat?rptType=3');
		    }
		 function setWareType(id,name) {
			 $("#wtype").val(id);
			 $("#wtypeName").val(name);
		 }
		 function setRegion(regionId){
			 $("#regionId").val(regionId);
		 }

		 function changeOutType(){
			 var v = $("#outType").val();
			 $('#xsTp').combobox('loadData',{});
			 $('#xsTp').combobox('setValue', '');
			 if(v=="销售出库"){
				 $('#xsTp').combobox('loadData',outData);
			 }else if(v=="其它出库"){
				 $('#xsTp').combobox('loadData',otherData);
			 }
		 }
		 $(function(){
			 $("#xsTp").combobox('loadData', outData);
		 })

			 function loadCustomerType(){
					$.ajax({
						url:"manager/queryarealist1",
						type:"post",
						success:function(data){
							if(data){
							   var list = data.list1;
							    var img="";
							     img +='<option value="">--请选择--</option>';
							    for(var i=0;i<list.length;i++){
							    	
							      if(list[i].qdtpNm=='${customerType}'){
							    	  img +='<option value="'+list[i].qdtpNm+'" selected="selected">'+list[i].qdtpNm+'</option>';
							      }	else
							      if(list[i].qdtpNm!=''){
							           img +='<option value="'+list[i].qdtpNm+'">'+list[i].qdtpNm+'</option>';
							       }
							    }
							   $("#customerType").html(img);
							 }
						}
					});
				}
		 loadCustomerType();
		 $("#customerType").val('${customerType}');
		 $("#xsTp").val('${outType}');
		 $("#timeType").val('${timeType}');
		 initGrid();
		</script>
	</body>
</html>
