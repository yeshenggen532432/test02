<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>销售票据明细表</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        ::-webkit-input-placeholder {
            color:black;
        }
        .biz-type.k-combobox{
            font-weight: bold;

        }
        .biz-type .k-input{
            color: black;
            background-color: rgba(0, 123, 255, .35);
        }
        .uglcw-query>li.xs-tp #xsTp_taglist {
            position: fixed;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .uglcw-grid .product-footer {
            padding: 0;
            text-align: right !important;
        }

        .uglcw-grid .product-footer span {
            text-align: left;
            display: inline-block;
            text-overflow: ellipsis;
            white-space: nowrap;
            position: relative;
            padding: 0 .75rem;
        }
        .grid-footer td{
            border-bottom: none;
            padding: .75rem .75rem;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal query">
                <li>
                    <input type="hidden" id="database" uglcw-model="database" uglcw-role="textbox" value="${database}">
                    <select uglcw-model="timeType" id="timeType" uglcw-role="combobox"
                            uglcw-options="placeholder:'时间类型',value: '2'">
                        <option value="1">发货时间</option>
                        <option value="2">销售时间</option>
                        <option value="3">收款时间</option>
                    </select>
                </li>
                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                </li>
                <li>
                    <select uglcw-model="outType" id="outType" uglcw-role="combobox" uglcw-options="value:'销售出库',
                     placeholder:'出库类型',
                     change: function(){
                        uglcw.ui.get('#xsTp').k().dataSource.read();
                     }
">
                        <option value="销售出库">销售出库</option>
                        <option value="其它出库">其它出库</option>

                    </select>
                </li>
                <li style="width: 180px!important;" class="xs-tp">
                    <input id="xsTp" uglcw-role="multiselect" uglcw-model="xsTp" uglcw-options="
                    placeholder:'销售类型',
                    tagMode: 'single',
                    tagTemplate: uglcw.util.template($('#xp-type-tag-template').html()),
                    autoClose: false,
                    url: '${base}manager/loadXsTp',
                    data: function(){
                        return {
                            outType: uglcw.ui.get('#outType').value()
                        }
                    },
                    loadFilter:{
                        data: function(response){
                            return response.list || []
                        }
                    },
                    dataTextField: 'xsTp',
                    dataValueField: 'xsTp'
                ">

                    <!--<select uglcw-model="xsTp" id="xsTp" uglcw-role="combobox" uglcw-options="placeholder:'销售类型', value:''">
                        <option value="正常销售">正常销售</option>
                        <option value="促销折让">促销折让</option>
                        <option value="消费折让">消费折让</option>
                        <option value="费用折让">费用折让</option>
                        <option value="其他销售">其他销售</option>
                        <option value="其它出库">其它出库</option>
                        <option value="销售退货">销售退货</option>
                    </select>-->
                </li>
                <li>
                    <tag:select2 name="stkId" id="stkId" tableName="stk_storage" headerKey="-1"
                                 whereBlock="status=1 or status is null"
                                 headerValue=" " displayKey="id" displayValue="stk_name" placeholder="仓库"/>

                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="customerTypeId" uglcw-options="
                                                url: '${base}manager/queryarealist1',
                                                placeholder: '客户类型',
                                                dataTextField: 'qdtpNm',
                                                dataValueField: 'id',
                                                loadFilter:{
                                                    data: function(response){
                                                        return response.list1 || [];
                                                    }
                                                }
                                             ">
                    </select>
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="khNm" placeholder="客户名称"/>
                </li>

                <li>
                    <input uglcw-role="textbox" uglcw-model="epCustomerName" placeholder="所属二批"/>
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="staff" placeholder="业务员"/>
                </li>
                <li>
                    <input uglcw-role="textbox" placeholder="商品名称" uglcw-model="wareNm">
                </li>
                <li>
                    <tag:select2 name="shopId" id="shopId" value="${shopId}" tableName="sys_chain_store" headerKey="" headerValue="所属连锁店"
                                 displayKey="id" displayValue="store_name" placeholder="所属连锁店"/>
                </li>
                <li>
                    <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                    <button id="reset" class="k-button" uglcw-role="button">重置</button>
                </li>
                <li>
                    <select class="biz-type" id="saleType" uglcw-model="saleType" uglcw-role="combobox"
                            uglcw-options="placeholder:'业务类型', value: ''">
                        <option value="001" selected>传统业务类</option>
                        <option value="003">线上商城</option>
                        <option value="004">线下门店</option>
                    </select>
                </li>

            </ul>
        </div>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid" class="uglcw-grid-compact"
                 uglcw-options="
                    responsive:['.header',40],
                    toolbar: uglcw.util.template($('#toolbar').html()),
                    id:'id',
                    autoBind: false,
                    url: '${base}manager/queryStkOutDetail',
                    criteria: '.form-horizontal',
                    pageable: true,
                    aggregate:[
                     {field: 'qty', aggregate: 'sum'},
                    ],
                     dblclick: function(row){
                     if(row.xsTp == '销售退货')
                     {
                        uglcw.ui.openTab('销售退货开单', '${base}manager/showstkin?billId=' + row.id);
                     }
                     else if(row.xsTp!= '终端零售')
                     {
                        uglcw.ui.openTab('销售销售开单', '${base}manager/showstkout?billId=' + row.id);
                     }
                     else
                     {
                         uglcw.ui.openTab('终端零售开单', '${base}manager/pos/toPosShopBillDetail?mastId=' + row.id);
                     }

                    },
                    loadFilter: {
                      data: function (response) {
                        response.rows.splice(response.rows.length - 1, 1);
                        var rows = []
                        $(response.rows).each(function(idx, row){
                            var hit = rows.find(function(item){
                               return item.id == row.id
                            })
                            if(!hit){
                                row.products = [
                                    {wareNm: row.wareNm, wareId: row.wareId, xsTp: row.xsTp, unitName: row.unitName, price: row.price,qty:row.qty,amt:row.amt,outQty:row.outQty,outAmt:row.outAmt}
                                ]
                                rows.push(row);
                            }else{
                                hit.qty+=row.qty;
                                hit.amt+=row.amt;
                                hit.outQty+=row.outQty;
                                hit.outAmt+=row.outAmt;
                                hit.recAmt+=row.recAmt;
                                hit.needRec=row.needRec;
                                hit.products.push({wareNm: row.wareNm, wareId: row.wareId, xsTp: row.xsTp, unitName: row.unitName, price: row.price,qty:row.qty,amt:row.amt,outQty:row.outQty,outAmt:row.outAmt})
                            }
                        })
                        return rows;
                      },
                      total: function (response) {
                        return response.total;
                      },
                      aggregates: function (response) {
                        var aggregate = {
                            qty:0,
                            amt: 0,
                            outQty: 0,
                            outAmt: 0,
                            recAmt: 0,
                            needRec:0
                        };
                        if (response.rows && response.rows.length > 0) {
                            aggregate = uglcw.extend(aggregate, response.rows[response.rows.length - 1])
                        }
                        return aggregate;
                      }
                     }

                    ">
                <div data-field="docNo" uglcw-options="width:160, tooltip: true, footerTemplate:'合计'">单号</div>
                <div data-field="khNm" uglcw-options="width: 150, tooltip: true">客户名称</div>
                <%--  <div data-field="wareNm" uglcw-options="width:120,hidden:true, tooltip: true">商品名称</div>
                  <div data-field="xsTp" uglcw-options="width:120,hidden:true">销售类型</div>
                  <div data-field="unitName" uglcw-options="width:100, hidden:true">计量单位</div>
                  <div data-field="price" uglcw-options="width:120,hidden:true, format: '{0:n2}'">销售单价</div>--%>


                <div data-field="wareNm"
                     uglcw-options="width: 800,
                       attributes:{class: 'product-grid'},
                       footerAttributes: {class: 'product-footer'},
                       footerTemplate: uglcw.util.template($('#product-footer-tpl').html()),
                       template: uglcw.util.template($('#product-tpl').html())">商品信息
                </div>

                <div data-field="recAmt"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.recAmt || 0, \'n2\')#'">
                    回款金额
                </div>
                <div data-field="needRec"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.needRec || 0, \'n2\')#'">
                    未回款金额
                </div>
                <div data-field="staff" uglcw-options="width: 150, tooltip: true">业务员</div>
                <div data-field="vehNos" uglcw-options="width: 150, tooltip: true">配送车辆</div>
                <div data-field="remarks" uglcw-options="width: 150, tooltip: true">备注</div>
                <div data-field="address" uglcw-options="width: 150, tooltip: true">地址</div>
                <div data-field="epCustomerName" uglcw-options="width: 150, tooltip: true">所属二批</div>
            </div>
        </div>
    </div>
</div>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script src="${base }/resource/jquery.jdirk.js" type="text/javascript" charset="utf-8"></script>
<tag:exporter service="incomeStatService" method="sumStkOutMast"
              bean="com.qweib.cloud.biz.erp.model.StkOut"
              extraColumns="xsTp:销售类型,unitName:计量单位,price:销售单价,qty:销售数量,amt:销售金额,outQty:发货数量,outAmt:发货金额"
              extraColumnsInsertIndex="3"
              condition=".query" description="销售票据明细表"

/>

<script type="text/x-uglcw-template" id="xp-type-tag-template">
    <div style="width: 130px;
            text-overflow: ellipsis;
            white-space: nowrap">
    # for(var idx = 0; idx < values.length; idx++){ #
        #: values[idx]#
        # if(idx < values.length - 1) {# , # } #
    # } #
    </div>
</script>
<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:toExport();" class="k-button k-button-icontext">
        <span class="k-icon k-i-excel"></span>导出
    </a>
    <a role="button" href="javascript:createRptData();" class="k-button k-button-icontext">
        <span class="k-icon k-i-info"></span>生成报表
    </a>
    <a role="button" href="javascript:queryRpt();" class="k-button k-button-icontext">
        <span class="k-icon k-i-search"></span>查询生成的报表
    </a>
    <a role="button" href="javascript:print();" class="k-button k-button-icontext">
        <span class="k-icon k-i-info"></span>打印
    </a>
</script>

<script id="product-footer-tpl" type="text/x-uglcw-template">
    <table class="product-grid grid-footer" style="table-layout:auto;" >
        <tbody>
        <tr>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td style="width: 80px;">#= uglcw.util.toString((data.qty && data.qty.sum != undefined) ? data.qty.sum : data.qty, 'n2')#</td>
            <td style="width: 80px;">#= uglcw.util.toString(data.amt || 0, 'n2')#</td>
            <td style="width: 80px;">#= uglcw.util.toString(data.outQty || 0, 'n2')#</td>
            <td style="width: 80px;">#= uglcw.util.toString(data.outAmt || 0, 'n2')#</td>
        </tr>
        </tbody>
    </table>
</script>
<script id="product-tpl" type="text/x-uglcw-template">
    <table class="product-grid" >
        <tbody>
        <tr style="font-weight: bold;">
            <td style="width: 120px;">商品名称</td>
            <td style="width: 60px;">销售类型</td>
            <td style="width: 80px;">计量单位</td>
            <td style="width: 80px;">价格</td>
            <td style="width: 80px;">销售数量</td>
            <td style="width: 80px;">销售金额</td>
            <td style="width: 80px;">发货数量</td>
            <td style="width: 80px;">发货金额</td>
        </tr>
        #for (var i=0; i< data.products.length; i++) { #
        <tr>
            <td>#= data.products[i].wareNm #</td>
            <td>#= data.products[i].xsTp #</td>
            <td>#= data.products[i].unitName #</td>
            <td>#= uglcw.util.toString(data.products[i].price,'n2')#</td>
            <td
                    data-field="qty"
                    data-ware-id="#= data.products[i].wareId#"
                    #if(data.products[i].qty){#
                    class="router-link"
                    #}#
            >#= uglcw.util.toString(data.products[i].qty,'n2')#
            </td>
            <td
                    data-field="amt"
                    data-ware-id="#= data.products[i].wareId#"
                    #if(data.products[i].amt){#
                    class="router-link"
                    #}#
            >#= uglcw.util.toString(data.products[i].amt,'n2')#
            </td>
            <td
                    data-field="outQty"
                    data-ware-id="#= data.products[i].wareId#"
                    #if(data.products[i].outQty){#
                    class="router-link"
                    #}#
            >#= uglcw.util.toString(data.products[i].outQty,'n2')#
            </td>
            <td
                    data-field="outAmt"
                    data-ware-id="#= data.products[i].wareId#"
                    #if(data.products[i].outAmt){#
                    class="router-link"
                    #}#
            >#= uglcw.util.toString(data.products[i].outAmt,'n2')#
            </td>
        </tr>
        # }#
        </tbody>
    </table>
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script src="${base }/resource/jquery.jdirk.js" type="text/javascript" charset="utf-8"></script>
<script>

    $(function () {
        uglcw.ui.init();
        $('.q-box-arrow').on('click', function () {
            $(this).find('i').toggleClass('k-i-arrow-chevron-left k-i-arrow-chevron-down');
            $('.q-box-more').toggle();
            $('.q-box-wrapper').closest('.layui-card').toggleClass('box-shadow')
        })

        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        })
        uglcw.ui.loaded()
    })


    function exportExcel() {

    }

    function createRptData() {
        var query = uglcw.ui.bind('.form-horizontal');
        uglcw.ui.openTab('生成销售票据明细表', "${base}manager/toStkOutDetailSave?" + $.map(query, function (v, k) {
            return k + '=' + (v || '');
        }).join('&'));
    }

    function queryRpt() {
        uglcw.ui.openTab('生成的统计表', '${base}manager/toStkCstStatQuery?rptType=8');
    }

    function print() {
        var query = uglcw.ui.bind('.form-horizontal');
        var sdate = query.sdate;
        var edate = query.edate;
        if(sdate==""){
            uglcw.ui.info("开始日期不能为空!");
            return;
        }
        if(edate==""){
            uglcw.ui.info("结束日期不能为空!");
            return;
        }
        var dis =$.date.diff(sdate, 'm', edate);
        if((dis+1)>3){
            uglcw.ui.info("最多只能打印3个月之间的数据");
            return;
        }

        uglcw.ui.openTab('打印销售票据明细', "${base}manager/toStkOutDetailPrint?" + $.map(query, function (v, k) {
            return k + '=' + (v || '');
        }).join('&'));
    }
</script>
</body>
</html>
