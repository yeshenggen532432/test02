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
				<li onclick="add()" data-icon="add" class="k-info">新建</li>
				<c:if test="${status eq -2}">
					<li onclick="draftSave()" class="k-info" data-icon="save" id="btndraft">暂存</li>
						<li onclick="audit()" class="k-info" data-icon="track-changes-accept" id="btndraftaudit"
							style="display: ${billId eq 0?'none':''}">审批</li>
				</c:if>
				<c:if test="${permission:checkUserFieldPdm('stk.stkIn.save')}">
						<li onclick="submitStk()" class="k-info" data-icon="save" id="btnsave"
							style="display: ${(status eq -2 and billId eq 0)?'':'none'}">保存并审批</li>
				</c:if>
				<c:if test="${permission:checkUserFieldPdm('stk.stkIn.cancel')}">
						<li onclick="cancelClick()" class="k-info" data-icon="delete" id="btncancel"
							style="display: ${(status eq -2 or billId eq 0)?'none':''}">作废</li>
				</c:if>
			</ul>
			<div class="bill-info">
			<%--	<span class="no"  id="billNo" style="color: green;">${billNo}</span>
				<span class="status" id="billstatus" style="color:red;">${billstatus}</span>--%>
				<span class="no" style="color: green;">
					<div id="billNo" uglcw-model="billNo" style="height: 25px;"uglcw-role="textbox">${billNo}</div></span>
				<span class="status" style="color:red;">
					<div id="billStatus" style="height: 25px;width: 80px" uglcw-model="billstatus" uglcw-role="textbox">${billstatus}</div></span>
			</div>
		</div>
		<div class="layui-card-body">
			<form class="form-horizontal" uglcw-role="validator">
				<input uglcw-role="textbox" type="hidden" uglcw-model="billId" id="billId" value="${billId}"/>
				<input uglcw-role="textbox" type="hidden" uglcw-model="inType" id="inType" value="领料回库"/>
				<input uglcw-role="textbox" type="hidden" uglcw-model="stkId"  value="${stkId}"/>
				<input uglcw-role="textbox" type="hidden" uglcw-model="proType" id="proType" value="${proType}"/>
				<input uglcw-role="textbox" type="hidden" uglcw-model="stkName" id="stkName" value="${stkName}"/>
				<input type="hidden" uglcw-role="textbox" uglcw-model="status" id="status" value="${status}"/>
				<input type="hidden" uglcw-role="textbox" uglcw-model="proName" id="proName" value="${proName}"/>

				<div class="form-group">
					<label class="control-label col-xs-5 col-md-3">车&nbsp;&nbsp;&nbsp;&nbsp;间</label>
					<div class="col-xs-7 col-md-4">
						<tag:select2 name="proId,proName" id="proId" tclass="pcl_sel" tableName="sys_depart" value="${proId }"  displayKey="branch_id" displayValue="branch_name"/>
					</div>
					<label class="control-label col-xs-5 col-md-3">入库时间</label>
					<div class="col-xs-7 col-md-4">
						<input id="inDate" uglcw-role="datetimepicker" uglcw-options="format:'yyyy-MM-dd HH:mm'"
							   uglcw-model="inDate" value="${inTime}">
					</div>
					<label class="control-label col-xs-5 col-md-3">入库仓库</label>
					<div class="col-xs-7 col-md-4">
						<input uglcw-validate="required" uglcw-role="combobox" id="stkId" value="${stkId}"
							   uglcw-options="
                                            url: '${base}manager/queryBaseStorage',
                                            dataTextField: 'stkName',
                                            index: 0,
                                            dataValueField: 'id'
                                        "
							   uglcw-model="stkId"></input>
					</div>
				</div>
				<div class="form-group" style="display: none">
					<label class="control-label col-xs-3">合计金额</label>
					<div class="col-xs-4">
						<input id="totalAmount" uglcw-options="spinners: false, format: 'n2'" uglcw-role="numeric"
							   uglcw-model="totalmt" value="${totalamt}"
							   disabled>
					</div>
					<label class="control-label col-xs-3">整单折扣</label>
					<div class="col-xs-4">
						<input id="discount" uglcw-role="numeric" uglcw-model="discount" value="${discount}">
					</div>
					<label class="control-label col-xs-3">金额</label>
					<div class="col-xs-4">
						<input id="discountAmount"
							   uglcw-options="spinners: false, format: 'n2'"
							   uglcw-role="numeric" uglcw-model="disamt" disabled
							   value="${disamt}">
					</div>
				</div>
				<div class="form-group">
					<label class="control-label col-xs-3">备注</label>
					<div class="col-xs-11">
                                <textarea uglcw-role="textbox" uglcw-model="remarks"
										  style="width: 100%;">${remarks}</textarea>
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
                                id: uglcw.util.uuid(),
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
                          dataSource: gridDataSource
                        '
			>

				<div data-field="wareCode" uglcw-options="
                            width: 100,
                            editable: false,
                        ">产品编号
				</div>
				<div data-field="wareNm" uglcw-options="width: 180,
                            tooltip: true,
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
                                    selectable: true,
                                    click: function () {
                                        showProductSelectorForRow(model, rowIndex, cellIndex);
                                    },
                                    url: '${base}manager/dialogWarePage',
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
                                        model.inTypeCode = 10001;
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
                             var input = $('<input name=\'beUnit\' data-bind=\'value:beUnit\'/>');
                             input.appendTo(container);
                             var widget = new uglcw.ui.ComboBox(input);
                             widget.init({
                              value: model.beUnit || 'B',
                              dataSource:[
                              { text: model.wareDw, value:model.maxUnitCode },
                              { text: model.minUnit, value:model.minUnitCode}
                              ],
                              change: function(){
                                console.log(this.value())
                              	model.set('beUnit', this.value())
                              }
                             })
                            }
                        ">单位
				</div>
				<c:if test="${permission:checkUserFieldPdm('stk.stkIn.lookqty')}">
					<div data-field="qty" uglcw-options="width: 150,
                            aggregates: ['sum'],
                            schema:{type: 'number',decimals:10},
                            footerTemplate: '#= (sum || 0) #'
                    ">入库数量
					</div>
				</c:if>
				<c:if test="${permission:checkUserFieldPdm('stk.stkIn.lookprice')}">
					<div data-field="price"
						 uglcw-options="width: 150,hidden: true, schema:{editable: true, type:'number',decimals:10, validation:{required:true, min:0}}">
						单价
					</div>
				</c:if>
				<div data-field="amt" uglcw-options="width: 150,
                            format:'{0: n2}',
                            hidden: true,
                            schema:{editable: true},
                            aggregates: ['sum'],
                            editor: function(container, options){ $('<span>'+options.model.amt+'</span>').appendTo(container)},
                            footerTemplate: '#= (sum || 0) #'">入库金额
				</div>
				<div data-field="productDate" uglcw-options="width: 150, format: 'yyyy-MM-dd',
                             schema:{ type: 'date'},
                             editor: function(container, options){
                                var model = options.model;
                                var input = $('<input  data-bind=\'value:productDate\' />');
                                input.appendTo(container);
                                var picker = new uglcw.ui.DatePicker(input);
                                picker.init({
                                    format: 'yyyy-MM-dd',
                                    value: model.productDate ? model.productDate : new Date()
                                });
                                picker.k().open();
                             }
                            ">生产日期
				</div>
				<div data-field="options" uglcw-options="width: 150, command:'destroy'">操作</div>
			</div>
		</div>
	</div>
</div>
<tag:product-in-selector-template query="onQueryProduct"/>

<tag:compositive-selector-template/>
<script type="text/x-uglcw-template" id="toolbar">
	<a role="button" href="javascript:addRow();" class="k-button k-button-icontext k-grid-add-purchase">
		<span class="k-icon k-i-add"></span>加一行
	</a>
	<a role="button" href="javascript:showProductSelector()" class="k-button k-button-icontext k-grid-add-purchase">
		<span class="k-icon k-i-cart"></span>添加商品
	</a>
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script src="${base}static/uglcu/biz/erp/util.js?v=20191120"></script>
<script>
	var gridDataSource = initData(${fns:toJson(warelist)})
	function initData(data){
		if(data){
			$(data).each(function(i, item){
				item.beUnit = item.beUnit || item.maxUnitCode;
			})
		}
		return data;
	}

	$(function () {
		uglcw.ui.init();
		uglcw.ui.get('#discount').on('change', calTotalAmount);
		//grid渲染后对toolbar上的控件进行初始化

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
			calTotalAmount();
		});
		uglcw.ui.get('#grid').on('dataBound', function () {
			uglcw.ui.init('#grid .k-grid-toolbar');
		});
		calTotalAmount();
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
	var isModify = false;

	function add() {
		uglcw.ui.openTab('领料回库制单', '${base}manager/pcotherstkin?r=' + new Date().getTime());
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
				row.productDate = '';
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
		if (status != -2) {
			uglcw.ui.warning('发票不在暂存状态，不能保存！')
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
		var bool = checkFormQtySign(products,1);
		if(!bool){
			return;
		}
		$(products).each(function(i,p){
			p.unitName = p.beUnit == 'B' ? p.wareDw:p.minUnit;
		})

		data.wareStr = JSON.stringify(products);

		uglcw.ui.loading();
		$.ajax({
			url: '${base}manager/dragSaveStkLlhkIn',
			type: 'post',
			data: data,
			dataType: 'json',
			success: function (json) {
				if (json.state) {
					uglcw.ui.get('#billId').value(json.id);
					uglcw.ui.get('#billNo').value(json.billNo);
					$("#btndraft").hide();
					$("#btnsave").hide();
					$("#btndraftaudit").show();
					$("#btnprint").show();
					$("#btncancel").show();
					$("#btnaudit").hide();
					uglcw.ui.get('#billStatus').value("暂存成功");
					isModify = false;
					uglcw.ui.loaded();
					/*uglcw.io.emit('pcstkinreload');
					setTimeout(function () {
						uglcw.ui.replaceCurrentTab('其他入库' + response.id, '${base}manager/showstkin?dataTp=${dataTp}&billId=' + response.id)
					}, 1000)*/
				}
			},
			error: function () {
				uglcw.ui.loaded();
				uglcw.ui.error('暂存失败');

			}
		})
	}

	function submitStk() {
		var valid = uglcw.ui.get('form').validate();
		if (!valid) {
			return;
		}
		var stkId = uglcw.ui.get("#stkId").value();

		if(stkId==0){
			return   uglcw.ui.error('请选择仓库');
		}
		var proId = uglcw.ui.get("#proId").value();

		if(proId == 0){
			return   uglcw.ui.error('请选择入库对象');
		}

		var form = uglcw.ui.bind('form');

		var products = uglcw.ui.get('#grid').bind();
		if (products.length < 1) {
			uglcw.ui.error('请选择商品');
			return;
		}
		var bool = checkFormQtySign(products,1);
		if(!bool){
			return;
		}
		form.id = form.billId;
		$(products).each(function(i,p){
			p.unitName = p.beUnit == 'B' ? p.wareDw:p.minUnit;
		})
		form.wareStr = JSON.stringify(products);
		uglcw.ui.loading();
		$.ajax({
			url: '${base}manager/addStkLlhkIn',
			type: 'post',
			dataType: 'json',
			data: form,
			success: function (json) {
				if (json.state) {
					uglcw.ui.get("#status").value(1);
					uglcw.ui.get("#billId").value(json.id);
					uglcw.ui.get("#billNo").value(json.billNo);
					uglcw.ui.get('#billStatus').value("提交成功");
					$("#btndraft").hide();
					$("#btndraftaudit").hide();
					$("#btnsave").hide();
					$("#btncancel").show();
					uglcw.ui.loaded();
				} else {
					uglcw.ui.error('提交失败');
					uglcw.ui.get("#status").value(-2);
					uglcw.ui.get("#billId").value(json.id);
					uglcw.ui.get("#billNo").value(json.billNo);
					$("#btndraft").hide();
					$("#btndraftaudit").hide();
				}
			},
			error: function () {
				uglcw.ui.loaded()
			}
		})

	}
	//审批
	function audit() {
		var billId = uglcw.ui.get('#billId').value();
		var status = uglcw.ui.get('#status').value();
		if (status == 0) {
			uglcw.ui.error('该单据已审批');
			return;
		}
		if (billId == 0 || status != -2) {
			uglcw.ui.error('发票已作废，不能审批！');
			return;
		}
		if (status == 2) {
			uglcw.ui.error('发票已作废，不能审批');
			return;
		}

		uglcw.ui.confirm('是否确定审核？', function () {
			uglcw.ui.loading();
			$.ajax({
				url: '${base}manager/auditDraftStkLlhkIn',
				type: 'post',
				data: {billId:billId},
				dataType: 'json',
				success: function (json) {
					uglcw.ui.loaded();
					if (json.state) {
						uglcw.ui.get('#billStatus').value('审批成功!');
						uglcw.ui.get("#status").value(0);
						$("#btndraft").hide();
						$("#btndraftaudit").hide();
						$("#btnsave").hide();
						$("#btnprint").show();
						$("#btncancel").show();
						$("#btnaudit").show();
						isModify = false;
					}else {
						uglcw.ui.error('审核失败!');
					}
					uglcw.ui.loaded();
				}
			})

		})
	}

	function toPrint() {
		top.layui.index.openTabsPage('${base}manager/showstkinprint?billId=${billId}', '其他入库${billId}打印');
	}

	function cancelClick() {
		var billId = uglcw.ui.get('#billId').value();
		if (billId == 0) {
			return uglcw.ui.warning('没有可作废单据');
		}
		var billStatus = uglcw.ui.get('#status').value();
		if (billStatus == 2) {
			return uglcw.ui.error('该单据已作废');
		}
		uglcw.ui.confirm('确定作废吗？', function () {
			uglcw.ui.loading();
			$.ajax({
				url: '${base}/manager/cancelStkLlhkInByBillId',
				data: {billId: billId},
				type: 'post',
				dataType: 'json',
				success: function (json) {
					uglcw.ui.loaded();
					if (json.state) {
						uglcw.ui.info('作废成功');
						uglcw.ui.get('#billStatus').value('作废成功');
						uglcw.ui.get('#status').value(2);
						$("#btncancel").hide();
					} else {
						uglcw.ui.error('作废失败!');
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
</script>
</body>
</html>
