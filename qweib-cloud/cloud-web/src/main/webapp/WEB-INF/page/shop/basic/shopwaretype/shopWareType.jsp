<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML>
<html>
<head>
<title>企微宝</title>

<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
<meta http-equiv="description" content="This is my page">
<%@include file="/WEB-INF/page/include/source.jsp"%>
<style type="text/css">
	.divDel{
		position: relative;
		width:160px;
		height:160px;
		margin:15px 0px 5px;
	}
	.imgDel{
		width:20px;
		height:20px;
		position: absolute;
		right: 5px;
		top: 5px;
	}
</style>
</head>

<body class="easyui-layout">
	<div data-options="region:'west',split:true,title:'商品分类树'" style="width:150px;padding-top: 5px;">
		<div style="padding:5px 5px;">
			<a href="javascript:getChecked();" class="easyui-linkbutton" data-options="iconCls:'icon-edit'" style="width:100%">上架商品类别编辑</a>
		</div>
		<!-- <ul id="waretypetree"></ul> -->
		<ul id="waretypetree" class="easyui-tree" data-options="url:'/manager/shopWareType/queryShopWaretypesByShopQy',animate:true,onClick: function(node){
					loadWareType(node.id);
				},onDblClick:function(node){
					$(this).tree('toggle', node.target);
				}">
		</ul>
	</div>

	<div data-options="region:'center',split:true" >

	<form  name="waretypefrm" id="waretypefrm" method="post" enctype="multipart/form-data">
		<div id="easyTabs" class="easyui-tabs" style="width:auto;height:auto;">
			<div id="wareTypeDiv" title="商品分类信息" style="padding:20px;">
				<div style="padding-left: 10px;padding-top: 10px;">
					上级分类：<span id="upWaretypeSpan">无</span>
				</div>

				<input type="hidden" name="waretypeId" id="waretypeId" /> <input
					type="hidden" name="waretypePid" id="waretypePid" />
				<table id="opertable" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<th>分类名称：</th>
						<td><input name="waretypeNm" id="waretypeNm"
							class="easyui-validatebox" data-options="required:true"
							maxlength="30" onkeydown="if(event.keyCode==13)return false;" disabled="disabled"/>
						</td>
					</tr>
					<tr>
						<th>非公司类别：</th>
						<td><input type="checkbox" value="1" name="noCompany" id="noCompany" disabled="disabled"/></td>
					</tr>
					<!-- <tr>
						<th></th>
						<td>
							<a class="easyui-linkbutton" href="javascript:addWareType();">新增一级分类</a>
							&nbsp; <a id="nextTypea" class="easyui-linkbutton" href="javascript:addNextType();">新增下级分类</a>
						</td>
					</tr> -->
				</table>

			</div>

			<div title="商品图片" style="overflow:auto;padding:20px;">
				<dl id="dl2">
				</dl>
				<dd style="margin:20px 0px;">
					<!-- <a class="easyui-linkbutton" iconcls="icon-add" href="javascript:void(0);" onclick="addRows(this);">增加图片</a> -->
				</dd>
			</div>
		</div>
		<div class="f_reg_but" style="clear:both">
			<a href="javascript:saveWareType();" class="easyui-linkbutton" data-options="iconCls:'icon-save'">保存</a>
			<!-- <a href="javascript:deleteWareType();" class="easyui-linkbutton" data-options="iconCls:'icon-remove'">删除</a> -->
		</div>
	</form>

	<div id="w" class="easyui-window" title="编辑商城商品分类" data-options="iconCls:'icon-save',closed:true" style="width:500px;height:400px;padding:10px;">
		<div style="text-align: center;" data-options="region:'south',border:false">
			<a class="easyui-linkbutton" href="javascript:savepower();">保存</a>
			&nbsp;&nbsp;
			<a class="easyui-linkbutton" href="javascript:closetreewin_power();">关闭</a>
		</div>
		<!-- <ul id="waretypeTreeWindow"></ul> -->
		<ul id="waretypeTreeWindow" class="easyui-tree" data-options="url:'manager/shopWareType/shopWaretypes',animate:true,checkbox:true"></ul>
	</div>

	</div>

	<script type="text/javascript">
		$(function() {
			//获取单商品分类
			loadWareType("");
		});

		function loadWareType(id) {
			$.ajax({
				url : "manager/shopWareType/getShopWaretype",
				type : "post",
				data : "id=" + id,
				success : function(json) {
					if (json) {
						$('#waretypefrm').form('load', {
							waretypeId : json.waretypeId,
							waretypePid : json.waretypePid,
							waretypeNm : json.waretypeNm,
							noCompany : json.noCompany
						});
						if (json.upWaretypeNm) {
							$("#upWaretypeSpan").html(json.upWaretypeNm);
						} else {
							$("#upWaretypeSpan").html("无");
						}

						//处理图片
						doWarpeTypePic(json);
					} else {
						$("#upWaretypeSpan").html("无");
					}
				}
			});
		}

		//处理图片
		function doWarpeTypePic(json){
			console.log(json);
			var waretypePicList=json.waretypePicList;
			if(waretypePicList!=null && waretypePicList.length>0){
				resetDefaultData(waretypePicList.length);//恢复默认数据
				var sb="";
				for(var i=0;i<waretypePicList.length;i++){
					var detail = waretypePicList[i];
					sb+="<dd id=\"ddphoto"+(i+1)+"\">";
					sb+="<input type=\"hidden\" name=\"subId\" id=\"subId"+(i+1)+"\" value=\""+detail.id+"\"/>";
					sb+="<div class=\"divDel\">";
					if(detail.pic!=null){
						sb+="<img id=\"photoImg2"+(i+1)+"\" style=\"width: 160px;height: 160px;\" src=\"upload/"+detail.pic+"\"/>";
					}else{
						sb+="<img id=\"photoImg2"+(i+1)+"\" style=\"width: 160px;height: 160px;\" src=\"resource/images/login_bg.jpg\"/>";
					}
					sb += "<img class=\"imgDel\"  src=\"resource/shop/mobile/images/delete_1.png\" onclick=\"deleteRows("+(i+1)+");\"/>";
					sb += "</div>";
					sb += "<div id=\"editDiv"+(i+1)+"\" >";
					sb += "<a class=\"easyui-linkbutton l-btn\" iconcls=\"icon-edit\" href=\"javascript:void(0);\" onclick=\"modifyRows("+(i+1)+");\">";
					sb += "<span class=\"l-btn-left\"><span class=\"l-btn-text icon-edit l-btn-icon-left\">编辑</span></a>";
					sb += "</div>";
					sb += "</dd>";
				}
				$("#dl2").html(sb);
			}else{
				loadDefaultPic();
			}
		}

		//恢复默认数量
		function resetDefaultData(num){
			delPicIds="";
			$("#dl2").empty();//清空
			index=num;
			len=num;
			picNum=num;
		}

		//加载默认图片（新增数据时）
		function loadDefaultPic(){
			resetDefaultData(1);//恢复默认数据
			var sb="";
			sb += "<dd id=\"ddphoto1\">";
			sb += "<div class=\"divDel\">";
			sb += "<img id=\"photoImg21\" style=\"width: 160px;height: 160px;\" src=\"resource/images/login_bg.jpg\"/ >";
			sb += "<img class=\"imgDel\"  src=\"resource/shop/mobile/images/delete_1.png\" onclick=\"deleteRows(1);\"/>";
			sb += "</div>";
			sb += "<div id=\"editDiv2\" >";
			sb += "<input type=\"file\" accept=\"image/*\" name=\"file21\" id=\"file21\" onchange=\"showPictrue(1)\"  class=\"uploadFile\"/>";
			sb += "</div>";
			sb += "</dd>";
			$("#dl2").html(sb);
		}

		//保存
		function saveWareType() {
			//easyUi的from表单的ajax请求接口
			$("#waretypefrm").form('submit',{
				type:"POST",
				url:"<%=basePath%>/manager/shopWareType/operShopWaretype",
				onSubmit: function(param){
					//额外参数
					param.delPicIds = delPicIds;
			    },
				success:function(data){
					if (data == "2") {
						alert("修改成功");
						//修改时：整体tree结构没变化；不需要重新加载
						//$('#waretypetree').tree('reload');
						loadWareType($("#waretypeId").val());
					} else if (data == "-1") {
						alert("操作失败");
					} else if (data == "-2") {
						alert("商品分类不能超过2级");
					} else if (data == "-3") {
						alert("该商品分类名称已经存在");
					} else {
						alert("添加成功");
						$('#waretypetree').tree('reload');
						$("#waretypeId").val(data);
						loadWareType($("#waretypeId").val());
					}
				}
			});
		}

		//添加照片
		var index=1;
		var picNum=1;
		var len=1;//记录原来的个数(备注：len初始化时(len=index);点击按钮"添加图片"len会固定不变，index而++;用来编辑图片时记录编辑的图片id(条件：len>=index))
		function addRows(obj){
			index++;
			picNum++;
			var strs = "<dd id=\"ddphoto"+index+"\">";
			strs+="<span class=\"title\">";
			strs+="<div class=\"divDel\">";
			strs+="<img id=\"photoImg2"+index+"\" alt=\"\" style=\"width: 160px;height: 160px;\" src=\"resource/images/login_bg.jpg\" />";
			strs+="<img class=\"imgDel\" src=\"resource/shop/mobile/images/delete_1.png\" onclick=\"deleteRows('"+index+"');\" />"
			strs+="</div>";
			strs+="<div id=\"editDiv"+index+"\">";
			strs+="<input type=\"file\" accept=\"image/*\" name=\"file2"+index+"\" id=\"file2"+index+"\" onchange=\'showPictrue("+index+")\'  class=\"uploadFile\"/>";
			strs+="</div>";
			strs+="</dd>";
			$("#dl2").append(strs);
		}

		//删除照片
		var delPicIds="";
		function deleteRows(c){
			picNum--;
			var picId = $("#subId"+c).val();
			if(picId!=null && picId!=undefined && picId!=""){
				//记录删除的图片id
				if(delPicIds==""){
					delPicIds=""+picId;
				}else{
					delPicIds+=","+picId;
				}
			}
			//console.log("删除的商品分类ids:"+delPicIds);
			var ddphoto = document.getElementById("ddphoto"+c);
			ddphoto.parentNode.removeChild(ddphoto);
			if(picNum==0){
				addRows(null);
			}
		}

		//显示图片
		function showPictrue(n){
			var r= new FileReader();
			f=document.getElementById("file2"+n).files[0];
			r.readAsDataURL(f);
			r.onload=function  (e) {
				document.getElementById('photoImg2'+n).src=this.result;
			}
			//修改时记录要删除的图片id(len,n就是index)
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

		//编辑图片
		function modifyRows(n){
			var str="<input type='file' accept='image/*' name='file2"+n+"' id='file2"+n+"'  onchange='showPictrue("+n+")'   class='uploadFile'/>";
			if($("#file2"+n+"").length>0){
			}else{
				$("#editDiv"+n).append(str);
			}
		}

		//===============================================================================
		function loadWareTypes(){
			/* $("#waretypetree").tree({
			    url: "manager/shopWareType/queryShopWaretypesByShopQy",
			    animate:true,
			    loadFilter: function(data){
			    	return data;
			    },
			    onLoadError:function(arguments){
			    	console.log("onLoadError::::"+arguments);
			    	$("#w").window('open');
			    },
			    onClick: function(node){
					loadWareType(node.id);
				},onDblClick:function(node){
					$(this).tree('toggle', node.target);
				}
			}); */
		}

		function getChecked(){
			$("#w").window('open');
			/* $("#waretypetree").tree({
			    url: "manager/shopWareType/shopWaretypes",
			    checkbox:true,
			    animate:true,
			    loadFilter: function(data){
					if (data.d){
						return data.d;
					} else {
						return data;
					}
			    }
			}); */
		}

		//保存
		function savepower(){
			//选中
			var cIds='';
			var nodes1 = $("#waretypeTreeWindow").tree('getChecked', 'checked');
			if(nodes1!=null){
				for(var i=0; i<nodes1.length; i++){
					if (cIds != '') cIds += ',';
					cIds += nodes1[i].id;
				}
			}
			//部分选中
			var iIds='';
			var nodes2 = $("#waretypeTreeWindow").tree('getChecked', 'indeterminate');
			if(nodes2!=null){
				for(var i=0; i<nodes2.length; i++){
					if (iIds != '') iIds += ',';
					iIds += nodes2[i].id;
				}
			}
			$.ajax({
				url : "manager/shopWareType/updateWaretypeShopQY",
				type : "post",
				data : {"cIds":cIds,"iIds":iIds},
				success : function(json) {
					if('1'==json){
						alert("修改成功");
						$("#w").window('close');
						window.location.reload()//刷新当前页面.
					}else{
						alert("修改失败");
					}
				}
			});
		}

		//关闭窗口
		function closetreewin_power(){
			$("#w").window('close');
		}






	</script>
</body>
</html>
