<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
	<title>其它入库收货入库</title>
	<%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
	<div class="layui-card master">
		<div class="layui-card-header btn-group">
			<ul uglcw-role="buttongroup">
				<c:if test="${permission:checkUserFieldPdm('stk.stkCome.save')}">
					<li onclick="auditProc()" id="btnaudit" class="k-success" data-icon="check">确认收货</li>
				</c:if>
			</ul>
		</div>
		<div class="layui-card-body">
			<form class="form-horizontal" uglcw-role="validator">
				<input uglcw-role="textbox" type="hidden" uglcw-model="billId" id="billId" value="${billId}"/>
				<input type="hidden" uglcw-role="textbox" uglcw-model="status" id="status" value="${status}"/>
				<div class="form-group">
					<label class="control-label col-xs-3">单据单号</label>
					<div class="col-xs-4">
						<input uglcw-role="gridselector" readonly value="${billNo}"
							   uglcw-options="click: function(){ showBill('${billId}'); }"
						/>
					</div>
					<label class="control-label col-xs-3" style="display: none">单据状态</label>
					<div class="col-xs-4" style="display: none">
						<input id="billStatus" uglcw-model="billstatus" uglcw-role="textbox" value="${billstatus}"
							   readonly
							   class="k-textbox">
					</div>
					<label class="control-label col-xs-3">收货时间</label>
					<div class="col-xs-4">
						<input id="inDate" uglcw-role="datetimepicker" uglcw-options="format:'yyyy-MM-dd HH:mm'"
							   uglcw-model="inDate" value="${inTime}">
					</div>
				</div>
				<div class="form-group">
					<label class="control-label col-xs-3">发货单位</label>
					<div class="col-xs-4">
						<input uglcw-model="proName" value="${proName}" readonly uglcw-role="textbox"/>
					</div>
					<label class="control-label col-xs-3">收货仓库</label>
					<div class="col-xs-4">
						<input uglcw-role="textbox" uglcw-model="stkName" value="${stkName}" readonly>
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
                          responsive:[".master",40],
                          editable: true,
                          dragable: true,
                          rowNumber: true,
                          checkbox: false,
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
                            width: 100
                        ">产品编号
				</div>
				<div data-field="wareNm" uglcw-options="width: 150,editable:false">产品名称</div>
				<div data-field="wareGg" uglcw-options="width: 100">产品规格</div>
				<div data-field="unitName" uglcw-options="width: 100">单位
				</div>
				<div data-field="price"
					 uglcw-options="width: 100,editable:false">
					单价
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
				<div data-field="qty" uglcw-options="
                           editable:false,
                            width: 100
                            ">单据数量
				</div>
				<div data-field="inQty" uglcw-options="
                            editable:false,
                            width: 100
                            ">已收数量
				</div>
				<div data-field="inQty1" uglcw-options="
                            schema:{editable: true, type: 'number',decimals:10, validation:{required:true, min:1}},
                            width: 80
                            ">本次收货
				</div>

				<div data-field="options" uglcw-options="width: 100, command:'destroy'">操作</div>
			</div>
		</div>
	</div>
</div>

<script type="text/x-kendo-template" id="toolbar">
	<%--
    <a role="button" href="javascript:batchRemove();" class="k-button k-button-icontext k-grid-add-purchase">
        <span class="k-icon k-i-delete"></span>批量删除
    </a>
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
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script src="${base}static/uglcu/biz/erp/util.js?v=20191120"></script>
<script>
	var gridDataSource = ${fns:toJson(warelist)};
	$(function () {
		uglcw.ui.init();
		uglcw.ui.get('#grid').on('dataBound', function () {
			uglcw.ui.init('#grid .k-grid-toolbar');
		})
		uglcw.ui.loaded();
	})



	function showBill(billId) {
		uglcw.ui.openTab('其他入库单据信息', '${base}manager/showstkin?dataTp=1&billId=' + billId);
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

	function toPrint() {
		uglcw.ui.openTab('单据${billId}打印', '${base}manager/showstkoutprint?billId=${billId}');
	}

	function auditProc() {
		var billId = uglcw.ui.get('#billId').value();
		if (billId == 0) {
			return uglcw.ui.warning('请先保存单据');
		}
		var status = uglcw.ui.get('#status').value();
		if (status != 0) {
			return uglcw.ui.warning('该单据不能收货');
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
			var inQty = product.inQty1;
			if(inQty<0){
				alert("本次入库数量必须大于0！");
				return;
			}
			product.inQty = product.inQty1;
			if (product.wareId) {
				return product;
			}
		});
		data.wareStr = JSON.stringify(list);
		$("#btnaudit").attr("disabled","disabled");
		uglcw.ui.confirm('确定收货吗？', function () {
			$.ajax({
				url: '${base}manager/auditProc',
				type: 'post',
				data: data,
				dataType: 'json',
				success: function (response) {
					if (response.state) {
						uglcw.ui.success('确认收货成功');
						$("#btnaudit").hide();
						<%--setTimeout(function () {--%>
						<%--window.location.href = '${base}manager/showstkincheck?billId=${billId}';--%>
						<%--}, 1000)--%>
					} else {
						$("#btnaudit").attr("disabled",false);
						uglcw.ui.error(response.msg || '确认收货失败');
					}
				}
			})
		})

	}
</script>
</body>
</html>
