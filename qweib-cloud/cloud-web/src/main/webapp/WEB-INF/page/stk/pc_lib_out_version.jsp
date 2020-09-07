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
    <script type="text/javascript" src="<%=basePath %>/resource/jquery-1.8.0.min.js"></script>
    <script type="text/javascript" src="<%=basePath %>/resource/common.js"></script>
    <script type="text/javascript" src="<%=basePath %>/resource/login/js/jquery-ui.min.js"></script>
    <script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
    <script src="<%=basePath %>/resource/stkstyle/js/Map.js" type="text/javascript" charset="utf-8"></script>
    <script src="<%=basePath %>/resource/stkstyle/js/tip.js" type="text/javascript" charset="utf-8"></script>
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
        .ware_stock_tip{
            color: red;
            font-weight: bold;
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
</style>
<div class="center">
    <div class="pcl_lib_out">
        <div class="pcl_menu_box">
            <div class="menu_btn">
                <div class="item" id="btnnew">
                 操作人：${reauditDesc} &nbsp;操作时间：${relaTime}
                </div>
                <div class="pcl_right_edi" style="width: 400px;">
                    <div class="pcl_right_edi_w">
                        <div>
                            <input type="text" id="billNo" style="color:green;width:160px;font-size: 14px"
                                   readonly="readonly" value="${billNo}"/>
                            <input type="text" id="billstatus" style="color:green;width:55px;font-size: 13px"
                                   readonly="readonly" value="${billstatus}"/>
                            <input type="text" id="paystatus" style="color:green;width:60px;font-size: 13px"
                                   readonly="readonly" value="${paystatus}"/>
                            <div
                                    style="float: right;width: 50px;position:absolute;right:0;bottom:0;font-size: 12px">
                                <a id="displayMainBtn" onclick="showMainDiv(this)" style="color:skyblue;">隐藏</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!--<p class="odd_num">单号：</p>-->
    <input type="hidden" name="billId" id="billId" value="${billId}"/>
    <input type="hidden" name="orderId" id="orderId" value="${orderId}"/>
    <input  type="hidden" name="stkId" id="stkId" value="${stkId}"/>
    <input type="hidden" name="pszd" id="pszd" value="${pszd}"/>
    <input type="hidden" name="status" id="status" value="${status}"/>
    <input type="hidden" name="empId" id="empId" value="${empId}"/>
    <input type="hidden" name="proType" id="proType" value="${proType}"/>
    <input type="hidden" name="autoPrice" id="autoPrice" value="${autoPrice}"/>
    <input type="hidden" name="isSUnitPrice" id="isSUnitPrice" value="${isSUnitPrice}">
    <input type="hidden" name="saleType" id="saleType" value="${saleType}"/>
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
                    <table>
                        <tr>
                            <td width="150px"> ${khNm}
                                <span id="cstMsg" style="color: red;font-size: 10px"></span></td>
                        </tr>
                    </table>
                </td>
                <td style="text-align: center;">配送地址：</td>
                <td>
                    <div class="pcl_input_box pcl_w2"><input type="text" id="cstaddress" value="${address }"/></div>
                </td>
                <td style="text-align: center;">联系电话：</td>
                <td>
                    <div class="pcl_input_box pcl_w2"><input type="text" id="csttel" value="${tel}"/></div>
                </td>
            </tr>
            <tr>
                <td style="text-align: center;">出货仓库：</td>
                <td>
                    <div class="selbox" id="stklist">
                        <span id="stkNamespan">${stkName}</span>
                        <select name="" class="pcl_sel" id="stksel">
                        </select>
                    </div>

                </td>
                <td style="text-align: center;">业 务 员：</td>
                <td>
                    <div class="pcl_chose_peo">
                        <a href="javascript:;" id="staff" style="padding-right: 30px;">${staff}</a>
                    </div>
                </td>
                <td style="text-align: center;">联系电话：</td>
                <td>
                    <div class="pcl_input_box pcl_w2"><input type="text" id="stafftel" value="${stafftel}"/></div>
                </td>
            </tr>
            <tr style="display: ${permission:checkUserFieldDisplay('stk.stkOut.lookamt')}">
                <td style="text-align: center;">
                    合计金额：
                </td>
                <td>
                    <div class="pcl_input_box pcl_w2"><input type="text" id="totalamt" value="${totalamt}"
                                                             readonly="readonly"/></div>
                </td>
                <td style="text-align: center;display:none">
                    整单折扣：
                </td>
                <td style="display:none">
                    <div class="pcl_input_box pcl_w2"><input type="text" id="discount" value="${discount}"
                                                             onchange="countAmt()"/></div>
                </td>
                <td style="text-align: center;">
                    发票金额：
                </td>
                <td>
                    <div class="pcl_input_box pcl_w2"><input type="text" id="disamt" value="${disamt}"
                                                             readonly="readonly"/></div>
                </td>
            </tr>
            <tr>
                <td style="text-align: center;">车&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;辆：</td>
                <td>
                    <div class="selbox">
                        <span id="vehNospan">${vehNo}</span>
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
    <div class="pcl_ttbox1 clearfix" style="height: 400px; overflow: auto;" id="content">
        <div class="pcl_lfbox1">
            <table id="more_list">
                <thead>
                <tr>
                    <td class="index">序号</td>
                    <c:if test="${billId ne 0}">
                        <td onclick="javascript:sortFieldSub(this,'b.ware_code')">产品编号▲</td>
                        <td onclick="javascript:sortFieldSub(this,'b.ware_nm')">产品名称▲</td>
                        <td onclick="javascript:sortFieldSub(this,'b.ware_gg')">产品规格▲</td>
                        <td onclick="javascript:sortFieldSub(this,'a.xs_tp')">销售类型▲</td>
                        <td onclick="javascript:sortFieldSub(this,'a.be_unit')">单位▲</td>
                        <td onclick="javascript:sortFieldSub(this,'a.qty')"
                            style="display: ${permission:checkUserFieldDisplay('stk.stkOut.lookqty')}">销售数量▲
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
                        <td onclick="javascript:sortField(this,'b.ware_nm')">产品名称▲</td>
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
                        返利单价
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
                    <tr onmouseout="wareTrOnMouseOutClick(this)" onmousedown="wareTrOnMouseDownClick(this)">
                        <td class="index">${s.index+1 }</td>
                        <td onkeydown="gjr_toNextRow(this,'edtqty')" style="padding-left: 20px;text-align: left;"
                            onclick="showCustomerHisWarePrice(this)">
                            <input type="hidden" name="wareId" value="${item.wareId}"/>
                            <input type="text" class="pcl_i2" value="${item.wareCode}" readonly="true"
                                   style="width: 130px" id="wareCode${s.index}" name="wareCode"/>
                        </td>
                        <td onkeydown="gjr_toNextRow(this,'edtqty')">
                                ${item.wareNm}
                        </td>
                        <td onkeydown="gjr_toNextRow(this,'edtprice')"><input type="text" class="pcl_i2"
                                                                              value="${item.wareGg}"
                                                                              style="width: 80px;" readonly="true"
                                                                              id="wareGg${s.index}" name="wareGg"/></td>
                        <td onkeydown="gjr_toNextRow(this,'edtprice')"><input type="hidden" name="xsTypeName"
                                                                              value="${item.xsTp}"/>
                            <select name="xstp" class="pcl_sel2" onchange="chooseXsTp(this)">
                                <option value="正常销售"<c:if test="${item.xsTp == '正常销售'}"> selected</c:if>>正常销售</option>
                                <option value="促销折让"<c:if test="${item.xsTp == '促销折让'}"> selected</c:if>>促销折让</option>
                                <option value="消费折让"<c:if test="${item.xsTp == '消费折让'}"> selected</c:if>>消费折让</option>
                                <option value="费用折让"<c:if test="${item.xsTp == '费用折让'}"> selected</c:if>>费用折让</option>
                                <option value="其他销售"<c:if test="${item.xsTp == '其他销售'}"> selected</c:if>>其他销售</option>
                            </select>
                        </td>
                        <td onkeydown="gjr_toNextRow(this,'edtqty')">
                            <select id="beUnit${s.index }" name="beUnit" class="pcl_sel2"
                                    onchange="changeUnit(this,${s.index })">
                                <option value="${item.maxUnitCode}">${item.wareDw}</option>
                                <option value="${item.minUnitCode}">${item.minUnit}</option>
                            </select>
                            <script type="text/javascript">
                                document.getElementById("beUnit${s.index}").value = '${item.beUnit}';
                            </script>
                        </td>
                        <td onkeydown="gjr_toNextRow(this,'edtqty')"
                            style="display: ${permission:checkUserFieldDisplay('stk.stkOut.lookqty')}"><input
                                name="edtqty" onclick="gjr_CellClick(this)" onkeydown="gjr_toNextCell(this,'edtprice')"
                                type="text" class="pcl_i2" value="${item.qty}" onchange="countAmt()"/></td>
                        <td onkeydown="gjr_toNextRow(this,'edtprice')"
                            style="display: ${permission:checkUserFieldDisplay('stk.stkOut.lookprice')}">
                            <input name="edtprice" id="edtprice${s.index}" type="text" class="pcl_i2"
                                   value="${item.price}" onclick="gjr_CellClick(this)"
                                   onkeydown="gjr_toNextCell(this,'qualityDays')" onchange="countAmt()"/></td>
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
                                                        class="pcl_i2" onkeyup="CheckInFloat(this)" value="${item.helpQty}"/></td>
                        <td style="display:none" class="helpClass"><input  name="helpUnit"
                                                        class="pcl_i2" value="${item.helpUnit}"/></td>
                        <td>
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

</body>
<script src="<%=basePath %>/resource/stkstyle/js/lCalendar.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript">

    function initCountAmt() {
        var total = 0;
        var sumQty = 0;
        var trList = $("#chooselist").children("tr");
        for (var i = 0; i < trList.length; i++) {
            var tdArr = trList.eq(i).find("td");
            var wareId = tdArr.eq(0).find("input").val();
            var qty = tdArr.eq(6).find("input").val();
            var totalAmt = tdArr.eq(8).find("input").val();
            total = parseFloat(total) + parseFloat(totalAmt);
            sumQty = sumQty + qty * 1;
        }
        $("#totalamt").val(numeral(total).format("0,0.00"));
        var discount = $("#discount").val();
        var disamt = parseFloat(total) - parseFloat(discount);
        $("#disamt").val(numeral(disamt).format("0,0.00"));
        $("#edtSumAmt").text(numeral(disamt).format("0,0.00"));
        $("#edtSumQty").text(sumQty);
    }
        initCountAmt();
</script>
<%@include file="/WEB-INF/page/include/handleFile.jsp"%>
</html>