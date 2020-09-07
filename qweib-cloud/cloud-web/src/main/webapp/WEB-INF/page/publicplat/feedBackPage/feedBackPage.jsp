<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
   
<!DOCTYPE html>  
<html>
<head>
	<meta charset="UTF-8">
	<title>意见反馈</title>
	<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
	<%@include file="/WEB-INF/page/include/source.jsp"%>
	<link rel="stylesheet" href="resource/feedback/css/reset.css">
	<link rel="stylesheet" href="resource/feedback/css/feedback.less">
	<link rel="stylesheet" href="resource/feedback/css/feedback.css">
	<!-- <style type="text/css">
		/*.show {
			/*position: absolute;*/
			position: fixed;
			left: 0;
			top:50%;
			width: 100%;
			height: 100%;
			background-color: #000;
			.show div {
			display: none;
			position: absolute;
			left: 50%;
			top: 50%;
			margin: -150px 0 0 -200px;
		}
		.show div img {
			display: block;
		}
		.show div span {
			position: absolute;
			right: 0;
			top: 0;
			width: 50px;
			height: 50px;
			background: url(resource/img/2.png) no-repeat;
			background-size: 100%;
			cursor: pointer;
		}
		#bgshow {
			width:100%;
			height:100%;
			position:absolute;
			left:0px;
			top:0px;
			background:#000;
		filter:alpha(opacity:50);
			opacity:0.5;
			display:none;
		}*/
	}
	</style> -->
</head>
<body>
	<div class="wrap" style="">
		<form id="frm" action="${base }/manager/feedBackPage" method="post">
			<input type="hidden" value="${page.curPage }" name="pageNo" id="curPage"/>
			<div>
				<input type="radio"  name="feedType" id="all" value="0" onclick="javascript:queryfeedback(1)"/>
				<label for="all">全部</label>
			</div>
			<div>
				<input type="radio"  name="feedType" id="feed"  value="1" onclick="javascript:queryfeedback(1)"/>
			<label for="feed">异常问题</label>
			</div>
			<div>
				<input type="radio"  name="feedType" id="change"  value="2" onclick="javascript:queryfeedback(1)"/>
			<label for="change">意见改进</label>
			</div>
			<div class="search">
				<input  type="text" name="scontent" id="search" value="请输入关键词/提交人姓名" onfocus="javascript:tofocus(this)" onblur="if(this.value==''){this.value='请输入关键词/提交人姓名'}" />
				<%--<label for="search" id="aa">请输入关键词/提交人姓名</label>
				--%><button onclick="javascript:queryfeedback(1);">搜索</button>
			</div>
		
			<c:if test="${empty page.rows}">
				<div style="margin: 20px;padding: 3px;text-align: center; float: left;font-size: 15px; color: red;">没有找到反馈信息</div>
			</c:if>
			<c:if test="${!empty page.rows}">
				<c:forEach items="${page.rows}" var="fback" varStatus="i">
					<div class="question" >
						<table >
							<tr style="height:45px;width:100%;">
								<th style="width: 200px;" class="setbg">问题类型</th>
								<th>${fback.feedType=='1'?'异常问题':'意见改进' }</th>
								<th class="setbg">提交人</th>
								<th>${fback.memberNm }</th>
								<th class="setbg">提交时间</th>
								<th>${fback.feedTime }</th>
							</tr>
							<tr style="height:80px;width:100%">
								<td class="setcss">问题描述</td>
								<td colspan="5" >
									<div style="width:100%;height: 80px;overflow: auto; text-align: center;line-height: 80px">
										${fback.feedContent }
									</div>
								</td>
							</tr>
							<tr style="height:300px;width:100%;">
								<td class="setcss">图片</td>
								<td colspan="5" class="picss">
									<div class="tdin" style="width:100%;height: 310px;overflow: auto;">
										<c:forEach items="${fback.picList}" var="mpic" varStatus="i">
											<img src="${base}/upload/${mpic.picMini}" alt="" title="" onclick="javascript:openModalDialog('${base}/upload/${mpic.pic}')">
										</c:forEach>
									</div>
								</td>
							</tr>
						</table>
					</div>
				</c:forEach>
				
			</c:if>
		</form>
		<c:if test="${!empty page.rows}">
			<div style="margin: 20px;padding: 3px;text-align: center; float: left;font-size: 15px; color: blue;">
				第${page.curPage}页 &nbsp;&nbsp;&nbsp;
				<c:choose>
					<c:when test="${page.curPage==1}"><span>上一页</span></c:when>
					<c:otherwise><a href="javascript:queryfeedback('${page.curPage-1}')"><u style="color: black;">上一页</u></a></c:otherwise>
				</c:choose>
				
				<c:choose>
					<c:when test="${page.curPage==page.totalPage || page.totalPage==0}"><span>下一页</span></c:when>
					<c:otherwise><a href="javascript:queryfeedback('${page.curPage+1}')"><u style="color: black;">下一页</u></a></c:otherwise>
				</c:choose>
				<c:if test="${page.totalPage!=0 }"><a href="javascript:queryfeedback('${page.totalPage}')"><span>末页</span></a></c:if>
				页次：
				<select id="pno" onchange="pnoChange();">
					<c:forEach var="i" begin="1" end="${page.totalPage}" step="1">
						<option value="${i}" >${i}</option>
					</c:forEach>
				</select>
				共${page.totalPage}页
			</div>
		</c:if>
	</div>
	<!--图片大图-->
		<div id="win" class="easyui-window" style="width:800px;height:500px;" 
			minimizable="false" maximizable="true" collapsible="true" closed="true" modal="true">
			<img src="" style="width: 100%;height: 100%;" id="bigpic">
		</div>
	<!-- 弹窗 -->
	<!-- <div class="show">
		<div>
			<img src="${base }/upload/sjk1435905303562109/chat/1441866280015.jpg" alt="" title="" id="showpic">
			<span></span>
		</div>
	</div> -->
	
	
	<script>
	$(function(){
		//反馈类型
		$("input:radio[value=${feedType}]").attr('checked','true');
		//查询输入框的值
		var scontent ="${scontent}";
		if(scontent!=''){
			$("#search").val(scontent);
		}
		//显示下拉框的页码
		var curPage = "${page.curPage}"
			$("#pno").val(curPage);
	});
	//分页查询
	function queryfeedback(pageNo){
		$("#curPage").val(pageNo);
		$("#frm").submit();
	}

	function tofocus(obj){
		if(obj.value=='请输入关键词/提交人姓名'){
			$("#search").val('');
		}
	}

	var show = $(".show ");
	var showDiv = $(".show div");
	var showDivHei = $(".show div").height();
	var showBtn = $(".show span")
	var oBg = document.getElementById('bgshow');
	function toBigimg(pic){
		var oframe = document.getElementById("showpic");
		oframe.src = pic;
		show.stop(true, true).animate({
			// top : "0",
			// height : showDivHei,
				display : "block",
			
		}, 1000);
		showDiv.css({
				display : "block",
		})
	}
	//showBtn.click(function() {
		//showDiv.fadeOut(200);
		//show.stop(true, true).animate({
			// top : "50%",
			//height : "0" 
		//},1000)
	//})

	function pnoChange(){
		$("#curPage").val($("#pno").val());
		$("#frm").submit();
		
	}

	function openModalDialog(pic){
		//var features='status:0;dialogWidth:470px;dialogHeight:270px;resizable:0;scroll:0;center:1';  
	    //showModalDialog("${base}/manager/toShowpic?pic="+pic,'','width=790,height=590');  
	    //$("#showpic").src=pic;
	    //$(".show").show();
	   // window.open ("${base}/manager/toShowpic?pic="+pic,'newwindow','height=600,width=850,top=100,left=200,toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no')
	    $("#bigpic").attr("src",pic);
		$('#win').window('open');
	}
	</script>
</body>
</html>