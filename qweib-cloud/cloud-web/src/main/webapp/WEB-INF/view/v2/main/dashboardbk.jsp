<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,Chrome=1">
    <!-- Google Chrome Frame也可以让IE用上Chrome的引擎: -->
    <meta name="renderer" content="webkit">
    <!--国产浏览器高速模式-->
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="author" content="sys" />
    <!-- 作者 -->
    <meta name="revised" content="sys.v3, 2019/05/01" />
    <!-- 定义页面的最新版本 -->
    <meta name="description" content="网站简介" />
    <!-- 网站简介 -->
    <meta name="keywords" content="搜索关键字，以半角英文逗号隔开" />
    <title>后台管理</title>

    <!-- 公共样式 开始 -->
    <link rel="stylesheet" type="text/css" href="${base}/static/newmain/css/base.css">
    <link rel="stylesheet" type="text/css" href="${base}/static/newmain/fonts/iconfont.css">
    <script type="text/javascript" src="${base}/static/newmain/framework/jquery-1.11.3.min.js"></script>
    <link rel="stylesheet" type="text/css" href="${base}/static/newmain/layui/css/layui.css">
    <script type="text/javascript" src="${base}/static/newmain/layui/layui.js"></script>
    <link rel="stylesheet" type="text/css" href="${base}/static/newmain/css/backHome.css">
    <script type="text/javascript" src="${base}/static/newmain/js/backHome.js" ></script>
    <script src="${base}/static/newmain/framework/cframe.js"></script><!-- 仅供所有子页面使用 -->
    <!-- 公共样式 结束 -->

    <link rel="stylesheet" type="text/css" href="${base}/static/newmain/css/reportForm.css">

</head>

<body>
<div class="cBody">
    <div class="console">
        <form class="layui-form" action="">
            <div class="layui-form-item">
                <div class="reportForm">
                    <a data-range="1" class="typeBut bl active">本周</a>
                    <a data-range="2" class="typeBut">上周</a>
                    <a data-range="3" class="typeBut">本月</a>
                    <a data-range="4" class="typeBut br">上月</a>
                </div>
                <div class="layui-input-inline">

                </div>
                <button class="layui-btn" lay-submit lay-filter="submitBut" onclick="loadData();">刷新</button>

            </div>
        </form>

    </div>

    <div class="reportForm_main">
        <div class="collectData">
            <div class="layui-row">
                <div class="layui-col-md3 br">
                    <div class="layui-col-md6">
                        <div class="title">零售金额</div>
                        <div class="nums" id="posAmt"><font>1</font></div>
                    </div>
                    <div class="layui-col-md6">
                        <div class="title">商城销售</div>
                        <div class="nums" id="mallAmt"><font>0</font></div>
                    </div>
                </div>
                <div class="layui-col-md3 br">
                    <div class="layui-col-md6">
                        <div class="title">批发金额</div>
                        <div class="nums" id="stkOutAmt"><font>1</font></div>
                    </div>
                    <div class="layui-col-md6">
                        <div class="title">会员充值</div>
                        <div class="nums" id="inputAmt"><font>1</font></div>
                    </div>
                </div>
                <div class="layui-col-md2">
                    <div class="title">采购金额</div>
                    <div class="nums" id="stkInAmt"><font>115.20</font></div>
                </div>
                <div class="layui-col-md2">
                    <div class="title">回款金额</div>
                    <div class="nums" id="recAmt"><font>0.00</font></div>
                </div>
                <div class="layui-col-md2">
                    <div class="title">付款金额</div>
                    <div class="nums" id="payAmt"><font>115.20</font></div>
                </div>
            </div>
        </div>

        <div class="reportType_tj">
            <form class="layui-form" action="">
                <div class="layui-input-inline">
                    <select name="reportType" id="reportType" lay-filter="reportType" onchange="selectChg();">
                        <option value="0">销售单数</option>
                        <option value="1">销售金额</option>
                    </select>
                </div>
                <div class="layui-input-inline">


                </div>
                <div class="changeRate">

                    <div class="layui-col-md6 right">
                        <!--上升-->
                        <!--<span class="data up">-99.42%<i class="iconfont icon-xiangshangjiantoucuxiao"></i></span>-->
                        <!--下降-->
                        <!--<span class="data">-99.42%<i class="iconfont icon-xiangxiajiantoucuxiao"></i></span>
                        <span class="text">相比上周期</span>-->
                    </div>
                </div>
                <div id="myReport" style="width: 100%; height: 400px;"></div>
                <script src="${base}/static/newmain/framework/echarts.min.js"></script>
                <script type="text/javascript">
                    // 基于准备好的dom，初始化echarts实例
                    var myChart = echarts.init(document.getElementById('myReport'));

                    // 指定图表的配置项和数据
                    var option = {
                        xAxis: {
                            type: 'category',
                            boundaryGap: false,
                            data: ['2018-03-01', '2018-03-02', '2018-03-03', '2018-03-04', '2018-03-05', '2018-03-06', '2018-03-07']
                        },
                        yAxis: {
                            type: 'value'
                        },
                        grid:{
                            top: 20,
                            bottom: 20,
                            left: 50,
                            right: 50
                        },
                        series: [{
                            data: [820, 932, 901, 934, 1290, 1330, 1320],
                            type: 'line'

                        }]
                    };
                    myChart.setOption(option);

                    function refreshData(data,_this) {
                        $(_this).addClass("active");
                        $(_this).siblings().removeClass("active");
                        if(!myChart) {
                            return;
                        }

                        //更新数据
                        var option = myChart.getOption();
                        option.series[0].data = data;
                        myChart.setOption(option);
                    }
                </script>
            </form>

        </div>


    </div>
    <div class="row m_t">
        <div class="custom_8-5 categorySingle">
            <div class="title">类别销售占比排行</div>

            <div class="con">
                <div id="categorySingle"></div>
                <div class="top no_mr">
                    <div class="smallCustom_5">
                        <table>
                            <tr>
                                <th colspan="2" class="tableTitle">类别 TOP 10</th>
                                <th class="tablePrice">金额（元）</th>
                            </tr>
                            <tbody id="typeList">

                            </tbody>
                        </table>
                    </div>
                    <div class="smallCustom_5">
                        <table>
                            <tr>
                                <th colspan="2" class="tableTitle">单品 TOP 10</th>
                                <th class="tablePrice">金额（元）</th>
                            </tr>

                            <tbody id="wareList">

                            </tbody>

                        </table>
                    </div>
                </div>
            </div>
        </div>
        <div class="custom_3-5 no_mr businessData">
            <div class="title">营业数据</div>
            <div id="businessData" style="width: 100%; height:100%;"></div>
        </div>
    </div>
    <div class="h_10"></div>
</div>
<!-- layUI 分页模块 -->


<script>
    $(function(){
        var categorySingle = [];//[{"HTML":1000},{"前端":3100},{"CSS":3200},{"Javascript":3400},{"Jquery":4200},{"C++":5010},{"汇编":1010},{"ES5":2010},{"ES6":3010},{"ES7":4010}];
        //营业数据
        var business = [{"已付款":1000, "订单数":1000},{"未处理订单":3100, "订单数":2370},{"待付款":3200, "订单数":3640}]
        $("#reportType").change(function(){

            selectChg();

        });
        init(categorySingle, business);
        layui.use(['form','laydate', 'layer', 'laypage'], function() {
            var form = layui.form;
            var laydate = layui.laydate;
            var laypage = layui.laypage,
                layer = layui.layer;

            //监听提交
            form.on('submit(submitBut)', function(data) {
                layer.msg(JSON.stringify(data.field));
                return false;
            });
            laydate.render({
                elem: '#time'
                ,range: true
            });
            //select监听
            form.on('select(reportType)', function(data){
                console.log(data.elem); //得到select原始DOM对象
                console.log(data.value); //得到被选中的值
                console.log(data.othis); //得到美化后的DOM对象
            });


            //总页数大于页码总数
            laypage.render({
                elem: 'pages'
                ,count: 5
                ,layout: ['prev', 'page', 'next', 'limit', 'skip']
                ,jump: function(obj){
                    console.log(obj)
                }
            });
        });

        var delay;
        $('.reportForm').on('click', 'a.typeBut', function () {
            $(this).siblings().removeClass('active');//.addClass('layui-btn-primary');
            $(this).addClass('active');
            clearTimeout(delay);
            setTimeout(loadData(), 300);
        })

        loadData();
    })
    function categorySingleClick(obj){
        //点击事件的执行代码
        //....
        //console.log("技术栈与单排占比排行 - 点击事件"+obj.name);
    }

    function timeFormat(date) {
        var ret;
        var fmt ="YYYY-mm-dd";
        var opt = {
            "Y+": date.getFullYear().toString(),        // 年
            "m+": (date.getMonth() + 1).toString(),     // 月
            "d+": date.getDate().toString(),            // 日
            "H+": date.getHours().toString(),           // 时
            "M+": date.getMinutes().toString(),         // 分
            "S+": date.getSeconds().toString()          // 秒
            // 有其他格式化字符需求可以继续添加，必须转化成字符串
        };
        for (var k in opt) {
            ret = new RegExp("(" + k + ")").exec(fmt);
            if (ret) {
                fmt = fmt.replace(ret[1], (ret[1].length == 1) ? (opt[k]) : (opt[k].padStart(ret[1].length, "0")))
            };
        };
        return fmt;
    }

    function timeFormat1(date) {
             if (!date || typeof(date) === "string") {
                     this.error("参数异常，请检查...");
                 }
             var y = date.getFullYear(); //年
             var m = date.getMonth() + 1; //月
             var d = date.getDate(); //日

             return y + "-" + m + "-" + d;
    }

    function getFirstDayOfWeek (date) {

            var weekday = date.getDay()||7; //获取星期几,getDay()返回值是 0（周日） 到 6（周六） 之间的一个整数。0||7为7，即weekday的值为1-7
             date.setDate(date.getDate()-weekday+1);//往前算（weekday-1）天，年份、月份会自动变化
             return timeFormat(date);
    }

    function getLastDayOfWeek (date) {

        var weekday = date.getDay()||7; //获取星期几,getDay()返回值是 0（周日） 到 6（周六） 之间的一个整数。0||7为7，即weekday的值为1-7
        date.setDate(date.getDate()-weekday-1);//往前算（weekday-1）天，年份、月份会自动变化
        return timeFormat(date);
    }

    function getFirstDayLastWeek()
    {
        var now = new Date();
        now.setDate(now.getDate() - parseInt(7));
        return getFirstDayOfWeek(now);
    }

    function getFirstDayOfMonth (date) {
             date.setDate(1);
             return timeFormat(date);
    }

    function getFirstDayLastMonth() {
        var firstdate = new Date(new Date().getFullYear(), new Date().getMonth()-1, 1);
        return timeFormat(firstdate);

    }

    function getEndDayLastMonth() {

        var date = new Date();
        var day = new Date(date.getFullYear(), date.getMonth(), 0).getDate();
        var enddate = new Date(new Date().getFullYear(), new Date().getMonth()-1, day);
        return timeFormat(enddate);

    }

    function loadData() {
        sumPageStat();
        sumTypeStat();
        sumWareStat();
        sumBillStat();
    }

    var sdate1="",edate1="";
    function getStart() {
        var el = $('.reportForm .active');
        var range = el.data('range');
        if(range ==1)//本周
        {
            sdate1 =getFirstDayOfWeek(new Date());
            edate1 = timeFormat(new Date());
        }
        if(range ==2)
        {
            sdate1 = getFirstDayLastWeek();
            edate1 = getLastDayOfWeek(new Date());
        }
        if(range ==3)
        {
            sdate1 = getFirstDayOfMonth(new Date());
            edate1 = timeFormat(new Date());
        }
        if(range ==4)
        {
            sdate1 = getFirstDayLastMonth();
            edate1 = getEndDayLastMonth();

        }

    }


    function sumPageStat() {
        getStart();
        var path = "${base}/manager/pos/sumPageStat";
        $.ajax({
            url: path,
            type: "POST",
            data: {sdate: sdate1,edate:edate1},
            dataType: 'json',
            success: function (json) {
                if (json.state) {
                    $("#posAmt").html('<font>' +json.posAmt + '</font>');
                    $("#mallAmt").html('<font>' +json.mallAmt+ '</font>');
                    $("#inputAmt").html('<font>' +json.inputAmt+ '</font>');
                    $("#stkOutAmt").html('<font>' +json.stkOutAmt+ '</font>');
                    $("#stkInAmt").html('<font>' +json.stkInAmt+ '</font>');
                    $("#recAmt").html('<font>' +json.recAmt+ '</font>');
                    $("#payAmt").html('<font>' +json.payAmt+ '</font>');
                    $("#newCstQty").html('<font>' +json.newCstQty+ '</font>');
                    $("#newCardQty").html('<font>' +json.newCardQty+ '</font>');
                    $("#wareQty").html('<font>' +json.wareQty+ '</font>');
                    $("#kqQty").html('<font>' +json.kqQty+ '</font>');
                    $("#bfQty").html('<font>' +json.bfQty+ '</font>');

                }
            }
        });
    }

    function sumTypeStat() {
        getStart();
        var path = "${base}/manager/queryWareTypeStat_firstPage";
        $.ajax({
            url: path,
            type: "POST",
            data: {sdate: sdate1,edate:edate1},
            dataType: 'json',
            success: function (json) {
                if (json.state) {
                    var rows = json.rows;
                    var html = "";
                    var data = [];

                    for(var i = 0;i<rows.length;i++)
                    {
                        var seq = 1 + i;
                        var row ='<tr>';
                        row = row +'<td width="20%">' + seq + '</td>';
                        row = row + '<td width="40%">' +rows[i].typeName + '</td>';
                        row = row + '<td width="40%">' +rows[i].sumAmt + '</td>';
                        html += row;
                        var map ={};
                        map[rows[i].typeName] = rows[i].sumAmt;
                        //var obj = '{"' + rows[i].typeName + '":' + rows[i].sumAmt + "}";
                        data.push(map);
                        //if(i == 0)data = data + obj;
                        //else data = data + ',' + obj;
                    }
                    $("#typeList").html(html);
                    //data.push(data1);
                    //data = data + ']';
                    dataRefresh1(categorySingleChart, data);

                }
            }
        });
    }

    function sumWareStat() {
        getStart();
        var path = "${base}/manager/queryWareStat_firstPage";
        $.ajax({
            url: path,
            type: "POST",
            data: {sdate: sdate1,edate:edate1},
            dataType: 'json',
            success: function (json) {
                if (json.state) {
                    var rows = json.rows;
                    var html = "";
                    var data = [];

                    for(var i = 0;i<rows.length;i++)
                    {
                        var seq = 1 + i;
                        var row ='<tr>';
                        row = row +'<td width="20%">' + seq + '</td>';
                        row = row + '<td width="40%">' +rows[i].typeName + '</td>';
                        row = row + '<td width="40%">' +rows[i].sumAmt + '</td>';
                        html += row;

                    }
                    $("#wareList").html(html);


                }
            }
        });
    }

    var billList = [];
    function sumBillStat() {
        getStart();
        var path = "${base}/manager/queryBillStat_firstPage";
        $.ajax({
            url: path,
            type: "POST",
            data: {sdate: sdate1,edate:edate1},
            dataType: 'json',
            success: function (json) {
                if (json.state) {
                    billList = json.rows;
                    selectChg();


                }
            }
        });
    }

    function refreshData(valueType) {

        if(!myChart) {
            return;
        }
        var xData = new Array();
        var yData = new Array();
        var option = myChart.getOption();

        //更新数据
        for(var i = 0;i<billList.length;i++)
        {
            xData.push(billList[i].dateStr);
            if(valueType==0)//订单数量
                yData.push(billList[i].billQty);
            else yData.push(billList[i].sumAmt);
        }
        option.xAxis.data = xData;
        option.series[0].data = yData;
        myChart.setOption(option);
    }

    function selectChg() {

        var oOpt = document.getElementById('reportType');
        var oOptVal = oOpt.options[oOpt.selectedIndex].value;
        refreshData(oOptVal);
    }
</script>



</div>
</body>

</html>