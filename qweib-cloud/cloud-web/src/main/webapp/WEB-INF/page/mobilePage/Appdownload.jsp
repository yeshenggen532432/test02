<%@ page language="java" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="base" value="${pageContext.request.contextPath}" />
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<base href="<%=basePath%>"/>
    <meta content="text/html; charset=utf-8" http-equiv="Content-Type" />
    <title>企微宝</title>
    <meta name="keywords" content="企微宝">
    <meta name="description" content="企微宝">
    <link href="resource/wzpage/css/layout.css" rel="stylesheet" />
</head>
<body class="body1" onload="loads()"> 
<input type="hidden"  value="5" id="time"/>
<div id="mobie">
<div id="head"><img src="resource/wzpage/images/logo.png" alt="" style="width: 100%"/></div>
<div id="main2">
<div class="m_left">
  <h2 class="h2_txt">
  </h2>
  <dl class="dl_01">
  <dt></dt>
<dd></dd>
<dd></dd>
<dd></dd>
  </dl>
  <h2 class="h2_txt">下载到手机：</h2>
  <dl class="dl_02">
  <dd>
  <p><a id="iphoneUrl" href="itms-services://?action=download-manifest&amp;url=https://oa.ytrxpos.com/cyd/upload/app/cnlife/CnlifeApp.plist" onclick="javascript:jiazai();"><img id="image"  src="resource/wzpage/images/iphone.gif" alt="Iphone下载" /></a></p>
  <p><a href="${android}">
  		<c:if test="${empty type}">
  			<img  src="resource/wzpage/images/android.gif" alt="Android下载" />
  		</c:if>
  </a></p>
  </dd>
  </dl>
  <div class="clear"></div>
  </div>
  <!-- <div class="m_right">
  <img  src="resource/wzpage/images/pic.png" alt=""/>
  </div> -->
  <div class="clear"></div>
</div>
<div class="icoBox mobil_ico">
 <ul>
 <li>
 <div><img src="resource/wzpage/images/ico1.gif" alt="交流" /></div>
 <div>交流</div>
 </li>
 <li>
 <div><img src="resource/wzpage/images/ico2.gif" alt="分享" /></div>
 <div>分享</div>
 </li>
 <li>
 <div><img src="resource/wzpage/images/ico3.gif" alt="单位岁月" /></div>
 <div>单位岁月</div>
 </li>
 </ul>
 </div>
 <div id="bottom">弘信创业 2015 版权所有</div>
</div>
</body>
<!--内容结束-->
    <script type="text/javascript">
	function loads(){
			// 判断系统版本号是否大于 6
				var version = navigator.userAgent.match(/OS [7-8]_\d[_\d]* like Mac OS X/i);
				if(version!=null&&typeof version !='undefined'){
					var test = version.toString();
					test = test.substring(test.indexOf(' '),test.indexOf('like'));
					var firstNum = test.substring(0,test.indexOf('_'));
					var secondeNum;
					if(test.length == 7){
						secondeNum=test.substring(test.indexOf('_')+1,test.lastIndexOf('_'));
					}else{
						secondeNum=test.substring(test.indexOf('_')+1);
					}
					if(parseInt(firstNum) == 7&& parseInt(secondeNum) >= 1){
						document.getElementById('iphoneUrl').href="itms-services://?action=download-manifest&amp;url=https://oa.ytrxpos.com/cyd/upload/app/cnlife/CnlifeApp.plist";
					}else if(parseInt(firstNum) == 8){
						document.getElementById('iphoneUrl').href="itms-services://?action=download-manifest&amp;url=https://oa.ytrxpos.com/cyd/upload/app/cnlife/CnlifeApp.plist";
					}else{
						document.getElementById('iphoneUrl').href="itms-services://?action=download-manifest&amp;url=http://oa.ytrxpos.com:8090/cyd/upload/app/cnlife/CnlifeApp.plist";
					}
				}
	}	
	function jiazai(){
	    document.getElementById("image").setAttribute("src","resource/wzpage/images/loading.gif");
	}
</script>
</html>
