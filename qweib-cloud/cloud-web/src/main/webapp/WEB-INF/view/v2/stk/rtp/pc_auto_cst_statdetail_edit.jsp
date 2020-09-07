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

	<body onload="initGrid()">
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
			 title="" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="true" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" showFooter="true" >
			
		</table>
		<div id="tb" style="padding:5px;height:auto">
		   时间: <input name="stime" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
	            <img onclick="WdatePicker({el:'stime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         	   -
	         	<input name="etime" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
	         	<img onclick="WdatePicker({el:'etime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	        销售类型:<select name="xsTp" id="xsTp">
	                  <option value="">全部</option>
	                  <option value="正常销售">正常销售</option>
					  <option value="促销折让">促销折让</option>
					  <option value="消费折让">消费折让</option>
					  <option value="费用折让">费用折让</option>
					  <option value="其他销售">其他销售</option>
					  <option value="其它出库">其它出库</option>
	               </select>
	   		客户类型: <select name="customerType" id="customerType" style="width: 100px;"></select>
	        客户名称: <input name="khNm" id="khNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
		    所属二批: <input name="epCustomerName" id="epCustomerName" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
			<input name="wtype" type="hidden" id="wtype" value="${wtype}"/>
	               <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:querycpddtj();">查询</a>
		</div>
		<script type="text/javascript">
		 var autoTitleDatas = eval('${autoTitleJson}');
		 var autoPriceDatas = eval('${autoPriceJson}');
		   //查询
		   //initGrid();
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
						field: 'sumQty',
						title: '销售数量',
						width: 80,
						align:'center',
						formatter:amtformatter,
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
						width: 80,
						align:'center',
						formatter:amtformatter
						
										
				};
	    	    cols.push(col);
	    	    

	    	    if(autoTitleDatas.length>0){
	    	    	for(var i=0;i<autoTitleDatas.length;i++){
	    	    		var json = autoTitleDatas[i];
	    	    		  var col = {
	  							field: 'auto'+json.name,
	  							title: ''+json.name,
	  							width: 70,
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
				
				$('#datagrid').datagrid({
					url:"manager/queryAutoCstStatDetailPage",
					queryParams:{
						sdate:$("#sdate").val(),
						edate:$("#edate").val(),
						outType:$("#xsTp").val(),
						stkUnit:$("#khNm").val(),
						epCustomerName:$("#epCustomerName").val(),
						customerType:$("#customerType").val(),
						wtype:$("#wtype").val()
						},
    	    		columns:[
    	    		  		cols
    	    		  	]}
    	    );
    	   // $('#datagrid').datagrid('reload'); 
		   }
			
		   function querycpddtj(){
				$("#datagrid").datagrid('load',{
					url:"manager/queryAutoCstStatDetailPage",
					sdate:$("#sdate").val(),
					edate:$("#edate").val(),
					outType:$("#xsTp").val(),
					stkUnit:$("#khNm").val(),
					epCustomerName:$("#epCustomerName").val(),
					customerType:$("#customerType").val(),
					wtype:$("#wtype").val()
				});
			}
			
			
			function amtformatterunitml(v,row)
			{
				if(v == null)return "";
				if (row != null) {
                    return numeral(v).format("0,0.00");
                }
			}
			
			function amtformatter(v,row)
			{
				if(v == null)return "";
				if(v=="0E-7"){
					return "0.00";
				}
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
			//回车查询
			function formatAutoAmt(val,row,index){
			    	var price = "";
			    	var beQty = row.sumQty;
			    	var html ="<input name='autoPrice"+index+"' value='"+price+"' type='hidden'/><span id='autoPrice"+index+"'>"+price+"</span>";
			    	if(autoPriceDatas.length>0){
			    		for(var i=0;i<autoPriceDatas.length;i++){
			    			var json = autoPriceDatas[i];
			    			if(json.wareId==row.wareId&&json.autoId==this.value){
			    				price = json.price;
			    				var sumAmt = "";
			    				if(price!=""){
			    					sumAmt = beQty*parseFloat(price);
			    				}
			    				html ="<input name='autoPrice"+index+"' value='"+sumAmt.toFixed(2)+"' type='hidden'/><span id='autoPrice"+index+"'>"+sumAmt.toFixed(2)+"</span>";
			    				break;
			    			}
			    		}
			    	}
			    	return html;
			    }
			
			
		</script>
	</body>
</html>
