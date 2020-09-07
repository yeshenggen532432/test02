<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html>

	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<meta name="format-detection" content="telephone=no" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=2.0, user-scalable=no"/>
		<title>出库</title>
		<meta name="description" content="">
		<meta name="keywords" content="">
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/stkstyle/css/style.css"/>		
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/stkstyle/css/lCalendar.css"/>
		<script src="<%=basePath %>/resource/stkstyle/js/resize.js" type="text/javascript" charset="utf-8"></script>
	</head>
<script type="text/javascript">
var basePath = '<%=basePath %>';

</script>
	<body class="bg1">
		
		<header class="fixed_top">
		<a href="backpage?token=${token}&lastPage=${lastPage}" class="arrow2"><img src="<%=basePath %>/resource/stkstyle/img/arrow2.png"/></a>
			<h1>其它入库开单</h1>
		</header>
		
		<input  type="hidden" name="token" id="tmptoken" value="${token}"/>
		<input  type="hidden" name="proId" id="proId" value="0"/>  
		<input  type="hidden" name="stkId" id="stkId" value="${stkId}"/>  
		<input  type="hidden" name="billId" id="billId" value="${billId}"/>
		<input  type="hidden" name="proType" id="proType" value="${proType}"/>
		<input  type="hidden" name="status" id="status" value="${status}"/>
		<input  type="hidden" name="lastPage" id="lastPage" value="${lastPage}"/>
		<div class="from_tb">
			<table>
				<tr>
					<td width="25%">发货对象</td>
					<td><a href="javascript:;" style="display: inline-block;width: 90%;" class="color_999" id="lib_supplier">${proName}</a></td>
				</tr>
				<tr class="ftb_hd">
					<td width="25%">收货仓库</td>
					<td>
						<a href="javascript:;" class="color_999" id="warehouse">${stkName}</a>
					</td>
				</tr>
				
				<tr class="ftb_hd">
					<td width="25%">发票时间</td>
					<td>
						<input id="demo1" type="text" readonly="readonly" name="input_date" placeholder="请点击" data-lcalendar="2011-01-1,2019-12-31" value="${inTime}" />
					</td>
				</tr>
				<tr class="ftb_hd">
					<td width="25%">备注</td>
					<td><input type="text" placeholder="请点击输入" id="remarks" value="${remarks}"/></td>
				</tr>
				
			</table>
		</div>
		
		<div class="interval"></div>
		
		<div class="library_total">
			<div class="tbox">
				<p class="tl1">合计</p>
				<div class="tbbb">
					<table id="more_list">
						<thead>
							<tr>
								<td>品项</td>
								
								<td>数量</td>
								<td>单位</td>
								<td>单价</td>
								<td>金额</td>
								<td></td>
							</tr>
						</thead>
						<tbody id = "subList">
						<c:forEach items="${warelist}" var="item" >
						<tr>
						<td><a href="javascript:;" class="beer">${item.wareNm}</a><input  type="hidden" name="wareId"  value="${item.wareId}"/></td>
						
						<td><input type="number" class="bli" value="${item.qty}" onchange="countAmt()"/></td>
						<td><input type="text" class="bli" value="${item.unitName}" readonly="readonly"/></td>
						<td><input type="number" class="bli" value="${item.price}" onchange="countAmt()"/></td>
						<td><input type="number" class="bli" value="${item.amt}" readonly="readonly"/></td>
						<td><a href="javascript:;" class="delete_beer">删除</a></td>
						
  						</tr>
 						</c:forEach>
							<tr class="initial_rest">
								
								
								<td><a href="javascript:;" class="beer"  onclick="showWareForm();">点击选择</a></td>
									
									<td><input type="number" class="bli"/></td>
									<td><input type="text" class="bli"/></td>
									<td><input type="number" class="bli"/></td>
									<td><input type="number" class="bli"/></td>
									<td><a href="javascript:;" class="delete_beer">删除</a></td>
							</tr>
						</tbody>
					</table>
				</div>
				
			</div>
			
			<div class="from_tb">
				<table>
					<tr>
						<td width="25%">合计金额</td>
						<td><p id="totalamt">${totalamt}</p></td>
					</tr>
					<tr>
						<td width="25%">整单折扣</td>
						<td><p><input type="number" id="discount" class="bli" value = "${discount}" onchange="countAmt()"/></p></td>
					</tr>
					<tr>
						<td width="25%">发票金额</td>
						<td><p id = "disamt">${disamt}</p></td>
					</tr>
					<tr>
						<td width="25%">状态</td>
						<td><p id = "billStatus">${billstatus}</p></td>
					</tr>
				</table>
			</div>
			
		</div>
		
		<div class="interval"></div>
		
		<div class="sub_box">
			<input type="submit" name="" id="" value="提交" class="library_submit" onclick="submitStk();"/>
			
		</div>
		
		<div class="had_box" id="lib_chose_sale_had">
			<div class="mask"></div>
			<div class="lib_box">
				<ul>
					<li>正常销售</li>
					<li>促销折让</li>
					<li>消费折让</li>
					<li>费用折让</li>
					<li>其他销售</li>
				</ul>
			</div>
		</div>
		<div class="had_box" id="warehouse_bhad">
			<div class="mask"></div>
			<div class="lib_box" id = "basestk">
				<ul>
					
				</ul>
			</div>
		</div>
		<div class="had_box" id="order_had">
			<div class="mask"></div>
			<div class="lib_box" id="stkDict">
				<ul>
					
				</ul>
			</div>
		</div>
		
		
		
		
		<div class="chose_people" style="display: none;">
			<div class="src_box">
				<div class="src">
					<img src="<%=basePath %>/resource/stkstyle/img/src_icon.png"/>
					<input type="text" placeholder="搜索" onchange="querycustomer(this.value)"/>
				</div>
			</div>
			<div class="people_list" id="customerList">
				<ul>
					
					
					
					
				</ul>
			</div>
		</div>
		
	<!--客户选择-->
		
		<div class="src_goods" id="lib_supplier_box">
			<div class="headersrc">
				<div class="hsrcbox">
					<img src="style/img/src_icon.png"/>
					<input type="text" name="" />
					<input type="submit" value="查询" />
				</div>
				<a href="javascript:;" class="close1">取消</a>
			</div>
			
			<div class="wap_swich_wap">
				<table>
					<tr>
						<td width="33.33%" class="on"><a href="javascript:;" class="on">供应商</a></td>
						<td width="33.33%"><a href="javascript:;">部门</a></td>
						<td width="33.33%"><a href="javascript:;">客户</a></td>
					</tr>
				</table>
			</div>
			
			<ul class="wap_bbbb">
				<li>
					<table class="wapsrcbb" width="100%">
						<thead>
							<tr>
								<td>供应商名称</td>
								<td>联系电话</td>
								<td>地址</td>
							</tr>
						</thead>
						<tbody id="provderList">
							<tr>
								<td>ZZ</td>
								<td>184464646464646</td>
								<td>地址地址地址地址地址地址地址</td>
							</tr>
						</tbody>
					</table>
				</li>
				<li>
					<div class="bodysrc clearfix">
						<div class="bodysrc_lf">
							<p class="bs_tl">部门分类树</p>
							<div class="bs_fbox" id="departTree">
								<div class="bs_f">
									<p>青岛小优</p>
									<div class="bs_submenu">
										<a href="#">管理部</a>
										<a href="#">管理部</a>
										
										<div class="bs_f">
											<p>青岛小优</p>
											<div class="bs_submenu">
												<a href="#">管理部</a>
											</div>
										</div>
										
										<div class="bs_f">
											<p>青岛小优</p>
											<div class="bs_submenu">
												<a href="#">管理部</a>
												<div class="bs_f">
													<p>青岛小优</p>
													<div class="bs_submenu">
														<a href="#">管理部</a>
													</div>
												</div>
												<div class="bs_f">
													<p>青岛小优</p>
													<div class="bs_submenu">
														<a href="#">管理部</a>
														<div class="bs_f">
															<p>青岛小优</p>
															<div class="bs_submenu">
																<a href="#">管理部</a>
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
						<div class="bodysrc_rf">
							<table>
								<thead>
									<tr>
										<td>姓名</td>
										<td>联系电话</td>
										
									</tr>
								</thead>
								<tbody id="memberList">
									
								</tbody>
							</table>
						</div>
					</div>
				</li>
				<li>
					<table class="wapsrcbb" width="100%">
						<thead>
							<tr>
								<td>供应商名称</td>
								<td>联系电话</td>
								<td>地址</td>
							</tr>
						</thead>
						<tbody id="customerlist">
							<tr>
								<td>ZZ</td>
								<td>184464646464646</td>
								<td>地址地址地址地址地址地址地址</td>
							</tr>
						</tbody>
					</table>
				</li>
			</ul>
		</div>
		
		
		<!--商品选择-->
		<div class="src_goods" id="beer_box">
		<header class="fixed_top">
		
			<h1>选择产品</h1>
		</header>
			<div class="headersrc">
				<div class="hsrcbox">
					<img src="<%=basePath %>/resource/stkstyle/img/src_icon.png"/>
					<input type="text" name="" onchange="queryWareByKeyWord(this.value);"/>
					<input type="submit" value="查询" />
				</div>
				<a href="javascript:;" class="close1">确认</a>
			</div>
			
			<div class="bodysrc clearfix">
				<div class="bodysrc_lf">
					<p class="bs_tl">商品类别</p>
					<div class="bs_fbox" id="wareTypeTree">
					<div class="bs_f">
						<a href="#">管理部</a>
					</div>
						<div class="bs_f" >
							
							<p>青岛小优</p>
							<div class="bs_submenu">
								<a href="#">管理部</a>
								<a href="#">管理部</a>
								
								<div class="bs_f">
									<p>青岛小优</p>
									<div class="bs_submenu">
										<a href="#">管理部</a>
									</div>
								</div>
								
								<div class="bs_f">
									<p>青岛小优</p>
									<div class="bs_submenu">
										<a href="#">管理部</a>
										<div class="bs_f">
											<p>青岛小优</p>
											<div class="bs_submenu">
												<a href="#">管理部</a>
											</div>
										</div>
										<div class="bs_f">
											<p>青岛小优</p>
											<div class="bs_submenu">
												<a href="#">管理部</a>
												<div class="bs_f">
													<p>青岛小优</p>
													<div class="bs_submenu">
														<a href="#">管理部</a>
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
				<div class="bodysrc_rf"  style="overflow:scroll; height:300px;">
					<table>
						<thead>
							<tr>
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
			<div class="bottom_bb">
			<div class="w">
				<p>选中产品数：<i id = "totalqty" style="color:red">0</i></p>
			</div>
			
			
		</div>
		</div>
		
	</body>
	
	<script src="<%=basePath %>/resource/stkstyle/js/jquery-2.1.0.min.js" type="text/javascript" charset="utf-8"></script>
	<script src="<%=basePath %>/resource/stkstyle/js/otherin.js" type="text/javascript" charset="utf-8"></script>
	<script src="<%=basePath %>/resource/stkstyle/js/lCalendar.js" type="text/javascript" charset="utf-8"></script>
	<script type="text/javascript">
		// 日历绑定
		var calendar = new lCalendar();
		calendar.init({
			'trigger': '#demo1',
			'type': 'date'
		});
		// 解决苹果 readonly 失效问题
		$("input[name='input_date']").focus(function(){
			$(this).blur();
		});
		
		$("#lib_supplier").click(function(){
			$("#lib_supplier_box").show();
		});
	</script>
</html>