<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<%@ taglib prefix="tag" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="permission" uri="/WEB-INF/tlds/permission.tld" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>工作台</title>
    <link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/posstyle/css/workbench.css"/>
    <link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/easyui/easyui.css"/>
    <link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/easyui/icon.css"/>
    <link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/posstyle/css/base.css"/>
    <script type="text/javascript" src="<%=basePath %>/resource/WdatePicker.js"></script>

</head>
<body>
<div class="container">
    <div id="hd">

    </div>

    <div id="bd">
        <div class="bd-content">
            <div class="right-zone">



            </div>
            <div class="center-part">
                <div id="tb" style="padding:0 30px;">
                <div class="conditions">
                    起止日期: <input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
                    <img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
                    -
                    <input name="edate" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
                    <img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
                    连锁店: <select name="shopName" id="shopName">
                    <option value="">全部</option>

                </select>
                    <a href="javascript:querySaleAnalyse();" class="easyui-linkbutton" iconCls="icon-search" data-options="selected:true">查询</a>

                </div>
                </div>
                <div class="center-items chart0 clearfix">
                    <div class="chart0-item">
                        <div class="item-inner">
                            <div class="item-content">
                                <div class="content-hd">收入组成分布图</div>
                                <div class="chart-chart" id="chart0"></div>
                            </div>
                        </div>
                    </div>
                    <div class="chart0-item">
                        <div class="item-inner">
                            <div class="item-content">
                                <div class="content-hd">预收款和营业收入对比图</div>
                                <div class="chart-chart" id="chart1"></div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="center-items chart1">
                    <div class="chart1-inner">
                        <div class="item-hd">年月收入变化图</div>
                        <div class="chart1-chart" id="chart3"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="ft"></div>
</div>
<div class="todo-panel">
    <div class="todo-title">
        <i class="iconfont">&#xe61f;</i>
        <span class="num">14&nbsp;<span class="unit">个</span></span>
        <label>待办未处理</label>
    </div>
    <div class="todo-items">
        <ul>







        </ul>
    </div>

</div>
<script type="text/javascript" src="<%=basePath%>/resource/jquery-1.8.0.min.js"></script>
<script type="text/javascript" src="<%=basePath %>/resource/jquery.easyui.min.js"></script>
<!-- <script type="text/javascript" src="js/menu.js"></script> -->
<script type="text/javascript" src="<%=basePath %>/resource/posstyle/js/echarts-all.js"></script>


<input type="hidden" id="cashPay" value="0">
<input type="hidden" id="bankPay" value="0">
<input type="hidden" id="cardPay" value="0">
<input type="hidden" id="wxPay" value="0">
<input type="hidden" id="zfbPay" value="0">
<input type="hidden" id="shopNo" value="${shopNo}">
<input type="hidden" id="totalSale" />
<input type="hidden" id="inputAmt" />

<script type="text/javascript">
    //chart0

    $(document).ready(function(){




        //我的待办点击事件
        $(document).on('click','.work-item.green',function(event){
            var width = (2 * $(this).width()) + 10;
            $(".todo-panel").width(width -2).css({top:$(this).offset().top,left:$(this).offset().left}).show();
            event.stopPropagation();
        });
        $(".todo-panel").click(function(){
            event.stopPropagation();
        });
        $(document).click(function(){
            $(".todo-panel").hide();
        });

    });

    function loadShop(){
        var shopNo = $("#shopNo").val();
        $.ajax({
            url:"queryShopRight",
            type:"post",
            success:function(data){
                if(data){
                    var list = data.rows;
                    var objSelect = document.getElementById("shopName");
                    objSelect.options.add(new Option(''),'');
                    for(var i = 0;i < list.length; i++)
                    {
                        objSelect.options.add( new Option(list[i].shopName,list[i].shopNo));

                    }
                    document.getElementById("shopName").value=shopNo;

                }
            }
        });
    }
    loadShop();
    
    function  querySaleAnalyse() {
        $.ajax({
            url:"querySaleStat",
            type:"post",
            data : {"sdate":$("#sdate").val(),"edate":$("#edate").val() + " 23:59:00","shopNo":$("#shopName").val()},
            dataType: 'json',
            async : false,
            success:function(data){
                if(data){
                    var list = data.rows;
                    if(list.length > 0)
                    {
                        $("#cashPay").val(list[0].saleCash);
                        $("#bankPay").val(list[0].saleBank);
                        $("#cardPay").val(list[0].saleCard);
                        $("#zfbPay").val(list[0].saleZfb);
                        $("#wxPay").val(list[0].saleWx);
                        $("#totalSale").val(list[0].totalSale);
                        $("#inputAmt").val(list[0].inputAmt);
                        refreshPie();
                    }


                }
            }
        });

        $.ajax({
            url:"queryPosYearStat",
            type:"post",
            data : {"sdate":$("#sdate").val(),"edate":$("#edate").val() + " 23:59:00","shopNo":$("#shopName").val()},
            dataType: 'json',
            async : false,
            success:function(data){
                if(data){
                    var labels = [];
                    var values = [];
                    var list = data.rows;
                    for(var i = 0;i<list.length;i++)
                    {
                        labels.push(list[i].monthStr);
                        values.push(list[i].amt);
                    }
                    refreshYearStat(labels,values);


                }
            }
        });


    }

    function refreshPie()
    {
        var cash = $("#cashPay").val();
        var bank = $("#bankPay").val();
        var card = $("#cardPay").val();
        var zfb = $("#zfbPay").val();
        var wx = $("#wxPay").val();
        var option0 =  {
            tooltip : {
                trigger: 'item',
                formatter: "{a} <br/>{b} : {c} ({d}%)"
            },
            legend: {
                orient : 'vertical',
                x : 'left',
                data:['现金','银行卡','会员卡','支付宝','微信'],
                show:false
            },
            toolbox: {
                show : false,
                feature : {
                    mark : {show: true},
                    dataView : {show: true, readOnly: false},
                    magicType : {
                        show: true,
                        type: ['pie', 'funnel'],
                        option: {
                            funnel: {
                                x: '25%',
                                width: '50%',
                                funnelAlign: 'center',
                                max: 1548
                            }
                        }
                    },
                    restore : {show: true},
                    saveAsImage : {show: true}
                }
            },
            calculable : true,
            series : [
                {
                    name:'访问来源',
                    type:'pie',
                    radius : ['50%', '70%'],
                    itemStyle : {
                        normal : {
                            label : {
                                show : false
                            },
                            labelLine : {
                                show : false
                            }
                        },
                        emphasis : {
                            label : {
                                show : true,
                                position : 'center',
                                textStyle : {
                                    fontSize : '30',
                                    fontWeight : 'bold'
                                }
                            }
                        }
                    },
                    data:[
                        {value:cash, name:'现金'},
                        {value:bank, name:'银行卡'},
                        {value:card, name:'会员卡'},
                        {value:zfb, name:'支付宝'},
                        {value:wx, name:'微信'}
                    ]
                }
            ]
        };
        var myChart0 = echarts.init(document.getElementById('chart0'));
        myChart0.setOption(option0);

        var totalSale = $("#totalSale").val();
        var inputAmt=$("#inputAmt").val();
        //chart1
        var option1 = {
            tooltip : {
                trigger: 'item',
                formatter: "{a} <br/>{b} : {c} ({d}%)"
            },
            legend: {
                orient : 'vertical',
                x : 'left',
                data:['预收款','营业收入'],
                show:false
            },
            toolbox: {
                show : false,
                feature : {
                    mark : {show: true},
                    dataView : {show: true, readOnly: false},
                    magicType : {
                        show: true,
                        type: ['pie', 'funnel'],
                        option: {
                            funnel: {
                                x: '25%',
                                width: '50%',
                                funnelAlign: 'center',
                                max: 1548
                            }
                        }
                    },
                    restore : {show: true},
                    saveAsImage : {show: true}
                }
            },
            calculable : true,
            series : [
                {
                    name:'访问来源',
                    type:'pie',
                    radius : ['50%', '70%'],
                    itemStyle : {
                        normal : {
                            label : {
                                show : false
                            },
                            labelLine : {
                                show : false
                            }
                        },
                        emphasis : {
                            label : {
                                show : true,
                                position : 'center',
                                textStyle : {
                                    fontSize : '30',
                                    fontWeight : 'bold'
                                }
                            }
                        }
                    },
                    data:[
                        {value:inputAmt, name:'预收款'},
                        {value:totalSale, name:'营业收入'}

                    ]
                }
            ]
        };

        var myChart1 = echarts.init(document.getElementById('chart1'));
        myChart1.setOption(option1);
    }

    function refreshYearStat(labelArray,valueArray)
    {
        var option3 = {
            tooltip : {
                trigger: 'axis'
            },
            legend: {
                data:['营业额'],
                show:false
            },
            toolbox: {
                show : false,
                feature : {
                    mark : {show: true},
                    dataView : {show: true, readOnly: false},
                    magicType : {show: true, type: ['line', 'bar']},
                    restore : {show: true},
                    saveAsImage : {show: true}
                }
            },
            calculable : true,
            xAxis : [
                {
                    type : 'category',
                    data :labelArray// ['采购组织','供应商','新物料','uimaker','信息管理','业务系统','采购商']
                }
            ],
            yAxis : [
                {
                    type : 'value'
                }
            ],
            series : [
                {
                    name:'营业额',
                    type:'bar',
                    data:valueArray,
                    markPoint : {
                        data : [
                            {type : 'max', name: '最大值'},
                            {type : 'min', name: '最小值'}
                        ]
                    },
                    markLine : {
                        data : [
                            {type : 'average', name: '平均值'}
                        ]
                    }
                }
            ]
        };

        var myChart3 = echarts.init(document.getElementById('chart3'));
        myChart3.setOption(option3);
    }
    //公开附件tab事件处理
    $(".attached-tab").on("click","a",function(){
        $(this).closest(".attached-tab").find("a").removeClass("current");
        $(this).addClass("current");
        $(this).closest(".attached").find("ul").addClass("hide");
        $(this).closest(".attached").find("ul." + $(this).attr("attached")).removeClass("hide");
    })

</script>
</body>
</html>
