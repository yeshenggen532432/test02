<%@ page language="java" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>配货单</title>
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

                        <c:if test="${invoice.status eq -2 }">
                                <li onclick="draftSaveStk()" id="btndraft" class="k-info" data-icon="save">暂存</li>
                                <li onclick="audit()" id="btndraftaudit" class="k-info" data-icon="track-changes-accept" style="display: ${(invoice.id ne 0 and invoice.status eq -2)?'':'none'}">审批</li>
                                <li onclick="submitStk()" class="k-info" data-icon="save"  id="btnaudit"
                                    style="display: ${(invoice.status eq -2 and invoice.id eq 0)?'':'none'}">保存并审批
                                </li>
                        </c:if>
                            <li onclick="toPrint()" class="k-info" data-icon="print" id="btnprint" style="display: ${invoice.id eq 0?'none':''}">打印</li>
                            <li onclick="cancelClick()" class="k-info" id="btncancel" style="display: ${(invoice.id eq 0 or invoice.status eq 2)?'none':''}" data-icon="delete">作废</li>
                    </ul>
                    <div class="bill-info">
                        <span class="no" style="color: green;"><input id="billNo" uglcw-model="billNo" style="height: 25px;" readonly  uglcw-role="textbox" value="${invoice.billNo}"/></span>
                        <span  class="status" style="color:red;">
                            <c:choose>
                                <c:when test="${invoice.status eq -2}"> <input id="billStatus" style="height: 25px;width: 100px" readonly uglcw-model="billstatus" uglcw-role="textbox" value="暂存"/></c:when>
                                <c:when test="${invoice.status eq 1}"> <input id="billStatus" style="height: 25px;width: 100px" readonly uglcw-model="billstatus" uglcw-role="textbox" value="已配货"/></c:when>
                                <c:otherwise>
                                    <input id="billStatus" style="height: 25px;width: 100px" readonly uglcw-model="billstatus" uglcw-role="textbox" value="暂存"/>
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </div>
                <div class="layui-card-body">
                    <form class="form-horizontal" uglcw-role="validator">
                        <input uglcw-role="textbox" type="hidden" uglcw-model="id" id="id" value="${invoice.id}"/>
                        <input uglcw-role="textbox" type="hidden" uglcw-model="sourceBillIds" id="sourceBillIds" value="${invoice.sourceBillIds}"/>
                        <input type="hidden" uglcw-role="textbox" uglcw-model="stkName" id="stkName" value="${invoice.stkName}"/>
                        <input uglcw-role="textbox" type="hidden" uglcw-model="status" id="status"
                               value="${invoice.status}"/>
                        <div class="form-group">

                            <label class="control-label col-xs-3">配货仓库</label>
                            <div class="col-xs-4">
                                <input uglcw-validate="required" uglcw-role="combobox" id="stkId" value="${invoice.stkId}"
                                       uglcw-options="
                                            url: '${base}manager/queryBaseStorage',
                                            dataTextField: 'stkName',
                                            index: 0,
                                            dataValueField: 'id'
                                        "
                                       uglcw-model="stkId"></input>
                            </div>
                            <label class="control-label col-xs-3">配货日期</label>
                            <div class="col-xs-4">
                                <input uglcw-role="datetimepicker" value="${invoice.billTimeStr}" uglcw-model="billTimeStr"
                                       uglcw-options="format:'yyyy-MM-dd HH:mm'">
                            </div>
                        </div>


                        <%--<div class="form-group">--%>
                            <%--<label class="control-label col-xs-3">车&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;辆</label>--%>
                            <%--<div class="col-xs-4">--%>
                                <%--<tag:select2 name="vehId" id="vehId" tclass="pcl_sel" value="${invoice.vehId }"--%>
                                             <%--headerKey=""--%>
                                             <%--validate="required"--%>
                                             <%--onchange="changeVehicle(this.value)"--%>
                                             <%--headerValue="" tableName="stk_vehicle" displayKey="id"--%>
                                             <%--displayValue="veh_no"/>--%>
                            <%--</div>--%>
                            <%--<label class="control-label col-xs-3">司&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;机</label>--%>
                            <%--<div class="col-xs-4">--%>
                                <%--<tag:select2 name="driverId" id="driverId" tclass="pcl_sel"--%>
                                             <%--validate="required"--%>
                                             <%--value="${invoice.driverId }" headerKey=""--%>
                                             <%--headerValue="" tableName="stk_driver" displayKey="id"--%>
                                             <%--displayValue="driver_name"/>--%>
                            <%--</div>--%>
                        <%--</div>--%>
                        <div class="form-group">
                            <label class="control-label col-xs-3">备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注</label>
                            <div class="col-xs-11">
                                <textarea uglcw-role="textbox" uglcw-model="remarks"
                                          style="width: 100%;">${invoice.remarks}</textarea>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
            <div class="layui-card">
                <div class="layui-card-body full">

                    <div uglcw-role="tabs" uglcw-options="
            activate: function(e){
                <%--var $iframe =  $(e.contentElement).find('iframe');--%>
                <%--if(!$iframe.attr('src')){--%>
                    <%--uglcw.ui.loading($(e.contentElement));--%>
                    <%--$iframe.on('load', function(e){--%>
                        <%--kendo.ui.progress($(e.target).closest('.k-content'), false);--%>
                    <%--})--%>
                    <%--$iframe.attr('src', $iframe.attr('data-src'))--%>
                <%--}--%>
            }
    ">
                        <ul>
                            <li>待配货销售单</li>
                            <li>关联单据</li>
                        </ul>
                        <div>
                                <div id="grid" uglcw-role="grid"
                                      uglcw-options='
                              id: "id",
                              editable: true,
                              height:400,
                              navigatable: true,
                              rowNumber: true,
                              aggregate: [
                                {field: "qty", aggregate: "sum"}
                              ],
                              dataSource:${fns:toJson(invoice.mergeList)}
                            '
                            >
                                <div data-field="ware_code" uglcw-options="width: 120">产品编号</div>
                                <div data-field="ware_nm" uglcw-options="width: 140, tooltip: true,editable:false">
                                    产品名称
                                </div>
                                <div data-field="ware_gg" uglcw-options="width: 80,editable: false">产品规格</div>
                                <div data-field="unit_name" uglcw-options="width: 80,editable: false">单位</div>
                                <div data-field="qty" uglcw-options="width: 100,
                            editable: false,
                            aggregates: ['sum'],
                            footerTemplate: '#= (sum || 0) #'">销售数量
                                </div>
                                <div data-field="_billdatas" uglcw-options="width:280,hidden:true,
                             template: function(mergeList){
                                return kendo.template($('#bill-list').html())(mergeList.datas);
                             }
                            ">关联单据
                                </div>
                                <div data-field="" uglcw-options="editable: false"></div>
                            </div>
                        </div>
                            <div>
                            <table class="product-grid">
                                <tbody>
                                <%--<tr style="font-weight: bold;">--%>
                                <%--<td style="width: 100px;">发票单号</td>--%>
                                <%--</tr>--%>
                                <c:forEach items="${billMap}" var="item">
                                <tr>
                                    <td><a href="javascript:showSaleBill(${item.key})" style="color: \\#337ab7;font-size: 12px; font-weight: bold;">${item.value}</a></td>
                                </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                </div>
            </div>
        </div>
    </div>
</div>



<script id="bill-list" type="text/x-uglcw-template">
    <table class="product-grid">
        <tbody>
        <%--<tr style="font-weight: bold;">--%>
            <%--<td style="width: 100px;">发票单号</td>--%>
        <%--</tr>--%>

        #for (var i=0; i< data.length; i++) { #
        <tr>
            <td><a href="javascript:showSaleBill(#= data[i].sourceBillId #)" style="color: \\#337ab7;font-size: 12px; font-weight: bold;">#= data[i].sourceBillNo #</a></td>
        </tr>
        # }#
        </tbody>
    </table>
</script>

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


    function draftSaveStk() {
        var status = uglcw.ui.get('#status').value();
        if (status == 1) {
            return uglcw.ui.error('该单据配货完成,不能暂存!');
        }
        var valid = uglcw.ui.get('form').validate();
        if (!valid) {
            return
        }
        var data = uglcw.ui.get('#grid').bind();
        if (data.length < 1) {
            return uglcw.ui.error('没有可配货的商品!');
        }
        var form = uglcw.ui.bind('form');

        var stkId = form.stkId;
        var bool = true;

        $(data).each(function (i, row) {
            $.map(row, function (v, k) {
                form['list[' + i + '].' + k] = v;
                var billDatas = row.datas;
                for(var j=0;j<billDatas.length;j++){
                    var billJson = billDatas[j];
                    if(billJson.stkId!=""&&billJson.stkId!=stkId){
                        bool = false;
                    }
                }
            })
        })

        if(!bool){
            uglcw.ui.confirm('配货仓库与发票仓库不一致，是否继续确定暂存？', function () {
                uglcw.ui.loading();
                $.ajax({
                    url: '${base}manager/stkInvoice/draftSave',
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
                            isModify = false;
                        }else{
                            uglcw.ui.error(json.msg || '暂存失败');
                        }
                    }
                })
            })


        }else{
            uglcw.ui.confirm('是否确定暂存？', function () {
                uglcw.ui.loading();
                $.ajax({
                    url: '${base}manager/stkInvoice/draftSave',
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
                            isModify = false;
                        }else{
                            uglcw.ui.error(json.msg || '暂存失败');
                        }
                    }
                })
            })
        }
    }

    function submitStk() {
        var status = uglcw.ui.get('#status').value();
        if (status == 1) {
            return uglcw.ui.error('该单据配货完成,不能操作!');
        }
        var valid = uglcw.ui.get('form').validate();
        if (!valid) {
            return
        }
        var data = uglcw.ui.get('#grid').bind();
        if (data.length < 1) {
            return uglcw.ui.error('没有可配货的商品!');
        }
        var form = uglcw.ui.bind('form');

        var stkId = form.stkId;
        var bool = true;

        $(data).each(function (i, row) {
            $.map(row, function (v, k) {
                form['list[' + i + '].' + k] = v;
                var billDatas = row.datas;
                for(var j=0;j<billDatas.length;j++){
                    var billJson = billDatas[j];
                    if(billJson.stkId!=""&&billJson.stkId!=stkId){
                        bool = false;
                    }
                }
            })
        })

        if(!bool){
            uglcw.ui.confirm('配货仓库与发票仓库不一致，是否继续确定保存并审批？', function () {
                uglcw.ui.loading();
                $.ajax({
                    url: '${base}manager/stkInvoice/addAudit',
                    data: form,
                    type: 'post',
                    dataType: 'json',
                    success: function (data) {
                        uglcw.ui.loaded();
                        var json = data;
                        if(json.state){
                            uglcw.ui.success('配货完成');
                            uglcw.ui.get('#billStatus').value('配货完成');
                            uglcw.ui.get("#id").value(json.id);
                            uglcw.ui.get("#billNo").value(json.billNo);
                            $("#btndraft").hide();
                            $("#btndraftaudit").hide();
                            $("#btnsave").hide();
                            $("#btnprint").show();
                            $("#btncancel").show();
                            $("#btnaudit").hide();
                            isModify = false;
                        }else{
                            uglcw.ui.error(json.msg || '配货失败');
                        }
                    }
                })
            })

        }else{
            uglcw.ui.confirm('是否确定保存并审批？', function () {
                uglcw.ui.loading();
                $.ajax({
                    url: '${base}manager/stkInvoice/addAudit',
                    data: form,
                    type: 'post',
                    dataType: 'json',
                    success: function (data) {
                        uglcw.ui.loaded();
                        var json = data;
                        if(json.state){
                            uglcw.ui.success('配货完成');
                            uglcw.ui.get('#billStatus').value('配货完成');
                            uglcw.ui.get("#id").value(json.id);
                            uglcw.ui.get("#billNo").value(json.billNo);
                            $("#btndraft").hide();
                            $("#btndraftaudit").hide();
                            $("#btnsave").hide();
                            $("#btnprint").show();
                            $("#btncancel").show();
                            $("#btnaudit").hide();
                            isModify = false;
                        }else{
                            uglcw.ui.error(json.msg || '配货失败');
                        }
                    }
                })
            })
        }


    }

    function audit() {//配货完成
        var billId = uglcw.ui.get('#id').value();
        var status = uglcw.ui.get('#status').value();
        if (!billId) {
            return uglcw.ui.error('请先保存！');
        }
        if (status == 1) {
            return uglcw.ui.error('该单据配货完成');
        }

        uglcw.ui.confirm('是否确定配货完成？', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/stkInvoice/audit',
                type: 'post',
                data: {billId: uglcw.ui.get('#id').value()},
                dataType: 'json',
                success: function (json) {
                    uglcw.ui.loaded();
                    if(json.state){
                        uglcw.ui.success('配货成功');
                        uglcw.ui.get('#billStatus').value('配货成功');
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
        var billId = uglcw.ui.get('#id').value();

        uglcw.ui.openTab('打印配货单'+billId, '${base}manager/stkInvoice/print?fromFlag=0&billId=' +billId);
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
                url: '${base}manager/stkInvoice/cancel',
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

    function showSaleBill(id) {
        uglcw.ui.openTab("发票信息", "${base}manager/showstkout?dataTp=1&billId=" + id)
    }
</script>
</body>
</html>
