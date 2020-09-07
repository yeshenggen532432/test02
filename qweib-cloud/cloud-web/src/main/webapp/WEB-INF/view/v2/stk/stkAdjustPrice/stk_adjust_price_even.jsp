<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>客户商品永久调节单</title>
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
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-card master">
        <div class="layui-card-header btn-group">
            <ul uglcw-role="buttongroup">
                <li onclick="add()" data-icon="add" class="k-info">新建</li>
                <c:if test="${stkAdjustPrice.status eq -2}">
                    <li onclick="drageSave()" id="btndraft" class="k-info" data-icon="save">暂存</li>
                </c:if>
                <li onclick="audit()" id="btnaudit" class="k-info" data-icon="track-changes-accept"
                    style="display: ${(stkAdjustPrice.id ne 0 and stkAdjustPrice.status eq -2)?'':'none'}">审批
                </li>
                <c:if test="${stkAdjustPrice.status ne -2 }">
                <li onclick="toPrint()" id="btnprict" class="k-info" data-icon="print" style="display: ${stkAdjustPrice.id eq 0?'none':''}">打印</li>
                </c:if>
            </ul>
            <div class="bill-info">
                <div class="no" style="color:green;"><span id="billNo" uglcw-model="billNo" style="height: 25px;"
                                                           readonly uglcw-role="textbox">${stkAdjustPrice.billNo}</span>
                </div>
                <div class="status" style="color:red;">
                    <c:choose>
                        <c:when test="${stkAdjustPrice.status eq -2 and not empty stkAdjustPrice.id and stkAdjustPrice.id ne 0}"><span
                                id="billStatus" style="height: 25px;width: 80px" uglcw-model="billstatus"
                                uglcw-role="textbox">暂存</span></c:when>
                        <c:when test="${stkAdjustPrice.status eq 1}"><span id="billStatus" style="height: 25px;width: 80px"
                                                                      uglcw-model="billstatus"
                                                                      uglcw-role="textbox">已审批</span></c:when>
                        <c:when test="${stkAdjustPrice.status eq 2}"><span id="billStatus" style="height: 25px;width: 80px"
                                                                      uglcw-model="billstatus"
                                                                      uglcw-role="textbox">已作废</span></c:when>
                        <c:otherwise>
                            <span id="billStatus" style="height: 25px;width: 80px" uglcw-model="billstatus"
                                  uglcw-role="textbox">新建</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
        <div class="layui-card-body">
            <form class="form-horizontal" uglcw-role="validator">
                <input type="hidden" uglcw-model="id" uglcw-role="textbox" id="billId" value="${stkAdjustPrice.id}"/>
                <input type="hidden" uglcw-model="bizType" uglcw-role="textbox" id="bizType" value="${stkAdjustPrice.bizType}"/>
                <input type="hidden" uglcw-model="type" uglcw-role="textbox" id="type" value="${stkAdjustPrice.type}"/>
                <input type="hidden"  uglcw-model="proId" uglcw-role="textbox" id="proId" value="${stkAdjustPrice.proId}"/>
                <input type="hidden"  uglcw-model="proName" uglcw-role="textbox" id="proName" value="${stkAdjustPrice.proName}"/>
                <input type="hidden" uglcw-model="status" uglcw-role="textbox" id="status" value="${stkAdjustPrice.status}"/>
                <div class="form-group">
                <label class="control-label col-xs-3">调价对象</label>
                <div class="col-xs-4">
                    <select uglcw-role="combobox" id="proType" uglcw-model="proType"  uglcw-options="value: '${stkAdjustPrice.proType}'">
                        <option value="0">所有客户</option>
                        <option value="2">客户</option>
                    </select>
                    <div  id="proName2_div" style="display: none">
                    <%--<input uglcw-role="gridselector"  id="proName2" uglcw-model="proName2" placeholder="选择客户"--%>
                           <%--tabindex="2"--%>
                           <%--uglcw-options="--%>
                           <%--click:function(){--%>
								<%--selectSender();--%>
							<%--}">--%>
                        <input uglcw-role="gridselector"  id="proName2" uglcw-model="proName2" placeholder="选择客户"
                               uglcw-options="
                           click:function(){
								queryCustomer();
							}">
                    </div>
                </div>
                    <label class="control-label col-xs-3">调价时间</label>
                    <div class="col-xs-4">
                        <input id="inDate" uglcw-role="datetimepicker" uglcw-options="format:'yyyy-MM-dd HH:mm'"
                               uglcw-model="inDate" value="${stkAdjustPrice.inDate}">
                    </div>
                </div>


                <div class="form-group">
                    <label class="control-label col-xs-3">备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注</label>
                    <div class="col-xs-11">
                                <textarea uglcw-role="textbox" uglcw-model="remarks"
                                          style="width: 100%;">${stkAdjustPrice.remarks}</textarea>
                    </div>
                </div>
            </form>
        </div>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options='
                         responsive:[".master",40],
                          id: "id",
                          rowNumber: true,
                          checkbox: false,
                          add: function(row){
                          return uglcw.extend({
                            }, row);
                          },
                          editable: true,
                          dragable: true,
                          toolbar: kendo.template($("#toolbar").html()),
                          height:400,
                          navigatable: true,
                          dataSource:${fns:toJson(stkAdjustPrice.list)}
                        '
            >
                <div data-field="wareCode" uglcw-options="
                                 width: 120,
                                 hidden: true,
                                 editable: false,
                            ">产品编号
                </div>
                <div data-field="wareNm" uglcw-options="width: 200">产品名称
                </div>
                <div data-field="wareGg" uglcw-options="width: 120,hidden: true, editable: false">产品规格</div>
                <div data-field="unitName" uglcw-options="width: 100">单位
                </div>
                <div data-field="beUnit" uglcw-options="width: 100,hidden:true">单位
                </div>
                <div data-field="zxPrice"
                     uglcw-options="width: 100,hidden:true">
                    执行价
                </div>
                <div data-field="newHisPrice"
                     uglcw-options="width: 100,hidden:true">
                    最新历史价
                </div>
                <div data-field="disPrice"
                     uglcw-options="width: 100,schema:{ type:'number',decimals:10}">
                    提价
                </div>
                <div data-field="price"
                     uglcw-options="width: 100,schema:{ type:'number',decimals:10}">
                   最新销售价
                </div>
                <div data-field="options" uglcw-options="width: 150, command:'destroy'">操作</div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:showProductSelector()" class="k-button k-button-icontext k-grid-add-purchase">
        <span class="k-icon k-i-search"></span>批量添加
    </a>
    <a style="color: red">
       提价和最新销售价只能输入一个；【提价】栏，正数表示提价，负数表示降价
    </a>
</script>
<script src="${base}/resource/stkstyle/js/Map.js"></script>
<tag:compositive-selector-template index="2" tabs="2"/>
<tag:product-out-selector-template query="onQueryProduct"/>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();
        <c:if test="${stkAdjustPrice.inDate == null}">
        uglcw.ui.get('#inDate').value(new Date());
        </c:if>
        uglcw.ui.get('#grid').k().dataSource.bind('change', function (e) {
            var action = e.action;
            if (action === 'itemchange') {
                var item = e.items[0];
            }
        })
        uglcw.ui.get('#grid').on('dataBound', function () {
            uglcw.ui.init('#grid .k-grid-toolbar');
        });

        var grid = uglcw.ui.get('#grid');
        uglcw.ui.get('#proType').on('change', function(){
            $("#proName2").val("");
            $("#proName").val('');
            $("#proId").val('');
            grid.hideColumn('zxPrice');
            grid.hideColumn("newHisPrice");
            if(this.value()==0){
                $("#proName2_div").hide();
            }else if(this.value()==2){
                $("#proName2_div").show();
                grid.showColumn('zxPrice');
                grid.showColumn("newHisPrice");
            }
        });
        uglcw.ui.init('#grid .k-grid-toolbar');
        uglcw.ui.loaded();
        grid.hideColumn('zxPrice');
        grid.hideColumn("newHisPrice");
        if('${stkAdjustPrice.proType}'==0){
            $("#proName2_div").hide();
        }else if('${stkAdjustPrice.proType}'==2){
            $("#proName2_div").show();
            $("#proName2").val('${stkAdjustPrice.proName}');
            grid.showColumn('zxPrice');
            grid.showColumn("newHisPrice");
        }else if('${stkAdjustPrice.proType}'==3){
            $("#proName2_div").hide();
        }else if('${stkAdjustPrice.proType}'==4){
            $("#proName2_div").hide();
        }
    });


    function selectSender() {
        <tag:compositive-selector-script title="客户信息" callback="onSenderSelect" />
    }

    function onSenderSelect(id, name, type) {
        uglcw.ui.bind('body', {
            proId: id,
            proName: name,
            proName2:name
        })
    }

    var delay;
    function refreshGrid(){
        clearTimeout(delay);
        delay = setTimeout(function(){
            uglcw.ui.get("#grid").k().refresh();
        }, 50);
    }


    function showProductSelector() {
        // if (!uglcw.ui.get('#proId').value()) {
        //     return uglcw.ui.error('请选择客户');
        // }
        <tag:product-out-selector-script callback="onProductSelect"/>
    }


    function onQueryProduct(param) {
        // param.stkId = uglcw.ui.get('#stkId').value();
        param.stkId = 0;
        return param;
    }


    function onProductSelect(data) {
        if (data) {
            if ($.isFunction(data.toJSON)) {
                data = data.toJSON();
            }
            data = $.map(data, function (item) {
                var row = item;
                if ($.isFunction(item.toJSON)) {
                    row = item.toJSON();
                }
                row.price = 0;
                row.newHisPrice = 0;
                row.unitName = row.wareDw;
                row.beUnit = row.maxUnitCode;
                return row;
            })

            if($("#proType").val()==2){
                loadCustomerWarePrices(data)
            }else{
                uglcw.ui.get('#grid').addRow(data);
                uglcw.ui.get('#grid').commit();
                uglcw.ui.get('#grid').scrollBottom();
            }
        }
    }

    function add() {
        uglcw.ui.openTab('客户商品调价单', '${base}manager/stkAdjustPrice/add?billId=0&r=' + new Date().getTime());
    }

    function scrollToGridBottom() {
        uglcw.ui.get('#grid').scrollBottom()
    }

    function scrollToGridTop() {
        uglcw.ui.get('#grid').scrollTop()
    }

    function saveChanges() {
        uglcw.ui.get('#grid').commit();
    }

    function addRow() {
        uglcw.ui.get('#grid').addRow({});
    }


    function batchRemove() {
        uglcw.ui.get('#grid').removeSelectedRow();
    }

    function drageSave() {//暂存
        var valid = uglcw.ui.get('form').validate();
        if (!valid) {
            return;
        }
        var form = uglcw.ui.bind('form');

        var status = form.status;
        if (status == 1) {
            return uglcw.ui.error('该单据已审批，不能保存！');
        }
        if (status == 2) {
            return uglcw.ui.error('该单据已作废，不能保存!');
        }

        if(form.proType!=0&&form.proName==""){
            return uglcw.ui.error('请选择调价对象!');
        }
        var list = uglcw.ui.get('#grid').bind();
        if (!list || list.length < 1) {
            return uglcw.ui.error('请添加明细');
        }
        var bool = false;
        for (var i = 0; i < list.length; i++) {
            var item = list[i];
            if (item.wareId == "") {
                bool = true;
                return uglcw.ui.error('第("' + (i + 1) + '")行，未关联商品');
            }
            if((item.disPrice!=""&& item.disPrice!=null && item.disPrice!=0)
                &&(item.price!=""&&item.price!=null&&item.price!=0)){
                bool = true;
                return uglcw.ui.error('第("' + (i + 1) + '")行，提价和最新销售价只能输入一个');
            }
            if((item.disPrice=="" ||item.disPrice==null|| item.disPrice==0)
                &&(item.price==""||item.price==null||item.price==0)){
                bool = true;
                return uglcw.ui.error('第("' + (i + 1) + '")行，提价和最新销售价必须有一个有值');
            }
        }

        $(list).each(function (idx, item) {
            delete item['productDate'];
            delete item['id'];
            $.map(item, function (v, k) {
                form['list[' + idx + '].' + k] = v;
            })
        });

        if (bool) {
            return;
        }
        delete form['proName2'];
        delete form['proName3'];
        delete form['proName4'];
        uglcw.ui.loading();
        $.ajax({
            url: '${base}manager/stkAdjustPrice/save',
            type: 'post',
            dataType: 'json',
            data: form,
            success: function (response) {
                uglcw.ui.loaded();
                if (response.state) {
                    uglcw.ui.info('暂存成功');
                    uglcw.ui.get('#billStatus').value("暂存成功");
                    uglcw.ui.get('#billId').value(response.id);
                    uglcw.ui.get('#billNo').value(response.billNo);
                    $("#btnprint").show();
                    $("#btncancel").show();
                    $("#btnaudit").show();
                    //uglcw.ui.success('暂存成功');
                    //uglcw.ui.replaceCurrentTab('理货信息' + response.id, '${base}manager/stkAdjustPrice/show?billId=' + response.id)
                } else {
                    uglcw.ui.error(response);
                }
            },
            error: function () {
                uglcw.ui.loaded()
            }
        })

    }

    function audit() {//审批
        var billId = uglcw.ui.get('#billId').value();
        var status = uglcw.ui.get('#status').value();
        if (status == 1) {
            uglcw.ui.error('单据已审批，不能在审批!');
            return;
        }
        if (status == 2) {
            uglcw.ui.error('发票已作废，不能在审批');
            return;
        }
        uglcw.ui.confirm('是否确定审批？', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/stkAdjustPrice/audit',
                type: 'post',
                data: {billId: uglcw.ui.get('#billId').value()},
                dataType: 'json',
                success: function (response) {
                    uglcw.ui.loaded();
                    if (response.state) {
                        uglcw.ui.success('审批成功');
                        uglcw.ui.get('#status').value(1);
                        uglcw.ui.get('#billStatus').value("审批成功");
                        $("#btndraft").hide();
                        $("#btncancel").show();
                        $("#btnaudit").hide();
                    } else {
                        uglcw.ui.warning(response.msg || '操作失败');
                    }
                }
            })

        })
    }

    function toPrint() {
        var billId = uglcw.ui.get("#billId").value();
        uglcw.ui.openTab('打印客户商品报价单${stkAdjustPrice.id}', '${base}manager/stkAdjustPrice/print?billId=' + billId);
    }

    function cancel() {
        var billId = uglcw.ui.get('#billId').value();
        if (!billId) {
            return uglcw.ui.warning('请先保存');
        }
        var billStatus = uglcw.ui.get('#status').value();
        if (billStatus == 2) {
            return uglcw.ui.error('该单据已作废');
        }
        uglcw.ui.confirm('确定作废吗？', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/stkAdjustPrice/cancel',
                data: {billId: billId},
                type: 'post',
                dataType: 'json',
                success: function (response) {
                    uglcw.ui.loaded();
                    if (response.state) {
                        uglcw.ui.success('作废成功');
                        uglcw.ui.get('#billStatus').value('作废成功');
                        uglcw.ui.get("#status").value(2);
                        $("#btndraft").hide();
                        $("#btnprint").hide();
                        $("#btncancel").hide();
                        $("#btnaudit").hide();
                    } else {
                        uglcw.ui.error(response.msg || '作废失败');
                    }
                },
                error: function () {
                    uglcw.ui.loaded();
                }
            })
        })
    }

    function loadCustomerWarePrices(datas) {
        var wareIds = $.map(datas, function (row) {
            return "" + row.wareId + "";
        }).join(',');
        var customerId = uglcw.ui.get('#proId').value();
        if (customerId) {
            customerId = customerId.substr(1);
            customerId = customerId.substr(0, customerId.length-1);
            $.ajax({
                url: '${base}manager/loadCustomerWarePrices',
                type: 'post',
                data: {
                    customerId: customerId,
                    wareIds:wareIds
                },
                success: function (response) {
                    var map = new Map();
                    if(response.rows&&response.rows.length>0){
                        var list = response.rows;
                        for(var i=0;i<list.length;i++){
                            var json = list[i];
                             map.put(json.wareId,json);
                        }
                    }
                    $.map(datas, function (data) {
                        var wareId = data.wareId;
                        data.zxPrice = data.wareDj;
                        data.price = "";
                        data.newHisPrice = 0;
                        if(map.containsKey(wareId)){
                            var json = map.get(wareId);
                            var maxHisPfPrice = json.maxHisPfPrice;
                            var minHisPfPrice = json.minHisPfPrice;
                            var wareDj = json.wareDj;//大单位单价 执行价
                            data.zxPrice = wareDj;
                            if(maxHisPfPrice!=""&&maxHisPfPrice!=undefined){
                                data.newHisPrice = maxHisPfPrice;
                               // data.price = maxHisPfPrice;
                            }
                        }
                        data.disPrice = "";
                        return data;
                    });
                    uglcw.ui.get('#grid').addRow(datas);
                    uglcw.ui.get('#grid').commit();
                    uglcw.ui.get('#grid').scrollBottom();
                }
            })
        }
    }


    function queryCustomer() {
       var win = uglcw.ui.Modal.showGridSelector({
            btns:['确定','取消'],
            closable: true,
            title: false,
            url: '${base}manager/stkchoosecustomer',
            query: function (params) {
                params.isDb = 2;
            },
            checkbox: true,
            width: 650,
            height: 400,
            criteria: '<input placeholder="请输入关键字" uglcw-role="textbox" uglcw-model="khNm">'+
                '<input uglcw-role="combobox" uglcw-model="qdtpNm"\n' +
                '                           uglcw-options="\n' +
                '                                    loadFilter:{\n' +
                '                                      data: function(response){\n' +
                '                                        return response.list1;\n' +
                '                                      }\n' +
                '                                    },\n' +
                '                                    placeholder:\'客户类型\',\n' +
                '                                    url: \'${base}manager/queryarealist1\',\n' +
                '                                    dataTextField:\'qdtpNm\',\n' +
                '                                    dataValueField: \'qdtpNm\',\n' +
                '                                    index: -1,\n' +
                '                                "\n' +
                '                    ></input>'+
                '<input placeholder="请输入业务员名称" uglcw-role="textbox" uglcw-model="memberNm">',
            columns: [
                {field: 'khNm', title: '客户名称', width: 160, tooltip: true},
                {field: 'mobile', title: '客户手机', width: 120},
                {field: 'address', title: '客户地址', width: 220, tooltip: true},
                {field: 'khCode', title: '客户编码', width: 160},
            ],
            yes: function (nodes) {
                if(nodes && nodes.length>0){
                    var count=0;
                    var ids = $.map(nodes, function (node) {
                        count++;
                        return node.id;
                    });
                    var nms = $.map(nodes, function (node) {
                        return node.khNm;
                    });

                    if(count>30){
                        uglcw.ui.info("不能同时超过30个客户进行设置调价！");
                        return;
                    }
                    var grid = uglcw.ui.get('#grid');
                    if(count>1){
                        grid.hideColumn('zxPrice');
                        grid.hideColumn("newHisPrice");
                    }else{
                        grid.showColumn('zxPrice');
                        grid.showColumn("newHisPrice");
                    }

                    var proId = $("#proId").val();
                    var proName = $("#proName").val();

                    // if(proId!=""){
                    //     ids = proId+ids;
                    //     nms = proName+nms;
                    // }
                    ids = ","+ids+",";
                    nms = ","+nms+",";
                    onSenderSelect(ids,nms);
                    uglcw.ui.Modal.close(win);
                };

            }
        })
    }
</script>
</body>
</html>
