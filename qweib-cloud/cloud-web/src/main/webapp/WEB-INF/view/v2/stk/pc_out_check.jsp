<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>发货确认</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card master">
        <form class="form-horizontal" uglcw-role="validator">
            <div class="actionbar layui-card-header btn-group">
                <ul uglcw-role="buttongroup">
                    <c:if test="${permission:checkUserFieldPdm('stk.stkSend.save')}">
                        <li onclick="auditProc()" class="k-info ghost" data-icon=" ion-md-send">确认发货</li>
                    </c:if>
                </ul>
                <div class="bill-info">
                    <span style="width: 50px;color: red;font-weight: bold;display:${redMark eq 1?'':'none'}">红字单</span>
                    <span class="no" style="color: green;"><div id="billNo" uglcw-model="billNo" style="height: 25px;${redMark eq 1?'color: red':''}"
                                                                uglcw-role="textbox">${billNo}</div></span>
                    <span class="status" style="color:red;"><div id="billStatus" style="height: 25px;width: 80px"
                                                                 uglcw-model="billstatus"
                                                                 uglcw-role="textbox">${billstatus}</div></span>
                    <span class="status" style="color:green;"><div id="paystatus" style="height: 25px;width: 80px"
                                                                   uglcw-model="paystatus"
                                                                   uglcw-role="textbox">${paystatus}</div></span>
                    <c:if test="${not empty verList}">
                        <span uglcw-role="tooltip" uglcw-options="
                            content: $('#bill-version-tpl').html(),
                            showOn: 'click',
                            autoHide: false
                    ">查看反审批版本</span>
                    </c:if>
                </div>
            </div>
            <div class="layui-card-body">
                <input uglcw-role="textbox" type="hidden" uglcw-model="billId" id="billId" value="${billId}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="status" id="status" value="${status}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="proType" id="proType"
                       value="${proType}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="autoPrice" id="autoPrice"
                       value="${autoPrice}"/>
                <div class="form-group">
                    <label class="control-label col-xs-3">单据单号</label>
                    <div class="col-xs-4">
                        <input type="hidden" uglcw-role="textbox" uglcw-model="orderId" id="orderId"
                               value="${orderId}"/>
                        <input uglcw-role="gridselector" uglcw-model="orderNo" value="${billNo}"
                               placeholder="请选择订单"
                               uglcw-options="tooltip:'查看订单', icon:'k-i-eye', click: function(){
                                    uglcw.ui.openTab('销售单据信息', '${base}manager/showstkout?dataTp=1&billId=${billId}');
							   }"/>
                    </div>
                    <label class="control-label col-xs-3" style="color:red;">发货时间</label>
                    <div class="col-xs-4">
                        <input uglcw-role="datetimepicker" uglcw-model="sendTime" value="${sendTime}"
                               placeholder="单据日期"
                               uglcw-options="format: 'yyyy-MM-dd HH:mm'"/>
                    </div>
                    <label class="control-label col-xs-3">配送指定</label>
                    <div class="col-xs-4">
                        <select uglcw-role="combobox" uglcw-model="pszd"
                                uglcw-options="
                                value: '${pszd}'
                                "
                                placeholder="配送指定">
                            <option value="公司直送" selected>公司直送</option>
                            <option value="直供转单二批">直供转单二批</option>
                        </select>
                    </div>
                    <c:if test="${pszd eq '直供转单二批'}">
                        <div id="ep-customer" style="padding-left: 5px; padding-right: 5px;"
                             class="col-xs-3">
                            <input type="hidden" uglcw-role="textbox" uglcw-model="epCustomerId"
                                   value="${epCustomerId}"/>
                            <input uglcw-role="gridselector"
                                   placeholder="二批客户"
                                   uglcw-model="epCustomerName" value="${epCustomerName}"/>
                        </div>
                    </c:if>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-3">
                        客户名称
                    </label>
                    <div class="col-xs-4">
                        <input id="cstId" uglcw-role="textbox" uglcw-model="cstId" type="hidden"
                               value="${cstId}"/>
                        <input uglcw-role="autocomplete" uglcw-model="khNm" id="khNm"
                               placeholder="请选择客户名称"
                               uglcw-options="
                                selectable: true,
                                value: '${khNm}',
                                dataTextField: 'khNm',
                                dataValueField: 'id',
                        "/>
                    </div>
                    <label class="control-label col-xs-3">联系电话</label>
                    <div class="col-xs-4">
                        <input uglcw-role="textbox" uglcw-model="tel" value="${tel}"/>
                    </div>
                    <label class="control-label col-xs-3">配送地址</label>
                    <div class="col-xs-4">
                        <input uglcw-role="textbox" uglcw-model="address" value="${address}"/>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-3">出货仓库</label>
                    <div class="col-xs-4">
                        <select id="stkId" uglcw-validate="required" uglcw-role="combobox"
                                uglcw-options="
                                            url: '${base}manager/queryBaseStorage',
                                            dataTextField: 'stkName',
                                            dataValueField: 'id',
                                            index: 0,
                                            value: '${stkId}'
                                        "
                                uglcw-model="stkId,stkName"></select>
                    </div>
                    <label class="control-label col-xs-3" style="color:red;">运输车辆</label>
                    <div class="col-xs-4">
                        <tag:select2 name="vehId" id="vehId" tclass="pcl_sel" onchange="changeVehicle(this.value)" value="${vehId }" headerKey=""
                                     headerValue="" tableName="stk_vehicle" displayKey="id"
                                     displayValue="veh_no"/>
                    </div>
                    <label class="control-label col-xs-3" style="color:red;">司&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;机</label>
                    <div class="col-xs-4">
                        <tag:select2 name="driverId" id="driverId" tclass="pcl_sel" value="${driverId }"
                                     headerKey=""
                                     headerValue="" tableName="stk_driver" displayKey="id"
                                     displayValue="driver_name"/>
                    </div>
                </div>
                <c:if test="${saleType eq '003'}">
                <div class="form-group">
                    <label class="control-label col-xs-3">
                        物流名称
                    </label>
                    <div class="col-xs-4">
                        <input uglcw-role="textbox" uglcw-model="transportName" value="${transportName}"/>
                    </div>
                    <label class="control-label col-xs-3">物流单号</label>
                    <div class="col-xs-4">
                        <input uglcw-role="textbox" uglcw-model="transportCode" value="${transportCode}"/>
                    </div>
                    <label class="control-label col-xs-3"></label>
                    <div class="col-xs-4">
                    </div>
                </div>
                </c:if>
                <div class="form-group">
                    <label class="control-label col-xs-3" style="color:red;">备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注</label>
                    <div class="col-xs-11">
                                <textarea uglcw-role="textbox" uglcw-model="remarks"
                                          style="width: 100%;">${remarks}</textarea>
                    </div>
                </div>
            </div>
        </form>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <%--<c:forEach items="${warelist}" var="item" varStatus="s">--%>
                <%--${item.wareNm}--%>
            <%--</c:forEach>--%>
            <div id="grid" uglcw-role="grid"
                 uglcw-options='
                          lockable: false,
                          checkbox: true,
                          sortable: {
                            mode: "multiple",
                            allowUnsort: true
                          },
                          autoAppendRow: false,
                          autoMove: false,
                          reorderable: true,
                          responsive:[".master",22],
                          id: "id",
                          minHeight: 250,
                          rowNumber: true,
                          editable: true,
                          toolbar: uglcw.util.template($("#toolbar").html()),
                          aggregate: [
                            {field: "qty", aggregate: "sum"},
                            {field: "outQty", aggregate: "sum"},
                            {field: "outQty1", aggregate: "sum"}
                          ],
                          dataSource: gridDataSource
                        '
            >
                <div data-field="wareCode" uglcw-options="
                            width: 100,
                            footerTemplate: '合计：'
                        ">产品编号
                </div>

                <div data-field="wareNm" uglcw-options="width: 160,
                            locked: false,
                            tooltip: true,
                            ">产品名称
                </div>

                <div data-field="wareGg" uglcw-options="width: 100, editable: false">产品规格</div>
                <div data-field="xsTp" uglcw-options="width: 80">
                    销售类型
                </div>
                <div data-field="beUnit" uglcw-options="width: 60,
                            template: '#= data.beUnit == data.maxUnitCode ? data.wareDw||\'\' : data.minUnit||\'\' #'
                        ">单位
                </div>
                <div data-field="productDate" uglcw-options="width: 100, format: 'yyyy-MM-dd',
                             schema:{ type: 'date'},
                             editor: function(container, options){
                                var model = options.model;
                                var input = $('<input  data-bind=\'value:productDate\' />');
                                input.appendTo(container);
                                var picker = new uglcw.ui.DatePicker(input);
                                picker.init({
                                    editable: true,
                                    format: 'yyyy-MM-dd',
                                    value: model.productDate ? model.productDate : new Date()
                                });
                                picker.k().open();
                             }
                            ">生产日期
                </div>
                <c:if test="${permission:checkUserFieldPdm('stk.stkSend.lookprice')}">
                    <div data-field="price"
                         uglcw-options="width: 80, format:'{0:n2}'">
                        单价
                    </div>
                </c:if>
                <div data-field="qty" uglcw-options="width: 100,
                                aggregates: ['sum'],
                                footerTemplate: '#= (sum||0) #'
                        ">单据数量
                </div>
                <div data-field="outQty" uglcw-options="width: 100,
                                aggregates: ['sum'],
                                footerTemplate: '#= (sum||0) #'
                        ">已发数量
                </div>
                <div data-field="outQty1" uglcw-options="width: 100,
                                aggregates: ['sum'],
                                schema:{ type: 'number',decimals:10, validation: {min: 0}},
                                footerTemplate: '#= (sum||0) #'
                        ">本次发货
                </div>
                <div data-field="sswId" uglcw-options="width: 100,hidden:true, editable: false">
                    sswId
                </div>
                <div data-field="op" uglcw-options="width: 100, command:['destroy']">操作</div>
            </div>
        </div>
    </div>
</div>
<!--模板-->
<script id="toolbar" type="text/x-uglcw-template">
    <a role="button" href="javascript:batchRemove();" class="k-button">
        <span class="k-icon k-i-trash"></span>批量删除
    </a>
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script src="${base}static/uglcu/biz/erp//util.js?v=20200616"></script>
<script>
    var gridDataSource = ${fns:toJson(warelist)};
    $(function () {
        uglcw.ui.init();
        //监听行数据变化
        uglcw.ui.get('#grid').k().dataSource.bind('change', function (e) {
            var action = e.action;
            if (action === 'itemchange') {
                uglcw.ui.get('#grid').commit();
            }
        });
        uglcw.ui.loaded();
    });

    function batchRemove() {
        uglcw.ui.get('#grid').removeSelectedRow();
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

    function auditProc() {
        var valid = uglcw.ui.get('form').validate();
        if (!valid) {
            return;
        }
        var status = uglcw.ui.get('#status').value();
        if (status == 2) {
            return uglcw.ui.warning('该单据已作废');
        }
        var data = uglcw.ui.bind('form');
        var list = uglcw.ui.get('#grid').value();
        var bool = true;
        if('${redMark}'=='1'){
            bool =  checkFormQtySign(list,-1);
        }else{
            bool =  checkFormQtySign(list,1);
        }
        if(!bool){
            return;
        }
        if (list.length < 1) {
            return uglcw.ui.warning('请选择发货商品');
        }
        list = $.map(list, function (r, i) {
            if (r.wareId && r.qty) {
                if (!r.outQty1) {
                    uglcw.ui.warning('[' + (i + 1) + ']: 请输入发货数量');
                    valid = false;
                }
                r.outQty = r.outQty1;
                return r;
            }
        })
        if (!valid) {
            return;
        }
        uglcw.ui.confirm('确定发货吗？', function () {
            $.ajax({
                url: '${base}manager/auditStkOut',
                type: 'post',
                dataType: 'json',
                data: {
                    billId: data.billId,
                    sendTimeStr: data.sendTime,
                    vehId: data.vehId,
                    stkId: data.stkId,
                    driverId: data.driverId,
                    remarks: data.remarks,
                    transportName:data.transportName,
                    transportCode:data.transportCode,
                    wareStr: JSON.stringify(list)
                },
                success: function (response) {
                    if (response.state) {
                        uglcw.ui.success('发货成功');
                        setTimeout(function () {
                            window.location.href = '${base}/manager/lookstkoutcheck?billId=' + data.billId + '&sendId=' + response.sendId;
                        }, 1000);
                    } else {
                        uglcw.ui.error('发货失败:' + response.msg);
                    }
                }
            })
        })
    }

</script>
</body>
</html>
