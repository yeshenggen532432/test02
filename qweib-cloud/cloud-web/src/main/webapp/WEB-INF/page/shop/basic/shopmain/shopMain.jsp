<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML>
<html>
	<head>
		<title>商城首页设置</title>
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<link rel="stylesheet" type="text/css" href="<%=basePath%>/resource/shop/pc/css/cropper.css">
		<script type="text/javascript" src="<%=basePath%>/resource/shop/pc/js/cropper.js"></script>
		<!-- 样式开始========= -->
		<style type="text/css">
			.divLogo, .divBanner, .divWareType{
				padding:10px;
			}
			ul{
				margin:10px;
			}
			.divWareType li{
				list-style-type: none;
				float:left;
				margin: 5px 10px;
			}
			
			span.title{
				font-size:12px;
				color:#333;
				font-weight: bold;
			}
			.warn{
				font-size:10px;
				color:#ff0000;
			}
			.divName{
				height:40px;
				margin: 5px 0px;
			}
			input#name{
				width:150px;
				height:25px;
				border-radius: 5px;
				border:solid 0.5px #ccc;
				font-size:12px;
				color:#333;
			}
			.line{
				width: 100%;
				height: 1px;
				border-bottom: 0.5px dashed #eee;
			}
			.divDel{
				position: relative;
				width:375px;
				height:150px;
				margin:15px 0px 5px;
			}
			.imgDel{
				width:20px;
				height:20px;
				position: absolute;
				right: 5px;
				top: 5px;
			}
            .img-container{
                background-color: #f7f7f7;
                text-align: center;
                width: 825px;
                height: 497px;
            }
            .img-container > img {
                max-width: 100%;
            }
		</style>
	</head>
	
  <body>
  	<!-- logo:开始 -->
	<div>
		<form action="" name="logofrm" id="logofrm" method="post" enctype="multipart/form-data">
			<div id="easyTabs" class="easyui-tabs" style="width:auto;height:auto;">
			
				<div class="divLogo" title="基本设置" style="padding:10px">
					<div class="divName">
						<input type="hidden" name="id" id="id" value="${shopMallInfo.id}"/>
						<span class="title">店铺名称：</span>
						<input class="easyui-textbox" id="name" name="name" value="${shopMallInfo.name}">
					</div>
					<div>
						<span class="title">店铺logo：</span>
						<c:if test="${!empty shopMallInfo.logo}">
				         	<img id="photoImgLogo" alt=""   style="width: 60px;height: 60px;" src="upload/${shopMallInfo.logo}"/>
				        </c:if>
		       			<c:if test="${empty shopMallInfo.logo}">
		       				<img id="photoImgLogo" alt=""   style="width: 60px;height: 60px;" src="resource/images/login_bg.jpg"/>
		       			</c:if>
						<input type="file" accept="image/*" name="file1" id="file1" onchange="showPictrueLogo()"  class="uploadFile"/>
					</div>
				</div>
				
				<!-- banner:开始 -->
				<div class="divBanner" title="广告图" style="padding:10px">
					<span class="warn">建议图片规格(横：750*300)</span>
					<dl id="dl2">
					<c:if test="${empty shopMallInfo.bannerList}">
		       			<dd id="ddphoto1">
		     				<div class="divDel">
			        			<img id="photoImg21" alt="" style="width: 100%;height: 100%" src="resource/images/login_bg.jpg">
			        			<img class="imgDel" alt=""   style="width: 20px;height: 20px;" src="resource/shop/mobile/images/delete_1.png" onclick="deleteRows(1);"/>
		        			</div>
		        			<div id="editDiv2" >
		        				<input type="file" accept="image/*" name="file21" id="file21" class="uploadFile" classId="1"/>
		        			</div>
		 				</dd>
		       		</c:if>
		       		
		       		<c:if test="${!empty shopMallInfo.bannerList}">
			      		<c:forEach items="${shopMallInfo.bannerList}" var="banner" varStatus="s">
			      			<dd id="ddphoto${s.index+1}">
			      				<input type="hidden" name="subId" id="subId${s.index+1}" value="${banner.id}"/>
			      				<c:set var="subIds" value="${subIds},${banner.id },"/>
			        			<div class="divDel" >
				        			<c:if test="${!empty banner.pic}">
				        				<img id="photoImg2${s.index+1}" alt=""   style="width: 100%;height: 100%" src="upload/${banner.pic}"/>
				        			</c:if>
				        			<c:if test="${empty banner.pic}">
				        				<img id="photoImg2${s.index+1}" alt=""   style="width: 100%;height: 100%" src="resource/images/login_bg.jpg"/>
				        			</c:if>
				        			<img class="imgDel" alt=""   style="width: 20px;height: 20px;" src="resource/shop/mobile/images/delete_1.png" onclick="deleteRows('${s.index+1}');"/>
			        			</div>
			        			
			        			<div id="editDiv${s.index+1}" >
			        				<a class="easyui-linkbutton" iconcls="icon-edit" href="javascript:void(0);" onclick="modifyRows('${s.index+1}');">编辑</a>
			        			</div>
							</dd>
						</c:forEach>
		       		</c:if>
		       		</dl>
		       		<dd style="margin:20px 0px;">
						<a class="easyui-linkbutton" iconcls="icon-add" href="javascript:void(0);" onclick="addRows(this);">增加图片</a>
					</dd>
				</div>
				
				<!-- 首页商品一级分类显示哪几个:开始 -->
				<div class="divWareType" title="首页推荐分类" style="padding:10px">
					<div>
						<span class="title">首页推荐分类</span><%--<span class="warn">(备注：最少选择4个,最多选择7个才会显示)</span>--%>
					</div>
					<div style="padding: 0px 0px 20px">
						<ul id="waretype">
						</ul>
					</div>
				</div>
				
				<%--
				不使用zzx 05-15
				<!--首页子模块 -->
				<div class="divModel" style="clear:both" title="模块显示格式设置" style="padding:10px">
					<div style="margin:10px">
						<span class="title">模块一：</span> <tag:select name="stkId1" id="stkId1" tableName="shop_ware_group" whereBlock="status=1" headerKey="" headerValue="--请选择--" displayKey="id" displayValue="name" value="${shopMallInfo.mGroup1}"/>
						<span class="warn">备注必须选择4个商品，否则不在商城首页显示；建议图片规格(竖：300*400 横：375*200)</span>
						<ul id="wareModel1">
						</ul>
					</div>
					<div style="margin:10px">
						<span class="title">模块二：</span>
                        <tag:select name="stkId2" id="stkId2" tableName="shop_ware_group" whereBlock="status=1" headerKey="" headerValue="--请选择--" displayKey="id" displayValue="name" value="${shopMallInfo.mGroup2}"/>
						<span class="warn">备注必须选择3个商品，否则不在商城首页显示；建议图片规格(竖：300*400 横：375*200)</span>
						<ul id="wareModel2">
						</ul>
					</div>
					<div style="margin:10px">
						 <span class="title">模块三：</span><tag:select name="stkId3" id="stkId3" tableName="shop_ware_group" whereBlock="status=1" headerKey="" headerValue="--请选择--" displayKey="id" displayValue="name" value="${shopMallInfo.mGroup3}"/>
						 <span class="warn">备注必须选择4个商品，否则不在商城首页显示；建议图片规格(竖：300*400 横：375*200)</span>
						<ul id="wareModel3">
						</ul>
					</div>
				</div>--%>
			
			</div>
			<div class="f_reg_but" style="clear:both">
		    	<input type="button" value="保存" class="l_button" onclick="toSubmit();"/>
		    </div>
		</form>

		<div id="w" class="easyui-window" title="图片裁剪" data-options="iconCls:'icon-save',closed:true" style="width: 825px;height: 494px;">
			<%--裁剪的原图片，按钮--%>
			<div style="margin: 10px">
				<button id="cropper" type="button" class="easyui-linkbutton" >保存裁剪</button>
			</div>
			<div class="img-container">
				<img id="image" src="" alt="Picture">
			</div>
		</div>
		
		<!-- ==============dialog：商品选择==================== -->
		<div id="wareDlg" closed="true" class="easyui-dialog" style="width:500px; height:200px;" title="商品选择" iconCls="icon-edit">
        </div>
	</div>
	
	<!-- script开始===================================================== -->
	<script type="text/javascript">

		$(document).ready(function(){
			//获取商品一级分类
			getWaretypeList();
			//子模块
			var groupId_1="${shopMallInfo.mGroup1}";
			var groupId_2="${shopMallInfo.mGroup2}";
			var groupId_3="${shopMallInfo.mGroup3}";
			var modelWareids_1="${shopMallInfo.modelWareids1}";
			var modelWareids_2="${shopMallInfo.modelWareids2}";
			var modelWareids_3="${shopMallInfo.modelWareids3}";
			if(groupId_1!=null && groupId_1!=''){
				getWareList(groupId_1,'1',modelWareids_1);
			}
			if(groupId_2!=null && groupId_2!=''){
				getWareList(groupId_2,'2',modelWareids_2);
			}
			if(groupId_3!=null && groupId_3!=''){
				getWareList(groupId_3,'3',modelWareids_3);
			}
		})

		var formData = new FormData();

		//from表单数据：名称,logo,banner,商品一级分类，子模块(分组)
		function toSubmit(){
			//店铺名称和logo
			var name=$("#name").val();
			if(name==null || name==""){
				alert("请输入店铺名称");
				return;
			}

			//商品一级分类
			var cbWareTypes = document.getElementsByName("waretypeWareIds");
			var waretypeWareIds = "";
			for(var i=0;i<cbWareTypes.length;i++){
				if(cbWareTypes[i].checked){
					var chVal=cbWareTypes[i].value;
					if(waretypeWareIds == ""){
						waretypeWareIds=chVal;
					}else{
						waretypeWareIds  = waretypeWareIds+","+chVal;
					}
				}
			}

			//========子模块1~子模块3=====
			var model1=$("#stkId1").val();
			var chxVals = document.getElementsByName("cbModel_1");
			var wareIds1 = "";
			for(var i=0;i<chxVals.length;i++){
				if(chxVals[i].checked){
					var chVal=chxVals[i].value;
					if(wareIds1 == ""){
						wareIds1=chVal;
					}else{
						wareIds1  = wareIds1+","+chVal;
					}
				}
			}
			var model2=$("#stkId2").val();
			var chxVals2 = document.getElementsByName("cbModel_2");
			var wareIds2 = "";
			for(var i=0;i<chxVals2.length;i++){
				if(chxVals2[i].checked){
					var chVal2=chxVals2[i].value;
					if(wareIds2 == ""){
						wareIds2=chVal2;
					}else{
						wareIds2  = wareIds2+","+chVal2;
					}
				}
			}
			var model3=$("#stkId3").val();
			var chxVals3 = document.getElementsByName("cbModel_3");
			var wareIds3 = "";
			for(var i=0;i<chxVals3.length;i++){
				if(chxVals3[i].checked){
					var chVal3=chxVals3[i].value;
					if(wareIds3 == ""){
						wareIds3=chVal3;
					}else{
						wareIds3 = wareIds3+","+chVal3;
					}
				}
			}

			var id=$("#id").val();
			formData.append("id",id);
			formData.append("name",name);

			formData.append("mGroup1",model1);
			formData.append("mGroup2",model2);
			formData.append("mGroup3",model3);
			formData.append("mWareIds1",wareIds1);
			formData.append("mWareIds2",wareIds2);
			formData.append("mWareIds3",wareIds3);
			formData.append("waretypeWareIds",waretypeWareIds);
			formData.append("delPicIds",delPicIds);

			$.ajax({
				url:"manager/shopMain/updateModel",
				type: "POST",
				data: formData,
				processData: false,
				contentType: false,
				success:function(data){
					if(data=="1"){
						alert("保存成功");
                        formData = null;
                        formData = new FormData();
					}else{
						alert("保存失败");
					}
				},
				error:function(data) {
				},
			});
		}

		//查询子模块下的商品列表
		function getWareList(groupId,type,modelWareids){
			$.ajax({
				url:"<%=basePath%>/manager/shopWare/queryWareByGroupId",
				data:{"groupId":groupId},
				type:"POST",
				success:function(json){
					if(json.state){
						var datas = json.wareList;
						var str="";
						if(datas!=null && datas!= undefined && datas.length>0){
							for(var i=0;i<datas.length;i++){
								str+="<li>";
								if(modelWareids.indexOf(datas[i].wareId) != -1){
									str+="<input type=\"checkbox\" name=\"cbModel_"+type+"\" value=\""+datas[i].wareId+"\" checked=\"checked\" >";
								}else{
									str+="<input type=\"checkbox\" name=\"cbModel_"+type+"\" value=\""+datas[i].wareId+"\">";
								}
								str+="<span>"+datas[i].wareNm+"</span>";
								str+="</li>";
							}
						}
						if(type=='1'){
							$("#wareModel1").html(str);
						}else if(type=='2'){
							$("#wareModel2").html(str);
						}else if(type=='3'){
							$("#wareModel3").html(str);
						}
						
					}
				}	
			});
		}
		
		//获取商品一级分类
		function getWaretypeList(){
			var waretypeIds="${shopMallInfo.waretype}";
			
			$.ajax({
				url:"<%=basePath%>/manager/shopWareType/queryWaretypeOne",
				type:"POST",
				success:function(json){
					if(json.state){
						var datas = json.wareTypes;
						var str="";
						if(datas!=null && datas!= undefined && datas.length>0){
							for(var i=0;i<datas.length;i++){
								str+="<li>";
								if(waretypeIds.indexOf(datas[i].waretypeId) != -1){
									str+="<input type=\"checkbox\" onclick=\"waretypeSelected("+datas[i].waretypeId+")\" id=\"cb"+datas[i].waretypeId+"\" name=\"waretypeWareIds\" value=\""+datas[i].waretypeId+"\" checked=\"checked\" >";
								}else{
									str+="<input type=\"checkbox\" onclick=\"waretypeSelected("+datas[i].waretypeId+")\" id=\"cb"+datas[i].waretypeId+"\" name=\"waretypeWareIds\" value=\""+datas[i].waretypeId+"\" >";
								}
								str+="<span>"+datas[i].waretypeNm+"</span>";
								str+="</li>";
							}
						}
						$("#waretype").html(str);
					}
				}	
			});
		}
		
   		function waretypeSelected(waretypeId){
   			var num=0;
   			var cbWareTypes = document.getElementsByName("waretypeWareIds");
			for(var i=0;i<cbWareTypes.length;i++){
				if(cbWareTypes[i].checked){
					num++;
				}
			}
			if(num>7){
				$("#cb"+waretypeId).attr('checked',false)  //移除 checked 状态 
				alert("最多选择7个");
			}
		}
		
		//显示logo图片
		function showPictrueLogo(n){
			var r= new FileReader();
			var f=document.getElementById('file1').files[0];
			r.readAsDataURL(f);
			r.onload=function  (e) {
				document.getElementById('photoImgLogo').src=this.result;
			}
			//修改重新赋值
			formData.set("file1",f);

		}
		
		//显示banner图片
		function showPictrue(n){
			var r= new FileReader();
			f=document.getElementById("file2"+n).files[0];
			r.readAsDataURL(f);
			r.onload=function  (e) {
				document.getElementById('photoImg2'+n).src=this.result;
			}
			//修改时记录要删除的图片id
			if(Number(len)>=Number(n)){
				var picId = $("#subId"+n).val();
				console.log("picId:"+picId);
				if(picId!=null && picId!=undefined && picId!=""){
					//记录删除的图片id
					if(delPicIds==""){
						delPicIds=""+picId;
					}else{
						delPicIds+=","+picId;
					}
					console.log(delPicIds);
				}
			}
		}

		//--------------------图片相关：开始-----------------
		//添加照片
		var index="${len}";
		var len=${len};//记录个数
		var size=${len};//记录banner总个数（目前最多选中3个）
		function addRows(obj){
			if(size>=3){
				alert("最多选择3个");
				return;
			}
			index++;
			size++;
			var strs = "<dd id=\"ddphoto"+index+"\">";
			strs+="<span class=\"title\">";
			strs+="<div class=\"divDel\" >";
			strs+="<img id=\"photoImg2"+index+"\" alt=\"\" style=\"width: 100%;height: 100%\" src=\"resource/images/login_bg.jpg\" />";
			strs+="<img class=\"imgDel\" src=\"resource/shop/mobile/images/delete_1.png\" onclick=\"deleteRows('"+index+"');\" />" 
			strs+="</div>";
			strs+="<div id=\"editDiv"+index+"\">";
			strs+="<input type=\"file\" accept=\"image/*\" name=\"file2"+index+"\" id=\"file2"+index+"\" class=\"uploadFile\" classId='"+index+"'/>";
			strs+="</div>";
			strs+="</dd>";
			$("#dl2").append(strs);
		}
		
		//删除照片
		var delPicIds="";
		function deleteRows(c){
			size--;
			var picId = $("#subId"+c).val();
			if(picId!=null && picId!=undefined && picId!=""){
				//记录删除的图片id
				if(delPicIds==""){
					delPicIds=""+picId;
				}else{
					delPicIds+=","+picId;
				}
			}
			var ddphoto = document.getElementById("ddphoto"+c);
			ddphoto.parentNode.removeChild(ddphoto);
		}

		//编辑图片
		function modifyRows(n){
			var str="<input type='file' accept='image/*' name='file2"+n+"' id='file2"+n+"' class='uploadFile' classId='"+n+"'/>";
			if($("#file2"+n+"").length>0){
			}else{
				$("#editDiv"+n).append(str);
			}
		}

		//裁剪
		var classId;
		var uploadedImageName;
		var uploadedImageType;
		var uploadedImageURL;
		var URL = window.URL || window.webkitURL;
		var options = {
			aspectRatio: 75 / 30,
			preview: '.img-preview',
		};
		$("#dl2").on('change','.uploadFile',function () {
			$("#w").window('open');
			classId = this.getAttribute("classId");
			console.log("classId:"+classId);
			var files = this.files;
			var file;
			if (files && files.length) {
				file = files[0];
				if (/^image\/\w+$/.test(file.type)) {
					uploadedImageName = file.name;
					uploadedImageType = file.type;
				}
				uploadedImageURL = URL.createObjectURL(file);
				$("#image").cropper('destroy').attr('src', uploadedImageURL).cropper(options);
				$("#dl2 #file2"+classId).val('');
			}else{
				window.alert('请选择图片文件');
			}
		});

		$("#cropper").on('click',function () {
			$("#w").window('close');
			var cropCanvas = $('#image').cropper('getCroppedCanvas');
			var cropUrl = cropCanvas.toDataURL(uploadedImageType, 0.4);
			$("#dl2 #photoImg2"+classId).attr('src',cropUrl);

			cropCanvas.toBlob(function(blob) {
				//通过has(key)来判断是否存在对应的key值
				if(formData.has("file2"+classId)){
					formData.set("file2"+classId, blob, uploadedImageName);
				}else{
					formData.append("file2"+classId, blob, uploadedImageName);
				}
				$('#image').attr('src','');
			})

			//修改时记录要删除的图片id
			if(Number(len)>=Number(classId)){
				var picId = $("#subId"+classId).val();
				if(picId!=null && picId!=undefined && picId!=""){
					//记录删除的图片id
					if(delPicIds==""){
						delPicIds=""+picId;
					}else{
						delPicIds+=","+picId;
					}
				}
			}
		})
		//--------------------图片相关：结束-----------------


		
		//子模块一
		$("select#stkId1").change(function(){
			var groupId=$("#stkId1").val();
			if(groupId==null || groupId==""){
				$("#wareModel1").html("");//"请选择清空"
				return;
			}
			getWareListDefault(groupId,'1');
		});
		//子模块二
		$("select#stkId2").change(function(){
			var groupId=$("#stkId2").val();
			if(groupId==null || groupId==""){
				$("#wareModel2").html("");//"请选择清空"
				return;
			}
			getWareListDefault(groupId,'2');
		});
		//子模块三
		$("select#stkId3").change(function(){
			var groupId=$("#stkId3").val();
			if(groupId==null || groupId==""){
				$("#wareModel3").html("");//"请选择清空"
				return;
			}
			getWareListDefault(groupId,'3');
		});
		
		//子模块一,二,三：选择分组商品（清空之前选中）
		function getWareListDefault(groupId,type){
			$.ajax({
				url:"<%=basePath%>/manager/shopWare/queryWareByGroupId",
				data:{"groupId":groupId},
				type:"POST",
				success:function(json){
					if(json.state){
						var datas = json.wareList;
						var str="";
						if(datas!=null && datas!= undefined && datas.length>0){
							for(var i=0;i<datas.length;i++){
								str+="<li>";
								str+="<input type=\"checkbox\" name=\"cbModel_"+type+"\" value=\""+datas[i].wareId+"\">";
								str+="<span>"+datas[i].wareNm+"</span>";
								str+="</li>";
							}
						}
						if(type=='1'){
							$("#wareModel1").html(str);
						}else if(type=='2'){
							$("#wareModel2").html(str);
						}else if(type=='3'){
							$("#wareModel3").html(str);
						}
						
					}
				}	
			});
		}
		
		//选择商品
		function dialogSelectWare(){
		 	$("#wareDlg").dialog({
		         title: '商品选择',
		         iconCls:"icon-edit",
		         width: 800,
		         height: 400,
		         modal: true,
		         //href: "<%=basePath %>/manager/dialogOutWareType?stkId="+stkId+"&customerId="+cstId,
		         onClose: function(){
		         }
		     });
		 	$("#wareDlg").dialog('open');
		}
		
	</script>
  </body>
</html>
