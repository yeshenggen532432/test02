<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>销售订单列表</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md12">
            <div class="layui-card header">
                <div class="layui-card-body">
                    <ul class="uglcw-query form-horizontal">
                        <li>
                            <input type="hidden" uglcw-model="jz" value="1" uglcw-role="textbox">
                            <input uglcw-model="orderNo" uglcw-role="textbox" placeholder="订单号">
                        </li>
                        <li>
                            <input uglcw-model="khNm" uglcw-role="textbox" placeholder="客户名称">
                        </li>
                        <li>
                            <input uglcw-model="memberNm" uglcw-role="textbox" placeholder="业务员名称">
                        </li>
                        <li>
                            <input uglcw-role="textbox" uglcw-model="wareNm" placeholder="商品名称">
                        </li>
                        <li>
                            <tag:select2 name="stkId" id="stkId" tableName="stk_storage"
                                         whereBlock="status=1 or status is null"
                                         headerKey=""
                                         headerValue="" displayKey="id" displayValue="stk_name" placeholder="仓库"/>
                        </li>
                        <li>
                            <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}">
                        </li>
                        <li>
                            <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                        </li>
                        <li>
                            <input type="checkbox" uglcw-role="checkbox" id="showProducts">
                            <label style="margin-top: 7px;" class="k-checkbox-label" for="showProducts">显示商品</label>
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
                    rowNumber:true,
                    toolbar: kendo.template($('#toolbar').html()),
                    url: '${base}manager/willOutPage?dataTp=${dataTp }',
                    criteria: '.form-horizontal',
                    pageable: true,
                    dblclick:function(row){
                        newOut(row.id);
                    },
                    aggregate:[
                     {field: 'zje', aggregate: 'SUM'}
                    ],
                    loadFilter: {
                      data: function (response) {
                        response.rows.splice(response.rows.length - 1, 1);
                        return response.rows || []
                      },
                      total: function (response) {
                        return response.total;
                      },
                      aggregates: function (response) {
                        var aggregate = {
                        	zje: 0,
                        	zdzk:0,
                        	cjje:0
                        };
                        if (response.rows && response.rows.length > 0) {
                            aggregate.zje = response.rows[response.rows.length - 1].list[0].wareZj;
                        }
                        return aggregate;
                      }
                     }

                    ">
                        <div data-field="orderNo" uglcw-options="
                          width:180,
                          locked: true,
                          footerTemplate: '合计'
                        ">订单号
                        </div>
                        <div data-field="oddate"
                             uglcw-options="width:200, template: '#= data.oddate+\' \'+data.odtime#'">下单日期
                        </div>
                        <div data-field="khNm" uglcw-options="width:160">客户名称</div>
                        <div data-field="memberNm" uglcw-options="width:160">业务员名称</div>
                        <div data-field="count" uglcw-options="width:700, hidden: true,
                         template: function(data){
                            return uglcw.util.template($('#product-list').html())(data.list);
                         }
                        ">商品信息
                        </div>
                        <div data-field="zje" uglcw-options=" width:140, format: '{0:n2}', footerTemplate:'#=uglcw.util.toString(data.zje,\'n2\')#'
                             ">
                            总金额
                        </div>
                        <div data-field="zdzk"
                             uglcw-options="width:120, format: '{0:n2}',footerTemplate:'#=uglcw.util.toString(data.zdzk,\'n2\')#'">
                            整单折扣
                        </div>
                        <div data-field="cjje"
                             uglcw-options="width:120, format: '{0:n2}',footerTemplate:'#=uglcw.util.toString(data.cjje,\'n2\')#'">
                            成交金额
                        </div>
                        <div data-field="orderZt"
                             uglcw-options="width:120,template: uglcw.util.template($('#formatterSt2').html())">订单状态
                        </div>
                        <div data-field="shr" uglcw-options="width:120, tooltip: true">收货人</div>
                        <div data-field="tel" uglcw-options="width:120, tooltip: true">电话</div>
                        <div data-field="address" uglcw-options="width:200, tooltip: true">地址</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:toZf();" class="k-button k-button-icontext">
        <span class="k-icon k-i-cancel"></span>作废
    </a>
</script>
<script type="text/x-kendo-template" id="formatterSt2">
    #if(data.list.length>0){#
    # if(data.orderZt=='未审核'){ #
    <button class="k-button" onclick="updateOrderSh(#= data.id#)"><i class="k-icon k-i-cancel"></i>未审核</button>
    #}else{#
    #= data.orderZt#
    #}#
    #}#
</script>
<script id="product-list" type="text/x-kendo-template">
    <table class="product-grid">
        <tbody>
        <tr style="font-weight: bold;">
            <td style="width: 120px;">商品名称</td>
            <td style="width: 120px;">销售类型</td>
            <td style="width: 60px;">单位</td>
            <td style="width: 80px;">规格</td>
            <td style="width: 60px;">数量</td>
            <td style="width: 60px;">单价</td>
            <td style="width: 60px;">总价</td>
        </tr>
        #for (var i=0; i< data.length; i++) { #
        <tr>
            <td>#= data[i].wareNm #</td>
            <td>#= data[i].xsTp #</td>
            <td>#= data[i].wareDw #</td>
            <td>#= data[i].wareGg #</td>
            <td>#= data[i].wareNum #</td>
            <td>#= data[i].wareDj #</td>
            <td>#= uglcw.util.toString(data[i].wareZj, "n") #</td>
        </tr>
        # }#
        </tbody>
    </table>
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        uglcw.ui.init();
        //显示商品
        uglcw.ui.get('#showProducts').on('change', function () {
            var checked = uglcw.ui.get('#showProducts').value();
            var grid = uglcw.ui.get('#grid');
            if (checked) {
                grid.showColumn('count');
            } else {
                grid.hideColumn('count');
            }
        });

        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        });

        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal', {sdate: '${sdate}', edate: '${edate}'});
        });


        uglcw.ui.loaded()
    });

    function add(orderId) {
        uglcw.ui.openTab('销售退货开单', "${base}manager/pcxsthin?orderId=" + orderId)
    }

    //销货商品信息
    function showProduct() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection && selection.length > 0) {
            var billNos = $.map(selection, function (row) {
                return row.billNo;
            })
            uglcw.ui.openTab('销货商品信息', '${base}manager/outWareListForGs?billNo=' + billNos);
        } else {
            uglcw.ui.warning('请勾选单据')
        }
    }

    function newOut(orderId) {
        if (orderId == 0) {
            uglcw.ui.openTab('销售开单', "${base}manager/pcstkout?orderId=" + orderId);
            return;

        }
        $.ajax({
            url: "${base}manager/checkOrderIsUse",
            type: "post",
            data: "orderId=" + orderId,
            success: function (data) {
                if (!data.state) {
                    uglcw.ui.openTab("销售开单", "${base}manager/pcstkout?orderId=" + orderId);
                } else {
                    uglcw.ui.error('该订单已经生成过销售单!');
                    return;
                }
            }
        });
    }

    function toZf() {//作废
        var selection = uglcw.ui.get('#grid').selectedRow();//选中当前行
        if (selection) {
            var ids = selection[0].id;
            if (selection[0].orderZt == '未审核') {
                return uglcw.ui.warning('该订单未审核，不能作废');
            }
            if (selection[0].orderZt == '已作废') {
                return uglcw.ui.warning('该订单已作废，不能再作废');
            }

            uglcw.ui.confirm('您确认想要作废该记录吗？', function () {
                $.ajax({
                    url: '${base}manager/updateOrderZf',
                    data: {id: ids},
                    type: 'post',
                    dataType: 'json',
                    success: function (json) {
                        if (json == 1) {
                            uglcw.ui.success('作废成功');
                            uglcw.ui.get('#grid').reload();
                        } else if (json == -1) {
                            uglcw.ui.error('作废失败');
                        }
                    }
                })
            })
        } else {
            return uglcw.ui.warning('请选择要作废的数据');
        }
    }

    function updateOrderSh(id) {
        uglcw.ui.confirm('确认您确认要审核吗？', function () {
            $.ajax({
                url: "${base}manager/updateOrderSh",
                type: "post",
                data: "id=" + id + "&sh=审核",
                success: function (data) {
                    if (data == '1') {
                        uglcw.ui.success("操作成功");
                        uglcw.ui.get('#grid').reload();
                    } else {
                        uglcw.ui.error("操作失败");
                        return;
                    }
                }
            });
        });
    }

</script>
</body>
</html>
