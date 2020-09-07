<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>发货管理列表</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }

        .uglcw-query li {
            width: 135px !important;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query">
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
                    <input uglcw-role="textbox" uglcw-model="khNm" placeholder="客户名称"/>
                </li>
                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker" value="${param.sdate}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="billStatus"
                            uglcw-options="placeholder:'发货状态'">
                        <option value="未发货" selected>未发货</option>
                        <option value="已发货">已发货</option>
                        <option value="作废">作废</option>
                        <option value="终止未发完">终止未发完</option>
                    </select>
                </li>
                <li>
                    <select uglcw-model="outType" uglcw-role="combobox"
                            uglcw-options="placeholder:'出库类型', index: -1">
                        <option value=""></option>
                        <option value="销售出库">销售出库</option>
                        <option value="其它出库">其它出库</option>
                        <option value="报损出库">报损出库</option>
                        <option value="借出出库">借出出库</option>
                        <%--<option value="领用出库">领用出库</option>--%>
                    </select>
                </li>
                <li>
                    <select uglcw-model="isPay" uglcw-role="combobox"
                            uglcw-options="placeholder:'收款状况', index: -1">
                        <option value="">收款状态</option>
                        <option value="0">未收款</option>
                        <option value="1">已收款</option>
                    </select>
                </li>
                <li>
                    <tag:select2 name="stkId" id="stkId" tableName="stk_storage" headerKey="-1"
                                 headerValue=""
                                 whereBlock="status=1 or status is null"
                                 displayKey="id"
                                 displayValue="stk_name" placeholder="仓库"/>

                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="wareNm" placeholder="商品名称"/>
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="remarks" placeholder="备注"/>
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
                    responsive:['.header',40],
                    toolbar: kendo.template($('#toolbar').html()),
                    id:'id',
                    checkbox: true,
                    url: '${base}manager/stkOutPage',
                    criteria: '.uglcw-query',
                    pageable: true,
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
                        totalAmt:0,
                        discount:0,
                        disAmt:0,
                        recAmt:0,
                        freeAmt:0
                        };
                        if (response.rows && response.rows.length > 0) {
                            aggregate = uglcw.extend(aggregate,response.rows[response.rows.length - 1])
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
                <div data-field="outDate" uglcw-options="width:140">日期</div>

                <div data-field="outType" uglcw-options="width:100">出库类型</div>
                <div data-field="khNm" uglcw-options="width:140, tooltip: true">客户名称</div>
                <div data-field="sumQty" uglcw-options="width:80">单据数量</div>
                <div data-field="sumOutQty" uglcw-options="width:80">已发货数量</div>
                <div data-field="psSumQty" uglcw-options="width:80">配送中数量</div>
                <div data-field="options"
                     uglcw-options="width: 120, template: uglcw.util.template($('#op-tpl').html())">操作
                </div>
                <div data-field="billStatus" uglcw-options="width:100">状态</div>
                <div data-field="count" uglcw-options="width:700, hidden: true,
                         template: function(data){
                            return kendo.template($('#product-list').html())(data.list);
                         }
                        ">商品信息
                </div>
                <c:if test="${permission:checkUserFieldPdm('stk.stkSend.lookamt')}">
                    <div data-field="totalAmt" uglcw-options=" width:100, footerTemplate: '#= uglcw.util.toString(data.totalAmt,\'n2\')#',
                             ">
                        合计金额
                    </div>
                    <div data-field="discount"
                         uglcw-options="width:100, template: '#= data.discount === \'null\' ? \'\' : data.discount#', footerTemplate: '#=uglcw.util.toString(data.discount,\'n2\') #'">
                        整单折扣
                    </div>
                    <div data-field="disAmt"
                         uglcw-options="width:100, footerTemplate: '#= uglcw.util.toString(data.disAmt,\'n2\')#'">单据金额
                    </div>
                    <div data-field="recAmt"
                         uglcw-options="width:100, footerTemplate: '#= uglcw.util.toString(data.recAmt,\'n2\')#'">已收金额
                    </div>
                    <div data-field="freeAmt"
                         uglcw-options="width:100,  template: '#= data.freeAmt === \'null\' ? \'\' : data.freeAmt#',footerTemplate: '#=uglcw.util.toString(data.freeAmt,\'n2\') #'">
                        核销金额
                    </div>
                </c:if>
                <div data-field="staff" uglcw-options="width:100">业务员</div>
                <div data-field="remarks" uglcw-options="width:120">备注</div>
                <div data-field="shr" uglcw-options="width:80, tooltip: true">收货人</div>
                <div data-field="address" uglcw-options="width:120, tooltip: true">地址</div>
                <div data-field="tel" uglcw-options="width:100,tooltip: true">电话</div>
                <div data-field="operator" uglcw-options="width:70">创建人</div>
                <div data-field="pszd" uglcw-options="width:80">配送指定</div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-uglcw-template" id="toolbar">
    <a role="button" href="javascript:showOutListQuery();" class="k-button k-button-icontext">
        <span class="k-icon k-i-search"></span>发货明细查询
    </a>
    <a role="button" id="showColumnSetting" class="k-button k-button-icontext" >
        <span class="k-icon k-i-settings"></span>设置显示列
    </a>
</script>
<script id="op-tpl" type="text/x-uglcw-template">
    <div class="op-button">
        #=renderButton(data)#
    </div>
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
    <a href="javascript:showDetail(#= data.id#,'#=data.outType#');"
       style="color: \\#337ab7;font-size: 12px; font-weight: bold;">#=
        data.billNo#</a>
</script>
<script id="finish-dialog" type="text/x-uglcw-template">
    <div class="layui-card">
        <div class="layui-card-body">
            <form uglcw-role="validator" class="form-horizontal">
                <div class="form-group">
                    <label class="control-label col-xs-4">备注</label>
                    <div class="col-xs-20">
                        <input type="hidden" uglcw-role="textbox" uglcw-model="billId">
                        <textarea style="height: 100px;" uglcw-role="textbox" uglcw-model="remarks"
                                  placeholder="请输入备注"></textarea>
                    </div>
                </div>
            </form>
        </div>
    </div>
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<%@include file="/WEB-INF/view/v2/include/script-column-view.jsp" %>
<script>

    $(function () {
        uglcw.ui.init();
        //uglcw.ui.get('[uglcw-model=billStatus]').value('');
        uglcw.ui.get('[uglcw-model=outType]').value('');
        $('.q-box-arrow').on('click', function () {
            $(this).find('i').toggleClass('k-i-arrow-chevron-left k-i-arrow-chevron-down');
            $('.q-box-more').toggle();
            $('.q-box-wrapper').closest('.layui-card').toggleClass('box-shadow')
        })
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
            uglcw.ui.get('#grid').k().dataSource.read();
        })

        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.uglcw-query');
        })

        /*显示列相关设置*/
        initColumnShow('XSFP_SEND_SHOW_COLUMN');//过滤设置隐藏的列表
        $("#showColumnSetting").click(function(){
            //设置显示列
            showColumnSetting('static/uglcu/biz/erp/columnView/stk_send_out_column_view.json','XSFP_SEND_SHOW_COLUMN');
        });
        /*显示列相关设置*/

        uglcw.ui.loaded()
    })

    function renderButton(data) {
        var rtn = "";
        var br = "";
        if (data.id) {
            if (data.sumOutQty != 0 && data.sumQty >= data.sumOutQty) {
                rtn += '<button class="k-button k-info" onclick="showOutList(' + data.id + ')">发货明细</button>';
                br = '<br/>';
            }
            if (data.status == 0 && data.sumQty > data.sumOutQty) {
                <c:if test="${permission:checkUserFieldPdm('stk.stkSend.senditems')}">
                rtn += br + '<button class="k-button k-info" onclick="send(' + data.id + ', \'' + data.outType + '\',\'' + data.billStatus + '\')">发货</button>';
                br = '<br/>';
                </c:if>
            }
            if ((data.status == 0 || data.status == 1) && data.sumOutQty != 0) {
                // rtn+=br+'<button class="k-button k-warning" onclick="doReturn('+data.id+')">退货</button>';
                br = '<br/>';
            }
            if (data.status == 0 && data.sumOutQty != 0) {
                rtn += br + '<button class="k-button k-success" onclick="finish(' + data.id + ')">完结</button>';
            }
        }
        return rtn;
    }

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

    function showOutListQuery() {
        uglcw.ui.openTab('发货明细查询', '${base}manager/outdetailquery');
    }

    function showDetail(id, outType) {
        if (id) {
            uglcw.ui.openTab(outType + "_发票信息", '${base}manager/showstkout?dataTp=${dataTp}&billId=' + id);
        }
    }

    //发货明细
    function showOutList(billId) {
        uglcw.ui.openTab('发货明细' + billId, '${base}manager/toOutList?billId=' + billId);
    }

    //发货
    function send(billId, outType, status) {

        if (status != '未发货') {
            uglcw.ui.warning("该单据不能操作");
            return;
        }
        uglcw.ui.openTab(outType + "_发货单", '${base}manager/showstkoutcheck?dataTp=1&billId=' + billId);
    }

    function doReturn(billId) {
        uglcw.ui.openTab('退货' + billId, '${base}manager/showstkoutrtn?dataTp=1&billId=' + billId);
    }

    function finish(id, remarks) {
        remarks = remarks || '';
        uglcw.ui.Modal.open({
            title: '完结确认',
            content: $('#finish-dialog').html(),
            success: function (container) {
                uglcw.ui.init(container);
                uglcw.ui.bind(container, {remarks: remarks, billId: id});
            },
            yes: function (container) {
                var data = uglcw.ui.bind($(container).find('form'));
                uglcw.ui.confirm('您确认想要完结该记录吗？', function () {
                    $.ajax({
                        url: '${base}manager/closeStkOut',
                        data: data,
                        type: 'post',
                        dataType: 'json',
                        success: function (json) {
                            if (json.state) {
                                uglcw.ui.success('完结成功');
                                uglcw.ui.get('#grid').reload();
                                uglcw.ui.Modal.close();
                            } else if (json == -1) {
                                uglcw.ui.error('完结失败' + json.msg);
                            }
                        }
                    });
                    return false;
                })
            }
        })
    }
</script>
</body>
</html>
