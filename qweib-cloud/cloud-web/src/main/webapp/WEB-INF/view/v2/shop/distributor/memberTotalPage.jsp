<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>分销业绩表(按会员)</title>
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
            <ul class="uglcw-query form-horizontal">
                <li>
                    <input uglcw-model="memberName" uglcw-role="textbox" placeholder="会员名称">
                </li>
                <li>
                    <input uglcw-model="createDateStart" uglcw-role="datepicker" value="${createDateStart}">
                </li>
                <li>
                    <input uglcw-model="createDateEnd" uglcw-role="datepicker" value="${createDateEnd}">
                </li>
                <%-- <li>
                     <input uglcw-model="auditDateStart" uglcw-role="datepicker" value="${auditDateStart}">
                 </li>
                 <li>
                     <input uglcw-model="auditDateEnd" uglcw-role="datepicker" value="${auditDateEnd}">
                 </li>--%>
                <li>
                    <select uglcw-role="combobox" uglcw-model="isAudit" placeholder="结算状态">
                        <option value="">全部</option>
                        <option value="0">未结</option>
                        <option value="1">已结</option>
                    </select>
                </li>
                <li>
                    <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                    <button id="reset" class="k-button" uglcw-role="button">重置</button>
                </li>
                <li>
                    <input type="checkbox" uglcw-role="checkbox" id="showProducts">
                    <label style="margin-top: 10px;" class="k-checkbox-label" for="showProducts">显示商品</label>
                </li>
                <li>
                    <a href="${base}/manager/shopDistributorOrder/toPage"><label style="margin-top: 10px;color: blue">分销业绩表（按订单）</label></a>
                </li>
            </ul>
        </div>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options="
 					 responsive:['.header',40],
                    <%--toolbar: kendo.template($('#toolbar').html()),--%>
                    id:'id',
                    checkbox: true,
                    url: '${base}manager/shopDistributorOrder/memberTotalPage',
                    criteria: '.form-horizontal',
                    pageable: true,
                    loadFilter: {
                        data: function(response){
                            var data= response.rows ? (response.rows || []) : [];
                             data.map(function(row){
                             var list=row.list||[];
                               list.map(function(item){
                                    item.memberId=row.memberId;
                               });
                             });
                            return data;
                        }
                    }
                    ">
                <div data-field="memberName" uglcw-options="width:100,align:'center'">会员名称</div>
                <div data-field="totalCommission" uglcw-options="width:100,align:'center'">总佣金</div>
                <div data-field="giveTotalCommission" uglcw-options="width:100,align:'center'">已结算佣金</div>
                <div data-field="unTotalCommission" uglcw-options="width:100,align:'center'">待结算佣金</div>
                <div data-field="count" uglcw-options="width:1000,hidden: true,template: function(data){
                             return kendo.template($('#product-list').html())(data.list);
                          }">商品信息
                </div>
            </div>
        </div>
    </div>
</div>

<script id="product-list" type="text/x-kendo-template">
    <table class="product-grid" style="padding-left: 5px;">
        <tbody>
        <tr style="font-weight: bold;">
            <td style="width: 120px;">订单号</td>
            <td style="width: 120px;">商品名称</td>
            <td style="width: 60px;">单位</td>
            <td style="width: 80px;">规格</td>
            <td style="width: 70px;">支付金额</td>
            <td style="width: 70px;text-align: center">一级佣金</td>
            <td style="width: 70px;text-align: center">二级佣金</td>
            <td style="width: 70px;text-align: center">三级佣金</td>
            <td style="width: 120px;">下单时间</td>
            <td style="width: 70px;">结算状态</td>
            <td style="width: 120px;">结算时间</td>
        </tr>
        #for (var i=0; i< data.length; i++) { #
        #if(data[i].firstCommission){#
        <tr>
            <td>#= data[i].orderNo #</td>
            <td>#= data[i].detailWareNm #</td>
            <td>#= data[i].wareDw #</td>
            <td>#= data[i].detailWareGg #</td>
            <td>#= data[i].warePayAmount #</td>
            <td style="text-align: center">#if(data[i].memberId == data[i].firstMemberId){#<span style="color: red">#= data[i].firstCommission||0 #</span>#}#</td>
            <td style="text-align: center">#if(data[i].memberId == data[i].secondMemberId){#<span style="color: red">#= data[i].secondCommission||0 #</span>#}#</td>
            <td style="text-align: center">#if(data[i].memberId == data[i].thirdMemberId){#<span style="color: red">#= data[i].thirdCommission||0 #</span>#}#</td>
            <td>#= data[i].createTime #</td>
            <td>#= data[i].isAudit?'已结':'未结' #</td>
            <td>#= data[i].auditTime||'' #</td>
            </td>
        </tr>
        # }}#
        </tbody>
    </table>
</script>


<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<%@include file="/WEB-INF/view/v2/include/shop-bforder.jsp" %>

<script>
    $(function () {
        uglcw.ui.init();
        //显示商品
        uglcw.ui.get('#showProducts').on('change', function () {
            var checked = uglcw.ui.get('#showProducts').value();
            var grid = uglcw.ui.get('#grid').k();
            var index = grid.options.columns.findIndex(function (column) {
                return column.field == 'count';
            })
            if (checked) {
                grid.showColumn(index)
            } else {
                grid.hideColumn(index);
            }
        })

        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        })

        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal');
        })

        uglcw.ui.loaded()

        $('#showProducts').trigger('click');
    })

    function toAudit(orderId) {
        uglcw.ui.confirm("是否确定结算", function () {
            uglcw.ui.loading();
            var url = "${base}/manager/shopDistributorOrder/toAudit";
            $.ajax({
                url: url,
                data: {orderId: orderId},
                type: 'post',
                success: function (json) {
                    uglcw.ui.loaded();
                    if (json.state) {
                        uglcw.ui.success('结算成功！');
                        uglcw.ui.get('#grid').reload();
                    }
                },
                error: function () {
                    uglcw.ui.info('结算错误！');
                }
            })
        })
    }
</script>
</body>
</html>
