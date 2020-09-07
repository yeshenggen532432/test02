<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
	<title>其他入库</title>
	<%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
	<div class="layui-card master">
		<div class="layui-card-header btn-group">
			<ul uglcw-role="buttongroup">
				<li onclick="add()" data-icon="add" class="k-info" id="btnnew">新建</li>
                <li style="display:${(stkPickup.status eq -2)?'':'none' }"
                            onclick="draftSave()" id="btnsave" class="k-info" data-icon="save">暂存</li>
				<li style="display:${(stkPickup.status eq -2 and not empty stkPickup.id)?'':'none' }"
                        onclick="audit()" class="k-info" id="btnaudit" data-icon="track-changes-accept">审批</li>

                <li style="display:${(stkPickup.status ne 2 and not empty stkPickup.id)?'':'none' }"
                                onclick="cancel()" class="k-info" id="btncancel"  data-icon="delete">作废</li>
			</ul>
			<div class="bill-info">
				<span class="no" style="color:green">${stkPickup.billName}</span>&nbsp;&nbsp;&nbsp;&nbsp;
				<span class="status" style="color: green;"><span id="billNo" uglcw-model="billNo" style="height: 25px;"  uglcw-role="textbox">${stkPickup.billNo}</span>&nbsp;&nbsp;&nbsp;&nbsp;
				<c:choose>
					<c:when test="${stkPickup.status eq -2}"><span uglcw-role="textbox" id="billstatus" style="color:red;">暂存</span></c:when>
					<c:when test="${stkPickup.status eq 1}"><span uglcw-role="textbox"  id="billstatus"  style="color:red;">已审批</span></c:when>
					<c:when test="${stkPickup.status eq 2}"><span uglcw-role="textbox"  id="billstatus" style="color:red;">已作废</span></c:when>
					<c:otherwise>
					<span uglcw-role="textbox" id="billstatus"  value="新建"   style="color:red;" readonly="readonly"></span>
					</c:otherwise>
				</c:choose>
				<span uglcw-role="textbox" id="billstatus" style="color: red"  readonly="readonly"></span>
			</div>
		</div>
		<div class="layui-card-body">
			<form class="form-horizontal" uglcw-role="validator">
				<input uglcw-role="textbox" type="hidden" uglcw-model="billId" id="billId" value="${stkPickup.id}"/>
				<input uglcw-role="textbox" type="hidden" uglcw-model="bizType" id="bizType" value="${stkPickup.bizType}"/>
				<input uglcw-role="textbox" type="hidden" uglcw-model="stkName" id="stkName" value="${stkPickup.stkName}"/>
				<input uglcw-role="textbox" type="hidden" uglcw-model="proName" id="proName" value="${stkPickup.proName}"/>
				<input uglcw-role="textbox" type="hidden" uglcw-model="proType" id="proType" value="5"/>
				<input uglcw-role="textbox" type="hidden" uglcw-model="status" id="status" value="${stkPickup.status}"/>
				<input uglcw-role="textbox" type="hidden" uglcw-model="ioMark" id="ioMark" value="${stkPickup.ioMark}"/>
				<input uglcw-role="textbox" type="hidden" uglcw-model="billName" id="billName" value="${stkPickup.billName}"/>
				<div class="form-group">
					<label class="control-label col-xs-5 col-md-3">单据时间</label>
					<div class="col-xs-7 col-md-4">
						<input id="inDate" uglcw-role="datetimepicker" uglcw-options="format:'yyyy-MM-dd HH:mm'"
							   uglcw-model="inDate" value="${stkPickup.inDate}">
					</div>
					<label class="control-label col-xs-5 col-md-3">仓&nbsp;&nbsp;&nbsp;&nbsp;库</label>
					<div class="col-xs-7 col-md-4">
						<tag:select2 name="stkId,stkName" id="stkId" tclass="pcl_sel" index="0"
									 whereBlock="status=1 or status is null"
									 tableName="stk_storage" value="${stkPickup.stkId }"  displayKey="id" displayValue="stk_name"/>

					</div>
					<label class="control-label col-xs-5 col-md-3">车&nbsp;&nbsp;&nbsp;&nbsp;间</label>
					<div class="col-xs-7 col-md-4">
						<tag:select2 name="proId,proName" id="proId" tclass="pcl_sel" index="0" tableName="sys_depart" value="${stkPickup.proId }"  displayKey="branch_id" displayValue="branch_name"/>
					</div>
				</div>
				<div class="form-group">
					<label class="control-label col-xs-3">备注</label>
					<div class="col-xs-11">
						<textarea uglcw-role="textbox" uglcw-model="remarks" style="width: 100%;">${remarks.remarks}</textarea>
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
                                inTypeCode: 10001,
                                qty:1,
                                amt: 0
                            }, row);
                          },
                          editable: true,
                          dragable: true,
                          toolbar: kendo.template($("#toolbar").html()),
                          height:400,
                          navigatable: true,
                          aggregate: [
                            {field: "qty", aggregate: "sum"},
                            {field: "amt", aggregate: "sum"}
                          ],
                          dataSource:${fns:toJson(stkPickup.subList)}
                        '
			>

                <div data-field="wareCode" uglcw-options="
                            width: 100,
                            editable: false
                        ">产品编号
                </div>
                <div data-field="wareNm" uglcw-options="width: 180,
                            schema:{
                                validation:{
                                    required: true,
                                    warecodevalidation:function(input){
                                        input.attr('data-warecodevalidation-msg', '请选择商品');
                                        if(!uglcw.ui.get(input).value()){
                                            uglcw.ui.toast('请选择商品');
                                        }
                                        return true;
                                    }
                                }
                            },
                            editor: function(container, options){
                                var model = options.model;
                                var rowIndex = $(container).closest('tr').index();
                                var cellIndex = $(container).index();
                                var input = $('<input name=\'_wareCode\' data-bind=\'value: wareNm\' placeholder=\'输入商品名称、商品代码、商品条码\' />');
                                input.appendTo(container);
                                $('<span data-for=\'_wareCode\' class=\'k-widget k-tooltip k-tooltip-validation k-invalid-msg\'>请选择商品</span>').appendTo(container);
                                new uglcw.ui.AutoComplete(input).init({
                                    highlightFirst: true,
                                    dataTextField: 'wareNm',
                                    autoWidth: true,
                                    url: '${base}manager/dialogWarePage',
                                     selectable: true,
                                    click: function () {
                                        showProductSelectorForRow(model, rowIndex, cellIndex);
                                    },
                                    data: function(){
                                        return {
                                            page:1, rows: 20,
                                            waretype: '',
                                            stkId: uglcw.ui.get('#stkId').value(),
                                            wareNm: uglcw.ui.get(input).value()
                                        }
                                    },
                                    loadFilter:{
                                        data: function(response){
                                          return response.rows || [];
                                        }
                                    },
                                    template: '<div><span>#= data.wareNm#</span><span style=\'float: right\'>#= data.wareGg#</span></div>',
                                    select: function (e) {
                                        var item = e.dataItem;
                                        var model = options.model;
                                        model.hsNum = item.hsNum;
                                        model.wareCode = item.wareCode;
                                        model.wareGg = item.wareGg;
                                        model.wareNm = item.wareNm;
                                        model.wareDw = item.wareDw;
                                        model.price = item.inPrice;
                                        model.qty = 1;
                                        model.amt = model.price * model.qty;
                                        model.beUnit = item.maxUnitCode;
                                        model.wareId = item.wareId;
                                        model.minUnit = item.minUnit;
                                        model.minUnitCode = item.minUnitCode;
                                        model.maxUnitCode = item.maxUnitCode;
                                        model.productDate = '';
                                        model.amt = parseFloat(model.qty)*parseFloat(model.price);
                                        uglcw.ui.get('#grid').commit();
                                        uglcw.ui.get('#grid').moveToNext(rowIndex, cellIndex);
                                    }
                                });
                           }
                ">产品名称
                </div>
				<div data-field="wareGg" uglcw-options="width: 150, schema:{editable: false}">产品规格</div>
				<div data-field="beUnit" uglcw-options="width: 150,
                            template: '#= data.beUnit == data.maxUnitCode ? data.wareDw||\'\' : data.minUnit||\'\' #',
                            editor: function(container, options){
                             var model = options.model;
                             if(!model.wareId){
                                $(container).html('<span>请先选择产品</span>')
                                return ;
                             }
                             var input = $('<input name=\'beUnit\' data-bind:\'value:beUnit\'>');
                             input.appendTo(container);
                             var widget = new uglcw.ui.ComboBox(input);
                             widget.init({
                              dataSource:[
                              { text: model.wareDw, value:model.maxUnitCode },
                              { text: model.minUnit, value:model.minUnitCode}
                              ]
                             })
                            }
                        ">单位
				</div>
					<div data-field="qty" uglcw-options="width: 150,
                            aggregates: ['sum'],
                            footerTemplate: '#= (sum || 0) #'
                    ">数量
					</div>
					<div data-field="price"
						 uglcw-options="width: 150,hidden: true, format:'{0: n2}', schema:{editable: true, type:'number', validation:{required:true, min:0}}">
						单价
					</div>
				<div data-field="amt" uglcw-options="width: 150,
                            format:'{0: n2}',
                            hidden: true,
                            schema:{editable: true},
                            aggregates: ['sum'],
                            editor: function(container, options){ $('<span>'+options.model.amt+'</span>').appendTo(container)},
                            footerTemplate: '#= (sum || 0) #'">金额
				</div>
				<div data-field="options" uglcw-options="width: 150, command:'destroy'">操作</div>
			</div>
		</div>
	</div>
</div>
<tag:compositive-selector-template/>
<script type="text/x-uglcw-template" id="toolbar">
	<a role="button" href="javascript:addRow();" class="k-button k-button-icontext k-grid-add-purchase">
		<span class="k-icon k-i-add"></span>加一行
	</a>
	<a role="button" href="javascript:showProductSelector()" class="k-button k-button-icontext k-grid-add-purchase">
		<span class="k-icon k-i-cart"></span>添加商品
	</a>

</script>
<tag:product-in-selector-template query="onQueryProduct"/>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
	$(function () {
		uglcw.ui.init();
		//uglcw.ui.get('#discount').on('change', calTotalAmount);
		//grid渲染后对toolbar上的控件进行初始化

        <c:if test="${empty stkPickup.id}">
         uglcw.ui.get('#inDate').value(new Date());
        </c:if>
		uglcw.ui.get('#grid').k().dataSource.bind('change', function (e) {
			var action = e.action;
			if (action === 'itemchange') {
				var item = e.items[0];
				if ((e.field === 'qty' || e.field === 'price')) {
					item.set('amt', Number((item.qty * item.price).toFixed(2)));
				} else if (e.field === 'beUnit') {
					if (item.beUnit === 'B') {
						//切换至大单位 价格=小单位单价*转换比例
						item.set('price', Number(item.price * item.hsNum).toFixed(2));
					} else if (item.beUnit === 'S') {
						item.set('price', Number(item.price / item.hsNum).toFixed(2));
					}
					//uglcw.ui.get('#grid').commit();
				}
			}
		//	calTotalAmount();
		});
		uglcw.ui.get('#grid').on('dataBound', function () {
			uglcw.ui.init('#grid .k-grid-toolbar');
		});
	//	calTotalAmount();
		resize();
		$(window).resize(resize);
		uglcw.ui.loaded();
	})

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
		uglcw.ui.openTab('领料出库', '${base}manager/stkPickup/add?bizType=${stkPickup.bizType}');
	}

	function selectSender() {
		<tag:compositive-selector-script title="发货单位" callback="onSenderSelect"/>
	}

	function onSenderSelect(id, name, type) {
		uglcw.ui.bind('body', {
			proId: id,
			proName: name,
			proType: type
		})
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
		var ds = uglcw.ui.get('#grid').k().dataSource;
		var data = ds.data().toJSON();
		var total = 0;
		$(data).each(function (idx, item) {
			total += (Number(item.price || 0) * Number(item.qty || 0))
		})
		uglcw.ui.get('#totalAmount').value(total.toFixed(2));
		var discount = uglcw.ui.get('#discount').value() || 0;
		uglcw.ui.get('#discountAmount').value((total - discount).toFixed(2));
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

    /**
     * 添加商品
     */

    function showProductSelector() {
        if (!uglcw.ui.get('#stkId').value()) {
            return uglcw.ui.error('请选择仓库');
        }
        <tag:product-out-selector-script callback="onProductSelect"/>
    }

    function onQueryProduct(param) {
        param.stkId = uglcw.ui.get('#stkId').value();
        return param;
    }

    /**
     * 产品选择回调
     */
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
                row.id = uglcw.util.uuid();
                row.price = row.inPrice || '0';
                row.unitName = row.wareDw;
                row.beUnit = row.maxUnitCode;
				row.qty = 1;
                row.amt = parseFloat(row.qty) * parseFloat(row.price);
                return row;
            })
            uglcw.ui.get('#grid').addRow(data);
            uglcw.ui.get('#grid').commit();
            uglcw.ui.get('#grid').scrollBottom();
        }
    }

	//暂存
	function draftSave() {
		uglcw.ui.get('#grid').commit();
		var status = uglcw.ui.get('#status').value();
		if (status == 1) {
			uglcw.ui.warning('该单据已审批，不能保存!');
			return;
		}
		if(status == 2){
		    uglcw.ui.warning('该单据已作废，不能保存！');
		    return;
        }
		var stkId = uglcw.ui.get('#stkId').value();
		if(stkId == ""){
		    uglcw.ui.warning('请选择仓库！');
		    return;
        }
		var proId = uglcw.ui.get('#proId').value();
		if(proId == ""){
		    uglcw.ui.warning('请选择车间！');
		    return;
        }
		if (!uglcw.ui.get('form').validate()) {
			return;
		}
		var data = uglcw.ui.bind('form');

		var products = uglcw.ui.get('#grid').bind();
		if (products.length < 1) {
			uglcw.ui.error('请选择商品');
			return;
		}
		data.id = data.billId;
		//	data.wareStr = JSON.stringify(products);

		$(products).each(function(i,p) {
			$.map(p, function (v, k) {
				if(k != 'id'){
					data['subList[' + i + '].' + k] = v
				}
			})
		})

		uglcw.ui.loading();
		$.ajax({
			url: '${base}manager/stkPickup/save',
			type: 'post',
			data: data,
			dataType: 'json',
			success: function (json) {
				uglcw.ui.loading();
				if (json.state) {
					uglcw.ui.get('#billId').value(json.id);
					uglcw.ui.get('#billNo').value(json.billNo);
					uglcw.ui.get('#status').value(json.status);
					uglcw.ui.get('#billstatus').value("提交成功");
					$("#btnsave").show();
					$("#btnaudit").show();
					$("#btncancel").show();
                    uglcw.ui.loaded();
				}else {
					uglcw.ui.error(json.msg);
				}

			},
			error: function () {
				uglcw.ui.loaded();
			}
		})
	}


	//审批
	function audit() {
		var billId = uglcw.ui.get('#billId').value();
		var status = uglcw.ui.get('#status').value();
		if (status == 1) {
			uglcw.ui.error('单据已审批，不能在审批!');
			return;
		}
		if (status == 2) {
			uglcw.ui.error('单据已作废，不能在审批!');
			return;
		}
		uglcw.ui.confirm('是否确定审批？', function () {
			uglcw.ui.loading();
			$.ajax({
				url: '${base}manager/stkPickup/audit',
				type: 'post',
				data: {billId: billId},
				dataType: 'json',
				success: function (json) {
					uglcw.ui.loaded();
					if (json.state) {
						uglcw.ui.get('#status').value(1);
						uglcw.ui.get("#billstatus").value("审批成功");
						$("#btnsave").hide();
						$("#btnaudit").hide();
						$("#btncancel").show();
					}else{
						uglcw.ui.error(json.msg);
					}
				}
			})

		})
	}


	//作废
	function cancel() {
		var billId = uglcw.ui.get('#billId').value();
		var status = uglcw.ui.get('#status').value();
		if (status == 2) {
			return uglcw.ui.error('该单据已作废，不能在审批!');
		}
		uglcw.ui.confirm('确定作废吗？', function () {
			uglcw.ui.loading();
			$.ajax({
				url: '${base}/manager/stkPickup/cancel',
				data: {billId: billId},
				type: 'post',
				dataType: 'json',
				success: function (json) {
					uglcw.ui.loaded();
					if (json.state) {
						uglcw.ui.get("#status").value(2);
						uglcw.ui.get("#billstatus").value("作废成功");
					} else {
						uglcw.ui.error('作废失败');
					}
				},
				error: function () {
					uglcw.ui.loaded();
				}
			})
		})

	}
/*
	function toPrint() {
		top.layui.index.openTabsPage('${base}manager/showstkinprint?billId=${billId}', '其他入库${billId}打印');
	}

	function auditClick() {
		var billId = uglcw.ui.get('#billId').value();
		if (billId == 0) {
			return uglcw.ui.info('请先保存');
		}
		var status = uglcw.ui.get('#billStatus').value();
		if (status == '已审') {
			return uglcw.ui.warning('该单据已审核');
		}
		if (status == '作废') {
			return uglcw.ui.warning('该单据已作废');
		}
		auditProc(billId);
	}

	function auditProc(billId) {
		uglcw.ui.openTab('其他入库收货' + billId, '${base}manager/showstkincheck?dataTp=1&billId=' + billId);
	}
*/

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
		model.wareId = item.wareId;
        model.hsNum = item.hsNum;
        model.wareCode = item.wareCode;
        model.wareGg = item.wareGg;
        model.wareNm = item.wareNm;
        model.wareDw = item.wareDw;
        model.price = item.inPrice;
        model.qty = 1;
        model.sunitFront = item.sunitFront;
        model.beUnit = item.maxUnitCode;
        model.minUnit = item.minUnit;
        model.minUnitCode = item.minUnitCode;
        model.maxUnitCode = item.maxUnitCode;
        model.unitName = item.wareDw;
        uglcw.ui.get('#grid').commit();
        uglcw.ui.get('#grid').moveToNext(rowIndex, cellIndex);
    }
</script>
</body>
</html>
