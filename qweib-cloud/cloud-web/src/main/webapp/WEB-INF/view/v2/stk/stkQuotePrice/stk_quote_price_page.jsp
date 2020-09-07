<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>客户商品报价单列表</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }
        .row-color-blue {
            color: blue;
            font-weight: bold;
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
                    <input type="hidden" uglcw-model="jz" value="1" uglcw-role="textbox">
                    <input type="hidden" uglcw-model="billType" value="0" uglcw-role="textbox">
                    <input uglcw-model="billNo" uglcw-role="textbox" placeholder="单据号">
                </li>
                <li>
                    <select uglcw-model="status" uglcw-role="combobox" uglcw-options="placeholder:'单据状态'">
                        <option value="">--单据状态--</option>
                        <option value="-2">暂存</option>
                        <option value="1">已审批</option>
                        <option value="2">已作废</option>
                    </select>
                </li>
                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
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
                    toolbar: uglcw.util.template($('#toolbar').html()),
                    id:'id',
                        dataBound: function(){
                        var data = this.dataSource.view();
                        $(data).each(function(idx, row){
                            var clazz = ''
                            if(row.status == 2){
                                clazz = 'row-color-blue';
                            }
                            $('#grid tr[data-uid='+row.uid+']').addClass(clazz);
                        })
                    },
                     dblclick:function(row){
                       uglcw.ui.openTab('>客户商品报价信息'+row.id, '${base}manager/stkQuotePrice/show?billId='+ row.id+$.map( function(v, k){  //只带id
                        return k+'='+(v||'');
                       }).join('&'));
                     },
                    url: '${base}manager/stkQuotePrice/page',
                    criteria: '.uglcw-query',
                    pageable: true,
                    ">
                <div data-field="billNo" uglcw-options="
                          width:160
                        ">单据单号
                </div>
                <div data-field="proName" uglcw-options="width:160">客户名称
                </div>
                <div data-field="customerTypeName" uglcw-options="width:160">客户类别
                </div>
                <div data-field="customerLevelName" uglcw-options="width:160">客户等级
                </div>
                <div data-field="inDate" uglcw-options="width:140">单据日期</div>
                <div data-field="status" uglcw-options="width:100,
                         template: uglcw.util.template($('#formatterStatus').html())">单据状态
                </div>
                <div data-field="op" uglcw-options="width:180,
                 template: uglcw.util.template($('#opt-tpl').html())">操作</div>
                <div data-field="count" uglcw-options="width:700, hidden: true,
                         template: function(data){
                            return kendo.template($('#product-list').html())(data.list);
                         }
                        ">商品信息
                </div>
                <div data-field="createName" uglcw-options="width:120">创建人</div>
                <div data-field="remarks" uglcw-options="width:200">备注</div>
            </div>
        </div>
    </div>

</div>
<script type="text/x-uglcw-template" id="toolbar">
    <%--<c:if test="${permission:checkUserFieldPdm('stk.stkQuotePrice.open')}">--%>
        <a role="button" href="javascript:add();" class="k-button k-button-icontext">
            <span class="k-icon k-i-track-changes-accept"></span>客户报价
        </a>
    <%--</c:if>--%>
    <%--<c:if test="${permission:checkUserFieldPdm('stk.stkQuotePrice.show')}">--%>
        <a role="button" class="k-button k-button-icontext"
           href="javascript:showDetail();">
            <span class="k-icon k-i-preview"></span>查看
        </a>
    <%--</c:if>--%>
</script>
<script id="formatterStatus" type="text/x-uglcw-template">
    #if(data.status==0||data.status==-2){#
    暂存
    #}else if(data.status==1){#
    已审批
    #}else{#
    已作废
    #}#
</script>
<script id="bill-no" type="text/x-uglcw-template">
    <a href="javascript:showDetail(#= data.id#);" style="color: \\#337ab7;font-size: 13px; font-weight: bold;">#=
        data.billNo#</a>
</script>

<script id="opt-tpl" type="text-x-uglcw-template">
    <button class="k-button k-success" style="width: 45px" onclick="toPrint(#=data.id#)"><i class="k-icon"></i>打印
    </button>
    # if(data.status == -2) {#
    <br/>
    <button class="k-button k-info" style="width: 30px" onclick="auditBill(#=data.id#)"><i
            class="k-icon"></i>审批
    </button>
    # } #

   #if(data.status == 1&&data.sycState!=1) {#
    <br/>
    <button class="k-button k-info" style="width: 110px" onclick="sycBill(this,#=data.id#)"><i
            class="k-icon"></i>同步到历史干预价
    </button>
    # } #

    #if(data.status == 1&&data.sycZxState!=1) {#
    <br/>
    <button class="k-button k-info" style="width: 110px" onclick="sycZxBill(this,#=data.id#)"><i
            class="k-icon"></i>同步到执行价
    </button>
    # } #
</script>

<script id="product-list" type="text/x-kendo-template">
    <table class="product-grid">
        <tbody>
        <tr style="font-weight: bold;">
            <td style="width: 120px;">商品名称</td>
            <td style="width: 60px;">单位</td>
            <td style="width: 80px;">规格</td>
            <td style="width: 60px;">执行价(大)</td>
            <td style="width: 60px;">最新历史价(大)</td>
            <td style="width: 60px;display: none">加减价+-</td>
            <td style="width: 60px;">报价(大)</td>
            <td style="width: 60px;">报价(小)</td>
        </tr>
        #for (var i=0; i< data.length; i++) { #
        <tr>
            <td>#= data[i].wareNm #</td>
            <td>#= data[i].unitName #</td>
            <td>#= data[i].wareGg #</td>
            <td>#= data[i].zxPrice #</td>
            <td>#= data[i].newHisPrice #</td>
            <td style="display: none">#= data[i].disPrice #</td>
            <td>#= data[i].price #</td>
            <td>#= data[i].minPrice === undefined ? '' : data[i].minPrice #</td>
        </tr>
        # }#
        </tbody>
    </table>
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
        })

        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        })

        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.uglcw-query');
        })

        uglcw.io.on('pcstkinreload', function () {
            uglcw.ui.get('#grid').reload();
        })
        uglcw.ui.loaded()
    })


    function add() {
        uglcw.ui.openTab('客户商品报价单', '${base}manager/stkQuotePrice/add');
    }

    function showDetail(id) {
        if (id) {
            uglcw.ui.openTab('客户商品报价单' + id, '${base}manager/stkQuotePrice/show?billId=' + id);
        } else {
            var selection = uglcw.ui.get('#grid').selectedRow();
            if (selection) {
                var id = selection[0].id;
                uglcw.ui.openTab('客户商品报价单' + id, '${base}manager/stkQuotePrice/show?billId=' + id);
            } else {
                uglcw.ui.warning('请选择单据');
            }
        }
    }

    function sycBill(el,id){
        var row = uglcw.ui.get("#grid").k().dataItem($(el).closest("tr"));
        var datas = row.list;
        var proId = row.proId;
        var form = {};
        form.customerId = proId;
        form.wareStr = JSON.stringify(datas);
        $.ajax({
            url: '${base}manager/updateCustomerWarePrices',
            type: 'post',
            dataType: 'json',
            data: form,
            success: function (json) {
                if (json.state) {
                    uglcw.ui.info('干预成功');
                    sycState(id);
                } else {
                    uglcw.ui.error(json.msg);
                }
                uglcw.ui.loaded();
            },
            error: function () {
                uglcw.ui.loaded();
                uglcw.ui.error('干预失败');
            }
        })
    }

    function sycState(billId){
        $.ajax({
            url: '${base}manager/stkQuotePrice/sycState',
            type: 'post',
            dataType: 'json',
            data: {billId:billId},
            success: function (json) {
                if (json.state) {
                    uglcw.ui.get('#grid').reload();
                }
                uglcw.ui.loaded();
            }
        })
    }

    function sycZxState(billId){
        $.ajax({
            url: '${base}manager/stkQuotePrice/sycZxState',
            type: 'post',
            dataType: 'json',
            data: {billId:billId},
            success: function (json) {
                if (json.state) {
                    uglcw.ui.get('#grid').reload();
                }
                uglcw.ui.loaded();
            }
        })
    }

    function sycZxBill(el,id){
        var row = uglcw.ui.get("#grid").k().dataItem($(el).closest("tr"));
        var datas = row.list;
        var proId = row.proId;
        var form = {};
        form.customerId = proId;
        form.wareStr = JSON.stringify(datas);
        $.ajax({
            url: '${base}manager/updateCustomerWareZxPrices',
            type: 'post',
            dataType: 'json',
            data: form,
            success: function (json) {
                if (json.state) {
                    uglcw.ui.info('干预成功');
                    sycZxState(id);
                } else {
                    uglcw.ui.error(json.msg);
                }
                uglcw.ui.loaded();
            },
            error: function () {
                uglcw.ui.loaded();
                uglcw.ui.error('干预失败');
            }
        })
    }

    function auditBill(billId) {//审批
        uglcw.ui.confirm('是否确定审批？', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/stkQuotePrice/audit',
                type: 'post',
                data: {billId: billId},
                dataType: 'json',
                success: function (response) {
                    uglcw.ui.loaded();
                    if (response.state) {
                        uglcw.ui.success('审批成功');
                    } else {
                        uglcw.ui.warning(response.msg || '操作失败');
                    }
                    uglcw.ui.get('#grid').reload();
                }
            })
        })
    }

    function toPrint(billId) {
        uglcw.ui.openTab('打印客户商品报价单${stkQuotePrice.id}', '${base}manager/stkQuotePrice/print?billId=' + billId);
    }


</script>
</body>
</html>
