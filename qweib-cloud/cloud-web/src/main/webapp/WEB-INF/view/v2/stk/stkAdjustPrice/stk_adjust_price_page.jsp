<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>客户商品调价单列表</title>
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
                <select uglcw-role="combobox" id="proType" uglcw-model="proType"  uglcw-options="placeholder:'对象类别'" >
                    <option value="">对象类别</option>
                    <option value="0">所有客户</option>
                    <option value="3">客户类型</option>
                    <option value="4" >客户等级</option>
                    <option value="2">客户</option>
                </select>
                </li>
                <li>
                    <input uglcw-model="proName" uglcw-role="textbox" placeholder="调价对象">
                </li>
                <li>
                    <select uglcw-role="combobox" id="type" uglcw-model="type"  uglcw-options="placeholder:'调价类型'" >
                        <option value="0">临时调价</option>
                        <option value="1">永久调价</option>
                    </select>
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
                       uglcw.ui.openTab('>客户商品报价信息'+row.id, '${base}manager/stkAdjustPrice/show?billId='+ row.id+$.map( function(v, k){  //只带id
                        return k+'='+(v||'');
                       }).join('&'));
                     },
                    url: '${base}manager/stkAdjustPrice/page',
                    criteria: '.uglcw-query',
                    pageable: true,
                    ">
                <div data-field="billNo" uglcw-options="
                          width:160
                        ">单据单号
                </div>
                <div data-field="proName" uglcw-options="width:160,template: uglcw.util.template($('#formatterProName').html())">调价对象
                </div>
                <div data-field="op" uglcw-options="width:180,
                 template: uglcw.util.template($('#opt-tpl').html())">操作</div>
                <div data-field="inDate" uglcw-options="width:140">调价日期</div>
                <div data-field="_sxdate" uglcw-options="width:200,template: uglcw.util.template($('#formatterSxdate').html())">生效日期</div>
                <div data-field="status" uglcw-options="width:100,
                         template: uglcw.util.template($('#formatterStatus').html())">单据状态
                </div>
                <div data-field="isUse" uglcw-options="width:100,
                         template: uglcw.util.template($('#formatterUse').html())">启用状态
                </div>
                <div data-field="type" uglcw-options="width:100,
                         template: uglcw.util.template($('#formatterType').html())">调价类型
                </div>

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
    <%--<c:if test="${permission:checkUserFieldPdm('stk.stkAdjustPrice.open')}">--%>
        <a role="button" href="javascript:add();" class="k-button k-button-icontext">
            <span class="k-icon k-i-track-changes-accept"></span>临时调价
        </a>
    <a role="button" href="javascript:addEven();" class="k-button k-button-icontext">
        <span class="k-icon k-i-track-changes-accept"></span>永久调价
    </a>
    <%--</c:if>--%>
    <%--<c:if test="${permission:checkUserFieldPdm('stk.stkAdjustPrice.show')}">--%>
        <a role="button" class="k-button k-button-icontext"
           href="javascript:showDetail();">
            <span class="k-icon k-i-preview"></span>查看
        </a>
    <a role="button" class="k-button k-button-icontext"
       href="javascript:toPrint();">
        <span class="k-icon k-i-preview"></span>打印
    </a>
    <%--</c:if>--%>
    <span style="color: red">注：审批后，启用"临时调价"后干预执行价，"永久调价"干预执行价和历史价</span>
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
<script id="formatterUse" type="text/x-uglcw-template">
    #if(data.isUse==0){#
    未启用
    #}else if(data.isUse==1){#
    已启用
    #}#
</script>
<script id="formatterType" type="text/x-uglcw-template">
    #if(data.type==0){#
    临时调价
    #}else if(data.type==1){#
    永久调价
    #}#
</script>
<script id="formatterSxdate" type="text/x-uglcw-template">
   #=data.sdate+"到"+data.edate#
</script>
<script id="formatterProName" type="text/x-uglcw-template">
    #if(data.proName==""){#
    所有客户
    #}else{#
    #=data.proName#
    #}#

</script>
<script id="bill-no" type="text/x-uglcw-template">
    <a href="javascript:showDetail(#= data.id#,#= data.type#);" style="color: \\#337ab7;font-size: 13px; font-weight: bold;">#=
        data.billNo#</a>
</script>

<script id="opt-tpl" type="text-x-uglcw-template">
    <%--<button class="k-button k-success" style="width: 45px" onclick="toPrint(#=data.id#)"><i class="k-icon"></i>打印--%>
    <%--</button>--%>
    # if(data.status == -2) {#
    <br/>
    <button class="k-button k-info" style="width: 30px" onclick="auditBill(#=data.id#)"><i
            class="k-icon"></i>审批
    </button>
    # } #

   #if(data.status == 1&&data.isUse==0&&data.type==0) {#
    <br/>
    <button class="k-button k-info" style="width: 30px" onclick="useBill(#=data.id#,1)"><i
            class="k-icon"></i>启用
    </button>
    # } #
    #if(data.status == 1&&data.isUse==1&data.type==0) {#
    <br/>
    <button class="k-button k-info" style="width: 30px" onclick="useBill(#=data.id#,0)"><i
            class="k-icon"></i>禁用
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
            <td style="width: 60px;">执行价</td>
            <td style="width: 60px;">提价</td>
            <td style="width: 60px;">最新销售价</td>
        </tr>
        #for (var i=0; i< data.length; i++) { #
        <tr>
            <td>#= data[i].wareNm #</td>
            <td>#= data[i].unitName #</td>
            <td>#= data[i].wareGg #</td>
            <td>#= data[i].zxPrice==undefined?0:data[i].zxPrice #</td>
            <td>#= data[i].disPrice==undefined?0:data[i].disPrice #</td>
            <td>#= data[i].price==undefined?0:data[i].price #</td>
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
        uglcw.ui.openTab('客户商品临时调价单', '${base}manager/stkAdjustPrice/add');
    }
    function addEven() {
        uglcw.ui.openTab('客户商品永久调价单', '${base}manager/stkAdjustPrice/addEven');
    }

    function showDetail(id,type) {
        var title ="客户商品临时调价单";
        if (id) {
            if(type==1){
                title="客户商品永久调价单";
            }
            uglcw.ui.openTab(title + id, '${base}manager/stkAdjustPrice/show?billId=' + id);
        } else {
            var selection = uglcw.ui.get('#grid').selectedRow();
            if (selection) {
                var id = selection[0].id;
                if(selection[0].type==1){
                    title="客户商品永久调价单";
                }
                uglcw.ui.openTab(title + id, '${base}manager/stkAdjustPrice/show?billId=' + id);
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
            url: '${base}manager/stkAdjustPrice/sycState',
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
            url: '${base}manager/stkAdjustPrice/sycZxState',
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
                url: '${base}manager/stkAdjustPrice/audit',
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

    function useBill(billId,isUse) {
        var msg = "启用";
        if(isUse==0){
            msg = "禁用";
        }
        uglcw.ui.confirm('是否确定'+msg+'？', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/stkAdjustPrice/updateUse',
                type: 'post',
                data: {billId: billId},
                dataType: 'json',
                success: function (response) {
                    uglcw.ui.loaded();
                    if (response.state) {
                        uglcw.ui.success(response.msg);
                    } else {
                        uglcw.ui.warning(response.msg || '操作失败');
                    }
                    uglcw.ui.get('#grid').reload();
                }
            })
        })
    }

    function toPrint(billId) {
        var title="打印客户商品临时调价单";
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            var id = selection[0].id;
            if(selection[0].type==1){
                title="客户商品永久调价单";
            }
            uglcw.ui.openTab(title + id, '${base}manager/stkAdjustPrice/print?billId=' + id);
        } else {
            uglcw.ui.warning('请选择单据');
        }
    }


</script>
</body>
</html>
