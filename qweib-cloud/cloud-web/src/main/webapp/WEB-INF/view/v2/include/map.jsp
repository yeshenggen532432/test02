<%@ page language="java" pageEncoding="UTF-8" %>
<%--地图--%>
<script type="text/x-uglcw-template" id="map_form">
    <div class="layui-card">
        <div class="layui-card-body">
            <div style="width:800px;height:500px;" minimizable="false"
                 maximizable="false" collapsible="false" closed="true" modal="true">
                <iframe src="" name="mapIframe" id="mapIframe" frameborder="0" marginheight="0" marginwidth="0"
                        width="100%" height="100%"></iframe>
            </div>
        </div>
    </div>
</script>
<%@include file="/WEB-INF/view/v2/include/script-map.jsp" %>
<script>
    var g_mapModel;
    var g_callFun;

    //显示地图
    function g_showMap(paramObj, callFun) {
        var url = "${base}/manager/getmap";
        if (paramObj) {
            var paramStr = '';
            for (var key in paramObj) {
                if (paramStr) paramStr += '&';
                paramStr += key + '=' + paramObj[key];
            }
            url += '?' + paramStr;
        }
        g_callFun = callFun;
        g_mapModel = uglcw.ui.Modal.open({
            area: ['820px', '560px'],
            btns: [],
            content: $('#map_form').html(),
            success: function (container) {
                $(container).find('#mapIframe').attr('src', url);
                //uglcw.ui.init($(container));
            }
        })
    }

    //地图获取标记回调方法
    function g_callMapData(data) {
        if(!data){alert('未找到数据');return false;}
        console.log(data);
        uglcw.ui.Modal.close(g_mapModel);
        if (g_callFun) g_callFun(data);
    }

    //定位
    function uglcw_location(callFun) {
        // 百度地图API功能
        var geolocation = new BMap.Geolocation();
        geolocation.getCurrentPosition(function(r){
            if(this.getStatus() == BMAP_STATUS_SUCCESS){
                callFun(r)
            }
        },{enableHighAccuracy: true})
    }
</script>
