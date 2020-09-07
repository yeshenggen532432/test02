var locationUrl = window.location.href.split('#')[0];
var ua = window.navigator.userAgent.toLowerCase();//验证是否在微信中打开
if (ua.match(/MicroMessenger/i) == 'micromessenger' || ua.match(/_SQ_/i) == '_sq_') {
    var shareUrlKey = encodeURIComponent("shareUrl=" + locationUrl);
    var shareConfig = getCache(shareUrlKey);
    if (shareConfig) {
        wechatConfig(JSON.parse(shareConfig));
    } else {
        //异步获取appid，时间戳，随机数，签名
        $.ajax({
            url: "/web/wx/shareConfig",
            data: {"token": getToken(), "locationUrl": encodeURIComponent(locationUrl)},
            type: "POST",
            success: function (data) {
                console.log("微信分享获取签名:" + JSON.stringify(data));
                if (data.state) {
                    data = data.obj;
                    wechatConfig(data);
                    //setCache(shareUrlKey, JSON.stringify(data));
                }
            },
            error: function (data) {
                console.log("分享获取出现错误:" + JSON.stringify(data));
            }
        });
    }
} else {
    console.log("非微信平台无法分享");
}

//配置：appid，时间戳，随机数，签名
function wechatConfig(config) {
    wx.config({
        debug: false,
        appId: config.appId,
        timestamp: config.timestamp,
        nonceStr: config.nonceStr,
        signature: config.signature,
        jsApiList: [
            'onMenuShareTimeline',//朋友圈
            'onMenuShareAppMessage',//朋友
            'onMenuShareQQ',//QQ
            'onMenuShareQZone',//QQ空间
            'onMenuShareWeibo',//微博
            'getLocation',
            'openLocation'
        ]
    });
    //商品详情页面手动获取数据进行分享
    if (typeof manualShare == "undefined") {
        wechatShare();//分享;
    }
    wx.checkJsApi({
        jsApiList: ['chooseImage'], // 需要检测的JS接口列表，所有JS接口列表见附录2,
        success: function (res) {
            // 以键值对的形式返回，可用的api值true，不可用为false
            // 如：{"checkResult":{"chooseImage":true},"errMsg":"checkJsApi:ok"}
        },
        error: function (data) {
            console.log('checkJsApi出现错误' + data);
        }
    });
}


function wechatShare($shareData) {
    if (!$shareData) {
        queryShopConfig();
        var title = document.title || getCache("shareTitle");
        console.log("title==" + document.title)
        var logo = $("img[id=shareImg]").attr("src") || getCache("shareLogo");
        if (!title)
            title = "驰用T3";
        if (!logo)
            logo = _basePath + "/resource/shop/mobile/images/ic_normal.jpg";


        //默认分享首页
        //var url = _basePath + "/web/mainWeb/toIndex?companyId=" + _companyId;
        //备注：encodeURIComponent（回调url）将接口url中？=&进行编码。（不然回调url中&参数会当成link的参数）

        $shareData = {
            title: title, // 分享标题
            desc: title, // 分享描述
            link: getShareLink(), // 分享链接，该链接域名或路径必须与当前页面对应的公众号JS安全域名一致
            imgUrl: logo,  // 分享图标
            success: function () {
            }
        }
    }

    console.log("wechatShare=" + JSON.stringify($shareData));
    // config信息验证后会执行ready方法，所有接口调用都必须在config接口获得结果之后，config是一个客户端的异步操作，所以如果需要在页面加载时就调用相关接口，
    // 则须把相关接口放在ready函数中调用来确保正确执行。对于用户触发时才调用的接口，则可以直接调用，不需要放在ready函数中。
    wx.ready(function () {
        wx.onMenuShareTimeline($shareData);
        wx.onMenuShareAppMessage($shareData);
        wx.onMenuShareQQ($shareData);
        wx.onMenuShareQZone($shareData);
        wx.onMenuShareWeibo($shareData);
        wx.getLocation({
            /*type: 'gcj02',*/
            success: function (res) {
                //alert('22' + JSON.stringify(res));
                var latitude = res.latitude; // 纬度，浮点数，范围为90 ~ -90
                var longitude = res.longitude; // 经度，浮点数，范围为180 ~ -180。

                if (latitude) {
                    setCache('location', JSON.stringify({latitude: latitude, longitude: longitude}));//地址位置保存到缓存中
                    makeGpsLocationToBaidu();//GPS地址转换成百度地址
                }

                /* wx.openLocation({
                     latitude:latitude, // 纬度，浮点数，范围为90 ~ -90
                     longitude: longitude, // 经度，浮点数，范围为180 ~ -180。
                     name: '', // 位置名
                     address: '', // 地址详情说明
                     scale: 13, // 地图缩放级别,整形值,范围从1~28。默认为最大
                     infoUrl: '' // 在查看位置界面底部显示的超链接,可点击跳转
                 });*/
            },
            cancel: function (res) {
                alert('用户拒绝授权获取地理位置');
            }
        });


    });
}

//查询商城基本配置
function queryShopConfig() {
    //如果没有商城基本配置时重新获取
    if (!getCache('shareTitle')) {
        $.ajax({
            url: "/web/mainWeb/getShopConfigSet",
            async: false,
            type: "POST",
            success: function (data) {
                if (data.state) {
                    var shopConfigSet = data.obj;
                    setCache("shareTitle", shopConfigSet.name);
                    if (shopConfigSet.logo)
                        setCache("shareLogo", _basePath + '/upload/' + shopConfigSet.logo);
                    else
                        setCache("shareLogo", '');
                }
            }
        });
    }
}

//获得分享链接
function getShareLink() {
    var _wid = getWid();
    if (!_wid) {
        alert("公司ID不能为空");
        return false;
    }
    var url = window.location.href;
    url = urlReplaceParam(url, ['pid', 'mid']);//过滤上级推广人ID

    //推广人ID为当前登陆员
    var mid = getCache("mid");
    if (mid && mid != '0') {
        var sp = "?";
        if (url.indexOf("?") > 0)
            sp = "&";
        url += sp + "pid=" + mid;
    }
    console.log("分享链接=" + url);
    return _basePath + "/web/shopDispatcherWid/share?redirectUri=" + encodeURIComponent(url) + "&wid=" + _wid
}