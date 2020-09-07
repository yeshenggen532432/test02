<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="tag" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="permission" uri="/WEB-INF/tlds/permission.tld" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html style="font-size: 50px;">

	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<meta name="format-detection" content="telephone=no" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=2.0, user-scalable=no"/>
		<title>移库管理</title>
		<meta name="description" content="">
		<meta name="keywords" content="">
		<script type="text/javascript">
		var amtDisplay = '${permission:checkUserFieldDisplay("stk.stkOut.lookamt")}';
		var priceDisplay = '${permission:checkUserFieldDisplay("stk.stkOut.lookprice")}';
		</script>
		<link rel="stylesheet" href="<%=basePath %>/resource/select/css/main.css">
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/stkstyle/css/style.css"/>		
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/stkstyle/css/lCalendar.css"/>
		<script type="text/javascript" src="<%=basePath %>/resource/jquery-1.8.0.min.js"></script>
		<script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
		<script src="<%=basePath %>/resource/stkstyle/js/pcbasein.js" type="text/javascript" charset="utf-8"></script>
		<script src="<%=basePath %>/resource/select/js/jquery.autocompleter.js"></script>
		<script type="text/javascript" src="<%=basePath %>resource/WdatePicker.js"></script>
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/themes/default/easyui.css">
		<script type="text/javascript" src="<%=basePath %>/resource/jquery.easyui.min.js"></script>
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/themes/icon.css">
		<script src="<%=basePath %>/resource/stkstyle/js/Map.js" type="text/javascript" charset="utf-8"></script>
		<script type="text/javascript">
			var basePath = '<%=basePath %>';
		</script>
	</head>
	<body>
		
		<style type="text/css">
			.menu_btn .item p{
				font-size: 12px;
			}
			.menu_btn .item img:last-of-type{
				display: none;
			}
			.menu_btn .item a{
				color: #00a6fb;
			}
			.menu_btn .item.on img:first-child{
				display: none;
			}
			.menu_btn .item.on img:last-of-type{
				display: inline;
			}
			.menu_btn .item.on a{
				color: #333;
			}
		</style>
		<form action="<%=basePath %>/manager/stkMove/save" name="savefrm" id="savefrm" method="post">
		<div class="center">
			<div class="pcl_lib_out">
				<div class="pcl_menu_box">
					<div class="menu_btn">
						<div class="item on" id="btnnew">
							<a href="javascript:newClick();">
								<img src="<%=basePath %>/resource/stkstyle/img/nicon7.png"/>
								<img src="<%=basePath %>/resource/stkstyle/img/nicon7a.png"/>
								<p>新建</p>
							</a>
						</div>
						<c:if test="${permission:checkUserFieldPdm('stk.stkMove.save')}">
						<div class="item" id="btnsave" >
							<a href="javascript:submitStk();">
								<img src="<%=basePath %>/resource/stkstyle/img/nicon1.png"/>
								<img src="<%=basePath %>/resource/stkstyle/img/nicon1a.png"/>
								<p>暂存</p>
							</a>
						</div>
						</c:if>
						<c:if test="${permission:checkUserFieldPdm('stk.stkMove.audit')}">
						<div class="item" id="btnsave" >
							<a href="javascript:audit();">
								<img src="<%=basePath %>/resource/stkstyle/img/nicon2.png"/>
								<img src="<%=basePath %>/resource/stkstyle/img/nicon2a.png"/>
								<p>审批</p>
							</a>
						</div>
						</c:if>
						<c:if test="${permission:checkUserFieldPdm('stk.stkMove.cancel')}">
						<div class="item" id="btncancel">
							<a href="javascript:cancel();">
								<img src="<%=basePath %>/resource/stkstyle/img/nicon5.png"/>
								<img src="<%=basePath %>/resource/stkstyle/img/nicon5a.png"/>
								<p>作废</p>
							</a>
						</div>
						</c:if>
						<c:if test="${stkMove.id ne -2 }">
						<c:if test="${permission:checkUserFieldPdm('stk.stkMove.print')}">
						<div class="item" id="btnprint">
							<a href="javascript:print();">
								<img src="<%=basePath %>/resource/stkstyle/img/nicon3.png"/>
								<img src="<%=basePath %>/resource/stkstyle/img/nicon3a.png"/>
								<p>打印</p>
							</a>
						</div>
						</c:if>
						</c:if>
						<div class="pcl_right_edi" style="width: 400px;">
							<div class="pcl_right_edi_w">
								<div>
								<input type="text" id="billNo" name="billNo"   style="color:green;width:160px;font-size: 14px" readonly="readonly" value="${stkMove.billNo}"/>
								  <c:choose>
								  	<c:when test="${stkMove.status eq -2 or stkMove.status eq 0 }"><input type="text" id="billstatus"  value="暂存"   style="color:red;width:60px" readonly="readonly"/></c:when>
								  	<c:when test="${stkMove.status eq 1}"><input type="text" id="billstatus"  value="已审批"   style="color:red;width:60px" readonly="readonly"/></c:when>
								  	<c:when test="${stkMove.status eq 2}"><input type="text" id="billstatus"  value="已作废"   style="color:red;width:60px" readonly="readonly"/></c:when>
									  <c:otherwise>
									  	<input type="text" id="billstatus"  value="新建"   style="color:red;width:70px" readonly="readonly"/>
									  </c:otherwise>
								    </c:choose>
								<input type="text" id="billstatus"    style="color:red;width:60px" readonly="readonly"/>
								</div>
							</div>
						</div>
					</div>
				</div>
				<input  type="hidden" name="id" id="billId" value="${stkMove.id}"/>
				<input  type="hidden" name="id" id="billType" value="${stkMove.billType}"/>
				<input  type="hidden" name="bizType" id="bizType" value="${stkMove.bizType}"/>
				<input  type="hidden" name="stkName" id="stkName" value="${stkMove.stkName}"/>
				<input  type="hidden" name="stkInName" id="stkInName" value="${stkMove.stkInName}"/>
				<input  type="hidden" name="proName" id="proName" value="${stkMove.proName}"/>
				<input type="hidden" name="proId" id="proId" value="${stkMove.proId}"/>
				<input type="hidden" name="proType" id="proType" value="${stkMove.proType}"/>
				<input  type="hidden" name="status" id="status" value="${stkMove.status}"/>
				<div class="pcl_fm">
					<table>
						<tbody>
							<tr>
								<td>单据时间：</td>
								<td>
								<div class="pcl_input_box pcl_w2">
									<input name="inDate" id="inDate"  onClick="WdatePicker({skin:'whyGreen',dateFmt: 'yyyy-MM-dd HH:mm'});" style="width: 100px;" value="${stkMove.inDate}"  readonly="readonly"/>
								</div>
								</td>
								<td>出库仓库：</td>
								<td>
								<div class="selbox">
								<span id="stkNamespan">${stkMove.stkName}</span>
									<tag:select name="stkId" id="stkId" tclass="pcl_sel"  tableName="stk_storage" value="${stkMove.stkId }" headerKey="" headerValue="--请选择--" displayKey="id" displayValue="stk_name"/>   
								</div>
								</td>
								<td>入库仓库：</td>
								<td>
								<div class="selbox">
								<span id="stkInNamespan">${stkMove.stkInName}</span>
									<tag:select name="stkInId" id="stkInId" tclass="pcl_sel" tableName="stk_storage" value="${stkMove.stkInId }" headerKey="" headerValue="--请选择--" displayKey="id" displayValue="stk_name"/>   
								</div>
								</td>
							</tr>
							<tr style="display:none;">
								<td>合计金额：</td>
								<td ><div class="pcl_input_box pcl_w2"><input type="text" name="totalAmt" id="totalamt" readonly="readonly" value="${stkMove.totalAmt}"/></div></td>
								<td>移库金额：</td>
								<td ><div class="pcl_input_box pcl_w2"><input type="text"  name="disAmt" id="disamt" readonly="readonly" value="${stkMove.disAmt}"/></div></td>
								<td></td>
								<td><input type="hidden"   name="discount" id="discount" value="${stkMove.discount}" onchange="countAmt()"/></td>
								
							</tr>
							<tr>
								<td valign="top">备注：</td>
								<td colspan="5">
									<div class="pcl_txr">
										<textarea name="remarks" id="remarks" value="${remarks.remarks}"></textarea>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div id="tb" style="padding:5px;height:auto">
				<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:dialogSelectWare();">添加商品</a>
				</div>
				<div class="pcl_ttbox1 clearfix">
					<div class="pcl_lfbox1">
						<table id="more_list">
							<thead>
								<tr>
									<td>序号</td>
									<td>产品编号</td>
									<td>产品名称</td>
									<td>产品规格</td>
									<td>单位</td>
									<td >移库数量</td>
									<td style="display:none">单价</td>
									<td style="display:none">移库金额</td>
									<td><a class="easyui-linkbutton" iconCls="icon-add" plain="true"
										   href="javascript:addTabRow(1);">增行</a></td>
								</tr>
							</thead>
							<tbody id="chooselist">
								<c:forEach items="${stkMove.list}" var="item" varStatus="s">
  								<tr>
									<td>${s.index+1 }</td>
								<td style="padding-left: 20px;text-align: left;" onkeydown="gjr_toNextRow(this,'qty')">
								<input id="wareId${s.index }" type="hidden" name="list[${s.index }].wareId" value = "${item.wareId}"/> 
							    <input id="wareCode${s.index }" name="list[${s.index }].wareCode" readonly="readonly" type="text" style="width: 150px" class="pcl_i2" value="${item.wareCode}"/>
								 </td>
								<td onkeydown="gjr_toNextRow(this,'qty')">
									<tag:autocompleter name="list[${s.index }].wareNm" id="wareNm${s.index }" value="${item.wareNm}"
													   tclass="pcl_i2" onclick="wareAutoClick(this)"
													   placeholder="输入商品名称、商品代码、商品条码"
													   onkeydown="gjr_forAuto_toNextCell(this,'qty')" width="200px"
													   onblur="checkWareExists(this)" ></tag:autocompleter>

								</td>
								<td onkeydown="gjr_toNextRow(this,'qty')">
								 <input id="wareGg${s.index }" name="list[${s.index }].wareGg" readonly="readonly" type="text" class="pcl_i2" value="${item.wareGg}"/>
								</td>
								<td>
								<select id="beUnit${s.index }" name="list[${s.index }].beUnit" class="pcl_sel2" onchange="changeUnit(this,${s.index })">
        						<option value="${item.maxUnitCode}">${item.wareDw}</option>
        						<option value="${item.minUnitCode}">${item.minUnit}</option>
        						</select>
        						<script type="text/javascript">
										document.getElementById("beUnit${s.index}").value='${item.beUnit}';
								</script>
								</td>
								<td onkeydown="gjr_toNextRow(this,'wareNm','1','gjrRowOperFun')">
								<input id="qty${s.index }" name="list[${s.index }].qty" type="text" class="pcl_i2" value="${item.qty}" onchange="countAmt()"/>
								</td>
								<td style="display: none">
								<input id="price${s.index }" name="list[${s.index }].price" type="text" class="pcl_i2" readonly="readonly" value="${item.price}" onchange="countAmt()"/>
								</td>
								<td style="display: none">
								<input id="amt${s.index }" name="list[${s.index }].amt" readonly="readonly" type="text" class="pcl_i2" value="${item.amt}" />
								</td>
								<td style="display:none"><input id="hsNum${s.index }" name="list[${s.index }].hsNum" type="hidden" class="pcl_i2" value="${item.hsNum}"/></td>
								<td style="display:none"><input id="unitName${s.index }" name="list[${s.index }].unitName" type="hidden" class="pcl_i2" value="${item.unitName}" /></td>
								<td><a href="javascript:;"onclick="deleteChoose(this);" class="pcl_del">删除</a></td>
								</tr>
 								</c:forEach>
							</tbody>
							<tfoot>
							<tr  align="center">
								<td>合计:</td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td id="edtSumQty">0</td>
								<td style="display: none"></td>
								<td id="edtSumAmt" style="display:none">0.00</td>
								<td></td>
								<td></td>

							</tr>
							</tfoot>
						</table>
					</div>
				</div>
			</div>
			<div id="copyAutoCompleter" style="display: none">
				<tag:autocompleter name="wareNm" id="wareNm" tclass="pcl_i2" placeholder="输入商品名称、商品代码、商品条码"
								   width="200px;text-align:left" onkeydown="gjr_forAuto_toNextCell(this,'qty')"
								   onblur="checkWareExists(this)"></tag:autocompleter>
			</div>
		</div>
		 <div id="wareDlg" closed="true" class="easyui-dialog" style="width:500px; height:200px;" title="商品选择" iconCls="icon-edit">
        </div>

        </form>
	</body>
	<script src="<%=basePath %>/resource/stkstyle/js/lCalendar.js" type="text/javascript" charset="utf-8"></script>
	<script type="text/javascript">
	$("#stkId").change(function(){
		var index = this.selectedIndex;
		var this_val = this.options[index].text;
		$("#stkName").val(this_val);
		$(this).siblings('span').text(this_val);
		isModify=true;
	});
	$("#stkInId").change(function(){
		var index = this.selectedIndex;
		var this_val = this.options[index].text;
		$("#stkInName").val(this_val);
		$(this).siblings('span').text(this_val);
		isModify=true;
	});
	function dialogSelectWare(){
		   var  stkId = $("#stkId").val();
			if(stkId == ""){
				alert("请选择出库仓库!");
				return;
			}
	    	$('#wareDlg').dialog({
	            title: '商品选择',
	            iconCls:"icon-edit",
	            width: 800,
	            height: 400,
	            modal: true,
	            href: "<%=basePath %>/manager/dialogWareType?stkId="+stkId,
	            onClose: function(){
	            }
	        });
	    	$('#wareDlg').dialog('open');
	  }
	var rowIndex=1000;
	var isModify = false;

	function countAmt(){
		var total = 0;
		var sumQty = 0;
		var trList = $("#chooselist").children("tr");
		for (var i=0;i<trList.length;i++) {
		    var tr = trList.eq(i)
		    var wareId = $(tr).find("input[name$='wareId']").val();
		    var qty = $(tr).find("input[name$='qty']").val();
		    var price = $(tr).find("input[name$='price']").val();
		    if(qty == "")break;
		    $(tr).find("input[name$='amt']").val(numeral(qty*price).format("0.00"));
		    total = total + qty*price;
		    sumQty = sumQty + qty*1;
		    if(wareId == 0)continue;
		}
		$("#totalamt").val(numeral(total).format("0.00"));
		var discount = $("#discount").val();
		var disamt = total - discount;
		$("#disamt").val(numeral(disamt).format("0.00"));

		$("#edtSumAmt").text(numeral(disamt).format("0,0.00"));
		$("#edtSumQty").text(sumQty);
		isModify=true;
	}
	function changeUnit(o,index){
		var trList = $("#chooselist").children("tr");
		if(index<0){
			return;
		}
		var hsNum = document.getElementById("hsNum"+index).value;
		var bePrice = document.getElementById("price"+index).value;
		var k= o.selectedIndex;
		bePrice = bePrice==''?0:bePrice;
		hsNum = hsNum==''?1:hsNum;
		var tempAmt = 0;
		if(o.value=='B'){//包装单位
			tempAmt = bePrice*hsNum;
			document.getElementById("price"+index).value=tempAmt.toFixed(2);
			document.getElementById("unitName"+index).value= o.options[k].text;
		}
		if(o.value=='S'){//计量单位
			tempAmt = bePrice/hsNum;
			tempAmt = parseFloat(tempAmt);
			document.getElementById("price"+index).value = tempAmt.toFixed(2);
			document.getElementById("unitName"+index).value=o.options[k].text;
		}
		countAmt(); 
	}
	
	function deleteChoose(lineObj)
	{
		var status = $("#status").val();
		if(status > 0)return;
		if(confirm('确定删除？')){
			//alert(lineObj.innerHTML);
			$(lineObj).parents('tr').remove();
			countAmt();
			resetTabIndex();
		}
	}
	
	function resetTabIndex(){
		var trList = $("#chooselist").children("tr");
		if(index<0){
			return;
		}
		for(var i=0;i<trList.length;i++){
			var tdArr = trList.eq(i);
			 $(tdArr).find("input[name$='wareId']").attr("name","list["+i+"].wareId");
			$(tdArr).find("input[name$='wareCode']").attr("name","list["+i+"].wareCode");
			$(tdArr).find("input[name$='wareNm']").attr("name","list["+i+"].wareNm");
			$(tdArr).find("input[name$='wareGg']").attr("name","list["+i+"].wareGg");
			$(tdArr).find("input[name$='price']").attr("name","list["+i+"].price");
			$(tdArr).find("input[name$='beUnit']").attr("name","list["+i+"].beUnit");
			$(tdArr).find("input[name$='qty']").attr("name","list["+i+"].qty");
			$(tdArr).find("input[name$='amt']").attr("name","list["+i+"].amt");


		}
	}
	
	function submitStk(){
		    var status = $("#status").val();
		    if(status==1){
		    	alert("该单据已审批，不能保存!");
		    	return;
		    }
		    if(status==2){
		    	alert("该单据已作废，不能保存!");
		    	return;
		    }
		    var  stkId = $("#stkId").val();
			if(stkId == ""){
				alert("请选择出库仓库!");
				return false;
			}
			var  stkInId = $("#stkInId").val();
			if(stkInId == ""){
				alert("请选择入库仓库!");
				return false;
			}
			if(stkId==stkInId){
				alert("出库仓库不能等于入库仓库!");
				return false;
			}
			var trList = $("#chooselist").children("tr");
			if(trList.length==0){
				alert("请添加明细!");
				return false;
			}
			var m = new Map()
			for(var i=0;i<trList.length;i++){
				var tdArr = trList.eq(i);
				var wareNm=  $(tdArr).find("input[name$='wareNm']").val();
				var wareId=  $(tdArr).find("input[name$='wareId']").val();
				if(wareNm==""){
					alert("第"+(i+1)+"行请输入商品!");
					return;
				}
				wareId = $(tdArr).find("input[name$='wareId']").val();
				var key = wareId;
				if(m.containsKey(key)){
					alert(wareNm+",该商品存在重复！");
					return;
				}
				m.put(key,key);
			}
		if(!confirm('是否确定暂存？'))return;
		$("#savefrm").form('submit',{
			success:function(data){
				var json = eval("("+data+")");
				if(json.state){
	        		$("#billId").val(json.id);
	        		$("#billNo").val(json.billNo);
	        		$("#status").val(json.status);
	        		$("#billstatus").val("暂存成功");
					isModify=false;
	        	}else{
	        		alert(json.msg);
	        	}
			}
		});
	}
	
	function audit(){
		var billId = $("#billId").val();
		var status = $("#status").val();
		if(status==1){
			alert("单据已审批，不能在审批!");
			return;
		}
		if(status==2){
			alert("单据已作废，不能在审批!");
			return;
		}
		if(isModify){
			$.messager.alert('消息','单据已修改，请先保存!','info');
			return;
		}
		$.messager.confirm('确认', '是否确定审批?',function(r){
			if(r){
				$.ajax({
			        url: "<%=basePath %>/manager/stkMove/audit",
			        type: "POST",
			        data : {"billId":billId},
			        dataType: 'json',
			        async : false,
			        success: function (json) {
			        	if(json.state){
			        		$("#status").val(1);
			        		$("#billstatus").val("审批成功");
			        	}else{
			        		alert(json.msg);
			        	}
			        }
			    });
			  }
		});
	}
	
	function cancel(){
		var billId = $("#billId").val();
		var status = $("#status").val();
		if(status==2){
			alert("单据已作废，不能在审批!");
			return;
		}
		$.messager.confirm('确认', '是否确定作废?',function(r){
			if(r){
				$.ajax({
			        url: "<%=basePath %>/manager/stkMove/cancel",
			        type: "POST",
			        data : {"billId":billId},
			        dataType: 'json',
			        async : false,
			        success: function (json) {
			        	if(json.state){
			        		$("#status").val(2);
			        		$("#billstatus").val("作废成功");
			        	}else{
			        		$("#billstatus").val(json.msg);
			        	}
			        }
			    });
			  }
		});
	}
	function newClick()
    {
    	location.href='<%=basePath %>/manager/stkMove/add';
    }
	function print()
    {
		if(isModify){
			$.messager.alert('消息','单据已修改，请先保存!','info');
			return;
		}
    	location.href='<%=basePath %>/manager/stkMove/print?billId='+'${stkMove.id}';
    }
	$(function (){
		var billId = $("#billId").val();
		var status = $("#status").val();
		if(billId == 0)
		{
		var myDate = new Date();    
		var seperator1 = "-";
	    
	    var month = myDate.getMonth() + 1;
	    var strDate = myDate.getDate();
	    if (month >= 1 && month <= 9) {
	        month = "0" + month;
	    }
	    if (strDate >= 0 && strDate <= 9) {
	        strDate = "0" + strDate;
	    }
	    var hour = myDate.getHours();
	    if(hour < 10)hour = '0' + hour;
	    var minute = myDate.getMinutes();
	    if(minute<10)minute = '0' + minute;
		var dateStr = myDate.getFullYear() + seperator1 + month + seperator1 + strDate + " " + hour + ":" + minute;	
		$("#inDate").val(dateStr);
		}
		$("#stkId").trigger("change");
		$("#stkInId").trigger("change");
	})




	/**********************设置商品下拉开始**********************/
	var curr_row_index = -1;
	var datas = "";
	function setWareAutoCompleter(obj, index) {
		curr_row_index = index;
		var cstId = $("#cstId").val();
		if (cstId == ""&&xsfpQuickBill=='none') {
			$.messager.alert('消息', '请先选择客户!', 'info');
			return;
		}
		var template = "{{ label }}";
		setAutoCompleter(obj.id, datas, template, setWareAutoDataFun);
	}

	function setAutoWarePingyin() {
		var path = "<%=basePath %>/manager/getWareListData";
		$.ajax({
			url: path,
			type: "POST",
			dataType: 'json',
			async: false,
			success: function (json) {
				if (json.state) {
					datas = json.list;
					var arr = new Array(datas.length);
					for (var i = 0; i < datas.length; i++) {
						var json = datas[i];
						json.name = json.wareNm;
						var label = json.wareNm;
						var temp = "";
						if (json.py != '' && json.py != undefined) {
							if (temp != "") {
								temp = temp + "$"
							}
							temp = temp + json.py;
						}
						if (json.wareCode != '' && json.wareCode != undefined) {
							if (temp != "") {
								temp = temp + "$"
							}
							temp = temp + json.wareCode;
						}
						if (json.beBarCode != '' && json.beBarCode != undefined) {
							if (temp != "") {
								temp = temp + "$"
							}
							temp = temp + json.beBarCode;
						}
						if (json.packBarCode != '' && json.packBarCode != undefined) {
							if (temp != "") {
								temp = temp + "$"
							}
							temp = temp + json.packBarCode;
						}
						if (temp != "") {
							label += "(" + temp + ")";
						}
						json.label = label + "!";
						arr[i] = json;
					}
					datas = arr;
				}
			}
		});
	}
	function setWareAutoDataFun(value, index, selected) {
		var json = {
			"wareId": selected.wareId,
			"wareNm": selected.name,
			"wareCode": selected.wareCode,
			"maxUnitCode": selected.maxUnitCode,
			"maxNm": selected.wareDw,
			"minUnitCode": selected.minUnitCode,
			"minNm": selected.minUnit,
			"hsNum": selected.hsNum,
			"price": selected.inPrice,
			"productDate": selected.productDate,
			"wareGg": selected.wareGg,
			"sunitFront":selected.sunitFront
		}
		// if (curr_row_index == -1) {
		// 	addTabRowData(json);
		// } else {
		setTabRowData(json);
		//}
	}

	function checkWareExists(obj) {
		var check = 0;
		var data = {};
		if (datas != null) {
			for (var i = 0; i < datas.length; i++) {
				var json = datas[i];
				if (obj.value == json.name) {
					check = 1;
					data = json;
					break;
				}
			}
			if (check == 1) {
				var json = {
					"wareId": data.wareId,
					"wareNm": data.name,
					"wareCode": data.wareCode,
					"maxUnitCode": data.maxUnitCode,
					"maxNm": data.wareDw,
					"minUnitCode": data.minUnitCode,
					"minNm": data.minUnit,
					"hsNum": data.hsNum,
					"price": data.inPrice,
					"productDate": data.productDate,
					"wareGg": data.wareGg,
					"sunitFront":data.sunitFront
				};
				if (curr_row_index == -1) {
					//addTabRowData(json);
				} else {
					setTabRowData(json);
				}
			} else {
				if (curr_row_index == -1) {
				} else {
					clearTabRowData(json);
				}
			}
		}
	}

	function setAutoCompleter(id, datas, template, fun) {
		$('#' + id).autocompleter({
			highlightMatches: true,
			source: datas,
			template: template,
			hint: true,
			empty: false,
			limit: 5,
			callback: fun
		});
	}

	function callBackFun(json){
		var size = json.list.length;
		if(size>0){
			for(var i=0;i<size;i++){
				var data = {
					"wareId": json.list[i].wareId,
					"wareNm": json.list[i].wareNm,
					"wareGg": json.list[i].wareGg,
					"wareCode": json.list[i].wareCode,
					"hsNum": json.list[i].hsNum,
					"stkQty": json.list[i].stkQty,
					"price": json.list[i].price,
					"sunitFront": json.list[i].sunitFront,
					"maxNm": json.list[i].wareDw,
					"minUnitCode": json.list[i].minUnitCode,
					"maxUnitCode": json.list[i].maxUnitCode,
					"minNm": json.list[i].minUnit,
					"hsNum": json.list[i].hsNum
				}
				var row = addTabRow(1);
				setRowData(row,data);
			}
		}
	}

	/**
	 *	添加行
	 */
	function addTabRow(k){

		<%--'<tr>'+--%>
		<%--'<td style="padding-left: 20px;text-align: left;"><img src="<%=basePath %>/resource/stkstyle/img/icon19.jpg" class="pcl_ic"/>'+--%>
		<%--'<input type="hidden" id="wareId'+rowIndex+'" name="list['+down+'].wareId" value = "' + wareId + '"/>'+--%>
		<%--'<input type="text" class="pcl_i2" readonly="readonly" style="width: 150px"  id="wareCode'+rowIndex+'" name="list['+down+'].wareCode" value = "' + wareCode + '"/></td>'+--%>
		<%--'<td><input type="text" class="pcl_i2" readonly="readonly" style="width: 150px"  id="wareNm'+rowIndex+'" name="list['+down+'].wareNm" value = "' + wareName + '"/></td>'+--%>
		<%--'<td><input type="text" class="pcl_i2" readonly="readonly" id="wareGg'+rowIndex+'" name="list['+down+'].wareGg" value = "' + wareGg + '"/></td>'+--%>
		<%--'<td>' +  --%>
		<%--'<select id="beUnit'+rowIndex+'" name="list['+down+'].beUnit" class="pcl_sel2" onchange="changeUnit(this,'+rowIndex+')">'+--%>
		<%--'<option value="'+maxUnitCode+'" checked>'+unitName+'</option>'+--%>
		<%--'<option value="'+minUnitCode+'">'+minUnit+'</option>'+--%>
		<%--'</select>'--%>
		<%--+ '</td>'+--%>
		<%--'<td><input id="qty'+rowIndex+'" name="list['+down+'].qty" type="text" class="pcl_i2" value="1" onchange="countAmt()"/></td>'+--%>
		<%--'<td style="display:none"><input id="price'+rowIndex+'" readonly="readonly" name="list['+down+'].price" type="text" class="pcl_i2" value="' + price + '" onchange="countAmt()"/></td>'+--%>
		<%--'<td style="display:none"><input id="amt'+rowIndex+'" readonly="readonly" name="list['+down+'].amt" type="text" class="pcl_i2" value="1" value="' + price + '"/></td>'+--%>
		<%--'<td style="display:none"><input id="hsNum'+rowIndex+'" name="list['+down+'].hsNum" type="hidden" class="pcl_i2" value="'+hsNum+'"/></td>'+--%>
		<%--'<td style="display:none"><input id="unitName'+rowIndex+'" name="list['+down+'].unitName" type="hidden" class="pcl_i2" value="'+unitName+'" /></td>'+--%>
		<%--'<td><a href="javascript:;"onclick="deleteChoose(this);" class="pcl_del">删除</a></td>'+--%>
		<%--'</tr>'--%>

		var autoCompleterHtml = document.getElementById("copyAutoCompleter").innerHTML;
		var len = $("#chooselist").find("tr").length;
		down = len;
		$("#more_list tbody").append(
				'<tr>'+
				'<td class="index">'+(len+1)+'</td>'+
				'<td style="padding-left: 20px;text-align: left;">'+
				'<input type="hidden" name="list['+down+'].wareId"/><input type="text" class="pcl_i2" readonly="true"  name="list['+down+'].wareCode"/></td>'+
				'<td id="autoCompleterTr'+rowIndex+'">'+autoCompleterHtml+'</td>'+
				'<td><input type="text" class="pcl_i2" readonly="true"  name="list['+down+'].wareGg" style="width: 90px;"/></td>'+
				'<td onkeydown="gjr_toNextRow(this,\'qty\')">' +
				'<select id="beUnit'+rowIndex+'" name="list['+down+'].beUnit" class="pcl_sel2" onchange="changeUnit(this,'+rowIndex+')">'+
				'</select>'
				+ '</td>'+
				'<td onkeydown="gjr_toNextRow(this,\'wareNm\',\'1\',\'gjrRowOperFun\')" ><input id="qty'+rowIndex+'"  name="list['+down+'].qty" type="text"  class="pcl_i2" value="1" onchange="countAmt()"/></td>'+
				'<td style="display:none"><input id="price'+rowIndex+'" name="list['+down+'].price" type="text" onkeydown="gjr_toNextCell(this,\'amt\')" class="pcl_i2"  onchange="countAmt()"/></td>'+
				'<td style="display:none"><input  name="list['+down+'].amt" type="text" class="pcl_i2"  onchange="countPrice()"/></td>'+
				'<td style="display:none"><input id="hsNum'+rowIndex+'" name="list['+down+'].hsNum" type="hidden" class="pcl_i2" /></td>'+
				'<td style="display:none"><input id="unitName'+rowIndex+'"  name="list['+down+'].unitName" type="hidden" class="pcl_i2"  /></td>'+
				'<td><a href="javascript:;"onclick="deleteChoose(this);" class="pcl_del">删除</a></td>'+
				'</tr>'
		);
		var row = $("#more_list tbody tr").eq(len);
		$(row).find("input[name$='wareNm']").attr("name","list["+down+"].wareNm");
		$(row).find("input[name$='wareNm']").attr("id", "wareNm" + rowIndex);
		$(row).find("input[name$='wareNm']").on("click", function () {
			var currRow = this.parentNode.parentNode.parentNode.parentNode;
			var tab = currRow.parentNode;
			var currRowIndex = currRow.rowIndex;
			curr_row_index = currRowIndex;
			var template = "{{ label }}";
			setAutoCompleter(this.id, datas, template, setWareAutoDataFun);
			if (k == 1) {
				$(this).focus();
				$(this).click();
				$(this).focus();
			}
		});
		$(row).find("input[name$='wareNm']").on("onblur", function () {
			checkWareExists(this);
		});
		rowIndex++;
		return row;
	}


	function setRowData(row,json){
		$(row).find("input[name$='wareId']").val(json.wareId);
		$(row).find("input[name$='wareCode']").val(json.wareCode);
		$(row).find("input[name$='wareNm']").val(json.wareNm);
		$(row).find("input[name$='wareGg']").val(json.wareGg);
		$(row).find("input[name$='price']").val(json.price);
		$(row).find("input[name$='hsNum']").val(json.hsNum);
		var size = $(row).find("select[name$='beUnit'] option").size();
		if (size == 0) {
			$(row).find("select[name$='beUnit']").append("<option value='" + json.maxUnitCode + "'>" + json.maxNm + "</option>");
			$(row).find("select[name$='beUnit']").append("<option value='" + json.minUnitCode + "'>" + json.minNm + "</option>");
		}
		$(row).find("input[name$='unitName']").val(json.maxNm);
		/************如果商品信息中有设置默认选中辅助单位，那么就选中设置选中辅助 开始***********/
		if(json.sunitFront=="1"){
			$(row).find("select[name$='beUnit']").val(json.minUnitCode);
			$(row).find("select[name$='beUnit']").trigger("change");
		}
		/************如果商品信息中有设置默认选中辅助单位，那么就选中设置选中辅助 结束***********/
		countAmt();
	}

	function setTabRowData(json) {
		var index = curr_row_index - 1;
		var row = $("#more_list tbody tr").eq(index);
		setRowData(row,json);
	}

	function clearTabRowData(json) {
		var index = curr_row_index - 1;
		var row = $("#more_list tbody tr").eq(index);
		$(row).find("input[name$='wareId']").val("");
		$(row).find("input[name$='wareCode']").val("");
		$(row).find("input[name$='wareNm']").val("");
		$(row).find("input[name$='wareGg']").val("");
		$(row).find("input[name$='price']").val("");
		$(row).find("input[name$='hsNum']").val("");
		$(row).find("select[name$='beUnit']").empty();
		$(row).find("input[name$='unitName']").val("");
		countAmt();
	}

	function wareAutoClick(o) {
		var currRow = o.parentNode.parentNode.parentNode.parentNode;
		var currRowIndex = currRow.rowIndex;
		curr_row_index = currRowIndex;
		var template = "{{ label }}";
		setAutoCompleter(this.id, datas, template, setWareAutoDataFun);
		enCount = 0;
		$(this).focus();
		$(this).click();
		$(this).focus();
	}
	setAutoWarePingyin();
	</script>
	<%@include file="/WEB-INF/page/include/handleFile.jsp"%>
</html>