<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="zh">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="maximum-scale=1.0,minimum-scale=1.0,user-scalable=0,width=device-width,initial-scale=1.0" />
    <meta name="format-detection" content="telephone=no,email=no,date=no,address=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge" />
    <title>登录</title>
    <meta name='keywords' content='' />
    <meta name='description' content='' />
    <meta name="author" content="" />

    <link rel="stylesheet" type="text/css" href="/static/login/css/public.css" />
    <link rel="stylesheet" type="text/css" href="/static/login/css/style.css" />
    <link rel="stylesheet" type="text/css" href="/static/login/css/swiper.min.css" />
    <script type="text/javascript" src="${base }/resource/md5.js"></script>
</head>
<style type="text/css">
    html,body{
        height:100%;
        position:relative;
    }
    body{
        min-height: 800px;
        padding-bottom:80px;
    }
      .s_error {

        display: none;
    }

      .s_error p {
        background: #fde9e9;
        text-align: center;
        padding: 5px 0;
        color: #FD0D0D;
    }

    .alert-error{background-color:#f2dede;border-color:#eed3d7;color:#b94a48;}
    .swiper-pagination-bullet{background:#a7b8fd;opacity: 1;}
    .swiper-pagination-bullet-active{width:23px;border-radius: 5px;}
</style>
<body>
<div class="main">
    <div id="header">
        <div class="max-width">
            <header>
                <div class="logo fl ">
                    <img class="logo-img" src="/static/login/img/logo.png" alt="" />
                    <img class="logo-name" src="/static/login/img/logo-name.png" alt=""/>
                </div>
                <div class="head-down fr">
                    <div class="lis phoneDown">
                        <span>下载手机端</span>
                        <div class="code-v hidden">
                            <img src="/static/login/img/code.png"/>
                        </div>
                    </div>
                    <div class="lis winDwon">
                        <div class="lis winDwon">
                            <a href="https://t3.cyecy.cn/upload/t3setup.zip" download="t3setup.zip"><span>下载桌面收银端</span></a>


                        </div>
                    </div>
                </div>
            </header>
        </div>
    </div>
    <!--banner-->
    <div class="banner">
        <div class="swiper-container" id="swiper-container-menber">
            <ul class="swiper-wrapper">
                <li class="swiper-slide swiper-no-swiping" style="background-image:url(/static/login/img/banner.jpg);"></li>
                <li class="swiper-slide swiper-no-swiping" style="background-image:url(/static/login/img/banner2.jpg);"></li>
                <li class="swiper-slide swiper-no-swiping" style="background-image:url(/static/login/img/banner3.jpg);"></li>
            </ul>
            <div class="swiper-pagination" id="swiper-pagination-banner"></div>
        </div>
        <div class="max-width">
            <form  method="post"  id="loginForm" action="${base }/manager/dologin">
                <input type="hidden" name="From" value="2"/>
                <input type="hidden" name="usrPwd" id="usrPwd"/>
            <div class="login fr">
                <div class="login-tit">登录</div>
                <div id="loginBlock" style="display:block;">
                    <div class="login-con" >

                        <div class="login-con-lis name">
                            <input id="UserName" name="usrNo" type="text" style="padding-top: 15px" placeholder="请输入您的用户名"/>
                        </div>
                        <div class="login-con-lis password">
                            <input  type="password" id="Password" name="tempPwd" style="padding-top: 15px" placeholder="请输入您的密码"/>
                        </div>
                        <div class="s_error name">
                            <p id="loginError" class="alert-error" style=""></p>
                        </div>
                    </div>
                    <label>
                        <input type="checkbox"  id="rememberMe"  value="1" />
                        记住登录密码
                    </label>

                    <div class="login-but"><button onclick="toSubmit()">登录</button></div>
                </div>
                <div id="downloadBlock" style="display:none">
                    <table width="100%" border="0">
                        <tr>
                            <td width="15%" height="55px"></td>
                            <td width="25%"></td>
                            <td width="10%"></td>
                            <td width="25%"></td>
                            <td width="25%"></td>
                        </tr>
                    <tr>
                        <td width="15%">

                        </td>
                        <td width="25%">
                            <div style="width: 100%;display:inline-block">
                                <img src="/static/img/login/google.png" height="80" width="80"/>
                            </div>
                        </td>
                        <td width="10%">

                        </td>
                        <td width="25%">
                            <a href="https://t3.cyecy.cn/upload/驰用T3.exe" download="t3setup.zip">

                                <img src="/static/img/login/t3.png" height="80" width="80"/>

                            </a>
                        </td>
                        <td width="25%">

                        </td>

                    </tr>
                        <tr>
                            <td width="15%" height="25px"></td>
                            <td width="25%"></td>
                            <td width="10%"></td>
                            <td width="25%"></td>
                            <td width="25%"></td>
                        </tr>
                        <tr>

                            <td colspan="5">
                                <label><font  size="3">

                                    您的浏览器版本太低
                                    请下载桌面安装版，或下载谷歌浏览器</font>
                                </label>
                            </td>

                        </tr>

                        <tr>
                            <td width="10%" height="25px"></td>
                            <td width="35%"><a style="color:#68c9c3;" href="https://t3.cyecy.cn/upload/驰用T3.exe" download="驰用T3.zip">下载桌面安装版</a></td>
                            <td width="10%"></td>
                            <td width="35%"><a style="color:#68c9c3;" href="https://t3.cyecy.cn/upload/49.0.2623.112_chrome_installer.exe" download="chrome_installer.exe">下载谷歌浏览器</a></td>
                            <td width="10%"></td>
                        </tr>


                    <div  >


                    </div>
                    </table>



                </div>
            </div>
            </form>
        </div>
    </div>
    <div class="foot">
        <div class="max-width">
            <div class="foot-but">2020福建驰用科技有限公司  版权所有   闽ICP备19014979</div>
        </div>
    </div>
</div>
<script src="/static/login/js/jquery.min.js" type="text/javascript" charset="utf-8"></script>
<script src="/static/login/js/swiper.min.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript" src="${base }/resource/showMsg.js"></script>
<script type="text/javascript">

    window.onload = function () {
        $("#usrNo").focus();

        $("#loginError").html(getMsg("${showMsg}"));
        if ("${showMsg}" != "") {
            $(".s_error").show();
            setTimeout(function () {
                $(".s_error").hide();
            }, 3000);
        }
        var isIe = IEVersion();
        if (!(isIe == -1||isIe=="edge")) {
            document.getElementById("loginBlock").style.display = "none";//隐藏
            document.getElementById("downloadBlock").style.display = "";//隐藏
        }

    }

    function IEVersion() {
        var userAgent = navigator.userAgent; //取得浏览器的userAgent字符串
        var isIE = userAgent.indexOf("compatible") > -1 && userAgent.indexOf("MSIE") > -1; //判断是否IE<11浏览器
        var isEdge = userAgent.indexOf("Edge") > -1 && !isIE; //判断是否IE的Edge浏览器
        var isIE11 = userAgent.indexOf('Trident') > -1 && userAgent.indexOf("rv:11.0") > -1;
        if(isIE) {
            var reIE = new RegExp("MSIE (\\d+\\.\\d+);");
            reIE.test(userAgent);
            var fIEVersion = parseFloat(RegExp["$1"]);
            if(fIEVersion == 7) {
                return 7;
            } else if(fIEVersion == 8) {
                return 8;
            } else if(fIEVersion == 9) {
                return 9;
            } else if(fIEVersion == 10) {
                return 10;
            } else {
                return 6;//IE版本<=7
            }
        } else if(isEdge) {
            return 'edge';//edge
        } else if(isIE11) {
            return 11; //IE11
        }else{
            return -1;//不是ie浏览器
        }
    }

    function tologinSubmit(e) {
        var key = window.event ? e.keyCode : e.which;
        if (key == 13) {
            toSubmit();
        }
    }

    var mySwiper1 = new Swiper('#swiper-container-menber', {
        pagination: '#swiper-pagination-banner',
        slidesPerView: 1,
        paginationClickable: true,
        //spaceBetween:10,
        autoplay : 4000,
        loop: true
    });
    //登陆
    function toSubmit() {
        if (navigator.userAgent.indexOf("MSIE") > 0 && !navigator.userAgent.indexOf("opera") > -1)
        {
            //alert('1111');
        }
        var tempPwd = $("#Password").val();
        var usrNo = $("#UserName").val();
        if (usrNo == '') {
            $("#loginError").html("用户名不能为空!");
            $(".s_error").show();
            setTimeout(function () {
                $(".s_error").hide();
            }, 3000);
            return false;
        }
        if (tempPwd == '') {
            $("#loginError").html("密码不能为空!");
            $(".s_error").show();
            setTimeout(function () {
                $(".s_error").hide();
            }, 3000);
            return false;
        }
        if (document.getElementById("rememberMe").checked == true) {
            setCookie();
        } else {
            delCookie();
        }
        $("#usrPwd").val(hex_md5(tempPwd));
        //checkDog();
        $("#loginForm").submit();
    }

    /*
     *说明：得到相应的Cookie值
     */
    function getCookie() {
        var start = 0;
        var end = 0;
        var name;
        //获取cookie
        var CookieString = document.cookie;
        // 密码框获得焦点
        document.getElementsByName("tempPwd")[0].focus();
        var startName = CookieString.substring(0, CookieString.indexOf("="));
        if (startName == "JSESSIONID") {
            return;
        }
        if (startName == "JSESSIONID") {//表示JSESSIONID在前面
            name = CookieString.substring(CookieString.replace('=', 'a').indexOf('=') + 1);//截取第二个“=”之后的字符串
        } else {
            //start = CookieString.indexOf("=");
            //end = CookieString.indexOf(";");
            //name = CookieString.substring(start + 1, end);
            name = CookieString;
        }
        name = decodeURIComponent(name);
        if (name == "JSESSIONID=") {
            return;
        }
        var arr = name.split("##");

        if (arr != undefined) {
            var useNos = arr[0].split('name=');
            if (useNos[1] != undefined) {
                document.getElementsByName("usrNo")[0].value = useNos[1];
            }
        }
        if (arr[1] != undefined) {
            document.getElementsByName("tempPwd")[0].value = arr[1].substring(arr[1].indexOf('='));
        }
        document.getElementById("rememberMe").checked = true;
    }

    function delCookie() {
        var expires = new Date();
        expires.setTime(expires.getTime() + 12 * 30 * 24 * 60 * 60 * 1000 * (-1));//设置用户名可以保存一年
        var nameString;//用户名
        var expireString;//过期时间
        expireString = expires.toGMTString();
        var cookieString = 'name=;expires=' + expireString;//设置Cookie为name=""和expires=""
        document.cookie = cookieString;
    }

    /*
     *说明：进入页面设置Cookie值
     */
    function setCookie() {
        var expires = new Date();
        expires.setTime(expires.getTime() + 12 * 30 * 24 * 60 * 60 * 1000);//设置用户名可以保存一年
        var nameString;//用户名
        var expireString;//过期时间
        nameString = document.getElementsByName("usrNo")[0].value +
            '##' + document.getElementsByName("tempPwd")[0].value + '##' + document.getElementById("rememberMe").checked;
        expireString = expires.toGMTString();
        var cookieString = 'name=' + encodeURIComponent(nameString) + ';expires=' + expireString;//设置Cookie为name=""和expires=""
        document.cookie = cookieString;
    }


    getCookie();
</script>
</body>
</html>
