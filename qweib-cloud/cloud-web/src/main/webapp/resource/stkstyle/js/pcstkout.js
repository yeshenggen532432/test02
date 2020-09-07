var editstatus = 0;
var gstklist;
var orderlist;
var isEp = 0;//是否选择直供转单二批 0:否 1:是
var moveRow = 0;
var chooseNoList = [];
var enCount = 0;
var saveCount = 0;
var inputCount = 0;
$(function () {
    querystorage();
    querydepart();
    //初始化按钮
    var status = $("#status").val();
    var billId = $("#billId").val();
    setKendoAutoCompleteInput("barcodeInput");//自动实列化
    $('#chooselist').on('click', '.tdClass div', function () {//查看商品历史价
        var td = $(this).closest('td');
        showCustomerHisWarePrice(td);
    });

    $('#chooselist').on('keyup', '.wareClass input[name=wareNm]', function () {
        if ($(this).val() == "") {
            clearTabRowData("");
        }
    });

    $("#khNm").focus();
    if (status == 0 && billId == 0) {
        statuschg(1);
    } else {
        if (status == 0) {
            statuschg(0);
        }
    }
    if (billId == 0) {

        $("#pszd").val("公司直送");
        $("#pszdspan").text("公司直送");
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
        var hour = myDate.getHours();
        if (hour < 10) hour = '0' + hour;
        var minute = myDate.getMinutes();
        if (minute < 10) minute = '0' + minute;
    }
    if (billId > 0) {
        $("#barcodeInput").focus();
        document.getElementById("btnsave").style.display = "none";
        checkOutSubPriceDiff();
    }

    if (status == -2) {
        editstatus = -2;
    }

    displayXsTpSel();
    var orderId = $("#orderId").val();

    if (orderId > 0 && billId == 0) {
        var len = $("#more_list tbody").find("tr").length;
        if (len == 0) {
            queryOrderDetail();
            $("#barcodeInput").focus();
            $("#barcodeInput").click();
            $("#barcodeInput").focus();
        }
        //$("#checktd").css('display','block');
        $("#checktd").css('display', '');
        $("#check1").attr("checked", false);//设置为选中状态
    } else {
        $("#checktd").css('display', '');
        //$("#check1").attr("checked", false);//设置为选中状态
        if (status == -2 && orderId > 0) {
            $("#checktd").css('display', 'block');
            //$("#check1").attr("checked", false);//设置为选中状态
        }
    }
    $(".ft_icon").on('touchend', function () {
        if ($(this).hasClass('show')) {
            $(".ftb_hd").hide();
            $(this).removeClass('show');
        } else {
            $(".ftb_hd").show();
            $(this).addClass('show');
        }
    });
    $("#pc_order").on('click', function () {
        selectSaleOrder();
    });

    $('#snapshot').on('click', showSnapshot);

    $("#epCustomerName").on('click', function () {
        isEp = 1;
        if (editstatus == 0) return;
        querycustomer();
        $("#customerForm").show();
    });

    $("#staff").on('click', function () {

        if (editstatus == 0) return;
        $("#staffForm").show();
        $("#memdiv").show();
        $(".pcl_3box .pcl_switch").show();
    });

    function close_box(box, btn) {
        btn.click(function () {
            box.hide();
        });
    }

    close_box($(".pcl_chose_people"), $(".close_button"));
    close_box($(".pcl_chose_people"), $(".close_btn2"));

    $(".pcl_infinite p").on('click', function () {
        if ($(this).hasClass('open')) {
            $(this).siblings('.pcl_file').slideUp(200);
            $(this).removeClass('open');
        } else {
            $(this).siblings('.pcl_file').slideDown(200);
            $(this).addClass('open');
        }
    });

    /*
	 * 通用点击选择选项按钮
	 * */
    function lib_had(btn, box) {
        btn.on('click', function () {
            box.fadeIn(200);
        });
        box.find('.mask').on('click', function () {
            box.fadeOut(200);
        });
        box.find('li').on('click', function () {
            var t = $(this).text();
            btn.text(t);
            box.fadeOut(200);
        });
    }

    /*
	 *  销售类型 选择方式
	 *
	 * */
    var v = 0, o;

    function lib_had2(btn, box) {
        var this_eq;
        btn.on('click', function () {
            if (!$(this).attr('data-id')) {
                $(this).attr('data-id', v);
                this_eq = v;
                v++;
            }
            box.fadeIn(200);
            o = $(this).attr('data-id');
        });
        box.find('.mask').on('click', function () {
            box.fadeOut(200);
        });
        box.find('li').on('click', function () {
            var t = $(this).text();
            $(".lib_chose_sale[data-id=" + o + "]").text(t);
            box.fadeOut(200);
        });
    }

    /*
	 * 有二级菜单的浮层
	 * */
    var flag = 1,
        didnum = Number(0);

    function has_sub_had(btn, box) {
        // 点击出现浮层按钮
        btn.on('click', function () {
            box.fadeIn(200);
        });
        // 半透明层关闭浮层
        box.find('.mask').on('click', function () {
            box.fadeOut(200);
            if (!$("#more_list .beer").length) {

                $("#more_list tbody").append(
                    '<tr class="initial_rest">' +
                    '<td><a href="javascript:;" class="delete_beer">删除</a></td>' +
                    '<td><a href="javascript:;" class="beer">点击选择</a></td>' +
                    '<td><a href="javascript:;" class="lib_chose_sale">点击选择</a></td>' +
                    '<td><input type="number" class="bli"/></td>' +
                    '<td><input type="text" class="bli"/></td>' +
                    '<td><input type="number" class="bli"/></td>' +
                    '</tr>'
                );
            }
            $(".beer").on('click', function () {
                $("#beer_box").fadeIn(200);
            });
            lib_had2($(".lib_chose_sale"), $("#lib_chose_sale_had")); // 出库-销售类型-按钮绑定
        });
        // 二级菜单栏点开
        box.find('li').on('click', function () {

            if (!$(this).hasClass('on')) {
                box.find('li').removeClass('on');
                box.find('.sub_menu').slideUp(200)
                $(this).addClass('on');
                $(this).find('.sub_menu').slideDown(200);
            }

        });

        $(".sub_2").on('click', function () {
            if (!$(this).hasClass('act')) {
                $(".sub_2").removeClass('act');
                $(".sub_m2").slideUp();
                $(this).addClass('act');
                $(this).find('.sub_m2').slideDown(200);
            }
        });

        box.find('td').on('click', function () {

            var t = $(this).find('span').text();

            var bl = $("#more_list .beer").length; // 获取已选中条数

            var did = $(this).attr('data-id'); // 选择按钮的data-id 如果不存在 则添加
            console.log(did);
            if (!did) {
                didnum++;
                $(this).attr('data-id', didnum);
            }

            $(".initial_rest").remove();

            if ($(this).hasClass('on')) {

                var didn2 = $(this).attr('data-id');
                $("#more_list tr").each(function () {
                    if ($(this).attr('data-id') == didn2) {
                        $(this).remove();
                    }
                });

            } else {
                var dididid = $(this).attr('data-id');
                $("#more_list tbody").append(
                    '<tr data-id="' + dididid + '">' +
                    '<td><a href="javascript:;" class="delete_beer">删除</a></td>' +
                    '<td><a href="javascript:;" class="beer">' + t + '</a></td>' +
                    '<td><a href="javascript:;" class="lib_chose_sale">点击选择</a></td>' +
                    '<td><input type="number" class="bli"/></td>' +
                    '<td><input type="text" class="bli"/></td>' +
                    '<td><input type="number" class="bli"/></td>' +
                    '</tr>'
                );
            }
            if ($(this).hasClass('on')) {
                $(this).removeClass('on');
                $(this).find('.check').removeClass('checked');
            } else {
                $(this).addClass('on');
                $(this).find('.check').addClass('checked');
            }
        });
    }

    /*

	 * 供应商选择
	 *
	 * */
    function supplier() {
        $("#lib_supplier").on('click', function () {
            $(".chose_people").fadeIn(200);
        });
        $(".people_list li").on('click', function () {
            var p1 = $(this).find('.p1').text(), p2 = $(this).find('.p2').text();

            $("#lib_supplier").html(p1 + '&nbsp;&nbsp;&nbsp;' + p2);
//			console.log(123);
            $(".chose_people").fadeOut(200);
        });
    }

    supplier();
    lib_had2($(".lib_chose_sale"), $("#lib_chose_sale_had")); // 出库-销售类型-按钮绑定

    lib_had($("#warehouse"), $("#warehouse_bhad")); // 出库-销售类型-按钮绑定
    lib_had($("#order"), $("#order_had")); // 出库-销售类型-按钮绑定
    //lib_had($("#lib_supplier"),$("#lib_supplier_had")); //供应商选择
    has_sub_had($(".beer"), $("#beer_box"));// 选择啤酒类型
});

function querystorage() {
    var path = "queryBaseStorage";
    $.ajax({
        url: path,
        type: "POST",
        data: {"token11": ""},
        dataType: 'json',
        async: false,
        success: function (json) {
            if (json.state) {

                var size = json.list.length;
                gstklist = json.list;
                var objSelect = document.getElementById("stksel");
                objSelect.options.add(new Option(''), '');
                for (var i = 0; i < size; i++) {
                    objSelect.options.add(new Option(json.list[i].stkName, json.list[i].id));
                    if (i == 0) {
                        var billId = $("#billId").val();

                        if (billId == 0) {
                            $("#stkId").val(json.list[i].id);
                            $("#stkNamespan").text(json.list[i].stkName);
                        }

                    }

                }


            }
        }
    });
}

function queryOrder() {
    var path = "queryOrderList";
    var sdate = $("#sdate").val();
    var edate = $("#edate").val();
    var khNm = $("#ordersearch").val();
    //var token = $("#tmptoken").val();
    //alert(token);
    $.ajax({
        url: path,
        type: "POST",
        data: {"sdate": sdate, "edate": edate, "khNm": khNm},
        dataType: 'json',
        async: false,
        success: function (json) {
            if (json.state) {
                var size = json.rows.length;
                var text = "";
                for (var i = 0; i < size; i++) {
                    text += "<tr onclick=\"orderclick(this)\">";
                    text += "<td><span id=\"pc_lib_order\">" + json.rows[i].orderNo + "</span><input  type=\"hidden\" name=\"orderId\" value=\"" + json.rows[i].id + "\"/>"
                        + "<input  type=\"hidden\" name=\"cstId\" value=\"" + json.rows[i].cid + "\"/></td>	";
                    text += "<td><span id=\"pc_lib_khNm\">" + json.rows[i].khNm + "</span><input  type=\"hidden\" name=\"tel\" value=\"" + json.rows[i].tel + "\"/></td>";
                    text += "<td><span id=\"pc_amt\">" + json.rows[i].cjje + "</span><input  type=\"hidden\" name=\"address\" value=\"" + json.rows[i].address + "\"/></td>";
                    text += "</tr>";
                }
                $("#orderList").html(text);
            }
        }
    });
}

function queryOrderDetail() {

    var unitDisplay = 'none';
    var checkSunitBox = $("#checkSunitBox").attr('checked');
    ;
    if (checkSunitBox) {
        unitDisplay = '';
    }

    var path = "queryOrderSub";
    var orderId = $("#orderId").val();

    if (orderId == 0)
        return;
    //var token = $("#tmptoken").val();
    //alert(token);
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
    $.ajax({
        url: path,
        type: "POST",
        data: {"orderId": orderId, "field": field, "sort": sort},
        dataType: 'json',
        async: false,
        success: function (json) {
            if (json.state) {
                $("#more_list tbody").html("");
                var size = json.rows.length;
                //gstklist = json.rows;
                for (var i = 0; i < size; i++) {
                    var beUnit = json.rows[i].beUnit;
                    var maxUnitCheck = "";
                    var minUnitCheck = "";
                    if (beUnit == "S") {
                        minUnitCheck = "checked";
                    } else {
                        maxUnitCheck = "checked";
                    }
                    $("#more_list tbody").append(
                        '<tr onmouseout="wareTrOnMouseOutClick(this)"   onmousedown="wareTrOnMouseDownClick(this)">' +
                        '<td class="index">' + (i + 1) + '</td>' +
                        '<td style="padding-left: 20px;text-align: left;" class="tdClass">' +
                        '<input type="hidden" name="wareId" value = "' + json.rows[i].wareId + '"/><input type="hidden" name="checkWare"/><input type="text" class="pcl_i2" readonly="true" id="wareCode' + rowIndex + '" value="' + json.rows[i].wareCode + '" name="wareCode"/><div></div></td>' +
                        '<td id="autoCompleterTr' + rowIndex + '" class="wareClass"><input name="wareNm"  type="text" placeholder="输入商品名称、商品代码、商品条码" onclick="wareAutoClick(this)" onkeydown="gjr_forAuto_toNextCell(this,\'edtqty\')" style="width: 170px"/>' + selectImg + '</td>' +
                        '<td ><input type="text" class="pcl_i2" readonly="true" id="wareGg' + rowIndex + '" style="width: 80px;" value="' + json.rows[i].wareGg + '" name="wareGg"/></td>' +
                        '<td >' +
                        '<select name="xstp" id="xstp' + rowIndex + '" style="width:80px" onchange="chooseXsTp(this);">' +
                        '<option value="正常销售" checked>正常销售</option>' +
                        '<option value="促销折让">促销折让</option>' +
                        '<option value="消费折让">消费折让</option>' +
                        '<option value="费用折让">费用折让</option>' +
                        '<option value="其他销售">其他销售</option>' +
                        '</select>' +
                        '</td>' +
                        '<td >' +
                        '<select id="beUnit' + rowIndex + '" name="beUnit" style="width:50px" onchange="changeUnit(this,' + rowIndex + ')">' +
                        '<option value="' + json.rows[i].maxUnitCode + '" ' + maxUnitCheck + '>' + json.rows[i].wareDw + '</option>' +
                        '<option value="' + json.rows[i].minUnitCode + '" ' + minUnitCheck + '>' + json.rows[i].minUnit + '</option>' +
                        '</select>'
                        + '</td>' +
                        '<td onkeydown="gjr_toNextRow(this,\'edtqty\')" style="display:' + qtyDisplay + '"><input onclick="gjr_CellClick(this)" id="edtqty' + rowIndex + '" onkeydown="gjr_toNextCell(this,\'edtprice\')"  name="edtqty" type="text" class="pcl_i2" value="' + json.rows[i].wareNum + '" onchange="countAmt()"/></td>' +
                        '<td onkeydown="gjr_toNextRow(this,\'edtprice\')" style="display:' + priceDisplay + '"><input onclick="gjr_CellClick(this)" id="edtprice' + rowIndex + '" onkeydown="gjr_toNextCell(this,\'edtRemarks\')"  name="edtprice" type="text" class="pcl_i2" value="' + json.rows[i].wareDj + '" onchange="countAmt()"/></td>' +
                        '<td style="display:' + amtDisplay + '"> <input id="amt' + rowIndex + '" onclick="gjr_CellClick(this)"  name="amt" type="text" value=' + json.rows[i].warezj + ' class="pcl_i2" onchange="countPrice()"/></td>' +
                        '<td style="display:' + fanLiDisplay + '"><input id="rebatePrice' + rowIndex + '" onclick="gjr_CellClick(this)"  name="rebatePrice" type="text" class="pcl_i2" value=""/></td>' +
                        '<td onkeydown="gjr_toNextRow(this,\'edtqty\')"><input  name="productDate" placeholder="单击选择"  id="productDate' + rowIndex + '" class="pcl_i2"  onClick="WdatePicker({skin:\'whyGreen\',dateFmt: \'yyyy-MM-dd\'});" style="width: 90px;"  readonly="readonly" value=""/><a href="javacript:;;" onclick="selectWareBatch(this)">关联</a></td>' +
                        '<td onkeydown="gjr_toNextRow(this,\'qualityDays\')"><input name="qualityDays" onclick="gjr_CellClick(this)"  onkeydown="gjr_toNextCell(this,\'edtRemarks\')"  class="pcl_i2"  style="width: 90px;" value="' + json.rows[i].qualityDays + '" /></td>' +
                        '<td onkeydown="gjr_toNextRow(this,\'wareNm\',\'1\')"><input onclick="gjr_CellClick(this)" name="edtRemarks" type="text" class="pcl_i2" style="width: 80px;" value="' + json.rows[i].remark + '"/></td>' +
                        '<td style="display:none"><input id="hsNum' + rowIndex + '" name="hsNum" type="hidden" class="pcl_i2" value="' + json.rows[i].hsNum + '"/></td>' +
                        '<td style="display:none"><input id="unitName' + rowIndex + '" name="unitName" type="hidden" class="pcl_i2" value="' + json.rows[i].wareDw + '" /></td>' +
                        '<td style="display:none"><input id="sunitPrice' + rowIndex + '" name="sunitPrice" type="hidden" class="pcl_i2" value="' + json.rows[i].sunitPrice + '" /></td>' +
                        '<td style="display:none"><input id="bUnitPrice' + rowIndex + '" name="bUnitPrice" type="hidden" class="pcl_i2" value="' + json.rows[i].bunitPrice + '" /></td>' +
                        '<td style="display:none"><input id="sswId' + rowIndex + '" name="sswId" type="hidden" class="pcl_i2" /></td>' +
                        '<td style="display:' + unitDisplay + '" class="sunitClass"><input name="sunitQty" readonly="readonly" class="pcl_i2" /></td>' +
                        '<td style="display:' + unitDisplay + '" class="sunitClass"><input name="sunitJiage" onclick="gjr_CellClick(this)" onchange="changeSunitPrice(this)"  class="pcl_i2" /></td>' +
                        '<td style="display:' + helpDisplay + '" class="helpClass"><input name="helpQty" onkeyup="CheckInFloat(this)"  class="pcl_i2" /></td>' +
                        '<td style="display:' + helpDisplay + '" class="helpClass"><input name="helpUnit"  class="pcl_i2" /></td>' +
                        '<td style="display:none" class="helpClass"><input name="priceFlag" type="hidden" /></td>' +
                        '<td>' + optBtn + '</td>' +
                        '</tr>'
                    );
                    var row = $("#more_list tbody tr").eq(i);
                    $(row).find("input[name='wareNm']").val(json.rows[i].wareNm);
                    $(row).find("select[name='xstp']").val(json.rows[i].xsTp);
                    $(row).find("input[name='wareNm']").attr("id", "wareNm" + rowIndex);
                    setKendoAutoComplete($(row).find("input[name='wareNm']").attr("id"));
                    setKendoAutoOption($(row).find("select[name='beUnit']").attr("id"));
                    setKendoAutoXsOption($(row).find("select[name='xstp']").attr("id"));
                    if (beUnit != "") {
                        document.getElementById("beUnit" + rowIndex).value = beUnit;
                    } else {
                        var wareDw2 = json.rows[i].wareDw2;
                        if (json.rows[i].wareDw == wareDw2) {
                            document.getElementById("beUnit" + rowIndex).options[0].selected = true;
                        }
                        if (json.rows[i].minUnit == wareDw2) {
                            document.getElementById("beUnit" + rowIndex).options[1].selected = true;
                        }
                    }
                    loadWareProductDate(json.rows[i].wareId, rowIndex);
                    rowIndex++;
                    countAmt();
                    displayXsTpSel();
                }

                checkOutSubPriceDiff();
            }
        }
    });
}

function queryOutsub() {
    var unitDisplay = 'none';
    var checkSunitBox = $("#checkSunitBox").attr('checked');
    if (checkSunitBox) {
        unitDisplay = '';
    }

    var path = "queryOutSub";
    var billId = $("#billId").val();

    if (billId == 0)
        return;
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
    $.ajax({
        url: path,
        type: "POST",
        data: {"billId": billId, "field": field, "sort": sort},
        dataType: 'json',
        async: false,
        success: function (json) {
            if (json.state) {
                $("#more_list tbody").html("");
                var size = json.rows.length;
                //gstklist = json.rows;
                for (var i = 0; i < size; i++) {
                    var beUnit = json.rows[i].beUnit;
                    var maxUnitCheck = "";
                    var minUnitCheck = "";
                    if (beUnit == "S") {
                        minUnitCheck = "checked";
                    } else {
                        maxUnitCheck = "checked";
                    }

                    $("#more_list tbody").append(
                        '<tr onmouseout="wareTrOnMouseOutClick(this)"   onmousedown="wareTrOnMouseDownClick(this)">' +
                        '<td class="index">' + (i + 1) + '</td>' +
                        '<td style="padding-left: 20px;text-align: left;"  class="tdClass">' +
                        '<input type="hidden" name="wareId" value = "' + json.rows[i].wareId + '"/><input type="hidden" name="checkWare"/><input type="text" class="pcl_i2" readonly="true" id="wareCode' + rowIndex + '" value="' + json.rows[i].wareCode + '" name="wareCode"/><div></div></td>' +
                        '<td id="autoCompleterTr' + rowIndex + '" class="wareClass"><input name="wareNm"  type="text" placeholder="输入商品名称、商品代码、商品条码" onclick="wareAutoClick(this)" onkeydown="gjr_forAuto_toNextCell(this,\'edtqty\')" style="width: 170px"/>' + selectImg + '</td>' +
                        '<td ><input type="text" class="pcl_i2" readonly="true" id="wareGg' + rowIndex + '" name="wareGg" style="width: 80px;" value="' + json.rows[i].wareGg + '"/></td>' +
                        '<td>' +
                        '<select name="xstp" id="xstp' + rowIndex + '" style="width:80px">' +
                        '<option value="正常销售" checked>正常销售</option>' +
                        '<option value="促销折让">促销折让</option>' +
                        '<option value="消费折让">消费折让</option>' +
                        '<option value="费用折让">费用折让</option>' +
                        '<option value="其他销售">其他销售</option>' +
                        '</select>' +
                        '</td>' +
                        '<td >' +
                        '<select id="beUnit' + rowIndex + '" name="beUnit" style="width:50px" onchange="changeUnit(this,' + rowIndex + ')">' +
                        '<option value="' + json.rows[i].maxUnitCode + '" ' + maxUnitCheck + '>' + json.rows[i].wareDw + '</option>' +
                        '<option value="' + json.rows[i].minUnitCode + '" ' + minUnitCheck + '>' + json.rows[i].minUnit + '</option>' +
                        '</select>'
                        + '</td>' +
                        '<td onkeydown="gjr_toNextRow(this,\'edtqty\')" style="display:' + qtyDisplay + '"><input onclick="gjr_CellClick(this)" id="edtqty' + rowIndex + '" onkeydown="gjr_toNextCell(this,\'edtprice\')"  name="edtqty" type="text" class="pcl_i2" value="' + json.rows[i].qty + '" onchange="countAmt()"/></td>' +
                        '<td onkeydown="gjr_toNextRow(this,\'edtprice\')" style="display:' + priceDisplay + '"><input onclick="gjr_CellClick(this)" id="edtprice' + rowIndex + '" onkeydown="gjr_toNextCell(this,\'edtRemarks\')"  name="edtprice" type="text" class="pcl_i2" value="' + json.rows[i].price + '" onchange="countAmt()"/></td>' +
                        '<td style="display:' + amtDisplay + '"><input id="amt' + rowIndex + '" onclick="gjr_CellClick(this)"  name="amt" type="text" value=' + json.rows[i].warezj + ' class="pcl_i2" onchange="countPrice()"/></td>' +
                        '<td style="display:' + fanLiDisplay + '"><input id="rebatePrice' + rowIndex + '" onclick="gjr_CellClick(this)"  name="rebatePrice" type="text" class="pcl_i2" value=""/></td>' +
                        '<td onkeydown="gjr_toNextRow(this,\'edtqty\')"><input  name="productDate" placeholder="单击选择"   id="productDate' + rowIndex + '" class="pcl_i2"  onClick="WdatePicker({skin:\'whyGreen\',dateFmt: \'yyyy-MM-dd\'});" style="width: 90px;"  readonly="readonly" value="' + json.rows[i].productDate + '"/><a href="javacript:;;" onclick="selectWareBatch(this)">关联</a></td>' +
                        '<td onkeydown="gjr_toNextRow(this,\'qualityDays\')"><input name="qualityDays" onclick="gjr_CellClick(this)"  onkeydown="gjr_toNextCell(this,\'edtRemarks\')"  class="pcl_i2"  style="width: 90px;" value="' + json.rows[i].activeDate + '" /></td>' +
                        '<td onkeydown="gjr_toNextRow(this,\'wareNm\',\'1\')"><input onclick="gjr_CellClick(this)" name="edtRemarks" type="text" class="pcl_i2" style="width: 80px;" value="' + json.rows[i].remarks + '"/></td>' +
                        '<td style="display:none"><input id="hsNum' + rowIndex + '" name="hsNum" type="hidden" class="pcl_i2" value="' + json.rows[i].hsNum + '"/></td>' +
                        '<td style="display:none"><input id="unitName' + rowIndex + '" name="unitName" type="hidden" class="pcl_i2" value="' + json.rows[i].wareDw + '" /></td>' +
                        '<td style="display:none"><input id="sunitPrice' + rowIndex + '" name="sunitPrice" type="hidden" class="pcl_i2" value="' + json.rows[i].sunitPrice + '" /></td>' +
                        '<td style="display:none"><input id="bUnitPrice' + rowIndex + '" name="bUnitPrice" type="hidden" class="pcl_i2" value="' + json.rows[i].bunitPrice + '" /></td>' +
                        '<td style="display:none"><input id="sswId' + rowIndex + '" name="sswId" type="hidden" class="pcl_i2" /></td>' +
                        '<td style="display:' + unitDisplay + '" class="sunitClass"><input name="sunitQty" readonly="readonly" class="pcl_i2" /></td>' +
                        '<td style="display:' + unitDisplay + '" class="sunitClass"><input name="sunitJiage" onclick="gjr_CellClick(this)" onchange="changeSunitPrice(this)" class="pcl_i2" /></td>' +
                        '<td style="display:' + helpDisplay + '" class="helpClass"><input name="helpQty" onkeyup="CheckInFloat(this)"  class="pcl_i2" /></td>' +
                        '<td style="display:' + helpDisplay + '" class="helpClass"><input name="helpUnit"  class="pcl_i2" /></td>' +
                        '<td style="display:none" class="helpClass"><input name="priceFlag" type="hidden" /></td>' +
                        '<td>' + optBtn + '</td>' +
                        '</tr>'
                    );
                    var row = $("#more_list tbody tr").eq(i);
                    /**********************商品行中下拉选中商品开始****************************/
                    $(row).find("input[name='wareNm']").val(json.rows[i].wareNm);
                    $(row).find("input[name='wareNm']").attr("id", "wareNm" + rowIndex);
                    $(row).find("select[name='xstp']").val(json.rows[i].xsTp);
                    setKendoAutoComplete($(row).find("input[name='wareNm']").attr("id"));
                    setKendoAutoOption($(row).find("select[name='beUnit']").attr("id"));
                    setKendoAutoXsOption($(row).find("select[name='xstp']").attr("id"));
                    /**********************商品行中下拉选中商品结束****************************/
                    if (beUnit != "") {
                        document.getElementById("beUnit" + rowIndex).value = beUnit;
                    } else {
                        var wareDw2 = json.rows[i].wareDw2;
                        if (json.rows[i].wareDw == wareDw2) {
                            document.getElementById("beUnit" + rowIndex).options[0].selected = true;
                        }
                        if (json.rows[i].minUnit == wareDw2) {
                            document.getElementById("beUnit" + rowIndex).options[1].selected = true;
                        }
                    }
                    loadWareProductDate(json.rows[i].wareId, rowIndex);
                    rowIndex++;
                    countAmt();
                    displayXsTpSel();
                }

                checkOutSubPriceDiff();
            }
        }
    });
}

function loadWareProductDate(wareId, index) {
    var stkId = $("#stkId").val();
    if (stkId == null || stkId == "" || stkId == 0) {
        return;
    }
    var path = "queryStorageWareByWareId";
    $.ajax({
        url: path,
        type: "POST",
        data: {"stkId": stkId, "wareId": wareId},
        dataType: 'json',
        async: false,
        success: function (json) {
            if (json.state) {
                var size = json.list.length;
                if (size > 0) {
                    var data = json.list[0];
                    $("#productDate" + index).val(data.productDate);
                }
            }
        }
    });

}

var combFieldSort = "";
var combFlag = 1;

function combMainSort(flag) {
    combFlag = flag;
}

function combClose() {
    var combBtn = $("#combBtn").text();
    if (combBtn == "显示组合") {
        $("#combBtn").text("关闭组合");
        $("#combField").show();
    } else {
        $("#combBtn").text("显示组合");
        $("#combField").hide();
    }
}

function combField() {
    var f1 = $("input[name='ware_nm_radio']:checked").val();
    var f2 = $("input[name='be_unit_radio']:checked").val();
    if (f1 == undefined && f2 == undefined) {
        return;
    }
    if (f1 == undefined && f2 != undefined) {
        combFieldSort = f2;
    }
    if (f2 == undefined && f1 != undefined) {
        combFieldSort = f1;
    }
    if (f2 != undefined && f1 != undefined) {
        if (combFlag == 2) {
            combFieldSort = f2 + "," + f1;
        } else {
            combFieldSort = f1 + "," + f2;
        }
    }
    field = combFieldSort;
    sort = "";
    queryOrderDetail();
}

var field = "";
var sort = "desc"

function sortField(td, f) {
    var orderId = $("#orderId").val();
    if (orderId == 0) {
        $.messager.alert('消息', '未保存的单据且没有关联订单的单据不能排序！', 'info');
        return;
    }

    if (f != field) {
        sort = "desc";
    } else {
        if (sort == "desc") {
            sort = "asc";
        } else {
            sort = "desc";
        }
    }
    field = f;
    queryOrderDetail();
}


function sortFieldSub(td, f) {

    if (f != field) {
        sort = "desc";
    } else {
        if (sort == "desc") {
            sort = "asc";
        } else {
            sort = "desc";
        }
    }
    field = f;
    queryOutsub();
}

function searchCustomer() {
    var filter = $("#searchcst").val();
    querycustomer(filter);
}

var customerPage = 1;

function querycustomer(filter) {
    customerPage = 1;
    var path = "stkchoosecustomer";
    var ep = '';
    if (isEp == 1) {
        ep = isEp;
    }
    var token = $("#tmptoken").val();
    //alert(token);
    $.ajax({
        url: path,
        type: "POST",
        data: {"token": token, "page": 1, "rows": 50, "dataTp": "1", "khNm": filter, "isEp": ep},
        dataType: 'json',
        async: false,
        success: function (json) {
            if (json.state) {
                var size = json.rows.length;
                var text = "";
                for (var i = 0; i < size; i++) {
                    text += "<tr ondblclick=\"customerclick(this)\">";
                    text += "<td><span id=\"pc_lib_name\">" + json.rows[i].khNm + "</span><input  type=\"hidden\" name=\"cstId\" value=\"" + json.rows[i].id + "\"/></td>	";
                    text += "<td><span id=\"pc_lib_mes\">" + json.rows[i].mobile + "</span></td>";
                    text += "<td><span id=\"pc_address\">" + json.rows[i].address + "</span></td>";
                    text += "<td><span id=\"pc_khNm\">" + json.rows[i].linkman + "</span></td>";
                    text += "<td>" + json.rows[i].branchName + "</td>";
                    text += "<td><span class=\"bule_col\">" + json.rows[i].shZt + "</span></td>";
                    text += "<td style='display:none'><span id='saleId'>" + json.rows[i].memId + "</span><span id='saleNm'>" + json.rows[i].memberNm + "</span></td>";
                    text += "</tr>";
                }
                customerPage++;
                $("#customerlist").html(text);
                //$("#customerlist").append(text);
            }
        }
    });
}


function querycustomerPage() {
    var filter = $("#searchcst").val();
    var path = "stkchoosecustomer";
    var ep = '';
    if (isEp == 1) {
        ep = isEp;
    }
    var token = $("#tmptoken").val();
    //alert(token);
    $.ajax({
        url: path,
        type: "POST",
        data: {"token": token, "page": customerPage, "rows": 50, "dataTp": "1", "khNm": filter, "isEp": ep},
        dataType: 'json',
        async: false,
        success: function (json) {
            if (json.state) {
                var size = json.rows.length;
                var text = "";
                for (var i = 0; i < size; i++) {
                    text += "<tr ondblclick=\"customerclick(this)\">";
                    text += "<td><span id=\"pc_lib_name\">" + json.rows[i].khNm + "</span><input  type=\"hidden\" name=\"cstId\" value=\"" + json.rows[i].id + "\"/></td>	";
                    text += "<td><span id=\"pc_lib_mes\">" + json.rows[i].mobile + "</span></td>";
                    text += "<td><span id=\"pc_address\">" + json.rows[i].address + "</span></td>";
                    text += "<td><span id=\"pc_khNm\">" + json.rows[i].linkman + "</span></td>";
                    text += "<td>" + json.rows[i].branchName + "</td>";
                    text += "<td><span class=\"bule_col\">" + json.rows[i].shZt + "</span></td>";
                    text += "<td style='display:none'><span id='saleId'>" + json.rows[i].memId + "</span><span id='saleNm'>" + json.rows[i].memberNm + "</span></td>";
                    text += "</tr>";
                }
                customerPage++;
                //$("#customerlist").html(text);
                $("#customerlist").append(text);
            }
        }
    });
}

function customerclick(trobj) {
    var cstId = $(trobj.cells[0]).find("input[name='cstId']").val();
    var shr = $(trobj.cells[0]).find("span").text();
    if (isEp == 1) {
        $("#epCustomerId").val(cstId);
        $("#epCustomerName").val(shr);
        $(".pcl_chose_people").hide();
        return;
    }

    var tel = $(trobj.cells[1]).find("#pc_lib_mes").text();
    var address = $(trobj.cells[2]).find("#pc_address").text();
    var saleId = $(trobj.cells[6]).find("#saleId").text();

    $("#cstId").val(cstId);
    $("#pc_lib").html(shr);
    $("#csttel").val(tel);
    $("#cstaddress").val(address);
    getMemberInfo(saleId);
    $(".pcl_chose_people").hide();
    setTimeout('setPingYi()', 10);
    isModify = true;
}

function checkCustomerUnRec(cstId) {
    var proType = $("#proType").val();
    if (proType != "2") {
        return;
    }
    $.ajax({
        url: "checkCustomerUnRecPage",
        type: "POST",
        data: {"cstId": cstId},
        dataType: 'json',
        async: false,
        success: function (json) {
            if (json.state) {
                $("#cstMsg").text("(有未结清单据!)");
                setTimeout('clearCstMsg()', 5000);
            } else {
                $("#cstMsg").text("");
            }
        }
    });
}

function clearCstMsg() {
    $("#cstMsg").text("");
}

function setPingYi() {
    //setAutoWarePingyin();
    $("#barcodeInput").focus();
    $("#barcodeInput").click();
    $("#barcodeInput").focus();
    var len = $("#chooselist").find("tr").length;
    if (len == 0) {
        addTabRow(1);
    }
}

function orderclick(trobj) {
    var orderId = $(trobj.cells[0]).find("input[name='orderId']").val();
    var cstId = $(trobj.cells[0]).find("input[name='cstId']").val();
    var orderNo = $(trobj.cells[0]).find("span").text();
    var khNm = $(trobj.cells[1]).find("span").text();
    var tel = $(trobj.cells[1]).find("input").val();
    var address = $(trobj.cells[2]).find("input").val();
    $("#orderId").val(orderId);
    $("#pc_lib").html(khNm);
    $("#csttel").val(tel);
    $("#cstaddress").val(address);
    $("#pc_order").text(orderNo);
    $("#cstId").val(cstId);
    $(".pcl_chose_people").hide();
    queryOrderDetail();
    //queryOrder();
}

function queryWareBarByKeyWord(keyWord) {
    var cstId = $("#cstId").val();
    if (cstId == "") {
        $.messager.alert('消息', '请先选择客户!', 'info');
        return;
    }

    var path = "queryStkWarePage1";
    if ($("#check1").is(":checked") == true) {
        path = "queryStkWarePageForBar";
    }

    stkId = $("#stkId").val();
    if (stkId == "") stkId = 0;
    $.ajax({
        url: path,
        type: "POST",
        data: {"keyWord": keyWord, "stkId": stkId, "status": 1, "customerId": cstId, "page": 1, "rows": 50},
        dataType: 'json',
        async: false,
        success: function (json) {
            if (json.state) {
                var size = json.list.length;
                var text = "";
                var data = "";
                var wareIds = "";
                var datas = Array();
                for (var i = 0; i < size; i++) {
                    var tempJson = {
                        "wareId": json.list[i].wareId,
                        "wareNm": json.list[i].wareNm,
                        "wareGg": json.list[i].wareGg,
                        "wareCode": json.list[i].wareCode,
                        "unitName": json.list[i].wareDw,
                        "qty": 1,
                        "wareDj": json.list[i].wareDj,
                        "stkQty": json.list[i].stkQty,
                        "sunitFront": json.list[i].sunitFront,
                        "sunitPrice": json.list[i].sunitPrice,
                        "maxNm": json.list[i].wareDw,
                        "minUnitCode": json.list[i].minUnitCode,
                        "maxUnitCode": json.list[i].maxUnitCode,
                        "minNm": json.list[i].minUnit,
                        "hsNum": json.list[i].hsNum,
                        "inPrice": json.list[i].inPrice,
                        "productDate": json.list[i].productDate,
                        "qualityDays": json.list[i].qualityDays
                    };
                    data = tempJson;
                    datas.push(tempJson);
                    if (i > 0) {
                        wareIds += ",";
                    }
                    wareIds += tempJson.wareId;
                }
            }
            if ($("#check1").is(":checked") == true) {
                var len = datas.length;
                if (len == 1) {
                    setWareCheckCode(data.wareCode);
                } else if (len > 1) {

                    $('#wareBarDialog').dialog({
                        title: '条码商品',
                        iconCls: "icon-edit",
                        width: 600,
                        height: 300,
                        modal: true,
                        href: basePath + "/manager/toDialogWareBarPage?ids=" + wareIds,
                        onClose: function () {
                        }
                    });
                    $('#wareBarDialog').dialog('open');

                    /*
					for(var i=0;i<len;i++){
						var dd = datas[i];
						if(IsInList(dd.wareCode))
						{
							$("#barcodeInput").val("");
							//return;
						}
						var qty = checkWareNo(dd.wareCode);
						//alert(444);
						if(qty == 0)
						{
							$.messager.alert('消息','商品不存在!','info');
							setTimeout(function(){
								$(".messager-body").window('close');
							},1000)
							return;
						}
					}*/
                }

            } else
                addTabRowData(data);
        }
    });
}

function setWareCheckCode(wareCode) {
    $("#barcodeInput").focus();
    if (IsInList(wareCode)) {
        $("#barcodeInput").val("");
        return;
    }
    var qty = checkWareNo(wareCode);
    if (qty == 0) {
        $.messager.alert('消息', '商品不存在!', 'info');
        setTimeout(function () {
            $(".messager-body").window('close');
        }, 1000)
        return;
    }
}


function editClick() {
    if (editstatus != 0) {
        return;
    }
    statuschg(2);
}

function deleteClick() {
    if (editstatus != 0) {
        //alert("请先保存");
        $.messager.alert('消息', '请先保存!', 'info');
        return;
    }
}

function auditClick() {
    var status = $("#status").val();
    if (status == 2) {
        $.messager.alert('消息', '该单据已经作废,不能发货', 'info');
        return;
    }
    if (status == -2) {
        $.messager.alert('消息', '该单据未审批，不能发货', 'info');
        return;
    }
    if (status == 0) {
        auditProc();
    }
}

function auditProc() {
    var billId = $("#billId").val();
    if (billId == 0) {
        alert("没有可发货的单据");
        return;
    }
    parent.close('发货单');
    parent.add('发货单', 'manager/showstkoutcheck?dataTp=1&billId=' + billId);
}

function newClick() {

    location = 'pcstkout?orderId=0';
    if (editstatus != 0) {
        return;
    }
    statuschg(1);
}

function resetClick() {
    statuschg(0);
}

function statuschg(btnstatus) {
    editstatus = btnstatus;
    if (btnstatus == 1)//新建
    {
        $("#remarks").removeAttr("readonly");
        $("#discount").removeAttr("readonly");
        $("#outDate").removeAttr("disabled");
        $("#pszdsel").removeAttr("disabled");
        $("#stksel").removeAttr("disabled");
        $("#ordersel").removeAttr("disabled");
        $("#csttel").removeAttr("readonly");
        $("#cstaddress").removeAttr("readonly");
        var edits = document.getElementsByName("edtprice");
        for (var i = 0; i < edits.length; i++) {
            $(edits[i]).removeAttr("readonly");
        }
        var qtyedits = document.getElementsByName("edtqty");
        for (var i = 0; i < qtyedits.length; i++) {
            $(qtyedits[i]).removeAttr("readonly");
        }
        var amts = document.getElementsByName("amt");
        for (var i = 0; i < amts.length; i++) {
            $(amts[i]).removeAttr("readonly");
        }
        $("#billstatus").val("未发货");
    }
    if (btnstatus == 2)//编辑
    {
        $("#remarks").removeAttr("readonly");
        $("#discount").removeAttr("readonly");
        $("#outDate").removeAttr("disabled");
        $("#pszdsel").removeAttr("disabled");
        $("#stksel").removeAttr("disabled");
        $("#ordersel").removeAttr("disabled");
        $("#csttel").removeAttr("readonly");
        $("#cstaddress").removeAttr("readonly");
        var edits = document.getElementsByName("edtprice");
        for (var i = 0; i < edits.length; i++) {
            $(edits[i]).removeAttr("readonly");
        }
        var qtyedits = document.getElementsByName("edtqty");
        for (var i = 0; i < qtyedits.length; i++) {
            $(qtyedits[i]).removeAttr("readonly");
        }
        var amts = document.getElementsByName("amt");
        for (var i = 0; i < amts.length; i++) {
            $(amts[i]).removeAttr("readonly");
        }
    }
    if (btnstatus == 0) {
        $("#remarks").attr("readonly", "readonly");
        $("#discount").attr("readonly", "readonly");
        $("#outDate").attr("disabled", true);
        $("#pszdsel").attr("disabled", "disabled");
        $("#stksel").attr("disabled", "disabled");
        $("#ordersel").attr("disabled", "disabled");
        $("#csttel").attr("readonly", "readonly");
        $("#cstaddress").attr("readonly", "readonly");
        var edits = document.getElementsByName("edtprice");
        for (var i = 0; i < edits.length; i++) {
            $(edits[i]).attr("readonly", "readonly");
        }
        var qtyedits = document.getElementsByName("edtqty");
        for (var i = 0; i < qtyedits.length; i++) {
            $(qtyedits[i]).attr("readonly", "readonly");
        }
        var amts = document.getElementsByName("amt");
        for (var i = 0; i < amts.length; i++) {
            $(amts[i]).attr("readonly", "readonly");
        }
    }

}

var rowIndex = 1000;

function wareTrOnMouseDownClick(o) {
    if ($("#check1").is(":checked") != true) {
        $("#more_list tbody tr").css("background", "#fff");
        $(o).css("background", "skyblue");
    }
    var wareId = $(o).find("input[name='wareId']").val()
    querySaleCustomerHisWarePrice(wareId);
    $("#tipPrice").show();
}

function wareTrOnMouseOverClick(o) {
    var wareId = $(o).find("input[name='wareId']").val()
    querySaleCustomerHisWarePrice(wareId);
    $("#tipPrice").show();
}


function wareTrOnMouseOutClick(o) {
    // $("#tipPrice").hide();
}

function deleteChoose(lineObj) {
    $.messager.confirm('删除', '确定删除？', function (r) {
        if (r) {
            $(lineObj).parents('tr').remove();
            countAmt();
            var len = $("#more_list").find("tr").length;  //#tb为Table的id  获取所有行
            for (var i = 1; i < len - 1; i++) {
                $("#more_list tr").eq(i).children("td").eq(0).html(i);  //给每行的第一列重写赋值
            }
        }
    });
}


function countAmt() {
    var total = 0;
    var sumQty = 0;
    var trList = $("#chooselist").children("tr");
    for (var i = 0; i < trList.length; i++) {
        var tdArr = trList.eq(i).find("td");
        var wareId = trList.eq(i).find("input[name='wareId']").val();
        var qty = trList.eq(i).find("input[name='edtqty']").val();
        var price = trList.eq(i).find("input[name='edtprice']").val();
        if (qty == "") break;
        total = total + qty * price;
        sumQty = sumQty + qty * 1;
        qty = parseFloat(qty);
        price = parseFloat(price);
        trList.eq(i).find("input[name='amt']").val(numeral(qty * price).format("0.00"));
        if (wareId == 0) continue;
    }
    $("#totalamt").val(numeral(total).format("0,0.00"));
    var discount = $("#discount").val();
    if (discount == "" || discount == undefined) {
        discount = 0;
    }
    var disamt = parseFloat(total) - parseFloat(discount);
    $("#disamt").val(numeral(disamt).format("0,0.00"));
    $("#edtSumAmt").text(numeral(disamt).format("0,0.00"));
    $("#edtSumQty").text(numeral(sumQty).format("0,0.00"));
    isModify = true;
}

function countPrice() {
    var total = 0;
    var sumQty = 0;
    var trList = $("#chooselist").children("tr");
    for (var i = 0; i < trList.length; i++) {

        var tdArr = trList.eq(i).find("td");
        var wareId = trList.eq(i).find("input[name='wareId']").val();
        var qty = trList.eq(i).find("input[name='edtqty']").val();
        var amt = trList.eq(i).find("input[name='amt']").val();
        if (qty == "" || amt == "") break;
        var price = parseFloat(amt) / parseFloat(qty);
        price = price.toFixed(7);
        trList.eq(i).find("input[name='edtprice']").val(price);
        total = parseFloat(total) + parseFloat(amt);
        sumQty = sumQty + qty * 1;
        if (wareId == 0) continue;
    }

    $("#totalamt").val(numeral(total).format("0,0.00"));
    var discount = $("#discount").val();
    var disamt = total - discount;
    $("#disamt").val(numeral(disamt).format("0,0.00"));
    $("#edtSumAmt").text(numeral(disamt).format("0,0.00"));
    $("#edtSumQty").text(numeral(sumQty).format("0,0.00"));
    isModify = true;
}

function displayXsTpSel() {
    var trList = $("#chooselist").children("tr");
    for (var i = 0; i < trList.length; i++) {
        var tdArr = trList.eq(i).find("td");
        // var wareId = tdArr.eq(1).find("input").val();
        // var xsTp = tdArr.eq(4).find("input").val();
        //  tdArr.eq(4).find(".pcl_sel2").val(xsTp);
        // var qty = tdArr.eq(6).find("input").val();
        var wareId = trList.eq(i).find("input[name='wareId']").val();
        var xsTp = trList.eq(i).find("select[name='xstp']").val();
        var qty = trList.eq(i).find("input[name='edtqty']").val();

        if (qty == "") break;
        if (wareId == 0) continue;
    }
}

function chooseXsTp(o) {
    var row = $(o).closest('tr');
    var xstp = $(row).find("select[name='xstp']").val();
    if (xstp != "正常销售")
        $(row).find("input[name='edtprice']").val("0");
    countAmt();
}


function submitStk() {
    if (editstatus == 0) {
        $.messager.alert('消息', '请先新建或编辑', 'info');
        return;
    }
    var cstId = $("#cstId").val();
    var billId = $("#billId").val();
    //var khNm =  $('#cstIdComb').combobox('getText')+"";
    //var khId =  $('#cstIdComb').combobox('getText')+"";
    var khNm = $("#khNm").val();
    if (cstId == "") {
        cstId = 0;
    }
    //var khNm = $("#pc_lib").text();
    var stkId = $("#stkId").val();
    var tel = $("#csttel").val();
    var address = $("#cstaddress").val();
    var remarks1 = $("#remarks").val();
    var orderId = $("#orderId").val();
    var outTime = $("#outDate").val();
    var shr = khNm;
    var staff = $("#staff").text();
    var stafftel = $("#stafftel").val();
    var empId = $("#empId").val();
    var proType = $("#proType").val();
    var driverId = $("#driverId").val();
    var vehId = $("#vehId").val();
    var saleType = $("#saleType").val();
    var transportName = $("#transportName").val();
    var transportCode = $("#transportCode").val();
    if (proType == undefined || proType == "") {
        proType = 2;
    }
    if (staff == "" && xsfpQuickBill == 'none') {
        //alert("请选择业务员");
        $.messager.alert('消息', '请选择业务员', 'info');
        return;
    }

    var epCustomerId = $("#epCustomerId").val();
    var epCustomerName = $("#epCustomerName").val();
    var pszd = $("#pszd").val();
    if (pszd != "公司直送" && epCustomerId == "") {
        //alert("当配送指定为【直供转单二批】时，请选择二批客户");
        $.messager.alert('消息', '当配送指定为【直供转单二批】时，请选择二批客户', 'info');
    }
    var checkAutoPrice = 0;//未选中
    if ($('#wareXsPrice').attr('checked')) {
        checkAutoPrice = 1;
    }
    var autoCreateFhd = 1;
    if ($('#autoCreateFhd').val() != undefined && $("#autoCreateFhd").is(":checked") == true) {
        autoCreateFhd = 0;
    }

    //判断客户对应商品价是否同步到客户执行价
    var checkCustomerPrice = 0;
    if ($('#wareCustomerPrice').attr('checked')) {
        checkCustomerPrice = 1;
    }

    var changeOrderPrice = 0;
    if ($("#changeOrderPrice").is(":checked") == true) {
        changeOrderPrice = 1;
    }

    var discount = $("#discount").val();
    var wareList = new Array();
    var trList = $("#chooselist").children("tr");
    for (var i = 0; i < trList.length; i++) {
        var tdArr = trList.eq(i).find("td");
        var wareId = trList.eq(i).find("input[name='wareId']").val();
        if (wareId == "" || wareId == undefined) {
            continue;
        }
        var xsTp = trList.eq(i).find("select[name='xstp']").val();
        var rebatePrice = trList.eq(i).find("input[name='rebatePrice']").val();
        var qty = trList.eq(i).find("input[name='edtqty']").val();
        var beUnit = trList.eq(i).find("select[name='beUnit']").val();
        var price = trList.eq(i).find("input[name='edtprice']").val();
        var hsNum = trList.eq(i).find("input[name='hsNum']").val();
        var productDate = trList.eq(i).find("input[name='productDate']").val();
        var unit = trList.eq(i).find("select[name='beUnit'] option:selected").text();
        var activeDate = trList.eq(i).find("input[name='qualityDays']").val();
        var remarks = trList.eq(i).find("input[name='edtRemarks']").val();
        var sswId = trList.eq(i).find("input[name='sswId']").val();
        var helpQty = trList.eq(i).find("input[name='helpQty']").val();
        var helpUnit = trList.eq(i).find("input[name='helpUnit']").val();
        var checkWare = trList.eq(i).find("input[name='checkWare']").val();
        var empType = $("#empType").val();
        if (beUnit == "") {
            $.messager.alert('消息', '请选择单位！', 'info');
            return;
        }
        if (qty == "") {
            $.messager.alert('消息', '第' + (i + 1) + '行，请输入数量', 'info');
            return;
        }
        if (wareId == 0) continue;
        var subObj = {
            wareId: wareId,
            xsTp: xsTp,
            qty: qty,
            outQty: qty,
            unitName: unit,
            price: price,
            productDate: productDate,
            activeDate: activeDate,
            remarks: remarks,
            hsNum: hsNum,
            beUnit: beUnit,
            sswId: sswId,
            rebatePrice: rebatePrice,
            helpQty: helpQty,
            helpUnit: helpUnit,
            checkWare: checkWare
        };
        wareList.push(subObj);
    }
    if (wareList.length == 0) {
        $.messager.alert('消息', '请选择商品', 'info');
        return;
    }
    if (stkId == 0) {
        $.messager.alert('消息', '请选择仓库', 'info');
        return;
    }
    if (cstId == 0 && xsfpQuickBill == 'none') {
        //alert("请选择客户");
        $.messager.alert('消息', '请选择客户', 'info');
        return;
    }
    khNm = $.trim(khNm);
    if (khNm == "") {
        $.messager.alert('消息', '请选择客户', 'info');
        return;
    }
    var token = $("#tmptoken").val();
    $.ajaxSettings.async = false;
    var bool = checkSubmitData();
    if (bool) {
        $.messager.confirm('确认', '是否确定保存?', function (r) {
            if (r) {
                $.ajax({
                    url: "checkStorageWare",
                    type: "POST",
                    data: {"token": token, "stkId": stkId, "wareStr": JSON.stringify(wareList)},
                    dataType: 'json',
                    async: false,
                    success: function (json) {
                        if (!json.state) {
                            alert(json.msg);
                        }
                        removeWareStockTip();
                        if (json != undefined && json.state) {
                            var stockIds = json.stockIds;
                            if (stockIds != "" && AUTO_CREATE_FHD == '' && NEW_STOCK_CAL == 'none') {
                                if (window.confirm("因以下商品库存不足:" + stockIds + ",是否先暂存!")) {
                                    data = {
                                        "token": token,
                                        "id": billId,
                                        "transportName": transportName,
                                        "transportCode": transportCode,
                                        "autoCreateFhd": autoCreateFhd,
                                        "checkAutoPrice": checkAutoPrice,
                                        "changeOrderPrice": changeOrderPrice,
                                        "checkCustomerPrice": checkCustomerPrice,
                                        "empType":empType,
                                        "status": -2,
                                        "cstId": cstId,
                                        "driverId": driverId,
                                        "vehId": vehId,
                                        "staff": staff,
                                        "empId": empId,
                                        "staffTel": stafftel,
                                        "shr": shr,
                                        "khNm": khNm,
                                        "proType": proType,
                                        "stkId": stkId,
                                        "tel": tel,
                                        "address": address,
                                        "discount": discount,
                                        "remarks": remarks1,
                                        "orderId": orderId,
                                        "outDate": outTime,
                                        "outType": "销售出库",
                                        "pszd": pszd,
                                        "epCustomerId": epCustomerId,
                                        "epCustomerName": epCustomerName,
                                        "saleType": saleType,
                                        "wareStr": JSON.stringify(wareList)
                                    };
                                    var path = "draftSaveStkOut";
                                    confirmDragData(data, path);
                                    isModify = false;
                                }
                                return;
                            }

                            if (json.changeWareIds != "") {
                                if (window.confirm("因以下无库存商品未设采购价:" + json.msg2 + "  是否去设置")) {
                                    showUpdateCgWares(json.changeWareIds);
                                    return;
                                }
                            }
                            var flag = 1;
                            if (json.msg != "") {
                                $.messager.confirm('确认', json.msg + '是否继续?', function (s) {
                                        if (s) {
                                            data = {
                                                "token": token,
                                                "id": billId,
                                                "transportName": transportName,
                                                "transportCode": transportCode,
                                                "autoCreateFhd": autoCreateFhd,
                                                "checkAutoPrice": checkAutoPrice,
                                                "changeOrderPrice": changeOrderPrice,
                                                "checkCustomerPrice": checkCustomerPrice,
                                                "empType":empType,
                                                "cstId": cstId,
                                                "driverId": driverId,
                                                "vehId": vehId,
                                                "staff": staff,
                                                "empId": empId,
                                                "staffTel": stafftel,
                                                "shr": shr,
                                                "khNm": khNm,
                                                "proType": proType,
                                                "stkId": stkId,
                                                "tel": tel,
                                                "address": address,
                                                "discount": discount,
                                                "remarks": remarks1,
                                                "orderId": orderId,
                                                "outDate": outTime,
                                                "outType": "销售出库",
                                                "pszd": pszd,
                                                "epCustomerId": epCustomerId,
                                                "epCustomerName": epCustomerName,
                                                "saleType": saleType,
                                                "wareStr": JSON.stringify(wareList)
                                            };
                                            var path = "addStkOut";
                                            confirmData(data, path);
                                            setWareStockTip(json.wareIds);
                                            return;
                                        }
                                    }
                                )

                            } else {
                                data = {
                                    "token": token,
                                    "id": billId,
                                    "transportName": transportName,
                                    "transportCode": transportCode,
                                    "autoCreateFhd": autoCreateFhd,
                                    "checkAutoPrice": checkAutoPrice,
                                    "changeOrderPrice": changeOrderPrice,
                                    "checkCustomerPrice": checkCustomerPrice,
                                    "empType":empType,
                                    "cstId": cstId,
                                    "staff": staff,
                                    "empId": empId,
                                    "driverId": driverId,
                                    "vehId": vehId,
                                    "staffTel": stafftel,
                                    "shr": shr,
                                    "khNm": khNm,
                                    "proType": proType,
                                    "stkId": stkId,
                                    "tel": tel,
                                    "address": address,
                                    "discount": discount,
                                    "remarks": remarks1,
                                    "orderId": orderId,
                                    "outDate": outTime,
                                    "outType": "销售出库",
                                    "pszd": pszd,
                                    "epCustomerId": epCustomerId,
                                    "epCustomerName": epCustomerName,
                                    "saleType": saleType,
                                    "wareStr": JSON.stringify(wareList)
                                };
                                var path = "addStkOut";
                                confirmData(data, path);
                            }
                        } else {
                            data = {
                                "token": token,
                                "id": billId,
                                "transportName": transportName,
                                "transportCode": transportCode,
                                "autoCreateFhd": autoCreateFhd,
                                "checkAutoPrice": checkAutoPrice,
                                "changeOrderPrice": changeOrderPrice,
                                "checkCustomerPrice": checkCustomerPrice,
                                "empType":empType,
                                "cstId": cstId,
                                "staff": staff,
                                "empId": empId,
                                "driverId": driverId,
                                "vehId": vehId,
                                "staffTel": stafftel,
                                "shr": shr,
                                "khNm": khNm,
                                "proType": proType,
                                "stkId": stkId,
                                "tel": tel,
                                "address": address,
                                "discount": discount,
                                "remarks": remarks1,
                                "orderId": orderId,
                                "outDate": outTime,
                                "outType": "销售出库",
                                "pszd": pszd,
                                "epCustomerId": epCustomerId,
                                "epCustomerName": epCustomerName,
                                "saleType": saleType,
                                "wareStr": JSON.stringify(wareList)
                            };
                            var path = "addStkOut";
                            confirmData(data, path);
                        }
                    }
                });
            }
        });
    }
}

function confirmData(data, path) {
    $.ajax({
        url: path,
        type: "POST",
        data: data,
        dataType: 'json',
        async: false,
        success: function (json) {
            if (json.state) {
                $("#billId").val(json.id);
                $("#status").val(0);
                $("#billNo").val(json.billNo);
                $("#billstatus").val("提交成功");
                alert(json.msg);
                $("#btndraft").hide();
                $("#btndraftaudit").hide();
                $("#btnsave").hide();
                $("#btnprint").show();
                $("#btncancel").show();
                $("#btnaudit").show();
                $("#btndraftpost").hide();
                if (json.autoSend == 1) {
                    $("#btnaudit").hide();
                }
                statuschg(0);
            } else {
                alert(json.msg);
            }
        }
    });
}


function draftSaveStk() {
    var status = $("#status").val();
    if (status == 0) {
        $.messager.alert('消息', '该单据已审批,不能暂存!', 'info');
    }
    var cstId = $("#cstId").val();
    var billId = $("#billId").val();
    //var khNm = $("#pc_lib").text();
    // var khNm =   $('#cstIdComb').combobox('getText')+"";
    // var khId =  $('#cstIdComb').combobox('getText')+"";
    var khNm = $("#khNm").val();
    if (cstId == "") {
        cstId = 0;
    }
    var stkId = $("#stkId").val();
    var tel = $("#csttel").val();
    var address = $("#cstaddress").val();
    var remarks1 = $("#remarks").val();
    var orderId = $("#orderId").val();
    var outTime = $("#outDate").val();
    var shr = khNm
    var staff = $("#staff").text();
    var stafftel = $("#stafftel").val();
    var empId = $("#empId").val();
    var proType = $("#proType").val();
    var driverId = $("#driverId").val();
    var vehId = $("#vehId").val();
    var saleType = $("#saleType").val();
    var transportName = $("#transportName").val();
    var transportCode = $("#transportCode").val();
    var empType = $("#empType").val();
    if (proType == undefined || proType == "") {
        proType = 2;
    }
    //alert(outTime);
    if (staff == "" && xsfpQuickBill == 'none') {
        $.messager.alert('消息', '请选择业务员', 'info');
        return;
    }
    var epCustomerId = $("#epCustomerId").val();
    var epCustomerName = $("#epCustomerName").val();
    var pszd = $("#pszd").val();
    if (pszd != "公司直送" && epCustomerId == "") {
        //alert("当配送指定为【直供转单二批】时，请选择二批客户");
        $.messager.alert('消息', '当配送指定为【直供转单二批】时，请选择二批客户', 'info');
    }
    var checkAutoPrice = 0;//未选中
    if ($('#wareXsPrice').attr('checked')) {
        checkAutoPrice = 1;
    }

    //判断客户对应商品价是否同步到客户执行价
    var checkCustomerPrice = 0;
    if ($('#wareCustomerPrice').attr('checked')) {
        checkCustomerPrice = 1;
    }

    var discount = $("#discount").val();
    var wareList = new Array();
    var trList = $("#chooselist").children("tr");
    for (var i = 0; i < trList.length; i++) {
        var tdArr = trList.eq(i).find("td");
        var wareId = trList.eq(i).find("input[name='wareId']").val();
        if (wareId == "" || wareId == undefined) {
            continue;
        }
        var xsTp = trList.eq(i).find("select[name='xstp']").val();
        var rebatePrice = trList.eq(i).find("input[name='rebatePrice']").val();
        var qty = trList.eq(i).find("input[name='edtqty']").val();
        var beUnit = trList.eq(i).find("select[name='beUnit']").val();
        var price = trList.eq(i).find("input[name='edtprice']").val();
        var hsNum = trList.eq(i).find("input[name='hsNum']").val();
        var productDate = trList.eq(i).find("input[name='productDate']").val();
        var unit = trList.eq(i).find("select[name='beUnit'] option:selected").text();
        var activeDate = trList.eq(i).find("input[name='qualityDays']").val();
        var remarks = trList.eq(i).find("input[name='edtRemarks']").val();
        var sswId = trList.eq(i).find("input[name='sswId']").val();
        var helpQty = trList.eq(i).find("input[name='helpQty']").val();
        var helpUnit = trList.eq(i).find("input[name='helpUnit']").val();
        var checkWare = trList.eq(i).find("input[name='checkWare']").val();
        if (beUnit == "") {
            $.messager.alert('消息', '请选择单位！', 'info');
            return;
        }
        if (qty == "") {
            $.messager.alert('消息', '第' + (i + 1) + '行，请输入数量', 'info');
            return;
        }
        if (wareId == 0) continue;
        var subObj = {
            wareId: wareId,
            xsTp: xsTp,
            qty: qty,
            outQty: qty,
            unitName: unit,
            price: price,
            productDate: productDate,
            activeDate: activeDate,
            remarks: remarks,
            hsNum: hsNum,
            beUnit: beUnit,
            sswId: sswId,
            rebatePrice: rebatePrice,
            helpQty: helpQty,
            helpUnit: helpUnit,
            checkWare: checkWare
        };
        wareList.push(subObj);
    }
    if (wareList.length == 0) {
        $.messager.alert('消息', '请选择商品', 'info');
        return;
    }

    if (stkId == 0) {
        //alert("请选择仓库");
        $.messager.alert('消息', '请选择仓库', 'info');
        return;
    }
    if (cstId == 0 && xsfpQuickBill == 'none') {
        //alert("请选择客户");
        $.messager.alert('消息', '请选择客户', 'info');
        return;
    }
    khNm = $.trim(khNm);
    if (khNm == "") {
        //alert("请选择仓库");
        $.messager.alert('消息', '请选择客户', 'info');
        return;
    }

    $.ajaxSettings.async = false;
    var bool = true;
    if (productDateConfig == '') {
        bool = checkSubmitData();
    }
    if (bool) {
        var token = $("#tmptoken").val();
        $.messager.confirm('确认', '是否确定暂存?', function (r) {
            if (r) {
                $.ajax({
                    url: "checkStorageWare",
                    type: "POST",
                    data: {"token": token, "stkId": stkId, "wareStr": JSON.stringify(wareList)},
                    dataType: 'json',
                    async: false,
                    success: function (json) {
                        isModify = false;
                        removeWareStockTip();
                        if (json != undefined && json.state) {
                            var flag = 1;
                            if (json.msg != "") {
                                $.messager.confirm('确认', json.msg + '是否继续?', function (s) {
                                        setWareStockTip(json.wareIds);
                                        if (s) {
                                            data = {
                                                "token": token,
                                                "id": billId,
                                                "transportName": transportName,
                                                "transportCode": transportCode,
                                                "checkAutoPrice": checkAutoPrice,
                                                "checkCustomerPrice": checkCustomerPrice,
                                                "status": status,
                                                "driverId": driverId,
                                                "vehId": vehId,
                                                "cstId": cstId,
                                                "staff": staff,
                                                "empId": empId,
                                                "empType":empType,
                                                "staffTel": stafftel,
                                                "shr": shr,
                                                "khNm": khNm,
                                                "proType": proType,
                                                "stkId": stkId,
                                                "tel": tel,
                                                "address": address,
                                                "discount": discount,
                                                "remarks": remarks1,
                                                "orderId": orderId,
                                                "outDate": outTime,
                                                "outType": "销售出库",
                                                "pszd": pszd,
                                                "epCustomerId": epCustomerId,
                                                "epCustomerName": epCustomerName,
                                                "saleType": saleType,
                                                "wareStr": JSON.stringify(wareList)
                                            };
                                            var path = "draftSaveStkOut";
                                            confirmDragData(data, path);
                                            return;
                                        }
                                    }
                                )

                            } else {
                                data = {
                                    "token": token,
                                    "id": billId,
                                    "transportName": transportName,
                                    "transportCode": transportCode,
                                    "checkAutoPrice": checkAutoPrice,
                                    "checkCustomerPrice": checkCustomerPrice,
                                    "status": status,
                                    "cstId": cstId,
                                    "driverId": driverId,
                                    "vehId": vehId,
                                    "staff": staff,
                                    "empId": empId,
                                    "staffTel": stafftel,
                                    "shr": shr,
                                    "khNm": khNm,
                                    "proType": proType,
                                    "empType":empType,
                                    "stkId": stkId,
                                    "tel": tel,
                                    "address": address,
                                    "discount": discount,
                                    "remarks": remarks1,
                                    "orderId": orderId,
                                    "outDate": outTime,
                                    "outType": "销售出库",
                                    "pszd": pszd,
                                    "epCustomerId": epCustomerId,
                                    "epCustomerName": epCustomerName,
                                    "saleType": saleType,
                                    "wareStr": JSON.stringify(wareList)
                                };
                                var path = "draftSaveStkOut";
                                confirmDragData(data, path);
                            }
                        } else {
                            data = {
                                "token": token,
                                "id": billId,
                                "transportName": transportName,
                                "transportCode": transportCode,
                                "checkAutoPrice": checkAutoPrice,
                                "checkCustomerPrice": checkCustomerPrice,
                                "status": status,
                                "cstId": cstId,
                                "driverId": driverId,
                                "vehId": vehId,
                                "staff": staff,
                                "empId": empId,
                                "empType":empType,
                                "staffTel": stafftel,
                                "shr": shr,
                                "khNm": khNm,
                                "proType": proType,
                                "stkId": stkId,
                                "tel": tel,
                                "address": address,
                                "discount": discount,
                                "remarks": remarks1,
                                "orderId": orderId,
                                "outDate": outTime,
                                "outType": "销售出库",
                                "pszd": pszd,
                                "epCustomerId": epCustomerId,
                                "epCustomerName": epCustomerName,
                                "saleType": saleType,
                                "wareStr": JSON.stringify(wareList)
                            };
                            var path = "draftSaveStkOut";
                            confirmDragData(data, path);
                        }
                    }
                });
            }
        });
    }
}

function setWareStockTip(wareIds) {
    $("#more_list tbody input[name$='wareId']").each(function () {
        var wareId = "$" + $(this).val() + "$";
        if (wareIds.indexOf(wareId) != -1) {
            var currRow = this.parentNode.parentNode;
            $(currRow).attr("class", "ware_stock_tip");
        }
    });
}


function removeWareStockTip() {
    $("#more_list tbody input[name$='wareId']").each(function () {
        var currRow = this.parentNode.parentNode;
        $(currRow).removeClass("ware_stock_tip");
    });
}

function confirmDragData(data, path) {
    $.ajax({
        url: path,
        type: "POST",
        data: data,
        dataType: 'json',
        async: false,
        success: function (json) {
            if (json.state) {
                $("#billId").val(json.id);
                $("#billNo").val(json.billNo);
                $("#btnsave").hide();
                $("#btndraftaudit").show();
                $("#btnprint").show();
                $("#btncancel").show();
                $("#btnaudit").hide();
                $("#btndraftpost").show();
                $("#billstatus").val("暂存成功");
                var snpashotId = $('#snapshotId').val();
                if(snpashotId) {
                    removeSnapshot(snpashotId);
                    $('#snapshotId').val('');
                }
            }
        }
    });
}

function printClick() {
    /*if(editstatus != 0)
		{
		  //alert("请先保存");
		  $.messager.alert('消息','请先保存','info');
		  return;
		}*/
    var status = $("#status").val();
    if (status == 2) {
        //alert("单据已经作废");
        $.messager.alert('消息', '单据已经作废', 'info');
        return;
    }
    var billId = $("#billId").val();
    if (billId == 0) {
        $.messager.alert('消息', '没有可打印的单据', 'info');
        return;
    }
    if (status == -2 && isModify) {
        $.messager.alert('消息', '单据已修改，请先暂存', 'info');
        return;
    }
    window.location.href = 'showstkoutprint?fromFlag=0&billId=' + billId;
}


function auditDraftStkOut() {
    var billId = $("#billId").val();
    var status = $("#status").val();

    var changeOrderPrice = 0;
    if ($("#changeOrderPrice").is(":checked") == true) {
        changeOrderPrice = 1;
    }

    if (status == 0) {
        $.messager.alert('消息', '该单据已审批!', 'info');
    }
    if (billId == 0 || status != -2) {
        $.messager.alert('消息', '没有可审核的单据', 'info');
        return;
    }
    if (isModify) {
        $.messager.alert('消息', '单据已修改，请先暂存', 'info');
        return;
    }
    var stkId = $("#stkId").val();
    var wareList = new Array();
    var trList = $("#chooselist").children("tr");
    for (var i = 0; i < trList.length; i++) {
        var tdArr = trList.eq(i).find("td");
        var wareId = trList.eq(i).find("input[name='wareId']").val();
        if (wareId == "" || wareId == undefined) {
            break;
        }
        var xsTp = trList.eq(i).find("select[name='xstp']").val();
        var rebatePrice = trList.eq(i).find("input[name='rebatePrice']").val();
        var qty = trList.eq(i).find("input[name='edtqty']").val();
        var beUnit = trList.eq(i).find("select[name='beUnit']").val();
        var price = trList.eq(i).find("input[name='edtprice']").val();
        var hsNum = trList.eq(i).find("input[name='hsNum']").val();
        var productDate = trList.eq(i).find("input[name='productDate']").val();
        var unit = trList.eq(i).find("select[name='beUnit'] option:selected").text();
        var activeDate = trList.eq(i).find("input[name='qualityDays']").val();
        var remarks = trList.eq(i).find("input[name='edtRemarks']").val();
        var sswId = trList.eq(i).find("input[name='sswId']").val();
        var helpQty = trList.eq(i).find("input[name='helpQty']").val();
        var helpUnit = trList.eq(i).find("input[name='helpUnit']").val();
        var checkWare = trList.eq(i).find("input[name='checkWare']").val();
        if (beUnit == "") {
            //alert("请选择单位！");
            $.messager.alert('消息', '请选择单位！', 'info');
            return;
        }
        if (qty == "") break;
        if (wareId == 0) continue;
        var subObj = {
            wareId: wareId,
            xsTp: xsTp,
            qty: qty,
            outQty: qty,
            unitName: unit,
            price: price,
            productDate: productDate,
            activeDate: activeDate,
            remarks: remarks,
            hsNum: hsNum,
            beUnit: beUnit,
            sswId: sswId,
            rebatePrice: rebatePrice,
            helpQty: helpQty,
            helpUnit: helpUnit
        };
        wareList.push(subObj);
    }

    $.messager.confirm('确认', '是否确定审核?', function (r) {
        var token = $("#tmptoken").val();
        if (r) {
            $.ajax({
                url: "checkStorageWare",
                type: "POST",
                data: {"token": token, "stkId": stkId, "wareStr": JSON.stringify(wareList)},
                dataType: 'json',
                async: false,
                success: function (json) {
                    removeWareStockTip();
                    if (json != undefined && json.state) {
                        var stockIds = json.stockIds;
                        if (stockIds && stockIds != "" && AUTO_CREATE_FHD == '' && NEW_STOCK_CAL == 'none') {
                            alert("因以下商品库存不足:" + stockIds + ",不允许审批!");
                            return;
                        }

                        if (json.changeWareIds != "") {
                            if (window.confirm("因以下无库存商品未设采购价:" + json.msg2 + "  是否去设置")) {
                                showUpdateCgWares(json.changeWareIds);
                                return;
                            }
                        }
                        var flag = 1;
                        if (json.msg != "") {
                            $.messager.confirm('确认', json.msg + '是否继续?', function (s) {
                                if (s) {
                                    auditBill(billId, changeOrderPrice);
                                }
                                setWareStockTip(json.wareIds);
                            })
                        } else {
                            auditBill(billId, changeOrderPrice);
                        }
                    } else {
                        auditBill(billId, changeOrderPrice);
                    }
                }
            });
        }
    });
}

function auditBill(billId, changeOrderPrice) {
    var path = "auditDraftStkOut";
    var autoCreateFhd = 1;
    if ($('#autoCreateFhd').val() != undefined && $("#autoCreateFhd").is(":checked") == true) {
        autoCreateFhd = 0;
    }
    $.ajax({
        url: path,
        type: "POST",
        data: {"token": "", "billId": billId, "autoCreateFhd": autoCreateFhd, "changeOrderPrice": changeOrderPrice},
        dataType: 'json',
        async: false,
        success: function (json) {
            if (json.state) {
                alert(json.msg);
                $("#billstatus").val(json.msg);
                $("#status").val(0);
                $("#btndraft").hide();
                $("#btndraftaudit").hide();
                $("#btnsave").hide();
                $("#btnprint").show();
                $("#btncancel").show();
                $("#btnaudit").show();
                $("#btndraftpost").hide();
                if (json.autoSend == 1) {
                    $("#btnaudit").hide();
                }
                statuschg(0);
            } else {
                $.messager.alert('消息', '审核失败', 'info');
            }
        }
    });
}

function postAccDialog() {
    $('#accDlg').dialog('open');
}

function postDraftStkOut() {
    var billId = $("#billId").val();
    var status = $("#status").val();
    if (status == 0) {
        $.messager.alert('消息', '该单据已审批!', 'info');
    }
    if (billId == 0 || status != -2) {
        $.messager.alert('消息', '没有可过账的单据', 'info');
        return;
    }

    if (isModify) {
        $.messager.alert('消息', '单据已修改，请先暂存', 'info');
        return;
    }

    var accId = $("#accId").val();
    $.messager.confirm('确认', '是否确定一键过账?', function (r) {
        if (r) {
            var path = "postDraftStkOut";
            $.ajax({
                url: path,
                type: "POST",
                data: {"token": "", "accId": accId, "billId": billId},
                dataType: 'json',
                async: false,
                success: function (json) {
                    if (json.state) {
                        $("#billstatus").val(json.msg);
                        $("#status").val(0);
                        $("#btndraft").hide();
                        $("#btndraftaudit").hide();
                        $("#btnsave").hide();
                        $("#btnprint").show();
                        $("#btncancel").show();
                        $("#btnaudit").show();
                        statuschg(0);
                        if ("一键过账成功" == json.msg) {
                            $("#paystatus").val("已结清");
                        }
                        $.messager.alert('消息', json.msg, 'info');
                    } else {
                        $.messager.alert('消息', '一键过账失败', 'info');
                    }
                    $('#accDlg').dialog('close');
                }
            });
        }
    });
}


function cancelProc() {
    var billId = $("#billId").val();
    if (billId == 0) {
        //alert("没有可作废的单据");
        $.messager.alert('消息', '没有可作废的单据', 'info');
        return;
    }
    if (!confirm('确定作废？')) return;
    var path = "cancelStkOut";
    $.ajax({
        url: path,
        type: "POST",
        data: {"token": "", "billId": billId},
        dataType: 'json',
        async: false,
        success: function (json) {
            if (json.state) {
                $("#billstatus").val("作废");
            } else {
                $.messager.alert('消息', '作废失败', 'info');
            }
        }
    });
}

function querydepart() {

    var path = "queryStkDepart";
    var token = $("#tmptoken").val();
    //alert(token);
    $.ajax({
        url: path,
        type: "POST",
        data: {"dataTp": "1"},
        dataType: 'json',
        async: false,
        success: function (json) {
            if (json == null) {
                return;
            }
            if (json.state) {

                var size = json.list.length;
                var text = "";
                var firstId = 0;
                for (var i = 0; i < size; i++) {
                    if (firstId == 0 && json.list[i].ischild == "2") firstId = json.list[i].branchId;
                    if (json.list[i].ischild == "0") continue;
                    text += makeDepartTree(json.list, json.list[i]);

                }


                $("#departTree").html(text);
                if (firstId != 0) queryMember(firstId);
            }
        }
    });
}

function makeDepartTree(departList, obj) {
    if (obj.ischild == "2")//没有子部门
    {
        var retStr = "<a href='javascript:queryMember(" + obj.branchId + ");'>" + obj.branchName + "</a>";
        obj.ischild = 0;
        return retStr;
    }
    if (obj.ischild == "1") {
        var retStr = "<div class='pcl_infinite'>";
        retStr += "<p><i></i>" + obj.branchName + "</p>";
        retStr += "<div class='pcl_file'>";
        obj.ischild = 0;
        for (var i = 0; i < departList.length; i++) {
            if (departList[i].parentId == obj.branchId) {

                retStr += makeDepartTree(departList, departList[i]);
            }
        }
        retStr += "</div>";
        retStr += "</div>";
        return retStr;

    }
    return "";
}

function queryMember(branchId) {

    var path = "stkMemberPage";
    var token = $("#tmptoken").val();
    //alert(token);
    $.ajax({
        url: path,
        type: "POST",
        data: {"token": token, "page": 1, "rows": 50, "branchId": branchId},
        dataType: 'json',
        async: false,
        success: function (json) {
            if (json.state) {
                displayMember(json);

            }
        }
    });
}

function getMemberInfo(memberId) {
    if (memberId == "") {
        $("#staff").html("");
        $("#empId").val("");
        $("#stafftel").val("");
        return;
    }
    var path = "getMemberInfo";
    var token = $("#tmptoken").val();
    $.ajax({
        url: path,
        type: "POST",
        data: {"token": token, "memberId": memberId},
        dataType: 'json',
        async: false,
        success: function (json) {
            if (json.state != undefined && json.state) {
                $("#staff").html(json.member.memberNm);
                $("#empId").val(json.member.memberId);
                $("#stafftel").val(json.member.memberMobile);
            } else {
                $("#staff").html("");
                $("#empId").val("");
                $("#stafftel").val("");
            }
        }
    });
}

function queryMemberByName(memberNm) {
    var path = "stkMemberPage";
    var token = $("#tmptoken").val();
    //alert(token);
    $.ajax({
        url: path,
        type: "POST",
        data: {"token": token, "page": 1, "rows": 50, "memberNm": memberNm},
        dataType: 'json',
        async: false,
        success: function (json) {
            if (json.state) {
                displayMember(json);

            }
        }
    });
}

function displayMember(json) {
    var size = json.rows.length;
    var text = "";
    for (var i = 0; i < size; i++) {
        text += "<tr onclick=\"memberClick(this)\">";
        text += "<td>" + json.rows[i].memberNm + "<input  type=\"hidden\" name=\"memberId\" value=\"" + json.rows[i].memberId + "\"/></td>	";

        text += "<td>" + json.rows[i].memberMobile + "</td>";


        text += "</tr>";

    }
    $("#memberList").html(text);
}

function reAudit() {

    var billId = $("#billId").val();
    if (billId == 0) {
        alert("没有可反审批的单据");
        return;
    }
    var billStatus = $("#status").val();
    if (billStatus == 2) {
        alert("该单据已作废");
        return;
    }
    if (!confirm('确定反审批？')) return;
    var path = "reAuditStkOut";

    $.ajax({
        url: path,
        type: "POST",
        data: {"token": "", "billId": billId},
        dataType: 'json',
        async: false,
        success: function (json) {
            if (json.state) {
                alert("反审批成功");
                window.location.href = "showstkout?billId=" + billId;
            } else {
                alert("反审批失败" + json.msg);
            }
        }
    });
}

function memberClick(trobj) {
    var tel = $(trobj.cells[1]).text();
    var memberNm = $(trobj.cells[0]).text();
    var memberId = $(trobj).find("input[name='memberId']").val();
    $("#staff").html(memberNm);
    $("#stafftel").val(tel);
    $("#empId").val(memberId);
    $(".pcl_chose_people").hide();
    isModify = true;
}

function cancelClick() {

    var billId = $("#billId").val();
    if (billId == 0) {
        //alert("没有可作废的单据");
        $.messager.alert('消息', '没有可作废的单据', 'info');
        return;
    }
    var billStatus = $("#status").val();
    if (billStatus == 2) {
        // alert("该单据已经作废");
        $.messager.alert('消息', '该单据已经作废', 'info');
        return;
    }
    if (!confirm('确定作废？')) return;
    var path = "cancelStkOut";
    $.ajax({
        url: path,
        type: "POST",
        data: {"token": "", "billId": billId},
        dataType: 'json',
        async: false,
        success: function (json) {
            if (json.state) {
                //alert("作废成功");
                $("#billstatus").val("作废");
                $("#status").val(2);
                $("#btndraft").hide();
                $("#btndraftaudit").hide();
                $("#btnsave").hide();
                $("#btnprint").show();
            } else {
                $.messager.alert('消息', '作废失败' + json.msg, 'info');
                alert("作废失败" + json.msg);
            }
        }
    });
}

function changeUnit(o) {

    var row = $(o).closest('tr')
    var hsNum = $(row).find("input[name='hsNum']").val();
    var bePrice = $(row).find("input[name='edtprice']").val();
    var k = o.selectedIndex;
    bePrice = bePrice == '' ? 0 : bePrice;
    hsNum = hsNum == '' ? 1 : hsNum;
    var tempAmt = 0;
    if (o.value == 'B') {//包装单位
        //tempAmt = bePrice*hsNum;
        tempAmt = parseFloat($(row).find("input[name='bUnitPrice']").val());
        tempAmt = tempAmt.toFixed(5);
        tempAmt = parseFloat(tempAmt);
        var str = tempAmt + "";
        if (str.indexOf(".") != -1) {
            var nums = str.split(".");
            var num1 = nums[0];
            var num2 = nums[1];
            if (num2.length > 2) {
                var p = num2.substring(0, 2);
                var p0 = parseFloat("0." + num2) - parseFloat("0." + p);
                if (parseFloat(p0) < parseFloat(0.001)) {
                    if (parseFloat(num1) > parseFloat(0)) {
                        tempAmt = parseFloat(num1) + parseFloat("0." + num2);
                    } else {
                        tempAmt = tempAmt.toFixed(2);
                    }
                }
            }
        }
        $(row).find("input[name='edtprice']").val(tempAmt);
        $(row).find("input[name='unitName']").val(o.options[k].text);
    }
    if (o.value == 'S') {//计量单位
        tempAmt = bePrice / hsNum;
        tempAmt = parseFloat(tempAmt);
        var isSUnitPrice = $("#isSUnitPrice").val();
        if (isSUnitPrice == 1) {
            var sunitPrice = $(row).find("input[name='sunitPrice']").val();
            if (0 + sunitPrice > 0) tempAmt = parseFloat(sunitPrice);
        }
        tempAmt = tempAmt.toFixed(5);
        tempAmt = parseFloat(tempAmt);
        var str = tempAmt + "";
        if (str.indexOf(".") != -1) {
            var nums = str.split(".");
            var num1 = nums[0];
            var num2 = nums[1];
            if (num2.length > 2) {
                var p = num2.substring(0, 2);
                var p0 = parseFloat("0." + num2) - parseFloat("0." + p);
                if (parseFloat(p0) < parseFloat(0.001)) {
                    if (parseFloat(num1) > parseFloat(0)) {
                        tempAmt = parseFloat(num1);
                    } else {
                        tempAmt = tempAmt.toFixed(2);
                    }
                }
            }
        }
        $(row).find("input[name='edtprice']").val(tempAmt);
        $(row).find("input[name='unitName']").val(o.options[k].text);
    }
    countAmt();
}

function chkbox(obj) {
    var chkbox = document.getElementsByName("chkbox");
    for (var i = 0; i < chkbox.length; i++) {
        chkbox[i].checked = obj.checked;
    }
}


function checkOnClick(check1) {
    if ($("#check1").is(":checked") != true) {
        $("#more_list tbody tr").css("background", "#fff");
        moveRow = 0;
        chooseNoList.length = 0;
        $("#more_list #chooselist input[name$='checkWare']").each(function () {
            $(this).val("0");
        });
    }
}

function checkWareNo(wareNo) {

    var trList = $("#chooselist").children("tr");
    var flag = 0;
    for (var i = 0; i < trList.length; i++) {
        var tdArr = trList.eq(i).find("td");
        var tmpNo = trList.eq(i).find("input[name='wareCode']").val();
        var tmpName = trList.eq(i).find("input[name='wareNm']").val();
        tmpNo = tmpNo.replace(/\s+/g, ""); //去空格
        if (tmpNo == wareNo || wareNo == tmpName) {
            chooseNoList.push(wareNo);
            testMove(i);
            flag = flag + 1;
            trList.eq(i).css("background", "skyblue");
            trList.eq(i).find("input[name$='checkWare']").val(1);
        }
    }
    return flag;
}

function IsInList(wareNo) {
    for (var i = 0; i < chooseNoList.length; i++) {
        if ("" + chooseNoList[i] == wareNo) return true;
    }
    return false;
}

function testMove(index) {
    var len = $("#more_list tbody").find("tr").length;
    if (len <= 1) return;

    if (moveRow == len - 1) return;

    if (moveRow == index) {
        moveRow = moveRow + 1;
        return;
    }
    if (moveRow == 0)
        $("#more_list tbody tr:eq(" + index + ")").insertBefore($("#more_list tbody tr:eq(0)"));//insertAfter
    else {
        $("#more_list tbody tr:eq(" + index + ")").insertBefore($("#more_list tbody tr:eq(" + moveRow + ")"));
    }
    moveRow = moveRow + 1;
    len = $("#more_list").find("tr").length;  //#tb为Table的id  获取所有行
    for (var i = 1; i < len; i++) {
        $("#more_list tr").eq(i).children("td").eq(0).html(i);  //给每行的第一列重写赋值
    }

}

function moveTr(t, oper) {
    if (oper == "MoveUp") {    //向上移动
        if ($(data_tr).prev().html() == null) { //获取tr的前一个相同等级的元素是否为空
            //alert("已经是最顶部了!");
            return;
        }
        {
            $(data_tr).insertBefore($(data_tr).prev()); //将本身插入到目标tr的前面
        }
    } else {
        if ($(data_tr).next().html() == null) {
            //alert("已经是最低部了!");
            return;
        }
        {
            $(data_tr).insertAfter($(data_tr).next()); //将本身插入到目标tr的后面
        }
    }
    var len = $("#more_list").find("tr").length;  //#tb为Table的id  获取所有行
    for (var i = 1; i < len; i++) {
        $("#more_list tr").eq(i).children("td").eq(0).html(i);  //给每行的第一列重写赋值
    }

}


function setWareCustomerHisPrice(wareId, oId) {
    var path = "querySaleCustomerHisWarePrice";
    var cstId = $("#cstId").val();
    if (cstId == "") {
        return;
    }
    if (wareId == "") {
        return;
    }
    $.ajax({
        url: path,
        type: "POST",
        data: {"cid": cstId, "wareId": wareId},
        dataType: 'json',
        async: false,
        success: function (json) {
            if (json.state) {

                var ware = document.getElementById(oId);
                var row = ware.parentNode.parentNode;
                var hsNum = $(row).find("input[name='hsNum']").val();
                var sunitPrice = $(row).find("input[name='sunitPrice']");
                var bUnitPrice = $(row).find("input[name='bUnitPrice']");
                if (hsNum == "" || hsNum == undefined || hsNum == 0) {
                    hsNum = 1;
                }
                // if(json.zxPrice!=undefined&&json.zxPrice!=''&&json.zxPrice!=null){
                // 	$("#"+oId).val(json.zxPrice);
                // 	$(bUnitPrice).val(json.zxPrice);
                // 	var bePrice = parseFloat(json.zxPrice);
                // 	var	tempPrice = bePrice/hsNum;
                // 	tempPrice = parseFloat(tempPrice);
                // 	tempPrice = tempPrice.toFixed(5);
                // 	tempPrice = parseFloat(tempPrice);
                // 	$(sunitPrice).val(tempPrice);
                // }
                if (json.zxPrice != undefined && json.zxPrice != '' && json.zxPrice != null && parseFloat(json.zxPrice) != 0) {
                    $("#" + oId).val(json.zxPrice);
                    $(bUnitPrice).val(json.zxPrice);
                    var bePrice = parseFloat(json.zxPrice);
                    var tempPrice = bePrice / hsNum;
                    tempPrice = parseFloat(tempPrice);
                    tempPrice = tempPrice.toFixed(5);
                    tempPrice = parseFloat(tempPrice);
                    if (json.minZxPrice == undefined || json.minZxPrice == '' || json.minZxPrice == null || parseFloat(json.minZxPrice) == 0) {
                        $(sunitPrice).val(tempPrice);
                    }
                }
                if (json.minZxPrice != undefined && json.minZxPrice != '' && json.minZxPrice != null && parseFloat(json.minZxPrice) != 0) {
                    $(sunitPrice).val(json.minZxPrice);
                    var bePrice = parseFloat(json.minZxPrice);
                    var tempPrice = parseFloat(bePrice) * parseFloat(hsNum);
                    tempPrice = parseFloat(tempPrice);
                    tempPrice = tempPrice.toFixed(5);
                    tempPrice = parseFloat(tempPrice);
                    if (json.zxPrice == undefined || json.zxPrice == '' || json.zxPrice == null || parseFloat(json.zxPrice) == 0) {
                        $(bUnitPrice).val(tempPrice);
                    }
                }
                if (json.hisPrice != 0 && json.hisPrice != "" && json.hisPrice != undefined) {
                    $("#" + oId).val(json.hisPrice);
                    $(bUnitPrice).val(json.hisPrice);
                    var bePrice = parseFloat(json.hisPrice);
                    var tempPrice = bePrice / hsNum;
                    tempPrice = parseFloat(tempPrice);
                    tempPrice = tempPrice.toFixed(5);
                    tempPrice = parseFloat(tempPrice);
                    $(sunitPrice).val(tempPrice);
                }
            }
        }
    });
}

/**
 * 设置客户的执行价
 * @param wareId
 * @param oId
 */
function setWareCustomerPrice(wareId, oId) {
    var path = "queryCustomerWarePrice";
    var cstId = $("#cstId").val();
    var proType = $("#proType").val();
    if (proType != 2) {
        return;
    }
    if (cstId == "") {
        return;
    }
    if (wareId == "") {
        return;
    }
    $.ajax({
        url: path,
        type: "POST",
        data: {"customerId": cstId, "wareId": wareId},
        dataType: 'json',
        async: false,
        success: function (json) {
            if (json.state) {
                var ware = document.getElementById(oId);
                var row = ware.parentNode.parentNode;
                var hsNum = $(row).find("input[name='hsNum']").val();
                var sunitPrice = $(row).find("input[name='sunitPrice']");
                var bUnitPrice = $(row).find("input[name='bUnitPrice']");
                if (hsNum == "" || hsNum == undefined || hsNum == 0) {
                    hsNum = 1;
                }
                if (json.zxPrice != undefined && json.zxPrice != '' && json.zxPrice != null && parseFloat(json.zxPrice) != 0) {
                    $("#" + oId).val(json.zxPrice);
                    $(bUnitPrice).val(json.zxPrice);
                    var bePrice = parseFloat(json.zxPrice);
                    var tempPrice = bePrice / hsNum;
                    tempPrice = parseFloat(tempPrice);
                    tempPrice = tempPrice.toFixed(5);
                    tempPrice = parseFloat(tempPrice);
                    if (json.minZxPrice == undefined || json.minZxPrice == '' || json.minZxPrice == null || parseFloat(json.minZxPrice) == 0) {
                        $(sunitPrice).val(tempPrice);
                    }
                }
                if (json.minZxPrice != undefined && json.minZxPrice != '' && json.minZxPrice != null && parseFloat(json.minZxPrice) != 0) {
                    $(sunitPrice).val(json.minZxPrice);
                    var bePrice = parseFloat(json.minZxPrice);
                    var tempPrice = parseFloat(bePrice) * parseFloat(hsNum);
                    tempPrice = parseFloat(tempPrice);
                    tempPrice = tempPrice.toFixed(5);
                    tempPrice = parseFloat(tempPrice);
                    if (json.zxPrice == undefined || json.zxPrice == '' || json.zxPrice == null || parseFloat(json.zxPrice) == 0) {
                        $(bUnitPrice).val(tempPrice);
                    }
                }
            }
        }
    });
}

/**
 * 默认全选
 * @param o
 */
function gjr_CellClick(o) {
    o.select();
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
function gjr_toNextCell(obj, field) {
    var v = window.event.keyCode;
    if (v == 13) {
        var currRow = $(obj).parents('tr');
        $(currRow).find("input[name='" + field + "']").focus();
        $(currRow).find("input[name='" + field + "']").select();
    }
}

function queryWareBarByWareParam(keyWord) {
    var cstId = $("#cstId").val();
    if (cstId == "" && xsfpQuickBill == 'none') {
        $.messager.alert('消息', '请先选择客户!', 'info');
        return;
    }
    var path = "queryStkWarePage1";
    stkId = $("#stkId").val();
    if (stkId == "") stkId = 0;
    $.ajax({
        url: path,
        type: "POST",
        data: {"keyWord": keyWord, "stkId": stkId, "status": 1, "customerId": cstId, "page": 1, "rows": 50},
        dataType: 'json',
        async: false,
        success: function (json) {
            if (json.state) {
                var size = json.list.length;
                var data = "";
                for (var i = 0; i < size; i++) {
                    data = {
                        "wareId": json.list[i].wareId,
                        "wareNm": json.list[i].wareNm,
                        "wareCode": json.list[i].wareCode,
                        "maxUnitCode": json.list[i].maxUnitCode,
                        "maxNm": json.list[i].wareDw,
                        "minUnitCode": json.list[i].minUnitCode,
                        "minNm": json.list[i].minUnit,
                        "hsNum": json.list[i].hsNum,
                        "wareDj": json.list[i].wareDj,
                        "stkQty": json.list[i].stkQty,
                        "qualityDays": json.list[i].qualityDays,
                        "sunitPrice": json.list[i].sunitPrice,
                        "productDate": json.list[i].productDate,
                        "sunitFront": json.list[i].sunitFront,
                        "wareGg": json.list[i].wareGg
                    };
                    break;
                }
                setTabRowData(data);
            } else {
                $.messager.alert('消息', '未找到该商品!', 'info');
                enCount = 0;
            }
        }
    });
}

function gjr_forAuto_toNextCell(obj, field) {
    var v = window.event.keyCode;
    inputCount = 0;
    if (obj.value == "") {
        if (v == 13) {
            return;
        }
    }
    if (v == 13) {
        enCount++;
        if (enCount > 1) {
            var currRow = $(obj).closest('tr');
            var currRowIndex = currRow.rowIndex;
            if (field == "beUnit" || field == "xstp") {
                $(currRow).find("select[name='" + field + "']").focus();
                $(currRow).find("select[name='" + field + "']").select();
            } else {
                $(currRow).find("input[name='" + field + "']").focus();
                $(currRow).find("input[name='" + field + "']").select();
            }
            enCount = 0;
            if (obj.value == "") {
                return;
            }
            var bool = checkSysWareByKeyWord(obj.value, 0);
            if (!bool) {
                clearTabRowData("");
                setTimeout(function () {
                    $(".messager-body").window('close');
                }, 1500);
                $(currRow).find("input[name='wareNm']").focus();
                return;
            }
        } else {
            var currRow = $(obj).closest('tr');
            //enCount=0;
            //if( $(currRow).find("input[name='wareId']").val()==""){
            var bool = checkSysWareByKeyWord(obj.value, 1);
            if (bool) {
                $(currRow).find("input[name='" + field + "']").focus();
                $(currRow).find("input[name='" + field + "']").select();
            }
            // }
        }
    }
}

function gjr_forAutotr_toNextCell(obj, field) {
    var currRow = $(obj).closest('tr');
    if (field == "beUnit") {
        $(currRow).find("select[name='" + field + "']").focus();
        $(currRow).find("select[name='" + field + "']").select();
    } else {
        $(currRow).find("input[name='" + field + "']").focus();
        $(currRow).find("input[name='" + field + "']").select();
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
function gjr_toNextRow(obj, targetField, lastColumn, nextRowFun) {
    var v = window.event.keyCode;
    if (v == 40 || v == 13) {//下移
        if (v == 13 && lastColumn != '1') {
            return;
        }
        var currRow = obj.parentNode;
        var tab = currRow.parentNode;
        var currRowIndex = currRow.rowIndex;
        var nextRowIndex = currRowIndex;
        var row = tab.rows[nextRowIndex];
        if (nextRowFun != undefined) {

        }
        if (lastColumn == "1") {
            var trList = $("#chooselist").children("tr");
            var len = trList.length;
            if (len == currRowIndex) {
                if ($("#check1").is(":checked") == true) {
                    $("#barcodeInput").focus();
                    $("#barcodeInput").click();
                    $("#barcodeInput").focus();
                    return;
                } else {
                    addTabRow();
                    var e = jQuery.Event("onkeydown");//模拟一个键盘事件
                    e.keyCode = 13;//keyCode=13是回车
                    $(obj).trigger(e);
                    enCount = 0;
                    return;
                }
            }
        }
        var cell = $(row).find("input[name='" + targetField + "']");
        cell.focus();
        $(cell).click();
        cell.focus();
        setTimeout(function () {
            $(cell).select();
        }, 10);
        if ($("#check1").is(":checked") != true) {
            $("#more_list tbody tr").css("background", "#fff");
            $(row).css("background", "skyblue");
        }
        var wareId = $(row).find("input[name='wareId']").val()
        querySaleCustomerHisWarePrice(wareId);
        $("#tipPrice").show();

    }
    if (v == 38) {//上移
        var currRow = obj.parentNode;
        var tab = currRow.parentNode;
        var currRowIndex = currRow.rowIndex;
        var nextRowIndex = currRowIndex - 2;
        var row = tab.rows[nextRowIndex];
        if (nextRowFun != undefined) {
        }
        var cell = $(row).find("input[name='" + targetField + "']");
        cell.focus();
        $(cell).click();
        cell.focus();
        setTimeout(function () {
            $(cell).select();
        }, 10)
        if ($("#check1").is(":checked") != true) {
            $("#more_list tbody tr").css("background", "#fff");
            $(row).css("background", "skyblue");
        }
        var wareId = $(row).find("input[name='wareId']").val()
        querySaleCustomerHisWarePrice(wareId);
        $("#tipPrice").show();

    }
}


function checkSubmitData() {
    var m = new Map()
    var sswIds = "";
    var sId = $("#stkId").val();
    var trList = $("#chooselist").children("tr");
    for (var i = 0; i < trList.length; i++) {
        var tdArr = trList.eq(i).find("td");
        var wareId = trList.eq(i).find("input[name='wareId']").val();
        if (wareId == "" || wareId == undefined) {
            break;
        }
        var qty = trList.eq(i).find("input[name='edtqty']").val();
        var productDate = trList.eq(i).find("input[name='productDate']").val();
        var sswId = trList.eq(i).find("input[name='sswId']").val();
        if (sswId == undefined) {
            continue;
        }
        var beUnit = $(tdArr).find("select[name='beUnit']").val();
        var hsNum = trList.eq(i).find("input[name='hsNum']").val();
        if (beUnit == 'S') {//计量单位
            var tempQty = 0;
            tempQty = qty / hsNum;
            tempQty = parseFloat(tempQty);
            qty = tempQty;
        }
        if (wareId != "" && sswId != "") {
            var key = wareId + "$" + sswId;
            if (m.containsKey(key)) {
                var tQty = m.get(key);
                tQty = parseFloat(tQty) + parseFloat(qty);
                m.put(key, tQty)
            } else {
                if (sswIds != "") {
                    sswIds = sswIds + ",";
                }
                sswIds = sswIds + sswId;
                m.put(key, qty);
            }
        }
    }
    $.ajaxSettings.async = false;
    var bool = true;
    if (sswIds != "") {
        $.ajax({
            url: "queryByWareByIds",
            type: "POST",
            data: {"stkId": sId, "sswIds": sswIds},
            dataType: 'json',
            async: false,
            success: function (json) {
                if (json.rows != undefined) {
                    var size = json.rows.length;
                    for (var i = 0; i < size; i++) {
                        var data = json.rows[i];
                        var key = data.wareId + "$" + data.id;
                        if (m.containsKey(key)) {
                            var qty = m.get(key);
                            var stkQty = data.qty;
                            if (parseFloat(qty) > parseFloat(stkQty)) {
                                $.messager.alert('消息', data.wareNm + '数量大于该批次库存数量(' + stkQty + ')!', 'info');
                                bool = false;
                            }
                        }
                    }
                }
            }
        })
    }
    return bool;
}


function checkSysWareByKeyWord(keyWord, op) {
    var bool = true;
    var stkId = $("#stkId").val();
    if(stkId==""){
        $.messager.alert('消息',"请选择仓库", 'info');
        return;
    }
    var path = basePath + "manager/querySysWarePageByKeyWord";
    // if(op==1){
    // 	path = basePath+"manager/queryStkWarePage1";
    // }
    $.ajax({
        url: path,
        type: "POST",
        data: {"keyWord": keyWord,"status": 1, "page": 1, "rows": 10},
        dataType: 'json',
        async: false,
        success: function (json) {
            if (json.state) {
                if (json.list.length > 0) {
                    console.log("data:" + json.list[0]);
                    var data = {
                        "wareId": json.list[0].wareId,
                        "wareNm": json.list[0].wareNm,
                        "wareGg": json.list[0].wareGg,
                        "wareCode": json.list[0].wareCode,
                        "unitName": json.list[0].wareDw,
                        "qty": 1,
                        "wareDj": json.list[0].wareDj,
                        "stkQty": json.list[0].stkQty,
                        "sunitFront": json.list[0].sunitFront,
                        "sunitPrice": json.list[0].sunitPrice,
                        "maxNm": json.list[0].wareDw,
                        "minUnitCode": json.list[0].minUnitCode,
                        "maxUnitCode": json.list[0].maxUnitCode,
                        "minNm": json.list[0].minUnit,
                        "hsNum": json.list[0].hsNum,
                        "inPrice": json.list[0].inPrice,
                        "productDate": json.list[0].productDate,
                        "qualityDays": json.list[0].qualityDays,
                        "packBarCode": json.list[0].packBarCode,
                        "beBarCode": json.list[0].beBarCode
                    }
                    if (op == 1) {
                        if (json.list.length == 1) {
                            setTabRowData(data, keyWord);
                        } else {
                            bool = false;
                        }
                    }
                }
            } else {
                $.messager.alert('消息', '未找到该商品!', 'info');
                bool = false;
                enCount = 0;
            }
        }
    });
    return bool;
}

function setKendoAutoComplete(id) {
    $('#' + id).kendoAutoComplete({
            dataTextField: 'wareNm',
            dataValueField: 'wareId',
            highlightFirst: true,
            clearButton: false,
            //headerTemplate: '<div style="background-color:blueviolet;color: white; font-weight: bold; "><span>请选择商品</span></div>',
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
                var row = $('#' + id).closest('tr');
                var currRowIndex = $(row).index();
                curr_row_index = currRowIndex + 1;
                setTabRowData(data)
            },
            change: function (e) {
                if ($('#' + id).data('kendoAutoComplete').value() == "") {
                    clearTabRowData("");
                }
                if ($('#' + id).data('kendoAutoComplete').value() != "") {

                }
            }
        }
    );
}

function wareAutoClick(o) {
    var currRow = $(o).closest('tr');
    var currRowIndex = $(currRow).index();
    curr_row_index = currRowIndex + 1;
    enCount = 0;
    $(this).focus();
    $(this).click();
    $(this).focus();
}


function checkCustomerPage() {
    var khNm = $("#khNm").val();
    var path = basePath + "/manager/stkchoosecustomer";
    var token = $("#tmptoken").val();
    $.ajax({
        url: path,
        type: "POST",
        data: {"token": token, "page": 1, "rows": 20, "dataTp": "1", "khNm": khNm},
        dataType: 'json',
        async: false,
        success: function (json) {
            if (json.state) {
                var size = json.rows.length;
                if (size > 0) {
                    var data = {
                        "id": json.rows[0].id,
                        "khNm": json.rows[0].khNm,
                        "mobile": json.rows[0].mobile,
                        "address": json.rows[0].address,
                        "linkman": json.rows[0].linkman,
                        "branchName": json.rows[0].branchName,
                        "shZt": json.rows[0].shZt,
                        "memId": json.rows[0].memId,
                        "memberNm": json.rows[0].memberNm
                    }
                    $("#proType").val(2);
                    $("#cstId").val(data.id);
                    $("#khNm").val(data.khNm);
                    $("#csttel").val(data.mobile);
                    $("#cstaddress").val(data.address);
                } else {
                    $("#proType").val(2);
                    $("#cstId").val("");
                    $("#csttel").val("");
                    $("#cstaddress").val("");
                    $("#staff").html("");
                    $("#empId").val("");
                    $("#stafftel").val("");
                }
            }
        }
    });
}


/**
 * 检查当前销售价与执行价不同
 */
function checkOutSubPriceDiff() {
    var proType = $("#proType").val();
    var status = $("#status").val();
    if (status != -2) {
        return;
    }
    if (proType != 2) {
        return;
    }
    var orderId = $("#orderId").val();
    var cstId = $("#cstId").val();
    var path = "checkOutSubPriceDiff";
    var billId = $("#billId").val();
    var isOrder = "1";
    if (billId == 0 && orderId != 0 && orderId != null && orderId != undefined) {
        isOrder = "0";
        billId = orderId;
    }
    if (COMPARE_HIS_PRICE == 'none' && COMPARE_ZX_PRICE == 'none') {
        return;
    }
    var compareTo = 0;
    if (COMPARE_HIS_PRICE == '') {
        compareTo = 1;
    }
    if (billId == 0 || billId == null || billId == undefined) {
        return;
    }
    $.ajax({
        url: path,
        type: "POST",
        data: {"billId": billId, "isOrder": isOrder, "compareTo": compareTo, "customerId": cstId},
        dataType: 'json',
        async: false,
        success: function (json) {
            if (json.state) {
                setWarePriceDiff(json.diffWareIds);
            }
        }
    });
}

function setWarePriceDiff(wareIds) {
    $("#more_list tbody input[name$='wareId']").each(function () {
        var wareId = "$" + $(this).val() + "$";
        if (wareIds.indexOf(wareId) != -1) {
            var currRow = this.parentNode.parentNode;
            //$(currRow).attr("class", "ware_dif_price_tip");
            var price = $(currRow).find("input[name='edtprice']");
            $(price).closest("td").attr("class", "ware_dif_price_tip");
            var priceFlagItems = $(currRow).find("input[name='priceFlag']");
            $(priceFlagItems).each(function (dx, data) {
                $(data).val(1);
            })
        }
    });
}

function getBillData() {
    var status = $('#status').val();
    if (status != -2) {
        return false;
    }
    var trList = $("#chooselist").children("tr"), wareList = [];
    for (var i = 0; i < trList.length; i++) {
        var wareId = trList.eq(i).find("input[name='wareId']").val();
        var wareNm = trList.eq(i).find("input[name='wareNm']").val();
        var wareCode = trList.eq(i).find("input[name='wareCode']").val();
        var wareGg = trList.eq(i).find("input[name='wareGg']").val();
        if (wareId == "" || wareId == undefined) {
            continue;
        }
        var wareDw, minUnit, maxUnitCode = 'B';
        trList.eq(i).find('select[name=beUnit] option').each(function (i, opt) {
            var code = $(opt).val();
            if (code == 'B') {
                wareDw = $(opt).text();
            } else {
                minUnit = $(opt).text();
            }
        });

        var xsTp = trList.eq(i).find("select[name='xstp']").val();
        var rebatePrice = trList.eq(i).find("input[name='rebatePrice']").val();
        var qty = trList.eq(i).find("input[name='edtqty']").val();
        var beUnit = trList.eq(i).find("select[name='beUnit']").val();
        var price = trList.eq(i).find("input[name='edtprice']").val();
        var hsNum = trList.eq(i).find("input[name='hsNum']").val();
        var productDate = trList.eq(i).find("input[name='productDate']").val();
        var unit = trList.eq(i).find("select[name='beUnit'] option:selected").text();
        var activeDate = trList.eq(i).find("input[name='qualityDays']").val();
        var remarks = trList.eq(i).find("input[name='edtRemarks']").val() || '';
        var sswId = trList.eq(i).find("input[name='sswId']").val();
        var helpQty = trList.eq(i).find("input[name='helpQty']").val();
        var helpUnit = trList.eq(i).find("input[name='helpUnit']").val();
        var checkWare = trList.eq(i).find("input[name='checkWare']").val();
        if (wareId == 0) continue;
        var subObj = {
            wareId: wareId,
            wareNm: wareNm,
            wareCode: wareCode,
            wareGg: wareGg,
            wareDw: wareDw,
            minUnit: minUnit,
            maxUnitCode: maxUnitCode,
            xsTp: xsTp,
            qty: qty,
            outQty: qty,
            unitName: unit,
            price: price,
            productDate: productDate,
            activeDate: activeDate,
            remarks: remarks,
            hsNum: hsNum,
            beUnit: beUnit,
            sswId: sswId,
            rebatePrice: rebatePrice,
            helpQty: helpQty,
            helpUnit: helpUnit,
            checkWare: checkWare
        };
        wareList.push(subObj);
    }
    if (wareList.length < 20) {
        return false;
    }
    var master = {
        cstId: $("#cstId").val() || 0,
        khNm: $('#khNm').val(),
        stkId: $('#stkId').val(),
        tel: $("#csttel").val(),
        address: $("#cstaddress").val(),
        remarks1: $("#remarks").val(),
        orderId: $("#orderId").val(),
        outDate: $("#outDate").val(),
        shr: $('#khNm').val(),
        staff: $("#staff").text(),
        stafftel: $("#stafftel").val(),
        empId: $("#empId").val(),
        proType: $("#proType").val() || 2,
        driverId: $("#driverId").val(),
        vehId: $("#vehId").val(),
        saleType: $("#saleType").val(),
        transportName: $("#transportName").val(),
        transportCode: $("#transportCode").val(),
        epCustomerId: $("#epCustomerId").val(),
        epCustomerName: $("#epCustomerName").val(),
        pszd: $("#pszd").val(),
        discount: $("#discount").val()
    };
    var bill = {master: master, rows: wareList};
    return bill;
}

var rawBillData = {};

function loadSnapshot(id) {
    rawBillData = getBillData();
    $.ajax({
        url: '/manager/common/bill/snapshot/' + id,
        type: 'get',
        success: function (response) {
            if (response.success) {
                var bill = JSON.parse(response.data.data);
                var master = bill.master;
                $('#snapshotId').val(response.data.id);
                $("#cstId").val(master.cstId);
                $('#khNm').val(master.khNm);
                $('#stkId').val(master.stkId);
                $("#csttel").val(master.tel);
                $("#cstaddress").val(master.address);
                $("#remarks").val(master.remarks1);
                $("#orderId").val(master.orderId);
                $("#outDate").val(master.outDate);
                $("#staff").text(master.staff);
                $("#stafftel").val(master.stafftel);
                $("#empId").val(master.empId);
                $("#proType").val(master.proType);
                $("#driverId").val(master.driverId);
                $("#vehId").val(master.vehId);
                $("#saleType").val(master.saleType);
                $("#transportName").val(master.transportName);
                $("#transportCode").val(master.transportCode);
                $("#epCustomerId").val(master.epCustomerId);
                $("#epCustomerName").val(master.epCustomerName);
                $("#pszd").val(master.pszd);
                $("#discount").val(master.discount);
                $("#more_list tbody").html("");
                var size = bill.rows.length, json = {rows: bill.rows};
                var unitDisplay = 'none';
                var checkSunitBox = $("#checkSunitBox").attr('checked');
                if (checkSunitBox) {
                    unitDisplay = '';
                }
                //gstklist = json.rows;
                for (var i = 0; i < size; i++) {
                    var beUnit = bill.rows[i].beUnit;
                    var maxUnitCheck = "";
                    var minUnitCheck = "";
                    if (beUnit == "S") {
                        minUnitCheck = "checked";
                    } else {
                        maxUnitCheck = "checked";
                    }

                    $("#more_list tbody").append(
                        '<tr onmouseout="wareTrOnMouseOutClick(this)"   onmousedown="wareTrOnMouseDownClick(this)">' +
                        '<td class="index">' + (i + 1) + '</td>' +
                        '<td style="padding-left: 20px;text-align: left;"  class="tdClass">' +
                        '<input type="hidden" name="wareId" value = "' + json.rows[i].wareId + '"/><input type="hidden" name="checkWare"/><input type="text" class="pcl_i2" readonly="true" id="wareCode' + rowIndex + '" value="' + json.rows[i].wareCode + '" name="wareCode"/><div></div></td>' +
                        '<td id="autoCompleterTr' + rowIndex + '" class="wareClass"><input name="wareNm"  type="text" placeholder="输入商品名称、商品代码、商品条码" onclick="wareAutoClick(this)" onkeydown="gjr_forAuto_toNextCell(this,\'edtqty\')" style="width: 170px"/>' + selectImg + '</td>' +
                        '<td ><input type="text" class="pcl_i2" readonly="true" id="wareGg' + rowIndex + '" name="wareGg" style="width: 80px;" value="' + json.rows[i].wareGg + '"/></td>' +
                        '<td>' +
                        '<select name="xstp" id="xstp' + rowIndex + '" style="width:80px">' +
                        '<option value="正常销售" checked>正常销售</option>' +
                        '<option value="促销折让">促销折让</option>' +
                        '<option value="消费折让">消费折让</option>' +
                        '<option value="费用折让">费用折让</option>' +
                        '<option value="其他销售">其他销售</option>' +
                        '</select>' +
                        '</td>' +
                        '<td >' +
                        '<select id="beUnit' + rowIndex + '" name="beUnit" style="width:50px" onchange="changeUnit(this,' + rowIndex + ')">' +
                        '<option value="' + json.rows[i].maxUnitCode + '" ' + maxUnitCheck + '>' + json.rows[i].wareDw + '</option>' +
                        '<option value="' + json.rows[i].minUnitCode + '" ' + minUnitCheck + '>' + json.rows[i].minUnit + '</option>' +
                        '</select>'
                        + '</td>' +
                        '<td onkeydown="gjr_toNextRow(this,\'edtqty\')" style="display:' + qtyDisplay + '"><input onclick="gjr_CellClick(this)" id="edtqty' + rowIndex + '" onkeydown="gjr_toNextCell(this,\'edtprice\')"  name="edtqty" type="text" class="pcl_i2" value="' + json.rows[i].qty + '" onchange="countAmt()"/></td>' +
                        '<td onkeydown="gjr_toNextRow(this,\'edtprice\')" style="display:' + priceDisplay + '"><input onclick="gjr_CellClick(this)" id="edtprice' + rowIndex + '" onkeydown="gjr_toNextCell(this,\'edtRemarks\')"  name="edtprice" type="text" class="pcl_i2" value="' + json.rows[i].price + '" onchange="countAmt()"/></td>' +
                        '<td style="display:' + amtDisplay + '"><input id="amt' + rowIndex + '" onclick="gjr_CellClick(this)"  name="amt" type="text" value=' + json.rows[i].warezj + ' class="pcl_i2" onchange="countPrice()"/></td>' +
                        '<td style="display:' + fanLiDisplay + '"><input id="rebatePrice' + rowIndex + '" onclick="gjr_CellClick(this)"  name="rebatePrice" type="text" class="pcl_i2" value=""/></td>' +
                        '<td onkeydown="gjr_toNextRow(this,\'edtqty\')"><input  name="productDate" placeholder="单击选择"   id="productDate' + rowIndex + '" class="pcl_i2"  onClick="WdatePicker({skin:\'whyGreen\',dateFmt: \'yyyy-MM-dd\'});" style="width: 90px;"  readonly="readonly" value="' + json.rows[i].productDate + '"/><a href="javacript:;;" onclick="selectWareBatch(this)">关联</a></td>' +
                        '<td onkeydown="gjr_toNextRow(this,\'qualityDays\')"><input name="qualityDays" onclick="gjr_CellClick(this)"  onkeydown="gjr_toNextCell(this,\'edtRemarks\')"  class="pcl_i2"  style="width: 90px;" value="' + json.rows[i].activeDate + '" /></td>' +
                        '<td onkeydown="gjr_toNextRow(this,\'wareNm\',\'1\')"><input onclick="gjr_CellClick(this)" name="edtRemarks" type="text" class="pcl_i2" style="width: 80px;" value="' + json.rows[i].remarks + '"/></td>' +
                        '<td style="display:none"><input id="hsNum' + rowIndex + '" name="hsNum" type="hidden" class="pcl_i2" value="' + json.rows[i].hsNum + '"/></td>' +
                        '<td style="display:none"><input id="unitName' + rowIndex + '" name="unitName" type="hidden" class="pcl_i2" value="' + json.rows[i].wareDw + '" /></td>' +
                        '<td style="display:none"><input id="sunitPrice' + rowIndex + '" name="sunitPrice" type="hidden" class="pcl_i2" value="' + json.rows[i].sunitPrice + '" /></td>' +
                        '<td style="display:none"><input id="bUnitPrice' + rowIndex + '" name="bUnitPrice" type="hidden" class="pcl_i2" value="' + json.rows[i].bunitPrice + '" /></td>' +
                        '<td style="display:none"><input id="sswId' + rowIndex + '" name="sswId" type="hidden" class="pcl_i2" /></td>' +
                        '<td style="display:' + unitDisplay + '" class="sunitClass"><input name="sunitQty" readonly="readonly" class="pcl_i2" /></td>' +
                        '<td style="display:' + unitDisplay + '" class="sunitClass"><input name="sunitJiage" onclick="gjr_CellClick(this)" onchange="changeSunitPrice(this)" class="pcl_i2" /></td>' +
                        '<td style="display:' + helpDisplay + '" class="helpClass"><input name="helpQty" onkeyup="CheckInFloat(this)"  class="pcl_i2" /></td>' +
                        '<td style="display:' + helpDisplay + '" class="helpClass"><input name="helpUnit"  class="pcl_i2" /></td>' +
                        '<td style="display:none" class="helpClass"><input name="priceFlag" type="hidden" /></td>' +
                        '<td>' + optBtn + '</td>' +
                        '</tr>'
                    );
                    var row = $("#more_list tbody tr").eq(i);
                    /**********************商品行中下拉选中商品开始****************************/
                    $(row).find("input[name='wareNm']").val(json.rows[i].wareNm);
                    $(row).find("input[name='wareNm']").attr("id", "wareNm" + rowIndex);
                    $(row).find("select[name='xstp']").val(json.rows[i].xsTp);
                    setKendoAutoComplete($(row).find("input[name='wareNm']").attr("id"));
                    setKendoAutoOption($(row).find("select[name='beUnit']").attr("id"));
                    setKendoAutoXsOption($(row).find("select[name='xstp']").attr("id"));
                    /**********************商品行中下拉选中商品结束****************************/
                    if (beUnit != "") {
                        document.getElementById("beUnit" + rowIndex).value = beUnit;
                    } else {
                        var wareDw2 = json.rows[i].wareDw2;
                        if (json.rows[i].wareDw == wareDw2) {
                            document.getElementById("beUnit" + rowIndex).options[0].selected = true;
                        }
                        if (json.rows[i].minUnit == wareDw2) {
                            document.getElementById("beUnit" + rowIndex).options[1].selected = true;
                        }
                    }
                    loadWareProductDate(json.rows[i].wareId, rowIndex);
                    rowIndex++;
                    countAmt();
                    displayXsTpSel();
                }

                checkOutSubPriceDiff();
                $.messager.show({
                    title: '提示',
                    msg: '加载成功',
                    timeout: 1000,
                    showType: 'slide'
                });
            } else {
                $.messager.show({
                    title: '提示',
                    msg: '加载失败',
                    timeout: 1000,
                    showType: 'slide'
                });
            }
        }
    })
}

function removeSnapshot(id) {
    $.ajax({
        url: '/manager/common/bill/snapshot/' + id,
        type: 'delete',
        success: function (response) {
            if (response.success) {
                uglcw.ui.success('快照删除成功');
                var snapshotId = $('#snapshotId').val();
                if (snapshotId === id) {
                    $('#snapshotId').val('');
                }
            }
        }
    })
}

function clearSnapshotId(id) {
    var current = $('#snapshotId').val();
    if (id === current) {
        $('#snapshotId').val('');
    }
}

$(function () {
    $('#chooselist').on('change', 'td input', function () {
        if (AUTO_SNAPSHOT !== 'none') {
            saveSnapshot();
        }
    })
});

var saveSnapshotDelay;

function saveSnapshot() {
    window.clearTimeout(saveSnapshotDelay);
    saveSnapshotDelay = setTimeout(function () {
        var bill = getBillData();
        if (!bill) {
            return;
        }
        $.ajax({
            url: '/manager/common/bill/snapshot',
            contentType: 'application/json',
            type: 'POST',
            data: JSON.stringify({
                title: $('#khNm').val(),
                id: $('#snapshotId').val(),
                billType: 'xxfp',
                data: bill
            }),
            success: function (response) {
                if (response.success) {
                    $('.snapshot-badge-dot').show();
                    uglcw.ui.get('#snapshotId').value(response.data)
                }
            }
        })
    }, 1500);
}