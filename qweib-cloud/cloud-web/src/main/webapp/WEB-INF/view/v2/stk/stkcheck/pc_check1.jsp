<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
	<title>盘点开单</title>
	<%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
	<form id="export" action="${base}manager/downloadCheckDataToExcel" method="post" style="display: none;">
		<textarea uglcw-role="textbox" name="wareStr" id="wareStr"></textarea>
	</form>
	<div class="uglcw-layout-container">
		<div class="uglcw-layout-fixed" style="width: 200px;">
			<div class="layui-card">
				<div class="layui-card-body full" uglcw-role="resizable" uglcw-options="responsive:[75]">
					<div id="tree"
						 uglcw-role="tree"
						 uglcw-options="
							url: '${base}manager/companyWaretypes',
							expandable:function(node){
							    return node.id == 0;
							},
							select: function(e){
							    var node = this.dataItem(e.node);
							    onWareTypeSelect(node.id);
							}">

					</div>
				</div>
			</div>
		</div>
		<div class="uglcw-layout-content">
			<div class="layui-card header">
				<div class="layui-card-body">
					<div class="form-horizontal query">
						<input type="hidden" uglcw-role="textbox" uglcw-model="wtype" id="wtype" value="${wtype}"/>
						<input id="billId" type="hidden" uglcw-role="textbox" uglcw-model="id" value="${billId}"/>
						<div class="form-group" style="margin-bottom: 5px!important;">
							<div class="col-xs-4" style="width: 250px">
								<input uglcw-model="checkTimeStr" uglcw-role="datetimepicker"
									   uglcw-options="format: 'yyyy-MM-dd HH:mm'"
									   value="${checkTime}" placeholder="盘点时间">
							</div>
							<div class="col-xs-4" style="width: 250px">
								<select uglcw-model="stkId" id="stkId" uglcw-role="combobox"
										uglcw-options="
                                            index: 0,
                                            value: '${stkId}',
                                            url: '${base}manager/queryBaseStorage',
                                            dataTextField: 'stkName',
                                            dataValueField: 'id'
                                        "
										placeholder="盘点仓库"></select>
							</div>
							<div class="col-xs-4 " style="width: 250px">
								<input value="${staff}" placeholder="选择人员" uglcw-model="staff,empId"
									   uglcw-role="gridselector"
									   uglcw-options="click: function(){
                                         selectEmployee();
                                        }"/>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="layui-card">

				<%--url: '${base}manager/queryCheckSub?billId=${billId}'--%>

				<div class="layui-card-body full">
					<div id="grid" uglcw-role="grid"
						 uglcw-options="
                            responsive: ['.header', 40],
                            editable: true,
                            autoAppendRow: false,
                            toolbar: uglcw.util.template($('#toolbar').html()),
                            id:'id',
                            serverFiltering: false
                    ">
						<div data-field="wareCode" uglcw-options="width:120,tooltip: true">商品编码</div>
						<div data-field="wareNm" uglcw-options="width:120, tooltip: true">商品名称</div>
						<div data-field="wareGg" uglcw-options="width:90">规格</div>
						<div data-field="stkQty" uglcw-options="width:90, format:'{0:n2}'">账面数量</div>
						<div data-field="unitName" uglcw-options="width:100">大单位</div>
						<div data-field="qty"
							 uglcw-options="width:120, format: '{0:n2}', editable: true, schema:{type: 'number'}">大单位数量
						</div>
						<div data-field="minUnit" uglcw-options="width:100">小单位</div>
						<div data-field="minQty"
							 uglcw-options="width:120, format: '{0:n2}', editable: true, schema:{type: 'number'}">
							小单位数量
						</div>
						<div data-field="disQty" uglcw-options="width:90, format:'{0:n2}'">差量</div>
						<div data-field="productDate" uglcw-options="width: 150, format: 'yyyy-MM-dd',
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
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<script type="text/x-uglcw-template" id="toolbar">
	<a role="button" class="k-button k-button-icontext"
	   href="javascript:dialogSelectWare();">
		<span class="k-icon k-i-search"></span>选择商品
	</a>
	<a role="button" class="k-button k-button-icontext"
	   href="javascript:drageSaveStk();">
		<span class="k-icon k-i-save"></span>暂存
	</a>
	<c:if test="${billId eq 0}">
		<a role="button" class="k-button k-button-icontext"
		   href="javascript:submitStk();">
			<span class="k-icon k-i-check"></span>保存并审批
		</a>
	</c:if>
	<a role="button" class="k-button k-button-icontext"
	   href="javascript:toDownloadDataExcel();">
		<span class="k-icon k-i-download"></span>下载数据
	</a>
	<a role="button" class="k-button k-button-icontext"
	   href="javascript:toUpWare();">
		<span class="k-icon k-i-upload"></span>上传数据
	</a>
	<a role="button" class="k-button k-button-icontext"
	   href="javascript:toDownloadCheckCustomTemplate();">
		<span class="k-icon k-i-download"></span>下载自定义数据模版
	</a>
	<a role="button" class="k-button k-button-icontext"
	   href="javascript:toUpCustomWare();">
		<span class="k-icon k-i-upload"></span>上传自定义数据
	</a>
	<span style="color: red;">（账面数量-大单位数量-小单位数量=差量）</span>
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

	$(function () {
		uglcw.ui.init();

		uglcw.ui.get('#stkId').on('change', function () {
			uglcw.ui.get('#grid').bind([]);
		});

		uglcw.ui.get('#grid').k().dataSource.bind('change', function (e) {
			var action = e.action;
			if (action === 'itemchange') {
				var item = e.items[0];
				if (e.field === 'minQty' || e.field === 'qty') {
					var disQty = item.qty - item.stkQty;
					var hsNum = item.hsNum || 1;
					var hsQty = item.minQty / hsNum;
					disQty = disQty + hsQty;
					item.set('disQty', disQty);
				}
			}
		})
		load();
		uglcw.ui.loaded();

		displaySub();

	});

	function selectEmployee() {
		<tag:dept-employee-selector callback="onEmployeeSelect"/>
	}

	function onEmployeeSelect(result) {
		if (result && result.length > 0) {
			var employee = result[0];
			uglcw.ui.bind('body', {
				staff: employee.memberNm,
				empId: employee.memberId
			})
		}
	}

	function onWareTypeSelect(typeId) {
		if(typeId==0){
			typeId="";
		}else{
			typeId='-'+typeId+'-';
		}
		uglcw.ui.get('#grid').k().dataSource.filter({
			field: 'waretypePath',
			operator: 'contains',
			value: typeId || ''
		})
	}

	function dialogSelectWare() {
		<tag:product-selector2 selection="#grid" callback="onProductSelect" query="onProductQuery" />
	}

	function onProductQuery(params) {
		params.stkId = uglcw.ui.get('#stkId').value();
		return params;
	}

	function onProductSelect(products) {
		var data = uglcw.ui.get('#grid').bind();
		if (products && products.length > 0) {
			$.map(products, function (p) {
				p.qty = p.stkQty;
				p.unitName = p.wareDw;
				p.disQty = 0;
				p.minQty = p.minQty || 0;
				var hit = false;
				$(data).each(function (j, row) {
					if (row.wareId == p.wareId) {
						hit = true;
						return false;
					}
				})
				if (!hit) {
					uglcw.ui.get('#grid').addRow(p);
				}
			})
		}

	}

	function toDownloadDataExcel() {
		var list = uglcw.ui.get('#grid').bind();
		$.map(list, function (item) {
			item.produceDate = item.productDate instanceof Date ? uglcw.util.toString(item.productDate, 'yyyy-MM-dd') : item.productDate;
		});
		uglcw.ui.get('#wareStr').value(JSON.stringify(list));
		$('#export').submit();
	}

	function drageSaveStk() {
		var data = uglcw.ui.bind('.query');
		var list = uglcw.ui.get('#grid').bind();
		if (!list || list.length < 1) {
			return uglcw.ui.error('请选择商品');
		}
		$.map(list, function (item) {
			item.produceDate = item.productDate instanceof Date ? uglcw.util.toString(item.productDate, 'yyyy-MM-dd') : item.productDate;
		});
		var stkId = uglcw.ui.get('#stkId').value();
		if (!stkId) {
			return uglcw.ui.error('请选择仓库');
		}
		data.wareStr = JSON.stringify(list);
		uglcw.ui.confirm('暂存后将不能修改，审批后影响库存', function () {
			$.ajax({
				url: '${base}manager/drageStkCheck',
				type: 'post',
				data: data,
				success: function (response) {
					if (response.state) {
						uglcw.ui.get('#billId').value(response.id);
						uglcw.ui.success(response.msg);
					} else {
						uglcw.ui.error(response.msg);
					}
				}
			})
		})
	}

	function submitStk() {
		var data = uglcw.ui.bind('.query');
		if (data.billId > 0) {
			return uglcw.ui.warning('盘点单不能修改');
		}
		var list = uglcw.ui.get('#grid').bind();
		if (!list || list.length < 0) {
			return uglcw.ui.error('请选择商品');
		}
		$.map(list, function (item) {
			item.produceDate = item.productDate instanceof Date ? uglcw.util.toString(item.productDate, 'yyyy-MM-dd') : item.productDate;
		});
		var stkId = uglcw.ui.get('#stkId').value();
		if (!stkId) {
			return uglcw.ui.error('请选择仓库');
		}
		data.wareStr = JSON.stringify(list);
		uglcw.ui.confirm('保存后将不能修改，是否确定保存', function () {
			$.ajax({
				url: '${base}manager/addStkCheck',
				type: 'post',
				data: data,
				success: function (response) {
					if (response.state) {
						uglcw.ui.success(response.msg);
						setTimeout(function () {
							uglcw.ui.replaceCurrentTab('盘点详情', '${base}manager/showStkcheck?billId=' + response.id);
						}, 1000)

					} else {
						uglcw.ui.error(response.msg);
					}
				}
			})
		})
	}

	function toUpWare() {
		uglcw.ui.Modal.showUpload({
			url: '${base}manager/toUpCheckData',
			field: 'upFile',
			error: function () {
				console.log('error', arguments)
			},
			complete: function () {
				console.log('complete', arguments);
			},
			success: function (e) {
				if (!e.response.state) {
					uglcw.ui.error(e.response);
				} else {
					//uglcw.ui.get('#grid').addRow(p);
					//console.log(e.response.list);
					uglcw.ui.get('#grid').bind(e.response.list);
					uglcw.ui.success('导入成功');
					// uglcw.ui.get('#grid').reload();
				}
			}
		})
	}

	var wareList = [];
	var wareIds="";

	function load() {
		var billId = uglcw.ui.get('#billId').value();
		if (billId == 0) {
			uglcw.ui.bind('.query', {
				checkTimeStr: uglcw.util.toString(new Date(), 'yyyy-MM-dd HH:mm')
			});
		} else {
			$.ajax({
				url: '${base}manager/queryCheckSub',
				type: 'post',
				data: {
					billId: billId
				},
				success: function (response) {
					if (response.state) {
						uglcw.ui.get('#grid').bind(response.list || []);
					}
				}
			})
		}
	}

	function toDownloadCheckCustomTemplate() {
		uglcw.ui.confirm('是否确定下载自定义模版?', function () {
			window.location.href = "manager/downloadCheckCustomTemplate";
		})
	}

	function toUpCustomWare() {
		var stkId = uglcw.ui.get('#stkId').value();
		if (!stkId) {
			return uglcw.ui.error('请选择仓库');
		}
		// $("#upStkId").val(stkId);
		// $("#wareIds").val("");
		wareIds="";
		uglcw.ui.Modal.showUpload({
			url: '${base}manager/toUpCheckCustomData?upStkId='+stkId,
			field: 'upFile',
			error: function () {
				console.log('error', arguments)
			},
			complete: function () {
				console.log('complete', arguments);
			},
			success: function (e) {
				if (!e.response.state) {
					uglcw.ui.error(e.response);
				} else {
					//uglcw.ui.get('grid').value([]);
					wareIds = e.response.wareIds;
					if(wareIds!=""){
						uglcw.ui.confirm('导入商品信息中有新新增的商品是否去完善', function () {
							showUpdateWares(wareIds);
						})
					}
					console.log(e.response.list);
					uglcw.ui.get('#grid').value(e.response.list);
					uglcw.ui.success('导入成功');
					//uglcw.ui.get('#grid').reload();
				}
			}
		})
	}


	function showUpdateWares(ids){
		var rtn =	uglcw.ui.Modal.open({
			title:'完善商品信息',
			url:"<%=basePath%>/manager/toWareRepair?ids="+ids,
			area:'500px',
			full:false,
			closable:false,
			btns:['yes'],
			success:function(container){
				uglcw.ui.toast('open success');
			},
			yes:function(container){

				(ids);
				uglcw.ui.Modal.close(rtn);
			},
			cancel:function(){
				uglcw.ui.toast('cancel');
			}

		})

	}

	function refreshCheckWare(){
		var wareIds = $("#wareIds").val();
		$.ajax({
			url: "<%=basePath %>/manager/getWareByIds",
			type: "POST",
			data : {"ids":wareIds},
			dataType: 'json',
			async : false,
			success: function (json) {
				if(json!=undefined&&json.state){
					var wareDatas = json.rows;
					var list = uglcw.ui.get('#grid').k().dataSouce.data();
					if (!list || list.length < 0) {
						return uglcw.ui.error('请选择商品');
					}
					$.map(list, function (item) {
						var newWare =getNewWare(item.wareId,wareDatas);
						if(newWare!=""){
							var minQty=item.minQty;
							if(minQty==""){
								minQty=0;
							}
							var qty =item.qty;
							var stkQty = item.stkQty;
							var disQty = qty - stkQty;
							disQty = numeral(disQty).format("0.00");
							var hsNum = newWare.hsNum;
							if(hsNum==0||hsNum==null||hsNum==undefined){
								hsNum = 1;
							}
							var hsQty = minQty/hsNum;
							disQty = parseFloat(disQty) + parseFloat(hsQty);
							disQty = formatterNumber(disQty);
							item.disQty = disQty;
							item.hsNum = hsNum;
							item.unitName =newWare.wareDw;
							item.minUnit = newWare.minUnit;
						}
					});
					uglcw.ui.get('#grid').commit();
				}
			}
		});
	}
	function getNewWare(wareId,wareDatas){
		var newWare="";
		for(var i=0;i<wareDatas.length;i++){
			var data = wareDatas[i];
			if(wareId==data.wareId){
				newWare = data;
				break;
			}
		}
		return newWare;
	}

	function displaySub()
	{
		var path = "${base}/manager/queryCheckSub";
		var billId = $("#billId").val();
		if(billId==""){
			return;
		}
		$.ajax({
			url: path,
			type: "POST",
			data : {"billId":billId},
			dataType: 'json',
			async : false,
			success: function (json) {
				if(json.state){
					uglcw.ui.get('#grid').value(json.list);
				}
			}
		});
	}
</script>
</body>
</html>
