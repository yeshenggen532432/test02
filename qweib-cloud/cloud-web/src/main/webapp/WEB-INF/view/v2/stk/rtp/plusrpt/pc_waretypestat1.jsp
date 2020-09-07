<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>按上类别销售统计明细</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-card">
        <div class="layui-card-body full">
            <div class="query">
                <input type="hidden" uglcw-role="textbox" uglcw-model="sdate" value="${sdate}"/>
                <input type="hidden" id="database" uglcw-model="database" uglcw-role="textbox" value="${datasource}">
                <input type="hidden" uglcw-role="textbox" uglcw-model="edate" value="${edate}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="outType" value="${outType}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="xsTp" value="${xsTp}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="staff" value="${staff}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="khNm" value="${khNm}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="wareNm" value="${wareNm}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="typeName" value="${typeName}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="typeId" value="${typeId}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="typeLevel" value="${typeLevel}"/>
                <input type="hidden" uglcw-role="textbox" uglcw-model="isRec" value="${isRec}"/>
            </div>
            <div id="grid" uglcw-role="grid"
                 uglcw-options="
                        toolbar: kendo.template($('#toolbar').html()),
                        id:'id',
                        align:'center',
                          responsive:['.header',40],
                        <%--dblclick: function(row){--%>
                          <%--showDetail(row.id, row.outType, row.outId);--%>
                        <%--},--%>
                        dataBound: function(){
                            filterField();
                        },
                        dblclick: function(row){
                            var q = uglcw.ui.bind('.query');
                            q.typeId = row.id;
                            q.typeLevel= row.typeLevel+1;
                            q.filterDataType='${filterDataType}';
                             var typeLevel = row.typeLevel + 1;
                            if(typeLevel>2){
                                q.typeLevel=typeLevel;
                                      uglcw.ui.openTab('类别统计-'+row.typeName, '${base}manager/toStkWareTypeStat2?'+ $.map(q, function(v, k){
                                    return k+'='+ (v||'');
                                }).join('&'));
                                return;
                            }
                             q.typeLevel=typeLevel;
                                  uglcw.ui.openTab('类别统计-'+row.typeName, '${base}manager/toStkWareTypeStat1?'+ $.map(q, function(v, k){
                                return k+'='+ (v||'');
                            }).join('&'));

                         },
                        url: '${base}manager/queryWareTypeStat',
                        criteria: '.query',
                    ">
                <div data-field="typeName" uglcw-options="width:150">类别/商品名称</div>
                <div data-field="price" uglcw-options="width:160, format: '{0:n2}'">销售均价</div>
                <div data-field="sumQty" uglcw-options="width:160, format: '{0:n2}'">数量</div>
                <div data-field="sumAmt" uglcw-options="width:150, format: '{0:n2}'">销售金额</div>
                <div data-field="freeQty" uglcw-options="width:120, format: '{0:n2}'">赠送数量</div>
                <div data-field="unitName" uglcw-options="width:120">计量单位</div>
                <div data-field="minPrice" uglcw-options="width:160, format: '{0:n2}'">销售均价(小)</div>
                <div data-field="minSumQty" uglcw-options="width:160, format: '{0:n2}'">数量(小)</div>
                <div data-field="minFreeQty" uglcw-options="width:120, format: '{0:n2}'">赠送数量(小)</div>
                <div data-field="minUnitName" uglcw-options="width:120">计量单位(小)</div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:toExport();" class="k-button k-button-icontext">
        <span class="k-icon k-i-excel"></span>导出
    </a>
    <a role="button" href="javascript:print();" class="k-button k-button-icontext">
        <span class="k-icon k-i-info"></span>打印
    </a>
</script>
<tag:exporter service="incomeStatService" method="sumWareTypeStat1"
              bean="com.qweib.cloud.biz.erp.model.StkWareTypeStatVo"
              condition=".query" description="商品类型销售统计"

/>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script src="${base }/resource/jquery.jdirk.js" type="text/javascript" charset="utf-8"></script>
<script>

    $(function () {
        uglcw.ui.init();
        uglcw.ui.loaded()
    })

    function exportExcel() {

    }
    function filterField(){
        var grid = uglcw.ui.get('#grid');
        if('${filterDataType}'==1){
            grid.showColumn('price');
            grid.showColumn('sumQty');
            grid.showColumn('freeQty');
            grid.hideColumn('minPrice');
            grid.hideColumn('minSumQty');
            grid.hideColumn('minFreeQty');
        }else if('${filterDataType}'==2){
            grid.hideColumn('price');
            grid.hideColumn('sumQty');
            grid.hideColumn('freeQty');
            grid.showColumn('minPrice');
            grid.showColumn('minSumQty');
            grid.showColumn('minFreeQty');
        }else if('${filterDataType}'==3){
            grid.showColumn('price');
            grid.showColumn('sumQty');
            grid.showColumn('freeQty');
            grid.showColumn('minPrice');
            grid.showColumn('minSumQty');
            grid.showColumn('minFreeQty');
        }
    }

    function print() {
        var query = uglcw.ui.bind('.query');
        query.filterDataType=${filterDataType};
        var sdate = query.sdate;
        var edate = query.edate;
        if(sdate==""){
            uglcw.ui.info("开始日期不能为空!");
            return;
        }
        if(edate==""){
            uglcw.ui.info("结束日期不能为空!");
            return;
        }
        var dis =$.date.diff(sdate, 'm', edate);
        if((dis+1)>3){
            uglcw.ui.info("最多只能打印3个月之间的数据");
            return;
        }

        uglcw.ui.openTab('打印按商品类别销售统计表', "${base}manager/toStkWareTypeStatPrint?" + $.map(query, function (v, k) {
            return k + '=' + (v || '');
        }).join('&'));
    }

</script>
</body>
</html>
