<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>企微宝</title>

    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">
    <%@include file="/WEB-INF/page/include/source.jsp" %>
    <script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
    <script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
</head>

<body class="easyui-layout" onload="initGrid()">
<div data-options="region:'west',split:true,title:'商品分类树'"
     style="width:150px;padding-top: 5px;">
    <ul id="waretypetree" class="easyui-tree"
        data-options="url:'manager/waretypes',animate:true,dnd:true,onClick: function(node){
					toShowWare(node.id);
				},onDblClick:function(node){
					$(this).tree('toggle', node.target);
				}">
    </ul>
</div>
<div id="wareTypeDiv" data-options="region:'center'">
    <table id="datagrid" fit="true" singleSelect="true"
           url="" title="" iconCls="icon-save" border="false"
           rownumbers="true" fitColumns="false" pagination="true"
           pageSize=50 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb"
           data-options="onClickCell: onClickCell,onDblClickRow: onDblClickRow,onLoadSuccess:onLoadSuccess">

    </table>
    <div id="tb" style="padding:5px;height:auto">
        年月: <input type="text" name="yymm" id="yymm" style="width:120px;height: 20px;"
                   onkeydown="toQuery(event);" value="${yymm}"/>
        商品名称: <input type="text" name="wareNm" id="wareNm" style="width:120px;height: 20px;"
                     onkeydown="toQuery(event);"/>

        仓库: <select name="wareStk" id="stkId">
        <option value="0">全部</option>

    </select>

        <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryClick();">查询</a>
        <!--<a class="easyui-linkbutton" iconCls="icon-add" href="javascript:chooseWare();">选择商品</a>-->
        <!--  <a class="easyui-linkbutton" iconCls="icon-print" href="javascript:myexport();">导出</a>-->
        <a class="easyui-linkbutton" iconCls="icon-save" href="javascript:showDlg();">设置显示字段</a>
        <%-- <a class="easyui-linkbutton" iconCls="icon-redo" plain="true" href="javascript:toLoadExcel();">导出</a>--%>


        <input type="hidden" id="waretype" value="0"/>
    </div>
</div>
<div>
    <form action="manager/orderExcel" name="loadfrm" id="loadfrm" method="post">
        <input type="text" name="orderNo2" id="orderNo2"/>
        <input type="text" name="khNm2" id="khNm2"/>
        <input type="text" name="memberNm2" id="memberNm2"/>
        <input type="text" name="sdate2" id="sdate2"/>
        <input type="text" name="edate2" id="edate2"/>
        <input type="text" name="orderZt2" id="orderZt2"/>
        <input type="text" name="pszd2" id="pszd2"/>
    </form>
</div>
<div id="dlg" closed="true" class="easyui-dialog" toolbar="#dlg-toolbar" title="请选择显示字段"
     style="width:400px;height:400px;padding:10px"
     data-options="

				iconCls: 'icon-save',

				buttons: [{
					text:'确定',
					iconCls:'icon-ok',
					handler:function(){
						saveFieldSet();
					}
				},{
					text:'取消',
					handler:function(){
						$('#dlg').dialog('close');
					}
				}]
			">

    <dd>
    </dd>
    <table id="datagrid1" class="easyui-datagrid" fit="true" singleSelect="false"
           url="manager/stkSummaryField" border="false"
           rownumbers="true" fitColumns="true" pagination="false" data-options="onLoadSuccess:onLoadSuccess1"
    >
        <thead>
        <tr>
            <th field="ck" checkbox="true" width="50"></th>


            <th field="title" width="100" align="center">
                字段名
            </th>

        </tr>
        </thead>
    </table>

    <input type="hidden" id="showfields" value="${fieldsStr}"/>
    <input type="hidden" id="showAmt" value="${showAmt}"/>
    <input type="hidden" id="isExpand" value="${isExpand}"/>


</div>
<div id="dlg-toolbar">
    <table cellpadding="0" cellspacing="0" style="width:100%">
        <tr>
            <td height="30px">

                显示金额否：<input type="checkbox" id="chkshowamt" onchange="chooseIsShowAmt(this)"/>

            </td>
            <td>
                展开/收起：<input type="checkbox" id="chkisExpand"/>
            </td>

        </tr>

    </table>
</div>
<%@include file="/WEB-INF/page/export/export.jsp" %>
<script type="text/javascript">
    var database = "${database}";
    queryBasestorage();

    function checkIsShow(fieldName) {
        var str = $("#showfields").val();
        var fields = str.split(",");
        for (var i = 0; i < fields.length; i++) {
            if (fields[i] == fieldName) return false;
        }
        return true;
    }

    var cols = new Array();

    function initGrid() {
        var showAmt = true;
        if ($("#showAmt").val() == "1") {
            $("#chkshowamt").attr("checked", "checked");
            showAmt = false;
        }
        if ($("#isExpand").val() == "1") $("#chkisExpand").attr("checked", "checked");

        var col = {
            field: 'stkId',
            title: 'stkId',
            width: 100,
            align: 'center',
            hidden: true
        };
        cols.push(col);

        var col = {
            field: 'wareId',
            title: 'wareId',
            width: 100,
            align: 'center',
            hidden: true


        };
        cols.push(col);

        var col = {
            field: 'wareNm',
            title: '商品名称',
            width: 150,
            align: 'center'


        };
        cols.push(col);

        var col = {
            field: 'unitName',
            title: '单位',
            width: 50,
            align: 'center'


        };
        cols.push(col);

        var showDisplay = '${permission:checkUserFieldDisplay("stk.wareSfcStat.showamt")}';
        var showHidden = false;
        if (showDisplay == 'none') {
            showHidden = true;
        }
        var isExpand = false;
        if ($("#isExpand").val() == "0") isExpand = true;

        var col = {
            field: 'initQty',
            title: '期初数量',
            width: 80,
            align: 'center',
            formatter: amtformatter
        };
        cols.push(col);

        var col = {
            field: '_bqQty',
            title: '本期入库',
            width: 80,
            align: 'center',
            formatter: amtformatterBqrk
        };
        cols.push(col);

        var col = {
            field: 'initAmt',
            title: '期初金额',
            width: 100,
            align: 'center',
            formatter: amtformatter,
            hidden: checkIsShow('期初金额')

        };
        cols.push(col);


        var col = {
            field: 'avgPrice',
            title: '平均价格',
            width: 100,
            align: 'center',
            formatter: amtformatter,
            hidden: checkIsShow('期初平均价格')


        };
        cols.push(col);
        //$("#chkshowamt").attr("checked","checked");
        //alert(11);

        var col = {
            field: 'initInQty',
            title: '初始化入库',
            width: 80,
            align: 'center',
            hidden: checkIsShow('初始化入库') || isExpand,
            formatter: function (v, row, index) {
                if (v == "") {
                    v = "0.00";
                }
                if (v == "0E-7") {
                    v = "0.00";
                }
                if (row != null) {
                    v = numeral(v).format("0,0.00");
                }
                return '<u style="color:blue;cursor:pointer">' + v + '</u>';
            }


        };
        cols.push(col);


        var col = {
            field: 'initInAmt',
            title: '初始化入库金额',
            width: 100,
            align: 'center',
            formatter: amtformatter,
            hidden: checkIsShow('初始化入库金额') || isExpand
        };
        cols.push(col);


        var col = {
            field: 'inQty',
            title: '采购入库',
            width: 80,
            align: 'center',
            hidden: checkIsShow('采购入库'),
            formatter: function (v, row, index) {
                if (v == "") {
                    v = "0.00";
                }
                if (v == "0E-7") {
                    v = "0.00";
                }
                if (row != null) {
                    v = numeral(v).format("0,0.00");
                }
                return '<u style="color:blue;cursor:pointer">' + v + '</u>';
            }


        };
        cols.push(col);


        var col = {
            field: 'inAmt',
            title: '采购金额',
            width: 100,
            align: 'center',
            formatter: amtformatter,
            hidden: checkIsShow('采购金额')
        };
        cols.push(col);

        var col = {
            field: 'otherTypeInQty',
            title: '其它类型入库',
            width: 80,
            align: 'center',
            hidden: checkIsShow('其它类型入库') || !isExpand,
            formatter: function (v, row, index) {
                if (v == "") {
                    v = "0.00";
                }
                if (v == "0E-7") {
                    v = "0.00";
                }
                if (row != null) {
                    v = numeral(v).format("0,0.00");
                }
                return '<u style="color:blue;cursor:pointer">' + v + '</u>';
            }


        };
        cols.push(col);


        var col = {
            field: 'otherTypeInAmt',
            title: '其它类型入库金额',
            width: 100,
            align: 'center',
            formatter: amtformatter,
            hidden: (!isExpand) || showAmt
        };
        cols.push(col);


        var col = {
            field: 'inQty1',
            title: '其它入库',
            width: 80,
            align: 'center',
            hidden: checkIsShow('其它入库') || isExpand,
            formatter: function (v, row, index) {
                if (v == "") {
                    v = "0.00";
                }
                if (v == "0E-7") {
                    v = "0.00";
                }
                if (row != null) {
                    v = numeral(v).format("0,0.00");
                }
                return '<u style="color:blue;cursor:pointer">' + v + '</u>';
            }
        };
        cols.push(col);

        var col = {
            field: 'inAmt1',
            title: '其它入库金额',
            width: 100,
            align: 'center',
            formatter: amtformatter,
            hidden: checkIsShow('其它入库金额') || isExpand


        };
        cols.push(col);


        var col = {
            field: 'rtnQty',
            title: '销售退货',
            width: 80,
            align: 'center',
            hidden: checkIsShow('销售退货') || isExpand,
            formatter: function (v, row, index) {
                if (v == "") {
                    v = "0.00";
                }
                if (v == "0E-7") {
                    v = "0.00";
                }
                if (row != null) {
                    v = numeral(v).format("0,0.00");
                }
                return '<u style="color:blue;cursor:pointer">' + v + '</u>';
            }


        };
        cols.push(col);


        var col = {
            field: 'rtnAmt',
            title: '退货金额',
            width: 100,
            align: 'center',
            formatter: amtformatter,
            hidden: checkIsShow('退货金额') || isExpand
        };
        cols.push(col);

        var col = {
            field: 'transInQty',
            title: '移入数量',
            width: 80,
            align: 'center',
            hidden: checkIsShow('移入数量') || isExpand,
            formatter: function (v, row, index) {
                if (v == "") {
                    v = "0.00";
                }
                if (v == "0E-7") {
                    v = "0.00";
                }
                if (row != null) {
                    v = numeral(v).format("0,0.00");
                }
                return '<u style="color:blue;cursor:pointer">' + v + '</u>';
            }


        };
        cols.push(col);


        var col = {
            field: 'transInAmt',
            title: '移入金额',
            width: 100,
            align: 'center',
            formatter: amtformatter,
            hidden: checkIsShow('移入金额') || isExpand
        };
        cols.push(col);

        var col = {
            field: 'zzInQty',
            title: '组装数量',
            width: 80,
            align: 'center',
            hidden: checkIsShow('组装数量') || isExpand,
            formatter: function (v, row, index) {
                if (v == "") {
                    v = "0.00";
                }
                if (v == "0E-7") {
                    v = "0.00";
                }
                if (row != null) {
                    v = numeral(v).format("0,0.00");
                }
                return '<u style="color:blue;cursor:pointer">' + v + '</u>';
            }


        };
        cols.push(col);


        var col = {
            field: 'zzInAmt',
            title: '组装金额',
            width: 100,
            align: 'center',
            formatter: amtformatter,
            hidden: checkIsShow('组装金额') || isExpand
        };
        cols.push(col);


        var col = {
            field: 'cxInQty',
            title: '拆卸入库数量',
            width: 80,
            align: 'center',
            hidden: checkIsShow('拆卸入库数量') || isExpand,
            formatter: function (v, row, index) {
                if (v == "") {
                    v = "0.00";
                }
                if (v == "0E-7") {
                    v = "0.00";
                }
                if (row != null) {
                    v = numeral(v).format("0,0.00");
                }
                return '<u style="color:blue;cursor:pointer">' + v + '</u>';
            }


        };
        cols.push(col);


        var col = {
            field: 'cxInAmt',
            title: '拆卸入库金额',
            width: 100,
            align: 'center',
            formatter: amtformatter,
            hidden: checkIsShow('拆卸入库金额') || isExpand
        };
        cols.push(col);


        var col = {
            field: 'scQty',
            title: '生产数量',
            width: 80,
            align: 'center',
            hidden: checkIsShow('生产数量') || isExpand,
            formatter: function (v, row, index) {
                if (v == "") {
                    v = "0.00";
                }
                if (v == "0E-7") {
                    v = "0.00";
                }
                if (row != null) {
                    v = numeral(v).format("0,0.00");
                }
                return '<u style="color:blue;cursor:pointer">' + v + '</u>';
            }


        };
        cols.push(col);


        var col = {
            field: 'scAmt',
            title: '生产金额',
            width: 100,
            align: 'center',
            formatter: amtformatter,
            hidden: checkIsShow('生产金额') || isExpand
        };
        cols.push(col);

        var col = {
            field: 'hkQty',
            title: '领料回库数量',
            width: 80,
            align: 'center',
            hidden: checkIsShow('领料回库数量') || isExpand,
            formatter: function (v, row, index) {
                if (v == "") {
                    v = "0.00";
                }
                if (v == "0E-7") {
                    v = "0.00";
                }
                if (row != null) {
                    v = numeral(v).format("0,0.00");
                }
                return '<u style="color:blue;cursor:pointer">' + v + '</u>';
            }


        };
        cols.push(col);


        var col = {
            field: 'hkAmt',
            title: '领料回库金额',
            width: 100,
            align: 'center',
            formatter: amtformatter,
            hidden: checkIsShow('领料回库金额') || isExpand
        };
        cols.push(col);

        var col = {
            field: 'checkInQty',
            title: '盘盈数量',
            width: 80,
            align: 'center',
            hidden: checkIsShow('盘盈数量') || isExpand,
            formatter: function (v, row, index) {
                if (v == "") {
                    v = "0.00";
                }
                if (v == "0E-7") {
                    v = "0.00";
                }
                if (row != null) {
                    v = numeral(v).format("0,0.00");
                }
                return '<u style="color:blue;cursor:pointer">' + v + '</u>';
            }


        };
        cols.push(col);


        var col = {
            field: 'checkInAmt',
            title: '盘盈金额',
            width: 100,
            align: 'center',
            formatter: amtformatter,
            hidden: checkIsShow('盘盈金额') || isExpand
        };
        cols.push(col);


        var col = {
            field: 'outQty11',
            title: '正常销售',
            width: 80,
            align: 'center',
            hidden: checkIsShow('正常销售'),
            formatter: function (v, row, index) {
                if (v == "") {
                    v = "0.00";
                }
                if (v == "0E-7") {
                    v = "0.00";
                }
                if (row != null) {
                    v = numeral(v).format("0,0.00");
                }

                return '<u style="color:blue;cursor:pointer">' + v + '</u>';
            }


        };
        cols.push(col);

        var col = {
            field: 'outAmt11',
            title: '销售成本',
            width: 100,
            align: 'center',
            formatter: amtformatter,
            hidden: checkIsShow('销售成本')
        };
        cols.push(col);


        var col = {
            field: 'otherTypeOutQty',
            title: '其它类型出库',
            width: 80,
            align: 'center',
            hidden: checkIsShow('其它类型出库') || !isExpand,
            formatter: function (v, row, index) {
                if (v == "") {
                    v = "0.00";
                }
                if (v == "0E-7") {
                    v = "0.00";
                }
                if (row != null) {
                    v = numeral(v).format("0,0.00");
                }
                return '<u style="color:blue;cursor:pointer">' + v + '</u>';
            }


        };
        cols.push(col);


        var col = {
            field: 'otherTypeOutAmt',
            title: '其它类型出库金额',
            width: 100,
            align: 'center',
            formatter: amtformatter,
            hidden: (!isExpand) || showAmt
        };
        cols.push(col);

        var col = {
            field: 'outQty12',
            title: '促销折让数量',
            width: 80,
            align: 'center',
            hidden: checkIsShow('促销折让数量') || isExpand,
            formatter: function (v, row, index) {
                if (v == "") {
                    v = "0.00";
                }
                if (v == "0E-7") {
                    v = "0.00";
                }
                if (row != null) {
                    v = numeral(v).format("0,0.00");
                }

                return '<u style="color:blue;cursor:pointer">' + v + '</u>';
            }


        };
        cols.push(col);

        var col = {
            field: 'outAmt12',
            title: '促销折让金额',
            width: 100,
            align: 'center',
            formatter: amtformatter,
            hidden: checkIsShow('促销折让金额') || isExpand


        };
        cols.push(col);


        var col = {
            field: 'outQty13',
            title: '消费折让数量',
            width: 80,
            align: 'center',
            hidden: checkIsShow('消费折让数量') || isExpand,
            formatter: function (v, row, index) {
                if (v == "") {
                    v = "0.00";
                }
                if (v == "0E-7") {
                    v = "0.00";
                }
                if (row != null) {
                    v = numeral(v).format("0,0.00");
                }

                return '<u style="color:blue;cursor:pointer">' + v + '</u>';
            }


        };
        cols.push(col);

        var col = {
            field: 'outAmt13',
            title: '消费折让金额',
            width: 100,
            align: 'center',
            formatter: amtformatter,
            hidden: checkIsShow('消费折让金额') || isExpand


        };
        cols.push(col);


        var col = {
            field: 'outQty14',
            title: '费用折让数量',
            width: 80,
            align: 'center',
            hidden: checkIsShow('费用折让数量') || isExpand,
            formatter: function (v, row, index) {
                if (v == "") {
                    v = "0.00";
                }
                if (v == "0E-7") {
                    v = "0.00";
                }
                if (row != null) {
                    v = numeral(v).format("0,0.00");
                }

                return '<u style="color:blue;cursor:pointer">' + v + '</u>';
            }


        };
        cols.push(col);

        var col = {
            field: 'outAmt14',
            title: '费用折让金额',
            width: 100,
            align: 'center',
            formatter: amtformatter,
            hidden: checkIsShow('费用折让金额') || isExpand


        };
        cols.push(col);

        var col = {
            field: 'outQty15',
            title: '其它销售数量',
            width: 80,
            align: 'center',
            hidden: checkIsShow('其它销售数量') || isExpand,
            formatter: function (v, row, index) {
                if (v == "") {
                    v = "0.00";
                }
                if (v == "0E-7") {
                    v = "0.00";
                }
                if (row != null) {
                    v = numeral(v).format("0,0.00");
                }

                return '<u style="color:blue;cursor:pointer">' + v + '</u>';
            }


        };
        cols.push(col);

        var col = {
            field: 'outAmt15',
            title: '其它销售金额',
            width: 100,
            align: 'center',
            formatter: amtformatter,
            hidden: checkIsShow('其它销售金额') || isExpand


        };
        cols.push(col);


        var col = {
            field: 'shopSaleQty',
            title: '终端零售数量',
            width: 80,
            align: 'center',
            hidden: checkIsShow('终端零售数量') || isExpand,
            formatter: function (v, row, index) {
                if (v == "") {
                    v = "0.00";
                }
                if (v == "0E-7") {
                    v = "0.00";
                }
                if (row != null) {
                    v = numeral(v).format("0,0.00");
                }

                return '<u style="color:blue;cursor:pointer">' + v + '</u>';
            }


        };
        cols.push(col);

        var col = {
            field: 'shopSaleAmt',
            title: '终端零售金额',
            width: 100,
            align: 'center',
            formatter: amtformatter,
            hidden: checkIsShow('终端零售金额') || isExpand


        };
        cols.push(col);


        var col = {
            field: 'otherOutQty',
            title: '其它出库数量',
            width: 80,
            align: 'center',
            hidden: checkIsShow('其它出库数量') || isExpand,
            formatter: function (v, row, index) {
                if (v == "") {
                    v = "0.00";
                }
                if (v == "0E-7") {
                    v = "0.00";
                }
                if (row != null) {
                    v = numeral(v).format("0,0.00");
                }

                return '<u style="color:blue;cursor:pointer">' + v + '</u>';
            }


        };
        cols.push(col);

        var col = {
            field: 'otherOutAmt',
            title: '其它出库金额',
            width: 100,
            align: 'center',
            formatter: amtformatter,
            hidden: checkIsShow('其它出库金额') || isExpand


        };
        cols.push(col);


        var col = {
            field: 'purRtnQty',
            title: '采购退货数量',
            width: 80,
            align: 'center',
            hidden: checkIsShow('采购退货数量') || isExpand,
            formatter: function (v, row, index) {
                if (v == "") {
                    v = "0.00";
                }
                if (v == "0E-7") {
                    v = "0.00";
                }
                if (row != null) {
                    v = numeral(v).format("0,0.00");
                }

                return '<u style="color:blue;cursor:pointer">' + v + '</u>';
            }


        };
        cols.push(col);

        var col = {
            field: 'purRtnAmt',
            title: '采购退货金额',
            width: 100,
            align: 'center',
            formatter: amtformatter,
            hidden: checkIsShow('采购退货金额') || isExpand


        };
        cols.push(col);


        var col = {
            field: 'transOutQty',
            title: '移出数量',
            width: 80,
            align: 'center',
            hidden: checkIsShow('移出数量') || isExpand,
            formatter: function (v, row, index) {
                if (v == "") {
                    v = "0.00";
                }
                if (v == "0E-7") {
                    v = "0.00";
                }
                if (row != null) {
                    v = numeral(v).format("0,0.00");
                }

                return '<u style="color:blue;cursor:pointer">' + v + '</u>';
            }


        };
        cols.push(col);

        var col = {
            field: 'transOutAmt',
            title: '移出金额',
            width: 100,
            align: 'center',
            formatter: amtformatter,
            hidden: checkIsShow('称出金额') || isExpand


        };
        cols.push(col);


        var col = {
            field: 'zzOutQty',
            title: '组装出库数量',
            width: 80,
            align: 'center',
            hidden: checkIsShow('组装出库数量') || isExpand,
            formatter: function (v, row, index) {
                if (v == "") {
                    v = "0.00";
                }
                if (v == "0E-7") {
                    v = "0.00";
                }
                if (row != null) {
                    v = numeral(v).format("0,0.00");
                }

                return '<u style="color:blue;cursor:pointer">' + v + '</u>';
            }


        };
        cols.push(col);

        var col = {
            field: 'zzOutAmt',
            title: '组装出库金额',
            width: 100,
            align: 'center',
            formatter: amtformatter,
            hidden: checkIsShow('组装出库金额') || isExpand


        };
        cols.push(col);


        var col = {
            field: 'cxOutQty',
            title: '拆卸出库数量',
            width: 80,
            align: 'center',
            hidden: checkIsShow('拆卸出库数量') || isExpand,
            formatter: function (v, row, index) {
                if (v == "") {
                    v = "0.00";
                }
                if (v == "0E-7") {
                    v = "0.00";
                }
                if (row != null) {
                    v = numeral(v).format("0,0.00");
                }

                return '<u style="color:blue;cursor:pointer">' + v + '</u>';
            }


        };
        cols.push(col);

        var col = {
            field: 'cxOutAmt',
            title: '拆卸出库金额',
            width: 100,
            align: 'center',
            formatter: amtformatter,
            hidden: checkIsShow('拆卸出库金额') || isExpand


        };
        cols.push(col);


        var col = {
            field: 'useQty',
            title: '领料数量',
            width: 80,
            align: 'center',
            hidden: checkIsShow('领料数量') || isExpand,
            formatter: function (v, row, index) {
                if (v == "") {
                    v = "0.00";
                }
                if (v == "0E-7") {
                    v = "0.00";
                }
                if (row != null) {
                    v = numeral(v).format("0,0.00");
                }

                return '<u style="color:blue;cursor:pointer">' + v + '</u>';
            }


        };
        cols.push(col);

        var col = {
            field: 'useAmt',
            title: '领料金额',
            width: 100,
            align: 'center',
            formatter: amtformatter,
            hidden: checkIsShow('领料金额') || isExpand


        };
        cols.push(col);


        var col = {
            field: 'lenOutQty',
            title: '领用数量',
            width: 80,
            align: 'center',
            hidden: checkIsShow('领用数量') || isExpand,
            formatter: function (v, row, index) {
                if (v == "") {
                    v = "0.00";
                }
                if (v == "0E-7") {
                    v = "0.00";
                }
                if (row != null) {
                    v = numeral(v).format("0,0.00");
                }

                return '<u style="color:blue;cursor:pointer">' + v + '</u>';
            }


        };
        cols.push(col);

        var col = {
            field: 'lenOutAmt',
            title: '领用金额',
            width: 100,
            align: 'center',
            formatter: amtformatter,
            hidden: checkIsShow('领用金额') || isExpand


        };
        cols.push(col);


        var col = {
            field: 'lossQty',
            title: '报损数量',
            width: 80,
            align: 'center',
            hidden: checkIsShow('报损数量') || isExpand,
            formatter: function (v, row, index) {
                if (v == "") {
                    v = "0.00";
                }
                if (v == "0E-7") {
                    v = "0.00";
                }
                if (row != null) {
                    v = numeral(v).format("0,0.00");
                }

                return '<u style="color:blue;cursor:pointer">' + v + '</u>';
            }


        };
        cols.push(col);

        var col = {
            field: 'lossAmt',
            title: '报损金额',
            width: 100,
            align: 'center',
            formatter: amtformatter,
            hidden: checkIsShow('报损金额') || isExpand


        };
        cols.push(col);


        var col = {
            field: 'lendQty',
            title: '借出数量',
            width: 80,
            align: 'center',
            hidden: checkIsShow('借出数量') || isExpand,
            formatter: function (v, row, index) {
                if (v == "") {
                    v = "0.00";
                }
                if (v == "0E-7") {
                    v = "0.00";
                }
                if (row != null) {
                    v = numeral(v).format("0,0.00");
                }

                return '<u style="color:blue;cursor:pointer">' + v + '</u>';
            }


        };
        cols.push(col);

        var col = {
            field: 'lendAmt',
            title: '借出金额',
            width: 100,
            align: 'center',
            formatter: amtformatter,
            hidden: checkIsShow('借出金额') || isExpand


        };
        cols.push(col);


        var col = {
            field: 'checkOutQty',
            title: '盘亏数量',
            width: 80,
            align: 'center',
            hidden: checkIsShow('盘亏数量') || isExpand,
            formatter: function (v, row, index) {
                if (v == "") {
                    v = "0.00";
                }
                if (v == "0E-7") {
                    v = "0.00";
                }
                if (row != null) {
                    v = numeral(v).format("0,0.00");
                }

                return '<u style="color:blue;cursor:pointer">' + v + '</u>';
            }


        };
        cols.push(col);

        var col = {
            field: 'checkOutAmt',
            title: '盘亏金额',
            width: 100,
            align: 'center',
            formatter: amtformatter,
            hidden: checkIsShow('盘亏金额') || isExpand


        };
        cols.push(col);
        var col = {
            field: '_bqck',
            title: '本期出库',
            width: 80,
            align: 'center',
            formatter: amtformatterBqck

        };
        cols.push(col);

        var col = {
            field: 'endQty',
            title: '期末数量',
            width: 80,
            align: 'center',
            formatter: amtformatter
        };
        cols.push(col);


        var col = {
            field: 'endAmt',
            title: '期末成本',
            width: 100,
            align: 'center',
            formatter: amtformatter,
            hidden: checkIsShow('期末成本')


        };
        cols.push(col);

        var col = {
            field: 'avgPrice1',
            title: '期末平均单价',
            width: 100,
            align: 'center',
            formatter: amtformatter,
            hidden: checkIsShow('期末平均单价')


        };
        cols.push(col);

        var wareNm = $("#wareNm").val();


        var stkId = $("#stkId").val();
        var waretype = $("#waretype").val();

        $('#datagrid').datagrid({
            url:"manager/stkmonth/queryMonthDetailPage",
            queryParams:{
                wareNm: wareNm,
                stkId: stkId,
                yymm: $("#yymm").val(),
                waretype: waretype

            },
            columns:[
                cols
            ]}
        );


    }

    function queryField() {
        $('#datagrid1').datagrid({
            url: "manager/stkSummaryField",
            queryParams: {
                colsStr: JSON.stringify(cols)

            }

        });
    }

    function showDlg() {
        queryField();
        $('#dlg').dialog('open');
    }

    //查询物流公司
    function toShowWare(waretype) {
        $("#waretype").val(waretype);
        querydata();
    }

    function queryClick() {
        $("#waretype").val(0);
        querydata();
    }

    function querydata() {
        var wareNm = $("#wareNm").val();


        var stkId = $("#stkId").val();
        var waretype = $("#waretype").val();

        $("#datagrid").datagrid('load', {
            url: "manager/stkmonth/queryMonthDetailPage?wareNm1=" + wareNm,
            wareNm: wareNm,
            stkId: stkId,
            yymm: $("#yymm").val(),
            waretype: waretype


        });
    }

    function queryBasestorage() {
        var path = "manager/queryBaseStorage";
        //var token = $("#tmptoken").val();


        $.ajax({
            url: path,
            type: "POST",
            data: {"token11": ""},
            dataType: 'json',
            async: false,
            success: function (json) {
                if (json.state) {

                    var size = json.list.length;
                    //gstklist = json.list;

                    var objSelect = document.getElementById("stkId");
                    //objSelect.options.add(new Option('合部','0'));

                    for (var i = 0; i < size; i++) {
                        objSelect.options.add(new Option(json.list[i].stkName, json.list[i].id));

                    }


                }
            }
        });
    }

    //回车查询
    function toQuery(e) {
        var key = window.event ? e.keyCode : e.which;
        if (key == 13) {
            querydata();
        }
    }

    //导出
    function myexport() {
        exportData('StkQueryService', 'queryStorageWarePage', 'com.cnlife.stk.model.StkStorageVo;', "{wareNm:'" + $("#wareNm").val() + "',stkId:'" + $("#stkId").val() + "',database:'" + database + "}", "库存记录");
    }

    function amtformatter(v, row) {
        if (v == "") {
            return "";
        }
        if (v == "0E-7") {
            return "0.00";
        }
        if (row != null) {
            return numeral(v).format("0,0.00");
        }
    }

    function amtformatterBqrk(v, row) {
        var initInQty = row.initInQty == "" ? 0 : row.initInQty;
        var inQty = row.inQty == "" ? 0 : row.inQty;
        var inQty1 = row.inQty1 == "" ? 0 : row.inQty1;
        var rtnQty = row.rtnQty == "" ? 0 : row.rtnQty;
        var transInQty = row.transInQty == "" ? 0 : row.transInQty;
        var zzInQty = row.zzInQty == "" ? 0 : row.zzInQty;
        var cxInQty = row.cxInQty == "" ? 0 : row.cxInQty;
        var scQty = row.scQty == "" ? 0 : row.scQty;
        var checkInQty = row.checkInQty == "" ? 0 : row.checkInQty;

        var totalQty = parseFloat(initInQty)
            + parseFloat(inQty)
            + parseFloat(inQty1)
            + parseFloat(rtnQty)
            + parseFloat(transInQty)
            + parseFloat(zzInQty)
            + parseFloat(cxInQty)
            + parseFloat(scQty)
            + parseFloat(checkInQty)
        ;

        return totalQty.toFixed(2);
    }

    function amtformatterBqck(v, row) {
        var outQty11 = row.outQty11 == "" ? 0 : row.outQty11;
        //var otherTypeOutQty = row.otherTypeOutQty==""?0:row.otherTypeOutQty;
        var outQty12 = row.outQty12 == "" ? 0 : row.outQty12;
        var outQty13 = row.outQty13 == "" ? 0 : row.outQty13;
        var outQty14 = row.outQty14 == "" ? 0 : row.outQty14;
        var outQty15 = row.outQty15 == "" ? 0 : row.outQty15;
        var shopSaleQty = row.shopSaleQty == "" ? 0 : row.shopSaleQty;
        var otherOutQty = row.otherOutQty == "" ? 0 : row.otherOutQty;
        var purRtnQty = row.purRtnQty == "" ? 0 : row.purRtnQty;
        var transOutQty = row.transOutQty == "" ? 0 : row.transOutQty;
        var zzOutQty = row.zzOutQty == "" ? 0 : row.zzOutQty;
        var cxOutQty = row.cxOutQty == "" ? 0 : row.cxOutQty;
        var useQty = row.useQty == "" ? 0 : row.useQty;
        var lenOutQty = row.lenOutQty == "" ? 0 : row.lenOutQty;
        var lossQty = row.lossQty == "" ? 0 : row.lossQty;
        var lendQty = row.lendQty == "" ? 0 : row.lendQty;
        var checkOutQty = row.checkOutQty == "" ? 0 : row.checkOutQty;

        var totalQty = parseFloat(outQty11)
            + parseFloat(outQty12)
            + parseFloat(outQty13)
            + parseFloat(outQty14)
            + parseFloat(outQty15)
            + parseFloat(shopSaleQty)
            + parseFloat(otherOutQty)
            + parseFloat(purRtnQty)
            + parseFloat(transOutQty)
            + parseFloat(zzOutQty)
            + parseFloat(cxOutQty)
            + parseFloat(useQty)
            + parseFloat(lenOutQty)
            + parseFloat(lossQty)
            + parseFloat(lendQty)
            + parseFloat(checkOutQty)
        ;
        return totalQty.toFixed(2);
    }

    function formatterSt(v, row) {
        var hl = '<table>';
        if (row.list.length > 0) {
            hl += '<tr>';
            hl += '<td width="120px;"><b>入库日期</b></td>';
            //if(${stkRight.priceFlag} == 1)
            hl += '<td width="80px;"><b>价格</b></td>';
            // if(${stkRight.qtyFlag} == 1)
            hl += '<td width="60px;"><b>数量</font></b></td>';


            hl += '</tr>';
        }
        for (var i = 0; i < row.list.length; i++) {
            hl += '<tr>';
            hl += '<td>' + row.list[i].inTimeStr + '</td>';
            //if(${stkRight.priceFlag} == 1)
            hl += '<td>' + row.list[i].inPrice + '</td>';
            // if(${stkRight.qtyFlag} == 1)
            hl += '<td>' + row.list[i].qty + '</td>';

            hl += '</tr>';
        }
        hl += '</table>';
        return hl;
    }

    function todetail(title, id) {
        window.parent.add(title, "manager/queryBforderDetailPage?orderId=" + id);
    }

    function formatterSt2(val, row) {
        if (row.list.length > 0) {
            if (val == '未审核') {
                return "<input style='width:60px;height:27px' type='button' value='未审核' onclick='updateOrderSh(this, " + row.id + ")'/>";
            } else {
                return val;
            }
        }
    }



    function saveFieldSet() {
        var ids = [];
        var rows = $("#datagrid1").datagrid("getSelections");
        for (var i = 0; i < rows.length; i++) {
            ids.push(rows[i].title);

        }
        if (ids.lenth == 0) {
            alert("请选择要显示的字段");
            return;
        }
        var showAmt = "0";
        if ($("#chkshowamt").attr('checked')) showAmt = "1";
        var isExpand = "0";
        if ($("#chkisExpand").attr('checked')) isExpand = "1";
        $.messager.confirm('确认', '您确认要保存吗？', function (r) {
            if (r) {
                $.ajax({
                    url: "manager/saveStkSummaryField",
                    type: "post",
                    data: "fieldsStr=" + ids + "&showAmt=" + showAmt + "&isExpand=" + isExpand,
                    success: function (data) {
                        if (data.state) {
                            alert("操作成功");
                            $('#dlg').dialog('close');
                            location = 'manager/querystksummary';
                        } else {
                            alert("操作失败");
                            return;
                        }
                    }
                });
            }
        });
    }

    //导出成excel
    function toLoadExcel() {
        $('#orderNo2').val($('#orderNo').val());
        $('#khNm2').val($('#khNm').val());
        $('#memberNm2').val($('#memberNm').val());
        $('#sdate2').val($('#sdate').val());
        $('#edate2').val($('#edate').val());
        $('#orderZt2').val($('#orderZt').val());
        $('#pszd2').val($('#pszd').val());
        $('#loadfrm').form('submit', {
            success: function (data) {
                alert(data);
            }
        });
    }








    function onClickCell(index, field, value) {
        var rows = $("#datagrid").datagrid("getRows");
        var row = rows[index];
        var sdate = $("#sdate").val();
        var edate = $("#edate").val();
        var stkId = $("#stkId").val();
        parent.closeWin('出入库明细');
        if (field == "inQty") {
            var billName = "采购入库";
            parent.add('出入库明细', 'manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
        }
        if (field == "initInQty") {
            var billName = "初始化入库";
            parent.add('出入库明细', 'manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
        }
        if (field == "checkInQty") {
            var billName = "盘盈";
            parent.add('出入库明细', 'manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
        }
        if (field == "inQty1") {
            var billName = "其它入库";
            parent.add('出入库明细', 'manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
        }
        if (field == "rtnQty") {
            var billName = "销售退货";
            parent.add('出入库明细', 'manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
        }
        if (field == "transInQty") {
            var billName = "移库入库";
            parent.add('出入库明细', 'manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
        }

        if (field == "zzInQty") {
            var billName = "组装入库";
            parent.add('出入库明细', 'manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
        }

        if (field == "cxInQty") {
            var billName = "拆卸入库";
            parent.add('出入库明细', 'manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
        }

        if (field == "scQty") {
            var billName = "生产入库";
            parent.add('出入库明细', 'manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
        }

        if (field == "hkQty") {
            var billName = "领料回库";
            parent.add('出入库明细', 'manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
        }


        if (field == "outQty11") {
            var billName = "正常销售";

            parent.add('出入库明细', 'manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
        }
        if (field == "outQty12") {
            var billName = "促销折让";
            parent.add('出入库明细', 'manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
        }
        if (field == "outQty13") {
            var billName = "消费折让";
            parent.add('出入库明细', 'manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
        }
        if (field == "outQty14") {
            var billName = "费用折让";
            parent.add('出入库明细', 'manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
        }
        if (field == "outQty15") {
            var billName = "其它销售";
            parent.add('出入库明细', 'manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
        }
        if (field == "otherOutQty") {
            var billName = "其它出库";
            parent.add('出入库明细', 'manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
        }
        if (field == "purRtnQty") {
            var billName = "采购退货";
            parent.add('出入库明细', 'manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
        }
        if (field == "transOutQty") {
            var billName = "移库出库";
            parent.add('出入库明细', 'manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
        }

        if (field == "zzOutQty") {
            var billName = "组装出库";
            parent.add('出入库明细', 'manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
        }

        if (field == "cxOutQty") {
            var billName = "拆卸出库";
            parent.add('出入库明细', 'manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
        }

        if (field == "useQty") {
            var billName = "领用出库";
            parent.add('出入库明细', 'manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
        }

        if (field == "lossQty") {
            var billName = "报损出库";
            parent.add('出入库明细', 'manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
        }

        if (field == "lendQty") {
            var billName = "借出出库";
            parent.add('出入库明细', 'manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
        }

        if (field == "checkOutQty") {
            var billName = "盘亏";
            parent.add('出入库明细', 'manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
        }

        if (field == "otherTypeInQty") {
            var billName = "其它类型入库";
            parent.add('出入库明细', 'manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
        }

        if (field == "otherTypeOutQty") {
            var billName = "其它类型出库";
            parent.add('出入库明细', 'manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + row.wareId + '&stkId=' + stkId + '&billName=' + billName);
        }
    }

    function onDblClickRow(rowIndex, rowData) {
        //parent.add('销售开票信息' + rowData.id,'manager/showstkout?dataTp=1&billId=' + rowData.id);
        //parent.add('付款记录' + rowData.id,'manager/queryPayPageByBillId?dataTp=1&billId=' + rowData.id);
        var sdate = $("#sdate").val();
        var edate = $("#edate").val();
        var stkId = $("#stkId").val();
        parent.closeWin('出入库明细');
        parent.add('出入库明细', 'manager/queryIoDetail?sdate=' + sdate + '&edate=' + edate + '&wareId=' + rowData.wareId + '&stkId=' + stkId + "&billName=全部");

    }

    function chooseWare() {
        parent.add('选择商品', 'manager/stkChooseWare');
    }

    function submitRight(qtyFlag) {

        $.ajax({
            url: "manager/saveOneStkRight",
            data: {"menuId": 129, "qtyFlag": qtyFlag},
            type: "post",
            success: function (json) {
                if (json.state) {
                    showMsg("保存成功");
                    //$("#datagrid").datagrid("reload");
                    location = 'manager/querystksummary';
                } else {
                    showMsg("提交失败");
                }
            }
        });

    }

    function sumStkProc() {
        $.ajax({
            url: "manager/updateStorageQty",
            data: {"token": 129},
            type: "post",
            success: function (json) {
                if (json.state) {
                    showMsg("计算成功");
                    //$("#datagrid").datagrid("reload");
                    //location = 'manager/querystksummary';
                } else {
                    showMsg("提交失败");
                }
            }
        });
    }

    function chooseRight(chk) {
        if (chk.checked) submitRight(1);
        else submitRight(0);
    }

    function onLoadSuccess() {
    }

    function onLoadSuccess1(data) {
        if (data) {
            $.each(data.rows, function (index, item) {
                if (item.chk) {
                    $('#datagrid1').datagrid('checkRow', index);
                }
            });
        }


    }

    function chooseIsShowAmt(chk) {
        var rows = $("#datagrid1").datagrid("getRows");
        $.each(rows, function (index, item) {

            if (item.title.indexOf("金额") != -1 || item.title.indexOf("单价") != -1) {
                if (chk.checked)
                    $('#datagrid1').datagrid('checkRow', index);
                else
                    $("#datagrid1").datagrid("unselectRow", index);
            }
        });
    }
</script>
</body>
</html>
