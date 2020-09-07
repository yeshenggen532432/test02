<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html>
<%@include file="/WEB-INF/page/shop/mobile/include/source2.jsp"%>
<head>
	<meta charset="UTF-8">
	<meta name="Keywords" content="">
	<meta name="Description" content="">
	<meta name="format-detection" content="telephone=no">
	<meta name="apple-mobile-web-app-capable" content="yes">
	<meta name="apple-mobile-web-app-status-bar-style" content="black">
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0,minimum-scale=1.0">
	<%--<title>收货地址</title>--%>
    <style type="text/css">
        body{
            overflow-x:hidden;
            height: 100%;
            /*开启moblie网页快速滚动和回弹的效果*/
            -webkit-overflow-scrolling: touch;
            font-size: 12px;
            font-family: "微软雅黑";
            overflow-x: hidden;
            -webkit-text-size-adjust: none !important;
        }
        *{
            margin: 0;
            padding: 0;
            -webkit-box-sizing: border-box;
            box-sizing: border-box;
        }

        /*==================tabbar======================*/
        #menu {
            width: 100%;
            height: 44px;
            position: fixed;
            left: 0px;
            bottom: 0px;
            background: #fff;
            box-shadow: 0 -3px 5px #ccc;
            z-index: 1000;
        }
        #menu ul {
            width: 100%;
            list-style: none;
            height: 44px;
        }
        #menu ul *{
            margin: 0;
            padding: 0;
        }
        #menu ul li {
            width: 25%;
            float: left;
        }
        #menu ul li a{
            display: block;
            width: 100%;
            color: #333;
            text-decoration: none;
        }
        #menu ul li a.red {
            color: #3388FF;
            -webkit-transition: .3s color;
            transition: .3s color;
        }
        #menu ul li a font.iconfont {
            font-size: 18px;
        }
        #menu ul li a span {
            display: block;
            line-height: 8px;
        }
        /*==================tabbar======================*/
        .mui-bar-nav ~ .mui-content {
            padding-bottom: 88px;
        }

        .my-name{
            font-size: 14px;
            font-weight: normal;
            color: #333333;
        }
        .mui-media {
            font-size: 14px;
        }

        .mui-table-view .mui-media-object {
            max-width: initial;
            width: 80px;
            height: 70px;
        }

        .my-dj-num {
            position: absolute;
            left: 125px;
            right: 10px;
            bottom: -5px;
            /*bottom: 5px;*/
            color: #8f8f94;
        }

        .my-dj-num .my-dj {
            display: inline-block;
            color: red;
            vertical-align: middle;
            font-size: 12px;
        }


        .mui-table-view:before,
        .mui-table-view:after {
            height: 0;
        }

        .mui-content>.mui-table-view:first-child {
            margin-top: 1px;
        }

        .mui-table-view-cell.mui-checkbox.mui-left{
            padding-left: 38px;
        }

        .mui-checkbox.mui-left input[type=checkbox]{
            left: 5px;
            right: 5px;
            top: 50%;
            margin-top: -14px;
        }
        .mui-table-view-cell{
            padding-left: 0px;
        }

        .my-content{
        }

        .my-gg-dw {
            position: absolute;
            left: 125px;
            right: 10px;
            top: 25px;
            /*top: 34px;*/
            color: #8f8f94;
        }
        .my-gg-dw .my-gg{
            font-size: 12px;
            color: #666666;
        }
        .mui-numbox{
            width: 100px;
            height: 25px;
            float: right;
            padding: 0 10px;
        }
        .mui-numbox [class*=btn-numbox]{
            font-size: 18px;
            font-weight: 400;
            line-height: 100%;
            position: absolute;
            top: 0;
            overflow: hidden;
            width: 33px;
            height: 100%;
            padding: 0;
            color: #555;
            border: none;
            border-radius: 0;
            background-color: #f9f9f9;
        }

        .my-tags{
            float: right;
        }

        .my-tags > div{
            height: 20px;
            float: left;
            margin: 0 0 0 5px;
            line-height: 20px;
            padding: 0px 10px;
            border-radius: 4px;
            border: 1px solid #3388FF;
            color: #3388FF;
            font-size: 12px;
        }
        .my-tags-active{background:#3388FF !important; color:#FFFFFF !important;}

        .my-footer{
            position: fixed;
            bottom: 44px;
            left: 0;
            right: 0;
            height: 44px;
        }

        .my-allcheck{
            display: inline-block;
            width: 75px;
            height: 100%;
        }
        .my-checkbox{
            display: inline-block;
            width: 40px;
            height: 70px;
        }

        .my-checkbox input[type=checkbox] {
            top: 50%;
            margin-top: -14px;
            right: 7px;
        }

        .my-allcheck input[type=checkbox] {
            top: 6px;
            right: 7px;
        }
        .mui-checkbox.mui-left label {
            padding-right: 10px;
            padding-left: 35px;
            padding-top: 10px;
            font-size: 12px;
            color: #666666;
        }
        .mui-btn{
            height: 100%;
        }
        .my-sum-money{
            font-size: 14px;
            color: red;
        }


    </style>


</head>
<!-- --------body开始----------- -->
<body>

<header class="mui-bar mui-bar-nav">
    <h1 class="mui-title">购物车</h1>
</header>
<div class="mui-content">
    <ul class="mui-table-view" id="list">

<%--        <li class="mui-table-view-cell mui-media" >
            <div class="mui-slider-right mui-disabled">
                <a class="mui-btn mui-btn-red">删除</a>
            </div>
            <div class="mui-slider-handle">
                <div class="mui-checkbox mui-pull-left  my-checkbox">
                    <input type="checkbox" id="check">
                </div>
                <img class="mui-media-object mui-pull-left" src="images/60x222260.gif">
                <div class="my-content mui-clearfix">
                    <h4 class="my-name mui-ellipsis">青岛啤酒</h4>
                    <div class="my-gg-dw">
                        <span class="my-gg">规格：500*24</span>
                        <div class="my-tags mui-clearfix">
                            <div >件</div>
                            <div >箱</div>
                        </div>
                    </div>
                    <div class="my-dj-num">
                        <div class="my-dj">￥999</div>
                        <div class="mui-numbox" data-numbox-min='1' data-numbox-max='9'>
                            <button class="mui-btn mui-btn-numbox-minus" type="button">-</button>
                            <input class="mui-input-numbox" type="number" value="5" />
                            <button class="mui-btn mui-btn-numbox-plus" type="button">+</button>
                        </div>
                    </div>
                </div>
            </div>
        </li>--%>

    </ul>

</div>


<div class="mui-table-view my-footer">
    <div class="mui-checkbox mui-left my-allcheck">
        <input name="checkbox1" type="checkbox" id="allcheck">
        <label for="allcheck">全选</label>
    </div>
    <span class="my-sum-money">合计:￥0.00</span>
    <button type="button" class="mui-btn mui-btn-primary mui-pull-right" onclick="javascript:toFillOrder();">去结算</button>
</div>

<div id="menu">
    <ul>
        <li><a href="<%=basePath %>/web/mainWeb/toIndex?token=${token}&companyId=${companyId}"><font class="iconfont">&#xe612;</font><span class="inco_txt">首页</span></a></li>
        <li><a href="<%=basePath %>/web/mainWeb/wareType.html?token=${token}"><font class="iconfont">&#xe660;</font><span class="inco_txt">分类</span></a></li>
        <li><a class="red"><font class="iconfont" style="color: #3388FF;">&#xe63e;</font><span class="inco_txt">购物车</span></a></li>
        <li><a href="<%=basePath %>/web/mainWeb/toMyInfo?token=${token}"><font class="iconfont">&#xe62e;</font><span class="inco_txt">我的</span></a></li>
    </ul>
</div>

<script>
    mui.init();
    //购物车加减控件
/*    mui('.mui-numbox').on('tap', '.mui-btn',function(e){
    });*/

    //删除购物车
    var delIndexs = "";//记录删除的下标
    $('#list').on('tap', '.mui-btn-red', function(event) {
        var elem = this;
        var li = elem.parentNode.parentNode;
        var checkbox = $(li).find("input[type=checkbox]")[0];
        mui.confirm('确认删除该条记录？', '温馨提示', ['取消', '确认'], function(e) {
            if (e.index == 1) {
                //从数据库删除购物车
                var careId=elem.getAttribute("careId");
                delShopCart(careId);
                //TODO 这边不直接移除元素；与下面的wareNum_i_wareid有关(i考虑到同一个商品会有多个区分)
                li.style.display="none";
                $(checkbox).attr('checked',false)  //移除 checked 状态
                // li.parentNode.removeChild(li);
                //记录删除的下标（不然全选会带）
                var index=elem.getAttribute("index");
                if(delIndexs == ""){
                    delIndexs = ""+index;
                }else{
                    delIndexs += ","+index;
                }
                updateZje();
            } else {
                setTimeout(function() {
                    $.swipeoutClose(li);
                }, 0);
            }
        });
    });

    mui("#list").on('tap','.my-tags div',function(e){
        //修改样式
        var $tag=$(this);//js对象转jquery对象
        $tag.siblings().removeClass("my-tags-active");
        $tag.addClass("my-tags-active");

        //改变单价；金额
        var index=this.getAttribute("index");
        var title=this.getAttribute("title");
        var wareId=this.getAttribute("wareId");
        var hsNum=this.getAttribute("hsNum");
        var wareDj=this.getAttribute("wareDj");
        if(title=='max'){
            //备注:页面上显示两位小数；计算不四舍五入
            $("#wareDj_"+index+"_"+wareId).text(wareDj);
            $("#wareDj_"+index+"_"+wareId).attr("wareDj",wareDj);
        }else{
            $("#wareDj_"+index+"_"+wareId).text((wareDj/hsNum).toFixed(2));
            $("#wareDj_"+index+"_"+wareId).attr("wareDj",wareDj/hsNum);
        }
        updateZje()
    })

    mui('#list').on('input', 'input[type=number]', function() {
        var value = mui($(this).closest('.mui-numbox')).numbox().getValue();
        if(value==null || value==undefined || value == NaN){
            return;
        }
        updateZje();
    });


    mui('#list').on('change', 'input[type=checkbox]', function() {
        setAllCheck();
    });

    //全选
    mui('.my-allcheck').on('change', 'input', function() {
        $("[name='checkbox']").prop("checked",this.checked);
        updateZje();//总金额
    });

    //遍历单选；如果全选
    function setAllCheck(){
        var chxVals = document.getElementsByName("checkbox");
        var flag=true;
        for(var i=0;i<chxVals.length;i++){
            var val = chxVals[i];
            if(val.checked==false){
                flag=false;
                break;
            }
        }
        if(flag){
            $("#allcheck").prop("checked",true);
        }else{
            $("#allcheck").prop("checked",false);
        }
        updateZje();
    }

    $(document).ready(function(){
        $.wechatShare();//分享
        getShopCartList();
    })

    //获取购物车列表
    function getShopCartList(){
        $.ajax({
            url:"<%=basePath%>/web/shopCart/queryShopCartListWeb",
            data:"token=${token}",
            type:"POST",
            success:function(json){
                if(json.state){
                    var datas = json.list;
                    var str="";
                    if(datas!=null&&datas!=undefined&&datas.length>0){
                        for(var i=0;i<datas.length;i++){
                            var careId=datas[i].id;//购物车id
                            var wareId=datas[i].wareId;//商品id
                            var beUnit=datas[i].beUnit;//大单位或小单位的代码
                            var minUnitCode=datas[i].minUnitCode;//小单位的代码
                            var minUnit = datas[i].minUnit;//小单位
                            var maxUnitCode=datas[i].maxUnitCode;//大单位的代码
                            var wareDw = datas[i].wareDw;//大单位
                            var wareDj=datas[i].wareDj;//价格
                            var hsNum=datas[i].hsNum;//换算
                            var flag = true;//默认选中大单位
                            //小单位
                            if(beUnit!=null && beUnit!=undefined && beUnit==minUnitCode){
                                flag = false;
                                //wareDj=(wareDj/hsNum).toFixed(2);
                            }

                            str += "<li class=\"mui-table-view-cell mui-media\" >";

                            str += "<div class='mui-slider-right mui-disabled' >";
                            str += "<a class='mui-btn mui-btn-red' careId='"+careId+"' index='"+i+"'>删除</a>";
                            str += "</div>";
                            str += "<div class='mui-slider-handle' >";

                            str += "<div class=\"mui-checkbox mui-pull-left  my-checkbox\">";
                            str += "<input type=\"checkbox\" name='checkbox' value='"+datas[i].wareId+"'>";
                            str += "</div>";

                            var warePicList=datas[i].warePicList;
                            if(warePicList!=null && warePicList!= undefined && warePicList.length>0){
                                var sourcePath= "<%=basePath%>/upload/"+warePicList[0].picMini;
                                for (var k=0;k<warePicList.length;k++){
                                    //1:为主图
                                    if(warePicList[k].type=='1'){
                                        sourcePath="<%=basePath%>/upload/"+warePicList[k].picMini;
                                        break;
                                    }
                                }
                                str += "<img class=\"mui-media-object mui-pull-left\" src='"+sourcePath+"'>";
                            }else{
                                //暂无图片
                                str += "<img class='mui-media-object mui-pull-left' src='<%=basePath%>/resource/shop/mobile/images/ic_normal.jpg' >";
                            }

                            str += "<div class='my-content mui-clearfix' >";
                            str += "<h4 class=\"my-name mui-ellipsis\">"+datas[i].wareNm+"</h4>";
                            str += "<div class=\"my-gg-dw\">";
                            str += "<span class=\"my-gg\">规格:"+datas[i].wareGg+"</span>";
                            str += "<div class=\"my-tags mui-clearfix\">";
                            if(flag){
                                //大单位
                                str += "<div class='my-tags-active' index='"+i+"' hsNum='"+hsNum+"' wareDj='"+wareDj+"' value='"+maxUnitCode+"' title='max' wareId='"+wareId+"'>"+wareDw+"</div>";
                                if(minUnit!=null && minUnit!=undefined && minUnit!='S'){
                                    str += "<div index='"+i+"' hsNum='"+hsNum+"' wareDj='"+wareDj+"' value='"+minUnitCode+"' title='min' wareId='"+wareId+"'>"+minUnit+"</div>"
                                }
                            }else{
                                //小单位
                                str += "<div index='"+i+"' hsNum='"+hsNum+"' wareDj='"+wareDj+"' value='"+maxUnitCode+"' title='max' wareId='"+wareId+"'>"+wareDw+"</div>";
                                str += "<div class='my-tags-active' index='"+i+"' hsNum='"+hsNum+"' wareDj='"+wareDj+"' value='"+minUnitCode+"' title='min' wareId='"+wareId+"'>"+minUnit+"</div>";
                            }
                            str += "</div>";
                            str += "</div>";
                            str += "<div class='my-dj-num'>";
                            if(flag){
                                str += "<div class='my-dj' id='wareDj_"+i+"_"+datas[i].wareId+"' wareDj='"+wareDj+"'>"+wareDj+"</div>";
                            }else{
                                str += "<div class='my-dj' id='wareDj_"+i+"_"+datas[i].wareId+"' wareDj='"+wareDj/hsNum+"'>"+(wareDj/hsNum).toFixed(2)+"</div>";
                            }

                            str += "<div class='mui-numbox' data-numbox-min='1'>";
                            str += "<button class='mui-btn mui-btn-numbox-minus' type='button' onclick='onReduce("+datas[i].id+","+datas[i].wareId+","+i+");'>-</button>";
                            str += "<input  class='mui-input-numbox' type='number' value='"+datas[i].wareNum+"' id='wareNum_"+i+"_"+datas[i].wareId+"'/>";
                            str += "<button class='mui-btn mui-btn-numbox-plus' type='button' onclick='onPlus("+datas[i].id+","+datas[i].wareId+","+i+");'>+</button>";
                            str += "</div>";
                            str += "</div>";
                            str += "</div>";
                            str += "</div>";
                            str += "</li>";
                        }
                        $("#list").html(str);
                    }
                }
            },
            error:function (data) {
            }
        });
    }

    //获取购物车列表
    function delShopCart(careId){
        $.ajax({
            url:"<%=basePath%>/web/shopCart/deleteShopCartById",
            data:{"token":"${token}","id":careId},
            type:"POST",
            success:function(json){
                if(json.state){
                }
            },
            error:function (json) {
            }
        });
    }

    //加
    function onPlus(id,wareId,i){
        var wareNum=$("#wareNum_"+i+"_"+wareId).val()
        $("#wareNum_"+i+"_"+wareId).val(parseInt(wareNum)+1);
        updateZje();//总金额
    }
    //减
    function onReduce(id,wareId,i){
        var wareNum=$("#wareNum_"+i+"_"+wareId).val()
        if(1==parseInt(wareNum)){
            return ;
        }
        $("#wareNum_"+i+"_"+wareId).val(parseInt(wareNum)-1);
        updateZje();//总金额
    }

    //修改总金额
    function updateZje(){
        var chxVals = document.getElementsByName("checkbox");
        var zje=0.0;
        console.log("length:"+chxVals.length);
        for(var i=0;i<chxVals.length;i++){
            if(chxVals[i].checked && delIndexs.indexOf(""+i)==-1){
                var wareId=chxVals[i].value;
                var wareNum=$("#wareNum_"+i+"_"+wareId).val();
                var wareDj=$("#wareDj_"+i+"_"+wareId).attr("wareDj");//这里要优化
                zje+=parseFloat(wareNum)*parseFloat(wareDj);
            }
        }
        $(".my-sum-money").text("总计：￥"+zje.toFixed(2));
    }

    //跳转：下单界面
    function toFillOrder(){
        var chxVals = document.getElementsByName("checkbox");
        var wareIds = "";
        var wareNums = "";
        var beUnits = "";//计量单位s
        var flag=false;
        for(var i=0;i<chxVals.length;i++){
            if(chxVals[i].checked && delIndexs.indexOf(""+i)==-1){
                flag=true;
                var chVal=chxVals[i].value;
                var wareNumVal=$("#wareNum_"+i+"_"+chVal).val();
                var beUnit=$(".my-tags-active")[i].getAttribute("value");
                if(wareIds == ""){
                    wareIds=chVal;
                    wareNums=wareNumVal;
                    beUnits = beUnit;
                }else{
                    wareIds += ","+chVal;
                    wareNums += ","+wareNumVal;
                    beUnits += ","+beUnit;
                }
            }
        }

       if(!flag){
            mui.alert("请选择所要购买的商品");
            return;
        }
        window.location.href="<%=basePath%>/web/shopBforderMobile/toFillOrder?token=${token}&wareIds="+wareIds+"&wareNums="+wareNums+"&beUnits="+beUnits+"&type=2";
    }


</script>
</body>

</html>
