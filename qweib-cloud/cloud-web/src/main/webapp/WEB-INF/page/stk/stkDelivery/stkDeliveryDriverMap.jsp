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
    <title>司机历史轨迹</title>
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
    <script type="text/javascript" src="<%=basePath %>/resource/jquery.easyui.min.js"></script>
    <link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/easyui/easyui.css">
    <link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/easyui/icon.css">
</head>  
<body>  
    <div class="demo_main">  
        <fieldset class="demo_title" style="font-size: 11px;">
                <input name="driverId" id="driverId" type="hidden" value="${driverId}"/>
            司机:${driverName}
            时间: <input name="cxtime" id="cxtime"  onClick="WdatePicker()" onchange="toquerycmap()" style="width: 100px;" readonly="readonly" value="${cxtime}"/>
	         	   <img onclick="WdatePicker({el:'cxtime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
                <input type="radio" onclick="toquerycmap();" name="psState" value="0"/>待分配(<span style="color: green" onclick="dialogBill('待分配',0,-2)">${billCountMap["0"]}</span>)
            <input type="radio" onclick="toquerycmap();" name="psState" value="1"/>待接收(<span style="color: green" onclick="dialogBill('待接收',1,-2)">${billCountMap["1"]}</span>)
                <input type="radio" onclick="toquerycmap();" name="psState" value="2"/>已接收(<span style="color: green" onclick="dialogBill('已接收',2,-2)">${billCountMap["2"]}</span>)
                <input type="radio" onclick="toquerycmap();" name="psState" value="3"/>配送中(<span style="color: green" onclick="dialogBill('配送中',3,-2)">${billCountMap["3"]}</span>)
                <input type="radio" onclick="toquerycmap();" name="psState" value="4"/>已完成(<span style="color: green" onclick="dialogBill('已完成',4,-2)">${billCountMap["4"]}</span>)
                <input type="radio" onclick="toquerycmap();" name="psState" value="5"/>配送中止(<span style="color:green" onclick="dialogBill('配送中止',5,-2)">${billCountMap["5"]}</span>)
            <input type="radio" onclick="toquerycmap();" name="psState" value=""/>全部(<span style="color:green" onclick="dialogBill('全部','','')">${billCountMap["all"]}</span>)
                <script>
                    $("input:radio[name=psState][value='${psState}']").attr("checked",true);
                </script>
&nbsp;&nbsp;&nbsp;
                 <input type="button" value="查询" onclick="toquerycmap();"/>
        </fieldset>  
        
            <div style="min-height: 500px; width: 100%;" id="map">  
            </div>
        <div id="billDlg" closed="true" class="easyui-dialog" style="width:500px; height:200px;" title="配送单据列表" iconCls="icon-edit">

        </div>
            <script type="text/javascript">
                var cusJson= '${customerArr}';
                var cusDatas = eval(cusJson);
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
                    var point = new BMap.Point(${lng}, ${lat});
                    //第2步：初始化地图,设置中心点坐标和地图级别。
                    map.centerAndZoom(point, 15);
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
                        var time = b.split("&")[2];
                        var maker = addMarker(new window.BMap.Point(p0, p1), i);
                        addTimeInfoWindow(maker,time);
                        polylinePointsArray[i] = new BMap.Point(p0,p1);
                     }
                    var polyline = new BMap.Polyline(polylinePointsArray, {strokeColor:"blue", strokeWeight:3, strokeOpacity:0.5});
                    map.addOverlay(polyline);
                    if(cusDatas!=null){
                      for(var i=0;i<cusDatas.length;i++){
                            var data = cusDatas[i];
                            var p0 = data.lng;
                            var p1 = data.lat;
                            var maker = addMarkerCustomer(new window.BMap.Point(p0, p1));
                            addInfoWindow(maker,data);
                      }
                    }

                }  
  
                // 添加标注  
                function addMarker(point, index) {
                  var myIcon = new BMap.Icon("http://api.map.baidu.com/img/markers.png",
                        new BMap.Size(9, 9), {
                            offset: new BMap.Size(10, 25),  
                            imageOffset: new BMap.Size(0, 0 - 12 * 25)
                        });  
                    var marker = new BMap.Marker(point, { icon: myIcon });  
                    map.addOverlay(marker);  
                    return marker;  
                }

                function addTimeInfoWindow(marker, time) {
                    //pop弹窗标题
                    var title = '<font style="font-weight:bold;color:#CE5521;font-size:12px">'+time+'</font>';
                    // //pop弹窗信息
                    var html = [];
                    var infoWindow = new BMap.InfoWindow(html.join(""), { title: title, width: 100,height:30});
                    var openTimeWinFun = function () {
                        marker.openInfoWindow(infoWindow);
                    };
                    marker.addEventListener("click", openTimeWinFun);
                    return openTimeWinFun;
                }

                function addMarkerCustomer(point) {
                    var myIcon = new BMap.Icon("http://api.map.baidu.com/img/markers.png",
                        new BMap.Size(25, 25), {
                            offset: new BMap.Size(10, 25),
                            imageOffset: new BMap.Size(0, 0 - 12 * 25)
                        });
                    var marker = new BMap.Marker(point, { icon: myIcon });
                    map.addOverlay(marker);
                    return marker;
                }



                // 添加信息窗口  
                function addInfoWindow(marker, data) {
                    //pop弹窗标题  
                    var customerName = data.customerName;
                    var bills = data.bills;
                    var title = '<div style="font-weight:bold;color:#CE5521;font-size:14px">' +customerName+ '</div>';
                    //pop弹窗信息  
                    var html = [];  
                    html.push('<table cellspacing="0" style="table-layout:fixed;width:100%;font:12px arial,simsun,sans-serif"><tbody>');

                    if(bills!=undefined){
                        var len=bills.length;
                        for(var i=0;i<len;i++){
                            var json = bills[i];
                            html.push('<tr>');
                            html.push('<td style="vertical-align:top;line-height:16px;width:50px;white-space:nowrap;word-break:keep-all"><b>配送单号：</b></td>');
                            html.push('<td style="vertical-align:top;line-height:16px" onclick="showBill('+json.billId+')">' + json.billNo + ' </td>');
                            html.push('</tr>');
                        }
                    }

                    html.push('</tbody></table>');

                    var label = new window.BMap.Label(customerName,{offset:new window.BMap.Size(20,-10)});
                    marker.setLabel(label);

                    var infoWindow = new BMap.InfoWindow(html.join(""), { title: title, width: 150 });

                    var openInfoWinFun = function () {
                        marker.openInfoWindow(infoWindow);
                    };
                    marker.addEventListener("click", openInfoWinFun);

                    label.addEventListener("click", openInfoWinFun);

                    return openInfoWinFun;
                }  
  
                //异步调用百度js  
                function map_load() {  
                    var load = document.createElement("script");  
                    load.src = "http://api.map.baidu.com/api?v=1.4&callback=map_init";
                    document.body.appendChild(load);  
                   $("#cxtime").val("${cxtime}");
                   $("#driverId").val("${driverId}");
                }  
                window.onload = map_load;
                //查询
				function toquerycmap(){
				    var cxtime=$("#cxtime").val();
				    var driverId=$("#driverId").val();
                    var psState=$('input:radio[name="psState"]:checked').val();
				    location.href="${base}manager/stkDelivery/driverMap?cxtime="+cxtime+"&driverId="+driverId+"&psState="+psState;
				}

				function showBill(billId) {
                    parent.parent.parent.closeWin('销售配送信息' + billId);
                    parent.parent.parent.add('销售配送信息' +billId, '${base}manager/stkDelivery/show?billId=' + billId);
                }

                function dialogBill(title,psState,status){
                    var url = "${base}/manager/stkDelivery/toPageDialog";
                    var sdate=$("#cxtime").val();
                    var edate=$("#cxtime").val();
                    var driverId=$("#driverId").val();
                    var psState=psState;
                    url+="?sdate="+sdate;
                    url+="&edate="+edate;
                    url+="&status="+status;
                    url+="&driverId="+driverId;
                    url+="&psState="+psState;
                    $('#billDlg').dialog({
                        title: title+'_配送单据列表',
                        iconCls:"icon-edit",
                        width: 800,
                        height: 400,
                        modal: true,
                        href: url,
                        onClose: function(){
                        }
                    });
                    $('#billDlg').dialog('open');
                }

            </script>

    </div>
</body>  
</html>  
