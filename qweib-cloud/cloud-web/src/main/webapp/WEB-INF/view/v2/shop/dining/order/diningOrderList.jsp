<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>餐饮历史订单</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <script type="text/javascript" src="${base}static/uglcu/plugins/lodop/LodopFuncs.js"></script>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal">
                <input type="hidden" uglcw-model="doDiningId" value="${diningId}" uglcw-role="textbox">
                <c:if test="${empty diningId}">
                    <li>
                        <input uglcw-model="diningName" uglcw-role="textbox" placeholder="桌号" value="${diningName}">
                    </li>
                    <li>
                        <input type="hidden" uglcw-model="isPay" value="${order.isPay}" uglcw-role="textbox">
                        <input uglcw-model="doOrderNo" uglcw-role="textbox" placeholder="餐饮订单号">
                    </li>
                </c:if>
                <li>
                    <select uglcw-role="combobox" uglcw-model="doStatus" placeholder="订单状态"
                            uglcw-options=" value: '${doStatus}'">
                        <c:forEach items="${statusMap}" var="statusObj">
                            <c:if test="${statusObj.key!=2}">
                                <option value="${statusObj.key}">${statusObj.value}</option>
                            </c:if>
                        </c:forEach>
                        <option value="">--订单状态--</option>
                    </select>
                </li>
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
            <div id="grid" uglcw-role="grid"
                 uglcw-options="
 					 responsive:['.header',40],
                    id:'doId',
                    checkbox: false,
                    pageable: true,
                    url: '${base}manager/shopDiningOrder/listPageData',
                    criteria: '.form-horizontal',
                    pageable: true,
                   loadFilter: {
                        data: function(response){
                            return response.state ? (response.obj.rows || []) : [];
                        },
                        total: function (response) {
                            return response.obj.total;
                      }
                    },
                    data: function(param){
                        uglcw.extend(param, uglcw.ui.bind('.uglcw-query'))
                        return param;
                    },
                    dataBound: function(){
                        uglcw.ui.init('#grid')
                    }
                    ">
                <div data-field="diningName" uglcw-options="width:100,align:'center'">桌号</div>
                <div data-field="doOrderNo" uglcw-options="width:150,align:'center'">餐饮订单号</div>
                <div data-field="doStartTime" uglcw-options="width:120,align:'center'">入座时间</div>
                <div data-field="doPeopleNumber" uglcw-options="width:100,align:'center'">人数</div>
                <div data-field="allAmount" uglcw-options="width:100,align:'center'">菜单金额</div>
                <div data-field="doPayAmount" uglcw-options="width:100,align:'center'" title="用户在线支付+线下买单">已付款</div>
                <div data-field="doDiscountAmount" uglcw-options="width:100,align:'center'">折扣金额</div>
                <div data-field="noPayAmount" uglcw-options="width:100,align:'center'">未付款</div>
                <div data-field="doStatusText" uglcw-options="width:100,align:'center'">状态</div>
                <div data-field="opt" uglcw-options="width:300,template: uglcw.util.template($('#opt-tpl').html())">操作</div>

            </div>
        </div>
    </div>
</div>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>

<%--商品信息--%>
<script id="product-list" type="text/x-qeb-template">
    <div id="product_grid" uglcw-role="grid" uglcw-options="height:395,id:'id',aggregate:[ {field: 'wareZj', aggregate: 'sum'}],
                    url:'${base}manager/shopDiningOrderDetail/diningOrderDetailList?doId=#= data.doId#',
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
        <div data-field="detailWareGg" uglcw-options="width:80,align:'center'">规格</div>
        <div data-field="wareDw" uglcw-options="width:60,align:'center'">单位</div>
        <div data-field="wareDj"
             uglcw-options="width:60,align:'center',template:'\\#=data.wareDj+\\'*\\'+data.wareNum\\#'">单价
        </div>
        <div data-field="wareZj"
             uglcw-options="width:100,align:'center', aggregates: ['sum'], footerTemplate: '\\#= data.wareZj.toFixed(2)\\#'">
            总价
        </div>
        <div data-field="isPayText" uglcw-options="width:60,align:'center'">是否付款</div>
        <div data-field="shopMemberName" uglcw-options="width:100,align:'center'">会员</div>
        <div data-field="ddoIsServeDishesText"
             uglcw-options="width:80,align:'center',template: uglcw.util.template($('\\#ddoIsServeDishes-tpl').html())">上菜状态
        </div>
    </div>
</script>
<script type="text/x-uglcw-template" id="opt-tpl">
    <button class="k-button k-info"
            onclick="printDetailSelf(#=data.doId#,'#=data.diningName#','#=data.doPeopleNumber#','#=data.doOrderNo#','#=data.doDiscountAmount#')">
        打印
    </button>

    <button class="k-button k-info"
            onclick="showProductList(#=data.doId#,#=data.noPayAmount||0#,'#=data.diningName#')">
        菜单明细
    </button>
    #if (data.doStatus!=1){#
    <button class="k-button k-info"
            onclick="showConfirmPay(#=data.doId#,0)">买单
    </button>
    <button class="k-button k-info"
            onclick="showConfirmPay(#=data.doId#,1)">
        离席买单
    </button>
    #}#
    <%--<button class="k-button k-info"
            onclick="payorderquery('#=data.doOrderNo#')">
        查询支付结果
    </button>--%>
</script>

<script type="text/x-uglcw-template" id="ddoIsServeDishes-tpl">
    #var ddoIsServeDishes=data.ddoIsServeDishes?0:1#
    <button class="k-button k-info"
            onclick="doServeDishes(#=data.diningId#,#=data.doId#,#=data.ddoId#,'#=ddoIsServeDishes#')">
        #=data.ddoIsServeDishesText#
    </button>
</script>


<%--公用方法转移--%>
<script>
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

    //弹出显示详情
    function showProductList(id, noPayAmount, diningName) {
        var btns = [];
        if (noPayAmount)
            btns = ['买单', '离席买单', '取消'];
        uglcw.ui.Modal.open({
            title: diningName + '菜单明细（' + noPayAmount + "）元未付款",
            maxmin: false,
            btns: btns,
            area: ['800px', '470px'],
            content: uglcw.util.template($('#product-list').html())({data: {doId: id}}),
            success: function (container) {
                uglcw.ui.init($(container));
            },
            yes: function (container) {//买单
                showConfirmPay(id, 0);
            },
            btn2: function () {//离席买单
                showConfirmPay(id, 1);
            }
        })
    }

    function printDetailSelf(doId, diningName, peopleNumber, doOrderNo, doDiscountAmount) {
        debugger
        var param = {};
        param.diningName = diningName;
        param.peopleNumber = peopleNumber;
        param.orderNo = doOrderNo;
        param.doDiscountAmount = parseFloat(doDiscountAmount || 0).toFixed(2);
        printDetail(doId, param);
    }
</script>

<jsp:include page="/WEB-INF/view/v2/shop/dining/order/opt_include.jsp">
    <jsp:param name="gridName" value="product_grid"/>
</jsp:include>
<%@include file="/WEB-INF/view/v2/shop/dining/order/detailPring_include.jsp" %>
</body>
</html>
