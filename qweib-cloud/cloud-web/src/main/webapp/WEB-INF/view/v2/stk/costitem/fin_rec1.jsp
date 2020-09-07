<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
	<title>其它收入库开单</title>
	<%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
	<style>
		.k-in {
			width: 100%;
			margin-right: 10px;
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
						<c:if test="${status eq 0}">
							<li onclick="draftSave()" class="k-info" id="btndraft" data-icon="save">暂存</li>
							<li onclick="audit()" class="k-info" style="display: ${billId eq 0?'none':''}" id="btnaudit" data-icon="track-changes-accept">审批</li>
						</c:if>
						<li onclick="saveAudit()" class="k-info"  id="btnsave"  style="display: ${(status eq 0 and billId eq 0)?'':'none'}" data-icon="save">保存并审批</li>
					</ul>
					<div class="bill-info">
						<span class="no" style="color: green;">${billNo}</span>
						<span id="billStatus" class="status" style="color:red;">${billStatus}</span>
					</div>
				</div>
				<div class="layui-card-body">
					<form class="form-horizontal" uglcw-role="validator">
						<input uglcw-role="textbox" type="hidden" uglcw-model="billId" id="billId" value="${billId}"/>
						<input uglcw-role="textbox" type="hidden" uglcw-model="cstId" value="${cstId}"/>
						<input uglcw-role="textbox" type="hidden" uglcw-model="proType" value="${proType}"/>
						<input type="hidden" uglcw-role="textbox" uglcw-model="status" id="status" value="${status}"/>
						<input type="hidden" uglcw-role="textbox" uglcw-model="accId" id="accId" value="${accId}"/>
						<input type="hidden" uglcw-role="textbox" uglcw-model="depId" id="depId" value="${depId}"/>



						<div class="form-group">
							<label class="control-label col-xs-3">往来单位</label>
							<div class="col-xs-4">
								<input uglcw-role="gridselector" uglcw-validate="required" uglcw-options="click: function(){
                                    selectConsignee();
                                }" uglcw-model="khNm,cstId" value="${proName}"/>
							</div>
							<label class="control-label col-xs-3">收款时间</label>
							<div class="col-xs-4">
								<input id="inDate"  uglcw-validate="required" uglcw-role="datetimepicker" uglcw-options="format:'yyyy-MM-dd HH:mm'"
									   uglcw-model="inDate" value="${billTimeStr}">
							</div>
							<label class="control-label col-xs-3">合计金额</label>
							<div class="col-xs-4">
								<input uglcw-role="numeric" id="totalamt" disabled  uglcw-model="totalAmt" uglcw-options="format: 'n2',spinners: false"
									   value="${totalAmt}"/>
							</div>
						</div>
						<div class="form-group" style="margin-bottom: 0px;">
							<label class="control-label col-xs-3">收款账户</label>
							<div class="col-xs-4">
								<select uglcw-role="combobox" uglcw-validate="required"   uglcw-model="accId"
										uglcw-options=" value: '${accId}',
                                  url: '${base}manager/queryAccountList',
                                  loadFilter:{
                                    data: function(response){return response.rows ||[];}
                                  },
                                  dataTextField: 'accName',
                                  dataValueField: 'id'
                                "
								>
								</select>
							</div>
							<label class="control-label col-xs-3">备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注</label>
							<div class="col-xs-11">
                                <textarea uglcw-role="textbox" uglcw-model="remarks"
										  style="width: 100%;">${remarks}</textarea>
							</div>
						</div>
					</form>
				</div>
			</div>
			<div class="layui-row layui-col-space15">
				<div class="layui-col-md7">
					<div class="layui-card">
						<div class="layui-card-body full">
							<div id="grid" uglcw-role="grid"
								 uglcw-options='
								  responsive:[".master",40],
                          id: "id",
                          editable: true,
                          height:400,
                          navigatable: true,
                          aggregate: [
                            {field: "amt", aggregate: "sum"}
                          ],
                          change: calTotalAmount,
                          dataSource:${fns:toJson(sublist)}
                       '
							>
								<div data-field="typeName"
									 uglcw-options="width: 120, editable: false, footerTemplate: '合计:'">其它收入科目
								</div>
								<div data-field="itemName" uglcw-options="width: 150,
									 editor: function(container, options){
										var input = $('<input>');
										input.appendTo(container);
										console.log(options);
										var model = options.model;
										var selector = new uglcw.ui.ComboBox(input);
										selector.init({
											value: model.id,
											dataSource:itemsJson,
											dataTextField: 'itemName',
											dataValueField: 'id',
											select: function(e){
												var item = e.dataItem;
												model.itemId = item.id,
												model.itemName = item.itemName;
											}
										})
									}">其它收入明细科目
								</div>

								<%--<div data-field="itemName" uglcw-options="width: 120, editor: function(container, options){--%>
                                    <%--var input = $('<input data-bind=\'value:itemName\'>');--%>
                                    <%--input.appendTo(container);--%>
                                    <%--var selector = new uglcw.ui.GridSelector(input);--%>
                                    <%--selector.init({--%>
                                        <%--click: function(){--%>
                                            <%--chooseItem(container, options.model, selector);--%>
                                        <%--}--%>
                                    <%--})--%>
                                <%--}">其它收入明细科目--%>
								<%--</div>--%>
								<div data-field="amt"
									 uglcw-options="width: 100,
									   footerTemplate: '#= (sum||0) #',
                                      format: '{0:n2}',
                                      schema:{type: 'number',
                                       validation:{min:0}}
									  ">
									金额
								</div>
								<div data-field="remarks" uglcw-options="width: 130,editable: true ">备注</div>
								<div data-field="options" uglcw-options="width: 100, command:'destroy'">操作</div>
							</div>
						</div>
					</div>
				</div>
				<div class="layui-col-md5">
					<div class="layui-row layui-col-space5">
						<div class="layui-col-md4">
							<div class="layui-card">
								<div class="layui-card-header">
									<span>其它收入科目</span>
								</div>
								<div class="layui-card-body full">
									<div id="tree" uglcw-role="tree" uglcw-options="
							url:'${base}manager/queryIncomeTypeList?typeName=营业外收入',
							dataTextField:'typeName',
							dataValueField: 'id',
							loadFilter:function(response){
								return response.rows;
							},
							select: function(e){
							   var item = this.dataItem(e.node);
							   uglcw.ui.bind('.query',{typeId: item.id});
							   uglcw.ui.get('#grid2').k().setOptions({autoBind: true})
							},
							dataBound: function(){
                                this.select($('#tree .k-item:eq(0)'));
                                var data = this.dataSource.data().toJSON();
                                if(data&&data.length>0){
                                    uglcw.ui.bind('.query',{typeId: data[0].id});
                                    uglcw.ui.get('#grid2').k().setOptions({autoBind: true})
                                }
							}
					"></div>
								</div>
							</div>
						</div>
						<div class="layui-col-md8">
							<div class="layui-card">
								<div class="layui-card-body full">
									<div class="query">
										<input type="hidden" uglcw-role="textbox" uglcw-model="typeId"/>
									</div>
									<div id="grid2" uglcw-role="grid" uglcw-options="
                                     responsive:['.master',40],
                                    url:'${base}manager/queryUseIncomeItemList?typeName=营业外收入',
                                    criteria: '.query',
                                    dblclick: function(row){
                                        uglcw.ui.get('#grid').addRow({
                                            itemId: row.id,
                                            itemName: row.itemName,
                                            typeName: row.typeName,
                                            remarks: row.remarks,
                                        })
                                    }
						">
										<div data-field="itemName">其它收入明细科目</div>
										<div data-field="remarks">备注</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>

		</div>
	</div>
</div>
<tag:compositive-selector-template index="2"/>
<tag:initem-selector-template/>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
	$(function () {
		uglcw.ui.init();
		uglcw.ui.get('#grid').k().dataSource.bind('change', function (e) {
			var action = e.action;
			if (action == 'itemchange' && (e.field == 'amt')) {
				calTotalAmount();
				uglcw.ui.get("#grid").commit();
			}

		})
		loadData();
		setTimeout(uglcw.ui.loaded, 210);
	})

	var c, m, s;

	function chooseItem(container, model, selector) {
		c = container;
		m = model;
		s = selector;
		<tag:costitem-selector-script callback="onCostItemChosen"/>
	}

	function onCostItemChosen(row) {
		s.value(row.itemName);
		m.set('itemId', row.id);
		m.set('itemName', row.itemName);
		m.set('typeName', row.typeName);
		saveChanges();
	}

	function selectConsignee() {
		<tag:compositive-selector-script callback="onItemChoose"/>
	}

	function onItemChoose(id, name, type) {
		uglcw.ui.bind('.master', {khNm: name, cstId: id, proType: type});
	}

	function add() {
		uglcw.ui.openTab('费用报销', '${base}manager/showFinCostEdit?r=' + new Date().getTime());
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
			total += (Number(item.amt));
		})
		uglcw.ui.get('#totalamt').value(total);
	}



	function draftSave() {//暂存

		var status = uglcw.ui.get('#status').value();
		if (status == 1) {
			return uglcw.ui.warning('该单据已审批，不能操作!')
		}
		if (status == 2) {
			return uglcw.ui.warning('该单据已作废，不能操作!')
		}

		if (!uglcw.ui.get('form').validate()) {
			return;
		}
		var data = uglcw.ui.bind('form');
		if(data.accId == 0||data.accId=='') {
			return uglcw.ui.warning("请选择收款账户");
		}
		var items = uglcw.ui.get('#grid').bind();
		if (items.length < 1) {
			uglcw.ui.error('请选择费用');
			return;
		}
		uglcw.ui.get('#grid').commit();
		var valid = true
		$(items).each(function(idx, item){
			if(!item.amt){
				uglcw.ui.warning('第['+(idx+1)+']请输入金额');
				valid =false;
				return false;
			}
		})
		if(!valid){
			return;
		}

		data.id = data.billId;
		data.recTimeStr = data.inDate;
		data.status = 0;
		// data.cstId=data.proId;
		data.wareStr = JSON.stringify(items);
		uglcw.ui.confirm('是否确定暂存?', function () {
			uglcw.ui.loading();
			$.ajax({
				url: '${base}manager/addFinRec',
				type: 'post',
				data: data,
				dataType: 'json',
				success: function (response) {
					uglcw.ui.loaded();
					if (response.state) {
						uglcw.ui.success('暂存成功');
						$('#billStatus').text('暂存成功');
						uglcw.ui.get("#status").value(0);
						uglcw.ui.get("#billId").value(response.id);
						$("#btnaudit").show();
						$("#btnsave").hide();
						response.billId = response.id;
						uglcw.ui.bind('form', response);
					}else{
						uglcw.ui.error('暂存失败！');
					}
				},
				error: function () {
					uglcw.ui.loaded();
				}
			})
		})
	}

	function saveAudit() {//保存并审批
		var valid = uglcw.ui.get('form').validate();
		if (!valid) {
			return;
		}
		var form = uglcw.ui.bind('form');
		if (form.status == 1) {
			return uglcw.ui.warning('该单据已审批，不能操作！');
		}
		if (form.status == 2) {
			return uglcw.ui.warning('该单据已作废，不能操作!');
		}
		form.id = form.billId;
		form.status = 1;
		form.recTimeStr = form.inDate;
		form.wareStr = JSON.stringify(uglcw.ui.get('#grid').bind());

		if(form.accId == 0||form.accId=='') {
			return uglcw.ui.warning("请选择收款账户");
		}
		var row = uglcw.ui.get('#grid').bind();//绑定表单数据
		if (row.length == 0) {
			uglcw.ui.warning("请添加明细！")
			return false;
		}
		var valid = true;
		$(row).each(function (index, item) {
			if (!item.amt) {
				valid = false;
				uglcw.ui.warning('第[' + (index + 1) + ')]行,请选择费用');
				return false;
			}
			$.map(item, function (v, k) {
				form['list[' + index + '].' + k] = v;
			})
		})
		if (!valid) {
			return;
		}

		uglcw.ui.confirm('是否确定保存并审批', function () {
			uglcw.ui.loading();
			$.ajax({
				url: '${base}manager/addFinRec',
				type: 'post',
				dataType: 'json',
				data: form,
				success: function (response) {
					uglcw.ui.loaded()
					if (response.state) {
						uglcw.ui.success('提交成功');
						response.billId = response.id;
						uglcw.ui.get("#status").value(1);
						uglcw.ui.get("#billId").value(response.id);
						$("#btnaudit").hide();
						$("#btnsave").hide();
						$("#btndraft").hide();
						$('#billStatus').text('提交成功');
					} else {
						uglcw.ui.error('提交失败');
					}
				},
				error: function () {
					uglcw.ui.loaded()
				}
			})
		})

	}

	function audit() {
		var status = uglcw.ui.get('#status').value();
		if (status == 1) {
			uglcw.ui.error('该单据已审批,不能操作');
			return;
		}
		if (status == 2) {
			uglcw.ui.error('该单据已作废，不能操作！');
			return;
		}
		uglcw.ui.confirm('是否确定审批？', function () {
			uglcw.ui.loading();
			$.ajax({
				url: '${base}manager/updateFinRecAudit',
				type: 'post',
				data: {billId: uglcw.ui.get('#billId').value(), costTerm: 1},
				dataType: 'json',
				success: function (response) {
					uglcw.ui.loaded();
					if (response.state) {
						uglcw.ui.success('审批成功');
						$('#billStatus').text('审批成功');
						uglcw.ui.get('#status').value(1);
						$("#btnaudit").hide();
						$("#btnsave").hide();
						$("#btndraft").hide();
					}
				}
			})

		})
	}

	function loadData()
	{
		<%--if(${billId}!=0){--%>
		<%--return;--%>
	<%--}--%>
		var path = "${base}manager/queryUseIncomeItemList";
		$.ajax({
			url: path,
			type: "POST",
			data : {"typeName":'营业外收入'},
			dataType: 'json',
			async : false,
			success: function (json) {
				if(json.state){
					var size = json.rows.length;
					itemsJson = json.rows;
					if(${billId}!=0){
						return;
					}
					//"itemName":'其他营业外收入'
					for(var i = 0;i < size; i++)
					{
						if(json.rows[i].itemName=='其他营业外收入'){
							uglcw.ui.get('#grid').addRow({
								itemId: json.rows[i].id,
								itemName: json.rows[i].itemName,
								typeName: json.rows[i].typeName,
								remarks: ''
							})
						}
						// if(i==0){
						// 	uglcw.ui.get('#grid').addRow({
						// 		itemId: json.rows[i].id,
						// 		itemName: json.rows[i].itemName,
						// 		typeName: json.rows[i].typeName,
						// 		remarks: ''
						// 	})
						// }
					}
				}
			}
		});
	}
</script>
</body>
</html>
