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
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal" id="bind">
                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="customerType"
                            placeholder="客户类型"
                            uglcw-options="
                                            url: '${base}/manager/queryarealist1',
                                            dataTextField: 'qdtpNm',
                                            dataValueField: 'qdtpNm',
                                            index:-1,
                                            loadFilter:{
                                             data: function(response){    //过滤数据
                                               return response.list1 || []
                                             }
                                            }
                                        "
                    >
                    </select>
                </li>
                <li>
                    <input uglcw-model="khNm" uglcw-role="textbox" placeholder="客户名称">
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="hzfsNm" placeholder="合作方式">
                        <option value="">合部</option>
                        <c:forEach items="${hzfsls}" var="hzfsls">
                            <option value="${hzfsls.hzfsNm}"
                                    <c:if test="${hzfsls.hzfsNm==customer.hzfsNm}">selected</c:if>>${hzfsls.hzfsNm}</option>
                        </c:forEach>
                    </select>
                </li>
                <li>
                    <input uglcw-model="staff" uglcw-role="textbox" placeholder="业务员">
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
                 uglcw-options="{
                         loadFilter: {
                         data: function (response) {
                         response.rows.splice( response.rows.length - 1, 1);
                         return response.rows || []
                       },
                       aggregates: function (response) {
                         var aggregate = {
                             sumQty:0,
                             sumAmt:0
                       };
                       if (response.rows && response.rows.length > 0) {
                            aggregate = uglcw.extend(aggregate,response.rows[response.rows.length - 1]);
                       }
                        return aggregate;
                       }
                     },
                    responsive:['.header',40],
                    id:'id',
                    url: '${base}/manager/queryMemBfStatPage',
                    criteria: '.form-horizontal',
                    pageable: true,
                      aggregate:[
                     {field: 'cstQty', aggregate: 'SUM'},
                     {field: 'bfQty', aggregate: 'SUM'},
                     {field: 'bfQty1', aggregate: 'SUM'},
                     {field: 'bfRate', aggregate: 'SUM'},
                     {field: 'wbfQty', aggregate: 'SUM'},
                     {field: 'wbfRate', aggregate: 'SUM'}
                    ],

                    }">

                <div data-field="memberNm" uglcw-options="width:120,footerTemplate: '合计'">业务员</div>
                <div data-field="cstQty" uglcw-options="{width:120,
                             footerTemplate: '#=data.cstQty#'}">客户数
                </div>
                <div data-field="bfQty" uglcw-options="{width:120,
                             footerTemplate: '#=data.bfQty#'}">拜访所属客户数
                </div>
                <div data-field="bfQty1" uglcw-options="{width:140,
                             footerTemplate: '#=data.bfQty1#'}">拜访非所属客户数
                </div>
                <div data-field="bfRate" uglcw-options="width:120,
                               template:'#=data.bfRate!=undefined ? (data.bfRate +\'%\'): \' \'#' ,
                                    footerTemplate: '#= uglcw.util.toString((data.bfRate+\'%\'||0),\'n2\')#'">拜访率%
                </div>
                <div data-field="wbfQty" uglcw-options="{width:120,
                             footerTemplate: '#=data.wbfQty#'}">未拜访商家数
                </div>
                <div data-field="wbfRate" uglcw-options="{width:120,
                              template:'#=data.wbfRate ? (data.wbfRate +\'%\'): \' \'#' ,
                                 footerTemplate: '#= uglcw.util.toString((data.wbfRate+\'%\'||0),\'n2\')#'}">未拜访率%
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

        uglcw.ui.get('#reset').on('click', function () {    //重置
            uglcw.ui.clear('.form-horizontal');
        })
        uglcw.ui.loaded()
    })


</script>
</body>
</html>
