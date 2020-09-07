<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>微店列表</title>
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
    <div class="layui-row layui-col-space15">

        <div class="layui-card">
            <div class="layui-card-body full">
                <div class="form-horizontal query" style="display: none">
                    <div class="form-group">
                        <div class="col-xs-4">
                            <input uglcw-model="mobile" uglcw-role="textbox" placeholder="手机号">
                        </div>
                        <div class="col-xs-4">
                            <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                            <button id="reset" class="k-button" uglcw-role="button">重置</button>
                        </div>
                    </div>
                </div>
                <div id="grid" uglcw-role="grid"
                     uglcw-options="
                             toolbar: kendo.template($('#toolbar').html()),
							id:'id',
							checkbox:true,
							pageable: true,
                    		url: '${base}manager/shopMicroInfo/page',
                    		criteria: '.query',
                    	">
                    <div data-field="name" uglcw-options="width:150">
                        店铺名称
                    </div>
                    <div data-field="linkman" uglcw-options="width:150">联系人</div>
                    <div data-field="mobile" uglcw-options="width:120">手机号</div>
                    <div data-field="areaInfo" uglcw-options="width:300">地址</div>
                    <div data-field="address" uglcw-options="width:300">地址详情</div>
                    <div data-field="createTime" uglcw-options="width:150">创建时间</div>
                    <div data-field="opt" uglcw-options="width:200,template: uglcw.util.template($('#opt-tpl').html())">
                        操作
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</div>

<script type="text/x-uglcw-template" id="toolbar">
    <a role="button" href="javascript:shopEditForm({});" class="k-button k-button-icontext">
        <span class="k-icon k-i-plus-outline"></span>添加
    </a>
</script>
<script type="text/x-uglcw-template" id="opt-tpl">
    <button class="k-button k-success" type="button" onclick="edit(#=data.id#)">编辑</button>
    <button class="k-button k-success" type="button" onclick="del(#=data.id#)">删除</button>
    <button class="k-button k-success" type="button" onclick="wareManager(#=data.id#,'#=data.name#')">商品管理</button>
</script>
<%--添加或修改--%>
<script type="text/x-uglcw-template" id="editForm_tpl">
    <div class="layui-card">
        <div class="layui-card-body">
            <form class="form-horizontal" uglcw-role="validator">
                <input uglcw-role="textbox" uglcw-model="id" type="hidden">
                <div class="form-group">
                    <label class="control-label col-xs-6">店铺名称</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="name" uglcw-role="textbox" uglcw-validate="required">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">联系人</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="linkman" uglcw-role="textbox" uglcw-validate="required">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">手机号</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="mobile" uglcw-role="textbox" uglcw-validate="required">
                    </div>
                </div>

                <div class="form-group" id="store_location">
                    <label class="control-label col-xs-6">选择地区</label>
                    <div class="col-xs-16">
                        <span id="provinceId"></span><span id="cityId"></span><span
                            id="areaId"></span>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">地址详情</label>
                    <div class="col-xs-16">
                        <input style="width: 200px;" uglcw-model="address" id="address" uglcw-role="textbox"
                               uglcw-validate="required">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">坐标</label>
                    <div class="col-xs-16">
                        <input style="width: 100px;" uglcw-model="longitude" id="longitude" uglcw-role="textbox">-
                        <input style="width: 100px;" uglcw-model="latitude" id="latitude" uglcw-role="textbox">
                        <input type="button" value="标注" onclick="javascript:showMap();"
                               uglcw-role="button"/>
                    </div>
                </div>
                <%--<div class="form-group">
                    <label class="control-label col-xs-6">默认</label>
                    <div class="col-xs-16">
                        <ul uglcw-role="radio" uglcw-model="isDefault" id="isJxcId"
                            uglcw-options='"layout":"horizontal","dataSource":[{"text":"否","value":"0"},{"text":"是","value":"1"}]'></ul>
                    </div>
                </div>--%>
            </form>
        </div>
    </div>
</script>


<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<%@include file="/WEB-INF/view/v2/include/map.jsp" %>
<script>
    //显示地图
    function showMap() {
        var oldLng = uglcw.ui.get("#longitude").value();
        var oldLat = uglcw.ui.get("#latitude").value();
        var address = uglcw.ui.get("#address").value();
        g_showMap({oldLng: oldLng, oldLat: oldLat, searchCondition: getAreaInfo() + address},
            function (data) {
                debugger
                console.log(data);
                uglcw.ui.get("#longitude").value(data.lng);
                uglcw.ui.get("#latitude").value(data.lat);

                uglcw.ui.get("#address").value(data.street + data.streetNumber);
            }
        )
        ;
    }


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

        //resize();
        //$(window).resize(resize);
        uglcw.ui.loaded();
    })


    //删除
    function del(id) {
        uglcw.ui.confirm("确定删除所选记录吗？", function () {
            $.ajax({
                url: "${base}manager/shopMicroInfo/delete",
                data: {
                    id: id,
                },
                type: 'post',
                dataType: 'json',
                success: function (resp) {
                    if (resp.state) {
                        uglcw.ui.get('#grid').reload();
                        uglcw.ui.success(resp.message);
                    } else {
                        uglcw.ui.error(resp.message)
                    }
                }
            });
        })
    }

    //添加
    function edit(id) {
        $.ajax({
            url: '${base}manager/shopMicroInfo/findById',
            data: {id: id},
            type: 'post',
            success: function (resp) {
                uglcw.ui.loaded();
                if (resp.state) {
                    shopEditForm(resp.obj);
                } else {
                    uglcw.ui.error('加载数据失败');
                }
            }
        })
    }

    function shopEditForm(data) {
        var text = data.id ? '修改' : '新增';
        uglcw.ui.Modal.open({
            title: text + ' 店铺',
            maxmin: false,
            area: ['600px', '450px'],
            content: $('#editForm_tpl').html(),
            success: function (container) {
                uglcw.ui.init($(container));
                uglcw.ui.bind($(container), data);
                loadProvince(data.provinceId, data.cityId, data.areaId);
            },
            yes: function () {
                var provinceId = $("[name=provinceId] option:selected").val();
                var cityId = $("[name=cityId] option:selected").val();
                var areaId = $("[name=areaId] option:selected").val();
                if (!areaId) {
                    uglcw.ui.error('请选择详细地址');
                    return false;
                }
                var data = uglcw.ui.bind(".form-horizontal");
                data.provinceId = provinceId;
                data.cityId = cityId;
                data.areaId = areaId;
                data.areaInfo = getAreaInfo();
                uglcw.ui.loading();
                $.ajax({
                    url: '${base}manager/shopMicroInfo/saveOrUpdate',
                    data: data,
                    type: 'post',
                    async: true,
                    success: function (resp) {
                        uglcw.ui.loaded();
                        if (resp.state) {
                            uglcw.ui.get('#grid').reload();
                            uglcw.ui.success(resp.message);
                        } else {
                            uglcw.ui.error(resp.message)
                        }
                    }, error: function () {
                        uglcw.ui.loaded();
                        uglcw.ui.error("出现错误")
                    }
                })
            }
        })
    }

    //获取选择地址名称
    function getAreaInfo() {
        var provinceStr = $("[name=provinceId] option:selected").text();
        var cityStr = $("[name=cityId] option:selected").text();
        var areaStr = $("[name=areaId] option:selected").text();
        return (provinceStr == '请选择' ? '' : provinceStr) + (cityStr == '请选择' ? '' : cityStr) + (areaStr == '请选择' ? '' : areaStr);
    }


    //获取店铺地址
    function loadProvince(provinceId, cityId, areaId) {
        $("#provinceId").html(getChild("0", "provinceId", provinceId));
        $("#cityId").html(getChild(provinceId, "cityId", cityId));
        $("#areaId").html(getChild(cityId, "areaId", areaId));
    }


    function getChild(parentId, name, selectId) {
        if (parentId != null && parentId != '') {
            $.get("${base}/manager/shopArea/getChild?parentId=" + parentId, function (data) {
                $("#" + name).html(getSelect(data, name, selectId));
            });
        }
    }

    //根据城市接口返回数据后转成select
    function getSelect(data, name, selectId) {
        var html = "<select name='" + name + "' onchange='changeSelect(this)'>";
        html += '<option value="">请选择</option>';
        if (data && data.state && data.obj) {
            var array = data.obj;
            for (var i = 0; i < array.length; i++) {
                var obj = array[i];
                var selectStr = "";
                if (selectId && obj.areaId == selectId)
                    selectStr = "selected";
                html += '<option value="' + obj.areaId + '" data-parentId="' + obj.areaParentId + '" ' + selectStr + '>' + obj.areaName + '</option>';
            }
        }
        html += "</select>";
        return html;
    }

    //改变事件
    function changeSelect(th) {
        var value = $(th).val();
        //if(!value)$(th).parent().next().html("");//$(th).parent().next().remove()
        var name = $(th).attr("name");
        if (name == 'areaId') return;
        if (name == 'provinceId') {
            name = "cityId";
            if (!value) {
                $("#cityId").html("");
            }
            $("#areaId").html("");
        } else if (name == 'cityId') {
            name = "areaId";
            if (!value)
                $("#areaId").html("");
        }
        getChild(value, name);

    }

    function wareManager(id, name) {
        uglcw.ui.openTab(name + "-商品管理", "${base}manager/shopMicroWare/toPage?microId=" + id);
    }
</script>

</body>
</html>
