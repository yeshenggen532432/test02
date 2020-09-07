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
		<script src="${base}resource/kqstyle/js/com.js" type="text/javascript"></script>
	</head>

	<body class="easyui-layout" fit="true" onload="initGrid()">
	<div data-options="region:'west',split:true,title:'部门分类树'"
			style="width:150px;padding-top: 5px;">
			<div id="divHYGL" style="overflow: auto;">
				<ul id="departtree" class="easyui-tree" fit="true"
					data-options="url:'manager/departs?depart=${depart }&dataTp=1',animate:true,dnd:false,onClick: function(node){
						queryByBranchId(node.id);
					},onDblClick:function(node){
						$(this).tree('toggle', node.target);
					}">
				</ul>
			</div>
		</div>
	<div id="departDiv" data-options="region:'center'" >
	<input type="hidden" id="id" value="${id}" />
	
		<table id="datagrid"  fit="true" singleSelect="true"
			 title="" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="false"  toolbar="#tb" showFooter="true" >
			
		</table>
		<div id="tb" style="padding:5px;height:auto">
		考勤日期: <input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         			-
	         		  <input name="edate" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
		   姓名: <input name="memberNm" id="memberNm" style="width:180px;height: 20px;" " />
		  
	     <input type="hidden" id="branchId" value=""/>
	     <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryAllData();">查询</a>  
	     <a class="easyui-linkbutton" iconCls="icon-print" href="javascript:toPrint();">打印</a>        
	     <span id="paramStr">
	     	正常√&nbsp; &nbsp; 
	     </span>   
	     <span id="paramStr">
	     	迟到L&nbsp; &nbsp; 
	     </span>    
	     
	      <span id="paramStr">
	     	缺勤×&nbsp; &nbsp; 
	     </span>  
	     
	      <span id="paramStr">
	     	备注≠&nbsp; &nbsp; 
	     </span>    
	     <span id="paramStr">
	     	早退E&nbsp; &nbsp; 
	     </span>   
	     <span id="paramStr">
	     	漏卡■
	     </span>   
	     <span id="paramStr">
	     	考勤地点错误O
	     </span>     
		</div>
		</div>
		<script type="text/javascript">
		 
		   //查询
		   //initGrid();
		   function queryByBranchId(id)
			{
				$("#branchId").val(id);
				queryData();
			}
		  
		   var cols1 = new Array();
		   function initGrid()
		   {
			   var cols = new Array();
			   var col = {
						field: 'memberNm',
						title: '员工姓名',
						width: 100,
						align:'center'
				};
	    	    cols.push(col);
	    	    
			   var beginDateStr = $("#sdate").val() + "";
			   var endDateStr = $("#edate").val() +"";
			   var beginDate = new Date(beginDateStr.replace(/\-/g, "/"));
			   var endDate = new Date(endDateStr.replace(/\-/g, "/"));
			   var beginDay = beginDate.getDate();
			   var endDay = endDate.getDate();
			   var days = dateDiff(endDate,beginDate);
			   for(var i = 0;i<= days;i++){
				   var objDate = addDays(beginDate,i);
				   var ymd = objDate.dateString;//("yyyy-MM-dd");
				   var title = ymd.substr(8,2);
				   var col = {
					   field: '_day' +i,
					   title: title,
					   width: 50,
					   align:'center',
					   value: i,
					   formatter:formatterSt3

				   };
		    	    cols.push(col);
				   
			   }		   
			   

				$('#datagrid').datagrid({
					url:"manager/kqrpt/queryKqResult",
	    	    	 queryParams:{	    	    		
	 					memberNm:$("#memberNm").val(),	 								
	 					sdate:$("#sdate").val(),
	 					edate:$("#edate").val(),
	 					branchId:$("#branchId").val()
	 					
	    	    	 },
	    	    		columns:[
	    	    		  		cols
	    	    		  	]}
    	    );
    	    
		   }
		   
		   function queryAllData()
		   {
			   $("#branchId").val(0);
				queryData();
		   }
		   function queryData(){
			   initGrid();
			   var branchId = $("#branchId").val();
			   $("#datagrid").datagrid('load',{
					url:"manager/kqrpt/queryKqResult",
					memberNm:$("#memberNm").val(),	 								
 					sdate:$("#sdate").val(),
 					edate:$("#edate").val(),
 					branchId:branchId
					
				});
		   }
		   function formatterSt3(v,row)
			{
			   var len = this.field.length;
			   var str = this.field.substr(4,len - 4);
			   var n = parseInt(str);
			   if(row.dayStr.length> n)
			   return row.dayStr[n];
			   else return "";
			}
			
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					 queryData();
				}
			}
			
			function toPrint()
			{
				var branchId = $("#branchId").val();
				   
				 var params = "branchId=" + branchId + "&memberNm=" + $("#memberNm").val() + "&sdate=" + $("#sdate").val() + "&edate=" + $("#edate").val() + "&billName=考勤签注表";
				parent.closeWin('考勤签注表打印');
		    	parent.add('考勤签注表打印' ,'manager/kqrpt/toKqResultPrint?' + params);
			}
	
		</script>
	</body>
</html>
