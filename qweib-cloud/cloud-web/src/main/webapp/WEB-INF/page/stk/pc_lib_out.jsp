<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<%@ taglib prefix="tag" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="permission" uri="/WEB-INF/tlds/permission.tld" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="format-detection" content="telephone=no"/>
    <meta HTTP-EQUIV="pragma" CONTENT="no-cache">
    <meta HTTP-EQUIV="Cache-Control" CONTENT="no-cache, must-revalidate">
    <meta HTTP-EQUIV="expires" CONTENT="0">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=2.0, user-scalable=no"/>
    <title>pc-销售发票</title>
    <link rel="stylesheet" href="<%=basePath %>/resource/select/css/main.css">
    <link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/stkstyle/css/style.css"/>
    <link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/stkstyle/css/lCalendar.css"/>
    <!-- <script src="<%=basePath %>/resource/stkstyle/js/jquery-2.1.0.min.js" type="text/javascript" charset="utf-8"></script> -->
    <script type="text/javascript">
        var priceDisplay = '${permission:checkUserFieldDisplay("stk.stkOut.lookprice")}';
        var amtDisplay = '${permission:checkUserFieldDisplay("stk.stkOut.lookamt")}';
        var qtyDisplay = '${permission:checkUserFieldDisplay("stk.stkOut.lookqty")}';
        var fanLiDisplay = '${fns:checkFieldDisplay("sys_config","*","code=\"CONFIG_OUT_FANLI_PRICE\"  and status=1")}';
        var productDateConfig = '${fns:checkFieldDisplay("sys_config","*","code=\"CONFIG_OUT_PRODUCT_DATE\"  and status=1")}';
        var helpDisplay = '${fns:checkFieldDisplay("sys_config","*","code=\"CONFIG_SALE_SHOW_HELP_UNIT\"  and status=1")}';
        var xsfpQuickBill = '${fns:checkFieldDisplay("sys_config","*","code=\"CONFIG_XSFP_QUICK_BILL\" and status=1")}';
        var AUTO_CREATE_XSFP = '${fns:checkFieldDisplay("sys_config","*","code=\"CONFIG_ORDER_AUTO_CREATE_XSFP\" and status=1")}';
        var NEW_STOCK_CAL = '${fns:checkFieldDisplay("sys_config","*","code=\"CONFIG_USE_NEW_STOCK_CAL\" and status=1")}';
        var AUTO_CREATE_FHD = '${fns:checkFieldDisplay("sys_config","*","code=\"CONFIG_XSFP_AUTO_CREATE_FHD\" and status=1")}';

        var COMPARE_ZX_PRICE = '${fns:checkFieldDisplay("sys_config","*","code=\"CONFIG_XSFP_COMPARE_ZX_PRICE\" and status=1")}';
        var COMPARE_HIS_PRICE = '${fns:checkFieldDisplay("sys_config","*","code=\"CONFIG_XSFP_COMPARE_HIS_PRICE\" and status=1")}';
        var AUTO_SNAPSHOT = '${fns:checkFieldDisplay("sys_config","*","code=\"CONFIG_ORDER_AUTO_SNAPSHOT\" and status=1")}';
        var isModify = false;//单据是否有修改；
    </script>
    <link rel="stylesheet" href="<%=basePath %>/resource/kendo/style/autocomplete.min.css">
    <script type="text/javascript" src="<%=basePath%>/resource/jquery-1.8.0.min.js"></script>
    <script src="<%=basePath %>/resource/kendo/js/kendo.custom.min.js"></script>
    <script type="text/javascript" src="<%=basePath %>/resource/common.js"></script>
    <script type="text/javascript" src="<%=basePath %>/resource/login/js/jquery-ui.min.js"></script>
    <script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
    <script src="<%=basePath %>/resource/stkstyle/js/Map.js" type="text/javascript" charset="utf-8"></script>
    <script src="<%=basePath %>/resource/stkstyle/js/tip.js" type="text/javascript" charset="utf-8"></script>
    <script src="<%=basePath %>/resource/stkstyle/js/pcstkout.js" type="text/javascript" charset="utf-8"></script>
    <script type="text/javascript" src="<%=basePath %>resource/WdatePicker.js"></script>
    <script type="text/javascript" src="<%=basePath %>/resource/jquery.easyui.min.js"></script>
    <link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/easyui/easyui.css">
    <link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/easyui/icon.css">
    <script src="<%=basePath %>/resource/select/js/jquery.autocompleter.js"></script>
    <script src="<%=basePath %>/resource/pingyin.js"></script>
    <style>
        tr {
            cursor: pointer;
        }

        .ware_stock_tip {
            color: red;
            font-weight: bold;
        }

        .ware_dif_price_tip {
            background-color: #01AAED;
        }

        .newColor {
            background-color: skyblue
        }

        ::selection {
            background: yellow;
            color: #555;
        }

        ::-moz-selection {
            background: yellow;
            color: #555;
        }

        ::-webkit-selection {
            background: yellow;
            color: #555;
        }

        .tip-wrap {
            position: absolute;
            display: none;
        }

        .tip-arr-a, .tip-arr-b {
            position: absolute;
            width: 0;
            height: 0;
            line-height: 0;
            border-style: dashed;
            border-color: transparent;
        }

        .tdClass {
            position: relative;
        }

        .tdClass div {
            position: absolute;
            right: 0;
            top: 0;
            border-radius: 0px 0px 0px 20px;
            height: 8px;
            width: 10px;
            background-color: rosybrown
        }

        #more_list thead td {
            position: sticky;
            top: 0;
            z-index: 12;
        }
    </style>
</head>
<script type="text/javascript">
    var basePath = '<%=basePath %>';
</script>
<body>
<style type="text/css">
    .menu_btn .item p {
        font-size: 12px;
    }

    .menu_btn .item img:last-of-type {
        display: none;
    }

    .menu_btn .item a {
        color: #00a6fb;
    }

    .menu_btn .item.on img:first-child {
        display: none;
    }

    .menu_btn .item.on img:last-of-type {
        display: inline;
    }

    .menu_btn .item.on a {
        color: #333;
    }

    .k-combobox-clearable .k-input {
        padding-right: 2px;
    }

    .k-combobox .k-dropdown-wrap .k-select {
        width: 1.2em;
    }

    .k-combobox .k-dropdown-wrap {
        padding-right: 1.2em;
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
                    <c:if test="${permission:checkUserFieldPdm('stk.stkOut.dragsave')}">
                        <div class="item" id="btndraft">
                            <a href="javascript:draftSaveStk();">
                                <img src="<%=basePath %>/resource/stkstyle/img/nicon1.png"/>
                                <img src="<%=basePath %>/resource/stkstyle/img/nicon1a.png"/>
                                <p>暂存</p>
                            </a>
                        </div>
                    </c:if>
                    <c:if test="${permission:checkUserFieldPdm('stk.stkOut.audit') }">
                        <div class="item" id="btndraftaudit" style="display: ${billId eq 0?'none':''}">
                            <a href="javascript:auditDraftStkOut();">
                                <img src="<%=basePath %>/resource/stkstyle/img/nicon2.png"/>
                                <img src="<%=basePath %>/resource/stkstyle/img/nicon2a.png"/>
                                <p>审批</p>
                            </a>
                        </div>
                    </c:if>
                </c:if>
                <c:if test="${permission:checkUserFieldPdm('stk.stkOut.saveaudit') }">
                    <div class="item" id="btnsave" style="display:${(status eq -2 and billId eq 0)?'':'none'}">
                        <a href="javascript:submitStk();">
                            <img src="<%=basePath %>/resource/stkstyle/img/nicon1.png"/>
                            <img src="<%=basePath %>/resource/stkstyle/img/nicon1a.png"/>
                            <p>保存并审批</p>
                        </a>
                    </div>
                </c:if>

                <c:if test="${permission:checkUserFieldPdm('stk.stkOut.onepost')&&autoPost eq '' }">
                    <div class="item" id="btndraftpost" style="display:${billId ne 0?'none':''}">
                        <a href="javascript:postAccDialog();">
                            <img src="<%=basePath %>/resource/stkstyle/img/nicon2.png"/>
                            <img src="<%=basePath %>/resource/stkstyle/img/nicon2a.png"/>
                            <p>一键过账</p>
                        </a>
                    </div>
                </c:if>


                <c:if test="${permission:checkUserFieldPdm('stk.stkOut.fahuo') }">
                    <div class="item" id="btnaudit"
                         style="display: ${(status eq -2 or billId eq 0 or status eq 1)?'none':''}">
                        <a href="javascript:auditClick();">
                            <img src="<%=basePath %>/resource/stkstyle/img/nicon4.png"/>
                            <img src="<%=basePath %>/resource/stkstyle/img/nicon4a.png"/>
                            <p>发货</p>
                        </a>
                    </div>
                </c:if>
                <c:if test="${permission:checkUserFieldPdm('stk.stkOut.cancel') }">
                    <div class="item" id="btncancel" style="display: ${billId eq 0?'none':''}">
                        <a href="javascript:cancelClick();">
                            <img src="<%=basePath %>/resource/stkstyle/img/nicon5.png"/>
                            <img src="<%=basePath %>/resource/stkstyle/img/nicon5a.png"/>
                            <p>作废</p>
                        </a>
                    </div>
                </c:if>
                <c:if test="${permission:checkUserFieldPdm('stk.stkOut.print') }">
                    <div class="item" id="btnprint" style="display: ${billId eq 0?'none':''}">
                        <a href="javascript:printClick();">
                            <img src="<%=basePath %>/resource/stkstyle/img/nicon3.png"/>
                            <img src="<%=basePath %>/resource/stkstyle/img/nicon3a.png"/>
                            <p>打印</p>
                        </a>
                    </div>
                </c:if>
                <c:if test="${status eq 0 or status eq 1}">
                    <div class="item" id="btnprint"
                         style="display:${fns:checkFieldDisplay('sys_config','*','code=\'CONFIG_XSFP_AUTO_REAUDIT\'  and status=1')}">
                        <a href="javascript:reAudit();">
                            <img src="<%=basePath %>/resource/stkstyle/img/nicon3.png"/>
                            <img src="<%=basePath %>/resource/stkstyle/img/nicon3a.png"/>
                            <p>反审批</p>
                        </a>
                    </div>
                </c:if>
                <div class="pcl_right_edi" style="width: 400px;">
                    <div class="pcl_right_edi_w">
                        <div>

                            <input type="text" id="billNo"
                                   style="color: ${(priceFlag eq 1 and status ne -2)?'red':'green'};width:160px;font-size: 14px"
                                   readonly="readonly" value="${billNo}"/>


                            <input type="text" id="billstatus" style="color:green;width:55px;font-size: 13px"
                                   readonly="readonly" value="${billstatus}"/>
                            <input type="text" id="paystatus" style="color:green;width:60px;font-size: 13px"
                                   readonly="readonly" value="${paystatus}"/>
                            <c:if test="${status == -2}">
                                <input type="text" id="snapshot" style="color:#38F;width:60px;font-size: 13px;display:${fns:checkFieldDisplay("sys_config","*","code=\"CONFIG_ORDER_AUTO_SNAPSHOT\" and status=1")}"
                                       readonly="readonly" value="快照列表"/>
                            </c:if>
                            <div
                                    style="float: right;width: 50px;position:absolute;right:0;bottom:0;font-size: 12px">
                                <a id="displayMainBtn" onclick="showMainDiv(this)" style="color:skyblue;">隐藏</a>
                            </div>
                            <c:if test="${not empty verList}">
                                <a onclick="show('billVersion')">查看反审批版本</a>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!--<p class="odd_num">单号：</p>-->
    <input type="hidden" name="snapshotId" id="snapshotId"/>
    <input type="hidden" name="billId" id="billId" value="${billId}"/>
    <input type="hidden" name="orderId" id="orderId" value="${orderId}"/>
    <input type="hidden" name="stkId" id="stkId" value="${stkId}"/>
    <input type="hidden" name="pszd" id="pszd" value="${pszd}"/>
    <input type="hidden" name="status" id="status" value="${status}"/>
    <input type="hidden" name="empId" id="empId" value="${empId}"/>
    <input type="hidden" name="proType" id="proType" value="${proType}"/>
    <input type="hidden" name="autoPrice" id="autoPrice" value="${autoPrice}"/>
    <input type="hidden" name="isSUnitPrice" id="isSUnitPrice" value="${isSUnitPrice}">
    <input type="hidden" name="saleType" id="saleType" value="${saleType}"/>
    <input  type="hidden" name="empType" id="empType" value="${empType}"/>
    <div class="pcl_fm" id="mainDivId">
        <table>
            <tbody>
            <tr>
                <td width="80px" style="text-align: center;">销售订单：</td>
                <td id="pc_order11" title="点击选择订单">
                    <div class="pcl_chose_peo">
                        <a href="javascript:;" id="pc_order" style="padding-right: 30px;">${orderNo}</a>
                    </div>
                </td>
                <td width="80px" style="text-align: center;">发票日期：</td>
                <td>
                    <div class="pcl_input_box pcl_w2">
                        <input name="text" id="outDate"
                               onClick="WdatePicker({skin:'whyGreen',dateFmt: 'yyyy-MM-dd HH:mm'});"
                               style="width: 100px;" value="${outTime}" readonly="readonly"/>
                    </div>
                </td>
                <td width="80px" style="text-align: center;">配送指定：</td>
                <td>
                    <table>
                        <tr>
                            <td width="80px">
                                <div class="selbox" style="width: 80px">
                                    <span id="pszdspan">${pszd}</span>
                                    <select name="" class="pcl_sel" id="pszdsel">
                                        <option value="公司直送">公司直送</option>
                                        <option value="直供转单二批">直供转单二批</option>
                                    </select>
                                </div>
                            </td>
                            <td>
                                <div class="pcl_input_box pcl_w2" id="epCustomerDiv" style="width: 70px;display: none">
                                    <input type="hidden" id="epCustomerId" name="epCustomerId"
                                           value="${epCustomerId }"/>
                                    <input type="text" id="epCustomerName" name="epCustomerName" required="required"
                                           placeholder="单击选择客户" value="${epCustomerName }" readonly="readonly"/>
                                </div>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>

            <tr>
                <td style="text-align: center;">客户名称：</td>
                <td>
                    <input name="cstId" type="hidden" id="cstId" value="${cstId}"/>


                    <input type="text" placeholder="请输入代码、名称、助记码" id="khNm" name="khNm" value="${khNm}"
                           style="width: 150px"/>
                    &nbsp;
                    <a href="javascript:;;" id="pc_lib" style="color: blue" onclick="selectWanglai()">选择客户</a>
                    |
                    <a href="javascript:;;" onclick="showUnRecPage()" style="color: blue">查看欠款</a>
                    <span id="cstMsg" style="color: red;font-size: 10px"></span></td>

                </td>
                <td style="text-align: center;">配送地址：</td>
                <td>
                    <div class="pcl_input_box pcl_w2"><input type="text" name="address" id="cstaddress"
                                                             value="${address }"/></div>
                </td>
                <td style="text-align: center;">联系电话：</td>
                <td>
                    <div class="pcl_input_box pcl_w2"><input type="text" name="tel" id="csttel" value="${tel}"/></div>
                </td>
            </tr>
            <tr>
                <td style="text-align: center;">出货仓库：</td>
                <td>
                    <div class="selbox" id="stklist">
                        <span id="stkNamespan" qwb-text="stkName">${stkName}</span>
                        <select name="" class="pcl_sel" id="stksel">
                        </select>
                    </div>

                </td>
                <td style="text-align: center;">业 务 员：</td>
                <td>
                    <div class="pcl_chose_peo">
                        <a href="javascript:;" id="staff" style="padding-right: 30px;" qwb-text="staff">${staff}</a>
                    </div>
                </td>
                <td style="text-align: center;">联系电话：</td>
                <td>
                    <div class="pcl_input_box pcl_w2"><input type="text" id="stafftel" name="stafftel"
                                                             value="${stafftel}"/></div>
                </td>
            </tr>
            <tr style="display: ${permission:checkUserFieldDisplay('stk.stkOut.lookamt')}">
                <td style="text-align: center;">
                    合计金额：
                </td>
                <td>
                    <div class="pcl_input_box pcl_w2"><input type="text" id="totalamt" name="totalamt"
                                                             value="${totalamt}"></div>
                </td>
                <td style="text-align: center;">
                    整单折扣：
                </td>
                <td>
                    <div class="pcl_input_box pcl_w2"><input type="text" id="discount" name="discount"
                                                             value="${discount}"></div>
                </td>
                <td style="text-align: center;">
                    发票金额：
                </td>
                <td>
                    <div class="pcl_input_box pcl_w2"><input type="text" id="disamt" name="disamt" value="${disamt}"
                                                             readonly="readonly"/></div>
                </td>
            </tr>
            <tr>
                <td style="text-align: center;">车&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;辆：</td>
                <td>
                    <div class="selbox">
                        <span id="vehNospan" qwb-text="vehNo">${vehNo}</span>
                        <tag:select name="vehId" id="vehId" tclass="pcl_sel" value="${vehId }" headerKey=""
                                    headerValue="" tableName="stk_vehicle" displayKey="id" displayValue="veh_no"/>
                    </div>
                </td>
                <td style="text-align: center;">司&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;机：</td>
                <td>
                    <div class="selbox">
                        <span id="driverNamespan">${driverName}</span>
                        <tag:select name="driverId" id="driverId" tclass="pcl_sel" value="${driverId }" headerKey=""
                                    headerValue="" tableName="stk_driver" displayKey="id" displayValue="driver_name"/>
                    </div>
                </td>
                <td></td>
                <td></td>
            </tr>
            <c:if test="${saleType eq '003'}">
                <tr>
                    <td style="text-align: center;">物流名称：</td>
                    <td>
                        <div class="pcl_input_box pcl_w2"><input type="text" name="transportName" id="transportName"
                                                                 value="${transportName}"></div>
                    </td>
                    <td style="text-align: center;">物流单号：</td>
                    <td>
                        <div class="pcl_input_box pcl_w2"><input type="text" name="transportCode" id="transportCode"
                                                                 value="${transportCode}"></div>
                    </td>
                    <td></td>
                    <td></td>
                </tr>
            </c:if>
            <tr>
                <td valign="top" style="text-align: center;">备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注：</td>
                <td colspan="5">
                    <div class="pcl_txr">
                        <textarea name="remarks" id="remarks">${remarks}</textarea>
                    </div>
                </td>
            </tr>

            </tbody>
        </table>
    </div>
    <div id="tb" style="padding:5px;height:auto">
        <table>
            <tr>
                <td>

                    <a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:dialogSelectWare();">批量添加</a>

                    <a class="easyui-linkbutton" iconCls="icon-add"
                       style="display: ${fns:checkFieldDisplay('sys_config','*','code=\'CONFIG_XSFP_QUICK_BILL\' and status =1')}"
                       plain="true" href="javascript:quickWareDialog();">快速添加商品</a>
                </td>
                <td><span style="font-size:12px;">请刷条码：</span></td>
                <td>
                    <%--onclick="setWareAutoCompleter(this,-1)" <tag:autocompleter name="pcWareNm" id="pcWareNm" placeholder="输入产品中文或拼音"  onblur="checkWareExists(this)" onclick="setWareAutoCompleter(this,1)"></tag:autocompleter>--%>
                    <%--<tag:autocompleter name="barcodeInput" id="barcodeInput" tclass="pcl_input_box pcl_i2"
                                       placeholder="输入商品名称、商品代码、商品条码" width="200px" onblur="checkWareExists(this)"
                                       onclick="setWareAutoCompleter(this,-1)" ></tag:autocompleter>--%>
                    <input type="text" placeholder="输入商品名称、商品代码、商品条码" id="barcodeInput" style="width: 200px"/>

                    <%-- <input type="text" class="pcl_input_box pcl_w2" id="barcodeInput" onkeyup ="queryWareBarByKeyWord(this.value)" />--%>
                </td>
                <td id="checktd" style="padding-left: 5px "><span style="font-size:12px;" id="checkLabel">商品较验<input
                        type="checkbox" id="check1" OnClick="checkOnClick(this);"/></span>
                    <span style="font-size:12px;display:${fns:checkFieldDisplay('sys_config','*','code=\'CONFIG_SUNIT_REFER\'  and status=1')}"
                          id="checkSunit">小单位参考列<input type="checkbox" id="checkSunitBox"
                                                       OnClick="checkSunitBox(this);"/></span>
                </td>
                <c:if test="${permission:checkUserFieldPdm('stk.stkOut.effect')}">
                    <td style="padding-left: 5px;">
                        <span style="font-size:12px;"
                              id="changeOrderPriceSpan"> 勾选后审批时影响订单商品价格<input ${empty effectOrderPrice?'checked=checked':''}
                                type="checkbox" id="changeOrderPrice" value="1"/></span>
                    </td>
                </c:if>
                <td style="padding-left: 10px">
                    <div class="tipDiv">
                        <span data-tip-msg="【生产日期】栏，点击[关联]可以选中具体批次的商品生产日期，且该批次生产日期的商品将会被占用"
                              style="color: red;font-size: 11px">生产日期提示》</span>
                    </div>
                </td>
                <td style="font-size: 12px;display:${fns:checkFieldDisplay('sys_config','*','code=\'CONFIG_CLOSE_XSPRICE_AUTO_WRITE\'  and status!=1')};">
                    <input type="checkbox" id="wareXsPrice" value="1"/>勾选后价格同步到商品信息
                </td>
                <td>
                    <c:if test="${billId eq 0 && orderId ne 0}">
                        <div style="font-size: 10px;">
				<span id="combField" style="display: none">
				[
				<span ondblclick="javascript:combMainSort(1)">按产品名称:</span>
				<input type="radio" onclick="javascript:combField()" name="ware_nm_radio" value="b.ware_nm desc"/>
				降序
				<input type="radio" onclick="javascript:combField()" name="ware_nm_radio" value="b.ware_nm asc"/>
				升序
				&nbsp;&nbsp;
				<span ondblclick="javascript:combMainSort(2)">按单位:</span>
				<input type="radio" onclick="javascript:combField()" name="be_unit_radio" value="a.be_unit desc"/>
				降序
				<input type="radio" onclick="javascript:combField()" name="be_unit_radio" value="a.be_unit asc"/>
				升序
				]
				</span>

                            &nbsp;
                            <span id="combBtn" onclick="combClose()" style="color: blue">显示组合</span>
                        </div>
                    </c:if>
                </td>
            </tr>
        </table>
        <table width="100%" style="float: right">
            <tr>
                <td id="tipPrice" style="font-size: 12px;text-align: center" align="center" colspan="10">
                    商品名称：<span style="color: blue" id="wareNmSpan"></span>
                    <span style="color: red">[</span>
                    历史价:<span id="hisPrice" style="color: blue"></span>
                    执行价:<span id="zxPrice" style="color: blue"></span>
                    商品价:<span id="orgPrice" style="color: blue"></span>
                    <span ${fns:checkFieldDisplay("sys_config","*","code=\"CONFIG_SALE_SHOW_INPRICE\"  and status=1") eq 'none'?'style="display:none"':""}>
                    成本价:<span id="inPrice" style="color: blue"></span>
                    </span>
                    <span style="color: red">]
					[</span>
                    实际库存:<span id="stkQty" style="color: green"></span>
                    占用库存:<span id="occQty" style="color: green"></span>
                    虚拟库存:<span id="xnQty" style="color: green"></span>
                    <span style="color: red">]</span>
                    <input type="checkbox" id="zhanYongChk" checked="checked" value="1"/>选中加载占用库存
                    <span style="font-size: 12px;display:${fns:checkFieldDisplay('sys_config','*','code=\'CONFIG_XSFP_TO_CUSTOMER_PRICE\'  and status!=1')};">
                    <input type="checkbox" id="wareCustomerPrice" value="1"/>勾选后价格同步到对应客户执行价
                    </span>
                    <span style="font-size: 12px;display:${fns:checkFieldDisplay('sys_config','*','code=\'CONFIG_XSFP_AUTO_CREATE_FHD\'  and status=1')};">
                         <input type="checkbox" id="autoCreateFhd"
                                value="1" ${(fns:checkFieldDisplay('sys_config','*','code=\'CONFIG_XSFP_AUTO_CREATE_FHD\'  and status=1') eq '')?'':'checked'}
                                value="1"/>分批发货
                     </span>
                </td>
            </tr>
        </table>
    </div>
    <div class="pcl_ttbox1 clearfix" style="height: 400px; overflow: auto" id="content">
        <div class="pcl_lfbox1">
            <table id="more_list">
                <thead>
                <tr>
                    <td class="index">序号</td>
                    <c:if test="${billId ne 0}">
                        <td onclick="javascript:sortFieldSub(this,'b.ware_code')">产品编号▲</td>
                        <td onclick="javascript:sortFieldSub(this,'b.ware_nm')" style="width:200px">产品名称▲</td>
                        <td onclick="javascript:sortFieldSub(this,'b.ware_gg')">产品规格▲</td>
                        <td onclick="javascript:sortFieldSub(this,'a.xs_tp')">销售类型▲</td>
                        <td onclick="javascript:sortFieldSub(this,'a.be_unit')">单位▲</td>
                        <td onclick="javascript:sortFieldSub(this,'a.qty')"
                            style="display: ${permission:checkUserFieldDisplay('stk.stkOut.lookqty')};">销售数量▲
                        </td>
                        <td onclick="javascript:sortFieldSub(this,'a.price')"
                            style="display: ${permission:checkUserFieldDisplay('stk.stkOut.lookprice')}">单价▲
                        </td>
                        <td onclick="javascript:sortFieldSub(this,'a.amt')"
                            style="display: ${permission:checkUserFieldDisplay('stk.stkOut.lookamt')}">销售金额▲
                        </td>
                    </c:if>
                    <c:if test="${billId eq 0}">
                        <td onclick="javascript:sortField(this,'b.ware_code')">产品编号▲</td>
                        <td onclick="javascript:sortField(this,'b.ware_nm')" style="width:200px">产品名称▲</td>
                        <td onclick="javascript:sortField(this,'b.ware_gg')">产品规格▲</td>
                        <td onclick="javascript:sortField(this,'a.xs_tp')">销售类型▲</td>
                        <td onclick="javascript:sortField(this,'a.be_unit')">单位▲</td>
                        <td onclick="javascript:sortField(this,'a.ware_num')"
                            style="display: ${permission:checkUserFieldDisplay('stk.stkOut.lookqty')}">销售数量▲
                        </td>
                        <td onclick="javascript:sortField(this,'a.ware_dj')"
                            style="display: ${permission:checkUserFieldDisplay('stk.stkOut.lookprice')}">单价▲
                        </td>
                        <td onclick="javascript:sortField(this,'a.ware_zj')"
                            style="display: ${permission:checkUserFieldDisplay('stk.stkOut.lookamt')}">销售金额▲
                        </td>
                    </c:if>
                    <td style="display: ${fns:checkFieldDisplay('sys_config','*','code=\'CONFIG_OUT_FANLI_PRICE\'  and status=1')}">
                        应付返利单价
                    </td>
                    <td>生产日期</td>
                    <td>有效期</td>
                    <td>备注</td>
                    <td style="display: none" class="sunitClass">小单位数量</td>
                    <td style="display: none" class="sunitClass">小单位价格</td>
                    <td style="display: none" class="helpClass">辅助销售数量</td>
                    <td style="display: none" class="helpClass">辅助销售单位</td>
                    <td><a class="easyui-linkbutton" iconCls="icon-add" plain="true"
                           href="javascript:addTabRow(1);">增行</a></td>
                </tr>
                </thead>
                <tbody id="chooselist">
                <c:forEach items="${warelist}" var="item" varStatus="s">
                    <tr onmouseout="wareTrOnMouseOutClick(this)" onmousedown="wareTrOnMouseDownClick(this)"
                        style="${item.checkWare eq 1?'background:skyblue':''}">
                        <td class="index">${s.index+1 }</td>
                        <td onkeydown="gjr_toNextRow(this,'edtqty')" style="padding-left: 20px;text-align: left;"
                            class="tdClass">
                            <input type="hidden" name="wareId" value="${item.wareId}"/>
                            <input type="hidden" name="checkWare" value="${item.checkWare}"/>
                            <input type="text" class="pcl_i2" value="${item.wareCode}" readonly="true"
                                   style="width: 100px" id="wareCode${s.index}" name="wareCode"/>
                            <div></div>
                        </td>
                        <td>
                            <input name="wareNm" id="wareNm${s.index }" type="text" placeholder="输入商品名称、商品代码、商品条码"
                                   value="${item.wareNm}" onclick="wareAutoClick(this)"
                                   onkeydown="gjr_forAuto_toNextCell(this,'edtqty')" style="width: 170px"/>
                            <img src="../../resource/images/select.gif" onclick="dialogOneWare(this)" id="selectFpno"
                                 align="absmiddle" align="absmiddle" style="position:absolute;right:5px;top:5px;">
                        </td>
                        <td onkeydown="gjr_toNextRow(this,'edtprice')"><input type="text" class="pcl_i2"
                                                                              value="${item.wareGg}"
                                                                              style="width: 80px;" readonly="true"
                                                                              id="wareGg${s.index}" name="wareGg"/></td>
                        <td>
                            <select name="xstp" id="xstp${s.index}" style="width:80px">
                                <option value="正常销售"<c:if test="${item.xsTp == '正常销售'}"> selected</c:if>>正常销售</option>
                                <option value="促销折让"<c:if test="${item.xsTp == '促销折让'}"> selected</c:if>>促销折让</option>
                                <option value="消费折让"<c:if test="${item.xsTp == '消费折让'}"> selected</c:if>>消费折让</option>
                                <option value="费用折让"<c:if test="${item.xsTp == '费用折让'}"> selected</c:if>>费用折让</option>
                                <option value="其他销售"<c:if test="${item.xsTp == '其他销售'}"> selected</c:if>>其他销售</option>
                            </select>
                        </td>
                        <td>
                            <select id="beUnit${s.index }" name="beUnit" style="width:50px"
                                    onchange="changeUnit(this,${s.index })">
                                <option value="${item.maxUnitCode}" <c:if
                                        test="${item.beUnit == 'B'}"> selected</c:if>>${item.wareDw}</option>
                                <option value="${item.minUnitCode}" <c:if
                                        test="${item.beUnit == 'S'}"> selected</c:if>>${item.minUnit}</option>
                            </select>
                        </td>
                        <td onkeydown="gjr_toNextRow(this,'edtqty')"
                            style="display: ${permission:checkUserFieldDisplay('stk.stkOut.lookqty')}"><input
                                name="edtqty" onclick="gjr_CellClick(this)" onkeydown="gjr_toNextCell(this,'edtprice')"
                                type="text" class="pcl_i2" value="${item.qty}" onchange="countAmt()"/></td>
                        <td onkeydown="gjr_toNextRow(this,'edtprice')"
                            style="display: ${permission:checkUserFieldDisplay('stk.stkOut.lookprice')}"
                            class="${(item.priceFlag eq 1 and status ne 2)?'ware_dif_price_tip':''}">
                            <input name="edtprice" id="edtprice${s.index}" type="text" class="pcl_i2"
                                   value="${item.price}" onclick="gjr_CellClick(this)"
                                   onkeydown="gjr_toNextCell(this,'edtRemarks')" onchange="countAmt()"/></td>
                        <td style="display: ${permission:checkUserFieldDisplay('stk.stkOut.lookamt')}">
                            <input id="amt${s.index}" name="amt" type="text" class="pcl_i2" value="${item.amt}"
                                   onchange="countPrice()"/>
                        </td>
                        <td style="display: ${fns:checkFieldDisplay('sys_config','*','code=\'CONFIG_OUT_FANLI_PRICE\'  and status=1')}">
                            <input name="rebatePrice" id="rebatePrice${s.index}" type="text" class="pcl_i2"
                                   value="${item.rebatePrice}" onclick="gjr_CellClick(this)"/></td>
                        <td onkeydown="gjr_toNextRow(this,'productDate')" ${not empty item.sswId?'style=background:#DBDBDB':''}>
                            <input name="productDate" id="productDate${s.index}" class="pcl_i2" placeholder="单击选择"
                                   onClick="WdatePicker({skin:'whyGreen',dateFmt: 'yyyy-MM-dd'});" style="width: 90px;"
                                   readonly="readonly" value="${item.productDate}"/>
                            <a href="javacript:;;" onclick="selectWareBatch(this)">关联</a>
                        </td>
                        <td onkeydown="gjr_toNextRow(this,'qualityDays')"><input name="qualityDays"
                                                                                 onclick="gjr_CellClick(this)"
                                                                                 onkeydown="gjr_toNextCell(this,'edtRemarks')"
                                                                                 class="pcl_i2" style="width: 90px;"
                                                                                 value="${item.activeDate}"/></td>
                        <td onkeydown="gjr_toNextRow(this,'wareNm','1','gjrRowOperFun')">
                            <input name="edtRemarks" onclick="gjr_CellClick(this)" type="text" class="pcl_i2"
                                   style="width: 80px;" value="${item.remarks}"/>
                        </td>
                        <td style="display:none"><input id="hsNum${s.index }" name="hsNum" type="hidden" class="pcl_i2"
                                                        value="${item.hsNum}"/></td>
                        <td style="display:none"><input id="unitName${s.index }" name="unitName" type="hidden"
                                                        class="pcl_i2" value="${item.unitName}"/></td>
                        <td style="display:none"><input id="sunitPrice${s.index }" name="sunitPrice" type="hidden"
                                                        class="pcl_i2" value="${item.sunitPrice}"/></td>
                        <td style="display:none">
                            <c:if test="${item.beUnit eq 'B'}">
                                <input id="bUnitPrice${s.index }" name="bUnitPrice" type="hidden" class="pcl_i2"
                                       value="${item.price}"/>
                            </c:if>
                            <c:if test="${item.beUnit eq 'S'}">
                                <input id="bUnitPrice${s.index }" name="bUnitPrice" type="hidden" class="pcl_i2"
                                       value="${item.price*item.hsNum}"/>
                            </c:if>
                        </td>
                        <td style="display:none"><input id="sswId${s.index }" name="sswId" value="${item.sswId}"
                                                        type="hidden" class="pcl_i2"/></td>
                        <td style="display:none" class="sunitClass"><input name="sunitQty" readonly="readonly"
                                                                           class="pcl_i2"/></td>
                        <td style="display:none" class="sunitClass"><input name="sunitJiage"
                                                                           onclick="gjr_CellClick(this)"
                                                                           onchange="changeSunitPrice(this)"
                                                                           class="pcl_i2"/></td>
                        <td style="display:none" class="helpClass"><input name="helpQty"
                                                                          class="pcl_i2" onkeyup="CheckInFloat(this)"
                                                                          value="${item.helpQty}"/></td>
                        <td style="display:none" class="helpClass"><input name="helpUnit"
                                                                          class="pcl_i2" value="${item.helpUnit}"/></td>

                        <td>
                            <img onclick="insertTabRow(this);" src="<%=basePath %>/resource/stkstyle/img/icon2.png"
                                 style="width:15px;height:15px;padding-right:5px;"><img onclick="deleteChoose(this);"
                                                                                        src="<%=basePath %>/resource/stkstyle/img/icon1.png"
                                                                                        style="width:15px;height:15px">
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
                <tfoot>
                <tr align="center">
                    <td>合计:</td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td id="edtSumQty" style="display: ${permission:checkUserFieldDisplay('stk.stkOut.lookqty')}">0</td>
                    <td style="display: ${permission:checkUserFieldDisplay('stk.stkOut.lookprice')}"></td>
                    <td id="edtSumAmt" style="display: ${permission:checkUserFieldDisplay('stk.stkOut.lookamt')}">0.00
                    </td>
                    <td style="display: ${fns:checkFieldDisplay('sys_config','*','code=\'CONFIG_OUT_FANLI_PRICE\'  and status=1')}"></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td style="display: none" class="sunitClass"></td>
                    <td style="display: none" class="sunitClass"></td>
                    <td style="display: none" class="helpClass"></td>
                    <td style="display: none" class="helpClass"></td>
                </tr>
                </tfoot>
            </table>
        </div>
    </div>
</div>
</div>
<div class="chose_people pcl_chose_people" style="" id="customerForm">
    <div class="mask"></div>
    <div class="cp_list">
        <a href="javascript:;" class="pcl_close_button"><img
                src="<%=basePath %>/resource/stkstyle/img/lightbox-btn-close.jpg"/></a>
        <div class="cp_src">
            <div class="cp_src_box">
                <img src="<%=basePath %>/resource/stkstyle/img/src_icon2.jpg"/>
                <input type="text" placeholder="搜索" id="searchcst" value="" onkeyup="querycustomer(this.value)"/>
            </div>
            <input type="button" class="cp_btn" value="查询" onclick="searchCustomer()"/>
        </div>
        <div style="height: 400px;overflow: auto;text-align: center">
            <table id="customerlist">

            </table>
            <span id="customerLoadData" style="text-align: center;float:center;"><a href="javascript:;;"
                                                                                    onclick="querycustomerPage()"
                                                                                    style="color: red">加载更多</a></span>
        </div>
    </div>
</div>

<div id="accDlg" closed="true" class="easyui-dialog" title="收款账号" style="width:300px;height:150px;padding:10px"
     data-options="
				iconCls: 'icon-save',
				buttons: [{
					text:'确定',
					iconCls:'icon-ok',
					handler:function(){
						postDraftStkOut();
					}
				},{
					text:'取消',
					handler:function(){
						$('#accDlg').dialog('close');
					}
				}]
			">
    收款账号: <tag:select name="accId" id="accId" tableName="fin_account" headerKey="" whereBlock="status=0"
                      headerValue="--请选择--" displayKey="id" displayValue="acc_name"/>
</div>

<%@include file="/WEB-INF/page/stk/dialog/dialogWanglai.jsp" %>

<div class="chose_people pcl_chose_people" style="" id="orderForm">
    <div class="mask"></div>
    <div class="cp_list">
        <a href="javascript:;" class="pcl_close_button"><img
                src="<%=basePath %>/resource/stkstyle/img/lightbox-btn-close.jpg"/></a>
        <div class="cp_src">
            <table border="0" cellspacing="0" cellpadding="0" frame=void rules=none>
                <td style="border:0">开始:</td>
                <td style="border:0">
                    <div class="pcl_input_box">
                        <input name="text" id="startDate" onClick="WdatePicker();" style="width: 100px;"
                               value="${sdate}" readonly="readonly"/>
                    </div>
                </td>
                <td style="border:0">截至:</td>
                <td style="border:0">
                    <div class="pcl_input_box">
                        <input name="text" id="endDate" onClick="WdatePicker();" style="width: 100px;" value="${edate}"
                               readonly="readonly"/>
                    </div>
                </td>
                <td colspan="2" style="border:0">
                    <div class="pcl_input_box">
                        <input type="text" placeholder="客户名称搜索" id="ordersearch" value="" style=" width: 100%；"/>
                    </div>
                </td>
                <td align="left" style="border:0">
                    <input type="button" class="cp_btn" value="查询" onclick="queryOrder();"/>
                </td>
            </table>
        </div>
        <table id="orderList">

        </table>
    </div>
</div>

<div class="chose_people pcl_chose_people" style="" id="staffForm">
    <div class="mask"></div>
    <div class="cp_list2">
        <!--<a href="javascript:;" class="pcl_close_button"><img src="style/img/lightbox-btn-close.jpg"/></a>-->
        <div class="pcl_box_left">
            <div class="cp_src">
                <div class="cp_src_box">
                    <img src="<%=basePath %>/resource/stkstyle/img/src_icon2.jpg"/>
                    <input type="text" placeholder="模糊查询"/>
                </div>
                <input type="button" class="cp_btn" value="查询"/>
                <input type="button" class="cp_btn2 close_btn2" value="取消"/>
            </div>
        </div>
        <div class="pcl_3box" id="memdiv">
            <div class="pcl_switch clearfix">
                <div class="pcl_3box2">
                    <h2>部门分类树</h2>
                    <div class="pcl_l2" id="departTree">
                        <a href="#">员工</a>
                    </div>
                </div>

                <div class="pcl_rf_box">
                    <div style="height: 400px;overflow: auto;text-align: center">
                        <table class="pcl_table">
                            <thead>
                            <tr>
                                <td>姓名</td>
                                <td>电话</td>
                            </tr>
                            </thead>
                            <tbody id="memberList">
                            <tr>
                                <td>客户1</td>
                                <td>人事经理</td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

        </div>

    </div>
</div>
</div>
<div id="selectSnapshot" closed="true" class="easyui-dialog" style="width:650px; height:400px;" title="快照列表">
    <iframe name="selectSnapshotFrm" id="selectSnapshotFrm" frameborder="0" marginheight="0" marginwidth="0"
            width="100%" height="100%"></iframe>
</div>
<div id="selectSaleOrder" closed="true" class="easyui-dialog" style="width:800px; height:400px;" title="选择销售订单">
    <iframe name="selectSaleOrderfrm" id="selectSaleOrderfrm" frameborder="0" marginheight="0" marginwidth="0"
            width="100%" height="100%"></iframe>
</div>
<div id="wareDlg" closed="true" class="easyui-dialog" style="width:500px; height:200px;" title="商品选择"
     iconCls="icon-edit">
</div>

<div id="wareHisDlg111" closed="true" class="easyui-dialog" style="width:300px; height:100px;" title="商品历史价格"
     iconCls="icon-edit">
</div>
<div id="wareBatchDialog" closed="true" class="easyui-dialog" style="width:400px; height:100px;" title="商品生产日期"
     iconCls="i**con-edit">
</div>
<div id="wareBarDialog" closed="true" class="easyui-dialog" style="width:400px; height:100px;" title="条码商品"
     iconCls="icon-edit">
</div>
<div id="quickWareDlg" closed="true" class="easyui-dialog" title="商品快速添加" data-options="
				iconCls: 'icon-save',
				buttons: [{
					text:'确定并关闭',
					iconCls:'icon-ok',
					handler:function(){
						confirmAndClose();
					}
				},{
					text:'确定并继续',
					iconCls:'icon-ok',
					handler:function(){
						confirmAndGo();
					}
				},{
					text:'取消',
					handler:function(){
						$('#quickWareDlg').dialog('close');
					}
				}]
			" style="width:500px;height:300px;padding:10px">
    <iframe name="quickWareFrm" id="quickWareFrm" frameborder="0" width="100%" style="height: 200px"></iframe>
</div>

<div id="dialogCustomerUnRecDialog" closed="true" class="easyui-dialog" style="width:700px; height:400px;"
     title="客户欠款单据" iconCls="icon-edit">
    <iframe name="dialogCustomerUnRecfrm" id="dialogCustomerUnRecfrm" frameborder="0" marginheight="0" marginwidth="0"
            width="100%" height="100%"></iframe>
</div>

<div id="dialogUpdateCgWares" closed="true" closable="false" class="easyui-dialog" style="width:320px; height:300px;"
     title="商品采购价设置" iconCls="icon-edit" data-options="
				iconCls: 'icon-save',
				buttons: [{
					text:'确定',
					iconCls:'icon-ok',
					handler:function(){
						$('#dialogUpdateCgWares').dialog('close');
					}
				}]
			">
    <iframe name="dialogUpdateCgWaresfrm" id="dialogUpdateCgWaresfrm" frameborder="0" marginheight="0" marginwidth="0"
            width="100%" height="100%"></iframe>
</div>


<div id="billVersion" style="position:absolute;display:none;border:1px solid silver;background:silver;">
    <c:if test="${not empty verList}">
        <table>
            <c:forEach items="${verList}" var="ver" varStatus="s">
                <tr>
                    <td><a href="javascript:;;" onclick="showVersion(${ver.id})">${ver.relaTime}</a></td>
                </tr>
            </c:forEach>
        </table>

    </c:if>

</div>

</body>
<script src="<%=basePath %>/resource/stkstyle/js/lCalendar.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript">
    var oneRowSelect = 0;
    var selectImg = '\<img src="../../resource/images/select.gif" onclick="dialogOneWare(this)" id="selectFpno"   align="absmiddle" style="position:absolute;right:5px;top:5px;">\
';
    var optBtn = "<img onclick=\"insertTabRow(this);\"  src=\"<%=basePath %>/resource/stkstyle/img/icon2.png\" style=\"width:15px;height:15px;padding-right:5px;\"><img onclick=\"deleteChoose(this);\"  src=\"<%=basePath %>/resource/stkstyle/img/icon1.png\" style=\"width:15px;height:15px\">";
    $("#stksel").change(function () {
        var index = this.selectedIndex;
        var stkId = this.options[index].value;
        $("#stkId").val(stkId);
        var this_val = this.options[index].text;
        $(this).siblings('span').text(this_val);
        isModify = true;
        queryOrderDetail();
    });


    $("#vehId").change(function () {
        var index = this.selectedIndex;
        var this_val = this.options[index].text;
        $(this).siblings('span').text(this_val);
    });

    $("#driverId").change(function () {
        var index = this.selectedIndex;
        var this_val = this.options[index].text;
        $(this).siblings('span').text(this_val);
    });


    $("#pszdsel").change(function () {
        var index = this.selectedIndex;
        var selObj = this.options[index].value;
        $("#pszd").val(selObj);
        //alert(selObj);
        var this_val = this.options[index].text;
        $(this).siblings('span').text(this_val);
        if (selObj == "公司直送") {
            $("#epCustomerDiv").hide();
            $("#epCustomerId").val("");
            $("#epCustomerName").val("");
        } else {
            $("#epCustomerDiv").show();
            var cstId = $("#cstId").val();
            if (cstId != "") {
                var path = "getCustomerJsonById";
                $.ajax({
                    url: path,
                    type: "POST",
                    data: {"id": cstId},
                    dataType: 'json',
                    async: false,
                    success: function (json) {
                        if (json.state) {
                            $("#epCustomerId").val(json.customer.epCustomerId);
                            $("#epCustomerName").val(json.customer.epCustomerName);
                        }
                    }
                });
            }
        }
        isModify = true;
    });

    $("#ordersel").change(function () {
        var index = this.selectedIndex;
        var id = this.options[index].value;
        $("#orderId").val(id);
        //alert(stkId);
        var this_val = this.options[index].text;
        $(this).siblings('span').text(this_val);
        queryOrderDetail();
        isModify = true;
    });

    $(".pcl_close_button").click(function () {
        $(this).parents('.chose_people').hide();
    });


    function checkSunitBox(o) {
        if (o.checked) {
            $(".sunitClass").show();
            $("#more_list tbody input[name='wareId']").each(function () {
                if ($(this).val() != "") {
                    var currRow = this.parentNode.parentNode;
                    var hsNum = $(currRow).find("input[name='hsNum']").val();
                    var qty = $(currRow).find("input[name='edtqty']").val();
                    var price = $(currRow).find("input[name='edtprice']").val();
                    var beUnit = $(currRow).find("select[name='beUnit']").val();
                    if (beUnit == "S") {
                        qty = parseFloat(qty);
                        price = parseFloat(price);
                    } else {
                        qty = parseFloat(qty) * parseFloat(hsNum);
                        price = parseFloat(price) / parseFloat(hsNum);
                    }
                    qty = qty.toFixed(5);
                    price = price.toFixed(5);
                    qty = parseFloat(qty);
                    price = parseFloat(price);
                    $(currRow).find("input[name='sunitQty']").val(qty);
                    $(currRow).find("input[name='sunitJiage']").val(price);
                }


            });
        } else {
            $(".sunitClass").hide();
        }
    }

    function changeSunitPrice(o) {
        if (o.value == "") {
            o.value = 0;
        }
        var currRow = o.parentNode.parentNode;
        var hsNum = $(currRow).find("input[name='hsNum']").val();
        var beUnit = $(currRow).find("select[name='beUnit']").val(o.value);
        if (beUnit == "S") {
            $(currRow).find("input[name='edtprice']").val(o.value);
        } else {
            var price = parseFloat(o.value) * parseFloat(hsNum);
            price = price.toFixed(5);
            price = parseFloat(price);
            $(currRow).find("input[name='edtprice']").val(price);
        }
        countAmt();
    }

    $(document).ready(function () {
            var fixHelperModified = function (e, tr) {
                    var $originals = tr.children();
                    var $helper = tr.clone();
                    $helper.children().each(function (index) {
                        $(this).width($originals.eq(index).width())
                    });
                    return $helper;
                },
                updateIndex = function (e, ui) {
                    $('td.index', ui.item.parent()).each(function (i) {
                        $(this).html(i + 1);
                    });
                };
            $("#more_list tbody").sortable({
                helper: fixHelperModified,
                stop: updateIndex
            }).disableSelection();  //添加tr基数背景色样式
            //mouseMoveRow();
        }
    );

    function showMainDiv(o) {
        if ($('#mainDivId').is(':hidden')) {
            //如果隐藏时。。。
            $('#mainDivId').show();
            $(o).text("隐藏");
        } else {
            //如果显示时。。。
            $('#mainDivId').hide();
            $(o).text("显示");
        }
    }

    function querySaleCustomerHisWarePrice(wareId) {
        var path = "querySaleCustomerHisWareStockPrice";
        var cstId = $("#cstId").val();
        if (cstId == "") {
            return;
        }
        if (wareId == "") {
            return;
        }

        var zhanYongChk = $("#zhanYongChk").is(":checked");
        var isCalOcc = 0;
        if (zhanYongChk) {
            isCalOcc = 1;
        }
        $.ajax({
            url: path,
            type: "POST",
            data: {"cid": cstId, "wareId": wareId, "isCalOcc": isCalOcc},
            dataType: 'json',
            async: false,
            success: function (json) {
                if (json.state) {
                    if (json.hisPrice == undefined) {
                        $("#hisPrice").text("");
                    } else {
                        $("#hisPrice").text(json.hisPrice);
                    }
                    $("#zxPrice").text(json.zxPrice);
                    $("#orgPrice").text(json.orgPrice);
                    $("#inPrice").text(json.inPrice);
                    var hsNum = 1;
                    var bUnit = 'B';
                    var sUnit = 'S';
                    var wareNmSpan = "";
                    $("#more_list tbody input[name$='wareId']").each(function () {
                        if ($(this).val() == wareId) {
                            var currRow = this.parentNode.parentNode;
                            hsNum = $(currRow).find("input[name='hsNum']").val();
                            wareNmSpan = $(currRow).find("input[name='wareNm']").val();
                            var beUnit = $(currRow).find("select[name='beUnit']");
                            bUnit = beUnit.get(0).options[0].text;
                            sUnit = beUnit.get(0).options[1].text;
                        }
                    });
                    if (json.occQty == "" || json.occQty == undefined) {
                        json.occQty = 0;
                    }
                    if (json.stkQty == "" || json.stkQty == undefined) {
                        json.stkQty = 0;
                    }
                    if (json.xnQty == "" || json.xnQty == undefined) {
                        json.xnQty = 0;
                    }
                    var minOccQty = parseFloat(json.occQty) * parseFloat(hsNum);
                    var stkQty = parseFloat(json.stkQty) * parseFloat(hsNum);
                    var xnQty = parseFloat(json.xnQty) * parseFloat(hsNum);

                    minOccQty = Math.floor(minOccQty * 100) / 100;
                    stkQty = Math.floor(stkQty * 100) / 100;
                    xnQty = Math.floor(xnQty * 100) / 100;

                    $("#wareNmSpan").html(wareNmSpan);
                    $("#occQty").html("<span style='color:orangered;font-size:12px'>" + formatterQty(json.occQty, hsNum, bUnit, sUnit) + "</span>&nbsp;<span style='color:blue;font-size:10px'>" + minOccQty + "<span style='font-size:6px'>" + sUnit + "</span></span>");
                    $("#stkQty").html("<span style='color:orangered;font-size:12px'>" + formatterQty(json.stkQty, hsNum, bUnit, sUnit) + "</span>&nbsp;<span style='color:blue;font-size:10px'>" + stkQty + "<span style='font-size:6px'>" + sUnit + "</span></span>");
                    $("#xnQty").html("<span style='color:orangered;font-size:12px'>" + formatterQty(json.xnQty, hsNum, bUnit, sUnit) + "</span>&nbsp;<span style='color:blue;font-size:10px'>" + xnQty + "<span style='font-size:6px'>" + sUnit + "</span></span>");
                }
            }
        });
    }

    function formatterQty(v, hsNum, bUnit, sUnit) {
        if (parseFloat(hsNum) > 1) {
            var str = v + "";
            if (str.indexOf(".") != -1) {
                var nums = str.split(".");
                var num1 = nums[0];
                var num2 = nums[1];
                if (parseFloat(num2) > 0) {
                    var minQty = parseFloat(0 + "." + num2) * parseFloat(hsNum);
                    minQty = Math.floor(minQty * 100) / 100;
                    return num1 + "" + bUnit + "" + minQty + "" + sUnit;
                }
            }
        }
        v = Math.floor(v * 100) / 100;
        return v + "<span style='font-size:8px'>" + bUnit + "</span>";

    }

    function selectSaleOrder() {
        var billId = $("#billId").val();
        if (billId != 0) {
            $.messager.alert('消息', '单据已生成，不能在选择订单!', 'info');
            return;
        }
        document.getElementById("selectSaleOrderfrm").src = "selectOrderPage";
        $('#selectSaleOrder').dialog('open');
    }

    function showSnapshot() {
        var url = "/manager/snapshot/list?billType=xxfp";
        var billId = $("#billId").val();
        if (billId != 0) {
            url += "&billId=" + billId;
        }
        document.getElementById("selectSnapshotFrm").src = url;
        $('#selectSnapshot').dialog('open');
    }

    function setValueFromOrder(rowIndex, rowData) {
        var orderId = rowData.id;
        var orderNo = rowData.orderNo;
        var address = rowData.address;
        var tel = rowData.tel;
        var pszd = rowData.pszd;
        var khNm = rowData.khNm;
        var cstId = rowData.cid;
        var staff = rowData.memberNm;
        var stafftel = rowData.memberMobile;
        var remarks = rowData.remo;
        var discount = rowData.zdzk;
        var mid = rowData.mid;

        $("#cstId").val(cstId);//客户ID
        $("#khNm").val(khNm);
        //$("#pc_lib").text(khNm);//客户名称
        $("#csttel").val(tel);//客户电话
        $("#cstaddress").val(address);//客户地址
        $("#remarks").val(remarks);//备注
        $("#orderId").val(orderId);//订单id
        $("#pc_order").text(orderNo);//订单号
        $("#empId").val(mid);
        $("#staff").text(staff);//业务员
        $("#stafftel").val(stafftel);//业务员电话
        $("#discount").val(discount);
        $("#checktd").css('display', 'block');
        $("#check1").attr("checked", false);//设置为选中状态
        queryOrderDetail();
        $('#selectSaleOrder').dialog('close');
    }

    function showUnRecPage() {
        var cstId = $("#cstId").val();
        if (cstId == "" && xsfpQuickBill == 'none') {
            $.messager.alert('消息', '请先选择客户!', 'info');
            return;
        }
        document.getElementById("dialogCustomerUnRecfrm").src = "<%=basePath%>/manager/toDialogCustomerUnRecPage?cstId=" + cstId;
        $('#dialogCustomerUnRecDialog').dialog('open');
    }

    function showUpdateCgWares(ids) {
        document.getElementById("dialogUpdateCgWaresfrm").src = "<%=basePath%>/manager/toWareInPrice?ids=" + ids;
        $('#dialogUpdateCgWares').dialog('open');
    }

    /**********************设置商品下拉开始**********************/
    var curr_row_index = -1;

    /*设置商品下拉结束*/
    function addTabRowData(json) {
        var unitDisplay = 'none';
        var checkSunitBox = $("#checkSunitBox").attr('checked');
        if (checkSunitBox) {
            unitDisplay = '';
        }
        //if (editstatus == 0) return;
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
        var dateStr = myDate.getFullYear() + seperator1 + month + seperator1 + strDate;
        var wareCode = json.wareCode;
        var wareId = json.wareId;
        var wareName = json.wareNm;
        var price = json.wareDj;
        var unitName = json.maxNm;
        var wareGg = json.wareGg;
        var maxUnitCode = json.maxUnitCode;
        var minUnitCode = json.minUnitCode;
        var minUnit = json.minNm;
        var hsNum = json.hsNum;
        var qualityDays = json.qualityDays;
        var productDate = json.productDate;
        var sunitPrice = json.sunitPrice;
        var qty = 1;
        var amt = price;


        if (json.qty != undefined && json.qty != 0) {
            qty = json.qty;
            amt = parseFloat(qty) * parseFloat(price);
        }
        if (qualityDays == undefined || qualityDays == "undefined") {
            qualityDays = "";
        }
        if (productDate == undefined || productDate == "undefined") {
            productDate = "";
        }
        var len = $("#chooselist").find("tr").length;
        len = len + 1;
        $("#more_list tbody").append('<tr  onmouseout="wareTrOnMouseOutClick(this)"   onmousedown="wareTrOnMouseDownClick(this)">' +
            '<td class="index">' + len + '</td>'
            +
            '<td style="padding-left: 20px;text-align: left;" class="tdClass">' +
            '<input type="hidden" id="wareId' + rowIndex + '" name="wareId" value = "' + wareId + '"/><input type="hidden" name="checkWare"/><input type="text" class="pcl_i2" readonly="true" id="wareCode' + rowIndex + '" value=' + wareCode + ' name="wareCode"/><div></div></td>' +
            '<td id="autoCompleterTr' + rowIndex + '" class="wareClass"><input name="wareNm"  type="text" placeholder="输入商品名称、商品代码、商品条码" onclick="wareAutoClick(this)" onkeydown="gjr_forAuto_toNextCell(this,\'edtqty\')" style="width: 170px"/>' + selectImg + '</td>' +
            '<td><input type="text" class="pcl_i2" readonly="true" id="wareGg' + rowIndex + '" value="' + wareGg + '" style="width: 80px;" name="wareGg"/></td>' +
            '<td >' +
            '<select name="xstp" id="xstp' + rowIndex + '"  style="width:80px" onchange="chooseXsTp(this);" >' +
            '<option value="正常销售" checked>正常销售</option>' +
            '<option value="促销折让">促销折让</option>' +
            '<option value="消费折让">消费折让</option>' +
            '<option value="费用折让">费用折让</option>' +
            '<option value="其他销售">其他销售</option>' +
            '</select>' +
            '</td>' +
            '<td >' +
            '<select id="beUnit' + rowIndex + '"  name="beUnit" style="width:50px" onchange="changeUnit(this,' + rowIndex + ')">' +
            '<option value="' + maxUnitCode + '" checked>' + unitName + '</option>' +
            '<option value="' + minUnitCode + '">' + minUnit + '</option>' +
            '</select>'
            + '</td>' +
            '<td onkeydown="gjr_toNextRow(this,\'edtqty\')" style="display:' + qtyDisplay + '"><input id="edtqty' + rowIndex + '" onclick="gjr_CellClick(this)" name="edtqty" type="text" class="pcl_i2" value="' + qty + '"  onkeydown="gjr_toNextCell(this,\'edtprice\')"  onchange="countAmt()"/></td>' +
            '<td onkeydown="gjr_toNextRow(this,\'edtprice\')" style="display:' + priceDisplay + '"><input id="edtprice' + rowIndex + '" onclick="gjr_CellClick(this)" onkeydown="gjr_toNextCell(this,\'edtRemarks\')"  name="edtprice" type="text" class="pcl_i2" value="' + price + '" onchange="countAmt()"/></td>' +
            '<td style="display:' + amtDisplay + '"><input id="amt' + rowIndex + '" onclick="gjr_CellClick(this)"  name="amt" type="text" class="pcl_i2" value="' + amt + '" onchange="countPrice()"/></td>' +
            '<td style="display:' + fanLiDisplay + '"><input id="rebatePrice' + rowIndex + '" onclick="gjr_CellClick(this)"  name="rebatePrice" type="text" class="pcl_i2" value=""/></td>' +
            '<td onkeydown="gjr_toNextRow(this,\'edtqty\')"><input name="productDate" placeholder="单击选择"  onkeydown="gjr_toNextCell(this,\'qualityDays\')"   onClick="WdatePicker({skin:\'whyGreen\',dateFmt: \'yyyy-MM-dd\'});" style="width: 90px;" class="pcl_i2"  readonly="readonly" value="' + productDate + '"/><a href="javacript:;;" onclick="selectWareBatch(this)">关联</a></td>' +
            '<td onkeydown="gjr_toNextRow(this,\'qualityDays\')"><input name="qualityDays" onclick="gjr_CellClick(this)"  onkeydown="gjr_toNextCell(this,\'edtRemarks\')"    style="width: 90px;" class="pcl_i2" value="' + qualityDays + '"/></td>' +
            '<td onkeydown="gjr_toNextRow(this,\'wareNm\',\'1\',\'gjrRowOperFun\')"><input  onclick="gjr_CellClick(this)" name="edtRemarks" type="text" class="pcl_i2" style="width: 80px;"/></td>' +
            '<td style="display:none"><input id="hsNum' + rowIndex + '" name="hsNum" type="hidden" class="pcl_i2" value="' + hsNum + '"/></td>' +
            '<td style="display:none"><input id="unitName' + rowIndex + '" name="unitName" type="hidden" class="pcl_i2" value="' + unitName + '" /></td>' +
            '<td style="display:none"><input id="sunitPrice' + rowIndex + '" name="sunitPrice" type="hidden" class="pcl_i2" value="' + sunitPrice + '" /></td>' +
            '<td style="display:none"><input id="bUnitPrice' + rowIndex + '" name="bUnitPrice" type="hidden" class="pcl_i2" value="' + price + '" /></td>' +
            '<td style="display:none"><input id="sswId' + rowIndex + '" name="sswId" type="hidden" class="pcl_i2" /></td>' +
            '<td style="display:' + unitDisplay + '" class="sunitClass"><input name="sunitQty" readonly="readonly" class="pcl_i2" /></td>' +
            '<td style="display:' + unitDisplay + '" class="sunitClass"><input name="sunitJiage" onclick="gjr_CellClick(this)" onchange="changeSunitPrice(this)" class="pcl_i2" /></td>' +
            '<td style="display:' + helpDisplay + '" class="helpClass"><input name="helpQty" onkeyup="CheckInFloat(this)"  class="pcl_i2" /></td>' +
            '<td style="display:none" ><input name="priceFlag" type="hidden" /></td>' +
            '<td style="display:' + helpDisplay + '" class="helpClass"><input name="helpUnit"  class="pcl_i2" /></td>' +
            '<td>' + optBtn + '</td>' +
            '</tr>');
        var row = $("#more_list tbody tr").eq(len - 1);
        $(row).find("input[name='wareNm']").attr("id", "wareNm" + rowIndex);
        $(row).find("input[name='wareNm']").val(json.wareNm);
        if(json.sswId!=undefined){
            $(row).find("input[name='sswId']").val(json.sswId);
            $(row).find("input[name='productDate']").parent().css('background-color', '#DBDBDB');//f5f5f5
        }else{
            $(row).find("input[name='sswId']").val("");
        }

        setKendoAutoComplete($(row).find("input[name='wareNm']").attr("id"));
        setKendoAutoOption($(row).find("select[name='beUnit']").attr("id"));
        setKendoAutoXsOption($(row).find("select[name='xstp']").attr("id"));
        if ($("#autoPrice").val() == 1) {
            setWareCustomerHisPrice(wareId, "edtprice" + rowIndex);
        } else {
            setWareCustomerPrice(wareId, "edtprice" + rowIndex);
        }
        rowIndex++;
        countAmt();
        /************如果商品信息中有设置默认选中辅助单位，那么就选中设置选中辅助 开始***********/

        var sunitFront = json.sunitFront;
        if (sunitFront == 1) {
            $(row).find("select[name='beUnit']").val(minUnitCode);
            $(row).find("select[name='beUnit']").data('kendoComboBox').value(json.minUnitCode);
            $(row).find("select[name='beUnit']").trigger("change");
        }
        /************如果商品信息中有设置默认选中辅助单位，那么就选中设置选中辅助 结束***********/
        if (curr_row_index != -1 && oneRowSelect == 0) {
            curr_row_index = row.rowIndex;
            $(row).find("input[name='wareNm']").focus();
        }
        $(row).find("input[name='wareNm']").focus();
        $("#wareInput").val("");
    }

    function callBackFun(json) {
        var size = json.list.length;
        if (size > 0) {
            for (var i = 0; i < size; i++) {
                if (oneRowSelect == 1 && i == 0) {
                    setTabRowData(json.list[i]);
                    var index = curr_row_index - 1;
                    var row = $("#more_list tbody tr").eq(index);
                    $(row).find("input[name='wareNm']").focus();
                    break;
                }
                if (i == 0) {
                    var len = $("#chooselist").find("tr").length;
                    if (len == 1) {
                        var tr = $("#chooselist").eq(len - 1);
                        var v = $(tr).find("input[name='wareId']").val();
                        if (v == "") {
                            curr_row_index = 1;
                            setTabRowData(json.list[i]);
                            curr_row_index = -1;
                            continue;
                        }
                    }
                }
                addTabRowData(json.list[i]);
            }
        }
    }

    function setCustomerHisWarePrice(data, oper) {
        var path = "querySaleCustomerHisWarePrice";
        var cstId = $("#cstId").val();
        if (cstId == "") {
            return;
        }
        if (data.wareId == "") {
            return;
        }
        $.ajax({
            url: path,
            type: "POST",
            data: {"cid": cstId, "wareId": data.wareId},
            dataType: 'json',
            async: false,
            success: function (json) {
                if (json.state) {
                    if (json.zxPrice != undefined && json.zxPrice != '' && json.zxPrice != null) {
                        data.wareDj = json.zxPrice;
                    }
                    if (json.hisPrice != undefined && json.hisPrice != '' && json.hisPrice != null) {
                        data.wareDj = json.hisPrice;
                    }
                }
                if (oper = "add") {
                    addTabRowData(data);
                } else {
                    setTabRowData(json.list[i]);
                }

            }
        });
    }

    function addTabRow(k) {
        var len = $("#chooselist").find("tr").length;
        len = len + 1;
        $("#more_list tbody").append(getAddRow(len));
        var td = $("#autoCompleterTr" + rowIndex);
        $(td).find("input[name='wareNm']").attr("id", "wareNm" + rowIndex);
        var row = $("#more_list tbody tr").eq(len - 1);
        setKendoAutoComplete($(row).find("input[name='wareNm']").attr("id"));
        //setKendoAutoOption($(row).find("select[name='beUnit']").attr("id"));
        setKendoAutoXsOption($(row).find("select[name='xstp']").attr("id"));
        curr_row_index = $(row).index() + 1;
        $(row).find("input[name='wareNm']").focus();
        //3.  todo
        rowIndex++;
    }

    function getAddRow(len) {
        var unitDisplay = 'none';
        var checkSunitBox = $("#checkSunitBox").attr('checked');
        ;
        if (checkSunitBox) {
            unitDisplay = '';
        }
        var row = '<tr  onmouseout="wareTrOnMouseOutClick(this)"   onmousedown="wareTrOnMouseDownClick(this)">' +
            '<td class="index">' + len + '</td>' +
            '<td style="padding-left: 20px;text-align: left;" class="tdClass">' +
            '<input type="hidden" id="wareId' + rowIndex + '" name="wareId"/><input type="hidden" name="checkWare"/><input type="text" class="pcl_i2" readonly="true" id="wareCode' + rowIndex + '" name="wareCode"/><div></div></td>' +
            '<td id="autoCompleterTr' + rowIndex + '" class="wareClass"><input name="wareNm"  type="text" placeholder="输入商品名称、商品代码、商品条码" onclick="wareAutoClick(this)" onkeydown="gjr_forAuto_toNextCell(this,\'edtqty\')" style="width: 170px"/>' + selectImg + '</td>' +
            '<td ><input type="text" class="pcl_i2" readonly="true" id="wareGg' + rowIndex + '" name="wareGg" style="width: 90px;"/></td>' +
            '<td>' +
            '<select name="xstp"  id="xstp' + rowIndex + '" style="width:80px" onchange="chooseXsTp(this);" >' +
            '<option value="正常销售" checked>正常销售</option>' +
            '<option value="促销折让">促销折让</option>' +
            '<option value="消费折让">消费折让</option>' +
            '<option value="费用折让">费用折让</option>' +
            '<option value="其他销售">其他销售</option>' +
            '</select>' +
            '</td>' +
            '<td >' +
            '<select id="beUnit' + rowIndex + '" style="width:50px"  name="beUnit"  onchange="changeUnit(this)">' +
            '</select>'
            + '</td>' +
            '<td onkeydown="gjr_toNextRow(this,\'edtqty\')" style="display:' + qtyDisplay + '"><input id="edtqty' + rowIndex + '" onclick="gjr_CellClick(this)" name="edtqty" type="text" class="pcl_i2" value="1"  onkeydown="gjr_toNextCell(this,\'edtprice\')"  onchange="countAmt()"/></td>' +
            '<td onkeydown="gjr_toNextRow(this,\'edtprice\')" style="display:' + priceDisplay + '"><input id="edtprice' + rowIndex + '" onclick="gjr_CellClick(this)" onkeydown="gjr_toNextCell(this,\'edtRemarks\')"  name="edtprice" type="text" class="pcl_i2"  onchange="countAmt()"/></td>' +
            '<td style="display:' + amtDisplay + '"><input id="amt' + rowIndex + '" onclick="gjr_CellClick(this)"  name="amt" type="text" class="pcl_i2" onchange="countPrice()"/></td>' +
            '<td style="display:' + fanLiDisplay + '"><input id="rebatePrice' + rowIndex + '" onclick="gjr_CellClick(this)"  name="rebatePrice" type="text" class="pcl_i2" value=""/></td>' +
            '<td onkeydown="gjr_toNextRow(this,\'edtqty\')"><input name="productDate" placeholder="单击选择"  onkeydown="gjr_toNextCell(this,\'qualityDays\')"   onClick="WdatePicker({skin:\'whyGreen\',dateFmt: \'yyyy-MM-dd\'});" style="width: 90px;" class="pcl_i2"  readonly="readonly"/><a href="javacript:;;" onclick="selectWareBatch(this)">关联</a></td>' +
            '<td onkeydown="gjr_toNextRow(this,\'qualityDays\')"><input name="qualityDays"  onclick="gjr_CellClick(this)"  onkeydown="gjr_toNextCell(this,\'edtRemarks\')"    style="width: 90px;" class="pcl_i2" /></td>' +
            '<td onkeydown="gjr_toNextRow(this,\'wareNm\',\'1\',\'gjrRowOperFun\')"><input  onclick="gjr_CellClick(this)" name="edtRemarks" type="text" class="pcl_i2" style="width: 80px;"/></td>' +
            '<td style="display:none"><input id="hsNum' + rowIndex + '" name="hsNum" type="hidden" class="pcl_i2" /></td>' +
            '<td style="display:none"><input id="unitName' + rowIndex + '" name="unitName" type="hidden" class="pcl_i2" /></td>' +
            '<td style="display:none"><input id="sunitPrice' + rowIndex + '" name="sunitPrice" type="hidden" class="pcl_i2"  /></td>' +
            '<td style="display:none"><input id="bUnitPrice' + rowIndex + '" name="bUnitPrice" type="hidden" class="pcl_i2" /></td>' +
            '<td style="display:none"><input id="sswId' + rowIndex + '" name="sswId" type="hidden" class="pcl_i2" /></td>' +
            '<td style="display:' + unitDisplay + '" class="sunitClass"><input name="sunitQty" readonly="readonly" class="pcl_i2" /></td>' +
            '<td style="display:' + unitDisplay + '" class="sunitClass"><input name="sunitJiage" onclick="gjr_CellClick(this)" onchange="changeSunitPrice(this)" class="pcl_i2" /></td>' +
            '<td style="display:' + helpDisplay + '" class="helpClass"><input name="helpQty" onkeyup="CheckInFloat(this)" class="pcl_i2" /></td>' +
            '<td style="display:' + helpDisplay + '" class="helpClass"><input name="helpUnit"  class="pcl_i2" /></td>' +
            '<td style="display:none"><input name="priceFlag" type="hidden" /></td>' +
            '<td>' + optBtn + '</td>' +
            '</tr>';
        return row;
    }


    function insertTabRow(o) {
        var currRow = $(o).parents('tr');
        var index = $(currRow).index();
        var rowHTML = getAddRow(index);
        currRow.after(rowHTML);
        var td = $("#autoCompleterTr" + rowIndex);
        var newRow = $(td).closest('tr');
        $(td).find("input[name='wareNm']").attr("id", "wareNm" + rowIndex);
        setKendoAutoComplete($(newRow).find("input[name='wareNm']").attr("id"));
        setKendoAutoOption($(newRow).find("select[name='beUnit']").attr("id"));
        setKendoAutoXsOption($(newRow).find("select[name='xstp']").attr("id"));
        curr_row_index = newRow.rowIndex;
        $(newRow).find("input[name='wareNm']").focus();
        resetTabIndex();
        rowIndex++;
    }

    function resetTabIndex() {
        var len = $("#more_list").find("tr").length;  //#tb为Table的id  获取所有行
        for (var i = 1; i < len - 1; i++) {
            $("#more_list tr").eq(i).children("td").eq(0).html(i);  //给每行的第一列重写赋值
        }
    }

    /**
     json:数据
     bar:如果大单位条码，则显示大单位；如果是小单位条码，则显示小单位
     **/
    function setTabRowData(json, bar) {
        var index = curr_row_index - 1;
        var row = $("#more_list tbody tr").eq(index);
        if ($(row).find("input[name='wareId']").val() != "") {
            //return;
        }
        $(row).find("input[name='wareId']").val(json.wareId);
        $(row).find("input[name='wareCode']").val(json.wareCode);
        $(row).find("input[name='wareNm']").val(json.wareNm);
        $(row).find("input[name='wareGg']").val(json.wareGg);
        $(row).find("input[name='edtprice']").val(json.wareDj);
        $(row).find("input[name='hsNum']").val(json.hsNum);
        $(row).find("input[name='sunitPrice']").val(json.sunitPrice);
        $(row).find("input[name='productDate']").val(json.productDate);
        $(row).find("input[name='qualityDays']").val(json.qualityDays);
        $(row).find("input[name='bUnitPrice']").val(json.wareDj);

        if(json.sswId!=undefined){
            $(row).find("input[name='sswId']").val(json.sswId);
            $(row).find("input[name='productDate']").parent().css('background-color', '#DBDBDB');//f5f5f5
        }else{
            $(row).find("input[name='sswId']").val("");
        }

        // $(row).find("select[name='beUnit'] option").empty();
        $(row).find("select[name='beUnit'] option").remove();
        //var size = $(row).find("select[name='beUnit'] option").size();
        //if (size == 0) {
        $(row).find("select[name='beUnit']").append("<option value='" + json.maxUnitCode + "'>" + json.maxNm + "</option>");
        $(row).find("select[name='beUnit']").append("<option value='" + json.minUnitCode + "'>" + json.minNm + "</option>");
        //}
        $(row).find("select[name='beUnit']").val(json.maxNm);
        // initOptionData($(row).find("select[name='beUnit']").attr("id"),json);
        setKendoAutoOption($(row).find("select[name='beUnit']").attr("id"));
        countAmt();

        if ($("#autoPrice").val() == 1) {
            var edtpriceId = $(row).find("input[name='edtprice']").attr("id");
            setWareCustomerHisPrice(json.wareId, edtpriceId);
            countAmt();
        } else {
            var edtpriceId = $(row).find("input[name='edtprice']").attr("id");
            setWareCustomerPrice(json.wareId, edtpriceId);
            countAmt();
        }

        /************如果商品信息中有设置默认选中辅助单位，那么就选中设置选中辅助 开始***********/

        var bool = true;
        if (bar) {
            if (bar == json.packBarCode) {
                bool = false;
            } else if (bar == json.beBarCode) {
                bool = false;
                $(row).find("select[name='beUnit']").val(json.minUnitCode);
                $(row).find("select[name='beUnit']").data('kendoComboBox').value(json.minUnitCode);
                $(row).find("select[name='beUnit']").trigger("change");
            }
        }
        if (bool) {
            var sunitFront = json.sunitFront;
            if (sunitFront == 1) {
                $(row).find("select[name='beUnit']").val(json.minUnitCode);
                $(row).find("select[name='beUnit']").data('kendoComboBox').value(json.minUnitCode);
                $(row).find("select[name='beUnit']").trigger("change");
            }
        }

        /************如果商品信息中有设置默认选中辅助单位，那么就选中设置选中辅助 结束***********/

        $(row).find("input[name='wareNm']").focus();

        wareTrOnMouseDownClick(row);
    }

    function clearTabRowData(json) {
        if (json == null || json == undefined) {
            return;
        }
        var index = curr_row_index - 1;
        var row = $("#more_list tbody tr").eq(index);
        $(row).find("input[name='wareId']").val("");
        $(row).find("input[name='wareCode']").val("");
        $(row).find("input[name='wareNm']").val("");
        $(row).find("input[name='wareGg']").val("");
        $(row).find("input[name='edtprice']").val("");
        $(row).find("input[name='hsNum']").val("");
        $(row).find("input[name='sunitPrice']").val("");
        $(row).find("input[name='bUnitPrice']").val("");
        $(row).find("select[name='beUnit']").empty();
        $(row).find("input[name='unitName']").val("");
        $(row).find("input[name='sswId']").val("");
        clearOptionData($(row).find("select[name='beUnit']").attr("id"));
        countAmt();
    }


    function dialogSelectWare() {
        oneRowSelect = 0;
        var cstId = $("#cstId").val();
        if (cstId == "" && xsfpQuickBill == 'none') {
            $.messager.alert('消息', '请先选择客户!', 'info');
            return;
        }
        var stkId = $("#stkId").val();
        if (stkId == "") {
            alert("请选择仓库!");
            return;
        }
        $('#wareDlg').dialog({
            title: '商品选择',
            iconCls: "icon-edit",
            width: 800,
            height: 400,
            modal: true,
            href: "<%=basePath %>/manager/dialogOutWareType?stkId=" + stkId + "&customerId=" + cstId,
            onClose: function () {
            }
        });
        $('#wareDlg').dialog('open');
    }

    function dialogOneWare(obj) {
        oneRowSelect = 1;
        var currRow = obj.parentNode.parentNode;
        var currRowIndex = currRow.rowIndex;
        curr_row_index = currRowIndex;
        var cstId = $("#cstId").val();
        if (cstId == "" && xsfpQuickBill == 'none') {
            $.messager.alert('消息', '请先选择客户!', 'info');
            return;
        }
        var stkId = $("#stkId").val();
        if (stkId == "") {
            alert("请选择仓库!");
            return;
        }
        $('#wareDlg').dialog({
            title: '商品选择',
            iconCls: "icon-edit",
            width: 800,
            height: 400,
            modal: true,
            href: "<%=basePath %>/manager/dialogOutWareType?stkId=" + stkId + "&op=1&customerId=" + cstId,
            onClose: function () {
            }
        });
        $('#wareDlg').dialog('open');
    }

    function showCustomerHisWarePrice(o) {
        var cstId = $("#cstId").val();
        if (cstId == "" && xsfpQuickBill == 'none') {
            $.messager.alert('消息', '请先选择客户!', 'info');
            return;
        }
        var currRow = $(o).closest('tr');
        var wareId = $(currRow).find("input[name='wareId']").val();
        if (wareId == "") {
            $.messager.alert('消息', '请选择商品!', 'info');
            return;
        }

        $('#wareHisDlg111').dialog({
            title: '商品历史价格',
            iconCls: "icon-edit",
            width: 600,
            height: 300,
            modal: true,
            href: "<%=basePath %>/manager/toDialogCustomerWarePricePage?wareId=" + wareId + "&customerId=" + cstId,
            onClose: function () {
            }
        });
        $('#wareHisDlg111').dialog('open');

    }

    var batchRow;

    function selectWareBatch(o) {
        var stkId = $("#stkId").val();
        var currRow = o.parentNode.parentNode;
        var wareId = $(currRow).find("input[name='wareId']").val();
        if (wareId == "") {
            alert("请选择商品!");
            return;
        }
        batchRow = currRow;
        $('#wareBatchDialog').dialog({
            title: '商品生产日期',
            iconCls: "icon-edit",
            width: 600,
            height: 300,
            modal: true,
            href: "<%=basePath %>/manager/toDialogWareBatchPage?wareId=" + wareId + "&stkId=" + stkId,
            onClose: function () {
            }
        });
        $('#wareBatchDialog').dialog('open');
    }

    function setWareBatchNo(json) {
        $(batchRow).find("input[name='productDate']").val(json.productDate);
        if (productDateConfig == '') {
            $(batchRow).find("input[name='productDate']").parent().css('background-color', '#DBDBDB');//f5f5f5
            $(batchRow).find("input[name='sswId']").val(json.sswId);
        }
        $('#wareBatchDialog').dialog('close');
    }

    $('.tipDiv span').tips({dire: 8});

    function initCountAmt() {
        var total = 0;
        var sumQty = 0;
        var trList = $("#chooselist").children("tr");
        for (var i = 0; i < trList.length; i++) {
            var tdArr = trList.eq(i).find("td");
            var wareId = trList.eq(i).find("input[name='wareId']").val();
            var qty = trList.eq(i).find("input[name='edtqty']").val();
            var totalAmt = trList.eq(i).find("input[name='amt']").val();
            total = parseFloat(total) + parseFloat(totalAmt);
            sumQty = sumQty + qty * 1;
        }
        $("#totalamt").val(numeral(total).format("0,0.00"));
        var discount = $("#discount").val();
        var disamt = parseFloat(total) - parseFloat(discount);
        $("#disamt").val(numeral(disamt).format("0,0.00"));
        $("#edtSumAmt").text(numeral(disamt).format("0,0.00"));
        $("#edtSumQty").text(sumQty);

        $("#more_list #chooselist input[name$='checkWare']").each(function () {
            if ($(this).val() == 1) {
                var currRow = this.parentNode.parentNode;
                //$(currRow).find("input[name$='qty']").val();
                var wareNo = $(currRow).find("input[name$='wareCode']").val();
                chooseNoList.push(wareNo);
                $("#check1").attr("checked", "checked");
                moveRow = $(currRow).index() + 1;
            }
        });
    }

    function selectWanglai() {
        isEp = 0;
        if (editstatus == 0) return;
        var orderId = $("#orderId").val();
        if (orderId > 0) return;
        $("#wanglaiForm").show();
    }

    function quickWareDialog() {
        oneRowSelect = 0;
        document.getElementById("quickWareFrm").src = '${base}/manager/toquickware?tp=xs';
        $('#quickWareDlg').dialog('open');
    }

    function confirmAndClose() {
        window.frames['quickWareFrm'].saveQuickWare(1, 'xs');
        var index = curr_row_index - 1;
        var row = $("#more_list tbody tr").eq(index);
        $(row).find("input[name='wareNm']").focus();

    }

    function confirmAndGo() {
        window.frames['quickWareFrm'].saveQuickWare(-1, 'xs');

    }

    function getCustomerById(customerId) {
        $.ajax({
            url: "${base}/manager/getCustomerById",
            type: "POST",
            data: {"customerId": customerId},
            dataType: 'json',
            async: false,
            success: function (json) {
                if (json.state) {
                    $("#csttel").val(json.customer.tel);
                    $("#cstaddress").val(json.customer.address);
                    var saleId = json.customer.memId;
                    if (saleId == undefined) {
                        saleId = "";
                    }
                    getMemberInfo(saleId);
                } else {
                    $("#csttel").val("");
                    $("#cstaddress").val("");
                    $("#staff").html("");
                    $("#empId").val("");
                    $("#stafftel").val("");

                }
            }
        })
    }

    function setKendoAutoCompleteInput(id) {
        $('#' + id).kendoAutoComplete({
                dataTextField: 'wareNm',
                dataValueField: 'wareId',
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
                            url: basePath + '/manager/dialogOutWarePage',
                            type: 'get',
                            data: function () {
                                return {
                                    page: 1, rows: 20,
                                    waretype: '',
                                    stkId: $('#stkId').val(),
                                    wareNm: $('#' + id).data('kendoAutoComplete').value(),
                                    customerId: ""
                                }
                            }
                        }
                    },
                    requestStart: function (e) {
                        var stkId = $("#stkId").val();
                        if (stkId == "") {
                            $.messager.alert('消息', "请选择仓库", "info");
                            setTimeout(function () {
                                $(".messager-body").window('close');
                            }, 1000)
                            e.preventDefault();
                        }
                        var cstId = $("#cstId").val();
                        if (cstId == "" && xsfpQuickBill == 'none') {
                            $.messager.alert('消息', '请先选择客户!', 'info');
                            setTimeout(function () {
                                $(".messager-body").window('close');
                            }, 1000)
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
                        "unitName": item.wareDw,
                        "qty": 1,
                        "wareDj": item.wareDj,
                        "stkQty": item.stkQty,
                        "sunitFront": item.sunitFront,
                        "sunitPrice": item.sunitPrice,
                        "maxNm": item.wareDw,
                        "minUnitCode": item.minUnitCode,
                        "maxUnitCode": item.maxUnitCode,
                        "minNm": item.minUnit,
                        "hsNum": item.hsNum,
                        "inPrice": item.inPrice,
                        "productDate": item.productDate,
                        "qualityDays": item.qualityDays,
                        "sswId":item.sswId
                    }
                    if (($("#check1").is(":checked") == true)) {
                        return;
                    }
                    addTabRowData(data);
                },
                change: function (e) {
                    if (event.keyCode == "13") {
                        if (($("#check1").is(":checked") == true)) {
                            queryWareBarByKeyWord($("#barcodeInput").val());
                        }
                        $('#' + id).data('kendoAutoComplete').value("");
                        $("#barcodeInput").focus();
                    }
                }
            }
        );
    }

    function setKendoAutoCompletePro(id) {
        var token = $("#tmptoken").val();
        $('#' + id).kendoAutoComplete({
                dataTextField: 'khNm',
                dataValueField: 'id',
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
                            url: basePath + '/manager/stkchoosecustomer',
                            type: 'get',
                            data: function () {
                                return {
                                    page: 1, rows: 20,
                                    dataTp: '1',
                                    token: token,
                                    khNm: $('#' + id).data('kendoAutoComplete').value()
                                }
                            }
                        }
                    }
                },
                select: function (e) {//返回值
                    var item = e.dataItem;
                    var data = {
                        "id": item.id,
                        "khNm": item.khNm,
                        "mobile": item.mobile,
                        "address": item.address,
                        "linkman": item.linkman,
                        "branchName": item.branchName,
                        "shZt": item.shZt,
                        "memId": item.memId,
                        "memberNm": item.memberNm
                    }
                    $("#proType").val(2);
                    if ($("#proType").val() == 2) {
                        $("#cstId").val(data.id);
                        $("#csttel").val(data.mobile);
                        $("#cstaddress").val(data.address);
                        var saleId = data.memId;
                        if (saleId == undefined) {
                            saleId = "";
                        }
                        getMemberInfo(saleId);
                        addTabRow(1);
                    }
                },
                change: function (e) {
                    checkCustomerPage();
                }
            }
        );
    }


    function show(id) {
        var display = $("#" + id + "").css('display');
        if (display == 'none') {
            $("#" + id + "").show();
            $("#" + id + "").css("left", event.clientX);
            $("#" + id + "").css("top", event.clientY + 10);
        } else {
            $("#" + id + "").hide();
        }
    }

    function showVersion(id) {
        parent.closeWin("销售发票版本记录");
        parent.add("销售发票版本记录", "manager/showstkoutversion?billId=" + id);
    }

    function setKendoAutoOption(id) {

        var combobox = $('#' + id).data('kendoComboBox');
        if (combobox) {
            combobox.destroy();
        }
        $('#' + id).kendoComboBox({
            dataTextField: 'text',
            valueTextField: 'value',
            clearButton: false,
            select: function (e) {
                var item = e.item;
                var dataItem = e.dataItem;
                if (event.keyCode == "13") {
                    gjr_forAutotr_toNextCell($('#' + id), 'edtqty');
                }
            },
            change: function (e) {
                gjr_forAutotr_toNextCell($('#' + id), 'edtqty');
            }
        });
        combobox = $('#' + id).data('kendoComboBox');
        //获得焦点时弹出选项
        combobox.input.on('focus', function () {
            combobox.open();
        });
        //回车焦点时弹出选项
        combobox.input.on('keydown', function (e) {
            if (e.keyCode === 13) {
                combobox.open();
                gjr_forAutotr_toNextCell($('#' + id), 'edtqty');
            }
        });
        combobox.input.prop("readonly", true);
    }

    function setKendoAutoXsOption(id) {
        $('#' + id).kendoComboBox({
            dataTextField: 'text',
            valueTextField: 'value',
            clearButton: false,
            select: function (e) {
                if (e.keyCode == 13) {
                    gjr_forAutotr_toNextCell($('#' + id), 'beUnit');
                }
            },
            change: function (e) {
                gjr_forAutotr_toNextCell($('#' + id), 'beUnit');
            }
        });
        var combobox = $('#' + id).data('kendoComboBox');
        //获得焦点时弹出选项
        combobox.input.on('focus', function () {
            combobox.open();
        });
        //回车焦点时弹出选项
        combobox.input.on('keydown', function (e) {
            if (e.keyCode == 13) {
                combobox.open();
                gjr_forAutotr_toNextCell($('#' + id), 'beUnit');
            }
        });
        combobox.input.prop("readonly", true);
    }

    function initOptionData(id, json) {
        var w = $('#' + id).data('kendoComboBox');
        console.log(json);
        w.setDataSource({
            data: [{text: json.maxNm, value: json.maxUnitCode}, {
                text: json.minNm,
                value: json.minUnitCode
            }]
        })
        w.select(0);
    }

    function clearOptionData(id) {
        var w = $('#' + id).data('kendoComboBox');
        w.setDataSource({data: []})
        w.value("");
    }

    if (helpDisplay == '') {
        $(".helpClass").show();
    }
    if (${billId}!=
    0
    )
    {
        initCountAmt();
        // $("#more_list #chooselist input[name='wareNm']").each(function(){
        //     setKendoAutoComplete($(this).attr("id"));
        // });
        // $("#more_list #chooselist select[name='beUnit']").each(function(){
        //     setKendoAutoOption($(this).attr("id"));
        // });
        // $("#more_list #chooselist select[name='xstp']").each(function(){
        //     setKendoAutoXsOption($(this).attr("id"));
        // });
        setTimeout('initData()', 1000);
    }

    function initData() {
        var trList = $("#chooselist").children("tr");
        for (var i = 0; i < trList.length; i++) {
            var row = trList.eq(i);
            setKendoAutoComplete($(row).find("input[name='wareNm']").attr("id"));
            setKendoAutoOption($(row).find("select[name='beUnit']").attr("id"));
            setKendoAutoXsOption($(row).find("select[name='xstp']").attr("id"));
        }
    }

    setKendoAutoCompletePro("khNm");
</script>
<%@include file="/WEB-INF/page/include/handleFile.jsp" %>
</html>