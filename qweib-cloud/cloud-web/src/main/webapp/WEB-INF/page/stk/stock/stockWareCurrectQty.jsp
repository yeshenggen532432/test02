<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>库存纠错</title>
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
		<table id="datagrid"  fit="true" singleSelect="true"
			 iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="false" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb"
			>
		</table>
		<div id="tb" style="padding:5px;height:auto">
		     商品名称: <input name="wareNm" id="wareNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
			 仓库:<tag:select name="stkId" id="stkId" tableName="stk_storage" onchange="reCorrectQty()" displayKey="id" displayValue="stk_name"/>
<br/>
			小单位大于<input name="maxEnd" id="maxEnd" size="7" value="${config.maxEnd}"/>归(<font color="red">1</font>)处理 &nbsp;&nbsp;
			小于<input name="minEnd"  id="minEnd"  size="7" value="${config.minEnd}"/>归(<font color="red">0</font>)处理
			<a class="easyui-linkbutton" iconCls="icon-redo" plain="true" href="javascript:reCorrectQty();">重新计算</a>
			<a class="easyui-linkbutton" iconCls="icon-redo" plain="true" href="javascript:confirmCorrectQty();">确定纠偏</a>

		</div>
		<script type="text/javascript">
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
					   field: 'hsNum',
					   title: 'hsNum',
					   width: 100,
					   align:'center',
					   hidden:true
				   };
				   cols.push(col);
				   var col = {
							field: 'stkName',
							title: '仓库名称',
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
							field: 'minUnitName',
							title: '小单位',
							width: 80,
							align:'center'
							
											
					};
		    	    cols.push(col);
					
		    	    var col = {
							field: 'qty',
							title: '纠偏前数量',
							width: 80,
							align:'center',
							formatter:amtformatter
					};
		    	    cols.push(col);

				   var col = {
					   field: 'qtyEnd',
					   title: '纠偏后数量',
					   width: 80,
					   align:'center',
					   formatter:amtformatter
				   };
				   cols.push(col);

				   var col = {
					   field: 'disQty',
					   title: '纠偏差量',
					   width: 80,
					   align:'center',
					   formatter:amtformatter
				   };
				   cols.push(col);

				   $('#datagrid').datagrid({
						url:"manager/stockWareCurrectQty",
						queryParams:{
							wareNm:$("#wareNm").val(),
							stkId:$("#stkId").val(),
							maxEnd:$("#maxEnd").val(),
							minEnd:$("#minEnd").val()
			    	    	},
	    	    		columns:[
	    	    		  		cols
	    	    		  	]}
	    	    );
			   }
			function reCorrectQty(){
				var maxEnd=$("#maxEnd").val();
				var	minEnd=$("#minEnd").val();
				if(parseFloat(maxEnd)>=1||parseFloat(minEnd)>=1){
					alert("纠偏参数值必须小于1");
					return;
				}
				$("#datagrid").datagrid('load',{
					url:"manager/stockWareCurrectQty",
					wareNm:$("#wareNm").val(),
					stkId:$("#stkId").val(),
					id:'${config.id}',
					maxEnd:$("#maxEnd").val(),
					minEnd:$("#minEnd").val()
				});
			}

			   function confirmCorrectQty(){
				   var maxEnd=$("#maxEnd").val();
				   var	minEnd=$("#minEnd").val();
				   if(parseFloat(maxEnd)>=1||parseFloat(minEnd)>=1){
					   alert("纠偏参数值必须小于1");
					   return;
				   }
				   if(!window.confirm("是否确定库存纠偏")){
					   return;
				   }
				   $.ajax({
					   url:"manager/stockWareCurrectConfirmQty",
					   type: "POST",
					   data : {"wareNm":$("#wareNm").val(),"stkId":$("#stkId").val(),"maxEnd":maxEnd,"minEnd":minEnd},
					   dataType: 'json',
					   async : false,
					   success: function (json) {
						   if(json.state){
						   	   alert(json.msg);
							   reCorrectQty();
						   }
					   }
				   });

			   }

			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					reCorrectQty();
				}
			}

			function formatterQty(v,row) {
			   	if(row.stkName=="合计："){
					return "";
				}
				var hsNum=row.hsNum;
				if(parseFloat(hsNum)>1){
					var str = row.sumQty+"";
					if(str.indexOf(".")!=-1){
						var nums = str.split(".");
						var num1 = nums[0];
						var num2 = nums[1];
						if(parseFloat(num2)>0){
							var minQty = parseFloat(0+"."+num2)*parseFloat(hsNum);
							minQty = minQty.toFixed(2);
							return num1+""+row.unitName+""+minQty+""+row.minUnitName;
						}
					}
				}
				return row.sumQty+row.unitName;

			}

			function amtformatter(v,row)
			{
				if(v=="0"){
					return "0";
				}
				if(v=="0E-7"){
					return "0.00";
				}
				if (row != null) {
                    return parseFloat(v);
                }
			}

		</script>
	</body>
</html>
