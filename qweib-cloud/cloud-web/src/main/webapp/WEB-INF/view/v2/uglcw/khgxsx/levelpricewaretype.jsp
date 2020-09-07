<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>按客户等级设置商品销售价格</title>
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
                         <div id="tree" uglcw-role="tree"
                            uglcw-options="
                            url:'manager/waretypes',
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
                            var node = this.dataItem(e.node)
                            uglcw.ui.get('#wtype').value(node.id);
                            uglcw.ui.get('#grid').reload();
                        }
                    "
                    >
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
                            <input type="hidden" uglcw-model="jz" value="1" uglcw-role="textbox">
                            <input type="hidden" uglcw-model="wtype" id="wtype" uglcw-role="textbox">
                            <input uglcw-model="wareNm" id="wareNm" uglcw-role="textbox" placeholder="商品名称">
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
					     checkbox: true,
					     rowNumber: true,
						id:'id',
						url: 'manager/wares',
						criteria: '.form-horizontal',
						pageable: true,
						">
                        <div data-field="wareCode" uglcw-options="width:120">商品编码</div>
                        <div data-field="wareNm" uglcw-options="width:120">商品名称</div>
                        <div data-field="waretypeNm" uglcw-options="width:120">所属分类</div>
                        <div data-field="wareGg" uglcw-options="width:100">规格</div>
                        <div data-field="wareDw" uglcw-options="width:80">单位</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        uglcw.ui.init();
        //显示商品
        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').k().dataSource.read();
        })

        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal', {
                sdate: '${sdate}', edate: '${edate}'
            });
        })
        uglcw.ui.loaded()

        //初始化grid
        initGrid();
    })


    //--------------------------------------------------------------------------------------------------------------------
    //初始化grid
    function initGrid() {
        var levelTitleJson = eval('${levelTitleJson}');
        var levelPriceJson = eval('${levelPriceJson}');
        var cols = uglcw.ui.get('#grid').k().options.columns;
        if (levelTitleJson.length > 0) {
            for (var i = 0; i < levelTitleJson.length; i++) {
                var json = levelTitleJson[i];
                var field = "level" + json.khdjNm;
                var title = json.khdjNm;
                var titleId = json.id;

                var createColumn = function (f, t, autoId) {
                    var col = {
                        field: f,
                        width: 100,
                        headerTemplate: "<span>" + t + "</span>",
                        template: function (row) {
                            var price = "";
                            var html = "<input type='hidden' id='level_price_Id_" + row.wareId + "_" + autoId + "'/>";
                            html += "<input type='text' name='levelPrice' size='7' onchange='changeWareLevelPrice(" + row.wareId + "," + autoId + ")' id='level_Price_" + row.wareId + "_" + autoId + "' value='" + price + "' class='k-textbox' uglcw-role='numeric' uglcw-validate='number'/>";
                            if (levelPriceJson.length > 0) {
                                for (var i = 0; i < levelPriceJson.length; i++) {
                                    var json = levelPriceJson[i];
                                    if (json.wareId == row.wareId && json.levelId == autoId) {
                                        html = "<input type='hidden' id='level_price_Id_" + row.wareId + "_" + autoId + "' value='" + json.id + "'/><input type='text' name='levelPrice' size='7' onchange='changeWareLevelPrice(" + row.wareId + "," + autoId + ")' id='level_Price_" + row.wareId + "_" + autoId + "' value='" + json.price + "' class='k-textbox' uglcw-role='numeric' uglcw-validate='number'/>";
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

        uglcw.ui.get('#grid').k().setOptions({
            columns: cols
        });
    }

    /*
            uglcw.ui.get('#grid').kInit({
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
							return {
								wtype: uglcw.ui.get('#wtype').value(),
								wareNm: uglcw.ui.get('#wareNm').value(),
								page: param.page,
								rows: param.pageSize
							}
						}
					}
				},
				serverPaging: true,
				pageSize: 20,
				serverAggregates: false,
			}
		})
	}*/

    function changeWareLevelPrice(wareId, levelId) {
        var levelPriceId = document.getElementById("level_price_Id_" + wareId + "_" + levelId).value;
        var levelPrice = document.getElementById("level_Price_" + wareId + "_" + levelId).value;
        $.ajax({
            url: "${base}manager/updateLevelPrice",
            type: "post",
            data: "id=" + levelPriceId + "&wareId=" + wareId + "&price=" + levelPrice + "&levelId=" + levelId,
            success: function (data) {
                if (data != '0') {
                    if (levelPriceId == "") {
                        document.getElementById("level_price_Id_" + wareId + "_" + levelId).value = data;
                        // uglcw.ui.success("保存")
                    }
                } else {
                    uglcw.ui.error("保存失败")
                }
            }
        });
    }

</script>
</body>
</html>
