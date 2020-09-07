<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
	<title>驰用T3</title>
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
				<div class="layui-card-header">
					<span>客户信息</span>
				</div>
				<div class="layui-card-body">
					<form class="form-horizontal" uglcw-role="validator">
						<div class="form-group">
							<label class="control-label col-xs-2">客户名称</label>
							<div class="col-xs-3">
								<input uglcw-role="textbox" uglcw-model="khNm" value="${customer.khNm}"/>
							</div>
							<label class="control-label col-xs-2">客户名称</label>
							<div class="col-xs-3">
								<input uglcw-role="textbox" uglcw-model="khCode" value="${customer.khCode}"/>
							</div>
							<label class="control-label col-xs-2">ERP编码</label>
							<div class="col-xs-3">
								<input uglcw-role="textbox" uglcw-model="erpCode" value="${customer.erpCode}"/>
							</div>
							<label class="control-label col-xs-2">客户类型</label>
							<div class="col-xs-3">
								<select uglcw-role="combobox" uglcw-model="qdtpNm"
										uglcw-options="

								  value:'${customer.qdtpNm}',
                                  url: '${base}manager/queryarealist1',
                                  data: function(){
                                  	return {qdtpNm: '${customer.qdtpNm}'}
                                  },
                                  loadFilter:{
                                    data: function(response){
                                    return response.list1 ||[];
                                   }
                                  },
                                  dataTextField: 'qdtpNm',
                                  dataValueField: 'qdtpNm'
                                "
								>

								</select>
							</div>
						</div>
						<div class="form-group">
							<label class="control-label col-xs-2">市场类型</label>
							<div class="col-xs-3">
								<select uglcw-role="combobox" uglcw-model="sctpNm">
									<option value="">请选择</option>
									<c:forEach items="${sctypels}" var="sctypels">
										<option value="${sctypels.sctpNm}" <c:if test="${sctypels.sctpNm==customer.sctpNm}">selected</c:if>>${sctypels.sctpNm}</option>
									</c:forEach>
								</select>
							</div>
							<label class="control-label col-xs-2">销售阶段</label>
							<div class="col-xs-3">
								<select uglcw-role="combobox" uglcw-model="xsjdNm">
									<option value="">请选择</option>
									<c:forEach items="${xsphasels}" var="xsphasels">
										<option value="${xsphasels.phaseNm}" <c:if test="${xsphasels.phaseNm==customer.xsjdNm}">selected</c:if>>${xsphasels.phaseNm}</option>
									</c:forEach>
								</select>
							</div>
							<label class="control-label col-xs-2">拜访频次</label>
							<div class="col-xs-3">
								<select uglcw-role="combobox" uglcw-model="bfpcNm">
									<option value="">请选择</option>
									<c:forEach items="${bfpcls}" var="bfpcls">
										<option value="${bfpcls.pcNm}" <c:if test="${bfpcls.pcNm==customer.bfpcNm}">selected</c:if>>${bfpcls.pcNm}</option>
									</c:forEach>
								</select>
							</div>
							<label class="control-label col-xs-2">客户等级</label>
							<div class="col-xs-3">
								<select uglcw-role="combobox" uglcw-model="khdjNm"
										uglcw-options="
								  value:'${customer.khdjNm}',
                                  url: '${base}manager/queryarealist2',
                                  data: function(){
                                  	return {qdtpNm: '${customer.qdtpNm}'}
                                  },
                                  loadFilter:{
                                    data: function(response){
                                    return response.list2 ||[];
                                   }
                                  },
                                  dataTextField: 'khdjNm',
                                  dataValueField: 'khdjNm'
                                "
								>

								</select>
							</div>


						</div>
						<div class="form-group" style="margin-bottom: 0px;">
							<label class="control-label col-xs-2">供货类型</label>
							<div class="col-xs-3">
								<select uglcw-role="combobox" uglcw-model="ghtpNm">
									<option value="">请选择</option>
									<c:forEach items="${ghtypels}" var="ghtypels">
										<option value="${ghtypels.ghtpNm}" <c:if test="${ghtypels.ghtpNm==customer.ghtpNm}">selected</c:if>>${ghtypels.ghtpNm}</option>
									</c:forEach>
								</select>
							</div>
							<label class="control-label col-xs-2">供货经销商</label>
							<div class="col-xs-3">
								<input uglcw-role="textbox" uglcw-model="pkhNm" value="${customer.pkhNm}"/>
							</div>
							<label class="control-label col-xs-2">业务联系人</label>
							<div class="col-xs-3">
								<input uglcw-role="textbox" uglcw-model="linkman" value="${customer.linkman}"/>
							</div>
							<label class="control-label col-xs-2">电话</label>
							<div class="col-xs-3">
								<input uglcw-role="textbox" uglcw-model="tel" value="${customer.tel}"/>
							</div>
						</div>
						<div class="form-group" style="margin-bottom: 10px;">

							<label class="control-label col-xs-2">手机</label>
							<div class="col-xs-3">
								<input uglcw-role="textbox" uglcw-model="mobile" value="${customer.mobile}"/>
							</div>
							<label class="control-label col-xs-2">手机支持彩信</label>
							<div class="col-xs-3">
								<input uglcw-role="textbox" uglcw-model="mobileCx" value="${customer.mobileCx}"/>
							</div>
							<label class="control-label col-xs-2">QQ</label>
							<div class="col-xs-3">
								<input uglcw-role="textbox" uglcw-model="qq" value="${customer.qq}"/>
							</div>
							<label class="control-label col-xs-2">微信</label>
							<div class="col-xs-3">
								<input uglcw-role="textbox" uglcw-model="wxCode" value="${customer.wxCode}"/>
							</div>
						</div>
						<div class="form-group">
							<label class="control-label col-xs-2">是否有效</label>
							<div class="col-xs-3">
								<input uglcw-role="checkbox" type="checkbox" uglcw-model="isYx" uglcw-value="1" id="readonly" />
								<label for="readonly"></label>
							</div>
							<label class="control-label col-xs-2">开户日期</label>
							<div class="col-xs-3">
								<input uglcw-role="textbox" uglcw-model="openDate" value="${customer.openDate}"/>
							</div>
							<label class="control-label col-xs-2">闭户日期</label>
							<div class="col-xs-3">
								<input uglcw-role="textbox" uglcw-model="closeDate" value="${customer.closeDate}"/>
							</div>
							<label class="control-label col-xs-2">是否开户</label>
							<div class="col-xs-3">
								<input type="checkbox" uglcw-role="checkbox"  id="isOpen1" uglcw-model="isOpen"  uglcw-value="1"/>
								<label for="isOpen1"></label>
							</div>
						</div>
						<div class="form-group">
							<label class="control-label col-xs-2">审核状态</label>
							<div class="col-xs-3">
								<input uglcw-role="textbox" uglcw-model="shZt" value="${customer.shZt}"/>
							</div>
							<label class="control-label col-xs-2">省</label>
							<div class="col-xs-3">
								<input uglcw-role="textbox" uglcw-model="province" value="${customer.province}"/>
							</div>
							<label class="control-label col-xs-2">城市</label>
							<div class="col-xs-3">
								<input uglcw-role="textbox" uglcw-model="city" value="${customer.city}"/>
							</div>
							<label class="control-label col-xs-2">区县</label>
							<div class="col-xs-3">
								<input uglcw-role="textbox" uglcw-model="area"  value="${customer.area}"/>
							</div>
						</div>
						<div class="form-group">
							<label class="control-label col-xs-2">地址</label>
							<div class="col-xs-18">
							<textarea uglcw-role="textbox" uglcw-model="address" >${customer.address}</textarea>
							</div>
						</div>
						<div class="form-group">
							<label class="control-label col-xs-2">备注</label>
							<div class="col-xs-18">
								<textarea uglcw-role="textbox" uglcw-model="remo">${customer.remo}</textarea>
							</div>
						</div>
						<div class="form-group">
							<label class="control-label col-xs-2">业务员</label>
							<div class="col-xs-3">
								<input uglcw-role="textbox" uglcw-model="memberNm" value="${customer.memberNm}"/>
							</div>
							<label class="control-label col-xs-2">部门</label>
							<div class="col-xs-3">
								<input uglcw-role="textbox" uglcw-model="branchName" value="${customer.branchName}"/>
							</div>
							<label class="control-label col-xs-2">合作方式</label>
							<div class="col-xs-3">
								<select uglcw-role="combobox" uglcw-model="hzfsNm">
									<option value="">请选择</option>
									<c:forEach items="${hzfsls}" var="hzfsls">
										<option value="${hzfsls.hzfsNm}" <c:if test="${hzfsls.hzfsNm==customer.hzfsNm}">selected</c:if>>${hzfsls.hzfsNm}</option>
									</c:forEach>
								</select>
							</div>

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
		uglcw.ui.init();
		uglcw.ui.loaded()

	})



</script>
</body>
</html>
