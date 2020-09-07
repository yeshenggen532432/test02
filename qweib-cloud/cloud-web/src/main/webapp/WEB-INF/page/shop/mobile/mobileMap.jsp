<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>地址导航</title>
    <%@include file="/WEB-INF/page/shop/mobile/include/source2.jsp" %>
    <style type="text/css">
        body, html, #allmap {
            width: 100%;
            height: 100%;
            overflow: hidden;
            margin: 0;
            font-family: "微软雅黑";
        }
    </style>
    <title>测距</title>
</head>
<body>
<header class="mui-bar mui-bar-nav">
    <a class="mui-action-back mui-icon mui-icon-left-nav mui-pull-left"></a>
    <h1 class="mui-title">地址导航</h1>
</header>
<div id="allmap"></div>
</body>
</html>

<%@include file="/WEB-INF/view/v2/include/script-map.jsp" %>
<script type="text/javascript">

    var win = window;
    //监听后退事件
    if (window.parent.backClick) {
        win = window.parent;
        history.pushState(null, null, document.URL);//去除历史记录
        //监听返回
        window.addEventListener("popstate", function (e) {
            window.parent.backClick();
        }, false);
    }


    var mylongitude = "${mylongitude}";
    var mylatitude = "${mylatitude}";

    var longitude = "${longitude}";
    var latitude = "${latitude}";


    // 百度地图API功能
    var map = new BMap.Map("allmap");
    map.addControl(new BMap.NavigationControl());					    // 添加平移缩放控件
    map.addControl(new BMap.ScaleControl());							// 添加比例尺控件
    map.addControl(new BMap.OverviewMapControl());						// 添加缩略地图控件
    map.enableScrollWheelZoom();										// 启用滚轮放大缩小
    map.enableContinuousZoom();    										//启用地图惯性拖拽，默认禁用
    map.addControl(new BMap.MapTypeControl());							// 添加地图类型控件


    var myPoint = new BMap.Point(longitude, latitude);
    if (mylongitude || mylatitude)
        myPoint = new BMap.Point(mylongitude, mylatitude);
    map.centerAndZoom(myPoint, 15);


    if (mylongitude || mylatitude) {
        var circle = new BMap.Circle(myPoint, 200, {strokeColor: "blue", strokeWeight: 1, strokeOpacity: 0.5}); //创建圆


        var pointA = new BMap.Point(mylongitude, mylatitude);  // 创建点坐标A--大渡口区
        var pointB = new BMap.Point(longitude, latitude);  // 创建点坐标B--江北区
        var polyline = new BMap.Polyline([pointA, pointB], {strokeColor: "blue", strokeWeight: 2, strokeOpacity: 0.5});  //定义折线
        addMarker(myPoint, '我的位置');
        map.addOverlay(circle); //增加圆
        map.addOverlay(polyline); //添加折线到地图上
    }

    var point = new BMap.Point(longitude, latitude);//增加点
    addMarker(point, '目地');//增加点


    //点击事件
    /*   map.addEventListener("click", function (e) {
           if (e.overlay) {
               if (confirm("是否获取标注?")) {debugger
                   var point2 = new BMap.Point(e.overlay.getPosition().lng, e.overlay.getPosition().lat);
                   var gc2 = new BMap.Geocoder();
                   gc2.getLocation(point2, function (rs) {
                       var addComp = rs.addressComponents;
                       Object.assign(addComp, rs.point);
                       callBack(addComp)
                   });
               }
           }
       });*/

    // 编写自定义函数,创建标注
    function addMarker(point, labelStr) {
        var marker = new BMap.Marker(point);
        map.addOverlay(marker);
        if (labelStr) {
            var label = new BMap.Label(labelStr, {offset: new BMap.Size(20, -10)});
            marker.setLabel(label);
        }
        marker.addEventListener("click", attribute);
    }

    //获取覆盖物位置
    function attribute(e) {
        mui.confirm('确认选择该地址？', '温馨提示', ['取消', '确认'], function (a) {
            if (a.index == 1) {
                var p = e.target;
                console.log("marker的位置是" + p.getPosition().lng + "," + p.getPosition().lat);
                callBack(p.getPosition().lng, p.getPosition().lat);
            }
        });
    }

    //回调
    function callBack(lng, lat) {
        if (window.parent.g_callMapData) {
            window.parent.g_callMapData(lng, lat);
        } else {
            setCache('lng', lng);
            setCache('lat', lat);
        }
        history.back();
    }

</script>

