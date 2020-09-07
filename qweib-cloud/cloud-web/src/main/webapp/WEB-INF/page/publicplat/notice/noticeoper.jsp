<%@ page language="java" pageEncoding="UTF-8"%>
<html>
	<head>
		<title>公告管理</title>

		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
<script type="text/javascript" charset="utf-8" src="resource/kindeditor/kindeditor-min.js"></script>
<script type="text/javascript" charset="utf-8" src="resource/kindeditor/lang/zh_CN.js"></script>
	</head>
	<body>		
<div class="box" >
			<form action="manager/poperNotice" name="usrFrm" id="usrFrm" method="post" enctype="multipart/form-data">
				<dl>
					<dd>
						<input type="hidden"  name="noticeId" id="noticeId" value="${notice.noticeId }"/>
						<input type="hidden" name="memberId" id="memberId" value="${notice.memberId}"/>
	      				<input type="hidden" id="noticeTime" name="noticeTime" value="${notice.noticeTime}"/>
	      				<input type="hidden" id="isPush" name="isPush" value="${notice.isPush}"/>
	      				<input type="hidden" id="datasource" name="datasource" value="${notice.datasource}"/>
	      				<c:if test="${!empty notice.memberId}">
	      					<input type="hidden"  name="noticeTp" id="noticeTp" value="${notice.noticeTp}"/>
	      				</c:if>
		  				<input type="hidden" name="noticePic" id="pic" value="${notice.noticePic}" />
						<input type="hidden" name="oldpic" id="oldpic" value="${notice.noticePic}" />
	        		</dd>
	        		<dd>
	      				<span class="title">标题：</span>
		      				<input class="reg_input" name="noticeTitle" id="noticeTitle" value="${notice.noticeTitle}" style="width: 156px; height: 20px;" />
							<span id="noticeTitleTip" class="onshow"></span>
	        		</dd>
	        		<dd>
	      				<span class="title">标题图：</span>
	        			<img id="photoImg" alt="" style="width: 380px;height: 215px;" />
	     				<iframe src="manager/toupfile?width=380&height=215" name="filefrm" id="filefrm" frameborder="0" marginheight="0" marginwidth="0" 
	     					height="22px" width="70px" scrolling="no"></iframe>
	     				<span id="picTip" class="onshow"></span>
	        		</dd>
	        		<c:if test="${isAdmin=='1'}">
	        			<c:if test="${empty notice.noticeId}">
			        		<dd>
			      				<span class="title">类型：</span>
			        			<input type="radio"  name="noticeTp" id="noticeTp1" value="1"/>系统公告
			        			<input type="radio" name="noticeTp" id="noticeTp4" value="4"/>购划算
			        		</dd>
		        		</c:if>
	        		</c:if>
	        		<c:if test="${empty notice.noticeId}">
		        		<dd>
		      				<span class="title">推送：</span>
		        			<input type="radio" checked="checked" name="ists"  value="2"/>否
		      				<input type="radio"  name="ists"  value="1"/>是
		        		</dd>
	        		</c:if>
	        		<dt class="f14 b"></dt>	        		
					<dd>
						<span id="noticeContentTip" class="onshow"></span>	
	        			<textarea class="reg_input" name="noticeContent" id="noticeContent" 
								style="width: 350px; height: 290px;">${notice.noticeContent}</textarea>
							
	 				</dd>			
				</dl>			
				<div class="f_reg_but">
					<c:if test="${empty notice.noticeId}">
						<input type="button" value="发布" class="s_button" onclick="save();"/>
					</c:if>
					<c:if test="${!empty notice.noticeId}">
						<input type="button" value="修改" class="s_button" onclick="save();"/>
					</c:if>
	    			<input type="button" value="返回" class="b_button" onclick="toback();"/>
	     		</div>
			</form>
	</div>
	<div id="imgWindow" class="easyui-window" title="裁剪窗" closed="true" style="width:700; height:550"
		minimizable="false" maximizable="true" collapsible="false">
		<iframe name="imgiframe" id="imgiframe" frameborder="0" marginheight="0" marginwidth="0" 
	     	height="100%" width="100%" scrolling="no">
	     </iframe>
	</div>
<script type="text/javascript">

$(function() {	
	//图片
	var pic = $("#pic").val();
	if(pic!=""){
		document.getElementById("photoImg").setAttribute("src","upload/publicplat/notice/"+pic+"?"+Math.random());
	}else{
		document.getElementById("photoImg").setAttribute("src","resource/images/login_bg.jpg");
	}
	$.formValidator.initConfig();
	
	$("#noticeTitle").formValidator( {
		onShow : "请输入标题",
		onFocus : "2-200个字符",
		onCorrect : "（正确）"
	}).inputValidator( {
		min : 2,
		max : 200,
		onError : "标题在2-200个字符之间"
	});
	
	$("#noticeContent").formValidator( {
		onShow : "",
		onFocus : "不能为空",
		onCorrect : "（正确）"
	}).inputValidator( {
		min : 1,
		onError : "不能为空"
	});
	$("#pic").formValidator({onShow:"请选择照片",onFocus:"请选择照片",onCorrect:"通过"}).inputValidator({min:1,max:30,onError:"请选择照片"});
	  
	var noticeTp="${notice.noticeTp}";
	var isAdmin = "${isAdmin}";
	var noticeId= "${notice.noticeId}"
	if(isAdmin=='1' && noticeId==''){
		if(noticeTp=='4'){
		  document.getElementById("noticeTp4").checked=true;
		}else{
		   document.getElementById("noticeTp1").checked=true;
		}
	}
	
	addEditor("noticeContent","usrFrm","<%=request.getContextPath()%>");

	
	
});

//添加用户
function save(){
	kindEditor.sync();
	if ($.formValidator.pageIsValid() == true) {
		$('#usrFrm').form('submit', {
			success : function(data) {
				if (data == "1") {
					alert("添加成功");
					toback();
				} else if (data == "2") {
					alert("修改成功");
					toback();
				} else {
					alert("操作失败");
					return;
				}
			}
		});
	}
}
function toback(){
	location.href="${base}/manager/tonotice";
}
			//判断图片
			function checkImg(obj){
				return checkExt(obj,"照片");
			}
				//显示上传消息
			function showUploadMsg(tp){
				if(tp==1){
					alert("上传的照片大小要大于380*215像素");
				}else if(tp==2){
					alert("上传出错");
				}
			}
			//显示图片
			function showPic(data){
			   document.getElementById("imgiframe").src="${base}/manager/noticeToImgCoord?imgsrc="+data+"&width=380&height=215";
				$("#imgWindow").window({
					title:"图片",
					top:getScrollTop()+30
				});
				$("#imgWindow").window('open');
			}
			//显示截图小图
			function showPhotoMini(data,dataOld){
			    $("#pic").val(data);
				document.getElementById("photoImg").setAttribute("src","upload/temp/"+data+"?"+Math.random());
				hideImgWin();
			}
			function hideImgWin(){
				$("#imgWindow").window('close');
			}
</script>
	</body>
</html>
