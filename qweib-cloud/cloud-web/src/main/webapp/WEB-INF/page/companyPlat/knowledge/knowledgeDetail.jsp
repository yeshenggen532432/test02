<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
   
<!DOCTYPE html>  
<html>
<head>
	<meta charset="UTF-8">
	<title></title>
	<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
	<%@include file="/WEB-INF/page/include/source.jsp"%>
	<link rel="stylesheet" href="resource/feedback/css/reset.css">
	<link rel="stylesheet" href="resource/feedback/css/feedback.less">
	<link rel="stylesheet" href="resource/feedback/css/feedback.css">
	<style type="text/css">
		.question th {
			height:20px;
		}
		#setbg {
			background: none repeat scroll 0 0 #e9e7e8;
			width: 10%;
		}
	</style>
</head>
<body>
	<div class="wrap" style="width:900px;">
		<form id="frm" action="manager/queryKnowledgeDetail?knowledgeId=${knowledge.knowledgeId }" method="post" style="width: 900px;">
			<c:if test="${empty knowledge}">
				<div style="margin: 20px;padding: 3px;text-align: center; float: left;font-size: 15px; color: red;">没有找到反馈信息</div>
			</c:if>
			<c:if test="${!empty knowledge}">
					<div class="question" style="width:900px;height: auto;">
						<table style="width:900px;height:auto;border: 1px solid #dadada;">
							<c:if test="${!empty knowledge.topiContent }">
								<tr style="height:80px;width:100%">
									<td id="setbg">内容</td>
									<td colspan="5" >
										<div style="width:100%;height: 80px;overflow: auto; text-align: center;line-height: 80px">
											${knowledge.topiContent }
										</div>
									</td>
								</tr>
							</c:if>
							<c:if test="${knowledge.tp=='1' }">
								<tr style="height:300px;width:100%;">
									<td id="setbg">图片</td>
									<td colspan="5" >
										<div class="tdin" style="width:100%;height: 310px;overflow: auto;border: 1px">
											<c:forEach items="${knowledge.picList}" var="kpic" varStatus="i">
												<img style="width: 200px;height: 200px" src="${base}/upload/${kpic.picMini}" alt="" title="" onclick="javascript:openModalDialog('${base}/upload/${kpic.pic}')">
											</c:forEach>
										</div>
									</td>
								</tr>
							</c:if>
							
							<c:if test="${knowledge.tp=='3' }">
								<tr>
									<th style="width: 200px;min-height: 20px;background: none repeat scroll 0 0 #e9e7e8;">文件</th>
									<td colspan="5">
										<c:forEach items="${knowledge.fileList}" var="att">
											<div style="width: 500px;">
												<span style="min-width: 300px;float: left;margin-top: 20px;">${att.attachName }</span>
												<a href="manager/download?path=${att.attacthPath }&filename=${att.attachName }" style="margin-left: 50px;float: left;color: blue;margin-top: 20px;text-decoration: underline">下载</a>
												<!-- <a href="javascript:lookFile('${att.attacthPath }','${att.attachName }');" style="margin-left: 20px;float: left;color: blue;margin-top: 20px;text-decoration: underline">查看</a> -->
											</div>
										</c:forEach>
									</td>
								</tr>
							</c:if>
						</table>
					</div>
			</c:if>
		</form>
	</div>
	<!--图片大图-->
		<div id="win" class="easyui-window" style="width:800px;height:500px;" 
			minimizable="false" maximizable="false" collapsible="false" closed="true" modal="true">
			<img style="width: 100%;height: 100%;" id="bigpic">
		</div>
	<!-- 弹窗 -->
	<!-- <div class="show">
		<div>
			<img src="" alt="" title="" id="showpic">
			<span></span>
		</div>
	</div> -->
	
	
	<script>

	//var show = $(".show ");
	//var showDiv = $(".show div");
	//var showDivHei = $(".show div").height();
	//var showBtn = $(".show span")
	//var oBg = document.getElementById('bgshow');
	//function toBigimg(pic){
	//	var oframe = document.getElementById("showpic");
	//	oframe.src = pic;
	//	show.stop(true, true).animate({
			// top : "0",
			// height : showDivHei,
	//			display : "block",
			
	//	}, 1000);
	//	showDiv.css({
	//			display : "block",
	//	})
	//}

	function pnoChange(){
		$("#curPage").val($("#pno").val());
		$("#frm").submit();
		
	}
	function lookFile(path,nm){
		//$.ajax({
		//	url:"manager/lookFile",
		//	data:"path="+path+"&name="+nm,
		//	type:"post",
		//	success:function(data){
		//		if(data=='-1'){
		//			alert("查看出错");
		//		}else if(data=='-2'){
		//			alert("文件不存在或已被删除");
		//		}else if(data=='-3'){
		//			alert("path路径出错");
		//		}
		//	}
		//});
		window.open('${base}'+'/upload/'+path);
	}
	function openModalDialog(pic){
		$("#bigpic").attr("src",pic);
		$('#win').window('open');
	}
	</script>
</body>
</html>