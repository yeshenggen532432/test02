<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>被关注回复</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="resource/loadDiv.js"></script>
		<style type="text/css">
		.textarea{
			align:center;
			height:180px;
			width:380px;
			margin-left:35px;	
		}
		.contentRadio{
			margin-left:5px;
			cursor:pointer;
		}
		#replyContentImage input{
			width:300px;
		}
		#replyContentImage p{
			margin-left:30px;
		}
		#imageTable{
		border:2px solid #F4F4F4;
		background:#ffffff;
		width:380px;
		height:180px;
		margin-top:20px;
		margin-left:30px; 
		cellspacing:0; 
		cellpadding:0;		
		}
		#imageTable td{
		border:2px solid #F4F4F4;
		align:center;
		}
		#imageTable button{
		 width:60px;
		}
		#imageTable img{
		 width:280px;
		 height:180px;
		}
		#replyContent button{
			width:80px;
			height:30px;
			position:relative;
			left:15%;
			font-size:13px;
		}
		#replyContent p{
			margin-top:20px;
			margin-left:20px;
			font-size:13px;
			margin-bottom:10px;
		}
		#replyContent label{
			margin-top:20px;
			padding-left:20px;
		}
		</style>
	</head>
	<body>
	
		<div style="border-left-width:2px;margin-top:30px;padding-left:20px;float:left" >
		<input type="hidden" id="id" value="${config.id }"  name='id'/>
			<div id="replyContent" class="">
				<p><label>回复内容</label>
				<label class="contentRadio"><input id="radioText"  type="radio" name="replyContentType" onclick="replyContentType()" value="text"  class="content"/>文字</label>
				<label class="contentRadio"><input id="radioImage" type="radio" name="replyContentType" onclick="replyContentType()" value="image" class="content"/>图片</label>
				<label class="contentRadio"><input type="button" id="saveButton" name="saveButton" onclick="saveReply()" value="保存" style="width:80px"/></label>
				</p>
					<div id="replyContentTextareaDiv">
						<p><textarea class="reg_input" name="replyContentTextarea" id="replyContentTextarea" 
						style="width:350px;height:180px;resize:none;margin-left:30px;"></textarea>
						<span id="replyContentTextareaTip" class="onshow"></span></p>
					</div>	
					<div id="replyContentImage" class="hidden">
					    <table  id="imageTable">
							<tr>
								<td width="280">
									<img id="buttonImage" alt="" src="">
								</td>
								<td  width="100">
									<a class="easyui-linkbutton" iconCls="icon-reload" plain="true" href="javascript:showImageWin();">设置图片</a>
								</td>
							</tr>
						</table>
						<p>image_id:&nbsp;&nbsp;&nbsp;<label  id="buttonImagID" stype="width:200px"/></p>
					</div>		
				</div>	
		</div>
		<!-- 设置图片素材 -->
		<div id="imageDiv" class="easyui-window" style="width:800px;height:400px;padding:10px;" 
			minimizable="false" maximizable="false" collapsible="false" closed="true">
		<table id="imageDatagrid" class="easyui-datagrid" fit="true" singleSelect="false"  border="false"
			rownumbers="true" fitColumns="false" pagination="true" 
			pageSize=10 pageList="[10,20,30,40,50]"  nowrap="false" toolbar="#imageTb">
			<thead>
				<tr>
					<th field="id" width="50" align="center">
						图片id
					</th>
					<th field="picMini" width="200" align="center" formatter="imageFormatter">
						图片
					</th>
					<th field="uploadTime" width="150" align="center">
						上传日期
					</th>
					<th field="mediaId" width="120" align="center" formatter="media_idFormatter">
						微信公众平台图片
					</th>
					<th field="setImage" width="80" align="center" formatter="imageSetFormatter">
						设置
					</th>
				</tr>
			</thead>
		</table>
		<div id="imageTb" style="padding:5px;height:auto">
		</div>
		
		</div>
		<script type="text/javascript">
		 $(function(){
			 	 //字数验证
				 $.formValidator.initConfig();
				 toValidate();
				 //选择单选框
				 var subscribeStatus="${config.subscribeStatus}";
				 if("${config.id}"==""){
					 var weixinConfigId=0; 
				 }else{
					 var weixinConfigId="${config.id}";
				 }
				 var getWeixinConfig_url="/manager/weiXinReply/getSubscribeReplyText?weixinConfigId="+weixinConfigId;
				 var subscribeTex="";
						var msg=$.ajax({url:getWeixinConfig_url,async:false});
						if(msg.responseText==""){
							 var radioText=$("#radioText");
							 radioText.prop("checked","checked");
							 replyContentType();
						}else{
							var json=$.parseJSON( msg.responseText ) ;
							var subscribeReplyTextMap=json.subscribeReplyTextMap;
							if(json.state){
								 var subscribeImageId="${config.subscribeImageId}";
								 var radioText=$("#radioText");
								 var radioImage=$("#radioImage");
								 if(subscribeStatus == "0"){
									 radioText.prop("checked","checked");
									 replyContentType();
									 $("#replyContentTextarea").val( subscribeReplyTextMap.subscribe_text);
								 }else{
									 if(subscribeImageId == "" || subscribeImageId == null){
										 radioText.prop("checked","checked");
										 replyContentType();
										 $("#replyContentTextarea").val( subscribeReplyTextMap.subscribe_text);
									 }else{
										 radioImage.prop("checked","checked");
										 replyContentType();
										 var getImage_url="/manager/weiXinReply/getSubscribeImageUrl?subscribeImageId="+subscribeImageId;
										 var msg=$.ajax({url:getImage_url,async:false});
										 if(msg.responseText==""){
											 alert("查询图片失败！");
										 }else{
											 var json=$.parseJSON( msg.responseText ) ;
											 var ImageMap=json.ImageMap;
											 var ImageUrl=ImageMap.pic;
											 ImageUrl="upload/"+ImageUrl;
											 $("#buttonImage").attr("src",ImageUrl);
										 } 
										 $("#buttonImagID").html(subscribeImageId);
									 }
								 } 
							}else{
								alert("查询回复内容失败！");
							}
						}
						
				 /* $.ajax({
						url:getWeixinConfig_url,
						success:function(data){
							if(data.state){
								subscribeText=data.subscribeText;
							}else{
							    alert("查询被关注回复内容失败");
							}
						}
				 }); */
				 
			});
		//表单验证
		 function toValidate(){ 
			$("#replyContentTextarea").formValidator({onShow:"1~600个字",onFocus:"1~600个字",onCorrect:"通过"}).inputValidator({min:1,max:1200,onError:"1~600个字"});
		} 
		//单选框
		   function replyContentType(){
			   var ContentType=$("input[name=replyContentType]:checked").val();
		 	   switch(ContentType){
		 	   case "text":
		 		   $("#replyContentTextareaDiv").show();
				   $("#replyContentImage").hide();
				   break;
		 	   case "image":
				   $("#replyContentTextareaDiv").hide();
				   $("#replyContentImage").show();
				   break;
		 	   default:break;
		 	   }
		   }
		   //查询图片			
			function queryImageMaterial(){ 
				  $('#imageDatagrid').datagrid({  
					    url:"/manager/WeixinConfig/imagePage" 
					});
			  }
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
		 function imageSetFormatter(val,row,index){
			   var ImageUrl=row.picMini;
			   var image_id=row.id;
			   ImageUrl=JSON.stringify(ImageUrl);
			   image_id=JSON.stringify(image_id);
			   return "<input style='width:60px;height:27px' type='button' value='设置' onclick='setImageMaterial("+ImageUrl+","+image_id+")' />"; 
		}
		//设置图片
			function showImageWin(){
				$("#imageDiv").window({title:"设置图片",modal:true});
				queryImageMaterial();
				$("#imageDiv").window('open');
				$("#imageDiv").window('center');
				
			}
			function hideImageWin(){
				$("#imageDiv").window('close');
				$('#imageDatagrid').datagrid('reload');
			}
			function imageSetFormatter(val,row,index){
				   var ImageUrl=row.picMini;
				   var image_id=row.id;
				   ImageUrl=JSON.stringify(ImageUrl);
				   image_id=JSON.stringify(image_id);
				   return "<input style='width:60px;height:27px' type='button' value='设置' onclick='setImageMaterial("+ImageUrl+","+image_id+")' />"; 
			}		
			function setImageMaterial(ImageUrl,image_id){
						ImageUrl="upload/"+ImageUrl;
						$("#buttonImage").attr("src",ImageUrl);
						$("#buttonImagID").html(image_id);
						hideImageWin();
			 }
			//保存
			function saveReply(){
				if("${config.id}"==""){
					alert("请先保存公众号配置！");
				}else{
					var ContentType=$("input[name=replyContentType]:checked").val();
					var subscribeImageId="${config.subscribeImageId}";
				 	   switch(ContentType){
				 	   case "text":
				 		  $("#buttonImagID").html("")
				 		  $("#buttonImage").attr('src',""); 
				 		  var saveReply_url="/manager/weiXinReply/updateSubscribeReply";
				 		  if ($.formValidator.pageIsValid()==true){
								$.ajax({
									url:saveReply_url,
									data:{"type":ContentType,"value":$("#replyContentTextarea").val()},
									//data:"type="+ContentType+"&value="+$("#replyContentTextarea").val(),
									type:"post",
									success:function(data){
										if(data=="1"){
										    alert("保存成功!");
										}else{
										    alert("保存失败");
										}
									}
								});
				 		  }
						   break;
				 	   case "image":
				 		 $("#replyContentTextarea").val(""); 
				 		 var saveReply_url="/manager/weiXinReply/updateSubscribeReply";
						 if($("#buttonImagID").html()=="")  {
							 alert("请选择图片");
						 }else{
							 $.ajax({
									url:saveReply_url,
									data:{"type":ContentType,"value":$("#buttonImagID").html()},
									type:"post",
									success:function(data){
										if(data=="1"){
										    alert("保存成功!");
										}else{
										    alert("保存失败");
										}
									}
							  });
						 }
						   break;
				 	   default:break;
				 	   }
				}
			}
		</script>
	</body>
</html>
