<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>企微宝微信图片素材管理</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<meta name="referrer" content="never">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="resource/loadDiv.js"></script>
		<script type="text/javascript" src="resource/jquery.upload.js"></script>	
		<style type="text/css">
		#uploadImagesForm{
			display:inline;
			
		}
		</style>
	</head>
	<body>
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="false"
			url="/manager/WeixinConfig/imagePage" border="false"
			rownumbers="true" fitColumns="false" pagination="true" 
			pageSize=5 pageList="[10,20,30,40,50]" nowrap="false" toolbar="#tb"
			data-opnions=""
			 >
			<thead>
				<tr>
					<th field="checkbox" checkbox="true"></th>
					<th field="picMini" width="200" align="center" formatter="imageFormatter">
						图片
					</th>
					<th field="uploadTime" width="150" align="center">
						上传日期
					</th>
					<th field="mediaId" width="120" align="center" formatter="media_idFormatter">
						微信公众平台图片
					</th>
					<th field="upload" width="130" align="center" formatter="uploadFormatter">
						上传到微信公众平台
					</th>
					<th field="delete" width="80" align="center" formatter="deleteFormatter" hidden="true">
						删除
					</th>
					<th field="remark" width="100" align="center">
						备注
					</th>
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
			图片&nbsp(共<label id="num">${imageCount}</label>条)&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp	
			<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:uploadImageToQWB();">上传单张图片</a>
			<form action="/manager/WeixinConfig/uploadWeixinImages" id="uploadImagesForm" name="uploadImagesForm" method="post" enctype="multipart/form-data">
				<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:uploadImages();">批量上传图片</a>
				<input type="file" hidden="true" multiple="multiple" name="fileUpload" id="fileUpload" value="上传多张图片" onchange="uploadImagesToQWB();">
			<button hidden="true" id="uploadButton" onclick="return uploadImagesToQWB()" style="width:80px">上传</button>
			</form>
			<a class="easyui-linkbutton" iconCls="icon-edit" plain="true" href="javascript:selectAllPageImages();">全选</a>
			<a class="easyui-linkbutton" iconCls="icon-edit" plain="true" href="javascript:unselectAllPageImages();">全不选</a>
			<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:uploadImagesMaterial();">批量上传选中行的图片到微信公众平台</a>
			<a class="easyui-linkbutton" iconCls="icon-reload" plain="true" href="javascript:queryImage();">刷新</a>
		</div>
		<script type="text/javascript">	
	 		$(function(){
				$("#datagrid").datagrid({
					onSelect:function(rowIndex, rowData){
						$("#datagrid").datagrid("updateRow",{
							index:rowIndex, 
							row:{remark:"待上传"} 
						})
					},
					onUnselect:function(rowIndex, rowData){
						$("#datagrid").datagrid("updateRow",{
							index:rowIndex,
							row:{remark:""}
						})
					}
				});
			}); 
			 function imageFormatter(val,row){			
				if(val!=""){
				   return "<input  type=\"image\" src=\""+"upload/"+val+"\" height=\"180\" width=\"180\" align=\"middle\" style=\"margin-top:10px;margin-bottom:10px;\"/>";
				}  
			} 
			 function media_idFormatter(val,row){	
					if(row.mediaId==""){
						return "未上传";
					}else{
						return "已上传";
					}    
				}
			 function uploadFormatter(val,row,index){
				   var str_row = JSON.stringify(row);
				   if(row.mediaId==""){
					   return "<input style='width:100px;height:27px' type='button' value='上传' onclick='uploadImageMaterial("+index+","+str_row+")' />"; 
				   }else{
					   return "<input style='width:100px;height:27px' type='button' value='重新上传' onclick='uploadImageMaterial("+index+","+str_row+")' />"; 
				   }
				   
			} 
			 function deleteFormatter(val,row,index){
					   var str_row = JSON.stringify(row);
					   return "<input style='width:60px;height:27px' type='button' value='删除' onclick='deleteImageMaterial("+index+","+str_row+")' />"; 
				} 
		 	//查询			
			function queryImage(){
				  var msg=$.ajax({url:"/manager/WeixinConfig/getImageMaterialCount",async:false});
				  var imageCount=$.parseJSON(msg.responseText);
				  $("#num").html(imageCount);	
			      $("#datagrid").datagrid('load',{
						url:"/manager/WeixinConfig/imagePage",
						total:imageCount
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
			// 上传单张图片到企微宝
			function uploadImageToQWB(){
				var postImage_Url="/manager/WeixinConfig/uploadWeixinImage";
					$.upload({
						// 上传地址
						url:postImage_Url,
						// 文件域名字
						fileName: 'fileUpload', 
						// 上传完成后, 返回json, text
						dataType: 'json',
						// 上传之前回调,return true表示可继续上传
						onSend: function() {
							return true;
						},
				 		// 上传之后回调
						 onComplate:function(data){	
							if(data.state){
								queryImage();
							}else{
								alert(data.msg);
							}
						},  
					});						
				}	
			// 批量上传多张图片到企微宝
			 function uploadImages(){
				$("#fileUpload").click();
			} 
			 
			//批量上传图片到企微宝
			function uploadImagesToQWB(){
				//检查批量上传的图片的数量
				var files = $("#fileUpload")[0].files;
				if(files.length==0){
					alert("没有图片");
					return;
				}
				
				if(files.length>50){
					alert("1次上传不能超过50张图片");
					$("#fileUpload").val("");
					return;
				}
				//检查批量上传的图片的类型
				var fileExt = "";
				for(var i=0;i<files.length;i++){
					fileExt=(files[i].name).substring(files[i].name.lastIndexOf(".")).toLowerCase();
				 	if(!fileExt.match(/.jpg|.jpeg|.gif|.png|.bmp/)){
						alert(files[i].name+"不是jpg、jpeg、gif、png、bmp类型的图片文件");
						$("#fileUpload").val("");
						return;
					} 
				}
				//检查批量上传的图片的大小
				for(var i=0;i<files.length;i++){
					var fileSize=files[i].size;
					if(fileSize>2*1024*1024){
						alert(files[i].name+"的大小超过了2MB");
						$("#fileUpload").val("");
						return;
					}
				}
				//上传图片到企微宝
				 $("#uploadImagesForm").form('submit',{
					success:function(data){
						var dataJson = JSON.parse(data);
						if(dataJson.state){
							$.messager.alert('消息','上传成功!','info');
							queryImage();
							$("#fileUpload").val("");
						}else{
							$.messager.alert('消息','上传失败!','info');
							$("#fileUpload").val("");
						}
					}
				});
			   return false;
			}
			//全选页面图片行
			function selectAllPageImages(){
				$("#datagrid").datagrid("selectAll");
				var rows = $("#datagrid").datagrid("getSelections");
				for(var i=0;i<rows.length;i++){
					$("#datagrid").datagrid("updateRow",{
						index:i, 
						row:{remark:"待上传"} 					
					})
				}
			}
			//全不选页面图片行
			function unselectAllPageImages(){
				$("#datagrid").datagrid("unselectAll");
				var rows =$("#datagrid").datagrid("getRows");
				for(var i=0;i<rows.length;i++){
					$("#datagrid").datagrid("updateRow",{
						index:i,
						row:{remark:""}
					})
				}
			}
			//上传图片到微信公众平台
			  function uploadImageMaterial(index,row){
				 $("#datagrid").datagrid('refreshRow',index);	
				 var id=row.id;
				 var imagePath="${uploadPath}"+"/"+row.pic;
				 $.ajax({
						url:"/manager/postQWBImage",
						data:"id="+id+"&imagePath="+imagePath,
						type:"post",
						dataType:"JSON",
						success:function(data){	
							if(data.media_id != null){
								 $("#datagrid").datagrid('reload');	
								alert("上传成功！");
							}else{
								alert("上传失败！"+data.errmsg);
							}
						}
					});
			 } 
			//批量上传选中的图片到微信公众平台
			  function uploadImagesMaterial(){
				 var rows = $("#datagrid").datagrid("getSelections");
				 if(rows.length==0){
					 alert("没有选中行！");
					 return;
				 }
				  for(var i=0;i<rows.length;i++){
					  var rowIndex = $("#datagrid").datagrid('getRowIndex',rows[i]);
					  var id=rows[i].id;
					  var imagePath="${uploadPath}"+"/"+rows[i].pic;
					  $.ajax({
							url:"/manager/postQWBImage",
							async:false,
							data:"id="+id+"&imagePath="+imagePath,
							type:"post",
							dataType:"JSON",
							success:function(data){		
								if(data.media_id != null){
									$("#datagrid").datagrid('unselectRow',rowIndex);
									$("#datagrid").datagrid('updateRow',{
										index: rowIndex, 
										row:{mediaId:"已上传"}
									}); 
								}else{
									alert("第"+(rowIndex+1)+"行图片上传失败！"+data.errmsg);
								}
							}
					 });
				 }	
				  alert("图片已上传！");
			 } 
			
		</script>
	</body>
</html>
