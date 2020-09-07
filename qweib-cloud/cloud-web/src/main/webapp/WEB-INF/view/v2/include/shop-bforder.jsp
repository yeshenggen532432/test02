<%@ page language="java" pageEncoding="UTF-8" %>
<script src="${base}/static/uglcu/shop/bforder.js?v=20191128"></script>
<%--订单号--%>
<script id="orderNo" type="text/x-qeb-template">
    <a href="javascript:showDetail(#= data.id#,#= data.shopDiningId#);" style="color:\\#3343a4;font-size: 12px; font-weight: bold;">#= data.orderNo#</a>
</script>
<%--订单状态--%>
<script id="orderZt" type="text/x-uglcw-template">
    # if(data.orderZt == '未审核' && data.shopDiningId ==null){ #
        #if((data.isPay || data.payType==1)&&data.status){#
            <button onclick="javascript:updateOrderSh(#= data.id #,#= data.payType #);" class="k-button k-info">未审核</button>
        #}else{#
            <span title='订单已支付或线下付款并未取消状态订单才能审核'>未审核</span>
        #}#
    # }else{ #
        <span>#= data.orderZt #</span>
    # } #
</script>

<%--付款状态--%>
<script id="isPay" type="text/x-uglcw-template">
    # if("1" == data.isPay){ #
    已付款
    # } else if("10" == data.isPay){ #
    <span style='color:red;'>已退款</span>
    # } #
</script>
<%--付款类型--%>
<script id="payType" type="text/x-uglcw-template">
    #if(data.payType == 0 && data.shopDiningId ==null){#
    <button class="k-button k-info" onclick='javascript:updatePayType(#=data.id#)' title='修改为线下支付类型'>${orderPayTypeMap[0]}</button>
    #}else{#
        <c:forEach items="${orderPayTypeMap}" var="payTypeMap">
            #if(data.payType==${payTypeMap.key}){#
                ${payTypeMap.value}
            #}#
        </c:forEach>
    #}#
</script>

<%--订单类型--%>
<script id="orderType_tmp" type="text/x-uglcw-template">
    <c:forEach items="${orderTypeMap}" var="orderTypeMap">
        #if(data.orderType==${orderTypeMap.key}){#
        ${orderTypeMap.value}
        #}#
    </c:forEach>
</script>


<%--下单时间--%>
<script id="odtime" type="text/x-uglcw-template">
    <span>#= data.oddate + '  ' + data.odtime #</span>
</script>

<%--商品信息--%>
<script id="product-list" type="text/x-qeb-template">
    <table class="product-grid" style="border:1px \\#3343a4 dashed;padding-left: 5px;">
        <tbody>
        <tr style="font-weight: bold;">
            <td style="width: 120px;">商品名称</td>
            <%--<td style="width: 60px;">销售类型</td>--%>
            <td style="width: 80px;">单位</td>
            <td style="width: 80px;">规格</td>
            <td style="width: 60px;">数量</td>
            <td style="width: 60px;">单价</td>
            <td style="width: 60px;">总价</td>
        </tr>
        #for (var i=0; i< data.length; i++) { #
        <tr>
            <td>#= data[i].detailWareNm #</td>
            <%--<td>#= data[i].xsTp #</td>--%>
            <td>#= data[i].wareDw #</td>
            <%--<td>#= data[i].wareGg #</td>--%>
            <td>#= data[i].detailWareGg #</td>
            <td>#= data[i].wareNum #</td>
            <td>#= data[i].wareDj #</td>
            <td>#= data[i].wareZj #</td>
        </tr>
        # }#
        </tbody>
    </table>
</script>


<%--商品统计信息--%>
<script id="product-group-list" type="text/x-qeb-template">
    <div id="grid1" uglcw-role="grid" uglcw-options="height:400,id:'id',
                    url:'${base}manager/shopBforder/queryShopBforderDetailGroup',
                    criteria: '.uglcw-query',
                    loadFilter: {
                        data: function(response){
                            return response.state ? (response.obj || []) : [];
                        }
                    },
    ">
        <div data-field="detailWareNm" uglcw-options="width:150,align:'center'">商品名称</div>
        <div data-field="detailWareGg" uglcw-options="width:80,align:'center'">规格</div>
        <div data-field="wareDw" uglcw-options="width:60,align:'center'">单位</div>
        <div data-field="wareNum" uglcw-options="width:60,align:'center'">数量</div>
    </div>
</script>