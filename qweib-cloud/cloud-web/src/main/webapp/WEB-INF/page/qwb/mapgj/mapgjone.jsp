<%@ page language="java" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<base href="<%=basePath%>"/>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="base" value="<%=basePath%>" />
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>  
    <title>业务员历史轨迹</title>  
    <!--css-->  
    <style type="text/css">  
        body, html,#map {width: 100%;height: 100%;overflow: hidden;margin:0;}  
        .demo_main { padding: 20px; padding-top: 10px; }  
        .demo_title { padding: 10px; margin-bottom: 10px; background-color: #D3D8E0; border: solid 1px gray; }  
        .demo_content { padding: 10px; margin-bottom: 10px; border: solid 1px gray; }  
        fieldset { border: 1px solid gray; }  
    </style>  
    <!--javascript-->  
    <script src="http://www.w3school.com.cn/jquery/jquery.js" type="text/javascript"></script> 
    <script type="text/javascript" src="${base}resource/WdatePicker.js"></script> 
</head>  
<body>  
    <div class="demo_main">  
        <fieldset class="demo_title"> 
                <input name="mid" id="mid" type="hidden" value="${mid}"/>
            时间: <input name="cxtime" id="cxtime"  onClick="WdatePicker();" style="width: 100px;" readonly="readonly" value="${cxtime}"/>
	         	   <img onclick="WdatePicker({el:'cxtime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
                 <input type="button" value="查询" onclick="toquerycmap();"/>  
        </fieldset>  
        
            <div style="min-height: 500px; width: 100%;" id="map">  
            </div>  
            <script type="text/javascript">  
                var s ="${markerArr}";
                s=s.replace(/\[/g,"['");
				s=s.replace(/\]/g,"']");
				s=s.replace(/,/g,"','");
				s=s.replace(/ \[/g,"[");
				s=s.replace(/\]','\[/g,"],[");
				s=s.replace(/\['\['/g,"[['");
				s=s.replace(/'\]'/g,"']");
                var markerArr = eval(s);
                var map; //Map实例
                function map_init() {  
                    map = new BMap.Map("map");  
                    //第1步：设置地图中心点，厦门市  
                    var point = new BMap.Point(118.103886, 24.489231);  
                    //第2步：初始化地图,设置中心点坐标和地图级别。  
                    map.centerAndZoom(point, 13);  
                    //第3步：启用滚轮放大缩小  
                    map.enableScrollWheelZoom(true);  
                    //第4步：向地图中添加缩放控件  
                    var ctrlNav = new window.BMap.NavigationControl({  
                        anchor: BMAP_ANCHOR_TOP_LEFT,  
                        type: BMAP_NAVIGATION_CONTROL_LARGE  
                    });  
                    map.addControl(ctrlNav);  
                    //第5步：向地图中添加缩略图控件  
                    var ctrlOve = new window.BMap.OverviewMapControl({  
                        anchor: BMAP_ANCHOR_BOTTOM_RIGHT,  
                        isOpen: 1  
                    });  
                    map.addControl(ctrlOve);  
  
                    //第6步：向地图中添加比例尺控件  
                    var ctrlSca = new window.BMap.ScaleControl({  
                        anchor: BMAP_ANCHOR_BOTTOM_LEFT  
                    });  
                    map.addControl(ctrlSca);  
  
                    //第7步：绘制点  
                    var polylinePointsArray = [];  
                    for (var i = 0; i < markerArr.length; i++) {
                        var b=markerArr[i][0].split(":")[1];
                        var p0 = b.split("&")[0];  
                        var p1 = b.split("&")[1];
                        var maker = addMarker(new window.BMap.Point(p0, p1), i);  
                        //addInfoWindow(maker, markerArr[i], i);
                        polylinePointsArray[i] = new BMap.Point(p0,p1);
                     }
                    var polyline = new BMap.Polyline(polylinePointsArray, {strokeColor:"blue", strokeWeight:3, strokeOpacity:0.5});
                    map.addOverlay(polyline);  
                }  
  
                // 添加标注  
                function addMarker(point, index) {
                  var myIcon = new BMap.Icon("${base}upload/attached/markers.png",  
                        new BMap.Size(8, 8), {  
                            offset: new BMap.Size(10, 25),  
                            imageOffset: new BMap.Size(0, 0 - 12 * 25)  
                        });  
                    var marker = new BMap.Marker(point, { icon: myIcon });  
                    map.addOverlay(marker);  
                    return marker;  
                }  
  
                // 添加信息窗口  
                function addInfoWindow(marker, poi) {  
                    //pop弹窗标题  
                    var a=poi[0].split(":")[1];
                    var b=poi[2].split(":")[1];
                    var c=poi[3].split(":")[1];
                    var d=poi[4].split(":")[1];
                    var e=poi[5].split(":")[1];
                    var f=poi[6].split(":")[1];
                    var g=poi[7].split(":")[1];
                    var h=poi[8].split(":")[1];
                    var j=poi[9].split(":")[1];
                    var title = '<div style="font-weight:bold;color:#CE5521;font-size:14px">' +a+ '</div>';  
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
                    var infoWindow = new BMap.InfoWindow(html.join(""), { title: title, width: 200 });  
  
                    var openInfoWinFun = function () {  
                        marker.openInfoWindow(infoWindow);  
                    };  
                    marker.addEventListener("click", openInfoWinFun);  
                    return openInfoWinFun;  
                }  
  
                //异步调用百度js  
                function map_load() {  
                    var load = document.createElement("script");  
                    load.src = "https://api.map.baidu.com/api?v=1.4&callback=map_init";
                    document.body.appendChild(load);  
                   $("#cxtime").val("${cxtime}");
                   $("#mid").val("${mid}");
                }  
                window.onload = map_load;  
                //查询
				function toquerycmap(){
				    var cxtime=$("#cxtime").val();
				    var mid=$("#mid").val();
				    location.href="${base}manager/queryMapGjOne?cxtime="+cxtime+"&mid="+mid;
				}
            </script>  
          
    </div>  
</body>  
</html>  
