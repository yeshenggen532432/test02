<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>业务销售统计表</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query">
                <input type="hidden" uglcw-role="textbox" uglcw-model="sdate" id="sdate" value="${sdate}" />
                <input type="hidden" uglcw-role="textbox" uglcw-model="edate" id="edate" value="${edate}" />
                <input type="hidden"  uglcw-role="textbox" uglcw-model="empId" id="empId" value="${empId}" />
                <input type="hidden" uglcw-role="textbox"  uglcw-model="timeType" id="timeType" value="${timeType}"/>


            </ul>
        </div>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options="
                    responsive:['.header',40],
                    toolbar: uglcw.util.template($('#toolbar').html()),
                    id:'id',
                    autoBind: false,
                    url: '${base}manager/querySumEmpRecDetail',
                    criteria: '.uglcw-query',
                    pageable: true,
                    aggregate:[
                     {field: 'recAmt', aggregate: 'sum'}
                    ],
                     dblclick: function(row){
                     if(row.xsTp == '销售退货')
                     {
                        uglcw.ui.openTab('销售退货开单', '${base}manager/pcstkthin?orderId=' + row.id);
                     }
                     else
                     {
                        uglcw.ui.openTab('销售退货开单', '${base}manager/showstkout?billId=' + row.id);
                     }

                    },
                    loadFilter: {
                      data: function (response) {
                         if(!response.rows || response.rows.length<2){
                            return [];
                        }
                        response.rows.splice(response.rows.length - 1, 1);
                        return response.rows;
                      },
                      total: function (response) {
                        return response.total;
                      },
                      aggregates: function (response) {
                        var aggregate = {};
                        if (response.rows && response.rows.length > 0) {
                            aggregate = response.rows[response.rows.length - 1]
                        }
                        return aggregate;
                      }
                     }

                    ">
                <div data-field="billNo" uglcw-options="width:150, tooltip: true, footerTemplate:'合计'">单号</div>
                <div data-field="recTimeStr" uglcw-options="width: 150, tooltip: true">收款时间</div>
                <div data-field="staff" uglcw-options="width:120, tooltip: true">业务员</div>
                <div data-field="shr" uglcw-options="width:120">客户名称</div>


                <div data-field="recAmt"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.recAmt || 0, \'n2\')#'">
                    回款金额
                </div>

            </div>
        </div>
    </div>
</div>
<script type="text/x-kendo-template" id="toolbar">

</script>
<script id="product-tpl" type="text/x-uglcw-template">

</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>


<script>

    $(function () {
        uglcw.ui.init();
        $('.q-box-arrow').on('click', function () {
            $(this).find('i').toggleClass('k-i-arrow-chevron-left k-i-arrow-chevron-down');
            $('.q-box-more').toggle();
            $('.q-box-wrapper').closest('.layui-card').toggleClass('box-shadow')
        })


        uglcw.ui.loaded();
        uglcw.ui.get('#grid').reload();

    })



</script>
</body>
</html>
