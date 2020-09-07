<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>门店会员类型设置</title>
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
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal query">
                <li>
                    <input uglcw-model="typeName" uglcw-role="textbox" placeholder="会员类型名称">
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="status" placeholder="状态">
                        <option value="1" selected>正常</option>
                        <option value="2">已禁用</option>
                    </select>
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
					    toolbar: kendo.template($('#toolbar').html()),
						id:'id',
						checkbox:true,
						pageable: true,
                  		url: '${base}manager/pos/queryMemberType',
                  		criteria: '.query',
                  	">
                  <div data-field="typeName" uglcw-options="width:100">会员类型名称</div>
                  <div data-field="cost" uglcw-options="width:100">工本费</div>
                  <div data-field="inputCash" uglcw-options="width:100">充值金额</div>
                  <div data-field="freeCost" uglcw-options="width:110">赠送金额</div>
                  <div data-field="cardDate" uglcw-options="width:200">有效期</div>
              </div>
        </div>
   </div>
</div>
<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:add();" class="k-button k-button-icontext">
        <span class="k-icon k-i-plus-outline"></span>添加
    </a>
    <a role="button" href="javascript:update();" class="k-button k-button-icontext">
        <span class="k-icon k-i-edit"></span>修改
    </a>
 <%--   <a role="button" href="javascript:del();" class="k-button k-button-icontext">
        <span class="k-icon k-i-delete"></span>删除
    </a>--%>
    <a role="button" href="javascript:updateMemberTypeStatus(1);" class="k-button k-button-icontext">
        <span class="k-icon k-i-checkmark"></span>启用</a>
    <a role="button" href="javascript:updateMemberTypeStatus(2);" class="k-button k-button-icontext">
        <span class="k-icon k-i-cancel"></span>移除</a>
</script>


<%--添加或修改--%>
<script type="text/x-uglcw-template" id="form">
    <div class="layui-card">
        <div class="layui-card-body">
            <form class="form-horizontal" uglcw-role="validator">
                <div class="form-group">
                    <input uglcw-role="textbox" uglcw-model="id" type="hidden">
                    <input uglcw-role="textbox" uglcw-model="status" type="hidden">
                    <label class="control-label col-xs-6">*类型名称</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="typeName" uglcw-role="textbox" uglcw-validate="required" >
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">有效期</label>
                    <div class="col-xs-3">
                        <input uglcw-model="dayLong" uglcw-role="textbox" style="width: 50px;">
                    </div>
                    <div class="col-xs-8">
                        <select uglcw-role="combobox" uglcw-model="dateUnit" style="width: 150px;">
                            <option value="0">无限期</option>
                            <option value="1">天</option>
                            <option value="2">周</option>
                            <option value="3">月</option>
                            <option value="4">年</option>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">前缀</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="prefix" uglcw-role="textbox" >
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">工本费</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="cost" uglcw-role="textbox" >
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">底金</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="inputCash" uglcw-role="textbox" >
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">赠送金额</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="freeCost" uglcw-role="textbox" >
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">折扣</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="discount" uglcw-role="textbox" >
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">有效期类型</label>
                    <div class="col-xs-16">
                        <select uglcw-role="combobox" uglcw-model="dateType" style="width: 200px;">
                            <option value="0">超期无法消费</option>
                            <option value="1">超期无法打折</option>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">卡介质</label>
                    <div class="col-xs-16">
                        <select uglcw-role="combobox" uglcw-model="icType" style="width: 200px;">
                            <option value="0">磁卡</option>
                            <option value="1">IC卡</option>
                            <option value="2">M1卡</option>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">店员发行</label>
                    <div class="col-xs-16">
                        <select uglcw-role="combobox" uglcw-model="newCard" style="width: 200px;">
                            <option value="0">店员可以发行</option>
                            <option value="1">店员不可发行</option>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">修改金额</label>
                    <div class="col-xs-16">
                        <select uglcw-role="combobox" uglcw-model="modifyAmt" style="width: 200px;">
                            <option value="0">充值金额可修改</option>
                            <option value="1">充值金额不可修改</option>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">挂失</label>
                    <div class="col-xs-16">
                        <select uglcw-role="combobox" uglcw-model="hanged" style="width: 200px;">
                            <option value="0">可挂失</option>
                            <option value="1">不可挂失</option>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">卡通用</label>
                    <div class="col-xs-16">
                        <select uglcw-role="combobox" uglcw-model="shopShare" style="width: 200px;">
                            <option value="0">通用</option>
                            <option value="1">连锁店</option>
                            <option value="2">加盟店</option>
                        </select>
                    </div>
                </div>
>
            </form>
        </div>
    </div>
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        //ui:初始化
        uglcw.ui.init();
        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        });

        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.query');
        });
        uglcw.ui.loaded();
        resize();
        $(window).resize(resize);

    })

    var delay;
    function resize() {
        if (delay) {
            clearTimeout(delay);
        }
        delay = setTimeout(function () {
            var grid = uglcw.ui.get('#grid').k();
            var padding = 15;
            var height = $(window).height() - padding - $('.header').height() - 40;
            grid.setOptions({
                height: height,
                autoBind: true
            })
        }, 200)
    }

    //-----------------------------------------------------------------------------------------

    //添加
    function add(){
        edit()
    }
    //修改
    function update(){
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            edit(selection[0]);
        }else{
            uglcw.ui.toast("请勾选你要操作的行！")
        }
    }

    //删除
/*    function del() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            uglcw.ui.confirm("确定删除所选记录吗？", function () {
                $.ajax({
                    url:"${base}manager/pos/deleteMemberType",
                    data: {
                        id:selection[0].id,
                    },
                    type: 'post',
                    dataType: 'json',
                    success: function (response) {
                        if(response == 1){
                            uglcw.ui.success("删除成功");
                            uglcw.ui.get('#grid').reload();
                        }else if(response == 0){
                            uglcw.ui.toast("已使用不能删除");
                        }else{
                            uglcw.ui.error("删除失败");
                        }
                    }
                });
            })
        }else{
            uglcw.ui.toast("请勾选你要操作的行！")
        }
    }*/

    //添加或修改
    function edit(row) {
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
                var data = uglcw.ui.bind($(container).find('form'));
                uglcw.ui.loading();
                $.ajax({
                    url: '${base}manager/pos/saveMemberType',
                    type: 'post',
                    data: data,
                    async: false,
                    success: function (resp) {
                        uglcw.ui.loaded();
                        if(resp == 1){
                            uglcw.ui.success('保存成功');
                            uglcw.ui.get('#grid').reload();
                            uglcw.ui.Modal.close();
                        }else{
                            uglcw.ui.error('操作失败');
                        }
                        // if (resp === '1') {
                        // 	uglcw.ui.success('添加成功');
                        // 	uglcw.ui.get('#grid').reload();
                        // 	uglcw.ui.Modal.close();
                        // } else if (resp === '2') {
                        // 	uglcw.ui.success('修改成功');
                        // 	uglcw.ui.get('#grid').reload();
                        // 	uglcw.ui.Modal.close();
                        // } else if (resp === '3') {
                        // 	uglcw.ui.error('会员等级名称已存在');
                        // } else {
                        // 	uglcw.ui.error('操作失败');
                        // }
                    }
                })
                return false;
            }
        })
    }

    function updateMemberTypeStatus(status) {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if(selection){
            $.ajax({
                url: '${base}manager/pos/updateMemberTypeStatus',
                type: 'post',
                data: {id:selection[0].id , status: status},
                async: false,
                success: function (data) {
                    if (data == '1') {
                        uglcw.ui.success('操作成功');
                        uglcw.ui.get('#grid').reload();
                    } else if(data == '2'){
                        uglcw.ui.error('已是当前状态不能重复操作');
                    }  else{
                        uglcw.ui.error('操作失败');
                        return;
                    }
                }
            })
        }else {
            uglcw.ui.warning('请选择要修改的行！');
        }
    }
</script>
</body>
</html>
