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
		<script type="text/javascript" src="resource/jquery.upload.js"></script>
	</head>
	<body>
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="false"
			url="/manager/getMaterialList?type=image&total=${image_count}" border="false"
			rownumbers="true" fitColumns="false" pagination="true" 
			pageSize=10 pageList="[5,10,15,20]" toolbar="#tb">
			<thead>
				<tr>
					<th field="media_id" width="350" align="center" hidden="true">
						素材id
					</th>
					<th field="url" width="300" align="center" formatter="imgFormatter">
						图片
					</th>
					<th field="name" width="150" align="center">
						名称
					</th>
					<th field="update_time" width="150" align="center" formatter="timeFormatter">
						更新日期
					</th>
					<th field="delete" width="80" align="center" formatter="deleteFormatter">
						删除
					</th>
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
			图片&nbsp(共<label id="num">${image_count}</label>条)&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp	
			<!-- <a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:upload();" >图片上传</a>    -->
			<a class="easyui-linkbutton" iconCls="icon-reload" plain="true" href="javascript:queryImageMaterial();">刷新</a>			
		</div>
		<script type="text/javascript">	
		function imgFormatter(val,row){			
			if(val!=""){
				 return "<input  type=\"image\" src=\""+""+val+"\" height=\"180\" width=\"280\" align=\"middle\" style=\"margin-top:10px;margin-bottom:10px;\"/>";
			}  
		}
		function timeFormatter(val,row){
			var timestamp=new Date(val*1000);
			return timestamp.toLocaleString();
		}
		 function deleteFormatter(val,row,index){
				   var str_row = JSON.stringify(row);
				   return "<input style='width:60px;height:27px' type='button' value='删除' onclick='deleteImageMaterial("+index+","+str_row+")' />"; 
			} 
		 	//查询			
			function queryImageMaterial(){
				  var msg=$.ajax({url:"/manager/getMaterialCount",async:false});
				  var json=$.parseJSON(msg.responseText);
				  var image_count=json.image_count;
				  $("#num").html(image_count);	
			      $("#datagrid").datagrid('load',{
						url:"/manager/getMaterialList?type=image",
						total:image_count
					});   
			  }
			 //删除		
			function deleteImageMaterial(index,row){
				$("#datagrid").datagrid('refreshRow',index);
				$.messager.confirm('提示框', '你确定要删除吗?',function(data){
					if(data){
						var media_id=row.media_id;
						var deleteImageMaterial_url="/manager/deleteMaterial?media_id="+media_id;
						var msg=$.ajax({url:deleteImageMaterial_url,async:false});
						var json=$.parseJSON(msg.responseText);
						if(json.errcode==0){
							alert("删除成功!");
							queryImageMaterial();					
						}else{
							alert("删除失败!"+" json.errcode:"+json.errcode+" ,json.errmsg:"+json.errmsg);					
						}
					}else{
						alert("取消删除！");
					}
				})  
			 }
			   
				// 上传图片到微信公众号
				function upload(){
					var postImage_Url="/manager/postWeixinImage";
						$.upload({
							// 上传地址
							url:postImage_Url,
							// 文件域名字
							fileName: 'media', 
							// 上传完成后, 返回json, text
							dataType: 'json',
							// 上传之前回调,return true表示可继续上传
							onSend: function() {
								return true;
							},
					 		// 上传之后回调
							 onComplate:function(data){		
								if(data.media_id != null){
									queryImageMaterial();
								}else{
									alert("上传失败！"+data.errmsg);
								}
							},  
						});						
					}		
		</script>
	</body>
</html>
