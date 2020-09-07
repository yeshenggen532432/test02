<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>驰用T3</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }

        .el-tag {
            height: 22px;
        }
    </style>
</head>
<body>
<tag:mask/>
<div class="layui-fluid page-list">
    <div class="layui-card header">
        <div class="layui-card-header actionbar btn-group">
            <a role="button" href="javascript:newBill('ZZRK', '组装单');" class="primary k-button k-button-icontext">
                <span class="k-icon k-i-file-add"></span>组装开单
            </a>
            <a role="button" class="primary k-button k-button-icontext" href="javascript:newBill('CXCK', '拆分单');">
                <span class="k-icon k-i-file-add"></span>拆卸开单</a>
            <a role="button" class="k-button k-button-icontext"
               href="javascript:showDetail();">
                <span class="k-icon k-i-preview"></span>查看
            </a>
        </div>
        <div class="layui-card-body full" style="padding-left: 5px;">
            <ul class="uglcw-query query">
                <li>
                    <input type="hidden" uglcw-model="jz" value="1" uglcw-role="textbox">
                    <input uglcw-model="billNo" uglcw-role="textbox" placeholder="单据号">
                </li>
                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="bizType" uglcw-options="value: ''" placeholder="单据类型">
                        <option value="ZZRK">装机入库</option>
                        <option value="CXCK">拆卸出库</option>
                    </select>
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-options="value: ''" uglcw-model="billStatus" placeholder="单据状态">
                        <option value="-2">暂存</option>
                        <option value="1">已审批</option>
                        <option value="2">已作废</option>
                    </select>
                </li>
                <li>
                    <tag:select2 name="stkId" id="stkId" tableName="stk_storage" headerKey="" whereBlock="status is null or status=1"
                                 headerValue="--出库仓库--" displayKey="id" displayValue="stk_name"/>
                </li>
                <li>
                    <tag:select2 name="stkInId" id="stkInId" tableName="stk_storage" headerKey="" whereBlock="status is null or status=1"
                                 headerValue="--入库仓库--" displayKey="id" displayValue="stk_name"/>
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
                        responsive:['.header',20],
                        id:'id',
                        dblclick: function(row){
                            showDetail(row.id, row.bizType);
                        },
                        rowNumber: true,
                        checkbox: true,
                        url: '${base}manager/stkZzcx/page',
                        criteria: '.uglcw-query',
                        pageable: true,
                        dataBound: function(){
                            uglcw.ui.init('#grid .k-grid-content');
                        }
                    ">
                <div data-field="billNo" uglcw-options="
                          width:180,
                          template: function(dataItem){
                           return kendo.template($('#bill-no').html())(dataItem);
                          }
                        ">单据单号
                </div>
                <div data-field="billName" uglcw-options="width:120">单据类型</div>
                <div data-field="inDate" uglcw-options="width:160">单据日期</div>
                <div data-field="operator" uglcw-options="width:100">创建人</div>
                <div data-field="stkName" uglcw-options="width:120">出库仓库</div>
                <div data-field="stkInName" uglcw-options="width:120">入库仓库</div>
                <div data-field="status"
                     uglcw-options="width:120, template: uglcw.util.template($('#status-tpl').html())">单据状态
                </div>
                <div data-field="count" uglcw-options="width:400, hidden: true,
                         template: function(data){
                            return kendo.template($('#product-list').html())(data.subList);
                         }
                        ">商品信息
                </div>
                <div data-field="remarks" uglcw-options="width:200, tooltip: true">备注</div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-uglcw-template" id="status-tpl">
    <span>
    #if(data.status == -2){#
        <span uglcw-role="tag" uglcw-options="type:'primary'">
        暂存
        </span>
    # } else if(data.status == 0){#
          <span uglcw-role="tag" uglcw-options="type:'success'">
             原料待入库
          </span>
    # }else if(data.status == 1){#
         <span uglcw-role="tag" uglcw-options="type:'success'">
        已审批
         </span>
    # }else {#
        <span uglcw-role="tag" uglcw-options="type:'danger'">
        已作废
        </span>
    #}#
    </span>
</script>
<script id="product-list" type="text/x-uglcw-template">
    <table class="product-grid">
        <tbody>
        <tr style="font-weight: bold;">
            <td style="width: 100px;">商品名称</td>
            <td style="width: 40px;">单位</td>
            <td style="width: 40px;">规格</td>
            <td style="width: 40px;">数量</td>
        </tr>
        #for (var i=0; i< data.length; i++) { #
        <tr>
            <td>#= data[i].wareNm #</td>
            <td>#= data[i].unitName #</td>
            <td>#= data[i].wareGg #</td>
            <td>#= data[i].qty #</td>
        </tr>
        # }#
        </tbody>
    </table>
</script>
<script id="bill-no" type="text/x-uglcw-template">
    # var name = '';#
    #if(data.bizType == 'ZZRK'){#
    #name = '组装入库';#
    #}else if(data.bizType == 'CXCK'){#
    #name = '拆卸出库';#
    #}#
    <button class="k-button" onclick="showDetail(#= data.id#, '#= data.bizType#', '#= name#');"
            style="color: \\#3343a4;font-size: 12px; font-weight: bold;">#=
        data.billNo#
    </button>
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
                grid.showColumn('count')
            } else {
                grid.hideColumn('count');
            }
        });

        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        });

        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.uglcw-query', {sdate: '${sdate}', edate: '$edate}'});
        });


        uglcw.ui.loaded()
    })

    function newBill(type, name) {
        uglcw.ui.openTab(name, '${base}manager/stkZzcx/add?bizType=' + type);
    }

    function showDetail(id, type) {
        if (id) {
            var name = '';
            if (type === 'ZZRK') {
                name = '组装单';
            } else if (type === 'CXCK') {
                name = '拆分单';
            }
            uglcw.ui.openTab(name + id, '${base}manager/stkZzcx/show?billId=' + id);
        } else {
            var selection = getSelection();
            if (selection) {
                var row = selection[0];
                showDetail(row.id, row.bizType);

            }
        }

    }

    function getSelection() {
        var rows = uglcw.ui.get('#grid').selectedRow();
        if (rows && rows.length > 0) {
            return rows;
        } else {
            uglcw.ui.warning('请先选择数据');
            return false;
        }
    }

</script>
</body>
</html>
