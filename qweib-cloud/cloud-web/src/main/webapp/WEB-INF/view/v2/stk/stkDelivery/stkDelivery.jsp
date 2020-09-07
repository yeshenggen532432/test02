<%@ page language="java" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>物流配送单</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .uglcw-search input, select {
            height: 30px;
        }

        .layui-card-header.btn-group {
            padding-left: 0px;
            line-height: inherit;
            height: inherit;
        }

        .dropdown-header {
            border-width: 0 0 1px 0;
            text-transform: uppercase;
        }

        .dropdown-header > span {
            display: inline-block;
            padding: 10px;
        }

        .dropdown-header > span:first-child {
            width: 50px;
        }

        .k-list-container > .k-footer {
            padding: 10px;
        }

        .k-grid .k-command-cell .k-button {
            padding-top: 2px;
            padding-bottom: 2px;
        }

        .k-grid tbody tr {
            cursor: move;
        }

        .k-tabstrip .criteria .k-textbox {
            width: 200px;
        }

        .k-tabstrip .criteria {
            margin-bottom: 5px;
        }

        .k-tabstrip .criteria .search {

        }

    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <div class="layui-col-xs12">
            <div class="layui-card master">
                <div class="layui-card-header btn-group">
                    <ul uglcw-role="buttongroup">

                        <c:if test="${delivery.status eq -2 }">
                            <c:if test="${permission:checkUserFieldPdm('stk.stkOut.dragsave')}">
                                <li onclick="draftSaveStk()" id="btndraft" class="k-info" data-icon="save">暂存</li>
                            </c:if>

                            <c:if test="${permission:checkUserFieldPdm('stk.stkOut.saveaudit') }">
                                <li onclick="draftSaveStkAndSend()" id="btnsave" class="k-info" data-icon="track-changes-accept" style="display:${(delivery.status eq -2 and delivery.id eq 0)?'':'none'}">
                                    暂存并发送司机
                                </li>
                            </c:if>
                                <li onclick="sendCar()" id="btnsendCar" class="k-info" data-icon="track-changes-accept" style="display: ${(delivery.id ne 0 and delivery.psState ne 3 and delivery.psState ne 4  and delivery.psState ne 5 )?'':'none'}">装车发货</li>

                            <c:if test="${permission:checkUserFieldPdm('stk.stkOut.audit') }">
                                <li onclick="audit()" id="btndraftaudit" class="k-info" data-icon="track-changes-accept" style="display: ${(delivery.id ne 0 and delivery.status eq -2)?'':'none'}">配送完成</li>
                            </c:if>
                        </c:if>
                        <c:if test="${permission:checkUserFieldPdm('stk.stkOut.print') }">
                            <li onclick="toPrint()" class="k-info" data-icon="print" id="btnprint" style="display: ${delivery.id eq 0?'none':''}">打印</li>
                        </c:if>

                        <c:if test="${permission:checkUserFieldPdm('stk.stkOut.cancel') }">
                            <li onclick="cancelClick()" class="k-info" id="btncancel" style="display: ${(delivery.id eq 0 or delivery.status eq 2)?'none':''}" data-icon="delete">作废</li>
                        </c:if>
                    </ul>
                    <div class="bill-info">

                        <span class="no" style="color: green;"><input id="billNo" uglcw-model="billNo" style="height: 25px;" readonly  uglcw-role="textbox" value="${delivery.billNo}"/></span>
                        <span  class="status" style="color:red;display: none">
                            <c:choose>
                                <c:when test="${delivery.status eq -2}"> <input id="billStatus" style="height: 25px;width: 100px" readonly uglcw-model="billstatus" uglcw-role="textbox" value="暂存"/></c:when>
                                <c:when test="${delivery.status eq 0}"> <input id="billStatus" style="height: 25px;width: 100px" readonly uglcw-model="billstatus" uglcw-role="textbox" value="已审批"/></c:when>
                                <c:when test="${delivery.status eq 1}"> <input id="billStatus" style="height: 25px;width: 100px" readonly uglcw-model="billstatus" uglcw-role="textbox" value="已发货"/></c:when>
                                <c:when test="${delivery.status eq 2}"> <input id="billStatus" style="height: 25px;width: 100px" readonly uglcw-model="billstatus" uglcw-role="textbox" value="已作废"/></c:when>
                                <c:otherwise>
                                    <input id="billStatus" style="height: 25px;width: 100px" readonly uglcw-model="billstatus" uglcw-role="textbox" value="暂存"/>
                                </c:otherwise>
                            </c:choose>
                        </span>
                        <span class="status">
                        <c:choose>
                            <c:when test="${delivery.psState eq 0}">待分配</c:when>
                            <c:when test="${delivery.psState eq 1}">待接收 </c:when>
                            <c:when test="${delivery.psState eq 2}">已接收</c:when>
                            <c:when test="${delivery.psState eq 3}">配送中</c:when>
                            <c:when test="${delivery.psState eq 4}">已收货</c:when>
                            <c:when test="${delivery.psState eq 5}">配送终止</c:when>
                            <c:when test="${delivery.psState eq 6}">已生成发货单</c:when>
                        </c:choose>
                        </span>
                    </div>
                </div>
                <div class="layui-card-body">
                    <form class="form-horizontal" uglcw-role="validator">
                        <input uglcw-role="textbox" type="hidden" uglcw-model="outId" id="outId" value="${delivery.outId}"/>
                        <input uglcw-role="textbox" uglcw-model="orderNo" type="hidden" readonly="readonly" id="orderNo"
                               value="${delivery.orderNo}"/>
                        <input uglcw-role="textbox" type="hidden" uglcw-model="id" id="id" value="${delivery.id}"/>
                        <input uglcw-role="textbox" type="hidden" uglcw-model="outType" id="outType"
                               value="${delivery.outType}"/>
                        <input uglcw-role="textbox" type="hidden" uglcw-model="orderId" id="orderId"
                               value="${delivery.orderId}"/>
                        <input uglcw-role="textbox" type="hidden" uglcw-model="stkId" id="stkId" value="${delivery.stkId}"/>
                        <input uglcw-role="textbox" type="hidden" uglcw-model="status" id="status"
                               value="${delivery.status}"/>
                        <input uglcw-role="textbox" type="hidden" uglcw-model="empId" id="empId" value="${delivery.empId}"/>
                        <input uglcw-role="textbox" type="hidden" uglcw-model="proType" id="proType"
                               value="${delivery.proType}"/>
                        <input uglcw-role="textbox" type="hidden" uglcw-model="psState" id="psState"
                               value="${delivery.psState}"/>
                        <input uglcw-role="textbox" type="hidden" uglcw-model="saleType" id="saleType"
                               value="${delivery.saleType}"/>
                        <div class="form-group">
                            <label class="control-label col-xs-3">单号</label>
                            <div class="col-xs-4">
                                <input uglcw-role="textbox" readonly uglcw-validate="required" value="${delivery.outNo}"
                                       uglcw-model="outNo"/>
                            </div>
                            <label class="control-label col-xs-3">配送日期</label>
                            <div class="col-xs-4">
                                <input uglcw-role="datetimepicker" value="${delivery.outDate}" uglcw-model="outDate"
                                       uglcw-options="format:'yyyy-MM-dd HH:mm'">
                            </div>
                            <label class="control-label  col-xs-3">配送指定</label>
                            <div class="col-xs-4">
                                <input uglcw-role="textbox" readonly uglcw-validate="required" value="${delivery.pszd}"
                                       uglcw-model="pszd"/>
                                <input uglcw-role="textbox" type="hidden" readonly uglcw-validate="required"
                                       value="${delivery.epCustomerId}"
                                       uglcw-model="epCustomerId"/>
                                <input uglcw-role="textbox" type="hidden" readonly uglcw-validate="required"
                                       value="${delivery.epCustomerName}"
                                       uglcw-model="epCustomerName"/>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3">客户名称</label>
                            <div class="col-xs-4">
                                <input type="hidden" uglcw-model="cstId" uglcw-role="textbox" value="${delivery.cstId}"
                                       readonly>
                                <input uglcw-model="khNm" uglcw-role="textbox" value="${delivery.khNm}"
                                       readonly>
                            </div>
                            <label class="control-label col-xs-3">配送地址</label>
                            <div class="col-xs-4">
                                <input uglcw-model="address" uglcw-role="textbox" value="${delivery.address}"
                                       readonly>
                            </div>
                            <label class="control-label col-xs-3">联系电话</label>
                            <div class="col-xs-4">
                                <input uglcw-model="tel" uglcw-role="textbox" value="${delivery.tel}"
                                       readonly>
                            </div>
                        </div>
                        <div class="form-group" style="display: none;">
                            <label class="control-label col-xs-3">合计金额</label>
                            <div class="col-xs-4">
                                <input id="totalAmt" uglcw-model="totalAmt" uglcw-role="numeric"
                                       value="${delivery.totalAmt}"
                                       readonly>
                            </div>
                            <label class="control-label col-xs-3">折扣金额</label>
                            <div class="col-xs-4">
                                <input id="discount" uglcw-model="discount" uglcw-role="numeric"
                                       value="${delivery.discount}">
                            </div>
                            <label class="control-label col-xs-3">单据金额</label>
                            <div class="col-xs-4">
                                <input id="disAmt" uglcw-model="disAmt" uglcw-role="numeric" value="${delivery.disAmt}"
                                       readonly>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3">出货仓库</label>
                            <div class="col-xs-4">
                                <input readonly uglcw-role="textbox" readonly uglcw-model="stkName"
                                       value="${delivery.stkName}"/>
                            </div>
                            <label class="control-label col-xs-3">业&nbsp;&nbsp;务&nbsp;&nbsp;员</label>
                            <div class="col-xs-4">
                                <input uglcw-model="mid" uglcw-role="textbox" type="hidden" id="mid"
                                       value="${delivery.mid}"/>
                                <input uglcw-role="textbox" uglcw-model="staff" value="${delivery.staff}"/>
                            </div>
                            <label class="control-label col-xs-3">联系电话</label>
                            <div class="col-xs-4">
                                <input uglcw-role="textbox" uglcw-model="staffTel" value="${delivery.staffTel}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3">车&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;辆</label>
                            <div class="col-xs-4">
                                <tag:select2 name="vehId" id="vehId" tclass="pcl_sel" value="${delivery.vehId }"
                                             headerKey=""
                                             validate="required"
                                             onchange="changeVehicle(this.value)"
                                             headerValue="" tableName="stk_vehicle" displayKey="id"
                                             displayValue="veh_no"/>
                            </div>
                            <label class="control-label col-xs-3">司&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;机</label>
                            <div class="col-xs-4">
                                <tag:select2 name="driverId" id="driverId" tclass="pcl_sel"
                                             validate="required"
                                             value="${delivery.driverId }" headerKey=""
                                             headerValue="" tableName="stk_driver" displayKey="id"
                                             displayValue="driver_name"/>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3">备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注</label>
                            <div class="col-xs-11">
                                <textarea uglcw-role="textbox" uglcw-model="remarks"
                                          style="width: 100%;">${delivery.remarks}</textarea>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
            <div class="layui-card">
                <div class="layui-card-body full">
                    <div id="grid" uglcw-role="grid"
                         uglcw-options='
                          id: "id",
                          editable: true,
                          height:400,
                          navigatable: true,
                          aggregate: [
                            {field: "qty", aggregate: "sum"},
                            {field: "amt", aggregate: "sum"}
                          ],
                          dataSource: gridDataSource
                        '
                    >
                        <div data-field="wareCode" uglcw-options="width: 100">产品编号</div>
                        <div data-field="wareNm" uglcw-options="width: 140, tooltip: true,editable:false">
                            产品名称
                        </div>
                        <div data-field="wareGg" uglcw-options="width: 80,editable: false">产品规格</div>
                        <div data-field="xsTp" uglcw-options="width: 80,editable: false">销售类型</div>
                        <div data-field="unitName" uglcw-options="width: 80,editable: false">单位</div>
                        <div data-field="qty" uglcw-options="width: 100,
                         hidden:!${permission:checkUserFieldPdm('stk.stkOut.lookqty')},
                        editable: false,
                        aggregates: ['sum'],
                        footerTemplate: '#= (sum || 0) #'">销售数量
                        </div>
                        <div data-field="price" uglcw-options="width: 100,
                        hidden:!${permission:checkUserFieldPdm('stk.stkOut.lookprice')},
                        editable: false">单价
                        </div>
                        <div data-field="amt" uglcw-options="width: 100, editable: false,
                        hidden:!${permission:checkUserFieldPdm('stk.stkOut.lookamt')},
                        aggregates: ['sum'],
                        footerTemplate: '#= (sum || 0) #'">销售金额
                        </div>
                        <div data-field="outQty1" uglcw-options="width:100,
                        hidden:!${permission:checkUserFieldPdm('stk.stkOut.lookqty')},
                        editable: false"
                        >已配送</div>
                        <div data-field="outQty" uglcw-options="width:100, schema:{type:'number',decimals:10, validation:{min: 0}}">
                            本次配送
                        </div>
                        <div data-field="productDate"
                             uglcw-options="width: 120,editable: false">生产日期
                        </div>
                        <div data-field="activeDate"
                             uglcw-options="width: 100,editable: false">有效期
                        </div>
                        <div data-field="remarks" uglcw-options="width:100, schema:{editable: true}">备注</div>
                        <div data-field="options" uglcw-options="width: 100, command:'destroy'">操作</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/x-uglcw-template" id="autocomplete-template">
    <span class="k-state-default"
          style="background-image: url('#: data.warePicList.length > 0 ? 'upload/'+data.warePicList[0].picMini: '' #')"></span>
    <span class="k-state-default"><h3>#: data.wareNm #</h3><p>#: data.wareCode # #: data.wareGg#</p></span>
</script>
<script type="text/x-uglcw-template" id="autocomplete-header-template">

</script>
<script type="text/x-uglcw-template" id="autocomplete-footer-template">
    共匹配 #: instance.dataSource.data().length #项商品
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    var gridDataSource = ${fns:toJson(warelist)};
    $(function () {
        uglcw.ui.init();
        resize();
        $(window).resize(resize);
        uglcw.ui.loaded();
    });

    var delay;

    function resize() {
        if (delay) {
            clearTimeout(delay);
        }
        delay = setTimeout(function () {
            var grid = uglcw.ui.get('#grid').k();
            var padding = 45;
            var height = $(window).height() - padding - $('.master').height() - $('.k-grid-toolbar').height();
            grid.setOptions({
                height: height,
                autoBind: true
            })
        }, 200)
    }

    function draftSaveStkAndSend() {
        var status = uglcw.ui.get('#status').value();
        if (status == 0) {
            return uglcw.ui.error('该单据已审批,不能暂存!');
        }
        var valid = uglcw.ui.get('form').validate();
        if (!valid) {
            return
        }
        var data = uglcw.ui.get('#grid').bind();
        if (data.length < 1) {
            return uglcw.ui.error('没有可配送的商品!');
        }
        var form = uglcw.ui.bind('form');

        $(data).each(function (i, row) {
            $.map(row, function (v, k) {
                form['list[' + i + '].' + k] = v;
            })
        })
        uglcw.ui.get('#psState').value(1);
        uglcw.ui.confirm('是否确定暂存并发送司机？', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/stkDelivery/draftSave',
                data: form,
                type: 'post',
                dataType: 'json',
                success: function (data) {
                    uglcw.ui.loaded();
                    var json = data;
                    if(json.state){
                        uglcw.ui.success('暂存成功');
                        uglcw.ui.get('#billStatus').value('暂存成功');
                        uglcw.ui.get("#id").value(json.id);
                        uglcw.ui.get("#billNo").value(json.billNo);

                        $("#btnsave").hide();
                        $("#btndraftaudit").show();
                        $("#btnprint").show();
                        $("#btncancel").show();
                        $("#btnaudit").hide();
                        $("#btndraftpost").show();
                        isModify=false;
                    }else{
                        uglcw.ui.error(json.msg || '暂存失败');
                    }
                }
            })
        })
    }

    function draftSaveStk() {
        var status = uglcw.ui.get('#status').value();
        if (status == 0) {
            return uglcw.ui.error('该单据已审批,不能暂存!');
        }
        var valid = uglcw.ui.get('form').validate();
        if (!valid) {
            return
        }
        var data = uglcw.ui.get('#grid').bind();
        if (data.length < 1) {
            return uglcw.ui.error('没有可配送的商品!');
        }
        var form = uglcw.ui.bind('form');

        $(data).each(function (i, row) {
            $.map(row, function (v, k) {
                form['list[' + i + '].' + k] = v;
            })
        })

        uglcw.ui.confirm('是否确定暂存？', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/stkDelivery/draftSave',
                data: form,
                type: 'post',
                dataType: 'json',
                success: function (data) {
                    uglcw.ui.loaded();
                    var json = data;
                    if(json.state){
                        uglcw.ui.success('暂存成功');
                        uglcw.ui.get('#billStatus').value('暂存成功');
                        uglcw.ui.get("#id").value(json.id);
                        uglcw.ui.get("#billNo").value(json.billNo);
                        $("#btnsave").hide();
                        $("#btndraftaudit").show();
                        $("#btnprint").show();
                        $("#btncancel").show();
                        //$("#btnaudit").hide();
                        $("#btndraftpost").show();
                        isModify = false;
                    }else{
                        uglcw.ui.error(json.msg || '暂存失败');
                    }
                }
            })
        })
    }

    function sendCar() {
        var status = uglcw.ui.get('#status').value();
        if (status == 2) {
            return uglcw.ui.error('该单据已作废');
        }
        uglcw.ui.confirm('是否确定该操作？', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/stkDelivery/sendCar',
                type: 'post',
                data: {ids: uglcw.ui.get('#id').value(), psState: 3},
                dataType: 'json',
                success: function (response) {
                    uglcw.ui.loaded();
                    if (response.state) {
                        uglcw.ui.success(response.msg);
                        $("#btnsendCar").hide();
                    } else {
                        uglcw.ui.error('操作失败');
                    }
                }
            })

        })
    }

    function audit() {//配送完成
        var billId = uglcw.ui.get('#id').value();
        var status = uglcw.ui.get('#status').value();
        if (!billId) {
            return uglcw.ui.error('请先保存！');
        }
        if (status == 1) {
            return uglcw.ui.error('该单据配送完成');
        }
        if (billId == 0 || status != -2) {
            return uglcw.ui.error('没有可配送完成的单据');
        }

        uglcw.ui.confirm('是否确定配送完成？', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/stkDelivery/audit',
                type: 'post',
                data: {billId: uglcw.ui.get('#id').value()},
                dataType: 'json',
                success: function (json) {
                    uglcw.ui.loaded();
                    if(json.state){
                        uglcw.ui.success('配送成功');
                        uglcw.ui.get('#billStatus').value('配送成功');
                        uglcw.ui.get("#status").value(1);
                        $("#btndraft").hide();
                        $("#btndraftaudit").hide();
                        $("#btnsave").hide();
                        $("#btnprint").show();
                        $("#btncancel").show();
                        $("#btnsendCar").hide();
                        //$("#btnaudit").show();
                    }
                    else
                    {
                        uglcw.ui.error(json.msg);
                    }
                },
                error: function () {
                    uglcw.ui.loaded();
                    uglcw.ui.error('操作失败');
                }
            })

        })
    }

    function toPrint() {
        uglcw.ui.openTab('打印配送单${delivery.id}', '${base}manager/stkDelivery/print?fromFlag=0&billId=' + '${delivery.id}');
    }

    function changeVehicle(id){
        $.ajax({
            url: '${base}manager/queryVehicleById?vehId='+id,
            type: 'post',
            dataType: 'json',
            success: function (response) {
                if (response.state) {
                    var data = response.vehicle;
                    if(data.driverId!=null&&data.driverId!=""){
                        // $("#driverId").val(data.driverId);
                        uglcw.ui.get("#driverId").value(data.driverId);
                    }
                }
            }
        })

    }

    function cancelClick() {
        var billId = uglcw.ui.get('#id').value();
        if (!billId) {
            return uglcw.ui.warning('请先保存');
        }
        var status = uglcw.ui.get('#status').value();
        if (status == 2) {
            return uglcw.ui.error('该单据已作废');
        }
        uglcw.ui.confirm('确定作废吗？', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/stkDelivery/cancel',
                data: {billId: billId},
                type: 'post',
                dataType: 'json',
                success: function (json) {
                    uglcw.ui.loaded();
                    if(json.state){
                        uglcw.ui.success('作废成功');
                        uglcw.ui.get('#billStatus').value('作废成功');
                        uglcw.ui.get("#status").value(2);
                        $("#btndraft").hide();
                        $("#btndraftaudit").hide();
                        $("#btnsave").hide();
                        $("#btnprint").hide();
                        $("#btncancel").hide();
                        $("#btnsendCar").hide();
                    }
                    else
                    {
                        uglcw.ui.error(json.msg || '作废失败');
                    }
                },
                error: function () {
                    uglcw.ui.loaded();
                }
            })
        })

    }
</script>
</body>
</html>
