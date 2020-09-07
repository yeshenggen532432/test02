<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>分销业绩表(按订单)</title>
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
            <ul class="uglcw-query form-horizontal">
                <%--  <li>
                      <c:set var="orderType" value="${order.orderType==null?1:order.orderType}"/>
                      <select uglcw-role="combobox" uglcw-model="orderType" placeholder="订单类型"
                              uglcw-options="clearButton:false">
                          <option value="">--全部--</option>
                          <option value="1"
                                  <c:if test="${order.orderType==1}">selected</c:if> >普通订单
                          </option>
                          <option value="9"
                                  <c:if test="${order.orderType==9}">selected</c:if> >餐饮订单
                          </option>
                          <option value="10"
                                  <c:if test="${order.orderType==10}">selected</c:if> >拼团订单
                          </option>
                      </select>
                      <c:if test="${order.orderType==9}">&lt;%&ndash;如果是餐饮订单时增加时分秒查询&ndash;%&gt;
                          <input type="hidden" uglcw-model="shopDiningId" value="${order.shopDiningId}" uglcw-role="textbox">
                      </c:if>
                  </li>--%>
                <li>
                    <input type="hidden" uglcw-model="tourId" value="${order.tourId}" uglcw-role="textbox">
                    <input type="hidden" uglcw-model="isPay" value="${order.isPay}" uglcw-role="textbox">
                    <input uglcw-model="orderNo" uglcw-role="textbox" placeholder="订单号">
                </li>
                <%-- <li>
                     <input uglcw-model="khNm" uglcw-role="textbox" placeholder="客户名称">
                 </li>
                 <li>
                     <input uglcw-role="textbox" uglcw-model="shopMemberName" placeholder="会员名称">
                 </li>
                 <c:if test="${order.isPay !=10}">
                     <li>
                         <select uglcw-role="combobox" uglcw-model="orderZt" placeholder="订单状态">
                             <option value="正常订单">正常订单</option>
                             <c:forEach items="${orderZtMap}" var="ztMap">
                                 <option value="${ztMap.key}">${ztMap.value}</option>
                             </c:forEach>
                             <option value="">--订单状态--</option>
                         </select>
                     </li>
                 </c:if>
                 <li>
                     <select uglcw-role="combobox" uglcw-model="payType" placeholder="付款类型">
                         <option value="">--付款类型--</option>
                         <c:forEach items="${orderPayTypeMap}" var="payTypeMap">
                             <option value="${payTypeMap.key}"
                                     <c:if test="${order.payType eq payTypeMap.key}">selected</c:if> >${payTypeMap.value}</option>
                         </c:forEach>
                     </select>
                 </li>
                 <li>
                     <tag:select2 name="stkId" id="stkId" tableName="stk_storage"
                                  whereBlock="status=1 or status is null"
                                  headerKey="" headerValue="--选择仓库--"
                                  displayKey="id" displayValue="stk_name"/>
                 </li>
 --%>

                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                </li>
                    <li>
                        <select uglcw-role="combobox" uglcw-model="isAudit" placeholder="审核状态">
                            <option value="">全部</option>
                            <option value="0">未审核</option>
                            <option value="1">审核</option>
                        </select>
                    </li>
                <li>
                    <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                    <button id="reset" class="k-button" uglcw-role="button">重置</button>
                </li>
                <li>
                    <input type="checkbox" uglcw-role="checkbox" id="showProducts">
                    <label style="margin-top: 10px;" class="k-checkbox-label" for="showProducts">显示商品</label>
                </li>
                <li>
                    <a href="${base}/manager/shopDistributorOrder/toMemberTotalPage"><label
                            style="margin-top: 10px;color: blue">分销业绩表（按会员）</label></a>
                </li>
            </ul>
        </div>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options="
 					 responsive:['.header',40],
                    <%--toolbar: kendo.template($('#toolbar').html()),--%>
                    id:'id',
                    checkbox: true,
                    url: '${base}manager/shopDistributorOrder/page',
                    criteria: '.form-horizontal',
                    pageable: true
                    ">
                <div data-field="orderNo" uglcw-options="
														  width:190,
														  locked: true,
														  align:'center',
														  template: function(dataItem){
														   return kendo.template($('#orderNo').html())(dataItem);
														  },
                        ">订单号
                </div>
                <%--<div data-field="status"
                     uglcw-options="width:100,align:'center',template: uglcw.util.template($('#status').html())">状态
                </div>--%>
               <%-- <div data-field="orderZt"
                     uglcw-options="width:100,align:'center',template: uglcw.util.template($('#orderZt').html())">订单状态
                </div>--%>

                <div data-field="isPay"
                     uglcw-options="width:100,align:'center',template: uglcw.util.template($('#isPay').html())">付款状态
                </div>
                <div data-field="isAudit"
                     uglcw-options="width:100,align:'center',template: uglcw.util.template($('#isAudit_templ').html())">结算状态
                </div>
                <%-- <div data-field="payType"
                      uglcw-options="width:100,align:'center',template: uglcw.util.template($('#payType').html())">付款类型
                 </div>--%>
                <div data-field="payTime" uglcw-options="width:130,align:'center'">付款时间</div>
                <%--<div data-field="pszd" uglcw-options="width:100,align:'center'">配送指定</div>--%>
                <%--<div data-field="oddate" uglcw-options="width:110,align:'center'">下单日期</div>--%>
                <%--<div data-field="odtime" uglcw-options="width:110,align:'center'">下单时间</div>--%>
                <div data-field="odtime"
                     uglcw-options="width:130,align:'center',template: uglcw.util.template($('#odtime').html())">下单时间
                </div>
                <div data-field="auditTime" uglcw-options="width:130,align:'center'">结算时间</div>
                <%--<div data-field="shTime" uglcw-options="width:100,align:'center'">送货时间</div>--%>
                <div data-field="count" uglcw-options="width:800,hidden: true,template: function(data){
                             return kendo.template($('#product-list').html())(data.list);
                          }">商品信息
                </div>
                <%--<div data-field="zje" uglcw-options="width:100,align:'center'">总金额</div>
                <div data-field="zdzk" uglcw-options="width:100,align:'center'">整单折扣</div>
                <div data-field="cjje" uglcw-options="width:100,align:'center'">成交金额</div>--%>
                <div data-field="firstAllCommission" uglcw-options="width:100,align:'center'">一级佣金小计</div>
                <div data-field="secondAllCommission" uglcw-options="width:100,align:'center'">二级佣金小计</div>
                <div data-field="thirdAllCommission" uglcw-options="width:100,align:'center'">三级佣金小计</div>
                <div data-field="orderAmount" uglcw-options="width:100,align:'center'">订单支付金额</div>
                <%--<div data-field="khNm" uglcw-options="width:100,align:'center'">客户名称</div>--%>
                <div data-field="shopMemberName" uglcw-options="width:100,align:'center'">下单会员</div>
                <%--<div data-field="secondAllCommission" uglcw-options="width:100,align:'center'">二级总佣金</div>
                <div data-field="thirdAllCommission" uglcw-options="width:100,align:'center'">三级总佣金</div>--%>
                <%--<div data-field="shr" uglcw-options="width:100,align:'center'">收货人</div>
                <div data-field="tel" uglcw-options="width:110,align:'center'">电话</div>
                <div data-field="address" uglcw-options="width:200,align:'center'">地址</div>
                --%>
                <div data-field="opt"
                     uglcw-options="width:160,align:'center',template: uglcw.util.template($('#oper_template').html())">操作
                </div>

            </div>
        </div>
    </div>
</div>

<script id="product-list" type="text/x-kendo-template">
    <table class="product-grid" style="padding-left: 5px;">
        <tbody>
        <tr style="font-weight: bold;">
            <td style="width: 120px;">商品名称</td>
            <td style="width: 60px;">单位</td>
            <td style="width: 80px;">规格</td>
            <td style="width: 60px;">数量</td>
            <td style="width: 60px;">单价</td>
            <td style="width: 60px;">总价</td>
            <td style="width: 100px;text-align: center">一级分销会员<br/>佣金</td>
            <td style="width: 100px;text-align: center">二级分销会员<br/>佣金</td>
            <td style="width: 100px;text-align: center">三级分销会员<br/>佣金</td>
        </tr>
        #for (var i=0; i< data.length; i++) { #
        <tr>
            <td>#= data[i].detailWareNm #</td>
            <td>#= data[i].wareDw #</td>
            <td>#= data[i].detailWareGg #</td>
            <td>#= data[i].wareNum #</td>
            <td>#= data[i].wareDj #</td>
            <td>#= data[i].wareZj #</td>
            <td style="text-align: center">#if(data[i].firstMemberName){##= data[i].firstMemberName||'无' #<br/><span style="color: red">#= data[i].firstCommission||0 ##}#</span></td>
            <td style="text-align: center">#if(data[i].secondMemberName){##= data[i].secondMemberName||'无' #<br/><span style="color: red">#= data[i].secondCommission||0 ##}#</span></td>
            <td style="text-align: center">#if(data[i].thirdMemberName){##= data[i].thirdMemberName||'无' #<br/><span style="color: red">#= data[i].thirdCommission||0 ##}#</span></td>
        </tr>
        # }#
        </tbody>
    </table>
</script>

<script id="isAudit_templ" type="text/x-uglcw-template">
    #=(data.isAudit==0)?'未结算':'已结算'#
</script>

<script id="oper_template" type="text/x-uglcw-template">
    #if(data.isAudit==0 && data.status==4){#
    <button class="k-button k-info" onclick="toAudit(#=data.id#)">结算</button>
    #}#
</script>


<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<%@include file="/WEB-INF/view/v2/include/shop-bforder.jsp" %>

<script>
    $(function () {
        uglcw.ui.init();
        //显示商品
        uglcw.ui.get('#showProducts').on('change', function () {
            var checked = uglcw.ui.get('#showProducts').value();
            var grid = uglcw.ui.get('#grid').k();
            var index = grid.options.columns.findIndex(function (column) {
                return column.field == 'count';
            })
            if (checked) {
                grid.showColumn(index)
            } else {
                grid.hideColumn(index);
            }
        })

        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        })

        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal');
        })

        uglcw.ui.loaded()

        $('#showProducts').trigger('click');
    })

    function toAudit(orderId) {
        uglcw.ui.confirm("是否确定结算", function () {
            uglcw.ui.loading();
            var url = "${base}/manager/shopDistributorOrder/toAudit";
            $.ajax({
                url: url,
                data: {orderId: orderId},
                type: 'post',
                success: function (json) {
                    uglcw.ui.loaded();
                    if (json.state) {
                        uglcw.ui.success('结算成功！');
                        uglcw.ui.get('#grid').reload();
                    }
                },
                error: function () {
                    uglcw.ui.info('结算错误！');
                }
            })
        })
    }
</script>
</body>
</html>
