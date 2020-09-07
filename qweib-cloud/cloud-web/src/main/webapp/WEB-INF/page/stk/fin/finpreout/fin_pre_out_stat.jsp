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
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" data-options="onClickCell: onClickCell">
		</table>
		<div id="tb" style="padding:5px;height:auto">		     
			付款日期: <input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         			-
	         		  <input name="edate" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:querydata(0);">查询</a>
		</div>
		<script type="text/javascript">
		    var database="${database}";
		    initGrid();
		   //queryorder();
		   var queryType = 0;
		    function initGrid()
		    {
		    	    var cols = new Array(); 
		    	    var col = {
							field: 'itemName1',
							title: ' ',
							width: 135,
							align:'center'
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'amt1',
							title: ' ',
							width: 120,
							align:'center',
							formatter:function(value,row,index){
								return  '<u style="color:blue;cursor:pointer">'+numeral(value).format("0,0.00")+'</u>';
							 }
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'itemName2',
							title: ' ',
							width: 80,
							align:'center'
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'amt2',
							title: ' ',
							width: 100,
							align:'center',
							formatter:amtformatter
					};
		    	    cols.push(col);		    	    
		    	    $('#datagrid').datagrid({
		    	    	url:"manager/queryFinPreOutStat",
		    	    	queryParams:{							
							sdate:$("#sdate").val(),
							edate:$("#edate").val()
			    	    	},
		    	    		columns:[
		    	    		  		cols
		    	    		  	]}
		    	    );
			}
			function querydata(type){
		    	queryType = type;
		    	if(type == 0)
			    	{
				$("#datagrid").datagrid('load',{
					url:"manager/queryFinPreOutStat",					
					sdate:$("#sdate").val(),
					edate:$("#edate").val()
				});
			    	}
		    	else
			    	{
		    		$("#datagrid").datagrid('load',{
						url:"manager/queryFinPreOutStat",					
						sdate:"",
						edate:""
					});
			    	}
			}
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					querydata();
				}
			}
			function amtformatter(v,row,index)
			{
				if (row != null) {
					
						if(index == 0)
							{
							return '<u style="color:blue;cursor:pointer">'+numeral(v).format("0,0.00")+'</u>';
							}
                }
			}
		    function onClickCell(index, field, value){
		    	var rows = $("#datagrid").datagrid("getRows");
		    	var row = rows[index];
		    	var sdate = $("#sdate").val();
		    	var edate = $("#edate").val();
		    	if(queryType != 0)
			    	{
			    		sdate= "";
			    		edate= "";
			    		inType="";
			    	}
		    	var amtType = "";
		    	if(index == 0&&field=="amt1")amtType = -1;//总收款
		    	if(index == 1&&field=="amt1")amtType = 6;//现金
		    	if(index == 2&&field=="amt1")amtType = 3;//银行卡
		    	if(index == 3&&field=="amt1")amtType = 1;//微信
		    	if(index == 4&&field=="amt1")amtType = 2;//支付宝
		    	if(amtType != "")
			    { 
		    		if(amtType == 6)amtType = 0;
		    		
		    		parent.add('往来预付款统计','manager/toFinPreOutUnitStat?sdate=' + sdate + '&edate=' + edate +  '&amtType=' + amtType);
			    }
		    }
		</script>
	</body>
</html>
