<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="tag" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html>
<head>
    <title>固定费用投入-客户列表</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }

        .fixed-field {
            padding: 0 !important;
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
                    <input uglcw-model="keyword" id="khNm" uglcw-role="textbox" placeholder="客户名称">
                </li>
                <li>
                    <select uglcw-model="status" uglcw-role="combobox" placeholder="客户状态">
                        <option value="1" selected>启用</option>
                        <option value="2">禁用</option>
                        <option value="3">已生成费用</option>
                    </select>
                </li>
                <li>
                    <input id="month" uglcw-model="month" uglcw-role="datepicker" uglcw-options="start:'year',depth:'year', dateInput: false, format:'yyyyMM',
                      change:function(){uglcw.ui.get('#grid').reload();}
                    " placeholder="归属月份">
                </li>
                <li>
                    <input type="checkbox" uglcw-role="checkbox" uglcw-value="0" uglcw-model="allowEmptyMonth"
                           id="allowEmptyMonth" >
                    <label style="margin-top: 10px;" class="k-checkbox-label" for="allowEmptyMonth">过滤月份为空的数据</label>
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
            <div id="grid"  uglcw-role="grid-advanced" uglcw-options="
                responsive:['.header',40],
                criteria: '.uglcw-query',
                pageable: true,
                checkbox: true,
                rowNumber: true,
                editable: true,
                toolbar: uglcw.util.template($('#toolbar').html()),
                url: '${base}manager/fixedField/customer',
                aggregate:[
                    <c:forEach items="${fields}" var="field">
                     {field: 'field_${field.id}', aggregate: 'SUM'},
                        </c:forEach>
                ],
                loadFilter: {
                      data: function (response) {
                        if(response && response.code == 200){
                            return response.data.rows || [];
                        }
                        return []
                      },
                      total: function(response){
                        return response.data ? response.data.total : 0;
                      },
                      data: loadFilter,
                      aggregates: function (response) {
                        var aggregate = {
                                <c:forEach items="${fields}" var="field">
                                   field_${field.id}:0,
                                </c:forEach>
                            };
                        if(response.code == 200){
                            $(response.data.sysFixedCustomerPriceSumVos).each(function(i, item){
                                aggregate['field_'+ item.fixedId] = item.price
                            });
                        }
                        return aggregate;
                     }
                 }
            ">
                <div data-field="khNm" uglcw-options="width:200,footerTemplate: '合  计:'">客户名称</div>
                <div data-field="month" uglcw-options="width:160, template: function(data){
                    if(data.month){
                        return data.month.substring(0, 4)+'年'+data.month.substring(4, 6)+'月';
                    }else{
                        return '';
                    }
                }, editor: monthEditor">月份</div>
                <c:forEach items="${fields}" var="field">
                    <div data-field="${field.name}" uglcw-options="
                        width:140,
                        attributes:{'class': 'fixed-field'},
                        template:function(row){
                            row.fixedId = '${field.id}';
                            return uglcw.util.template($('#price').html())({data: row});
                        },
                        footerTemplate: '#= data.field_${field.id} || 0#',
                        headerTemplate: '<span onclick=\'javascript:operatePrice(${field.id});\'>${field.name}✎</span>'
                    ">${field.name}</div>
                </c:forEach>
                </div>

            </div>
        </div>
    </div>
    <ul id="grid-menu"></ul>
</div>
<script type="text/x-uglcw-template" id="toolbar">
    <a role="button" href="javascript:popCustomer();" class="k-button k-button-icontext k-grid-add-purchase">
        <span class="k-icon k-i-add"></span>添加客户
    </a>
    <a role="button" class="k-button k-button-icontext" href="javascript:del();">
        <span class="k-icon k-i-trash"></span>删除
    </a>
    <a role="button" href="javascript:updateCustomerStatus(1);" class="k-button k-button-icontext">
        <span class="k-icon k-i-checkmark"></span>启用</a>
    <a role="button" href="javascript:updateCustomerStatus(2);" class="k-button k-button-icontext">
        <span class="k-icon k-i-cancel"></span>禁用</a>

    <a role="button" href="javascript:createFixedFee();" class="k-button k-button-icontext">
        <span class="k-icon k-i-info"></span>生成固定费用单
    </a>
</script>
<script type="text/x-uglcw-template" id="price">
    <input type="hidden" id="fixed_price_id_#= data.fixedId#">
    <input style="display:none;" class="k-textbox input_fixed_#= data.fixedId#"
           id="fixed_price_#= data.id#_#= data.fixedId#" value="#= data['price_'+data.fixedId] || ''#"
           uglcw-role="numeric" name="fixedPrice" size="7"
           onchange="changeFixedPrice(#=data['id_'+data.fixedId]#, #=data.fixedId#, #= data.id#, this)"/>
    <span class="fixed_#= data.fixedId#_span" id="fixed_span_#= data.id#_#= data.fixedId#">#= data['price_'+data.fixedId] || ''#</span>
</script>

<script type="text/x-uglcw-template" id="customer_type">
    <input placeholder="请输入关键字" uglcw-role="textbox" uglcw-model="khNm">
    <tag:select2 placeholder="客户类型" id="qdtypeId" name="qdtypeId" headerKey="" headerValue=""
                 displayKey="id" displayValue="qdtp_nm" tableName="sys_qdtype"> </tag:select2>

</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        //ui:初始化
        uglcw.ui.init();
        //查询
        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        })


        //重置
        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal');
            uglcw.ui.get('#grid').reload();
        })

        uglcw.ui.get('#grid').k().dataSource.bind('change', function (e) {
            var action = e.action;
            if (action === 'itemchange') {
                if (e.field === 'month') {

                }
            }
        });
        initContextMenu();
        uglcw.ui.loaded();
    })

    function initContextMenu(){
        $('#grid-menu').kendoContextMenu({
            filter: ".k-grid-content td",
            target: '#grid',
            hideOnClick: true,
            dataSource: [
                {
                    text: '复制',
                    attr: {
                        action: 'copy'
                    }
                }
            ],
            select: function (e) {
                var grid = uglcw.ui.get('#grid');
                var target = $(e.target), row = target.closest('tr');
                var action = $(e.item).attr("action");
                switch (action) {
                    case 'copy':
                        var rowData = grid.k().dataItem($(row));
                        addCustomer([rowData.id]);
                        break;
                    default:
                        break;
                }
            }
        })
    }

    function monthEditor(container, options) {
        var model = options.model;
        var input = $('<input >');
        input.appendTo(container);
        var widget = new uglcw.ui.DatePicker(input);
        widget.init({
            start: 'year',
            depth: 'year',
            format: 'yyyyMM',
            dateInput: true,
            value: model.month || '',
            change: function () {
                var month = uglcw.util.toString(this.value(), 'yyyyMM');
                $.ajax({
                    url: '${base}manager/fixedField/updateMonth',
                    data:{
                        customerId: model.id,
                        month: month,
                        old: model.month
                    },
                    type: 'post',
                    success: function(response){
                        if(response.code === 200){
                            model.set('month', month);
                            uglcw.ui.success('设置成功');
                        }else{
                            uglcw.ui.error(response.message);
                        }
                    }
                })
            }
        })
    }

    function loadFilter(response) {
        var rows = response.data.rows || [];
        var customerIds = $.map(rows, function (row) {
            return row.id
        })
        if (customerIds.length > 0) {
            $.ajax({
                async: false, //同步
                url: '${base}manager/fixedField/customer/price',
                type: 'post',
                contentType: 'application/json',
                data: JSON.stringify(customerIds),
                success: function (res) {
                    if (res.code == 200) {
                        $(res.data).each(function (i, item) {
                            $(rows).each(function (j, row) {
                                if (item.customerId == row.id && item.month == row.month) {
                                    row['price_' + item.fixedId] = item.price
                                    row['id_' + item.fixedId] = item.id;
                                    row.status = item.status;
                                }
                            })
                        })
                    }
                }
            })
        }

        return rows
    }

    function changeFixedPrice(id, fixedId, customerId, el) {
        var row = uglcw.ui.get('#grid').k().dataItem($(el).closest('tr'));
        var fixedPrice = $(el).val();
        if (isNaN(fixedPrice)) {
            uglcw.ui.toast("请输入数字");
            return;
        }
        $.ajax({
            url: "${base}manager/fixedField/updateFixedCustomerPrice",
            type: "post",
            data: {
                id: id,
                price: fixedPrice,
                fixedId: fixedId,
                customerId: customerId,
                month: row.month || ''
            },
            success: function (data) {
                if (data != '0') {
                    $(el).closest('td').find('span').text(fixedPrice);
                } else {
                    uglcw.ui.error("保存失败");
                }
            }
        });
    }

    function operatePrice(field) {
        $('.input_fixed_' + field).toggle();
        $('.fixed_' + field + '_span').toggle();
    }


    function popCustomer() {
        uglcw.ui.Modal.showGridSelector({
            closable: false,
            title: false,
            url: '${base}manager/fixedField/queryNoneCustomerPrice',
            loadFilter: {
                data: function (response) {
                    return response.data.rows || [];
                },
                total: function (response) {
                    return response.data.total;
                }
            },
            checkbox: true,
            width: 700,
            height: 400,
            criteria: $('#customer_type').html(),
            columns: [
                {
                    field: 'khNm', title: '客户名称', width: 'auto',
                    headerAttributes: {'style': 'text-align: center'},
                    attributes: {'style': 'text-align: center'},
                },
            ],
            yes: function (nodes) {
                if (nodes && nodes.length > 0) {
                    var ids = $.map(nodes, function (node) {
                        return node.id;
                    });
                    addCustomer(ids);
                }

            }
        })
    }


    function addCustomer(ids) {
        $.ajax({
            url: "${base}/manager/fixedField/addCustomerPrice",
            data: JSON.stringify(ids),
            type: "post",
            contentType: "application/json",
            success: function (json) {
                if (json != "-1") {
                    uglcw.ui.success('添加成功');
                    uglcw.ui.get('#grid').reload();
                } else {
                    uglcw.ui.error('操作失败');
                }
            }
        });
        //});
    }

    function del() {
        var selection = uglcw.ui.get('#grid').selectedRow();
            if(selection){
                $.ajax({
                    url: "${base}/manager/fixedField/deleteByCustomerId",
                    data: {id:selection[0].id,month:(selection[0].month ||'')},
                    type: "post",
                    success: function (json) {
                        if (json != "-1") {
                            uglcw.ui.success('删除成功！');
                            uglcw.ui.get('#grid').reload();
                        } else {
                            uglcw.ui.error('操作失败');
                        }
                    }
                });
            }else {
                uglcw.ui.warning('请选择要修改的行！');
            }
    }

    function updateCustomerStatus(state) {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if(selection){
            $.ajax({
                url: '${base}manager/fixedField/updateCustomerStatus',
                type: 'post',
                data: {id:selection[0].id,month:(selection[0].month ||''), status: state},
                success: function (response) {
                    if (response.code == 200) {
                        uglcw.ui.get('#grid').reload();
                    } else {
                        uglcw.ui.error(response.message || '操作失败');
                        return;
                    }

                }
            })
        }else {
            uglcw.ui.warning('请选择要修改的行！');
        }

    }

    function createFixedFee() {//生成固定费用单
        var selection = uglcw.ui.get('#grid').selectedRow();
        var customerIds = $.map(selection, function (row) {   return row.id}).join(',');
        var query = uglcw.ui.bind('.uglcw-query');
        if(query.month==""||query.month==null){
          return uglcw.ui.info("请选择归属日期!");
        }
        query.customerIds=customerIds;
        uglcw.ui.confirm('是否确定生成固定费用单，若未选中，将全部生成？', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/stkCustomerFixedCalculate/create',
                type: 'post',
                data: query,
                dataType: 'json',
                success: function (response) {
                    uglcw.ui.loaded();
                    if (response.state) {
                        uglcw.ui.success("固定费用生成成功!");
                        uglcw.ui.get('#grid').reload({stay: true});
                    } else {
                        uglcw.ui.error('固定费用生成失败！');
                    }
                }
            })
        })
    }

</script>
</body>
</html>
