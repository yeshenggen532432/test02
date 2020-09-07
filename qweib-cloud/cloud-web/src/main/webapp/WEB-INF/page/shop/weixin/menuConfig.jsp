<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>自定义菜单</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<meta name="referrer" content="never">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script src="<%=basePath%>/resource/clipboard.min.js"></script>
		<script type="text/javascript" src="resource/loadDiv.js"></script>
		<link href="${base}resource/shop/weixin/css/menuConfig.css" rel="stylesheet" type="text/css" />
	</head>
	<body>
		<div id="tb" style="padding:5px;height:auto">
			<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:addLeftButton();">增加左边菜单</a>
			<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:addMiddleButton();">增加中间菜单</a>
			<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:addRightButton();">增加右边菜单</a>
			<a class="easyui-linkbutton" iconCls="icon-save" plain="true" href="javascript:updateWeixinMenu();">发布微信公众号菜单</a>
			<a class="easyui-linkbutton" iconCls="icon-reload" plain="true" href="javascript:refresh();">刷新</a>
			<div hidden="true">divId:<input id="divId" type="text"/></div>
		</div>
		
		<!-- 菜单设置 -->
		<div class="box" style="width:40%;float:left">
		  <dl id="dl">
		  <dd>
			<table id="menuTable" class="table">
				<tr>
					<td><label>菜单</label></td>
      				<td><label>左边菜单</label></td>
			        <td><label>中间菜单</label></td>
      				<td><label>右边菜单</label></td>
	        	</tr>
				<tr>
					<td><label>子菜单5:</label></td>
      				<td><button id="left5"    onclick="left5()" ></button></td>
			        <td><button id="middle5"    onclick="middle5()" ></button></td>
			        <td><button id="right5"    onclick="right5()" ></button></td>
	        	</tr>
	        	<tr>
	        		<td><label>子菜单4:</label></td>
			        <td><button id="left4"    onclick="left4()" ></button></td>
			        <td><button id="middle4"    onclick="middle4()" ></button></td>
			        <td><button id="right4"    onclick="right4()" ></button></td>
			     </tr>
			     <tr>
			     	<td><label>子菜单3:</label></td>
      				<td><button id="left3"    onclick="left3()" ></button></td>
			        <td><button id="middle3"    onclick="middle3()" ></button></td>
			        <td><button id="right3"    onclick="right3()" ></button></td>
	        	</tr>
	        	<tr>
	        		<td><label>子菜单2:</label></td>
      				<td><button id="left2"    onclick="left2()" ></button></td>
			        <td><button id="middle2"    onclick="middle2()" ></button></td>
			        <td><button id="right2"    onclick="right2()" ></button></td>
	        	</tr>
	        	<tr>
	        		<td><label>子菜单1:</label></td>
      				<td><button id="left1"    onclick="left1()" ></button></td>
			        <td><button id="middle1"    onclick="middle1()" ></button></td>
			        <td><button id="right1"    onclick="right1()" ></button></td>
	        	</tr>
	        	<tr>
	        		<td><label>主菜单0:</label></td>
      				<td><button id="left0"    onclick="left0()"></button></td>
			        <td><button id="middle0"  onclick="middle0()" ></button></td>
			        <td><button id="right0"   onclick="right0()" ></button></td>
	        	</tr>
			</table>
			</dd>
			</dl>	
		</div>
		
		<!-- 菜单素材设置 -->
		
		<div id="menuMaterialEdit" >
				<p>按钮位置：<label id="buttonPosition"></label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				按钮号：<label id="buttonNo"></label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				按钮类型：<label id="buttonType"></label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			    <a class="easyui-linkbutton" iconCls="icon-save" plain="true" href="javascript:saveButtonMaterial();"><font size="3">保存</font></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			    <a class="easyui-linkbutton" iconCls="icon-delete" plain="true" href="javascript:deleteButtonMaterial();"><font size="3">删除</font></a></p>
				<hr color="E7E7EB" size="2"/>
				<form action="" name="menuMaterialEditForm" id="menuMaterialEditForm" method="post" >
				<p id="menuButtonName"><label>菜单名称&nbsp;&nbsp;&nbsp;</label><input type="text"  class="reg_input"  id="buttonName" /><span id="buttonNameTip" class="onshow"></span></p>
				</form>
				<hr color="E7E7EB" size="2"/>
				<p><label>菜单内容</label>
				<label class="contentRadio"><input type="radio" name="buttonMaterialContentType" onclick="buttonMaterialContentType()" value="url" class="content"/>跳转网页</label>
				<label class="contentRadio"><input type="radio" name="buttonMaterialContentType" onclick="buttonMaterialContentType()" value="text" class="content"/>文字</label>
				<label class="contentRadio"><input type="radio" name="buttonMaterialContentType" onclick="buttonMaterialContentType()" value="image" class="content"/>图片</label>
				<label class="contentRadio"><input type="radio" name="buttonMaterialContentType" onclick="buttonMaterialContentType()" value="news" class="content"/>图文消息</label>
				</p>
				<div id="buttonMaterialContent" class="">
					<div id="buttonMaterialContentView" class="hidden">
						<p><label>订阅者点击该子菜单会跳到以下链接</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<a class="easyui-linkbutton" iconCls="icon-edit" plain="true" href="javascript:setQWBShopUrl();">设置为商城首页</a>
						</p>
						<p><label>页面地址</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="text" id="buttonMaterialContentUrl" class="menuName" />
							<span id="buttonMaterialContentUrlTip" class="onshow"></span></p>
					</div>
					<div id="menuButtonMaterialContentTextarea">
					
						<p><textarea class="reg_input" name="buttonMaterialContentTextarea" id="buttonMaterialContentTextarea" 
						style="width:350px;height:180px;resize:none;margin-left:30px;"></textarea>
						<span id="buttonMaterialContentTextareaTip" class="onshow"></span></p>
					</div>	
					<div id="menuButtonMaterialContentImage" class="hidden">
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
						<p>image_id:&nbsp;&nbsp;&nbsp;<lable id="buttonImagID" stype="width:200px"/></p>
					</div>	
					<div id="menuButtonMaterialContentNews">
					    <table  id="newsTable">
							<tr>
								<td width="280">
									<img id="buttonNewsImage" alt="" src="">
								</td>
								<td width="170">
									<lable id="buttonNewsTitle"></lable>
								</td>
								<td  width="100">
								<a class="easyui-linkbutton" iconCls="icon-reload" plain="true" href="javascript:showNewsWin();">设置图文</a>
								</td>
							</tr>
						</table>
						<p>image_id&nbsp;&nbsp;&nbsp;<lable  id="buttonNewsImageID" stype="width:200px"/></p>
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
		<!-- 设置图文消息素材 -->
		<div id="newsDiv" class="easyui-window" style="width:800px;height:400px;padding:10px;" 
			minimizable="false" maximizable="false" collapsible="false" closed="true">
			<table id="newsDatagrid" class="easyui-datagrid" fit="true" singleSelect="false" border="false"		 
			rownumbers="true" fitColumns="false" pagination="true" 
			pageSize=5 pageList="[5,10]" nowrap="false" toolbar="#newsTb">
			<thead>
				<tr>
					<th field="media_id" width="300" align="center" hidden="true">
						素材id
					</th>
					<th field="thumb" width="300" align="center" formatter="newsImgFormatter">
						封面
					</th>
					<th field="title" width="200" align="center" formatter="newsTitleFormatter">
						标题
					</th>
			    	<th field="setNews" width="80" align="center" formatter="newsSetFormatter">
						设置
					</th> 
				</tr>
			</thead>
		</table>
		<div id="newsTb" style="padding:5px;height:auto">
			图文消息&nbsp(共<label id="newsNum">${news_count}</label>条)
		</div>
		</div>	
		<script type="text/javascript">
		 $(function(){
				clearMenuMaterial();
				toValidate();
				queryMenuButton();
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
		 
		 //查询菜单按钮
		 function queryMenuButton(){
			var getMenuButton_url="/manager/getMenuButton";
			var msg=$.ajax({url:getMenuButton_url,async:false});
			var json=$.parseJSON( msg.responseText ) ;
			var leftButtonList=json.leftButtonList;
			var middleButtonList=json.middleButtonList;
			var rightButtonList=json.rightButtonList;
		 	for(var i=0;i<json.leftButtonNum;i++){
				$("#"+leftButtonList[i].position+leftButtonList[i].button_no).html(leftButtonList[i].name);
				$("#"+leftButtonList[i].position+leftButtonList[i].button_no).show();
			}
			for(var i=0;i<json.middleButtonNum;i++){
				$("#"+middleButtonList[i].position+middleButtonList[i].button_no).html(middleButtonList[i].name);
				$("#"+middleButtonList[i].position+middleButtonList[i].button_no).show();
			} 
			for(var i=0;i<json.rightButtonNum;i++){
				$("#"+rightButtonList[i].position+rightButtonList[i].button_no).html(rightButtonList[i].name);
				$("#"+rightButtonList[i].position+rightButtonList[i].button_no).show();
			}
		 }
		 
			//表单验证
			 function toValidate(){ 
				$.formValidator.initConfig({validatorGroup:"1"});
				$.formValidator.initConfig({validatorGroup:"2"});
				$.formValidator.initConfig({validatorGroup:"3"});
				if($("#buttonNo").html()=="0"){
					$("#buttonName").formValidator({validatorGroup:"1",onShow:"1~4个字或1~8个字母",onFocus:"1~4个字或1~8个字母",onCorrect:"通过"}).inputValidator({min:1,max:8,onError:"1~4个字或1~8个字母"});	
				}else{
					$("#buttonName").formValidator({validatorGroup:"1",onShow:"1~8个字或1~16个字母",onFocus:"1~8个字或1~16个字母",onCorrect:"通过"}).inputValidator({min:1,max:16,onError:"1~8个字或1~16个字母"});
				}
				$("#buttonMaterialContentUrl").formValidator({validatorGroup:"2",onShow:"1~2083个字符",onFocus:"1~2083个字符",onCorrect:"通过"}).inputValidator({min:1,max:2083,onError:"1~2083个字符"});
				$("#buttonMaterialContentTextarea").formValidator({validatorGroup:"3",onShow:"1~600个字",onFocus:"1~600个字",onCorrect:"通过"}).inputValidator({min:1,max:1200,onError:"1~600个字"});
				
			} 
		//增加左边菜单
		function addLeftButton(){
			if($("#left0").is(':hidden()')){
				$("#left0").show();
				clearMenuMaterial();
				$("#buttonPosition").html("left");
				$("#buttonNo").html("0");
				toValidate();
				$("#buttonType").html("url");
				$("input[name=buttonMaterialContentType][value=url]").attr("checked",true);
			}else{
				if($("#left0").html()==""){
					alert("左边主菜单还未设置！");
					return;
				}else{
					for(var i=1;i<=5;i++){
						if($("#left"+i).is(':hidden()')){
							$("#left"+i).show();
							clearMenuMaterial();
							$("#buttonPosition").html("left");
							$("#buttonNo").html(i);
							$("#buttonType").html("url");
							return;
						}else{
							if($("#left"+i).html()==""){
								alert("左边子菜单"+i+"还未设置！");
								return;
							}
						}
					}
					alert("左边菜单已满!");
				}	
			}
			
		}
		//增加中间菜单
		function addMiddleButton(){
			if($("#left0").html()==""){
				alert("左边主菜单还未设置!");
				return;
			}else{
				if($("#middle0").is(':hidden()')){
					$("#middle0").show();
					clearMenuMaterial();
					$("#buttonPosition").html("middle");
					$("#buttonNo").html("0");
					$("#buttonType").html("url");
				}else{
					if($("#middle0").html()==""){
						alert("中间主菜单还未设置！");
						return;
					}else{
						for(var i=1;i<=5;i++){
							if($("#middle"+i).is(':hidden()')){
								$("#middle"+i).show();
								clearMenuMaterial();
								$("#buttonPosition").html("middle");
								$("#buttonNo").html(i);
								$("#buttonType").html("url");
								return;
							}else{
								if($("#middle"+i).html()==""){
									alert("中间子菜单"+i+"还未设置！");
									return;
								}
							}
						}
						alert("中间菜单已满!");
					}	
				}
			}
		}
		//增加右边菜单
		function addRightButton(){
			if($("#middle0").html()==""){
				alert("中间主菜单还未设置!");
				return;
			}else{
				if($("#right0").is(':hidden()')){
					$("#right0").show();
					clearMenuMaterial();
					$("#buttonPosition").html("right");
					$("#buttonNo").html("0");
					$("#buttonType").html("url");
				}else{
					if($("#right0").html()==""){
						alert("右边主菜单还未设置！");
						return;
					}else{
						for(var i=1;i<=5;i++){
							if($("#right"+i).is(':hidden()')){
								$("#right"+i).show();
								clearMenuMaterial();
								$("#buttonPosition").html("right");
								$("#buttonNo").html(i);
								$("#buttonType").html("url");
								return;
							}else{
								if($("#right"+i).html()==""){
									alert("右边子菜单"+i+"还未设置！");
									return;
								}
							}
						}
						alert("右边菜单已满!");
					}	
				}
			}
		}
		   //清空菜单素材页面
		   function clearMenuMaterial(){
			   $("#buttonPosition").html("");
			   $("#buttonNo").html("");
			   $("#buttonType").html("");
			   $("#buttonName").val("");
			   $('input:radio[name=buttonMaterialContentType]').attr('checked',false);
			   $("#buttonMaterialContentTextarea").val("");
			   $("#buttonMaterialContentUrl").val("");
			   $("#buttonImage").attr('src',""); 
			   $("#buttonImagID").html("");
			   $("#buttonNews").attr('src',"");  
			   $("#buttonNewsTitle").html("");
			   $("#buttonNewsImageID").html("");

               $("input[name=buttonMaterialContentType][value=url]").attr("checked",true);
			   $("#buttonMaterialContentView").show();
			   $("#menuButtonMaterialContentTextarea").hide();
			   $("#menuButtonMaterialContentImage").hide();
			   $("#menuButtonMaterialContentNews").hide();
			   //清空图片、视频素材
		   }
		   function toWeixinLogin(){
			var get_url="/manager/getWeixinLoginUrl?getWeixinLoginUrl=1";
			var msg=$.ajax({url:get_url,async:false});
			var json=$.parseJSON(msg.responseText);
			var url=json.url;
		    parent.add('微信公众平台',url);
		   }
		   function showMaterial(){				
				 //获取图片素材列表
				 
			    var url="/toPhotoMaterialPage";
			    parent.add('素材管理',url);				
		   }
		   function refresh(){
			   location.reload();
		   }
		   //单选框
		   function buttonMaterialContentType(){
			   var ContentType=$("input[name=buttonMaterialContentType]:checked").val();
		 	   $("#buttonType").html(ContentType);
		 	   switch(ContentType){
		 	   case "url":
		 		   $("#buttonMaterialContentView").show();
				   $("#menuButtonMaterialContentTextarea").hide();
				   $("#menuButtonMaterialContentImage").hide();
				   $("#menuButtonMaterialContentNews").hide();
				   break;
		 	   case "text":
		 		   $("#buttonMaterialContentView").hide();
				   $("#menuButtonMaterialContentTextarea").show();
				   $("#menuButtonMaterialContentImage").hide();
				   $("#menuButtonMaterialContentNews").hide();
				   break;
		 	   case "image":
		 		   $("#buttonMaterialContentView").hide();
				   $("#menuButtonMaterialContentTextarea").hide();
				   $("#menuButtonMaterialContentImage").show();
				   $("#menuButtonMaterialContentNews").hide();
				   break;
		 	   case "news":
		 		   $("#buttonMaterialContentView").hide();
				   $("#menuButtonMaterialContentTextarea").hide();
				   $("#menuButtonMaterialContentImage").hide();
				   $("#menuButtonMaterialContentNews").show();
				   break;
		 	   default:break;
		 	   }
		 	
		   }
		   //保存按钮素材
		   function saveButtonMaterial(){  
			   var saveButtonMaterial_url="/manager/saveButtonMaterial";
			   var position=$("#buttonPosition").html();
			   var button_no=$("#buttonNo").html();
			   if( position=="" ||  button_no==""){
				   alert("菜单没有按钮,请新增按钮！");
				   return;
			   }
			   var type=$("#buttonType").html();
			   var name=$("#buttonName").val();
			  if( type==""){
				  alert("请选择菜单类型！");
				  return;
			  }
			   switch(type){
			   case "url":
				   var value=$("#buttonMaterialContentUrl").val();
				   var image_url="";
				   var news_title="";
				   if ($.formValidator.pageIsValid("1")==true && $.formValidator.pageIsValid("2")==true){
						$.ajax({
							url:saveButtonMaterial_url,
							data:{"position":position,"button_no":button_no,"name":name,"type":type,"value":value,"iamge_url":image_url,"news_title":news_title},
							type:"post",
							success:function(data){
								if(data=="1"){
									$("#"+position+button_no).html(name);  
								    alert("保存成功!");
								}else{
								    alert("保存失败");
								}
							}
						});
					}
				   break;
			   case "text":
				   var value=$("#buttonMaterialContentTextarea").val();
				   var image_url="";
				   var news_title="";
				   if ($.formValidator.pageIsValid("1")==true && $.formValidator.pageIsValid("3")==true){
						$.ajax({
							url:saveButtonMaterial_url,
							data:"position="+position+"&button_no="+button_no+"&name="+name+"&type="+type+"&value="+value+"&image_url"+image_url+"&news_title"+news_title,
							type:"post",
							success:function(data){
								if(data=="1"){
									$("#"+position+button_no).html(name);  
								    alert("保存成功!");
								}else{
								    alert("保存失败");
								}
							}
						});
					}
				   break;
			   case "image":
				   var value=$("#buttonImagID").html();
				   var image_url=$("#buttonImage").attr("src");
				   var news_title="";
				   if ($.formValidator.pageIsValid("1")==true){
						$.ajax({
							url:saveButtonMaterial_url,
							data:"position="+position+"&button_no="+button_no+"&name="+name+"&type="+type+"&value="+value+"&image_url="+image_url+"&news_title="+news_title,
							type:"post",
							success:function(data){
								if(data=="1"){
									$("#"+position+button_no).html(name);  
								    alert("保存成功!");
								}else{
								    alert("保存失败");
								}
							}
						});
					}
				   break;
			   case "news":
				   var value=$("#buttonNewsImageID").html();
				   var image_url=$("#buttonNewsImage").attr("src"); 
				   var news_title=$("#buttonNewsTitle").html();
				   if ($.formValidator.pageIsValid("1")==true){
						$.ajax({
							url:saveButtonMaterial_url,
							data:"position="+position+"&button_no="+button_no+"&name="+name+"&type="+type+"&value="+value+"&image_url="+image_url+"&news_title="+news_title,
							type:"post",
							success:function(data){
								if(data=="1"){
									$("#"+position+button_no).html(name);  
								    alert("保存成功!");
								}else{
								    alert("保存失败");
								}
							}
						});
					}
				   break;
			   }	 
			  }
				   
			 //查询图片			
			function queryImageMaterial(){ 
				  $('#imageDatagrid').datagrid({  
					    url:"/manager/WeixinConfig/imagePage" 
					});
			  }
			 //查询图文
			 function queryNewsMaterial(){
				  var msg=$.ajax({url:"/manager/getMaterialCount",async:false});
				  var json=$.parseJSON(msg.responseText);
				  var news_count=json.news_count;
				  $("#newsNum").html(news_count);	
				  $('#newsDatagrid').datagrid({  
					    url:"/manager/getMaterialList",
					    queryParams:{  
					        type:"news",  
					        total:news_count
					    }  
					});
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
			//设置图文
			function newsImgFormatter(val,row,index){
				if(val!=""){
					var thumb_photo= row.content.news_item[0].thumb_url;
					return "<input  type=\"image\" src=\""+""+thumb_photo+"\" height=\"180\" width=\"280\" align=\"middle\" style=\"margin-top:10px;margin-bottom:10px;\"/>";  
				}
			}
			function newsTitleFormatter(val,row){
				 return row.content.news_item[0].title;           
			}
			function newsSetFormatter(val,row,index){
				var thumbImageUrl=row.content.news_item[0].thumb_url;
				var title=row.content.news_item[0].title;
				var media_id=row.media_id;
				thumbImageUrl=JSON.stringify(thumbImageUrl);
				title = JSON.stringify(title); 
				media_id=JSON.stringify(media_id);
				return "<input style='width:60px;height:27px' type='button' value='设置' onclick='setNewsMaterial("+thumbImageUrl+","+title+","+media_id+")' />";	
			}	
			function setNewsMaterial(thumbImageUrl,title,image_id){
				$("#buttonNewsImage").attr("src",thumbImageUrl);
				$("#buttonNewsTitle").html(title);
				$("#buttonNewsImageID").html(image_id);
				hideNewsWin(); 
			}
			function showNewsWin(){
				$("#newsDiv").window({title:"设置图文",modal:true});
				queryNewsMaterial();
				$("#newsDiv").window('open');
				$("#newsDiv").window('center');
			}
			function hideNewsWin(){
				$("#newsDiv").window('close');
			}
			function left0(){
				if($("#buttonPosition").html()!="left" ||  $("#buttonNo").html()!="0"){
					clearMenuMaterial();
					var getMenuButtonMaterial_url="/manager/getMenuButtonMaterial?position=left&button_no=0";
					var msg=$.ajax({url:getMenuButtonMaterial_url,async:false});
					var json=$.parseJSON( msg.responseText ) ;
					var buttonMaterialMap=json.buttonMaterialMap;
					if(json.state){
						$("#buttonPosition").html(buttonMaterialMap.position);
						$("#buttonNo").html(buttonMaterialMap.button_no);
						$("#buttonName").val(buttonMaterialMap.name);
						$("#buttonType").html(buttonMaterialMap.type);
						switch(buttonMaterialMap.type){
						case "url":
							 $("input[name=buttonMaterialContentType][value=url]").attr("checked",true);
							 $("#buttonMaterialContentUrl").val(buttonMaterialMap.url);
							 break;
						case "text":
							 $("input[name=buttonMaterialContentType][value=text]").attr("checked",true);
							 $("#buttonMaterialContentTextarea").val(buttonMaterialMap.text);
							 $("#buttonMaterialContentView").hide();
					         $("#menuButtonMaterialContentTextarea").show();
					         $("#menuButtonMaterialContentImage").hide();
					         $("#menuButtonMaterialContentNews").hide();
							 break;
						case "image":
							$("input[name=buttonMaterialContentType][value=image]").attr("checked",true);
							$("#buttonImagID").html(buttonMaterialMap.image_id);
							$("#buttonImage").attr('src',buttonMaterialMap.image_url); 
							$("#buttonMaterialContentView").hide();
					        $("#menuButtonMaterialContentTextarea").hide();
					        $("#menuButtonMaterialContentImage").show();
					        $("#menuButtonMaterialContentNews").hide();
							 break;
						case "news":
							$("input[name=buttonMaterialContentType][value=news]").attr("checked",true);
							$("#buttonNewsImageID").html(buttonMaterialMap.media_id);
							$("#buttonNewsImage").attr('src',buttonMaterialMap.image_url);
							$("#buttonNewsTitle").html(buttonMaterialMap.news_title);
							 break;
						default : 
							break;
						}
					}else{
						alert("查询按钮素材失败！");
					}
				}	 
			}
			function left1(){
				if($("#buttonPosition").html()!="left" ||  $("#buttonNo").html()!="1"){
					clearMenuMaterial();
					var getMenuButtonMaterial_url="/manager/getMenuButtonMaterial?position=left&button_no=1";
					var msg=$.ajax({url:getMenuButtonMaterial_url,async:false});
					var json=$.parseJSON( msg.responseText ) ;
					var buttonMaterialMap=json.buttonMaterialMap;
					if(json.state){
						$("#buttonPosition").html(buttonMaterialMap.position);
						$("#buttonNo").html(buttonMaterialMap.button_no);
						$("#buttonName").val(buttonMaterialMap.name);
						$("#buttonType").html(buttonMaterialMap.type);
						switch(buttonMaterialMap.type){
						case "url":
							 $("input[name=buttonMaterialContentType][value=url]").attr("checked",true);
							 $("#buttonMaterialContentUrl").val(buttonMaterialMap.url);
							 break;
						case "text":
							 $("input[name=buttonMaterialContentType][value=text]").attr("checked",true);
							 $("#buttonMaterialContentTextarea").val(buttonMaterialMap.text);
							 $("#buttonMaterialContentView").hide();
					         $("#menuButtonMaterialContentTextarea").show();
					         $("#menuButtonMaterialContentImage").hide();
					         $("#menuButtonMaterialContentNews").hide();
							 break;
						case "image":
							$("input[name=buttonMaterialContentType][value=image]").attr("checked",true);
							$("#buttonImagID").html(buttonMaterialMap.image_id);
							$("#buttonImage").attr('src',buttonMaterialMap.image_url); 
							$("#buttonMaterialContentView").hide();
					        $("#menuButtonMaterialContentTextarea").hide();
					        $("#menuButtonMaterialContentImage").show();
					        $("#menuButtonMaterialContentNews").hide();
							 break;
						case "news":
							$("input[name=buttonMaterialContentType][value=news]").attr("checked",true);
							$("#buttonNewsImageID").html(buttonMaterialMap.media_id);
							$("#buttonNewsImage").attr('src',buttonMaterialMap.image_url);
							$("#buttonNewsTitle").html(buttonMaterialMap.news_title);
							$("#buttonMaterialContentView").hide();
					        $("#menuButtonMaterialContentTextarea").hide();
					        $("#menuButtonMaterialContentImage").hide();
					        $("#menuButtonMaterialContentNews").show();
							 break;
						default : 
							break;
						}
					}else{
						alert("查询按钮素材失败！");
					}
				}	 
			}
			function left2(){
				if($("#buttonPosition").html()!="left" ||  $("#buttonNo").html()!="2"){
					clearMenuMaterial();
					var getMenuButtonMaterial_url="/manager/getMenuButtonMaterial?position=left&button_no=2";
					var msg=$.ajax({url:getMenuButtonMaterial_url,async:false});
					var json=$.parseJSON( msg.responseText ) ;
					var buttonMaterialMap=json.buttonMaterialMap;
					if(json.state){
						$("#buttonPosition").html(buttonMaterialMap.position);
						$("#buttonNo").html(buttonMaterialMap.button_no);
						$("#buttonName").val(buttonMaterialMap.name);
						$("#buttonType").html(buttonMaterialMap.type);
						switch(buttonMaterialMap.type){
						case "url":
							 $("input[name=buttonMaterialContentType][value=url]").attr("checked",true);
							 $("#buttonMaterialContentUrl").val(buttonMaterialMap.url);
							 break;
						case "text":
							 $("input[name=buttonMaterialContentType][value=text]").attr("checked",true);
							 $("#buttonMaterialContentTextarea").val(buttonMaterialMap.text);
							 $("#buttonMaterialContentView").hide();
					         $("#menuButtonMaterialContentTextarea").show();
					         $("#menuButtonMaterialContentImage").hide();
					         $("#menuButtonMaterialContentNews").hide();
							 break;
						case "image":
							$("input[name=buttonMaterialContentType][value=image]").attr("checked",true);
							$("#buttonImagID").html(buttonMaterialMap.image_id);
							$("#buttonImage").attr('src',buttonMaterialMap.image_url); 
							$("#buttonMaterialContentView").hide();
					        $("#menuButtonMaterialContentTextarea").hide();
					        $("#menuButtonMaterialContentImage").show();
					        $("#menuButtonMaterialContentNews").hide();
							 break;
						case "news":
							$("input[name=buttonMaterialContentType][value=news]").attr("checked",true);
							$("#buttonNewsImageID").html(buttonMaterialMap.media_id);
							$("#buttonNewsImage").attr('src',buttonMaterialMap.image_url);
							$("#buttonNewsTitle").html(buttonMaterialMap.news_title);
							$("#buttonMaterialContentView").hide();
					        $("#menuButtonMaterialContentTextarea").hide();
					        $("#menuButtonMaterialContentImage").hide();
					        $("#menuButtonMaterialContentNews").show();
							 break;
						default : 
							break;
						}
					}else{
						alert("查询按钮素材失败！");
					}
				}	 
			}
			function left3(){
				if($("#buttonPosition").html()!="left" ||  $("#buttonNo").html()!="3"){
					clearMenuMaterial();
					var getMenuButtonMaterial_url="/manager/getMenuButtonMaterial?position=left&button_no=3";
					var msg=$.ajax({url:getMenuButtonMaterial_url,async:false});
					var json=$.parseJSON( msg.responseText ) ;
					var buttonMaterialMap=json.buttonMaterialMap;
					if(json.state){
						$("#buttonPosition").html(buttonMaterialMap.position);
						$("#buttonNo").html(buttonMaterialMap.button_no);
						$("#buttonName").val(buttonMaterialMap.name);
						$("#buttonType").html(buttonMaterialMap.type);
						switch(buttonMaterialMap.type){
						case "url":
							 $("input[name=buttonMaterialContentType][value=url]").attr("checked",true);
							 $("#buttonMaterialContentUrl").val(buttonMaterialMap.url);
							 break;
						case "text":
							 $("input[name=buttonMaterialContentType][value=text]").attr("checked",true);
							 $("#buttonMaterialContentTextarea").val(buttonMaterialMap.text);
							 $("#buttonMaterialContentView").hide();
					         $("#menuButtonMaterialContentTextarea").show();
					         $("#menuButtonMaterialContentImage").hide();
					         $("#menuButtonMaterialContentNews").hide();
							 break;
						case "image":
							$("input[name=buttonMaterialContentType][value=image]").attr("checked",true);
							$("#buttonImagID").html(buttonMaterialMap.image_id);
							$("#buttonImage").attr('src',buttonMaterialMap.image_url); 
							$("#buttonMaterialContentView").hide();
					        $("#menuButtonMaterialContentTextarea").hide();
					        $("#menuButtonMaterialContentImage").show();
					        $("#menuButtonMaterialContentNews").hide();
							 break;
						case "news":
							$("input[name=buttonMaterialContentType][value=news]").attr("checked",true);
							$("#buttonNewsImageID").html(buttonMaterialMap.media_id);
							$("#buttonNewsImage").attr('src',buttonMaterialMap.image_url);
							$("#buttonNewsTitle").html(buttonMaterialMap.news_title);
							$("#buttonMaterialContentView").hide();
					        $("#menuButtonMaterialContentTextarea").hide();
					        $("#menuButtonMaterialContentImage").hide();
					        $("#menuButtonMaterialContentNews").show();
							 break;
						default : 
							break;
						}
					}else{
						alert("查询按钮素材失败！");
					}
				}	 
			}
			function left4(){
				if($("#buttonPosition").html()!="left" ||  $("#buttonNo").html()!="4"){
					clearMenuMaterial();
					var getMenuButtonMaterial_url="/manager/getMenuButtonMaterial?position=left&button_no=4";
					var msg=$.ajax({url:getMenuButtonMaterial_url,async:false});
					var json=$.parseJSON( msg.responseText ) ;
					var buttonMaterialMap=json.buttonMaterialMap;
					if(json.state){
						$("#buttonPosition").html(buttonMaterialMap.position);
						$("#buttonNo").html(buttonMaterialMap.button_no);
						$("#buttonName").val(buttonMaterialMap.name);
						$("#buttonType").html(buttonMaterialMap.type);
						switch(buttonMaterialMap.type){
						case "url":
							 $("input[name=buttonMaterialContentType][value=url]").attr("checked",true);
							 $("#buttonMaterialContentUrl").val(buttonMaterialMap.url);
							 break;
						case "text":
							 $("input[name=buttonMaterialContentType][value=text]").attr("checked",true);
							 $("#buttonMaterialContentTextarea").val(buttonMaterialMap.text);
							 $("#buttonMaterialContentView").hide();
					         $("#menuButtonMaterialContentTextarea").show();
					         $("#menuButtonMaterialContentImage").hide();
					         $("#menuButtonMaterialContentNews").hide();
							 break;
						case "image":
							$("input[name=buttonMaterialContentType][value=image]").attr("checked",true);
							$("#buttonImagID").html(buttonMaterialMap.image_id);
							$("#buttonImage").attr('src',buttonMaterialMap.image_url); 
							$("#buttonMaterialContentView").hide();
					        $("#menuButtonMaterialContentTextarea").hide();
					        $("#menuButtonMaterialContentImage").show();
					        $("#menuButtonMaterialContentNews").hide();
							 break;
						case "news":
							$("input[name=buttonMaterialContentType][value=news]").attr("checked",true);
							$("#buttonNewsImageID").html(buttonMaterialMap.media_id);
							$("#buttonNewsImage").attr('src',buttonMaterialMap.image_url);
							$("#buttonNewsTitle").html(buttonMaterialMap.news_title);
							$("#buttonMaterialContentView").hide();
					        $("#menuButtonMaterialContentTextarea").hide();
					        $("#menuButtonMaterialContentImage").hide();
					        $("#menuButtonMaterialContentNews").show();
							 break;
						default : 
							break;
						}
					}else{
						alert("查询按钮素材失败！");
					}
				}	 
			}
			function left5(){
				if($("#buttonPosition").html()!="left" ||  $("#buttonNo").html()!="5"){
					clearMenuMaterial();
					var getMenuButtonMaterial_url="/manager/getMenuButtonMaterial?position=left&button_no=5";
					var msg=$.ajax({url:getMenuButtonMaterial_url,async:false});
					var json=$.parseJSON( msg.responseText ) ;
					var buttonMaterialMap=json.buttonMaterialMap;
					if(json.state){
						$("#buttonPosition").html(buttonMaterialMap.position);
						$("#buttonNo").html(buttonMaterialMap.button_no);
						$("#buttonName").val(buttonMaterialMap.name);
						$("#buttonType").html(buttonMaterialMap.type);
						switch(buttonMaterialMap.type){
						case "url":
							 $("input[name=buttonMaterialContentType][value=url]").attr("checked",true);
							 $("#buttonMaterialContentUrl").val(buttonMaterialMap.url);
							 break;
						case "text":
							 $("input[name=buttonMaterialContentType][value=text]").attr("checked",true);
							 $("#buttonMaterialContentTextarea").val(buttonMaterialMap.text);
							 $("#buttonMaterialContentView").hide();
					         $("#menuButtonMaterialContentTextarea").show();
					         $("#menuButtonMaterialContentImage").hide();
					         $("#menuButtonMaterialContentNews").hide();
							 break;
						case "image":
							$("input[name=buttonMaterialContentType][value=image]").attr("checked",true);
							$("#buttonImagID").html(buttonMaterialMap.image_id);
							$("#buttonImage").attr('src',buttonMaterialMap.image_url); 
							$("#buttonMaterialContentView").hide();
					        $("#menuButtonMaterialContentTextarea").hide();
					        $("#menuButtonMaterialContentImage").show();
					        $("#menuButtonMaterialContentNews").hide();
							 break;
						case "news":
							$("input[name=buttonMaterialContentType][value=news]").attr("checked",true);
							$("#buttonNewsImageID").html(buttonMaterialMap.media_id);
							$("#buttonNewsImage").attr('src',buttonMaterialMap.image_url);
							$("#buttonNewsTitle").html(buttonMaterialMap.news_title);
							$("#buttonMaterialContentView").hide();
					        $("#menuButtonMaterialContentTextarea").hide();
					        $("#menuButtonMaterialContentImage").hide();
					        $("#menuButtonMaterialContentNews").show();
							 break;
						default : 
							break;
						}
					}else{
						alert("查询按钮素材失败！");
					}
				}	 
			}
			function middle0(){
				if($("#buttonPosition").html()!="middle" ||  $("#buttonNo").html()!="0"){
					clearMenuMaterial();
					var getMenuButtonMaterial_url="/manager/getMenuButtonMaterial?position=middle&button_no=0";
					var msg=$.ajax({url:getMenuButtonMaterial_url,async:false});
					var json=$.parseJSON( msg.responseText ) ;
					var buttonMaterialMap=json.buttonMaterialMap;
					if(json.state){
						$("#buttonPosition").html(buttonMaterialMap.position);
						$("#buttonNo").html(buttonMaterialMap.button_no);
						$("#buttonName").val(buttonMaterialMap.name);
						$("#buttonType").html(buttonMaterialMap.type);
						switch(buttonMaterialMap.type){
						case "url":
							 $("input[name=buttonMaterialContentType][value=url]").attr("checked",true);
							 $("#buttonMaterialContentUrl").val(buttonMaterialMap.url);
							 break;
						case "text":
							 $("input[name=buttonMaterialContentType][value=text]").attr("checked",true);
							 $("#buttonMaterialContentTextarea").val(buttonMaterialMap.text);
							 $("#buttonMaterialContentView").hide();
					         $("#menuButtonMaterialContentTextarea").show();
					         $("#menuButtonMaterialContentImage").hide();
					         $("#menuButtonMaterialContentNews").hide();
							 break;
						case "image":
							$("input[name=buttonMaterialContentType][value=image]").attr("checked",true);
							$("#buttonImagID").html(buttonMaterialMap.image_id);
							$("#buttonImage").attr('src',buttonMaterialMap.image_url); 
							$("#buttonMaterialContentView").hide();
					        $("#menuButtonMaterialContentTextarea").hide();
					        $("#menuButtonMaterialContentImage").show();
					        $("#menuButtonMaterialContentNews").hide();
							 break;
						case "news":
							$("input[name=buttonMaterialContentType][value=news]").attr("checked",true);
							$("#buttonNewsImageID").html(buttonMaterialMap.media_id);
							$("#buttonNewsImage").attr('src',buttonMaterialMap.image_url);
							$("#buttonNewsTitle").html(buttonMaterialMap.news_title);
							$("#buttonMaterialContentView").hide();
					        $("#menuButtonMaterialContentTextarea").hide();
					        $("#menuButtonMaterialContentImage").hide();
					        $("#menuButtonMaterialContentNews").show();
							 break;
						default : 
							break;
						}
					}else{
						alert("查询按钮素材失败！");
					}
				}	 
			}
			function middle1(){
				if($("#buttonPosition").html()!="middle" ||  $("#buttonNo").html()!="1"){
					clearMenuMaterial();
					var getMenuButtonMaterial_url="/manager/getMenuButtonMaterial?position=middle&button_no=1";
					var msg=$.ajax({url:getMenuButtonMaterial_url,async:false});
					var json=$.parseJSON( msg.responseText ) ;
					var buttonMaterialMap=json.buttonMaterialMap;
					if(json.state){
						$("#buttonPosition").html(buttonMaterialMap.position);
						$("#buttonNo").html(buttonMaterialMap.button_no);
						$("#buttonName").val(buttonMaterialMap.name);
						$("#buttonType").html(buttonMaterialMap.type);
						switch(buttonMaterialMap.type){
						case "url":
							 $("input[name=buttonMaterialContentType][value=url]").attr("checked",true);
							 $("#buttonMaterialContentUrl").val(buttonMaterialMap.url);
							 break;
						case "text":
							 $("input[name=buttonMaterialContentType][value=text]").attr("checked",true);
							 $("#buttonMaterialContentTextarea").val(buttonMaterialMap.text);
							 $("#buttonMaterialContentView").hide();
					         $("#menuButtonMaterialContentTextarea").show();
					         $("#menuButtonMaterialContentImage").hide();
					         $("#menuButtonMaterialContentNews").hide();
							 break;
						case "image":
							$("input[name=buttonMaterialContentType][value=image]").attr("checked",true);
							$("#buttonImagID").html(buttonMaterialMap.image_id);
							$("#buttonImage").attr('src',buttonMaterialMap.image_url); 
							$("#buttonMaterialContentView").hide();
					        $("#menuButtonMaterialContentTextarea").hide();
					        $("#menuButtonMaterialContentImage").show();
					        $("#menuButtonMaterialContentNews").hide();
							 break;
						case "news":
							$("input[name=buttonMaterialContentType][value=news]").attr("checked",true);
							$("#buttonNewsImageID").html(buttonMaterialMap.media_id);
							$("#buttonNewsImage").attr('src',buttonMaterialMap.image_url);
							$("#buttonNewsTitle").html(buttonMaterialMap.news_title);
							$("#buttonMaterialContentView").hide();
					        $("#menuButtonMaterialContentTextarea").hide();
					        $("#menuButtonMaterialContentImage").hide();
					        $("#menuButtonMaterialContentNews").show();
							 break;
						default : 
							break;
						}
					}else{
						alert("查询按钮素材失败！");
					}
				}	 
			}
			function middle2(){
				if($("#buttonPosition").html()!="middle" ||  $("#buttonNo").html()!="2"){
					clearMenuMaterial();
					var getMenuButtonMaterial_url="/manager/getMenuButtonMaterial?position=middle&button_no=2";
					var msg=$.ajax({url:getMenuButtonMaterial_url,async:false});
					var json=$.parseJSON( msg.responseText ) ;
					var buttonMaterialMap=json.buttonMaterialMap;
					if(json.state){
						$("#buttonPosition").html(buttonMaterialMap.position);
						$("#buttonNo").html(buttonMaterialMap.button_no);
						$("#buttonName").val(buttonMaterialMap.name);
						$("#buttonType").html(buttonMaterialMap.type);
						switch(buttonMaterialMap.type){
						case "url":
							 $("input[name=buttonMaterialContentType][value=url]").attr("checked",true);
							 $("#buttonMaterialContentUrl").val(buttonMaterialMap.url);
							 break;
						case "text":
							 $("input[name=buttonMaterialContentType][value=text]").attr("checked",true);
							 $("#buttonMaterialContentTextarea").val(buttonMaterialMap.text);
							 $("#buttonMaterialContentView").hide();
					         $("#menuButtonMaterialContentTextarea").show();
					         $("#menuButtonMaterialContentImage").hide();
					         $("#menuButtonMaterialContentNews").hide();
							 break;
						case "image":
							$("input[name=buttonMaterialContentType][value=image]").attr("checked",true);
							$("#buttonImagID").html(buttonMaterialMap.image_id);
							$("#buttonImage").attr('src',buttonMaterialMap.image_url); 
							$("#buttonMaterialContentView").hide();
					        $("#menuButtonMaterialContentTextarea").hide();
					        $("#menuButtonMaterialContentImage").show();
					        $("#menuButtonMaterialContentNews").hide();
							 break;
						case "news":
							$("input[name=buttonMaterialContentType][value=news]").attr("checked",true);
							$("#buttonNewsImageID").html(buttonMaterialMap.media_id);
							$("#buttonNewsImage").attr('src',buttonMaterialMap.image_url);
							$("#buttonNewsTitle").html(buttonMaterialMap.news_title);
							$("#buttonMaterialContentView").hide();
					        $("#menuButtonMaterialContentTextarea").hide();
					        $("#menuButtonMaterialContentImage").hide();
					        $("#menuButtonMaterialContentNews").show();
							 break;
						default : 
							break;
						}
					}else{
						alert("查询按钮素材失败！");
					}
				}	 
			}
			function middle3(){
				if($("#buttonPosition").html()!="middle" ||  $("#buttonNo").html()!="3"){
					clearMenuMaterial();
					var getMenuButtonMaterial_url="/manager/getMenuButtonMaterial?position=middle&button_no=3";
					var msg=$.ajax({url:getMenuButtonMaterial_url,async:false});
					var json=$.parseJSON( msg.responseText ) ;
					var buttonMaterialMap=json.buttonMaterialMap;
					if(json.state){
						$("#buttonPosition").html(buttonMaterialMap.position);
						$("#buttonNo").html(buttonMaterialMap.button_no);
						$("#buttonName").val(buttonMaterialMap.name);
						$("#buttonType").html(buttonMaterialMap.type);
						switch(buttonMaterialMap.type){
						case "url":
							 $("input[name=buttonMaterialContentType][value=url]").attr("checked",true);
							 $("#buttonMaterialContentUrl").val(buttonMaterialMap.url);
							 break;
						case "text":
							 $("input[name=buttonMaterialContentType][value=text]").attr("checked",true);
							 $("#buttonMaterialContentTextarea").val(buttonMaterialMap.text);
							 $("#buttonMaterialContentView").hide();
					         $("#menuButtonMaterialContentTextarea").show();
					         $("#menuButtonMaterialContentImage").hide();
					         $("#menuButtonMaterialContentNews").hide();
							 break;
						case "image":
							$("input[name=buttonMaterialContentType][value=image]").attr("checked",true);
							$("#buttonImagID").html(buttonMaterialMap.image_id);
							$("#buttonImage").attr('src',buttonMaterialMap.image_url); 
							$("#buttonMaterialContentView").hide();
					        $("#menuButtonMaterialContentTextarea").hide();
					        $("#menuButtonMaterialContentImage").show();
					        $("#menuButtonMaterialContentNews").hide();
							 break;
						case "news":
							$("input[name=buttonMaterialContentType][value=news]").attr("checked",true);
							$("#buttonNewsImageID").html(buttonMaterialMap.media_id);
							$("#buttonNewsImage").attr('src',buttonMaterialMap.image_url);
							$("#buttonNewsTitle").html(buttonMaterialMap.news_title);
							$("#buttonMaterialContentView").hide();
					        $("#menuButtonMaterialContentTextarea").hide();
					        $("#menuButtonMaterialContentImage").hide();
					        $("#menuButtonMaterialContentNews").show();
							 break;
						default : 
							break;
						}
					}else{
						alert("查询按钮素材失败！");
					}
				}	 
			}
			function middle4(){
				if($("#buttonPosition").html()!="middle" ||  $("#buttonNo").html()!="4"){
					clearMenuMaterial();
					var getMenuButtonMaterial_url="/manager/getMenuButtonMaterial?position=middle&button_no=4";
					var msg=$.ajax({url:getMenuButtonMaterial_url,async:false});
					var json=$.parseJSON( msg.responseText ) ;
					var buttonMaterialMap=json.buttonMaterialMap;
					if(json.state){
						$("#buttonPosition").html(buttonMaterialMap.position);
						$("#buttonNo").html(buttonMaterialMap.button_no);
						$("#buttonName").val(buttonMaterialMap.name);
						$("#buttonType").html(buttonMaterialMap.type);
						switch(buttonMaterialMap.type){
						case "url":
							 $("input[name=buttonMaterialContentType][value=url]").attr("checked",true);
							 $("#buttonMaterialContentUrl").val(buttonMaterialMap.url);
							 break;
						case "text":
							 $("input[name=buttonMaterialContentType][value=text]").attr("checked",true);
							 $("#buttonMaterialContentTextarea").val(buttonMaterialMap.text);
							 $("#buttonMaterialContentView").hide();
					         $("#menuButtonMaterialContentTextarea").show();
					         $("#menuButtonMaterialContentImage").hide();
					         $("#menuButtonMaterialContentNews").hide();
							 break;
						case "image":
							$("input[name=buttonMaterialContentType][value=image]").attr("checked",true);
							$("#buttonImagID").html(buttonMaterialMap.image_id);
							$("#buttonImage").attr('src',buttonMaterialMap.image_url); 
							$("#buttonMaterialContentView").hide();
					        $("#menuButtonMaterialContentTextarea").hide();
					        $("#menuButtonMaterialContentImage").show();
					        $("#menuButtonMaterialContentNews").hide();
							 break;
						case "news":
							$("input[name=buttonMaterialContentType][value=news]").attr("checked",true);
							$("#buttonNewsImageID").html(buttonMaterialMap.media_id);
							$("#buttonNewsImage").attr('src',buttonMaterialMap.image_url);
							$("#buttonNewsTitle").html(buttonMaterialMap.news_title);
							$("#buttonMaterialContentView").hide();
					        $("#menuButtonMaterialContentTextarea").hide();
					        $("#menuButtonMaterialContentImage").hide();
					        $("#menuButtonMaterialContentNews").show();
							 break;
						default : 
							break;
						}
					}else{
						alert("查询按钮素材失败！");
					}
				}	 
			}
			function middle5(){
				if($("#buttonPosition").html()!="middle" ||  $("#buttonNo").html()!="5"){
					clearMenuMaterial();
					var getMenuButtonMaterial_url="/manager/getMenuButtonMaterial?position=middle&button_no=5";
					var msg=$.ajax({url:getMenuButtonMaterial_url,async:false});
					var json=$.parseJSON( msg.responseText ) ;
					var buttonMaterialMap=json.buttonMaterialMap;
					if(json.state){
						$("#buttonPosition").html(buttonMaterialMap.position);
						$("#buttonNo").html(buttonMaterialMap.button_no);
						$("#buttonName").val(buttonMaterialMap.name);
						$("#buttonType").html(buttonMaterialMap.type);
						switch(buttonMaterialMap.type){
						case "url":
							 $("input[name=buttonMaterialContentType][value=url]").attr("checked",true);
							 $("#buttonMaterialContentUrl").val(buttonMaterialMap.url);
							 break;
						case "text":
							 $("input[name=buttonMaterialContentType][value=text]").attr("checked",true);
							 $("#buttonMaterialContentTextarea").val(buttonMaterialMap.text);
							 $("#buttonMaterialContentView").hide();
					         $("#menuButtonMaterialContentTextarea").show();
					         $("#menuButtonMaterialContentImage").hide();
					         $("#menuButtonMaterialContentNews").hide();
							 break;
						case "image":
							$("input[name=buttonMaterialContentType][value=image]").attr("checked",true);
							$("#buttonImagID").html(buttonMaterialMap.image_id);
							$("#buttonImage").attr('src',buttonMaterialMap.image_url); 
							$("#buttonMaterialContentView").hide();
					        $("#menuButtonMaterialContentTextarea").hide();
					        $("#menuButtonMaterialContentImage").show();
					        $("#menuButtonMaterialContentNews").hide();
							 break;
						case "news":
							$("input[name=buttonMaterialContentType][value=news]").attr("checked",true);
							$("#buttonNewsImageID").html(buttonMaterialMap.media_id);
							$("#buttonNewsImage").attr('src',buttonMaterialMap.image_url);
							$("#buttonNewsTitle").html(buttonMaterialMap.news_title);
							$("#buttonMaterialContentView").hide();
					        $("#menuButtonMaterialContentTextarea").hide();
					        $("#menuButtonMaterialContentImage").hide();
					        $("#menuButtonMaterialContentNews").show();
							 break;
						default : 
							break;
						}
					}else{
						alert("查询按钮素材失败！");
					}
				}	 
			}
			function right0(){
				if($("#buttonPosition").html()!="right" ||  $("#buttonNo").html()!="0"){
					clearMenuMaterial();
					var getMenuButtonMaterial_url="/manager/getMenuButtonMaterial?position=right&button_no=0";
					var msg=$.ajax({url:getMenuButtonMaterial_url,async:false});
					var json=$.parseJSON( msg.responseText ) ;
					var buttonMaterialMap=json.buttonMaterialMap;
					if(json.state){
						$("#buttonPosition").html(buttonMaterialMap.position);
						$("#buttonNo").html(buttonMaterialMap.button_no);
						$("#buttonName").val(buttonMaterialMap.name);
						$("#buttonType").html(buttonMaterialMap.type);
						switch(buttonMaterialMap.type){
						case "url":
							 $("input[name=buttonMaterialContentType][value=url]").attr("checked",true);
							 $("#buttonMaterialContentUrl").val(buttonMaterialMap.url);
							 break;
						case "text":
							 $("input[name=buttonMaterialContentType][value=text]").attr("checked",true);
							 $("#buttonMaterialContentTextarea").val(buttonMaterialMap.text);
							 $("#buttonMaterialContentView").hide();
					         $("#menuButtonMaterialContentTextarea").show();
					         $("#menuButtonMaterialContentImage").hide();
					         $("#menuButtonMaterialContentNews").hide();
							 break;
						case "image":
							$("input[name=buttonMaterialContentType][value=image]").attr("checked",true);
							$("#buttonImagID").html(buttonMaterialMap.image_id);
							$("#buttonImage").attr('src',buttonMaterialMap.image_url); 
							$("#buttonMaterialContentView").hide();
					        $("#menuButtonMaterialContentTextarea").hide();
					        $("#menuButtonMaterialContentImage").show();
					        $("#menuButtonMaterialContentNews").hide();
							 break;
						case "news":
							$("input[name=buttonMaterialContentType][value=news]").attr("checked",true);
							$("#buttonNewsImageID").html(buttonMaterialMap.media_id);
							$("#buttonNewsImage").attr('src',buttonMaterialMap.image_url);
							$("#buttonNewsTitle").html(buttonMaterialMap.news_title);
							$("#buttonMaterialContentView").hide();
					        $("#menuButtonMaterialContentTextarea").hide();
					        $("#menuButtonMaterialContentImage").hide();
					        $("#menuButtonMaterialContentNews").show();
							 break;
						default : 
							break;
						}
					}else{
						alert("查询按钮素材失败！");
					}
				}	 
			}
			function right1(){
				if($("#buttonPosition").html()!="right" ||  $("#buttonNo").html()!="1"){
					clearMenuMaterial();
					var getMenuButtonMaterial_url="/manager/getMenuButtonMaterial?position=right&button_no=1";
					var msg=$.ajax({url:getMenuButtonMaterial_url,async:false});
					var json=$.parseJSON( msg.responseText ) ;
					var buttonMaterialMap=json.buttonMaterialMap;
					if(json.state){
						$("#buttonPosition").html(buttonMaterialMap.position);
						$("#buttonNo").html(buttonMaterialMap.button_no);
						$("#buttonName").val(buttonMaterialMap.name);
						$("#buttonType").html(buttonMaterialMap.type);
						switch(buttonMaterialMap.type){
						case "url":
							 $("input[name=buttonMaterialContentType][value=url]").attr("checked",true);
							 $("#buttonMaterialContentUrl").val(buttonMaterialMap.url);
							 break;
						case "text":
							 $("input[name=buttonMaterialContentType][value=text]").attr("checked",true);
							 $("#buttonMaterialContentTextarea").val(buttonMaterialMap.text);
							 $("#buttonMaterialContentView").hide();
					         $("#menuButtonMaterialContentTextarea").show();
					         $("#menuButtonMaterialContentImage").hide();
					         $("#menuButtonMaterialContentNews").hide();
							 break;
						case "image":
							$("input[name=buttonMaterialContentType][value=image]").attr("checked",true);
							$("#buttonImagID").html(buttonMaterialMap.image_id);
							$("#buttonImage").attr('src',buttonMaterialMap.image_url); 
							$("#buttonMaterialContentView").hide();
					        $("#menuButtonMaterialContentTextarea").hide();
					        $("#menuButtonMaterialContentImage").show();
					        $("#menuButtonMaterialContentNews").hide();
							break;
						case "news":
							$("input[name=buttonMaterialContentType][value=news]").attr("checked",true);
							$("#buttonNewsImageID").html(buttonMaterialMap.media_id);
							$("#buttonNewsImage").attr('src',buttonMaterialMap.image_url);
							$("#buttonNewsTitle").html(buttonMaterialMap.news_title);
							$("#buttonMaterialContentView").hide();
					        $("#menuButtonMaterialContentTextarea").hide();
					        $("#menuButtonMaterialContentImage").hide();
					        $("#menuButtonMaterialContentNews").show();
							break;
						default : 
							break;
						}
					}else{
						alert("查询按钮素材失败！");
					}
				}	 
			}
			function right2(){
				if($("#buttonPosition").html()!="right" ||  $("#buttonNo").html()!="2"){
					clearMenuMaterial();
					var getMenuButtonMaterial_url="/manager/getMenuButtonMaterial?position=right&button_no=2";
					var msg=$.ajax({url:getMenuButtonMaterial_url,async:false});
					var json=$.parseJSON( msg.responseText ) ;
					var buttonMaterialMap=json.buttonMaterialMap;
					if(json.state){
						$("#buttonPosition").html(buttonMaterialMap.position);
						$("#buttonNo").html(buttonMaterialMap.button_no);
						$("#buttonName").val(buttonMaterialMap.name);
						$("#buttonType").html(buttonMaterialMap.type);
						switch(buttonMaterialMap.type){
						case "url":
							 $("input[name=buttonMaterialContentType][value=url]").attr("checked",true);
							 $("#buttonMaterialContentUrl").val(buttonMaterialMap.url);
							 break;
						case "text":
							 $("input[name=buttonMaterialContentType][value=text]").attr("checked",true);
							 $("#buttonMaterialContentTextarea").val(buttonMaterialMap.text);
							 $("#buttonMaterialContentView").hide();
						        $("#menuButtonMaterialContentTextarea").show();
						        $("#menuButtonMaterialContentImage").hide();
						        $("#menuButtonMaterialContentNews").hide();
							 break;
						case "image":
							$("input[name=buttonMaterialContentType][value=image]").attr("checked",true);
							$("#buttonImagID").html(buttonMaterialMap.image_id);
							$("#buttonImage").attr('src',buttonMaterialMap.image_url); 
							$("#buttonMaterialContentView").hide();
					        $("#menuButtonMaterialContentTextarea").hide();
					        $("#menuButtonMaterialContentImage").show();
					        $("#menuButtonMaterialContentNews").hide();
							break;
						case "news":
							$("input[name=buttonMaterialContentType][value=news]").attr("checked",true);
							$("#buttonNewsImageID").html(buttonMaterialMap.media_id);
							$("#buttonNewsImage").attr('src',buttonMaterialMap.image_url);
							$("#buttonNewsTitle").html(buttonMaterialMap.news_title);
							$("#buttonMaterialContentView").hide();
					        $("#menuButtonMaterialContentTextarea").hide();
					        $("#menuButtonMaterialContentImage").hide();
					        $("#menuButtonMaterialContentNews").show();
							break;
						default : 
							break;
						}
					}else{
						alert("查询按钮素材失败！");
					}
				}	 
			}
			function right3(){
				if($("#buttonPosition").html()!="right" ||  $("#buttonNo").html()!="3"){
					clearMenuMaterial();
					var getMenuButtonMaterial_url="/manager/getMenuButtonMaterial?position=right&button_no=3";
					var msg=$.ajax({url:getMenuButtonMaterial_url,async:false});
					var json=$.parseJSON( msg.responseText ) ;
					var buttonMaterialMap=json.buttonMaterialMap;
					if(json.state){
						$("#buttonPosition").html(buttonMaterialMap.position);
						$("#buttonNo").html(buttonMaterialMap.button_no);
						$("#buttonName").val(buttonMaterialMap.name);
						$("#buttonType").html(buttonMaterialMap.type);
						switch(buttonMaterialMap.type){
						case "url":
							 $("input[name=buttonMaterialContentType][value=url]").attr("checked",true);
							 $("#buttonMaterialContentUrl").val(buttonMaterialMap.url);
							 break;
						case "text":
							 $("input[name=buttonMaterialContentType][value=text]").attr("checked",true);
							 $("#buttonMaterialContentTextarea").val(buttonMaterialMap.text);
							 $("#buttonMaterialContentView").hide();
						     $("#menuButtonMaterialContentTextarea").show();
						     $("#menuButtonMaterialContentImage").hide();
						     $("#menuButtonMaterialContentNews").hide();
							 break;
						case "image":
							$("input[name=buttonMaterialContentType][value=image]").attr("checked",true);
							$("#buttonImagID").html(buttonMaterialMap.image_id);
							$("#buttonImage").attr('src',buttonMaterialMap.image_url); 
						    $("#buttonMaterialContentView").hide();
					        $("#menuButtonMaterialContentTextarea").hide();
					        $("#menuButtonMaterialContentImage").show();
					        $("#menuButtonMaterialContentNews").hide();
						 break;
						case "news":
							$("input[name=buttonMaterialContentType][value=news]").attr("checked",true);
							$("#buttonNewsImageID").html(buttonMaterialMap.media_id);
							$("#buttonNewsImage").attr('src',buttonMaterialMap.image_url);
							$("#buttonNewsTitle").html(buttonMaterialMap.news_title);
							$("#buttonMaterialContentView").hide();
					        $("#menuButtonMaterialContentTextarea").hide();
					        $("#menuButtonMaterialContentImage").hide();
					        $("#menuButtonMaterialContentNews").show();
							break;
						default : 
							break;
						}
					}else{
						alert("查询按钮素材失败！");
					}
				}	 
			}
			function right4(){
				if($("#buttonPosition").html()!="right" ||  $("#buttonNo").html()!="4"){
					clearMenuMaterial();
					var getMenuButtonMaterial_url="/manager/getMenuButtonMaterial?position=right&button_no=4";
					var msg=$.ajax({url:getMenuButtonMaterial_url,async:false});
					var json=$.parseJSON( msg.responseText ) ;
					var buttonMaterialMap=json.buttonMaterialMap;
					if(json.state){
						$("#buttonPosition").html(buttonMaterialMap.position);
						$("#buttonNo").html(buttonMaterialMap.button_no);
						$("#buttonName").val(buttonMaterialMap.name);
						$("#buttonType").html(buttonMaterialMap.type);
						switch(buttonMaterialMap.type){
						case "url":
							 $("input[name=buttonMaterialContentType][value=url]").attr("checked",true);
							 $("#buttonMaterialContentUrl").val(buttonMaterialMap.url);
							 break;
						case "text":
							 $("input[name=buttonMaterialContentType][value=text]").attr("checked",true);
							 $("#buttonMaterialContentTextarea").val(buttonMaterialMap.text);
							 $("#buttonMaterialContentView").hide();
						     $("#menuButtonMaterialContentTextarea").show();
						     $("#menuButtonMaterialContentImage").hide();
						     $("#menuButtonMaterialContentNews").hide();
							 break;
						case "image":
							$("input[name=buttonMaterialContentType][value=image]").attr("checked",true);
							$("#buttonImagID").html(buttonMaterialMap.image_id);
							$("#buttonImage").attr('src',buttonMaterialMap.image_url); 
							$("#buttonMaterialContentView").hide();
						    $("#menuButtonMaterialContentTextarea").hide();
						    $("#menuButtonMaterialContentImage").show();
						    $("#menuButtonMaterialContentNews").hide();
							 break;
						case "news":
							$("input[name=buttonMaterialContentType][value=news]").attr("checked",true);
							$("#buttonNewsImageID").html(buttonMaterialMap.media_id);
							$("#buttonNewsImage").attr('src',buttonMaterialMap.image_url);
							$("#buttonNewsTitle").html(buttonMaterialMap.news_title);
							$("#buttonMaterialContentView").hide();
						    $("#menuButtonMaterialContentTextarea").hide();
						    $("#menuButtonMaterialContentImage").hide();
						    $("#menuButtonMaterialContentNews").show();
							 break;
						default : 
							break;
						}
					}else{
						alert("查询按钮素材失败！");
					}
				}	 
			}
			function right5(){
				if($("#buttonPosition").html()!="right" ||  $("#buttonNo").html()!="5"){
					clearMenuMaterial();
					var getMenuButtonMaterial_url="/manager/getMenuButtonMaterial?position=right&button_no=5";
					var msg=$.ajax({url:getMenuButtonMaterial_url,async:false});
					var json=$.parseJSON( msg.responseText ) ;
					var buttonMaterialMap=json.buttonMaterialMap;
					if(json.state){
						$("#buttonPosition").html(buttonMaterialMap.position);
						$("#buttonNo").html(buttonMaterialMap.button_no);
						$("#buttonName").val(buttonMaterialMap.name);
						$("#buttonType").html(buttonMaterialMap.type);
						switch(buttonMaterialMap.type){
						case "url":
							 $("input[name=buttonMaterialContentType][value=url]").attr("checked",true);
							 $("#buttonMaterialContentUrl").val(buttonMaterialMap.url);
							 break;
						case "text":
							 $("input[name=buttonMaterialContentType][value=text]").attr("checked",true);
							 $("#buttonMaterialContentTextarea").val(buttonMaterialMap.text);
							 $("#buttonMaterialContentView").hide();
						     $("#menuButtonMaterialContentTextarea").show();
						     $("#menuButtonMaterialContentImage").hide();
						     $("#menuButtonMaterialContentNews").hide();
							 break;
						case "image":
							$("input[name=buttonMaterialContentType][value=image]").attr("checked",true);
							$("#buttonImagID").html(buttonMaterialMap.image_id);
							$("#buttonImage").attr('src',buttonMaterialMap.image_url); 
							$("#buttonMaterialContentView").hide();
						    $("#menuButtonMaterialContentTextarea").hide();
						    $("#menuButtonMaterialContentImage").show();
						    $("#menuButtonMaterialContentNews").hide();
							break;
						case "news":
							$("input[name=buttonMaterialContentType][value=news]").attr("checked",true);
							$("#buttonNewsImageID").html(buttonMaterialMap.media_id);
							$("#buttonNewsImage").attr('src',buttonMaterialMap.image_url);
							$("#buttonNewsTitle").html(buttonMaterialMap.news_title);
							$("#buttonMaterialContentView").hide();
						    $("#menuButtonMaterialContentTextarea").hide();
						    $("#menuButtonMaterialContentImage").hide();
						    $("#menuButtonMaterialContentNews").show();
							break;
						default : 
							break;
						}
					}else{
						alert("查询按钮素材失败！");
					}
				}	 
			}
			
			function deleteButtonMaterial(){
				var buttonPosition=$("#buttonPosition").html();
				var button_no=$("#buttonNo").html();
				if(buttonPosition != "" && button_no !=""){
					if(confirm("是否要删除当前按钮?")){
						var deleteMenuButton_url="/manager/deleteMenuButton?position="+buttonPosition+"&button_no="+button_no;
						var msg=$.ajax({url:deleteMenuButton_url,async:false});
						var json=$.parseJSON( msg.responseText ) ;
						if(json.state){
							alert("删除成功！");
							refresh();
						}else{
							alert("删除失败！");
						}
					}
				}	
			}
			function updateWeixinMenu(){
				if(  $("#left0").html()==""){
					alert("没有菜单按钮！");
					return;
				};
				var updateWeixinMenuButton_url="/manager/updateWeixinMenuButton";
				var msg=$.ajax({url:updateWeixinMenuButton_url,async:false});
				var json=$.parseJSON( msg.responseText ) ;
				if(json.errcode=="0"){
					if(json.queryMenuStatus){
						if(json.updateMenuStatus){
							alert("微信菜单更新成功！自定义菜单设置成功！");
						}else{
							alert("微信菜单更新成功,但自定义菜单设置失败！");
						}						
					}else{
						alert("微信菜单更新成功,但菜单开启状态查询失败！");
					}
				}else{
                    if(json.errcode=="40018"){
                        alert("微信菜单更新失败！无效菜单名长度,主菜单名称过长！");
                    }else{
                        alert("微信菜单更新失败！"+json.errmsg);
                    }
				}
			}
			function setQWBShopUrl(){
				var getQWBShopUrl_url="/manager/WeixinConfig/getQWBShopUrl"; 
				var msg=$.ajax({url:getQWBShopUrl_url,async:false});
				var json=$.parseJSON( msg.responseText );
				$("#buttonName").val(); 
				if(json.state){
					$("#buttonName").val("浏览商城"); 
					$("#buttonMaterialContentUrl").val(json.shopUrl); 
				}else{
					alert("获取商城地址失败！");
				}
			}
		</script>
	</body>
</html>
