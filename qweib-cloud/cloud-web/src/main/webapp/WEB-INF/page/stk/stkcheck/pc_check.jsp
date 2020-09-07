<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html style="font-size: 50px;">

	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<meta name="format-detection" content="telephone=no" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=2.0, user-scalable=no"/>
		<title>盘点开单</title>
		<meta name="description" content="">
		<meta name="keywords" content="">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/stkstyle/css/style.css"/>		
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/stkstyle/css/lCalendar.css"/>
		<script src="<%=basePath %>/resource/stkstyle/js/jquery-2.1.0.min.js" type="text/javascript" charset="utf-8"></script>
		<script src="<%=basePath %>/resource/stkstyle/js/pcstkcheck.js" type="text/javascript" charset="utf-8"></script>
		<script type="text/javascript" src="<%=basePath %>resource/WdatePicker.js"></script>
	</head>
<script type="text/javascript">
var basePath = '<%=basePath %>';
var gwareList;
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
			<input  type="hidden" name="auditFlag" id="auditFlag" value="${auditFlag}"/>
			<input  type="hidden" name="status" id="status" value="${status}"/>
			<div class="pcl_lib_out">
				
				<div class="pcl_menu_box">
					<div class="menu_btn">
						<div class="item on" id="btnnew">
							<a href="javascript:newClick();">
								<img src="<%=basePath %>/resource/stkstyle/img/nicon1.png"/>
								<img src="<%=basePath %>/resource/stkstyle/img/nicon1a.png"/>
								<p>新建</p>
							</a>
						</div>
						<!--  <div class="item" id="btnedit">
							<a href="javascript:editClick();">
								<img src="<%=basePath %>/resource/stkstyle/img/nicon2.png"/>
								<img src="<%=basePath %>/resource/stkstyle/img/nicon2a.png"/>
								<p>编辑</p>
							</a>
						</div>-->
						<!--  <div class="item" id="btndelete">
							<a href="javascript:deleteClick();">
								<img src="<%=basePath %>/resource/stkstyle/img/nicon3.png"/>
								<img src="<%=basePath %>/resource/stkstyle/img/nicon3a.png"/>
								<p>删除</p>
							</a>
						</div>-->
						 
						<div class="item" id="btnsave">
							<a href="javascript:submitStk();">
								<img src="<%=basePath %>/resource/stkstyle/img/nicon6.png"/>
								<img src="<%=basePath %>/resource/stkstyle/img/nicon6a.png"/>
								<p>保存</p>
							</a>
						</div>
						<!--  <div class="item" id="btnreset">
							<a href="javascript:resetClick();">
								<img src="<%=basePath %>/resource/stkstyle/img/nicon7.png"/>
								<img src="<%=basePath %>/resource/stkstyle/img/nicon7a.png"/>
								<p>取消</p>
							</a>
						</div>-->
						
						<div class="pcl_right_edi">
							<div class="pcl_right_edi_w">
								<div>
									<input type="text" id="billstatus"   style="color:red;width:60px" readonly="readonly" value="${billstatus}"/>
									&nbsp;&nbsp;
									<!--  <input type="text" id="paystatus"   style="color:red;width:60px" readonly="readonly" value="${paystatus}"/>-->
								</div>
							</div>
							
						</div>
						
					</div>
					
				</div>
				
				<!--<p class="odd_num">单号：</p>-->
				<input  type="hidden" name="billId" id="billId" value="${billId}"/>
				<input  type="hidden" name="stkId" id="stkId" value="${stkId}"/>
				<input  type="hidden" name="stkName" id="stkName" value="${stkName}"/>
				
				<div class="pcl_fm">
					<table>
						<tbody>
							<tr>
								<td>盘点时间：</td>
								<td>
								<div class="pcl_input_box pcl_w2">
									<input name="text" id="checkDate"  onClick="WdatePicker({skin:'whyGreen',dateFmt: 'yyyy-MM-dd HH:mm'});" style="width: 100px;" value="${checkTime}"  readonly="readonly"/>
								</div>
								</td>
								<td>盘点仓库：</td>
								<td>
									
									<div class="selbox" id="stklist">
										<span id="stkNamespan">${stkName}</span>
										<select name="" class="pcl_sel" id = "stksel">
											
										</select>
									</div>
									
								</td>
								<td>盘点人员：</td>
								<td >
								<div class="pcl_chose_peo" >
										<a href="javascript:;" id="staff" style="padding-right: 30px;">${staff}</a>
								</div>
								</td>
								
							</tr>
							
							
							
							
							<tr>
								<td valign="top">备注：</td>
								<td colspan="5">
									<div class="pcl_txr">
										<textarea name="" id="remarks" value="${remarks}"></textarea>
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
									<td>产品编号</td>
									<td>产品名称</td>
									
									<td>单位</td>
									<td>账面数量</td>
									<td>盘点数量</td>
									<td>差量</td>
									<td>操作</td>
								</tr>
							</thead>
							<tbody id="chooselist">
								<c:forEach items="${warelist}" var="item" >
								
  								<tr>
								<td style="padding-left: 20px;text-align: left;"><img src="<%=basePath %>/resource/stkstyle/img/icon19.jpg"class="pcl_ic"/>
								<input type="hidden" name="wareId" value = "${item.wareId}"/> ${item.wareCode} </td>
								<td>${item.wareNm}</td>
								
								<td> ${item.unitName} </td>
								<td><input name="edtStkQty" type="text" class="pcl_i2" value="${item.stkQty}" readonly="readonly" /></td>
								<td><input name="edtqty" type="text" class="pcl_i2" value="${item.qty}" onchange="countQty()"/></td>
								<td>${item.disQty}</td>
								<td></td>
				
								</tr>
 								</c:forEach>
							</tbody>
						</table>
					</div>
					<div class="pcl_rfbox clearfix">
						<div class="pcl_rt">
							<span>请刷条码：</span><input type="text" class="pcl_ip" id="wareInput" onkeyup ="queryWareByKeyWord(this.value)" />
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
										<td>商品编号</td>
										<td>名称</td>
										<td>价格</td>
										<td>库存量</td>
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
		<!-- 业务员 -->
		<div class="chose_people pcl_chose_people" style="" id="staffForm">
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
	
	
	
	<script src="<%=basePath %>/resource/stkstyle/js/lCalendar.js" type="text/javascript" charset="utf-8"></script>
	<script type="text/javascript">
		/*$(".pcl_sel").change(function(){
			var index = this.selectedIndex;
		       
			var this_val = this.options[index].text;
			$(this).siblings('span').text(this_val);
		});*/
		
		$("#stksel").change(function(){
			var index = this.selectedIndex;
		    var stkId = this.options[index].value;
		    $("#stkId").val(stkId);
		    
			var this_val = this.options[index].text;
			$(this).siblings('span').text(this_val);
		});
		
		$("#pszdsel").change(function(){
			var index = this.selectedIndex;
		    var selObj = this.options[index].value;
		    $("#pszd").val(selObj);
		    //alert(selObj);
			var this_val = this.options[index].text;
			$(this).siblings('span').text(this_val);
		});
		$(".pcl_close_button").click(function(){
			$(this).parents('.chose_people').hide();
		});
		
		function testwaretype(typeId)
		{
			alert(typeId);
		}
		
	</script>
</html>