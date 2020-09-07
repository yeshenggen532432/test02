<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>车销单</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <script>
        var NEW_STOCK_CAL = '${fns:checkFieldDisplay("sys_config","*","code=\"CONFIG_USE_NEW_STOCK_CAL\" and status=1")}';
        var AUTO_CREATE_FHD = '${fns:checkFieldDisplay("sys_config","*","code=\"CONFIG_XSFP_AUTO_CREATE_FHD\" and status=1")}';
    </script>
    <style>
        .product-grid td {
            padding: 0;
        }

        .biz-type.k-combobox {
            font-weight: bold;
        }

        .biz-type .k-input {
            color: black;
            background-color: rgba(0, 123, 255, .35);
        }
    </style>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query">
                <li>
                    <input uglcw-model="saleCar" uglcw-role="textbox" type="hidden" value="${saleCar}"/>
                    <input uglcw-model="orderLb" uglcw-role="textbox" type="hidden" value="车销单"/>
                    <input uglcw-model="sdate" uglcw-role="datepicker" >
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                </li>
                <li>
                    <input type="hidden" uglcw-model="jz" value="1" uglcw-role="textbox">
                    <input uglcw-model="billNo" uglcw-role="textbox" placeholder="单号">
                </li>
                <li>
                    <input uglcw-model="orderNo" uglcw-role="textbox" placeholder="订单单号">
                </li>
                <li>
                    <input uglcw-model="khNm" uglcw-role="textbox" placeholder="客户名称">
                </li>
                <li>
                    <input uglcw-model="memberNm" uglcw-role="textbox" placeholder="业务员名称">
                </li>
                <li style="display:none;">
                    <select uglcw-role="combobox" uglcw-model="outType" uglcw-options="value: '', tooltip: '出库类型'"
                            placeholder="出库类型">
                        <option value="销售出库">销售出库</option>
                    </select>
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="billStatus" uglcw-options="value: '${billStatus}'"
                            placeholder="状态">
                        <option value="">全部</option>
                        <option value="暂存">暂存</option>
                        <option value="未发货">未发货</option>
                        <option value="已发货">已发货</option>
                        <option value="作废">作废</option>
                        <option value="终止未发完">终止未发完</option>
                    </select>
                </li>
                <li>
                    <tag:select2 name="stkId" id="stkId" tableName="stk_storage" headerKey="-1"
                                 whereBlock="sale_car=1"
                                 headerValue=""
                                 index="0"
                                 displayKey="id" displayValue="stk_name" placeholder="仓库"/>
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="wareNm" placeholder="商品名称">
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="remarks" placeholder="备注">
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="customerType" uglcw-options="
                                    url: '${base}manager/queryarealist1',
                                    placeholder: '客户类型',
                                    dataTextField: 'qdtpNm',
                                    dataValueField: 'qdtpNm',
                                    loadFilter:{
                                        data: function(response){
                                            return response.list1 || [];
                                        }
                                    }
                            ">
                    </select>
                </li>

                <li >
                    <select uglcw-model="pszd" id="pszd" uglcw-options="value: ''" placeholder="配送指定" uglcw-role="combobox">
                        <option value="公司直送">公司直送</option>
                        <option value="直供转单二批">直供转单二批</option>
                    </select>
                </li>

                <li>
                    <input uglcw-model="epCustomerName" uglcw-role="textbox" placeholder="所属二批">
                </li>
                <%--<li>--%>
                    <%--<select id="saleCar" uglcw-options="value:'', tooltip: '仓库类型'" uglcw-model="saleCar" uglcw-role="combobox"--%>
                            <%--placeholder="仓库类型">--%>
                        <%--<option value="0" selected>正常仓库</option>--%>
                        <%--<option value="1">车销仓库</option>--%>
                        <%--<option value="2">门店仓库</option>--%>
                    <%--</select>--%>
                <%--</li>--%>

                <li>
                    <input type="checkbox" uglcw-role="checkbox" id="showProducts">
                    <label style="margin-top: 10px;" class="k-checkbox-label" for="showProducts">显示商品</label>
                </li>
                <li>
                    <input type="checkbox" uglcw-role="checkbox" uglcw-model="showNoModify" onclick="query()"
                           id="showNoModify">
                    <label style="margin-top: 10px;" class="k-checkbox-label" for="showNoModify">显示未修改的单据</label>
                </li>
                <li>
                    <input type="checkbox" uglcw-role="checkbox" uglcw-model="count" onclick="query()"
                           id="count">
                    <label style="margin-top: 10px;" class="k-checkbox-label" for="count">只显示未打印单据</label>

                </li>
                <li>
                    <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                    <button id="reset" class="k-button" uglcw-role="button">重置</button>
                </li>
                <li style="display: none">
                    <select class="biz-type" uglcw-model="saleType" uglcw-role="combobox"
                            uglcw-options="placeholder:'业务类型', value: ''">
                        <option value="001" selected>传统业务类</option>
                        <option value="003">线上商城</option>
                    </select>
                </li>
            </ul>
        </div>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options="
                    responsive:['.header', 50],
                    toolbar: uglcw.util.template($('#toolbar').html()),
                    id:'id',
                    checkbox: true,
                    url: '${base}manager/stkOutHisPage',
                    criteria: '.uglcw-query',
                    pageable: true,
                    rowNumber: true,
                    dblclick: function(row){
                        showDetail(row.id);
                    },
                    aggregate:[
                     {field: 'totalAmt', aggregate: 'SUM'},
                     {field: 'discount', aggregate: 'SUM'},
                     {field: 'disAmt', aggregate: 'SUM'},
                     {field: 'recAmt', aggregate: 'SUM'},
                     {field: 'freeAmt', aggregate: 'SUM'}
                    ],
                    loadFilter: {
                      data: function (response) {
                        if(response.rows && response.rows.length>0){
                            response.rows.splice(response.rows.length - 1, 1);
                        }
                        return response.rows || []
                      },
                      total: function (response) {
                        return response.total;
                      },
                      aggregates: function (response) {
                        var aggregate = {
                            totalAmt: 0,
                            discount: 0,
                            disAmt:0,
                            recAmt: 0,
                            freeAmt: 0
                        };
                        if (response.rows && response.rows.length > 0) {
                            aggregate = uglcw.extend(aggregate, response.rows[response.rows.length - 1]);
                        }
                        return aggregate;
                      }
                     },
                     dataBound: function(){
                       var ids = $.map(uglcw.ui.get('#grid').value(), function(row){
                            return row.id
                        })
                        getPrintBillCount(ids.join(','))
                     }

                    ">
                <div data-field="billNo" uglcw-options="
                          width:160,
                          template: function(dataItem){
                           return kendo.template($('#bill-no').html())(dataItem);
                          },
                          footerTemplate: '合计'
                        ">销售单号
                </div>
                <div data-field="orderNo" uglcw-options="width:170">订单单号</div>
                <div data-field="outDate" uglcw-options="width:140">销售日期</div>
                <div data-field="khNm" uglcw-options="width:180, tooltip: true">客户名称</div>
                <div data-field="staff" uglcw-options="width:90">业务员</div>
                <div data-field="outType" uglcw-options="width:90">出库类型</div>
                <div data-field="op" uglcw-options="width:200, template: uglcw.util.template($('#opt-tpl').html())">操作</div>
                <div data-field="newTime"
                     uglcw-options="width:90, template: uglcw.util.template($('#modified').html())">是否修改过
                </div>
                <div data-field="count" uglcw-options="width:700, hidden: true,
                         template: function(data){
                            return kendo.template($('#product-list').html())(data.list);
                         }
                        ">商品信息
                </div>
                <c:if test="${permission:checkUserFieldPdm('stk.stkSend.lookamt')}">
                    <div data-field="totalAmt" uglcw-options=" width:80, footerTemplate: '#= data.totalAmt#',
                             ">
                        合计金额
                    </div>
                    <div data-field="discount" uglcw-options="width:80, footerTemplate: '#= data.discount#'">
                        整单折扣
                    </div>
                    <div data-field="disAmt" uglcw-options="width:80, footerTemplate: '#= data.disAmt#'">单据金额</div>
                    <div data-field="recAmt" uglcw-options="width:80, footerTemplate: '#= data.recAmt#'">已收金额</div>
                    <div data-field="freeAmt" uglcw-options="width:80, footerTemplate: '#= data.freeAmt#'">
                        核销金额
                    </div>
                </c:if>
                <div data-field="billStatus" uglcw-options="width:80">状态</div>
                <div data-field="operator" uglcw-options="width:90">创建人</div>
                <div data-field="remarks" uglcw-options="width:100, tooltip:true">备注</div>
                <div data-field="shr" uglcw-options="width:160, tooltip: true">收货人</div>
                <div data-field="tel" uglcw-options="width:140, tooltip: true">电话</div>
                <div data-field="address" uglcw-options="width:160,tooltip: true">地址</div>
                <div data-field="pszd" uglcw-options="width:100,tooltip: true">配送指定</div>
                <div data-field="epCustomerName" uglcw-options="width:160">所属二批</div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-kendo-template" id="toolbar">
    <%--<a href="javascript:maxMin(this);">--%>
        <%--<span style="margin-left: 5px;" class="k-icon uglcw-grid-maxmin ion-md-expand"></span>--%>
    <%--</a>--%>
    <%--<c:if test="${permission:checkUserButtonPdm('stk.stkOut.createxs')}">--%>
        <%--<a role="button" href="javascript:add(0);" class="k-button k-button-icontext">--%>
            <%--<span class="k-icon k-i-file-add"></span>销售开单--%>
        <%--</a>--%>
    <%--</c:if>--%>
    <%--<c:if test="${permission:checkUserButtonPdm('stk.stkOut.ghwaredesc')}">--%>
        <%--<a role="button" class="k-button k-button-icontext" href="javascript:showProduct();">--%>
            <%--<span class="k-icon k-i-paste-plain-text"></span>销售商品信息</a>--%>
    <%--</c:if>--%>
    <%--<c:if test="${permission:checkUserButtonPdm('stk.stkOut.ghwaredesc')}">--%>
        <%--<a role="button" class="k-button k-button-icontext" href="javascript:batchPrint();">--%>
            <%--<span class="k-icon k-i-print"></span>批量打印--%>
        <%--</a>--%>
    <%--</c:if>--%>
    <%--<a role="button" class="k-button k-button-icontext"--%>
       <%--href="javascript:downloadDetails();">--%>
        <%--<span class="k-icon k-i-download"></span>下载销售发票明细--%>
    <%--</a>--%>
    <%--<a role="button" class="k-button k-button-icontext"--%>
       <%--href="javascript:showSpecialOrder();">--%>
        <%--<span class="k-icon k-i-search"></span>查询未生成发票的订单--%>
    <%--</a>--%>
</script>

<script id="modified" type="text/x-uglcw-template">
    # if(data.outType){ #
    <span>#= data.newTime ? '已修改' : '未修改' #</span>
    # } #
</script>

<script id="saleTypeTpl" type="text/x-uglcw-template">
    # if(data.saleType){ #
    <span>#= data.saleType=='001' ? '传统业务类' : '线上商城' #</span>
    # } #
</script>

<script id="opt-tpl" type="text-x-uglcw-template">
    # if(data.outType){ #
    <button class="k-button k-success" onclick="printBill(#=data.id#)"><i class="k-icon"></i>打印(<span
            id="print_#= data.id#">0</span>)
    </button>
    # if(data.billStatus == '作废'){ #
    <button class="k-button k-info" onclick="copyBill(#=data.id#, '#=data.orderId#', '#=data.outType#')"><i
            class="k-icon"></i>复制
    </button>
    # } else if(data.billStatus == '暂存') {#
    <button class="k-button k-info" style="width: 30px"
            onclick="auditBill(this,#=data.id#, '#= data.billStatus#', '#= data.billNo#','#=data.stkId#')"><i
            class="k-icon"></i>审批
    </button>
    # } #
    # } #

</script>
<script id="product-list" type="text/x-kendo-template">
    <table class="product-grid">
        <tbody>
        <tr style="font-weight: bold;">
            <td style="width: 120px;">商品名称</td>
            <td style="width: 60px;">单位</td>
            <td style="width: 80px;">规格</td>
            <td style="width: 80px;">销售类型</td>
            <td style="width: 60px;">数量</td>
            <td style="width: 60px;">单价</td>
            <td style="width: 60px;">总价</td>
            <td style="width: 60px;">已发数量</td>
            <td style="width: 60px;">未发数量</td>
        </tr>
        #for (var i=0; i< data.length; i++) { #
        <tr>
            <td>#= data[i].wareNm #</td>
            <td>#= data[i].unitName #</td>
            <td>#= data[i].wareGg #</td>
            <td>#= data[i].xsTp #</td>
            <td>#= data[i].qty #</td>
            <td>#= data[i].price #</td>
            <td>#= kendo.toString(data[i].qty * data[i].price, "n") #</td>
            <td>#= data[i].outQty #</td>
            <td>#= data[i].outQty1 #</td>
        </tr>
        # }#
        </tbody>
    </table>
</script>
<script id="bill-no" type="text/x-kendo-template">
    # if(data.priceFlag ==1 && data.status!=-2 ){ #
        <a href="javascript:showDetail(#= data.id#);" style="color:red;font-size: 12px; font-weight: bold;">#=
            data.billNo#</a>
    # } else {#
        <a href="javascript:showDetail(#= data.id#);" style="color:\\#337ab7;font-size: 12px; font-weight: bold;">#=
            data.billNo#</a>
        # } #
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
            uglcw.ui.clear('.uglcw-query', {
                sdate: '${sdate}',
                edate: '${edate}',
                billStatus: '暂存'
            });
        });

        uglcw.ui.loaded();
    });

    function query() {
        uglcw.ui.get('#grid').reload();
    }

    function maxMin() {
        var $master = $('.header');
        var grid = uglcw.ui.get('#grid');
        if ($master.is(':visible')) {
            $master.hide();
        } else {
            $master.show();
        }
        $('.uglcw-grid-maxmin').toggleClass('ion-md-expand ion-md-contract');
        setTimeout(function () {
            grid.resize();
        }, 100);
    }

    function add(orderId) {
        uglcw.ui.openTab('销售发票', "${base}manager/pcstkout?orderId=" + orderId)
    }

    //销货商品信息
    function showProduct() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection && selection.length > 0) {
            var billNos = $.map(selection, function (row) {
                return "'" + row.billNo + "'";
            }).join(',');
            uglcw.ui.openTab('销货商品信息', '${base}manager/outWareListForGs?billNo=' + billNos);
        } else {
            uglcw.ui.warning('请勾选发票')
        }
    }

    function showDetail(id) {
        uglcw.ui.openTab('销售发票', "${base}manager/showstkout?dataTp=1&billId=" + id)
    }

    function getPrintBillCount(ids) {
        $.ajax({
            url: "${base}manager/sysPrintRecord/queryPrintCountList",
            data: {fdSourceIds: ids, fdModel: 'com.cnlife.stk.model.StkOutsub'},
            type: "post",
            async: true,
            success: function (json) {
                if (json.state) {
                    $.map(json.rows, function (data) {
                        $("#print_" + data.fd_source_id).text(data.count);
                    });

                }

            }
        });
    }

    function copyBill(id, orderId, title) {
        if (!orderId) {
            uglcw.ui.openTab(title, '${base}manager/copystkout?billId=' + id);
        } else {
            $.ajax({
                url: '${base}manager/checkOrderIsUse',
                type: 'post',
                data: {orderId: orderId},
                success: function (response) {
                    if (!response.state) {
                        uglcw.ui.openTab(title, '${base}manager/copystkout?billId=' + id);
                    } else {
                        uglcw.ui.warning('该单据是由销售订单生成的销售发票单，不能复制，只有作废该发票单，才能复制!')
                    }
                }
            })
        }
    }

    function batchPrint() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection && selection.length > 0) {
            uglcw.ui.openTab('批量打印发票', '${base}manager/showstkoutbatchprint?fromFlag=1&billIds=' + $.map(selection, function (row) {
                return row.id
            }).join(','));
        } else {
            uglcw.ui.info('请勾选单据');
        }
    }



    function auditBill(el, id, status, no, stkId) {
        if (status != '暂存') {
            return uglcw.ui.info('只有暂存的单据才需要审批!');
        }
        var row = uglcw.ui.get("#grid").k().dataItem($(el).closest("tr"));
        var wareList = row.get("list");
        console.log(wareList[0]);
        uglcw.ui.confirm('是否确定审核[' + no + ']？', function () {
            checkProductStock(stkId, wareList, function () {
                $.ajax({
                    url: '${base}manager/auditDraftStkOut',
                    type: 'post',
                    data: {billId: id, changeOrderPrice: 0, autoCreateFhd: 1},
                    dataType: 'json',
                    success: function (response) {
                        if (response.state) {
                            uglcw.ui.success(response.msg);
                            uglcw.ui.get('#grid').reload({stay: true});
                        } else {
                            uglcw.ui.error('审核失败！');
                        }
                    }
                })
            }, "审批");
        })
    }


    function checkProductStock(stkId, products, callback, op) {
        $.ajax({
            url: '${base}manager/checkStorageWare',
            type: 'POST',
            data: {
                stkId: stkId,
                wareStr: JSON.stringify(products)
            },
            success: function (response) {
                if (response && response.state) {
                    if ((op == '暂存') && response.msg) {
                        uglcw.ui.confirm(response.msg + '是否继续?', function () {
                            callback();
                        })
                        return;
                    }
                    var stockIds = response.stockIds;
                    if (stockIds && AUTO_CREATE_FHD == '' && NEW_STOCK_CAL == 'none') {
                        uglcw.ui.notice({
                            type: 'error',
                            title: '提示',
                            desc: '以下商品库存不足:' + stockIds + ',不允许' + op + '！'
                        });
                        return;
                    }
                    callback();
                } else {
                    callback();
                }
            }
        })
    }

    <%--function auditBill(id, status, no) {--%>
        <%--if (status != '暂存') {--%>
            <%--return uglcw.ui.info('只有暂存的单据才需要审批!');--%>
        <%--}--%>
        <%--uglcw.ui.confirm('是否确定审核[' + no + ']？', function () {--%>
            <%--$.ajax({--%>
                <%--url: '${base}manager/auditDraftStkOut',--%>
                <%--type: 'post',--%>
                <%--data: {billId: id, changeOrderPrice: 0},--%>
                <%--dataType: 'json',--%>
                <%--success: function (response) {--%>
                    <%--if (response.state) {--%>
                        <%--uglcw.ui.success('审核成功！');--%>
                        <%--uglcw.ui.get('#grid').reload();--%>
                    <%--} else {--%>
                        <%--uglcw.ui.error('审核失败！');--%>
                    <%--}--%>
                <%--}--%>
            <%--})--%>
        <%--})--%>
    <%--}--%>

    function printBill(id) {
        uglcw.ui.openTab('发票单' + id, '${base}manager/showstkoutprint?fromFlag=1&billId=' + id)
    }

    function downloadDetails() {
        uglcw.ui.confirm('是否下载发票明细数据?', function () {
            var query = uglcw.ui.bind('.form-horizontal');
            var params = $.map(query, function (v, k) {
                return k + '=' + v
            });
            window.location.href = '${base}manager/downloadOutWareListForBillToExcel?' + params.join('&');
        })
    }

    function showSpecialOrder() {
        uglcw.ui.openTab('销售订单列表', '${base}manager/showOrderPage?dataTp=0');
    }
</script>
</body>
</html>
