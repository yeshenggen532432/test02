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
		<style>
		.file-box{position:relative;width:70px;height: auto;}
		.uploadBtn{background-color:#FFF; border:1px solid #CDCDCD;height:22px;line-height: 22px;width:70px;}
		.uploadFile{ position:absolute; top:0; right:0; height:22px; filter:alpha(opacity:0);opacity: 0;width:70px;}
	    </style>
	</head>

	<body>
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
			url="manager/taskmempage" title="成员列表" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="true" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb"
			data-options="onDblClickRow: tochoice">
			<thead>
				<tr>
				   <th field="memberId" width="50" align="center" hidden="true">
						memberId
					</th>
					<th field="memberNm" width="120" align="center">
						姓名
					</th>
					<th field="memberMobile" width="120" align="center" >
						手机号码
					</th>
					<th field="memberCompany" width="120" align="center" >
						公司
					</th>
					<th field="memberJob" width="80" align="center" >
						职业
					</th>
					<th field="memberTrade" width="80" align="center" >
						行业
					</th>
					<th field="memberGraduated" width="80" align="center" >
						毕业院校
					</th>
					<th field="memberHometown" width="120" align="center" >
						家乡
					</th>
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
		     姓名: <input name="memberNm" id="memberNm" style="width:100px;height: 20px;" onkeydown="toQuery(event);"/>
			手机号码: <input name="memberMobile" id="memberMobile" style="width:100px;height: 20px;" onkeydown="toQuery(event);"/>
			<c:if test="${empty info.mId}">
			公司: <input name="memberCompany" id="memberCompany" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
			</c:if>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:querymember();">查询</a>
		</div>
		<script type="text/javascript">
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
				if(gzrIds!='' &&(gzrIds.indexOf(memberId+",")>0 || gzrIds.indexOf(","+memberId)>0 || gzrIds==memberId)){
					alert("关注人已存在!");
					window.parent.closeWindow();
				}else{
					if (row){
						window.parent.setMem(row.memberId,row.memberNm);
					}
				}
			}
		</script>
	</body>
</html>
