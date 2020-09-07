<%@ page language="java" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<base href="<%=basePath%>"/>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="base" value="<%=basePath%>" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>  
    <meta name="viewport" content="width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no"/>
    <!--css-->  
    <style type="text/css">  
        body, html,#map {width: 100%;height: 100%;overflow: hidden;margin:0;}  
         
    </style>  
    <script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=gIzggYvrqG7zD5MCsFwSjKOkU8yv8SsC"></script>
  <script type="text/javascript" src="http://developer.baidu.com/map/jsdemo/data/points-sample-data.js"></script>
</head>  
<body>  
     
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
			    var map = new BMap.Map("map", {});                        // 创建Map实例
			    map.centerAndZoom(new BMap.Point(118.103886, 24.489231), 13);     // 初始化地图,设置中心点坐标和地图级别
			    map.enableScrollWheelZoom();                        //启用滚轮放大缩小
			    if (document.createElement('canvas').getContext) {  // 判断当前浏览器是否支持绘制海量点
			        var points = [];  // 添加海量点数据
			        for (var i = 0; i < markerArr.length; i++) {
			           var b=markerArr[i][1].split(":")[1];
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
			          var lng=e.point.lng;
			          var lat=e.point.lat;
			          var a="";
			          var b="";
			          var c="";
			          var d="";
			          var e="";
			          var f="";
			          var g="";
			          var h="";
			          var j="";
			          for (var i = 0; i < markerArr.length; i++) {
			             var s=markerArr[i][1].split(":")[1];
			             var p0 = s.split("&")[0];  
			             var p1 = s.split("&")[1];
			             if(p0==lng&&p1==lat){
					          a=markerArr[i][0].split(":")[1];
		                      b=markerArr[i][2].split(":")[1];
		                      c=markerArr[i][3].split(":")[1];
		                      d=markerArr[i][4].split(":")[1];
		                      e=markerArr[i][5].split(":")[1];
		                      f=markerArr[i][6].split(":")[1];
		                      g=markerArr[i][7].split(":")[1];
		                      h=markerArr[i][8].split(":")[1];
		                      j=markerArr[i][9].split(":")[1];
		                      break;
	                     }
			          }
			        var point = new BMap.Point(lng, lat);
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
                    var infowindow = new BMap.InfoWindow(html.join(""), { title: title, width: 200 });
                    map.openInfoWindow(infowindow, point);
			        });
			        map.addOverlay(pointCollection);  // 添加Overlay
			    } else {
			        alert('请在chrome、safari、IE8+以上浏览器查看本示例');
			    }
			    //查询
				function toquerycmap(){
				    var khNm=document.getElementById("khNm").value;
				    var memberNm=document.getElementById("memberNm").value;
				    location.href="${base}manager/querycmap?khNm="+khNm+"&memberNm="+memberNm;
				}
            </script>  
      
</body>  
</html>  
