<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>发货明细查询</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }
        .row-color-blue {
            color: blue !important;
            text-decoration: line-through;
            font-weight: bold;
        }

        .row-color-pink {
            color: #FF00FF !important;
            font-weight: bold;
        }

        .row-color-red {
            color: red !important;
            font-weight: bold;

        }
    </style>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal">
                <li>
                    <input uglcw-role="textbox" type="hidden" uglcw-model="jz" value="1"/>
                    <input uglcw-role="textbox" type="hidden" uglcw-model="ioType" value="1"/>
                    <input uglcw-role="textbox" uglcw-model="voucherNo" placeholder="发货单号"/>
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="billNo" placeholder="发票单号"/>
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="customerType" uglcw-options="
                                        placeholder:'客户类型',
                                                            index:-1,
                                        url: '${base}manager/queryarealist1',
                                        dataTextField: 'qdtpNm',
                                        dataValueField: 'qdtpNm',
                                        loadFilter: {
                                        data: function(response){
                                        return response.list1 || []
                                      }
                                    }
                                 "></select>
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="stkUnit" placeholder="客户名称"/>
                </li>
                <li>
                    <select uglcw-model="xsTp" uglcw-role="combobox"
                            uglcw-options="placeholder:'销售类型', index: -1">
                        <option value=""></option>
                        <option value="正常销售">正常销售</option>
                        <option value="促销折让">促销折让</option>
                        <option value="消费折让">消费折让</option>
                        <option value="费用折让">费用折让</option>
                        <option value="其他销售">其他销售</option>
                    </select>
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="vehNo" placeholder="车号"/>
                </li>
                <li>
                    <tag:select2 name="stkId" id="stkId" tableName="stk_storage" headerKey="-1"
                                 headerValue="" displayKey="id" placeholder="仓库"
                                 whereBlock="status=1 or status is null"
                                 displayValue="stk_name"/>


                </li>
                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="deliveryNo" placeholder="配送单号"/>
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="wareNm" placeholder="商品名称"/>
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="status"
                            uglcw-options="placeholder:'状态',index:-1">
                        <option value="-1">全部</option>
                        <option value="0">正常</option>
                        <option value="2">作废</option>
                        <option value="3">被冲红单</option>
                        <option value="4">冲红单</option>
                    </select>
                </li>
                <li>

                    <select uglcw-model="outType" uglcw-role="combobox"
                            uglcw-options="placeholder:'发票类型', index: -1">
                        <option value=""></option>
                        <option value="销售出库">销售出库</option>
                        <option value="其它出库">其它出库</option>
                        <option value="报损出库">报损出库</option>
                        <option value="借出出库">借出出库</option>
                        <option value="领用出库">领用出库</option>
                    </select>
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="epCustomerName" placeholder="所属二批"/>
                </li>
                <li>
                    <input type="checkbox" uglcw-role="checkbox" id="showProducts">
                    <label style="margin-top: 7px" class="k-checkbox-label" for="showProducts">显示商品</label>
                </li>
                <li>

                    <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                    <button id="reset" class="k-button" uglcw-role="button">重置</button>
                </li>
                <li style="width: 250px !important; padding-top: 5px">
                    <span style="background-color:#FF00FF;border: 1;color:white ">&nbsp;被冲红单&nbsp;</span>
                    &nbsp;<span style="background-color:red;border: 1;color:white">&nbsp;&nbsp;&nbsp;冲红单&nbsp;&nbsp;&nbsp;</span>
                    &nbsp;<span style="background-color:blue;border: 1;color:white">&nbsp;&nbsp;&nbsp;作废单&nbsp;&nbsp;&nbsp;</span>
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
                    url: '${base}manager/queryOutDetailList1',
                    criteria: '.form-horizontal',
                    pageable: true,
                    loadFilter: {
                      data: function (response) {
                        response.rows.splice(response.rows.length - 1, 1);
                        return response.rows || []
                      },
                      total: function (response) {
                        return response.total;
                      }
                     },
                     dblclick:function(row){
                        showDetail(row.id,row.outType,row.outId);
                    },
                     dataBound: function(){
                        var data = this.dataSource.view();
                        $(data).each(function(idx, row){
                            var clazz = ''
                            if(row.status == 2){
                                clazz = 'row-color-blue';
                            }else if(row.status == 3){
                                clazz = 'row-color-pink';
                            }else if(row.status == 4){
                                clazz = 'row-color-red';
                            }
                            $('#grid tr[data-uid='+row.uid+']').addClass(clazz);
                        })
                    }
                    ">
                <div data-field="voucherNo" uglcw-options="
                          width:160,
                          template: function(dataItem){
                           return kendo.template($('#bill-no').html())(dataItem);
                          },
                          footerTemplate: '合计'
                        ">发货单号
                </div>
                <div data-field="sendTimeStr" uglcw-options="width:140">发货日期</div>
                <div data-field="billNo" uglcw-options="width:160">单号</div>
                <div data-field="khNm" uglcw-options="width:140">往来单位</div>
                <div data-field="vehNo" uglcw-options="width:100">运输车辆</div>
                <div data-field="driverName" uglcw-options="width:80">司机</div>
                <div data-field="stkName" uglcw-options="width:80">仓库</div>
                <div data-field="status" uglcw-options="width:70, template: uglcw.util.template($('#status-tpl').html())">
                    状态
                </div>
                <div data-field="options"
                     uglcw-options="width:150, template: uglcw.util.template($('#op-tpl').html())">
                    操作
                </div>
                <div data-field="count" uglcw-options="width:700, hidden: true,
                         template: function(data){
                            return kendo.template($('#product-list').html())(data.subList);
                         }

                        ">商品信息
                </div>
                <div data-field="epCustomerName" uglcw-options="width:100">所属二批</div>

            </div>
        </div>
    </div>
</div>
<script id="op-tpl" type="text/x-uglcw-template">
    <c:if test="${permission:checkUserButtonPdm('stk.stkSend.cancel')}">
        # if(data.status==0 || data.status==1){ #
        <button class="k-button k-info" onclick="invalid(#= data.id#, '#= data.billStatus#')"><i
                class="k-icon k-i-cancel"></i>作废
        </button>
        #}#
    </c:if>
    <button class="k-button k-info" onclick="toPrint(#= data.id#)"><i
            class="k-icon k-i-cancel"></i>打印
    </button>
</script>
<script id="status-tpl" type="text/x-uglcw-template">
    #if(data.status == 1 || data.status == 0){#
    正常
    #}else if(data.status == 2){#
    作废
    #}else if(data.status == 3){#
    被冲红单
    #}else if(data.status == 4){#
    冲红单
    #}#
</script>
<script id="product-list" type="text/x-uglcw-template">
    <table class="product-grid">
        <tbody>
        <tr style="font-weight: bold;">
            <td style="width: 120px;">商品名称</td>
            <td style="width: 60px;">单位</td>
            <td style="width: 80px;">销售类型</td>
            <td style="width: 80px;">发货数量</td>
            <td style="width: 60px;">单价</td>
            <td style="width: 60px;">总价</td>
        </tr>
        #for (var i=0; i< data.length; i++) { #
        <tr>
            <td>#= data[i].wareNm #</td>
            <td>#= data[i].unitName #</td>
            <td>#= data[i].xsTp #</td>
            <td>#= kendo.toString(data[i].outQty,"n")#</td>
            <td>#= data[i].price #</td>
            <td>#= kendo.toString(data[i].outQty * data[i].price, "n") #</td>
        </tr>
        # }#
        </tbody>
    </table>
</script>
<script id="bill-no" type="text/x-uglcw-template">
    <a href="javascript:showDetail(#= data.id#, '#= data.outType#', #= data.outId#);"
       style="color: \\#337ab7;font-size: 12px; font-weight: bold;">#=data.voucherNo#</a>
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        uglcw.ui.init();
        uglcw.ui.get('[uglcw-model=status]').value('');
        $('.q-box-arrow').on('click', function () {
            $(this).find('i').toggleClass('k-i-arrow-chevron-left k-i-arrow-chevron-down');
            $('.q-box-more').toggle();
            $('.q-box-wrapper').closest('.layui-card').toggleClass('box-shadow')
        });
        //显示商品
        uglcw.ui.get('#showProducts').on('change', function () {
            var checked = uglcw.ui.get('#showProducts').value();
            var grid = uglcw.ui.get('#grid');
            if (checked) {
                grid.showColumn('count')
            } else {
                grid.hideColumn('count');
            }
        })

        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').k().dataSource.read();
        })

        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal');
        })


        uglcw.ui.loaded()
    });

    function getSelection() {
        var result = [], grid = $('#order-list').data('kendoGrid');
        var rows = grid.element.find('.k-grid-content tr.k-state-selected');
        if (rows.length > 0) {
            $(rows).each(function (idx, item) {
                result.push(grid.dataItem(item))
            })
            return result;
        } else {
            layer.msg('请先选择数据');
            return false;
        }
    }

    function invalid(id, status) {
        if (status === '作废') {
            return uglcw.ui.warning('该单据已作废');
        }
        uglcw.ui.confirm('是否确认作废出库单吗？', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/cancelStkOut1',
                data: {billId: id},
                type: 'post',
                dataType: 'json',
                success: function (response) {
                    uglcw.ui.loaded();
                    if (response.state) {
                        uglcw.ui.success('作废成功！');
                        uglcw.ui.get("#grid").reload();
                    } else {
                        uglcw.ui.error(response.msg || '作废失败！');
                    }
                },
                error: function () {
                    uglcw.ui.loaded();
                }
            })
        })
    }

    function showDetail(id, outType, outId) {
        uglcw.ui.openTab(outType + '_发货单信息', 'manager/lookstkoutcheck?dataTp=1&billId=' + outId + '&sendId=' + id);
    }

    function toPrint(id)
    {
        uglcw.ui.openTab('发货单打印', '${base}manager/showstksendprint?dataTp=1&billId=' + id);
    }

</script>
</body>
</html>
