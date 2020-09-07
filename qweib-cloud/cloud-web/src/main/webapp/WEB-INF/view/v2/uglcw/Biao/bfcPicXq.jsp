<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>驰用T3</title>
		<%@include file="/WEB-INF/page/include/source.jsp"%>
	</head>
	<body>
	
		<div class="box">
  			<form name="picfrm" id="picfrm" method="post">
  			  <div>
  			  <dl id="dl">
  			        <c:if test="${tp=='1'}">
		      			<dt class="f14 b">签到图片</dt>
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
	     			</c:if>
	     			<c:if test="${tp=='2'}">
		      			<dt class="f14 b">生动化陈列采集图片</dt>
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
	     			</c:if>
	     			<c:if test="${tp=='3'}">
		      			<dt class="f14 b">库存检查图片</dt>
		      			<table>
		      			<tr>
		      			<c:if test="${!empty cljccjPic}">
		        		<c:forEach items="${cljccjPic}" var="cljccjPic" varStatus="s4">
			      			<td>
			        			&nbsp;&nbsp;&nbsp;<a onclick="toBigPic('${cljccjPic.pic}');"><img style="width: 125px;" src="${base}upload/${cljccjPic.picMini}"/></a>
			     			</td>
		     			</c:forEach>
		     			</c:if>
		     		    </tr>
		     			</table>
	     			</c:if>
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
