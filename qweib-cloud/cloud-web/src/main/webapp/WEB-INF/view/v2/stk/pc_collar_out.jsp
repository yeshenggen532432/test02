<%@ page language="java" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
	<title>领用出库</title>
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
						<li onclick="add()" data-icon="add" class="k-info" id="btnnew">新建</li>
						<c:if test="${permission:checkUserFieldPdm('stk.stkOut.dragsave') and status eq -2 }">
							<li onclick="draftSave()" class="k-info" data-icon="save" id="btndraft">暂存</li>
						</c:if>
						<c:if test="${permission:checkUserFieldPdm('stk.stkOut.audit') and status eq -2}">
							<li onclick="audit()" class="k-info" data-icon="track-changes-accept"  id="btndraftaudit" style="display: ${billId eq 0?'none':''}">审批</li>
						</c:if>
						<c:if test="${permission:checkUserFieldPdm('stk.stkOut.saveaudit')}">
							<li onclick="submitStk()" class="k-info" data-icon="save"  id="btnsave"  style="display: ${(status eq -2 and billId eq 0)?'':'none'}">保存并审批</li>
						</c:if>
						<c:if test="${permission:checkUserFieldPdm('stk.stkOut.fahuo')}">
							<li onclick="auditClick()" data-icon="check" id="btnaudit" style="display: ${(status eq -2 or billId eq 0 or status eq 1)?'none':''}">发货</li>
						</c:if>
						<c:if test="${permission:checkUserFieldPdm('stk.stkOut.cancel')}">
							<li onclick="cancelClick()" id="btncancel" class="k-error" data-icon="delete" style="display: ${billId eq 0?'none':''}">作废</li>
						</c:if>
						<c:if test="${permission:checkUserFieldPdm('stk.stkOut.print')}">
							<li onclick="toPrint()" id="btnprint" data-icon="print" style="display: ${billId eq 0?'none':''}">打印</li>
						</c:if>
					</ul>
					<div class="bill-info">
						<span class="no" style="color: green;"><input id="billNo" uglcw-model="billNo" style="height: 25px;" readonly  uglcw-role="textbox" value="${billNo}"/></span>
						<span class="status" style="color:red;"><input id="billStatus" style="height: 25px;width: 80px" readonly uglcw-model="billstatus" uglcw-role="textbox" value="${billstatus}"></span>
					</div>
				</div>
				<div class="layui-card-body">
					<form class="form-horizontal" uglcw-role="validator">
						<input type="hidden" uglcw-model="id" uglcw-role="textbox" id="billId" value="${billId}"/>
						<input type="hidden" uglcw-model="orderId" uglcw-role="textbox" id="orderId" value="${orderId}"/>
						<input type="hidden" uglcw-model="pszd" uglcw-role="textbox" id="pszd" value="${pszd}"/>
						<input type="hidden" uglcw-model="proType" uglcw-role="textbox" id="proType" value="${proType}"/>
						<input type="hidden" uglcw-model="cstId" uglcw-role="textbox" id="cstId" value="${cstId}"/>
						<input type="hidden" uglcw-model="status" uglcw-role="textbox" id="status" value="${status}"/>
						<input type="hidden" uglcw-model="empId" uglcw-role="textbox" id="empId" value="${empId}"/>
						<input type="hidden" uglcw-model="isSUnitPrice" uglcw-role="textbox" id="isSUnitPrice"
							   value="${isSUnitPrice}">
						<div class="form-group">
							<label class="control-label col-xs-3">领用单位</label>
							<div class="col-xs-4">
								<input uglcw-role="gridselector" uglcw-model="khNm" value="${khNm}"
									   uglcw-validate="required"
									   uglcw-options="click:function(){selectSender();}">
							</div>
							<label class="control-label col-xs-3">单据时间</label>
							<div class="col-xs-4">
								<input uglcw-role="datetimepicker" value="${outTime}" uglcw-model="outDate"
									   uglcw-options="format:'yyyy-MM-dd HH:mm'">
							</div>
							<label class="control-label col-xs-5 col-xs-3">领用仓库</label>
							<div class="col-xs-7 col-xs-4">
								<select id="stkId" uglcw-role="combobox" uglcw-validate="required" uglcw-model="stkId,stkName"
										uglcw-options="
                                    url: '${base}manager/queryBaseStorage',
                                    index:0,
                                    dataTextField: 'stkName',
                                    dataValueField: 'id'
                                "></select>
							</div>
						</div>
						<div class="form-group" style="display: none">
							<label class="control-label col-xs-3">合计金额</label>
							<div class="col-xs-4">
								<input id="totalAmt" uglcw-model="totalamt" uglcw-role="numeric" value="${totalamt}"
									   readonly>
							</div>
							<label class="control-label col-xs-3">折扣金额</label>
							<div class="col-xs-4">
								<input id="discount" uglcw-model="discount" uglcw-role="numeric" value="${discount}">
							</div>
							<label class="control-label col-xs-3">单据金额</label>
							<div class="col-xs-4">
								<input id="disAmt" uglcw-model="disamt" uglcw-role="numeric" value="${disamt}"
									   readonly>
							</div>
						</div>
						<div class="form-group">
							<label class="control-label col-xs-3">领&nbsp;&nbsp;用&nbsp;&nbsp;人</label>
							<div class="col-xs-4">
								<input id="salesman" uglcw-role="gridselector" uglcw-model="staff,empId" value="${staff}"
									   uglcw-options="click: selectEmployee"
								/>
							</div>
							<label class="control-label col-xs-3">联系电话</label>
							<div class="col-xs-4">
								<input uglcw-role="textbox" uglcw-model="staffTel" value="${tel}">
							</div>
						</div>
						<div class="form-group">
							<label class="control-label col-xs-3">备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注</label>
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
                                inTypeCode: 10001,
                                qty:1,
                                amt: 0,
                                remarks:"",
                                price:0
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
						<div data-field="wareNm" uglcw-options="width: 210,
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
                                    template: '<div><span>#= data.wareNm#</span><span class=\'float: right\'>#data.wareGg#</span></div>',
                                    select: function (e) {
                                        var item = e.dataItem;
                                        var model = options.model;
                                        model.inTypeCode = 10001;
                                        model.hsNum = item.hsNum;
                                        model.wareCode = item.wareCode;
                                        model.wareGg = item.wareGg;
                                        model.wareNm = item.wareNm;
                                        model.wareDw = item.wareDw;
                                        model.price = 0;
                                        model.qty = 1;
                                        model.remarks= item.remarks || '';
                                        model.beUnit = item.maxUnitCode;
                                        model.wareId = item.wareId;
                                        model.minUnit = item.minUnit;
                                        model.minUnitCode = item.minUnitCode;
                                        model.maxUnitCode = item.maxUnitCode;
                                        model.productDate = item.productDate || new Date();
                                        model.qualityDays = item.qualityDays || '';
                                        model.amt = parseFloat(model.qty)*parseFloat(model.price);
                                        uglcw.ui.get('#grid').commit();
                                        uglcw.ui.get('#grid').moveToNext(rowIndex, cellIndex);
                                    }
                                });
                           }">产品名称</div>

						<div data-field="wareGg" uglcw-options="width: 100,editable: false">产品规格</div>
						<div data-field="beUnit" uglcw-options="width: 80,
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
							<div data-field="qty" uglcw-options="width: 100,
                            aggregates: ['sum'],
                            schema:{type: 'number',decimals:10},
                            hidden:!${permission:checkUserFieldPdm('stk.stkOut.lookqty')},
                            footerTemplate: '#= (sum || 0) #'
                    ">领用数量
							</div>
						<div data-field="price"
							 uglcw-options="width: 100, hidden: true, schema:{type:'number'}">
							单价
						</div>
						<div data-field="amt" uglcw-options="width: 100,
                            schema:{editable: true},
                            hidden: true,
                            aggregates: ['sum'],
                            editor: function(container, options){ $('<span>'+options.model.amt+'</span>').appendTo(container)},
                            footerTemplate: '#= (sum || 0) #'">报损金额
						</div>
						<div data-field="productDate" uglcw-options="width: 120,format: 'yyyy-MM-dd',
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
                             }">生产日期
						</div>
						<div data-field="qualityDays" uglcw-options="width:110,editable:true">有效期
						</div>
						<div data-field="remarks" uglcw-options="width: 120,editable:true ">备注</div>
						<div data-field="options" uglcw-options="width: 100, command:'destroy'">操作</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<tag:compositive-selector-template index="2"/>
<tag:product-out-selector-template query="onQueryProduct"/>

<script type="text/x-uglcw-template" id="toolbar">
	<a role="button" href="javascript:addRow();" class="k-button k-button-icontext k-grid-add-purchase">
		<span class="k-icon k-i-add"></span>增行
	</a>
	<a role="button" href="javascript:showProductSelector()" class="k-button k-button-icontext k-grid-add-purchase">
		<span class="k-icon k-i-search"></span>批量添加
	</a>
	<a role="button" href="javascript:batchRemove();" class="k-button k-button-icontext k-grid-add-purchase" style="display: none">
		<span class="k-icon k-i-delete"></span>批量删除
	</a>
	<input uglcw-role="autocomplete"
		   uglcw-options="
             highlightFirst: true,
             dataTextField: 'wareNm',
             autoWidth: true,
             url: '${base}manager/dialogWarePage',
             data: function(){
                  return {
                    page:1, rows: 20,
                    waretype: '',
                    stkId: uglcw.ui.get('\\#stkId').value(),
                    wareNm: uglcw.ui.get('\\#autocomplete').value()
                }
            },
            loadFilter:{
                  data: function(response){
                   return response.rows || [];
                   }
             },

             change: function(){this.value('')},
             select: function(e){
                var item = e.dataItem.toJSON();
                var grid = uglcw.ui.get('\\#grid');
                item.qty = 1;
                item.price = '0';
                item.unitName = item.wareDw;
                item.beUnit = item.maxUnitCode;
                item.qty = item.qty || item.stkQty || 1;
                item.amt = parseFloat(item.qty) * parseFloat(item.price);
                grid.addRow(item,{move:false});
             }
            "
		   id="autocomplete" class="autocomplete" placeholder="搜索产品..." style="width: 250px;">
	<%--

	<a role="button" href="javascript:scrollToGridTop();" class="k-button k-button-icontext k-grid-add-purchase">
		<span class="k-icon k-i-arrow-end-up"></span>
	</a>
	<a role="button" href="javascript:scrollToGridBottom();" class="k-button k-button-icontext k-grid-add-purchase">
		<span title="滚动至底部" class="k-icon k-i-arrow-end-down"></span>
	</a>
	<a role="button" href="javascript:saveChanges();" class="k-button k-button-icontext k-grid-add-purchase">
		<span title="滚动至顶部" class="k-icon k-i-check"></span>
	</a>--%>
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
<script src="${base}static/uglcu/biz/erp/util.js?v=20191120"></script>
<script>
	var gridDataSource = ${fns:toJson(warelist)};
	$(function () {
		uglcw.ui.init();

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
				}
				uglcw.ui.get('#grid').commit();
			}
			calTotalAmount();
		})

		/*uglcw.ui.get('#discount').on('change', function () {
			calTotalAmount();
		})
*/
		isModify=false;
		uglcw.ui.get('#grid').on('dataBound', function () {
			uglcw.ui.init('#grid .k-grid-toolbar');
		});
		uglcw.ui.init('#grid .k-grid-toolbar');
		uglcw.ui.loaded();
	});

	var isModify=false;

	function selectSender() {
		<tag:compositive-selector-script title="收货单位" callback="onSenderSelect"/>
	}
	function onSenderSelect(id, name, type) {
		uglcw.ui.bind('body', {
			cstId: id,
			khNm: name,
			proType: type
		})
	}

	function add() {
		uglcw.ui.openTab('领用出库', '${base}manager/pccollarout?billId=0&r=' + new Date().getTime());
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
		uglcw.ui.get('#totalAmt').value(total);
		var discount = uglcw.ui.get('#discount').value();
		uglcw.ui.get('#disAmt').value(total - discount);
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
			$(data).each(function (i, row) {
				row.qty = 1;
				row.price = row.inPrice || '0';
				row.unitName = row.wareDw;
				row.beUnit = row.maxUnitCode;
				row.qty = row.qty || row.stkQty || 1;
				row.amt = parseFloat(row.qty) * parseFloat(row.price);
				row.productDate = row.productDate;
				row.qualityDays =row.qualityDays;
			})
			uglcw.ui.get('#grid').addRow(data);
			uglcw.ui.get('#grid').commit();
			uglcw.ui.get('#grid').scrollBottom();
		}
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
						staff: employee.memberNm,
						empId: employee.memberId,
						staffTel: employee.memberMobile
					})
				}
			}
		})

	}

	function draftSave() {
		var status = uglcw.ui.get('#status').value();
		if (status == 0) {
			return uglcw.ui.warning('该单据已审批，不能暂存！');
		}
		var valid = uglcw.ui.get('form').validate();
		if (valid) {
			var data = uglcw.ui.bind('form');
			var list = uglcw.ui.get('#grid').bind();
			if (!list || list.length < 1) {
				return uglcw.ui.error('请选择商品');
			}
			var bool = checkFormQtySign(list,1);
			if(!bool){
				return;
			}
			data.outType = '领用出库';
			data.shr = data.khNm;
			list = $.map(list, function (product) {
				//FIXME ??
				product.xsTp = "";
				product.productDate = product.productDate ? uglcw.util.toString(product.productDate, 'yyyy-MM-dd') : '';
				product.activeDate = product.activeDate ? uglcw.util.toString(product.activeDate, 'yyyy-MM-dd') : '';
				product.unitName = product.beUnit === product.maxUnitCode ? product.wareDw : product.minUnit;
				if (product.wareId) {
					return product;
				}
			});
			data.wareStr = JSON.stringify(list);
			uglcw.ui.confirm('是否确定暂存？', function () {
				uglcw.ui.loading();
				$.ajax({
					url: '${base}manager/draftSaveStkOut',
					type: 'post',
					data: data,
					dataType: 'json',
					success: function (json) {
						if(json.state){
							uglcw.ui.info('暂存成功');
							$("#btnsave").hide();
							$("#btndraftaudit").show();
							$("#btnprint").show();
							$("#btncancel").show();
							$("#btnaudit").hide();
							uglcw.ui.get('#billStatus').value("暂存成功");
							uglcw.ui.get('#billId').value(json.id);
							uglcw.ui.get('#billNo').value(json.billNo);

						}
						isModify=false;
						uglcw.ui.loaded();
					},
					error: function () {
						uglcw.ui.loaded();
						uglcw.ui.error('暂存失败');
					}
				})
			})
		}
	}

	function audit() {//审批
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
				url: '${base}manager/auditDraftStkOut',
				type: 'post',
				data: {billId: billId},
				dataType: 'json',
				success: function (json) {
					if(json.state){
						uglcw.ui.info('审批成功');
						uglcw.ui.get('#billStatus').value('审批成功');
						uglcw.ui.get("#status").value(0);
						$("#btndraft").hide();
						$("#btndraftaudit").hide();
						$("#btnsave").hide();
						$("#btnprint").show();
						$("#btncancel").show();
						$("#btnaudit").show();
						if(json.autoSend==1){
							$("#btnaudit").hide();
						}
						isModify=false;
					}
					else
					{
						uglcw.ui.error('审核失败!');
					}
					uglcw.ui.loaded();
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
			var bool = checkFormQtySign(list,1);
			if(!bool){
				return;
			}
			data.outType = '领用出库';
			data.shr = data.khNm;
			list = $.map(list, function (product) {
				//FIXME ??
				product.xsTp = "";
				product.activeDate = product.activeDate ? uglcw.util.toString(product.activeDate, 'yyyy-MM-dd') : '';
				product.unitName = product.beUnit === product.maxUnitCode ? product.wareDw : product.minUnit;
				if (product.wareId) {
					return product;
				}
			});

			data.wareStr = JSON.stringify(list);
			uglcw.ui.confirm('保存后将不能修改，是否确定保存？', function () {
				uglcw.ui.loading();
				$.ajax({
					url: '${base}manager/addStkOut',
					type: 'post',
					data: data,
					dataType: 'json',
					success: function (json) {
						if(json.state){
							uglcw.ui.info('提交成功');
							uglcw.ui.get('#billStatus').value('提交成功');
							uglcw.ui.get("#status").value(0);
							uglcw.ui.get("#billId").value(json.id);
							uglcw.ui.get("#billNo").value(json.billNo);
							$("#btndraft").hide();
							$("#btndraftaudit").hide();
							$("#btnsave").hide();
							$("#btnprint").show();
							$("#btncancel").show();
							$("#btnaudit").show();
							if(json.autoSend==1){
								$("#btnaudit").hide();
							}
							isModify = false;
						}
						else
						{
							uglcw.ui.error(json.msg);
						}
						uglcw.ui.loaded();
						isModify=false;
					},
					error: function () {
						uglcw.ui.loaded();
						uglcw.ui.error('审批失败');
					}
				})
			})
		}
	}

	function auditProc(){
		var billId = uglcw.ui.get('#billId').value();
		if(billId == 0){
			return uglcw.ui.warning('请先保存');
		}
		uglcw.ui.openTab('领用出库', '${base}manager/showstkoutcheck?dataTp=1&billId=' + billId);
	}

	function toPrint() {

		var status = $("#status").val();
		if(status == 2)
		{
			return uglcw.ui.warning('单据已经作废,不能打印');
		}
		var billId = $("#billId").val();
		if(billId == 0)
		{
			return  uglcw.ui.warning('没有可打印的单据');
		}
		if(status==-2&&isModify){
			return  uglcw.ui.warning('单据已修改，请先暂存');
		}

		top.layui.index.openTabsPage('${base}manager/showstkoutprint?billId=${billId}&fromFlag=0', '打印领用单据单');
	}


	function cancelClick() {//作废
		var billId = uglcw.ui.get('#billId').value();
		if (billId ==0) {
			return uglcw.ui.warning('没有可作废的单据');
		}

		var status = uglcw.ui.get('#status').value();
		if (status == 2) {
			return uglcw.ui.error('该单据已作废');
		}
		uglcw.ui.confirm('确定作废吗？', function () {
			uglcw.ui.loading();
			$.ajax({
				url: '${base}manager/cancelStkOut',
				data: {billId: billId},
				type: 'post',
				dataType: 'json',
				success: function (response) {
					uglcw.ui.loaded();
					if (response.state) {
						uglcw.ui.info('作废成功');
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
		var status = uglcw.ui.get('#status').value();
		if(status == -2){
			return uglcw.ui.warning('该单据未审批');
		}
		if (status == 1) {
			return uglcw.ui.warning('该单据已收货');
		}
		if (status == 2) {
			return uglcw.ui.warning('该单据已作废');
		}
		auditProc();
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
		model.price = 0;
		model.qty = 1;
		model.sunitFront = item.sunitFront;
		model.beUnit = item.maxUnitCode;
		model.wareId = item.wareId;
		model.minUnit = item.minUnit;
		model.minUnitCode = item.minUnitCode;
		model.maxUnitCode = item.maxUnitCode;
		model.productDate = item.productDate || '';
		model.qualityDays = item.qualityDays || '';
		item.unitName = item.wareDw;
		model.amt = model.price * model.qty;
		uglcw.ui.get('#grid').commit();
		uglcw.ui.get('#grid').moveToNext(rowIndex, cellIndex);
	}
</script>
</body>
</html>
