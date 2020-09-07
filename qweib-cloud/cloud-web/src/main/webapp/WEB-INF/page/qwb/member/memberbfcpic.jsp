<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>企微宝</title>
		<%@include file="/WEB-INF/page/include/source.jsp"%>
	</head>
	<body>
	
		<div class="box">
  			<form name="picfrm" id="picfrm" method="post">
  			  <div>
  			  <dl id="dl">
	      			<dt class="f14 b">1，拜访签到拍照</dt>
	      			<table>
	      			<tr>
	      			<c:if test="${!empty bfqdpzPic}">
	        		<c:forEach items="${bfqdpzPic}" var="bfqdpzPic" varStatus="s1">
		      			<td>
		        			&nbsp;&nbsp;&nbsp;<a onclick="toBigPic('${bfqdpzPic.pic}');"><img style="width: 125px;" src="${base}upload/${bfqdpzPic.picMini}"/></a>
		     			</td>
	     			</c:forEach>
	     			</c:if>
	     			</tr>
	     			</table>
	      			<dt class="f14 b">2，生动化检查</dt>
	      			<table>
	      			<tr>
	      			<c:if test="${!empty bfsdhjcPic1}">
	        		<c:forEach items="${bfsdhjcPic1}" var="bfsdhjcPic1" varStatus="s2">
		      			<td>
		        			&nbsp;&nbsp;&nbsp;<a onclick="toBigPic('${bfsdhjcPic1.pic}');"><img style="width: 125px;" src="${base}upload/${bfsdhjcPic1.picMini}"/></a>
		     			</td>
	     			</c:forEach>
	     			</c:if>
	     			<c:if test="${!empty bfsdhjcPic2}">
	        		<c:forEach items="${bfsdhjcPic2}" var="bfsdhjcPic2" varStatus="s3">
		      			<td>
		        			&nbsp;&nbsp;&nbsp;<a onclick="toBigPic('${bfsdhjcPic2.pic}');"><img style="width: 125px;" src="${base}upload/${bfsdhjcPic2.picMini}"/></a>
		     			</td>
	     			</c:forEach>
	     			</c:if>
	     			</tr>
	     			</table>
	     			<dt class="f14 b">3，陈列检查采集</dt>
	     			<table>
	      			<tr>
	      			<c:if test="${!empty list1}">
	        		<c:forEach items="${list1}" var="list1" varStatus="s4">
	        		    <c:forEach items="${list1.bfxgPicLs}" var="bfxgPicLs" varStatus="s41">
		      			<td>
		        			&nbsp;&nbsp;&nbsp;<a onclick="toBigPic('${bfxgPicLs.pic}');"><img style="width: 125px;" src="${base}upload/${bfxgPicLs.picMini}"/></a>
		     			</td>
		     			</c:forEach>
	     			</c:forEach>
	     			</c:if>
	     			</tr>
	     			</table>
	     			<dt class="f14 b">4，道谢并告知下次拜访</dt>
	     			<table>
	      			<tr>
	      			<c:if test="${!empty bfgzxcPic}">
	        		<c:forEach items="${bfgzxcPic}" var="bfgzxcPic" varStatus="s5">
		      			<td>
		      				&nbsp;&nbsp;&nbsp;<a onclick="toBigPic('${bfgzxcPic.pic}');"><img style="width: 125px;" src="${base}upload/${bfgzxcPic.picMini}"/></a>
		     			</td>
	     			</c:forEach>
	     			</c:if>
	     			</tr>
	     			</table>
		       </dl>
	          </div>
	        </form>
		</div>
		<div id="bigPicDiv"  class="easyui-window" title="图片" style="width:315px;top: 110px;" 
			minimizable="false" maximizable="false" modal="true"  collapsible="false" 
			 closed="true">
			  <img style="width: 300px;" id="photoImg" alt=""/>
		</div>
		<script type="text/javascript">
		  function toBigPic(picurl){
		       document.getElementById("photoImg").setAttribute("src","${base}upload/"+picurl);
			   $("#bigPicDiv").window("open");
		  }
		  $('#bigPicDiv').window({
		     onBeforeClose:function(){
		       document.getElementById("photoImg").setAttribute("src","");
		     }
		  });
		</script>
	</body>
</html>
