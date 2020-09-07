<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>  
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0"> 
<meta content="email=no,telephone=no" name="format-detection"/>
<%@include file="/WEB-INF/page/include/source.jsp"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<script type="text/javascript" src="resource/1-6-10.esl.js"></script>
<title>问卷调查</title>
<style>
.b_button{margin:100px 650px;}
</style>
  </head>
  
  <body>
    <!-- 为ECharts准备一个具备大小（宽高）的Dom -->
    <div id="main" style="height:400px; width:1000px;margin:0 auto;"></div>
    <input type="button" value="返回" class="b_button" onclick="toback();"/>
    <script type="text/javascript">
    	// 路径配置
        require.config({
            paths:{ 
                'echarts' : 'resource/echarts',
                'echarts/chart/pie' : 'resource/echarts'
            }
        });
        
        // 使用
        require(
            [
                'echarts',
                'echarts/chart/pie' // 使用柱状图就加载bar模块，按需加载
            ],
            function (ec) {
                // 基于准备好的dom，初始化echarts图表
                var myChart = ec.init(document.getElementById('main')); 
                var option = {
    title : {
        text: '问卷管理',
        subtext: '投票统计',
        x:'center'
    },
    tooltip : {
        trigger: 'item',
        formatter: "{a} <br/>{b} : {c} ({d}%)"
    },
    legend: {
        orient : 'vertical',
        x : 'left',
        data:${nos}
    },
    toolbox: {
        show : true,
        feature : {
            dataView : {show: true, readOnly: false},
            restore : {show: true},
            saveAsImage : {show: true}
        }
    },
    calculable : true,
    series : [
        {
            name:'投票统计',
            type:'pie',
            radius : '55%',
            center: ['50%', '60%'],
            data:${ratio}
        }
    ]
};
                    
                    
                myChart.setOption(option); 
            }
        );
    function toback(){
		location.href="${base}/manager/queryquestionnaire";
	}
    </script>      
</body>
</html>
