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
                    <input type="hidden" uglcw-model="saleType" uglcw-role="textbox" value="${saleType}"/>
                    <input type="hidden" uglcw-model="customerType" uglcw-role="textbox" value="${customerType}"/>
                    <input type="hidden" uglcw-model="khNm" uglcw-role="textbox" value="${khNm}"/>
                    <input type="hidden" uglcw-model="epCustomerName" uglcw-role="textbox" value="${epCustomerName}"/>
                    <input type="hidden" uglcw-model="staff" uglcw-role="textbox" value="${staff}"/>
                    <input type="hidden" uglcw-model="xsTp" uglcw-role="textbox" value="${xsTp}"/>
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
                    url: '${base}manager/queryStkOutDetail',
                    criteria: '.form-horizontal',
                    pageable: true,
                    loadFilter: {
                         data: function (response) {
                             response.rows.splice( response.rows.length - 1, 1);
                             return response.rows || []
                         },
                         aggregates: function (response) {
                             var aggregate={
                                    price:0,
                                    qty:0,
                                    amt:0,
                                    outQty:0,
                                    outAmt:0,
                                    recAmt:0,
                                 needRec:0
                             }
                             if (response.rows && response.rows.length > 0) {
                                 aggregate = uglcw.extend(aggregate,response.rows[response.rows.length - 1]);

                            }
                            return aggregate;
                     }
                    },
				    aggregate:[
						{field: 'price', aggregate: 'SUM'},
						{field: 'qty', aggregate: 'SUM'},
						{field: 'amt', aggregate: 'SUM'},
						{field: 'outQty', aggregate: 'SUM'},
						{field: 'outAmt', aggregate: 'SUM'},
						{field: 'recAmt', aggregate: 'SUM'},
						{field: 'needRec', aggregate: 'SUM'}

				    ]
                    ">
            <div data-field="docNo" uglcw-options="width:200, tooltip: true,footerTemplate: '合  计:'">单号</div>
            <div data-field="khNm" uglcw-options="width:240,tooltip: true">客户名称</div>
            <div data-field="wareNm" uglcw-options="width:80">商品名称</div>
            <div data-field="xsTp" uglcw-options="width:80">销售类型</div>
            <div data-field="unitName" uglcw-options="width:80">计量单位</div>
            <div data-field="price"
                 uglcw-options="width:100,format: '{0:n2}',footerTemplate: '#= uglcw.util.toString(data.price,\'n2\')#'">
                销售单价
            </div>
            <div data-field="qty"
                 uglcw-options="width:100,format: '{0:n2}',footerTemplate: '#= uglcw.util.toString(data.qty,\'n2\')#'">销售数量
            </div>
            <div data-field="amt"
                 uglcw-options="width:100,format: '{0:n2}',footerTemplate: '#= uglcw.util.toString(data.amt,\'n2\')#'">销售金额
            </div>
            <div data-field="outQty"
                 uglcw-options="width:100,format: '{0:n2}',footerTemplate: '#= uglcw.util.toString(data.outQty,\'n2\')#'">
                发货数量
            </div>
            <div data-field="outAmt"
                 uglcw-options="width:100,format: '{0:n2}',footerTemplate: '#= uglcw.util.toString(data.outAmt,\'n2\')#'">
                发货金额
            </div>
            <div data-field="recAmt"
                 uglcw-options="width:100,format: '{0:n2}',footerTemplate: '#= uglcw.util.toString(data.recAmt,\'n2\')#'">
                回款金额
            </div>
            <div data-field="needRec"
                 uglcw-options="width:100,format: '{0:n2}',footerTemplate: '#= uglcw.util.toString(data.needRec,\'n2\')#'">
                未回款金额
            </div>
            <div data-field="staff" uglcw-options="width:80">业务员</div>
            <div data-field="vehNos" uglcw-options="width:80">配送车辆</div>
            <div data-field="epCustomerName" uglcw-options="width:80">所属二批</div>
            <div data-field="remarks" uglcw-options="width:120">备注</div>
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
        var dateTypeStr = "销售日期";
        var paramStr = dateTypeStr + ":" + data.sdate + "-" + data.edate + " 销售类型:" + data.outType + "y业务员:" + data.staff + "客户名称:" + data.khNm +
            "客户类型:" + data.customerType + "所属二批:" + data.epCustomerName + "销售类型:" + data.xsTp + "商品名称:" + data.wareNm;
        var merCols = 'docNo,khNm,recAmt,needRec,staff,vehNos,epCustomerName';
        var saveHtml = {
            paramStr: paramStr,
            merCols: merCols,
            rows: rows,
            cols: cols
        }
        data.rptType = 8;
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
                    uglcw.ui.openTab('生成的统计表', '${base}manager/toStkCstStatQuery?rptType=8');
                } else {
                    uglcw.ui.error('保存失败！');
                }
            }
        })
    }
</script>
</body>
</html>
