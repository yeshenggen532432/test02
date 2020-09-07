<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>卡宝包</title>
	<%@include file="/WEB-INF/page/include/source.jsp"%>
	<style>
		.file-box{position:relative;width:70px;height: auto;}
		.uploadBtn{background-color:#FFF; border:1px solid #CDCDCD;height:22px;line-height: 22px;width:70px;}
		.uploadFile{ position:absolute; top:0; right:0; height:22px; filter:alpha(opacity:0);opacity: 0;width:70px;}
	</style>
  </head>
  <body>
  	<div class="file-box">
	  	<form action="manager/uploadtemp" name="uploadfrm" id="uploadfrm" method="post" enctype="multipart/form-data">
	  		<input type="hidden" name="width" value="${width}"/>
			<input type="hidden" name="height" value="${height}"/>
			<input type="button" class="uploadBtn" value="上传照片" />
			<input type="file" name="upFile" id="upFile" onchange="toupload(this);" class="uploadFile"/>
	  	</form>
  	</div>
  	<script type="text/javascript">
		function toupload(obj){
			var bool = window.parent.checkImg(obj);
			if(bool){
				$("#uploadfrm").form('submit',{
					success:function(data){
						if(data!="-1" && data!="-2"){
							window.parent.showPic2(data,'${str1}','${str2}');
						}else if(data=="-1"){
							window.parent.showUploadMsg(1);
						}else if(data=="-2"){
							window.parent.showUploadMsg(2);
						}
					}
				});
			}
		}  	
  	</script>
  </body>
</html>
