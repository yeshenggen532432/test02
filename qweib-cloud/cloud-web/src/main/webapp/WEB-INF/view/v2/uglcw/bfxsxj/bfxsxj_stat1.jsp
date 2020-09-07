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
                <div class="layui-card-body" uglcw-role="resizable" uglcw-options="responsive: [75]">
                    <div id="tree" uglcw-role="tree"
                         uglcw-options="
                        url:'manager/syswaretypes',
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
                        select: function(e){
                            var node = this.dataItem(e.node)
                            uglcw.ui.get('#wareType').value(node.id);
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
                    <ul class="uglcw-query query form-horizontal">
                        <li>
                            <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}">
                        </li>
                        <li>
                            <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                        </li>
                        <li>
                            <input id="wareType" type="hidden" uglcw-model="waretype" uglcw-role="textbox">
                            <input uglcw-role="textbox" uglcw-model="khNm" placeholder="客户名称">
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
                            <select uglcw-role="combobox" uglcw-model="noCompany" placeholder="公司类别"
                                    uglcw-options="value: ''">
                                <option value="2">公司类别</option>
                                <option value="1">非公司类别</option>
                            </select>
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
                    checkbox: true,
                    toolbar: kendo.template($('#toolbar').html()),
                    url: '${base}manager/sumBfxsxjPage1',
                    criteria: '.uglcw-query',
                    pageable: true,
                    aggregate:[
                     {field: 'kcNum', aggregate: 'SUM'},
                     {field: 'kcNum1', aggregate: 'SUM'},
                    ],
                    loadFilter: {
                      data: function (response) {
                        response.rows.splice(response.rows.length - 1, 1);
                        console.log(response.rows);
                        return response.rows || []
                      },
                      total: function (response) {
                        return response.total;
                      },
                      aggregates: function (response) {
                        var aggregate = {};
                        if (response.rows && response.rows.length > 0) {
                            aggregate = response.rows[response.rows.length - 1]
                        }
                        console.log(aggregate);
                        return aggregate;
                      }
                     }
                    ">
                        <div data-field="khNm" uglcw-options="width:180">客户名称</div>
                        <div data-field="kcNum" uglcw-options="width:220, footerTemplate: '#= data.kcNum#'">公司产品最后库存数
                        </div>
                        <div data-field="kcNum1" uglcw-options="width:220,footerTemplate: '#= data.kcNum1#'">非公司产品最后库存数
                        </div>
                        <div data-field="dhNum" uglcw-options="width:160">到货数量</div>
                        <div data-field="sxNum" uglcw-options="width:160">实销数量</div>
                        <div data-field="ddNum" uglcw-options="width:160">订单数量</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript: toExport();" class="k-button k-button-icontext">
        <span class="k-icon k-i-download"></span>导出
    </a>
</script>
<tag:exporter service="sysBfxsxjService" method="sumBfxsxjPage1"
              bean="com.qweib.cloud.core.domain.SysBfxsxj"
              condition=".query" description="拜访销售总结汇总表"

/>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        uglcw.ui.init();
        //显示商品
        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').k().dataSource.read();
        })

        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.uglcw-query', {
                sdate: '${sdate}', edate: '${edate}'
            });
        })
        uglcw.ui.loaded()
    })


    function doExport() {
        //TODO 导出公共页面;
        exportData('sysBfxsxjService', 'sumBfxsxjPage1', 'com.cnlife.uglcw.model.SysBfxsxj', "{sdate:" + sdate + ",edate:" + edate + ",database:'" + database + "',customerType:'" + customerType + "',noCompany:" + noCompany + ",khNm:'" + khNm + "'}", "拜访销售总结汇总表");
    }

</script>
</body>
</html>
