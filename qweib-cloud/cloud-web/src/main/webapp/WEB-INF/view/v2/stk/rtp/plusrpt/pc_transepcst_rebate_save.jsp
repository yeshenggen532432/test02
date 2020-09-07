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
            <ul class="uglcw-query form-horizontal">
                <li style="width: 300px;">
                    <input type="hidden" uglcw-model="sdate" uglcw-role="textbox" value="${sdate}"/>
                    <input type="hidden" uglcw-model="edate" uglcw-role="textbox" value="${edate}"/>
                    <input type="hidden" uglcw-model="outType" uglcw-role="textbox" value="${outType}"/>
                    <input type="hidden" uglcw-model="customerType" uglcw-role="textbox" value="${customerType}"/>
                    <input type="hidden" uglcw-model="khNm" uglcw-role="textbox" value="${khNm}"/>
                    <input type="hidden" uglcw-model="epCustomerName" uglcw-role="textbox" value="${epCustomerName}"/>
                    <input type="hidden" uglcw-model="timeType" uglcw-role="textbox" value="${dateType}"/>
                    <input type="hidden" uglcw-model="wareNm" uglcw-role="textbox" value="${wareNm}"/>


                    <input uglcw-model="rptTitle" uglcw-role="textbox" value="${title}" placeholder="标题">
                </li>
                <li>
                    <input uglcw-model="remarks" uglcw-role="textbox" placeholder="备注">
                </li>
                <li>
                    <button class="k-button k-info" onclick="saveRpt()">保存</button>
                </li>
            </ul>
        </div>
    </div>
</div>
<div class="layui-card">
    <div class="layui-card-body full">
        <div id="grid" uglcw-role="grid"
             uglcw-options="
			  		responsive:['.header',40],
                    id:'id',
                    url: '${base}manager/queryStkCstTransRebate',
                    criteria: '.form-horizontal',
                    pageable: false,
                    query: function(q){
                        delete q['rows'];
                        return q;
                    },
                    loadFilter: {
                         data: function (response) {
                             response.rows.splice( response.rows.length - 1, 1);
                             return response.rows || []
                         },
                         aggregates: function (response) {
                             var aggregate={
                                    outQty:0,
                                    rate:0,
                                    amt:0
                             }
                             if (response.rows && response.rows.length > 0) {
                                 aggregate = uglcw.extend(aggregate,response.rows[response.rows.length - 1]);

                            }
                            return aggregate;
                     }
                    },
				    aggregate:[
						{field: 'outQty', aggregate: 'SUM'},
						{field: 'rate', aggregate: 'SUM'},
						{field: 'amt', aggregate: 'SUM'}

				    ]
                    ">
            <div data-field="epCustomerName" uglcw-options="width:100, tooltip: true,footerTemplate: '合  计:'">所属二批客户名称
            </div>
            <div data-field="khNm" uglcw-options="width:100,tooltip: true">终端客户名称</div>
            <div data-field="wareNm" uglcw-options="width:100">商品名称</div>
            <div data-field="outQty"
                 uglcw-options="width:100,format: '{0:n2}',footerTemplate: '#= uglcw.util.toString(data.outQty,\'n2\')#'">
                发货数量
            </div>
            <div data-field="rate"
                 uglcw-options="width:100,format: '{0:n2}',footerTemplate: '#= uglcw.util.toString(data.rate,\'n2\')#'">
                单件返利
            </div>
            <div data-field="amt"
                 uglcw-options="width:100,format: '{0:n2}',footerTemplate: '#= uglcw.util.toString(data.amt,\'n2\')#'">
                返利总额
            </div>
        </div>
    </div>
</div>
</div>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        uglcw.ui.init();
        uglcw.ui.loaded()
    })

    function saveRpt() {//保存
        var rows = uglcw.ui.get('#grid').value();//获取行的数据
        var cols = $.map(uglcw.ui.get('#grid').k().options.columns, function (col) {
            return {field: col.field, title: col.title.trim()}
        })
        var data = uglcw.ui.bind('.form-horizontal');
        var dateTypeStr = "发票日期";
        var paramStr = dateTypeStr + ":" + data.sdate + "-" + data.edate + " 销售类型:" + data.outType + "客户名称:" + data.khNm
            + "客户类型:" + data.customerType + "所属二批客户名" + data.epCustomerName + "商品名称:" + data.wareNm;
        var merCols = 'khNm,address,epCustomerName,recAmt,needRec';
        var saveHtml = {
            paramStr: paramStr,
            merCols: merCols,
            rows: rows,
            cols: cols
        }
        data.rptType = 10;
        data.saveHtml = JSON.stringify(saveHtml);
        $.ajax({
            url: '${base}manager/saveAutoCstDetailStat',
            data: data,
            type: 'post',
            dataType: 'json',
            success: function (data) {
                data = eval(data);
                if (parseInt(data) > 0) {
                    uglcw.ui.success('保存成功！');
                    uglcw.ui.openTab('生成的统计表', '${base}manager/toStkCstStatQuery?rptType=10');
                } else {
                    uglcw.ui.error('保存失败！');
                }
            }
        })
    }
</script>
</body>
</html>
