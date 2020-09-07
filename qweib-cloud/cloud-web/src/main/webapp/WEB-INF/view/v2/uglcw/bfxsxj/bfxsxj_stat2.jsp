<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>驰用T3</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="uglcw-layout-container">
        <div class="uglcw-layout-fixed" style="width:200px">
            <div class="layui-card">
                <div class="layui-card-header">
                    库存商品类
                </div>
                <div class="layui-card-body">
                    <div id="tree" uglcw-role="tree"
                         uglcw-options="
                        expandable: function(node){
                        return node.id === 0;
                       },
                        loadFilter: function (response) {
                        $(response).each(function (index, item) {
                            if (item.text == '根节点') {
                                item.text = '库存商品类'
                            }
                        })
                        return response;
                        },
                        url:'manager/syswaretypes',
                        select: function(e){
                            var node = this.dataItem(e.node)
                            uglcw.ui.get('#wareType').value(node.id);
                            uglcw.ui.get('#grid').reload();
                        }
                    "
                    >
                    </div>
                </div>
            </div>
        </div>
        <div class="uglcw-layout-content">
            <div class="layui-card header">
                <div class="layui-card-body">
                    <ul class="uglcw-query form-horizontal">
                        <li>
                            <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}">
                        </li>
                        <li>
                            <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                        </li>
                        <li>
                            <input type="hidden" uglcw-model="jz" value="1" uglcw-role="textbox">
                            <input id="wareType" type="hidden" uglcw-model="waretype" uglcw-role="textbox">
                            <input uglcw-role="textbox" uglcw-model="wareNm" placeholder="商品名称">
                        </li>
                        <li>
                            <select uglcw-role="combobox" uglcw-model="noCompany" placeholder="公司类别"
                                    uglcw-options="index:-1">
                                <option value="0">全部</option>
                                <option value="2">公司类别</option>
                                <option value="1">非公司类别</option>
                            </select>
                        </li>
                        <li>
                            <select uglcw-role="combobox" uglcw-model="customerType"
                                    placeholder="客户类型"
                                    uglcw-options="
                                            url: '${base}manager/queryarealist1',
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
                            <select uglcw-role="combobox" uglcw-model="hzfsNm" placeholder="合作方式"
                                    uglcw-options="index:-1">
                                <option value="">合部</option>
                                <c:forEach items="${hzfsls}" var="hzfsls">
                                    <option value="${hzfsls.hzfsNm}"
                                            <c:if test="${hzfsls.hzfsNm==customer.hzfsNm}">selected</c:if>>${hzfsls.hzfsNm}</option>
                                </c:forEach>
                            </select>
                        </li>
                        <li>
                            <input uglcw-model="regionNm" uglcw-role="textbox" placeholder="所属片区">
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
                         uglcw-options="
                         checkbox:'true',
                    responsive:['.header',40],
                    id:'id',
                    url: '${base}manager/queryMemBfXsxjStatPage',
                    criteria: '.form-horizontal',
                    pageable: true,
                    ">

                        <div data-field="wareNm" uglcw-options="width:260">商品名称</div>
                        <div data-field="kcNum" uglcw-options="width:260">最后库存数</div>
                        <div data-field="wareRate" uglcw-options="width:260">市场占比%</div>
                        <div data-field="saleRate" uglcw-options="width:260">铺货率%</div>
                        <div data-field="cstQty" uglcw-options="width:260">在售商家数</div>
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
    })


</script>
</body>
</html>
