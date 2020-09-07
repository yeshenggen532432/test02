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
			var tab=currRow.parentNode;
			var currRowIndex=currRow.rowIndex;
			var nextRowIndex=currRowIndex-1;
			$(currRow).find("input[name*='"+field+"']").focus();
			$(currRow).find("input[name*='"+field+"']").select();
			if(obj.value==""){
				return;
			}
			enCount=0;
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
		$(currRow).find("input[name*='"+field+"']").focus();
		$(currRow).find("input[name*='"+field+"']").select();
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
		var cell=$(row).find("input[name*='"+targetField+"']");
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
		var cell=$(row).find("input[name*='"+targetField+"']");
		cell.focus();
		$(cell).click();
		cell.focus();
		var wareId = $(row).find("input[name*='wareId']").val()

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
		$(currRow).find("input[name*='"+field+"']").focus();
		$(currRow).find("input[name*='"+field+"']").select();
	}
}

/**
 * 检查商品是否存在
 * @param keyWord
 */
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
	var path = basePath+"manager/querySysWarePageByKeyWord";
	$.ajax({
		url: path,
		type: "POST",
		data : {"keyWord":keyWord,"status":1,"page":1,"rows":50},
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
						"sunitPrice":json.list[i].sunitPrice,
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
		href: basePath+"/manager/dialogWareType?oneRowSelect=1&op=1&stkId="+stkId,
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
						url: basePath+'/manager/dialogWarePage',
						type: 'get',
						data: function(){
							return {
								page:1, rows: 20,
								waretype: '',
								stkId: $('#stkId').val(),
								wareNm: $('#'+id).data('kendoAutoComplete').value()
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
					"hsNum": item.hsNum,
					"stkQty": item.stkQty,
					"price": item.inPrice,
					"sunitFront": item.sunitFront,
					"maxNm": item.wareDw,
					"minUnitCode":item.minUnitCode,
					"maxUnitCode": item.maxUnitCode,
					"minNm": item.minUnit,
					"hsNum": item.hsNum
				}
				var row =	$('#'+id).closest('tr');
				setRowData(row,data);
				var currRowIndex = $(row).index();
				curr_row_index = currRowIndex+1;
				//alert($(row).find("input[name='wareNm']").val());
			}
		}
	);
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
