<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
	<title>添加经销商-修改经销商</title>
	<%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
	<style>
		.product-grid td {
			padding: 0;
		}
		.tyWidth{
			width:200px
		}
		/*lable左对齐*/
		.form-horizontal .control-label {
			text-align: left;
		}
		/*去掉阴影*/
		.layui-card {
			box-shadow: 0 0 0 0 rgba(0,0,0,0);
		}
	</style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
	<div class="layui-row layui-col-space15">
		<div class="layui-col-md12">
			<div class="layui-card" id="layout">
				<div class="layui-card-header">
					<button id="save" uglcw-role="button" class="k-info" onclick="javascript:toSumbit();">保存</button>
				</div>
				<div class="layui-card-body">
					<form class="form-horizontal" uglcw-role="validator">
						<div uglcw-role="tabs">
							<ul >
								<li>经销商信息</li>
								<li>基本</li>
							</ul>
							<%--======================经销商信息:start===========================--%>
							<div>
								<div class="layui-col-md12">
									<div class="layui-card">
										<div class="layui-card-body">
											<input type="hidden" uglcw-role="textbox" uglcw-model="id" id="id" value="${customer.id}"/>
											<input type="hidden" uglcw-role="textbox" uglcw-model="khTp" id="khTp" value="1"/>
											<input type="hidden" uglcw-role="textbox" uglcw-model="qdtpNm" id="qdtpNm" value="${customer.qdtpNm}"/>
											<input type="hidden" uglcw-role="textbox" uglcw-model="khdjNm" id="khdjNm" value="${customer.khdjNm}"/>
											<input type="hidden" uglcw-role="textbox" uglcw-model="xsjdNm" id="xsjdNm" value="${customer.xsjdNm}"/>
											<input type="hidden" uglcw-role="textbox" uglcw-model="ghtpNm" id="ghtpNm" value="${customer.ghtpNm}"/>
											<input type="hidden" uglcw-role="textbox" uglcw-model="khPid" id="khPid" value="${customer.khPid}"/>
											<input type="hidden" uglcw-role="textbox" uglcw-model="qq" id="qq" value="${customer.qq}"/>
											<input type="hidden" uglcw-role="textbox" uglcw-model="wxCode" id="wxCode" value="${customer.wxCode}"/>
											<input type="hidden" uglcw-role="textbox" uglcw-model="shMid" id="shMid" value="${customer.shMid}"/>
											<input type="hidden" uglcw-role="textbox" uglcw-model="shTime" id="shTime" value="${customer.shTime}"/>
											<input type="hidden" uglcw-role="textbox" uglcw-model="province" id="province" value="${customer.province}"/>
											<input type="hidden" uglcw-role="textbox" uglcw-model="city" id="city" value="${customer.city}"/>
											<input type="hidden" uglcw-role="textbox" uglcw-model="area" id="area" value="${customer.area}"/>
											<input type="hidden" uglcw-role="textbox" uglcw-model="longitude" id="longitude" value="${customer.longitude}"/>
											<input type="hidden" uglcw-role="textbox" uglcw-model="latitude" id="latitude" value="${customer.latitude}"/>
											<input type="hidden" uglcw-role="textbox" uglcw-model="memId" id="memId" value="${customer.memId}"/>
											<input type="hidden" uglcw-role="textbox" uglcw-model="branchId" id="branchId" value="${customer.branchId}"/>
											<input type="hidden" uglcw-role="textbox" uglcw-model="wlId" id="wlId" value="${customer.wlId}"/>
											<input type="hidden" uglcw-role="textbox" uglcw-model="createTime" id="createTime" value="${customer.createTime}"/>
											<input type="hidden" uglcw-role="textbox" uglcw-model="isDb" id="isDb" value="${customer.isDb}"/>
											<div class="form-group">
												<label class="control-label col-xs-2">1.经销商名称</label>
												<div class="col-xs-16">
													<input style="width: 200px;" uglcw-model="khNm" id="khNm" uglcw-role="textbox" value="${customer.khNm}" value="${customer.khNm}" placeholder="(必填)" uglcw-validate="required" >
												</div>
											</div>
											<div class="form-group">
												<label class="control-label col-xs-2">2.业务员</label>
												<div class="col-xs-16">
													<input id="memberNm" uglcw-role="gridselector" uglcw-model="memberNm" value="${customer.memberNm}" class="tyWidth"
														   style="width: 200px;"
														   uglcw-options="click: showSelectMember" readonly uglcw-validate="required"  placeholder="(必填)"/>
												</div>
											</div>
											<div class="form-group">
												<label class="control-label col-xs-2">3.部门</label>
												<div class="col-xs-16">
													<input style="width: 200px;" uglcw-model="branchName" id="branchName" uglcw-role="textbox" value="${customer.branchName}" readonly>
												</div>
											</div>
											<div class="form-group">
												<label class="control-label col-xs-2">4.经销商分类</label>
												<div class="col-xs-16">
													<select uglcw-model="jxsflNm" id="jxsflNm" class="tyWidth" uglcw-role="combobox">
														<option value="">请选择</option>
														<c:forEach items="${jxsflls}" var="jxsflls">
															<option value="${jxsflls.flNm}" <c:if test="${jxsflls.flNm==customer.jxsflNm}">selected</c:if>>${jxsflls.flNm}</option>
														</c:forEach>
													</select>
												</div>
											</div>
											<div class="form-group">
												<label class="control-label col-xs-2">5.市场类型</label>
												<div class="col-xs-16">
													<select uglcw-model="sctpNm" id="sctpNm" class="tyWidth" uglcw-role="combobox">
														<option value="">请选择</option>
														<c:forEach items="${sctypels}" var="sctypels">
															<option value="${sctypels.sctpNm}" <c:if test="${sctypels.sctpNm==customer.sctpNm}">selected</c:if>>${sctypels.sctpNm}</option>
														</c:forEach>
													</select>
												</div>
											</div>
											<div class="form-group">
												<label class="control-label col-xs-2">6.经销商级别</label>
												<div class="col-xs-16">
													<select uglcw-model="jxsjbNm" id="jxsjbNm" class="tyWidth" uglcw-role="combobox">
														<option value="">请选择</option>
														<c:forEach items="${jxsjbls}" var="jxsjbls">
															<option value="${jxsjbls.jbNm}" <c:if test="${jxsjbls.jbNm==customer.jxsjbNm}">selected</c:if>>${jxsjbls.jbNm}</option>
														</c:forEach>
													</select>
												</div>
											</div>
											<div class="form-group">
												<label class="control-label col-xs-2">7.拜访频次</label>
												<div class="col-xs-16">
													<select uglcw-model="bfpcNm" id="bfpcNm" class="tyWidth" uglcw-role="combobox">
														<option value="">请选择</option>
														<c:forEach items="${bfpcls}" var="bfpcls">
															<option value="${bfpcls.pcNm}" <c:if test="${bfpcls.pcNm==customer.bfpcNm}">selected</c:if>>${bfpcls.pcNm}</option>
														</c:forEach>
													</select>
												</div>
											</div>
											<div class="form-group">
												<label class="control-label col-xs-2">8.经销商状态</label>
												<div class="col-xs-16">
													<select uglcw-model="jxsztNm" id="jxsztNm" class="tyWidth" uglcw-role="combobox">
														<option value="">请选择</option>
														<c:forEach items="${jxsztls}" var="jxsztls">
															<option value="${jxsztls.ztNm}" <c:if test="${jxsztls.ztNm==customer.jxsztNm}">selected</c:if>>${jxsztls.ztNm}</option>
														</c:forEach>
													</select>
												</div>
											</div>
											<div class="form-group">
												<label class="control-label col-xs-2">9.联系人</label>
												<div class="col-xs-16">
													<input style="width: 200px;" uglcw-model="linkman" id="linkman" uglcw-role="textbox" value="${customer.linkman}">
												</div>
											</div>
											<div class="form-group">
												<label class="control-label col-xs-2">10.联系电话</label>
												<div class="col-xs-16">
													<input style="width: 200px;" uglcw-model="tel" id="tel" uglcw-role="textbox" value="${customer.tel}" >
												</div>
											</div>
											<div class="form-group">
												<label class="control-label col-xs-2">11.联系手机</label>
												<div class="col-xs-16">
													<input style="width: 200px;" uglcw-model="mobile" id="mobile" uglcw-role="textbox" value="${customer.mobile}">
												</div>
											</div>
											<div class="form-group">
												<label class="control-label col-xs-2">12.手机支持彩信</label>
												<div class="col-xs-16">
													<input style="width: 200px;" uglcw-model="mobileCx" id="mobileCx" uglcw-role="textbox" value="${customer.mobileCx}">
												</div>
											</div>
											<div class="form-group">
												<label class="control-label col-xs-2">13.收货地址</label>
												<div class="col-xs-16">
													<input style="width: 200px;" uglcw-model="address" id="address" uglcw-role="textbox" value="${customer.address}">
												</div>
											</div>
											<div class="form-group">
												<label class="control-label col-xs-2">14.物流公司</label>
												<div class="col-xs-16">
													<input id="wlNm" uglcw-role="gridselector" uglcw-model="wlNm" value="${customer.wlNm}" class="tyWidth"
														   style="width: 200px;"
														   uglcw-options="click: showSelectWlgs" readonly/>
												</div>
											</div>
											<div class="form-group">
												<label class="control-label col-xs-2">15.物流联系人</label>
												<div class="col-xs-16">
													<input style="width: 200px;" uglcw-model="wllinkman" id="wllinkman" uglcw-role="textbox" value="${customer.wllinkman}" readonly>
												</div>
											</div>
											<div class="form-group">
												<label class="control-label col-xs-2">16.物流联系电话</label>
												<div class="col-xs-16">
													<input style="width: 200px;" uglcw-model="wltel" id="wltel" uglcw-role="textbox" value="${customer.wltel}" readonly>
												</div>
											</div>
											<div class="form-group">
												<label class="control-label col-xs-2">17.物流公司地址</label>
												<div class="col-xs-16">
													<input style="width: 200px;" uglcw-model="wladdress" id="wladdress" uglcw-role="textbox" value="${customer.wladdress}" readonly>
												</div>
											</div>
											<div class="form-group">
												<label class="control-label col-xs-2">18.经销商编码</label>
												<div class="col-xs-16">
													<input style="width: 200px;" uglcw-model="khCode" id="khCode" uglcw-role="textbox" value="${customer.khCode}" >
												</div>
											</div>
											<div class="form-group">
												<label class="control-label col-xs-2">19.ERP编码</label>
												<div class="col-xs-16">
													<input style="width: 200px;" uglcw-model="erpCode" id="erpCode" uglcw-role="textbox" value="${customer.erpCode}">
												</div>
											</div>
											<div class="form-group">
												<label class="control-label col-xs-2">20.审核状态</label>
												<div class="col-xs-16">
													<input style="width: 200px;" uglcw-model="shZt" id="shZt" uglcw-role="textbox" value="${customer.shZt}" readonly>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
							<%--======================经销商信息:end===========================--%>


							<%--======================基本:start===========================--%>
							<div>
								<div class="layui-col-md12">
									<div class="layui-card">
										<div class="layui-card-body">
											<div class="form-group">
												<label class="control-label col-xs-2">1.负责人/法人</label>
												<div class="col-xs-16">
													<input style="width: 200px;" uglcw-model="fman" id="fman" uglcw-role="textbox" value="${customer.fman}">
												</div>
											</div>
											<div class="form-group">
												<label class="control-label col-xs-2">2.负责人电话</label>
												<div class="col-xs-16">
													<input style="width: 200px;" uglcw-model="ftel" id="ftel" uglcw-role="textbox" value="${customer.ftel}">
												</div>
											</div>
											<div class="form-group">
												<label class="control-label col-xs-2">3.经营范围</label>
												<div class="col-xs-16">
													<input style="width: 200px;" uglcw-model="jyfw" id="jyfw" uglcw-role="textbox" value="${customer.jyfw}">
												</div>
											</div>
											<div class="form-group">
												<label class="control-label col-xs-2">4.覆盖区域</label>
												<div class="col-xs-16">
													<input style="width: 200px;" uglcw-model="fgqy" id="fgqy" uglcw-role="textbox" value="${customer.fgqy}">
												</div>
											</div>
											<div class="form-group">
												<label class="control-label col-xs-2">5.年销售额</label>
												<div class="col-xs-16">
													<input style="width: 200px;" uglcw-model="nxse" id="nxse" uglcw-role="textbox" value="${customer.nxse}">
												</div>
											</div>
											<div class="form-group">
												<label class="control-label col-xs-2">6.仓库面积</label>
												<div class="col-xs-16">
													<input style="width: 200px;" uglcw-model="ckmj" id="ckmj" uglcw-role="textbox" value="${customer.ckmj}">
												</div>
											</div>

											<div class="form-group">
												<label class="control-label col-xs-2" for="isYx">7.是否有效</label>
												<div class="col-xs-16">
													<input style="width: 200px;" uglcw-model="isYx" id="isYx" uglcw-role="checkbox" type="checkbox" uglcw-value="${empty customer.isYx?1:customer.isYx}" uglcw-options="type:'number'">
													<label for="isYx"></label>
												</div>
											</div>
											<div class="form-group">
												<label class="control-label col-xs-2" for="isOpen">8.是否开户</label>
												<div class="col-xs-16">
													<input style="width: 200px;" uglcw-model="isOpen" id="isOpen" uglcw-role="checkbox" type="checkbox" uglcw-value="${empty customer.isOpen?1:customer.isOpen}" uglcw-options="type:'number'">
													<label for="isOpen"></label>
												</div>
											</div>

											<div class="form-group">
												<label class="control-label col-xs-2">9.开户日期</label>
												<div class="col-xs-16">
													<input style="width: 200px;" uglcw-model="openDate" id="openDate" uglcw-role="datepicker" value="${customer.openDate}">
												</div>
											</div>
											<div class="form-group">
												<label class="control-label col-xs-2">10.闭户日期</label>
												<div class="col-xs-16">
													<input style="width: 200px;" uglcw-model="closeDate" id="closeDate" uglcw-role="datepicker" value="${customer.closeDate}">
												</div>
											</div>
											<div class="form-group">
												<label class="control-label col-xs-2">11.备注</label>
												<div class="col-xs-16">
													<textarea style="width: 300px;" uglcw-model="remo" id="remo" uglcw-role="textbox">${customer.remo}</textarea>
												</div>
											</div>
											<div class="form-group">
												<label class="control-label col-xs-2">12.代理其他品类</label>
												<div class="col-xs-16">
													<textarea style="width: 300px;" uglcw-model="dlqtpl" id="dlqtpl" uglcw-role="textbox">${customer.dlqtpl}</textarea>
												</div>
											</div>
											<div class="form-group">
												<label class="control-label col-xs-2">13.代理其他品牌</label>
												<div class="col-xs-16">
													<textarea style="width: 300px;" uglcw-model="dlqtpp" id="dlqtpp" uglcw-role="textbox">${customer.dlqtpp}</textarea>
												</div>
											</div>

										</div>
									</div>
								</div>
							</div>
							<%--======================基本:end===========================--%>



						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

	$(function () {
		//ui:初始化
		uglcw.ui.init();
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
			var height =$(window).height();
			$('#layout').height((height-30)+"px");
		}, 200)
	}

	//-----------------------------------------------------------------------------------------

	function toSumbit() {
		var khNm=uglcw.ui.get("#khNm").value();
		var memberNm=uglcw.ui.get("#memberNm").value();
		var mobile=uglcw.ui.get("#mobile").value();
		if(!khNm){
			uglcw.ui.toast("经销商名称不能为空");
			return;
		}
		if(!memberNm){
			uglcw.ui.toast("业务员不能为空");
			return;
		}
		if(!mobile){
			uglcw.ui.toast("手机不能为空");
			return;
		}
		var valid = uglcw.ui.get('.form-horizontal').validate();
		if (!valid) {
			return false;
		}
		var data = uglcw.ui.bind('.form-horizontal');
		uglcw.ui.loading();
		$.ajax({
			url: '${base}manager/opercustomer',
			type: 'post',
			data: data,
			async: false,
			success: function (resp) {
				uglcw.ui.loaded();
				if(resp == "1"){
					uglcw.ui.success("添加成功");
					uglcw.io.emit('refreshCustomer-jxs',"success");//发布事件
					uglcw.ui.closeCurrentTab();//关闭当前页
				}else if(resp == "2"){
					uglcw.ui.success("修改成功");
					uglcw.io.emit('refreshCustomer-jxs',"success");//发布事件
					uglcw.ui.closeCurrentTab();//关闭当前页
				}else if(resp == "-2"){
					uglcw.ui.success("该客户编码已存在");
					return;
				}else if(resp == "-3"){
					uglcw.ui.success("该客户名称已存在");
					return;
				}else{
					uglcw.ui.error("操作失败");
				}
			}
		})
	}

	//选择业务员
	function showSelectMember() {
		uglcw.ui.Modal.showGridSelector({
			closable: false,
			title: false,
			url: '${base}manager/memberPage',
			// query: function (params) {
			//     params.extra = new Date().getTime();
			// },
			checkbox: false,
			width: 650,
			height: 400,
			criteria: '<input placeholder="请输入姓名" uglcw-role="textbox" uglcw-model="memberNm">',
			columns: [
				{field: 'memberNm', title: '姓名', width: 100},
				{field: 'memberMobile', title: '手机号码', width: 150},
				{field: 'branchName', title: '部门', width: 150},
			],
			yes: function (nodes) {
				var node = nodes[0];
				uglcw.ui.get('#memId').value(node.memberId);
				uglcw.ui.get('#memberNm').value(node.memberNm);
				uglcw.ui.get('#branchId').value(node.branchId);
				uglcw.ui.get('#branchName').value(node.branchName);
			}
		})
	}

	//选择物流公司
	function showSelectWlgs(){
		uglcw.ui.Modal.showGridSelector({
			closable: false,
			title: false,
			url: '${base}manager/logisticsPage',
			// query: function (params) {
			//     params.extra = new Date().getTime();
			// },
			checkbox: false,
			width: 650,
			height: 400,
			criteria: '<input placeholder="请输入物流公司名称" uglcw-role="textbox" uglcw-model="wlNm">',
			columns: [
				{field: 'wlNm', title: '名称', width: 100},
				{field: 'dcode', title: '代码', width: 150},
				{field: 'linkman', title: '联系人', width: 150},
				{field: 'tel', title: '联系电话', width: 150},
				{field: 'address', title: '地址', width: 280},
			],
			yes: function (nodes) {
				var node = nodes[0];
				uglcw.ui.get('#wlId').value(node.id);
				uglcw.ui.get('#wlNm').value(node.wlNm);
				uglcw.ui.get('#wllinkman').value(node.linkman);
				uglcw.ui.get('#wltel').value(node.tel);
				uglcw.ui.get('#wladdress').value(node.address);
			}
		})
	}

	//显示地图
	function showMap(){
		var city = uglcw.ui.get("#city").value();
		var oldLng = uglcw.ui.get("#longitude").value();
		var oldLat = uglcw.ui.get("#latitude").value();
		var zoom = uglcw.ui.get("#zoom").value();
		var address = uglcw.ui.get("#address").value();
		document.getElementById("windowifrm").src="${base}/manager/getmap?oldLng="+oldLng+"&oldLat="+oldLat+"&zoom="+zoom+"&searchCondition="+address+"&city="+city;
		showWindow("标注(提示：右键选择获取标注。)");
	}
	function setWarePrice() {
		uglcw.ui.openTab("${customer.khNm}-设置商品销售价","manager/customerwaretype?customerId=${customer.id}&op=1");
	}

	function setAutoPrice(){
		uglcw.ui.openTab("${customer.khNm}-设置营销费用","manager/autopricecustomerwaretype?customerId=${customer.id}");
	}


</script>
</body>
</html>
