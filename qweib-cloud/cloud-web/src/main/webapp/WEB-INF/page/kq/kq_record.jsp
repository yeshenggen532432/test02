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
		<script type="text/javascript" src="resource/loadDiv.js"></script>
		<script type="text/javascript" src="resource/dtree.js"></script>
		<script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
		<style>
		.file-box{position:relative;width:70px;height: auto;}
		.uploadBtn{background-color:#FFF; border:1px solid #CDCDCD;height:22px;line-height: 22px;width:70px;}
		.uploadFile{ position:absolute; top:0; right:0; height:22px; filter:alpha(opacity:0);opacity: 0;width:70px;}
	    </style>
	</head>

	<body class="easyui-layout" fit="true">
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
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="false"
			url="manager/kqrpt/queryKqRecord" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="true" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
			<thead>
				<tr>
					<th field="ck" checkbox="true"></th>
				    <th field="memberId" width="50" align="center" hidden="true">
						memberId
					</th>
					
					<th field="memberNm" width="100" align="center">
						姓名
					</th>
					<th field="kqDate" width="80" align="center" >
						日期
					</th>
					<th field="time1" width="80" align="center">
						时间1
					</th>	
					<th field="time2" width="80" align="center">
						时间2
					</th>					
					<th field="time3" width="80" align="center">
						时间3
					</th>	
					<th field="time4" width="80" align="center">
						时间4
					</th>					
					
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
		考勤日期: <input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         			-
	         		  <input name="edate" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	     
		     员工姓名: <input name="memberNm" id="memberNm" style="width:100px;height: 20px;" onkeydown="toQuery(event);"/>
			
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryClick();">查询</a>
			
			<input type="hidden" id="branchId" value=""/>
		</div>
		</div>
		<script type="text/javascript">
		    var id="${info.datasource}";
		    var dataTp = "${dataTp}";
		    
			
			
			function queryByBranchId(id)
			{
				$("#branchId").val(id);
				$("#memberNm").val("");
				queryRecordPage();
			}
			function queryClick()
			{
				$("#branchId").val(0);
				queryRecordPage();
			}

		    //查询商品
			function queryRecordPage(){
			  
				$("#datagrid").datagrid('load',{
					url:"manager/kqrpt/queryKqRecord",
					memberNm:$("#memberNm").val(),
					sdate:$("#sdate").val(),
					edate:$("#edate").val(),
					branchId:$("#branchId").val()
					
					
				});
			  
			  
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					queryRecordPage();
				}
			}
 

		</script>
	</body>
</html>
