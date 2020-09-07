<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>收货管理列表</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }
    </style>
</head>
<body>
<tag:mask/>
<div class="layui-fluid page-list">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query">
                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker" value="${param.sdate}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                </li>
                <li>
                    <input type="hidden" uglcw-model="jz" value="1" uglcw-role="textbox">
                    <input uglcw-model="billNo" uglcw-role="textbox" placeholder="单号">
                </li>
                <li>
                    <input uglcw-model="proName" uglcw-role="textbox" placeholder="往来单位">
                </li>
                <li>
                    <input uglcw-model="memberNm" uglcw-role="textbox" placeholder="业务员">
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="inType" uglcw-options="value: ''" placeholder="入库类型">
                        <option value="采购入库">采购入库</option>
                        <option value="其它入库">其它入库</option>
                        <option value="销售退货">销售退货</option>
                        <option value="采购退货">采购退货</option>
                    </select>
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="billStatus" placeholder="状态">
                        <option value="未收货" selected>未收货</option>
                        <option value="已收货">已收货</option>
                        <option value="作废">作废</option>
                    </select>
                </li>
                <li>
                    <tag:select2 name="stkId" id="stkId" tableName="stk_storage" headerKey="-1"
                                 whereBlock="status=1 or status is null"
                                 headerValue=" " displayKey="id" displayValue="stk_name" placeholder="仓库"/>

                </li>
                <li>
                    <input uglcw-model="wareNm" uglcw-role="textbox" placeholder="商品名称">
                </li>
                <li>
                    <input type="checkbox" uglcw-role="checkbox" id="showProducts">
                    <label style="margin-top: 10px;" class="k-checkbox-label" for="showProducts">显示商品</label>
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
            <div id="grid" uglcw-role="grid" class="uglcw-grid-compact"
                 uglcw-options="
                    checkbox: true,
                    responsive:['.header',40],
                    toolbar: uglcw.util.template($('#toolbar').html()),
                    id:'id',
                    url: '${base}manager/stkInForShPage',
                    criteria: '.uglcw-query',
                    pageable: true,
                    dblclick: function(row){
                        showDetail(row.id,row.billStatus);
                    },
                    aggregate:[
                     {field: 'totalAmt', aggregate: 'SUM'},
                     {field: 'discount', aggregate: 'SUM'},
                     {field: 'disAmt', aggregate: 'SUM'},
                     {field: 'payAmt', aggregate: 'SUM'},
                     {field: 'freeAmt', aggregate: 'SUM'}
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
                        var aggregate = {};
                        if (response.rows && response.rows.length > 0) {
                            aggregate = response.rows[response.rows.length - 1]
                        }
                        return aggregate;
                      }
                     }

                    ">
                <div data-field="billNo" uglcw-options="
                          width:160,
                          template: function(dataItem){
                           return kendo.template($('#bill-no').html())(dataItem);
                          },
                          footerTemplate: '合计'
                        ">单号
                </div>
                <div data-field="inDate" uglcw-options="width:150">日期</div>
                <div data-field="operator" uglcw-options="width:100">创建人</div>
                <div data-field="inType" uglcw-options="width:100">入库类型</div>
                <div data-field="proName" uglcw-options="width:120,tooltip: true">往来单位</div>
                <div data-field="sumQty" uglcw-options="width:80">单据数量</div>
                <div data-field="sumInQty" uglcw-options="width:80">已收货数量</div>
                <div data-field="memberNm" uglcw-options="width:100">业务员</div>
                <div data-field="options"
                     uglcw-options="width:190, template: uglcw.util.template($('#op-tpl').html())">操作
                </div>
                <div data-field="count" uglcw-options="width:700, hidden: true,
                         template: function(data){
                            return kendo.template($('#product-list').html())(data.list);
                         }
                        ">商品信息
                </div>
                <div data-field="billStatus" uglcw-options="width:100">单据状态</div>
                <div data-field="remarks" uglcw-options="width:'auto', tooltip:true">备注</div>
            </div>
        </div>
    </div>
</div>
<script id="op-tpl" type="text/x-uglcw-template">
    #if(data.id){#
    <c:if test="${permission:checkUserButtonPdm('stk.stkCome.items')}">
        #if(data.billStatus !='作废'&&Math.abs(data.sumInQty)!=0&&Math.abs(data.sumQty)>=Math.abs(data.sumInQty)){#
        <button class="k-button k-info" onclick="showInList(#= data.id#)">收货明细</button>
        #}#
    </c:if>
    #if(data.billStatus !='作废'&&data.billStatus=='未收货'){#
    <c:if test="${permission:checkUserButtonPdm('stk.stkCome.shouhuo')}">
        <button class="k-button k-success"
                onclick="showCheck(#= data.id#,'#= data.inType#','#=data.billStatus#','#=data.openZfjz#')">
            收货
        </button>
    </c:if>
    #}#
    #}#
</script>
<script type="text/x-uglcw-template" id="toolbar">
    <a role="button" href="javascript:showInDetailQuery();" class="k-button k-button-icontext">
        <span class="k-icon k-i-search"></span>收货明细查询
    </a>
</script>
<script id="product-list" type="text/x-uglcw-template">
    <table class="product-grid">
        <tbody>
        <tr style="font-weight: bold;text-align: center">
            <td style="width: 120px;">商品名称</td>
            <td style="width: 60px;">单位</td>
            <td style="width: 80px;">规格</td>
            <td style="width: 80px;">采购类型</td>
            <td style="width: 60px;">数量</td>
            <td style="width: 60px;">单价</td>
            <td style="width: 60px;">总价</td>
            <td style="width: 60px;">已收数量</td>
            <td style="width: 60px;">未收数量</td>
        </tr>
        #for (var i=0; i< data.length; i++) { #
        <tr>
            <td>#= data[i].wareNm #</td>
            <td>#= data[i].unitName #</td>
            <td>#= data[i].wareGg #</td>
            <td>#= data[i].inTypeName #</td>
            <td>#= data[i].qty #</td>
            <td>#= data[i].price #</td>
            <td>#= data[i].amt #</td>
            <td>#= data[i].inQty #</td>
            <td>#= data[i].inQty1 #</td>
        </tr>
        # }#
        </tbody>
    </table>
</script>
<script id="bill-no" type="text/x-uglcw-template">
    <a href="javascript:showDetail(#= data.id#,'#= data.billStatus#');"
       style="color: \\#337ab7;font-size: 12px; font-weight: bold;">#=
        data.billNo#</a>
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();
        uglcw.ui.get('[uglcw-model=inType]').value('');
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
            uglcw.ui.get('#grid').reload();
        })

        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.uglcw-query', {sdate: '${sdate}', edate: '${edate}'});
        })
        uglcw.ui.loaded()
    })

    function getSelection() {
        var rows = uglcw.ui.get('#grid').selectedRow();
        if (rows && rows.length > 0) {
            return rows;
        } else {
            uglcw.ui.warning('请先选择数据');
            return false;
        }
    }

    function showInList(id) {
        uglcw.ui.openTab('收货明细' + id, '${base}manager/indetailquery?billId=' + id);
    }

    function showInDetailQuery() {
        uglcw.ui.openTab('收货明细查询', '${base}manager/indetailquery');
    }

    function showCheck(id, title, status, openZfjz) {
        if (status != '未收货') {
            return uglcw.ui.error(status + '单据,不能操作');
        }
        $.ajax({
            url: '${base}/manager/stkExtrasCarryOver/checkInUse',
            data: {
                billId: id
            },
            type: 'post',
            dataType: 'json',
            success: function (response) {
                if (response.state) {
                    var billId = $("#billId").val();
                    if (billId == 0) {
                        uglcw.ui.warning("没有可收货的单据");
                        return;
                    }
                    if (openZfjz == 1) {
                        return uglcw.ui.error("待结转采购杂费，暂不支持收货");
                    } else {
                        uglcw.ui.openTab(title + '_收货确认' + id, '${base}manager/showstkincheck?dataTp=1&billId=' + id);
                    }
                } else {
                    if (response.status == 1) {
                        showToCheck(title, id, response.secoId);
                    } else {
                        uglcw.ui.error("已生成未审批结算单，请选审批杂费结算单<a href='javascript:showZfjzDetail(" + response.secoId + ")'>去审批<a>");
                    }
                }
            }
        })


    }

    function invalid() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            var flag = true;
            $(selection).each(function (idx, item) {
                if (item.status != 0) {
                    uglcw.ui.error('订单[' + item.billNo + ']不能作废');
                    flag = false;
                }
            })
            if (!flag) {
                return;
            }
            uglcw.ui.confirm('确定作废所选订单吗', function () {
                $.ajax({
                    url: '${base}manager/cancelProc',
                    data: {
                        billId: selection[0].id
                    },
                    type: 'post',
                    dataType: 'json',
                    success: function (response) {
                        if (response.state) {
                            uglcw.ui.success(response.msg);
                            uglcw.ui.get('#grid').k().dataSource.read();
                        } else {
                            uglcw.ui.error(response.msg);
                        }
                    }
                })
            })
        }
    }

    function showDetail(id, status) {
        uglcw.ui.openTab('单据信息' + id, '${base}manager/showstkin?billId=' + id);
    }

    function showZfjzDetail(id) {
        uglcw.ui.openTab('单据信息' + id, '${base}manager/stkExtrasCarryOver/show?billId=' + id);
    }

    function showToCheck(title, sourceBillId, secoId) {
        uglcw.ui.openTab(title + '_收货确认' + sourceBillId, '${base}manager/showstkincheck?dataTp=1&billId=' + sourceBillId + "&secoId=" + secoId);
    }

</script>
</body>
</html>
