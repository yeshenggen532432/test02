<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>车辆配送统计</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        ::-webkit-input-placeholder {
            color:black;
        }
        .biz-type.k-combobox{
            font-weight: bold;

        }
        .biz-type .k-input{
            color: black;
            background-color: rgba(0, 123, 255, .35);
        }
        .uglcw-query>li.xs-tp #billName_taglist {
            position: fixed;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal">
                <li>
                    <input type="hidden" id="database" uglcw-model="database" uglcw-role="textbox" value="${database}">
                    <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                </li>

                <li>
                    <select uglcw-model="outType" id="outType" uglcw-role="combobox" uglcw-options="
                     placeholder:'出库类型',
                     change: function(){
                        uglcw.ui.get('#billName').k().dataSource.read();
                     }">
                        <option value="销售出库">销售出库</option>
                        <option value="其它出库">其它出库</option>
                    </select>
                </li>
                <li style="width: 180px!important;" class="xs-tp">
                    <input id="billName" uglcw-role="multiselect" uglcw-model="billName" uglcw-options="
                    placeholder:'销售类型',
                    tagMode: 'single',
                    tagTemplate: uglcw.util.template($('#xp-type-tag-template').html()),
                    autoClose: false,
                    url: '${base}manager/loadXsTp',
                    data: function(){
                        return {
                            outType: uglcw.ui.get('#outType').value()
                        }
                    },
                    loadFilter:{
                        data: function(response){
                            return response.list || []
                        }
                    },
                    dataTextField: 'xsTp',
                    dataValueField: 'xsTp'
                ">
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="vehNo" placeholder="车牌号"/>
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="driverName" placeholder="送货人"/>
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="wareNm" placeholder="品名"/>
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
                    autoBind: false,
                    responsive:['.header',40],
                    toolbar: uglcw.util.template($('#toolbar').html()),
                    id:'id',
                    url: '${base}manager/queryVehicleTotalStatPage',
                    criteria: '.form-horizontal',
                    pageable: true,
                    aggregate:[
                     {field: 'outQty', aggregate: 'sum'}

                    ],
                    dblclick: function(row){
                        var q = uglcw.ui.bind('.form-horizontal');
                        q.vehNo = row.vehNo;
                        uglcw.ui.openTab('车辆配送客户统计表', '${base}manager/queryVehicleCustomerStat?'+ $.map(q, function(v, k){
                            return k+'='+(v||'');
                        }).join('&'));
                    },
                    loadFilter: {
                      data: function (response) {
                        if(!response || !response.rows || response.rows.length <1){
                            return [];
                        }
                        response.rows.splice(response.rows.length - 1, 1);
                        return response.rows;
                      },
                      total: function (response) {
                        return response.total;
                      },
                      aggregates: function (response) {
                        var aggregate = {
                            outQty:0,
                            ioPrice:0
                        };
                        if (response.rows && response.rows.length > 0) {
                            aggregate = uglcw.extend(aggregate, response.rows[response.rows.length - 1]);
                        }
                        return aggregate;
                      }
                     }

                    ">
                <div data-field="vehNo" uglcw-options="">车牌号</div>
                <div data-field="outQty"
                     uglcw-options="format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.outQty.sum != undefined ? data.outQty.sum : data.outQty,\'n2\')#'">
                    发货数量
                </div>
                <div data-field="ioPrice"
                     uglcw-options="format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.ioPrice || 0, \'n2\')#'">
                    配送费用
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-uglcw-template" id="xp-type-tag-template">
    <div style="width: 130px;
            text-overflow: ellipsis;
            white-space: nowrap">
        # for(var idx = 0; idx < values.length; idx++){ #
        #: values[idx]#
        # if(idx < values.length - 1) {# , # } #
        # } #
    </div>
</script>
<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:queryRpt();" class="k-button k-button-icontext">
        <span class="k-icon k-i-search"></span>查看生成的报表
    </a>
    <a role="button" href="javascript:toRptData();" class="k-button k-button-icontext">
        <span class="k-icon k-i-search"></span>车辆客户统计表
    </a>
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        uglcw.ui.init();
        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        })

        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal', {sdate: '${sdate}', edate: '${edate}'});
        })

        uglcw.ui.loaded()
    })


    function showMainDetail() {
        var q = uglcw.ui.bind('.form-horizontal');
        uglcw.ui.openTab('查看客户毛利明细', '${base}manager/queryCstStatDetailList?' + $.map(q, function (v, k) {
            return k + '=' + (v || '');
        }).join('&'));
    }

    function exportExcel() {
    }

    function toRptData() {
        var query = uglcw.ui.bind('.form-horizontal');
        uglcw.ui.openTab('车辆配送客户统计表', "${base}manager/queryVehicleCustomerStat?" + $.map(query, function (v, k) {
            return k + '=' + (v || '');
        }).join('&'));
    }

    function queryRpt() {
        uglcw.ui.openTab('车辆配送客户生成的统计表', '${base}manager/querySaveRptDataStat?rptType=1');
    }

</script>
</body>
</html>
