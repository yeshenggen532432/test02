<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>商城会员收藏商品</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="resource/loadDiv.js"></script>
		<script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
	</head>
	<body>
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="false"
			url="manager/shopWareFavorite/uppage" border="false"
			rownumbers="true" fitColumns="false" pagination="true"
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
			<thead>
				<tr>
					<th field="memNm" width="100" align="center">
						会员名称
					</th>
					 <!-- formatter="formatDatebox" -->
					<th field="createTimeStr" width="100" align="center">
						收藏日期
					</th>
					<th field="wareNm" width="100" align="center" >
						商品名称
					</th>
					<th field="wareGg" width="80" align="center">
						规格
					</th>
					<th field="wareDj" width="80" align="center">
						价格
					</th>
					<th field="_picture" width="600" align="left" formatter="formatPicture">
						图片
					</th>
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
		     会员名称: <input name="memNm" id="memNm" style="width:156px;height: 20px;" onkeydown="toQuery(event);"/>
		     商品名称: <input name="wareNm" id="wareNm" style="width:156px;height: 20px;" onkeydown="toQuery(event);"/>
		     创建日期: <input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         			-
	         		  <input name="edate" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	   <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryWare();">查询</a>
		</div>
		<!-- <div id="bigPicDiv"  class="easyui-window" title="图片" style="width:315px;height:400px;top: 110px;overflow: hidden;"
			minimizable="false" maximizable="false"   collapsible="false"
			 closed="true">
			  <img style="width: 300px;height:300px;" id="photoImg" alt=""/>
			  <input type="hidden" id="photoId" />
			   <input type="hidden" id="wareId" />
		</div>	 -->
	</div>

		<script type="text/javascript">
		    //查询
			function queryWare(){
				$("#datagrid").datagrid('load',{
					url:"manager/shopWareFavorite/uppage",
					   wareNm:$("#wareNm").val(),
					   memNm:$("#memNm").val(),
					   putOn:$("#putOn").val(),
					   sdate:$("#sdate").val(),
					   edate:$("#edate").val()
				});
			}

			function formatType(val,row,index){
				return row.waretypeNm;
			}

		    //EasyUI用DataGrid用日期格式化
/* 		    function DateFormatter(value, rec, index) {
		        if (value == undefined) {
		            return "";
		        }
		        value = value.substr(1, value.length - 2);
		        var obj = eval('(' + "{Date: new " + value + "}" + ')');
		        var dateValue = obj["Date"];
		        if (dateValue.getFullYear() < 1900) {
		            return "";
		        }
		        return dateValue.format("yyyy-mm-dd");
		    } */

			function formatPicture(val,row){
				var html="";
				if(row.warePicList!=null && row.warePicList.length>0){
					for(var i=0;i<row.warePicList.length;i++){
						var color = "";
						if(row.warePicList[i].type=="1"){
							color = "border:1px solid #ff0000";
						}
						html+="&nbsp;&nbsp;<img  onclick='toBigPic(\""+row.warePicList[i].pic+"\",\""+row.warePicList[i].id+"\",\""+row.wareId+"\")' style='width: 80px;height: 80px;"+color+"' src='upload/"+row.warePicList[i].picMini+"'/>";
					}
				}
				return html;
			}

			/*
			function toBigPic(picurl,photoId,wareId){
				   document.getElementById("photoImg").setAttribute("src","${base}upload/"+picurl);
				   document.getElementById("photoId").value=photoId;
				   document.getElementById("wareId").value=wareId;
				   $("#bigPicDiv").window("open");
			   }
			   $('#bigPicDiv').window({
			     onBeforeClose:function(){
			       document.getElementById("photoImg").setAttribute("src","");
			       document.getElementById("photoId").value="";
			       document.getElementById("wareId").value="";
			     }
			   }); */

			  function formatDatebox(val) {
				    if (val == null || val == '') {
				        return '';
				    }
				    var dt;
				    if (val instanceof Date) {
				        dt = val;
				    } else {
				        dt = new Date(val);
				    }
				    return dt.format("yyyy-MM-dd");
				    /* return val.substring(0,10); //扩展的Date的format方法(上述插件实现) */
			}

		</script>
	</body>
</html>
