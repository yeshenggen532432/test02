<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>会员等级</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }

        .xxzf-more {
            font-size: 8px;
            color: red;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <%--2右边：表格start--%>
        <div class="layui-col-md12">
            <%--表格：头部start--%>
            <div class="layui-card header">
                <div class="layui-card-body">
                    <ul class="uglcw-query form-horizontal query">
                        <li>
                            <input uglcw-model="gradeName" uglcw-role="textbox" placeholder="等级名称">
                        </li>
                        <li>
                            <select uglcw-role="combobox" uglcw-model="status" placeholder="启用状态" uglcw-options="value:''">
                                <option value="-1">全部</option>
                                <option value="1" selected>已启用</option>
                                <option value="0">未启用</option>

                            </select>
                        </li>
                        <li>
                            <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                            <button id="reset" class="k-button" uglcw-role="button">重置</button>
                        </li>
                    </ul>
                </div>
            </div>
            <%--表格：头部end--%>

            <%--表格：start--%>
            <div class="layui-card">
                <div class="layui-card-body full">
                    <div id="grid" uglcw-role="grid"
                         uglcw-options="
                          responsive:['.header',40],
						    toolbar: kendo.template($('#toolbar').html()),
							id:'id',
							checkbox:true,
							pageable: true,
                    		url: '${base}manager/shopMemberGrade/page',
                    		criteria: '.query',
                    	">
                        <div data-field="gradeName" uglcw-options="width:100">等级名称</div>
                        <%--<div data-field="status" uglcw-options="width:100,template: uglcw.util.template($('#status').html())">状态</div>--%>
                        <div data-field="isXxzf"
                             uglcw-options="width:100, template: uglcw.util.template($('#isXxzf').html())">线下支付
                        </div>
                        <div data-field="isDef"
                             uglcw-options="width:100, template: '#=data.isDef==1?\'是\':\'否\'#'">默认等级
                        </div>
                        <div data-field="isJxc"
                             uglcw-options="width:150, template: uglcw.util.template($('#isJxc').html())">进销存客户使用
                        </div>
                        <div data-field="posId"
                             uglcw-options="width:100, template: uglcw.util.template($('#posId_templ').html())">是否门店等级
                        </div>
                        <div data-field="oper" uglcw-options="width:100, template: uglcw.util.template($('#oper').html())">
                            操作状态
                        </div>
                        <div data-field="hy_oper"
                             uglcw-options="width:300, template: uglcw.util.template($('#hy_oper').html())">会员相关操作
                        </div>
                        <div data-field="jg_oper"
                             uglcw-options="width:200, template: uglcw.util.template($('#jg_oper').html())">等级价格设置
                        </div>
                    </div>
                </div>
            </div>
            <%--表格：end--%>
        </div>
        <%--2右边：表格end--%>
    </div>
</div>
<%--等级价格设置--%>
<script id="jg_oper" type="text/x-uglcw-template">
    <button onclick="javascript:toSetPricePag(#= data.id#,'#=data.gradeName#');" class="k-button k-info">设置商品价格</button>
</script>

<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:add();" class="k-button k-button-icontext">
        <span class="k-icon k-i-plus-outline"></span>添加
    </a>
    <a role="button" href="javascript:update();" class="k-button k-button-icontext">
        <span class="k-icon k-i-edit"></span>修改
    </a>
    <a role="button" href="javascript:del();" class="k-button k-button-icontext">
        <span class="k-icon k-i-delete"></span>删除
    </a>
    <a role="button" href="javascript:setGradePrice();" class="k-button k-button-icontext">
        <span class="k-icon k-i-gear"></span>会员等级价格设置
    </a>
</script>
<%--&lt;%&ndash;启用状态&ndash;%&gt;--%>
<%--<script id="status" type="text/x-uglcw-template">--%>
<%--<span>#= data.status == '1' ? '已启用' : '未启用' #</span>--%>
<%--</script>--%>
<%--启用操作--%>
<script id="isXxzf" type="text/x-uglcw-template">
    # if(data.isXxzf === 0){ #
    不显示
    # }else if(1 === data.isXxzf){ #
    显示
    # } #
</script>
<script id="isJxc" type="text/x-uglcw-template">
    # if(data.isJxc == 1){ #
    是
    # } #
</script>
<script id="posId_templ" type="text/x-uglcw-template">
    # if(data.posId){ #
    是
    # } #
</script>
<%--启用操作--%>
<script id="oper" type="text/x-uglcw-template">
    # if(data.status == '1'){ #
    <button onclick="javascript:updateStatus(#= data.id#,0);" class="k-button k-info">启用</button>
    # }else if(data.status == '0'){ #
    <button onclick="javascript:updateStatus(#= data.id#,1);" class="k-button k-info">不启用</button>
    # }#
</script>
<%--会员相关操作--%>
<script id="hy_oper" type="text/x-uglcw-template">
    <button onclick="javascript:addMember(#= data.id#,#= data.isJxc #);" class="k-button k-info">添加会员</button>
    <button onclick="javascript:delMember(#= data.id#,#= data.isJxc #,1);" class="k-button k-info">移除会员</button>
    <button onclick="javascript:delMember(#= data.id#,#= data.isJxc #);" class="k-button k-info">
        查看会员
    </button>
</script>
<%--添加或修改--%>
<script type="text/x-uglcw-template" id="form">
    <div class="layui-card">
        <div class="layui-card-body">
            <form class="form-horizontal" uglcw-role="validator">
                <div class="form-group">
                    <input uglcw-role="textbox" uglcw-model="id" type="hidden">
                    <label class="control-label col-xs-6">等级名称</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="gradeName" uglcw-role="textbox" uglcw-validate="required"
                               placeholder="请输入等级名称">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">等级级别</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="gradeNo" uglcw-role="numeric" uglcw-validate="number"
                               placeholder="请输入(1`100之内的整数">
                    </div>
                </div>

                <div class="form-group">
                    <label class="control-label col-xs-6">进销存客户使用</label>
                    <div class="col-xs-16">
                        <ul uglcw-role="radio" uglcw-model="isJxc" id="isJxcId" onchange="chageIsJxc()"
                            uglcw-options='"layout":"horizontal","dataSource":[{"text":"不是","value":"0"},{"text":"是","value":"1"}]'></ul>
                        <span class="xxzf-more">该等级是否专属进销存客户使用</span>
                    </div>
                </div>
                <div class="form-group" id="isXxzfDiv">
                    <label class="control-label col-xs-6">线下支付</label>
                    <div class="col-xs-16">
                        <ul uglcw-role="radio" uglcw-model="isXxzf" id="isXxzfId"
                            uglcw-options='"layout":"horizontal","dataSource":[{"text":"不显示","value":"0"},{"text":"显示","value":"1"}]'></ul>
                        <span class="xxzf-more">会员下单选择支付方式是否显示或不显示“线下支付”</span>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">状态</label>
                    <div class="col-xs-16">
                        <ul uglcw-role="radio" uglcw-model="status"
                            uglcw-options='"layout":"horizontal","dataSource":[{"text":"启用","value":"1"},{"text":"禁用","value":"0"}]'></ul>
                        <span class="xxzf-more">禁用后该等级和等级价格不生效,原所属会员需重新分配等级、并设置等级价格</span>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">默认等级</label>
                    <div class="col-xs-16">
                        <ul uglcw-role="radio" uglcw-model="isDef"
                            uglcw-options='"layout":"horizontal","dataSource":[{"text":"否","value":"0"},{"text":"是","value":"1"}]'></ul>
                        <span class="xxzf-more">新会员注册时默等级(普通和进销存等级可各设置一个)</span>
                    </div>
                </div>
            </form>
        </div>
    </div>
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
            uglcw.ui.clear('.query');
            uglcw.ui.get('#grid').reload();
        })
        uglcw.ui.loaded();
    })


    function chageIsJxc() {
        var isJxc = uglcw.ui.get("#isJxcId").value();
        if (isJxc && isJxc != 1) {
            $('#isXxzfDiv').removeClass('hide');
        } else {
            $('#isXxzfDiv').addClass('hide');
        }
    }

    //-----------------------------------------------------------------------------------------
    //修改启用状态
    function updateStatus(id, status) {
        var str = status ? '启用' : '不启用' ;
        uglcw.ui.confirm("是否确定" + str + "操作?", function () {
            $.ajax({
                url: '${base}manager/shopMemberGrade/updateStatus',
                data: {
                    id: id,
                    status: status
                },
                type: 'post',
                dataType: 'json',
                success: function (response) {
                    if (response == "1") {
                        uglcw.ui.success("操作成功");
                        uglcw.ui.get('#grid').reload();
                    } else {
                        uglcw.ui.error("操作失败");
                    }
                }
            })
        })
    }

    //添加
    function add() {
        edit()
    }

    //修改
    function update() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            if (selection[0].name == '热销商品' || selection[0].name == '常售商品') {
                uglcw.ui.toast("热销商品、常售商品为系统默认，不允许操作!")
                return;
            }
            edit(selection[0]);
        } else {
            uglcw.ui.toast("请勾选你要操作的行！")
        }
    }

    //删除
    function del() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            uglcw.ui.confirm("确定删除所选记录吗？", function () {
                $.ajax({
                    url: "${base}manager/shopMemberGrade/delete",
                    data: {
                        id: selection[0].id,
                    },
                    type: 'post',
                    dataType: 'json',
                    success: function (response) {
                        if (response == "1") {
                            uglcw.ui.success("删除成功");
                            uglcw.ui.get('#grid').reload();
                        } else {
                            uglcw.ui.error("删除失败");
                        }
                    }
                });
            })
        } else {
            uglcw.ui.toast("请勾选你要操作的行！")
        }
    }

    //添加或修改
    function edit(row) {
        if (row && row.posId) {
            uglcw.ui.toast("门店等级不可修改，请在门店中修改")
            return;
        }
        uglcw.ui.Modal.open({
            content: $('#form').html(),
            success: function (container) {
                uglcw.ui.init($(container));
                if (row) {
                    uglcw.ui.bind($(container), row);
                }
            },
            yes: function (container) {
                var valid = uglcw.ui.get($(container).find('form')).validate();
                if (!valid) {
                    return false;
                }
                //如果进销存等级时删除线下支付，统一由用户控制
                var isJxc = uglcw.ui.get("#isJxcId").value();
                if (isJxc && isJxc == 1) {
                    uglcw.ui.get("#isXxzfId").value('');
                }
                var data = uglcw.ui.bind($(container).find('form'));
                uglcw.ui.loading();
                $.ajax({
                    url: '${base}manager/shopMemberGrade/update',
                    type: 'post',
                    data: data,
                    async: false,
                    success: function (resp) {
                        uglcw.ui.loaded();
                        if (resp.state) {
                            uglcw.ui.success(resp.message);
                            uglcw.ui.get('#grid').reload();
                            uglcw.ui.Modal.close();
                        } else {
                            uglcw.ui.error(resp.message);
                        }
                    }
                })
                return false;
            }
        })
    }

    //按会员等级设置商品价格
    function setGradePrice() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            var id = selection[0].id;
            var gradeName = selection[0].gradeName;
            //uglcw.ui.openTab(gradeName + '_商品价格','${base}manager/shopMemberGrade/gradePriceWaretype?gradeId=' + id);
            toSetPricePag(id, gradeName);
        } else {
            uglcw.ui.toast("请勾选你要操作的行！")
        }
    }

    //添加会员
    function addMember(gradeId, isJxc) {
        if (isJxc == undefined || isJxc == 'undefined') {
            isJxc = '';
        }
        var tip = isJxc == '1' ? '仅操作进销存客户会员,并关闭进销存价格关联' : '';
        uglcw.ui.Modal.showGridSelector({
            closable: false,
            title: false,
            url: '${base}manager/shopMember/dialogShopMemberPage2?gradeId=' + gradeId + '&isJxc=' + isJxc + '&type=1',
            query: function (params) {
                params.name = params.keyword;
            },
            checkbox: true,
            width: 650,
            height: 400,
            criteria: '<input placeholder="请输入关键字" uglcw-role="textbox" uglcw-model="keyword">',
            columns: [
                {field: 'name', title: '会员名称', width: 150},
                {field: 'mobile', title: '电话', width: 100},
                {field: 'gradeName', title: '会员等级', width: 160, tooltip: true},
                {field: 'customerName', title: '关联客户', width: 160},
            ],
            success: function (c) {
                $('<span style="color:red;">' + tip + '</span>').appendTo($(c).find('.criteria'))
            },
            yes: function (nodes) {
                var ids = nodes.map(function (node, index) {
                    return node.id;
                });
                callBackFunSelectMemeber(ids, gradeId, 1);
            }
        })
    }

    //删除会员
    function delMember(gradeId, isJxc, isDel) {
        if (isJxc == undefined || isJxc == 'undefined') {
            isJxc = '';
        }
        var bottons = [];
        var title = '查看会员';
        if (isDel) {
            bottons = undefined;
            title = '移除会员';
        }

        uglcw.ui.Modal.showGridSelector({
            closable: true,
            title: title,
            url: '${base}manager/shopMember/dialogShopMemberPage2?gradeId=' + gradeId + '&isJxc=' + isJxc + '&type=2',
            query: function (params) {
                params.name = params.keyword;
            },
            btns: bottons,
            checkbox: true,
            width: 650,
            height: 400,
            criteria: '<input placeholder="请输入关键字" uglcw-role="textbox" uglcw-model="keyword">',
            columns: [
                {field: 'name', title: '会员名称', width: 150},
                {field: 'mobile', title: '电话', width: 100},
                {field: 'gradeName', title: '会员等级', width: 160, tooltip: true},
                {field: 'customerName', title: '关联客户', width: 160},
            ],
            yes: function (nodes) {
                if (isDel) {
                    var ids = nodes.map(function (node, index) {
                        return node.id;
                    });
                    callBackFunSelectMemeber(ids, '', 2);
                }
            }
        })

    }


    //选择会员-回调
    function callBackFunSelectMemeber(ids, gradeId, type) {
        $.ajax({
            url: "${base}manager/shopMember/batchUpdateShopMemberGrade",
            data: "ids=" + ids + "&gradeId=" + gradeId,
            type: "post",
            success: function (json) {
                if (json != "-1") {
                    uglcw.ui.get($('.uglcw-selector-container .uglcw-grid')).reload();
                    if (type == '1') {
                        uglcw.ui.success('添加成功');
                    } else {
                        uglcw.ui.success('移除成功');
                    }
                } else {
                    uglcw.ui.error('操作失败');
                }
            }
        });
    }

    //设置商品价格
    function toSetPricePag(id, gradeName) {
        uglcw.ui.openTab(gradeName+"_等级价格设置", "${base}manager/shopMemberGrade/gradePriceWaretype?_sticky=v2&gradeId=" + id);
    }


</script>
</body>
</html>
