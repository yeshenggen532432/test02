<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>营业状态</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        body {
            background-color: #fff;
            width: 100%;
            height: 100%;
            margin: 10px;
        }

        div {
            padding-top: 2px;
        }

        .layadmin-backlog-body {
            display: block;
            padding: 5px 10px;
            background-color: #f8f8f8;
            color: #999;
            border-radius: 2px;
            transition: all .3s;
            -webkit-transition: all .3s;
            margin: 5px;
            height: 160px;
            width: 200px;
        }

        .layadmin-backlog-body p cite {
            font-style: normal;
            font-size: 25px;
            font-weight: 200;
            color: #009688;
        }

        .layadmin-backlog-body h3 {
            padding-bottom: 10px;
            font-size: 12px;
        }

        .toolbar_menu button {
            color: #00a2eb;
            padding: 3px;
            cursor: pointer;
            font-size: 15px;
            margin: 2px;
        }

        .divLab {
            font-size: 20px
        }
    </style>
</head>
<body>
<div id="app" style="display: none">
    <ul>
        <li class="layadmin-backlog-body layui-col-xs2" v-for="item,i in diningList" :key="i">
            <div style="font-size: 15px">{{item.name}}<span v-if="item.peopleNumber">{{item.peopleNumber}}人</span>
                <%-- <div style="float: right;">
                     切换<select v-model="statusSelected[i]" @change="changeStatus(item,i)">
                     <option v-for="opt in diningStatusMap" :selected="opt.key==item.status"
                             :value="opt.key">{{opt.text}}
                     </option>
                 </select>
                 </div>--%>
            </div>
            <div class="divLab" :style="{'color': item.color,'border-radius': '20%'}">{{ item.statusText }}
                {{item.showDetailCount}}
                <%--下单时间,如果下单时间大于最后一次查看时间说明有新订单,需要增加提醒--%>
                <img v-if="(item.addOrderTime && item.lastLookTime==null) || (item.lastLookTime<item.addOrderTime)"
                     width="15px" src="${base}/static/uglcu/images/face/47.gif">
            </div>
            <div v-if="item.reserveTimeStr || item.startTimeStr">
                <div v-if="item.reserveTimeStr">预定时间 {{ item.reserveTimeStr }}</div>
                <div v-if="item.startTimeStr">入座时间:{{ item.startTimeStr }} 时长:{{item.startLongTimeStr}}</div>
            </div>
            <div>
                当天:({{item.dayBuyCount}})次
            </div>
            <div class="toolbar_menu" style="float: right;" v-if="item.status ==10">
                <button @click="changeStatus(item)">预定</button>
            </div>
            <div class="toolbar_menu" style="float: right;" v-if="item.status !=10">
                <button @click="addOrder(item)">点菜</button>
                <button v-if="item.status==40 || item.status==50" @click="confirmReceipt(item,1)">发厨房</button>
                <button v-if="item.status==40 || item.status==50" @click="confirmReceipt(item,2)">上菜</button>
                <button v-if="item.status==40 || item.status==50" @click="confirmReceipt(item,10)">结帐</button>
                <button @click="queryOrder(item)">订单</button>
                <button @click="leaveStatus(item,i)">客人离席</button>
            </div>
        </li>
    </ul>
</div>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script src="${base}static/uglcu/vue/vue.min.js"></script>
<script src="${base}static/uglcu/socket.io.js"></script>
<script>
    var index = layer.load(1); //换了种风格
    var vm = new Vue({
        el: '#app',
        data: {diningStatusMap: [], diningList: [], status: '', statusSelected: []},
        mounted: function () {
            layer.close(index);
            $("#app").css("display", "");
            this.loadDiningStatusMap();//加载状态
            this.loadDining();//加载列表
            this.refrefshStartTime();
        },
        methods: {
            loadDining() {
                var vm = this;
                $.ajax({
                    url: "${base}/manager/shopDiningTable/findList",
                    type: "POST",
                    data: {"page": 1, "rows": 50, "status": this.status},
                    dataType: 'json',
                    success: function (json) {
                        if (json.state) {
                            var size = json.obj.length;
                            if (size > 0) {
                                var pageable = json.obj || [];
                                pageable.filter(function (item, i) {
                                    //item.statusText = vm.getStatusStr(item.status);
                                    var color = '#009688';
                                    if (item.status == 20)
                                        color = '#13ce66';
                                    else if (item.status == 40)
                                        color = '#ff4949';
                                    item.color = color;
                                    vm.statusSelected.push(item.status);
                                })
                                vm.diningList = pageable;
                            } else {
                                vm.diningList = [];
                            }
                        }
                    }
                });
            },
            refrefshStartTime() {
                var vm = this;
                setInterval(function () {
                    vm.diningList.forEach(function (value) {
                        if (value.startTime) {
                            var mss = (new Date().getTime() - value.startTime) / 1000;
                            value.startLongTimeStr = vm.formatSeconds(mss);
                        }
                    })
                }, 1000)
            },
            formatSeconds(value) {
                var d = Math.floor(value / 60 / 60 / 24);
                var h = Math.floor(value / 60 / 60 % 24);
                var m = Math.floor(value / 60 % 60);
                var s = Math.floor(value % 60);

                h = h.toString().length == 1 ? 0 + '' + h : h;
                m = m.toString().length == 1 ? 0 + '' + m : m;
                s = s.toString().length == 1 ? 0 + '' + s : s;
                d = d ? d + '天' : '';
                return d + h + ':' + m + ':' + s;
            },
            getStatusStr(status) {
                var statusText = "";
                this.diningStatusMap.forEach(function (item) {
                    if (item.key == status) {
                        statusText = item.text;
                        return;
                    }
                });
                return statusText;
            },
            loadDiningStatusMap() {
                <c:forEach items="${diningStatusMap}" var="item">
                this.diningStatusMap.push({key:${item.key}, text: '${item.value}'});
                </c:forEach>
            },
            changeStatus(item) {
                var cuuStatus = 20;// this.statusSelected[index];
                if (cuuStatus == 20) {
                    layer.prompt({value: '', title: '请输入人数'}, function (peopleNumber, index) {
                        layer.close(index);
                        vm.updateStatus(item, cuuStatus, peopleNumber)
                    });
                } else {
                    uglcw.ui.confirm("是否确定修改状态", function () {
                        vm.updateStatus(item, cuuStatus)
                    });
                }
            }, leaveStatus: function (item, index) {
                var cuuStatus = 10;
                uglcw.ui.confirm("是否确定客户已离席", function () {
                    vm.updateStatus(item, cuuStatus)
                });
            },
            updateStatus(item, cuuStatus, peopleNumber) {
                var index = layer.load(1); //换了种风格
                var id = item.id;
                var status = cuuStatus;
                $.ajax({
                    url: '${base}manager/shopDiningTable/updateStatus',
                    data: {id: id, status: status, peopleNumber: peopleNumber},
                    type: 'post',
                    async: false,
                    success: function (resp) {
                        layer.close(index);
                        if (resp.state) {
                            layer.msg('操作成功', {icon: 1, time: 2000}, function () {
                                //loadQuickData();
                                item.peopleNumber = peopleNumber;
                                item.status = status;
                                item.statusText = vm.getStatusStr(status);
                            });

                            vm.loadDining();
                        } else {
                            layer.msg(resp.message, {icon: 2, time: 2000});
                        }
                    }
                })
            },
            addOrder(item) {
                var url = "${base}/manager/shopDiningTable/toWarePage?diningId=" + item.id;
                uglcw.ui.openTab(item.name + "点菜", url);
            },
            queryOrder(item) {
                var id = item.id;
                var name = item.name;
                var text = name + "订单";
                var url = "${base}/manager/shopBforder/toDiningPage?orderType=9&promotionId=" + id + "&startCreateTime=" + item.lastEmptyTime;
                uglcw.ui.openTab(text, url);
            },
            confirmReceipt(item, flag) {
                var url = "${base}/manager/shopDiningOrderDetail/toDiningOrderDetail?diningId=" + item.id + "&doId=" + item.currDiningOrderId + '&flag=' + flag;
                var text = '结帐';
                if (flag == 1) {
                    text = '发厨房';
                } else if (flag == 2) {
                    text = '上菜';
                }
                uglcw.ui.openTab(item.name + text, url);
            },
        }
    });
</script>
<script>
    /**
     * 前端js的 socket.emit("事件名","参数数据")方法，是触发后端自定义消息事件的时候使用的,
     * 前端js的 socket.on("事件名",匿名函数(服务器向客户端发送的数据))为监听服务器端的事件
     **/
    var socket = io.connect("http://${conf["webSocket.server"]}", {
        transports: ["websocket"]
    });
    var firstconnect = true;

    function connect() {
        if (firstconnect) {

            //socket.on('reconnect', function(){ status_update("Reconnected to Server"); });
            //socket.on('reconnecting', function( nextRetry ){ status_update("Reconnecting in "
            //+ nextRetry + " seconds"); });
            //socket.on('reconnect_failed', function(){ message("Reconnect Failed"); });
            //firstconnect = false;
        } else {
            socket.socket.reconnect();
        }
    }

    //监听服务器连接事件
    socket.on('connect', function () {
        console.log("服务器连接成功");
        var data = {"companyId": "${companyId}", "mid": "${mid}", "type": "0"};
        socket.emit('registerDiningStatus', data);
    });
    //监听服务器关闭服务事件
    socket.on('disconnect', function () {
        console.log("服务器关闭");
        //socket.disconnect();
        uglcw.ui.error('服务器断开连接')
    });

    //监听服务器关闭服务事件
    socket.on('reconnect', function () {
        console.log("服务器重连");
    });

    //监听服务器端发送消息事件
    socket.on('changeStatusMsg', function (data) {
        console.log("changeStatusMsg的消息是：" + data);
        vm.loadDining();
      /*  setTimeout(function () {
            //收到消息时刷新页面
            vm.loadDining();
        }, 2000);*/

    });
    setInterval(function () {
        vm.loadDining();
    }, 10000);

    //监听服务器端发送消息事件
    socket.on('registerDiningSuccess', function (data) {
        console.log("注册成功返回消息是：" + data);
    });
    //监听服务器端发送消息事件
    socket.on('onLineCount', function (data) {
        console.log("在线人数消息是：" + JSON.stringify(data));
    });

</script>
</body>
</html>

