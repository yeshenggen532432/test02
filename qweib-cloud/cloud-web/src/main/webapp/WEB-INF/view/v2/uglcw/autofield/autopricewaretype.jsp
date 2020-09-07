<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>商品费用投入设置</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="uglcw-layout-container">
        <div class="uglcw-layout-fixed" style="width:200px">
            <div class="layui-card" uglcw-role="resizable" uglcw-options="responsive:[35]">
                <ul uglcw-role="accordion" uglcw-options="expandMode: 'single'" id="accordion">
                    <li>
                        <span>库存商品类</span>
                        <div uglcw-role="tree" id="tree"
                         uglcw-options="
							url: '${base}manager/companyStockWaretypes',
							expandable:function(node){return node.id == '0'},
							loadFilter: function (response) {
                            $(response).each(function (index, item) {
                                if (item.text == '根节点') {
                                    item.text = '库存商品类'
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
                    </li>
                </ul>
            </div>
        </div>
        <div class="uglcw-layout-content">
            <div class="layui-card header">
                <div class="layui-card-body">
                    <ul class="uglcw-query form-horizontal">
                        <li>
                            <input type="hidden" uglcw-model="wtype" value="${param.wtype}" id="wareType"
                                   uglcw-role="textbox">
                            <input uglcw-model="wareNm" value="${param.wareNm}" id="wareNm" uglcw-role="textbox"
                                   placeholder="商品名称">
                        </li>
                        <li>
                            <input uglcw-model="packBarCode" value="${param.packBarCode}" id="packBarCode"
                                   uglcw-role="textbox" placeholder="大单位条码">
                        </li>
                        <li>
                            <input uglcw-model="beBarCode" value="${param.beBarCode}" id="beBarCode" uglcw-role="textbox"
                                   placeholder="小单位条码">
                        </li>
                        <li>
                            <select uglcw-role="combobox" uglcw-model="status" id="status" placeholder="商品状态">
                                <option value="">--商品状态--</option>
                                <option value="1" selected>启用</option>
                                <option value="2">不启用</option>
                            </select>
                        </li>
                        <li>
                            <input type="hidden" uglcw-role="textbox"id="click-flag" uglcw-model="clickFlag" value="${param.clickFlag}" value="0"/>
                            <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                            <button id="reset" class="k-button" uglcw-role="button">重置</button>
                        </li>
                    </ul>
                </div>
            </div>
            <div class="layui-card">
                <div class="layui-card-body full">
                    <div id="grid" uglcw-role="grid"
                    ></div>
                    <%--<div id="grid" uglcw-role="grid"--%>
                    <%--uglcw-options="--%>
                    <%--id:'id',--%>
                    <%--checkbox:true,--%>
                    <%--pageable: true,--%>
                    <%--url: '${base}manager/wares',--%>
                    <%--criteria: '.form-horizontal',--%>
                    <%--">--%>
                    <%--<div data-field="wareCode" uglcw-options="width:100">商品编码</div>--%>
                    <%--<div data-field="wareNm" uglcw-options="width:100">商品名称</div>--%>
                    <%--<div data-field="waretypeNm" uglcw-options="width:100">所属分类</div>--%>
                    <%--<div data-field="wareGg" uglcw-options="width:80">规格</div>--%>
                    <%--<div data-field="wareDw" uglcw-options="width:60">大单位</div>--%>
                    <%--<div data-field="minUnit" uglcw-options="width:60">小单位</div>--%>
                    <%--</div>--%>
                </div>
            </div>
        </div>
    </div>
</div>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        //ui:初始化
        uglcw.ui.init();

        //查询
        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#click-flag').value(1);
            window.location.href = '${base}manager/autopricewaretype?' + $.map(uglcw.ui.bind('.form-horizontal'), function (v, k) {
                return k + '=' + v;
            }).join('&');
            // uglcw.ui.get('#grid').reload();
        })

        //重置
        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal');
            uglcw.ui.get('#grid').reload();
        })
        //初始化grid
        initGrid();
        //设置tree高度
      /*  var treeHeight = $(window).height() - $("div.layui-card-header").height() - 60;
        $("#tree").height(treeHeight + "px");*/
        uglcw.ui.loaded();
    })


    //---------------------------------------------------------------------------------------------------------------
    //sapn和input切换
    function operatePrice(field) {
        var display = $("." + field + "_imput").css('display');
        if (display == 'none') {
            $("." + field + "_imput").show();
            $("." + field + "_span").hide();
        } else {
            $("." + field + "_imput").hide();
            $("." + field + "_span").show();
        }
    }

    //改变商品价格
    function changeWareAutoPrice(wareId, autoId) {
        var autoPriceId = document.getElementById("auto_price_Id_" + wareId + "_" + autoId).value;
        var autoPrice = document.getElementById("auto_Price_" + wareId + "_" + autoId).value;
        if (isNaN(autoPrice)) {
            uglcw.ui.toast("请输入数字")
            return;
        }
        $.ajax({
            url: "${base}manager/updateAutoPrice",
            type: "post",
            data: "id=" + autoPriceId + "&wareId=" + wareId + "&price=" + autoPrice + "&autoId=" + autoId,
            success: function (data) {
                if (data != '0') {
                    if (autoPriceId == "") {
                        document.getElementById("auto_price_Id_" + wareId + "_" + autoId).value = data;
                        $("#auto_span_" + wareId + "_" + autoId).text(autoPrice);
                        // uglcw.ui.toast("保存成功")
                    }
                } else {
                    uglcw.ui.error("保存失败")
                }
            }
        });
    }

    //初始化grid
    function initGrid() {
        var autoTitleDatas = eval('${autoTitleJson}');
        var autoPriceDatas = eval('${autoPriceJson}');
        var cols = [
            {field: 'wareCode', title: '商品编码', width: 80},
            {field: 'wareNm', title: '商品名称', width: 100},
            {field: 'waretypeNm', title: '所属分类', width: 80},
            {field: 'wareGg', title: '规格', width: 60},
            {field: 'wareDw', title: '单位', width: 60},
        ];
        if (autoTitleDatas.length > 0) {
            for (var i = 0; i < autoTitleDatas.length; i++) {
                var json = autoTitleDatas[i];
                var field = "auto" + json.id;
                var title = json.name;
                var titleId = json.id;

                var createColumn = function (f, t, autoId) {
                    var col = {
                        field: f,
                        width: 120,
                        headerTemplate: "<span onclick=\"javascript:operatePrice('" + field + "');\">" + t + "✎</span>",
                        template: function (row) {
                            var price = "";
                            var html = "<input type='hidden' id='auto_price_Id_" + row.wareId + "_" + autoId + "'/>";
                            html += "<input style='display:none' class='" + f + "_imput k-textbox' name='autoPrice' uglcw-role='numeric' uglcw-validate='number' size='7' onchange='changeWareAutoPrice(" + row.wareId + "," + autoId + ")' id='auto_Price_" + row.wareId + "_" + autoId + "' value='" + price + "' />";
                            html += "<span class=" + f + "_span" + " id='auto_span_" + row.wareId + "_" + autoId + "'>" + price + "</span>";
                            if (autoPriceDatas.length > 0) {
                                for (var j = 0; j < autoPriceDatas.length; j++) {
                                    var priceData = autoPriceDatas[j];
                                    if (priceData.wareId == row.wareId && priceData.autoId == autoId) {
                                        price = priceData.price;
                                        var priceId = priceData.id;
                                        if (price == null || price == undefined || price == 'undefined') {
                                            price = "";
                                        }
                                        html = "";
                                        html = "<input type='hidden' id='auto_price_Id_" + row.wareId + "_" + autoId + "' value='" + priceId + "'/>";
                                        html += "<input style='display:none' class='" + f + "_imput k-textbox' uglcw-role='numeric' uglcw-validate='number' name='autoPrice'  size='7' onchange='changeWareAutoPrice(" + row.wareId + "," + autoId + ")' id='auto_Price_" + row.wareId + "_" + autoId + "' value='" + price + "' />";
                                        html += "<span class=" + f + "_span" + " id='auto_span_" + row.wareId + "_" + autoId + "'>" + price + "</span>";
                                        break;
                                    }
                                }
                            }
                            return html;
                        }
                    };
                    cols.push(col);
                }
                createColumn(field, title, titleId);

            }
        }

        uglcw.ui.get('#grid').kInit({
             responsive:['.header',40],
            // navigatable: true,
            pageable: {
                numeric: true,
                refresh: true,
                buttonCount: 5,
                previousNext: true,
                pageSizes: [10, 20, 50, 100, 200, 500, 1000]
            },
            columns: cols,
            dataSource: {
                schema: {
                    data: function (response) {
                        var rows = response.rows || [];
                        return rows;
                    },
                    total: function (response) {
                        return response.total;
                    },
                },
                transport: {
                    read: {
                        url: '${base}manager/wares',
                        data: function (param) {
                            param = {
                                wtype: uglcw.ui.get('#wareType').value(),
                                wareNm: uglcw.ui.get('#wareNm').value(),
                                packBarCode: uglcw.ui.get('#packBarCode').value(),
                                beBarCode: uglcw.ui.get('#beBarCode').value(),
                                status: uglcw.ui.get('#status').value(),
                                page: param.page,
                                rows: param.pageSize

                            }
                            if(uglcw.ui.get('#click-flag').value()==1){
                                delete param['wtype']
                            }
                            return param;

                        }
                    }
                },
                serverPaging: true,
                pageSize: 20,
                serverAggregates: false,
            }
        })
    }


</script>
</body>
</html>
