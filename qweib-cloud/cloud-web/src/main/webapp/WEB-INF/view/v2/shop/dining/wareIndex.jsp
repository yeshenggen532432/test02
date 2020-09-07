<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>点菜</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>

        body {
            background-color: #fff;
            width: 100%;
            height: 100%;
            margin: 10px;
        }

        cite {
            cursor: pointer;
        }

        .layadmin-backlog-body {
            text-align: center;
            display: block;
            padding: 10px 15px;
            background-color: #f8f8f8;
            color: #999;
            border-radius: 20px;
            margin: 5px;
            height: 180px;
            width: 150px;
        }

        p {
            margin: 5px;
        }

        .layadmin-backlog-body span {
            font-style: normal;
            font-size: 15px;
            font-weight: 200;
            color: #009688;
            cursor: pointer;
        }

        .layadmin-backlog-body p cite {
            font-style: normal;
            font-size: 15px;
            font-weight: 200;
            color: #303133;
            background-color: #eee;
            border-radius: 10%;
        }

        .layadmin-backlog-body p .selected {
            background: #fbebee;
            color: #fa436a;
        }

    </style>
</head>
<body>
<div id="app" style="display: none">
    <div :style="{'width':leftOrderWidth+'px',float:'left',height:'500px', border:'1px solid #999'}">
        <div>
            <button class="layui-btn layui-btn-danger" @click="submitOrder">提交订单</button>
            合计:{{orderAmount}}
        </div>
        <table style="width:100%;margin: 15px;">
            <thead style="font-weight: bold">
            <tr style="height: 25px;">
                <td width="150px">菜单</td>
                <td width="100px">规格</td>
                <td width="50">单价</td>
                <td width="100" style="text-align: center">数量</td>
            </tr>
            </thead>
            <tbody>
            <tr v-for="item,i in buyWareList">
                <td>{{item.wareNm}}</td>
                <td>{{item.detailWareGg}}{{item.wareDw}}</td>
                <td>{{item.wareDj}}</td>
                <td><a href="javascript:;" style="margin-right: 5px" @click="wareNumAdd(item,-1)">-</a>
                    <input v-model="item.wareNum" style="align-content:center;width: 40px;"
                           @change="wareNumChange(item)">
                    <a href="javascript:;" style="margin-left: 5px;" @click="wareNumAdd(item,1)">+</a></td>
            </tr>
            </tbody>
        </table>
    </div>

    <div :style="{float:'right',width:rightWareListWidth+'px'}">
        <ul>
            <li class="layadmin-backlog-body layui-col-xs2" v-for="item,i in wareList" :key="i"
                @click="selectItem(item)">
                <img v-if="item.pic" :src="item.pic" style="width: 80px;height: 80px">
                <p>{{item.wareNm}}</p>
                <p>
                    <cite :class="{ selected: item.selectedMax }" @click="selectSpec(item, item.maxUnitCode)"
                          @click.stop
                          v-if="item.wareDw || item.wareGg">{{item.wareGg}}{{item.wareDw}}/{{item.shopBaseMaxLsPrice}}</cite>
                    <cite :class="{ selected: item.selectedMin}" @click="selectSpec(item, item.minUnitCode)" @click.stop
                          v-if="item.minUnit || item.minWareGg">{{item.minWareGg}}{{item.minUnit}}/{{item.shopBaseMinLsPrice}}</cite>
                </p>
                <p>
                    <%-- <span style="margin-right: 5px"
                           @click="wareNumAdd(item,-1)">-</span>
                         <input v-model="item.wareNum" style="align-content:center;width: 40px;"
                                @change="wareNumChange(item)">
                         <span style="margin-left: 5px;" @click="wareNumAdd(item,1)">+</span>
                     </p>--%>
            </li>
        </ul>
    </div>


</div>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script src="${base}static/uglcu/vue/vue.min.js"></script>
<script>
    var index = layer.load(1); //换了种风格
    var base = '${base}';
    var vm = new Vue({
        el: '#app',
        data: {wareList: [], buyWareList: [], orderAmount: 0.00, leftOrderWidth: 350, rightWareListWidth: 600},
        mounted: function () {
            layer.close(index);
            $("#app").css("display", "");
            this.loadWare();
            let point = this.findDimensions();
            this.rightWareListWidth = point.width - this.leftOrderWidth - 50;
        },
        methods: {
            loadWare: function () {
                var vm = this;
                $.ajax({
                    url: "${base}/manager/shopWare/page?loadGlobalLsRate=1&showPic=1",
                    type: "POST",
                    data: {"page": 1, "rows": 50},
                    dataType: 'json',
                    success: function (page) {
                        if (page && page.rows && page.rows.length > 0) {
                            page.rows.filter(function (item) {
                                vm.selectSpec(item, item.maxUnitCode, 0);
                                item.detailShopWareAlias = item.shopWareAlias;
                                item.detailWareNm = item.wareNm;
                                item.xsTp = '正常销售';
                                item.wareNum = 0;
                                if (item.warePicList && item.warePicList.length > 0)
                                    item.pic = base + 'upload' + item.warePicList[0].picMini;
                            })
                            vm.wareList = page.rows || [];
                        }
                    }
                });
            },
            selectItem(item) {
                if (!(item.minUnit || item.minWareGg)) this.selectSpec(item, item.maxUnitCode);
                else
                    uglcw.ui.info('请选择规格!');
            },
            selectSpec(item, unitCode, wareNum) {
                if (unitCode == item.maxUnitCode) {
                    item.selectedMax = true;
                    item.selectedMin = false;
                    item.detailWareGg = item.wareGg || '';
                    item.wareDj = item.shopBaseMaxLsPrice;
                    item.beUnit = item.maxUnitCode;
                    item.wareDjOriginal = item.wareDj;
                    item.wareDw = item.wareDw;
                } else {
                    item.selectedMin = true;
                    item.selectedMax = false;
                    item.detailWareGg = item.minWareGg || '';
                    item.wareDj = item.shopBaseMinLsPrice;
                    item.beUnit = item.minUnitCode;
                    item.wareDjOriginal = item.wareDj;
                    item.wareDw = item.minUnit;
                }
                if (wareNum != 0) {
                    item.wareNum = 1;
                    this.showDetail(item);
                }
            },
            wareNumAdd(item, num) {
                item.wareNum = item.wareNum + num;
                item.wareNum = item.wareNum < 0 ? 0 : item.wareNum;
                this.showDetail(item);
            },
            wareNumChange(item) {
                item.wareNum = item.wareNum < 0 ? 0 : item.wareNum;
                this.showDetail(item);
            },
            showDetail(item) {
                var vm = this;
                //验证是否存在同商品同规格
                let exists = false;
                vm.buyWareList.forEach(function (value, index) {
                    if ((value.wareId + value.beUnit) == (item.wareId + item.beUnit)) {
                        value.wareNum = item.wareNum;
                        value.wareZj = item.wareDj * item.wareNum;//总价(最终单价*数量)
                        exists = true;
                        if (item.wareNum == 0) {
                            vm.del(index)
                        }
                        return;
                    }
                })

                if (!exists) {
                    item.wareZj = item.wareDj * item.wareNum;//总价(最终单价*数量)
                    let temp = JSON.parse(JSON.stringify(item));
                    vm.buyWareList.push(temp);
                }
                vm.orderAmount = 0;
                vm.buyWareList.forEach(function (value) {
                    vm.orderAmount = (parseFloat(vm.orderAmount) + value.wareZj).toFixed(2);
                })

            },
            del(i) {
                var vm = this;
                vm.buyWareList.splice(i, 1);
            },
            submitOrder() {
                var vm = this;
                let form = {};
                form.diningId =${diningId};
                form.wareStr = JSON.stringify(vm.buyWareList);
                uglcw.ui.confirm('是否确认提交？', function () {
                    uglcw.ui.loading();
                    $.ajax({
                        url: '${base}manager/shopDiningOrder/saveSaleorder',
                        type: 'post',
                        dataType: 'json',
                        data: form,
                        success: function (json) {
                            uglcw.ui.loaded();
                            if (json.state) {
                                uglcw.ui.success(json.message);
                                vm.reset();
                                setTimeout(function () {
                                    uglcw.ui.closeCurrentTab();
                                }, 1500)
                            } else {
                                uglcw.ui.error(json.message || '保存失败');
                            }
                        },
                        error: function () {
                            uglcw.ui.loaded()
                        }
                    })
                })
            },
            reset() {
                vm.buyWareList = [];
                vm.orderAmount = 0;
            },
            findDimensions() {//函数：获取尺寸
                var point = {};
                //获取窗口宽度
                point.width = window.innerWidth || 1000;
                point.height = window.innerHeight || 1000;
                return point;
            }
        }
    });
</script>

</body>
</html>

