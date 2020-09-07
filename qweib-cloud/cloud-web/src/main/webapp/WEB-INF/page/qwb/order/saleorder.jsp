<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="tag" tagdir="/WEB-INF/tags"%>
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
		<title>销售订单</title>
		<meta name="description" content="">
		<meta name="keywords" content="">
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/stkstyle/css/style.css"/>		
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/stkstyle/css/lCalendar.css"/>
		<!-- <script src="<%=basePath %>/resource/stkstyle/js/jquery-2.1.0.min.js" type="text/javascript" charset="utf-8"></script> -->
		<script type="text/javascript" src="<%=basePath %>/resource/jquery-1.8.0.min.js"></script>
		<script type="text/javascript" src="<%=basePath %>/resource/login/js/jquery-ui.min.js"></script>
		<script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
		<script src="<%=basePath %>/resource/stkstyle/js/saleorder.js" type="text/javascript" charset="utf-8"></script>
		<script type="text/javascript" src="<%=basePath %>resource/WdatePicker.js"></script>
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/themes/default/easyui.css">
		<script type="text/javascript" src="<%=basePath %>/resource/jquery.easyui.min.js"></script>
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/themes/icon.css">
		<style>
   		 	tr{cursor: pointer;}
		</style>
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
							<a href="javascript:addorder();">
								<img src="<%=basePath %>/resource/stkstyle/img/nicon1.png"/>
								<img src="<%=basePath %>/resource/stkstyle/img/nicon1a.png"/>
								<p>新建</p>
							</a>
						</div>
						<div class="item" id="btnsave">
							<a href="javascript:submitStk();">
								<img src="<%=basePath %>/resource/stkstyle/img/nicon6.png"/>
								<img src="<%=basePath %>/resource/stkstyle/img/nicon6a.png"/>
								<p>保存</p>
							</a>
						</div>
						<%--
						<div class="item" id="btnprint">
							<a href="javascript:printClick();">
								<img src="<%=basePath %>/resource/stkstyle/img/nicon8.png"/>
								<img src="<%=basePath %>/resource/stkstyle/img/nicon8a.png"/>
								<p>打印</p>
							</a>
						</div>
						 --%>
						<div class="pcl_right_edi" style="width: 400px;">
							<div class="pcl_right_edi_w">
								 <input type="text" id="orderNo"   style="color:green;width:160px;font-size: 14px" readonly="readonly" value="${bforder.orderNo}"/>
								<font style="color: green" id="divOrderStatus">
									${bforder.orderZt }
								</font>
							</div>
						</div>
					</div>
				</div>
				<input  type="hidden" name="id" id="id" value="${bforder.id}"/>
				<input  type="hidden" name="pszd" id="pszd" value="${bforder.pszd}"/>
				<input  type="hidden" name="proType" id="proType" value="${bforder.proType}"/>
				<input  type="hidden" name="orderZt" id="orderZt" value="${bforder.orderZt}"/>
				<input  type="hidden" name="orderTp" id="orderTp" value="${bforder.orderTp}"/>
				<input  type="hidden" name="orderLb" id="orderLb" value="${bforder.orderLb}"/>
				<input  type="hidden" name="shopMemberId" id="shopMemberId" value="${bforder.shopMemberId}"/>
				<input  type="hidden" name="shopMemberName" id="shopMemberName" value="${bforder.shopMemberName}"/>
				<input  type="hidden" name="status" id="status" value="${bforder.status}"/>
				<input  type="hidden" name="isPay" id="isPay" value="${bforder.isPay}"/>
				<input  type="hidden" name="payType" id="payType" value="${bforder.payType}"/>

				<input  type="hidden" name="isSend" id="isSend" value="${bforder.isSend}"/>
				<input  type="hidden" name="isFinish" id="isFinish" value="${bforder.isFinish}"/>
				<input  type="hidden" name="payTime" id="payTime" value="${bforder.payTime}"/>
				<input  type="hidden" name="transportName" id="transportName" value="${bforder.transportName}"/>
				<input  type="hidden" name="finishTime" id="finishTime" value="${bforder.finishTime}"/>
				<input  type="hidden" name="cancelTime" id="cancelTime" value="${bforder.cancelTime}"/>
				<input  type="hidden" name="cancelRemo" id="cancelRemo" value="${bforder.cancelRemo}"/>
				<input  type="hidden" name="transportCode" id="transportCode" value="${bforder.transportCode}"/>
				<input  type="hidden" name="couponCost" id="couponCost" value="${bforder.couponCost}"/>


				<div class="pcl_fm">
					<table>
						<tbody>
							<tr>
								<td>客户名称：</td>
								<td>
									<div class="pcl_chose_peo"><a href="javascript:;" id="pc_lib" style="padding-right: 30px;">${bforder.khNm}</a></div>
									<input type="hidden" id="cid" value="${bforder.cid}"/>
								</td>
								<td>送货日期：</td>
								<td>
								<div class="pcl_input_box pcl_w2">
									<input name="text" id="shTime"  onClick="WdatePicker({skin:'whyGreen',dateFmt: 'yyyy-MM-dd HH:mm:ss'});" style="width: 120px;" value="${bforder.shTime}"  readonly="readonly"/>
								</div>
								</td>
								<td>订单日期：</td>
								<td ><div class="pcl_input_box pcl_w2"><input name="oddate" type="text" id="oddate"  style="width: 120px;" value="${bforder.oddate}"  readonly="readonly"/>
								<input type="hidden" name="odtime" id="odtime"  style="width: 120px;" value="${bforder.odtime}"  />
								</div></td>
							</tr>
							<tr>
								<td>收货人：</td>
								<td ><div class="pcl_input_box pcl_w2"><input type="text" name="shr" id="shr" value="${bforder.shr }"/></div></td>
								<td>客户地址：</td>
								<td ><div class="pcl_input_box pcl_w2"><input type="text" id="address" value="${bforder.address }"/></div></td>
								<td>联系电话：</td>
								<td><div class="pcl_input_box pcl_w2"><input type="text" id="tel" value="${bforder.tel}"/></div></td>
							</tr>
							<tr>
								<td>配送指定：</td>
								<td>
								<table>
									<tr>
										<td width="60px">
											<div class="selbox" style="width: 60px">
											<span id="pszdspan">${bforder.pszd}</span> 
											 <select name="" class="pcl_sel" id="pszdsel">
												<option value="公司直送">公司直送</option>
												<option value="转二批配送">转二批配送</option>
											</select>
										     </div>
									     </td>
										<td>
										</td>
									</tr>
								</table>
								</td>
								<td>业  务  员：</td>
								<td >
								<div class="pcl_chose_peo" >
									<a href="javascript:;" id="memberNm" style="padding-right: 30px;">${bforder.memberNm}</a>
								</div>
								<input type="hidden" id="mid" name="mid" value="${bforder.mid}"/>
								</td>
								<td>
								 仓库：
								</td>
								<td><div class="selbox">
								<span id="stkNamespan">${bforder.stkName}</span>
								<tag:select name="stkId" id="stkId" tclass="pcl_sel"  value="${bforder.stkId }" tableName="stk_storage"
											whereBlock="status=1 or status is null"
											displayKey="id" displayValue="stk_name"/>
								</div>
								</td>
							</tr>
							<tr>
									<td>
								商品总价：
								</td>
								<td>
								<div class="pcl_input_box pcl_w2"><input type="text" id="zje" value="${bforder.zje}" readonly="readonly"/></div>
								</td>
								<td>
								整单折扣：
								</td>
								<td>
								<div class="pcl_input_box pcl_w2"><input type="text" id="zdzk" value="${bforder.zdzk}" onchange="countAmt()"/></div>
								</td>
								<td>
								商品净收入总额：
								</td>
								<td>
								<div class="pcl_input_box pcl_w2"><input type="text" id="cjje" value="${bforder.cjje}" readonly="readonly"/></div>
								</td>
								
							</tr>
							<tr>
								<td>
									促销总额：
								</td>
								<td>
									<div class="pcl_input_box pcl_w2"><input type="text" id="promotionCost" value="${bforder.promotionCost}" readonly="readonly"/></div>
								</td>
								<td>
									运费：
								</td>
								<td>
									<div class="pcl_input_box pcl_w2"><input type="text" id="freight" value="${bforder.freight}" readonly="readonly"/></div>
								</td>
								<td>
									订单实付：
								</td>
								<td>
									<div class="pcl_input_box pcl_w2"><input type="text" id="orderAmount" value="${bforder.orderAmount}" readonly="readonly"/></div>
								</td>

							</tr>
							<tr>
								<td valign="top">备注：</td>
								<td colspan="5">
									<div class="pcl_txr">
										<textarea name="" id="remo">${bforder.remo}</textarea>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div id="tb" style="padding:5px;height:auto">
				<table>
				<tr>
				<td><a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:showWare();">添加商品</a></td>
				<td id="tipPrice" style="font-size: 12px;display: none">
					历史价：<span id="hisPrice"></span>
					执行价：<span id="zxPrice"></span>
					商品价：<span id="orgPrice"></span>
				</td>
				</tr>
				</table>
				
				</div>
				<div class="pcl_ttbox1 clearfix">
					<div class="pcl_lfbox1">
						<table id="more_list">
							<thead>
								<tr>
									<td style="display: none">产品编号</td>
									<td>产品名称</td>
									<td>产品规格</td>
									<td>销售类型</td>
									<td>单位</td>
									<td>单价</td>
									<td>订单数量</td>
									<td>订单金额</td>
									<td>备注</td>
									<td>操作</td>
								</tr>
							</thead>
							<tbody id="chooselist">
								<c:forEach items="${warelist}" var="item" varStatus="s">
  								<tr>
									<input type="hidden" name="id" value="${item.id}">
									<input type="hidden" name="detailWareNm" value="${item.detailWareNm}">
									<input type="hidden" name="detailWareGg" value="${item.detailWareGg}">
									<input type="hidden" name="detailShopWareAlias" value="${item.detailShopWareAlias}">
									<input type="hidden" name="detailWareDesc" value="${item.detailWareDesc}">
									<input type="hidden" name="wareDjFinal" value="${item.wareDjFinal}">
									<input type="hidden" name="detailPromotionCost" value="${item.detailPromotionCost}">
									<input type="hidden" name="detailCouponCost" value="${item.detailCouponCost}">


								<td style="padding-left: 20px;text-align: left;display: none"><img src="<%=basePath %>/resource/stkstyle/img/icon19.jpg" class="pcl_ic"/>
								<input type="hidden" name="wareId" value = "${item.wareId}"/></td>
								<td>${item.wareNm}</td>
								<td>${item.wareGg}</td>
								<%--	<td>${item.detailWareGg}</td>--%>
								<td>
								<select id="xstpType${s.index}"  name="xstp" class="pcl_sel2" onchange="chooseXsTp(this)">
								<option value="正常销售">正常销售</option>
								<option value="促销折让">促销折让</option>
								<option value="消费折让">消费折让</option>
								<option value="费用折让">费用折让</option>
								<option value="其他销售">其他销售</option>
								</select>
								<script type="text/javascript">
										document.getElementById("xstpType${s.index}").value='${item.xsTp}';
								</script>
								</td>
								<td>
									<select id="beUnit${s.index }" name="beUnit" class="pcl_sel2" onchange="changeUnit(this,${s.index })">
										<option value="${item.maxUnitCode }"> ${item.wareDw}</option>
										<option value="${item.minUnitCode }"> ${item.minUnit}</option>
									</select>
									<script type="text/javascript">
										document.getElementById("beUnit${s.index}").value='${item.beUnit}';
									</script>
								 </td>
								<td><input id="edtprice${s.index}" name="edtprice${s.index}" type="text" class="pcl_i2" value="${item.wareDj}" onchange="countAmt()"/></td>
								<td><input id="edtqty${s.index}" name="edtqty${s.index}" type="text" class="pcl_i2" value="${item.wareNum}" onchange="countAmt()"/></td>
								<td>${item.wareZj}</td>
								<td style="display:none"><input id="hsNum${s.index }" name="hsNum" type="hidden" class="pcl_i2" value="${item.hsNum}"/></td>
								<td style="display:none"><input id="unitName${s.index }" name="unitName" type="hidden" class="pcl_i2" value="${item.wareDw2}" /></td>
								<td><input id="remark${s.index }" name="remark" class="pcl_i2" value="${item.remark}" title="${item.remark}"/></td>
								<td><a href="javascript:;"onclick="deleteChoose(this);" class="pcl_del">删除</a></td>
								</tr>
 								</c:forEach>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
		<div class="chose_people pcl_chose_people" style="" id = "customerForm">
			<div class="mask"></div>
			<div class="cp_list">
			<a href="javascript:;" class="pcl_close_button"><img src="<%=basePath %>/resource/stkstyle/img/lightbox-btn-close.jpg"/></a>
				<div class="cp_src">
					<div class="cp_src_box">
						<img src="<%=basePath %>/resource/stkstyle/img/src_icon2.jpg"/>
						<input type="text" placeholder="搜索" id="searchcst" value="" onkeyup ="querycustomer(this.value)"/>
					</div>
					<input type="button" class="cp_btn" value="查询" onclick="searchCustomer();"/>
				</div>
				<div style="height: 400px;overflow: auto;text-align: center">
				<table id="customerlist">
					
				</table>
				<span id="customerLoadData" style="text-align: center;float:center;"><a href="javascript:;;" onclick="querycustomerPage()" style="color: red">加载更多</a></span>
				</div>
			</div>
		</div>
		<div class="chose_people pcl_chose_people" style="" id = "orderForm">
			<div class="mask"></div>
			<div class="cp_list">
			<a href="javascript:;" class="pcl_close_button"><img src="<%=basePath %>/resource/stkstyle/img/lightbox-btn-close.jpg"/></a>
				<div class="cp_src">	
					<table border="0" cellspacing="0" cellpadding="0" frame=void rules=none>
					<td style="border:0">开始:</td>
					<td style="border:0"><div class="pcl_input_box">
					<input name="text" id="startDate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}"  readonly="readonly"/>
					</div>
					</td>
					<td style="border:0">截至:</td>
					<td style="border:0"><div class="pcl_input_box">
					<input name="text" id="endDate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}"  readonly="readonly"/>
					</div>
					</td>
					<td colspan = "2" style="border:0">
					<div class="pcl_input_box">
						<input type="text" placeholder="客户名称搜索" id="ordersearch" value="" style=" width: 100%；"/>
					</div>
					</td>
					<td align="left" style="border:0">
					<input type="button" class="cp_btn" value="查询" onclick="queryOrder();"/>
					</td>
					</table>
					
				</div>
				<table id="orderList">
					
				</table>
			</div>
		</div>
		
		
		<div class="chose_people pcl_chose_people" style="" id="memberForm">
			<div class="mask"></div>
			<div class="cp_list2">
				<!--<a href="javascript:;" class="pcl_close_button"><img src="style/img/lightbox-btn-close.jpg"/></a>-->
				<div class="pcl_box_left">
					<div class="cp_src">
						<div class="cp_src_box">
							<img src="<%=basePath %>/resource/stkstyle/img/src_icon2.jpg"/>
							<input type="text" placeholder="模糊查询"/>
						</div>
						<input type="button" class="cp_btn" value="查询"/>
						<input type="button" class="cp_btn2 close_btn2" value="取消"/>
					</div>					
				</div>
				<div class="pcl_3box" id="memdiv">
					
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
										<td>电话</td>
									</tr>
								</thead>
								<tbody id="memberList">
									<tr>
										<td>客户1</td>
										<td>人事经理</td>
									</tr>
									<tr>
										<td>客户1</td>
										<td>人事经理</td>
									</tr>
									<tr>
										<td>客户1</td>
										<td>人事经理</td>
									</tr>
									
									<tr>
										<td>客户1</td>
										<td>人事经理</td>
									</tr><tr>
										<td>客户1</td>
										<td>人事经理</td>
									</tr>
									<tr>
										<td>客户1</td>
										<td>人事经理</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					
				</div>
				
			</div>
		</div>	
		
	</body>
	
	<div id="dlg" closed="true" class="easyui-dialog" title="商品信息" style="width:600px;height:400px;padding:10px"
			data-options="
				iconCls: 'icon-save',
				
				buttons: [{
					text:'确定',
					iconCls:'icon-ok',
					handler:function(){
						confirmWareSelect();
						$('#dlg').dialog('close');
					}
				},{
					text:'取消',
					handler:function(){
						$('#dlg').dialog('close');
					}
				}]
			">
		<div class="pcl_rfbox clearfix">
						<div class="pcl_rt">
							<input type="text" class="pcl_ip" style="font-size: 11px" placeholder="请输入名称、编码、助记码查询" id="wareInput" onkeydown ="queryWareByKeyWord(this.value)" />&nbsp;&nbsp;<input type="button" style="font-size: 12px" value="查询" onclick="queryWareByKeyWord($('#wareInput').val())"/>
						</div>
						<div class="pcl_rttb1 tb fl" id="wareTypeTree">
							<table>
								<thead>
									<tr>
										<td>商品类别</td>
										
									</tr>
								</thead>
								
							</table>
							<div class="infinite">
								
							</div>
							
							
						</div>
						<div class="pcl_rttb2 tb fr">
							<table id="waretable">
								<thead>
									<tr>
										<td><input type="checkbox" id="checkAllBox" onclick="chkbox(this)" name="checkAllBox"/></td>
										<td>商品编号</td>
										<td>名称</td>
										<td>价格</td>
										<td>库存量</td>
									</tr>
								</thead>
								<tbody id="warelist">
									
								</tbody>
							</table>
						</div>
					</div>
		
		</div>
	
	<script src="<%=basePath %>/resource/stkstyle/js/lCalendar.js" type="text/javascript" charset="utf-8"></script>
	<script type="text/javascript">
		$("#pszdsel").change(function(){
			var index = this.selectedIndex;
		    var selObj = this.options[index].value;
		    $("#pszd").val(selObj);
		    //alert(selObj);
			var this_val = this.options[index].text;
			$(this).siblings('span').text(this_val);
			/*
			if(selObj=="公司直送"){
				$("#epCustomerDiv").hide();
				$("#epCustomerId").val("");
				$("#epCustomerName").val("");
			}else{
				$("#epCustomerDiv").show();
			}*/
		});
		
		$(".pcl_close_button").click(function(){
			$(this).parents('.chose_people').hide();
		});
		
		 function showWare(){
		    
			 var cid = $("#cid").val();
			 if(cid==""){
				 alert("请先选择客户!");
				 return;
			 }
		    	$('#dlg').dialog('open');
		    	 queryWareType(cid);
			 }
		
		 /*
		 if("${pszd}"=="直供转单二批"){
			 $("#epCustomerDiv").show();
		 }*/
		 
		 function querySaleCustomerHisWarePrice(wareId)
		 {
		 	var path = "queryOrderSaleCustomerHisWarePrice";
		 	var cid = $("#cid").val();
		 	if(cid==""){
		 		return;
		 	}
		 	$.ajax({
		         url: path,
		         type: "POST",
		         data : {"cid":cid,"wareId":wareId},
		         dataType: 'json',
		         async : false,
		         success: function (json) {
		         	if(json.state){
		         		$("#hisPrice").text(json.hisPrice);
		         		$("#zxPrice").text(json.zxPrice);
		         		$("#orgPrice").text(json.orgPrice);
		         	}
		         }
		     });
		 	
		 }
		function addorder(){
			window.location.href='addorder';
		}
		var stkName =  $("#stkId").find("option:selected").text();
		$("#stkNamespan").html(stkName);
		
	</script>
</html>