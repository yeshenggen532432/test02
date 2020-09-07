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
		<title>领料回库</title>
		<meta name="description" content="">
		<meta name="keywords" content="">
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/stkstyle/css/style.css"/>		
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/stkstyle/css/lCalendar.css"/>
		<script type="text/javascript" src="<%=basePath %>/resource/jquery-1.8.0.min.js"></script>
		<script type="text/javascript">
		var priceDisplay = '${permission:checkUserFieldDisplay("stk.stkIn.lookprice")}';
		var amtDisplay = '${permission:checkUserFieldDisplay("stk.stkIn.lookamt")}';
		var qtyDisplay = '${permission:checkUserFieldDisplay("stk.stkIn.lookqty")}';
		</script>
		<script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
		<script src="<%=basePath %>/resource/stkstyle/js/pcllhkin.js" type="text/javascript" charset="utf-8"></script>
		<script type="text/javascript" src="<%=basePath %>resource/WdatePicker.js"></script>
		<script type="text/javascript" src="<%=basePath %>/resource/jquery.easyui.min.js"></script>
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
						<div class="item" id="btnsave" style="display: ${(status eq -2 and billId eq 0)?'':'none'}">
							<a href="javascript:submitStk();">
								<img src="<%=basePath %>/resource/stkstyle/img/nicon1.png"/>
								<img src="<%=basePath %>/resource/stkstyle/img/nicon1a.png"/>
								<p>保存并审批</p>
							</a>
						</div>
						</c:if>
						<c:if test="${permission:checkUserFieldPdm('stk.stkIn.cancel')}">
						<div class="item" id="btncancel"  style="display: ${(status eq -2 or billId eq 0)?'none':''}">
							<a href="javascript:cancelClick();">
								<img src="<%=basePath %>/resource/stkstyle/img/nicon5.png"/>
								<img src="<%=basePath %>/resource/stkstyle/img/nicon5a.png"/>
								<p>作废</p>
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
				<input  type="hidden" name="stkId" id="stkName" value="${stkName}"/>
				<input  type="hidden" name="proType" id="proType" value="${proType}"/>
				<input  type="hidden" name="status" id="status" value="${status}"/>
				<input  type="hidden" name="proName" id="proName" value="${proName}"/>
				<div class="pcl_fm">
					<table>
						<tbody>
							<tr>
								<td style="text-align: center">车&nbsp;&nbsp;&nbsp;&nbsp;间：</td>
								<td>
									<div class="selbox">
										<span id="stkProNamespan">${proName}</span>
										<tag:select name="proId" id="proId" tclass="pcl_sel" tableName="sys_depart" value="${proId }"  displayKey="branch_id" displayValue="branch_name"/>
									</div>
								</td>
								<td style="text-align: center;">入库时间：</td>
								<td>
								<div class="pcl_input_box pcl_w2">
									<input name="text" id="inDate"  onClick="WdatePicker({skin:'whyGreen',dateFmt: 'yyyy-MM-dd HH:mm'});" style="width: 100px;" value="${inTime}"  readonly="readonly"/>
								</div>
								</td>
								<td style="text-align: center;">入库仓库：</td>
								<td>
									<div class="selbox" id="stklist">
										<span id = "stkNamespan">${stkName}</span>
										<select name="" class="pcl_sel" id = "stksel">
										</select>
									</div>
								</td>
							</tr>
							<tr  style="display: none">
								<td style="text-align: center;">合计金额：</td>
								<td ><div class="pcl_input_box pcl_w2"><input type="text" id="totalamt" readonly="readonly" value="${totalamt}"/></div></td>
								<td style="text-align: center;">整单折扣：</td>
								<td><div class="pcl_input_box pcl_w2"><input type="text" id="discount" value="${discount}" onchange="countAmt()"/></div></td>
								<td style="text-align: center;">发票金额：</td>
								<td ><div class="pcl_input_box pcl_w2"><input type="text" id="disamt" readonly="readonly" value="${disamt}"/></div></td>
							</tr>
							<tr>
								<td valign="top" style="text-align: center;">备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注：</td>
								<td colspan="5">
									<div class="pcl_txr">
										<textarea name="" id="remarks">${remarks}</textarea>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="pcl_ttbox1 clearfix">
					<div class="pcl_lfbox1">
						<table id="more_list">
							<thead>
								<tr>
									<td>产品编号</td>
									<td>产品名称</td>
									<td>产品规格</td>
									<td>单位</td>
									<td >入库数量</td>
									<td style="display: none">单价</td>
									<td style="display: none">入库金额</td>
									<td>生产日期</td>
									<td>操作</td>
								</tr>
							</thead>
							<tbody id="chooselist">
								<c:forEach items="${warelist}" var="item" >
  								<tr>
								<td style="padding-left: 20px;text-align: left;"><img src="<%=basePath %>/resource/stkstyle/img/icon19.jpg"class="pcl_ic"/>
								<input type="hidden" name="wareId" value = "${item.wareId}"/> ${item.wareCode} </td>
								<td>${item.wareNm}</td>
								<td>${item.wareGg}</td>
								<td><select id="beUnit${s.index }" name="beUnit" class="pcl_sel2" onchange="changeUnit(this,${s.index })">
	        						<option value="${item.maxUnitCode}" ${(item.maxUnitCode eq item.beUnit)?'selected=selected':''}>${item.wareDw}</option>
	        						<option value="${item.minUnitCode}" ${(item.minUnitCode eq item.beUnit)?'selected=selected':''}>${item.minUnit}</option>
	        						</select>
								</td>
								<td ><input name="edtqty" type="text" class="pcl_i2" value="${item.qty}" onchange="countAmt()"/></td>
								<td style="display: none"><input name="edtprice" type="text" class="pcl_i2" value="${item.price}" readonly="readonly"/></td>
								<td style="display: none"><input name="amt" type="text" class="pcl_i2" value="${item.amt}" readonly="readonly"/></td>
								<td style="display:none"><input id="hsNum${s.index }" name="hsNum" type="hidden" class="pcl_i2" value="${item.hsNum}"/></td>
								<td style="display:none"><input id="unitName${s.index }" name="unitName" type="hidden" class="pcl_i2" value="${item.unitName}" /></td>
								<td><input name="productDate" type="text" class="pcl_i2" value="${item.productDate}" onClick="WdatePicker({skin:'whyGreen',dateFmt:'yyyy-MM-dd'});"/></td>
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
							<td id="edtSumQty" >0</td>
							<td style="display: none"></td>
							<td id="edtSumAmt" style="display: none">0.00</td>
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
									
								</tbody>
							</table>
							</div>
						</div>
					</div>
					<div class="pcl_switch clearfix">
						<div class="pcl_3box2" style="height: 350px;overflow: auto;">
						<div class="pcl_3box2">
							<h2>部门分类树</h2>
							<div class="pcl_l2" id="departTree">
								<a href="#">员工</a>
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
										
									</tr>
								</thead>
								<tbody id="warelist">
									
								</tbody>
							</table>
						</div>
					</div>
		
		</div>
	<div id="wareDlg" closed="true" class="easyui-dialog" style="width:500px; height:200px;" title="商品选择" iconCls="icon-edit">
     </div>
	
	<script src="<%=basePath %>/resource/stkstyle/js/lCalendar.js" type="text/javascript" charset="utf-8"></script>
	<script type="text/javascript">
		/*$(".pcl_sel").change(function(){
			var index = this.selectedIndex;
		       
			var this_val = this.options[index].text;
			$(this).siblings('span').text(this_val);
		});*/

		$("#proId").change(function(){
			var index = this.selectedIndex;
			var this_val = this.options[index].text;
			$("#stkProName").val(this_val);
			$("#proName").val(this_val);
			$(this).siblings('span').text(this_val);
		});

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
		    //$("#pszd").val(selObj);
		    //alert(selObj);
			var this_val = this.options[index].text;
			$(this).siblings('span').text(this_val);
		});
		
		function showWare(){
	    	$('#dlg').dialog('open');
		 }
		
		function dialogSelectWare(){
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
		 
		 function setTabRowData(json)
		 {
				//alert(JSON.stringify(wareId));
				var wareId = json.wareId;
				var wareCode = json.wareCode;
				var wareName = json.wareNm;
				var wareGg = json.wareGg;
				var unitName = json.wareDw;
				var minUnit = json.minUnit;
				var maxUnitCode = json.maxUnitCode;
				var minUnitCode = json.minUnitCode;
				var price  = json.price;
				var hsNum = json.hsNum;
				var sunitFront = json.sunitFront;
				
				$("#more_list tbody").append(
						'<tr>'+
							'<td style="padding-left: 20px;text-align: left;"><img src="'+basePath +'/resource/stkstyle/img/icon19.jpg"class="pcl_ic"/>'+
							'<input type="hidden" id="wareId'+rowIndex+'" name="wareId" value = "' + wareId + '"/>' + wareCode + '</td>'+
							'<td>'+ wareName + '</td>'+
							'<td>'+ wareGg + '</td>'+
							'<td>' +  
							'<select id="beUnit'+rowIndex+'" name="beUnit" class="pcl_sel2" onchange="changeUnit(this,'+rowIndex+')">'+
							'<option value="'+maxUnitCode+'" checked>'+unitName+'</option>'+
							'<option value="'+minUnitCode+'">'+minUnit+'</option>'+
							'</select>'
							+ '</td>'+
							'<td style="display:'+qtyDisplay+'"><input id="edtqty'+rowIndex+'" name="edtqty" type="text" class="pcl_i2" value="1" onchange="countAmt()"/></td>'+
							'<td style="display:'+priceDisplay+'"><input id="edtprice'+rowIndex+'" name="edtprice" type="text" class="pcl_i2" value="' + price + '" readonly="readonly" onchange="countAmt()"/></td>'+
							'<td style="display:'+amtDisplay+'"><input id="amt'+rowIndex+'" name="amt" type="text" class="pcl_i2" value="' + price + '" readonly="readonly" onchange="countPrice()"/></td>'+
							'<td style="display:none"><input id="hsNum'+rowIndex+'" name="hsNum" type="hidden" class="pcl_i2" value="'+hsNum+'"/></td>'+
							'<td style="display:none"><input id="unitName'+rowIndex+'" name="unitName" type="hidden" class="pcl_i2" value="'+unitName+'" /></td>'+
							'<td><input name="text"  class="pcl_i2"  onClick="WdatePicker({skin:\'whyGreen\',dateFmt: \'yyyy-MM-dd\'});" style="width: 90px;"  readonly="readonly" value="'  + '"/></td>'+
							'<td><a href="javascript:;"onclick="deleteChoose(this);" class="pcl_del">删除</a></td>'+
							
						'</tr>'
					);
				rowIndex++;
				countAmt();
				var len = $("#more_list").find("tr").length ;
				var row = $("#more_list tbody tr").eq(len-3);
				/************如果商品信息中有设置默认选中辅助单位，那么就选中设置选中辅助 开始***********/
				if(sunitFront==1){
					$(row).find("select[name='beUnit']").val(minUnitCode);
					$(row).find("select[name='beUnit']").trigger("change");
				}
				/************如果商品信息中有设置默认选中辅助单位，那么就选中设置选中辅助 结束***********/
		 }
		
	</script>
	<%@include file="/WEB-INF/page/include/handleFile.jsp"%>
</html>