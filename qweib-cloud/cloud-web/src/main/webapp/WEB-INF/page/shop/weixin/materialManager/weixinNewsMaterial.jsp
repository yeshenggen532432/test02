<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>素材管理</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<meta name="referrer" content="never">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="resource/loadDiv.js"></script>
	</head>
	<body>
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="false"
			url="/manager/getMaterialList?type=news&total=${news_count}" border="false"
			rownumbers="true" fitColumns="false" pagination="true" 
			pageSize=5 pageList="[5,10]" nowrap="false" toolbar="#tb">
			<thead>
				<tr>
					<th field="media_id" width="300" align="center" hidden="true">
						素材id
					</th>
					<th field="thumb" width="300" align="center" formatter="imgFormatter">
						封面
					</th>
					<th field="title" width="200" align="center" formatter="titleFormatter">
						标题
					</th>
					<th field="author" width="60" align="center" formatter="authorFormatter">
						作者
					</th>
					<th field="update_time" width="150" align="center" formatter="timeFormatter">
						更新日期
					</th>
					<th field="news_url" width="80" align="center" formatter="urlFormatter">
						浏览
					</th>
			    	<th field="delete" width="80" align="center" formatter="deleteFormatter">
						删除
					</th> 
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
			图文消息&nbsp(共<label id="num">${news_count}</label>条)
			<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:editPhotoTextMaterial();">新建图文素材</a>
			<a class="easyui-linkbutton" iconCls="icon-reload" plain="true" href="javascript:queryNewsMaterial();">刷新</a>
		</div>
		<script type="text/javascript">	
		//查询			
		function queryNewsMaterial(){
			  var msg=$.ajax({url:"/manager/getMaterialCount",async:false});
			  var json=$.parseJSON(msg.responseText);
			  var news_count=json.news_count;
			  $("#num").html(news_count);	
			  $("#datagrid").datagrid('load',{
					url:"/manager/getMaterialList?type=news",
					total:news_count
				});
		 }
		function imgFormatter(val,row,index){
			if(val!=""){
				var thumb_photo= row.content.news_item[0].thumb_url;
				return "<input  type=\"image\" src=\""+""+thumb_photo+"\" height=\"180\" width=\"280\" align=\"middle\" style=\"margin-top:10px;margin-bottom:10px;\"/>";  
			}
		}
		function timeFormatter(val,row){
			var timestamp=new Date(val*1000);
			return timestamp.toLocaleString();
		}
		function titleFormatter(val,row){
			 return row.content.news_item[0].title;           
		}
		function authorFormatter(val,row){
			 return row.content.news_item[0].author; 
		}
		function urlFormatter(val,row,index){
			var url= row.content.news_item[0].url;
			return "<input style='width:60px;height:27px' type='button' value='浏览' onclick='showNews("+index+","+"\""+url+"\""+")' />";	 
		}
		function showNews(index,url){
		     window.open(url,'浏览图文消息');
		     $("#datagrid").datagrid('refreshRow',index);		     
		}
		function deleteFormatter(val,row,index){
			var media_id= row.media_id;
		    return "<input style='width:60px;height:27px' type='button' value='删除' onclick='deleteNewsMaterial("+index+","+"\""+media_id+"\""+")' />";
		} 	
		 //删除		
		function deleteNewsMaterial(index,media_id){
			$("#datagrid").datagrid('refreshRow',index);
			$.messager.confirm('提示框', '你确定要删除吗?',function(data){
				if(data){
					var deletePhotoMaterial_url="/manager/deleteMaterial?media_id="+media_id;
					var msg=$.ajax({url:deletePhotoMaterial_url,async:false});
					var json=$.parseJSON(msg.responseText);
					if(json.errcode==0){
						alert("删除成功!");
						queryNewsMaterial();					
					}else{
						alert("删除失败!"+" json.errcode:"+json.errcode+" ,json.errmsg:"+json.errmsg);
					}
				}else{
					alert("取消删除！");
				}
			})  
		 }
		</script>
	</body>
</html>
