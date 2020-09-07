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
    <title>pc-销售配送单</title>
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

        ::selection {
            background: yellow;
            color: #555;
        }

        ::-moz-selection {
            background: yellow;
            color: #555;
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
                <c:if test="${delivery.status eq -2 }">
                    <c:if test="${permission:checkUserFieldPdm('stk.stkOut.dragsave')}">
                        <div class="item" id="btndraft">
                            <a href="javascript:draftSaveStk();">
                                <img src="<%=basePath %>/resource/stkstyle/img/nicon1.png"/>
                                <img src="<%=basePath %>/resource/stkstyle/img/nicon1a.png"/>
                                <p>暂存</p>
                            </a>
                        </div>
                    </c:if>

                    <c:if test="${permission:checkUserFieldPdm('stk.stkOut.saveaudit') }">
                        <div class="item" id="btnsave" style="display:${(delivery.status eq -2 and delivery.id eq 0)?'':'none'}">
                            <a href="javascript:draftSaveStkAndSend();">
                                <img src="<%=basePath %>/resource/stkstyle/img/nicon1.png"/>
                                <img src="<%=basePath %>/resource/stkstyle/img/nicon1a.png"/>
                                <p>暂存并发送司机</p>
                            </a>
                        </div>
                    </c:if>


                    <div class="item" id="btnsendCar" style="display: ${(delivery.id ne 0 and delivery.psState ne 3 and delivery.psState ne 4  and delivery.psState ne 5 )?'':'none'}">
                        <a href="javascript:sendCar();">
                            <img src="<%=basePath %>/resource/stkstyle/img/nicon2.png"/>
                            <img src="<%=basePath %>/resource/stkstyle/img/nicon2a.png"/>
                            <p>装车发货</p>
                        </a>
                    </div>

                    <c:if test="${permission:checkUserFieldPdm('stk.stkOut.audit') }">
                        <div class="item" id="btndraftaudit" style="display: ${(delivery.id ne 0 and delivery.status eq -2)?'':'none'}">
                            <a href="javascript:audit();">
                                <img src="<%=basePath %>/resource/stkstyle/img/nicon2.png"/>
                                <img src="<%=basePath %>/resource/stkstyle/img/nicon2a.png"/>
                                <p>配送完成</p>
                            </a>
                        </div>
                    </c:if>
                </c:if>
                <%--
                <c:if test="${permission:checkUserFieldPdm('stk.stkOut.saveaudit') }">
                    <div class="item" id="btnsave" style="display:${(delivery.status eq -2 and delivery.id eq 0)?'':'none'}">
                        <a href="javascript:submitStk();">
                            <img src="<%=basePath %>/resource/stkstyle/img/nicon1.png"/>
                            <img src="<%=basePath %>/resource/stkstyle/img/nicon1a.png"/>
                            <p>保存并发货</p>
                        </a>
                    </div>
                </c:if>
                --%>



                <c:if test="${permission:checkUserFieldPdm('stk.stkOut.print') }">
                    <div class="item" id="btnprint" style="display: ${delivery.id eq 0?'none':''}">
                        <a href="javascript:printClick();">
                            <img src="<%=basePath %>/resource/stkstyle/img/nicon3.png"/>
                            <img src="<%=basePath %>/resource/stkstyle/img/nicon3a.png"/>
                            <p>打印</p>
                        </a>
                    </div>
                </c:if>

                <c:if test="${permission:checkUserFieldPdm('stk.stkOut.cancel') }">
                    <div class="item" id="btncancel" style="display: ${(delivery.id eq 0 or delivery.status eq 2)?'none':''}">
                        <a href="javascript:cancel();">
                            <img src="<%=basePath %>/resource/stkstyle/img/nicon5.png"/>
                            <img src="<%=basePath %>/resource/stkstyle/img/nicon5a.png"/>
                            <p>作废</p>
                        </a>
                    </div>
                </c:if>

                <div class="pcl_right_edi" style="width: 400px;">
                    <div class="pcl_right_edi_w">
                        <div>
                            <input type="text" id="billNo" name="billNo"   style="color:green;width:160px;font-size: 14px" readonly="readonly" value="${delivery.billNo}"/>
                            <c:choose>
                                <c:when test="${delivery.status eq -2}"><input type="text" id="billstatus"  value="暂存"   style="color:red;width:60px" readonly="readonly"/></c:when>
                                <c:when test="${delivery.status eq 0}"><input type="text" id="billstatus"  value="已审批"   style="color:red;width:60px" readonly="readonly"/></c:when>
                                <c:when test="${delivery.status eq 1}"><input type="text" id="billstatus"  value="已发货"   style="color:red;width:60px" readonly="readonly"/></c:when>
                                <c:when test="${delivery.status eq 2}"><input type="text" id="billstatus"  value="已作废"   style="color:red;width:60px" readonly="readonly"/></c:when>
                                <c:otherwise>
                                    <input type="text" id="billstatus"  value="暂存"   style="color:red;width:70px" readonly="readonly"/>
                                </c:otherwise>
                            </c:choose>
                            <input type="text" id="billstatus"  style="color:red;width:60px" readonly="readonly"/>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <form action="<%=basePath %>/manager/stkDelivery/draftSave" name="savefrm" id="savefrm" method="post">
    <input type="hidden" name="outId" id="outId" value="${delivery.outId}"/>
    <input name="orderNo" type="hidden" readonly="readonly" id="orderNo" value="${delivery.orderNo}"/>
    <input type="hidden" name="id" id="id" value="${delivery.id}"/>
    <input type="hidden" name="outType" id="outType" value="${delivery.outType}"/>
    <input type="hidden" name="orderId" id="orderId" value="${delivery.orderId}"/>
    <input  type="hidden" name="stkId" id="stkId" value="${delivery.stkId}"/>
    <input type="hidden" name="status" id="status" value="${delivery.status}"/>
    <input type="hidden" name="empId" id="empId" value="${delivery.empId}"/>
    <input type="hidden" name="proType" id="proType" value="${delivery.proType}"/>
        <input type="hidden" name="psState" id="psState" value="${delivery.psState}"/>
    <input type="hidden" name="saleType" id="saleType" value="${delivery.saleType}"/>
    <div class="pcl_fm" id="mainDivId">
        <table>
            <tbody>
            <tr>
                <td width="80px" style="text-align: center;">发票单号：</td>
                <td id="pc_order11">
                    <div class="pcl_input_box pcl_w2">
                        <input type="text" readonly="readonly" name="outNo" id="outNo" value="${delivery.outNo}"/>
                    </div>
                </td>
                <td width="80px" style="text-align: center;">配送日期：</td>
                <td>
                    <div class="pcl_input_box pcl_w2">
                        <input name="text" name="outDate" id="outDate"
                               onClick="WdatePicker({skin:'whyGreen',dateFmt: 'yyyy-MM-dd HH:mm'});"
                               style="width: 100px;" value="${delivery.outDate}" readonly="readonly"/>
                    </div>
                </td>
                <td width="80px" style="text-align: center;">配送指定：</td>
                <td>
                    <table>
                        <tr>
                            <td width="80px">
                                <div class="pcl_input_box pcl_w2">
                                    <input name="pszd" type="text" readonly="readonly" id="pszd" value="${delivery.pszd}"/>
                                </div>

                            </td>
                            <td>
                                <div class="pcl_input_box pcl_w2" id="epCustomerDiv" style="width: 70px;display: none">
                                    <input type="hidden" id="epCustomerId" name="epCustomerId"
                                           value="${epCustomerId }"/>
                                    <input type="text" id="epCustomerName" name="epCustomerName" required="required"
                                           placeholder="单击选择客户" value="${delivery.epCustomerName }" readonly="readonly"/>
                                </div>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>

            <tr>
                <td style="text-align: center;">客户名称：</td>
                <td>
                    <div class="pcl_input_box pcl_w2">
                    <input name="cstId" type="hidden" id="cstId" value="${delivery.cstId}"/>
                    <input name="khNm" type="text" readonly="readonly" id="khNm" value="${delivery.khNm}"/>
                    </div>
                </td>
                <td style="text-align: center;">配送地址：</td>
                <td>
                    <div class="pcl_input_box pcl_w2"><input type="text" id="address" name="address" value="${delivery.address }"/></div>
                </td>
                <td style="text-align: center;">联系电话：</td>
                <td>
                    <div class="pcl_input_box pcl_w2"><input type="text" id="tel" name="tel" value="${delivery.tel}"/></div>
                </td>
            </tr>
            <tr>
                <td style="text-align: center;">出货仓库：</td>
                <td>
                    <div class="pcl_input_box pcl_w2">
                        <input name="stkName" type="text" readonly="readonly" id="stkName" value="${delivery.stkName}"/>
                    </div>

                </td>
                <td style="text-align: center;">业 务 员：</td>
                <td>
                    <div class="pcl_chose_peo">
                        <input name="mid" type="hidden" id="mid" value="${delivery.mid}"/>
                        <input name="staff" type="text" readonly="readonly" id="staff" value="${delivery.staff}"/>
                    </div>
                </td>
                <td style="text-align: center;">联系电话：</td>
                <td>
                    <div class="pcl_input_box pcl_w2"><input type="text" id="staffTel" value="${delivery.staffTel}"/></div>
                </td>
            </tr>
            <tr style="display: none">
                <td style="text-align: center;">
                    合计金额：
                </td>
                <td>
                    <div class="pcl_input_box pcl_w2"><input type="text" id="totalAmt" value="${delivery.totalAmt}"
                                                             readonly="readonly"/></div>
                </td>
                <td style="text-align: center;">
                    整单折扣：
                </td>
                <td>
                    <div class="pcl_input_box pcl_w2"><input type="text" id="discount" value="${delivery.discount}" readonly="readonly"
                                                             onchange="countAmt()"/></div>
                </td>
                <td style="text-align: center;">
                    发票金额：
                </td>
                <td>
                    <div class="pcl_input_box pcl_w2"><input type="text" id="disAmt" name="disAmt" value="${delivery.disAmt}" readonly="readonly"
                                                             readonly="readonly"/></div>
                </td>
            </tr>
            <tr>
                <td style="text-align: center;">车&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;辆：</td>
                <td>
                    <div class="selbox">
                        <span id="vehNospan">${delivery.vehNo}</span>
                        <tag:select name="vehId" id="vehId" tclass="pcl_sel" value="${delivery.vehId }" headerKey=""
                                    headerValue="" tableName="stk_vehicle" displayKey="id" displayValue="veh_no"/>
                    </div>
                </td>
                <td style="text-align: center;">司&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;机：</td>
                <td>
                    <div class="selbox">
                        <span id="driverNamespan">${delivery.driverName}</span>
                        <tag:select name="driverId" id="driverId" tclass="pcl_sel" value="${delivery.driverId }" headerKey=""
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
                        <textarea name="remarks" id="remarks">${delivery.remarks}</textarea>
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
                    <td >产品编号</td>
                    <td>产品名称</td>
                    <td>产品规格</td>
                    <td>销售类型</td>
                    <td>单位</td>
                    <td
                        style="display: ${permission:checkUserFieldDisplay('stk.stkOut.lookqty')}">销售数量
                    </td>
                    <td style="display: ${permission:checkUserFieldDisplay('stk.stkOut.lookprice')}">单价
                    </td>
                    <td  style="display: ${permission:checkUserFieldDisplay('stk.stkOut.lookamt')}">销售金额
                    </td>
                    <td>已配送</td>
                    <td>本次配送</td>
                    <td>生产日期</td>
                    <td>有效期</td>
                    <td>备注</td>
                    <td></td>
                </tr>
                </thead>
                <tbody id="chooselist">
                <c:forEach items="${warelist}" var="item" varStatus="s">
                    <tr >
                        <td class="index">${s.index+1 }</td>
                        <td  style="padding-left: 20px;text-align: left;">
                            <input type="hidden" name="list[${s.index}].outSubId" value="${item.outSubId}"/>
                            <input type="hidden" name="list[${s.index}].rebatePrice" value="${item.rebatePrice}"/>
                            <input type="hidden" name="list[${s.index}].wareId" value="${item.wareId}"/>
                            <input type="text" name="list[${s.index}].wareCode" class="pcl_i2" value="${item.wareCode}" readonly="true"
                                   style="width: 130px" id="wareCode${s.index}"/>
                        </td>
                        <td >
                            <input type="text" class="pcl_i2" value="${item.wareNm}" readonly="true"
                                   style="width: 130px" id="wareNm${s.index}" name="list[${s.index}].wareNm"/>
                        </td>
                        <td ><input type="text" class="pcl_i2" value="${item.wareGg}"
                                                                              style="width: 80px;" readonly="true"
                                                                              id="wareGg${s.index}" name="list[${s.index}].wareGg"/></td>
                        <td ><input type="text" class="pcl_i2" readonly="readonly" name="list[${s.index}].xsTp" value="${item.xsTp}"/>
                        </td>
                        <td >
                            <input type="hidden" class="pcl_i2" readonly="readonly" name="list[${s.index}].beUnit" value="${item.beUnit}"/>
                            <input  class="pcl_i2" readonly="readonly" name="list[${s.index}].unitName" value="${item.unitName}"/>
                        </td>
                        <td style="display: ${permission:checkUserFieldDisplay('stk.stkOut.lookqty')}">
                            <input type="text" class="pcl_i2" readonly="readonly" name="list[${s.index}].qty" value="${item.qty}"/>
                        </td>
                        <td style="display: ${permission:checkUserFieldDisplay('stk.stkOut.lookprice')}">
                            <input type="text" class="pcl_i2" readonly="readonly" name="list[${s.index}].price" value="${item.price}"/>
                        </td>
                        <td style="display: ${permission:checkUserFieldDisplay('stk.stkOut.lookamt')}">
                            <input type="text" class="pcl_i2" readonly="readonly" name="list[${s.index}].amt" value="${item.amt}"/>
                        </td>
                        <td style="display: ${permission:checkUserFieldDisplay('stk.stkOut.lookqty')}">
                            <input type="text" class="pcl_i2" readonly="readonly" name="list[${s.index}].outQty1" value="${item.outQty1}"/>
                        </td>
                        <td style="display: ${permission:checkUserFieldDisplay('stk.stkOut.lookqty')}">
                            <input type="text" class="pcl_i2" name="list[${s.index}].outQty" onchange="changeData()" value="${item.outQty}"/>
                        </td>
                        <td >
                            <input type="text" class="pcl_i2" readonly="readonly" name="list[${s.index}].productDate" value="${item.productDate}"/>
                        </td>
                        <td>
                            <input type="text" class="pcl_i2" readonly="readonly" name="list[${s.index}].activeDate" value="${item.activeDate}"/>
                        </td>
                        <td >
                            <input type="text" class="pcl_i2" readonly="readonly" name="list[${s.index}].remarks" value="${item.remarks}"/>
                        </td>
                        <td style="display:none">
                            <input type="hidden"  name="list[${s.index}].hsNum" value="${item.hsNum}"/>
                        </td>
                        <td><a href="javascript:;;" onclick="deleteChoose(this);" class="pcl_del">删除</a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
                <tfoot>
            </table>
        </div>
    </div>
    </form>
</div>
</body>
<script src="<%=basePath %>/resource/stkstyle/js/lCalendar.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript">
   var isModify=false;

    $("#vehId").change(function () {
        var index = this.selectedIndex;
        var this_val = this.options[index].text;
        $(this).siblings('span').text(this_val);
        isModify=true;
    });

    $("#driverId").change(function () {
        var index = this.selectedIndex;
        var this_val = this.options[index].text;
        $(this).siblings('span').text(this_val);
        isModify=true;
    });


    function submitStk(){//暂时不用
        document.getElementById("savefrm").action="<%=basePath %>/manager/stkDelivery/addAudit";
        if(!confirm('是否确定保存并发货？'))return;
        $("#savefrm").form('submit',{
            success:function(data){
                var json = eval("("+data+")");
                if(json.state){
                    $("#id").val(json.id);
                    $("#status").val(0);
                    $("#billNo").val(json.billNo);
                    $("#billstatus").val("提交成功");
                    $("#btndraft").hide();
                    $("#btndraftaudit").hide();
                    $("#btnsave").hide();
                    $("#btnprint").show();
                    $("#btncancel").show();
                    $("#btnaudit").show();
                    $("#btndraftpost").hide();
                    isModify=false;
                }else{
                    alert(json.msg);
                }
            }
        });
    }

    function draftSaveStkAndSend(){
        document.getElementById("savefrm").action="<%=basePath %>/manager/stkDelivery/draftSave";
        var status = $("#status").val();
        if(status==0){
            $.messager.alert('消息','该单据已审批,不能暂存!','info');
            return;
        }

        var vehId = $("#vehId").val();
        if(vehId==""){
            $.messager.alert('消息','请选择配送车辆！','info');
            return;
        }
        var driverId = $("#driverId").val();
        if(driverId==""){
            $.messager.alert('消息','请选择司机！','info');
            return;
        }

        var trList = $("#chooselist").children("tr");
        if(trList.length==0){
            alert("没有可配送的商品！");
            return;
        }

        $("#psState").val(1);
        if(!confirm('是否确定暂存并发送司机？'))return;
        $("#savefrm").form('submit',{
            success:function(data){
                var json = eval("("+data+")");
                if(json.state){
                    $("#id").val(json.id);
                    $("#billNo").val(json.billNo);
                    $("#btnsave").hide();
                    $("#btndraftaudit").show();
                    $("#btnprint").show();
                    $("#btncancel").show();
                    $("#btnaudit").hide();
                    $("#btndraftpost").show();
                    $("#billstatus").val("暂存成功");
                    isModify=false;
                }else{
                    alert(json.msg);
                }
            }
        });
    }

    function draftSaveStk(){
        document.getElementById("savefrm").action="<%=basePath %>/manager/stkDelivery/draftSave";

        var status = $("#status").val();
        if(status==0){
            $.messager.alert('消息','该单据已审批,不能暂存!','info');
            return;
        }
        var vehId = $("#vehId").val();
        if(vehId==""){
            $.messager.alert('消息','请选择配送车辆！','info');
            return;
        }
        var driverId = $("#driverId").val();
        if(driverId==""){
            $.messager.alert('消息','请选择司机！','info');
            return;
        }
        var trList = $("#chooselist").children("tr");
        if(trList.length==0){
            alert("没有可配送的商品！");
            return;
        }
        //$.ajaxSettings.async = false;
        if(!confirm('是否确定暂存？'))return;
        $("#savefrm").form('submit',{
            success:function(data){
                var json = eval("("+data+")");
                if(json.state){
                    $("#id").val(json.id);
                    $("#billNo").val(json.billNo);
                    $("#btnsave").hide();
                    $("#btndraftaudit").show();
                    $("#btnprint").show();
                    $("#btncancel").show();
                    $("#btnaudit").hide();
                    $("#btndraftpost").show();
                    $("#billstatus").val("暂存成功");
                    isModify = false;
                }else{
                    alert(json.msg);
                }
            }
        });
    }

    function printClick()
    {
        var billId  = $("#id").val();

        if(billId == 0)
        {
            $.messager.alert('消息','没有可打印的单据','info');
            return ;
        }
        window.location.href='<%=basePath %>/manager/stkDelivery/print?fromFlag=0&billId=' + billId;
    }

    function audit()
    {
        var billId = $("#id").val();
        var status = $("#status").val();
        if(status==1){
            $.messager.alert('消息','该单据配送完成!','info');
            return;
        }
        if(billId == 0||status!=-2)
        {
            $.messager.alert('消息','没有可配送完成的单据','info');
            return;
        }
        if(isModify){
            $.messager.alert('消息','单据已修改，请先暂存','info');
            return;
        }
        var stkId = $("#stkId").val();
        auditBill(billId);
    }
    function auditBill(billId){

        if(!confirm('是否确定配送完成？'))return;

        var path = "<%=basePath %>/manager/stkDelivery/audit";
        $.ajax({
            url: path,
            type: "POST",
            data : {"token":"","billId":billId},
            dataType: 'json',
            async : false,
            success: function (json) {
                if(json.state){
                    $("#billstatus").val("配送完成成功！");
                    $("#status").val(1);
                    $("#btndraft").hide();
                    $("#btndraftaudit").hide();
                    $("#btnsave").hide();
                    $("#btnprint").show();
                    $("#btncancel").show();
                    $("#btnaudit").show();
                }
                else
                {
                    $.messager.alert('消息',"操作失败,"+json.msg,'info');
                }
            }
        });
    }

    function cancel()
    {
        var billId = $("#id").val();
        var status = $("#status").val();
        if(status==2){
            $.messager.alert('消息','该单据已作废!','info');
            return;
        }

        if(isModify){
            $.messager.alert('消息','单据已修改，请先暂存','info');
            return;
        }

        if(!confirm('是否确定作废？'))return;

        var path = "<%=basePath %>/manager/stkDelivery/cancel";
        $.ajax({
            url: path,
            type: "POST",
            data : {"token":"","billId":billId},
            dataType: 'json',
            async : false,
            success: function (json) {
                if(json.state){
                    $("#billstatus").val("作废成功！");
                    $("#status").val(2);
                    $("#btndraft").hide();
                    $("#btndraftaudit").hide();
                    $("#btnsave").hide();
                    $("#btnprint").show();
                    $("#btncancel").show();
                    $("#btnaudit").show();
                }
                else
                {
                    $.messager.alert('消息',json.msg,'info');
                }
            }
        });
    }

    function sendCar(){
            // <option value="">全部</option>
            // <option value="0">待分配</option>
            // <option value="1">待接收</option>
            // <option value="2">已接收</option>
            // <option value="3">配送中</option>
            // <option value="4">已送达</option>
            // <option value="5">配送终止</option>

        var billId = $("#id").val();

        $.messager.confirm('确认', '是否确定该操作?', function (r) {
            if (r) {
                var path = "<%=basePath %>/manager/stkDelivery/sendCar";
                $.ajax({
                    url: path,
                    type: "POST",
                    data: {"ids": billId,"psState":3},
                    dataType: 'json',
                    async: false,
                    success: function (json) {
                        if (json.state) {
                           alert(json.msg);
                           $("#btnsendCar").hide();
                        } else {
                            $.messager.alert('消息', '操作失败', 'info');
                        }
                    }
                });
            }
        });
    }

    function deleteChoose(lineObj)
    {
        if(confirm('确定删除？')){
            $(lineObj).parents('tr').remove();
            resetTabIndex();
        }
    }

    function resetTabIndex(){
        var trList = $("#chooselist").children("tr");
        if(index<0){
            return;
        }
        for(var i=0;i<trList.length;i++){
            var tdArr = trList.eq(i);
            $(tdArr).find("input[name$='id']").attr("name","subList["+i+"].id");
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
            $(tdArr).find("input[name$='outQty']").attr("name","subList["+i+"].outQty");
            $(tdArr).find("input[name$='outQty1']").attr("name","subList["+i+"].outQty1");
            $(tdArr).find("input[name$='outAmt']").attr("name","subList["+i+"].outAmt");
            $(tdArr).find("input[name$='productDate']").attr("name","subList["+i+"].productDate");
            $(tdArr).find("input[name$='activeDate']").attr("name","subList["+i+"].activeDate");
            $(tdArr).find("input[name$='remarks']").attr("name","subList["+i+"].remarks");
            $(tdArr).find("input[name$='xsTp']").attr("name","subList["+i+"].xsTp");
        }
    }
    function changeData(){
        isModify=true;
    }
</script>
<%@include file="/WEB-INF/page/include/handleFile.jsp"%>
</html>