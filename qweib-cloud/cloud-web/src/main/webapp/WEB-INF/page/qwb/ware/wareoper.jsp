<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>T3</title>
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<style type="text/css">
			.divDel{
				position: relative;
				width:200px;
				height:160px;
				margin:15px 0px 5px;
			}
			.imgDel{
				width:20px;
				height:20px;
				position: absolute;
				right: 5px;
				top: 5px;
			}
			.left_title{width:200px; display:inline-block; text-align:left; padding-left:30px}
		</style>
		<script>
			var showDesc = '${permission:checkUserButtonPdm("qwb.sysWare.showAllDesc")}';
			var showYxDesc = '${permission:checkUserButtonPdm("qwb.sysWare.showYxDesc")}';
			var showPosDesc = '${permission:checkUserButtonPdm("qwb.sysWare.showPosDesc")}';
			var showShopDesc = '${permission:checkUserButtonPdm("qwb.sysWare.showShopDesc")}';
			var showPlatShopDesc = '${permission:checkUserButtonPdm("qwb.sysWare.showPlatShopDesc")}';
			var wareAutoCodeConfig = '${fns:checkFieldDisplay("sys_config","*","code=\"CONFIG_WARE_AUTO_CODE\"  and status=1")}';
			var wareHsBili = '${fns:checkFieldDisplay("sys_config","*","code=\"CONFIG_WARE_MODIFY_HS_BILI\"  and status=1")}';

		</script>
	</head>
	<body>
  			<form action="manager/operware" name="warefrm1" id="warefrm1" method="post" enctype="multipart/form-data">
  			  	<input  type="hidden" name="putOn" id="putOn" value="${ware.putOn}"/>
  			  	<input  type="hidden" name="wareId" id="wareId" value="${ware.wareId}"/>
  			    <input type="hidden" name="fbtime" id="fbtime" value="${ware.fbtime}" />
  				<input type="hidden" name="waretype" id="waretype" />

  				<c:set var="subIds" value=""/>
  				<input type="hidden" name="delSubIds" id="delSubIds" />
  			<div id="easyTabs" class="easyui-tabs" style="width:auto;height:auto;">
			    <div title="商品信息" style="padding:20px;">
			    <div class="box" >
					<dl id="dl1" style="font-size: 13px">
					<fieldset style="width:99%;border:1px dotted skyblue;-moz-border-radius: 5px; -webkit-border-radius: 5px; -khtml-border-radius: 5px; border-radius: 5px;  ">
	        		<legend  style="border:0px;background-color:white; font-size: 13px;color:teal;">一、商品基本信息</legend>
	      			<dd >
						<span class="left_title">1.商品编号1<span ${fns:checkFieldDisplay("sys_config","*","code=\"CONFIG_WARE_AUTO_CODE\"  and status=1") eq 'none'?'':"style='display:none'"}>*</span>：</span>
	        			<input class="reg_input" name="wareCode" id="wareCode" value="${ware.wareCode}" style="width: 180px;font-size: 13px"/>
	        			<span id="wareCodeTip" class="onshow"></span>
	        		</dd>
	      			<dd>
	      				<span class="left_title">2.商品名称*：</span>
	        			<input class="reg_input" name="wareNm" id="wareNm" value="${ware.wareNm}" style="width: 240px;font-size: 13px"/>
	        			<span id="wareNmTip" class="onshow"></span>
	        		</dd>
	        		<dd>
	      				<span class="left_title">3.助记码：</span>
	        			<input class="reg_input" name="py" id="py" value="${ware.py}" style="width: 240px;font-size: 13px"/>
	        			<span id="pyTip" class="onshow"></span>
	        		</dd>
					<dd>
						<span class="left_title">4.商品品牌：</span>
						<span>
							<tag:select id="brandId" name="brandId" headerKey="" headerValue="" value="${ware.brandId}" displayKey="id" displayValue="name" tableName="sys_brand">
							</tag:select>
						</span>
					</dd>
	        		<dd>
	        			<span class="left_title">5.商品类别：</span>
	        			<select id="waretypecomb" class="easyui-combotree" style="width:200px;"
	        					data-options="url:'manager/syswaretypes',animate:true,dnd:true,onClick: function(node){
						setTypeWare(node.id);
						}"></select>
	        		</dd>
						<dd >
							<span class="left_title">6.大单位原价：</span>
							<input class="reg_input" name="lsPrice" id="lsPrice" value="${ware.lsPrice}" style="width: 100px;font-size: 13px"/>
						</dd>
						<dd class="showClass1" >
							<span class="left_title">7.小单位原价：</span>
							<span>
							<input class="reg_input" name="minLsPrice" id="minLsPrice" value="${ware.minLsPrice}" onkeyup="CheckInFloat(this)" style="width: 100px;font-size: 13px"/>.
						</span>
					<dd>
						<span class="left_title">8.所属多规格商品：</span>
						<input class="reg_input" name="multiSpecId" id="multiSpecId" value="${ware.multiSpecId}" type="hidden"/>
						<input class="reg_input" name="multiSpecNm" id="multiSpecNm" value="${ware.multiSpecNm}" readonly="readonly" style="width: 100px;font-size: 13px"/>
					</dd>

					<dd>
						<span class="left_title">9.生产厂商：</span>
						<input class="reg_input" name="providerName" id="providerName" value="${ware.providerName}" style="width: 100px;font-size: 13px"/>
					</dd>
					<dd>
						<span class="left_title">10.保&nbsp;质&nbsp;期：</span>
						<input class="reg_input" name="qualityDays" id="qualityDays" value="${ware.qualityDays}" style="width: 100px;font-size: 13px"/>
						<span id="qualityDaysTip" class="onshow"></span>
					</dd>
						<dd>
							<span class="left_title">11.是否常用：</span>
							<input type="radio" name="isCy" id="isCy1" value="1" checked="checked"/>是
							<input type="radio" name="isCy" id="isCy2" value="2"/>否
						</dd>
						<dd>
							<span class="left_title">12.是否启用：</span>
							<input type="radio" name="status" id="status1" value="1" checked="checked"/>是
							<input type="radio" name="status" id="status2" value="2"/>否
						</dd>
						<dd>
							<span class="left_title">13.备&nbsp;&nbsp;&nbsp;&nbsp;注：</span>
							<input class="reg_input" name="remark" id="remark" value="${ware.remark}" style="width: 240px"/>
							<span id="remarkTip" class="onshow"></span>
						</dd>
						<dd style="display: none">
							<span class="left_title">标识码：</span>
							<input class="reg_input" name="asnNo" id="asnNo" value="${ware.asnNo}" style="width: 100px;font-size: 13px"/>
						</dd>

						<dd style="display: none">
							<span class="left_title">运输费用：</span>
							<input class="reg_input" name="tranAmt" id="tranAmt" value="${ware.tranAmt}" style="width: 100px;font-size: 13px"/>
							<span id="tranAmtTip" class="onshow"></span>
						</dd>
						<dd style="display: none">
							<span class="left_title">提成费用：</span>
							<input class="reg_input" name="tcAmt" id="tcAmt" value="${ware.tcAmt}" style="width: 100px;font-size: 13px"/>
							<span id="tcAmtTip" class="onshow"></span>
						</dd>
	        		</fieldset>
	        		<fieldset style="width:99%;border:1px dotted skyblue;-moz-border-radius: 5px; -webkit-border-radius: 5px; -khtml-border-radius: 5px; border-radius: 5px; ">
	        		<legend  style="border:0px;background-color:white;font-size: 13px;color:teal">二.进销存商品信息</legend>
						<dd>(一)大单位信息</dd>
	        		<dd>
	      				<span class="left_title">1.大单位名称*：</span>
	        			<input class="reg_input" name="wareDw" id="wareDw" value="${ware.wareDw}" style="width: 100px;font-size: 13px"/>
	        			<span id="wareDwTip" class="onshow"></span><input type="radio" value="" name="unitCheck" id="bUnitCheck"/><span style="font-size: 7px">默认主单位</span>
	        		</dd>
					<dd>
						<span class="left_title">2.大单位规格*：</span>
						<input class="reg_input" name="wareGg" id="wareGg" value="${ware.wareGg}" style="width: 100px;;font-size: 13px"/>
						<span id="wareGgTip" class="onshow"></span>
					</dd>
	        		<dd>
	      				<span class="left_title">3.大单位条码：</span>
	        			<input class="reg_input" name="packBarCode" id="packBarCode" value="${ware.packBarCode}" style="width: 200px;font-size: 13px"/>
	        			<span id="packBarCodeTip" class="onshow"></span>
	        		</dd>

	        		<dd>
	      				<span class="left_title">4.大单位采购价：</span>
	        			<input class="reg_input" name="inPrice" id="inPrice" value="${ware.inPrice}" style="width: 100px;font-size: 13px"/>
	        			<span id="wareInPriceTip" class="onshow"></span>
	        		</dd>
	        		<dd>
	      				<span class="left_title">5.大单位批发价：</span>
	        			<input class="reg_input" name="wareDj" id="wareDj" value="${ware.wareDj}" style="width: 100px;font-size: 13px"/>
	        			<span id="wareDjTip" class="onshow"></span>
	        		</dd>

						<dd class="showClass1" style="display: none">
							<span class="left_title">6.大单位分销价：</span><span>
							<input class="reg_input" name="fxPrice" id="fxPrice" value="${ware.fxPrice}" onkeyup="CheckInFloat(this)" style="width: 100px;font-size: 13px"/>.
						</span>

						</dd>
						<dd class="showClass1" style="display: none">
							<span class="left_title">7.大单位促销价：</span><span>
							<input class="reg_input" name="cxPrice" id="cxPrice" value="${ware.cxPrice}" onkeyup="CheckInFloat(this)" style="width: 100px;font-size: 13px"/>.
							</span>
						</dd>
	        		<dd>
	      				<span class="left_title">8.预警最低数量：</span>
	        			<input class="reg_input" name="warnQty" id="warnQty" value="${ware.warnQty}" style="width: 100px;font-size: 13px"/>
	        			<span id="warnQtyTip" class="onshow"></span>
	        		</dd>
						<dd>(二) 小单位信息</dd>
						<dd>
							<input  type="hidden" name="maxUnitCode" id="maxUnitCode" value="${ware.maxUnitCode}" style="width: 100px"/>
							<input  type="hidden" name="minUnitCode" id="minUnitCode" value="${ware.minUnitCode}" style="width: 100px"/>
							<span class="left_title">1.小单位名称：</span>
							<input class="reg_input" name="minUnit" id="minUnit" value="${ware.minUnit}" style="width: 100px"/>
							<span id="minUnitTip" class="onshow"></span>
							<input type="radio" name="unitCheck" value="1" id="sUnitCheck"/><span style="font-size: 7px">默认主单位</span>
						</dd>
						<dd class="showClass">
						<span class="left_title">2.小单位规格：</span><span>
							<input class="reg_input" name="minWareGg" id="minWareGg" value="${ware.minWareGg}"  style="width: 100px;font-size: 13px"/>.
						</span>
						</dd>
						<dd>
							<span class="left_title">3.小单位条码：</span>
							<input class="reg_input" name="beBarCode" id="beBarCode" value="${ware.beBarCode}" style="width: 200px;font-size: 13px"/>
							<span id="beBarCodeTip" class="onshow"></span>
						</dd>

						<dd class="showClass">
							<span class="left_title">4.小单位采购价：</span><span>
							<input class="reg_input" name="minInPrice" id="minInPrice" value="${ware.minInPrice}" onkeyup="CheckInFloat(this)" style="width: 100px;font-size: 13px"/>.
						</span>
						</dd>
						<dd>
							<span class="left_title">5.小单位批发价：</span>
							<input class="reg_input" name="sunitPrice" id="sunitPrice" value="${ware.sunitPrice}" style="width: 100px;font-size: 13px"/>
							<span id="sunitPriceTip" class="onshow"></span>
						</dd>


						</dd>
						<dd class="showClass1" style="display: none">
							<span class="left_title">6.小单位分销价：</span><span>
							<input class="reg_input" name="minFxPrice" id="minFxPrice" value="${ware.minFxPrice}" onkeyup="CheckInFloat(this)" style="width: 100px;font-size: 13px"/>.
						</span>
						</dd>
						<dd class="showClass1" style="display: none">
							<span class="left_title">7.小单位促销价：</span><span>
							<input class="reg_input" name="minCxPrice" id="minCxPrice" value="${ware.minCxPrice}" onkeyup="CheckInFloat(this)" style="width: 100px;font-size: 13px"/>.
						</span>
						</dd>
						<dd class="showClass">
							<span class="left_title">8.预警最低库存数量：</span><span>
							<input class="reg_input" name="minWarnQty" id="minWarnQty" value="${ware.minWarnQty}" onkeyup="CheckInFloat(this)" style="width: 100px;font-size: 13px"/>.
						</span>
						</dd>
						<dd>
							<span class="left_title">9.大小单位换算比例*：</span>
							<span style="font-size: 10px" >
	        				<input class="reg_input"
								   name="bUnit"
								   id="bUnit"
									<c:if test="${ware.bUnit != null and ware.bUnit == 1}">
								   	readonly="readonly"
									</c:if>
								   value="${ware.bUnit == null ? 1 :ware.bUnit}"
								   onkeyup="checkBUnit(this)"
								   onchange="calUnit()"
								   style="width: 30px"/>
	        				*大单位
	        				=
	        				<input class="reg_input" name="sUnit" id="sUnit" value="${ware.sUnit}"  onkeyup="checkSUnit(this)" onchange="calUnit()" style="width: 30px"/>*小单位
	        			</span>
							&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-size: 10px;"><input class="reg_input" name="hsNum" id="hsNum" value="${ware.hsNum}" readonly="readonly" style="width: 40px"/></span>
						</dd>

						<dd style="display: none">
							开单默认小单位：
							<input type="checkbox" name="sunitFront" value="1" id="sunitFront" ${ware.sunitFront eq '1'?'checked':'' }>
						</dd>
						<c:if test="${not empty ware.wareId}">
						<dd class="showYxClass">(三) 商品营销信息</dd>
							<dd class="showYxClass">
								<span class="left_title">1.客户类型商品销售价格设置：</span><span style="font-size: 10px" ><a href="javascript:;;" onclick="wareCustomerTypeDialog(${ware.wareId})">查看</a></span>
							</dd>
						<dd class="showYxClass">
							<span class="left_title">2.客户等级销售价设置：</span><span style="font-size: 10px" ><a href="javascript:;;" onclick="wareLevelDialog(${ware.wareId})">查看</a></span>
						</dd>

						<dd class="showYxClass">
							<span class="left_title">3.商品销售投入费用项目设置：</span><span style="font-size: 10px" ><a href="javascript:;;" onclick="wareAutoPriceDialog(${ware.wareId})">查看</a></span>
						</dd>
						<dd class="showYxClass">
							<span class="left_title">4.费用项目关联计算设置：</span><span style="font-size: 10px" >展开 （关联销售量货关联销售收入或销售毛利）</span>
						</dd>
						<dd class="showYxClass">
							<span class="left_title">5.费用项目投入计算：</span><span style="font-size: 10px" >展开</span>
						</dd>
						</c:if>
	        		</fieldset>
	        		<fieldset style="width:99%;border:1px dotted skyblue;-moz-border-radius: 5px;
						-webkit-border-radius: 5px;
						-khtml-border-radius: 5px;
						border-radius: 5px;" class="showPosClass">
	        		<legend  style="border:0px;background-color:white;font-size: 13px;color:teal">三、收银系统商品信息</legend>
						<dd>
							<span class="left_title">1.门店商品别称：</span><span>
							<input class="reg_input" name="posWareNm" id="posWareNm" value="${ware.posWareNm}" onkeyup="CheckInFloat(this)" style="width: 100px;font-size: 13px"/>.
						</span>
						</dd>
						<dd>
							<span class="left_title">2.门店大单位采购价：</span><span>
							<input class="reg_input" name="posInPrice" id="posInPrice" value="${ware.posInPrice}" onkeyup="CheckInFloat(this)" style="width: 100px;font-size: 13px"/>.
						</span>
						</dd>
						<dd>
							<span class="left_title">3.门店大单位批发价：</span><span>
							<input class="reg_input" name="posPfPrice" id="posPfPrice" value="${ware.posPfPrice}" onkeyup="CheckInFloat(this)" style="width: 100px;font-size: 13px"/>.
						</span>
						</dd>
						<dd>
							<span class="left_title">4.门店大单位零售价：</span><span>
							<input class="reg_input" name="posPrice1" id="posPrice1" value="${ware.posPrice1}" onkeyup="CheckInFloat(this)" style="width: 100px;font-size: 13px"/>.
						</span>
						</dd>
						<dd>
							<span class="left_title">5.门店大单位促销价：</span><span>
							<input class="reg_input" name="posCxPrice" id="posCxPrice" value="${ware.posCxPrice}" onkeyup="CheckInFloat(this)" style="width: 100px;font-size: 13px"/>.

						</span>
						</dd>
						<dd>
							<span class="left_title">6.门店小单位采购价：</span><span>
							<input class="reg_input" name="posMinInPrice" id="posMinInPrice" value="${ware.posMinInPrice}" onkeyup="CheckInFloat(this)" style="width: 100px;font-size: 13px"/>.
						</span>
						</dd>
						<dd>
							<span class="left_title">7.门店小单位批发价：</span><span>
							<input class="reg_input" name="posMinPfPrice" id="posMinPfPrice" value="${ware.posMinPfPrice}" onkeyup="CheckInFloat(this)" style="width: 100px;font-size: 13px"/>.
						</span>
						</dd>
						<dd>
							<span class="left_title">8.门店小单位零售价：</span><span>
							<input class="reg_input" name="posPrice2" id="posPrice2" value="${ware.posPrice2}" onkeyup="CheckInFloat(this)" style="width: 100px;font-size: 13px"/>.</span>
						</dd>
						<dd>
							<span class="left_title">9.门店小单位促销价：</span><span>
							<input class="reg_input" name="posMinCxPrice" id="posMinCxPrice" value="${ware.posMinCxPrice}" onkeyup="CheckInFloat(this)" style="width: 100px;font-size: 13px"/>.

						</span>
						</dd>
	        		</fieldset>

						<fieldset style="width:99%;border:1px dotted skyblue;-moz-border-radius: 5px;
						-webkit-border-radius: 5px;
						-khtml-border-radius: 5px;
						border-radius: 5px;" class="showShopClass">
							<legend  style="border:0px;background-color:white;font-size: 13px;color:teal">四、自营商城商品信息</legend>
							<dd>
								<span class="left_title">1.自营商城商品别称：</span><span>
								<input class="reg_input" name="shopWareAlias" id="shopWareAlias" value="${ware.shopWareAlias}" style="width: 100px;font-size: 13px"/>.
							</span>
							</dd>
							<dd>
								<span class="left_title">2.自营商城商品大单位：</span>
								是否显示<input type="checkbox" name="shopWarePriceShow" value="1" <c:if test="${ware.shopWarePriceShow==null || ware.shopWarePriceShow==1}">checked</c:if> onchange="return priceShowChange(this)">
								&nbsp;&nbsp;默认单位<input type="radio" name="shopWarePriceDefault" value="0" <c:if test="${ware.shopWarePriceShow==null || ware.shopWarePriceDefault==0}">checked</c:if>>
							</dd>
							<dd style="display: none">
								<span class="left_title">2.自营商城商品大单位批发价：</span><span>
								<input class="reg_input" name="shopWarePrice" id="shopWarePrice" value="${ware.shopWarePrice}" onkeyup="CheckInFloat(this)" style="width: 100px;font-size: 13px"/>.

							</span>
							</dd>
							<dd>
								<span class="left_title">3.自营商城商品大单位零售价：</span><span>
								<input class="reg_input" name="shopWareLsPrice" id="shopWareLsPrice" value="${ware.shopWareLsPrice}" onkeyup="CheckInFloat(this)" style="width: 100px;font-size: 13px"/>.
							</span>
							</dd>
							<dd style="display: none">
								<span class="left_title">4.自营商城商品大单位促销价：</span><span>
								<input class="reg_input" name="shopWareCxPrice" id="shopWareCxPrice" value="${ware.shopWareCxPrice}" onkeyup="CheckInFloat(this)" style="width: 100px;font-size: 13px"/>.
							</span>
							</dd>
							<dd>
								<span class="left_title">4.自营商城商品小单位：</span>
								是否显示<input type="checkbox" name="shopWareSmallPriceShow" value="1" <c:if test="${ware.shopWareSmallPriceShow==null || ware.shopWareSmallPriceShow==1}">checked</c:if> onchange="return priceShowChange(this)">
								&nbsp;&nbsp;默认单位<input type="radio" name="shopWarePriceDefault" value="1" <c:if test="${ware.shopWarePriceDefault==1}">checked</c:if>>
							</dd>
							<dd style="display: none">
								<span class="left_title">5.自营商城商品小单位批发价：</span><span>
								<input class="reg_input" name="shopWareSmallPrice" id="shopWareSmallPrice" value="${ware.shopWareSmallPrice}" onkeyup="CheckInFloat(this)" style="width: 100px;font-size: 13px"/>.
							</span>
							</span>
							</dd>
							<dd>
								<span class="left_title">5.自营商城商品小单位零售价：</span><span>
								<input class="reg_input" name="shopWareSmallLsPrice" id="shopWareSmallLsPrice" value="${ware.shopWareSmallLsPrice}" onkeyup="CheckInFloat(this)" style="width: 100px;font-size: 13px"/>.

							</span>
							</dd>
							<dd style="display: none">
								<span class="left_title">7.自营商城商品小单位促销价：</span><span>
								<input class="reg_input" name="shopWareSmallCxPrice" id="shopWareSmallCxPrice" value="${ware.shopWareSmallCxPrice}" onkeyup="CheckInFloat(this)" style="width: 100px;font-size: 13px"/>.
							</span>
							</dd>
							<dd>
								<span class="left_title">6.自营商城排序：</span><span>
								<input class="reg_input" name="shopSort" id="shopSort" value="${ware.shopSort}" onkeyup="CheckInFloat(this)" style="width: 100px;font-size: 13px"/>.
							</span>
							</dd>
						</fieldset>

						<fieldset style="width:99%;border:1px dotted skyblue;-moz-border-radius: 5px;
						-webkit-border-radius: 5px;
						-khtml-border-radius: 5px;
						border-radius: 5px;" class="showPlatShopClass">
							<legend  style="border:0px;background-color:white;font-size: 13px;color:teal">五、平台商城商品信息</legend>
							<dd>
								<span class="left_title">1.平台商城商品别称：</span><span>
								<input class="reg_input" name="platshopWareNm" id="platshopWareNm" value="${ware.platshopWareNm}" onkeyup="CheckInFloat(this)" style="width: 100px;font-size: 13px"/>.
							</span>
							</dd>
							<dd>
								<span class="left_title">2.平台商城商品类别：</span><span>
								<input class="reg_input" name="platshopWareType" id="platshopWareType" value="${ware.platshopWareType}" onkeyup="CheckInFloat(this)" style="width: 100px;font-size: 13px"/>.
							</span>
							</dd>
							<dd>
								<span class="left_title">3.平台商城商品大单位批发价：</span><span>
								<input class="reg_input" name="platshopWarePfPrice" id="platshopWarePfPrice" value="${ware.platshopWarePfPrice}" onkeyup="CheckInFloat(this)" style="width: 100px;font-size: 13px"/>.
							</span>
							</dd>
							<dd>
								<span class="left_title">4.平台商城商品大单位零售价：</span><span>
								<input class="reg_input" name="platshopWareLsPrice" id="platshopWareLsPrice" value="${ware.platshopWareLsPrice}" onkeyup="CheckInFloat(this)" style="width: 100px;font-size: 13px"/>.
							</span>
							</dd>
							<dd>
								<span class="left_title">5.平台商城商品大单位促销价：</span><span>
								<input class="reg_input" name="platshopWareCxPrice" id="platshopWareCxPrice" value="${ware.platshopWareCxPrice}" onkeyup="CheckInFloat(this)" style="width: 100px;font-size: 13px"/>.
							</span>
							</dd>
							<dd>
								<span class="left_title">6.平台商城商品小单位批发价：</span><span>
								<input class="reg_input" name="platshopWareMinPfPrice" id="platshopWareMinPfPrice" value="${ware.platshopWareMinPfPrice}" onkeyup="CheckInFloat(this)" style="width: 100px;font-size: 13px"/>.
							</span>
							</dd>
							<dd>
								<span class="left_title">7.平台商城商品小单位零售价：</span><span>
								<input class="reg_input" name="platshopWareMinLsPrice" id="platshopWareMinLsPrice" value="${ware.platshopWareMinLsPrice}" onkeyup="CheckInFloat(this)" style="width: 100px;font-size: 13px"/>.</span>
							</dd>
							<dd>
								<span class="left_title">8.平台商城商品小单位促销价：</span><span>
								<input class="reg_input" name="platshopWareMinCxPrice" id="platshopWareMinCxPrice" value="${ware.platshopWareMinCxPrice}" onkeyup="CheckInFloat(this)" style="width: 100px;font-size: 13px"/>.</span>
							</dd>
						</fieldset>
	        		<fieldset style="width:99%;border:1px dotted skyblue;-moz-border-radius: 5px;
						-webkit-border-radius: 5px;
						-khtml-border-radius: 5px;
						border-radius: 5px;" class="showClass">
	        		<legend  style="border:0px;background-color:white;font-size: 13px;color:teal">六、信息备注说明</legend>

	        		</fieldset>
	        		</dl>
	        		</div>
			    </div>

			    <!-- ================= 图片开始=================== -->
			    <div title="商品图片" style="overflow:auto;padding:20px;">
		        	<dl id="dl2">
						<c:if test="${empty ware.warePicList}">
			       			<dd id="ddphoto1">
			     				<div class="divDel">
				        			<img id="photoImg21" alt="" style="width: 200px;height: 160px;" src="resource/images/login_bg.jpg" >
				        			<img class="imgDel" alt=""   style="width: 20px;height: 20px;" src="resource/shop/mobile/images/delete_1.png" onclick="deleteRows(1);"/>
			        			</div>
			        			<div id="editDiv2" >
			        				<input type="file" accept="image/*" name="file21" id="file21" onchange="showPictrue(1)"  class="uploadFile"/>
			        			</div>
			 				</dd>
			       		</c:if>

			       		<c:if test="${!empty ware.warePicList}">
				      		<c:forEach items="${ware.warePicList}" var="item" varStatus="s">
				      			<dd id="ddphoto${s.index+1}">
				      				<input type="hidden" name="subId" id="subId${s.index+1}" value="${item.id}"/>
				      				<c:set var="subIds" value="${subIds},${item.id },"/>
				        			<div class="divDel">
					        			<c:if test="${!empty item.pic}">
					        				<img id="photoImg2${s.index+1}" alt=""   style="width: 200px;height: 160px;" src="upload/${item.pic}"/>
					        			</c:if>
					        			<c:if test="${empty item.pic}">
					        				<img id="photoImg2${s.index+1}" alt=""   style="width: 200px;height: 160px;" src="resource/images/login_bg.jpg"/>
					        			</c:if>
					        			<img class="imgDel" alt=""   style="width: 20px;height: 20px;" src="resource/shop/mobile/images/delete_1.png" onclick="deleteRows('${s.index+1}');"/>
				        			</div>

				        			<div id="editDiv${s.index+1}" >
				        				<a class="easyui-linkbutton" iconcls="icon-edit" href="javascript:void(0);" onclick="modifyRows('${s.index+1}');">编辑</a>
				        			</div>
								</dd>
							</c:forEach>
			       		</c:if>
	       			</dl>
		       		<dd style="margin:20px 0px;">
						<a class="easyui-linkbutton" iconcls="icon-add" href="javascript:void(0);" onclick="addRows(this);">增加图片</a>
					</dd>
			    </div>
			    <!-- ================= 图片结束=================== -->
			</div>
	        	<div class="f_reg_but" style="clear:both">
	    			<input type="button" value="保存" class="l_button" onclick="toSubmit();"/>
	      			<input type="button" value="返回" class="b_button" onclick="toback();"/>
	     		</div>

				<div id="wareLevelDlg" closed="true" class="easyui-dialog"  title="客户等级对应商品价格信息"  style="width:500px;height:300px;padding:10px">
					<iframe  name="wareLevelDlgFrm" id="wareLevelDlgFrm" frameborder="0"    width="100%" style="height: 200px"></iframe>
				</div>
				<div id="wareCustomerTypeDlg" closed="true" class="easyui-dialog"  title="客户类型对应商品价格信息"  style="width:500px;height:300px;padding:10px">
					<iframe  name="wareCustomerTypeDlgFrm" id="wareCustomerTypeDlgFrm" frameborder="0"    width="100%" style="height: 200px"></iframe>
				</div>
				<div id="wareAutoPriceDlg" closed="true" class="easyui-dialog"  title="商品销售投入费用项目"  style="width:500px;height:300px;padding:10px">
					<iframe  name="wareAutoPriceDlgFrm" id="wareAutoPriceDlgFrm" frameborder="0"    width="100%" style="height: 200px"></iframe>
				</div>
	  		</form>

	    <script type="text/javascript">
		   function toSubmit(){
				if ($.formValidator.pageIsValid()==true){
					var bUnit=$("#bUnit").val();
					var sUnit=$("#sUnit").val();
					if(bUnit==""){
						$("#bUnit").val(1);
					}
					if(sUnit==""){
						$("#sUnit").val(1);
					}
					calUnit();
					if($("#inPrice").val()==""){
						$("#inPrice").val(0);
					}
					if($("#wareDj").val()==""){
						$("#wareDj").val(0);
					}
					var wareTypeId=$("#waretype").val();
				  	var check =	checkWareTypeLeaf(wareTypeId);
				  	if(check==false){
				  		//alert("商品类别请选择最末节点");
						if(!window.confirm("商品类别未选择最末节点,如果继续操作商品将归属到未分类!")){
							return;
						}
						$("#waretype").val(-1);
					}
					var subId = document.getElementsByName("subId");
					var subIds = '${subIds}';
					if(subId!=undefined){
						for(var i=0;i<subId.length;i++){
							var id = subId[i].value;
							if(id!=""){
								subIds = subIds.replace(id+",",'');
							}
						}
					}
					document.getElementById("delSubIds").value=subIds;

					var unitCheck = $("input[name='unitCheck']:checked").val();

					if(unitCheck==1){
						$("#sunitFront").attr('checked',true);
					}else{
						$("#sunitFront").attr('checked',false);
					}

					//easyUi的from表单的ajax请求接口
					$("#warefrm1").form('submit',{
						type:"POST",
						//url:"manager/operware",
						onSubmit: function(param){//参数
							param.delPicIds = delPicIds;
					    },
						success:function(data){
							if(data=="1"){
								alert("添加成功");
								toback();
							}else if(data=="2"){
								alert("修改成功");
								toback();
							}else if(data=="-2"){
								alert("该商品名称已存在了");
								return;
							}else if(data=="-3"){
								alert("该商品编码已存在了");
								return;
							}else if(data == "-4"){
								alert("该商品小单位条码已存在了");
								return;
							}else if(data =="-5"){
								alert("该商品大单位条码已存在了");
								return;
							}else{
								alert("操作失败");
							}
						}
					});
				}
			}
		    function setTypeWare(typeId){
		    	$("#waretype").val(typeId);
				var bool =  checkWareTypeLeaf(typeId);
				if(!bool){
					alert("商品类别未选择最末节点，未更改将会自动归到未分类商品类别！");
				}
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

			function toback(){
				window.parent.$('#editdlg').dialog('close');
				window.parent.reloadware();
				//location.href="${base}/manager/towares?wtype="+$("#waretype").val();
			}
			$(function(){
			    var waretype ="${ware.waretype}";
			    var wareId ="${ware.wareId}";
			    if(waretype){
			       $("#waretype").val(waretype);
			    }else{
			       $("#waretype").val("${wtype}");
			    }
			    $.formValidator.initConfig();
			    $("#wareNm").formValidator({onShow:"请输入(25个字以内)",onFocus:"请输入(25个字以内)",onCorrect:"通过"}).inputValidator({min:1,max:50,onError:"请输入(25个字以内)"});
			    if(wareAutoCodeConfig=='none'){
					$("#wareCode").formValidator({onShow:"请输入(20个字符以内)",onFocus:"请输入(20个字符以内)",onCorrect:"通过"}).inputValidator({min:1,max:20,onError:"请输入(20个字符以内)"});
				}
			    $("#wareGg").formValidator({onShow:"请输入(10个字以内)",onFocus:"请输入(10个字以内)",onCorrect:"通过"}).inputValidator({min:1,max:20,onError:"请输入(10个字以内)"});
			    $("#wareDw").formValidator({onShow:"请输入(5个字以内)",onFocus:"请输入(5个字以内)",onCorrect:"通过"}).inputValidator({min:1,max:10,onError:"请输入(5个字以内)"});
			    //$("#wareDj").formValidator({onShow:"请输单价",onFocus:"请输单价"}).regexValidator({regExp:"money",dataType:"enum",onError:"单价格式不正确"});
			    //$("#minUnit").formValidator({onShow:"请输入(5个字以内)",onFocus:"请输入(5个字以内)",onCorrect:"通过"}).inputValidator({min:1,max:10,onError:"请输入(5个字以内)"});
			    //$("#hsNum").formValidator({onShow:"请输入(5个字以内)",onFocus:"请输入(5个字以内)",onCorrect:"通过"}).inputValidator({min:1,max:20,onError:"请输入(5个字以内)"});
			    var isCy = "${ware.isCy}";
				if(isCy!=""){
				   document.getElementById("isCy"+isCy).checked=true;
				}
				var status = "${ware.status}";
				if(status!=""){
				   document.getElementById("status"+status).checked=true;
				}else{
					document.getElementById("status1").checked=true;
				}

				var wareCode = "${ware.wareCode}";
				if(wareCode!=""){
					document.getElementById("wareCode").readOnly=true;
				}

				$('#waretypecomb').combotree('setValue', '${wareType.waretypeNm}');

				$("#sUnit").attr("readonly",'${wareIsUse}');
				//$("#bUnit").attr("readonly",'${wareIsUse}');
				var bool = true;
				 if(wareHsBili=='none'){
					 bool = true;
				 }else{
					 bool = false;
				 }
				$("#sUnit").attr("readonly",bool);
				//$("#bUnit").attr("readonly",bool);

				if('${ware.sunitFront}'=='1'){
					$("#sUnitCheck").attr('checked','true');
				}else{
					$("#bUnitCheck").attr('checked','true');
				}

				if(wareId==""){
					$("#sUnit").attr("readonly",false);
					//$("#bUnit").attr("readonly",false);
				}
				//var a = $("input[name='unitCheck']:checked").val();
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
					return false;
				}
			    if('' != oInput.value.replace(/\d{1,}\.{0,1}\d{0,}/,''))
			    {
			        oInput.value = oInput.value.match(/\d{1,}\.{0,1}\d{0,}/) == null ? '' :oInput.value.match(/\d{1,}\.{0,1}\d{0,}/);
			    }
			    return true;
			}

           function CheckInInt(oInput)
           {
               if(window.event.keyCode==37||window.event.keyCode==37){
                   return false;
               }
               if('' != oInput.value.replace(/\d{1,}/,''))
               {
                   oInput.value = oInput.value.match(/\d{1,}/) == null ? '' :oInput.value.match(/\d{1,}/);
               }
               return true;
           }

			function checkBUnit(input){
				if(CheckInInt(input)){
					if(input.value < 1){
						input.value = 1;
					}
				}
			}
		   function checkSUnit(input){
			   if(CheckInFloat(input)){
				   if(!input.value){
					   input.value = 1;
				   }
			   }
		   }

			//*************************图片相关：开始******************************************
			//显示图片
			function showPictrue(n){
				console.log("showPictrue:"+n);
				var r= new FileReader();
				f=document.getElementById("file2"+n).files[0];
				r.readAsDataURL(f);
				r.onload=function  (e) {
					document.getElementById('photoImg2'+n).src=this.result;
				}
				//修改时记录要删除的图片id
				if(Number(len)>=Number(n)){
					var picId = $("#subId"+n).val();
					console.log("picId:"+picId);
					if(picId!=null && picId!=undefined && picId!=""){
						//记录删除的图片id
						if(delPicIds==""){
							delPicIds=""+picId;
						}else{
							delPicIds+=","+picId;
						}
						console.log(delPicIds);
					}
				}
			}

			//添加照片
			var index="${len}";
			var len="${len}";//记录个数
			function addRows(obj){
				index++;
				var strs = "<dd id=\"ddphoto"+index+"\">";
				strs+="<span class=\"title\">";
				strs+="<div class=\"divDel\">";
				strs+="<img id=\"photoImg2"+index+"\" alt=\"\" style=\"width: 200px;height: 160px;\" src=\"resource/images/login_bg.jpg\" />";
				strs+="<img class=\"imgDel\" src=\"resource/shop/mobile/images/delete_1.png\" onclick=\"deleteRows('"+index+"');\" />"
				strs+="</div>";
				strs+="<div id=\"editDiv"+index+"\">";
				strs+="<input type=\"file\" accept=\"image/*\" name=\"file2"+index+"\" id=\"file2"+index+"\" onchange=\'showPictrue("+index+")\'  class=\"uploadFile\"/>";
				strs+="</div>";
				strs+="</dd>";
				$("#dl2").append(strs);
			}

			//删除照片
			var delPicIds="";
			function deleteRows(c){
				var picId = $("#subId"+c).val();
				if(picId!=null && picId!=undefined && picId!=""){
					//记录删除的图片id
					if(delPicIds==""){
						delPicIds=""+picId;
					}else{
						delPicIds+=","+picId;
					}
				}
				var ddphoto = document.getElementById("ddphoto"+c);
				ddphoto.parentNode.removeChild(ddphoto);
			}
			//编辑图片
			function modifyRows(n){
				var str="<input type='file' accept='image/*' name='file2"+n+"' id='file2"+n+"'  onchange='showPictrue("+n+")'   class='uploadFile'/>";
				if($("#file2"+n+"").length>0){
				}else{
					$("#editDiv"+n).append(str);
				}
			}
			//*************************图片相关：结束******************************************

		   function wareLevelDialog(wareId){
			   document.getElementById("wareLevelDlgFrm").src='${base}/manager/levelpriceoneware?wareId='+wareId;
			   $('#wareLevelDlg').dialog('open');
		   }

		   function wareCustomerTypeDialog(wareId){
			   document.getElementById("wareCustomerTypeDlgFrm").src='${base}/manager/qdtypepriceoneware?wareId='+wareId;
			   $('#wareCustomerTypeDlg').dialog('open');
		   }

		   function wareAutoPriceDialog(wareId){
			   document.getElementById("wareAutoPriceDlgFrm").src='${base}/manager/autopriceoneware?wareId='+wareId;
			   $('#wareAutoPriceDlg').dialog('open');
		   }

		   if(showDesc=='true'){
			   $(".showClass").show();
		   }else{
			   $(".showClass").hide();
		   }
		   if(showYxDesc=='true'){
			   $(".showYxClass").show();
		   }else{
			   $(".showYxClass").hide();
		   }
		   if(showPosDesc=='true'){
			   $(".showPosClass").show();
		   }else{
			   $(".showPosClass").hide();
		   }
		   if(showShopDesc=='true'){
			   $(".showShopClass").show();
		   }else{
			   $(".showShopClass").hide();
		   }
		   if(showPlatShopDesc=='true'){
			   $(".showPlatShopClass").show();
		   }else{
			   $(".showPlatShopClass").hide();
		   }


		   //大小单位显示和默认切换方法
		   function priceShowChange(th,load){
			   var shopWarePriceShow=$("input[name='shopWarePriceShow']").prop('checked');
			   var shopWareSmallPriceShow=$("input[name='shopWareSmallPriceShow']").prop('checked');
			   var shopWarePriceDefault0=$("input:radio[name='shopWarePriceDefault'][value='0']");//大单位默认
			   var shopWarePriceDefault1=$("input:radio[name='shopWarePriceDefault'][value='1']");

			   if(!shopWarePriceShow&&!shopWareSmallPriceShow){//两个同时不显示
				   $(th).prop("checked",true);
				   alert("大小单位不能两个同时隐藏");
				   return false;
			   }
			   if(!$("#wareDw").val()&&!$("#wareGg").val()&&!$("#minUnit").val()&&!$("#minWareGg").val()){
				   alert("大小单位名称或规格不能同时为空");
				   return false;
			   }
			   //如果显示大单位时验证名称和规格是否有填写
			   if(shopWarePriceShow&&!$("#wareDw").val()&&!$("#wareGg").val()){
				   if(!load)
					   alert("大单位名称规格未设置");
				   $("input[name='shopWarePriceShow']").prop('checked',false);
				   //$("input[name='shopWareSmallPriceShow']").prop('checked',true);
				   $(shopWarePriceDefault0).prop("checked",false);
				   $(shopWarePriceDefault0).prop("disabled",true);
				   $(shopWarePriceDefault1).prop("checked",true);
				   return false;
			   }
			   //如果显示小单位时验证名称和规格是否有填写
			   if(shopWareSmallPriceShow&&!$("#minUnit").val()&&!$("#minWareGg").val()){
				   if(!load)
					   alert("小单位名称规格未设置");
				   $("input[name='shopWarePriceShow']").prop('checked',true);
				   $("input[name='shopWareSmallPriceShow']").prop('checked',false);
				   $(shopWarePriceDefault1).prop("checked",false);
				   $(shopWarePriceDefault1).prop("disabled",true);
				   $(shopWarePriceDefault0).prop("checked",true);
				   return false;
			   }

			   //如果大单位不显示时默认需要选中小单位
			   if(!shopWarePriceShow&&shopWareSmallPriceShow){//大单位不显示
				   $(shopWarePriceDefault1).prop("checked",true);
				   $(shopWarePriceDefault0).prop("disabled",true);
				   $(shopWarePriceDefault1).prop("disabled",false);
			   }else if(shopWarePriceShow&&!shopWareSmallPriceShow){//小单位不显示
				   $(shopWarePriceDefault0).prop("checked",true);
				   $(shopWarePriceDefault1).prop("disabled",true);
				   $(shopWarePriceDefault0).prop("disabled",false);
			   }else{
				   $(shopWarePriceDefault0).prop("disabled",false);
				   $(shopWarePriceDefault1).prop("disabled",false);
			   }
		   }
		</script>
	</body>
</html>
