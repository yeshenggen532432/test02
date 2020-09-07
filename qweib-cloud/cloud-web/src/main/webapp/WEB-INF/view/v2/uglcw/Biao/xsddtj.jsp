<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>驰用T3</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md12">
            <div class="layui-card">
                <div class="layui-card header">
                    <div class="layui-card-body">
                        <ul class="uglcw-query query">
                            <li>
                                <input uglcw-model="stime" uglcw-role="datepicker" value="${etime}">
                            </li>
                            <li>
                                <input uglcw-model="etime" uglcw-role="datepicker" value="${etime}">
                            </li>
                            <li>
                                <select uglcw-role="combobox" uglcw-model="orderZt" placeholder="订单状态">
                                    <option value="">全部</option>
                                    <option value="审核">审核</option>
                                    <option value="未审核">未审核</option>
                                </select>
                            </li>
                            <li>
                                <select uglcw-role="combobox" uglcw-model="pszd" placeholder="配送指定">
                                    <option value="">全部</option>
                                    <option value="公司直送">公司直送</option>
                                    <option value="转二批配送">转二批配送</option>
                                </select>
                            </li>
                            <li>
                                <input uglcw-model="khNm" uglcw-role="textbox" placeholder="客户名称">
                            </li>
                            <li>
                                <input uglcw-model="memberNm" uglcw-role="textbox" placeholder="业务员名称">
                            </li>
                            <li>
                                <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                                <button id="reset" class="k-button" uglcw-role="button">重置</button>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
            <div class="layui-card">
                <div class="layui-card-body full">
                    <div id="grid" uglcw-role="grid"
                         uglcw-options="
                         loadFilter: {
                         data: function (response) {
                             return response.rows || []
                         },
                         aggregates: function (response) {
                             var aggregate = {};
                             if (response.footer && response.footer.length>0) {
                                  aggregate = response.footer[0]
                             }
                             return aggregate;
                         }
                     },
                      responsive:['.header',40],
                    id:'id',
                    url: '${base}manager/xsddtjPage?dataTp=1',
                    criteria: '.uglcw-query',
                    pageable: true,
						aggregate:[
                  		   {field: 'memberNm', aggregate: 'SUM'}
                    ]"
                    >
                        <div data-field="khNm" uglcw-options="width:100">客户名称</div>
                        <div data-field="memberNm" uglcw-options="width:100">业务员名称</div>
                        <div data-field="count1" uglcw-options="width:400,
                         template: function(data){
                            return kendo.template($('#product-list').html())(data.list1);
                         }, footerTemplate: '<span style=\'color: red;\'>#= data.memberNm#</span>'">订单信息
                        </div>
                        <div data-field="zje" uglcw-options="width:160">金额总计</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script id="product-list" type="text/x-kendo-template">
    <table class="product-grid" style="border-bottom:1px \\#3343a4 solid;padding-left: 5px;">
        <tbody>
        <tr style="font-weight: bold;">
            <td style="width: 15px;">商品名称</td>
            <td style="width: 10px;">销售类型</td>
            <td style="width: 10px;">单位</td>
            <td style="width: 10px;">订单数量</td>
            <td style="width: 10px;">单价</td>
            <td style="width: 10px;">订单金额</td>
        </tr>
        #for (var i=0; i< data.length; i++) { #
        <tr>
            <td>#= data[i].wareNm #</td>
            <td>#= data[i].xsTp #</td>
            <td>#= data[i].wareDw #</td>
            <td>#= data[i].wareNum #</td>
            <td>#= data[i].wareDj #</td>
            <td>#= data[i].wareZj #</td>
        </tr>
        # }#
        </tbody>
    </table>
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();

        uglcw.ui.get('#search').on('click', function () {   //搜索（查询）
            uglcw.ui.get('#grid').k().dataSource.read();
        })

        uglcw.ui.get('#reset').on('click', function () {    //重置（清除搜索输入框数据）
            uglcw.ui.clear('.uglcw-query');
        })


        uglcw.ui.loaded()
    })


    function toaddJxsjb() {//添加客户等级
        uglcw.ui.Modal.open({
            area: '500px',
            content: $('#t').html(),
            success: function (container) {
                uglcw.ui.init($(container));
            },
            yes: function (container) {
                var valid = uglcw.ui.get($(container).find('.form-horizontal')).validate();
                if (valid) {
                    $.ajax({
                        url: '${base}/manager/operJxsjb',
                        data: uglcw.ui.bind(container),  //绑定值
                        type: 'post',
                        success: function (data) {
                            if (data == "1" || data == "2") {
                                uglcw.ui.get('#grid').reload();//刷新页面数据
                            } else {
                                uglcw.ui.error('失败');//错误提示
                                return;
                            }
                        }
                    })
                } else {
                    uglcw.ui.error('失败');
                    return false;
                }
            }
        });
    }

    function getSelected() {//修改
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            uglcw.ui.Modal.open({
                area: '500px',
                content: $('#t').html(),
                success: function (container) {
                    uglcw.ui.init($(container));//初始化
                    uglcw.ui.bind($(container).find('#bind'), selection[0]);//邦定数据
                },
                yes: function (container) {
                    var valid = uglcw.ui.get($(container).find('.form-horizontal')).validate();
                    if (valid) {
                        $.ajax({
                            url: '${base}/manager/operJxsjb',
                            data: uglcw.ui.bind(container),  //绑定值
                            type: 'post',
                            success: function (data) {
                                if (data == "1" || data == "2") {
                                    uglcw.ui.get('#grid').reload();//刷新页面数据
                                } else {
                                    uglcw.ui.error('失败');//错误提示
                                    return;
                                }
                            }
                        })
                    } else {
                        uglcw.ui.error('失败');
                        return false;
                    }
                }
            });
        } else {
            uglcw.ui.warning('请选择要修改的行！');
        }
    }

    function toDel() {   //删除
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) { //判断是否为空
            uglcw.ui.confirm('是否要删除选中的经销商级别?', function () {
                $.ajax({
                    url: '${base}/manager/deleteJxsjbById',
                    data: {
                        id: selection[0].id
                    },
                    type: 'post',
                    dataType: 'json',
                    success: function (json) {
                        if (json) {
                            if (json == '1') {
                                uglcw.ui.success('删除成功');//错误提示
                                uglcw.ui.get('#grid').reload();
                            }
                        } else {
                            uglcw.ui.error('删除失败');
                        }
                    }
                })
            })
        } else {
            uglcw.ui.warning('请选择要删除的行！');
        }
    }
</script>
</body>
</html>
