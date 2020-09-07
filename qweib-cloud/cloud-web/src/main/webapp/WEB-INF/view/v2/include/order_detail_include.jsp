<%@ page language="java" pageEncoding="UTF-8" %>
<%String hideOrder=request.getParameter("hideOrder");
if(hideOrder==null){
%>
<div data-field="orderNo" uglcw-options="
														  width:190,
														  locked: true,
														  align:'center',
														  template: function(dataItem){
														   return kendo.template($('#orderNo').html())(dataItem);
														  },
                        ">订单号
</div>
<%}%>
<div data-field="orderZt"
     uglcw-options="width:100,align:'center',template: uglcw.util.template($('#orderZt').html())">审核状态
</div>
<%String hidePayInfo=request.getParameter("hidePayInfo");
    if(hidePayInfo==null){
%>
<div data-field="isPay"
     uglcw-options="width:100,align:'center',template: uglcw.util.template($('#isPay').html())">付款状态
</div>
<div data-field="payType"
     uglcw-options="width:100,align:'center',template: uglcw.util.template($('#payType').html())">付款类型
</div>
<div data-field="payTime" uglcw-options="width:100,align:'center'">付款时间</div>
<%}%>
<div data-field="orderType"
     uglcw-options="width:100,align:'center',template: uglcw.util.template($('#orderType_tmp').html())">订单类型
</div>
<div data-field="odtime"
     uglcw-options="width:160,align:'center',template: uglcw.util.template($('#odtime').html())">下单时间
</div>
<div data-field="shTime" uglcw-options="width:100,align:'center'">送货时间</div>
<div data-field="khNm" uglcw-options="width:100,align:'center'">客户名称</div>
<div data-field="shopMemberName" uglcw-options="width:100,align:'center'">会员名称</div>
<div data-field="count" uglcw-options="width:700,hidden: true,template: function(data){
                            return kendo.template($('#product-list').html())(data.list);
                         }">商品信息
</div>
<%--<div data-field="zje" uglcw-options="width:100,align:'center'">总金额</div>
<div data-field="zdzk" uglcw-options="width:100,align:'center'">整单折扣</div>
<div data-field="cjje" uglcw-options="width:100,align:'center'">成交金额</div>--%>
<div data-field="zje" uglcw-options="width:100,align:'center'">商品总价</div>
<div data-field="promotionCost" uglcw-options="width:100,align:'center'">促销</div>
<div data-field="couponCost" uglcw-options="width:100,align:'center'">优惠</div>
<div data-field="freight" uglcw-options="width:100,align:'center'">运费</div>
<div data-field="orderAmount" uglcw-options="width:100,align:'center'">订单应付</div>
<div data-field="shr" uglcw-options="width:100,align:'center'">收货人</div>
<div data-field="tel" uglcw-options="width:110,align:'center'">电话</div>
<div data-field="address" uglcw-options="width:200,align:'center'">地址</div>
<div data-field="remo" uglcw-options="width:200,align:'center'">备注</div>