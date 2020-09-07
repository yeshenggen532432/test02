<%@ taglib prefix="i" uri="http://www.springframework.org/tags/form" %>
<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>组团产品设置</title>
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

        .shopTourWare-item .ivu-form-item {
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
            <i-form ref="form" :label-width="120" :model="shopTourWare" :rules="rules">
                <divider orientation="left">基本信息</divider>
                <form-item class="main-item" label="组团名称" prop="name">
                    <i-select v-model="shopTourWare.planId" :disabled="shopTourWare.status == 1" placeholder="选择组团方案"
                              @on-change="selectTourPlan" style="width:120px">
                        <i-option v-for="item in tourPlans" :value="item.id" :key="item.name">{{ item.name }}</i-option>
                    </i-select>
                    <i-input :disabled="shopTourWare.status == 1" style="width: 200px;" required
                             v-model="shopTourWare.name"
                             placeholder="如：10人团欢乐购"></i-input>

                </form-item>
                <form-item class="main-item" label="生效时间">
                    <div style="display: flex;">
                        <form-item prop="startTime">
                            <date-picker :disabled="shopTourWare.status == 1" :options="startTimeOptions"
                                         type="datetime"
                                         format="yyyy-MM-dd HH:mm"
                                         placeholder="开始时间"
                                         v-model="shopTourWare.startTime"></date-picker>
                        </form-item>
                        <span style="margin-left: 10px;margin-right: 10px;">至</span>
                        <form-item prop="endTime">
                            <date-picker :disabled="shopTourWare.status == 1" :options="endTimeOptions" type="datetime"
                                         format="yyyy-MM-dd HH:mm"
                                         placeholder="结束时间"
                                         v-model="shopTourWare.endTime"></date-picker>
                        </form-item>
                    </div>
                </form-item>
                <form-item  class="main-item"  label="参团人数" prop="count">
                    <input-number :disabled="shopTourWare.status == 1" :min="2" :max="100"
                                  v-model="shopTourWare.count"></input-number>&nbsp<span style="color: red">请填写2-100数字</span>
                </form-item>
                <form-item class="main-item" label="选择产品" prop="wareNm">
                    <i-input :disabled="true" style="width: 200px;" v-model="shopTourWare.wareNm"></i-input>
                    <a @click="selectAllProducts" style="margin-right: 10px;">
                        <icon type="md-add"></icon>选择商品</a>
                </form-item>
                <form-item  class="main-item"  label="单位">
                    <i-select v-model="shopTourWare.wareUnit" @on-change="selectUnit" style="width:120px">
                        <i-option v-for="item in units" :value="item.value" :key="item.label">{{ item.label }}</i-option>
                    </i-select>
                </form-item>
                <%--<form-item  class="main-item"   label="单位">--%>
                <%--<i-input :disabled="true" style="width: 80px;" v-model="shopTourWare.unitName"--%>
                <%--></i-input>--%>
                <%--</form-item>--%>
                <form-item  class="main-item"  label="商城零售价" >
                    <input-number v-model="shopTourWare.shopPrice"
                                  :disabled="true"></input-number>&nbsp;元
                </form-item>

                <form-item  class="main-item"  label="组团价格" prop="price">
                    <input-number v-model="shopTourWare.price"
                                  :disabled="shopTourWare.status == 1"></input-number>&nbsp;元
                </form-item>

                <form-item class="main-item" label="团长价格" prop="headPrice">
                    <input-number v-model="shopTourWare.headPrice"
                                  :disabled="shopTourWare.status == 1"></input-number>&nbsp;元
                </form-item>


                <form-item class="main-item" label="限购数量" prop="limitQty">
                    <input-number :disabled="shopTourWare.status == 1"
                                  v-model="shopTourWare.limitQty"></input-number>&nbsp
                </form-item>
                <form-item  class="main-item"  label="排序" prop="orderCd">
                    <input-number :disabled="shopTourWare.status == 1"
                                  v-model="shopTourWare.orderCd"></input-number>&nbsp
                </form-item>
                <form-item class="main-item" label="描   述">
                    <i-input :disabled="shopTourWare.status == 1" style="width: 400px;height: 100px" type="textarea"
                             v-model="shopTourWare.description"
                             placeholder="组团描述"></i-input>
                </form-item>
            </i-form>
            </Card>
        </div>
        <div class="action-wrapper">
            <i-button style="border-radius: 0;" type="default" @click="close">关闭</i-button>
            <i-button style="border-radius: 0;" type="primary" @click="save"
                      :disabled="shopTourWare.status == 1 || shopTourWare.status == 2">保存
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
                    productSelection: [],
                    tourPlans:[],
                    units:[],
                    //maxPrice:null,
                    //minPrice:null,
                    rules: {
                        name: [
                            {required: true, message: '请输入组团名称'}
                        ],
                        wareNm: [
                            {required: true, message: '请选择商品'}
                        ],
                        count: [
                            {required: true, message: '请输入参团人数'}
                        ],
                        price: [
                            {required: true, message: '请输入组团价格'}
                        ],
                        startTime: [
                            {required: true, message: '请选择组团开始时间'}
                        ],
                        endTime: [
                            {required: true, message: '请选择组团结束时间'}
                        ]
                    },
                    shopTourWare: {
                        id: ${param.id ne null ? param.id : 'null'},
                        status: 0,
                        name: '',
                        description: '',
                        wareId:null,
                        wareNm:'',
                        startTime: null,
                        endTime: null,
                        count:2,
                        shopPrice:null,
                        price:null,
                        limitQty:null,
                        planId:null,
                        wareUnit:'B',
                        unitName:'',
                        planName:null,
                        orderCd:1
                    }
                },
                mounted: function () {
                    var vm = this;
                    //vm.loadProductCategory(null);
                    vm.loadProductGroups();
                    if (vm.shopTourWare.id) {
                        vm.load();
                    }
                    vm.loadTourPlans();
                },
                methods: {
                    selectTourPlan:function(v){
                        var vm = this
                        if(vm.tourPlans){
                            vm.tourPlans.forEach(function (value) {
                                if(value.id==v){
                                    vm.shopTourWare.name = value.name;
                                    vm.shopTourWare.planId = value.id;
                                    vm.shopTourWare.count = value.count;
                                    vm.shopTourWare.limitQty = value.limitQty;
                                    vm.shopTourWare.startTime = value.startTime ? new Date(value.startTime) : value.startTime;
                                    vm.shopTourWare.endTime = value.endTime ? new Date(value.endTime) : value.endTime;
                                }
                            })
                        }
                    },
                    selectUnit:function(v){
                        var vm = this;
                        /*var salePrice = vm.maxPrice;
                        if (v != 'B') {
                            salePrice = vm.minPrice;
                        }
                        vm.shopTourWare.shopPrice=salePrice;*/
                        if(vm.units){
                            vm.units.forEach(function (value) {
                                if(value.value==v){
                                    vm.shopTourWare.unitName = value.label;
                                    vm.shopTourWare.shopPrice=value.price;
                                }
                            })
                        }
                    },
                    load: function () {
                        var vm = this;
                        vm.$Spin.show();
                        $.ajax({
                            url: '${base}manager/shopHeadTourWare/get?id=' + vm.shopTourWare.id,
                            type: 'get',
                            success: function (response) {
                                vm.$Spin.hide();
                                if (response.success) {
                                    var shopTourWare = response.data;
                                    shopTourWare.startTime = shopTourWare.startTime ? new Date(shopTourWare.startTime) : shopTourWare.startTime;
                                    shopTourWare.endTime = shopTourWare.endTime ? new Date(shopTourWare.endTime) : shopTourWare.endTime;
                                    Object.assign(vm.shopTourWare, shopTourWare)
                                    vm.findWare(vm.shopTourWare.wareId);
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
                    loadTourPlans: function () {
                        var vm = this;
                        $.ajax({
                            url: '${base}manager/shopHeadTourPlan/list',
                            type: 'get',
                            dataType: 'json',
                            success: function (resp) {
                                vm.tourPlans = resp.obj;
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
                    selectAllProducts: function (item) {
                        this.currentItem = item;
                        var vm = this;
                        var url = '${base}manager/shopWare/page?loadGlobalLsRate=1';
                        this.selectProducts(url, false, function (data) {
                            if (data && data.length > 0) {
                                var ware = data[0];
                                var   maxPrice = ware.shopBaseMaxLsPrice;
                                /*if (ware.shopWareLsPrice || ware.shopWareSmallLsPrice) {
                                    ware.maxPrice = ware.shopWareLsPrice ? ware.shopWareLsPrice : (ware.shopWareSmallLsPrice * this.hsNum).toFixed(2);
                                }*/
                                var  minPrice = ware.shopBaseMinLsPrice;
                                /* if (ware.shopWareLsPrice || ware.shopWareSmallLsPrice) {
                                     ware.minPrice = ware.shopWareSmallLsPrice ? ware.shopWareSmallLsPrice : (ware.shopWareLsPrice / ware.hsNum).toFixed(2);
                                 }*/
                                vm.shopTourWare.wareId = ware.wareId;
                                vm.shopTourWare.wareNm = ware.wareNm;
                                vm.shopTourWare.shopPrice = maxPrice;
                                vm.shopTourWare.wareUnit='B';
                                vm.maxPrice = maxPrice;
                                vm.minPrice = minPrice;
                                /*  units=[{
                                      value:ware.maxUnitCode,
                                      label:ware.wareDw
                                  },
                                  {
                                      value:ware.minUnitCode,
                                      label:ware.minUnit
                                  }
                                  ]*/
                                let units = [];
                                units.push(
                                    {
                                        value: ware.maxUnitCode,
                                        label: ware.wareDw
                                    }
                                )
                                if (ware.minUnit) {
                                    units.push(
                                        {
                                            value: ware.minUnitCode,
                                            label: ware.minUnit
                                        }
                                    )
                                }
                                vm.units = units;
                                vm.findWare(ware.wareId);
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
                            checkbox: false,
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
                    close:function(){
                        uglcw.ui.closeCurrentTab();
                    },
                    save: function () {
                        var vm = this;
                        vm.$refs.form.validate(function (v) {
                            if (v) {
                                vm.$Spin.show();
                                var shopTourWare = Object.assign({}, vm.shopTourWare);
                                shopTourWare.startTime = uglcw.util.toString(shopTourWare.startTime, 'yyyy-MM-dd HH:mm');
                                shopTourWare.endTime = uglcw.util.toString(shopTourWare.endTime, 'yyyy-MM-dd HH:mm');
                                $.ajax({
                                    url: '${base}manager/shopHeadTourWare/save',
                                    type: 'post',
                                    contentType: 'application/json',
                                    data: JSON.stringify(shopTourWare),
                                    success: function (response) {
                                        if (response.code === 200) {
                                            vm.shopTourWare.id = response.data;
                                            vm.$Message.success(response.message);
                                            //window.parent.$('.layui-this span').text(vm.shopTourWare.name);
                                            setTimeout(function () {
                                                uglcw.ui.closeCurrentTab();
                                            },1000)
                                            uglcw.io.emit('shop_head_tour_ware_chage',1);
                                        } else {
                                            vm.$Message.error(response.message);
                                        }
                                        vm.$Spin.hide();
                                    }
                                });
                            }
                        })
                    },
                    findWare: function (wareId) {
                        $.ajax({
                            url: "${base}manager/shopWare/findById",
                            data: {"wareId": wareId},
                            type: "post",
                            success: function (response) {
                                if (response.state) {
                                    var ware = response.obj;
                                    //var   maxPrice = ware.shopBaseMaxLsPrice;
                                    /*if (ware.shopWareLsPrice || ware.shopWareSmallLsPrice) {
                                        ware.maxPrice = ware.shopWareLsPrice ? ware.shopWareLsPrice : (ware.shopWareSmallLsPrice * ware.hsNum).toFixed(2);
                                    }*/
                                    //var  minPrice =  ware.shopBaseMinLsPrice;
                                    /*if (ware.shopWareLsPrice || ware.shopWareSmallLsPrice) {
                                        ware.minPrice = ware.shopWareSmallLsPrice ? ware.shopWareSmallLsPrice : (ware.shopWareLsPrice / ware.hsNum).toFixed(2);
                                    }*/
                                    /*units=[{
                                        value:ware.maxUnitCode,
                                        label:ware.wareDw
                                    },
                                        {
                                            value:ware.minUnitCode,
                                            label:ware.minUnit
                                        }
                                    ]*/
                                    let units = [];
                                    units.push(
                                        {
                                            value: ware.maxUnitCode,
                                            label: ware.wareDw,
                                            price:ware.shopBaseMaxLsPrice
                                        }
                                    )
                                    if (ware.minUnit) {
                                        units.push(
                                            {
                                                value: ware.minUnitCode,
                                                label: ware.minUnit,
                                                price:ware.shopBaseMinLsPrice
                                            }
                                        )
                                    }

                                    vm.units= units;
                                    /*vm.maxPrice = maxPrice;
                                    vm.minPrice = minPrice;*/
                                    vm.shopTourWare.unitName=ware.wareDw;
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
