<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>餐饮会员订单明细</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <script type="text/javascript" src="${base}static/uglcu/plugins/lodop/LodopFuncs.js"></script>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal">
                <%--<li>
                    <select uglcw-role="combobox" uglcw-model="doStatus" placeholder="订单状态"
                            uglcw-options=" value: '${doStatus}'">
                        <c:forEach items="${statusMap}" var="statusObj">
                            <c:if test="${statusObj.key!=2}">
                                <option value="${statusObj.key}">${statusObj.value}</option>
                            </c:if>
                        </c:forEach>
                        <option value="">--订单状态--</option>
                    </select>
                </li>--%>
                <li>
                    <input uglcw-model="startDoStartTime" uglcw-role="datetimepicker" value="${startDoStartTime}"
                           placeholder="开始时间">
                </li>
                <li>
                    <input uglcw-model="endDoStartTime" uglcw-role="datetimepicker" value="${endDoStartTime}"
                           placeholder="结束时间">
                </li>
                <li>
                    <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                    <button id="reset" class="k-button" uglcw-role="button">重置</button>
                </li>
            </ul>
        </div>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid" uglcw-options="
                    responsive:['.header',40],
                    id:'id',
                    criteria: '.uglcw-query',
                    <c:if test="${flag==2}"> checkbox: true,</c:if>
                    aggregate:[ {field: 'wareZj', aggregate: 'sum'}],
                    toolbar: kendo.template($('#toolbar').html()),
                    url:'${base}manager/shopDiningOrderDetail/diningOrderDetailList?doId=${doId}&diningId=${diningId}',
                    loadFilter: {
                        data: function(response){
                            return response.state ? (response.obj || []) : [];
                        },
                        aggregates: function (response) {
                        var aggregate = {
                            wareZj: 0,
                        };
                        if (response.obj && response.obj.length > 0) {
                             $.map(response.obj, function(item){
                                aggregate.wareZj += item.wareZj;
                             })
                        }
                        return aggregate;
                      }
                    },
                ">
                <div data-field="detailWareNm" uglcw-options="width:150,align:'center',footerTemplate: '总消费'">商品名称
                </div>
                <div data-field="detailWareGg" uglcw-options="width:120,align:'center'">规格</div>
                <div data-field="wareDw" uglcw-options="width:60,align:'center'">单位</div>
                <div data-field="wareDj" uglcw-options="width:60">单价</div>
                <div data-field="wareNum" uglcw-options="width:60">数量</div>
                <div data-field="wareZj"
                     uglcw-options="width:100,align:'center', aggregates: ['sum'], footerTemplate: '\\#= data.wareZj.toFixed(2)\\#'">
                    总价
                </div>
                <div data-field="isPayText" uglcw-options="width:100,align:'center'">是否付款</div>
                <div data-field="ddoCreateTime" uglcw-options="width:150">下单时间</div>
                <div data-field="shopMemberName" uglcw-options="width:100,align:'center'">会员</div>
                <c:if test="${flag==2||flag==10}">
                    <div data-field="ddoIsServeDishesText"
                         uglcw-options="width:100,align:'center',template: uglcw.util.template($('\\#ddoIsServeDishes-tpl').html())">
                        上菜状态
                    </div>
                </c:if>
                <c:if test="${flag==1}">
                    <div data-field="ddoSendKitchen"
                         uglcw-options="width:100,align:'center',template: uglcw.util.template($('\\#ddoSendKitchen-tpl').html())">
                        发送厨房
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</div>


<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>

<script type="text/x-uglcw-template" id="toolbar">
    <c:if test="${flag==1}">
        <a role="button" href="javascript:void(0);" class="k-button k-button-icontext"
           onclick="doSendKitchen(${doId},null)">
            <span class="k-icon k-i-plus-outline"></span>批量发厨房(不重复发送)
        </a>
        选择打印机:
        <select id="PrinterList" onchange="changePringIndex()">
            <option id="select" value='-1' disabled selected style='display:none;'>默认设备</option>
        </select>
    </c:if>

    <c:if test="${flag==2}">
        <a role="button" href="javascript:void(0);" class="k-button k-button-icontext"
           onclick="doServeDishesBatch()">
            <span class="k-icon k-i-plus-outline"></span>上菜(不重复上菜)
        </a>
    </c:if>
    <c:if test="${flag==10}">
        <a role="button" href="javascript:void(0);" class="k-button k-button-icontext"
           onclick="printDetailSelf()">
            <span class="k-icon k-i-plus-outline"></span>打印
        </a>
        <a role="button" href="javascript:void(0);" class="k-button k-button-icontext"
           onclick="showConfirmPay(${doId},0)">
            <span class="k-icon k-i-plus-outline"></span>买单
        </a>
        <a role="button" href="javascript:void(0);" class="k-button k-button-icontext"
           onclick="showConfirmPay(${doId},1)">
            <span class="k-icon k-i-plus-outline"></span>离席买单
        </a>
    </c:if>
    <%--<button class="k-button k-info"
            onclick="payorderquery('#=data.doOrderNo#')">
        查询支付结果
    </button>--%>
</script>

<script type="text/x-uglcw-template" id="ddoIsServeDishes-tpl">
    #var ddoIsServeDishes=data.ddoIsServeDishes?0:1#
    <button class="k-button k-info"
            onclick="doServeDishes(${diningId}, ${doId},#=data.ddoId#,'#=ddoIsServeDishes#')">
        #=data.ddoIsServeDishesText#
    </button>
</script>

<script type="text/x-uglcw-template" id="ddoSendKitchen-tpl">

    <button class="k-button k-info" #if(data.ddoSendKitchen){# style="color: red" #}#
            onclick="doSendKitchen(null,#=data.ddoId#,'#=data.detailWareNm#','#=data.detailWareGg#','#=data.wareDw#','#=data.wareNum#')">
        发厨房(#=data.ddoSendKitchen#)
    </button>

</script>

<%--公用方法转移--%>
<script>

    window.onload = function print() {
        //获取打印机设备数，用于进行遍历
        /* debugger
         var count = LODOP.GET_PRINTER_COUNT();
         for (var i = 0; i < count; i++) {
             //根据设备序号获取设备名
             var msg = LODOP.GET_PRINTER_NAME(i);
             //将设备名添加到select块，并添加相应value值
             $("#PrinterList").append("<option value='" + i + "'>" + msg + "</option>");
             // alert(LODOP.GET_PRINTER_NAME(1));
         }*/
        //if (document.getElementById('PrinterList').innerHTML!="") return;
        var index = localStorage.getItem('uglcw_dining_pring_index') || -1;
        LODOP = getLodop();
        var iPrinterCount = LODOP.GET_PRINTER_COUNT();
        for (var i = 0; i < iPrinterCount; i++) {
            var option = document.createElement('option');
            option.innerHTML = LODOP.GET_PRINTER_NAME(i);
            option.value = i;
            document.getElementById('PrinterList').appendChild(option);
        }
        $('#PrinterList').val(index)
    }

    function changePringIndex() {
        localStorage.setItem('uglcw_dining_pring_index', $('#PrinterList').val());
    }

    $(function () {
        uglcw.ui.init();
        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        })

        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal');
        })

        uglcw.ui.loaded()
    })

    function changePayType(va) {
        $(".pay_form-horizontal").find("[name=payType]:checked").val();
    }


    //批量上菜
    function doServeDishesBatch() {
        let rows = uglcw.ui.get('#grid').selectedRow();
        if (!rows || rows.length == 0) {
            uglcw.ui.error('请选择');
            return false;
        }
        let ids = [];
        rows.forEach(function (item) {
            ids.push(item.ddoId)
        })
        doServeDishes(${diningId}, ${doId}, ids.join(','), 1);
    }


    //发送厨房
    function doSendKitchen(doId, ddoId, detailWareNm, detailWareGg, wareDw, wareNum) {
        var data = {};
        data.doId = doId;
        data.ddoId = ddoId;
        var text = "";
        if (!ddoId)
            text = "<br/>批量发送时,已发送数据不会重复发送！";
        uglcw.ui.confirm("是否确定发送厨房?" + text, function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/shopDiningOrderDetail/doSendKitchen',
                data: data,
                type: 'post',
                async: false,
                success: function (resp) {
                    uglcw.ui.loaded();
                    var msg = resp.message;
                    if (resp.state) {
                        uglcw.ui.info('操作成功，正在发送打印...');
                        if (!ddoId) {
                            var rows = uglcw.ui.get('#grid').value();
                            var params = [];
                            rows.forEach(function (row) {
                                if (!row.ddoSendKitchen) {
                                    var param = {};
                                    param.diningName = '${shopDiningTable.name}';
                                    param.detailWareNm = row.detailWareNm;
                                    param.detailWareGg = row.detailWareGg || '' + '' + row.wareDw || '';
                                    param.wareNum = row.wareNum;
                                    params.push(param)
                                }
                            })
                            if (params.length > 0)
                                sendKitchenPreview(params);
                        } else {
                            var param = {};
                            param.diningName = '${shopDiningTable.name}';
                            param.detailWareNm = detailWareNm;
                            param.detailWareGg = detailWareGg || '' + '' + wareDw || '';
                            param.wareNum = wareNum;
                            sendKitchenPreview([param]);
                        }
                        setTimeout(function () {
                            uglcw.ui.get('#grid').reload();
                            uglcw.ui.loaded();
                        }, 2000);
                    } else {
                        uglcw.ui.loaded();
                        uglcw.ui.error(msg);
                    }
                }
            });
        })
    }


    function printDetailSelf() {
        var param = {};
        param.diningName = '${shopDiningTable.name}';
        param.peopleNumber = '${shopDiningTable.peopleNumber}';
        param.orderNo = '${shopDiningOrder.doOrderNo}';
        param.doDiscountAmount = parseFloat('${shopDiningOrder.doDiscountAmount}' || 0).toFixed(2);
        printDetail(${doId}, param);
    }
</script>
<jsp:include page="/WEB-INF/view/v2/shop/dining/order/opt_include.jsp">
    <jsp:param name="gridName" value="grid"/>
</jsp:include>
<%@include file="/WEB-INF/view/v2/shop/dining/order/detailPring_include.jsp" %>
</body>
</html>
