<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>优惠券规则设置</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <link href="${base}static/uglcu/iview/iview.css" rel="stylesheet">
    <style>
        .time-range{
            display: flex!important;
        }
        .time-range .ivu-radio{
            margin-top: 10px;
            height: 14px;
        }
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

        .coupon-item .ivu-form-item {
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

        .custom_mask {
            position: fixed;
            top: 0;
            left: 0;
            bottom: 0;
            z-index: 99998;
            width: 100%;
            height: 100%;
        }
    </style>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div id="app">
        <div class="custom_mask" v-if="show"></div>
        <div style="padding-bottom: 50px;">
            <i-form ref="form" :label-width="120" :model="coupon" :rules="rules">
                <divider orientation="left">基本信息</divider>
                <form-item class="main-item" label="优惠券类型" prop="type">
                    <radio-group v-model="coupon.type" @on-change="couponTypeChange">
                        <radio :label="1" :disabled="(!!coupon.id && coupon.status != -2)">满减券</radio>
                        <radio :label="2" :disabled="(!!coupon.id && coupon.status != -2)">折扣券</radio>
                    </radio-group>
                </form-item>
                <form-item class="main-item" label="优惠券名称" prop="name">
                    <i-input style="width: 300px;" required v-model="coupon.name"
                             placeholder="如：国庆满减活动，最多15个字"></i-input>
                </form-item>
                <form-item class="main-item" label="名称备注" prop="nameRemark">
                    <i-input style="width: 300px;" v-model="coupon.nameRemark"
                             placeholder="仅内部可见，最多15个字"></i-input>
                </form-item>
                <form-item class="main-item" label="发放总量" prop="quantity">
                    <i-input style="width: 300px;" type="number" v-model="coupon.quantity"
                             placeholder="最多1000000张"></i-input>&nbsp;张
                </form-item>
                <form-item class="main-item" label="适用商品" prop="scope">
                    <div style="display: grid;">
                        <radio-group v-model="coupon.scope">
                            <radio :label="0" :disabled="(!!coupon.id && coupon.status != -2)">全部商品可用</radio>
                            <radio :label="1" :disabled="(!!coupon.id && coupon.status != -2)">指定商品类别可用</radio>
                            <radio :label="2" :disabled="(!!coupon.id && coupon.status != -2)">指定商品可用 <span v-if="expand.productSelection.length > 0">({{expand.productSelection.length}})</span>
                            </radio>
                        </radio-group>
                        <div v-if="coupon.scope == 1">
                            <a @click="loadProductCategory" v-if="(!coupon.id || coupon.status == -2)" style="margin-right: 10px;">
                                点击<span v-if="categoryLoaded">重新</span>加载分类</a>

                            <tree ref="productCategory" :data="productCategories"
                                  show-checkbox></tree>
                        </div>
                        <div v-if="coupon.scope == 2">
                            <a @click="loadProducts" v-if="(!coupon.id || coupon.status == -2)" style="margin-right: 10px;">
                                <icon type="md-add"></icon>
                                选择商品 ({{expand.productSelection.length}})</a>
                            <a @click="batchRemoveProduct" v-if="(!coupon.id || coupon.status == -2)" style="margin-right: 10px;">
                                <icon type="ios-trash-outline"></icon>
                                批量删除</a>

                            <i-table :height="300" style="width: 600px;" size="small" :columns="productColumns"
                                     @on-select="onProductSelect"
                                     @on-select-all="onProductSelect"
                                     @on-select-change="onProductSelect"
                                     :data="expand.productSelection"></i-table>
                        </div>
                    </div>
                </form-item>
                <form-item class="main-item" label="使用门槛" prop="thresholdType">
                    <radio-group v-model="coupon.thresholdType">
                        <radio :label="2" :disabled="(!!coupon.id && coupon.status != -2)">订单满
                            <i-input :disabled="coupon.thresholdType == 1 || (!!coupon.id && coupon.status != -2)" style="width: 100px;" type="number"
                                     v-model="coupon.moreThanAmount"></i-input>&nbsp;元
                        </radio>
                        <radio :label="1" :disabled="(!!coupon.id && coupon.status != -2)">无使用门槛</radio>
                    </radio-group>
                </form-item>
                <form-item class="main-item" label="优惠内容" prop="couponAmount">
                    <span v-if="coupon.type == 1">减免 <input-number style="width: 100px;" :disabled="(!!coupon.id && coupon.status != -2)" type="number"
                                                              v-model="coupon.couponAmount"></input-number> 元</span>
                    <span v-if="coupon.type == 2">打 <input-number style="width: 100px;" :disabled="(!!coupon.id && coupon.status != -2)" :active-change="false" :min="10" :max="99" :setp="1" :active-change="false"
                                                             v-model="coupon.couponAmount"></input-number> 折 <span>输入范围(10-99)  (如：{{coupon.couponAmount}}=单价*{{coupon.couponAmount/100}})</span></span>
                </form-item>
                <form-item class="main-item" v-if="coupon.type === 2" prop="couponAmount">
                    <CheckBox :disabled="(!!coupon.id && coupon.status != -2)" v-model="coupon.mostCouponAmountStatus">最多优惠</CheckBox>
                    <i-input style="width: 100px;" :disabled="(!!coupon.id && coupon.status != -2) || !coupon.mostCouponAmountStatus" type="number"
                             v-model="coupon.mostCouponAmount"></i-input>
                    元
                </form-item>
                <form-item class="main-item" label="用券时间" prop="timeType">
                    <radio-group v-model="coupon.timeType" vertical>
                        <radio :label="1" :disabled="(!!coupon.id && coupon.status != -2)" class="time-range">
                            <div style="display: flex;">
                                <form-item prop="timeRangeBegin">
                                    <date-picker transfer :disabled="(!!coupon.id && coupon.status != -2) || coupon.timeType != 1"
                                                 :options="startTimeOptions"
                                                 type="datetime"
                                                 format="yyyy-MM-dd HH:mm"
                                                 placeholder="开始时间"
                                                 v-model="coupon.timeRangeBegin"></date-picker>
                                </form-item>
                                <span style="margin-left: 10px;margin-right: 10px;">至</span>
                                <form-item prop="timeRangeEnd">
                                    <date-picker transfer :disabled="(!!coupon.id && coupon.status != -2) || coupon.timeType != 1"
                                                 :options="endTimeOptions"
                                                 type="datetime"
                                                 format="yyyy-MM-dd HH:mm"
                                                 placeholder="结束时间"
                                                 v-model="coupon.timeRangeEnd"></date-picker>
                                </form-item>
                            </div>
                        </radio>
                        <radio :label="2" :disabled="(!!coupon.id && coupon.status != -2)">领券当日起
                            <Poptip trigger="focus" title="提示信息" content="有效期按自然天计算。举例：如设置领券当日起2天内可用，用户在5月20日15:00时领取优惠券，则该优惠券的可用时间为5月20日的15:00:00至5月21日的23:59:59。">
                            <i-input :disabled="(!!coupon.id && coupon.status != -2) || coupon.timeType != 2" style="width: 100px;" type="number"
                                     v-model="expand.timeNum1"></i-input>
                            </Poptip>
                                &nbsp;天内可用
                        </radio>
                        <radio :label="3" :disabled="(!!coupon.id && coupon.status != -2)">领券次日起
                            <Poptip trigger="focus" title="提示信息" content="有效期按自然天计算。举例：如设置领券次日起2天内可用，用户在3月20日的15:00领取优惠券，则该优惠券的可用时间为3月21日的00:00:00到3月22日的23:59:59。">
                            <i-input :disabled="(!!coupon.id && coupon.status != -2) || coupon.timeType != 3" style="width: 100px;" type="number"
                                     v-model="expand.timeNum2"></i-input>
                            </Poptip>
                                &nbsp;天内可用
                        </radio>
                    </radio-group>
                </form-item>
                <divider orientation="left">领取和使用规则</divider>
                <form-item class="main-item" label="领取人限制" prop="limitMember">
                    <div style="display: grid;">
                        <radio-group v-model="coupon.limitMember">
                            <radio :label="0" :disabled="(!!coupon.id && coupon.status != -2)">不限制</radio>
                            <radio :label="1" :disabled="(!!coupon.id && coupon.status != -2)">指定会员类型</radio>
                            <radio :label="2" :disabled="(!!coupon.id && coupon.status != -2)">指定会员等级</radio>
                            <radio :label="3" :disabled="(!!coupon.id && coupon.status != -2)">指定会员</radio>
                        </radio-group>
                        <div v-if="coupon.limitMember == 1">
                            <i-select v-model="expand.memberTypeSelection" :disabled="(!!coupon.id && coupon.status != -2)" style="width: 500px"
                                      multiple
                                      placeholder="请选择会员类型">
                                <i-option :value="1" :key="1">常规会员</i-option>
                                <i-option :value="2" :key="2">员工会员</i-option>
                                <i-option :value="3" :key="3">进销存会员</i-option>
                                <i-option :value="4" :key="4">门店会员</i-option>
                            </i-select>
                        </div>
                        <div v-if="coupon.limitMember == 2">
                            <i-select v-model="expand.memberLevelSelection" :disabled="(!!coupon.id && coupon.status != -2)" style="width: 500px"
                                      multiple
                                      placeholder="请选择会员等级">
                                <i-option v-for="item in memberLevels" :value="item.id" :key="item.id">
                                    {{item.gradeName}}
                                </i-option>
                            </i-select>
                        </div>
                        <div v-if="coupon.limitMember == 3">
                            <a @click="loadMembers" v-if="(!coupon.id || coupon.status == -2)" style="margin-right: 10px;">
                                <icon type="md-add"></icon>
                                选择会员 ({{expand.memberSelection.length}})</a>
                            <a @click="batchRemoveMember" v-if="(!coupon.id || coupon.status == -2)" style="margin-right: 10px;">
                                <icon type="ios-trash-outline"></icon>
                                批量删除</a>
                            <i-table :height="300" style="width: 700px;" size="small" :columns="memberColumns"
                                     @on-select="onMemberSelect"
                                     @on-select-all="onMemberSelect"
                                     @on-select-change="onMemberSelect"
                                     :data="expand.memberSelection"></i-table>
                        </div>
                    </div>
                </form-item>
                <form-item class="main-item" label="每人限领次数" prop="limitNum">
                    <radio-group v-model="coupon.limitNumType">
                        <radio :label="0" :disabled="(!!coupon.id && coupon.status != -2)">不限次数</radio>
                        <radio :label="1" :disabled="(!!coupon.id && coupon.status != -2)">限领
                            <i-input :disabled="(!!coupon.id && coupon.status != -2) || coupon.limitNumType != 1" style="width: 100px;" type="number"
                                     v-model="coupon.limitNum"></i-input>&nbsp;次
                        </radio>
                    </radio-group>
                </form-item>
                <%--<form-item class="main-item" label="分享设置" prop="allowShared">--%>
                    <%--<Checkbox v-model="coupon.allowShared">优惠券允许分享给好友领取</Checkbox>--%>
                <%--</form-item>--%>
                <form-item class="main-item" label="使用说明">
                    <i-input style="width: 600px;" type="textarea" rows="5" @on-change="statementChange"
                             v-model="coupon.statement" :disabled="(!!coupon.id && coupon.status != -2)"
                             placeholder="使用说明"></i-input>
                </form-item>
            </i-form>
            </Card>
        </div>
        <div class="action-wrapper" style="z-index:99999">
            <i-button style="border-radius: 0;" type="default" @click="cancel">关闭</i-button>
            <i-button style="border-radius: 0;" v-if="!show" type="primary" @click="save">保存</i-button>
            <i-button v-if="coupon.id" style="border-radius: 0;" type="default" @click="copyData">复制</i-button>
        </div>
    </div>
</div>
<script type="text/x-uglcw-template" id="product-group-tag">
    # for(var i=0; i < data.length; i++){#
    #var item = data[i];#
    <div uglcw-role="tag" data-id="#= item.id#">#= item.text#</div>
    #}#
</script>
<script id="member-selector-tpl" type="text/x-uglcw-template">
    <div class="layui-card">
        <div class="layui-card-body">
            <div class="member-query">
                <input type="hidden" uglcw-role="textbox" uglcw-model="source" value="1">
            </div>
            <div uglcw-role="tabs" uglcw-lazy="true" uglcw-options="select: function(e){
                uglcw.ui.bind('.member-query',{ source: $(e.item).data('source')});
                var grid = $('#grid-member-selector').data('kendoGrid')
                if(grid){
                    uglcw.ui.get('#grid-member-selector').reload({page: 1});
                }
            }">
                <ul>
                    <li data-source="1">常规会员</li>
                    <li data-source="2">员工会员</li>
                    <li data-source="3">进销存客户</li>
                    <li data-source="4">门店会员</li>
                </ul>
            </div>
            <div id="grid-member-selector" uglcw-role="grid"
                 uglcw-options="
                    height: 350,
                    id:'id',
                    pageable: true,
                    url: '${base}manager/shopMember/shopMemberPage?isDel=0',
                    checkbox: true,
                    criteria: '.member-query'
                "
            >
                <div data-field="name" uglcw-options="width:'auto'">会员名称</div>
                <div data-field="mobile" uglcw-options="width:'auto'">电话</div>
                <div data-field="pic" uglcw-options="width:'auto', template: uglcw.util.template($('#avatar-tpl').html())">
                    头像
                </div>
                <div data-field="nickname" uglcw-options="width:'auto'">昵称</div>
            </div>
        </div>
    </div>
</script>
<script id="avatar-tpl" type="text/x-uglcw-template">
    #if(data.pic){#
    <img src="#= data.pic#" style="width: 50px;height:50px;"/>
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
                productGroups: [],  // 商城商品分组
                coupon: {
                    id: '${param.id ne null ? param.id : ''}',
                    type: 1,
                    name: '',
                    nameRemark: '',
                    quantity: null,
                    status: null,
                    scope: 0,
                    thresholdType: 2,
                    moreThanAmount: null,
                    couponAmount: null,
                    mostCouponAmountStatus: false,
                    mostCouponAmount: null,
                    timeType: 1,
                    timeRangeBegin: null,
                    timeRangeEnd: null,
                    timeNum: null,
                    limitMember: 1,
                    members: [],
                    limitNumType: 1,
                    limitNum: 1,
                    allowShared: true,
                    statement: ''
                },
                rules: {
                    name: [
                        {required: true, message: '请输入优惠券名称'}
                    ],
                    quantity: [
                        {required: true, message: '请输入发放总量'}
                    ],
                    scope: [
                        {required: true, message: '请选择适用商品'}
                    ],
                    thresholdType: [
                        {required: true, message: '请选择使用门槛'}
                    ],
                    couponAmount: [
                        {required: true, message: '请输入优惠内容'}
                    ],
                    timeType: [
                        {required: true, message: '请选择用券时间'}
                    ],
                    limitMember: [
                        {required: true, message: '请选择领取人限制'}
                    ],
                    limitNumType: [
                        {required: true, message: '请选择每人限领次数'}
                    ]
                },
                categoryLoaded: false,
                productCategories: [],
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
                memberLevels: [], //会员等级
                expand: {
                    categorySelection: [],
                    productSelection: [],//限制商品
                    timeNum1: null,
                    timeNum2: null,
                    memberTypeSelection: [1,2,4], // 选中会员类型列表
                    memberLevelSelection: [],
                    memberSelection: []
                },
                productSelection: [],//限制商品
                memberSelection: [],
                show: ${param.oper eq 'show' ? true : false},
                copy: ${param.oper eq 'copy' ? true : false},
                statementEdit: false
            },
            mounted: function () {
                var vm = this;
                vm.loadMemberLevels();
                vm.loadProductGroups();
                if (vm.coupon.id) {
                    vm.load();
                }
            },
            watch: {
                'coupon.type'(newVal) {
                    this.computeStatement();
                },
                'coupon.name'(newVal) {
                    this.computeStatement();
                },
                'coupon.scope'(newVal) {
                    this.computeStatement();
                },
                'coupon.thresholdType'(newVal) {
                    this.computeStatement();
                },
                'coupon.moreThanAmount'(newVal) {
                    this.computeStatement();
                },
                'coupon.couponAmount'(newVal) {
                    this.computeStatement();
                },
                'coupon.mostCouponAmount'(newVal) {
                    this.computeStatement();
                },
                'coupon.timeRangeBegin'(newVal) {
                    this.computeStatement();
                },
                'coupon.timeRangeEnd'(newVal) {
                    this.computeStatement();
                },
                'expand.timeNum1'(newVal) {
                    this.computeStatement();
                },
                'expand.timeNum2'(newVal) {
                    this.computeStatement();
                }
            },
            computed: {
                productColumns: function () {
                    if (this.coupon.id && !! this.coupon.status && this.coupon.status != -2) {
                        return [
                            {type: 'selection', width: 50, fixed: 'left'},
                            {title: '商品名称', key: 'wareNm'},
                            {title: '商品规格', key: 'wareGg'}
                        ];
                    } else {
                        return [
                            {type: 'selection', width: 50, fixed: 'left'},
                            {title: '商品名称', key: 'wareNm'},
                            {title: '商品规格', key: 'wareGg'},
                            {
                                title: '操作', fixed: 'right', width: 100, render: function (h, params) {
                                    return h('i-button', {
                                        on: {
                                            click: function () {
                                                vm.$Modal.confirm({
                                                    title: '确定删除吗?',
                                                    onOk: function () {
                                                        vm.expand.productSelection.splice(params.index, 1);
                                                    }
                                                })
                                            }
                                        }
                                    }, '删除');
                                }
                            }
                        ];
                    }
                },
                memberColumns: function () {
                    if (this.coupon.id && !!this.coupon.status && this.coupon.status != -2) {
                        return [
                            {title: '会员名称', key: 'name'},
                            {title: '电话', key: 'mobile'},
                            {
                                title: '头像', key: 'pic', render: function (h, params) {
                                    var rows = params.row;
                                    return rows.pic ? h('img', {
                                        attrs: {
                                            src: rows.pic,
                                            width: 50,
                                            height: 50
                                        }
                                    }) : ''
                                }
                            },
                            {title: '昵称', key: 'nickname'}
                        ]
                    } else {
                        return [
                            {type: 'selection', width: 50, fixed: 'left'},
                            {title: '会员名称', key: 'name'},
                            {title: '电话', key: 'mobile'},
                            {
                                title: '头像', key: 'pic', render: function (h, params) {
                                    var rows = params.row;
                                    return rows.pic ? h('img', {
                                        attrs: {
                                            src: rows.pic,
                                            width: 50,
                                            height: 50
                                        }
                                    }) : ''
                                }
                            },
                            {title: '昵称', key: 'nickname'},
                            {
                                title: '操作', fixed: 'right', width: 100, render: function (h, params) {
                                    return h('i-button', {
                                        on: {
                                            click: function () {
                                                vm.$Modal.confirm({
                                                    title: '确定删除吗?',
                                                    onOk: function () {
                                                        vm.expand.memberSelection.splice(params.index, 1);
                                                    }
                                                })
                                            }
                                        }
                                    }, '删除');
                                }
                            }
                        ]
                    }
                }
            },
            methods: {
                load: function () {
                    var vm = this;
                    vm.$Spin.show();
                    $.ajax({
                        url: '${base}manager/mall/coupon/' + vm.coupon.id,
                        type: 'get',
                        success: function (response) {
                            if (response.success) {
                                vm.coupon = response.data;

                                //限制商品为类别
                                if (vm.coupon.scope === 1) {
                                    vm.loadProductCategory(null, function () {
                                        vm.checkProductCategory(vm.coupon.objects);
                                    });//加载分类zzx
                                } else if (vm.coupon.scope === 2) {
                                    vm.expand.productSelection = vm.coupon.customProducts;
                                }

                                if (vm.coupon.limitMember === 1) {
                                    vm.expand.memberTypeSelection = vm.coupon.members;
                                } else if (vm.coupon.limitMember === 2) {
                                    vm.expand.memberLevelSelection = vm.coupon.members;
                                } else if (vm.coupon.limitMember === 3) {
                                    vm.expand.memberSelection = vm.coupon.customMembers;
                                }

                                if (vm.copy) {
                                    vm.coupon.id = null;
                                    vm.coupon.name = null;
                                    vm.coupon.nameRemark = null;
                                    vm.coupon.status = null;
                                }

                                if (vm.coupon.timeType === 1) {
                                    vm.coupon.timeRangeBegin = new Date(vm.coupon.timeRangeBegin);
                                    vm.coupon.timeRangeEnd = new Date(vm.coupon.timeRangeEnd);
                                } else if (vm.coupon.timeType === 2) {
                                    vm.expand.timeNum1 = vm.coupon.timeNum;
                                } else if (vm.coupon.timeType === 3) {
                                    vm.expand.timeNum2 = vm.coupon.timeNum;
                                }

                                if (!!vm.coupon.id) {
                                    vm.statementEdit = true;
                                }
                            } else {
                                vm.$Message.error(response.message);
                            }
                            vm.$Spin.hide();
                        },
                        error: function () {
                            vm.$Spin.hide();
                            vm.$Message.error('加载失败，请稍后再试');
                        }
                    })
                },
                checkProductCategory: function (selected) {
                    var vm = this;
                    selected = selected || [];
                    var visit = function (node) {
                        if (node.children && node.children.length > 0) {
                            $.map(node.children, function (child) {
                                visit(child);
                            })
                        } else if (selected.indexOf(node.value) !== -1) {
                            vm.$set(node, 'checked', true);
                        }

                        if (vm.coupon.status != null && vm.coupon.status != -2) {
                            vm.$set(node, 'disabled', true);
                        }
                    };
                    $(vm.productCategories).each(function (i, category) {
                        visit(category);
                    });
                },
                loadProductGroups: function () {
                    var vm = this;
                    $.ajax({
                        url: '${base}manager/shopWareGroup/queryGroupTree',
                        type: 'get',
                        dataType: 'json',
                        success: function (resp) {
                            vm.productGroups = resp;
                        }
                    })
                },
                loadProductCategory: function (event, callback) {
                    var vm = this;
                    $.ajax({
                        url: '${base}manager/mall/coupon/waretypes',
                        type: 'get',
                        dataType: 'json',
                        success: function (response) {
                            vm.categoryLoaded = true;
                            response = uglcw.util.arrayToTree(response.data, {
                                parent: 'waretypePid',
                                id: 'waretypeId'
                            });
                            var visit = function (nodes) {
                                if (nodes && nodes.length > 0) {
                                    $.map(nodes, function (node) {
                                        node.label = node.waretypeNm;
                                        node.title = node.waretypeNm;
                                        node.value = node.waretypeId;
                                        if (node.children && node.children.length > 0) {
                                            node.loading = false;
                                            visit(node.children);
                                        }
                                    })
                                }
                            };
                            visit(response);
                            vm.productCategories = response;
                            if (callback) {
                                callback();
                            }
                        }
                    })
                },
                loadProducts: function () {
                    var vm = this;
                    var url = '${base}manager/shopWare/page';
                    vm.selectProducts(url, true, function (data) {
                        //过滤已存在商品，不能重复增加
                        if (data && data.length > 0 && vm.expand.productSelection && vm.expand.productSelection.length > 0) {
                            $(vm.expand.productSelection).each(function (j, item) {
                                for (var i = data.length - 1; i >= 0; i--) {
                                    if (item.wareId == data[i].wareId) {
                                        data.splice(i, 1);
                                        return;
                                    }
                                }
                            })
                        }
                        vm.expand.productSelection = vm.expand.productSelection.concat(data);
                    });
                },
                onProductSelect: function (selection) {
                    this.productSelection = selection;
                },
                batchRemoveProduct: function () {
                    var vm = this;
                    if (vm.productSelection.length < 1) {
                        return vm.$Message.warning('请选择要删除的商品');
                    }
                    vm.expand.productSelection = $.map(vm.expand.productSelection, function (item) {
                        if (!vm.hit(vm.productSelection, item, 'wareId')) {
                            return item;
                        }
                    });
                },
                selectProducts: function (url, checkbox, callback) {
                    var vm = this;
                    if (!url) {
                        url = '${base}manager/shopWare/page';
                    }
                    uglcw.ui.Modal.showTreeGridSelector({
                        title: '挑选产品',
                        url: url,
                        loadFilter: {
                            data: function (response) {
                                return response.rows || []
                            }
                        },
                        tree: {
                            url: '${base}manager/shopWareNewType/shopWaretypesExists',
                            lazy: false,
                            model: 'waretype',
                            id: 'id',
                            expandable: function (node) {
                                return node.id == 0;
                            }
                        },
                        width: 900,
                        id: 'wareId',
                        pageable: true,
                        query: function (params) {
                            return params;
                        },
                        checkbox: checkbox,
                        criteria: '<input uglcw-role="textbox" placeholder="输入关键字" uglcw-model="wareNm"/>' +
                            '<input uglcw-role="textbox" type="hidden" uglcw-model="groupIds"/>' +
                            '<div style="display: inline-flex">' + uglcw.util.template($('#product-group-tag').html())({data: vm.productGroups}) + '</div>',
                        columns: [
                            {field: 'wareCode', title: '商品编码', width: 120, tooltip: true},
                            {
                                field: 'wareNm', title: '商品名称', width: 250, tooltip: true
                            },
                            {field: 'wareDw', title: '大单位', width: 120},
                            {field: 'minUnit', title: '小单位', width: 120},
                            {field: 'maxUnitCode', title: '大单位代码', width: 120, hidden: true},
                            {field: 'minUnitCode', title: '小单位代码', width: 120, hidden: true},
                            {field: 'hsNum', title: '换算比例', width: 120, hidden: true},
                            {field: 'sunitFront', title: '开单默认选中小单位', width: 240, hidden: true}
                        ],
                        success: function (c, tree, grid) {
                            $(c).find('[uglcw-role=tag]').on('click', function () {
                                var group = $(this).attr('data-id');
                                uglcw.ui.bind(c, {
                                    groupIds: group
                                });
                                grid.reload();
                            })
                            grid.on('dataBound', function () {//默认选中已存在活动商品，并禁用
                                if (vm.existsWares && vm.existsWares.length > 0) {
                                    $(grid.k().dataSource.data()).each(function (i, row) {
                                        if (vm.existsWares.indexOf(row.wareId + "") != -1) {
                                            var row = $(c).find('.uglcw-grid tr[data-uid=' + row.uid + ']');
                                            grid.k().select(row);
                                            setTimeout(function () {
                                                $(row).unbind('click');
                                                $(row).find('input[type=checkbox]').prop('disabled', true);
                                                $(row).removeClass('k-state-selected');
                                            }, 50);
                                        }
                                    })
                                }
                            });

                            grid.on('change', function (e) {
                                console.log(e.sender.select());
                            })
                        },
                        yes: function (data) {
                            if (data) {
                                callback(data);
                            }
                        }
                    })
                },
                loadMemberLevels: function () {
                    var vm = this;
                    $.ajax({
                        url: '${base}manager/shopMemberGrade/page',
                        type: 'get',
                        dataType: 'json',
                        data: {rows: 50, page: 1, status: 1},
                        success: function (response) {
                            vm.memberLevels = response.rows || [];
                        }
                    })
                },
                loadMembers: function () {
                    var vm = this
                    uglcw.ui.Modal.open({
                        title: '请选择会员',
                        area: '650px',
                        content: $('#member-selector-tpl').html(),
                        success: function (c) {
                            uglcw.ui.init(c);
                        },
                        yes: function (c) {
                            var rows = uglcw.ui.get($(c).find('.uglcw-grid')).selectedRow();
                            if (rows && rows.length > 0) {
                                var check = function (source, target, idName) {
                                    var hit = false;
                                    $(source).each(function (i, item) {
                                        if (item[idName] === target[idName]) {
                                            hit = true;
                                            return false;
                                        }
                                    });
                                    return hit;
                                };

                                var source = vm.expand.memberSelection;
                                var tmpMembers = []
                                $(rows).each(function (j, row) {
                                    if (!check(source, row, 'id')) {
                                        tmpMembers.push(row)
                                    }
                                })
                                vm.expand.memberSelection = vm.expand.memberSelection.concat(tmpMembers)
                            }
                        }
                    })
                },
                onMemberSelect: function (selection) {
                    this.memberSelection = selection;
                },
                batchRemoveMember: function () {
                    var vm = this;
                    if (vm.memberSelection.length < 1) {
                        return vm.$Message.warning('请选择要删除的会员');
                    }
                    vm.expand.memberSelection = $.map(vm.expand.memberSelection, function (item) {
                        if (!vm.hit(vm.memberSelection, item, 'id')) {
                            return item;
                        }
                    });
                },
                couponTypeChange: function (value) {
                    this.coupon.couponAmount = null;
                },
                statementChange: function (e) {
                    this.statementEdit = true;
                },
                computeStatement: function () {
                    var vm = this;
                    if (vm.statementEdit) {
                        return vm.coupon.statement
                    }
                    var nameText = !!vm.coupon.name ? vm.coupon.name : '';
                    var timeTypeText = '';
                    if (vm.coupon.timeType === 1) {
                        if (!!vm.coupon.timeRangeBegin) {
                            timeTypeText = uglcw.util.toString(vm.coupon.timeRangeBegin, 'yyyy-MM-dd HH:mm');
                        }
                        if (!!vm.coupon.timeRangeEnd) {
                            timeTypeText += '到' + uglcw.util.toString(vm.coupon.timeRangeEnd, 'yyyy-MM-dd HH:mm');
                        }
                    } else if (vm.coupon.timeType === 2) {
                        if (!!vm.expand.timeNum1) {
                            timeTypeText = '领券当日起' + vm.expand.timeNum1 + '天内可用';
                        }
                    } else if (vm.coupon.timeType === 3) {
                        if (!!vm.expand.timeNum2) {
                            timeTypeText = '领券次日起' + vm.expand.timeNum2 + '天内可用';
                        }
                    }
                    var scopeText = vm.coupon.scope === 0 ? '全部商品可用' : vm.coupon.scope === 1 ? '指定商品类别可用' : '指定商品可用';
                    var thresholdTypeText = vm.coupon.thresholdType === 1 ? '无限制' : vm.coupon.moreThanAmount ? '满' + vm.coupon.moreThanAmount + '元' : '';
                    var couponAmountText = null;
                    if (!!vm.coupon.couponAmount) {
                        if (vm.coupon.type === 1) {
                            couponAmountText = '减免' + vm.coupon.couponAmount + '元优惠卷';
                        } else {
                            couponAmountText = vm.coupon.couponAmount + '折优惠券';
                            if (!!vm.coupon.mostCouponAmount) {
                                couponAmountText += '，最多优惠' + vm.coupon.mostCouponAmount + '元';
                            }
                        }
                    }

                    var result = nameText + (!!timeTypeText ? '\n使用时间：' + timeTypeText : '') + '\n优惠内容：' + scopeText
                        + (!!thresholdTypeText ? '，' + thresholdTypeText : '') + (!!couponAmountText ? '，' + couponAmountText : '');

                    vm.coupon.statement = result;
                },
                cancel: function () {
                    uglcw.ui.closeCurrentTab();
                },
                save: function () {
                    var vm = this;
                    vm.$refs.form.validate(function (v) {
                        if (!v) {
                            return;
                        }

                        vm.coupon.quantity = parseInt(vm.coupon.quantity);
                        if (vm.coupon.scope === 0) {
                            vm.coupon.objects = [];
                        } else if (vm.coupon.scope === 1) {
                            var objects = $.map(vm.$refs.productCategory.getCheckedNodes(), function (c) {
                                if (!c.disableCheckbox)
                                    return c.value;
                            });
                            if (objects.length === 0) {
                                return vm.$Message.warning('请选择产品类别');
                            }
                            vm.coupon.objects = objects;
                        } else if (vm.coupon.scope === 2) {
                            if (!vm.expand.productSelection || vm.expand.productSelection.length < 1) {
                                return vm.$Message.warning('请选择商品');
                            }
                            vm.coupon.objects = $.map(vm.expand.productSelection, function (item) {
                                return item.wareId;
                            });
                        }

                        if (vm.coupon.thresholdType === 1) {
                            vm.coupon.moreThanAmount = null;
                        } else if (vm.coupon.thresholdType === 2) {
                            if (!vm.coupon.moreThanAmount) {
                                return vm.$Message.warning('请填写满减金额')
                            } else if (vm.coupon.moreThanAmount > 100000) {
                                return vm.$Message.warning('满减金额超出上限')
                            }
                        }

                        if (vm.coupon.type === 1) {
                            vm.coupon.mostCouponAmountStatus = false;
                            vm.coupon.mostCouponAmount = null;
                            if (vm.coupon.couponAmount > 100000) {
                                return vm.$Message.warning('减免金额超出上限')
                            }
                        } else if (vm.coupon.type === 2) {
                            if (!vm.coupon.mostCouponAmountStatus) {
                                vm.coupon.mostCouponAmount = null;
                            } else if (vm.coupon.mostCouponAmount > 100000) {
                                return vm.$Message.warning('最多优惠金额超出上限')
                            }
                        }

                        if (vm.coupon.timeType === 1) {
                            if (!vm.coupon.timeRangeBegin || !vm.coupon.timeRangeEnd) {
                                return vm.$Message.warning('请选择用券时间');
                            }
                            var timeLimit = 12 * 3600 * 1000;
                            if (vm.coupon.timeRangeEnd.valueOf() - vm.coupon.timeRangeBegin.valueOf() < timeLimit) {
                                return vm.$Message.warning('结束时间最少要大于开始时间 12 小时');
                            }
                            if (vm.coupon.timeRangeEnd.valueOf() - new Date().valueOf() < timeLimit) {
                                vm.coupon.timeRangeEnd = null;
                                return vm.$Message.warning('结束时间最少要大于当前时间 12 小时，请重新选择');
                            }
                        } else if (vm.coupon.timeType === 2) {
                            if (!vm.expand.timeNum1) {
                                return vm.$Message.warning('请选择用券时间');
                            }
                            vm.coupon.timeNum = parseInt(vm.expand.timeNum1);
                        } else if (vm.coupon.timeType === 3) {
                            if (!vm.expand.timeNum2) {
                                return vm.$Message.warning('请选择用券时间');
                            }
                            vm.coupon.timeNum = parseInt(vm.expand.timeNum2);
                        }

                        if (vm.coupon.limitMember === 0) {
                            vm.coupon.members = []
                        } else if (vm.coupon.limitMember === 1) {
                            if (!vm.expand.memberTypeSelection || vm.expand.memberTypeSelection.length < 1) {
                                return vm.$Message.warning('请指定会员类型');
                            }
                            vm.coupon.members = vm.expand.memberTypeSelection;
                        } else if (vm.coupon.limitMember === 2) {
                            if (!vm.expand.memberLevelSelection || vm.expand.memberLevelSelection.length < 1) {
                                return vm.$Message.warning('请指定会员等级');
                            }
                            vm.coupon.members = vm.expand.memberLevelSelection;
                        } else if (vm.coupon.limitMember === 3) {
                            if (!vm.expand.memberSelection || vm.expand.memberSelection.length < 1) {
                                return vm.$Message.warning('请指定会员');
                            }
                            vm.coupon.members = $.map(vm.expand.memberSelection, function (item) {
                                return item.id;
                            });
                        }

                        if (vm.coupon.limitNumType === 0) {
                            vm.coupon.limitNum = null;
                        } else if (vm.coupon.limitNumType === 1) {
                            if (vm.coupon.limitNum < 1) {
                                return vm.$Message.warning('请输入每人限领次数');
                            }
                            vm.coupon.limitNum = parseInt(vm.coupon.limitNum);
                        }

                        vm.$Spin.show();
                        var url = vm.coupon.id ?
                            (vm.coupon.status == -2 ? '${base}manager/mall/coupon/' + vm.coupon.id : '${base}manager/mall/coupon/update_enabled/' + vm.coupon.id)
                            : '${base}manager/mall/coupon'

                        $.ajax({
                            url: url,
                            type: 'post',
                            contentType: 'application/json',
                            data: JSON.stringify(vm.coupon),
                            success: function (response) {
                                if (response.code === 200) {
                                    vm.$Message.success(response.message);
                                    window.parent.$('.layui-this span').text(vm.coupon.name);
                                    if (!vm.coupon.id) {
                                        vm.coupon.id = response.data;
                                    }
                                    vm.load()
                                    vm.copy = false;
                                } else {
                                    vm.$Message.error(response.message);
                                }
                                vm.$Spin.hide();
                            }
                        });
                    })
                },
                copyData: function () {
                    uglcw.ui.openTab('添加优惠券', '${base}manager/mall/coupon/detail?_sticky=v2&id=' + this.coupon.id + '&oper=copy');
                },
                hit: function (source, target, idName) {
                    var hit = false;
                    $(source).each(function (i, item) {
                        if (item[idName] == target[idName]) {
                            hit = true;
                            return false;
                        }
                    });
                    return hit;
                }
            }
        })
    })

</script>
</body>
</html>
