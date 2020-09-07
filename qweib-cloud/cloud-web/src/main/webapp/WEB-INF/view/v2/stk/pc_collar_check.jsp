<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
	<title>领用出库发货单</title>
	<%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
	<div class="layui-row layui-col-space15">
		<div class="layui-col-md12">
			<div class="layui-card master">
				<div class="layui-card-header btn-group">
					<ul uglcw-role="buttongroup">
						<li onclick="auditProc()" class="k-success" data-icon="check">确认发货</li>
					</ul>
				</div>
				<div class="layui-card-body">
					<form class="form-horizontal" uglcw-role="validator">
						<input uglcw-role="textbox" type="hidden" uglcw-model="billId" id="billId" value="${billId}"/>
						<input type="hidden" uglcw-role="textbox" uglcw-model="status" id="status" value="${status}"/>
						<div class="form-group">
							<label class="control-label col-md-3">单号</label>
							<div class="col-md-4">
								<a href="javascript:showBill('${billId}');">${billNo}</a>
							</div>
							<label class="control-label col-md-3" style="display: none">单据状态</label>
							<div class="col-md-4" style="display: none">
								<input id="billStatus" uglcw-model="billstatus" uglcw-role="textbox" value="${billstatus}"
									   readonly
									   class="k-textbox">
							</div>
							<label class="control-label col-xs-5 col-md-3">发货时间</label>
							<div class="col-xs-7 col-md-4">
								<input id="inDate" uglcw-role="datetimepicker" uglcw-options="format:'yyyy-MM-dd HH:mm'"
									   uglcw-model="sendTimeStr" value="${sendTime}">
							</div>
							<label class="control-label col-xs-3">发货仓库</label>
							<div class="col-xs-4">
								<input uglcw-role="textbox" uglcw-model="stkName" value="${stkName}" readonly>
							</div>
						</div>
						<div class="form-group">
							<label class="control-label col-xs-5 col-md-3">领用单位</label>
							<div class="col-xs-7 col-md-4">
								<input uglcw-model="khNm" value="${khNm}" readonly uglcw-role="textbox"/>
							</div>
							<label class="control-label col-xs-3">运输车辆</label>
							<div class="col-xs-4">
								<select uglcw-role="combobox"
										uglcw-options="
                                  value: '${vehId}',
                                  url:'${base}manager/queryVehicleList',
                                  dataTextField: 'vehNo',
                                  dataValueField: 'id'
                                 "
								></select>
							</div>
							<label class="control-label col-xs-3">司&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;机</label>
							<div class="col-xs-4">
								<select uglcw-role="combobox"
										uglcw-options="
                                  value: '${driverId}',
                                  url:'${base}manager/queryDriverList',
                                  dataTextField: 'driverName',
                                  dataValueField: 'id'
                                 "
								></select>
							</div>
						</div>
						<div class="form-group" style="display: none;">
							<label class="control-label col-xs-3">合计金额</label>
							<div class="col-xs-4">
								<input id="totalAmount" uglcw-role="numeric" uglcw-model="totalmt" value="${totalamt}"
									   readonly>
							</div>
							<label class="control-label col-xs-3">整单折扣</label>
							<div class="col-xs-4">
								<input id="discount" uglcw-role="numeric" uglcw-model="discount" value="${discount}">
							</div>
							<label class="control-label col-xs-3">单据金额</label>
							<div class="col-xs-4">
								<input id="discountAmount" uglcw-role="numeric" uglcw-model="disamt" readonly
									   value="${disamt}">
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
                          id: "id",
                          editable: true,
                          dragable: true,
                          height:400,
                          rowNumber: true,
                          navigatable: true,
                          aggregate: [
                            {field: "qty", aggregate: "sum"},
                            {field: "amt", aggregate: "sum"}
                          ],
                          dataSource: gridDataSource
                        '
					>
						<div data-field="wareCode" uglcw-options="
                            width: 100
                        ">产品编号
						</div>
						<div data-field="wareNm" uglcw-options="width: 150, schema:{editable: false}">产品名称</div>
						<div data-field="wareGg" uglcw-options="width: 150">产品规格</div>
						<div data-field="unitName" uglcw-options="width: 150">单位
						</div>
						<div data-field="price"
							 uglcw-options="width: 100,
							     editable: false,
							     hidden:!${permission:checkUserFieldPdm('stk.stkSend.lookprice')}
									">
							单价
						</div>
						<div data-field="qty" uglcw-options="
                           	editable: false,
                            width: 100
                            ">单据数量
						</div>
						<div data-field="outQty" uglcw-options="
                            editable: false,
                            width: 100
                            ">已发数量
						</div>
						<div data-field="outQty1" uglcw-options="
                            schema:{editable: true, type: 'number',decimals:10, validation:{required:true, min:1}},
                            width: 100
                            ">本次发货
						</div>
						<div data-field="productDate" uglcw-options="width: 120,format: 'yyyy-MM-dd',
                             schema:{ type: 'date'},
                             editor: config.editors.productDate">生产日期
						</div>
						<div data-field="options" uglcw-options="width: 150, command:'destroy'">操作</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>


<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script src="${base}static/uglcu/biz/erp/util.js?v=20191120"></script>
<script>
	var gridDataSource = ${fns:toJson(warelist)};
	$(function () {
		uglcw.ui.init();
		uglcw.ui.get('#grid').on('dataBound', function () {
			uglcw.ui.init('#grid .k-grid-toolbar');
		})
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

	function showBill(billId) {
		uglcw.ui.openTab('领用出库单据信息', '${base}manager/showstkout?dataTp=1&billId=' + billId);
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

	function batchRemove() {
		uglcw.ui.get('#grid').removeSelectedRow();
	}

	function auditProc() {
		var billId = uglcw.ui.get('#billId').value();
		if (billId == 0) {
			return uglcw.ui.warning('请先保存单据');
		}
		var status = uglcw.ui.get('#status').value();
		if (status != 0) {
			return uglcw.ui.warning('该单据不能发货');
		}

		if (!uglcw.ui.get('form').validate()) {
			return;
		}
		var data = uglcw.ui.bind('form');
		var list = uglcw.ui.get('#grid').bind();
		var bool = checkFormQtySign(list,1);
		if(!bool){
			return;
		}
		list = $.map(list, function (product) {
			var outQty = product.outQty1;
			if(outQty<0){
				alert("本次发货库数量必须大于0！");
				return;
			}
			product.outQty = product.outQty1;
			if (product.wareId) {
				return product;
			}
		});
		data.wareStr = JSON.stringify(list);
		uglcw.ui.confirm('确定发货吗？', function () {
			$.ajax({
				url: '${base}/manager/auditStkOut',
				type: 'post',
				data: data,
				dataType: 'json',
				success: function (response) {
					if (response.state) {
						uglcw.ui.success('发货成功')
						setTimeout(function () {
							window.location.href = '${base}manager/lookstkoutcheck?billId=' + billId + '&sendId=' + response.sendId;
						}, 1000)
					} else {
						uglcw.ui.error(response.msg);
					}
				}
			})
		})

	}
</script>
</body>
</html>
