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
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal">
                <li>
                    <select id="zhi" uglcw-role="combobox" uglcw-model="zhi" onchange="toquerycmap();"
                            uglcw-options="index:-1">
                        <option value="" ${id==''?'selected':'' }>请选择</option>
                        <c:forEach items="${infoList}" var="infoList" varStatus="s">
                            <option value="${s.count-1}:${infoList.location}" ${id==s.count-1?'selected':'' }>${infoList.userNm}</option>
                        </c:forEach>
                    </select>
                </li>
            </ul>
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
    //数据
    var id = "${id}";
    var longitude = "${longitude}";
    var latitude = "${latitude}";
    var s = "${markerArr}";
    s = s.replace(/\[/g, "['");
    s = s.replace(/\]/g, "']");
    s = s.replace(/,/g, "','");
    s = s.replace(/ \[/g, "[");
    s = s.replace(/\]','\[/g, "],[");
    s = s.replace(/\['\['/g, "[['");
    s = s.replace(/'\]'/g, "']");
    var markerArr = eval(s);

    //异步调用百度js
    window.onload = map_load;
    function map_load() {
        var load = document.createElement("script");
        load.src = "${mapUrl}api?v=2.0&callback=map_init&s=1";
        document.body.appendChild(load);
    }

    var map; //Map实例
    function map_init() {
        map = new BMap.Map("map");

        //第1步:中心点
        if(longitude && latitude){
            var point = new BMap.Point(longitude, latitude);
            map.centerAndZoom(point, 14);
        }else{
            initLocation();
        }

        //第2步：启用滚轮放大缩小
        map.enableScrollWheelZoom(true);
        //第3步：向地图中添加缩放控件
        var ctrlNav = new window.BMap.NavigationControl({
            anchor: BMAP_ANCHOR_TOP_LEFT,
            type: BMAP_NAVIGATION_CONTROL_LARGE
        });
        map.addControl(ctrlNav);
        //第4步：向地图中添加缩略图控件
        var ctrlOve = new window.BMap.OverviewMapControl({
            anchor: BMAP_ANCHOR_BOTTOM_RIGHT,
            isOpen: 1
        });
        map.addControl(ctrlOve);
        //第5步：向地图中添加比例尺控件
        var ctrlSca = new window.BMap.ScaleControl({
            anchor: BMAP_ANCHOR_BOTTOM_LEFT
        });
        map.addControl(ctrlSca);


        //第6步：绘制点
        for (var i = 0; i < markerArr.length; i++) {
            var b = markerArr[i][1].split(":")[1];
            var unm = markerArr[i][0].split(":")[1];
            var ys = markerArr[i][6].split(":")[1];
            var p0 = b.split("&")[0];
            var p1 = b.split("&")[1];
            var maker = addMarker(new window.BMap.Point(p0, p1), i, unm, ys);
            if (id) {
                if (i == id) {
                    addInfoWindow2(maker, markerArr[i], i);
                } else {
                    addInfoWindow(maker, markerArr[i], i);
                }
            } else {
                addInfoWindow(maker, markerArr[i], i);
            }
        }
    }

    // 添加标注
    function addMarker(point, index,unm,ys) {
        var myLabel = new BMap.Label(unm,
            {offset:new BMap.Size(-24,-12), //label的偏移量，为了让label的中心显示在点上
                position:point}); //label的位置
        myLabel.setStyle({//给label设置样式，任意的CSS都是可以的
            "color":"white",                   //颜色
            "fontSize":"12px",               //字号
            "height":"20px",                //高度
            "width":"42px",                 //宽
            "textAlign":"center",           //文字水平居中显示
            "background":ys,
            "border":"1px solid "+ys,
            "max-width":"inherit"
        });

        map.addOverlay(myLabel); //把label添加到地图上
        var myIcon = new BMap.Icon("${mapUrl}img/markers.png",
            new BMap.Size(23, 25), {
                offset: new BMap.Size(10, 25),
                imageOffset: new BMap.Size(0, 0 - 12 * 25)
            });
        var marker = new BMap.Marker(point, { icon: myIcon });
        map.addOverlay(marker);
        return marker;
    }

    // 添加信息窗口
    function addInfoWindow(marker, poi) {
        var a = poi[0].split(":")[1];
        var b = poi[2].split(":")[1];
        var c = poi[3].split(":")[1];
        var d = poi[4].split(":")[1] + ":" + poi[4].split(":")[2] + ":" + poi[4].split(":")[3];
        var e = poi[5].split(":")[1];
        var title = '<div style="font-weight:bold;color:#CE5521;font-size:14px">' + a + '</div>';
        //pop弹窗信息
        var html = [];
        html.push('<table cellspacing="0" style="table-layout:fixed;width:100%;font:12px arial,simsun,sans-serif"><tbody>');
        html.push('<tr>');
        html.push('<td style="vertical-align:top;line-height:16px;width:38px;white-space:nowrap;word-break:keep-all"><b>电话:</b></td>');
        html.push('<td style="vertical-align:top;line-height:16px">' + c + ' </td>');
        html.push('</tr>');
        html.push('<tr>');
        html.push('<td style="vertical-align:top;line-height:16px;width:38px;white-space:nowrap;word-break:keep-all"><b>地址:</b></td>');
        html.push('<td style="vertical-align:top;line-height:16px">' + b + ' </td>');
        html.push('</tr>');
        html.push('<tr>');
        html.push('<td style="vertical-align:top;line-height:16px;width:60px;white-space:nowrap;word-break:keep-all"><b>时间:</b></td>');
        html.push('<td style="vertical-align:top;line-height:16px">' + d + ' </td>');
        html.push('</tr>');
        html.push('<tr>');
        html.push('<td style="vertical-align:top;line-height:16px;width:50px;white-space:nowrap;word-break:keep-all"><b>状态:</b></td>');
        html.push('<td style="vertical-align:top;line-height:16px">' + e + ' </td>');
        html.push('</tr>');
        html.push('</tbody></table>');
        var infoWindow = new BMap.InfoWindow(html.join(""), {title: title, width: 200});
        var openInfoWinFun = function () {
            marker.openInfoWindow(infoWindow);
        };
        marker.addEventListener("click", openInfoWinFun);
        return openInfoWinFun;
    }

    // 添加信息窗口
    function addInfoWindow2(marker, poi) {
        var a = poi[0].split(":")[1];
        var b = poi[2].split(":")[1];
        var c = poi[3].split(":")[1];
        var d = poi[4].split(":")[1] + ":" + poi[4].split(":")[2] + ":" + poi[4].split(":")[3];
        var e = poi[5].split(":")[1];
        var title = '<div style="font-weight:bold;color:#CE5521;font-size:14px">' + a + '</div>';
        //pop弹窗信息
        var html = [];
        html.push('<table cellspacing="0" style="table-layout:fixed;width:100%;font:12px arial,simsun,sans-serif"><tbody>');
        html.push('<tr>');
        html.push('<td style="vertical-align:top;line-height:16px;width:38px;white-space:nowrap;word-break:keep-all"><b>电话:</b></td>');
        html.push('<td style="vertical-align:top;line-height:16px">' + c + ' </td>');
        html.push('</tr>');
        html.push('<tr>');
        html.push('<td style="vertical-align:top;line-height:16px;width:38px;white-space:nowrap;word-break:keep-all"><b>地址:</b></td>');
        html.push('<td style="vertical-align:top;line-height:16px">' + b + ' </td>');
        html.push('</tr>');
        html.push('<tr>');
        html.push('<td style="vertical-align:top;line-height:16px;width:60px;white-space:nowrap;word-break:keep-all"><b>时间:</b></td>');
        html.push('<td style="vertical-align:top;line-height:16px">' + d + ' </td>');
        html.push('</tr>');
        html.push('<tr>');
        html.push('<td style="vertical-align:top;line-height:16px;width:50px;white-space:nowrap;word-break:keep-all"><b>状态:</b></td>');
        html.push('<td style="vertical-align:top;line-height:16px">' + e + ' </td>');
        html.push('</tr>');
        html.push('</tbody></table>');
        var infoWindow = new BMap.InfoWindow(html.join(""), {title: title, width: 200});
        var openInfoWinFun = marker.openInfoWindow(infoWindow);

        marker.addEventListener("click", openInfoWinFun);
        return openInfoWinFun;
    }



    //查询
    function toquerycmap() {
        var zhi = $("#zhi").val();
        location.href = "${base}/manager/querymmap?zhi=" + encodeURIComponent(zhi);
    }

    //指定60秒刷新一次
    setTimeout('toquerycmap()', 60000);

    /**
     * 定位当前位置
     */
    function initLocation() {
        var geolocation = new BMap.Geolocation();
        geolocation.getCurrentPosition(function(r){
            if(this.getStatus() == BMAP_STATUS_SUCCESS){
                map.centerAndZoom(r.point, 14);
            }
        },{enableHighAccuracy: true})
    }
</script>
</body>

