<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>企微宝</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="resource/loadDiv.js"></script>
	</head>
	<body>
		<input type="hidden" name="wtype" id="wtype" value="${wtype}"/>
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="false"
			url="manager/waresshop?wtype=${wtype}" border="false"
			rownumbers="true" fitColumns="false" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
			<thead>
				<tr>
					<th  field="wareId" checkbox="true"></th>
					<th field="waretypeNm" width="80" align="center" formatter="formatType">
						所属分类
					</th>
					<th field="wareNm" width="100" align="center">
						商品名称
					</th>
					<th field="wareGg" width="80" align="center">
						规格
					</th>
					<th field="_picture" width="600" align="left" formatter="formatPicture">
						图片
					</th>
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
		     商品名称: <input name="wareNm" id="wareNm" style="width:156px;height: 20px;" onkeydown="toQuery(event);"/>
			<input type="hidden" name="wtype" id="wtypeid" value="${wtype}"/>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryWare();">查询</a>
		</div>
		<div id="bigPicDiv"  class="easyui-window" title="图片" style="width:315px;height:400px;top: 110px;overflow: hidden;" 
			minimizable="false" maximizable="false" modal="true"  collapsible="false" 
			 closed="true">
			  <img style="width: 300px;" id="photoImg" alt=""/>
		</div>		
	</div>
		
		<script type="text/javascript">
		    //查询
			function queryWare(){
				$("#datagrid").datagrid('load',{
					url:"manager/waresshop",
					   wareNm:$("#wareNm").val()
				});
			}
			function formatType(val,row,index){
				return row.waretypeNm;
			}
			function formatPicture(val,row){
				var html="";
				if(row.warePicList.length>0){
					for(var i=0;i<row.warePicList.length;i++){
						html+="&nbsp;&nbsp;<img onclick='toBigPic(\""+row.warePicList[i].pic+"\")' style='width: 80px;height: 80px;' src='upload/"+row.warePicList[i].picMini+"'/>";
					}
				}
				return html;
			}
			function toBigPic(picurl){
				   document.getElementById("photoImg").setAttribute("src","${base}upload/"+picurl);
				   $("#bigPicDiv").window("open");
			   }
			   $('#bigPicDiv').window({
			     onBeforeClose:function(){
			       document.getElementById("photoImg").setAttribute("src","");
			     }
			   });
		</script>
	</body>
</html>
