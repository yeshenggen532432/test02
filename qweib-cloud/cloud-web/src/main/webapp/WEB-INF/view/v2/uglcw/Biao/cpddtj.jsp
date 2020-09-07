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
                                <select uglcw-role="combobox" uglcw-model="xsTp" placeholder="销售类型"
                                        uglcw-options="value:''">
                                    <option value="正常销售">正常销售</option>
                                    <option value="促销折让">促销折让</option>
                                    <option value="消费折让">消费折让</option>
                                    <option value="费用折让">费用折让</option>
                                    <option value="其它">其它</option>
                                </select>
                            </li>
                            <li>
                                <select uglcw-role="combobox" uglcw-model="pszd" placeholder="配送指定"
                                        uglcw-options="value:''">
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
                    url: '${base}manager/cpddtjPage?dataTp=1',
                    criteria: '.query',
                    pageable: true,
                    aggregate:[
                     {field: 'nums', aggregate: 'SUM'},
                     {field: 'zjs', aggregate: 'SUM'}
                    ]">
                            <div data-field="wareNm"
                                 uglcw-options="width:140,footerTemplate: '合计'">商品名称
                            </div>
                            <div data-field="xsTp" uglcw-options="width:120">销售类型</div>
                            <div data-field="wareDw" uglcw-options="width:100">单位</div>
                            <div data-field="nums"
                                 uglcw-options="width:100,footerTemplate: '#= uglcw.util.toString(data.nums,\'n2\')#'">订单数量
                            </div>
                            <div data-field="wareDj" uglcw-options="width:100">单价</div>
                            <div data-field="zjs"
                                 uglcw-options="width:100,footerTemplate: '#= uglcw.util.toString(data.zjs,\'n2\')#'">订单金额
                            </div>
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

            uglcw.ui.get('#search').on('click', function () {   //搜索（查询）
                uglcw.ui.get('#grid').k().dataSource.read();
            })

            uglcw.ui.get('#reset').on('click', function () {    //重置（清除搜索输入框数据）
                uglcw.ui.clear('.uglcw-query');
            })

            uglcw.ui.loaded()
        })


    </script>
</body>
</html>
