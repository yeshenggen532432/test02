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
    <link rel="stylesheet" type="text/css" href="${base}/static/newmain/layui/css/modules/laydate/default/laydate.css">
   <script type="text/javascript" src="${base}/static/newmain/layui/lay/modules/laydate.js"></script>
    <script type="text/javascript" src="${base}/static/newmain/layui/layui.js"></script>
    <link rel="stylesheet" type="text/css" href="${base}/static/newmain/css/backHome.css">

    <script src="${base}/static/newmain/framework/cframe.js"></script><!-- 仅供所有子页面使用 -->
    <script src="${base}/static/newmain/framework/echarts.min.js"></script>
    <!-- 公共样式 结束 -->

    <link rel="stylesheet" type="text/css" href="${base}/static/newmain/css/reportForm.css">

</head>
<style>
    .card-panel {
        margin-top: 18px;
        margin-left: 10px;
        margin-right: 10px;
        margin-bottom: 10px;
        height: 108px;
        color: #666;
        background: #fff;
        box-shadow: 4px 4px 40px rgba(0, 0, 0, .05);
        border-color: rgba(0, 0, 0, .05);
        border-radius: 4px;
    }

    .chart-panel {
        margin-top: 10px;
        margin-left: 10px;
        margin-right: 10px;
        margin-bottom: 10px;
        height: 300px;
        color: #666;
        background: #fff;
        box-shadow: 4px 4px 40px rgba(0, 0, 0, .05);
        border-color: rgba(0, 0, 0, .05);
        border-radius: 4px;
    }

    .chart-panelcate {
        margin-top: 10px;

        margin-right: 18px;
        margin-bottom: 10px;
        height: 300px;
        with:90%;
        color: #666;
        background: #fff;
        box-shadow: 4px 4px 40px rgba(0, 0, 0, .05);
        border-color: rgba(0, 0, 0, .05);
        border-radius: 4px;
    }

    .chart-panel1 {
        margin-top: 10px;
        margin-left: 10px;
        margin-right: 18px;
        margin-bottom: 10px;
        height: 300px;
        color: #666;
        background: #fff;
        box-shadow: 4px 4px 40px rgba(0, 0, 0, .05);
        border-color: rgba(0, 0, 0, .05);
        border-radius: 4px;
    }
    .u4_img {
        border-width: 0px;
        position: absolute;
        left: 0px;
        top: 0px;
        width: 41px;
        height: 42px;
    }
    .u12_img {
        border-width: 0px;
        position: absolute;
        left: 0px;
        top: 0px;
        width: 41px;
        height: 34px;
    }
    .u19_img {
        border-width: 0px;
        position: absolute;
        left: 0px;
        top: 0px;
        width: 35px;
        height: 42px;
    }

    .u24_img {
        border-width: 0px;
        position: absolute;
        left: 0px;
        top: 0px;
        width: 42px;
        height: 42px;
    }
    .u30_img {
        border-width: 0px;
        position: absolute;
        left: 0px;
        top: 0px;
        width: 37px;
        height: 42px;
    }
    .u4 {
        border-width: 0px;
        position: absolute;
        left: 10px;
        top: 20px;
        width: 41px;
        height: 42px;
        display: flex;
        font-family: 'Arial Normal', 'Arial';
        font-weight: 400;
        font-style: normal;
        font-size: 14px;
    }
    .u5 {
        border-width: 0px;
        position: absolute;
        left: 70px;
        top: 15px;
        width: 62px;
        height: 34px;
        display: flex;
        font-family: 'PingFangSC-Medium', 'PingFang SC Medium', 'PingFang SC';
        font-weight: 500;
        font-style: normal;
        font-size: 25px;
    }

    .u3 {
        border-width: 0px;
        position: absolute;
        left: 70px;
        top: 48px;
        width: 56px;
        height: 19px;
        display: flex;
        font-family: 'PingFangSC-Regular', 'PingFang SC';
        font-weight: 400;
        font-style: normal;
        color: #999999;
    }

    .smallCustom_5{
        float: left;
        color: #000;
        border-radius: 6px;
        overflow: hidden;
        position: relative;
        padding: 20px;
        -webkit-box-sizing: border-box;
        -moz-box-sizing: border-box;
        box-sizing: border-box;

    }

    table{
        width: 100%;
    }
     table td, table th{
        height: 25px;
        text-align: center;
    }
     table td{
        border-bottom: 1px dashed #676767;
    }
     table th{
        border-bottom: 1px solid #676767;
    }

   table .tableTitle{
        text-align: left;
    }
    table .tablePrice{
        color: #fbb80b;
    }

    .u0 {
        border-width: 0px;
        position: absolute;
        left: 171px;
        top: 639px;
        width: 197px;
        height: 90px;
        display: flex;
        font-family: 'PingFangSC-Medium', 'PingFang SC Medium', 'PingFang SC';
        font-weight: 500;
        font-style: normal;
        color: #FFFFFF;
        text-align: left;
        line-height: 25px;
    }

    .u0_div {
        border-width: 0px;
        position: absolute;
        left: 0px;
        top: 0px;
        width: 197px;
        height: 90px;
        background: inherit;
        background-color: rgba(23, 143, 255, 0.898039215686275);
        border: none;
        border-radius: 4px;
        -moz-box-shadow: none;
        -webkit-box-shadow: none;
        box-shadow: none;
        font-family: 'PingFangSC-Medium', 'PingFang SC Medium', 'PingFang SC';
        font-weight: 500;
        font-style: normal;
        color: #FFFFFF;
        text-align: left;
        line-height: 25px;
    }

    .u0 .text {
        position: absolute;
        align-self: center;
        padding: 2px 2px 2px 20px;
        box-sizing: border-box;
        width: 100%;
    }
    .u0_text {
        border-width: 0px;
        word-wrap: break-word;
        text-transform: none;
    }
</style>

<body background="#f2f2f2">
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


        </div>
    </form>

</div>
<!-- layUI 分页模块 -->
<div class="layui-container" style="background:#f2f2f2;color:#f2f2f2;width: 100%;">
    <div class="layui-row">
        <div class="layui-col-md2 card-panel">
            <div  class="u4">
                <img  class="u4_img" src="${base}/static/img/u4.png">
                <div  class="text " style="display:none; visibility: hidden">
                    <p></p>
                </div>
            </div>
            <div class="u5">
                <span id="totalSale">0</span>
            </div>
            <div class="u3">
                <span>线下销售</span>
            </div>
        </div>
        <div class="layui-col-md2 card-panel">
            <div  class="u4">
                <img  class="u12_img" src="${base}/static/img/u12.svg">
                <div  class="text " style="display:none; visibility: hidden">
                    <p></p>
                </div>
            </div>
            <div class="u5">
                <span id="mallAmt">0</span>
            </div>
            <div class="u3">
                <span>商城销售</span>
            </div>
        </div>
        <div class="layui-col-md2 card-panel">
            <div  class="u4">
                <img  class="u19_img" src="${base}/static/img/u19.svg">
                <div  class="text " style="display:none; visibility: hidden">
                    <p></p>
                </div>
            </div>
            <div class="u5">
                <span id="inputAmt">0</span>
            </div>
            <div class="u3">
                <span>会员充值</span>
            </div>
        </div>
        <div class="layui-col-md2 card-panel">
            <div  class="u4">
                <img  class="u24_img" src="${base}/static/img/u24.svg">
                <div  class="text " style="display:none; visibility: hidden">
                    <p></p>
                </div>
            </div>
            <div class="u5">
                <span id="recAmt">0</span>
            </div>
            <div class="u3">
                <span>回款金额</span>
            </div>
        </div>
        <div class="layui-col-md2 card-panel">
            <div  class="u4">
                <img  class="u30_img" src="${base}/static/img/u30.svg">
                <div  class="text " style="display:none; visibility: hidden">
                    <p></p>
                </div>
            </div>
            <div class="u5">
                <span id="saleRate">0</span>
            </div>
            <div class="u3">
                <span>销售毛利</span>
            </div>
        </div>


    </div>
    <div class="layui-row ">
        <div class="layui-col-xs6 chart-panel1">
        <div id="myReport" style="width: 100%; height: 270px;color: #fff;"></div>
        </div>
        <div class="layui-col-xs5">

            <div style="width:88%" class="chart-panelcate">

                <div style="margin-left: 50px;height:88%;">
            <div id="categorySingle" style="position:absolute;left:80px;top: 30px;height:250px;width: 300px;"></div>
                </div>
            </div>
        </div>


    </div>

    <div class="layui-row">
        <div id="u0" class="u0" data-label="浮层看板" style="z-index:1000; display:none;">
            <div id="u0_div" class="u0_div"></div>
            <div id="u0_text" class="text u0_text">
                <p><span id="orderQty" style="color:#fff;">订单数量：895</span></p><p><span id="orderAmt" style="color:#fff;">当日销售：￥300,000</span></p>
            </div>
        </div>
        <div class="layui-col-md3 chart-panel">
            <div id="saleDate" style="width: 100%; height: 270px;color: #fff;">
                <div id="dateCtrl" style="position: absolute;top:10px;height: 100%;color:#fff;width:96%;text-align:center;">

                </div>
            </div>
        </div>
        <div class="layui-col-md3 chart-panel smallCustom_5">
            <table>
                <tr>
                    <th colspan="2" class="tableTitle">单品 TOP 10</th>
                    <th class="tablePrice">金额（元）</th>
                </tr>

                <tbody id="wareList">

                </tbody>

            </table>
        </div>

        <div class="layui-col-md5 " >
            <div class="chart-panel" style="width: 85%;">
            <div id="saleChart2" style="position:absolute;left:10px;top: 30px;height:250px;width: 85%;"></div>
            </div>
        </div>


    </div>
</div>

<script type="text/javascript">

    $(function(){
        var categorySingle = [];
        var delay;
        $('.reportForm').on('click', 'a.typeBut', function () {
            $(this).siblings().removeClass('active');//.addClass('layui-btn-primary');
            $(this).addClass('active');
            clearTimeout(delay);
            setTimeout(loadData(), 300);
        });
        initChart1();
        initZhuChart1();
        sumPageStat();
        sumTypeStat();
        sumIncomeStat();
        sumWareStat();

        categorySingle1("categorySingle", categorySingle);
        laydate.render({
            elem: '#dateCtrl',
            trigger:'selectDate',
            type:'date',
            position: 'static',
            showBottom: false,
            theme:'grid',
            calendar: true,

            change:function(value,date,endDate){
                console.log("change:" + value);
                $("#u0").hide();
                sumBillStat(value,value);
                //document.getElementById('u0').display="";
            }
        });



        $("#u0").click(function()
        {
            $("#u0").hide();
        });
    })

    function loadData() {
        sumPageStat();
        sumTypeStat();
        sumIncomeStat();
        sumWareStat();

    }

    function hideu0()
    {
        $("#u0").hide();
    }

    function selectDate() {
        alert(111)

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


    var saleChart;
    function initChart1() {
        saleChart = echarts.init(document.getElementById('myReport'));

        // 指定图表的配置项和数据
        var option = {

            xAxis: {
                type: 'category',

                data: []
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
                name:'销售毛利',
                data: [],
                type: 'line',
                color:'#4ecb73',

            },
                {
                    name:'销售金额',
                    data: [],
                    type: 'line',
                    color:'#3AA1ff',

                }]
        };
        saleChart.setOption(option);


    }

    var zhuchart;

    function initZhuChart1() {
        zhuchart = echarts.init(document.getElementById('saleChart2'));


        var option = {
            tooltip: {
                trigger: 'axis',
                axisPointer: {
                    type: 'shadow'
                }
            },
            legend: {
                data: ['销售金额', '销售毛利']
            },
            grid:{
                top: 20,
                bottom: 20,
                left: 50,
                right: 50
            },
            xAxis: {
                type: 'category',

                data: ['周一', '周二', '周三', '周四', '周五', '周六', '周日']
            },
            yAxis: {
                type: 'value'
            },

            series: [
                {
                    name:'销售毛利',
                    color:'#4ecb73',
                    data: [120, 132, 101, 134, 90, 230, 210],
                    stack: '销售金额',
                    type: 'bar'
                },
                {
                name:'销售金额',
                stack: '销售金额',
                color:'#3AA1ff',
                data: [320, 332, 301, 334, 390, 330, 320],
                type: 'bar'

            }

            ]
        };

        zhuchart.setOption(option);


    }


    function categorySingleClick(obj){
        //点击事件的执行代码
        //....
        //console.log("技术栈与单排占比排行 - 点击事件"+obj.name);
    }

    var categorySingleChart;
    function categorySingle1(id,data){

        var xData = new Array();
        var yData = new Array();
        var colors = ['#6f71f0','#7eed80','#d47f4f','#f8696c','#1ca484','#fa9c24','#2977d5','#2cc6ed','#7e7c7c','#dd78e8'];

        var tag = 0;
        for (var i = 0; i < data.length; i++) {
            for (x in data[i]){
                xData.push(x);
                var temp = {
                    value: data[i][x],
                    name: x
                };
                yData.push(temp);
            }
        }

        categorySingleChart = echarts.init(document.getElementById(id));

        var option = {
            title: {
                text: '类别销售占比排行',
                subtext: '',
                left: 'left'
            },
            legend: {
                type: 'scroll',
                orient: 'vertical',
                right: 10,
                top: 20,
                bottom: 20,
                textStyle: {
                    color: '#000'
                },
//	    	selectedMode:false,//取消图例上的点击事件
                icon: 'roundRect',
                orient: 'vertical',
                data: xData
            },
            series: [
                {
                    name:'类别',
                    type:'pie',
                    center: ['35%', '50%'],
                    radius: ['60%', '75%'],

                    label: {
                        show: false,
                        position: 'center',
                    },
                    emphasis: {
                        label: {
                            show: true,
                            position: 'center',
                            formatter: '{b}\n{per|{d}%}',
                            lineHeight: 50,
                            fontSize: 20,
                            fontWeight: 'bold',
                            color: '#000',
                            rich: {
                                per: {
                                    color: '#000',
                                    padding: [2, 4],
                                    borderRadius: 2
                                }
                            }
                        },
                        labelLine: {
                            show: true
                        },
                        emphasis: {
                            itemStyle: {
                                shadowBlur: 10,
                                shadowOffsetX: 0,
                                shadowColor: 'rgba(0, 0, 0, 0.5)'
                            }
                        }

                    },
                    data: yData
                }
            ]
        };
        categorySingleChart.on("click", categorySingleClick);

        categorySingleChart.setOption(option);
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
                    $("#totalSale").html(json.totalSale );
                    $("#mallAmt").html(json.mallAmt);
                    $("#inputAmt").html(json.inputAmt);
                    //$("#stkOutAmt").html('<font>' +json.stkOutAmt+ '</font>');
                    //$("#stkInAmt").html('<font>' +json.stkInAmt+ '</font>');
                    $("#recAmt").html(json.recAmt);
                    //$("#payAmt").html('<font>' +json.payAmt+ '</font>');
                    //$("#newCstQty").html('<font>' +json.newCstQty+ '</font>');
                    //$("#newCardQty").html('<font>' +json.newCardQty+ '</font>');
                    //$("#wareQty").html('<font>' +json.wareQty+ '</font>');
                   // $("#kqQty").html('<font>' +json.kqQty+ '</font>');
                    $("#saleRate").html(json.rateAmt);

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
                    dataRefresh2(categorySingleChart, data);
                    //dataRefresh2(zhuchart,data);

                }
            }
        });
    }


    var billList = [];
    function sumIncomeStat() {
        //getStart();
        var path = "${base}/manager/queryWareStatPage_date";
        $.ajax({
            url: path,
            type: "POST",
            data: {sdate: sdate1,edate:edate1},
            dataType: 'json',
            success: function (json) {
                if (json.state) {

                    billList = json.rows;
                    refreshData();
                    refreshZhuChart();
                }
            }
        });
    }


    function dataRefresh2(myChart, data){
        var xData = new Array();
        var yData = new Array();
        var option = myChart.getOption();

        if(!myChart) {
            return;
        }


        var colors = ['#6f71f0','#7eed80','#d47f4f','#f8696c','#1ca484','#fa9c24','#2977d5','#2cc6ed','#7e7c7c','#dd78e8'];
        var tag = 0;

        for (var i = 0; i < data.length; i++) {
            for (x in data[i]){
                xData.push(x);
                var temp = {
                    value: data[i][x],
                    name: x,
                    itemStyle : {	//区域填充样式
                        color: colors[i]
                    }
                };
                yData.push(temp);
            }
        }

        option.series[0].data = yData;
        option.legend[0].data = xData;


        myChart.setOption(option);
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



    function sumBillStat(startDate,endDate) {
        //getStart();
        var path = "${base}/manager/queryBillStat_firstPage";
        $.ajax({
            url: path,
            type: "POST",
            data: {sdate: startDate,edate:endDate},
            dataType: 'json',
            success: function (json) {
                if (json.state) {

                    if(json.rows.length> 0) {
                        $("#orderQty").html('订单数量:' + json.rows[0].billQty);
                        $("#orderAmt").html('销售金额:' + json.rows[0].sumAmt);
                        $("#u0").show();
                        //$("#u0").hide(5000);
                        setTimeout(hideu0, 3000);
                    }

                }
            }
        });
    }

    function refreshData() {

        if(!saleChart) {
            return;
        }
        var xData = new Array();
        var yData = new Array();
        var yData2 = new Array();

        //更新数据
        for(var i = 0;i<billList.length;i++)
        {
            xData.push(billList[i].dateStr);

            yData.push(billList[i].disAmt);
            yData2.push(billList[i].sumAmt);
        }

        var option = {

            xAxis: {
                type: 'category',

                data: xData
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
                name:'销售毛利',
                data: yData,
                type: 'line',
                color:'#4ecb73',

            },
                {
                    name:'销售金额',
                    data: yData2,
                    type: 'line',
                    color:'#3AA1ff',

                }]
        };
        saleChart.setOption(option);
    }

    function refreshZhuChart() {

        if(!zhuchart) {
            return;
        }
        var xData = new Array();
        var yData = new Array();
        var yData2 = new Array();
        //var option = zhuchart.getOption();

        //更新数据
        for(var i = 0;i<billList.length;i++)
        {
            xData.push(billList[i].dateStr);

            yData.push(billList[i].disAmt);
            yData2.push(billList[i].sumAmt);
        }
        var option = {
            tooltip: {
                trigger: 'axis',
                axisPointer: {
                    type: 'shadow'
                }
            },
            legend: {
                data: ['销售金额', '销售毛利']
            },
            grid:{
                top: 20,
                bottom: 20,
                left: 50,
                right: 50
            },
            xAxis: {
                type: 'category',

                data: xData
            },
            yAxis: {
                type: 'value'
            },

            series: [
                {
                    name:'销售毛利',
                    color:'#4ecb73',
                    data: yData,
                    stack: '销售金额',
                    type: 'bar'
                },
                {
                    name:'销售金额',
                    stack: '销售金额',
                    color:'#3AA1ff',
                    data: yData2,
                    type: 'bar'

                }

            ]
        };

        //option.xAxis.data = xData;
        //option.series[0].data = yData;
        //option.series[1].data = yData2;
        zhuchart.setOption(option);

    }



</script>




</body>

</html>