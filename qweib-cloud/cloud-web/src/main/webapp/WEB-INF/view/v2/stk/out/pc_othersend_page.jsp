<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>其他出库发货单</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid page-list">
    <div class="layui-card header">
        <div class="layui-card-header actionbar btn-group">
            <c:set var="showQt" value="${permission:checkUserButtonPdm('stk.stkOtherOut.showQt')}"/>
            <c:set var="showBs" value="${permission:checkUserButtonPdm('stk.stkOtherOut.showBs')}"/>
            <c:set var="showJc" value="${permission:checkUserButtonPdm('stk.stkOtherOut.showJc')}"/>
            <c:if test="${permission:checkUserButtonPdm('stk.stkOtherOut.createqt')}">
                <a role="button" href="javascript:add('其他出库单','${base}manager/pcotherstkout');" class="primary k-button k-button-icontext">
                    <span class="k-icon k-i-add"></span>其他出库开单
                </a>
            </c:if>
            <c:if test="${permission:checkUserButtonPdm('stk.stkOtherOut.createbs')}">
            <a role="button" href="javascript:add('报损单','${base}manager/pclossstkout');" class="primary k-button k-button-icontext">
                <span class="k-icon k-i-add"></span>报损开单
            </a>
            </c:if>
            <c:if test="${permission:checkUserButtonPdm('stk.stkOtherOut.createjc')}">
            <a role="button" href="javascript:add('借出单','${base}manager/pcborrowstkout');" class="primary k-button k-button-icontext">
                <span class="k-icon k-i-add"></span>借出开单
            </a>
            </c:if>
<%--            <a role="button" class="k-button k-button-icontext" href="javascript:showProduct();">--%>
<%--                <span class="k-icon k-i-paste-plain-text"></span>销售商品信息</a>--%>
            <a role="button" class="k-button k-button-icontext" href="javascript:batchPrint();">
                <span class="k-icon k-i-print"></span>批量打印
            </a>
        </div>
        <div class="layui-card-body full" style="padding-left: 5px;">
            <ul class="uglcw-query query">
                <li>
                    <input type="hidden" uglcw-model="jz" value="1" uglcw-role="textbox">
                    <input uglcw-model="billNo" uglcw-role="textbox" placeholder="发票单号">
                </li>
                <li>
                    <input uglcw-role="combobox" uglcw-model="customerType"
                           uglcw-options="
                                    loadFilter:{
                                      data: function(response){
                                        return response.list1;
                                      }
                                    },
                                    placeholder:'客户类型',
                                    url: '${base}manager/queryarealist1',
                                    dataTextField:'qdtpNm',
                                    dataValueField: 'qdtpNm',
                                    index: -1,
                                "
                    ></input>
                </li>
                <li>
                    <input uglcw-model="khNm" uglcw-role="textbox" placeholder="客户名称">
                </li>
                <li>
                    <select uglcw-model="outType" uglcw-role="combobox"
                            uglcw-options=" placeholder:'出库类型',
                                         dataTextField: 'name',
                                         dataValueField: 'id',
                                         clearButton: ${(showQt and showBs and showJc)?true:false}
                                "
                            id="outType">
<%--                        <option value="其它出库">其它出库</option>--%>
<%--                        <option value="借出出库">借出出库</option>--%>
<%--                        <option value="报损出库">报损出库</option>--%>
                    </select>
                </li>
                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="billStatus"
                            uglcw-options="placeholder:'发票状态'">
                        <option value="">全部</option>
                        <option value="暂存">暂存</option>
                        <option value="未发货">未发货</option>
                        <option value="已发货">已发货</option>
                        <option value="作废">作废</option>
                        <option value="终止未发完">终止未发完</option>
                    </select>
                </li>
                <li>
                    <input uglcw-model="memberNm" uglcw-role="textbox" placeholder="业务员名称">
                </li>
                <li>
                    <tag:select2 name="stkId" id="stkId" tableName="stk_storage" headerKey="-1" whereBlock="status is null or status=1"
                                 headerValue="" displayKey="id" displayValue="stk_name" placeholder="仓库"/>

                </li>
                <li>
                    <input uglcw-model="wareNm" uglcw-role="textbox" placeholder="商品名称">
                </li>
                <li>
                    <input uglcw-model="remarks" uglcw-role="textbox" placeholder="备注">
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
                    responsive:['.header',20],
                    id:'id',
                    checkbox: true,
                    url: '${base}manager/stkOtherPage',
                    dblclick: function(row){
                        showDetail(row.id,row.outType);
                    },
                    criteria: '.uglcw-query',
                    pageable: true,
                    autoBind: false,
                    aggregate:[
                     {field: 'totalAmt', aggregate: 'SUM'},
                     {field: 'discount', aggregate: 'SUM'},
                     {field: 'disAmt', aggregate: 'SUM'},
                     {field: 'recAmt', aggregate: 'SUM'},
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
                        var aggregate = {
                            totalAmt: 0,
                            discount: 0,
                            disAmt: 0,
                            recAmt: 0,
                            freeAmt: 0
                        };
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
                <div data-field="outType" uglcw-options="width:100">出库类型</div>
                <div data-field="outDate" uglcw-options="width:140">日期</div>
                <div data-field="billStatus" uglcw-options="width:100">状态</div>
                <div data-field="khNm" uglcw-options="width:130">客户名称</div>
                <div data-field="staff" uglcw-options="width:80">业务员</div>
                <%--   <div data-field="operator" uglcw-options="width:160">创建人</div>--%>
                <div data-field="ops" uglcw-options="width:170, template: uglcw.util.template($('#opt').html()) ">操作
                </div>
                <div data-field="count" uglcw-options="width:700, hidden: true,
                         template: function(data){
                            return kendo.template($('#product-list').html())(data.list);
                         }
                        ">商品信息
                </div>
                 <c:if test="${permission:checkUserFieldPdm('stk.stkOut.lookamt')}">
                <div data-field="totalAmt" uglcw-options=" width:80, footerTemplate: '#=uglcw.util.toString(data.totalAmt,\'n2\') #',
                             ">
                    合计金额
                </div>
                <div data-field="discount"
                     uglcw-options="width:80, footerTemplate: '#= uglcw.util.toString(data.discount,\'n2\')#'">
                    整单折扣
                </div>
                <div data-field="disAmt"
                     uglcw-options="width:80, footerTemplate: '#= uglcw.util.toString(data.disAmt,\'n2\')#'">单据金额
                </div>
                <div data-field="recAmt"
                     uglcw-options="width:80, footerTemplate: '#= uglcw.util.toString(data.recAmt,\'n2\')#'">已收金额
                </div>
                <div data-field="freeAmt"
                     uglcw-options="width:80, footerTemplate: '#=uglcw.util.toString(data.freeAmt,\'n2\') #'">
                    核销金额
                </div>
                </c:if>
                <div data-field="remarks" uglcw-options="width:160, tooltip: true">备注</div>
                <div data-field="shr" uglcw-options="width:100, tooltip: true">收货人</div>
                <div data-field="tel" uglcw-options="width:100, tooltip: true">电话</div>
                <div data-field="address" uglcw-options="width:160,tooltip: true">地址</div>
            </div>
        </div>
    </div>
</div>

<script id="opt" type="text/x-uglcw-template">
    # if(data.outType){#
    <a role="button" class="k-button k-button-icontext k-info k-grid-print"
       href="javascript:toPrint(#=data.id#,'#=data.outType#');">
        <span class="k-icon k-i-print"></span>打印</a>
    # if(data.billStatus == '作废'){ #
    <a role="button" class="k-button k-button-icontext k-info k-grid-print"
       href="javascript:toCopy(#=data.id#, #=data.orderId#, '#=data.outType#');">
        <span class="k-icon k-i-copy"></span>复制</a>
    # } #
    # if(data.billStatus == '暂存'){ #
    <a role="button" class="k-button k-button-icontext k-success k-grid-audit"
       href="javascript:toAudit(#=data.id#, '#=data.billStatus#', '#=data.billNo#');">
        <span class="k-icon k-i-check"></span>审批</a>
    # } #
    # } #
</script>

<script id="product-list" type="text/x-uglcw-template">
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
<script id="bill-no" type="text/x-uglcw-template">
    <a href="javascript:showDetail(#= data.id#, '#= data.outType#');" style="color: \\#337ab7;font-size: 12px; font-weight: bold;">#=
        data.billNo#</a>
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        uglcw.ui.init();
        //uglcw.ui.get('#pszd').value('');
        //显示商品
        uglcw.ui.get('#showProducts').on('change', function () {
            var checked = uglcw.ui.get('#showProducts').value();
            var grid = uglcw.ui.get('#grid');
            if (checked) {
                grid.showColumn('count');
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
        loadOutTypes();
        uglcw.ui.loaded()
    })

    function loadOutTypes(){
        var w =  uglcw.ui.get("#outType").k();
        w.setDataSource({
            data:[]
        })
        var outDatas = new Array();
        if('${showQt}'=='false'
            &&'${showBs}'=='false'
            &&'${showJc}'=='false'){
            outDatas.push({id:'无发票权限',name:'无发票权限'});
        }
        if('${showQt}'=='true'){
            outDatas.push({id:'其它出库',name:'其它出库'});

        }
        if('${showBs}'=='true'){
            outDatas.push({id:'报损出库',name:'报损出库'});
        }
        if('${showJc}'=='true'){
            outDatas.push({id:'借出出库',name:'借出出库'});
        }
        w.setDataSource({
            data:outDatas
        });

        if(${showQt}&&${showBs}&&${showJc}){
        }else{
            w.select(0);
        }
        uglcw.ui.get('#grid').reload();
    }

    function add(type, path) {
        uglcw.ui.openTab(type, path + '?r=' + new Date().getTime());
    }

    //销货商品信息
    function showProduct() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection && selection.length > 0) {
            var billNos = $.map(selection, function (row) {
                return "'" + row.billNo + "'";
            });
            uglcw.ui.openTab('销货商品信息', '${base}manager/outWareListForGs?billNo=' + billNos.join(','));
        } else {
            uglcw.ui.warning('请勾选发票')
        }
    }

    function showDetail(id, bizType) {
        uglcw.ui.openTab(bizType + '_发票信息', "${base}manager/showstkout?dataTp=1&billId=" + id)
    }

    function toPrint(id, bizType) {
        uglcw.ui.openTab(bizType + '_发票信息', '${base}manager/showstkoutprint?fromFlag=1&billId=' + id);
    }

    function toAudit(id, status, billNo) {
        if (status !== '暂存') {
            return uglcw.ui.warning('只有暂存的单据才需要审批！')
        }
        uglcw.ui.confirm('是否确定审核[' + billNo + ']?', function () {
            $.ajax({
                url: '${base}manager/auditDraftStkOut',
                type: 'post',
                dataType: 'json',
                data: {billId: id, changeOrderPrice: 0},
                success: function (response) {
                    if (response.state) {
                        uglcw.ui.get('#grid').reload();
                    } else {
                        uglcw.ui.error('审核失败');
                    }
                }
            })
        })
    }

    function toCopy(billId, orderId, title) {
        if (!orderId) {
            uglcw.ui.openTab(title, '${base}manager/copystkout?billId=' + billId);
        } else {
            $.ajax({
                url: '${base}manager/checkOrderIsUse',
                type: 'post',
                data: {orderId: orderId},
                success: function (resposne) {
                    if (resposne.state) {
                        uglcw.ui.openTab(title, '${base}manager/copystkout?billid=' + billId);
                    } else {
                        uglcw.ui.toast('该单据是由销售订单生成的销售发票单，不能复制，只有作废该发票单，才能复制!');
                        return;
                    }
                }
            })
        }

    }

    function batchPrint() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (!selection || selection.length < 1) {
            return uglcw.ui.warning('请勾选发票');
        }
        uglcw.ui.openTab('批量打印发票', '${base}manager/showstkoutbatchprint?printType=1&fromFlag=1&billIds=' + $.map(selection, function (item) {
            return item.id
        }).join(','));
    }


</script>
</body>
</html>
