<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>  
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0">
<meta content="email=no,telephone=no" name="format-detection"/>
<title>在线订餐</title>
<%@include file="/WEB-INF/page/include/source.jsp"%> 
<link rel="stylesheet" type="text/css" href="resource/yuanqu/css/yq.css" />
</head>
<script type="text/javascript">
	function tohide(){
		$('.zxdc_xl').hide();
	}
	function toshow(){
		$('.zxdc_xl').show();
	}
</script>
<body>
<ul class="zxdc_nav clearfix" >
  <li class="li_l"><a href="javascript:toshow();"  class="cur"><em class="qb ">全部</em></a></li>
  <li class="li_r"><a href="web/dczxyd">已点<em class="sl">3</em></a></li>
</ul>
<ul class="zxdc_xl" style="display:none;">
  <li><a href="javascript:tohide();">套餐</a></li>
  <li><a href="javascript:tohide();">小吃</a></li>
  <li class="last"><a href="javascript:tohide();">饮料</a></li>
</ul>
<ul class="zxdc_list">
  <li>
    <a href="javascript:void(0)"><img class="cm" src="resource/yuanqu/images/dc_c1.jpg"></a>
    <h2><a href="javascript:void(0)">中式西芝糖裹</a></h2>
    <p>价格：<em class="red">19元</em></p>
    <p>近期出售128份</p>
    <div class="zxdc_pc"><span class="dc_px"><span class="dc_pxs" style="width:100%;"></span></span>86好评</div>
    <div class="zxdc_zt"><span class="yd"></span></div>
  </li>
  <li>
    <a href="javascript:void(0)"><img class="cm" src="resource/yuanqu/images/dc_c2.jpg"></a>
    <h2><a href="javascript:void(0)">川味鱼干片</a></h2>
    <p>价格：<em class="red">22元</em></p>
    <p>近期出售203份</p>
    <div class="zxdc_pc"><span class="dc_px"><span class="dc_pxs" style="width:100%;"></span></span>165好评</div>
    <div class="zxdc_zt"><a href="javascript:void(0)" class="ld"></a></div>
  </li>
  <li>
    <a href="javascript:void(0)"><img class="cm" src="resource/yuanqu/images/dc_c3.jpg"></a>
    <h2><a href="javascript:void(0)">酱烧大块肉</a></h2>
    <p>价格：<em class="red">28元</em></p>
    <p>近期出售116份</p>
    <div class="zxdc_pc"><span class="dc_px"><span class="dc_pxs" style="width:100%;"></span></span>97好评</div>
    <div class="zxdc_zt"><span class="yd"></span></div>
  </li>
  <li>
    <a href="javascript:void(0)"><img class="cm" src="resource/yuanqu/images/dc_c4.jpg"></a>
    <h2><a href="javascript:void(0)">麻辣香锅</a></h2>
    <p>价格：<em class="red">22元</em></p>
    <p>近期出售245份</p>
    <div class="zxdc_pc"><span class="dc_px"><span class="dc_pxs" style="width:100%;"></span></span>203好评</div>
    <div class="zxdc_zt"><a href="javascript:void(0)" class="ld"></a></div>
  </li>
</ul>
</body>
</html>