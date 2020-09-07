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
		<title>组装入库管理</title>
		<meta name="description" content="">
		<meta name="keywords" content="">
		<script type="text/javascript">
		var amtDisplay = '';
		var priceDisplay = '';
		if('${stkZzcx.ioMark}'=='1'){
			amtDisplay='none';
			priceDisplay='none';
		}
		</script>
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/stkstyle/css/style.css"/>		
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/stkstyle/css/lCalendar.css"/>
		<script type="text/javascript" src="<%=basePath %>/resource/jquery-1.8.0.min.js"></script>
		<script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
		<script type="text/javascript" src="<%=basePath %>resource/WdatePicker.js"></script>
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/easyui/easyui.css">
		<script type="text/javascript" src="<%=basePath %>/resource/jquery.easyui.min.js"></script>
		<script src="<%=basePath %>/resource/stkstyle/js/Map.js" type="text/javascript" charset="utf-8"></script>
		<script type="text/javascript">
		var map = new Map();
		</script>
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/easyui/icon.css">
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
		<form action="<%=basePath %>/manager/stkZzcx/save" name="savefrm" id="savefrm" method="post">
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
						<div class="item" id="btnsave" style="display:${(stkZzcx.status eq -2)?'':'none' }">
							<a href="javascript:submitStk();">
								<img src="<%=basePath %>/resource/stkstyle/img/nicon1.png"/>
								<img src="<%=basePath %>/resource/stkstyle/img/nicon1a.png"/>
								<p>暂存</p>
							</a>
						</div>
						<div class="item" id="btnaudit" style="display:${(stkZzcx.status eq -2 and  stkZzcx.id ne 0)?'':'none' }">
							<a href="javascript:audit();">
								<img src="<%=basePath %>/resource/stkstyle/img/nicon2.png"/>
								<img src="<%=basePath %>/resource/stkstyle/img/nicon2a.png"/>
								<p>审批</p>
							</a>
						</div>
						<div class="item" id="btncancel" style="display:${(stkZzcx.status eq -2 or stkZzcx.status eq 2)?'none':'' }">
							<a href="javascript:cancel();">
								<img src="<%=basePath %>/resource/stkstyle/img/nicon5.png"/>
								<img src="<%=basePath %>/resource/stkstyle/img/nicon5a.png"/>
								<p>作废</p>
							</a>
						</div>
						<div class="pcl_right_edi" style="width: 500px;">
							<div class="pcl_right_edi_w">
								<div>
								<span style="color:green">${stkZzcx.billName}</span>
								<input type="text" id="billNo" name="billNo"   style="color:green;width:160px;font-size: 14px" readonly="readonly" value="${stkZzcx.billNo}"/>
								  <c:choose>
								  	<c:when test="${stkZzcx.status eq -2}"><input type="text" id="billstatus"  value="暂存"   style="color:red;width:60px" readonly="readonly"/></c:when>
								  	<c:when test="${stkZzcx.status eq 1}"><input type="text" id="billstatus"  value="已审批"   style="color:red;width:60px" readonly="readonly"/></c:when>
								  	<c:when test="${stkZzcx.status eq 2}"><input type="text" id="billstatus"  value="已作废"   style="color:red;width:60px" readonly="readonly"/></c:when>
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
				<input  type="hidden" name="id" id="billId" value="${stkZzcx.id}"/>
				<input  type="hidden" name="bizType" id="bizType" value="${stkZzcx.bizType}"/>
				<input  type="hidden" name="stkName" id="stkName" value="${stkZzcx.stkName}"/>
				<input  type="hidden" name="stkInName" id="stkInName" value="${stkZzcx.stkInName}"/>
				<input  type="hidden" name="proName" id="proName" value="${stkZzcx.proName}"/>
				<input type="hidden" name="proId" id="proId" value="${stkZzcx.proId}"/>
				<input type="hidden" name="proType" id="proType" value="${stkZzcx.proType}"/>
				<input  type="hidden" name="status" id="status" value="${stkZzcx.status}"/>
				<input  type="hidden" name="ioMark" id="ioMark" value="${stkZzcx.ioMark}"/>
				<input  type="hidden" name="billName" id="billName" value="${stkZzcx.billName}"/>
				<div class="pcl_fm">
					<table>
						<tbody>
							<tr>
								<td>单据时间：</td>
								<td>
								<div class="pcl_input_box pcl_w2">
									<input name="inDate" id="inDate"  onClick="WdatePicker({skin:'whyGreen',dateFmt: 'yyyy-MM-dd HH:mm'});" style="width: 100px;" value="${stkZzcx.inDate}"  readonly="readonly"/>
								</div>
								</td>
								<td>入库仓库：</td>
								<td>
								<div class="selbox">
								<span id="stkNamespan">${stkZzcx.stkName}</span>
									<tag:select name="stkId" id="stkId" tclass="pcl_sel"  tableName="stk_storage" value="${stkZzcx.stkId }"  displayKey="id" displayValue="stk_name"/>   
								</div>
								</td>
								<td>原料仓库：</td>
								<td>
								<div class="selbox">
								<span id="stkInNamespan">${stkZzcx.stkInName}</span>
									<tag:select name="stkInId" id="stkInId" tclass="pcl_sel" tableName="stk_storage" value="${stkZzcx.stkInId }"  displayKey="id" displayValue="stk_name"/>   
								</div>
								</td>
							</tr>
							<tr style="display: none">
								<td>合计金额：</td>
								<td ><div class="pcl_input_box pcl_w2"><input type="text" name="totalAmt" id="totalamt" readonly="readonly" value="${stkZzcx.totalAmt}"/></div></td>
								<td>组装金额：</td>
								<td ><div class="pcl_input_box pcl_w2"><input type="text"  name="disAmt" id="disamt" readonly="readonly" value="${stkZzcx.disAmt}"/></div></td>
								<td></td>
								<td><input type="hidden"   name="discount" id="discount" value="${stkZzcx.discount}" onchange="countAmt()"/></td>
								
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
				
				<div id="easyTabs" class="easyui-tabs" style="width:auto;height:auto;">
			    <div title="组装商品" style="padding:10px;">
				<div id="tb" style="padding:5px;height:auto">
				<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:dialogSelectWare(0);">添加商品</a>
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
									<td>数量</td>
									<td style="display:${stkZzcx.ioMark eq 1?'none':''}">单价</td>
									<td style="display:${stkZzcx.ioMark eq 1?'none':''}">金额</td>
									<td>操作</td>
								</tr>
							</thead>
							<tbody id="chooselist">
								<c:forEach items="${stkZzcx.subList}" var="item" varStatus="s">
  								<tr>
								<td style="padding-left: 20px;text-align: left;"><img src="<%=basePath %>/resource/stkstyle/img/icon19.jpg"class="pcl_ic"/>
								<input id="wareId${s.index }" type="hidden" name="subList[${s.index }].wareId" value = "${item.wareId}"/> 
							    <input id="wareCode${s.index }" name="subList[${s.index }].wareCode" readonly="readonly" type="text" style="width: 150px" class="pcl_i2" value="${item.wareCode}"/>
								 </td>
								<td>
								 <input id="wareNm${s.index }" name="subList[${s.index }].wareNm" readonly="readonly" type="text" style="width: 150px" class="pcl_i2" value="${item.wareNm}"/>
								</td>
								<td>
								 <input id="wareGg${s.index }" name="subList[${s.index }].wareGg" readonly="readonly" type="text" class="pcl_i2" value="${item.wareGg}"/>
								</td>
								<td>
								<select id="beUnitMain${s.index }" name="subList[${s.index }].beUnit" class="pcl_sel2" onchange="changeRelaUnit(this,${s.index })">
        						<option value="${item.maxUnitCode}">${item.wareDw}</option>
        						<option value="${item.minUnitCode}">${item.minUnit}</option>
        						</select>
        						<script type="text/javascript">
										document.getElementById("beUnitMain${s.index}").value='${item.beUnit}';
								</script>
								</td>
								<td >
								<input id="qty${s.index }" name="subList[${s.index }].qty" type="text" class="pcl_i2" value="${item.qty}" onchange="countAmt(),resetStkWareTplList(${item.wareId},this)"/>
								</td>
								<td style="display:${stkZzcx.ioMark eq 1?'none':''}">
								<input id="price${s.index }" name="subList[${s.index }].price" type="text" class="pcl_i2" value="${item.price}" onchange="countAmt()"/>
								</td>
								<td style="display:${stkZzcx.ioMark eq 1?'none':''}">
								<input id="amt${s.index }" name="subList[${s.index }].amt" readonly="readonly" type="text" class="pcl_i2" value="${item.amt}" />
								</td>
								<td style="display:none"><input id="hsNum${s.index }" name="subList[${s.index }].hsNum" type="hidden" class="pcl_i2" value="${item.hsNum}"/></td>
								<td style="display:none"><input id="unitName${s.index }" name="subList[${s.index }].unitName" type="hidden" class="pcl_i2" value="${item.unitName}" /></td>
								<td><a href="javascript:;"onclick="deleteChoose(this);" class="pcl_del">删除</a></td>
								</tr>
								<script>
									map.put('${item.wareId}','${item.wareNm}');
								</script>
 								</c:forEach>
							</tbody>
						</table>
					</div>
				</div>
				</div>
				 <div title="关联原料" style="padding:10px;">
				 <div id="tb2" style="padding:5px;height:auto">
				<%--<a class="easyui-linkbutton" iconCls="icon-add" id="mateBtnId" style="display:${(empty stkZzcx.id or stkZzcx.id eq 0)?'':'none' }" plain="true" href="javascript:dialogSelectWare(1);">添加商品</a>--%>

					 <a class="easyui-linkbutton" iconCls="icon-add" id="mateBtnId" style="display:${(empty stkZzcx.id or stkZzcx.id eq 0)?'':'none' }" plain="true" href="javascript:dialogSelectWare(1);">添加商品</a>
				</div>
				<div class="pcl_ttbox1 clearfix">
					<div class="pcl_lfbox1">
						<table id="more_list1">
							<thead>
								<tr>
									<td>产品编号</td>
									<td>产品名称</td>
									<td>产品规格</td>
									<td>单位</td>
									<td>数量</td>
									<td style="display:${stkZzcx.ioMark eq 1?'none':''}">单价</td>
									<td style="display:${stkZzcx.ioMark eq 1?'none':''}">金额</td>
									<td>组装产品</td>
									<td>操作</td>
								</tr>
							</thead>
							<tbody id="chooselist">
								<c:forEach items="${stkZzcx.itemList}" var="item" varStatus="s">
  								<tr>
								<td style="padding-left: 20px;text-align: left;"><img src="<%=basePath %>/resource/stkstyle/img/icon19.jpg"class="pcl_ic"/>
								<input id="wareId${s.index }" type="hidden" name="itemList[${s.index }].wareId" value = "${item.wareId}"/> 
							    <input id="wareCode${s.index }" name="itemList[${s.index }].wareCode" readonly="readonly" type="text" style="width: 150px" class="pcl_i2" value="${item.wareCode}"/>
								 </td>
								<td>
								 <input id="wareNm${s.index }" name="itemList[${s.index }].wareNm" readonly="readonly" type="text" style="width: 150px" class="pcl_i2" value="${item.wareNm}"/>
								</td>
								<td>
								 <input id="wareGg${s.index }" name="itemList[${s.index }].wareGg" readonly="readonly" type="text" class="pcl_i2" value="${item.wareGg}"/>
								</td>
								<td>
								<select id="beUnit${s.index }" name="itemList[${s.index }].beUnit" class="pcl_sel2" onchange="changeUnit(this,${s.index })">
        						<option value="${item.maxUnitCode}">${item.wareDw}</option>
        						<option value="${item.minUnitCode}">${item.minUnit}</option>
        						</select>
        						<script type="text/javascript">
										document.getElementById("beUnit${s.index}").value='${item.beUnit}';
								</script>
								</td>
								<td >
								<input id="qty${s.index }" name="itemList[${s.index }].qty" type="text" class="pcl_i2" value="${item.qty}" onchange="countRelaAmt()"/>
								</td>
								<td style="display:${stkZzcx.ioMark eq 1?'none':''}">
								<input id="price${s.index }" name="itemList[${s.index }].price" type="text" class="pcl_i2" value="${item.price}" onchange="countRelaAmt()"/>
								</td>
								<td style="display:${stkZzcx.ioMark eq 1?'none':''}" >
								<input id="amt${s.index }" name="itemList[${s.index }].amt" readonly="readonly" type="text" class="pcl_i2" value="${item.amt}" />
								</td>
								<td>
									<select  id="relaWareId${s.index }" name="itemList[${s.index }].relaWareId" class="pcl_sel2">
										<c:forEach items="${stkZzcx.subList}" var="sub">
											<option value="${sub.wareId}"}>${sub.wareNm}</option>
										</c:forEach>
									</select>
									<script>
										document.getElementById("relaWareId${s.index}").value='${item.relaWareId}';
									</script>
								</td>
								<td style="display:none"><input id="hsNum${s.index }" name="itemList[${s.index }].hsNum" type="hidden" class="pcl_i2" value="${item.hsNum}"/></td>
								<td style="display:none"><input id="unitName${s.index }" name="itemList[${s.index }].unitName" type="hidden" class="pcl_i2" value="${item.unitName}" /></td>
								<td  ><a href="javascript:;" class="delMateClass" style="display:${(empty stkZzcx.id)?'':'none' }" onclick="deleteChoose(this);" >删除</a></td>
								</tr>
 								</c:forEach>
							</tbody>
						</table>
					</div>
				</div>
				</div>	
			</div>
		
				</div>
		 <div id="wareDlg" closed="true" class="easyui-dialog" style="width:500px; height:200px;" title="商品选择" iconCls="icon-edit">
        </div>
        </form>
	</body>
	<script src="<%=basePath %>/resource/stkstyle/js/lCalendar.js" type="text/javascript" charset="utf-8"></script>
	<script type="text/javascript">
	var isModify = false;
	Array.prototype.remove = function(s) {
		for (var i = 0; i < this.length; i++) {
			if (s == this[i])
				this.splice(i, 1);
		}
	}
	$("#stkId").change(function(){
		var index = this.selectedIndex;
		var this_val = this.options[index].text;
		$("#stkName").val(this_val);
		$(this).siblings('span').text(this_val);
		isModify = true;
	});
	$("#stkInId").change(function(){
		var index = this.selectedIndex;
		var this_val = this.options[index].text;
		$("#stkInName").val(this_val);
		$(this).siblings('span').text(this_val);
		isModify = true;
	});
	
	var flag=0;
	function dialogSelectWare(t){
		   flag = t;
		   var stkInId = $("#stkInId").val();
			if(stkInId == ""){
				alert("请选择原料仓库!");
				return;
			}
		   var  stkId = $("#stkId").val();
			if(stkId == ""){
				alert("请选择拆装仓库!");
				return;
			}
			if(t==1){
				stkId = stkInId;
			}
			var url = "<%=basePath %>/manager/dialogWareType?stkId="+stkId;
	    	$('#wareDlg').dialog({
	            title: '商品选择',
	            iconCls:"icon-edit",
	            width: 800,
	            height: 400,
	            modal: true,
	            href: url,
	            onClose: function(){
	            }
	        });
	    	$('#wareDlg').dialog('open');
	  }
	
	function callBackFun(json){
		var size = json.list.length;
		if(size>0){
			for(var i=0;i<size;i++){
				if(flag==1){
					setRelaTabRowData(json.list[i]);	
				}else{
				setTabRowData(json.list[i]);
				}
			}
		}
	}
	var rowIndex=1000;
	function setTabRowData(json){
		if(map.containsKey(json.wareId)){
			return;
		}else{
			map.put(json.wareId,json.wareNm);
			var trList = $("#more_list1 #chooselist").children("tr");
			if(trList.length>0){
				  $("select[name$='relaWareId']").append("<option value='"+json.wareId+"'>"+json.wareNm+"</option>");;
			}
		}
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
		var down = $("#more_list").find("tr").length ;
		down = down-1;
		$("#more_list tbody").append(
				'<tr>'+
					'<td style="padding-left: 20px;text-align: left;"><img src="<%=basePath %>/resource/stkstyle/img/icon19.jpg" class="pcl_ic"/>'+
					'<input type="hidden" id="wareId'+rowIndex+'" name="subList['+down+'].wareId" value = "' + wareId + '"/>'+
					'<input type="text" class="pcl_i2" readonly="readonly" style="width: 150px"  id="wareCode'+rowIndex+'" name="subList['+down+'].wareCode" value = "' + wareCode + '"/></td>'+
					'<td><input type="text" class="pcl_i2" readonly="readonly" style="width: 150px"  id="wareNm'+rowIndex+'" name="subList['+down+'].wareNm" value = "' + wareName + '"/></td>'+
					'<td><input type="text" class="pcl_i2" readonly="readonly" id="wareGg'+rowIndex+'" name="subList['+down+'].wareGg" value = "' + wareGg + '"/></td>'+
					'<td>' +  
					'<select id="beUnit'+rowIndex+'" name="subList['+down+'].beUnit" class="pcl_sel2" onchange="changeUnit(this,'+rowIndex+')">'+
					'<option value="'+maxUnitCode+'" checked>'+unitName+'</option>'+
					'<option value="'+minUnitCode+'">'+minUnit+'</option>'+
					'</select>'
					+ '</td>'+
					'<td><input id="qty'+rowIndex+'" name="subList['+down+'].qty" type="text" class="pcl_i2" value="1" onchange="countAmt(),resetStkWareTplList('+wareId+',this)"/></td>'+
					'<td style="display:'+priceDisplay+'"><input id="price'+rowIndex+'"  name="subList['+down+'].price" type="text" class="pcl_i2" value="' + price + '" onchange="countAmt()"/></td>'+
					'<td style="display:'+amtDisplay+'"><input id="amt'+rowIndex+'" readonly="readonly" name="subList['+down+'].amt" type="text" class="pcl_i2" value="1" value="' + price + '"/></td>'+
					'<td style="display:none"><input id="hsNum'+rowIndex+'" name="subList['+down+'].hsNum" type="hidden" class="pcl_i2" value="'+hsNum+'"/></td>'+
					'<td style="display:none"><input id="unitName'+rowIndex+'" name="subList['+down+'].unitName" type="hidden" class="pcl_i2" value="'+unitName+'" /></td>'+
					'<td><a href="javascript:;"onclick="deleteChoose(this);" class="pcl_del">删除</a></td>'+
				'</tr>'
			);
		rowIndex++;
		countAmt();
		var len = $("#more_list").find("tr").length ;
		var row = $("#more_list tbody tr").eq(len-2);
		/************如果商品信息中有设置默认选中辅助单位，那么就选中设置选中辅助 开始***********/
		if(sunitFront=="1"){
			$(row).find("select[name$='beUnit']").val(minUnitCode);
			$(row).find("select[name$='beUnit']").trigger("change");
		}
		/************如果商品信息中有设置默认选中辅助单位，那么就选中设置选中辅助 结束***********/
		getStkWareTplList(wareId);
	}
	
	
	function setRelaTabRowData(json){
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
		var relaWareId = json.relaWareId;
		var qty=1;
		if(relaWareId!=undefined&&relaWareId!=""){
			qty = json.stkQty;
		}
		var down = $("#more_list1").find("tr").length ;
		down = down-1;
		var op = "";
		var k = 0;
	    for(var o in map.keys){
	    	var key = map.keys[o];
	    	 var checked = '';
	    	 if(k==0&&relaWareId==undefined){
	    		 checked = 'selected="selected"';
	    	 }
	    	 if(relaWareId!=undefined&&relaWareId!=""&&key==relaWareId){
	    		 checked = 'selected="selected"';
	    	 }
	    	 if(key==undefined||map.get(key)==undefined){
	    		 continue;
	    	 }
			 op+="<option value="+key+" "+checked+">"+map.get(key)+"</option>";
		} 
		$("#more_list1 tbody").append(
				'<tr>'+
					'<td style="padding-left: 20px;text-align: left;"><img src="<%=basePath %>/resource/stkstyle/img/icon19.jpg" class="pcl_ic"/>'+
					'<input type="hidden" id="wareId'+rowIndex+'" name="itemList['+down+'].wareId" value = "' + wareId + '"/>'+
					'<input type="text" class="pcl_i2" readonly="readonly" style="width: 150px"  id="wareCode'+rowIndex+'" name="itemList['+down+'].wareCode" value = "' + wareCode + '"/></td>'+
					'<td><input type="text" class="pcl_i2" readonly="readonly" style="width: 150px"  id="wareNm'+rowIndex+'" name="itemList['+down+'].wareNm" value = "' + wareName + '"/></td>'+
					'<td><input type="text" class="pcl_i2" readonly="readonly" id="wareGg'+rowIndex+'" name="itemList['+down+'].wareGg" value = "' + wareGg + '"/></td>'+
					'<td>' +  
					'<select id="beUnit'+rowIndex+'" name="itemList['+down+'].beUnit" class="pcl_sel2" onchange="changeRelaUnit(this,'+rowIndex+')">'+
					'<option value="'+maxUnitCode+'" checked>'+unitName+'</option>'+
					'<option value="'+minUnitCode+'">'+minUnit+'</option>'+
					'</select>'
					+ '</td>'+
					'<td><input id="qty'+rowIndex+'" name="itemList['+down+'].qty" type="text" class="pcl_i2" value="'+qty+'" onchange="countRelaAmt()"/></td>'+
					'<td style="display:'+priceDisplay+'"><input id="price'+rowIndex+'"  name="itemList['+down+'].price" type="text" class="pcl_i2" value="' + price + '" onchange="countRelaAmt()"/></td>'+
					'<td style="display:'+amtDisplay+'"><input id="amt'+rowIndex+'" readonly="readonly" name="itemList['+down+'].amt" type="text" class="pcl_i2" value="1" value="' + price + '"/></td>'+
					'<td style="display:none"><input id="hsNum'+rowIndex+'" name="itemList['+down+'].hsNum" type="hidden" class="pcl_i2" value="'+hsNum+'"/></td>'+
					'<td style="display:none"><input id="unitName'+rowIndex+'" name="itemList['+down+'].unitName" type="hidden" class="pcl_i2" value="'+unitName+'" /></td>'+
					'<td>' +  
					'<select id="relaWareId'+rowIndex+'" name="itemList['+down+'].relaWareId" class="pcl_sel2" >'+
					op
					+ '</td>'+
					'<td><a href="javascript:;" class="delMateClass" onclick="deleteChooseRela(this);">删除</a></td>'+
				'</tr>'
			);
		rowIndex++;
		countRelaAmt();
		var len = $("#more_list1").find("tr").length ;
		var row = $("#more_list1 tbody tr").eq(len-2);
		/************如果商品信息中有设置默认选中辅助单位，那么就选中设置选中辅助 开始***********/
		var	beUnit = json.beUnit;
		$(row).find("select[name$='beUnit']").val(beUnit);
		$(row).find("select[name$='beUnit']").trigger("change");

		// if(sunitFront=="1"){
		// 	$(row).find("select[name$='beUnit']").val(minUnitCode);
		// 	$(row).find("select[name$='beUnit']").trigger("change");
		// }
		/************如果商品信息中有设置默认选中辅助单位，那么就选中设置选中辅助 结束***********/
	}
	
	function countAmt(){
		var total = 0;
		var sumQty = 0;
		var trList = $("#more_list #chooselist").children("tr");
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
		isModify = true;
	}
	
	function countRelaAmt(){
		var total = 0;
		var sumQty = 0;
		var trList = $("#more_list1 #chooselist").children("tr");
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
		isModify = true;
	}
	function changeRelaUnit(o,index){
		var trList = $("#more_list1 #chooselist").children("tr");
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
	function changeUnit(o,index){
		var trList = $("#more_list #chooselist").children("tr");
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
	
	function checkWare(wareId){
		var trList = $("#more_list1 #chooselist").children("tr");
		var bool = false;
		if(trList.length>0){
			for(var i=0;i<trList.length;i++){
				var tdArr = trList.eq(i);
				var rwId =  $(tdArr).find("select[name$='relaWareId']").val();
				if(rwId==wareId){
					bool = true;
					break;
				}
			}
		}
		return bool;
	}
	
	
	function deleteChoose(lineObj)
	{
		var status = $("#status").val();
		if(status > 0)return;
		if(confirm('确定删除？')){
			 var wareId = $($(lineObj).parents('tr')).find("input[name$='wareId']").val();
			 if(map.containsKey(wareId)){
				 map.remove(wareId);
			 }
			var trList = $("#more_list1 #chooselist").children("tr");
			if(trList.length>0){
				for(var i=0;i<trList.length;i++){
					var tdArr = trList.eq(i);
					var rwId =  $(tdArr).find("select[name$='relaWareId']").val();
					if(rwId==wareId){
						$(tdArr).remove();
					}
				}
			    $("select[name$='relaWareId'] option").each(function(){
			    	   if($(this).val() == wareId){
			    	   	 $(this).remove();
			    	   }
			   });
			    resetTabRelaIndex();
			}
			$(lineObj).parents('tr').remove();
			countAmt();
			resetTabIndex();
		}
	}
	function deleteChooseRela(lineObj)
	{
		var status = $("#status").val();
		if(status > 0)return;
		if(confirm('确定删除？')){
			//alert(lineObj.innerHTML);
			$(lineObj).parents('tr').remove();
			resetTabRelaIndex();
		}
	}
	
	function resetTabIndex(){
		var trList = $("#more_list #chooselist").children("tr");
		for(var i=0;i<trList.length;i++){
			var tdArr = trList.eq(i);
			 $(tdArr).find("input[name$='wareId']").attr("name","subList["+i+"].wareId");
			 $(tdArr).find("input[name$='wareCode']").attr("name","subList["+i+"].wareCode");
			 $(tdArr).find("input[name$='wareNm']").attr("name","subList["+i+"].wareNm");
			 $(tdArr).find("input[name$='wareGg']").attr("name","subList["+i+"].wareGg");
			 $(tdArr).find("select[name$='beUnit']").attr("name","subList["+i+"].beUnit");
			 $(tdArr).find("input[name$='qty']").attr("name","subList["+i+"].qty");
			 $(tdArr).find("input[name$='price']").attr("name","subList["+i+"].price");
			 $(tdArr).find("input[name$='amt']").attr("name","subList["+i+"].amt");
			 $(tdArr).find("input[name$='hsNum']").attr("name","subList["+i+"].hsNum");
			 $(tdArr).find("input[name$='unitName']").attr("name","subList["+i+"].unitName");
			 $(tdArr).find("input[name$='wareNm']").attr("name","subList["+i+"].wareNm");
		}
	}
	
	function resetTabRelaIndex(){
		var trList = $("#more_list1 #chooselist").children("tr");
		for(var i=0;i<trList.length;i++){
			var tdArr = trList.eq(i);
			 $(tdArr).find("input[name$='wareId']").attr("name","itemList["+i+"].wareId");
			 $(tdArr).find("input[name$='wareCode']").attr("name","itemList["+i+"].wareCode");
			 $(tdArr).find("input[name$='wareNm']").attr("name","itemList["+i+"].wareNm");
			 $(tdArr).find("input[name$='wareGg']").attr("name","itemList["+i+"].wareGg");
			 $(tdArr).find("select[name$='beUnit']").attr("name","itemList["+i+"].beUnit");
			 $(tdArr).find("input[name$='qty']").attr("name","itemList["+i+"].qty");
			 $(tdArr).find("input[name$='price']").attr("name","itemList["+i+"].price");
			 $(tdArr).find("input[name$='amt']").attr("name","itemList["+i+"].amt");
			 $(tdArr).find("input[name$='hsNum']").attr("name","itemList["+i+"].hsNum");
			 $(tdArr).find("input[name$='unitName']").attr("name","itemList["+i+"].unitName");
			 $(tdArr).find("select[name$='relaWareId']").attr("name","itemList["+i+"].relaWareId");
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
				alert("请选择拆装仓库!");
				return false;
			}
			var  stkInId = $("#stkInId").val();
			if(stkInId == ""){
				alert("请选择原料仓库!");
				return false;
			}
			var trList = $("#more_list #chooselist").children("tr");
			if(trList.length==0){
				alert("请添加明细!");
				return false;
			}
			if(trList.length>1){
				alert("组装产品只能选择一个！");
				return false;
			}
			for(var i=0;i<trList.length;i++){
				var tdArr = trList.eq(i);
				var wareNm= $(tdArr).find("input[name$='wareNm']").val();
				if(wareNm==""){
					alert("第"+(i+1)+"行请输入商品!");
				}
				var wareId=  $(tdArr).find("input[name$='wareId']").val();
				var bool = checkWare(wareId);
		    	if(!bool){
		    		alert("商品"+wareNm+"未关联原料!不能保存！");
		    		return;
		    	}
		    	if('${stkZzcx.ioMark}'=='-1'){
		    		var amt = $(tdArr).find("input[name$='amt']").val();
			    	var totalSubAmt = 0;
			    	 $("select[name$='relaWareId']").each(function(){
				    	   if($(this).val() == wareId){
				    		   var currRow=this.parentNode.parentNode;
				 		 	   var subAmt= $(currRow).find("input[name$='amt']").val();
				 		 	   totalSubAmt = totalSubAmt + parseFloat(subAmt);
				    	   }});
			    	 if(amt!=totalSubAmt){
			    		 alert("商品"+wareNm+"的金额，不等于关联原料的金额"); 
			    		 return;
			    	 }
		    	}
			}
		if(!confirm('是否确定暂存？'))return;
		$("#savefrm").form('submit',{
			success:function(data){
				var json = eval("("+data+")");
				if(json.state){
	        		$("#billId").val(json.id);
	        		$("#billNo").val(json.billNo);
	        		$("#status").val(json.status);
					$("#btnaudit").show();
	        		$("#billstatus").val("暂存成功");
					isModify =  false;
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
			        url: "<%=basePath %>/manager/stkZzcx/audit",
			        type: "POST",
			        data : {"billId":billId},
			        dataType: 'json',
			        async : false,
			        success: function (json) {
			        	if(json.state){
			        		$("#status").val(1);
							$("#btnaudit").hide();
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
			        url: "<%=basePath %>/manager/stkZzcx/cancel",
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
    	location.href='<%=basePath %>/manager/stkZzcx/add?bizType=${stkZzcx.bizType}';
    }
	function print()
    {
    	location.href='<%=basePath %>/manager/stkZzcx/print?billId='+'${stkZzcx.id}';
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
		isModify=false;
	}) 
	
	
	function getStkWareTplList(relaWareId){
		$.ajax({
	        url: "<%=basePath %>/manager/stkZzcx/getStkWareTplList",
	        type: "POST",
	        data:{"relaWareId":relaWareId},
	        dataType: 'json',
	        async : false,
	        success: function (json) {
	        		if(json.list!=undefined){
	        			var size = json.list.length;
						var relaBeUnit = "B";
	        			for(var i=0;i<size;i++){
	        				var row = json.list[i];
	        				var data = {
	        						wareId:row.wareId,
	        						wareNm:row.wareNm,
	        						wareGg:row.wareGg,
	        						wareCode:row.wareCode,
	        						wareDw:row.wareDw,
	        						minUnit:row.minUnit,
	        						minUnitCode:row.minUnitCode,
	        						maxUnitCode:row.maxUnitCode,
	        						hsNum:row.hsNum,
	        						stkQty:row.stkQty,
	        						price:row.inPrice,
	        						sunitFront:row.sunitFront,
	        						relaWareId:relaWareId,
									beUnit:row.beUnit,
								    relaBeUnit:row.relaBeUnit
	        				};
	        				setRelaTabRowData(data);
							relaBeUnit = row.relaBeUnit;
	        			}
	        			if(size>0){
							$("#more_list #chooselist input[name$='wareId']").each(function () {
								var wareId = $(this).val();
								if(wareId==relaWareId){
									var currRow =  $(this).closest('tr');
									$(currRow).find("select[name$='beUnit']").val(relaBeUnit);
									$(currRow).find("select[name$='beUnit']").trigger("change");
								}
							});
							// $("#mateBtnId").hide();
							// $(".delMateClass").hide();
						}
	        		}
	        }
	    })
	}
	/**
		当拆装商品改变时，自动按比例更新原料的数量
	**/
	function resetStkWareTplList(relaWareId,o){
		var qty = o.value;
		if(qty==""){
			qty=0;
		}
		$.ajax({
	        url: "<%=basePath %>/manager/stkZzcx/getStkWareTplList",
	        type: "POST",
	        data:{"relaWareId":relaWareId},
	        dataType: 'json',
	        async : false,
	        success: function (json) {
	        		if(json.list!=undefined){
	        			var size = json.list.length;
	        			for(var i=0;i<size;i++){
	        				var row = json.list[i];
	        				var trList = $("#more_list1 #chooselist").children("tr");
	        				if(trList.length>0){
	        					for(var j=0;j<trList.length;j++){
	        						var tdArr = trList.eq(j);
	        						var wareId =  $(tdArr).find("input[name$='wareId']").val();
	        						var rwId =  $(tdArr).find("select[name$='relaWareId']").val();
	        						//alert(wareId+":"+row.wareId+"-"+rwId+":"+relaWareId);
	        						if(rwId==relaWareId&&wareId==row.wareId){
	        							var totalQty = parseFloat(qty)*parseFloat(row.stkQty);
	        							$(tdArr).find("input[name$='qty']").val(totalQty.toFixed(2));
	        							break;
	        						} 
	        					}
	        				}
	        			}
	        			countRelaAmt();
	        		}
	        }
	    })
	}
	</script>
	<%@include file="/WEB-INF/page/include/handleFile.jsp"%>
</html>