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
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
			 title="" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="true" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" showFooter="true" data-options="onDblClickRow: onDblClickRow">
		</table>
		<div id="tb" style="padding:5px;height:auto">
			<input type="hidden" name="rptType" id="rptType" value="${rptType }">
		   时间: <input name="stime" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
	         	   <img onclick="WdatePicker({el:'stime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         	   -
	         <input name="etime" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
	         <img onclick="WdatePicker({el:'etime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	      	 标题：<input name="rptTitle" id="rptTitle"  style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
		 	
	               <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:query();">查询</a>
		</div>
		<script type="text/javascript">
		   //查询
		   //initGrid();
		   function initGrid()
		   {
			    var cols = new Array(); 
	    	    var col = {
						field: 'rptTitle',
						title: '标题',
						width: 80,
						align:'center'
				};
	    	    cols.push(col);
	    	    
	    	    var col = {
						field: 'sdate',
						title: '日期',
						width: 80,
						align:'left'
				};
	    	    cols.push(col);
	    	    
	    	    var col = {
						field: 'operName',
						title: '操作人',
						width: 80,
						align:'left'
				};
	    	    cols.push(col);
	    	    
	    	    var col = {
						field: 'remark',
						title: '备注',
						width: 80,
						align:'left'
				};
	    	    cols.push(col);
	    	    
				$('#datagrid').datagrid({
					url:"manager/querySaveRptDataStatPage",
					queryParams:{
						sdate:$("#sdate").val(),
						edate:$("#edate").val(),
						rptTitle:$("#rptTitle").val(),
						rptType:$("#rptType").val()
						},
    	    		columns:[
    	    		  		cols
    	    		  	]
						}
    	    );
		   }
			function query(){
				$("#datagrid").datagrid('load',{
					url:"manager/querySaveRptDataStatPage",
					sdate:$("#sdate").val(),
					edate:$("#edate").val(),
					rptTitle:$("#rptTitle").val(),
					rptType:$("#rptType").val()
				});
			}
			function DateTimeFormatter(v,row) {
			    if (v == undefined) {
			        return "";
			    }
			    var date = new Date(v);
                var y = date.getFullYear();
                var m = date.getMonth() + 1;
                var d = date.getDate();
                return y + '-' +m + '-' + d+" "+date.getHours()+":"+date.getMinutes();
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					query();
				}
			}
			function onDblClickRow(rowIndex, rowData)
		    {
		    	var id = rowData.id;
		    	var title = rowData.rptTitle;
		    	parent.closeWin(title);
		    	parent.add(title,'manager/querySaveRptDataItemStat?id=' + id);
		    }
			
			
		</script>
	</body>
</html>
