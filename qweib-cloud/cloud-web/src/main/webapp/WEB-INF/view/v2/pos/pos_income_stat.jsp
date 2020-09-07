<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>各门店报表-零售毛利统计表</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .query .k-widget.k-numerictextbox {
            display: none;
        }
    </style>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="uglcw-layout-container">
        <div class="uglcw-layout-fixed" style="width: 200px">
            <div class="layui-card">
                <div class="layui-card-header">
                    库存商品类
                </div>
                <div class="layui-card-body" uglcw-role="resizable" uglcw-options="responsive:[75]">
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
                        url:'${base}manager/waretypes',
                        select: function(e){
                            var node = this.dataItem(e.node)
                            uglcw.ui.get('#wtype').value(node.id);
                            uglcw.ui.get('#click-flag').value(0);
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
                    <ul class="uglcw-query form-horizontal query">
                        <li>
                            <input type="hidden" uglcw-role="textbox" uglcw-model="database" id="database"
                                   value="${database}">
                            <input uglcw-model="sdate" uglcw-role="datepicker" id="sdate" value="${sdate}">
                        </li>
                        <li>
                            <input uglcw-model="edate" uglcw-role="datepicker" id="edate" value="${edate}">
                        </li>
                        <li>
                            <select uglcw-role="combobox"
                                    uglcw-options="
                                        url: '${base}manager/pos/queryShopRight',
                                        value: '${shopNo}',
                                         loadFilter:{
                                             data: function(response){
                                                var rows = response.rows ||[];
                                                return rows;
                                             }
                                          },

                                           dataTextField: 'shopName',
                                           dataValueField:'shopNo'
                                        "
                                    uglcw-model="shopNo" id="shopName" placeholder="连锁店">
                                <option value="">全部</option>
                            </select>
                        </li>
                        <li>
                            <input id="wtype" type="hidden" uglcw-model="wtype" uglcw-role="textbox">
                            <input uglcw-role="textbox" uglcw-model="wareNm" id="wareNm" placeholder="商品名称">
                        </li>
                        <li>
                            <input type="hidden" uglcw-role="textbox"id="click-flag" value="0"/>
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
                         checkbox: true,
                          loadFilter: {
                         data: function (response) {
                             response.rows.splice( response.rows.length - 1, 1);
                             return response.rows || []
                         },
                       aggregates: function (response) {
                         var aggregate = {
                             sumQty:0,
                            sumAmt:0,
                            avgPrice:0,
                            sumCost:0,
                            sumCost:0,
                            avgCost:0,
                            disAmt:0,
                            avgAmt:0,
                            avgRate:0
                         };
                       if (response.rows && response.rows.length > 0) {
                            aggregate = uglcw.extend(aggregate,response.rows[response.rows.length - 1]);
                       }
                        return aggregate;
                       }
                     },
                    responsive:['.header',40],
                    id:'id',
                    toolbar: kendo.template($('#toolbar').html()),
                    url: '${base}manager/pos/queryPosIncomeStat',
                    criteria: '.form-horizontal',
                    query: function(param){
                        if(uglcw.ui.get('#click-flag').value()==1){
                            delete param['wtype']
                        }
                        param.edate+=' 23:59:00';
                        return param;
                    },
                      aggregate:[
                      {field: 'sumQty', aggregate: 'SUM'},
                     {field: 'sumAmt', aggregate: 'SUM'},
                     {field: 'avgPrice', aggregate: 'SUM'},
                     {field: 'sumCost', aggregate: 'SUM'},
                     {field: 'avgCost', aggregate: 'SUM'},
                     {field: 'disAmt', aggregate: 'SUM'},
                     {field: 'avgAmt', aggregate: 'SUM'},
                     {field: 'avgRate', aggregate: 'SUM'}
                    ],
                    pageable: true,

                    ">
                        <div data-field="wareNm" uglcw-options="width:180,footerTemplate: '合计'">商品名称</div>
                        <div data-field="sumQty"
                             uglcw-options="width:160, template: '#= data.sumQty ? uglcw.util.toString(data.sumQty,\'n2\'): \' \'#',
                             footerTemplate: '#= uglcw.util.toString((data.sumQty||0),\'n2\')#'">
                            销售数量
                        </div>
                        <div data-field="avgPrice"
                             uglcw-options="width:160,  template: '#= data.avgPrice ? uglcw.util.toString(data.avgPrice,\'n2\'): \' \'#',
                             footerTemplate: '#= uglcw.util.toString((data.avgPrice||0),\'n2\')#'">
                            平均售价
                        </div>
                        <div data-field="sumAmt"
                             uglcw-options="width:160,  template: '#= data.sumAmt ? uglcw.util.toString(data.sumAmt,\'n2\'): \' \'#',
                             footerTemplate: '#= uglcw.util.toString((data.sumAmt||0),\'n2\')#'">
                            销售金额
                        </div>

                        <div data-field="sumCost"
                             uglcw-options="width:160,  template: '#= data.sumCost ? uglcw.util.toString(data.sumCost,\'n2\'): \' \'#',
                             footerTemplate: '#= uglcw.util.toString((data.sumCost||0),\'n2\')#'">
                            销售成本
                        </div>

                        <div data-field="avgCost"
                             uglcw-options="width:160,  template: '#= data.avgCost ? uglcw.util.toString(data.avgCost,\'n2\'): \' \'#',
                             footerTemplate: '#= uglcw.util.toString((data.avgCost||0),\'n2\')#'">
                            销售成本
                        </div>
                        <div data-field="disAmt"
                             uglcw-options="width:160,  template: '#= data.disAmt ? uglcw.util.toString(data.disAmt,\'n2\'): \' \'#',
                             footerTemplate: '#= uglcw.util.toString((data.disAmt||0),\'n2\')#'">
                            销售毛利
                        </div>
                        <div data-field="avgAmt"
                             uglcw-options="width:160,  template: '#= data.avgAmt ? uglcw.util.toString(data.avgAmt,\'n2\'): \' \'#',
                             footerTemplate: '#= uglcw.util.toString((data.avgAmt||0),\'n2\')#'">
                            平均单位毛利
                        </div>

                        <div data-field="avgRate"
                             uglcw-options="width:160,  template: '#= data.avgRate ? uglcw.util.toString(data.avgRate,\'n2\'): \' \'#',
                             footerTemplate: '#= uglcw.util.toString((data._avgRate||0),\'n2\')#'">
                            毛利率
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:toExport();" class="k-button k-button-icontext">
        <span class="k-icon k-i-download"></span>导出
    </a>
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<tag:exporter service="posSaleStatService" method="queryWareStatPage"
              bean="com.qweib.cloud.biz.pos.model.PosWareStatVo"
              description="商品销售排行"
              beforeExport="beforeExport"
/>
<script>
    function beforeExport(param) {//构造参数
        return {
            waretype: parseInt(uglcw.ui.get("#wareType").value() || 0),
            wareNm: uglcw.ui.get("#wareNm").value(),
            shopNo: uglcw.ui.get("#shopName").value(),
            database: uglcw.ui.get("#database").value(),
            sdate: uglcw.ui.get("#sdate").value(),
            edate: uglcw.ui.get("#edate").value() + " 23:59:00",
        };
    }
</script>
<script>

    $(function () {
        uglcw.ui.init();
        //显示商品
        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#click-flag').value(1);
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
