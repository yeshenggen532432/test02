<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>收货明细查询</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
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
    <div class="layui-card header" style="display:<c:if test="${billId ne ''}">none</c:if>">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal">
                <li>
                    <input type="hidden" uglcw-model="jz" uglcw-role="textbox" value="1"/>
                    <input type="hidden" uglcw-model="ioType" uglcw-role="textbox" value="0"/>
                    <input   type="hidden" uglcw-model="billId"  id="billId"  uglcw-role="textbox"  value="${billId }"/>
                    <input class="k-textbox" uglcw-role="textbox" uglcw-model="billNo" placeholder="单据单号">
                </li>
                <li>
                    <input class="k-textbox" uglcw-role="textbox" uglcw-model="stkUnit"
                           placeholder="往来单位">
                </li>
                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                </li>
                <li>
                    <select uglcw-model="billName" id="inType" uglcw-role="combobox">
                        <option value="">入库类型</option>
                        <option value="采购入库">采购入库</option>
                        <option value="销售退货">销售退货入库</option>
                        <option value="采购退货">采购退货</option>
                        <option value="其它入库">其它入库</option>
                    </select>
                </li>
                <li>
                    <tag:select2 name="stkId" id="stkId" tableName="stk_storage" headerKey="-1"
                                 whereBlock="status=1 or status is null"
                                 headerValue=" " displayKey="id" displayValue="stk_name" placeholder="仓库"/>

                </li>
                <li>
                    <input uglcw-role="textbox" placeholder="商品名称" uglcw-model="wareNm">
                </li>
                <li>
                    <select uglcw-model="status" id="billStatus" uglcw-role="combobox">
                        <option value="-1">状态</option>
                        <option value="0">正常</option>
                        <option value="2">作废</option>
                        <option value="3">被冲红单</option>
                        <option value="4">冲红单</option>
                    </select>
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
                    id:'id',
                     responsive:['.header', 50],
                     rowNumber: true,
                   <%-- toolbar: uglcw.util.template($('#toolbar').html()),--%>
                    url: '${base}manager/queryInComePage',
                    criteria: '.form-horizontal',
                    pageable: true,
                    dblclick:function(row){
                        showDetail(row.id, row.inId);
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
                <div data-field="voucherNo" uglcw-options="width:160">收货单号</div>
                <div data-field="billNo" uglcw-options="
                          width:160,
                          template: function(dataItem){
                           return uglcw.util.template($('#bill-no').html())(dataItem);
                          }
                        ">单据单号
                </div>
                <div data-field="comeTimeStr" uglcw-options="width:130">日期</div>
                <div data-field="proName" uglcw-options="width:140,tooltip:true">往来单位</div>
                <div data-field="stkName" uglcw-options="width:140,tooltip:true">仓库名称</div>
                <div data-field="status" uglcw-options="width:70, template: uglcw.util.template($('#status-tpl').html())">
                    状态
                </div>
                <div data-field="count" uglcw-options="width:600, template: uglcw.util.template($('#product-tpl').html())">
                    商品信息
                </div>
                <div data-field="operation" uglcw-options="width:100, template: uglcw.util.template($('#opt-tpl').html())">
                    操作
                </div>
            </div>
        </div>
    </div>
</div>

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
<script id="opt-tpl" type="text/x-uglcw-template">
    #if(data.status == 0 || data.status == 1){#
    <button class="k-button k-info" onclick="cancelBill(#= data.id#, #= data.inId#)"><i
            class="k-icon k-i-cancel"></i>作废
    </button>
    #}#
</script>

<script id="product-tpl" type="text/x-kendo-template">
    <table class="product-grid">
        <tbody>
        <tr style="font-weight: bold;">
            <td style="width: 100px;">商品名称</td>
            <td style="width: 40px;">单位</td>
            <c:if test="${permission:checkUserFieldPdm('stk.stkCome.lookqty')}">
                <td style="width: 40px;">收货数量</td>
            </c:if>
            <c:if test="${permission:checkUserFieldPdm('stk.stkCome.lookprice')}">
                <td style="width: 40px;">单价</td>
            </c:if>
            <c:if test="${permission:checkUserFieldPdm('stk.stkCome.lookamt')}">
                <td style="width: 40px;">总价</td>
            </c:if>
        </tr>
        #var list = data.subList;#
        #for (var i=0; i< subList.length; i++) { #
        <tr>
            <td>#= subList[i].wareNm #</td>
            <td>#= subList[i].unitName #</td>
            <c:if test="${permission:checkUserFieldPdm('stk.stkCome.lookqty')}">
                <td>#= subList[i].inQty #</td>
            </c:if>
            <c:if test="${permission:checkUserFieldPdm('stk.stkCome.lookprice')}">
                <td>#= uglcw.util.toString( subList[i].price, 'n2') #</td>
            </c:if>
            <c:if test="${permission:checkUserFieldPdm('stk.stkCome.lookamt')}">
                <td>#= uglcw.util.toString(subList[i].inQty * subList[i].price, 'n2') #</td>
            </c:if>
        </tr>
        # }#
        </tbody>
    </table>
</script>
<script id="bill-no" type="text/x-kendo-template">
    <a href="javascript:showDetail(0, #= data.inId#);"
       style="color: \\#337ab7;font-size: 12px; font-weight: bold;">
        #=data.billNo#</a>
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        uglcw.ui.init();

        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        });

        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal', {sdate: '${sdate}', edate: '${edate}'});
        });


        uglcw.ui.loaded()
    });


    function showDetail(id, inId) {
        if (!id) {
            uglcw.ui.openTab('单据单' + inId, '${base}manager/showstkin?dataTp=1&billId=' + inId);
        } else {
            uglcw.ui.openTab('收货确认单' + id, '${base}manager/showstkinchecklook?dataTp=1&billId=' + id);
        }

    }

    function refresh() {
        uglcw.ui.get('#grid').reload();
    }

    function cancelBill(id, idId) {
        var billId = id || idId;

        var url = billId ? '${base}manager/cancelStkInCome' : '${base}manager/cancelStkInByBillId';
        uglcw.ui.confirm('是否确认作废收货明细?', function () {
            uglcw.ui.loading();
            $.ajax({
                url: url,
                data: {billId: billId},
                type: 'post',
                success: function (response) {
                    uglcw.ui.loaded();
                    if (response.state) {
                        uglcw.ui.success('作废成功！');
                        uglcw.ui.get('#grid').reload();
                    } else {
                        uglcw.ui.error(response.msg || '作废失败');
                    }
                },
                error: function () {
                    uglcw.ui.loaded();
                    uglcw.ui.error(response.msg || '作废失败');
                }
            })

        })
    }
</script>
</body>
</html>
