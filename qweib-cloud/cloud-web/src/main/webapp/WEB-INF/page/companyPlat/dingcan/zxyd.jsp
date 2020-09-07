<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>  
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0">
<meta content="email=no,telephone=no" name="format-detection"/>
<%@include file="/WEB-INF/page/include/source.jsp"%> 
<title>在线订餐-已点</title>
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
<ul class="zxdc_nav clearfix">
  <li class="li_l"><a href="web/dczxdc"><em class="qb"  onclick="toshow();">&nbsp;</em>全部</a></li>
  <li class="li_r"><a href="web/dczxyd" class="cur">已点<em class="sl">3</em></a></li>
</ul>
<ul class="zxdc_xl" style="display:none;">
  <li><a href="javascript:tohide();">套餐</a></li>
  <li><a href="javascript:tohide();">小吃</a></li>
  <li class="last"><a href="javascript:tohide();">饮料</a></li>
</ul>
<ul class="zxdc_list">
  <li>
    <a href="javascript:void(0)"><img class="cm" src="resource/yuanqu/images/dc_c2.jpg"></a>
    <h2><a href="javascript:void(0)">川味鱼干片</a></h2>
    <p>价格：<em class="red">22元</em></p>
    <div class="zxdc_yd_sc"><a href="javascript:void(0)">删除</a></div>
    <dl class="zxdc_yd_jj">
      <dd><a href="javascript:void(0)">+</a></dd>
      <dd><input type="text" value="1"></dd>
      <dd><a href="javascript:void(0)">-</a></dd>
    </dl>
  </li>
  <li>
    <a href="javascript:void(0)"><img class="cm" src="resource/yuanqu/images/dc_c3.jpg"></a>
    <h2><a href="javascript:void(0)">酱烧大块肉</a></h2>
    <p>价格：<em class="red">28元</em></p>
    <div class="zxdc_yd_sc"><a href="javascript:void(0)">删除</a></div>
    <dl class="zxdc_yd_jj">
      <dd><a href="javascript:void(0)">+</a></dd>
      <dd><input type="text" value="1"></dd>
      <dd><a href="javascript:void(0)">-</a></dd>
    </dl>
  </li>
  <li>
    <a href="javascript:void(0)"><img class="cm" src="resource/yuanqu/images/dc_c4.jpg"></a>
    <h2><a href="javascript:void(0)">麻辣香锅</a></h2>
    <p>价格：<em class="red">22元</em></p>
    <div class="zxdc_yd_sc"><a href="javascript:void(0)">删除</a></div>
    <dl class="zxdc_yd_jj">
      <dd><a href="javascript:void(0)">+</a></dd>
      <dd><input type="text" value="1"></dd>
      <dd><a href="javascript:void(0)">-</a></dd>
    </dl>
  </li>
</ul>
<div class="zxdc_tijiao">
  <input type="submit" value="确定">
</div>
</body>
</html>