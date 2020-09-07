<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>生成客户费用统计表</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }
    </style>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <div class="form-horizontal">
                <div class="form-group" style="margin-bottom: 0px;">
                    <input type="hidden" uglcw-model="id" uglcw-role="textbox" value="${id}"/>
                    <div class="col-xs-7">
                        <input uglcw-model="rptTitle" id="rptTitle" uglcw-role="textbox" value="${title}" placeholder="标题">
                    </div>
                    <div class="col-xs-6">
                        <input id="remark" uglcw-model="remarks" uglcw-role="textbox" placeholder="备注">

                    </div>
                    <span id="paramStr"></span>
                </div>
            </div>
        </div>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid"></div>
        </div>
    </div>
</div>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script id="aggregate-template">
    # $(data.items).each(function (i, item) {#
        <label style="margin-right: 5px;">#= item.title#: #= item.value == undefined ? '' : item.value#</label>
    #})#
</script>
<script>

    $(function () {
        uglcw.ui.init();

        var grid = new uglcw.ui.Grid('#grid');

        load(function (title, remark, config) {
            uglcw.ui.get('#rptTitle').value(title);
            uglcw.ui.get('#remark').value(remark);
            var aggregates = [];
            var aggregatesData = {};
            var columns = $.map(config.cols, function (col) {
                if (config.merCols.indexOf(col.field) == -1) {
                    return col
                } else {
                    col.value = 0;
                    col.hidden = true;
                    aggregates.push(col);
                }
            });
            if (config.rows.length > 0) {
                $(config.rows).each(function (k, row) {
                    aggregatesData[row.khNm] = row;
                })

            }
            columns.push({
                field: 'khNm',
                hidden: true,
                groupHeaderTemplate: function (data) {
                    var row = aggregatesData[data.value];
                    var items = [];
                    $(aggregates).each(function (j, aggr) {
                        items.push({
                            title: aggr.title,
                            field: aggr.field,
                            value: row[aggr.field]
                        })
                    })
                    return uglcw.util.template($('#aggregate-template').html())({data: {title: data.value, items: items}});
                }
            });
            columns.push({
                field: 'address',
                hidden: true,
                //groupHeaderTemplate: uglcw.util.template($('#aggregate-template').html())({data: aggregates})
                groupHeaderTemplate: '#= value#'
            })

            grid.kInit({
                columns: columns,
                dataSource: {
                    data: config.rows,
                    group: {
                        field: 'khNm',
                        aggregates: [
                            {
                                field: 'khNm',
                                aggregate: 'count'
                            }
                        ]
                    }
                }

            })
        })

        uglcw.ui.loaded()
    })

    function load(callback) {
        $.ajax({
            url: '${base}manager/queryCstStatMastData',
            type: 'get',
            data: {
                id: '${param.id}'
            },
            success: function (response) {
                if (response.state) {
                    callback(response.rptTitle, response.remarks, JSON.parse(response.blodHtml));
                }
            }
        })
    }


</script>
</body>
</html>
