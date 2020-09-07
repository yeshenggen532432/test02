<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>驰用T3</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }
    </style>
</head>
<head>
    <style type="text/css">
        html, body {
            margin: 0;
            width: 100%;
            height: 100%;
            background: #ffffff;
        }

        #map {
            width: 100%;
            height: 100%;
        }

        #panel {
            position: absolute;
            top: 30px;
            left: 10px;
            z-index: 999;
            color: #fff;
        }

        #login {
            position: absolute;
            width: 300px;
            height: 40px;
            left: 50%;
            top: 50%;
            margin: -40px 0 0 -150px;
        }

        #login input[type=password] {
            width: 200px;
            height: 30px;
            padding: 3px;
            line-height: 30px;
            border: 1px solid #000;
        }

        #login input[type=submit] {
            width: 80px;
            height: 38px;
            display: inline-block;
            line-height: 38px;
        }
    </style>
    <%@include file="/WEB-INF/view/v2/include/script-map.jsp" %>
</head>
<body>
<div class="layui-fluid">
    <div class="layui-card">
        <div class="layui-card-body">
            <div class="form-horizontal">
                <div class="form-group">
                    <label class="control-label col-xs-2">客户</label>
                    <div class="col-xs-4">
                        <input id="khNm" uglcw-role="textbox" uglcw-model="khNm">
                    </div>
                    <label class="control-label col-xs-2">业务员</label>
                    <div class="col-xs-4">
                        <input uglcw-role="textbox" uglcw-model="memberNm" id="memberNm">
                    </div>
                    <div class="col-xs-6">
                        <button id="search" uglcw-role="button" class="k-button k-info" onclick="toquerycmap()">查询
                        </button>
                        <button id="reset" class="k-button" uglcw-role="button">重置</button>
                    </div>
                </div>
                </form>
            </div>
        </div>
    </div>
</div>
<div id="map"></div>
<script type="text/javascript">
    var s = '${markerArr}';
    /*s=s.replace(/\[/g,"['");
     s=s.replace(/\]/g,"']");
     s=s.replace(/,/g,"','");
     s=s.replace(/ \[/g,"[");
     s=s.replace(/\]','\[/g,"],[");
     s=s.replace(/\['\['/g,"[['");
     s=s.replace(/'\]'/g,"']"); */
    var markerArr = eval(s);
    alert(123);
    var map = new BMap.Map("map", {});                        // 创建Map实例
    map.centerAndZoom(new BMap.Point(118.103886, 24.489231), 13);     // 初始化地图,设置中心点坐标和地图级别
    map.enableScrollWheelZoom();                        //启用滚轮放大缩小
    if (document.createElement('canvas').getContext) {  // 判断当前浏览器是否支持绘制海量点
        var points = [];  // 添加海量点数据
        for (var i = 0; i < markerArr.length; i++) {
            var b = markerArr[i][1].split(":")[1];
            var p0 = b.split("&")[0];
            var p1 = b.split("&")[1];
            points.push(new BMap.Point(p0, p1));
        }
        var options = {
            size: BMAP_POINT_SIZE_BIG,
            shape: BMAP_POINT_SHAPE_STAR,
            color: '#d340c3'
        }
        var pointCollection = new BMap.PointCollection(points, options);  // 初始化PointCollection
        pointCollection.addEventListener('click', function (e) {
            var lng = e.point.lng;
            var lat = e.point.lat;
            var a = "";
            var b = "";
            var c = "";
            var d = "";
            var e = "";
            var f = "";
            var g = "";
            var h = "";
            var j = "";
            for (var i = 0; i < markerArr.length; i++) {
                var s = markerArr[i][1].split(":")[1];
                var p0 = s.split("&")[0];
                var p1 = s.split("&")[1];
                if (p0 == lng && p1 == lat) {
                    a = markerArr[i][0].split(":")[1];
                    b = markerArr[i][2].split(":")[1];
                    c = markerArr[i][3].split(":")[1];
                    d = markerArr[i][4].split(":")[1];
                    e = markerArr[i][5].split(":")[1];
                    f = markerArr[i][6].split(":")[1];
                    g = markerArr[i][7].split(":")[1];
                    h = markerArr[i][8].split(":")[1];
                    j = markerArr[i][9].split(":")[1];
                    break;
                }
            }
            var point = new BMap.Point(lng, lat);
            var title = '<div style="font-weight:bold;color:#CE5521;font-size:14px">' + a + '</div>';
            //pop弹窗信息
            var html = [];
            html.push('<table cellspacing="0" style="table-layout:fixed;width:100%;font:12px arial,simsun,sans-serif"><tbody>');
            html.push('<tr>');
            html.push('<td style="vertical-align:top;line-height:16px;width:50px;white-space:nowrap;word-break:keep-all"><b>联系人:</b></td>');
            html.push('<td style="vertical-align:top;line-height:16px">' + d + ' </td>');
            html.push('</tr>');
            html.push('<tr>');
            html.push('<td style="vertical-align:top;line-height:16px;width:38px;white-space:nowrap;word-break:keep-all"><b>电话:</b></td>');
            html.push('<td style="vertical-align:top;line-height:16px">' + c + ' </td>');
            html.push('</tr>');
            html.push('<tr>');
            html.push('<td style="vertical-align:top;line-height:16px;width:38px;white-space:nowrap;word-break:keep-all"><b>手机:</b></td>');
            html.push('<td style="vertical-align:top;line-height:16px">' + e + ' </td>');
            html.push('</tr>');
            html.push('<tr>');
            html.push('<td style="vertical-align:top;line-height:16px;width:38px;white-space:nowrap;word-break:keep-all"><b>地址:</b></td>');
            html.push('<td style="vertical-align:top;line-height:16px">' + b + ' </td>');
            html.push('</tr>');
            html.push('<tr>');
            html.push('<td style="vertical-align:top;line-height:16px;width:60px;white-space:nowrap;word-break:keep-all"><b>上次拜访:</b></td>');
            html.push('<td style="vertical-align:top;line-height:16px">' + j + ' </td>');
            html.push('</tr>');
            html.push('<tr>');
            html.push('<td style="vertical-align:top;line-height:16px;width:50px;white-space:nowrap;word-break:keep-all"><b>业务员:</b></td>');
            html.push('<td style="vertical-align:top;line-height:16px">' + f + ' </td>');
            html.push('</tr>');
            html.push('<tr>');
            html.push('<td style="vertical-align:top;line-height:16px;width:38px;white-space:nowrap;word-break:keep-all"><b>部门:</b></td>');
            html.push('<td style="vertical-align:top;line-height:16px">' + g + ' </td>');
            html.push('</tr>');
            html.push('<tr>');
            html.push('<td style="vertical-align:top;line-height:16px;width:38px;white-space:nowrap;word-break:keep-all"><b>备注:</td>');
            html.push('<td style="vertical-align:top;line-height:16px">' + h + ' </td>');
            html.push('</tr>');
            html.push('</tbody></table>');
            var infowindow = new BMap.InfoWindow(html.join(""), {title: title, width: 200});
            map.openInfoWindow(infowindow, point);
        });
        map.addOverlay(pointCollection);  // 添加Overlay
    } else {
        alert('请在chrome、safari、IE8+以上浏览器查看本示例');
    }

    //查询
    function toquerycmap() {
        var khNm = document.getElementById("khNm").value;
        var memberNm = document.getElementById("memberNm").value;
        location.href = "${base}manager/querycmap?khNm=" + khNm + "&memberNm=" + memberNm;
    }
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();
        uglcw.ui.get('#reset').on('click', function () {    //重置
            uglcw.ui.clear('.form-horizontal');
        });
        uglcw.ui.loaded()
    })
</script>
</body>
</html>
