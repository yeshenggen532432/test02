<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>采购单据查询列表</title>
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
        <c:set var="showOther" value="${permission:checkUserButtonPdm('stk.stkIn.showother')}"/>
        <c:set var="showTuihuo" value="${permission:checkUserButtonPdm('stk.stkIn.showtuihuo')}"/>
        <c:set var="showCg" value="${permission:checkUserButtonPdm('stk.stkIn.showcg')}"/>
        <div class="layui-card-header actionbar btn-group">
            <c:if test="${permission:checkUserButtonPdm('stk.stkIn.createkg')}">
                <a role="button" href="javascript:addPurchase();" class="k-button k-button-icontext primary">
                    <span class="k-icon k-i-track-changes-accept"></span>采购开单
                </a>
            </c:if>
            <c:if test="${permission:checkUserButtonPdm('stk.stkIn.createother')}">
                <a role="button" class="k-button k-button-icontext" href="javascript:addOther();">
                    <span class="k-icon k-i-add"></span>其他入库</a>
            </c:if>
            <c:if test="${permission:checkUserButtonPdm('stk.stkIn.tuihuo')}">
                <a role="button" class="k-button k-button-icontext" href="javascript:addPurchaseReturn();">
                    <span class="k-icon k-i-track-changes-reject"></span>采购退货
                </a>
            </c:if>
<%--            <c:if test="${permission:checkUserButtonPdm('stk.stkIn.look')}">--%>
<%--                <a role="button" class="k-button k-button-icontext"--%>
<%--                   href="javascript:showDetail();">--%>
<%--                    <span class="k-icon k-i-preview"></span>查看--%>
<%--                </a>--%>
<%--            </c:if>--%>

            <a role="button" id="showColumnSetting" class="k-button k-button-icontext" >
                <span class="k-icon k-i-settings"></span>设置显示列
            </a>

            <c:if test="${permission:checkUserButtonPdm('stk.stkIn.ghdesc')}">
                <a role="button" href="javascript:showProductInfo();" class="k-button k-button-icontext k-grid-add-other">
                    <span class="k-icon k-i-search"></span>购货商品信息</a>
            </c:if>
        </div>
        <div class="layui-card-body full" style="padding-left: 5px;">
            <ul class="uglcw-query">
                <li>
                    <input type="hidden" uglcw-model="jz" value="1" uglcw-role="textbox">
                    <input uglcw-model="billNo" uglcw-role="textbox" placeholder="单据单号">
                </li>
                <li>
                    <input uglcw-model="proName" uglcw-role="textbox" placeholder="供应商">
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="inType" id="inType"
                            placeholder="入库类型"
                            uglcw-options="
                              dataTextField: 'name',
                              dataValueField: 'id'

                            "
                            >
                    </select>

                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="billStatus" placeholder="单据状态">
                        <option value="">全部</option>
                        <option value="暂存" selected>暂存</option>
                        <option value="已收货">已收货</option>
                        <option value="未收货">未收货</option>
                        <option value="作废">作废</option>
                    </select>
                </li>
                <li>
                    <tag:select2 name="stkId" id="stkId" tableName="stk_storage" headerKey="-1"
                                 whereBlock="status=1 or status is null"
                                 headerValue=" " displayKey="id" displayValue="stk_name" placeholder="仓库"/>

                </li>
                <li>
                    <input class="k-textbox" uglcw-role="textbox" uglcw-model="wareNm" placeholder="商品名称">
                </li>
                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}" placeholder="开始日期">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}" placeholder="结束日期">
                </li>
                <li>
                    <input class="k-textbox" uglcw-role="textbox" uglcw-model="remarks" placeholder="备注">
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
            <div id="grid" uglcw-role="grid"
                 uglcw-options="
                    responsive: ['.header', 40],
                    checkbox: true,
                    rowNumber: true,
                    autoBind: false,
                    id:'id',
                    url: '${base}manager/stkInHisPage',
                    criteria: '.uglcw-query',
                    pageable: true,
                     dblclick:function(row){
                      if(row.inType == '采购入库'){
                        uglcw.ui.openTab('采购开票信息'+row.id,'${base}manager/showstkin?dataTp=1&billId='+row.id);
                      }else if(row.inType == '采购退货'){
                        uglcw.ui.openTab('采购退货信息'+row.id,'${base}manager/showstkin?dataTp=1&billId='+row.id);
                      }else{
                        uglcw.ui.openTab('其它入库单信息'+row.id,'${base}manager/showstkin?dataTp=1&billId='+row.id);
                      }
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
                        var rows = response.rows || [];
                        if(rows.length > 0){
                            rows.splice(rows.length - 1, 1);
                        }
                        return rows;
                      },
                      total: function (response) {
                        return response.total || 0;
                      },
                      aggregates: function (response) {
                        var aggregate = {totalAmt: 0, discount:0, disAmt:0,payAmt:0,freeAmt:0};
                        if (response.rows && response.rows.length > 0) {
                            aggregate = uglcw.extend(aggregate, response.rows[response.rows.length - 1])
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
                <div data-field="inDate" uglcw-options="width:140">单据日期</div>
                <div data-field="operator" uglcw-options="width:100">创建人</div>
                <div data-field="inType" uglcw-options="width:80">入库类型</div>
                <div data-field="proName" uglcw-options="width:130,tooltip: true">供应商</div>
                <div data-field="op" uglcw-options="width:200,hidden:${(fns:checkFieldDisplay('sys_config','*','code=\'CONFIG_CGFP_OPEN_ZFJS\'  and status=1') eq '')?'false':'true'}, template: uglcw.util.template($('#opt-tpl').html())">操作</div>
                <div data-field="count" uglcw-options="width:700, hidden: true,
                         template: function(data){
                            return kendo.template($('#product-list').html())(data.list);
                         }
                        ">商品信息
                </div>
                <div data-field="totalAmt" uglcw-options="width:100, hidden:!${permission:checkUserFieldPdm('stk.stkIn.lookamt')}, footerTemplate: '#= data.totalAmt#'">
                    合计金额
                </div>
                <div data-field="discount" uglcw-options="width:100, hidden:!${permission:checkUserFieldPdm('stk.stkIn.lookamt')}, footerTemplate: '#= data.discount#'">
                    整单折扣
                </div>
                <div data-field="disAmt" uglcw-options="width:100, hidden:!${permission:checkUserFieldPdm('stk.stkIn.lookamt')}, footerTemplate: '#= data.disAmt#'">单据金额
                </div>
                <div data-field="payAmt" uglcw-options="width:100, hidden:!${permission:checkUserFieldPdm('stk.stkIn.lookamt')}, footerTemplate: '#= data.payAmt#'">已付金额
                </div>
                <div data-field="freeAmt" uglcw-options="width:100, hidden:!${permission:checkUserFieldPdm('stk.stkIn.lookamt')}, footerTemplate: '#= data.freeAmt#'">
                    核销金额
                </div>
                <div data-field="billStatus" uglcw-options="width:100">单据状态</div>
                <div data-field="submitUser" uglcw-options="width:100,tooltip: true">审核人</div>
                <div data-field="cancelUser" uglcw-options="width:100,tooltip: true">作废人</div>
                <div data-field="remarks" uglcw-options="width:150, tooltip:true">备注</div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-kendo-template" id="toolbar">

</script>


<script id="product-list" type="text/x-kendo-template">
    <table class="product-grid">
        <tbody>
        <tr style="font-weight: bold;">
            <td style="width: 120px;">商品名称</td>
            <td style="width: 60px;">单位</td>
            <td style="width: 80px;">规格</td>
            <td style="width: 80px;">采购类型</td>
            <td style="width: 60px;display: ${permission:checkUserFieldDisplay('stk.stkIn.lookqty')}">数量</td>
            <td style="width: 60px;display: ${permission:checkUserFieldDisplay('stk.stkIn.lookprice')}">单价</td>
            <td style="width: 60px;display: ${permission:checkUserFieldDisplay('stk.stkIn.lookamt')}">总价</td>
            <td style="width: 60px;display: ${permission:checkUserFieldDisplay('stk.stkIn.lookqty')}">已收数量</td>
            <td style="width: 60px;display: ${permission:checkUserFieldDisplay('stk.stkIn.lookqty')}">未收数量</td>
        </tr>
        #for (var i=0; i< data.length; i++) { #
        <tr>
            <td>#= data[i].wareNm #</td>
            <td>#= data[i].unitName #</td>
            <td>#= data[i].wareGg #</td>
            <td>#= data[i].inTypeName #</td>
            <td style='display: ${permission:checkUserFieldDisplay('stk.stkIn.lookqty')}'>#= data[i].qty #</td>
            <td style='display: ${permission:checkUserFieldDisplay('stk.stkIn.lookprice')}'>#= data[i].price #</td>
            <td style='display: ${permission:checkUserFieldDisplay('stk.stkIn.lookamt')}'>#= data[i].amt #</td>
            <td style='display: ${permission:checkUserFieldDisplay('stk.stkIn.lookqty')}'>#= data[i].inQty #</td>
            <td style='display: ${permission:checkUserFieldDisplay('stk.stkIn.lookqty')}'>#= data[i].inQty1 #</td>
        </tr>
        # }#
        </tbody>
    </table>
</script>

<script id="opt-tpl" type="text-x-uglcw-template">
    # if(data.inType=='采购入库'&&data.disAmt1==0){ #
    <button class="k-button k-success" onclick="addCarryOver(#=data.id#)"><i class="k-icon"></i>杂费结转
    </button>
    # } #

</script>

<script id="bill-no" type="text/x-kendo-template">
    <a href="javascript:showDetail(#= data.id#);" style="color: \\#337ab7;font-size: 12px; font-weight: bold;">#=
        data.billNo#</a>
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<%@include file="/WEB-INF/view/v2/include/script-column-view.jsp" %>
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
            ;
        })
        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.uglcw-query', {sdate: '${sdate}', edate: '${edate}'});
        })
        loadInTypes();

        /*显示列相关设置*/
        initColumnShow('CGFP_SHOW_COLUMN');//过滤设置隐藏的列表
        $("#showColumnSetting").click(function(){
            //设置显示列

            showColumnSetting('static/uglcu/biz/erp/columnView/stk_in_column_view.json','CGFP_SHOW_COLUMN');

        });
        /*显示列相关设置*/


        uglcw.ui.loaded()
    });

    function loadInTypes(){
        var w =  uglcw.ui.get("#inType").k();
        w.setDataSource({
            data:[]
        })
        var inDatas = new Array();
        inDatas.push({id:'采购入库',name:'采购入库'});
        inDatas.push({id:'其它入库',name:'其它入库'});
        inDatas.push({id:'采购退货',name:'采购退货'});

        w.setDataSource({
            data:inDatas
        });
        if(${showCg}&&${showOther}&&${showTuihuo}){
        }else{
            w.select(0);
        }


        uglcw.ui.get('#grid').reload();
    }


    function getSelection() {
        var rows = uglcw.ui.get("#grid").selectedRow();
        if (rows && rows.length > 0) {
            return rows;
        } else {
            uglcw.ui.warning('请先选择数据');
            return false;
        }
    }

    function invalid() {
        var selection = getSelection();
        if (selection) {
            if (selection[0].status != 0) {
                return uglcw.ui.error('单据[' + selection[0].billNo + ']不能作废');
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

    function addPurchase() {
        uglcw.ui.openTab('采购单据', '${base}manager/pcstkin');
    }

    function addOther() {
        uglcw.ui.openTab('其它入库开单', '${base}manager/pcotherstkin');
    }

    function addPurchaseReturn() {
        uglcw.ui.openTab('采购退货', '${base}manager/pcinthin');
    }

    function addCarryOver(id) {
            $.ajax({
                url: '${base}/manager/stkExtrasCarryOver/checkInUse',
                data: {
                    billId:id
                },
                type: 'post',
                dataType: 'json',
                success: function (response) {
                    if (response.state) {
                        uglcw.ui.openTab('杂费结转单' + id, '${base}manager/stkExtrasCarryOver/toAdd?billId=' + id);
                    } else {
                        uglcw.ui.error(response.msg);
                    }
                }
            })

    }

    function showDetail(id) {
        if (id) {
            uglcw.ui.openTab('采购单据' + id, '${base}manager/showstkin?dataTp=${dataTp}&billId=' + id);
        } else {
            var selection = uglcw.ui.get('#grid').selectedRow();
            if (selection) {
                var id = selection[0].id;
                uglcw.ui.openTab('采购单据' + id, '${base}manager/showstkin?dataTp=${dataTp}&billId=' + id);
            } else {
                uglcw.ui.warning('请选择单据');
            }
        }
    }

    function showProductInfo() {
        var selection = getSelection();
        if (selection) {
            uglcw.ui.openTab('购货商品信息', '${base}manager/inWareListForGs?billNo=' + $.map(selection, function (row) {
                return "'" + row.billNo + "'";
            }).join(','));
        }
    }
</script>
</body>
</html>
