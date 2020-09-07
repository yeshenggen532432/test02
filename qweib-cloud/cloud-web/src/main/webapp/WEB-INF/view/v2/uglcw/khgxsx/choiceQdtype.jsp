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
	</head>

	<body>
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
			url="manager/querySysQdtype" title="渠道类型列表" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="true" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" data-options="onDblClickRow: tochoice">
			<thead>
				<tr>
				    <!--<th field="ck" checkbox="true"></th>-->
					<th field="id" width="50" align="center" hidden="true">
						id
					</th>
					<th field="coding" width="60" align="center">
						编号
					</th>
					<th field="qdtpNm" width="80" align="center">
						名称
					</th>
					<th field="remo" width="100" align="center">
						注备
					</th>
					<th field="isSx" width="60" align="center" formatter="formatterSt">
						是否生效
					</th>
					<th field="sxaDate" width="80" align="center">
						生效日期
					</th>
					<th field="sxeDate" width="80" align="center">
						失效日期
					</th>
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
		    名称: <input name="qdtpNm" id="qdtpNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
		    <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:querys();">查询</a>
		</div>
		<script type="text/javascript">
		    function formatterSt(val,row){
				if(val==1){
				   return "是";
				}else{
				   return "否";
				}
		    }
		    //查询
			function querys(){
				$("#datagrid").datagrid('load',{
					url:"manager/querySysQdtype",
					qdtpNm:$("#qdtpNm").val()
				});
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					querys();
				}
			}
			//选择确定
			function tochoice(index){
			    var row = $('#datagrid').datagrid('getSelected');
				if (row){
				  window.parent.setQdtype(row.id,row.qdtpNm);
				}
			}
		</script>
	</body>
</html>
