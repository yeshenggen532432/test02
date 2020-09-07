<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>待配货列表</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        html, body {
            height: 100%;
            margin: 0 auto;
        }
    </style>
</head>
<body>
<tag:mask/>
<div class="layui-card header" style="margin-bottom: 0px;">
    <div class="layui-card-body">
        <ul class="uglcw-query">
                <input type="hidden" uglcw-model="jz" uglcw-role="textbox" value="1"/>
<%--
                <select uglcw-role="combobox" uglcw-model="isPay">
                    <option value="">全部</option>
                    <option value="0">未收款</option>
                    <option value="1">已收款</option>
                </select>--%>
            <li>
                <input uglcw-model="billNo" uglcw-role="textbox" placeholder="发票单号">
            </li>
            <li>
                <select uglcw-role="combobox" uglcw-model="customerType" placeholder="客户类型"
                        uglcw-options="
                                  url: '${base}manager/queryarealist1',
                                  loadFilter:{
                                    data: function(response){return response.list1 ||[];}
                                  },
                                  dataTextField: 'qdtpNm',
                                  dataValueField: 'qdtpNm'
                                "
                             >

                </select>
            </li>
            <li>
                <input class="k-textbox" uglcw-role="textbox" uglcw-model="khNm" placeholder="客户名称">
            </li>
            <li>
                <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}">
            </li>
            <li>
                <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
            </li>

            <li>
                <select uglcw-role="combobox" uglcw-model="billStatus"
                        placeholder="发票状态">
                    <option value="未发货" selected>未发货</option>
                    <option value="已发货">已发货</option>
                </select>
            </li>
            <li>
                <tag:select2 name="vehId" id="vehId" tclass="pcl_sel"
                             headerKey=""
                             validate="required"
                             placeholder="车辆"
                             tableName="stk_vehicle" displayKey="id"
                             displayValue="veh_no"/>
            </li>
            <li style="display:none;">
                <select  uglcw-role="combobox" uglcw-model="isPay">
                    <option value="-1">全部</option>
                    <option value="0">未收款</option>
                    <option value="1">已收款</option>
                </select>
            </li>
            <li>
                <select uglcw-model="outType" uglcw-role="combobox" id="outType" placeholder="出库类型">
                    <option value="销售出库">销售出库</option>
                    <option value="其它出库">其它出库</option>
                    <option value="报损出库">报损出库</option>
                    <option value="领用出库">领用出库</option>
                    <option value="借出出库">借出出库</option>
                </select>
            </li>
            <li>
                <uglcw:storage-select base="${base}" showHead="true" id="stkId" name="stkId" status="1" type="0"/>
            </li>
            <li>
                <input class="k-textbox" uglcw-role="textbox" uglcw-model="wareNm" placeholder="商品名称">
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
<div class="layui-card" style="margin-bottom: 0px;">
    <div class="layui-card-body full">
        <div id="grid" uglcw-role="grid"
             uglcw-options="
                    responsive:['.header',40],
                    id:'id',
                    url: '${base}manager/stkInvoice/stkOutPageForInvoice',
                      toolbar: uglcw.util.template($('#toolbar').html()),
                    criteria: '.uglcw-query',
                    checkbox: true,
                    pageable: true,
                    dblclick:function(row){
                        showDetail(row.id);
                    },

                    ">
            <div data-field="billNo" uglcw-options="
                          width:160,
                          template: function(dataItem){
                           return kendo.template($('#bill-no').html())(dataItem);
                          }

                        ">单号
            </div>
            <div data-field="vehNo" uglcw-options="width:120">车辆</div>
            <div data-field="stkName" uglcw-options="width:120">仓库</div>
            <div data-field="billStatus" uglcw-options="width:100">状态</div>
            <div data-field="staff" uglcw-options="width:80">业务员</div>
            <div data-field="khNm" uglcw-options="width:140">客户名称</div>
            <div data-field="outDate" uglcw-options="width:140">日期</div>
            <div data-field="shr" uglcw-options="width:80">收货人</div>
            <div data-field="tel" uglcw-options="width:100">电话</div>
            <div data-field="address" uglcw-options="width:160">地址</div>
            <div data-field="operator" uglcw-options="width:120">创建人</div>
            <div data-field="count" uglcw-options="width:700, hidden: true,
                         template: function(data){
                            return kendo.template($('#product-list').html())(data.list);
                         }
                        ">商品信息
            </div>
            <c:if test="${permission:checkUserFieldPdm('stk.stkSend.lookamt')}">
                <div data-field="totalAmt" uglcw-options=" width:80">
                    合计金额
                </div>
                <div data-field="discount" uglcw-options="width:80">
                    整单折扣
                </div>
                <div data-field="disAmt" uglcw-options="width:80">单据金额
                </div>
                <div data-field="recAmt" uglcw-options="width:80">已收金额
                </div>
                <div data-field="freeAmt" uglcw-options="width:80">
                    核销金额
                </div>
            </c:if>
            <div data-field="outType" uglcw-options="width:130">出库类型</div>

            <div data-field="remarks" uglcw-options="width:120, tooltip: true">备注</div>

            <div data-field="pszd" uglcw-options="width:80">配送指定</div>
        </div>
    </div>
</div>

<script id="opt-tpl" type="text/x-uglcw-template">
    #if(data.id && data.billStatus !== '作废'){#
    <button class="k-button k-info" onclick="showCheck(#= data.id#, '#= data.outType#', '#= data.billStatus#')"><i
            class="k-icon k-i-success"></i>配送
    </button>
    #}#
</script>


<script id="toolbar" type="text/x-uglcw-template">

    <a role="button" href="javascript:createInvoice();" class="k-button k-button-icontext k-grid-add-purchase">
        <span class="k-icon k-i-search"></span>生成配货单
    </a>

</script>

<script id="product-list" type="text/x-uglcw-template">
    <table class="product-grid">
        <tbody>
        <tr style="font-weight: bold;">
            <td style="width: 100px;">商品名称</td>
            <td style="width: 60px;">销售类型</td>
            <td style="width: 50px;">单位</td>
            <td style="width: 60px;">规格</td>
            <td style="width: 40px;">数量</td>
            <td style="width: 40px;">单价</td>
            <td style="width: 40px;">金额</td>
            <td style="width: 60px;">已送数量</td>
            <td style="width: 60px;">未配送数量</td>
        </tr>

        #for (var i=0; i< data.length; i++) { #
        <tr>
            <td>#= data[i].wareNm #</td>
            <td>#= data[i].xsTp #</td>
            <td>#= data[i].unitName #</td>
            <td>#= data[i].wareGg #</td>
            <td>#= data[i].qty #</td>
            <td>#= data[i].price #</td>
            <td>#= uglcw.util.toString(data[i].amt, "n") #</td>
            <td>#= data[i].outQty #</td>
            <td>#= data[i].outQty1 #</td>
        </tr>
        # }#
        </tbody>
    </table>
</script>
<script id="bill-no" type="text/x-uglcw-template">
    <a href="javascript:showBill(#= data.id#,'#= data.outType#');"
       style="color: \\#337ab7;font-size: 12px; font-weight: bold;">#=
        data.billNo#</a>
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
            uglcw.ui.clear('.uglcw-query', {sdate: '${sdate}', edate: '${edate}'});
        });

        uglcw.ui.loaded()
    });

    function showBill(id, outType) {
        uglcw.ui.openTab(outType, "${base}manager/showstkout?dataTp=1&billId=" + id)
    }

    function createInvoice(){
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection && selection.length > 0) {
            var billIds = $.map(selection, function (row) {
                return row.id
            }).join(',');
            uglcw.ui.openTab("生成配货单", "${base}manager/stkInvoice/add?billIds=" + billIds)
        } else {
            uglcw.ui.info('请勾选单据');
        }
    }
</script>
</body>
</html>
