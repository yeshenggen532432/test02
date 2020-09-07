<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>促销规则设置</title>
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

        .reward-item .ivu-form-item {
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
            <i-form ref="form" :label-width="120" :model="reward" :rules="rules">
                <divider orientation="left">基本信息</divider>
                <form-item class="main-item" label="活动名称" prop="title">
                    <i-input :disabled="but_disabled" style="width: 300px;" required v-model="reward.title"
                             placeholder="如：国庆满减活动，最多20个字"></i-input>
                </form-item>
                <form-item class="main-item" label="活动时间">
                    <div style="display: flex;">
                        <form-item prop="startTime">
                            <date-picker :disabled="but_disabled" :options="startTimeOptions" type="datetime"
                                         format="yyyy-MM-dd HH:mm"
                                         placeholder="开始时间"
                                         v-model="reward.startTime"></date-picker>
                        </form-item>
                        <span style="margin-left: 10px;margin-right: 10px;">至</span>
                        <form-item prop="endTime">
                            <date-picker :disabled="but_disabled" :options="endTimeOptions" type="datetime"
                                         format="yyyy-MM-dd HH:mm"
                                         placeholder="结束时间"
                                         v-model="reward.endTime"></date-picker>
                        </form-item>
                    </div>
                </form-item>
                <form-item class="main-item" label="备    注">
                    <i-input :disabled="but_disabled" style="width: 400px;" type="textarea"
                             v-model="reward.description"
                             placeholder="活动备注"></i-input>
                </form-item>
                <divider orientation="left">活动规则</divider>

                <form-item class="main-item" label="活动说明" style="overflow:hidden">
                    <a @click="if(rewardRemarksHeight==100){rewardRemarksHeight=30;rewardRemarksText='显示'}else{rewardRemarksHeight=100;rewardRemarksText='隐藏'}">{{rewardRemarksText}}</a>
                    <div :style="{ backgroundColor:'aliceblue',overflow:'hidden',height: rewardRemarksHeight + 'px' }">
                        1.同一时间或存在交叉时间的所有促销方案关联的商品一律不执行多个方案，只执行该商品相关联的优先级方案。<br/>
                        2.方案优先顺序：指定商品>指定商品分类>全部商品。<br/>
                        3.如果单方案设立多个指定的商品或分类商品或全部商品,是指所指定内商品同时下单可合并计算促销，不是各商品单独计算促销。
                    </div>
                </form-item>

                <form-item class="main-item" label="活动商品" prop="goodsRangeType">
                    <div style="display: grid;">
                        <radio-group v-model="reward.goodsRangeType" :disabled="but_disabled">
                            <radio :disabled="but_disabled" :label="0">全部商品可用</radio>
                            <radio :disabled="but_disabled" :label="1">指定商品类别可用</radio>
                            <radio :disabled="but_disabled" :label="3">指定商品可用 <span
                                    v-if="reward.products.length > 0">({{reward.products.length}})</span>
                            </radio>
                        </radio-group>
                        <div v-if="reward.goodsRangeType == 3">
                            <a @click="selectNoRewareProducts" style="margin-right: 10px;">
                                <icon type="md-add"></icon>
                                选择商品 ({{reward.products.length}})</a>
                            <a @click="batchRemoveProduct" style="margin-right: 10px;">
                                <icon type="ios-trash-outline"></icon>
                                批量删除</a>

                            <i-table :height="300" style="width: 600px;" size="small" :columns="productColumns"
                                     @on-select="onProductSelect"
                                     @on-select-all="onProductSelect"
                                     @on-select-change="onProductSelect"
                                     :data="reward.products"></i-table>
                        </div>
                        <div v-if="reward.goodsRangeType == 1">
                            <a @click="loadProductCategory" style="margin-right: 10px;">
                                点击<span v-if="categoryLoaded">重新</span>加载分类</a>

                            <tree ref="productCategory" :data="productCategories"
                                  show-checkbox></tree>
                        </div>
                    </div>
                </form-item>

                <form-item class="main-item" label="优惠设置">
                    <div style="display: grid">
                        <radio-group v-model="reward.activityType" :disabled="but_disabled">
                            <radio :label="1" :disabled="but_disabled">满N元减/送</radio>
                            <radio :label="0" :disabled="but_disabled">满N件减/送</radio>
                        </radio-group>

                        <radio-group v-model="reward.rewardType" @on-change="onCyclicChange">
                            <radio :label="0" :disabled="but_disabled">阶梯满减</radio>
                            <radio :label="1" :disabled="but_disabled">循环满减</radio>
                        </radio-group>
                        <!--阶梯满减-->
                        <div v-if="reward.rewardType == 0">
                            <div class="reward-item" v-for="item,i in reward.items" :key="i">
                                <div class="item-header">
                                    <span>{{i+1}}级优惠</span>
                                    <a v-if="i!=0" @click="removeItem(i)">删除</a>
                                </div>
                                <i-form :label-width="80" :model="item" :rules="tieredItemRules">
                                    <form-item label="优惠门槛" prop="meetAmount">
                                        满&nbsp;<input-number :disabled="but_disabled" :min="0"
                                                             v-model="item.meetAmount"></input-number>&nbsp;{{reward.activityType==1?
                                        '元': '件'}}
                                    </form-item>
                                    <form-item label="优惠内容">
                                        <div style="display: grid;">
                                            <checkbox :disabled="but_disabled" v-model="item.saveOrderAmt" style="width:150px"
                                                      @on-change="if(item.saveOrderAmt)item.rewardMode=1;">订单金额优惠
                                            </checkbox>
                                            <radio-group :disabled="but_disabled" class="sub-item" vertical
                                                         v-if="item.saveOrderAmt"
                                                         v-model="item.rewardMode">
                                                <radio :label="1" checked  style="width:150px">
                                                    减
                                                    <input-number :min="0" v-model="item.cash"
                                                                  :disabled="but_disabled || item.rewardMode!=1"></input-number>
                                                    元
                                                </radio>
                                                <radio :label="2" style="width:150px">
                                                    打
                                                    <input-number placeholder="1-99" :min="1" :max="99" :setp="1" :active-change="false"
                                                                  v-model="item.discount"
                                                                  :disabled="but_disabled || item.rewardMode!=2"></input-number>
                                                    折 <span style="color: gray;">1-99</span>&nbsp;&nbsp;(如：{{item.discount}}=单价*{{item.discount/100}})
                                                </radio>
                                            </radio-group>
                                        </div>
                                    </form-item>
                                    <form-item class="none-label" label=" ">
                                        <div style="display: grid;">
                                            <checkbox v-model="item.postage" :disabled="but_disabled || 1==1">包邮
                                            </checkbox>
                                            <div class="sub-item">
                                                <a v-if="item.postage" @click="toSelectArea(item)">请选择区域</a>
                                                <div v-if="item.regionNames.length > 0">
                                                    <span v-text="item.regionNames.slice(0, 10).join('、')"></span>
                                                    <poptip :width="600" trigger="hover" :word-wrap="true" title="已选区域"
                                                            :content="item.regionNames.join('、')">
                                                        <span v-if="item.regionNames.length > 10">({{item.regionNames.length}})...</span>
                                                    </poptip>
                                                </div>
                                                <span class="item-desc">同一订单，若部分商品满足包邮，那该订单的所有商品都包邮。</span>
                                            </div>
                                        </div>
                                    </form-item>
                                    <form-item class="none-label" label=" ">
                                        <div style="display: grid;">
                                            <checkbox disabled v-model="item.sendScore">
                                                送
                                                <input-number v-model="item.score"
                                                              :disabled="!item.sendScore"></input-number>
                                                积分
                                            </checkbox>
                                            <div class="sub-item">
                                            <span class="item-desc">送积分是订单基础积分上额外赠送，如：
                                                订单本身100积分，本次设置送20积分，则该笔订单总共产生120积分。</span>
                                            </div>
                                        </div>
                                    </form-item>
                                    <form-item class="none-label" label=" ">
                                        <div style="display: grid;">
                                            <checkbox disabled v-model="item.sendCoupon">送优惠券</checkbox>
                                            <div class="sub-item">
                                                <a v-if="item.sendCoupon">添加优惠券</a>
                                            </div>
                                        </div>
                                    </form-item>
                                    <form-item class="none-label" label=" ">
                                        <div style="display: grid;">
                                            <checkbox v-model="item.sendPresent" :disabled="but_disabled" style="width:150px">送赠品
                                            </checkbox>
                                            <div class="sub-item" v-if="item.sendPresent">
                                                <%--<span class="item-desc">仅支持购买实物商品送赠品</span>--%>
                                                <span class="item-desc">
                                                    1.赠品备注：<i-input
                                                        style="width: 300px;" maxLength="20" required
                                                        v-model="item.product_source_memo"
                                                        placeholder="如：可选择商品或输入赠送名称，最多20个字"></i-input></span>
                                                <a @click="selectAllProducts(item)">2.添加赠品</a>
                                                <i-table :height="100" style="width: 600px;" size="small"
                                                         :columns="productsSourceColumns(i)"
                                                         @on-select="onProductSelect"
                                                         @on-select-all="onProductSelect"
                                                         @on-select-change="onProductSelect"
                                                         :data="item.products_source"></i-table>
                                            </div>
                                        </div>
                                    </form-item>
                                </i-form>
                            </div>
                            <divider v-if="reward.items.length <5" dashed style="margin: 5px 0;"></divider>
                            <div class="setting-add" v-if="reward.items.length <5">
                                <a @click="addItem">添加 {{reward.items.length+1}} 级优惠</a>
                                <p>提醒：每级优惠不叠加，如：满足二级优惠条件后则不再享有一级优惠。最多支持五级优惠。</p>
                            </div>
                        </div>
                        <!--阶梯满减-->
                        <!--循环满减-->
                        <div v-else>
                            <i-form :label-width="80" v-for="item,i in reward.items" :key="i">
                                <form-item label="优惠门槛">
                                    每满&nbsp;<input-number :disabled="but_disabled"
                                                          v-model="item.meetAmount"></input-number>&nbsp;{{reward.activityType==1?
                                    '元': '件'}}
                                </form-item>
                                <form-item label="优惠内容">
                                    <div style="display: grid;">
                                        <checkbox v-model="item.saveOrderAmt" :disabled="but_disabled">
                                            减&nbsp;<input-number v-model="item.cash"
                                                                 :disabled="but_disabled || !item.saveOrderAmt"></input-number>&nbsp;元
                                        </checkbox>
                                    </div>
                                </form-item>
                                <form-item class="none-label" label=" ">
                                    <div style="display: grid;">
                                        <checkbox v-model="item.postage" :disabled="but_disabled || 1==1">包邮
                                        </checkbox v-model="item.postage">
                                        <div class="sub-item">
                                            <a v-if="item.postage && reward.state == 0" @click="toSelectArea(item)">请选择区域</a>
                                            <div v-if="item.regionNames.length > 0">
                                                <span v-text="item.regionNames.slice(0, 10).join('、')"></span>
                                                <poptip :width="600" trigger="hover" :word-wrap="true" title="已选区域"
                                                        :content="item.regionNames.join('、')">
                                                    <span v-if="item.regionNames.length > 10">({{item.regionNames.length}})...</span>
                                                </poptip>
                                            </div>
                                            <span class="item-desc">同一订单，若部分商品满足包邮，那该订单的所有商品都包邮。</span>
                                        </div>
                                    </div>
                                </form-item>
                                <form-item class="none-label" label=" ">
                                    <div style="display: grid;">
                                        <checkbox disabled v-model="item.sendScore">
                                            送
                                            <input-number v-model="item.score"
                                                          :disabled="!item.sendScore"></input-number>
                                            积分
                                        </checkbox>
                                        <div class="sub-item">
                                            <span class="item-desc">送积分是订单基础积分上额外赠送，如：
                                                订单本身100积分，本次设置送20积分，则该笔订单总共产生120积分。</span>
                                        </div>
                                    </div>
                                </form-item>
                                <form-item class="none-label" label=" ">
                                    <div style="display: grid;">
                                        <checkbox disabled v-model="item.sendCoupon">送优惠券</checkbox>
                                        <div class="sub-item">
                                            <a v-if="item.sendCoupon">添加优惠券</a>
                                        </div>
                                    </div>
                                </form-item>
                                <form-item class="none-label" label=" ">
                                    <div style="display: grid;">
                                        <checkbox v-model="item.sendPresent" :disabled="but_disabled">送赠品
                                        </checkbox>
                                        <div class="sub-item">
                                            <a v-if="item.sendPresent">添加赠品</a>
                                            <%--<span class="item-desc">仅支持购买实物商品送赠品</span>--%>
                                            <div class="sub-item" v-if="item.sendPresent">
                                                <%--<span class="item-desc">仅支持购买实物商品送赠品</span>--%>
                                                <span class="item-desc">
                                                    1.赠品备注：<i-input
                                                        style="width: 300px;" maxLength="20" required
                                                        v-model="item.product_source_memo"
                                                        placeholder="如：可选择商品或输入赠送名称，最多20个字"></i-input></span>
                                                <a @click="selectAllProducts(item)">2.添加赠品</a>
                                                <i-table :height="100" style="width: 600px;" size="small"
                                                         :columns="productsSourceColumns(i)"
                                                         @on-select="onProductSelect"
                                                         @on-select-all="onProductSelect"
                                                         @on-select-change="onProductSelect"
                                                         :data="item.products_source"></i-table>
                                            </div>
                                        </div>
                                    </div>
                                </form-item>
                            </i-form>
                        </div>
                        <!--循环满减-->
                    </div>
                </form-item>
            </i-form>
            </Card>
        </div>
        <modal :closable="false" v-model="showImage">
            <img :src="previewUrl" style="width: 100%;">
        </modal>
        <i-backTop :height="200" :bottom="100"></i-backTop>
        <modal @on-ok="addMember" class="member-selector" :closable="false" v-model="showMemberSelector" :width="600"
               style="padding: 0;">
            <tabs @on-click="onMemberTypeChange" v-model="memberQuery.source">
                <tab-pane name="1" label="常规"></tab-pane>
                <tab-pane name="2" label="员工"></tab-pane>
                <tab-pane name="3" label="经销存客户"></tab-pane>
                <tab-pane name="4" label="门店"></tab-pane>
            </tabs>
            <i-table size="small" :columns="memberSelectorColumns" :data="members" :height="350"
                     @on-select="onMemberSelectorSelectChange"
                     @on-select-all="onMemberSelectorSelectChange"
                     @on-select-change="onMemberSelectorSelectChange"
            >
            </i-table>
            <page style="margin: 5px;" :current="memberQuery.page" :total="memberTotal" size="small" show-elevator
                  @on-change="onMemberPageChange"
                  show-total/>
        </modal>
        <modal @on-ok="onAreaSelect" title="请选择区域" :width="600" v-model="showAreaSelector" :closable="true">
            <row slot="header">
                <i-col span="24">
                    <checkbox @click.prevent.native="checkAllArea"
                              v-model="allAreaChecked"
                    >全选
                    </checkbox>
                </i-col>
            </row>
            <row>
                <i-col span="8" v-for="area in areas" :key="area.areaId" style="margin-bottom: 5px;">
                    <div>
                        <checkbox class="area-item"
                                  @click.prevent.native="checkArea(area)"
                                  :label="area.areaId"
                                  :indeterminate="area.indeterminate" v-model="area.checkAll"
                                  :class="{'area-toggle': area.showChildren}">
                            {{area.areaName}} <span style="color: #57a3f3;" v-if="area.checked.length>0">({{area.checked.length}})</span>
                        </checkbox>
                        <icon @click.native="toggleAreaChildren(area)" class="area-icon"
                              :class="{'area-toggle': area.showChildren}"
                              :type="area.showChildren ? 'ios-arrow-back' : 'ios-arrow-down'"></icon>
                        <div v-if="area.showChildren" class="area-children">
                            <div class="area-children-group">
                                <checkbox-group v-model="area.checked" @on-change="onAreaChildrenChange(area, event)">
                                    <checkbox :label="child.areaId" v-for="child in area.children" :key="child.areaId"
                                              :true-value="child.areaId">
                                        {{child.areaName}}
                                    </checkbox>
                                </checkbox-group>
                            </div>
                        </div>
                    </div>
                </i-col>
            </row>
        </modal>
        <div class="action-wrapper">
            <i-button style="border-radius: 0;" type="default" @click="cancel">取消</i-button>
            <i-button style="border-radius: 0;" type="primary" @click="save"
                      :disabled="but_disabled">保存
            </i-button>
            <i-button v-if="reward.runStatus == 2" style="border-radius: 0;" type="default"
                      @click="copy">复制规则
            </i-button>

        </div>
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
                but_disabled:false,
                rewardRemarksHeight: 100,
                rewardRemarksText: '隐藏',
                categoryLoaded: false,
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
                currentItem: null,
                showAreaSelector: false,
                areas: [],
                memberQuery: {
                    page: 0,
                    rows: 10,
                    source: '1'
                },
                memberTotal: 0,
                members: [],
                previewUrl: '',
                showMemberSelector: false,
                showImage: false,
                productSelection: [],
                memberSelection: [],
                memberSelectorSelection: [],
                productColumns: [
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
                                                vm.reward.products.splice(params.index, 1);
                                            }
                                        })
                                    }
                                }
                            }, '删除');
                        }
                    }
                ],
                memberColumns: [
                    {type: 'selection', width: 50, fixed: 'left'},
                    {title: '会员名称', key: 'name', width: 100},
                    {title: '电话', key: 'mobile', width: 110},
                    {
                        title: '头像', key: 'pic', width: 100, render: function (h, params) {
                            var row = params.row;
                            return h('img', {
                                domProps: {
                                    src: row.pic
                                },
                                style: {
                                    width: '50px',
                                    height: '50px'
                                },
                                on: {
                                    click: function () {
                                        vm.preview(row.pic);
                                    }
                                }
                            })
                        }
                    },
                    {title: '昵称', key: 'nickname', width: 100},
                    {
                        title: '操作', fixed: 'right', width: 100, render: function (h, params) {
                            return h('i-button', {
                                on: {
                                    click: function () {
                                        vm.$Modal.confirm({
                                            title: '确定删除吗?',
                                            onOk: function () {
                                                vm.reward.members.splice(params.index, 1);
                                            }
                                        })
                                    }
                                }
                            }, '删除');
                        }
                    }
                ],
                memberSelectorColumns: [
                    {type: 'selection', width: 50, fixed: 'left'},
                    {title: '会员名称', key: 'name', width: 100},
                    {title: '电话', key: 'mobile', width: 110},
                    {title: '会员等级', key: 'gradeName', width: 100},
                    {
                        title: '头像', key: 'pic', width: 100, render: function (h, params) {
                            var row = params.row;
                            return h('img', {
                                domProps: {
                                    src: row.pic
                                },
                                style: {
                                    width: '50px',
                                    height: '50px'
                                },
                                on: {
                                    click: function () {
                                        vm.preview(row.pic);
                                    }
                                }
                            })
                        }
                    },
                    {title: '昵称', key: 'nickname', width: 100}
                ],
                productCategoryColumns: [
                    {title: '商品类别', key: 'wareType'},
                    {title: '类别图片', key: 'wareTypePic'},
                    {
                        title: '操作', width: 100, render: function (h, params) {

                        }, fixed: 'right'
                    }
                ],
                showCategorySelector: false,
                productCategories: [],
                tieredItemRules: {
                    meetAmount: [
                        {required: true, message: '请输入优惠门槛金额'}
                    ]
                },
                rules: {
                    title: [
                        {required: true, message: '请输入活动名称'}
                    ],
                    startTime: [
                        {required: true, message: '请选择活动开始时间'}
                    ],
                    endTime: [
                        {required: true, message: '请选择活动结束时间'}
                    ],
                    goodsRangeType: [
                        {required: true, message: '请选择活动商品'}
                    ],
                    rewardType: [
                        {required: true}
                    ]
                },
                memberLevels: [], //会员等级
                reward: {
                    state: 0,
                    status: 1,
                    amountLimit: null,
                    title: '',
                    description: '',
                    id: ${param.id ne null ? param.id : 'null'},
                    activityType: 1, //1 满N元  0满N减
                    startTime: null,
                    endTime: null,
                    productCategoryIds: [], //商品类别
                    memberLevelIds: [],
                    goodsRangeType: 0,
                    memberRangeType: 0,
                    items: [
                        {
                            saveOrderAmt: false, //是否优惠订单金额
                            rewardMode: 0, //1 减免金额 2打折
                            meetAmount: null, //满
                            cash: 0, //减
                            discount: 0, //打折
                            postage: false, //是否包邮
                            regionIds: [], //区域ID
                            regionNames: [], //区域名称
                            score: 0, //积分
                            sendScore: false, //是否赠送积分
                            sendCoupon: false, //是否赠送优惠券
                            coupons: [], //优惠券列表
                            sendPresent: false, //是否赠送赠品
                            presents: [], //赠品

                            products_source: [],//赠品资源
                            product_source_memo: null
                        }
                    ],
                    rewardType: 0,
                    memberLevels: [],
                    products: [],//限制商品
                    categories: [],
                    members: []
                }
            },
            mounted: function () {
                var vm = this;
                vm.loadMemberLevels();
                //vm.loadProductCategory(null);
                vm.loadProductGroups();
                vm.loadAreas();
                if (vm.reward.id) {
                    vm.load();
                }
            },
            methods: {
                productsSourceColumns: function (level) {
                    var vm = this;
                    return [
                        /*{type: 'selection', width: 50, fixed: 'left'},*/
                        {title: '商品名称', key: 'wareNm'},
                        {
                            title: '商品规格', key: 'wareGg', render: function (h, params) {
                                var row = params.row;
                                var idx = params.index;
                                var options = [];
                                if (row.wareGg || row.wareDw) {
                                    options.push(
                                        h('i-option', {
                                            props: {
                                                value: row.maxUnitCode
                                            }
                                        }, row.wareGg + row.wareDw)
                                    )
                                }
                                if (row.minWareGg || row.minUnit) {
                                    options.push(h('i-option', {
                                        props: {
                                            value: row.minUnitCode
                                        }
                                    }, row.minWareGg + row.minUnit))
                                }
                                return h('i-select', {
                                        props: {
                                            transfer: true,
                                            value: row.unitCode
                                        },
                                        on: {
                                            'on-change': function (v) {
                                                console.log(v);
                                                vm.reward.items[level].products_source[idx].unitCode = v;
                                            }
                                        }
                                    },
                                    options
                                )
                            }
                        }, {
                            title: '操作', fixed: 'right', width: 100, render: function (h, params) {
                                return h('i-button', {
                                    on: {
                                        click: function () {
                                            vm.$Modal.confirm({
                                                title: '确定删除吗?',
                                                onOk: function () {
                                                    vm.reward.items[level].products_source.splice(params.index, 1);
                                                }
                                            })
                                        }
                                    }
                                }, '删除');
                            }
                        }
                    ]
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
                    };
                    $(vm.productCategories).each(function (i, category) {
                        visit(category);
                    })
                },
                load: function () {
                    var vm = this;
                    vm.$Spin.show();
                    $.ajax({
                        url: '${base}manager/mall/reward/detail/' + vm.reward.id,
                        type: 'get',
                        success: function (response) {
                            vm.$Spin.hide();
                            if (response.success) {
                                var reward = response.data;
                                vm.but_disabled=(reward.state==1||reward.state==2)?true:false;
                                reward.startTime = reward.startTime ? new Date(reward.startTime) : reward.startTime;
                                reward.endTime = reward.endTime ? new Date(reward.endTime) : reward.endTime;
                                reward.products = reward.products || [];
                                reward.members = reward.members || [];
                                reward.memberLevelIds = reward.memberLevelIds || [];
                                reward.productCategoryIds = reward.productCategoryIds || [];

                                $(reward.items).each(function (i, item) {
                                    item.saveOrderAmt = !!(item.cash || item.discount);
                                    item.regionIds = item.regionIds || [];
                                    item.regionNames = item.regionNames || [];
                                    item.coupons = item.coupons || [];

                                    //加载赠品
                                    if (item.presentIds && item.sendPresent) {
                                        var presentIdsJSON = JSON.parse(item.presentIds);
                                        item.product_source_memo = presentIdsJSON.product_source_memo;
                                        //加载商品信息
                                        if (presentIdsJSON.products_source && presentIdsJSON.products_source.length > 0) {
                                            var wareData = presentIdsJSON.products_source[0];
                                            vm.findWare(wareData.wareId, function (data) {
                                                if (data) {
                                                    data.unitCode = wareData.unitCode;
                                                    vm.$set(item, 'products_source', [data]);
                                                }
                                            });
                                        }
                                    }
                                });
                                Object.assign(vm.reward, reward);

                                //限制商品为类别
                                if (reward.goodsRangeType === 1) {
                                    vm.loadProductCategory(null, function () {
                                        vm.checkProductCategory(reward.productCategoryIds);
                                    });//加载分类zzx

                                }
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
                checkAllArea: function () {
                    var vm = this;
                    vm.allAreaChecked = !vm.allAreaChecked;
                    var checked = vm.allAreaChecked;
                    $.map(vm.areas, function (item) {
                        item.checkAll = checked;
                        item.checked = checked ? $.map(item.children, function (child) {
                            return child.areaId
                        }) : [];
                        item.indeterminate = false;
                        $.map(item.children, function (child) {
                            child.checked = checked;
                        })
                    })
                },
                onAreaSelect: function () {
                    var vm = this;
                    var item = vm.currentItem;
                    item.regionIds = [];
                    item.regionNames = [];
                    $.map(vm.areas, function (area) {
                        if (area.indeterminate || area.checkAll) {
                            item.regionIds.push(area.areaId);
                            if (area.checkAll) {
                                //全选时只放省份名称
                                item.regionNames.push(area.areaName);
                            }
                        }
                        $.map(area.children, function (child) {
                            if (area.checked.indexOf(child.areaId) !== -1) {
                                item.regionIds.push(child.areaId);
                                if (!area.checkAll) {
                                    //省份全选时不存市名称
                                    item.regionNames.push(child.areaName);
                                }
                            }
                        })
                    })
                },
                resetArea: function () {
                    var vm = this;
                    var currentItem = vm.currentItem;
                    $(vm.areas).each(function (i, item) {
                        item.checkAll = false;
                        item.checked = [];
                        item.showChildren = false;
                        item.indeterminate = false;
                        $.map(item.children, function (child) {
                            if (currentItem.regionIds.indexOf(child.areaId) !== -1) {
                                child.checked = true;
                                item.checked.push(child.areaId);
                            } else {
                                child.checked = false;
                            }
                        })
                        if (item.checked.length > 0 && item.checked.length === item.children.length) {
                            item.checkAll = true;
                        } else if (item.checked.length > 0) {
                            item.indeterminate = true;
                        } else if (currentItem.regionIds.indexOf(item.areaId) !== -1 && item.children.length === 0) {
                            item.checkAll = true
                        }
                    })
                },
                checkArea: function (area) {
                    var vm = this;
                    vm.$nextTick(function () {
                        if (area.indeterminate) {
                            area.checkAll = false;
                        } else {
                            area.checkAll = !area.checkAll;
                        }
                        area.indeterminate = false;
                        if (area.checkAll) {
                            area.checked = $.map(area.children, function (child) {
                                return child.areaId
                            });
                        } else {
                            area.checked = [];
                        }
                    })
                },
                onAreaChildrenChange: function (area) {
                    if (area.checked.length === area.children.length) {
                        area.checkAll = true;
                        area.indeterminate = false;
                    } else if (area.checked.length > 0) {
                        area.indeterminate = true;
                        area.checkAll = false;
                    } else {
                        area.indeterminate = false;
                        area.checkAll = false;
                    }
                },
                toggleAreaChildren: function (area) {
                    var vm = this;
                    var show = !area.showChildren;
                    $.each(vm.areas, function (i, item) {
                        item.showChildren = false;
                    });
                    this.$set(area, 'showChildren', show);
                },
                toSelectArea: function (item) {
                    this.currentItem = item;
                    this.resetArea();
                    this.showAreaSelector = true;
                },
                loadAreas: function () {
                    var vm = this;
                    $.ajax({
                        url: '${base}manager/shopArea',
                        type: 'get',
                        dataType: 'json',
                        success: function (response) {
                            var areas = response.data || [];
                            $.map(areas, function (area) {
                                area.showChildren = false;
                                area.indeterminate = false;
                                area.checkAll = false;
                                area.checked = [];
                                $.map(area.children, function (child) {
                                    child.checked = false;
                                })
                            });
                            vm.areas = areas;
                        }
                    })
                },
                onMemberSelectorSelectChange: function (selection) {
                    this.memberSelectorSelection = selection;
                },
                onMemberPageChange: function (page) {
                    this.memberQuery.page = page - 1;
                    this.loadMember();
                },
                onMemberTypeChange: function () {
                    this.memberQuery.page = 0;
                    this.loadMember();
                },
                addMember: function () {
                    var vm = this;
                    $(vm.memberSelectorSelection).each(function (idx, item) {
                        if (!vm.hit(vm.reward.members, item, 'memId')) {
                            vm.reward.members.push(item);
                        }
                    });
                },
                loadMember: function () {
                    var vm = this;
                    vm.memberQuery.page += 1;
                    $.ajax({
                        url: '${base}manager/shopMember/shopMemberPage',
                        data: vm.memberQuery,
                        type: 'get',
                        dataType: 'json',
                        success: function (response) {
                            vm.members = response.rows || [];
                            vm.memberTotal = response.total || 0;
                        }
                    })
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
                },
                selectMember: function () {
                    this.memberQuery.page = 0;
                    this.loadMember();
                    this.showMemberSelector = true;
                },
                onMemberSelect: function (selection) {
                    this.memberSelection = selection;
                },
                batchRemoveProduct: function () {
                    var vm = this;
                    if (vm.productSelection.length < 1) {
                        return vm.$Message.warning('请选择要删除的商品');
                    }
                    vm.reward.products = $.map(vm.reward.products, function (item) {
                        if (!vm.hit(vm.productSelection, item, 'wareId')) {
                            return item;
                        }
                    });
                },
                batchRemoveMember: function () {
                    var vm = this;
                    if (vm.memberSelection.length < 1) {
                        return vm.$Message.warning('请选择要删除的会员');
                    }
                    vm.reward.members = $.map(vm.reward.members, function (item) {
                        if (!vm.hit(vm.memberSelection, item, 'memId')) {
                            return item;
                        }
                    });
                },
                onProductSelect: function (selection) {
                    this.productSelection = selection;
                },
                preview: function (url) {
                    this.previewUrl = url;
                    this.showImage = true;
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
                loadProductCategory: function (item, callback) {
                    var vm = this;
                    if (!vm.reward.startTime || !vm.reward.endTime) {
                        uglcw.ui.error('请选择活动中心日期');
                        return;
                    }
                    var startTime = new Date(vm.reward.startTime).getTime();
                    var endTime = new Date(vm.reward.endTime).getTime();
                    var id = null;
                    if (item) {
                        if (item.state === 'open') {
                            return;
                        }
                        item.loading = true;
                        id = item.id;
                    }
                    $.ajax({
                        url: '${base}manager/mall/reward/shop/waretypes',
                        type: 'get',
                        data: {"startTime": startTime, "endTime": endTime, "rewardId": vm.reward.id},
                        dataType: 'json',
                        success: function (response) {
                            vm.categoryLoaded = true;
                            var existsWareTypeIdList = response.data.existsWareTypeIdList;
                            response = uglcw.util.arrayToTree(response.data.sysWaretypesList, {
                                parent: 'waretypePid',
                                id: 'waretypeId'
                            });
                            var visit = function (nodes) {
                                if (nodes && nodes.length > 0) {
                                    $.map(nodes, function (node) {
                                        node.label = node.waretypeNm;
                                        node.title = node.waretypeNm;
                                        node.value = node.waretypeId;
                                        //默认选择别的活动已存在分类，并禁用
                                        if (existsWareTypeIdList && existsWareTypeIdList.length > 0) {
                                            if (existsWareTypeIdList.indexOf(node.waretypeId + "") > -1) {
                                                node.disableCheckbox = true;
                                                node.checked = true;
                                            }
                                        }
                                        if (node.children && node.children.length > 0) {
                                            node.loading = false;
                                            visit(node.children);
                                        } else if (node.state === 'closed') {
                                            node.loading = false;
                                            node.children = [];
                                        }
                                    })
                                }
                            };
                            visit(response);
                            if (item) {
                                item.children = response || [];
                                item.loading = false;
                            }
                            //callback(response);
                            vm.productCategories = response;
                            if (callback) {
                                callback()
                            }
                        },
                        error: function () {
                            if (item) {
                                item.loading = false;
                            }
                        }
                    })
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
                selectNoRewareProducts: function () {
                    var vm = this;
                    if (!vm.reward.startTime || !vm.reward.endTime) {
                        uglcw.ui.error('请选择活动中心日期');
                        return;
                    }
                    var startTime = new Date(vm.reward.startTime).getTime();
                    var endTime = new Date(vm.reward.endTime).getTime();
                    var rewardId = vm.reward.id;
                    rewardId = rewardId ? rewardId : "";
                    var url = '${base}manager/mall/reward/warePage?objectType=3&startTime=' + startTime + "&endTime=" + endTime + "&rewardId=" + rewardId;
                    this.selectProducts(url, true, function (data) {
                        if (vm.existsWares && vm.existsWares.length > 0 && data && data.length > 0) {
                            for (var i = data.length - 1; i >= 0; i--) {
                                if (vm.existsWares.indexOf(data[i].wareId + "") > -1) {
                                    data.splice(i, 1);
                                }
                            }
                        }
                        //过滤已存在商品，不能重复增加
                        if (data && data.length > 0 && vm.reward.products && vm.reward.products.length > 0) {
                            /*for (var i = data.length - 1; i >= 0; i--) {
                                $(vm.reward.products).each(function (j, item) {
                                    if (item.wareId == data[i].wareId) {
                                        data.splice(i, 1);
                                        return;
                                    }
                                })
                            }*/
                            $(vm.reward.products).each(function (j, item) {
                                for (var i = data.length - 1; i >= 0; i--) {
                                    if (item.wareId == data[i].wareId) {
                                        data.splice(i, 1);
                                        return;
                                    }
                                }
                            })
                        }
                        vm.reward.products = vm.reward.products.concat(data);
                    });
                },
                selectAllProducts: function (item) {
                    this.currentItem = item;
                    var vm = this;
                    var url = '${base}manager/shopWare/page';
                    this.selectProducts(url, false, function (data) {
                        if (data && data.length > 0) {
                            data = $.map(data, function (item) {
                                item.unitCode = item.maxUnitCode;
                                return item;
                            })
                        }
                        vm.$set(vm.currentItem, 'products_source', data);
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
                                var existsWares = response.existsWareIdList || []
                                vm.existsWares = existsWares;
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
                            /*{field: 'wareGg', title: '规格', width: 120},
                            {field: 'inPrice', title: '采购价格', width: 120},
                            {field: 'stkQty', title: '库存数量', width: 120},*/
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
                                            //
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
                addItem: function () {
                    if (this.reward.items.length >= 5) {
                        return this.$Message.warning('优惠阶梯不能超过五级');
                    }
                    this.reward.items.push({
                        saveOrderAmt: false,
                        rewardMode: 0,
                        meetAmount: null,
                        cash: 0,
                        discount: 0,
                        postage: false,
                        score: 0,
                        sendScore: false,
                        sendCoupon: false,
                        sendPresent: false,
                        regionIds: [],
                        regionNames: []
                    })
                },
                removeItem: function (i) {
                    this.reward.items.splice(i, 1);
                },
                onCyclicChange: function () {
                    this.reward.items = [{
                        level: 1,
                        saveOrderAmt: false,
                        rewardMode: 0,
                        meetAmount: null,
                        cash: 0,
                        discount: 0,
                        postage: false,
                        score: 0,
                        sendScore: false,
                        sendCoupon: false,
                        sendPresent: false,
                        regionIds: [],
                        regionNames: []
                    }]
                },
                save: function () {
                    var vm = this;
                    vm.$refs.form.validate(function (v) {
                        if (v) {
                            vm.$Spin.show();
                            var reward = Object.assign({}, vm.reward);
                            reward.startTime = uglcw.util.toString(reward.startTime, 'yyyy-MM-dd HH:mm');
                            reward.endTime = uglcw.util.toString(reward.endTime, 'yyyy-MM-dd HH:mm');
                            var valid = true;


                            $(reward.items).each(function (i, item) {
                                item.level = i + 1;
                                if (!item.meetAmount) {
                                    vm.$Message.error('请设置优惠门槛');
                                    valid = false;
                                    return false;
                                }

                                if (!item.postage) {
                                    item.regionIds = [];
                                    item.regionNames = [];
                                }
                                if (!item.saveOrderAmt) {
                                    item.cash = 0;
                                    item.discount = 0;
                                    item.rewardMode = 0;
                                }
                                //循环满减
                                if (reward.rewardType === 1 && item.saveOrderAmt) {
                                    item.rewardMode = 1
                                }

                                if (item.sendPresent) {
                                    if (item.products_source && item.products_source.length > 0) {
                                        item.products_source = $.map(item.products_source, function (p) {
                                            return {
                                                wareId: p.wareId,
                                                qty: 1,
                                                unitCode: p.unitCode
                                            }
                                        })
                                    }
                                    if (item.product_source_memo) {
                                        item.product_source_memo = item.product_source_memo;
                                    }
                                    if (!item.products_source && !item.product_source_memo) {
                                        valid = false;
                                        vm.$Message.error('请选择赠品或输入商品名称');
                                        return;
                                    }
                                    //item.presentIds=presentIds;
                                }

                            });
                            if (!valid) {
                                vm.$Spin.hide();
                                return;
                            }
                            if (reward.goodsRangeType === 3) {
                                reward.productIds = $.map(reward.products, function (product) {
                                    return product.wareId;
                                });
                            } else {
                                reward.productIds = [];
                            }

                            if (reward.goodsRangeType === 1) {
                                reward.productCategoryIds = $.map(vm.$refs.productCategory.getCheckedNodes(), function (c) {
                                    if (!c.disableCheckbox)
                                        return c.value;
                                });
                            } else {
                                reward.productCategoryIds = [];
                            }

                            if (reward.memberRangeType === 3) {
                                reward.memberLevelIds = [];
                                reward.memberTypeIds = [];
                                reward.memberIds = $.map(reward.members, function (member) {
                                    return member.memId;
                                })
                            }

                            $.ajax({
                                url: '${base}manager/mall/reward',
                                type: 'post',
                                contentType: 'application/json',
                                data: JSON.stringify(reward),
                                success: function (response) {
                                    if (response.code === 200) {
                                        vm.reward.id = response.data;
                                        vm.$Message.success(response.message);
                                        //vm.load();
                                        //window.parent.$('.layui-this span').text(vm.reward.title);
                                        setTimeout(function () {
                                            uglcw.io.emit('shop_reward_chage',1);
                                            uglcw.ui.closeCurrentTab();
                                        },1000);
                                    } else {
                                        vm.$Message.error(response.message);
                                    }
                                    vm.$Spin.hide();
                                }
                            });
                        }
                    })
                },
                copy: function () {
                    var vm = this;
                    vm.$Spin.show();
                    vm.reward.state = 0;
                    vm.reward.id = "";
                    //vm.reward.title=null;
                    //vm.reward.startTime=new Date();
                    if (vm.reward.items && vm.reward.items.length > 0)
                        vm.reward.items.forEach(function (value) {
                            value.id = "";
                        })
                    setTimeout(function () {
                        vm.$Spin.hide();
                        window.parent.$('.layui-this span').text('复制规则');
                    }, 500)
                },
                cancel: function () {
                    uglcw.ui.closeCurrentTab();
                    //uglcw.ui.openTab('促销规则设置', '${base}manager/mall/reward/index');
                },
                findWare: function (wareId, callback) {
                    $.ajax({
                        url: "${base}manager/shopWare/findById",
                        data: {"wareId": wareId},
                        type: "post",
                        success: function (response) {
                            if (response.state) {
                                var data = response.obj;
                                console.log(data);
                                callback(data);
                            }
                        }, error: function (error) {

                        }
                    });
                }
            }
        })
    })

</script>
</body>
</html>
