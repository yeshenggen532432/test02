<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>商品版本</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }

        .tyWidth {
            width: 200px
        }

        /*lable左对齐*/
        .form-horizontal .control-label {
            text-align: left;
        }

        /*去掉阴影*/
        .layui-card {
            box-shadow: 0 0 0 0 rgba(0, 0, 0, 0);
        }

        .uglcw-radio .k-radio-label:before {
            width: 12px;
            height: 12px;
        }

        .k-textbox {
            border-color: #c5c5c5;
        }

        .k-dropdown-wrap.k-state-default {
            border-color: #c5c5c5;
        }
    </style>
    <script>
        var showDesc = '${permission:checkUserButtonPdm("uglcw.sysWare.showAllDesc")}';
        var showYxDesc = '${permission:checkUserButtonPdm("uglcw.sysWare.showYxDesc")}';
        var showInPrice = '${permission:checkUserButtonPdm("uglcw.sysWare.showInPrice")}';
        var showSalePrice = '${permission:checkUserButtonPdm("uglcw.sysWare.showSalePrice")}';
        var showPosPrice = '${permission:checkUserButtonPdm("uglcw.sysWare.showPosPrice")}';
        var showShopPrice = '${permission:checkUserButtonPdm("uglcw.sysWare.showShopPrice")}';
        var showPosDesc = '${permission:checkUserButtonPdm("uglcw.sysWare.showPosDesc")}';
        var showShopDesc = '${permission:checkUserButtonPdm("uglcw.sysWare.showShopDesc")}';
        var showPlatShopDesc = '${permission:checkUserButtonPdm("uglcw.sysWare.showPlatShopDesc")}';
        var wareAutoCodeConfig = '${fns:checkFieldDisplay("sys_config","*","code=\"CONFIG_WARE_AUTO_CODE\"  and status=1")}';
        var wareHsBili = '${fns:checkFieldDisplay("sys_config","*","code=\"CONFIG_WARE_MODIFY_HS_BILI\"  and status=1")}';
    </script>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md12">
            <div class="layui-card">
                <div class="layui-card-header" style="display: none">
                    <input type="hidden" uglcw-role="textbox" id="click_flag" value="${param.click_flag}">
                </div>
                <div class="layui-card-body">
                    <form class="form-horizontal" uglcw-role="validator">
                        <div uglcw-role="tabs">
                            <ul>
                                <li>一、商品基本信息</li>
                                <li>二、进销存商品信息</li>
                                <li class="showPosClass">三、收银系统商品信息</li>
                                <li class="showShopClass">四、自营商城商品信息</li>
                                <li class="showPlatShopClass">五、平台商城商品信息</li>
                                <li>商品图片</li>
                            </ul>
                            <%--======================商品基本信息:start===========================--%>
                            <div>
                                <div class="layui-col-md12">
                                    <div class="layui-card">
                                        <div class="layui-card-body">
                                            <input type="hidden" uglcw-model="putOn" uglcw-role="textbox" id="putOn"
                                                   value="${ware.putOn}"/>
                                            <input type="hidden" uglcw-model="addRate" uglcw-role="textbox" id="addRate"
                                                   value="${ware.addRate}"/>
                                            <input type="hidden" uglcw-model="wareId" uglcw-role="textbox" id="wareId"
                                                   value="${ware.wareId}"/>
                                            <input type="hidden" uglcw-model="fbtime" uglcw-role="textbox" id="fbtime"
                                                   value="${ware.fbtime}"/>
                                            <input type="hidden" uglcw-model="sort" uglcw-role="textbox" id="sort"
                                                   value="${ware.sort}"/>
                                            <c:set var="subIds" value=""/>
                                            <input type="hidden" uglcw-model="delSubIds" id="delSubIds"
                                                   uglcw-role="textbox"/>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">1.商品编号:</label>
                                                <div class="col-xs-6">
                                                    <input style="width: 200px;" uglcw-model="wareCode" id="wareCode"
                                                           uglcw-role="textbox" value="${ware.wareCode}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">2.商品名称*:</label>
                                                <div class="col-xs-6">
                                                    <input style="width: 200px;" uglcw-model="wareNm" id="wareNm"
                                                           uglcw-role="textbox" uglcw-validate="required" maxlength="25"
                                                           value="${ware.wareNm}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">3.助记码:</label>
                                                <div class="col-xs-6">
                                                    <input style="width: 200px;" uglcw-model="py" id="py"
                                                           uglcw-role="textbox" value="${ware.py}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">4.商品品牌:</label>
                                                <div class="col-xs-6" style="width: 200px">
                                                    <tag:select2 id="brandId" name="brandId" headerKey="" headerValue=""
                                                                 value="${ware.brandId}" displayKey="id"
                                                                 displayValue="name" tableName="sys_brand">
                                                    </tag:select2>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">5.商品类别:</label>
                                                <div class="col-xs-4">
                                                    <input type="hidden" uglcw-model="waretype" uglcw-role="textbox" id="waretype"
                                                           value="${not empty ware.waretype ? ware.waretype: param.wtype}"/>
                                                    <input uglcw-role="gridselector"  id="waretypeNm" uglcw-model="waretypeNm" value="${not empty ware.waretypeNm ? ware.waretypeNm: wareType.waretypeNm}"
                                                               placeholder="请选择商品类别"
                                                               uglcw-options="allowInput: false,clearButton: false"/>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">6.销售原价(大)：</label>
                                                <div class="col-xs-6 showSalePrice" style="width: 200px;">
                                                    <input uglcw-model="lsPrice" id="lsPrice" uglcw-role="textbox"
                                                           value="${ware.lsPrice}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">7.销售原价(小)：</label>
                                                <div class="col-xs-6 showSalePrice" style="width: 200px">
                                                    <input uglcw-model="minLsPrice" id="minLsPrice" uglcw-role="textbox"
                                                           value="${ware.minLsPrice}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">8.多规格商品组名:</label>
                                                <%--  <div class="col-xs-4">
                                                      <input type="hidden" uglcw-model="aliasName" id="multiSpecId"
                                                             uglcw-role="textbox" value="${ware.multiSpecId}">
                                                      <input style="width: 200px;" uglcw-model="multiSpecNm"
                                                             id="multiSpecNm"
                                                             uglcw-role="textbox" value="${ware.multiSpecNm}" readonly>
                                                  </div>
                                                  --%>
                                                <div class="col-xs-6" style="width: 200px">
                                                    <tag:select2 id="groupId" name="groupId" headerKey="" headerValue=""
                                                                 value="${ware.groupId}" displayKey="id"
                                                                 displayValue="group_name"
                                                                 tableName="sys_warespec_group">
                                                    </tag:select2>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">10.多规格商品属性:</label>
                                                <div class="col-xs-4">
                                                    <input style="width: 200px;" uglcw-model="attribute"
                                                           id="attribute"
                                                           uglcw-role="textbox" value="${ware.attribute}">
                                                </div>
                                            </div>

                                            <div class="form-group">
                                                <label class="control-label col-xs-4">11.生产厂商:</label>
                                                <div class="col-xs-4">
                                                    <input style="width: 200px;" uglcw-model="providerName"
                                                           id="providerName"
                                                           uglcw-role="textbox" value="${ware.providerName}">
                                                </div>

                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">12.保&nbsp;质&nbsp;期：</label>
                                                <div class="col-xs-4">
                                                    <input style="width: 200px;" uglcw-model="qualityDays"
                                                           id="qualityDays"
                                                           uglcw-role="textbox" value="${ware.qualityDays}">
                                                </div>

                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">13.是否常用:</label>
                                                <div class="col-xs-4">
                                                    <ul uglcw-role="radio" uglcw-model="isCy"
                                                        uglcw-value="1"
                                                        uglcw-options='layout:"horizontal",
                                                             dataSource:[{"text":"是","value":"1"},{"text":"否","value":"2"}]
                                                 '></ul>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">14.是否启用:</label>
                                                <div class="col-xs-4">
                                                    <ul uglcw-role="radio" uglcw-model="status"
                                                        uglcw-value="1"
                                                        uglcw-options='layout:"horizontal",
                                                             dataSource:[{"text":"是","value":"1"},{"text":"否","value":"2"}]
                                                 '></ul>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">15.运输费用:</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="tranAmt" id="tranAmt"
                                                           uglcw-role="textbox" value="${ware.tranAmt}"/>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">16.备&nbsp;&nbsp;&nbsp;&nbsp;注：</label>
                                                <div class="col-xs-6">
                                                    <textarea uglcw-model="remark" id="remark" uglcw-role="textbox"
                                                    >${ware.remark}</textarea>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">17.标识码:</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="asnNo" id="asnNo"
                                                           uglcw-role="textbox" value="${ware.asnNo}"/>
                                                </div>
                                            </div>

                                            <div class="form-group" style="display: none">
                                                <label class="control-label col-xs-4">18.提成费用:</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="tcAmt" id="tcAmt"
                                                           uglcw-role="textbox" value="${ware.tcAmt}"/>
                                                </div>
                                            </div>

                                        </div>
                                    </div>
                                </div>
                            </div>

                            <%--======================进销存商品信息:start===========================--%>
                            <div>
                                <div class="layui-col-md12">
                                    <div class="layui-card">
                                        <div class="layui-card-body">
                                            <span>(一)大单位信息</span>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">1.大单位名称：</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="wareDw" uglcw-role="textbox" value="${ware.wareDw}"
                                                    <%-- uglcw-validate="required"--%> maxlength="5" id="wareDw">
                                                </div>
                                                <div class="col-xs-4">
                                                    <ul uglcw-role="radio" uglcw-model="sunitFront" id="bUnitCheck"
                                                        uglcw-value="${ware.sunitFront}"
                                                        uglcw-options='layout:"horizontal",
                                                             checkDefault: false,
                                                             dataSource:[{"text":"默认主单位","value":"0"}]
                                                 '></ul>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">2.规格(大)：</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="wareGg" uglcw-role="textbox" value="${ware.wareGg}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">3.条码(大)：</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="packBarCode" uglcw-role="textbox"
                                                           value="${ware.packBarCode}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">4.采购价(大)：</label>
                                                <div class="col-xs-6 showInPrice">
                                                    <input uglcw-model="inPrice" uglcw-role="textbox"
                                                           value="${ware.inPrice}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">5.批发价(大)：</label>
                                                <div class="col-xs-6 showSalePrice">
                                                    <input uglcw-model="wareDj" uglcw-role="textbox" value="${ware.wareDj}"
                                                    >
                                                    <a style="color:blue;"
                                                       onclick="wareCustomerTypeDialog(${ware.wareId},1)">按客户类型设置</a>
                                                </div>
                                            </div>

                                            <div class="form-group" style="display: none">
                                                <label class="control-label col-xs-4">7.大单位分销价：</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="fxPrice" uglcw-role="textbox"
                                                           value="${ware.fxPrice}">
                                                </div>
                                            </div>
                                            <div class="form-group" style="display: none">
                                                <label class="control-label col-xs-4">8.大单位促销价：</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="cxPrice" uglcw-role="textbox"
                                                           value="${ware.cxPrice}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">6.预警最低数量：</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="warnQty" uglcw-role="textbox"
                                                           value="${ware.warnQty}">
                                                </div>
                                            </div>
                                            <span>(二)小单位信息</span>
                                            <div class="form-group">
                                                <input type="hidden" uglcw-role="textbox" uglcw-model="maxUnitCode"
                                                       id="maxUnitCode"
                                                       value="${ware.maxUnitCode}"/>
                                                <input type="hidden" uglcw-role="textbox" uglcw-model="minUnitCode"
                                                       id="minUnitCode"
                                                       value="${ware.minUnitCode}"/>
                                                <label class="control-label col-xs-4">1.小单位名称：</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="minUnit" uglcw-role="textbox" id="minUnit"
                                                           value="${ware.minUnit}"
                                                           maxlength="15">
                                                </div>
                                                <div class="col-xs-4">
                                                    <ul uglcw-role="radio" uglcw-model="sunitFront" id="sUnitCheck"
                                                        uglcw-value="${ware.sunitFront}"
                                                        uglcw-options='layout:"horizontal",
                                                             checkDefault: false,
                                                             dataSource:[{"text":"默认主单位","value":"1"}]
                                                 '></ul>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">2.规格(小)：</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="minWareGg" uglcw-role="textbox"
                                                           value="${ware.minWareGg}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">3.条码(小)：</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="beBarCode" uglcw-role="textbox"
                                                           value="${ware.beBarCode}">
                                                </div>
                                            </div>
                                            <div class="form-group showClass">
                                                <label class="control-label col-xs-4">4.采购价(小)：</label>
                                                <div class="col-xs-6 showInPrice">
                                                    <input uglcw-model="minInPrice" uglcw-role="textbox"
                                                           value="${ware.minInPrice}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">5.批发价(小)：</label>
                                                <div class="col-xs-6 showSalePrice">
                                                    <input uglcw-model="sunitPrice" uglcw-role="textbox"
                                                           value="${ware.sunitPrice}">
                                                    <a style="color:blue;"
                                                       onclick="wareCustomerTypeDialog(${ware.wareId},0)">按客户类型设置</a>
                                                </div>
                                            </div>

                                            <div class="form-group" style="display: none">
                                                <label class="control-label col-xs-4">7.小单位分销价*：</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="minFxPrice" uglcw-role="textbox"
                                                           value="${ware.minFxPrice}">
                                                </div>
                                            </div>
                                            <div class="form-group" style="display: none">
                                                <label class="control-label col-xs-4">8.小单位促销价*：</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="minCxPrice" uglcw-role="textbox"
                                                           value="${ware.minCxPrice}">
                                                </div>
                                            </div>
                                            <div class="form-group showClass">
                                                <label class="control-label col-xs-4">6.预警最低库存数量：</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="minWarnQty" uglcw-role="textbox"
                                                           value="${ware.minWarnQty}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">7.大小单位换算比例*：</label>
                                                <div class="col-xs-10" style="display: inline-flex">
                                                    <input uglcw-model="bUnit" id="bUnit" uglcw-role="numeric"
                                                    <c:if test="${ware.bUnit == null}">
                                                           onchange="if(this.value !=1){uglcw.ui.error('只能输入1');this.value=1;return false;}"
                                                    </c:if>
                                                           style="width: 250px;"
                                                    <c:if test="${ware.bUnit != null and ware.bUnit == 1}">
                                                           readonly="readonly"
                                                    </c:if>
                                                           uglcw-options="spinners: false, min:1, decimals: 0"
                                                           value="${ware.bUnit == null ? 1 :ware.bUnit}">
                                                    <span style="width: 250px; text-align: center;">*大单位=</span>

                                                    <input style="width: 250px;" uglcw-model="sUnit" id="sUnit"
                                                           uglcw-role="numeric"
                                                           uglcw-options="spinners: false"
                                                           value="${ware.sUnit == null ? 1 :ware.sUnit}"
                                                           onchange="if(!this.value ){this.value=1;return false;}">
                                                    <span style="width: 250px; text-align: center">*小单位</span>

                                                    <input style="width: 250px;" uglcw-model="hsNum" id="hsNum"
                                                           uglcw-role="textbox"
                                                           value="${ware.hsNum == null ?1 :ware.hsNum}" readonly>
                                                </div>
                                            </div>
                                            <c:if test="${not empty ware.wareId}">
                                                <span class="showYxClass" style="display: none">(三) 商品营销信息</span>
                                                <div class="form-group showYxClass" style="display: none">
                                                    <label class="control-label col-xs-4">1.客户类型商品销售价格设置：</label>
                                                    <div class="col-xs-6">
                                                        <a style="color:blue;"
                                                           onclick="wareCustomerTypeDialog(${ware.wareId})">设置</a>
                                                    </div>
                                                </div>
                                                <div class="form-group showYxClass"  style="display: none">
                                                    <label class="control-label col-xs-4">2.客户等级商品销售价设置：</label>
                                                    <div class="col-xs-6">
                                                        <a style="color:blue;"
                                                           onclick="wareLevelDialog(${ware.wareId})">设置</a>
                                                    </div>
                                                </div>

                                                <div class="form-group showYxClass" style="display: none">
                                                    <label class="control-label col-xs-4">3.商品销售投入费用项目设置：</label>
                                                    <div class="col-xs-6">
                                                        <a style="color:blue;"
                                                           onclick="wareAutoPriceDialog(${ware.wareId})">设置</a>
                                                    </div>
                                                </div>
                                                <div class="form-group showYxClass" style="display: none">
                                                    <label class="control-label col-xs-4">4.费用项目关联计算设置：</label>
                                                    <div class="col-xs-6">
                                                        <span>展开 （关联销售量货关联销售收入或销售毛利）</span>
                                                    </div>
                                                </div>
                                                <div class="form-group showYxClass" style="display: none">
                                                    <label class="control-label col-xs-4">5.费用项目投入计算：</label>
                                                    <div class="col-xs-6">
                                                        <span>展开</span>
                                                    </div>
                                                </div>
                                            </c:if>

                                        </div>
                                    </div>
                                </div>
                            </div>

                            <%--======================收银系统商品信息:start===========================--%>
                            <div class="showPosClass">
                                <div class="layui-col-md12">
                                    <div class="layui-card">
                                        <div class="layui-card-body">
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">1.门店商品别称：</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="posWareNm" uglcw-role="textbox"
                                                           value="${ware.posWareNm}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">2.门店大单位采购价：</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="posInPrice" uglcw-role="textbox"
                                                           value="${ware.posInPrice}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">3.门店大单位批发价：</label>
                                                <div class="col-xs-6 showPosPrice">
                                                    <input uglcw-model="posPfPrice" uglcw-role="textbox"
                                                           value="${ware.posPfPrice}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">4.门店大单位零售价：</label>
                                                <div class="col-xs-6 showPosPrice">
                                                    <input uglcw-model="posPrice1" uglcw-role="textbox"
                                                           value="${ware.posPrice1}">
                                                </div>
                                            </div>
                                            <div class="form-group" style="display: none">
                                                <label class="control-label col-xs-4">5.门店大单位促销价</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="posCxPrice" id="shZt"
                                                           uglcw-role="textbox" value="${ware.posCxPrice}">
                                                </div>
                                            </div>
                                            <div class="form-group" style="display: none">
                                                <label class="control-label col-xs-4">5.门店小单位采购价</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="posMinInPrice" id="posMinInPrice"
                                                           uglcw-role="textbox" value="${ware.posMinInPrice}">
                                                </div>
                                            </div>
                                            <div class="form-group" style="display: none">
                                                <label class="control-label col-xs-4">6.门店小单位批发价</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="posMinPfPrice" id="posMinPfPrice"
                                                           uglcw-role="textbox" value="${ware.posMinPfPrice}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">7.门店小单位零售价</label>
                                                <div class="col-xs-6 showPosPrice">
                                                    <input uglcw-model="posPrice2" id="posPrice2"
                                                           uglcw-role="textbox" value="${ware.posPrice2}">
                                                </div>
                                            </div>
                                            <div class="form-group" style="display: none">
                                                <label class="control-label col-xs-4">9.门店小单位促销价</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="posMinCxPrice" id="posMinCxPrice"
                                                           uglcw-role="textbox" value="${ware.posMinCxPrice}" readonly>
                                                </div>
                                            </div>


                                        </div>
                                    </div>
                                </div>
                            </div>


                            <%--======================自营商城商品信息:start===========================--%>
                            <div class="showShopClass">
                                <div class="layui-col-md12">
                                    <div class="layui-card">
                                        <div class="layui-card-body">
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">1.自营商城商品别称：</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="shopWareAlias" uglcw-role="textbox"
                                                           value="${ware.shopWareAlias}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-5">2.自营商城商品大单位</label>
                                                <div class="col-xs-16">
                                                    是否显示<input type="checkbox" name="shopWarePriceShow" value="1"
                                                               <c:if test="${ware.shopWarePriceShow==null || ware.shopWarePriceShow==1}">checked</c:if>
                                                               onchange="return priceShowChange(this)">
                                                    &nbsp;&nbsp;默认单位<input type="radio" name="shopWarePriceDefault"
                                                                           value="0"
                                                                           <c:if test="${ware.shopWarePriceShow==null || ware.shopWarePriceDefault==0}">checked</c:if>>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">2.自营商城商品大单位批发价*：</label>
                                                <div class="col-xs-6 showShopPrice">
                                                    <input uglcw-model="shopWarePrice" uglcw-role="textbox"
                                                           value="${ware.shopWarePrice}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">3.自营商城商品大单位零售价：</label>
                                                <div class="col-xs-6 showShopPrice">
                                                    <input uglcw-model="shopWareLsPrice" uglcw-role="textbox"
                                                           value="${ware.shopWareLsPrice}">
                                                </div>
                                            </div>
                                            <div class="form-group" style="display: none">
                                                <label class="control-label col-xs-4">4.自营商城商品大单位促销价*：</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="shopWareCxPrice" uglcw-role="textbox"
                                                           value="${ware.shopWareCxPrice}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-5">4.自营商城商品小单位</label>
                                                <div class="col-xs-16">
                                                    是否显示<input type="checkbox" name="shopWareSmallPriceShow" value="1"
                                                               <c:if test="${ware.shopWareSmallPriceShow==null || ware.shopWareSmallPriceShow==1}">checked</c:if>
                                                               onchange="return priceShowChange(this)">
                                                    &nbsp;&nbsp;默认单位<input type="radio" name="shopWarePriceDefault"
                                                                           value="1"
                                                                           <c:if test="${ware.shopWarePriceDefault==1}">checked</c:if>>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">5.自营商城商品小单位批发价</label>
                                                <div class="col-xs-6 showShopPrice">
                                                    <input uglcw-model="shopWareSmallPrice"
                                                           uglcw-role="textbox" value="${ware.shopWareSmallPrice}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">5.自营商城商品小单位零售价</label>
                                                <div class="col-xs-6 showShopPrice">
                                                    <input uglcw-model="shopWareSmallLsPrice" id="shopWareSmallLsPrice"
                                                           uglcw-role="textbox" value="${ware.shopWareSmallLsPrice}"
                                                    >
                                                </div>
                                            </div>
                                            <div class="form-group" style="display: none">
                                                <label class="control-label col-xs-4">7.自营商城商品小单位促销价</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="shopWareSmallCxPrice" id="shopWareSmallCxPrice"
                                                           uglcw-role="textbox" value="${ware.shopWareSmallCxPrice}"
                                                           readonly>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">6.自营商城排序</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="shopSort" id="shopSort"
                                                           uglcw-role="textbox" value="${ware.shopSort}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">9.商品简述</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="wareResume" id="wareResume" maxlength="20"
                                                           uglcw-role="textbox" value="${ware.wareResume}">
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <%--======================平台商城商品信息:start===========================--%>
                            <div class="showPlatShopClass">
                                <div class="layui-col-md12">
                                    <div class="layui-card">
                                        <div class="layui-card-body">
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">1.平台商城商品别称：</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="platshopWareNm" uglcw-role="textbox"
                                                           value="${ware.platshopWareNm}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">2.平台商城商品类别：</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="platshopWareType" uglcw-role="textbox"
                                                           value="${ware.platshopWareType}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">3.平台商城商品大单位批发价：</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="platshopWarePfPrice" uglcw-role="textbox"
                                                           value="${ware.platshopWarePfPrice}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">4.平台商城商品大单位零售价：</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="platshopWareLsPrice" uglcw-role="textbox"
                                                           value="${ware.platshopWareLsPrice}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">5.平台商城商品大单位促销价</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="platshopWareCxPrice" id="platshopWareCxPrice"
                                                           uglcw-role="textbox" value="${ware.platshopWareCxPrice}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">6.平台商城商品小单位批发价</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="platshopWareMinPfPrice"
                                                           id="platshopWareMinPfPrice"
                                                           uglcw-role="textbox" value="${ware.platshopWareMinPfPrice}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">7.平台商城商品小单位零售价</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="platshopWareMinLsPrice"
                                                           id="platshopWareMinLsPrice"
                                                           uglcw-role="textbox" value="${ware.platshopWareMinLsPrice}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">8.平台商城商品小单位促销价</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="platshopWareMinCxPrice"
                                                           id="platshopWareMinCxPrice"
                                                           uglcw-role="textbox" value="${ware.platshopWareMinCxPrice}">
                                                </div>
                                            </div>

                                            <%--======================信息备注说明:start===========================--%>

                                        </div>
                                    </div>
                                </div>
                            </div>
                            <%--======================商品图片:end===========================--%>
                            <div class="layui-col-md12">
                                <div class="layui-card">
                                    <div class="layui-card-body">
                                        <div class="form-group">
                                            <div class="col-xs-16">
                                                <div id="album" uglcw-options="cropper: false, dataSource: $.map(picList || [], function(pic){
                                                    return {
                                                        id: pic.id,
                                                        fid: pic.id,
                                                        url: '/upload/'+pic.picMini,
                                                        title: pic.pic,
                                                        picMini: pic.picMini,
                                                        pic: pic.pic,
                                                        wareId: pic.wareId
                                                    }
                                                })" uglcw-role="album"></div>
                                            </div>

                                        </div>
                                    </div>
                                </div>
                            </div>
                            <%--======================商品图片:end===========================--%>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>


<script id="product-type-selector-template" type="text/uglcw-template">
    <div class="uglcw-selector-container">
        <div style="line-height: 30px">
            已选:
            <button style="display: none;" id="__type_name" class="k-button k-info ghost"></button>
            <input type="hidden" uglcw-role="textbox" id="__type_id">
            <input type="hidden" uglcw-role="textbox" id="__upWaretypeNm">
        </div>
        <div style="padding: 2px;height: 344px;">

            <ul uglcw-role="accordion">
                <li>
                    <span>库存商品类</span>
                    <div>
                        <div uglcw-role="tree"
                             uglcw-options="
                                url:'${base}manager/syswaretypes?isType=0',
                                id:'id',
                                expandable:function(node){
                                    return node.id == '0';
                                },
                                loadFilter:function(response){
                                $(response).each(function(index,item){
                                    if(item.text=='根节点'){
                                        item.text='库存商品类'
                                    }
                                })
                                return response;
                                },
                                select: function(e){
                                    var node = this.dataItem(e.node);
                                    $('#__type_id').val(node.id);
                                      $('#__type_id').val(node.id);
                                       $('#__upWaretypeNm').val(node.text);
                                    $('#__type_name').text(node.text);
                                    $('#__type_name').show();
                                }
                            ">
                        </div>
                    </div>
                </li>
                <li>
                    <span>原辅材料类</span>
                    <div uglcw-role="tree"
                         uglcw-options="
                                url:'${base}manager/syswaretypes?isType=1',
                                id:'id',
                                expandable:function(node){
                                    return node.id == '0';
                                },
                                loadFilter:function(response){
                                $(response).each(function(index,item){
                                    if(item.text=='根节点'){
                                        item.text='原辅材料类'
                                    }
                                })
                                return response;
                                },
                                select: function(e){
                                    var node = this.dataItem(e.node);
                                    $('#__type_id').val(node.id);
                                    $('#__type_name').text(node.text);
                                     $('#__upWaretypeNm').val(node.text);
                                    $('#__type_name').show();
                                }
                            ">
                    </div>
                </li>
                <li>
                    <span>低值易耗品类</span>
                    <div uglcw-role="tree"
                         uglcw-options="
                                url:'${base}manager/syswaretypes?isType=2',
                                id:'id',
                                expandable:function(node){
                                    return node.id == '0';
                                },
                                loadFilter:function(response){
                                $(response).each(function(index,item){
                                    if(item.text=='根节点'){
                                        item.text='低值易耗品类'
                                    }
                                })
                                return response;
                                },
                                select: function(e){
                                    var node = this.dataItem(e.node);
                                    $('#__type_id').val(node.id);
                                    $('#__type_name').text(node.text);
                                      $('#__upWaretypeNm').val(node.text);
                                    $('#__type_name').show();
                                }
                            ">
                    </div>
                </li>
                <li>
                    <span>固定资产类</span>
                    <div uglcw-role="tree"
                         uglcw-options="
                                url:'${base}manager/syswaretypes?isType=3',
                                id:'id',
                                expandable:function(node){
                                    return node.id == '0';
                                },
                                loadFilter:function(response){
                                $(response).each(function(index,item){
                                    if(item.text=='根节点'){
                                      item.text='固定资产'
                                    }
                                })
                                return response;
                                },
                                select: function(e){
                                    var node = this.dataItem(e.node);
                                     $('#__type_id').val(node.id);
                                    $('#__type_name').text(node.text);
                                       $('#__upWaretypeNm').val(node.text);
                                    $('#__type_name').show();
                                }
                            ">
                    </div>
                </li>
            </ul>
        </div>
    </div>
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    var picList = ${fns:toJson(ware.warePicList)}
        $(function () {
            //ui:初始化
            uglcw.ui.init();
            uglcw.ui.loaded();
            var bool = true;
            if (wareHsBili == 'none') {
                bool = true;
            } else {
                bool = false;
            }
            $("#sUnit").attr("readonly", bool);
            //$("#bUnit").attr("readonly",bool);
            var wareId = "${ware.wareId}";
            if (wareId == "") {
                $("#sUnit").attr("readonly", false);
                //$("#bUnit").attr("readonly",false);
            }

            loadSnapshot();
        })

    if (showDesc == 'true') {
        $(".showClass").show();
    } else {
        $(".showClass").hide();
    }
    if (showYxDesc == 'true') {
        $(".showYxClass").show();
    } else {
        //$(".showYxClass").hide();
    }
    if (showPosDesc == 'true') {
        $(".showPosClass").show();
    } else {
        $(".showPosClass").hide();
    }
    if (showShopDesc == 'true') {
        $(".showShopClass").show();
    } else {
        $(".showShopClass").hide();
    }
    if (showPlatShopDesc == 'true') {
        $(".showPlatShopClass").show();
    } else {
        $(".showPlatShopClass").hide();
    }

    function loadSnapshot() {
        $.ajax({
            url: CTX + 'manager/common/bill/snapshot/${snapshotId}',
            type: 'get',
            success: function (response) {
                    var data = JSON.parse(response.data.data);
                    uglcw.ui.bind('.layui-card-body', data.query);
            }
        })
    }

    function wareLevelDialog(wareId){
        win = uglcw.ui.Modal.open({
            title: '商品客户等级价格设置',
            id: "wareLevelDialog",
            url: '${base}/manager/levelpriceoneware?wareId='+wareId,
            area: ['400px', '400px'],
            full: false,
            closable: true,
            btns: [],
            success: function (container) {
                // uglcw.ui.toast('open success');
            },
            yes: function (container) {
                // refreshCheckWare(ids);

                // uglcw.ui.Modal.close(win);
            },
            cancel: function () {
                uglcw.ui.toast('cancel');
            }
        })
        // uglcw.ui.openTab('商品客户等级价格设置', );
    }

    function wareCustomerTypeDialog(wareId,op){
        win = uglcw.ui.Modal.open({
            title: '商品客户类型价格设置',
            id: "wareCustomerTypeDialog",
            url: '${base}/manager/qdtypepriceoneware?op='+op+'&wareId='+wareId,
            area: ['400px', '400px'],
            full: false,
            closable: true,
            btns: [],
            success: function (container) {
                // uglcw.ui.toast('open success');
            },
            yes: function (container) {
                // refreshCheckWare(ids);

                // uglcw.ui.Modal.close(win);
            },
            cancel: function () {
                //  uglcw.ui.toast('cancel');
            }
        })
        //uglcw.ui.openTab('商品客户类型价格设置', );
    }
</script>
</body>
</html>
