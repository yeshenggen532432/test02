<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>驰用T3</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <link rel="stylesheet" href="${base}/static/uglcu/css/bill-common.css" media="all">
    <style>
        .uglcw-search input, select {
            height: 30px;
        }

        .snapshot-badge-dot {
            display: none;
            position: absolute;
            -webkit-transform: translateX(-50%);
            transform: translateX(-50%);
            -webkit-transform-origin: 0 center;
            transform-origin: 0 center;
            top: 4px;
            right: 8px;
            height: 8px;
            width: 8px;
            border-radius: 100%;
            background: #ed4014;
            z-index: 10;
            box-shadow: 0 0 0 1px #fff;
        }

        .form-group {
            display: inline-flex;
            width: 100%;
        }

        .form-group .control-label {
            width: 120px;
            text-align: right;
        }

        .form-group .content {
            width: 600px;
            margin-left: 15px;
        }

    </style>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card master">
        <form class="form-horizontal" uglcw-role="validator">
            <div class="layui-card-header btn-group">
                <ul uglcw-role="buttongroup">
                    <li onclick="updateSubmit()" class="k-info" data-icon="save" id="btnsave">保存</li>
                </ul>
            </div>

            <div class="layui-card-body master">
                <div class="form-group">
                    <label class="control-label">报表标题</label>
                    <div class="content">
                        <input type="hidden" uglcw-model="rptType" uglcw-role="textbox" value="1">
                        <input uglcw-role="textbox" uglcw-model="rptTitle" value="${sdate}-${edate}车辆配送客户统计表" size="80">
                    </div>
                </div>

                <div class="form-group">
                    <label class="control-label">备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注</label>
                    <div class="content" style="text-align: left">
                        <textarea uglcw-role="textbox" uglcw-model="remark" style="width: 100%;">报表参数--时间:${sdate}-${edate},车牌号:${vehNo },送货人:${driverName },品名:${wareNm},销售类型:${billName}</textarea>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label">是否同步更新价格：</label>
                    <div class="content">
                        <ul uglcw-role="radio" uglcw-model="updatePrice"
                            uglcw-value="0"
                            uglcw-options='layout:"horizontal",
                                    dataSource:[{"text":"是","value":"1"},
                                                {"text":"否","value":"0"}]'>

                        </ul>
                    </div>
                </div>
            </div>
        </form>
    </div>

    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid-advanced"
                 uglcw-options='
                          lockable: false,
                          draggable: true,
                          reorderable: true,
                          responsive:[".master",40],
                          id: "id",
                          rowNumber: true,
                          checkbox: false,
                          editable: true,
                          height:400,
                          aggregate: [
                            {field: "outQty", aggregate: "sum"},
                            {field: "ioPrice", aggregate: "sum"}
                          ],
                          dataSource:${fns:toJson(datas)}

            '
            >
                <div data-field="vehNo" uglcw-options="width: 100">配送车辆</div>
                <div data-field="customerName" uglcw-options="width: 100">销售客户</div>
                <div data-field="wareNm" uglcw-options="width: 80">品项</div>
                <div data-field="billName" uglcw-options="width: 100">销售类型</div>
                <div data-field="unitName" uglcw-options="width: 100">单位</div>
                <div data-field="outQty" uglcw-options="width: 100,
                   aggregates: ['sum'],
                   footerTemplate: '#= uglcw.util.toString((sum || 0), \'n2\')#'
                        ">发货数量
                </div>
                <div data-field="tranAmt" uglcw-options="width: 100,
                   schema:{type:'number',decimals:10}">单位配送费用
                </div>
                <div data-field="ioPrice" uglcw-options="width: 100,
                   aggregates: ['sum'],
                   footerTemplate: '#= uglcw.util.toString((sum || 0), \'n2\')#'
                        ">配送费用
                </div>
            </div>
        </div>
    </div>
</div>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();
        uglcw.ui.loaded();

        uglcw.ui.get('#grid').k().dataSource.bind('change', function (e) {
            var action = e.action;
            if (action === 'itemchange') {
                var item = e.items[0];
                var commit = false;
                if (e.field === 'tranAmt' || e.field === 'outQty') {
                    item.set('ioPrice', Number((item.outQty * item.tranAmt).toFixed(2)));
                    commit = true;

                }
            }
        })
    });

    function updateSubmit() {
        var data = uglcw.ui.bind('form');
        var form = uglcw.ui.get('#grid').value();
        $(form).each(function (index, item) {
            data['items[' + index + '].driverName'] = item.driverName;
            data['items[' + index + '].customerId'] = item.customerId;
            data['items[' + index + '].customerName'] = item.customerName;
            data['items[' + index + '].wareId'] = item.wareId;
            data['items[' + index + '].wareNm'] = item.wareNm;
            data['items[' + index + '].billName'] = item.billName;
            data['items[' + index + '].unitName'] = item.unitName;
            data['items[' + index + '].outQty'] = item.outQty;
            data['items[' + index + '].unitAmt'] = item.tranAmt;
            data['items[' + index + '].sumAmt'] = item.ioPrice;
        })


        $.ajax({
            url: '${base}manager/saveVehicleCustomerStat',
            type: 'post',
            dataType: 'json',
            data: data,
            success: function (data) {
                data = eval(data)
                if (parseInt(data) > 0) {
                    uglcw.ui.success("保存成功！");
                } else {
                    uglcw.ui.error("保存失败！");
                }
            }
        })

    }

</script>
</body>
</html>
