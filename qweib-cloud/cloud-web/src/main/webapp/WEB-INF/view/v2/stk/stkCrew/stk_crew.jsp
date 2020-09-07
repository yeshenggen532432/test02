<%@ page language="java" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>库位理货单</title>
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
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md12">
            <div class="layui-card master">
                <div class="layui-card-header btn-group">
                    <ul uglcw-role="buttongroup">
                        <li onclick="add()" data-icon="add" class="k-info">新建</li>
                        <c:if test="${stkCrew.status eq -2}">
                            <li onclick="drageSave()" id="btndraft" class="k-info" data-icon="save">暂存</li>
                        </c:if>
                        <%--<c:if test="${permission:checkUserFieldPdm('stk.stkCrew.audit')}">--%>
                            <li onclick="audit()" id="btnaudit" class="k-info" data-icon="track-changes-accept" style="display: ${(stkCrew.id ne 0 and stkCrew.status eq -2)?'':'none'}">审批</li>
                        <%--</c:if>--%>
                        <%--<c:if test="${permission:checkUserFieldPdm('stk.stkCrew.cancel')}">--%>
                            <%--<li onclick="cancel()" id="btncancel" class="k-info" data-icon="delete" style="display: ${stkCrew.id eq 0 or stkCrew.status eq 2 or stkCrew.status eq 1?'none':''}">作废</li>--%>
                        <%--</c:if>--%>
                        <%--<c:if test="${stkCrew.status ne -2 }">--%>
                            <%--<c:if test="${permission:checkUserFieldPdm('stk.stkCrew.print')}">--%>
                                <%--<li onclick="toPrint()" id="btnprict" class="k-info" data-icon="print" style="display: ${stkCrew.id eq 0?'none':''}">打印</li>--%>
                            <%--</c:if>--%>
                        <%--</c:if>--%>


                    </ul>
                    <div class="bill-info">
                        <div class="no" style="color:green;"><span id="billNo" uglcw-model="billNo" style="height: 25px;"   uglcw-role="textbox">${stkCrew.billNo}</span></div>
                        <div class="status"  style="color:red;">
                            <c:choose>
                                <c:when test="${stkCrew.status eq -2 and not empty stkCrew.id and stkCrew.id ne 0}"><span id="billStatus" style="height: 25px;width: 80px" uglcw-model="billstatus" uglcw-role="textbox">暂存</span></c:when>
                                <c:when test="${stkCrew.status eq 1}"><span id="billStatus" style="height: 25px;width: 80px"  uglcw-model="billstatus" uglcw-role="textbox">已审批</span></c:when>
                                <c:when test="${stkCrew.status eq 2}"><span id="billStatus" style="height: 25px;width: 80px"  uglcw-model="billstatus" uglcw-role="textbox">已作废</span></c:when>
                                <c:otherwise>
                                    <span id="billStatus" style="height: 25px;width: 80px" uglcw-model="billstatus" uglcw-role="textbox">新建</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
                <div class="layui-card-body">
                    <form class="form-horizontal" uglcw-role="validator">
                        <input type="hidden" uglcw-model="id" uglcw-role="textbox" id="billId" value="${stkCrew.id}"/>
                        <input type="hidden" uglcw-model="bizType" uglcw-role="textbox" id="bizType"
                               value="${stkCrew.bizType}"/>
                        <input type="hidden" uglcw-model="proName" uglcw-role="textbox" id="proName"
                               value="${stkCrew.proName}"/>
                        <input type="hidden" uglcw-model="proId" uglcw-role="textbox" id="proId" value="${stkCrew.proId}"/>
                        <input type="hidden" uglcw-model="proType" uglcw-role="textbox" id="proType"
                               value="${stkCrew.proType}"/>
                        <input type="hidden" uglcw-model="status" uglcw-role="textbox" id="status"
                               value="${stkCrew.status}"/>
                        <div class="form-group">
                            <label class="control-label col-xs-3">理货时间</label>
                            <div class="col-xs-4">
                                <input id="inDate" uglcw-role="datetimepicker" uglcw-options="format:'yyyy-MM-dd HH:mm'"
                                       uglcw-model="inDate" value="${stkCrew.inDate}">
                            </div>
                            <label class="control-label col-xs-3">仓库</label>
                            <div class="col-xs-4">
                                <uglcw:storage-select base="${base}" id="stkId" name="stkId" type="0" value="${stkCrew.stkId}" dataBound="loadDataInit" change="loadDataInit()"
                                ></uglcw:storage-select>
                            </div>
                            <label class="control-label col-xs-3">单据信息</label>
                            <div class="col-xs-4">
                                <input type="hidden" uglcw-role="textbox" uglcw-model="sourceId" id="sourceId"
                                       value="${sourceId}"/>
                                <input  uglcw-role="textbox" uglcw-model="sourceNo" value="${sourceNo}" readonly="readonly"
                                       <%--placeholder="请选择采购发票"--%>
                                       <%--uglcw-options="allowInput: false,--%>
                               <%--<c:if test="${not empty sourceNo}">--%>
                                <%--clearButton: false,--%>
                                   <%--</c:if>--%>
                                 <%--click: selectInBill"--%>
                                />
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3">备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注</label>
                            <div class="col-xs-11">
                                <textarea uglcw-role="textbox" uglcw-model="remarks"
                                          style="width: 100%;">${stkCrew.remarks}</textarea>
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
                                qty:1,
                                amt: 0,
                                price: 0
                            }, row);
                          },
                          editable: true,
                          dragable: true,
                          toolbar: kendo.template($("#toolbar").html()),
                          height:400,
                          navigatable: true,
                          aggregate: [
                            {field: "qty", aggregate: "sum"},
                            {field: "inQty", aggregate: "sum"},
                             {field: "minInQty", aggregate: "sum"},
                            {field: "amt", aggregate: "sum"}
                          ],
                          dataSource:${fns:toJson(stkCrew.list)}
                        '
                    >
                        <div data-field="wareCode" uglcw-options="
                                 width: 120,
                                 hidden: true,
                                 editable: false,
                            ">产品编号
                        </div>
                        <div data-field="wareNm" uglcw-options="width: 200">产品名称</div>
                        <div data-field="wareGg" uglcw-options="width: 120,hidden: true, editable: false">产品规格</div>
                        <div data-field="beUnit" uglcw-options="width: 100,hidden:true">单位
                        </div>
                        <div data-field="unitName" uglcw-options="width: 100">单位
                        </div>
                        <div data-field="outStkId" uglcw-options="width: 150,hidden:true">移出库位Id
                        </div>
                        <div data-field="outStkName" uglcw-options="width: 150">移出库位
                        </div>
                        <div data-field="qty" uglcw-options="width: 100,
                            schema:{editable: false},
                            aggregates: ['sum'],
                            footerTemplate: '#= (sum || 0) #'
                       ">存放数量
                        </div>
                        <div data-field="minQty" uglcw-options="width: 100,hidden:true
                       ">存放数量小
                        </div>
                        <div data-field="_sum_Qty" uglcw-options="width:120,tooltip: true,titleAlign:'center',align:'right',
                                template: function(data){
                                    return formatQty(data);
                                }">大小数量
                        </div>
                        <div data-field="price"
                             uglcw-options="width: 100, hidden: true, schema:{ type:'number',decimals:10}">
                            单价
                        </div>
                        <div data-field="amt" uglcw-options="width: 100,
                            schema:{editable: true},
                            hidden: true,
                            aggregates: ['sum'],
                            editor: function(container, options){ $('<span>'+options.model.amt+'</span>').appendTo(container)},
                            footerTemplate: '#= (sum || 0) #'">存放金额
                        </div>
                        <div data-field="inStkName" uglcw-options="width: 150,
									 editor: function(container, options){
										var input = $('<input>');
										input.appendTo(container);
										console.log(options);
										var model = options.model;
										var selector = new uglcw.ui.ComboBox(input);
										selector.init({
											dataSource:itemsJson,
											dataTextField: 'houseName',
											dataValueField: 'id',
											select: function(e){
												var item = e.dataItem;
												model.inStkId = item.id,
												model.inStkName = item.houseName;

											}
										})
									}">移入库位
                        </div>
                        <div data-field="inQty" uglcw-options="width: 100,
                            aggregates: ['sum'],
                            schema:{ type: 'number',decimals:10},
                            footerTemplate: '#= (sum || 0) #'
                       ">移入数量(大)
                        </div>
                        <div data-field="minInQty" uglcw-options="width: 100,
                            aggregates: ['sum'],
                            schema:{ type: 'number',decimals:10},
                            footerTemplate: '#= (sum || 0) #'
                       ">移入数量(小)
                        </div>
                        <div data-field="checkQty" uglcw-options="width: 100,
                                template: function(data){
                                    return formatInQty(data);
                                }">移入总数
                        </div>
                        <div data-field="options" uglcw-options="width: 150, command:'destroy'">操作</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/x-kendo-template" id="toolbar">
    <input type="hidden" id="wareIds" uglcw-role="textbox" uglcw-model="wareIds"/>
    <input uglcw-role="gridselector" id="wareNms" uglcw-model="wareNms" style="font-size: 11px;width: 150px"
           placeholder="请选择商品"
           uglcw-options="allowInput: false,
                                clearButton: false,
                                 click:showProductSelector3"
    />
    <input type="hidden" uglcw-role="textbox" id="houseIds" uglcw-model="houseIds"/>
    <input uglcw-role="gridselector" id="houseNames" uglcw-model="houseNames"  style="font-size: 11px;width:150px"
           placeholder="请选择仓库"
           uglcw-options="allowInput: false,
                                clearButton: false,
                                 click:winHouseList "
    />

    <a role="button" href="javascript:loadWareByHouseIds();" class="k-button k-button-icontext k-grid-add-purchase">
        <span class="k-icon k-i-add"></span>加载数据
    </a>
   <%--
    <a role="button" href="javascript:scrollToGridTop();" class="k-button k-button-icontext k-grid-add-purchase">
        <span class="k-icon k-i-arrow-end-up"></span>
    </a>
    <a role="button" href="javascript:scrollToGridBottom();" class="k-button k-button-icontext k-grid-add-purchase">
        <span title="滚动至底部" class="k-icon k-i-arrow-end-down"></span>
    </a>
    <a role="button" href="javascript:saveChanges();" class="k-button k-button-icontext k-grid-add-purchase">
        <span title="滚动至顶部" class="k-icon k-i-check"></span>
    </a>
    --%>
</script>


<%--<script type="text/x-uglcw-template" id="autocomplete-template">
    <span class="k-state-default"
          style="background-image: url('#: data.warePicList.length > 0 ? 'upload/'+data.warePicList[0].picMini: '' #')"></span>
    <span class="k-state-default"><h3>#: data.wareNm #</h3><p>#: data.wareCode # #: data.wareGg#</p></span>
</script>--%>
<%--<script type="text/x-uglcw-template" id="autocomplete-header-template">

</script>
<script type="text/x-uglcw-template" id="autocomplete-footer-template">
    共匹配 #: instance.dataSource.data().length #项商品
</script>--%>
<tag:product-in-selector-template query="onQueryProduct"/>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();

        <c:if test="${stkCrew.inDate == null}">
        uglcw.ui.get('#inDate').value(new Date());
        </c:if>

        uglcw.ui.get('#grid').k().dataSource.bind('change', function (e) {
            var action = e.action;
            if (action === 'itemchange') {
                var item = e.items[0];
                if ((e.field === 'inQty' || e.field === 'minInQty')) {
                    formatInQty(item);
                }
                uglcw.ui.get('#grid').commit();
            }

        })
        uglcw.ui.get('#grid').on('dataBound', function () {
            uglcw.ui.init('#grid .k-grid-toolbar');
        });
        uglcw.ui.init('#grid .k-grid-toolbar');
        uglcw.ui.loaded();
        uglcw.ui.get('#sourceId').on('change', laodBillSub);
    });

    function showProductSelector() {
        // if (!uglcw.ui.get('#stkId').value()) {
        //     return uglcw.ui.error('请选择仓库');
        // }
        <tag:product-out-selector-script callback="onProductSelect"/>
    }

    function showProductSelector3() {
        // if (!uglcw.ui.get('#stkId').value()) {
        //     return uglcw.ui.error('请选择仓库');
        // }
        <tag:product-out-selector-script callback="onProductSelect3"/>
    }

    function onProductSelect3(data) {
        if (data) {
            if($.isFunction(data.toJSON)){
                data = data.toJSON();
            }
            var wareIds = $.map(data, function (row) {
                return "'" + row.wareId + "'";
            }).join(',');
            var wareNms = $.map(data, function (row) {
                return "" + row.wareNm + "";
            }).join(',');
            $("#wareIds").val(wareIds);
            $("#wareNms").val(wareNms);
        }
    }

    function onQueryProduct(param) {
        // param.stkId = uglcw.ui.get('#stkId').value();
        param.stkId = 0;
        return param;
    }



    function onProductSelect(data) {
        if (data) {
            if($.isFunction(data.toJSON)){
                data = data.toJSON();
            }
            data = $.map(data, function (item) {
                var row = item;
                if($.isFunction(item.toJSON)){
                    row = item.toJSON();
                }

                // "price": json.list[i].wareDj,
                //     "sunitFront": json.list[i].sunitFront,
                //     "sunitPrice":json.list[i].sunitPrice,
                row.price = row.wareDj || '0';
                row.unitName = row.wareDw;
                row.beUnit = row.maxUnitCode;
                row.qty = 1;
                row.inQty = 1;
                row.amt = parseFloat(row.qty) * parseFloat(row.price);
                row.productDate = '';
                return row;
            })
            uglcw.ui.get('#grid').addRow(data);
            uglcw.ui.get('#grid').commit();
            uglcw.ui.get('#grid').scrollBottom();
        }
    }

    /**
     * 产品选择回调
     */
    // function onProductSelect(data) {
    //     if (data) {
    //         $(data).each(function (i, row) {
    //             row.qty = 1;
    //             row.price = row.inPrice || '0';
    //             row.unitName = row.wareDw;
    //             row.beUnit = row.maxUnitCode;
    //             row.qty = row.qty || row.stkQty || 1;
    //             row.amt = parseFloat(row.qty) * parseFloat(row.price);
    //             row.productDate = '';
    //         })
    //         uglcw.ui.get('#grid').addRow(data);
    //         uglcw.ui.get('#grid').commit();
    //         uglcw.ui.get('#grid').scrollBottom();
    //     }
    // }

    function add() {
        uglcw.ui.openTab('理货开单', '${base}manager/stkCrew/add?billId=0&r=' + new Date().getTime());
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
        uglcw.ui.get('#grid').addRow({
        });
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
            return uglcw.ui.error('该单据已作废，不能保存!')
        }
        // if (form.stkId == form.stkInId) {
        //     return uglcw.ui.error('出入仓库不能相同！');
        // }

        if(form.stkId==0||form.stkId==""){
            return uglcw.ui.error('仓库不能位空！')
        }

        var list = uglcw.ui.get('#grid').bind();
        if (!list || list.length < 1) {
            return uglcw.ui.error('请添加明细');
        }

        var bool = false;

        for(var i=0;i<list.length;i++){
            var item = list[i];
            if(item.wareId==""){
                bool = true;
               // return uglcw.ui.error('第("'+(i+1)+'")行，未关联商品');
            }
            if(item.qty==""||item.qty==0){
                bool = true;
              //  return uglcw.ui.error('存放数量不能等于0');
            }
            if(item.inQty==""||item.inQty==0){
                bool = true;
               // return uglcw.ui.error('移入数量不能等于0');
            }
            if(parseFloat(item.inQty)>parseFloat(item.qty)){
                bool = true;
              //  return uglcw.ui.error('移入数量必须小于等于存放数量');
            }
            if(item.outStkId==0
                ||item.outStkId==""
                ||item.outStkId==undefined
                ||item.inStkId==""
                ||item.inStkId==0
                ||item.inStkId==undefined){
                bool = true;
             //   return uglcw.ui.error('移出库位或移入库位不能位空');
            }
            if(item.outStkId==item.inStkId){
                bool = true;
                return uglcw.ui.error('移出库位与移入库位不能相同');
            }
        }

        var index = 0;
        $(list).each(function (idx, item) {
            delete item['productDate'];
            delete item['id'];
            if(item.inStkName!=undefined
                    &&
                (
                    (item.inQty!=0
                    &&item.inQty!=undefined
                    )
                    ||
                    (item.minInQty!=0
                        &&item.minInQty!=undefined
                    )
                )
                    ){
                $.map(item, function (v, k) {
                    form['list[' + index + '].' + k] = v;
                });
                index++;
            }
        });
        // if(bool){
        //     return;
        // }
        uglcw.ui.loading();
        $.ajax({
            url: '${base}manager/stkCrew/save',
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
                    //uglcw.ui.replaceCurrentTab('理货信息' + response.id, '${base}manager/stkCrew/show?billId=' + response.id)
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
            uglcw.ui.error('单据已作废，不能在审批');
            return;
        }
        //
        // if(!billId){
        //     return uglcw.ui.warning('单据已修改，请先保存!');
        // }
        uglcw.ui.confirm('是否确定审批？', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/stkCrew/audit',
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
        uglcw.ui.openTab('打印理货单${stkCrew.id}', '${base}manager/stkCrew/print?billId=' + billId);
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
                url: '${base}manager/stkCrew/cancel',
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
    /**
     * 行内挑选框
     */
    var model, rowIndex, cellIndex;

    function showProductSelectorForRow(m, r, c) {
        model = m;
        rowIndex = r;
        cellIndex = c;
        <tag:product-out-selector-script checkbox="false" callback="onProductSelect2"/>
    }

    function onProductSelect2(data) {
        if (!data || data.length < 1) {
            return;
        }
        var item = data[0];
        model.hsNum = item.hsNum;
        model.wareCode = item.wareCode;
        model.wareGg = item.wareGg;
        model.wareNm = item.wareNm;
        model.wareDw = item.wareDw;
        model.price = item.inPrice;
        model.qty = 1;
        model.sunitFront = item.sunitFront;
        model.beUnit = item.maxUnitCode;
        model.wareId = item.wareId;
        model.minUnit = item.minUnit;
        model.minUnitCode = item.minUnitCode;
        model.maxUnitCode = item.maxUnitCode;
        model.productDate = '';
        item.unitName = item.wareDw;
        model.amt = model.price * model.qty;
        uglcw.ui.get('#grid').commit();
        uglcw.ui.get('#grid').moveToNext(rowIndex, cellIndex);
    }

    var itemsJson=[];

    function loadDataInit()
    {
        var stkId = $("#stkId").val();
        if(stkId){
            $.ajax({
                url: "${base}/manager/stkHouse/dataList",
                type: "POST",
                data: {"stkId": stkId, "status": 1},
                dataType: 'json',
                async: false,
                success: function (json) {
                    if (json.list != undefined) {
                        itemsJson = json.list;
                    }
                }
            })
        }
    }

    function selectInBill() {
        uglcw.ui.Modal.showGridSelector({
            title: '请选择采购单',
            closable: false,
            width: 800,
            height: 400,
            checkbox: false,
            url: '${base}/manager/queryPageForCrew',
            criteria: '<input style="width: 120px;" uglcw-role="textbox" uglcw-model="billNo" placeholder="单号">' +
                '<input style="width: 120px;" uglcw-role="textbox" uglcw-model="proName" placeholder="供应商">' +
                '<input style="width: 120px;" uglcw-role="datepicker" value="${sdate}" uglcw-model="sdate" placeholder="开始时间">' +
                '<input style="width: 120px;" uglcw-role="datepicker" value="${edate}" uglcw-model="edate" placeholder="结束时间">'
            ,
            query: function (params) {
                return params;
            },
            columns: [
                {title: '单号', field: 'billNo', width: 150, tooltip: true},
                {title: '日期', field: 'inDate', width: 100},
                {title: '供应商', field: 'proName', width: 120, tooltip: true},
                {title: '入库类型', field: 'inType', width: 120, tooltip: true},
                {title: '总仓', field: 'houseName', width: 120, tooltip: true},
                {title: '创建人', field: 'operator', width: 80, tooltip: true},
                {title: '状态', field: 'billStatus', width: 120, tooltip: true},
                {title: '备注', field: 'remarks', width: 120, tooltip: true}
            ],
            yes: function (data) {
                if (data && data.length > 0) {
                    var bill = data[0];
                    var $proId = $('#proId');
                    $proId.data('silent', true);
                    uglcw.ui.bind('.master', {
                        sourceId: bill.id,
                        sourceNo: bill.billNo,
                        proId: bill.proId,
                        proName: bill.proName,
                        proType: bill.proType,
                        houseId: bill.houseId
                    })
                    //清除客户不触发变更提示
                    $proId.removeData('silent');
                }
            }
        })
    }

    function laodBillSub(){
        var sourceId = $("#sourceId").val();
        if(sourceId){
            $.ajax({
                url: "${base}/manager/getBillInfo",
                type: "POST",
                data: {"billId": sourceId},
                dataType: 'json',
                async: false,
                success: function (json) {
                    if (json.state) {
                        var stkIn = json.stkIn;
                        var list = stkIn.list;
                        var outStkId = stkIn.stkId;
                        var outStkName = stkIn.stkName;
                        if(list){
                            list = $.map(list, function (item) {
                                var row = item;
                                if($.isFunction(item.toJSON)){
                                    row = item.toJSON();
                                }
                                row.price = item.price;
                                row.unitName = item.unitName;
                                row.beUnit = item.beUnit;
                                row.qty = item.qty;
                                row.inQty = item.qty;
                                row.amt = parseFloat(row.qty) * parseFloat(row.price);
                                row.productDate = item.productDate;
                                row.outStkId = outStkId;
                                row.outStkName = outStkName;
                                return row;
                            })
                            uglcw.ui.get('#grid').value(list);
                            uglcw.ui.get('#grid').commit();
                            uglcw.ui.get('#grid').scrollBottom();
                        }
                        loadDataInit();
                    }else{
                        uglcw.ui.error("明细加载失败");
                    }
                }
            })
        }
    }

    function loadHouseWareQty(model,wareId,houseId){
        if(wareId&&houseId){
            $.ajax({
                url: "${base}/manager/stkHouseWare/getHouseWareQty",
                type: "POST",
                data: {"wareId": wareId,"houseId":houseId},
                dataType: 'json',
                async: false,
                success: function (json) {
                    if (json.state) {
                        var qty = json.stkQty;
                        if(qty!=0){
                            //uglcw.ui.error("当前库位该商品位0!");
                           // model.set("qty",qty);
                           // model.set("inQty",qty);
                            model.qty = qty;
                          //   model.set("qty",qty);
                             model.set("inQty",qty);
                            uglcw.ui.get('#grid').commit();
                        }
                    }else{
                        uglcw.ui.error("明细加载失败");
                    }
                }
            })
        }
    }


    function winHouseList() { //加载库存数据
        var stkId = $("#stkId").val();
        var rtn =   uglcw.ui.Modal.showGridSelector({
            title: '请选择要导入的库位数据',
            closable: false,
            width: 300,
            height: 400,
            checkbox: true,
            //btns:false,
            btns:['确定','取消'],
            pageable:false,
            url: "${base}/manager/stkHouse/dataList?stkId="+stkId+"&status=1",
            columns: [
                {title: '库位名称', field: 'houseName', width: 100}
            ],
            yes: function (data) {
                if (data && data.length > 0) {
                    //var bill = data[0];
                    var houseIds = $.map(data, function (row) {
                        return "'" + row.id + "'";
                    }).join(',');
                    var houseNames = $.map(data, function (row) {
                        return "" + row.houseName + "";
                    }).join(',');

                    $("#houseIds").val(houseIds);
                    $("#houseNames").val(houseNames)
                    //alert(houseIds);
                    //loadWareByHouseIds(houseIds);
                    uglcw.ui.Modal.close(rtn);
                }
            }
        })
    }

    function loadWareByHouseIds(){
        var houseIds = $("#houseIds").val();
        var stkId = $("#stkId").val();
        var wareIds = $("#wareIds").val();
        if(houseIds==""&&wareIds==""){
            uglcw.ui.error("库位和商品必须选一个！");
            return;
        }
        if(stkId){
            $.ajax({
                url: "${base}/manager/stkHouseWare/list",
                type: "POST",
                data: {"stkId": stkId, "houseIds": houseIds,"wareIds":wareIds},
                dataType: 'json',
                async: false,
                success: function (json) {
                    if (json.rows != undefined) {
                            var   list = $.map(json.rows, function (item) {
                            if(item.wareId==null){
                                    return;
                            }
                            var row = item;
                            if($.isFunction(item.toJSON)){
                                row = item.toJSON();
                            }
                            row.price = item.price;
                            row.unitName = item.unitName;
                            row.beUnit = item.beUnit;
                            row.qty = item.qty;
                            row.minQty = item.minQty;
                            //row.inQty = item.qty;
                            row.amt = parseFloat(row.qty) * parseFloat(row.price);
                            row.outStkId = item.houseId;
                            row.outStkName = item.houseName;
                            return row;
                        });
                        uglcw.ui.get('#grid').value(list);
                        uglcw.ui.get('#grid').commit();
                        uglcw.ui.get('#grid').scrollBottom();
                    }
                }
            })
        }
    }


    function formatQty(data) {
        var hsNum = data.hsNum || 1;
        var minSumQty = data.minQty ||0;
        var result = "";
        var remainder = minSumQty % hsNum;
        if (remainder === 0) {
            //整数件
            result += '<span>' + minSumQty / hsNum + '</span>' + data.unitName;
        } else if (remainder === minSumQty) {
            //不足一件
            var minQty =   Math.floor(minSumQty*100)/100;
            result += '<span>' + minQty + '</span>' + data.minUnit;
        } else {
            //N件有余
            var minQty = Math.floor(remainder*100)/100;
            result += '<span>' + parseInt(minSumQty / hsNum) + '</span>' + data.unitName + '<span>' + minQty + '</span>' + data.minUnit;
        }
        return result;
    }


    function formatInQty(data) {
        var hsNum = data.hsNum || 1;
        var minInQty = data.minInQty||0;
        var hsQty = minInQty / hsNum;
        var inQty = data.inQty||0;
        var checkQty = parseFloat(inQty)+parseFloat(hsQty);
        data.checkQty = checkQty;
        return checkQty;
    }


</script>
</body>
</html>
