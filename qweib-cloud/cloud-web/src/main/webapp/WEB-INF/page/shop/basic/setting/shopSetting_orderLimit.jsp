<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<title>批发购物下单限制设置</title>
	<%@include file="/WEB-INF/page/include/source.jsp"%>
</head>
<body>
<div class="box">
	<form action="manager/shopSetting/edit" name="shopRechargeFrm" id="shopRechargeFrm" method="post">
		<input  type="hidden" name="name" id="name" value="order_limit"/>
		<dl id="dl" class="settingTab">
			<dt class="f14 b">(默认)批发购物下单限制设置</dt>
			<dd>
				<span class="title">限制</span>
				<input type="radio" name="limit_type" value="1" <c:if test="${model==null ||  model.limit_type==null || model.limit_type=='1'}">checked</c:if> >同时满足可下单&nbsp;&nbsp;
				<input type="radio" name="limit_type" value="2" <c:if test="${model!=null && model.limit_type=='2'}">checked</c:if>>满足数量可下单&nbsp;&nbsp;
				<input type="radio" name="limit_type" value="3" <c:if test="${model!=null && model.limit_type=='3'}">checked</c:if>>满足金额可下单&nbsp;&nbsp;
				<input type="radio" name="limit_type" value="4" <c:if test="${model!=null && model.limit_type=='4'}">checked</c:if> title="如果数量或金额有一项为空时则等于不限制">满足任意一项可下单&nbsp;&nbsp;
			</dd>
			<dd>
				<span class="title">数量(大于等于)</span>
				<input type="number" class="reg_input" name="limit_number" value="${model.limit_number}" style="width: 240px"  oninput="if(value.length>10)value=value.slice(0,10);if(value<0)value=0"/>件(0不限制)
			</dd>
			<dd>
				<span class="title">金额(大于等于)</span>
				<input type="number" class="reg_input" name="limit_money" value="${model.limit_money}" style="width: 240px" oninput="if(value.length>10)value=value.slice(0,10);if(value<0)value=0"/>元(0不限制)
			</dd>
		</dl>



		<c:set var="datas" value="${fns:loadListByParam('shop_member_grade','','status=1 and is_jxc=1')}"/>
		<c:forEach items="${datas}" var="data">
			<c:set value="_gradeId${data.id}" var="key"/>
			<c:set value="${modelGrade[key]}" var="gmodel"/>
			<dl id="dl" gradeId="${key}" class="settingTab">
				<dt class="f14 b">${data.grade_name}-限制设置&nbsp;&nbsp;&nbsp;&nbsp;是否启用：<input type="checkbox" value="1" name="is_open" <c:if test="${gmodel.is_open}">checked</c:if>></dt>
				<dd>
					<span class="title">限制</span>
					<input type="radio" name="limit_type${key}" value="1" <c:if test="${gmodel==null ||  gmodel.limit_type==null || gmodel.limit_type=='1'}">checked</c:if> >同时满足可下单&nbsp;&nbsp;
					<input type="radio" name="limit_type${key}" value="2" <c:if test="${gmodel!=null && gmodel.limit_type=='2'}">checked</c:if>>满足数量可下单&nbsp;&nbsp;
					<input type="radio" name="limit_type${key}" value="3" <c:if test="${gmodel!=null && gmodel.limit_type=='3'}">checked</c:if>>满足金额可下单&nbsp;&nbsp;
					<input type="radio" name="limit_type${key}" value="4" <c:if test="${gmodel!=null && gmodel.limit_type=='4'}">checked</c:if> title="如果数量或金额有一项为空时则等于不限制">满足任意一项可下单&nbsp;&nbsp;
				</dd>
				<dd>
					<span class="title">数量(大于等于)</span>
					<input type="number" class="reg_input" name="limit_number" value="${gmodel.limit_number}" style="width: 240px"  oninput="if(value.length>10)value=value.slice(0,5);if(value<0)value=0"/>件(0不限制)
				</dd>
				<dd>
					<span class="title">金额(大于等于)</span>
					<input type="number" class="reg_input" name="limit_money" value="${gmodel.limit_money}" style="width: 240px" oninput="if(value.length>10)value=value.slice(0,6);if(value<0)value=0"/>元(0不限制)
				</dd>
			</dl>

		</c:forEach>

		<%--select id="${id}" name="${name }" class="${tclass}" onchange="${onchange }" options="${options}" style="width:${width};font-size: 10px">
			<c:if test="${ not empty headerKey || headerKey eq ''}">
				<option value="${headerKey}" >
					<c:if test="${ not empty headerValue }">${headerValue}</c:if>
				</option>
			</c:if>
			<c:forEach items="${datas}" var="map">
				<option value="${map[displayKey]}" ${(value eq  map[displayKey])?'selected':''}>${map[displayValue]}</option>
			</c:forEach>
		</select>--%>

		<div class="f_reg_but" style="clear:both">
			<input type="button" value="保存" class="l_button" onclick="toSubmit();"/>
			<input type="reset" value="重置" class="b_button"/>
		</div>
	</form>
</div>


<!-- ===================================以下是：js===================================================-->
<script type="text/javascript">
	//表单验证
	$(function(){
		$.formValidator.initConfig();
		//$("#limit_number").formValidator({ onShow: "请输入数字", onCorrect: "通过" }).regexValidator({ regExp: "num", dataType: "enum", onError: "数字格式不正确" });
		//$("#limit_money").formValidator({ onShow: "请输入数字", onCorrect: "通过" }).regexValidator({ regExp: "num", dataType: "enum", onError: "数字格式不正确" });
	});

	//提交数据
	function toSubmit(){
		var datas=[];
		$(".settingTab").each(function (i,item) {
			var gradeId=$(this).attr("gradeId")
			if(!gradeId)gradeId="";
			var data={};
			data.name="order_limit"+gradeId;
			data.is_open=$('[name=is_open]',this).is(":checked");
			data.limit_type=$("[name=limit_type"+gradeId+"]:checked",this).val();
			data.limit_number=$('[name=limit_number]',this).val();
			data.limit_money=$('[name=limit_money]',this).val();
			datas.push(data);
		})
		console.log(datas);

		/*if ($.formValidator.pageIsValid()==true){
			$("#shopRechargeFrm").form('submit',{
				dataType: 'json',
				success:function(data){
					if(data)
					alert(JSON.parse(data).msg)
				}
			});
		}*/
		var msg="";
		$(datas).each(function (i,item) {
			$.ajax({
				type:"post",
				url:"${base}/manager/shopSetting/edit",
				data:item,
				async:false,
				success:function (data) {
					if(data)
						msg=data.msg;
				}
			});
		})
		alert(msg);
	}
</script>
</body>
</html>
