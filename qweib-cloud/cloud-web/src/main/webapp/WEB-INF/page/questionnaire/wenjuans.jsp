<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>  
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0"> 
<meta content="email=no,telephone=no" name="format-detection"/>
<%@include file="/WEB-INF/page/include/source.jsp"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<title>问卷调查</title>
<style type="text/css">
body, h1, h2, h3, h4, h5, h6, p, dl, dt, dd, ul, ol, li, fieldset, button, input, textarea, th, td { margin:0; padding:0;}
body { font:12px/1.6 "微软雅黑", Tahoma, Helvetica, Arial, "\5b8b\4f53", sans-serif; color:#333; text-align:center; background-color:#fff;}
ul, ol, li { list-style:none;}
a { text-decoration:none; color:#333;}
a:hover { text-decoration:none;}
fieldset, img { border:none;}
em { font-style:normal;}
.wjbox { padding:40px 0; text-align:left;}
.wj_tit { height:99px; line-height:99px; background:url(images/wj_lbg.png) repeat-x left bottom; font-size:22px; color:#4da8dd; text-indent:20px;}
.wj_tit em { font-size:40px; margin:0 5px;}
.wj_tit em.a { color:#fd78a7;}
.wj_tit em.b { color:#37cf94;}
.wj_tit em.c { color:#e9b234;}
.wj_tijiao { padding:30px 20px 10px 20px;}
.wj_tijiao a { text-align:center; display:block; width:100%; height:60px; line-height:60px; background-color:#4da8dd; border-radius:4px; font-size:18px; color:#fff; font-weight:bold;}
.wj_tijiao input { text-align:center; width:100%; height:60px; line-height:60px; background-color:#4da8dd; border-radius:4px; font-size:18px; color:#fff; border:none; font-family:"微软雅黑"; font-weight:bold; cursor:pointer; -webkit-appearance:none;}
.wj_da li { height:99px; line-height:99px; background:url(images/wj_lbg.png) repeat-x left bottom; font-size:20px; color:#333; padding:0 85px 0 20px; position:relative;}
.wj_da span em { background-color:#fd78a7; color:#fff; border-radius:25px; display:inline-block; width:40px; height:40px; line-height:40px; text-align:center; border:2px solid #fff; position:absolute; z-index:99; top:28px; left:19px;}

.wj_da .c_fen em { background-color:#fd78a7;}
.wj_da .c_lv em { background-color:#37cf94;}
.wj_da .c_huang em { background-color:#e9b234;}
.wj_da .c_reg em { background-color:reg;}
.wj_da .c_blue em { background-color:blue;}
.wj_da .c_green em { background-color:green;}
.wj_da .c_purple em { background-color:purple;}
.wj_da .c_yellow em { background-color:#ffff00;}

.wj_da .c_fen_q { background-color:#fd78a7; float:left; margin-top:30px; height:40px; border-radius:25px;}
.wj_da .c_lv_q { background-color:#37cf94; float:left; margin-top:30px; height:40px; border-radius:25px;}
.wj_da .c_huang_q { background-color:#e9b234; float:left; margin-top:30px; height:40px; border-radius:25px;}
.wj_da .c_reg_q { background-color:reg; float:left; margin-top:30px; height:40px; border-radius:25px;}
.wj_da .c_blue_q { background-color:blue; float:left; margin-top:30px; height:40px; border-radius:25px;}
.wj_da .c_green_q { background-color:green; float:left; margin-top:30px; height:40px; border-radius:25px;}
.wj_da .c_purple_q { background-color:purple; float:left; margin-top:30px; height:40px; border-radius:25px;}
.wj_da .c_yellow_q { background-color:yellow; float:left; margin-top:30px; height:40px; border-radius:25px;}
.wj_da i { position:absolute; font-style:normal; font-size:24px; right:20px;}
.wj_da i.c_fen_i { color:#fd78a7;}
.wj_da i.c_lv_i { color:#37cf94;}
.wj_da i.c_huang_i { color:#e9b234;}
.wj_da i.c_reg _i { color:reg;}
.wj_da i.c_blue_i { color:blue;}
.wj_da i.c_green_i { color:green;}
.wj_da i.c_purple_i { color:purple;}
.wj_da i.c_yellow_i { color:yellow;}
</style>
</head>

<body>
<div class="wjbox">
	<c:if test="${nos!=null}">
  		<div class="wj_tit">您选择的是<em class="b">${nos }</em></div>
  	</c:if>
  <ul class="wj_da"> 
  	<c:forEach items="${ratios}" var="ratio" varStatus="i">
  		<li><span class="${i.count==1?'c_fen_q':i.count==2?'c_lv_q':i.count==3?'c_huang_q':i.count==4?'c_yellow_q':i.count==5?'c_blue_q':i.count==6?'c_green_q':i.count==7?'c_purple_q':''}" 
  				style="width:${ratio.ratio>96?ratio.ratio-4:ratio.ratio }%;"><span class="${i.count==1?'c_fen':i.count==2?'c_lv':i.count==3?'c_huang':i.count==4?'c_yellow':i.count==5?'c_blue':i.count==6?'c_green':i.count==7?'c_purple':''}"><em>${ratio.no }</em>
  				</span></span><i class="${i.count==1?'c_fen_i':i.count==2?'c_lv_i':i.count==3?'c_huang_i':i.count==4?'c_yellow_i':i.count==5?'c_blue_i':i.count==6?'c_green_i':i.count==7?'c_purple_i':''}">${ratio.ratio }%</i></li>
  	</c:forEach>
  </ul>
  <div class="wj_tijiao"><a href="javascript:history.go(-1)" >返回</a></div>
</div>
</body>
</html>
    