<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>快速添加商品</title>

		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<link rel="stylesheet" href="<%=basePath %>/resource/kendo/style/autocomplete.min.css">
		<script src="<%=basePath %>/resource/kendo/js/kendo.custom.min.js"></script>
		<style type="text/css">
			td {height: 25px}
		</style>
		<script>
			var wareAutoCodeConfig = '${fns:checkFieldDisplay("sys_config","*","code=\"CONFIG_WARE_AUTO_CODE\"  and status=1")}';
		</script>
	</head>
	<body >
			<div style="height: 300px; overflow: auto;">
  			<form action="manager/saveQuickWare" name="quickWareFrm" id="quickWareFrm" method="post" >
  			  	<input  type="hidden" name="putOn" id="putOn" value="0" />
  			  	<input  type="hidden" name="wareId" id="wareId" />
  				<input type="hidden" name="waretype" id="waretype" />
				<input type="hidden" name="status" value="1"/>
				<input type="hidden" name="isCy" value="1">
					<table>
						<tr >
							<td width="100px">商品编号<span ${fns:checkFieldDisplay("sys_config","*","code=\"CONFIG_WARE_AUTO_CODE\"  and status=1") eq 'none'?'':"style='display:none'"}>*</span>：</td>
							<td><input  name="wareCode" id="wareCode"  style="width: 140px;font-size: 13px"/>
								<font ${fns:checkFieldDisplay("sys_config","*","code=\"CONFIG_WARE_AUTO_CODE\"  and status=1") eq 'none'?"style='display:none'":''}>
						（为空时会自动生成）
						</font>
								<font id="wareCodeTip" class="onshow"></font>
							</td>
						</tr>
						<tr>
							<td>商品名称*：</td>
							<td>
								<input type="text" name="wareNm" id="wareNm" placeholder="输入商品名称、商品代码、商品条码" style="width: 150px;"/>
							</td>
						</tr>
						<tr>
							<td>单位名称：</td>
							<td><input  name="wareDw" id="wareDw"  style="width: 100px;font-size: 13px"/>
								<font id="wareDwTip" class="onshow"></font></td>
						</tr>
						<tr>
							<td>规&nbsp;&nbsp;&nbsp;&nbsp;格：</td>
							<td><input  name="wareGg" id="wareGg"   style="width: 100px;;font-size: 13px"/>
								<font id="wareGgTip" class="onshow"></font></td>
						</tr>
						<c:if test="${empty param.tp}"><%--采购发票--%>
							<tr>
								<td>商品类别：</td>
								<td><select id="waretypecomb" class="easyui-combotree" style="width:200px;"
											data-options="url:'manager/syswaretypes',animate:true,dnd:true,onClick: function(node){
								setTypeWare(node.id);
								}"></select>
								</td>
							</tr>
							<tr>
								<td>采购价*：</td>
								<td><input  name="inPrice" id="inPrice"  style="width: 100px;font-size: 13px"/>
									<font id="wareInPriceTip" class="onshow"></font></td>
							</tr>
							<tr>
								<td>采购数量：</td>
								<td><input  name="initQty" id="initQty"  style="width: 100px;font-size: 13px"/>
								</td>
							</tr>

							<tr style="display: none" class="showClass">
								<td>批发价*：</td>
								<td><input name="wareDj" id="wareDj"  style="width: 100px;font-size: 13px"/>
									<font id="wareDjTip" class="onshow"></font></td>
							</tr>
						</c:if>
						<c:if test="${not empty param.tp}"><%--销售发票--%>
							<tr>
								<td>商品类别：</td>
								<td><select id="waretypecomb" class="easyui-combotree" style="width:200px;"
											data-options="url:'manager/syswaretypes',animate:true,dnd:true,onClick: function(node){
								setTypeWare(node.id);
								}"></select>
								</td>
							</tr>
							<tr>
								<td>成本价*：</td>
								<td><input  name="inPrice" id="inPrice"  style="width: 100px;font-size: 13px"/>
									<font id="wareInPriceTip" class="onshow"></font></td>
							</tr>
							<tr  class="showClass">
								<td>销售价*：</td>
								<td><input name="wareDj" id="wareDj"  style="width: 100px;font-size: 13px"/>
									<font id="wareDjTip" class="onshow"></font></td>
							</tr>
							<tr>
								<td>销售数量：</td>
								<td><input  name="initQty" id="initQty"  style="width: 100px;font-size: 13px"/>
								</td>
							</tr>
						</c:if>



						<tr style="display: none" class="showClass">
							<td>
								<input  type="hidden" name="maxUnitCode" id="maxUnitCode"  value="${ware.maxUnitCode}" style="width: 100px"/>
								<input  type="hidden" name="minUnitCode" id="minUnitCode" value="${ware.minUnitCode}" style="width: 100px"/>
								小单位名称*：</td>
							<td><input  name="minUnit" id="minUnit" value="S" style="width: 100px"/>
								<font id="minUnitTip" class="onshow"></font></td>
						</tr>
						<tr style="display: none" class="showClass">
							<td>大小单位换算比例*：</td>
							<td>
								<input  name="bUnit" id="bUnit" value="1" onkeyup="CheckInFloat(this)" onchange="calUnit()" style="width: 30px"/>
								*大单位
								=
								<input  name="sUnit" id="sUnit" value="1"  onkeyup="CheckInFloat(this)" onchange="calUnit()" style="width: 30px"/>*小单位
								&nbsp;&nbsp;&nbsp;&nbsp;<font style="font-size: 10px;"><input class="reg_input" name="hsNum" id="hsNum" value="1" readonly="readonly" style="width: 40px"/></font>
							</td>
						</tr>
						<tr>
							<td colspan="2" align="center">
								<font id="showSpan" onclick="showElement('show')">显示其它信息</font>
								<font id="hiddenSpan" onclick="showElement('hidden')" style="display: none">隐藏其它信息</font>
							</td>
						</tr>
					</table>
	  		</form>
			</div>
	    <script type="text/javascript">
		   function saveQuickWare(op,t){
					var bUnit=$("#bUnit").val();
					var sUnit=$("#sUnit").val();
					if(bUnit==""&&sUnit==""){
						alert("单位换算不能为空！");
						return;
					}
					if($("#inPrice").val()==""){
						$("#inPrice").val(0);
					}

			        var wareTypeId=$("#waretype").val();
					if(wareTypeId!=""){
						var check =	checkWareTypeLeaf(wareTypeId);
						if(check==false){
							if(!window.confirm("商品类别未选择最末节点,如果继续操作商品将归属到未分类!")){
								return;
							}
							$("#waretype").val(-1);
						}
					}

					$("#quickWareFrm").form('submit',{
						type:"POST",
						dataType: 'json',
						//url:"manager/saveQuickWare",
						success:function(data){
							data = eval('(' + data + ')');
							if(data.state){
								var json = {};
								var  wareList = new Array();
								var qty = $("#initQty").val();
								var rt = {
									waretypePath:data.ware.waretypePath,
									wareId:data.ware.wareId,
									wareNm:data.ware.wareNm,
									wareGg:data.ware.wareGg,
									wareCode:data.ware.wareCode,
									wareDw:data.ware.wareDw,
									minUnit:data.ware.minUnit,
									minUnitCode:data.ware.minUnitCode,
									maxUnitCode:data.ware.maxUnitCode,
									hsNum:data.ware.hsNum,
									qty:qty,
									price:data.ware.inPrice,
									sunitFront:data.ware.sunitFront
								};
								if(t=='xs'){//销售发票返回格式
									rt = {waretypePath:data.ware.waretypePath,
											wareId:data.ware.wareId,
											wareNm:data.ware.wareNm,
											wareGg:data.ware.wareGg,
											wareCode:data.ware.wareCode,
											maxNm:data.ware.wareDw,
											minNm:data.ware.minUnit,
											minUnitCode:data.ware.minUnitCode,
											maxUnitCode:data.ware.maxUnitCode,
											hsNum:data.ware.hsNum,
											qty:qty,
											wareDj:data.ware.wareDj,
											sunitFront:data.ware.sunitFront,
											sunitPrice:data.ware.sunitPrice,
											qualityDays:data.ware.qualityDays,
											productDate:data.ware.productDate,
											inPrice:data.ware.inPrice
									}
								}
								wareList.push(rt);
								json ={
									list:wareList
								}
								window.parent.callBackFun(json);

								if(op==1){
									window.parent.$('#quickWareDlg').dialog('close');
								}else if(op==-1){
									var url = '${base}/manager/toquickware';
									if(${not empty param.tp}){
										url = url+"?tp=${param.tp}";
									}
									document.location.href=url;
								}

							}else{
								alert("添加失败");
							}
						}
					});
			}
		    function setTypeWare(typeId){
		    	$("#waretype").val(typeId);
				checkWareTypeLeaf(typeId);
		    }
			$(function(){
				setKendoAutoComplete("wareNm");
			    $.formValidator.initConfig();
			    if(wareAutoCodeConfig=='none'){
					$("#wareCode").formValidator({onShow:"请输入(20个字符以内)",onFocus:"请输入(20个字符以内)",onCorrect:"通过"}).inputValidator({min:1,max:20,onError:"请输入(20个字符以内)"});
				}
			    $("#warewareDwGg").formValidator({onShow:"请输入(10个字以内)",onFocus:"请输入(10个字以内)",onCorrect:"通过"});
			    $("#").formValidator({onShow:"请输入(5个字以内)",onFocus:"请输入(5个字以内)",onCorrect:"通过"});
			    $("#wareDj").formValidator({onShow:"请输单价",onFocus:"请输单价"}).regexValidator({regExp:"money",dataType:"enum",onError:"单价格式不正确"});
			    $("#minUnit").formValidator({onShow:"请输入(5个字以内)",onFocus:"请输入(5个字以内)",onCorrect:"通过"});
			    $("#hsNum").formValidator({onShow:"请输入(5个字以内)",onFocus:"请输入(5个字以内)",onCorrect:"通过"}).inputValidator({min:1,max:20,onError:"请输入(5个字以内)"});

				//$("#sUnit").attr("readonly",bool);
				//$("#bUnit").attr("readonly",bool);
				var wareId = $("#wareId").val();
				if(wareId==""){
					$("#sUnit").attr("readonly",false);
					$("#bUnit").attr("readonly",true);
				}
			});
			//计算换算单位
			function calUnit(){
				var bUnit=$("#bUnit").val();
				var sUnit=$("#sUnit").val();
				if(bUnit!=""&&sUnit!=""){
					var hsNum = parseFloat(sUnit)/parseFloat(bUnit);
					console.log("hsNum:"+hsNum);
					console.log("hsNum.toFixed(7)："+hsNum.toFixed(7));
					$("#hsNum").val(hsNum.toFixed(7));
				}
			}
			function CheckInFloat(oInput)
			{
				if(window.event.keyCode==37||window.event.keyCode==37){
					return;
				}
			    if('' != oInput.value.replace(/\d{1,}\.{0,1}\d{0,}/,''))
			    {
			        oInput.value = oInput.value.match(/\d{1,}\.{0,1}\d{0,}/) == null ? '' :oInput.value.match(/\d{1,}\.{0,1}\d{0,}/);
			    }
			}
			function showElement(v) {
				if(v=='show'){
					$(".showClass").show();
					$("#hiddenSpan").show();
					$("#showSpan").hide();
				}else{
					$(".showClass").hide();
					$("#hiddenSpan").hide();
					$("#showSpan").show();
				}
			}
		   $('#wareNmComb').combobox({
			   onChange:function(nvalue, ovalue){
				   $("#proId").val(nvalue);
				   var wareId =   $('#wareNmComb').combobox('getValue')+"";
				   var wareNm =   $('#wareNmComb').combobox('getText')+"";
				   if(wareId==wareNm){
					   $("#wareId").val("");
					   $("#wareCode").val("");
					   $("#wareNm").val("");
					   $("#wareDw").val("");
					   $("#wareGg").val("");
					   $("#inPrice").val("");
					   $("#wareDj").val("");
					   $("#maxUnitCode").val("B");
					   $("#minUnitCode").val("S");
					   $("#minUnit").val("S");
					   $("#bUnit").val(1);
					   $("#sUnit").val(1);
					   $("#hsNum").val(1);
					   $('#waretypecomb').combotree('setValue',"");
				   }else{
					    $("#wareId").val(wareId);
					   getWareById(wareId);
				   }
		   }
		   });

			function getWareById(wareId){
				$.ajax({
					url: "manager/getWareById",
					type: "POST",
					data : {"wareId":wareId},
					dataType: 'json',
					async : false,
					success: function (json) {
						if(json.state){
							$("#wareId").val(json.ware.wareId);
							$("#waretype").val(json.ware.waretype);
							$("#wareCode").val(json.ware.wareCode);
							$("#wareNm").val(json.ware.wareNm);
							$("#wareDw").val(json.ware.wareDw);
							$("#wareGg").val(json.ware.wareGg);
							$("#inPrice").val(json.ware.inPrice);
							$("#wareDj").val(json.ware.wareDj);
							$("#maxUnitCode").val(json.ware.maxUnitCode);
							$("#minUnitCode").val(json.ware.minUnitCode);
							$("#minUnit").val(json.ware.minUnit);
							$("#bUnit").val(json.ware.bbUnit);
							$("#sUnit").val(json.ware.ssUnit);
							$("#hsNum").val(json.ware.hsNum);
							$('#waretypecomb').combotree('setValue', json.ware.waretypeNm);
						}else{
							$("#wareId").val("");
							$("#wareNm").val("");
							$("#wareCode").val("");
							$("#wareDw").val("");
							$("#wareGg").val("");
							$("#inPrice").val("");
							$("#wareDj").val("");
							$("#maxUnitCode").val("B");
							$("#minUnitCode").val("S");
							$("#minUnit").val("S");
							$("#bUnit").val(1);
							$("#sUnit").val(1);
							$("#hsNum").val(1);
							$('#waretypecomb').combotree('setValue',"");
						}
					}
				})
			}

		   /**
			校验商品类别是否末级节点
			*/
		   function checkWareTypeLeaf(typeId){
			   $.ajaxSettings.async = false;
			   var bool=true;
			   $.ajax({
				   url: "manager/checkWareTypeLeaf",
				   data: "id=" + typeId,
				   type: "post",
				   dataType: 'json',
				   success: function (json) {
					   if(!json.state){
						   //alert("请选择最末节点!");
						   bool = false;
					   }
				   }
			   });
			   return bool;
		   }

		   $('#wareNmComb').combobox('setText',"");

		   function setKendoAutoComplete(id){
			   $('#'+id).kendoAutoComplete({
						   dataTextField:'wareNm',
						   dataValueField:'wareId',
						   dataSource: {//数据源
							   serverFiltering: true,
							   schema: {
								   data: function (response) {
									   return response.rows || [];
								   }
							   },
							   transport: {
								   read: {
									   url: '<%=basePath %>/manager/dialogWarePage',
									   type: 'get',
									   data: function(){
										   return {
											   page:1, rows: 20,
											   waretype: '',
											   stkId: 0,
											   wareNm: $('#'+id).data('kendoAutoComplete').value()
										   }
									   }
								   }
							   }
						   },
						   select: function (e) {//返回值
							   var item = e.dataItem;
							   getWareById(item.wareId);
						   },
				           change: function(e){
						   	 var check =checkSysWareByKeyWord($("#wareNm").val());
						   	 if(check){
							 }else{
								 $("#wareId").val("");
								 $("#wareCode").val("");
								 $("#wareDw").val("");
								 $("#wareGg").val("");
								 $("#inPrice").val("");
								 $("#wareDj").val("");
								 $("#maxUnitCode").val("B");
								 $("#minUnitCode").val("S");
								 $("#minUnit").val("S");
								 $("#bUnit").val(1);
								 $("#sUnit").val(1);
								 $("#hsNum").val(1);
								 $('#waretypecomb').combotree('setValue',"");
							 }
						   }
					   }
			   );
		   }

		   function checkSysWareByKeyWord(keyWord)
		   {
			   var bool = true;
			   $.ajaxSettings.async = false;
			   var path = "<%=basePath %>/manager/querySysWarePageByKeyWord";
			   $.ajax({
				   url: path,
				   type: "POST",
				   data : {"keyWord":keyWord,"status":1,"page":1,"rows":50},
				   dataType: 'json',
				   async : false,
				   success: function (json) {
					   if(json.state){
					   }else{
						   bool = false;
					   }
				   }
			   });
			   return bool;
		   }


		</script>
	</body>
</html>
