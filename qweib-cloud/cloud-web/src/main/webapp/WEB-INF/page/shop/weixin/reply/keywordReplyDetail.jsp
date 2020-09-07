<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>收到消息回复</title>
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
		.imageTable{
		border:2px solid #F4F4F4;
		background:#ffffff;
		width:380px;
		height:180px;
		margin-top:20px;
		margin-left:30px; 
		cellspacing:0; 
		cellpadding:0;		
		}
		.imageTable td{
		border:2px solid #F4F4F4;
		align:center;
		}
		.imageTable button{
		 width:60px;
		}
		.imageTable img{
		 width:280px;
		 height:180px;
		}
		.replyContent button{
			width:80px;
			height:30px;
			position:relative;
			left:15%;
			font-size:13px;
		}
		.replyContent p{
			margin-top:20px;
			margin-left:20px;
			font-size:13px;
			margin-bottom:10px;
		}
		.replyContent label{
			margin-top:20px;
			padding-left:20px;
		}
		hr{
		 height:3px;
		 width:100%;
		 border:none;
		 background-color:#FF0000;
		}
		p{
			margin-top:10px;
			margin-left:60px;
			font-size:13px;
			margin-bottom:10px;
		}
		#tb{
			background-color:#F4F4F4;
		}
		</style>
	</head>
	<body>
		<div id="tb" style="padding:5px;height:auto">
			<a class="easyui-linkbutton" iconCls="icon-edit" plain="true" href="javascript:showKeywordEditDiv();">修改关键词</a>
			<a class="easyui-linkbutton" iconCls="icon-back" plain="true" href="javascript:parent.toKeywordReply();">返回</a>
		</div>
		<!-- 关键词回复-->
		<div id="keywordReply">
			<dl id="keywordReplyDl">
			<dd>
			<p >关键词:<label id="keywordLabel">${keyword}</label></p>
			<hr/>
			</dd>
			<c:if test="${keywordReplyDetailListSize>0}">
			<c:forEach items="${keywordReplyDetailList}" var="keywordReplyDetail" varStatus="s">
				<dd id="dd${s.index}">
				<div style="border-left-width:2px;margin-top:0px;padding-left:20px;float:left;height:360px;" >
					<div id="replyContent${s.index}" class="replyContent">
					<!-- 关键词回复内容id -->
					<p>关键词回复内容id:<label id="id${s.index}" name='id${s.index}'>${keywordReplyDetail.id}</label></p>
						<p><label>回复内容</label>
						<label class="contentRadio"><input id="radioText${s.index}"  type="radio" name="replyContentType${s.index}" onclick="replyContentType(${s.index})" value="text"  class="content"/>文字</label>
						<label class="contentRadio"><input id="radioImage${s.index}" type="radio" name="replyContentType${s.index}" onclick="replyContentType(${s.index})" value="image" class="content"/>图片</label>
						<label class="contentRadio"><input type="button" id="saveButton${s.index}" name="saveButton${s.index}" onclick="saveReply(${s.index})" value="保存" style="width:80px"/></label>
						<label class="contentRadio"><input type="button" id="saveButton${s.index}" name="saveButton${s.index}" onclick="deleteReply(${s.index})" value="删除" style="width:80px"/></label>
						</p>
							<!-- 设置回复文字 -->
							<div id="replyContentTextareaDiv${s.index}">
								<p><textarea class="reg_input" name="replyContentTextarea${s.index}" id="replyContentTextarea${s.index}" 
								style="width:350px;height:180px;resize:none;margin-left:30px;"></textarea>
								<span id="replyContentTextarea${s.index}Tip" class="onshow"></span></p>
							</div>	
							<!-- 设置回复图片 -->
							<div id="replyContentImage${s.index}" class="hidden">
							    <table  id="imageTable${s.index}" class="imageTable">
									<tr>
										<td width="280">
											<img id="buttonImage${s.index}" alt="" src="">
										</td>
										<td  width="100">
											<a class="easyui-linkbutton" iconCls="icon-reload" plain="true" href="javascript:showImageWin(${s.index});">设置图片</a>
										</td>
									</tr>
								</table>
								<p>image_id:&nbsp;&nbsp;<label id="buttonImagID${s.index}" stype="width:200px"/></p>
							</div>		
					</div>	
				</div>
				<hr/>	
				</dd>		
			</c:forEach>
			</c:if>
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
				<!-- 修改关键词 -->
				<div id="keywordEditDiv" class="easyui-window" style="width:480px;height:260px;padding:10px;" 
						minimizable="false" maximizable="false" collapsible="false" closed="true">
					<table width="100%" border="0" cellpadding="0" cellspacing="0" style="margin-top:20px;">
						<tr>
							<td align="right">关键词：</td>
							<td style="margin-top: 10px;">
								<textarea class="reg_input" name="keywordTextarea" id="keywordTextarea" style="width:200px;height:100px;"></textarea>
								<span id="keywordTextareaTip" class="onshow"></span>
							</td>
						</tr>
						<tr height="20px"></tr>
						<tr height="40px">
							<td align="center" colspan="2">
								<a class="easyui-linkbutton" href="javascript:updateKeyword();">保存</a>
								<a class="easyui-linkbutton" href="javascript:hideKeywordEditDiv();">关闭</a>
							</td>
						</tr>
					</table>
				</div>
			</dl>
			<!-- 设置关键字 -->
			<div style="margin:20px 0px;">
						<a class="easyui-linkbutton" iconcls="icon-add" href="javascript:void(0);" onclick="addKeywordReply();">增加关键词回复</a>
			</div>
		</div>

		<script type="text/javascript">
		 var keywordIndex=0;//编辑的关键词回复
		 var keywordCount=0;//关键词回复总数
		 $(function(){
			 	 keywordCount=${keywordReplyDetailListSize};
			 	 var keywordReplyDetailList="${keywordReplyDetailList}";
			     $.formValidator.initConfig({validatorGroup:"keyword"});//关键词回复字数验证
			 	 toValidateKeyword();//关键词字数验证
				 <c:forEach items="${keywordReplyDetailList}" var="keywordReplyDetail" varStatus="s">
				 	 var keyword_text="${keywordReplyDetail.keywordText}";
					 var keyword_image_id="${keywordReplyDetail.keywordImageId}";
					 console.log(keyword_text);
					 console.log(keyword_image_id);
					 var index=${s.index};
					 $.formValidator.initConfig({validatorGroup:"${s.index}"});//关键字回复字数验证
					 toValidate("${s.index}");//关键词回复字数验证
					 var radioText=$("#radioText"+index);
					 var radioImage=$("#radioImage"+index);
					 if(keyword_image_id==0 || keyword_image_id==""){
						 radioText.prop("checked","checked");
						 replyContentType(index);
						 $("#replyContentTextarea"+index).val(keyword_text);
					 }else{
						 radioImage.prop("checked","checked");
						 replyContentType(index);
						 var getImage_url="/manager/weiXinReply/getKeywordImageUrl?keywordImageId="+keyword_image_id;
						 var msg=$.ajax({url:getImage_url,async:false});
						 if(msg.responseText==""){
							 alert("查询图片失败！");
						 }else{
							 var json=$.parseJSON( msg.responseText ) ;
							 var ImageMap=json.ImageMap;
							 var ImageUrl=ImageMap.pic;
							 console.log("ImageUrl:"+ImageUrl);
							 ImageUrl="upload/"+ImageUrl;
							 $("#buttonImage"+index).attr("src",ImageUrl);
						 } 
						 $("#buttonImagID"+index).html(keyword_image_id);
					 }
				  </c:forEach>
			});
		//关键词回复表单验证
		 function toValidate(index){ 
			$("#replyContentTextarea"+index).formValidator({validatorGroup:index,onShow:"1~600个字",onFocus:"1~600个字",onCorrect:"通过"}).inputValidator({min:1,max:1200,onError:"1~600个字"});
		} 
		//关键词表单验证
		 function toValidateKeyword(){ 
			$("#keywordTextarea").formValidator({validatorGroup:"keyword",onShow:"1~30个字",onFocus:"1~30个字",onCorrect:"通过"}).inputValidator({min:1,max:60,onError:"1~30个字"});
		} 
		//单选框
		   function replyContentType(index){
			   var ContentType=$("input[name=replyContentType"+index+"]:checked").val();
		 	   switch(ContentType){
		 	   case "text":
		 		   $("#replyContentTextareaDiv"+index).show();
				   $("#replyContentImage"+index).hide();
				   break;
		 	   case "image":
				   $("#replyContentTextareaDiv"+index).hide();
				   $("#replyContentImage"+index).show();
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
			function setImageMaterial(ImageUrl,image_id){
				ImageUrl="upload/"+ImageUrl;
				$("#buttonImage"+keywordIndex).attr("src",ImageUrl);
				$("#buttonImagID"+keywordIndex).html(image_id);
				hideImageWin();
			 }
			//设置图片
			function showImageWin(index){
				keywordIndex=index;
				$("#imageDiv").window({title:"设置图片",modal:true});
				queryImageMaterial();
				$("#imageDiv").window('open');
				$("#imageDiv").window('center');
			}
			function hideImageWin(){
				$("#imageDiv").window('close');
				$('#imageDatagrid').datagrid('reload');
			}		
	
			//保存关键词回复
			function saveReply(index){
				var ContentType=$("input[name=replyContentType"+index+"]:checked").val();
				var id=$("#id"+index).html();
			 	   switch(ContentType){
			 	   case "text":
			 		  $("#buttonImagID"+index).html("");
			 		  $("#buttonImage"+index).attr('src',""); 
			 		  var saveReply_url="/manager/weiXinReply/updateKeywordReply";
			 		  if ($.formValidator.pageIsValid(index.toString())){
							$.ajax({
								url:saveReply_url,
								data:{"id":id,"type":ContentType,"keyword":$("#keywordLabel").html(),"value":$("#replyContentTextarea"+index).val()},
								type:"post",
								success:function(data){
									if(data.state){
									    alert("保存成功!");
									    if(id=="0"){
									    	$("#id"+index).html(data.keywordReplyId);
									    }
									}else{
									    alert("保存失败");
									}
								}
							});
			 		  }
					   break;
			 	   case "image":
			 		 $("#replyContentTextarea"+index).val(""); 
			 		 var saveReply_url="/manager/weiXinReply/updateKeywordReply";
					 if($("#buttonImagID"+index).html()=="")  {
						 alert("请选择图片");
					 }else{
						 $.ajax({
								url:saveReply_url,
								data:{"id":id,"type":ContentType,"keyword":$("#keywordLabel").html(),"value":$("#buttonImagID"+index).html()},
								type:"post",
								success:function(data){
									if(data.state){
									    alert("保存成功!");
									    if(id=="0"){
									    	$("#id"+index).html(data.keywordReplyId);
									    }
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
			//删除关键词回复
			function deleteReply(index){
				var id=$("#id"+index).html();
				var deleteReply_url="/manager/weiXinReply/deleteKeywordReply";
				$.ajax({
					url:deleteReply_url,
					data:{"id":id},
					type:"post",
					success:function(data){
						if(data){
						    alert("删除成功!");
						    $("#dd"+index).remove();
						    keywordCount=keywordCount-1;
						}else{
						    alert("删除失败!");
						}
					}
			  });
			}
			//打开修改关键词窗口
			function showKeywordEditDiv(){
				$("#keywordEditDiv").window({title:"修改关键词",modal:true});
				$("#keywordEditDiv").window({top:100,left:$(window).width()/2-240});
				var keyword=$("#keywordLabel").html();
				$("#keywordTextarea").val(keyword);
				$("#keywordEditDiv").window('open');	
			}
			//关闭修改关键词窗口
			function hideKeywordEditDiv(){
				$("#keywordEditDiv").window('close');
			}
			//更新关键词
			function updateKeyword(){
				if($.formValidator.pageIsValid("keyword")){
					var updateKeyword_url="/manager/weiXinReply/updateKeyword";
					$.ajax({
						url:updateKeyword_url,
						data:{"keyword":$.trim($("#keywordTextarea").val()),"oldKeyword":$("#keywordLabel").html()},
						type:"post",
						success:function(data){
							if(data=="1"){
							    alert("保存成功!");
							    $("#keywordLabel").html($.trim($("#keywordTextarea").val()));
							    hideKeywordEditDiv();							    
							}else{
							    alert("保存失败");
							}
						}
				  }); 
				}
			}
			
			//增加关键词回复
			function addKeywordReply(){
				var strs = "<dd id=\"dd"+keywordCount+"\">";
				strs+="<div style=\"border-left-width:2px;margin-top:0px;padding-left:20px;float:left;height:360px;\" >";
				strs+="<div id=\"replyContent"+keywordCount+"\" class=\"replyContent\">";
				strs+="<p>关键词回复内容id:<label id=\"id"+keywordCount+"\" name='id"+keywordCount+"'>0</label></p>";
				strs+="<p><label>回复内容</label>";	
				strs+="<label class=\"contentRadio\"><input id=\"radioText"+keywordCount+"\"  type=\"radio\" name=\"replyContentType"+keywordCount+"\" onclick=\"replyContentType("+keywordCount+")\" value=\"text\"  class=\"content\"/>文字</label>";		
				strs+="<label class=\"contentRadio\"><input id=\"radioImage"+keywordCount+"\" type=\"radio\" name=\"replyContentType"+keywordCount+"\" onclick=\"replyContentType("+keywordCount+")\" value=\"image\" class=\"content\"/>图片</label>";	
				strs+="<label class=\"contentRadio\"><input type=\"button\" id=\"saveButton"+keywordCount+"\" name=\"saveButton"+keywordCount+"\" onclick=\"saveReply("+keywordCount+")\" value=\"保存\" style=\"width:80px\"/></label>";		
				strs+="<label class=\"contentRadio\"><input type=\"button\" id=\"saveButton"+keywordCount+"\" name=\"saveButton"+keywordCount+"\" onclick=\"deleteReply("+keywordCount+")\" value=\"删除\" style=\"width:80px\"/></label>";		
				strs+="</p>";	
				strs+="<div id=\"replyContentTextareaDiv"+keywordCount+"\">";		
				strs+="<p><textarea class=\"reg_input\" name=\"replyContentTextarea"+keywordCount+"\" id=\"replyContentTextarea"+keywordCount+"\"";			
				strs+="style=\"width:350px;height:180px;resize:none;margin-left:30px;\"></textarea>";				 
				strs+="<span id=\"replyContentTextarea"+keywordCount+"Tip\" class=\"onshow\"></span></p>";
				strs+="</div>";
				strs+="<div id=\"replyContentImage"+keywordCount+"\" class=\"hidden\">";				
				strs+="<table  id=\"imageTable"+keywordCount+"\" class=\"imageTable\">";			
				strs+="<tr>";			
				strs+="<td width=\"280\">";			    
				strs+="<img id=\"buttonImage"+keywordCount+"\" alt=\"\" src=\"\">";
				strs+="</td>";
				strs+="<td  width=\"100\">";
				strs+="<a class=\"easyui-linkbutton\" iconCls=\"icon-reload\" plain=\"true\" href=\"javascript:showImageWin("+keywordCount+");\">设置图片</a>";						
				strs+="</td>";						
				strs+="</tr>";						
				strs+="</table>";				
				strs+="<p>image_id:&nbsp;&nbsp;<label id=\"buttonImagID"+keywordCount+"\" stype=\"width:200px\"/></p>";					
				strs+="</div>";				
				strs+="</div>";				
				strs+="</div>";
				strs+="<hr/>";
				strs+="</dd>";
				$("#keywordReplyDl").append(strs);

				//滚动滚动条
                document.body.scrollTop =document.body.scrollHeight;

				$.formValidator.initConfig({validatorGroup:keywordCount.toString()});//关键字回复字数验证
				toValidate(keywordCount.toString());//关键字回复字数验证
				//单选框默认选择文本
				var radioText=$("#radioText"+keywordCount);
				radioText.prop("checked","checked");
				replyContentType(keywordCount);
				keywordCount=keywordCount+1;
			}
		</script>
	</body>
</html>
