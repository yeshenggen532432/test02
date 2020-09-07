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
		<title>材料配方表</title>
		<meta name="description" content="">
		<meta name="keywords" content="">
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
		<form action="<%=basePath %>/manager/stkProduceWareTpl/save" name="savefrm" id="savefrm" method="post">
		<input type="hidden" name="bizType" id="bizType"/>
		<div class="center" >
			<div class="pcl_lib_out">
				<div id="easyTabs" class="easyui-tabs" style="margin-left: 3px">
			    <div title="主产品" style="padding:10px;">
				<div id="tb" style="padding:5px;height:auto">
			<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:dialogSelectWare(0);">添加主产品</a>
				</div>
				<div class="pcl_ttbox1 clearfix">
					<div class="pcl_lfbox1" style="height: 350px;overflow: auto;">
						<table id="more_list">
							<thead>
								<tr>
									<td>产品名称</td>
									<td>单位</td>
									<td>操作</td>
								</tr>
							</thead>
							<tbody id="chooselist">
							</tbody>
						</table>
					</div>
				</div>
				</div>
				 <div title="原料" style="padding:10px;">
				 <div id="tb2" style="padding:5px;height:auto">
			<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:dialogSelectWare(1);">添加原料</a>
				</div>
				<div class="pcl_ttbox1 clearfix">
					<div class="pcl_lfbox1"  style="height: 350px;overflow: auto;">
						<table id="more_list1">
							<thead>
								<tr>
									<td>主产品</td>
									<td>原料编号</td>
									<td>原料名称</td>
                                    <td>原来单位</td>
									<td>原料规格</td>
									<td>配比数量</td>
									<td>操作</td>
								</tr>
							</thead>
							<tbody id="chooselist">
							<c:forEach items="${itemList}" var="item" varStatus="s">
								<tr>
									<td>
										<select  id="relaWareId${s.index }" name="itemList[${s.index }].relaWareId" class="pcl_sel2">
										</select>
										<input id="relaWareNm${s.index }" type="hidden"  name="itemList[${s.index }].relaWareNm"  class="pcl_i2" />
										<input type="hidden" id="relaUnitName${s.index }" name="itemList[${s.index }].relaUnitName" />
										<input type="hidden" id="relaBeUnit${s.index }" name="itemList[${s.index }].relaBeUnit"/>
									</td>
									<td style="padding-left: 20px;text-align: left;">
										<input id="wareId${s.index }" type="hidden" name="itemList[${s.index }].wareId" value = "${item.wareId}"/>
										<input id="wareCode${s.index }" name="itemList[${s.index }].wareCode" readonly="readonly" type="text" style="width: 150px" class="pcl_i2" value="${item.wareCode}"/>
									</td>
									<td>
										<input id="wareNm${s.index }" name="itemList[${s.index }].wareNm" readonly="readonly" type="text" style="width: 150px" class="pcl_i2" value="${item.wareNm}"/>
									</td>
									<td>
										<select id="beUnit${s.index }" name="itemList[${s.index }].beUnit" style="width:50px" class="pcl_sel2">
											<option value="${item.maxUnitCode}" <c:if test="${item.beUnit == 'B'}"> selected</c:if>>${item.wareDw}</option>
											<option value="${item.minUnitCode}" <c:if test="${item.beUnit == 'S'}"> selected</c:if>>${item.minUnit}</option>
										</select>
									</td>
									<td>
										<input id="wareGg${s.index }" name="itemList[${s.index }].wareGg" readonly="readonly" type="text" class="pcl_i2" value="${item.wareGg}"/>
									</td>
									<td style="display:none"><input id="unitName${s.index }" name="itemList[${s.index }].unitName" type="hidden" class="pcl_i2" value="${item.unitName}" /></td>
									<td >
										<input id="qty${s.index }" name="itemList[${s.index }].qty" type="text" class="pcl_i2" value="${item.qty}" onchange="countRelaAmt()"/>
									</td>
									<td><a href="javascript:;"onclick="deleteChooseRela(this);" class="pcl_del">删除</a></td>
								</tr>
							</c:forEach>
							</tbody>
						</table>
					</div>
				</div>
				</div>	
			&nbsp;&nbsp;&nbsp;&nbsp;	<a class="easyui-linkbutton" iconCls="icon-save" plain="true" href="javascript:submitStk();">保存</a>
				</div>
		 <div id="wareDlg" closed="true" class="easyui-dialog" style="width:500px; height:200px;" title="商品选择" iconCls="icon-edit">
        </div>
        </form>
	</body>
	<script src="<%=basePath %>/resource/stkstyle/js/lCalendar.js" type="text/javascript" charset="utf-8"></script>
	<script type="text/javascript">
	Array.prototype.remove = function(s) {
		for (var i = 0; i < this.length; i++) {
			if (s == this[i])
				this.splice(i, 1);
		}
	}
	var flag=0;
	function dialogSelectWare(t){
		   flag = t;
			var url = "<%=basePath %>/manager/dialogWareType?stkId=0";
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
					'<td style="padding-left: 20px;text-align: left;display:none">'+
					'<input type="hidden" id="wareId'+rowIndex+'" name="subList['+down+'].wareId" value = "' + wareId + '"/>'+
					'<td><input type="text" class="pcl_i2" readonly="readonly" style="width: 150px"  id="wareNm'+rowIndex+'" name="subList['+down+'].wareNm" value = "' + wareName + '"/></td>'+
					'<td>' +
					'<select id="beUnit'+rowIndex+'" name="subList['+down+'].beUnit" class="pcl_sel2">'+
					'<option value="'+maxUnitCode+'" checked>'+unitName+'</option>'+
					'<option value="'+minUnitCode+'">'+minUnit+'</option>'+
					'</select>'
					+ '</td>'+
				'<td><a href="javascript:;"onclick="deleteChoose(this);" class="pcl_del">删除</a></td>'+
				'</tr>'
			);
		rowIndex++;
	}
	
	
	function setRelaTabRowData(json){
		var wareId = json.wareId;
		var wareCode = json.wareCode;
		var wareName = json.wareNm;
		var wareGg = json.wareGg;
		var relaWareId = json.relaWareId;
		var unitName = json.wareDw;
		var minUnit = json.minUnit;
		var maxUnitCode = json.maxUnitCode;
		var minUnitCode = json.minUnitCode;
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
					'<td>' +  
					'<select id="relaWareId'+rowIndex+'" name="itemList['+down+'].relaWareId" class="pcl_sel2" >'+
					op +
                    '</select>' +
                    '<input type="hidden" id="relaWareNm'+rowIndex+'" name="itemList['+down+'].relaWareNm"/>'+
                     '<input type="hidden" id="relaBeUnit'+rowIndex+'" name="itemList['+down+'].relaBeUnit"/>'+
                    '<input type="hidden" id="relaUnitName'+rowIndex+'" name="itemList['+down+'].relaUnitName"/>'+
					'</td>'+
					'<td style="padding-left: 20px;text-align: left;">'+
					'<input type="hidden" id="wareId'+rowIndex+'" name="itemList['+down+'].wareId" value = "' + wareId + '"/>'+
					'<input type="text" class="pcl_i2" readonly="readonly" style="width: 150px"  id="wareCode'+rowIndex+'" name="itemList['+down+'].wareCode" value = "' + wareCode + '"/></td>'+
					'<td><input type="text" class="pcl_i2" readonly="readonly" style="width: 150px"  id="wareNm'+rowIndex+'" name="itemList['+down+'].wareNm" value = "' + wareName + '"/></td>'+
					'<td>' +
					'<select id="beUnit'+rowIndex+'" name="itemList['+down+'].beUnit" class="pcl_sel2">'+
					'<option value="'+maxUnitCode+'" checked>'+unitName+'</option>'+
					'<option value="'+minUnitCode+'">'+minUnit+'</option>'+
					'</select>'+
                     '<input type="hidden" id="unitName'+rowIndex+'" name="itemList['+down+'].unitName" value="'+unitName+'"/>'
					+ '</td>'+
					'<td><input type="text" class="pcl_i2" readonly="readonly" id="wareGg'+rowIndex+'" name="itemList['+down+'].wareGg" value = "' + wareGg + '"/></td>'+
					'<td><input id="qty'+rowIndex+'" name="itemList['+down+'].qty" type="text" class="pcl_i2" value="'+qty+'" onchange="countRelaAmt()"/></td>'+
					'<td><a href="javascript:;"onclick="deleteChooseRela(this);" class="pcl_del">删除</a></td>'+
				'</tr>'
			);
		rowIndex++;
		countRelaAmt();
	}

	function countRelaAmt(){
		var total = 0;
		var sumQty = 0;
		var trList = $("#more_list1 #chooselist").children("tr");
		for (var i=0;i<trList.length;i++) {
		    var tr = trList.eq(i)
		    var wareId = $(tr).find("input[name$='wareId']").val();
		    var qty = $(tr).find("input[name$='qty']").val();
		    if(qty == "")break;
		    sumQty = sumQty + qty*1;
		    if(wareId == 0)continue;
		}
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
		}
	}
	function deleteChooseRela(lineObj)
	{
		if(confirm('确定删除？')){
			//alert(lineObj.innerHTML);
			$(lineObj).parents('tr').remove();
			resetTabRelaIndex();
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
			 $(tdArr).find("input[name$='qty']").attr("name","itemList["+i+"].qty");
			 $(tdArr).find("select[name$='beUnit']").attr("name","itemList["+i+"].beUnit");
		  	 $(tdArr).find("input[name$='unitName']").attr("name","itemList["+i+"].unitName");
			 $(tdArr).find("input[name$='relaWareNm']").attr("name","itemList["+i+"].relaWareNm");
			 $(tdArr).find("select[name$='relaWareId']").attr("name","itemList["+i+"].relaWareId");
		}
	}
	
	function submitStk(){
			var trList = $("#more_list #chooselist").children("tr");
			if(trList.length==0){
				alert("请添加明细!");
				return false;
			}

			for(var i=0;i<trList.length;i++){
				var tdArr = trList.eq(i);
				var wareNm= $(tdArr).find("input[name$='wareNm']").val();
                var beUnit= $(tdArr).find("select[name$='beUnit']").val();
                var unitName= $(tdArr).find("select[name$='beUnit']").find("option:selected").text();
				if(wareNm==""){
					alert("第"+(i+1)+"行请输入商品!");
					return
				}
				var wareId=  $(tdArr).find("input[name$='wareId']").val();
				var bool = checkWare(wareId);
		    	if(!bool){
		    		alert("商品"+wareNm+"未关联原料!不能保存！");
		    		return;
		    	}
		    	var  mm = new Map();
				 $("select[name$='relaWareId']").each(function(){
					   if($(this).val() == wareId){
						   var currRow=this.parentNode.parentNode;
						   var mmWareId =   $(currRow).find("input[name$='wareId']").val();
						   if(mm.containsKey(mmWareId)){
							   bool =false;
						   }
						   $(currRow).find("input[name$='relaWareNm']").val(wareNm);
						   $(currRow).find("input[name$='relaBeUnit']").val(beUnit);
						   $(currRow).find("input[name$='relaUnitName']").val(unitName);
						   var tx = $(currRow).find("select[name$='beUnit']").find("option:selected").text();
						   $(currRow).find("input[name$='unitName']").val(tx);
						   mm.put(mmWareId,"1");
					   }});
				if(!bool){
					alert("商品"+wareNm+"关联的原料有重复!!不能保存！");
					return;
				}
			}
		if(!confirm('保存后将不能修改，是否确定保存？'))return;
		$("#savefrm").form('submit',{
			success:function(data){
				var json = eval("("+data+")");
				if(json.state){
					alert("保存成功！");
	        	}else{
	        		alert(json.msg);
	        	}
			}
		}); 
	}
	

	</script>
	<%@include file="/WEB-INF/page/include/handleFile.jsp"%>
</html>