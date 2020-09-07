<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>发货单明细</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .price {
            margin-left: 10px;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-card master">
        <div class="layui-card-header btn-group">
            <ul uglcw-role="buttongroup">
                <c:if test="${permission:checkUserFieldPdm('stk.stkSend.print')}">
                    <li onclick="toPrint()" class="k-info" data-icon="print">打印</li>
                </c:if>
            </ul>
            <div style="float:right; margin-top:8px; font-weight: bold;"><span
                    style="color: gray;">发货单${stkSend.billNo}</span><span
                    style="margin-left: 10px; color:${stkSend.status eq 2 ? 'red': 'green'}">${stkSend.status eq 2 ? '作废单': '正常单'}</span>
            </div>
        </div>
        <div class="layui-card-body">
            <form class="form-horizontal" uglcw-role="validator">
                <input type="hidden" uglcw-model="id" uglcw-role="textbox" id="billId" value="${stkSend.id}"/>
                <input type="hidden" uglcw-model="status" uglcw-role="textbox" id="status" value="${billstatus}"/>
                <div class="form-group">
                    <label class="control-label col-xs-3">单据单号</label>
                    <div class="col-xs-4">
                        <input uglcw-model="billNo" uglcw-role="gridselector" value="${stkSend.billNo}"
                               placeholder="自动生成"
                               uglcw-options="icon:'k-i-preview', click:function(){
									   	uglcw.ui.openTab('销售单据信息${stkSend.outId}', '${base}manager/showstkout?dataTp=1&billId=${stkSend.outId}');
									   }"
                               readonly>

                    </div>
                    <label class="control-label col-xs-3">发货时间</label>
                    <div class="col-xs-4">
                        <input uglcw-role="datetimepicker"
                               value="<fmt:formatDate value="${stkSend.sendTime}" pattern="yyyy-MM-dd HH:mm" />"
                               uglcw-model="sendTime"
                               uglcw-options="format:'yyyy-MM-dd HH:mm'">
                    </div>
                    <label class="control-label col-xs-3">配送指定</label>
                    <div class="col-xs-4">
                        <select uglcw-role="combobox" uglcw-options="value:'${stkSend.pszd}'">
                            <option value="公司直送">公司直送</option>
                            <option value="直供转单二批">直供转单二批</option>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-3">客户名称</label>
                    <div class="col-xs-4">
                        <input id="consignee" uglcw-role="gridselector" readonly uglcw-validate="required"
                               value="${stkSend.khNm}"
                               uglcw-options="click: function(){}"
                               uglcw-model="khNm">
                    </div>
                    <label class="control-label col-xs-5 col-xs-3">联系电话</label>
                    <div class="col-xs-4">
                        <input uglcw-role="textbox" uglcw-model="tel" value="${stkSend.tel}"/>
                    </div>
                    <label class="control-label col-xs-5 col-xs-3">配送地址</label>
                    <div class="col-xs-4">
                        <input uglcw-role="textbox" uglcw-model="address" value="${stkSend.address}"/>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-3">出货仓库</label>
                    <div class="col-xs-4">
                        <input uglcw-role="textbox" uglcw-model="address" value="${stkSend.stkName}"/>
                    </div>
                    <label class="control-label col-xs-3">运输车辆</label>
                    <div class="col-xs-4">
                        <select uglcw-role="combobox"
                                uglcw-options="
                                        value: '${stkSend.vehId}',
									    url: '${base}manager/queryVehicleList',
								    	dataTextField:'vehNo',
								    	dataValueField: 'id'
							        	"
                        >
                        </select>
                    </div>
                    <label class="control-label col-xs-3">司机</label>
                    <div class="col-xs-4">
                        <select uglcw-role="combobox"
                                uglcw-options="
                                        value: '${stkSend.driverId}',
									    url: '${base}manager/queryDriverList',
								    	dataTextField:'driverName',
								    	dataValueField: 'id'
							        	"
                        >
                        </select>
                    </div>
                </div>
                <c:if test="${saleType eq '003'}">
                    <div class="form-group">
                        <label class="control-label col-xs-3">
                            物流名称：
                        </label>
                        <div class="col-xs-4">
                            <input uglcw-role="textbox" uglcw-model="transportName" value="${stkSend.transportName}"/>
                        </div>
                        <label class="control-label col-xs-3">物流单号：</label>
                        <div class="col-xs-4">
                            <input uglcw-role="textbox" uglcw-model="transportCode" value="${stkSend.transportCode}"/>
                        </div>
                        <label class="control-label col-xs-3"></label>
                        <div class="col-xs-4">
                        </div>
                    </div>
                </c:if>
                <div class="form-group">
                    <label class="control-label col-xs-3">备注</label>
                    <div class="col-xs-11">
                                <textarea uglcw-role="textbox" uglcw-model="remarks"
                                          style="width: 100%;">${stkSend.remarks}</textarea>
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
                          dragable: true,
                          height:400,
                          navigatable: true,
                          aggregate: [
                            {field: "qty", aggregate: "sum"},
                            {field: "amt", aggregate: "sum"}
                          ],
                          dataSource:${fns:toJson(subList)}
                        '
            >
                <div data-field="wareCode" uglcw-options="
                            width: 120
                        ">产品编号
                </div>
                <div data-field="wareNm" uglcw-options="width: 150, schema:{editable: false}">产品名称</div>
                <div data-field="wareGg" uglcw-options="width: 100, schema:{editable: false}">产品规格</div>
                <div data-field="unitName"
                     uglcw-options="width: 70, schema:{editable: false}">
                    单位
                </div>
                <div data-field="xsTp"
                     uglcw-options="width: 80, schema:{editable: false}">
                    销售类型
                </div>
                <div data-field="productDate" uglcw-options="width: 100, schema:{editable: false}">
                    生产日期
                </div>
                <div data-field="price"
                     uglcw-options="width: 100, schema:{editable: true, type:'number', validation:{required:true, min:0}}">
                    单价
                </div>
                <div data-field="qty" uglcw-options="width: 100,
                            aggregates: ['sum']
                    ">单据数量
                </div>
                <div data-field="outQty" uglcw-options="width: 100,
                            aggregates: ['sum']
                    ">发货数量
                </div>
            </div>
        </div>
    </div>
</div>

<script id="consignee-selector" type="text/x-uglcw-template">
    <div uglcw-role="tabs">
        <ul>
            <li uglcw-field="proName" uglcw-id="id" uglcw-type="0">供应商</li>
            <li uglcw-field="memberNm" uglcw-id="memberId" uglcw-type="1">部门</li>
            <li uglcw-field="khNm" uglcw-id="id" uglcw-type="2">客户</li>
            <li uglcw-field="proName" uglcw-id="id" uglcw-type="3">其他往来单位</li>
        </ul>
        <div>
            <div class="criteria criteria-provider">
                <input class="query" style="width:200px;" placeholder="输入关键字" uglcw-model="proName" uglcw-role="textbox">
                <button class="k-info search" uglcw-role="button"><i class="k-icon k-i-search"></i>搜索</button>
            </div>
            <div uglcw-role="grid" id="grid-provider" uglcw-options="
                url: '${base}manager/stkprovider',
				size:'small',
				criteria: '.criteria-provider',
				pageable: true,
				height: 350
			">
                <div data-field="proName">供应商</div>
                <div data-field="tel">联系电话</div>
                <div data-field="address">地址</div>
            </div>
        </div>
        <div>
            <div style="display: inline-flex;">
                <div class="col-xs-5">
                    <div style="height:350px;" uglcw-role="tree"
                         uglcw-options="
                            dataTextField: 'branchName',
                            dataValueField: 'branchId',
                            url:'${base}manager/department/tree?dataTp=1',
                            select: function(e){
                                var node = this.dataItem(e.node);
                                uglcw.ui.bind('.criteria-member',{branchId: node.branchId});
                                uglcw.ui.get('.grid-member').reload();
                            },
                            loadFilter:function(response){
                              return response.data || [];
                            }
                        "
                    ></div>
                </div>
                <div class="col-xs-19" style="padding: 0;">
                    <div class="criteria criteria-member">
                        <input uglcw-role="textbox" uglcw-model="branchId" type="hidden">
                        <input class="query" style="width:200px;" placeholder="输入关键字" uglcw-model="memberNm"
                               uglcw-role="textbox">
                        <button class="k-info search" uglcw-role="button"><i class="k-icon k-i-search"></i>搜索</button>
                    </div>
                    <div uglcw-role="grid"
                         class="grid-member"
                         uglcw-options="
                    url: '${base}manager/stkMemberPage',
				    height: 350,
				    criteria: '.criteria-member',
				    size:'small',
				    pageable: true
			">
                        <div data-field="memberNm">姓名</div>
                        <div data-field="memberMobile">电话</div>
                    </div>
                </div>
            </div>
        </div>
        <div>
            <div class="criteria criteria-customer">
                <input class="query" style="width:200px;" placeholder="输入关键字" uglcw-model="khNm" uglcw-role="textbox">
                <button class="k-info search" uglcw-role="button"><i class="k-icon k-i-search"></i>搜索</button>
            </div>
            <div uglcw-role="grid" uglcw-options="
				size:'small',
				criteria: '.criteria-customer',
				pageable: {
                    refresh: true,
                    pageSizes: true,
                    buttonCount: 2
				},
				url: '${base}manager/stkchoosecustomer',
				height: 350
			">
                <div data-field="memberNm">客户名称</div>
                <div data-field="memberMobile">联系电话</div>
                <div data-field="address">地址</div>
            </div>
        </div>
        <div>
            <div class="criteria criteria-finunit">
                <input class="query" style="width:200px;" placeholder="输入关键字" uglcw-model="proName" uglcw-role="textbox">
                <button class="k-info search" uglcw-role="button"><i class="k-icon k-i-search"></i>搜索</button>
            </div>
            <div uglcw-role="grid" uglcw-options="
                editable: false,
				size:'small',
				criteria: 'criteria-finunit',
				url: '${base}manager/queryFinUnit',
				pageable: true,
				height: 350
			">
                <div data-field="proName">往来单位</div>
                <div data-field="mobile">联系电话</div>
                <div data-field="address">地址</div>
            </div>
        </div>
    </div>
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();

        uglcw.ui.get('#grid').k().dataSource.bind('change', function (e) {
            var action = e.action;
            if (action == 'itemchange' && (e.field == 'qty' || e.field == 'price')) {
                var item = e.items[0];
                item.set('amt', Number((item.qty * item.price).toFixed(2)));
            }
            calTotalAmount();
        })

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
            var padding = 15;
            var height = $(window).height() - padding - $('.master').height() - $('.k-grid-toolbar').height();
            grid.setOptions({
                height: height,
                autoBind: true
            })
        }, 200)
    }

    function add() {
        uglcw.ui.openTab('销售退货开单', "${base}manager/pcxsthin?orderId=0");
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

    function calTotalAmount() {

    }

    function addRow() {
        uglcw.ui.get('#grid').addRow({
            id: kendo.guid(),
            inTypeCode: 10001,
            qty: 1,
            amt: 0,
        });
    }


    function batchRemove() {
        uglcw.ui.get('#grid').removeSelectedRow();
    }

    function showConsignee() {
        uglcw.ui.Modal.open({
            closable: true,
            title: '请选择收货单位',
            area: '850px',
            moveOut: true,
            scrollbar: false,
            content: $('#consignee-selector').html(),
            success: function (container) {
                uglcw.ui.init(container);
                //搜索事件
                $(container).find('.criteria .search').on('click', function () {
                    uglcw.ui.get($(this).closest('.k-content').find('.k-grid')).reload();
                });
                //双击选中事件
                $(container).find('.uglcw-grid').on('dblclick', 'tbody tr', function () {
                    var grid = uglcw.ui.get($(this).closest('.uglcw-grid')).k();
                    var dataItem = grid.dataItem(this);
                    var field = $('[uglcw-role=tabs]').find('li.k-state-active').attr('uglcw-field');
                    var id = $('[uglcw-role=tabs]').find('li.k-state-active').attr('uglcw-id');
                    var type = $('[uglcw-role=tabs]').find('li.k-state-active').attr('uglcw-type');
                    //赋值并关闭
                    uglcw.ui.get('#consignee').value(dataItem[field]);
                    uglcw.ui.get('#proId').value(dataItem[id]);
                    uglcw.ui.get('#proType').value(type);
                    uglcw.ui.Modal.close();
                });

            },
            yes: function (container) {
                var row = uglcw.ui.get($(container).find('.k-content.k-state-active .uglcw-grid')).selectedRow();
                if (row && row.length > 0) {
                    var field = $('[uglcw-role=tabs]').find('li.k-state-active').attr('uglcw-field');
                    var id = $('[uglcw-role=tabs]').find('li.k-state-active').attr('uglcw-id');
                    var type = $('[uglcw-role=tabs]').find('li.k-state-active').attr('uglcw-type');
                    uglcw.ui.get('#consignee').value(row[0][field]);
                    uglcw.ui.get('#proId').value(row[0][id]);
                    uglcw.ui.get('#proType').value(type);
                }
            }
        })
    }

    //加载最新销售价
    function loadSalePrice(wareId, callback) {
        var proId = uglcw.ui.get('#proId').value();
        $.ajax({
            url: '${base}manager/querySaleCustomerHisWarePrice',
            type: 'get',
            data: {cid: proId, wareId: wareId},
            dataType: 'json',
            success: function (response) {
                if (response.state) {
                    callback(response);
                }
            }
        })
    }

    function showProductSelector() {
        var stkId = uglcw.ui.get('#stkId').value();
        if (!stkId) {
            return uglcw.ui.error('请选择入库仓库！');
        }
        uglcw.ui.Modal.showTreeGridSelector({
            tree: {
                url: '${base}manager/companyWaretypes',
                model: 'waretype',
                id: 'id'
            },
            width: 900,
            id: 'wareId',
            pageable: true,
            url: '${base}manager/dialogWarePage',
            query: function (params) {
                params.stkId = uglcw.ui.get('#stkId').value()
            },
            checkbox: true,
            criteria: '<input uglcw-role="textbox" placeholder="输入关键字" uglcw-model="wareNm">',
            columns: [
                {field: 'wareCode', title: '商品编码', width: 120, tooltip: true},
                {
                    field: 'wareNm', title: '商品名称', width: 120, tooltip: true
                },
                {field: 'wareGg', title: '规格', width: 120},
                {field: 'inPrice', title: '采购价格', width: 120},
                {field: 'stkQty', title: '库存数量', width: 120},
                {field: 'wareDw', title: '大单位', width: 120},
                {field: 'minUnit', title: '小单位', width: 120},
                {field: 'maxUnitCode', title: '大单位代码', width: 120, hidden: true},
                {field: 'minUnitCode', title: '小单位代码', width: 120, hidden: true},
                {field: 'hsNum', title: '换算比例', width: 120, hidden: true},
                {field: 'sunitFront', title: '开单默认选中小单位', width: 240, hidden: true}
            ],
            yes: function (data) {
                if (data) {
                    $(data).each(function (i, row) {
                        row.qty = 1;
                        row.price = row.inPrice;
                        row.unitName = row.wareDw;
                        row.beUnit = row.maxUnitCode;
                        row.qty = row.qty || row.stkQty || 1;
                        row.amt = parseFloat(row.qty) * parseFloat(row.price);
                    })
                    uglcw.ui.get('#grid').addRow(data);
                    uglcw.ui.get('#grid').scrollBottom();
                }
            }
        })
    }

    function selectEmployee() {
        uglcw.ui.Modal.showTreeGridSelector({
            tree: {
                loadFilter: function (response) {
                    return response.data || [];
                },
                url: '${base}manager/department/tree?dataTp=1',
                model: 'branchId',
                dataTextField: 'branchName',
                id: 'branchId'
            },
            width: 900,
            id: 'memberId',
            selectable: 'row',
            pageable: true,
            url: '${base}manager/stkMemberPage',
            criteria: '<input uglcw-role="textbox" placeholder="输入关键字" uglcw-model="memberNm">',
            columns: [
                {field: 'memberNm', title: '姓名'},
                {field: 'memberMobile', title: '电话'}
            ],
            yes: function (data) {
                if (data) {
                    var employee = data[0];
                    uglcw.ui.bind('form', {
                        empNm: employee.memberNm,
                        empId: employee.memberId
                    })
                }
            }
        })

    }

    function draftSaveStk() {
        var status = uglcw.ui.get('#status').value();
        if (status != -2) {
            return uglcw.ui.warning('单据不在暂存状态，不能保存！');
        }
        var valid = uglcw.ui.get('form').validate();
        if (valid) {
            var data = uglcw.ui.bind('form');
            var list = uglcw.ui.get('#grid').bind();
            if (!list || list.length < 1) {
                return uglcw.ui.error('请选择商品');
            }
            data.inType = '销售退货';
            data.shr = data.khNm;
            $(list).each(function (idx, row) {
                row.productDate = row.productDate ? uglcw.util.toString(row.productDate, 'yyyy-MM-dd') : '';
            })

            data.wareStr = JSON.stringify(list);
            uglcw.ui.confirm('是否确定暂存？', function () {
                uglcw.ui.loading();
                $.ajax({
                    url: '${base}manager/dragSaveStkIn',
                    type: 'post',
                    data: data,
                    dataType: 'json',
                    success: function (response) {
                        uglcw.ui.loaded();
                        if (response.state) {
                            uglcw.ui.replaceCurrentTab('销售退货' + response.id, '${base}manager/showstkin?dataTp=1&billId=' + response.id);
                        } else {
                            uglcw.ui.error(response.msg);
                        }
                    },
                    error: function () {
                        uglcw.ui.loaded();
                        uglcw.ui.error('暂存失败');
                    }
                })
            })
        }
    }

    function audit() {
        var billId = uglcw.ui.get('#billId').value();
        var status = uglcw.ui.get('#status').value();
        if (status == 0) {
            return uglcw.ui.error('该单据已审批！');
        }
        if (billId == 0 || status != -2) {
            return uglcw.ui.warning('没有可审核的单据');
        }
        uglcw.ui.confirm('是否确定审核？', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/auditDraftStkIn',
                type: 'post',
                data: {billId: billId},
                dataType: 'json',
                success: function (response) {
                    uglcw.ui.loaded();
                    if (response.state) {
                        uglcw.ui.success('审批成功！');
                        setTimeout(uglcw.ui.reload, 1000)
                    } else {
                        uglcw.ui.error('审批失败');
                    }
                },
                error: function () {
                    uglcw.ui.loaded();
                    uglcw.ui.error('审批失败');
                }
            })
        })
    }

    function submitStk() {
        var valid = uglcw.ui.get('form').validate();
        if (valid) {
            var data = uglcw.ui.bind('form');
            var list = uglcw.ui.get('#grid').bind();
            if (!list || list.length < 1) {
                return uglcw.ui.error('请选择商品');
            }
            data.inType = '销售退货';
            data.shr = data.khNm;
            $(list).each(function (idx, row) {
                row.activeDate = row.activeDate ? uglcw.util.toString(row.activeDate, 'yyyy-MM-dd') : '';
            })

            data.wareStr = JSON.stringify(list);
            uglcw.ui.confirm('保存后将不能修改，是否确定保存？', function () {
                uglcw.ui.loading();
                $.ajax({
                    url: '${base}manager/addStkIn',
                    type: 'post',
                    data: data,
                    dataType: 'json',
                    success: function (response) {
                        uglcw.ui.loaded();
                        if (response.state) {
                            uglcw.ui.success('审批成功');
                            setTimeout(uglcw.ui.reload, 1000);
                        } else {
                            uglcw.ui.error(response.msg);
                        }
                    },
                    error: function () {
                        uglcw.ui.loaded();
                        uglcw.ui.error('审批失败');
                    }
                })
            })
        }
    }

    function auditProc() {
        var billId = uglcw.ui.get('#billId').value();
        if (billId == 0) {
            return uglcw.ui.warning('请先保存');
        }
        uglcw.ui.openTab('退货入库收货', '${base}manager/showstkincheck?dataTp=1&billId=' + billId);
    }

    function audit() {
        var billId = uglcw.ui.get('#billId').value();
        var status = uglcw.ui.get('#status').value();
        if (!billId) {
            return uglcw.ui.error('请先保存！');
        }
        if (status == 1) {
            uglcw.ui.error('该单据已审核');
            return;
        }
        if (status == 2) {
            uglcw.ui.error('单据已作废，不能审批');
            return;
        }

        uglcw.ui.confirm('是否确定审核？', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/stkMove/audit',
                type: 'post',
                data: {billId: uglcw.ui.get('#billId').value()},
                dataType: 'json',
                success: function (response) {
                    uglcw.ui.loaded();
                    if (response.state) {
                        uglcw.ui.success('审批成功');
                        uglcw.ui.get('#billStatus').value('审批成功');
                        uglcw.ui.get('#status').value(0);
                        uglcw.biz.state('state', 4);
                    }
                }
            })

        })
    }

    function toPrint() {
        uglcw.ui.openTab('发货明细打印${stkSend.id }', '${base}manager/showstksendprint?billId=' + '${stkSend.id }');
    }


    function cancelClick() {
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
                url: '${base}manager/cancel',
                data: {billId: billId},
                type: 'post',
                dataType: 'json',
                success: function (response) {
                    uglcw.ui.loaded();
                    if (response.state) {
                        uglcw.ui.get('#billStatus').value('作废成功');
                        uglcw.ui.get('#status').value(2);
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

    function auditClick() {
        var billId = uglcw.ui.get('#billId').value();
        if (billId == 0) {
            return uglcw.ui.info('请先保存');
        }
        var status = uglcw.ui.get('#billstatus').value();
        if (status == '已审') {
            return uglcw.ui.warning('该单据已审核');
        }
        if (status == '作废') {
            return uglcw.ui.warning('该单据已作废');
        }
        auditProc(billId);
    }

</script>
</body>
</html>
