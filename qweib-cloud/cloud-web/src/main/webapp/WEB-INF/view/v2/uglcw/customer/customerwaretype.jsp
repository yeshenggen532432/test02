<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>设置费用</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        /*.inputAmt{*/
        /*width: 70px;*/
        /*height: 15px;*/
        /*}*/
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="uglcw-layout-container">

        <div class="uglcw-layout-fixed" style="width:200px">
            <div class="layui-card">
                <div class="layui-card-header">库存商品类</div>
                <div class="layui-card-body">
                    <div uglcw-role="tree" id="tree"
                         uglcw-options="
							url: '${base}manager/companyStockWaretypes',
							expandable:function(node){return node.id == '0'},
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
								uglcw.ui.get('#wareType').value(node.id);
								uglcw.ui.get('#click-flag').value(0);
								uglcw.ui.get('#grid').reload();
                       		}
                    	">
                    </div>
                </div>
            </div>
        </div>
        <div class="uglcw-layout-content">
            <div class="layui-card header">
                <div class="layui-card-body">
                    <ul class="uglcw-query form-horizontal">
                        <li>
                            <input type="hidden" uglcw-model="jz" value="1" uglcw-role="textbox">
                            <input id="wtype" type="hidden" uglcw-model="wtype" uglcw-role="textbox">
                            <input uglcw-role="textbox" uglcw-model="wareNm" placeholder="商品名称">
                        </li>
                        <li>
                            <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                            <button id="reset" class="k-button" uglcw-role="button">重置</button>
                        </li>
                    </ul>
                </div>
            </div>
            <div class="layui-card">
                <div class="layui-card-body full">
                    <div id="grid" uglcw-role="grid"
                         uglcw-options="
					responsive:['.header',40],
                    id:'id',
                    toolbar: kendo.template($('#toolbar').html()),
                    url: '${base}manager/wares',
                    criteria: '.form-horizontal',
                    pageable: true,
                    ">
                        <%--<div data-field="inDate" uglcw-options="--%>
                        <%--width:50, selectable: true, type: 'checkbox', locked: true,--%>
                        <%--headerAttributes: {'class': 'uglcw-grid-checkbox'}--%>
                        <%--"></div>--%>
                        <div data-field="wareCode" uglcw-options="width:120">商品编码</div>
                        <div data-field="wareNm" uglcw-options="width:140">商品名称</div>
                        <div data-field="waretypeNm" uglcw-options="width:140">所属分类</div>
                        <div data-field="wareGg" uglcw-options="width:120">规格</div>
                        <div data-field="wareDw" uglcw-options="width:120">单位</div>
                        <div data-field="wareDj" uglcw-options="
								width:110,
								template:templateWareDj,
								hidden:true
							" >
                            大单位批发价
                        </div>
                        <c:if test="${op !=1}">
                            <div data-field="tranAmt" uglcw-options="
								width:110,
								template:templateTranAmt,
							">
                                单件运输费用
                            </div>
                            <c:if test="${op !=1}">
                            </c:if>
                            <div data-field="tcAmt" uglcw-options="
								width:110,
								template:templateTcAmt,
								hidden:true
							">
                                单件提成费用
                            </div>
                        </c:if>
                        <div data-field="fbtime" uglcw-options="width:200">发布时间</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:editPrice();" class="k-button k-button-icontext">
        <span class="k-icon k-i-edit"></span><span id="editPrice">编辑运输费用</span>
    </a>
</script>

<script id="wareDj" type="text/x-uglcw-template">
    <%--# var wareId = data.wareId #--%>
    <%--# if(val == null || val == undefined || val === '' || val== "undefined"){ #--%>
    <%--# 	val = "" #--%>
    <%--# } #--%>

    <%--<input class="#=field#_input k-textbox" name="#=field#_input" uglcw-role="numeric" uglcw-validate="number" style="height:25px;display:none" onchange="changePrice(this,'#= field #',#= wareId #)"  value='#= val #'>--%>
    <%--<span class="#=field#_span" id="#=field#_span_#=wareId#" >#= val #</span>--%>
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    var warePriceDatas = eval('${warePrice}');
    var salePriceDatas = eval('${salePrice}');
    var customerPriceDatas = eval('${customerPrice}');

    $(function () {
        uglcw.ui.init();
        //显示商品
        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').k().dataSource.read();
            document.getElementById("editPrice").innerText = "编辑价格";
            k = 1;
        })

        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal', {
                sdate: '${sdate}', edate: '${edate}'
            });
        })
        uglcw.ui.loaded()
    })


    var k = 1;

    function editPrice() {
        var inputSale = document.getElementsByName("inputSale");
        var spanSale = document.getElementsByName("spanSale");
        var inputTranAmt = document.getElementsByName("inputTranAmt");
        var spanTranAmt = document.getElementsByName("spanTranAmt");
        var inputTcAmt = document.getElementsByName("inputTcAmt");
        var spanTcAmt = document.getElementsByName("spanTcAmt");
        for (var i = 0; i < inputSale.length; i++) {
            if (k == 1) {
                inputSale[i].style.display = '';
                spanSale[i].style.display = 'none';
                if ('${op}' != 1) {
                    inputTranAmt[i].style.display = '';
                    spanTranAmt[i].style.display = 'none';
                    inputTcAmt[i].style.display = '';
                    spanTcAmt[i].style.display = 'none';
                }
            } else {
                inputSale[i].style.display = 'none';
                spanSale[i].style.display = '';
                if ('${op}' != 1) {
                    inputTranAmt[i].style.display = 'none';
                    spanTranAmt[i].style.display = '';
                    inputTcAmt[i].style.display = 'none';
                    spanTcAmt[i].style.display = '';
                }
            }
        }
        if (k == 1) {
            document.getElementById("editPrice").innerText = "关闭编辑价格";
            k = 0;
        } else {
            document.getElementById("editPrice").innerText = "编辑价格";
            k = 1;
        }
    }

    //------------------------------------------------------大单位批发价:start------------------------------------------------------------
    //模板：大单位批发价
    function templateWareDj(row) {
        var saleAmt = "";
        if (saleAmt == undefined || saleAmt == "undefined") {
            saleAmt = 0.0;
        }
        var html = "<input type='hidden' id='clientPriceId" + row.wareId + "' /><input type='text' style='display:none' size='7' onchange='changeCustomerPrice(this," + row.wareId + ")' name='inputSale' value='" + saleAmt + "' class='k-textbox' uglcw-role='numeric' uglcw-validate='number'/><span name='spanSale' id='spanSale_" + row.wareId + "'>" + saleAmt + "</span>";
        if (customerPriceDatas.length > 0) {
            for (var i = 0; i < customerPriceDatas.length; i++) {
                var json = customerPriceDatas[i];
                if (json.wareId == row.wareId) {
                    saleAmt = json.saleAmt;
                    html = "<input type='hidden' id='clientPriceId" + row.wareId + "' value=" + json.id + " /><input type='text' style='display:none' size='7' onchange='changeCustomerPrice(this," + row.wareId + ")' name='inputSale' value='" + saleAmt + "' class='k-textbox' uglcw-role='numeric' uglcw-validate='number'/><span  name='spanSale' id='spanSale_" + row.wareId + "'>" + saleAmt + "</span>";
                    break;
                }
            }
            return html;
        } else {
            return "<input type='hidden' id='clientPriceId" + row.wareId + "' /><input type='text' style='display:none' size='7' onchange='changeCustomerPrice(this," + row.wareId + ")' name='inputSale' value='" + saleAmt + "' class='k-textbox' uglcw-role='numeric' uglcw-validate='number'/><span name='spanSale' id='spanSale_" + row.wareId + "'>" + saleAmt + "</span>";
        }
    }

    //修改价格：大单位批发价
    function changeCustomerPrice(obj, wareId) {
        if (isNaN(obj.value)) {
            uglcw.ui.toast("请输入数字")
            return;
        }
        var id = document.getElementById("clientPriceId" + wareId).value;
        var saleAmt1 = $("#spanSale_" + wareId);
        $.ajax({
            url: "${base}manager/updateSysCustomerPrice",
            type: "post",
            data: "id=" + id + "&wareId=" + wareId + "&saleAmt=" + obj.value + "&customerId=${param.customerId}",
            success: function (data) {
                if (data != '0') {
                    if (id == "") {
                        document.getElementById("clientPriceId" + wareId).value = data;
                    }
                    saleAmt1.text("" + obj.value);

                } else {
                    uglcw.ui.toast("操作失败");
                }
            }
        });
    }

    //------------------------------------------------------大单位批发价:end------------------------------------------------------------

    //------------------------------------------------------单价运输费用:start------------------------------------------------------------
    //模板：单价运输费用
    function templateTranAmt(row) {
        var tranAmt = row.tranAmt;
        if (tranAmt == undefined || tranAmt == "undefined") {
            tranAmt = 0.0;
        }
        var html = "<input type='hidden' id='clientWareId" + row.wareId + "' /><input type='text' style='display:none' size='7' onchange='changeTranPrice(this," + row.wareId + ")' name='inputTranAmt' value='" + tranAmt + "' class='k-textbox' uglcw-role='numeric' uglcw-validate='number'/><span name='spanTranAmt' id='spanTranAmt_" + row.wareId + "'>" + tranAmt + "</span>";
        if (warePriceDatas.length > 0) {
            for (var i = 0; i < warePriceDatas.length; i++) {
                var json = warePriceDatas[i];
                if (json.wareId == row.wareId) {
                    tranAmt = json.tranAmt;
                    html = "<input type='hidden' id='clientWareId" + row.wareId + "' value=" + json.id + " /><input type='text' style='display:none' size='7' onchange='changeTranPrice(this," + row.wareId + ")' name='inputTranAmt' value='" + tranAmt + "' class='k-textbox' uglcw-role='numeric' uglcw-validate='number'/><span  name='spanTranAmt' id='spanTranAmt_" + row.wareId + "'>" + tranAmt + "</span>";
                    break;
                }
            }
            return html;
        } else {
            return "<input type='hidden' id='clientWareId" + row.wareId + "'/><input type='text' style='display:none' size='7' onchange='changeTranPrice(this," + row.wareId + ")' name='inputTranAmt' value='" + tranAmt + "' class='k-textbox' uglcw-role='numeric' uglcw-validate='number'/><span name='spanTranAmt' id='spanTranAmt_" + row.wareId + "'>" + tranAmt + "</span>";
        }
    }

    function changeTranPrice(obj, wareId) {
        if (isNaN(obj.value)) {
            uglcw.ui.toast("请输入数字")
            return;
        }
        var id = document.getElementById("clientWareId" + wareId).value;
        var spanTranAmt = $('#spanTranAmt_' + wareId)
        $.ajax({
            url: "${base}manager/updateSysCustomerWarePrice",
            type: "post",
            data: "id=" + id + "&wareId=" + wareId + "&tranAmt=" + obj.value + "&customerId=${param.customerId}",
            success: function (data) {
                if (data != '0') {
                    if (id == "") {
                        document.getElementById("clientWareId" + wareId).value = data;
                    }
                    spanTranAmt.text(obj.value);

                } else {
                    uglcw.ui.toast("操作失败");
                }
            }
        });
    }

    //------------------------------------------------------单价运输费用:end------------------------------------------------------------


    //------------------------------------------------------单件提成费用:start------------------------------------------------------------
    //模板：单件提成费用
    function templateTcAmt(row) {
        var tcAmt = row.tcAmt;
        if (tcAmt == undefined || tcAmt == "undefined") {
            tcAmt = 0.0;
        }
        var html = "<input type='hidden' id='clienttcId" + row.wareId + "' /><input type='text' style='display:none' size='7' onchange='changeTcPrice(this," + row.wareId + ")' name='inputTcAmt' value='" + tcAmt + "' class='k-textbox' uglcw-role='numeric' uglcw-validate='number'/><span name='spanTcAmt' id='spanTcAmt_" + row.wareId + "'>" + tcAmt + "</span>";
        if (salePriceDatas.length > 0) {
            for (var i = 0; i < salePriceDatas.length; i++) {
                var json = salePriceDatas[i];
                if (json.wareId == row.wareId) {
                    tcAmt = json.tcAmt;
                    html = "<input type='hidden' id='clienttcId" + row.wareId + "' value=" + json.id + " /><input type='text' style='display:none' size='7' onchange='changeTcPrice(this," + row.wareId + ")' name='inputTcAmt' value='" + tcAmt + "' class='k-textbox' uglcw-role='numeric' uglcw-validate='number'/><span  name='spanTcAmt' id='spanTcAmt_" + row.wareId + "'>" + tcAmt + "</span>";
                    break;
                }
            }
            return html;
        } else {
            return "<input type='hidden' id='clienttcId" + row.wareId + "'/><input type='text' style='display:none' size='7' onchange='changeTcPrice(this," + row.wareId + ")' name='inputTcAmt' value='" + tcAmt + "' class='k-textbox' uglcw-role='numeric' uglcw-validate='number'/><span name='spanTcAmt' id='spanTcAmt_" + row.wareId + "'>" + tcAmt + "</span>";
        }
    }

    function changeTcPrice(obj, wareId) {
        if (isNaN(obj.value)) {
            uglcw.ui.toast("请输入数字")
            return;
        }
        var id = document.getElementById("clienttcId" + wareId).value;
        var spanTcAmt = $('#spanTcAmt_' + wareId);
        $.ajax({
            url: "${base}manager/updateSysCustomerSalePrice",
            type: "post",
            data: "id=" + id + "&wareId=" + wareId + "&tcAmt=" + obj.value + "&customerId=${param.customerId}",
            success: function (data) {
                if (data != '0') {
                    if (id == "") {
                        document.getElementById("clienttcId" + index).value = data;
                    }
                    spanTcAmt.text(obj.value)

                } else {
                    uglcw.ui.toast("操作失败");
                }
            }
        });
    }

    //------------------------------------------------------单件提成费用:end------------------------------------------------------------


</script>
</body>
</html>
