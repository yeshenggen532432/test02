//从链接中获取参数
function getQueryVariable(variable) {
    var query = window.location.search.substring(1);
    var vars = query.split("&");
    for (var i = 0; i < vars.length; i++) {
        var pair = vars[i].split("=");
        if (pair[0] == variable) {
            return pair[1];
        }
    }
    return (false);
}

//设置缓存
function setCache(name, value) {
    sessionStorage.setItem("uglcw_" + name, value);
}

//获取缓存数据
function getCache(name) {
    return sessionStorage.getItem("uglcw_" + name) || '';
}

//获取缓存数据
function removeCache(name) {
    return sessionStorage.removeItem("uglcw_" + name) || '';
}


function getToken() {
    return getCache("token");
}

function getWid() {
    return getCache("wid");
}

function makeGpsLocationToBaidu() {
    console.log('进入百度地址转换');
    var location = getCache("location");
    if (location) {
        location = JSON.parse(location);
        //http://lbsyun.baidu.com/index.php?title=webapi/guide/changeposition
        //coords:源坐标，格式：经度,纬度;格式：经度,纬度;最多一百个
        //from=1：gps设备角度坐标，wgs84坐标
        //to=5:目的坐标为百度经纬度
        var url = '//api.map.baidu.com/geoconv/v1/?coords=' + location.longitude + ',' + location.latitude + '&from=1&to=5&ak=A6lwDScPTc1VDRsD6GAa0N8X';
        $.get(url, function (data) {
            if (data.status === 0) {
                location.longitude = data.result[0].x;
                location.latitude = data.result[0].y;
                setCache('location', JSON.stringify(location));//地址位置保存到缓存中
                console.log('百度地址转换成功' + JSON.stringify(location));
            }
        }, 'jsonp');
    } else {
        return null;
    }
}

var _wid = getQueryVariable('wid');//公司ID
var _token = getQueryVariable('token');
var _pid = getQueryVariable('pid');//推广会员ID
var _mid = getQueryVariable('mid');//当前会员ID

//会员TOKEN不为空时公司ID才保存
if (_token && _token != 'null') {
    setCache("token", _token);
    if (_wid && _wid != 'null') {
        setCache("wid", _wid);
    }
}
if (_pid && _pid != 'null' && _pid != '0') {
    setCache("pid", _pid);
}
if (_mid && _mid != 'null' && _mid != '0') {
    setCache("mid", _mid);
}
//所有AJAX统一处理加上TOKEN
$.ajaxSetup({
    //aysnc: true, // 默认同异加载
    //type: "POST" , // 默认使用POST方式
    headers: { // 默认添加请求头
        "token": getToken(),
        "companyId": getWid()
    },

    //完成请求后触发。即在success或error触发后触发

    complete: function (request, textStatus) {

        // 一般这里写一些公共处理方法，比如捕获后台异常，展示到页面

        var status = request.status;
        //后台自定义抛出异常后处理
        if (status == 299) {
            var msg = request.responseText || "数据异常！"
            console.log('错误提示', request.responseText || "数据异常！", "error");
        } else if (status == 298) {
            //未登录
            console.log('错误提示', request.responseText, "error");
        } else if (status == 404) {
            console.log('错误提示', request.responseText, "error");
        } else if (status == 0) {
            //超时 返回0
            if ("timeout" == textStatus) {
                console.log('错误提示', "服务器连接超时！", "error");
            }
        } else if (status == 200) {
            //页面能相应
            if (textStatus != "success") {
                var content = request.responseText;

            }
        }

    },
    error: function (jqXHR, textStatus, errorMsg) { // 出错时默认的处理函数
        // jqXHR 是经过jQuery封装的XMLHttpRequest对象
        // textStatus 可能为： null、"timeout"、"error"、"abort"或"parsererror"
        // errorMsg 可能为： "Not Found"、"Internal Server Error"等

        // 提示形如：发送AJAX请求到"/index.html"时出错[404]：Not Found
        console.log('发送AJAX请求到"' + this.url + '"时出错[' + jqXHR.status + ']：' + errorMsg);
    }
});

var browser = {
    versions: function () {
        var u = navigator.userAgent, app = navigator.appVersion;
        return {         //移动终端浏览器版本信息
            weixin: u.indexOf('MicroMessenger') > -1, //微信浏览器
            webKit: u.indexOf('AppleWebKit') > -1, //苹果、谷歌内核
            mobile: !!u.match(/AppleWebKit.*Mobile.*/), //是否为移动终端
            ios: !!u.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/), //ios终端
            android: u.indexOf('Android') > -1 || u.indexOf('Linux') > -1, //android终端或uc浏览器
            iPhone: u.indexOf('iPhone') > -1, //是否为iPhone或者QQHD浏览器
            iPad: u.indexOf('iPad') > -1, //是否iPad
            webApp: u.indexOf('Safari') == -1 //是否web应该程序，没有头部与底部
        };
    }(),
    language: (navigator.browserLanguage || navigator.language).toLowerCase()
}

//页面跳转封装
function toPage(url, target) {
    /* if (browser.versions.ios) {//IOS直接打开，因返回时出现token丢失
         location.href = urlHandle(url) + "&token=" + getCache("token");
         return;
     }*/
    /* var formData = new FormData();
      formData.append("token", getCache("token"));
      var request = new XMLHttpRequest();
      request.open("POST", url + param);
      request.send(formData);*/

    var form = document.createElement('form');
    form.action = urlHandle(url);
    form.method = 'post';
    var input = document.createElement('input');
    input.type = 'hidden';
    input.name = 'token';
    input.value = getCache("token");
    form.appendChild(input);
    if (target)
        $(target).append(form);
    else
        $(document.body).append(form);
    form.submit();
}

function urlHandle(url) {
    if (!url) return;
    var query = '';
    if (url.indexOf('?') > 0) {
        query = url.substring(url.indexOf('?') + 1);
        url = url.substring(0, url.indexOf('?'));
    }
    var param = '?companyId=' + getWid();
    if (query) {//过滤链接中的token,companyId
        var vars = query.split("&");
        for (var i = 0; i < vars.length; i++) {
            var pair = vars[i].split("=");
            if (pair[0] == 'token' || pair[0] == 'companyId') {
                continue;
            } else {
                param += '&' + pair[0] + '=' + pair[1];
            }
        }
    }
    url += param
    return url;
}


/**
 * 过滤URL中的参数
 * @param url
 * @param filters
 * @returns {*}
 */
function urlReplaceParam(url, filters) {
    if (!url) return;
    var query = '';
    if (url.indexOf('?') > 0) {
        query = url.substring(url.indexOf('?') + 1);
        url = url.substring(0, url.indexOf('?'));
    }
    var param = '';
    if (query) {//过滤链接中的token,companyId
        if (!(filters instanceof Array))
            filters = [filters];
        var vars = query.split("&");
        vars = vars.filter(function (value) {
            var pair = value.split("=");
            if (!pair) return;
            var exists = false;
            filters.map(function (item) {
                if (pair[0] == item) {
                    exists = true;
                    return;
                }
            })
            if (!exists)
                return value;
        })
        if (vars && vars.length > 0)
            param = "?" + vars.join('&');
    }
    url += param
    return url;
}