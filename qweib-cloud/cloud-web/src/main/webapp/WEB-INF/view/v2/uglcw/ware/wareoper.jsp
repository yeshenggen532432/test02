<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>编辑商品信息</title>
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
            text-align: right;
        }
        /*去掉阴影*/
        .layui-card {
            box-shadow: 0 0 0 0 rgba(0, 0, 0, 0);
        }
        .uglcw-radio .k-radio-label:before {
            width: 12px;
            height: 12px;
        }
        .k-textbox,.k-numeric-wrap {
            border-color: #c5c5c5!important;
        }
        .k-dropdown-wrap.k-state-default {
            border-color: #c5c5c5;
        }
    </style>
    <script>
        var showDesc = '${permission:checkUserButtonPdm("uglcw.sysWare.showAllDesc")}';
        <%--var showYxDesc = '${permission:checkUserButtonPdm("uglcw.sysWare.showYxDesc")}';--%>
        var showYxDesc = 'false';
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
                <div class="layui-card-header">
                    <input type="hidden" uglcw-role="textbox" id="click_flag" value="${param.click_flag}">
                    <c:choose>
                        <c:when test="${!empty sourceShop}">
                            <button id="save" uglcw-role="button" class="k-info" onclick="toSumbit(0);">保存至商城下架</button>
                            <button id="save" uglcw-role="button" class="k-info" onclick="toSumbit(1);">保存并上架商城</button>
                        </c:when>
                        <c:otherwise>
                            <button id="save" uglcw-role="button" class="k-info" onclick="toSumbit('');">保存</button>
                            <button id="cancel" uglcw-role="button" class="k-default" onclick="toback();">返回</button>
                        </c:otherwise>
                    </c:choose>
                    <div class="bill-info">
                        <input type="hidden" id="snapshotId" uglcw-role="textbox" uglcw-model="snapshot"/>
                        <div id="snapshot" onclick="showSnapshot()" style="border: none;"  class="k-info ghost">
                            快照<i class="k-icon k-i-clock"></i>
                            <sup class="snapshot-badge-dot"></sup>
                        </div>
                    </div>
                </div>
                <div class="layui-card-body">
                    <form class="form-horizontal" uglcw-role="validator">
                        <div uglcw-role="tabs">
                            <ul>
                                <li>一、商品基本信息</li>
                                <li>二、商品辅助信息</li>
                                <li class="showPosClass">三、收银系统商品信息</li>
                                <li class="showShopClass">四、自营商城商品信息</li>
                                <li class="showPlatShopClass hide">五、平台商城商品信息</li>
                                <li class="hide">商品图片</li>
                            </ul>
                            <%--======================商品基本信息:start===========================--%>
                            <div>
                                <div class="layui-col-md12">
                                    <div class="layui-card">
                                        <div class="layui-card-body">
                                            <input type="hidden" uglcw-model="putOn" uglcw-role="textbox" id="putOn" value="${ware.putOn}"/>
                                            <input type="hidden" uglcw-model="addRate" uglcw-role="textbox" id="addRate" value="${ware.addRate}"/>
                                            <input type="hidden" uglcw-model="wareId" uglcw-role="textbox" id="wareId" value="${ware.wareId}"/>
                                            <input type="hidden" uglcw-model="fbtime" uglcw-role="textbox" id="fbtime" value="${ware.fbtime}"/>
                                            <input type="hidden" uglcw-model="sort" uglcw-role="textbox" id="sort" value="${ware.sort}"/>
                                            <c:set var="subIds" value=""/>
                                            <input type="hidden" uglcw-model="delSubIds" id="delSubIds" uglcw-role="textbox"/>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">1.商品编号:</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="wareCode" id="wareCode" uglcw-role="textbox" value="${ware.wareCode}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">2.商品名称*:</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="wareNm" id="wareNm"  uglcw-role="textbox" uglcw-validate="required" maxlength="25" value="${ware.wareNm}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">3.商品类别:</label>
                                                <div class="col-xs-4">
                                                    <input type="hidden" uglcw-model="waretype" uglcw-role="textbox" id="waretype" value="${not empty ware.waretype ? ware.waretype: param.wtype}"/>
                                                    <input uglcw-role="gridselector"  id="waretypeNm" uglcw-model="waretypeNm" value="${not empty ware.waretypeNm ? ware.waretypeNm: wareType.waretypeNm}" placeholder="请选择商品类别" uglcw-options="allowInput: false,clearButton: false,click: selectType"/>
                                                </div>
                                            </div>
                                            <span>(一)大单位信息</span>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">1.大单位名称：</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="wareDw" uglcw-role="textbox" value="${ware.wareDw}" maxlength="5" id="wareDw">
                                                </div>
                                                <div class="col-xs-4">
                                                    <ul uglcw-role="radio" uglcw-model="sunitFront" id="bUnitCheck" uglcw-value="${ware.sunitFront}"
                                                        uglcw-options='layout:"horizontal", checkDefault: false, dataSource:[{"text":"默认主单位","value":"0"}] '>
                                                    </ul>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">2.规格(大)：</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="wareGg" uglcw-role="textbox" value="${ware.wareGg}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">3.采购价(大)：</label>
                                                <div class="col-xs-6 showInPrice">
                                                    <input uglcw-model="inPrice" uglcw-role="textbox" value="${ware.inPrice}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">4.批发价(大)：</label>
                                                <div class="col-xs-6 showSalePrice">
                                                    <input uglcw-model="wareDj" uglcw-role="textbox" value="${ware.wareDj}">
                                                    <%--<a style="color:blue;" onclick="wareCustomerTypeDialog(${ware.wareId},1)">按客户类型设置</a>--%>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">5.销售原价(大)：</label>
                                                <div class="col-xs-6 showSalePrice">
                                                    <input uglcw-model="lsPrice" id="lsPrice" uglcw-role="textbox" value="${ware.lsPrice}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">6.条码(大)：</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="packBarCode" uglcw-role="textbox" value="${ware.packBarCode}">
                                                </div>
                                            </div>

                                            <span>(二)小单位信息</span>
                                            <div class="form-group">
                                                <input type="hidden" uglcw-role="textbox" uglcw-model="maxUnitCode" id="maxUnitCode" value="${ware.maxUnitCode}"/>
                                                <input type="hidden" uglcw-role="textbox" uglcw-model="minUnitCode" id="minUnitCode" value="${ware.minUnitCode}"/>
                                                <label class="control-label col-xs-4">1.小单位名称：</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="minUnit" uglcw-role="textbox" id="minUnit" value="${ware.minUnit}" maxlength="15">
                                                </div>
                                                <div class="col-xs-4">
                                                    <ul uglcw-role="radio" uglcw-model="sunitFront" id="sUnitCheck" uglcw-value="${ware.sunitFront}"
                                                        uglcw-options='layout:"horizontal", checkDefault: false, dataSource:[{"text":"默认主单位","value":"1"}] '></ul>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">2.规格(小)：</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="minWareGg" uglcw-role="textbox" value="${ware.minWareGg}">
                                                </div>
                                            </div>
                                            <div class="form-group showClass">
                                                <label class="control-label col-xs-4">3.采购价(小)：</label>
                                                <div class="col-xs-6 showInPrice">
                                                    <input uglcw-model="minInPrice" uglcw-role="textbox" value="${ware.minInPrice}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">4.批发价(小)：</label>
                                                <div class="col-xs-6 showSalePrice">
                                                    <input uglcw-model="sunitPrice" uglcw-role="textbox" value="${ware.sunitPrice}">
                                                    <%--<a style="color:blue;" onclick="wareCustomerTypeDialog(${ware.wareId},0)">按客户类型设置</a>--%>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">5.销售原价(小)：</label>
                                                <div class="col-xs-6 showSalePrice">
                                                    <input uglcw-model="minLsPrice" id="minLsPrice" uglcw-role="textbox" value="${ware.minLsPrice}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">6.条码(小)：</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="beBarCode" uglcw-role="textbox" value="${ware.beBarCode}">
                                                </div>
                                            </div>

                                            <span>(三)单位换算</span>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">7.大小单位换算比例*：</label>
                                                <div class="col-xs-10" style="display: inline-flex">
                                                    <input uglcw-model="bUnit" id="bUnit" uglcw-role="numeric" style="width: 250px;"
                                                    <c:if test="${ware.bUnit == null}"> onchange="if(this.value !=1){uglcw.ui.error('只能输入1');this.value=1;return false;}" </c:if>
                                                    <c:if test="${ware.bUnit != null and ware.bUnit == 1}"> readonly="readonly" </c:if>
                                                           uglcw-options="spinners: false, change: calUnit,min:1, decimals: 0" value="${ware.bUnit == null ? 1 :ware.bUnit}">
                                                    <span style="width: 250px; text-align: center;">*大单位=</span>
                                                    <input style="width: 250px;" uglcw-model="sUnit" id="sUnit" uglcw-role="numeric" uglcw-options="spinners: false,change:calUnit" value="${ware.sUnit == null ? 1 :ware.sUnit}"
                                                           onchange="if(!this.value ){this.value=1;return false;}calUnit()">
                                                    <span style="width: 250px; text-align: center">*小单位</span>
                                                    <input style="width: 250px;" uglcw-model="hsNum" id="hsNum" uglcw-role="textbox" value="${ware.hsNum == null ?1 :ware.hsNum}" readonly>
                                                </div>
                                            </div>
                                            <div class="form-group showClass">
                                                <label class="control-label col-xs-4"></label>
                                                <div class="col-xs-8">
                                                    <span id="maxToMin" uglcw-role="button" class="k-info" onclick="toSubmit('sync_ware_max_to_min')">以大单位为准重新运算库存</span>
                                                    <span id="minToMax" uglcw-role="button" class="k-info" onclick="toSubmit('sync_ware_min_to_max')">以小单位为准重新运算库存</span>
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
                                            <span>(一)大单位辅助信息</span>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">1.预警最低数量：</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="warnQty" uglcw-role="textbox" value="${ware.warnQty}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">2.最低销售价(大)：</label>
                                                <div class="col-xs-6 showSalePrice">
                                                    <input uglcw-model="lowestSalePrice" uglcw-role="textbox" value="${ware.lowestSalePrice}">
                                                </div>
                                            </div>

                                            <span>(二)小单位辅助信息</span>
                                            <div class="form-group showClass">
                                                <label class="control-label col-xs-4">1.预警最低库存数量：</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="minWarnQty" uglcw-role="textbox" value="${ware.minWarnQty}">
                                                </div>
                                            </div>

                                            <span>(三)其它辅助信息</span>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">1.助记码:</label>
                                                <div class="col-xs-6">
                                                    <input style="width: 200px;" uglcw-model="py" id="py" uglcw-role="textbox" value="${ware.py}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">2.商品品牌:</label>
                                                <div class="col-xs-6" style="width: 200px">
                                                    <tag:select2 id="brandId" name="brandId" headerKey="" headerValue="" value="${ware.brandId}" displayKey="id"  displayValue="name" tableName="sys_brand"> </tag:select2>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">3.多规格商品组名:</label>
                                                <div class="col-xs-6" style="width: 200px">
                                                    <tag:select2 id="groupId" name="groupId" headerKey="" headerValue="" value="${ware.groupId}" displayKey="id" displayValue="group_name" tableName="sys_warespec_group">
                                                    </tag:select2>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">4.多规格商品属性:</label>
                                                <div class="col-xs-4">
                                                    <input style="width: 200px;" uglcw-model="attribute"  id="attribute" uglcw-role="textbox" value="${ware.attribute}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">5.生产厂商:</label>
                                                <div class="col-xs-4">
                                                    <input style="width: 200px;" uglcw-model="providerName" id="providerName" uglcw-role="textbox" value="${ware.providerName}">
                                                </div>

                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">6.保&nbsp;质&nbsp;期：</label>
                                                <div class="col-xs-4">
                                                    <input style="width: 200px;" uglcw-model="qualityDays"  id="qualityDays" uglcw-role="textbox" value="${ware.qualityDays}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">7.是否常用:</label>
                                                <div class="col-xs-4">
                                                    <ul uglcw-role="radio" uglcw-model="isCy" uglcw-value="1"  uglcw-options='layout:"horizontal", dataSource:[{"text":"是","value":"1"},{"text":"否","value":"2"}]'></ul>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">8.是否启用:</label>
                                                <div class="col-xs-4">
                                                    <ul uglcw-role="radio" uglcw-model="status" uglcw-value="1"  uglcw-options='layout:"horizontal", dataSource:[{"text":"是","value":"1"},{"text":"否","value":"2"}] '></ul>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">9.运输费用:</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="tranAmt" id="tranAmt" uglcw-role="textbox" value="${ware.tranAmt}"/>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">10.备&nbsp;&nbsp;&nbsp;&nbsp;注：</label>
                                                <div class="col-xs-6">
                                                    <textarea uglcw-model="remark" id="remark" uglcw-role="textbox" >${ware.remark}</textarea>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">11.标识码:</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="asnNo" id="asnNo"  uglcw-role="textbox" value="${ware.asnNo}"/>
                                                </div>
                                            </div>
                                            <%--======================商品图片:end===========================--%>
                                            <div class="form-group">
                                                <label class="control-label col-xs-2">12.商品图片:</label>
                                                <div class="col-xs-16">
                                                    <div id="album"uglcw-role="album" uglcw-options="cropper: false, dataSource: $.map(picList || [], function(pic){
                                                                    return { id: pic.id, fid: pic.id, url: '/upload/'+pic.picMini, title: pic.pic, picMini: pic.picMini, pic: pic.pic, wareId: pic.wareId}
                                                                })">
                                                    </div>
                                                </div>
                                            </div>
                                            <%--======================商品图片:end===========================--%>

                                            <%-----------------------------------------------------------------------------%>
                                            <div class="form-group" style="display: none">
                                                <label class="control-label col-xs-4">13.小单位分销价*：</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="minFxPrice" uglcw-role="textbox" value="${ware.minFxPrice}">
                                                </div>
                                            </div>
                                            <div class="form-group" style="display: none">
                                                <label class="control-label col-xs-4">14.小单位促销价*：</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="minCxPrice" uglcw-role="textbox" value="${ware.minCxPrice}">
                                                </div>
                                            </div>
                                            <div class="form-group" style="display: none">
                                                <label class="control-label col-xs-4">15.提成费用:</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="tcAmt" id="tcAmt" uglcw-role="textbox" value="${ware.tcAmt}"/>
                                                </div>
                                            </div>
                                            <div class="form-group" style="display: none">
                                                <label class="control-label col-xs-4">16.大单位分销价：</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="fxPrice" uglcw-role="textbox" value="${ware.fxPrice}">
                                                </div>
                                            </div>
                                            <div class="form-group" style="display: none">
                                                <label class="control-label col-xs-4">17.大单位促销价：</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="cxPrice" uglcw-role="textbox" value="${ware.cxPrice}">
                                                </div>
                                            </div>

                                            <c:if test="${not empty ware.wareId}">
                                                <span class="showYxClass" style="display: none">(四) 商品营销信息</span>
                                                <div class="form-group showYxClass" style="display: none">
                                                    <label class="control-label col-xs-4">1.客户类型商品销售价格设置：</label>
                                                    <div class="col-xs-6">
                                                        <a style="color:blue;" onclick="wareCustomerTypeDialog(${ware.wareId})">设置</a>
                                                    </div>
                                                </div>
                                                <div class="form-group showYxClass"  style="display: none">
                                                    <label class="control-label col-xs-4">2.客户等级商品销售价设置：</label>
                                                    <div class="col-xs-6">
                                                        <a style="color:blue;"  onclick="wareLevelDialog(${ware.wareId})">设置</a>
                                                    </div>
                                                </div>
                                                <div class="form-group showYxClass" style="display: none">
                                                    <label class="control-label col-xs-4">3.商品销售投入费用项目设置：</label>
                                                    <div class="col-xs-6">
                                                        <a style="color:blue;" onclick="wareAutoPriceDialog(${ware.wareId})">设置</a>
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
                                                    <input uglcw-model="posInPrice" uglcw-role="numeric"
                                                           value="${ware.posInPrice}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">3.门店大单位批发价：</label>
                                                <div class="col-xs-6 showPosPrice">
                                                    <input uglcw-model="posPfPrice" uglcw-role="numeric"
                                                           value="${ware.posPfPrice}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">4.门店大单位零售价：</label>
                                                <div class="col-xs-6 showPosPrice">
                                                    <input uglcw-model="posPrice1" uglcw-role="numeric"
                                                           value="${ware.posPrice1}">
                                                </div>
                                            </div>
                                            <div class="form-group" style="display: none">
                                                <label class="control-label col-xs-4">5.门店大单位促销价</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="posCxPrice" id="shZt"
                                                           uglcw-role="numeric" value="${ware.posCxPrice}">
                                                </div>
                                            </div>
                                            <div class="form-group" style="display: none">
                                                <label class="control-label col-xs-4">6.门店小单位采购价</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="posMinInPrice" id="posMinInPrice"
                                                           uglcw-role="numeric" value="${ware.posMinInPrice}">
                                                </div>
                                            </div>
                                            <div class="form-group" style="display: none">
                                                <label class="control-label col-xs-4">7.门店小单位批发价</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="posMinPfPrice" id="posMinPfPrice"
                                                           uglcw-role="numeric" value="${ware.posMinPfPrice}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">8.门店小单位零售价</label>
                                                <div class="col-xs-6 showPosPrice">
                                                    <input uglcw-model="posPrice2" id="posPrice2"
                                                           uglcw-role="numeric" value="${ware.posPrice2}">
                                                </div>
                                            </div>
                                            <div class="form-group" style="display: none">
                                                <label class="control-label col-xs-4">9.门店小单位促销价</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="posMinCxPrice" id="posMinCxPrice"
                                                           uglcw-role="numeric" value="${ware.posMinCxPrice}" readonly>
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
                                                <label class="control-label col-xs-4">1.自营商城商品别称</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="shopWareAlias" uglcw-role="textbox" value="${ware.shopWareAlias}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">2.自营商城排序</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="shopSort" id="shopSort" uglcw-role="textbox" value="${ware.shopSort}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">3.商品简述</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="wareResume" id="wareResume" maxlength="20" uglcw-role="textbox" value="${ware.wareResume}">
                                                </div>
                                            </div>
                                            <span>(一)大单位信息</span>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">1.自营商城商品大单位</label>
                                                <div class="col-xs-16">
                                                    是否显示<input type="checkbox" name="shopWarePriceShow" value="1" <c:if test="${ware.shopWarePriceShow==null || ware.shopWarePriceShow==1}">checked</c:if> onchange="return priceShowChange(this)">
                                                    &nbsp;&nbsp;默认单位<input type="radio" name="shopWarePriceDefault" value="0" <c:if test="${ware.shopWarePriceShow==null || ware.shopWarePriceDefault==0}">checked</c:if>>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">2.自营商城商品大单位批发价</label>
                                                <div class="col-xs-6 showShopPrice">
                                                    <input uglcw-model="shopWarePrice" uglcw-role="textbox" value="${ware.shopWarePrice}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">3.自营商城商品大单位零售价</label>
                                                <div class="col-xs-6 showShopPrice">
                                                    <input uglcw-model="shopWareLsPrice" uglcw-role="textbox" value="${ware.shopWareLsPrice}">
                                                </div>
                                            </div>
                                            <div class="form-group" style="display: none">
                                                <label class="control-label col-xs-4">4.自营商城商品大单位促销价</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="shopWareCxPrice" uglcw-role="textbox" value="${ware.shopWareCxPrice}">
                                                </div>
                                            </div>
                                            <span>(二)小单位信息</span>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">1.自营商城商品小单位</label>
                                                <div class="col-xs-16">
                                                    是否显示<input type="checkbox" name="shopWareSmallPriceShow" value="1" <c:if test="${ware.shopWareSmallPriceShow==null || ware.shopWareSmallPriceShow==1}">checked</c:if> onchange="return priceShowChange(this)">
                                                    &nbsp;&nbsp;默认单位<input type="radio" name="shopWarePriceDefault" value="1" <c:if test="${ware.shopWarePriceDefault==1}">checked</c:if>>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">2.自营商城商品小单位批发价</label>
                                                <div class="col-xs-6 showShopPrice">
                                                    <input uglcw-model="shopWareSmallPrice" uglcw-role="textbox" value="${ware.shopWareSmallPrice}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4">3.自营商城商品小单位零售价</label>
                                                <div class="col-xs-6 showShopPrice">
                                                    <input uglcw-model="shopWareSmallLsPrice" id="shopWareSmallLsPrice" uglcw-role="textbox" value="${ware.shopWareSmallLsPrice}" >
                                                </div>
                                            </div>
                                            <div class="form-group" style="display: none">
                                                <label class="control-label col-xs-4">4.自营商城商品小单位促销价</label>
                                                <div class="col-xs-6">
                                                    <input uglcw-model="shopWareSmallCxPrice" id="shopWareSmallCxPrice" uglcw-role="textbox" value="${ware.shopWareSmallCxPrice}" readonly>
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
<script type="text/x-uglcw-template" id="snapshot-tpl">
    <div uglcw-role="grid" uglcw-options="
            id: 'id',
            pageable: false,
            url: '${base}manager/common/bill/snapshot?billType=sysWare',
            data: function(params){
                var billId = uglcw.ui.get('#wareId').value();
                if(billId && billId != '0'){
                    params.billId = billId;
                }
                params.filterUser='1';
                return params;
            },
            loadFilter:{
                data: function(response){
                    return response.data || [];
                }
            }
        ">
        <div data-field="updateTime" uglcw-options="schema:{type: 'timestamp',format: 'yyyy-MM-dd HH:mm:ss'}">更新时间</div>
        <div data-field="title" uglcw-options="tooltip: true">商品名称</div>
        <div data-field="opts" uglcw-options="template: uglcw.util.template($('#snapshot-opt-tpl').html())">操作</div>
    </div>
</script>
<script type="text/x-uglcw-template" id="snapshot-opt-tpl">
    <button class="k-button k-info ghost" onclick="loadSnapshot('#= data.id#','#= data.title#')">查看</button>
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    var picList = ${fns:toJson(ware.warePicList)}
    var oldData={};
    var oldWareNm ="";
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

        $('#lsPrice').on('change', function () {
            $("#addRate").val("");
        });
        $('#minPrice').on('change', function () {
            $("#addRate").val("");
        });

        oldData =  uglcw.ui.bind('.layui-card-body');
        oldWareNm = uglcw.ui.get("#wareNm").value();
        uglcw.ui.get('.form-horizontal').on('change', function (e) {
            $('.form-horizontal').data('_change', true);
        });

    })


    /**
     校验商品类别是否末级节点
     */
    function checkWareTypeLeaf(typeId) {
        var bool = true;
        $.ajax({
            async: false,
            url: "${base}manager/checkWareTypeLeaf",
            data: "id=" + typeId,
            type: "post",
            dataType: 'json',
            success: function (json) {
                if (!json.state) {
                    bool = false;
                }
            }
        });
        return bool;
    }


    function toSumbit(putOnFlag,url) {
        var wareNm = uglcw.ui.get("#wareNm").value();
        if (wareNm == "") {
            return uglcw.ui.warning("请输入商品名称")
        }
        var wareDw = uglcw.ui.get("#wareDw").value();
        if (wareDw == "") {
            //return uglcw.ui.warning("请输入大单位名称")

        }
        var minUnit = uglcw.ui.get("#minUnit").value();
        if (minUnit) {
            var sUnit = uglcw.ui.get("#sUnit").value();
            if (!sUnit) {
                return uglcw.ui.warning('请输入大小单位换算比例')
            }
        }
        var bUnit = uglcw.ui.get("#bUnit").value();
        var sUnit = uglcw.ui.get("#sUnit").value();
        if (bUnit == "") {
            uglcw.ui.get("#bUnit").value("1");
        }
        if (bUnit == "" && sUnit == "") {
            uglcw.ui.get("#sUnit").value("1");
        }
        calUnit();
        var wareTypeId = uglcw.ui.get("#waretype").value();
        var check = checkWareTypeLeaf(wareTypeId);
        if (check == false) {
            if (!window.confirm("商品类别未选择最末节点,如果继续操作商品将归属到未分类!")) {
                return;
            }
            uglcw.ui.get("#waretype").value(-1);
        }

        var msg="是否确定保存?";
        if(url!=undefined&&url!=''&&url!=null){
            msg="单据有变动，是否确认保存";
        }
        if(sUnit!=oldData.sUnit){
            msg+="换算比例调整将影响商品大小数量、成本计算，调整后，建议对库存进行重新运算。";
        }
        uglcw.ui.confirm(msg, function () {
            var valid = uglcw.ui.get('.form-horizontal').validate();
            if (!valid) {
                uglcw.ui.warning("请输入检查完整后在提交");
                return false;
            }
            if (putOnFlag != '') {
                $('#putOn').val(putOnFlag);
            }
            var delPicIds = "";
            var data = uglcw.ui.bindFormData('.form-horizontal');
            var album = uglcw.ui.get('#album');
            data.append('delPicIds', album.getDeleted().join(','));
            data.append('shopWarePriceShow', uglcw.util.toInt($("input[name='shopWarePriceShow']").is(":checked")));
            data.append('shopWareSmallPriceShow', uglcw.util.toInt($("input[name='shopWareSmallPriceShow']").is(":checked")));
            data.append('shopWarePriceDefault', $("input:radio[name='shopWarePriceDefault']:checked").val());
            album.bindFormData(data);
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/operware?sourceShop=${sourceShop}',
                type: 'post',
                data: data,
                processData: false,
                contentType: false,
                success: function (resp) {
                    uglcw.ui.loaded();
                    if (resp == "1") {
                        uglcw.ui.success("添加成功");
                        <c:choose>
                        <c:when test="${!empty sourceShop}">setTimeout(function () {
                            uglcw.io.emit('listen_wareChange');//通知商城刷新列表
                            uglcw.ui.closeCurrentTab();
                        },1000)
                        </c:when><c:otherwise>toback();</c:otherwise>
                        </c:choose>
                    } else if (resp == "2") {
                        saveSnapshot();
                        uglcw.ui.success("修改成功");
                        $('.form-horizontal').data('_change', false);
                        //setTimeout(toback(),3000);
                        if(url!=undefined&&url!=''&&url!=null){
                            syncHs(url);
                        }
                    } else if (resp == "-2") {
                        uglcw.ui.success("该商品名称已存在了");
                        return;
                    } else if (resp == "-3") {
                        uglcw.ui.success("该商品编码已存在了");
                        return;
                    } else if (resp == "-4") {
                        uglcw.ui.success("该商品小单位条码已存在了");
                    } else if (resp == "-5") {
                        uglcw.ui.success("该商品大单位条码已存在了");
                    } else {
                        uglcw.ui.error("操作失败");
                    }
                }
            })
        });
    }

    function toback() {//返回
        if (uglcw.ui.get("#click_flag").value() ==1) {
            setTimeout(function () {
                uglcw.ui.openTab('商品信息管理', '/manager/queryware');//重新打开表单页面
            })
            uglcw.ui.closeCurrentTab();//关闭当前页面
        } else if(uglcw.ui.get("#click_flag").value() ==3){
            setTimeout(function () {
                uglcw.ui.openTab('商品管理', '/manager/shopWare/shopWareType?_sticky=v2');
            })
            uglcw.ui.closeCurrentTab();//关闭当前页面
        }
        else
        {
            setTimeout(function () {
                uglcw.ui.openTab('商品分类管理', '/manager/querywaretype');
            })
            uglcw.ui.closeCurrentTab();//关闭当前页面
        }
    }

    function calUnit() {//计算换算单位
        var bUnit = uglcw.ui.get("#bUnit").value();
        var sUnit = uglcw.ui.get("#sUnit").value();
        if (bUnit !== "" && sUnit !== "") {
            var hsNum = parseFloat(sUnit) / parseFloat(bUnit);
            console.log("hsNum:" + hsNum);
            console.log("hsNum.toFixed(7)：" + hsNum.toFixed(7));
            uglcw.ui.get("#hsNum").value(hsNum.toFixed(7));

        }
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

    function selectType() {
        var win = uglcw.ui.Modal.open({
            checkbox: true,
            selection: 'single',
            title: false,
            maxmin: false,
            resizable: false,
            move: true,
            btns: ['确定', '取消'],
            area: ['400', '415px'],
            content: $('#product-type-selector-template').html(),
            success: function (c) {
                uglcw.ui.init(c);
            },
            yes: function (c) {
                var typeId= uglcw.ui.get($(c).find('#__type_id')).value();
                var typeName=uglcw.ui.get($(c).find('#__upWaretypeNm')).value();
                var bool= checkWareTypeLeaf(typeId);
                if(!bool){
                    uglcw.ui.warning('商品类别未选择最末节点，未更改将会自动归到未分类商品类别！');
                    return false;
                }
                uglcw.ui.get('#waretype').value(typeId);
                uglcw.ui.get('#waretypeNm').value(typeName);
                uglcw.ui.Modal.close(win);
            }
        })
    }

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

    if (showInPrice == 'false') {
        $(".showInPrice").hide();
    }
    if (showSalePrice == 'false') {
        $(".showSalePrice").hide();
    }

    if (showPosPrice == 'false') {
        $(".showPosPrice").hide();
    }

    if (showShopPrice == 'false') {
        $(".showShopPrice").hide();
    }

    //大小单位显示和默认切换方法
    function priceShowChange(th, load) {
        var shopWarePriceShow = $("input[name='shopWarePriceShow']").prop('checked');
        var shopWareSmallPriceShow = $("input[name='shopWareSmallPriceShow']").prop('checked');
        var shopWarePriceDefault0 = $("input:radio[name='shopWarePriceDefault'][value='0']");//大单位默认
        var shopWarePriceDefault1 = $("input:radio[name='shopWarePriceDefault'][value='1']");

        if (!shopWarePriceShow && !shopWareSmallPriceShow) {//两个同时不显示
            $(th).prop("checked", true);
            uglcw.ui.error("大小单位不能两个同时隐藏");
            return false;
        }
        if (!$("[name=wareDw]").val() && !$("[name=wareGg]").val() && !$("[name=minUnit]").val() && !$("[name=minWareGg]").val()) {
            uglcw.ui.error("大小单位名称或规格不能同时为空");
            return false;
        }
        //如果显示大单位时验证名称和规格是否有填写
        if (shopWarePriceShow && !$("[name=wareDw]").val() && !$("[name=wareGg]").val()) {
            if (!load)
                uglcw.ui.error("大单位名称规格未设置");
            $("input[name='shopWarePriceShow']").prop('checked', false);
            //$("input[name='shopWareSmallPriceShow']").prop('checked',true);
            $(shopWarePriceDefault0).prop("checked", false);
            $(shopWarePriceDefault0).prop("disabled", true);
            $(shopWarePriceDefault1).prop("checked", true);
            return false;
        }
        //如果显示小单位时验证名称和规格是否有填写
        if (shopWareSmallPriceShow && !$("[name=minUnit]").val() && !$("[name=minWareGg]").val()) {
            if (!load)
                uglcw.ui.error("小单位名称规格未设置");
            $("input[name='shopWarePriceShow']").prop('checked', true);
            $("input[name='shopWareSmallPriceShow']").prop('checked', false);
            $(shopWarePriceDefault1).prop("checked", false);
            $(shopWarePriceDefault1).prop("disabled", true);
            $(shopWarePriceDefault0).prop("checked", true);
            return false;
        }

        //如果大单位不显示时默认需要选中小单位
        if (!shopWarePriceShow && shopWareSmallPriceShow) {//大单位不显示
            $(shopWarePriceDefault1).prop("checked", true);
            $(shopWarePriceDefault0).prop("disabled", true);
            $(shopWarePriceDefault1).prop("disabled", false);
        } else if (shopWarePriceShow && !shopWareSmallPriceShow) {//小单位不显示
            $(shopWarePriceDefault0).prop("checked", true);
            $(shopWarePriceDefault1).prop("disabled", true);
            $(shopWarePriceDefault0).prop("disabled", false);
        } else {
            $(shopWarePriceDefault0).prop("disabled", false);
            $(shopWarePriceDefault1).prop("disabled", false);
        }
    }

    function showSnapshot() {
        uglcw.ui.Modal.open({
            title: '版本列表',
            area: ['600px', '450px'],
            content: $('#snapshot-tpl').html(),
            success: function (c) {
                uglcw.ui.init(c);
            },
            btns: false
        })
    }

    function saveSnapshot() {
        var wareId = uglcw.ui.get('#wareId').value();
        var query = oldData;
        wareId = (wareId && wareId != '0') ? wareId : undefined;
        $.ajax({
            url: CTX + '/manager/common/bill/snapshot',
            contentType: 'application/json',
            type: 'POST',
            data: JSON.stringify({
                title: oldWareNm,
                id: uglcw.ui.get('#snapshotId').value(),
                billType: 'sysWare',
                data: {
                    query: query,
                    data:{}
                },
                billId: wareId
            }),
            success: function (response) {
                if (response.success) {
                    // $('.snapshot-badge-dot').show();
                    // uglcw.ui.get('#snapshotId').value(response.data)
                }
            }
        })
    }

    function loadSnapshot(id,title) {
        var wareId = uglcw.ui.get("#wareId").value();
        uglcw.ui.openTab(title+"信息记录",CTX + '/manager/showWareVersion?snapshotId='+id+'&wareId='+wareId);

    }

    function syncHs(url) {
        var wareId = uglcw.ui.get("#wareId").value();
        uglcw.ui.confirm("是否确定该操作", function () {
            uglcw.ui.loading();
            $.ajax({
                async: false,
                url: "${base}manager/stkSfcWare/"+url,
                data: "wareId=" + wareId,
                type: "post",
                dataType: 'json',
                success: function (response) {
                    if (response.success) {
                        uglcw.ui.success(response.message);
                    }else{
                        uglcw.ui.error("修复失败")
                    }
                    uglcw.ui.loaded();
                }
            });
        })
    }
    function toSubmit(url){
        if ($('.form-horizontal').data('_change')) {
            return toSumbit('',url);
        }
        syncHs(url);
    }

</script>
</body>
</html>
