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
		<script type="text/javascript" src="resource/loadDiv.js"></script>
		<style>
		.file-box{position:relative;width:70px;height: auto;}
		.uploadBtn{background-color:#FFF; border:1px solid #CDCDCD;height:22px;line-height: 22px;width:70px;}
		.uploadFile{ position:absolute; top:0; right:0; height:22px; filter:alpha(opacity:0);opacity: 0;width:70px;}
	    </style>
	</head>

	<body>
		<table id="datagrid" class="easyui-datagrid" fit="true"
			url="manager/querytasks?type=${type }&taskId=${taskId}" title="任务详情" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="true" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" AllowPaging="false"
			data-options="onDblClickRow: tochoice">
			<thead>
				<tr>
				   <th field="id" width="50" align="center" hidden="true">
						id
					</th>
					<th field="taskTitle" width="120" align="center">
						任务名称
					</th>
					<th field="createTime" width="120" align="center" >
						创建时间
					</th>
					<th field="createName" width="120" align="center" >
						发布人
					</th>
					<th field="memberNm" width="80" align="center"  formatter="isnull">
						执行人
					</th>
					<th field="supervisor" width="80" align="center"  formatter="isnull">
						关注人
					</th>
					<th field="status" width="80" align="center" formatter="vstatue">
						状态
					</th>
					<th field="percent" width="80" align="center"  formatter="isnull">
						进度
					</th>
				</tr>
			</thead>
		</table>
		<script type="text/javascript">
			//状态
			function vstatue(val){
				if(val=="1"){
					return "<span style='color:blue'>进行中</span>";
				}else if(val=="2"){
					return "<span style='color:green'>完成</span>";
				}else if(val=="3"){
					return "<span style='color:red'>草稿</span>";
				}
			}
		    var id="${info.mId}";
		    //查询商品
			function querymember(){
			  if(!id){
				$("#datagrid").datagrid('load',{
					url:"manager/memberPage",
					memberCompany:$("#memberCompany").val(),
					memberNm:$("#memberNm").val(),
					memberMobile:$("#memberMobile").val()
					
				});
			  }else{
				 $("#datagrid").datagrid('load',{
					url:"manager/memberPage",
					memberNm:$("#memberNm").val(),
					memberMobile:$("#memberMobile").val()
					
				});
			  }
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					querymember();
				}
			}
			//双击选择
			function tochoice(index){
				var row = $('#datagrid').datagrid('getSelected');
				var memberId = row.memberId;
				var gzrIds = "${gzrIds}";
				if(gzrIds!='' &&(gzrIds.contains(memberId+",") || gzrIds.contains(","+memberId) || gzrIds==memberId)){
					alert("关注人已存在!");
					window.parent.closeWindow();
				}else{
					if (row){
						window.parent.setMem(row.memberId,row.memberNm);
					}
				}
			}
			function isnull(val){
				if(val==""|| typeof(val)=="undefined"){
					return "—";
				}else{
					return val;
				}
			}
		</script>
	</body>
</html>
