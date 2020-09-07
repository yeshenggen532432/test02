<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>各门店报表-商品排行</title>
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
                <div class="layui-card-body" uglcw-role="resizable" uglcw-options="responsive: [75]">
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
                        url:'manager/waretypes',
                        select: function(e){
                            var node = this.dataItem(e.node)
                            uglcw.ui.get('#wareType').value(node.id);
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
                    <ul class="uglcw-query form-horizontal">
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
                            <input uglcw-role="textbox" uglcw-model="wareNm" id="wareNm" placeholder="商品名称">
                        </li>
                        <li>
                            <input id="wareType" type="hidden" uglcw-model="waretype" uglcw-role="textbox">
                            <input uglcw-role="textbox" uglcw-model="khNm" placeholder="客户名称">
                        </li>
                        <li>
                            <input type="hidden" uglcw-role="textbox"id="click-flag" value="0"/>
                            <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                            <button id="reset" class="k-button" uglcw-role="button">重置</button>
                        </li>
                        <li style="width: 160px;">
                            <input type="checkbox" id="hideZero"
                                   uglcw-options="type:'number'"
                                   uglcw-model="hideZero" uglcw-value="0" uglcw-role="checkbox">
                            <label style="margin-top: 10px;" for="hideZero">过滤数量为0的记录否</label>
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
                    checkbox: true,
                    toolbar: kendo.template($('#toolbar').html()),
                    url: '${base}manager/pos/queryPosWareStatPage',
                    criteria: '.form-horizontal',
                    query: function(param){
                        if(uglcw.ui.get('#click-flag').value()==1){
                        delete param['waretype']
                        }
                        param.edate+='23:59:00';
                        return param;
                    },
                      aggregate:[
                     {field: 'sumQty', aggregate: 'SUM'},
                     {field: 'sumAmt', aggregate: 'SUM'}
                    ],
                    pageable: true,

                    ">
                        <div data-field="wareNm" uglcw-options="width:180,footerTemplate: '合计'">商品名称</div>
                        <div data-field="sumQty"
                             uglcw-options="width:160, template: '#= data.sumQty ? uglcw.util.toString(data.sumQty,\'n2\'): \' \'#',
                             footerTemplate: '#= uglcw.util.toString((data.sumQty||0),\'n2\')#'">
                            销售数量
                        </div>
                        <div data-field="sumAmt"
                             uglcw-options="width:160,  template: '#= data.sumAmt ? uglcw.util.toString(data.sumAmt,\'n2\'): \' \'#',
                             footerTemplate: '#= uglcw.util.toString((data.sumAmt||0),\'n2\')#'">
                            销售金额
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
            hideZero: uglcw.ui.get("#hideZero").value(),
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
        uglcw.layout.init();
        //显示商品
        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#click-flag').value(1); //搜索标记
            uglcw.ui.get('#grid').k().dataSource.read();
        })

        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal', {
                sdate: '${sdate}', edate: '${edate}'
            });
        })

        uglcw.ui.get('#hideZero').on('change', function () { //实时监听
            uglcw.ui.get('#grid').reload();
        })

        uglcw.ui.loaded()
    })


</script>
</body>
</html>
