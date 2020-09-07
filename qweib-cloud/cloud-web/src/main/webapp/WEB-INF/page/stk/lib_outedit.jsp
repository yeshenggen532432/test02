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
			<h1>销售开单</h1>
		</header>
		
		<input  type="hidden" name="token" id="tmptoken" value="${token}"/>
		<input  type="hidden" name="cstId" id="cstId" value="${cstId}"/>  
		<input  type="hidden" name="stkId" id="stkId" value="${stkId}"/>  
		<input  type="hidden" name="orderId" id="orderId" value="${orderId}"/>
		<input  type="hidden" name="billId" id="billId" value="${billId}"/>
		<input  type="hidden" name="statusindex" id="statusindex" value="${status}"/>
		<input  type="hidden" name="lastPage" id="lastPage" value="${lastPage}"/>
		<div class="from_tb">
			<table>
				<tr >
					<td width="25%">销售订单</td>
					<td>
						<a href="javascript:;" class="color_999" id="order">${orderNo}</a>
					</td>
				</tr>
				<tr>
					<td width="25%">客户</td>
					<td><a href="javascript:;" style="display: inline-block;width: 90%;" class="color_999" id="lib_supplier">${khNm}</a><a href="javascript:;" class="ft_icon"></a></td>
				</tr>
				<tr class="ftb_hd">
					<td width="25%">电话</td>
					<td><input type="text" placeholder="请点击输入" id="cstTel" value="${tel}"/></td>
				</tr>
				<tr class="ftb_hd">
					<td width="25%">地址</td>
					<td><input type="text" placeholder="请点击输入" id="cstAddress" value="${address}"/></td>
				</tr>
				
				
				<tr >
					<td width="25%">发票时间</td>
					<td>
						<input id="demo1" type="text" readonly="readonly" name="input_date" placeholder="请点击" data-lcalendar="2011-01-1,2019-12-31" value="${outTime}" />
					</td>
				</tr>
				
				<tr>
					<td width="25%">出货仓库</td>
					<td>
						<a href="javascript:;" class="color_999" id="warehouse">${stkName}</a>
					</td>
				</tr>
				<tr>
					<td width="25%">业务员</td>
					<td><a href="javascript:;" style="display: inline-block;width: 90%;" class="color_999" id="staff">${staff}</a></td>
				</tr>
				<tr >
					<td width="25%">电话</td>
					<td><input type="text" placeholder="请点击输入" id="stafftel" value="${stafftel}" /></td>
				</tr>
				<tr >
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
									<td>销售类型</td>
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
						<td><a href="javascript:;" class="lib_chose_sale">${item.xsTp}</a></td>
						<td><input type="number" class="bli" value="${item.qty}" onchange="countAmt()"/></td>
						<td><input type="text" class="bli" value="${item.unitName}"/></td>
						<td><input type="number" class="bli" value="${item.price}" onchange="countAmt()"/></td>
						<td><input type="number" class="bli" value="${item.amt}" readonly="readonly"/></td>
						<td><a href="javascript:;" class="delete_beer">删除</a></td>
						</tr>
						
 						</c:forEach>
							<tr class="initial_rest">
								
								
								<td><a href="javascript:;" class="beer">点击选择</a></td>
									<td><a href="javascript:;" class="lib_chose_sale">点击选择</a></td>
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
						<td><p id="disamt">${disamt}</p></td>
					</tr>
					<tr>
						<td width="25%">状态</td>
						<td><a id = "status" style="color:red;width:60px">${billstatus}</a>&nbsp;&nbsp; <a id="payStatus" style="color:red;width:60px">${paystatus}</a></td>
					</tr>
				</table>
			</div>
			
		</div>
		
		<div class="interval"></div>
		
		<div class="sub_box">
			<input type="submit" name="" id="btnsubmit" value="提交" class="library_submit" onclick="submitStk();"/>
			
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
		<!-- 选择订单 -->
		<div class="chose_people" style="display: none;" id = "orderdiv">
		<header class="fixed_top">
			<a href="javascript:closeOrderForm();" class="arrow2"><img src="<%=basePath %>/resource/stkstyle/img/arrow2.png"/></a>
			<h1>选择订单</h1>
		</header>
		<div class="src_box">
			<div class="src">
				<img src="<%=basePath %>/resource/stkstyle/img/src_icon.png"/>
				<input type="text" placeholder="供应商或单号搜索" id="searchKey" onchange="queryData()"/>
			</div>
		</div>
		<div class="order_btn_top">
		
			<table>
				<tr>
					<td width="25%">
						<div class="dtbox">
							<input id="demo2" type="text" readonly="readonly" name="input_date" value="2017-07-01" placeholder="请点击" data-lcalendar="2011-01-1,2019-12-31" onchange="queryData();" />
							
							<img src="<%=basePath %>/resource/stkstyle/img/icon22.png"/>
						</div>
					</td>
					<td width="25%">
						<div class="dtbox">
							<input id="demo3" type="text" readonly="readonly" name="input_date" value="2017-07-01" placeholder="请点击" data-lcalendar="2011-01-1,2019-12-31" onchange="queryData();"/>
							<img src="<%=basePath %>/resource/stkstyle/img/icon22.png"/>
						</div>
					</td>
					<td width="25%">
						<div class="dtbox">
							<a href="javascript:queryOrder();" id="queryBtn">查询</a>
							
						</div>
					</td>
				</tr>
			</table>
		</div>
		<div class="sctb">
			<div class="sctbw">
				<table>
					<thead>
						<tr>
							
							<td align="center" style = "WIDTH:100px;">单号</td>
							<td align="center" style = "WIDTH:100px;">客户</td>
							<td align="center" style = "WIDTH:80px;">总金额</td>
							
						</tr>
					</thead>
					<tbody id="orderList">
					</tbody>
					</table>
			</div>
		</div>
		</div>
		<div class="had_box has_sub_menu" id="beer_box1111">
			<div class="mask"></div>
			<div class="lib_box" id = "wareList">
				<ul>
					<li>
						
					</li>
					<li>
						
					</li>
					<li>
						
					</li>
					<li><p class="lib_title">喜力啤酒<img src="<%=basePath %>/resource/stkstyle/img/arrow.png"/></p></li>
					<li><p class="lib_title">其他<img src="<%=basePath %>/resource/stkstyle/img/arrow.png"/></p></li>
				</ul>
			</div>
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
		
		
		
		<div class="chose_people" style="display: none;" id="customerdiv">
		<header class="fixed_top">
		
			<h1>选择客户</h1>
		</header>
			<div class="src_box">
				<div class="src">
					<img src="<%=basePath %>/resource/stkstyle/img/src_icon.png"/>
					<input type="text" placeholder="搜索" onchange="querycustomer(this.value)"/>
					<a href="javascript:;" class="wap_closebtn">取消</a>
				</div>
			</div>
			<div class="people_list" id="customerList">
				<ul>
					
					
					
					
				</ul>
			</div>
		</div>
		
	<!--业务员-->
		
		<div class="src_goods" id="staffForm">
			<div class="headersrc">
				<div class="hsrcbox">
					<img src="<%=basePath %>/resource/stkstyle/img/src_icon.png"/>
					<input type="text" name="" />
					<input type="submit" value="查询" />
				</div>
				<a href="javascript:;" class="close1">取消</a>
			</div>
			
			
			
			<ul class="wap_bbbb" id="memdiv">
				
				<li>
					<div class="bodysrc clearfix" id="pcl_switch">
						<div class="bodysrc_lf">
							<p class="bs_tl">部门分类树</p>
							<div class="bs_fbox" id="departTree1">
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
								<tbody id="memberList1">
									
								</tbody>
							</table>
						</div>
					</div>
				</li>
				
			</ul>
		</div>		
		
	</body>
	
	<script src="<%=basePath %>/resource/stkstyle/js/jquery-2.1.0.min.js" type="text/javascript" charset="utf-8"></script>
	<script src="<%=basePath %>/resource/stkstyle/js/stkout.js" type="text/javascript" charset="utf-8"></script>
	<script src="<%=basePath %>/resource/stkstyle/js/lCalendar.js" type="text/javascript" charset="utf-8"></script>
	<script type="text/javascript">
		// 日历绑定
		var calendar = new lCalendar();
		calendar.init({
			'trigger': '#demo1',
			'type': 'date'
		});
		
		var calendar3 = new lCalendar();
		var calendar2 = new lCalendar();
		calendar3.init({
			'trigger': '#demo3',
			'type': 'date'
		});
		calendar2.init({
			'trigger': '#demo2',
			'type': 'date'
		});
		// 解决苹果 readonly 失效问题
		$("input[name='input_date']").focus(function(){
			$(this).blur();
		});
	</script>
</html>