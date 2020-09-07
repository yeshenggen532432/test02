<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>驰用T3</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-card">
        <div class="layui-card header">
            <div class="layui-card-body">
                <ul class="uglcw-query form-horizontal query">
                    <li>
                        <input uglcw-model="qdtpNm" uglcw-role="textbox" placeholder="客户类型名称">
                    </li>
                    <li>
                        <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                        <button id="reset" class="k-button" uglcw-role="button">重置</button>
                    </li>
                </ul>
            </div>
        </div>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options="{
                    responsive:['.header',40],
                    toolbar: kendo.template($('#toolbar').html()),
                    id:'id',
                    url: '${base}/manager/toQdtypePage',
                    criteria: '.query',
                    pageable: true,

                    }">

                <div data-field="coding" uglcw-options="width:200">编码</div>
                <div data-field="qdtpNm" uglcw-options="width:200">客户类型名称</div>
                <div data-field="rate" uglcw-options="
								width:120,
								headerTemplate: uglcw.util.template($('#header_rate').html()),
								template:function(row){
									return uglcw.util.template($('#rate_tmplate').html())({val:row.rate, data: row, field:'rate'})
								}
								">销售折扣率(%)</div>

                <div data-field="hy_oper"
                     uglcw-options="width:300, template: uglcw.util.template($('#kh_oper').html())">客户类型相关操作
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:toaddQdtype();" class="k-button k-button-icontext">
        <span class="k-icon k-i-plus"></span>添加
    </a>
    <a role="button" class="k-button k-button-icontext"
       href="javascript:getSelected();">
        <span class="k-icon k-i-pencil"></span>修改
    </a>
    <a role="button" href="javascript:toDel();" class="k-button k-button-icontext k-grid-add-other">
        <span class="k-icon k-i-delete"></span>删除</a>
</script>
<%--客户相关操作--%>
<script id="kh_oper" type="text/x-uglcw-template">
    <button onclick="javascript:addCustomer(#= data.id#);" class="k-button k-info">添加</button>
    <button onclick="javascript:delCustomer(#= data.id #);" class="k-button k-info">移除</button>
    <button onclick="javascript:queryCustomer(#=data.id#);" class="k-button k-info">
        查看
    </button>
</script>
<script id="t" type="text/uglcw-template">
    <div class="layui-card">
        <div class="layui-card-body">
            <div class="form-horizontal" uglcw-role="validator" id="bind">
                <div class="form-group">
                    <input type="hidden" uglcw-role="textbox" uglcw-model="id" id="id">
                    <label class="control-label col-xs-8">编码</label>
                    <div class="col-xs-14">
                        <input class="form-control" uglcw-role="textbox" uglcw-model="coding" id="coding"
                               uglcw-validate="required">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">客户类型名称</label>
                    <div class="col-xs-14">
                        <input class="form-control" uglcw-role="textbox" uglcw-model="qdtpNm" id="qdtpNm2"
                               uglcw-validate="required">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">销售折扣率</label>
                    <div class="col-xs-14">
                        <input class="form-control"
                               uglcw-role="numeric"
                               uglcw-options="min:0, max: 1000"
                               uglcw-model="rate" id="rate">
                    </div>
                </div>
            </div>
        </div>
    </div>
</script>
<script id="header_rate" type="text/x-uglcw-template">
    <span onclick="javascript:operate('rate');">销售折扣率%✎</span>
</script>
<script id="rate_tmplate" type="text/x-uglcw-template">
    # if(val == null || val == undefined || val === '' || val== "undefined"){ #
    #    val = "" #
    # } #
    <div style="display: inline-flex">
        <div style="display: none">
            <input class="#=field#_input" id="#=field#_input_#= data.id #" name="#=field#_input" uglcw-role="numeric"
                   uglcw-options="min:0, max: 1000" style="height:25px;width: 60px"
                   onchange="changeRate(this,'#= field #',#= data.id #)" value='#= val #'>
        </div>
        <span class="#=field#_span" id="#=field#_span_#= data.id #">#= val #</span>
        <span class="#=field#_org_rate" id="#=field#_org" style='color:green'></span>
    </div>
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();

        uglcw.ui.get('#search').on('click', function () {   //搜索（查询）
            uglcw.ui.get('#grid').k().dataSource.read();
        })

        uglcw.ui.get('#reset').on('click', function () {    //重置（清除搜索输入框数据）
            uglcw.ui.clear('.form-horizontal');
        })

        uglcw.ui.loaded()
    })

    function toaddQdtype() {//添加
        uglcw.ui.Modal.open({  //弹框当前页面div
            area: '500px',
            content: $('#t').html(),
            success: function (container) {
                uglcw.ui.init($(container)); //初始化页面
            },
            yes: function (container) {
                var valid = uglcw.ui.get($(container).find('.form-horizontal')).validate();
                if (valid) {
                    $.ajax({
                        url: '${base}/manager/operQdtype',
                        type: 'post',
                        data: uglcw.ui.bind(container),
                        success: function (data) {
                            if (data == "1" || data == "2") {
                                uglcw.ui.get('#grid').reload();//刷新页面数据
                            } else {
                                uglcw.ui.error('失败');//错误提示
                                return;
                            }
                        }
                    })
                } else {
                    uglcw.ui.error('失败');
                    return false;
                }

            }
        });
    }

    //获取选中行的值
    function getSelected() {
        var selection = uglcw.ui.get('#grid').selectedRow();//选中当前行数据
        if (selection) {
            uglcw.ui.Modal.open({  //弹框当前页面div
                area: '500px',
                content: $('#t').html(),
                success: function (container) {
                    uglcw.ui.init($(container)); //初始化页面
                    uglcw.ui.bind($(container).find('#bind'), selection[0]);//绑定数据
                },
                yes: function (container) {
                    var valid = uglcw.ui.get($(container).find('.form-horizontal')).validate();
                    if (valid) {
                        $.ajax({
                            url: '${base}/manager/operQdtype',
                            type: 'post',
                            data: uglcw.ui.bind(container),
                            success: function (data) {
                                if (data == "1" || data == "2") {
                                    uglcw.ui.get('#grid').reload();//刷新页面数据
                                } else {
                                    uglcw.ui.error('失败');//错误提示
                                    return;
                                }
                            }
                        })
                    } else {
                        uglcw.ui.error('失败');
                        return false;
                    }

                }
            });
        } else {
            uglcw.ui.warning('请选择要修改的行！');
        }
    }

    function toDel() {   //删除
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) { //判断是否为空
            uglcw.ui.confirm('是否要删除选中的客户类型?', function () {
                $.ajax({
                    url: '${base}/manager/deleteQdtypeById',
                    data: {
                        id: selection[0].id
                    },
                    type: 'post',
                    dataType: 'json',
                    success: function (json) {
                        if (json) {
                            if (json == '1') {
                                uglcw.ui.success('删除成功');
                                uglcw.ui.get('#grid').reload();//刷新页面数据
                            }else if (json == '2'){
                                uglcw.ui.error('客户类型内有归属客户不能删除');
                            }  else {
                                uglcw.ui.error('删除失败');//错误提示
                            }
                        } else {
                            uglcw.ui.error(response.msg);//错误提示
                        }
                    }
                })
            })
        } else {
            uglcw.ui.warning('请选择要删除的行！');
        }
    }
    //添加客户
    function addCustomer(id) {
        uglcw.ui.Modal.showGridSelector({
            closable: false,
            title: false,
            url: '${base}manager/queryNoneTypedCustomer',
             query: function (params) {
                params.isDb = 2;
            },
            checkbox: true,
            width: 700,
            height: 400,
            criteria: '<input placeholder="请输入关键字" uglcw-role="textbox" uglcw-model="khNm">'+
                        '<input placeholder="请输入业务员名称" uglcw-role="textbox" uglcw-model="memberNm">',
            columns: [
                {field: 'khNm', title: '客户名称', width: 160, tooltip: true},
                {field: 'mobile', title: '客户手机', width: 120},
                {field: 'address', title: '客户地址', width: 220, tooltip: true},
                {field: 'khCode', title: '客户编码', width: 100},
                {field: 'memberNm', title: '业务员', width: 160},
            ],
            yes: function (nodes) {
                if(nodes && nodes.length>0){
                    var ids = $.map(nodes, function (node) {
                        return node.id;
                    });
                    callBackFunQueryNoneTypedCustomer(ids, id);
                };

            }
        })
    }
    //移除客户
    function delCustomer(id) {
        uglcw.ui.Modal.showGridSelector({
            closable: false,
            title: false,
            url: '${base}manager/queryCustomerByQdtypeId?id=' + id,
            query: function (params) {
                params.isDb = 2;
            },
            checkbox: true,
            width: 650,
            height: 400,
            criteria: '<input placeholder="请输入关键字" uglcw-role="textbox" uglcw-model="khNm">',
            columns: [
                {field: 'khNm', title: '客户名称', width: 160, tooltip: true},
                {field: 'mobile', title: '客户手机', width: 120},
                {field: 'address', title: '客户地址', width: 220, tooltip: true},
                {field: 'khCode', title: '客户编码', width: 160},
            ],
            yes: function (nodes) {
                if(nodes && nodes.length>0){
                    var ids = $.map(nodes, function (node) {
                        return node.id;
                    });
                    callBackFunQueryCustomerByQdtypeId(ids);
                }

            }
        })
    }

    //查询客户
    function queryCustomer(id) {
        uglcw.ui.Modal.showGridSelector({
            btns:[],
            closable: true,
            title: false,
            url: '${base}manager/queryCustomerByQdtypeId?id=' + id,
            query: function (params) {
                params.isDb = 2;
            },
            checkbox: true,
            width: 650,
            height: 400,
            criteria: '<input placeholder="请输入关键字" uglcw-role="textbox" uglcw-model="khNm">',
            columns: [
                {field: 'khNm', title: '客户名称', width: 160, tooltip: true},
                {field: 'mobile', title: '客户手机', width: 120},
                {field: 'address', title: '客户地址', width: 220, tooltip: true},
                {field: 'khCode', title: '客户编码', width: 160},
            ],
        })
    }

    //添加客户的回调
    function callBackFunQueryNoneTypedCustomer(ids,id) {
        $.ajax({
            url: "${base}manager/batchUAddCustomer",
            data: { ids:ids.join(','),
                id:id},
            type: "post",
            success: function (json) {
                if (json != "-1") {
                    uglcw.ui.success('添加成功');
                } else {
                    uglcw.ui.error('操作失败');
                }
            }
        });
    }
    //移除客户的回调
    function callBackFunQueryCustomerByQdtypeId(ids) {
        $.ajax({
            url: "${base}manager/batchRemoveCustomerType",
            data: { ids:ids.join(',')},
            type: "post",
            success: function (json) {
                if (json != "-1") {
                    uglcw.ui.success('移除成功');
                } else {
                    uglcw.ui.error('操作失败');
                }
            }
        });
    }


    function changeRate(o, field,id) {
        if (isNaN(o.value)) {
            uglcw.ui.toast("请输入数字")
            return;
        }
        $.ajax({
            url: "${base}manager/updateQdTypeRate",
            type: "post",
            data: "id="+id+"&rate=" + o.value + "&field=" + field,
            success: function (data) {
                if (data == '1') {
                    uglcw.ui.info('更新成功!');
                    $("#" + field + "_span_"+id).text(o.value);
                } else {
                    uglcw.ui.toast("价格保存失败");
                }
            }
        });
    }

    function operate(field) {
        var display = $("." + field + "_input").closest("div").css('display');
        if (display == 'none') {
            $("." + field + "_input").closest("div").show();
            $("." + field + "_span").hide();
        } else {
            $("." + field + "_input").closest("div").hide();
            $("." + field + "_span").show();
        }
    }
</script>
</body>
</html>
