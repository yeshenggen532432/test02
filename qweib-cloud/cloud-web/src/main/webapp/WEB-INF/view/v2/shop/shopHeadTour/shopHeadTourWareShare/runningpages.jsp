<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>执行中的团长组团商品列表</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query query">
                <li>
                    <input type="hidden" uglcw-model="shtwId" value="${shtwId}" uglcw-role="textbox">
                    <input uglcw-model="sdate" uglcw-role="datepicker">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker">
                </li>
                <li>
                    <input uglcw-model="name" uglcw-role="textbox" placeholder="组团名称">
                </li>
                <li>
                    <input uglcw-model="shopMemberName" uglcw-role="textbox" placeholder="团长">
                </li>
                <li>
                    <input uglcw-model="wareNm" uglcw-role="textbox" placeholder="商品名称">
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="status" placeholder="组团状态"
                            uglcw-options="value:''">
                        <option value="">全部</option>
                        <c:forEach items="${tourRunStatusMap}" var="map">
                            <c:if test="${map.key !=0}">
                            <option value="${map.key}">${map.value}</option>
                            </c:if>
                        </c:forEach>
                    </select>
                </li>
                <li>
                    <button uglcw-role="button" class="k-info" id="search">搜索</button>
                    <button uglcw-role="button" id="reset">重置</button>
                </li>
            </ul>
        </div>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options="
                            <%--toolbar: kendo.template($('#toolbar').html()),--%>
							id:'id',
							checkbox:true,
							pageable: true,
                    		url: '${base}manager/shopHeadTourWareShare/runningpages',
                    		criteria: '.query',
                    	">
                <div data-field="name" uglcw-options="width:150">组团名称</div>
                <div data-field="shopMemberName" uglcw-options="width:150">团长</div>
                <div data-field="wareNm" uglcw-options="width:150">商品名称</div>
                <div data-field="unitName" uglcw-options="width:60">单位</div>
                <div data-field="shopPrice" uglcw-options="width:80">商城原价</div>
                <div data-field="price" uglcw-options="width: 80">组团价</div>
                <div data-field="headPrice" uglcw-options="width: 80">团长价</div>
                <div data-field="count" uglcw-options="width: 70, template: uglcw.util.template($('#tpl_count').html())">
                    组团人数
                </div>
                <div data-field="limitQty" uglcw-options="width: 80">限购数量</div>
                <div data-field="startTime" uglcw-options="width:120">开始时间</div>
                <div data-field="endTime" uglcw-options="width:120, template: uglcw.util.template($('#endTime_tpl').html())">结束时间</div>
                <%--<div data-field="planName"--%>
                <%--uglcw-options="width: 100">组团方案--%>
                <%--</div>--%>
                <div data-field="status" uglcw-options="width:100, template:'#=getRunStatus(data.status)#'">
                    组团状态
                </div>
                <div data-field="orderCd"
                     uglcw-options="width: 50">排序
                </div>
            </div>
        </div>
    </div>
</div>

<script id="tpl_count" type="text/x-uglcw-template">
    #var styleText=''#
    #if(data.hasCount)styleText="color:red;font-size:12px;font-weight:bold;"#
    <span onclick="showOrders(#= data.id#,#=data.hasCount#);"
          style="#=styleText#">#=data.hasCount+"/"+data.count  #</span>
</script>
<script id="endTime_tpl" type="text/x-uglcw-template">
    #=data.finalTime?data.finalTime:data.endTime#
</script>

<%--启用操作--%>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    var tourRunStatusArray = [];
    <c:forEach items="${tourRunStatusMap}" var="map">
    tourRunStatusArray.push({
    ${map.key}:
    '${map.value}'
    })
    </c:forEach>

    function getRunStatus(status) {
        for (var i in tourRunStatusArray) {
            var item = tourRunStatusArray[i];
            if (item[status]) {
                return item[status];
            }
        }
    }

    $(function () {
        //ui:初始化
        uglcw.ui.init();

        //查询
        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        })

        //重置
        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.query');
            uglcw.ui.get('#grid').reload();
        })

        //resize();
        //$(window).resize(resize);
        uglcw.ui.loaded();
    })

    function showOrders(id, hasCount) {
        if (hasCount)
            uglcw.ui.openTab('组团订单列表', '${base}manager/shopBforder/toPage?orderType=4&promotionId=' + id);
    }
</script>

</body>
</html>
