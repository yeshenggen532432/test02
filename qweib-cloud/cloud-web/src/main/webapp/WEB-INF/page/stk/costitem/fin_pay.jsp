<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
		<title>费用报销付款凭证</title>
		<meta name="description" content="">
		<meta name="keywords" content="">
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/stkstyle/css/style.css"/>		
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/stkstyle/css/lCalendar.css"/>
		<script type="text/javascript" src="<%=basePath %>/resource/jquery-1.8.0.min.js"></script>
		<script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
		<script src="<%=basePath %>/resource/stkstyle/js/fin_pay.js" type="text/javascript" charset="utf-8"></script>
		<script type="text/javascript" src="<%=basePath %>/resource/jquery.easyui.min.js"></script>
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/easyui/easyui.css">
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/easyui/icon.css">
		<script type="text/javascript" src="<%=basePath %>resource/WdatePicker.js"></script>
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
				<p class="pcl_title">费用报销付款凭证单-${billNo}</p>
				<div class="pcl_menu_box">
					<div class="menu_btn">
						<div class="item" id="btnnew">
							<a href="javascript:newClick();">
								<img src="<%=basePath %>/resource/stkstyle/img/nicon1.png"/>
								<img src="<%=basePath %>/resource/stkstyle/img/nicon1a.png"/>
								<p>新建</p>
							</a>
						</div>
						<c:if test="${status eq 0 }">
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
						<div class="item" id="btnsave" style="display:${(status eq 0 and billId eq 0)?'':'none'}">
							<a href="javascript:saveAudit();">
								<img src="<%=basePath %>/resource/stkstyle/img/nicon1.png"/>
								<img src="<%=basePath %>/resource/stkstyle/img/nicon1a.png"/>
								<p>保存并审批</p>
							</a>
						</div>	
						
						
						<div class="pcl_right_edi">
							<div class="pcl_right_edi_w">
								<div>
									<input type="text" id="billstatus"   style="color:red;width:10 0px" readonly="readonly" value="${billstatus}"/>
								</div>
							</div>
							
						</div>
						
					</div>
					
				</div>
				
				<!--<p class="odd_num">单号：</p>-->
				<input  type="hidden" name="billId" id="billId" value="${billId}"/>
				
				<input  type="hidden" name="proId" id="proId" value="${proId}"/>
				<input  type="hidden" name="proType" id="proType" value="${proType}"/>
				<input  type="hidden" name="status" id="status" value="${status}"/>
				<input  type="hidden" name="depId" id="depId" value="${depId}"/>
				<input  type="hidden" name="costBillId" id="costBillId" value="${costBillId}"/>
				
				<input  type="hidden" name="accId" id="accId" value="${accId}"/>
				<div class="pcl_fm">
					<table>
						<tbody>
							<tr>
							<td>原单号：</td>
								<td id="pc_order11">
									<div class="pcl_chose_peo" >
										<a href="javascript:;" id="pc_order" style="padding-right: 30px;">${costNo}</a>
									</div>
								</td>
								<td>付款对象：</td>
								<td>
									<div class="pcl_chose_peo"><a href="javascript:;" id="pc_lib" style="padding-right: 30px;">${proName}</a></div>
								</td>
								<td>付款时间：</td>
								<td>
								<div class="pcl_input_box pcl_w2">
									<input name="text" id="inDate"  onClick="WdatePicker({skin:'whyGreen',dateFmt: 'yyyy-MM-dd HH:mm'});" style="width: 100px;" value="${payTimeStr}"  readonly="readonly"/>
								</div>
								</td>
								
								
							</tr>
							<tr>
							<td>分期摊销：</td>
								<td ><div class="pcl_input_box"><input type="text" id="costTerm"  value="${costTerm}"/></div></td>
							
							<td>付款金额：</td>
								<td ><div class="pcl_input_box"><input type="text" id="payAmt" readonly="readonly" value="${payAmt}"/></div></td>
							
							<td>
							付款账户：
							</td>
							<td>
							<div class="selbox" id="stklist">
										<span id="spAccount">${accName}</span>
										<select name="" class="pcl_sel" id = "payAccount">
											
										</select>
									</div>
							
							
							</td>
							</tr>
							<tr>
								<td valign="top">备注：</td>
								<td colspan="5">
									<div class="pcl_txr">
										<textarea name="" id="remarks" >${remarks}</textarea>
									</div>
								</td>
							</tr>
							
						</tbody>
					</table>
				</div>
				
				<div class="pcl_ttbox clearfix">
					<div class="pcl_lfbox">
						<table id="more_list">
							<thead>
								<tr>
								<td>费用科目</td>
									<td>费用明细科目</td>
									<td>付款金额</td>
									<td>备注</td>
									<td>操作</td>
								</tr>
							</thead>
							<tbody id="chooselist">
							<c:forEach items="${sublist}" var="item" varStatus="s">
								<tr>
									<td style="padding-left: 20px;text-align: left;">
										<img src="<%=basePath %>/resource/stkstyle/img/icon19.jpg"class="pcl_ic"/>
										<input type="hidden" name="id" id="costId${s.index}" value = "${item.costId}"/>
										<span id="typeName${s.index}">${item.typeName}</span>
									</td><td><span id="itemName${s.index}">${item.itemName}</span>&nbsp;

									<c:if test="${empty costNo}">
										<a href="javascript:;;" onclick="javascript:dialogCostType(${s.index})" style="color: #00a6fb">选择</a>
									</c:if>
									</td>
									<td><input name="amt" type="text" class="pcl_i2" value="${item.amt}" onchange="countAmt()"/></td>
									<td><input name="remarks" type="text" class="pcl_i2" value="${item.remarks}"/></td>
									<td><a href="javascript:;"onclick="deleteChoose(this);" class="pcl_del">删除</a></td>
								</tr>
							</c:forEach>
							</tbody>
						</table>
					</div>
					<div class="pcl_rfbox clearfix">
						
						<div class="pcl_rttb1 tb fl" id="wareTypeTree">
							<table>
								<thead>
									<tr>
										<td>费用科目</td>
										
									</tr>
								</thead>
								
							</table>
							<div class="infinite">
								<div class="pcl_menu_m">
									<p>一级分类</p>
									<div class="pcl_sub_menu">
										<a href="#">分类2</a>
										<a href="#">分类2</a>
										<a href="#">分类2</a>
										<div class="pcl_menu_m">
											<p>一级分类</p>
											<div class="pcl_sub_menu">
												<a href="#">分类2</a>
												<a href="#">分类2</a>
												<a href="#">分类2</a>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="infinite">
								<div class="pcl_menu_m">
									<p>一级分类</p>
									<div class="pcl_sub_menu">
										<a href="#">分类2</a>
										<a href="#">分类2</a>
										<a href="#">分类2</a>
									</div>
								</div>
							</div>
							<div class="infinite">
								<div class="pcl_menu_m">
									<div class="pcl_sub_menu" style="display: block; padding-left: 0;">
										<a href="#">分类2</a>
									</div>
								</div>
							</div>
						</div>
						<div class="pcl_rttb2 tb fr">
							<table id="waretable">
								<thead>
									<tr>
										<td>明细科目名称</td>
										<td>备注</td>
										
									</tr>
								</thead>
								<tbody id="warelist">
									<tr ondblclick="waredbclick(this)">
										<td style="padding-left: 20px;text-align: left;"><img src="<%=basePath %>/resource/stkstyle/img/icon19.jpg" class="pcl_ic" name = "warecode"/><input type="hidden" name="wareId" value = "1"/>asd1</td>
										<td><input type="hidden" name="wareUnit" value = "个"/>asd2</td>
										<td>asd3</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="chose_people pcl_chose_people" style="" id="empselect">
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
						<div style="height: 400px;overflow: auto;text-align: center">
							<table class="pcl_table">
								<thead>
									<tr>
										<td>供应商</td>
										<td>联系电话</td>
										<td>地址</td>
									</tr>
								</thead>
								<tbody id="provderList">
									<tr>
										<td>客户1</td>
										<td>14577886611</td>
										<td>福建省厦门市集美区沈海高速</td>
									</tr>

								</tbody>
							</table>
							</div>
						</div>
					</div>
					<div class="pcl_switch clearfix">
						<div class="pcl_3box2" style="height: 350px;overflow: auto;">
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
						<div style="height: 400px;overflow: auto;text-align: center">
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
					</div>
					<div class="pcl_switch">
						<div class="pcl_3box1">
						<div style="height: 400px;overflow: auto;text-align: center">
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
							<span id="customerLoadData" style="text-align: center;float:center;"><a href="javascript:;;" onclick="querycustomerPage()" style="color: red">加载更多</a></span>
							</div>
						</div>
					</div>
						<div class="pcl_switch">
						<div class="pcl_3box1">
						<div style="height: 400px;overflow: auto;text-align: center">
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
							<span id="customerLoadData" style="text-align: center;float:center;"><a href="javascript:;;" onclick="queryFinUnitPage()" style="color: red">加载更多</a></span>
							</div>
						</div>
					</div>
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
						<input type="text" placeholder="申请名称搜索" id="ordersearch" value="" style=" width: 100%；"/>
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
		<div id="costTypeDlg" closed="true" class="easyui-dialog" style="width:500px; height:200px;" title="费用科目选择" iconCls="icon-edit">
		</div>

	</body>
	
	
	
	<script src="<%=basePath %>/resource/stkstyle/js/lCalendar.js" type="text/javascript" charset="utf-8"></script>
	<script type="text/javascript">
		$("#payAccount").change(function(){
			var index = this.selectedIndex;
		    var accId = this.options[index].value;
		    $("#accId").val(accId);
			var this_val = this.options[index].text;
			$(this).siblings('span').text(this_val);
			isModify = false;
		});
		
		$("#intypesel").change(function(){
			var index = this.selectedIndex;
		    var selObj = this.options[index].value;
		    //$("#pszd").val(selObj);
		    //alert(selObj);
			var this_val = this.options[index].text;
			$(this).siblings('span').text(this_val);
			isModify = false;
		});
		
		$(".pcl_close_button").click(function(){
			$(this).parents('.chose_people').hide();
		});

		var subIndex = -1;
		function dialogCostType(index){
			subIndex = index;
			$('#costTypeDlg').dialog({
				title: '选择费用科目',
				iconCls:"icon-edit",
				width: 800,
				height: 400,
				modal: true,
				href: "<%=basePath %>/manager/toDialogCostType",
				onClose: function(){
				}
			});
			$('#costTypeDlg').dialog('open');
		}
		function onClickRow1(index, row){
			queryItem(row.id);
		}
		function queryItem(typeId){
			$("#itemgrid").datagrid('load',{
				url:"<%=basePath%>/manager/queryUseCostItemList",
				typeId:typeId
			});
		}
		function dialogCostOnDblClickRow(index, row){
			$("#costId"+subIndex).val(row.id);
			$("#itemName"+subIndex).text(row.itemName);
			$("#typeName"+subIndex).text(row.typeName);
			$('#costTypeDlg').dialog('close');
		}
	</script>
	<%@include file="/WEB-INF/page/include/handleFile.jsp"%>
</html>