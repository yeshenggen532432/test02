/**
 * 入库JS基类
 * @type {number}
 */
var enCount=0;
var oneRowSelect = 0;
var selectImg='\<img src="../../resource/images/select.gif" onclick="dialogOneWare(this)" id="selectFpno"   align="absmiddle" style="position:absolute;right:5px;top:5px;">\
';
function gjr_forAuto_toNextCell(obj,field)
{
	if(obj.value==""){
		return;
	}
	var v=window.event.keyCode;
	if(v==13){
		enCount++;
		if(enCount>1){
			var currRow=$(obj).closest('tr');
			var currRowIndex=currRow.rowIndex;
			$(currRow).find("input[name='"+field+"']").focus();
			$(currRow).find("input[name='"+field+"']").select();
			enCount=0;
			if(obj.value==""){
				return;
			}
			var bool = checkSysWareByKeyWord(obj.value);
			if(!bool){
				clearTabRowData("");
				setTimeout(function(){
					$(".messager-body").window('close');
				},1500)
				$(currRow).find("input[name='wareNm']").focus();
				return;
			}
		}
	}
}
function gjr_forAutotr_toNextCell(obj,field)
{
	var v=window.event.keyCode;
	if(v==13)
	{
		var currRow=obj.parentNode;
		var tab=currRow.parentNode;
		var currRowIndex=currRow.rowIndex;
		var nextRowIndex=currRowIndex-1;
		$(currRow).find("input[name='"+field+"']").focus();
		$(currRow).find("input[name='"+field+"']").select();
	}
}
/**
 *摘要：keydown事件，当按enter健时调整到下一个行
 *@说明：
 *@创建：作者:郭建荣
 *@param obj:当前cell对象
 *@param targetField:目标列
 *@param lastColumn: 1:最后一列
 *@param nextRowFun:下一行的相关操作函数，可以缺省（缺省时不执行）
 *@修改历史
 **/
function gjr_toNextRow(obj,targetField,lastColumn,nextRowFun) {
	var v=window.event.keyCode;
	if(v==40||v==13)
	{//下移
		if(v==13&&lastColumn!='1'){
			return;
		}
		var currRow=obj.parentNode;
		var tab=currRow.parentNode;
		var currRowIndex=currRow.rowIndex;
		var nextRowIndex=currRowIndex;
		var row=tab.rows[nextRowIndex];
		if(nextRowFun!=undefined){
		}
		if(lastColumn=="1"){
			var trList = $("#chooselist").children("tr");
			var len = trList.length;
			if(len==currRowIndex){
				addTabRow();
				var e = jQuery.Event("onkeydown");//模拟一个键盘事件
				e.keyCode =13;//keyCode=13是回车
				$(obj).trigger(e);
				enCount=0;
				return;
			}
		}
		var cell=$(row).find("input[name='"+targetField+"']");
		cell.focus();
		$(cell).click();
		cell.focus();
	}
	if(v==38)
	{//上移
		var currRow=obj.parentNode;
		var tab=currRow.parentNode;
		var currRowIndex=currRow.rowIndex;
		var nextRowIndex=currRowIndex-2;
		var row=tab.rows[nextRowIndex];
		if(nextRowFun!=undefined){
		}
		var cell=$(row).find("input[name='"+targetField+"']");
		cell.focus();
		$(cell).click();
		cell.focus();
		var wareId = $(row).find("input[name='wareId']").val()

	}
}


/**
 *摘要：keydown事件，当按enter健时调整到下一个列
 *@说明：
 *@创建：作者:郭建荣
 *@param obj:当前cell对象
 *@param field:目标列
 *@return
 *@修改历史：
 **/
function gjr_toNextCell(obj,field)
{
	var v=window.event.keyCode;
	if(v==13)
	{
		var currRow=obj.parentNode.parentNode;
		var tab=currRow.parentNode;
		var currRowIndex=currRow.rowIndex;
		var nextRowIndex=currRowIndex-1;
		$(currRow).find("input[name='"+field+"']").focus();
		$(currRow).find("input[name='"+field+"']").select();
	}
}

function checkSysWareByKeyWord(keyWord)
{
	var bool = true;
	$.ajaxSettings.async = false;
	var path = basePath+"manager/querySysWarePageByKeyWord";
	$.ajax({
		url: path,
		type: "POST",
		data : {"keyWord":keyWord,"status":1,"page":1,"rows":50},
		dataType: 'json',
		async : false,
		success: function (json) {
			if(json.state){
			}else{
				$.messager.alert('消息','未找到该商品!','info');
				bool = false;
				enCount = 0;
			}
		}
	});
	return bool;
}

function querySysWareByKeyWord(keyWord)
{
	var cstId = $("#cstId").val();
	if(cstId==""){
		$.messager.alert('消息','请先选择客户!','info');
		return;
	}
	var path = "queryStkWarePage1";
	stkId = $("#stkId").val();
	if(stkId == "")stkId = 0;
	$.ajax({
		url: path,
		type: "POST",
		data : {"keyWord":keyWord,"stkId":stkId,"status":1,"customerId":cstId,"page":1,"rows":50},
		dataType: 'json',
		async : false,
		success: function (json) {
			if(json.state){
				var size = json.list.length;
				var data = "";
				for(var i = 0;i < size; i++)
				{
					data = {
						"wareId":json.list[i].wareId,
						"wareNm":json.list[i].wareNm,
						"wareCode":json.list[i].wareCode,
						"maxUnitCode":json.list[i].maxUnitCode,
						"maxNm":json.list[i].wareDw,
						"minUnitCode":json.list[i].minUnitCode,
						"minNm":json.list[i].minUnit,
						"hsNum":json.list[i].hsNum,
						"price":json.list[i].wareDj,
						"stkQty":json.list[i].stkQty,
						"qualityDays":json.list[i].qualityDays,
						"sunitPrice":json.list[i].sunitPrice,
						"productDate":json.list[i].productDate,
						"sunitFront":json.list[i].sunitFront,
						"wareGg":json.list[i].wareGg
					};
					break;
				}
				setTabRowData(data);
			}else{
				$.messager.alert('消息','未找到该商品!','info');
				enCount = 0;
			}
		}
	});
}

function dialogOneWare(obj){
	oneRowSelect=1;
	var currRow=obj.parentNode.parentNode;
	var currRowIndex = currRow.rowIndex;
	curr_row_index = currRowIndex;
	var cstId = $("#cstId").val();
	if(cstId==""){
		$.messager.alert('消息','请先选择客户!','info');
		return;
	}
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
		href: basePath+"/manager/dialogOutWareType?stkId="+stkId+"&op=1&customerId="+cstId,
		onClose: function(){
		}
	});
	$('#wareDlg').dialog('open');
}


function setKendoAutoComplete(id){
	$('#'+id).kendoAutoComplete({
			dataTextField:'wareNm',
			dataValueField:'wareId',
	    	highlightFirst: true,
			dataSource: {//数据源
				serverFiltering: true,
				schema: {
					data: function (response) {
						return response.rows || [];
					}
				},
				transport: {
					read: {
						url: basePath+'/manager/dialogOutWarePage',
						type: 'get',
						data: function(){
							return {
								page:1, rows: 20,
								waretype: '',
								stkId: $('#stkId').val(),
								wareNm: $('#'+id).data('kendoAutoComplete').value(),
								customerId:""
							}
						}
					}
				},
				requestStart:function(e) {
					var stkId = $("#stkId").val();
					if(stkId==""){
						$.messager.alert('消息',"请选择仓库","info");
						setTimeout(function(){
							$(".messager-body").window('close');
						},1000)
						e.preventDefault();
					}
				}
			},
			select: function (e) {//返回值
				var item = e.dataItem;
				var data = {
					"wareId": item.wareId,
					"wareNm": item.wareNm,
					"wareGg": item.wareGg,
					"wareCode": item.wareCode,
					"unitName":item.wareDw,
					"qty":1,
					"price": item.wareDj,
					"stkQty":item.stkQty,
					"sunitFront": item.sunitFront,
					"sunitPrice": item.sunitPrice,
					"maxNm": item.wareDw,
					"minUnitCode": item.minUnitCode,
					"maxUnitCode": item.maxUnitCode,
					"minNm":item.minUnit,
					"hsNum": item.hsNum,
					"inPrice":item.inPrice,
					"productDate":item.productDate,
					"qualityDays":item.qualityDays
				}
				var row =	$('#'+id).closest('tr');
				if($("#changeNewHisPrice").val()!=undefined&&$("#changeNewHisPrice").is(":checked")== true){
					setCustomerHisWarePrice(row,data);
				}else{
					setRowData(row,data);
				}
				var currRowIndex = $(row).index();
				curr_row_index = currRowIndex+1;
			}
		}
	);
}

function checkInPrice(){
	var token = $("#tmptoken").val();
	var wareList = new Array();
	var trList = $("#chooselist").children("tr");
	for (var i=0;i<trList.length;i++) {
		var xsTp = "";
		var wareId = trList.eq(i).find("input[name='wareId']").val();
		var qty =trList.eq(i).find("input[name='edtqty']").val();
		var beUnit = trList.eq(i).find("select[name='beUnit']").val();
		var price = trList.eq(i).find("input[name='edtprice']").val();
		var hsNum = trList.eq(i).find("input[name='hsNum']").val();
		var unit = trList.eq(i).find("select[name='beUnit'] option:selected").text();
		var remarks = trList.eq(i).find("input[name='remarks']").val();
		if(qty == "")break;
		if(wareId == 0)continue;
		var subObj = {
			wareId: wareId,
			xsTp: xsTp,
			qty: qty,
			outQty:qty,
			unitName: unit,
			price: price,
			remarks:remarks,
			hsNum:hsNum,
			beUnit:beUnit
		};
		wareList.push(subObj);
	}
	var stkId = $("#stkId").val();
	var bool = true;
	$.ajaxSettings.async = false;
	$.ajax({
		url: basePath+"/manager/checkStorageWare",
		type: "POST",
		data : {"token":token,"stkId":stkId,"wareStr":JSON.stringify(wareList)},
		dataType: 'json',
		async : false,
		success: function (json) {
			if(json!=undefined&&json.state){
				if(json.changeWareIds!=""){
					if(window.confirm("因以下无库存商品未设采购价:"+json.msg2+" 为准确成本核算，建议补充采购价信息，是否去设置")){
						showUpdateCgWares(json.changeWareIds);
						bool = false;
					}
				}
			}
		}
	});
	return bool;
}

function showUpdateCgWares(ids){
	document.getElementById("dialogUpdateCgWaresfrm").src = basePath+"/manager/toWareInPrice?ids=" + ids;
	$('#dialogUpdateCgWares').dialog('open');
}

function wareAutoClick(o) {
	var currRow = $(o).closest('tr');
	var currRowIndex = $(currRow).index();
	curr_row_index = currRowIndex+1;
	enCount = 0;
	$(this).focus();
	$(this).click();
	$(this).focus();
}
