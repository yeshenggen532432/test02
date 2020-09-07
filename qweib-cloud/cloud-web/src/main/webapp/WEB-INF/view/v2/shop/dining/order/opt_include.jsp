<%@ page language="java" pageEncoding="UTF-8" %>
<style>
    .product-grid td {
        padding: 0;
    }

    .pay_body img {
        height: 120px;
        width: 120px;
        margin: 20px;
    }

    .pay_body .main {
        float: left;
        margin-left: 8px;
        position: relative;
    }

    .pay_body .radio {
        position: absolute;
        top: 0;
        right: 0;
        z-index: 1000;
    }
</style>
<script type="text/x-uglcw-template" id="confirm_pay_tpl">
    <div class="layui-card">
        <div class="layui-card-body">
            <form class="pay_form-horizontal" uglcw-role="validator">
                <input uglcw-role="textbox" uglcw-model="diningOrderId" type="hidden">
                <input uglcw-role="textbox" uglcw-model="endDining" type="hidden">
                <div class="form-group">
                    <label class="control-label col-xs-6">菜单总金额</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="allAmount" uglcw-role="textbox"
                               uglcw-validate="required" disabled>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">已买单金额</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="doPayAmount" uglcw-role="textbox"
                               uglcw-validate="required" disabled>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">待买单金额</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" id="noPayAmount" uglcw-model="noPayAmount" uglcw-role="textbox"
                               uglcw-validate="required" disabled>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">折扣金额</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" id="discountAmount" uglcw-model="discountAmount" uglcw-role="numeric"
                               uglcw-validate="number"
                               onkeyup="uglcw.ui.get('#netReceiptsAmount').value($('#noPayAmount').val()-this.value);">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">实收金额</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" id="netReceiptsAmount" uglcw-model="netReceiptsAmount"
                               uglcw-role="numeric" uglcw-validate="number"
                               onkeyup="uglcw.ui.get('#discountAmount').value($('#noPayAmount').val()-this.value);">
                    </div>
                </div>
                <div class="pay_body">
                    <div class="main">
                        <div class="img" onclick="$('.pay_form-horizontal input[name=payType]').get(0).checked=true;">
                            <img alt="线下支付" src="${base}/static/uglcu/images/pay/xianjin.jpg">
                        </div>
                        <div class="radio">
                            <input class="payType" type="radio" name="payType" value="1" checked>
                        </div>
                    </div>
                    <div class="main">
                        <div class="img" onclick="$('.pay_form-horizontal input[name=payType]').get(1).checked=true;">
                            <img alt="支付宝" src="${base}/static/uglcu/images/pay/alipay.jpg">
                        </div>
                        <div class="radio">
                            <input class="payType" type="radio" name="payType" value="4">
                        </div>
                    </div>
                    <div class="main">
                        <div class="img" onclick="$('.pay_form-horizontal input[name=payType]').get(2).checked=true;">
                            <img alt="微信" src="${base}/static/uglcu/images/pay/weixin.jpg">
                        </div>
                        <div class="radio">
                            <input class="payType" type="radio" name="payType" value="3">
                        </div>
                    </div>
                </div>
                <div><input style="width: 500px;" uglcw-model="payNum" id="payNum" uglcw-role="textbox" placeholder="付款码数字"
                            onclick="$(this).focus().select();"
                            onkeydown="if(event.keyCode==13)confirmReceipt();">
                </div>
            </form>
        </div>
    </div>
</script>
<script>

    //弹出确认收款界面
    function showConfirmPay(id, endDining) {
        uglcw.ui.loading();
        $.ajax({
            url: '${base}manager/shopDiningOrder/findById',
            data: {doId: id},
            type: 'post',
            async: false,
            success: function (resp) {
                uglcw.ui.loaded();
                if (resp.state) {
                    var data = resp.obj;
                    if (!data.noPayAmount) {
                        uglcw.ui.error('无金额未收款');
                        return false;
                    }
                    data.endDining = endDining;//是否结束就餐
                    data.netReceiptsAmount = data.noPayAmount;//实收金额=未支付金额
                    data.diningOrderId = data.doId;//订单ID
                    uglcw.ui.Modal.open({
                        title: data.diningName + (endDining ? '-离席买单' : '-买单'),
                        maxmin: false,
                        area: ['600px', '450px'],
                        content: $('#confirm_pay_tpl').html(),
                        success: function (container) {
                            uglcw.ui.init($(container));
                            uglcw.ui.bind($(container), data);
                            $("#payNum").focus();
                        },
                        yes: function () {
                            return confirmReceipt();
                        }
                    })
                } else {
                    uglcw.ui.error(resp.message);
                    return;
                }
            }, error: function (e) {
                uglcw.ui.loaded();
                uglcw.ui.error('出现错误' + e);
            }
        })

    }

    //确认收款
    function confirmReceipt() {
        var data = uglcw.ui.bind('.pay_form-horizontal');
        if (data.payNum) {
            if (data.payNum.indexOf('10') == 0 || data.payNum.indexOf('11') == 0 || data.payNum.indexOf('12') == 0 || data.payNum.indexOf('13') == 0 || data.payNum.indexOf('14') == 0 || data.payNum.indexOf('15') == 0) {
                $('.pay_form-horizontal input[name=payType]').get(2).checked = true;
            } else {
                $('.pay_form-horizontal input[name=payType]').get(1).checked = true;
            }
        }
        var payType = $(".pay_form-horizontal").find("[name=payType]:checked").val();
        if (!data.netReceiptsAmount || !data.endDining || !payType) {
            uglcw.ui.error("参数错误");
            return true;
        }
        if (payType == 4) {
            uglcw.ui.error("开发中....");
            return false;
        }
        data.payType = payType;
        diningRecAndScanpay(data);
    }

    //入帐并调用第三方支付
    function diningRecAndScanpay(data) {
        $.ajax({
            url: '${base}manager/shopDiningOrder/diningRecAndScanpay',
            data: data,
            type: 'post',
            async: false,
            success: function (resp) {
                uglcw.ui.loaded();
                var msg = resp.message;
                if (resp.state) {
                    uglcw.ui.success(msg);
                    uglcw.ui.get('#grid').reload();
                    return true;
                } else {
                    uglcw.ui.error(msg);
                    return false;
                }
            }
        });
    }

    //上下菜
    function doServeDishes(diningId, doId, ddoIds, putOn) {
        var data = {};
        data.diningId = diningId;
        data.doId = doId;
        data.ddoIds = ddoIds;
        data.status = putOn;
        uglcw.ui.confirm("是否确定修改上菜状态?", function () {
            $.ajax({
                url: '${base}manager/shopDiningOrderDetail/doServeDishes',
                data: data,
                type: 'post',
                async: false,
                success: function (resp) {
                    uglcw.ui.loaded();
                    var msg = resp.message;
                    if (resp.state) {
                        uglcw.ui.success(msg);
                        let grid = '<%=request.getParameter("gridName")%>';
                        if (!grid) 'grid';
                        uglcw.ui.get('#' + grid).reload();
                    } else
                        uglcw.ui.error(msg);
                }
            });
        })
    }

    //支付结果查询
    function payorderquery(orderNo) {
        uglcw.ui.confirm("是否支付结果查询?", function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}web/payorderquery',
                data: {orderNo: orderNo},
                type: 'post',
                async: false,
                success: function (resp) {
                    uglcw.ui.loaded();
                    var msg = resp.message;
                    if (resp.state) {
                        uglcw.ui.success(msg);
                    } else
                        uglcw.ui.error(msg);
                }
            });
        })
    }
</script>
