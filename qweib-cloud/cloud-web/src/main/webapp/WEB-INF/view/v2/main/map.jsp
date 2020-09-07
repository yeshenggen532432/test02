<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style type="text/css">
        body, html, #allmap {
            width: 100%;
            height: 100%;
            overflow: hidden;
            margin: 0;
        }

        #l-map {
            height: 100%;
            width: 78%;
            float: left;
            border-right: 2px solid #bcbcbc;
        }

        #r-result {
            height: 100%;
            width: 20%;
            float: left;
        }
    </style>
    <title>获取标注</title>
</head>

<body>
<tag:mask></tag:mask>
<div class="form-group">
    <input id="search" uglcw-model="search" uglcw-role="textbox" placeholder="如：xx市xx区具体地址" style="width: 200px;">
    <button uglcw-role="button" class="k-button k-info" onclick="search()">搜索</button>
    <span style="color: red">温馨提示：鼠标右键(放大,缩小,获取标注,恢复初始位置)</span>
</div>
<div id="allmap"></div>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<%@include file="/WEB-INF/view/v2/include/script-map.jsp" %>
<script type="text/javascript">
    $(function () {
        //ui:初始化
        uglcw.ui.init();
        uglcw.ui.loaded();
    })
    //原有位置坐标
    var oldLng = "${oldLng}";
    var oldLat = "${oldLat}";

    //用地区后台换来的坐标(备用)
    var cityLng = "${cityLng}";
    var cityLat = "${cityLat}";
    //当前城市名(备用)
    var cityNm = "${cityNm}";

    //模糊地址
    var searchCondition = "${searchCondition}";

    var map = new BMap.Map("allmap");									// 创建Map实例
    if (oldLng && oldLat) {
        map.centerAndZoom(new BMap.Point(oldLng, oldLat), 13);  	// 初始化地图,泉州坐标
    } else if (cityLng && cityLat) {
        map.centerAndZoom(new BMap.Point(cityLng, cityLat), 13);  		// 初始化地图,设置中心点坐标和地图级别
        if (cityNm) {
            map.setCurrentCity(cityNm);
        }
    }else{
        map.centerAndZoom(new BMap.Point(118.103886,24.489231), 13);  	// 初始化地图,厦门坐标
    }
    map.addControl(new BMap.NavigationControl());					    // 添加平移缩放控件
    map.addControl(new BMap.ScaleControl());							// 添加比例尺控件
    map.addControl(new BMap.OverviewMapControl());						// 添加缩略地图控件
    map.enableScrollWheelZoom();										// 启用滚轮放大缩小
    map.enableContinuousZoom();    										//启用地图惯性拖拽，默认禁用
    map.addControl(new BMap.MapTypeControl());							// 添加地图类型控件

    //右键菜单
    var contextMenu = new BMap.ContextMenu();
    var txtMenuItem = [
        {
            text: '放大',
            callback: function () {
                map.zoomIn()
            }
        },
        {
            text: '缩小',
            callback: function () {
                map.zoomOut()
            }
        },
        {
            text: '获取标注',
            callback: function (p) {
                var point2 = new BMap.Point(p.lng, p.lat);
                var gc2 = new BMap.Geocoder();
                gc2.getLocation(point2, function (rs) {
                    var addComp = rs.addressComponents;
                    Object.assign(addComp, p);
                    callBack(addComp)
                });
            }
        },
        {
            text: '恢复初始位置',
            callback: function () {
                map.reset();
            }
        }
    ];

    for (var i = 0; i < txtMenuItem.length; i++) {
        contextMenu.addItem(new BMap.MenuItem(txtMenuItem[i].text, txtMenuItem[i].callback, 100));
        if (i == 1) {
            contextMenu.addSeparator();
        }
    }
    map.addContextMenu(contextMenu);
    //添加标注
    if (oldLng != "" && oldLat != "") {
        var existPoint = new BMap.Point(oldLng, oldLat);
        var marker = new BMap.Marker(existPoint);
        map.addOverlay(marker);
    } else {
        if (searchCondition) {
            console.log("模糊地址："+ searchCondition)
            var local = new BMap.LocalSearch(map, {
                renderOptions: {map: map}
            });
            local.search(searchCondition);
        }
    }

    //点击事件
    map.addEventListener("click", function (e) {
        if (e.overlay) {
            if (confirm("是否获取标注?")) {
                var point2 = new BMap.Point(e.overlay.getPosition().lng, e.overlay.getPosition().lat);
                var gc2 = new BMap.Geocoder();
                gc2.getLocation(point2, function (rs) {
                    var addComp = rs.addressComponents;
                    Object.assign(addComp, rs.point);
                    callBack(addComp)
                });
            }
        }
    });

    //回调
    function callBack(data) {
        if (window.parent.g_callMapData)
            window.parent.g_callMapData(data);
    }

    /**
     * 模糊搜索
     */
    function search() {
        // 创建地址解析器实例
        var myGeo = new BMap.Geocoder();
        // 将地址解析结果显示在地图上,并调整地图视野
        var search = uglcw.ui.get("#search").value();
        // myGeo.getPoint(search, function(point){
        //     if (point) {
        //         console.log(point);
        //         // map.centerAndZoom(point, 100);
        //         // map.addOverlay(new BMap.Marker(point));
        //     }else{
        //         uglcw.ui.toast("您选择地址没有解析到结果!")
        //     }
        // });
        map.clearOverlays();
        var local = new BMap.LocalSearch(map, {
            renderOptions: {map: map}
        });
        local.search(search);
    }
</script>
</body>
</html>
