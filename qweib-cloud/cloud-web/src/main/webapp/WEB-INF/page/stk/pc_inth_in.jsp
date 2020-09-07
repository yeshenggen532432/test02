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
		<title>采购退货</title>
		<meta name="description" content="">
		<meta name="keywords" content="">
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/stkstyle/css/style.css"/>	
		<script type="text/javascript">
		var priceDisplay = '${permission:checkUserFieldDisplay("stk.stkIn.lookprice")}';
		var amtDisplay = '${permission:checkUserFieldDisplay("stk.stkIn.lookamt")}';
		var qtyDisplay = '${permission:checkUserFieldDisplay("stk.stkIn.lookqty")}';
		</script>
		<link rel="stylesheet" href="<%=basePath %>/resource/select/css/main.css">
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/stkstyle/css/lCalendar.css"/>
		<link rel="stylesheet" href="<%=basePath %>/resource/kendo/style/autocomplete.min.css">
		<script type="text/javascript" src="<%=basePath%>/resource/jquery-1.8.0.min.js"></script>
		<script src="<%=basePath %>/resource/kendo/js/kendo.custom.min.js"></script>
		<script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
		<script src="<%=basePath %>/resource/stkstyle/js/pcinthin.js" type="text/javascript" charset="utf-8"></script>
		<script type="text/javascript" src="<%=basePath %>resource/WdatePicker.js"></script>
		<script type="text/javascript" src="<%=basePath %>/resource/jquery.easyui.min.js"></script>
		<script src="<%=basePath %>/resource/stkstyle/js/pcbasein.js" type="text/javascript" charset="utf-8"></script>
		<script src="<%=basePath %>/resource/select/js/jquery.autocompleter.js"></script>
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/easyui/easyui.css">
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/easyui/icon.css">
	</head>
<script type="text/javascript">
var basePath = '<%=basePath %>';
</script>
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
		
		<div class="center">
			
			<div class="pcl_lib_out">
				<div class="pcl_menu_box">
					<div class="menu_btn">
						<div class="item" id="btnnew">
							<a href="javascript:newClick();">
								<img src="<%=basePath %>/resource/stkstyle/img/nicon7.png"/>
								<img src="<%=basePath %>/resource/stkstyle/img/nicon7a.png"/>
								<p>新建</p>
							</a>
						</div>
						<c:if test="${status eq -2 }">
						<div class="item" id="btndraft">
							<a href="javascript:draftSave();">
								<img src="<%=basePath %>/resource/stkstyle/img/nicon1.png"/>
								<img src="<%=basePath %>/resource/stkstyle/img/nicon1a.png"/>
								<p>暂存</p>
							</a>
						</div>
						<div class="item" id="btndraftaudit" style="display: ${billId eq 0?'none':''}">
							<a href="javascript:audit();">
								<img src="<%=basePath %>/resource/stkstyle/img/nicon2.png"/>
								<img src="<%=basePath %>/resource/stkstyle/img/nicon2a.png"/>
								<p>审批</p>
							</a>
						</div>
						</c:if>
						<c:if test="${permission:checkUserFieldPdm('stk.stkIn.save')}">
						<div class="item" id="btnsave" style="display: ${(status eq -2 or billId eq 0)?'':'none'}">
							<a href="javascript:submitStk();">
								<img src="<%=basePath %>/resource/stkstyle/img/nicon1.png"/>
								<img src="<%=basePath %>/resource/stkstyle/img/nicon1a.png"/>
								<p>保存并审批</p>
							</a>
						</div>
						</c:if>
						<c:if test="${permission:checkUserFieldPdm('stk.stkIn.shouhuo')}">
						  <div class="item" id="btnaudit" style="display: ${(status eq -2 or billId eq 0 or status eq 1)?'none':''}">
							<a href="javascript:auditClick();">
								<img src="<%=basePath %>/resource/stkstyle/img/nicon4.png"/>
								<img src="<%=basePath %>/resource/stkstyle/img/nicon4a.png"/>
								<p>收货</p>
							</a>
						</div>
						</c:if>
						<c:if test="${permission:checkUserFieldPdm('stk.stkIn.cancel')}">
						<div class="item" id="btncancel" style="display: ${(status eq -2 or billId eq 0)?'none':''}">
							<a href="javascript:cancelClick();">
								<img src="<%=basePath %>/resource/stkstyle/img/nicon5.png"/>
								<img src="<%=basePath %>/resource/stkstyle/img/nicon5a.png"/>
								<p>作废</p>
							</a>
						</div>
						</c:if>
						<c:if test="${permission:checkUserFieldPdm('stk.stkIn.print')}">
						<div class="item" id="btnprint" style="display: ${(status eq -2 or billId eq 0)?'none':''}">
							<a href="javascript:printClick();">
								<img src="<%=basePath %>/resource/stkstyle/img/nicon3.png"/>
								<img src="<%=basePath %>/resource/stkstyle/img/nicon3a.png"/>
								<p>打印</p>
							</a>
						</div>
						</c:if>
						<div class="pcl_right_edi" style="width: 400px;">
							<div class="pcl_right_edi_w">
								<div>
								  <input type="text" id="billNo"   style="color:green;width:160px;font-size: 14px" readonly="readonly" value="${billNo}"/>
								  <input type="text" id="billstatus"   style="color:red;width:60px" readonly="readonly" value="${billstatus}"/>
								</div>
							</div>
						</div>
					</div>
				</div>
				<!--<p class="odd_num">单号：</p>-->
				<input  type="hidden" name="billId" id="billId" value="${billId}"/>
				<input  type="hidden" name="stkId" id="stkId" value="${stkId}"/>
				<input  type="hidden" name="stkName" id="stkName" value="${stkName}"/>
				<input  type="hidden" name="proId" id="proId" value="${proId}"/>
				<input  type="hidden" name="proType" id="proType" value="${proType}"/>
				<input  type="hidden" name="status" id="status" value="${status}"/>
				<div class="pcl_fm">
					<table>
						<tbody>
							<tr>
								<td>退货单位：</td>
								<td>
									<div class="pcl_chose_peo"><a href="javascript:;" id="pc_lib" style="padding-right: 30px;">${proName}</a></div>
								</td>
								<td>退货时间：</td>
								<td>
								<div class="pcl_input_box pcl_w2">
									<input name="text" id="inDate"  onClick="WdatePicker({skin:'whyGreen',dateFmt: 'yyyy-MM-dd HH:mm'});" style="width: 100px;" value="${inTime}"  readonly="readonly"/>
								</div>
								</td>
								<td>退货仓库：</td>
								<td>
									<div class="selbox" id="stklist">
										<span id = "stkNamespan">${stkName}</span>
										<select name="" class="pcl_sel" id = "stksel">
											
										</select>
									</div>
								</td>
							</tr>
							<tr  style="display: ${permission:checkUserFieldDisplay('stk.stkIn.lookamt')}">
								<td>合计退货：</td>
								<td ><div class="pcl_input_box pcl_w2"><input type="text" id="totalamt" readonly="readonly" value="${totalamt*(-1)}"/></div></td>
								<td>退货金额：</td>
								<td ><div class="pcl_input_box pcl_w2"><input type="text" id="disamt" readonly="readonly" value="${disamt*(-1)}"/></div></td>
								<td style="display:none">整单折扣：</td>
								<td style="display:none"><div class="pcl_input_box pcl_w2"><input type="text" id="discount" value="${discount}" onchange="countAmt()"/></div></td>
								<td></td>
								<td></td>
							</tr>
							<tr>
								<td valign="top">备注：</td>
								<td colspan="5">
									<div class="pcl_txr">
										<textarea name="" id="remarks">${remarks}</textarea>
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
									<td  style="display: ${permission:checkUserFieldDisplay('stk.stkIn.lookqty')}">退货数量</td>
									<td  style="display: ${permission:checkUserFieldDisplay('stk.stkIn.lookprice')}">退货单价</td>

									<td  style="display: ${permission:checkUserFieldDisplay('stk.stkIn.lookamt')}">退货金额</td>
									<td>生产日期</td>
									<td><a class="easyui-linkbutton" iconCls="icon-add" plain="true"
										   href="javascript:addTabRow(1);">增行</a></td>
								</tr>
							</thead>
							<tbody id="chooselist">

							<c:forEach items="${warelist}" var="item" varStatus="s">
								<tr>
									<td>${s.index+1 }</td>
									<td style="padding-left: 20px;text-align: left;" onkeydown="gjr_toNextRow(this,'edtqty')">
										<input type="hidden" name="wareId" value = "${item.wareId}"/>
										<input type="text" class="pcl_i2" value="${item.wareCode}" readonly="true"/>
									<td>
									<input name="wareNm" id="wareNm${s.index }" type="text" placeholder="输入商品名称、商品代码、商品条码" value="${item.wareNm}" onclick="wareAutoClick(this)" onkeydown="gjr_forAuto_toNextCell(this,'edtqty')" style="width: 200px"/>
									</td>
									<td onkeydown="gjr_toNextRow(this,'edtprice')"><input type="text" class="pcl_i2"
																						  value="${item.wareGg}"
																						  style="width: 80px;" readonly="true"
																						  id="wareGg${s.index}" name="wareGg"/></td>
									<td>
										<select id="beUnit${s.index }" name="beUnit" class="pcl_sel2" onchange="changeUnit(this,${s.index })">
											<option value="${item.maxUnitCode}" ${(item.maxUnitCode eq item.beUnit)?'selected=selected':''}>${item.wareDw}</option>
											<option value="${item.minUnitCode}" ${(item.minUnitCode eq item.beUnit)?'selected=selected':''}>${item.minUnit}</option>
										</select>
									</td>
									<td onkeydown="gjr_toNextRow(this,'edtqty')" style="display: ${permission:checkUserFieldDisplay('stk.stkIn.lookqty')}"><input id="edtqty${s.index}"  name="edtqty" type="text"  onkeydown="gjr_toNextCell(this,'edtprice')" class="pcl_i2" value="${item.qty*(-1)}" onchange="countAmt()"/></td>
									<td  onkeydown="gjr_toNextRow(this,'edtprice')" style="display: ${permission:checkUserFieldDisplay('stk.stkIn.lookprice')}"><input id="edtprice${s.index}" name="edtprice" type="text" onkeydown="gjr_toNextCell(this,'productDate')" class="pcl_i2" value="${item.price}" onchange="countAmt()"/></td>
									<td style="display: ${permission:checkUserFieldDisplay('stk.stkIn.lookamt')}"><input name="amt" type="text" class="pcl_i2" value="${item.amt*(-1)}" onchange="countPrice()"/></td>
									<td style="display:none"><input id="hsNum${s.index }" name="hsNum" type="hidden" class="pcl_i2" value="${item.hsNum}"/></td>
									<td style="display:none"><input id="unitName${s.index }" name="unitName" type="hidden" class="pcl_i2" value="${item.unitName}" /></td>
									<td onkeydown="gjr_toNextRow(this,'wareNm','1','gjrRowOperFun')"><input name="productDate" type="text" class="pcl_i2" style="width: 90px;"  readonly="readonly" value="${item.productDate}" onClick="WdatePicker({skin:'whyGreen',dateFmt:'yyyy-MM-dd'});"/></td>
									<td><a href="javascript:;"onclick="deleteChoose(this);" class="pcl_del">删除</a></td>
								</tr>
							</c:forEach>
							</tbody>
							</tbody>
							<tfoot>
							<tr  align="center">
								<td>合计:</td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td id="edtSumQty" style="display: ${permission:checkUserFieldDisplay('stk.stkIn.lookqty')}">0</td>
								<td style="display: ${permission:checkUserFieldDisplay('stk.stkIn.lookprice')}"></td>
								<td id="edtSumAmt" style="display: ${permission:checkUserFieldDisplay('stk.stkIn.lookamt')}">0.00</td>
								<td></td>
								<td></td>

							</tr>
							</tfoot>
						</table>
					</div>
				</div>
			</div>
		</div>
		<div class="chose_people pcl_chose_people" style="">
			<div class="mask"></div>
			<div class="cp_list2">
				<!--<a href="javascript:;" class="pcl_close_button"><img src="style/img/lightbox-btn-close.jpg"/></a>-->
				<div class="pcl_box_left">
					<div class="cp_src">
						<div class="cp_src_box">
							<img src="<%=basePath %>/resource/stkstyle/img/src_icon2.jpg"/>
							<input type="text" placeholder="模糊查询" id="searchtext"/>
						</div>
						<input type="button" class="cp_btn" value="查询" onclick="queryclick()"/>
						<input type="button" class="cp_btn2 close_btn2" value="取消"/>
					</div>
					<div class="cp_btn_box">
						<a href="javascript:;" class="on">供应商</a><a href="javascript:;">部门</a><a href="javascript:;">客户</a><a href="javascript:;">其它往来单位</a>
					</div>
				</div>
				<div class="pcl_3box">
					<div class="pcl_switch">
						<div class="pcl_3box1">
							<table class="pcl_table">
								<thead>
									<tr>
										<td>供应商</td>
										<td>联系电话</td>
										<td>地址</td>
									</tr>
								</thead>
								<tbody id="provderList">
								
								</tbody>
							</table>
						</div>
					</div>
					<div class="pcl_switch clearfix">
						<div class="pcl_3box2">
							<h2>部门分类树</h2>
							<div class="pcl_l2" id="departTree">
								<a href="#">员工</a>
								<a href="#">员工</a>
								<a href="#">员工</a>
								<div class="pcl_infinite">
									<p><i></i>综合部</p>
									<div class="pcl_file">
										<a href="#">员工</a>
										<a href="#">员工</a>
										<a href="#">员工</a>
										<div class="pcl_infinite">
											<p><i></i>综合部</p>
											<div class="pcl_file">
												<a href="#">员工</a>
												<a href="#">员工</a>
												<a href="#">员工</a>
											</div>
										</div>
									</div>
								</div>
								<div class="pcl_file">
									<div class="pcl_infinite">
										<p><i></i>综合部</p>
										<div class="pcl_file">
											<a href="#">员工</a>
											<a href="#">员工</a>
											<a href="#">员工</a>
										</div>
									</div>
								</div>
							</div>
						</div>
						
						<div class="pcl_rf_box">
							<table class="pcl_table" >
								<thead>
									<tr>
										<td>姓名</td>
										<td>职位</td>
									</tr>
								</thead>
								<tbody id="memberList">
									
								</tbody>
							</table>
						</div>
					</div>
					<div class="pcl_switch">
						<div class="pcl_3box1">
							<table class="pcl_table">
								<thead>
									<tr>
										<td>客户名称</td>
										<td>联系电话</td>
										<td>地址</td>
									</tr>
								</thead>
								<tbody id="customerlist">
									
								</tbody>
							</table>
						</div>
					</div>
					<div class="pcl_switch">
						<div class="pcl_3box1">
							<table class="pcl_table">
								<thead>
									<tr>
										<td>往来单位</td>
										<td>联系电话</td>
										<td>地址</td>
									</tr>
								</thead>
								<tbody id="unitList">
									
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
	</body>
	<div id="wareDlg" closed="true" class="easyui-dialog" style="width:500px; height:200px;" title="商品选择" iconCls="icon-edit"/>
	<script src="<%=basePath %>/resource/stkstyle/js/lCalendar.js" type="text/javascript" charset="utf-8"></script>
	<script type="text/javascript">
		$("#stksel").change(function(){
			var index = this.selectedIndex;
		    var stkId = this.options[index].value;
		    $("#stkId").val(stkId);
			var this_val = this.options[index].text;
			$(this).siblings('span').text(this_val);
		});
		
		$("#intypesel").change(function(){
			var index = this.selectedIndex;
		    var selObj = this.options[index].value;
			var this_val = this.options[index].text;
			$(this).siblings('span').text(this_val);
		});
		
		function showWare(){
	    	$('#dlg').dialog('open');
		 }
		 function dialogSelectWare(){
			 oneRowSelect=0;
			   var  stkId = $("#stkId").val();
				if(stkId == ""){
					alert("请选择仓库!");
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
		 
		 function callBackFun(json){
				var size = json.list.length;
				if(size>0){
					for(var i=0;i<size;i++){
						setTabRowData(json.list[i]);
					}
				}
			}

		/**********************设置商品下拉开始**********************/
		var curr_row_index = -1;
		function callBackFun(json){
			var size = json.list.length;
			if(size>0){
				if(oneRowSelect==1&&size>1){
					alert("行中选择商品时，只能选择一个");
					return;
				}
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
					if(oneRowSelect==1&&i==0){
						var row = setTabRowData(data);
						$(row).find("input[name='wareNm']").focus();
						//curr_row_index=row.rowIndex;
						//2. todo
						break;
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
			var len = $("#chooselist").find("tr").length;
			$("#more_list tbody").append(
					'<tr>'+
					'<td class="index">'+(len+1)+'</td>'+
					'<td style="padding-left: 20px;text-align: left;">'+
					'<input type="hidden" name="wareId"/><input type="text" class="pcl_i2" readonly="true"  name="wareCode"/></td>'+
					'<td id="autoCompleterTr'+rowIndex+'"><input name="wareNm"  type="text" placeholder="输入商品名称、商品代码、商品条码" onclick="wareAutoClick(this)" onkeydown="gjr_forAuto_toNextCell(this,\'edtqty\')" style="width: 200px"/>'+selectImg+'</td>'+
					'<td><input type="text" class="pcl_i2" readonly="true"  name="wareGg" style="width: 90px;"/></td>'+
					'<td onkeydown="gjr_toNextRow(this,\'edtqty\')">' +
					'<select id="beUnit'+rowIndex+'" name="beUnit" class="pcl_sel2" onchange="changeUnit(this,'+rowIndex+')">'+
					'</select>'
					+ '</td>'+
					'<td onkeydown="gjr_toNextRow(this,\'edtqty\')" style="display:'+qtyDisplay+'"><input id="edtqty'+rowIndex+'"  name="edtqty" type="text" onkeydown="gjr_toNextCell(this,\'edtprice\')" class="pcl_i2" value="1" onchange="countAmt()"/></td>'+
					'<td onkeydown="gjr_toNextRow(this,\'edtprice\')" style="display:'+priceDisplay+'"><input id="edtprice'+rowIndex+'" name="edtprice" type="text" onkeydown="gjr_toNextCell(this,\'productDate\')" class="pcl_i2"  onchange="countAmt()"/></td>'+
					'<td style="display:'+amtDisplay+'"><input  name="amt" type="text" class="pcl_i2"  onchange="countPrice()"/></td>'+
					'<td style="display:none"><input id="hsNum'+rowIndex+'" name="hsNum" type="hidden" class="pcl_i2" /></td>'+
					'<td style="display:none"><input id="unitName'+rowIndex+'"  name="unitName" type="hidden" class="pcl_i2"  /></td>'+
					'<td onkeydown="gjr_toNextRow(this,\'wareNm\',\'1\',\'gjrRowOperFun\')"><input name="productDate"  class="pcl_i2"  onClick="WdatePicker({skin:\'whyGreen\',dateFmt: \'yyyy-MM-dd\'});" style="width: 90px;"  readonly="readonly" value="'  + '"/></td>'+
					'<td><a href="javascript:;"onclick="deleteChoose(this);" class="pcl_del">删除</a></td>'+
					'</tr>'
			);
			var row = $("#more_list tbody tr").eq(len);;
			$(row).find("input[name='wareNm']").attr("id", "wareNm" + rowIndex);
			setKendoAutoComplete($(row).find("input[name='wareNm']").attr("id"));
			curr_row_index = row.rowIndex;
			$(row).find("input[name='wareNm']").focus();
			//3.  todo
			rowIndex++;
			return row;
		}
		function setRowData(row,json){
			$(row).find("input[name='wareId']").val(json.wareId);
			$(row).find("input[name='wareCode']").val(json.wareCode);
			$(row).find("input[name='wareNm']").val(json.wareNm);
			$(row).find("input[name='wareGg']").val(json.wareGg);
			$(row).find("input[name='edtprice']").val(json.price);
			$(row).find("input[name='hsNum']").val(json.hsNum);
			$(row).find("input[name='productDate']").val(json.productDate);
			var size = $(row).find("select[name='beUnit'] option").size();
			if (size == 0) {
				$(row).find("select[name='beUnit']").append("<option value='" + json.maxUnitCode + "'>" + json.maxNm + "</option>");
				$(row).find("select[name='beUnit']").append("<option value='" + json.minUnitCode + "'>" + json.minNm + "</option>");
			}
			$(row).find("input[name='unitName']").val(json.maxNm);
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

			return row;
			//4. todo
		}

		function clearTabRowData(json) {
			var index = curr_row_index - 1;
			var row = $("#more_list tbody tr").eq(index);
			$(row).find("input[name='wareId']").val("");
			$(row).find("input[name='wareCode']").val("");
			$(row).find("input[name='wareNm']").val("");
			$(row).find("input[name='wareGg']").val("");
			$(row).find("input[name='edtprice']").val("");
			$(row).find("input[name='hsNum']").val("");
			$(row).find("select[name='beUnit']").empty();
			$(row).find("input[name='unitName']").val("");
			countAmt();
		}

        function countSum(){
            var sumQty = 0;
            var sumAmt = 0;
            $("#more_list #chooselist input[name='edtqty']").each(function(){
                sumQty +=parseFloat($(this).val());
            });
            $("#more_list #chooselist input[name='amt']").each(function(){
                sumAmt +=parseFloat($(this).val());
            });
            $("#edtSumQty").html(parseFloat(sumQty.toFixed(2)));
            $("#edtSumAmt").html(parseFloat(sumAmt.toFixed(2)));
        }
		if(${billId}==0){
			addTabRow(1);
		}
		if(${billId}!=0){
			countSum();
			$("#more_list #chooselist input[name='wareNm']").each(function(){
				setKendoAutoComplete($(this).attr("id"));
			});
		}
	</script>
	<%@include file="/WEB-INF/page/include/handleFile.jsp"%>
</html>