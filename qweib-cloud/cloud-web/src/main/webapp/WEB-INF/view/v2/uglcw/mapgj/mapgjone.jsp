<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>驰用T3</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style type="text/css">
        body, html, #map {
            width: 100%;
            height: 100%;
            overflow: hidden;
            margin: 0;
        }
    </style>
</head>
<body>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <div class="form-horizontal">
                <div class="form-group" style="margin-bottom: 3px;">
                    <div class="col-xs-4">
                        <input type="hidden" uglcw-model="mid" id="mid" uglcw-role="textbox" value="${mid}">
                        <input uglcw-model="cxtime" id="cxtime" uglcw-role="datepicker" value="${cxtime}">
                    </div>
                    <div class="col-xs-4">
                        <button uglcw-role="button" onclick="toquerycmap();">查询</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<div style="min-height: 500px; width: 100%;" id="map">
</div>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();
        uglcw.ui.loaded()

    })
</script>
<script type="text/javascript">
    window.onload = map_load;

    //异步调用百度js
    function map_load() {
        var load = document.createElement("script");
        load.src = "${mapUrl}api?v=2&callback=map_init";
        document.body.appendChild(load);
        $("#cxtime").val("${cxtime}");
        $("#mid").val("${mid}");
    }

    var s = "${markerArr}";
    s = s.replace(/\[/g, "['");
    s = s.replace(/\]/g, "']");
    s = s.replace(/,/g, "','");
    s = s.replace(/ \[/g, "[");
    s = s.replace(/\]','\[/g, "],[");
    s = s.replace(/\['\['/g, "[['");
    s = s.replace(/'\]'/g, "']");
    var markerArr = eval(s);
    var map; //Map实例

    function map_init() {
        map = new BMap.Map("map");
        //第1步：启用滚轮放大缩小
        map.enableScrollWheelZoom(true);
        //第2步：向地图中添加缩放控件
        var ctrlNav = new window.BMap.NavigationControl({
            anchor: BMAP_ANCHOR_TOP_LEFT,
            type: BMAP_NAVIGATION_CONTROL_LARGE
        });
        map.addControl(ctrlNav);
        //第3步：向地图中添加缩略图控件
        var ctrlOve = new window.BMap.OverviewMapControl({
            anchor: BMAP_ANCHOR_BOTTOM_RIGHT,
            isOpen: 1
        });
        map.addControl(ctrlOve);
        //第4步：向地图中添加比例尺控件
        var ctrlSca = new window.BMap.ScaleControl({
            anchor: BMAP_ANCHOR_BOTTOM_LEFT
        });
        map.addControl(ctrlSca);


        //默认中心点：厦门
        map.centerAndZoom(new BMap.Point(118.103886, 24.489231), 15);

        //第5步：绘制点
        var polylinePointsArray = [];
        for (var i = 0; i < markerArr.length; i++) {
            var b = markerArr[i][0].split(":")[1];
            var p0 = b.split("&")[0];
            var p1 = b.split("&")[1];

            //已第一点为中心点
            if (i == 0) {
                var point = new BMap.Point(p0, p1);
                map.centerAndZoom(point, 15);
            }
            //标记物
            addMarker(new window.BMap.Point(p0, p1),i);
            polylinePointsArray[i] = new BMap.Point(p0, p1);
        }


        ///第6步：添加线
        var polyline = new BMap.Polyline(polylinePointsArray, {
            strokeColor: "red",
            strokeWeight: 3,
            strokeOpacity: 0.8
        });
        map.addOverlay(polyline);
    }

    // 添加标注
    function addMarker(point) {
        <%--var myIcon = new BMap.Icon("${base}static/img/markerblue.png",--%>
            <%--new BMap.Size(20, 20), {--%>
                <%--offset: new BMap.Size(10, 25),--%>
                <%--imageOffset: new BMap.Size(0, 0 - 12 * 25)--%>
            <%--});--%>
        var myIcon = new BMap.Icon("${base}static/img/marker_blue.png",new BMap.Size(6,6));
        var marker = new BMap.Marker(point, {icon: myIcon});
        map.addOverlay(marker);

        // addInfoWindow(marker);
        return marker;
    }

    // 测试弹出信息
    function addInfoWindow(marker) {
        marker.addEventListener("click", function (e) {
                var opts = {
                    width: 250,     // 信息窗口宽度
                    height: 80,     // 信息窗口高度
                    title: "信息窗口", // 信息窗口标题
                    enableMessage: true//设置允许信息窗发送短息
                };
                var p = e.target;
                var point = new BMap.Point(p.getPosition().lng, p.getPosition().lat);
                var infoWindow = new BMap.InfoWindow("dddd", opts);  // 创建信息窗口对象
                map.openInfoWindow(infoWindow, point); //开启信息窗口
            }
        );
    }

    //查询
    function toquerycmap() {
        var cxtime = $("#cxtime").val();
        var mid = $("#mid").val();
        location.href = "${base}manager/queryMapGjOne?cxtime=" + cxtime + "&mid=" + mid;
    }
</script>

</div>
</body>
</html>  
