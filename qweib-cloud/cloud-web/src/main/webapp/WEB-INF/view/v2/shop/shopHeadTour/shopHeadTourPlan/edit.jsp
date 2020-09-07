<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>组图方案设置</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <link href="${base}static/uglcu/iview/iview.css" rel="stylesheet">
    <style>
        .ivu-modal-content {
            border-radius: 1px;
        }

        .action-wrapper {
            padding: 10px;
            position: fixed;
            bottom: 0;
            z-index: 10;
            width: 100%;
            transition: right .5s;
            box-shadow: 0 -3px 5px #eee;
            text-align: center;
            background: #fff;
        }

        .item-header {
            display: flex;
            justify-content: space-between;
            box-sizing: border-box;
            width: 100%;
            color: #333;
            line-height: 30px;
            font-size: 12px;
            padding: 1px 10px;
            background-color: #f7f7f7;
            margin-bottom: 10px;
        }

        .ivu-form-item-label:after {
            content: ':';
        }

        .none-label .ivu-form-item-label:after {
            content: '';
        }

        .item-desc {
            color: #999;
            font-size: 12px;
        }

        .ivu-form-item {
            margin-bottom: 5px;
        }

        .shopTourPlan-item .ivu-form-item {
            margin-bottom: 5px;
        }

        .sub-item {
            margin-left: 20px;
            display: grid;
        }

        .member-selector .ivu-tabs-bar {
            margin-bottom: 0px;
        }

        .member-selector .ivu-modal-body {
            padding: 0 5px;
        }

        .area-item {
            position: relative;
        }

        .area-toggle {
            position: relative;
            z-index: 100;
        }

        .area-icon {
            cursor: pointer;
            margin-left: 4px;
            display: inline-block;
            width: 14px;
            height: 14px;
            vertical-align: top;
            transition: all 0.2s ease-out 0s;
        }

        .area-children {
            position: absolute;
            top: -8px;
            left: -10px;
            z-index: 99;
            min-width: 120px;
            background-color: white;
            box-shadow: rgba(0, 0, 0, 0.2) 0px 1px 4px;
            padding: 30px 0px 8px 10px;
            border-radius: 2px;
        }

        .area-children-group .ivu-checkbox-group {
            box-sizing: border-box;
            max-height: 200px;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
        }

        .main-item > .ivu-form-item-label {
            border-left: 4px solid #2d8cf0;
            border-radius: 2px;
        }

        .ivu-form-item-error-tip {
            position: static;
        }
    </style>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div id="app">
        <div style="padding-bottom: 50px;">
            <i-form ref="form" :label-width="120" :model="shopTourPlan" :rules="rules">
                <divider orientation="left">基本信息</divider>
                <form-item class="main-item" label="方案名称" prop="name">
                    <i-input :disabled="shopTourPlan.status == 1" style="width: 300px;" required v-model="shopTourPlan.name"
                             placeholder="如：10人团"></i-input>
                </form-item>
                <form-item class="main-item" label="生效时间">
                    <div style="display: flex;">
                        <form-item prop="startTime">
                            <date-picker :disabled="shopTourPlan.status == 1" :options="startTimeOptions" type="datetime"
                                         format="yyyy-MM-dd HH:mm"
                                         placeholder="开始时间"
                                         v-model="shopTourPlan.startTime"></date-picker>
                        </form-item>
                        <span style="margin-left: 10px;margin-right: 10px;">至</span>
                        <form-item prop="endTime">
                            <date-picker :disabled="shopTourPlan.status == 1" :options="endTimeOptions" type="datetime"
                                         format="yyyy-MM-dd HH:mm"
                                         placeholder="结束时间"
                                         v-model="shopTourPlan.endTime"></date-picker>
                        </form-item>
                    </div>
                </form-item>

                <form-item  class="main-item"  label="参团人数" prop="count">
                    <input-number :disabled="shopTourPlan.status == 1" :min="2" :max="100"
                                  v-model="shopTourPlan.count"></input-number>&nbsp<span style="color: red">请填写2-100数字</span>
                </form-item>

                <form-item  class="main-item"  label="限购数量" prop="limitQty">
                    <input-number :disabled="shopTourPlan.status == 1"
                                  v-model="shopTourPlan.limitQty"></input-number>&nbsp
                </form-item>

                <form-item class="main-item" label="描   述">
                    <i-input :disabled="shopTourPlan.status == 1" style="width: 400px;height: 100px" type="textarea"
                             v-model="shopTourPlan.description"
                             placeholder="方案描述"></i-input>
                </form-item>
            </i-form>
            </Card>
        </div>
        <div class="action-wrapper">
            <i-button style="border-radius: 0;" type="default" @click="close">关闭</i-button>
            <i-button style="border-radius: 0;" type="primary" @click="save"
                      :disabled="shopTourPlan.status == 1">保存
            </i-button>

        </div>
</div>
<script type="text/x-uglcw-template" id="product-group-tag">
    # for(var i=0; i
    <data.length; i++){#
    #var item = data[i];#
    <div uglcw-role="tag" data-id="#= item.id#">#= item.text#</div>
    #}#
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script src="${base}static/uglcu/vue/vue.min.js"></script>
<script src="${base}static/uglcu/iview/iview.min.js"></script>
<script src="${base}static/uglcu/iview/zh-CN.js"></script>
<script>
    var vm;
    $(function () {
        uglcw.ui.loaded();
        Vue.config.debug = true;
        Vue.config.devtools = true;
        vm = new Vue({
            el: '#app',
            data: {
                startTimeOptions: {
                    disabledDate: function (date) {
                        var now = new Date().setHours(0, 0, 0, 0);
                        return date && date.valueOf() < now.valueOf();
                    }
                },
                endTimeOptions: {
                    disabledDate: function (date) {
                        var now = new Date().setHours(0, 0, 0, 0);
                        return date && date.valueOf() < now.valueOf();
                    }
                },
                allAreaChecked: false,
                rules: {
                    name: [
                        {required: true, message: '请输入方案名称'}
                    ],
                    count: [
                        {required: true, message: '请输入参团人数'}
                    ],
                    startTime: [
                        {required: true, message: '请选择组团开始时间'}
                    ],
                    endTime: [
                        {required: true, message: '请选择组团结束时间'}
                    ]
                },
                shopTourPlan: {
                    id: ${param.id ne null ? param.id : 'null'},
                    status: 0,
                    name: '',
                    description: '',
                    startTime: null,
                    endTime: null,
                    count:2,
                    limitQty:null
                }
            },
            mounted: function () {
                var vm = this;
                if (vm.shopTourPlan.id) {
                    vm.load();
                }
            },
            methods: {
                load: function () {
                    var vm = this;
                    vm.$Spin.show();
                    $.ajax({
                        url: '${base}manager/shopHeadTourPlan/get?id=' + vm.shopTourPlan.id,
                        type: 'get',
                        success: function (response) {
                            vm.$Spin.hide();
                            if (response.success) {
                                var shopTourPlan = response.data;
                                shopTourPlan.startTime = shopTourPlan.startTime ? new Date(shopTourPlan.startTime) : shopTourPlan.startTime;
                                shopTourPlan.endTime = shopTourPlan.endTime ? new Date(shopTourPlan.endTime) : shopTourPlan.endTime;
                                Object.assign(vm.shopTourPlan, shopTourPlan)
                            } else {
                                vm.$Message.error(response.message);
                            }
                        },
                        error: function () {
                            vm.$Spin.hide();
                            vm.$Message.error('加载失败，请稍后再试');
                        }
                    })
                },
                close:function(){
                    uglcw.ui.closeCurrentTab();
                },
                save: function () {
                    var vm = this;
                    vm.$refs.form.validate(function (v) {
                        if (v) {
                            vm.$Spin.show();
                            var shopTourPlan = Object.assign({}, vm.shopTourPlan);
                            shopTourPlan.startTime = uglcw.util.toString(shopTourPlan.startTime, 'yyyy-MM-dd HH:mm');
                            shopTourPlan.endTime = uglcw.util.toString(shopTourPlan.endTime, 'yyyy-MM-dd HH:mm');
                            $.ajax({
                                url: '${base}manager/shopHeadTourPlan/save',
                                type: 'post',
                                contentType: 'application/json',
                                data: JSON.stringify(shopTourPlan),
                                success: function (response) {
                                    if (response.code === 200) {
                                        vm.shopTourPlan.id = response.data;
                                        vm.$Message.success(response.message);
                                        //window.parent.$('.layui-this span').text(vm.shopTourPlan.name);
                                        setTimeout(function () {
                                            uglcw.ui.closeCurrentTab();
                                        },1000)
                                        uglcw.io.emit('shop_head_tour_plan_chage',1);
                                    } else {
                                        vm.$Message.error(response.message);
                                    }
                                    vm.$Spin.hide();
                                }
                            });
                        }
                    })
                }
            }
        })
    })

</script>
</body>
</html>
