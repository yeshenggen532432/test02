var digitArray = new Array('0', '1', '2', '3', '4', '5', '6', '7',
    '8', '9', 'a', 'b', 'c', 'd', 'e', 'f');

function toHex(n) {

    var result = ''
    var start = true;

    for (var i = 32; i > 0;) {
        i -= 4;
        var digit = (n >> i) & 0xf;

        if (!start || digit != 0) {
            start = false;
            result += digitArray[digit];
        }
    }

    return (result == '' ? '0' : result);
}

//软件狗操作

var bConnect = 0;

function initSecurityDog() {



}

var keyid = "";//软件狗系列号
var gMemId = 0;
var gMobile = "";

function writeDogProc(memberId, mobile) {
    gMemId = memberId;
    gMobile = mobile;
    writeDog();
}


function updateDog(memberId, useDog) {
    $.ajax({
        url: "/manager/updateUseDog",
        type: "post",
        data: {
            memberId: memberId,
            useDog: useDog,
            idKey: keyid
        },
        success: function (data) {
            if (data == '1') {
                uglcw.ui.success("设置成功");
                uglcw.ui.get('#grid').reload();
            } else {
                uglcw.ui.error("设置失败");
                return;
            }
        }
    });
}

function writeDog() {
    //如果是IE10及以下浏览器，则使用AVCTIVEX控件的方式

    if (navigator.userAgent.indexOf("MSIE") > 0
        && !navigator.userAgent.indexOf("opera") > -1)
        return Handle_IE10();

    //判断是否安装了服务程序，如果没有安装提示用户安装

    if (bConnect == 0) {
        uglcw.ui.warning("未能连接服务程序，请确定服务程序是否安装。");
        return false;

    }
    try {
        var DevicePath, mylen, ret, username, mykey, outstring, address, mydata, i, InString, versionex, version,
            seed;
        var ProduceDate, macAddr;

        //由于是使用事件消息的方式与服务程序进行通讯，

        //好处是不用安装插件，不分系统及版本，控件也不会被拦截，同时安装服务程序后，可以立即使用，不用重启浏览器

        //不好的地方，就是但写代码会复杂一些

        var s_simnew1 = new SoftKey3W(); //创建UK类

        s_simnew1.Socket_UK.onopen = function () {

            s_simnew1.ResetOrder();//这里调用ResetOrder将计数清零，这样，消息处理处就会收到0序号的消息，通过计数及序号的方式，从而生产流程

        }

        //写代码时一定要注意，每调用我们的一个UKEY函数，就会生产一个计数，即增加一个序号，较好的逻辑是一个序号的消息处理中，只调用我们一个UKEY的函数

        s_simnew1.Socket_UK.onmessage = function got_packet(Msg) {

            var UK_Data = JSON.parse(Msg.data);

            if (UK_Data.type != "Process")
                return;//如果不是流程处理消息，则跳过

            //alert(Msg.data);

            switch (UK_Data.order) {

                case 0: {

                    s_simnew1.FindPort(0);//查找加密锁

                }

                    break;//!!!!!重要提示，如果在调试中，发现代码不对，一定要注意，是不是少了break,这个少了是很常见的错误
                case 1: {
                    if (UK_Data.LastError != 0) {
                        uglcw.ui.error("sWriteEx_2让加密锁进行普通解密运算时错误，错误码为："
                            + UK_Data.LastError.toString());
                        s_simnew1.Socket_UK.close();
                        return false;
                    }
                    //window.alert ("对数据3456进行使用普通算法二普通解密运算后的结果是："+UK_Data.return_value.toString());
                    DevicePath = UK_Data.return_value;//获得返回的UK的路径
                    s_simnew1.GetID_1(DevicePath); //'读取锁的ID
                }
                    break;
                case 2: {
                    if (UK_Data.LastError != 0) {
                        uglcw.ui.error("读取锁的ID时错误，错误码为："
                            + UK_Data.LastError.toString());
                        s_simnew1.Socket_UK.close();
                        return false;
                    }
                    keyid = toHex(UK_Data.return_value);
                    s_simnew1.GetID_2(DevicePath); //'读取锁的ID
                }
                    break;
                case 3: {
                    if (UK_Data.LastError != 0) {
                        uglcw.ui.error("读取锁的ID时错误，错误码为："
                            + UK_Data.LastError.toString());
                        s_simnew1.Socket_UK.close();
                        return false;
                    }
                    keyid = keyid + toHex(UK_Data.return_value);
                    //window.alert ("锁的ID是："+keyid);
                    InString = "" + gMobile;
                    //写入字符串到UK的地址1中
                    address = 1;
                    s_simnew1.YWriteString(InString, address,
                        "ffffffff", "ffffffff", DevicePath); //写入字符串带长度,使用默认的读密码
                }
                    break;

                case 4: {
                    if (UK_Data.LastError != 0) {
                        uglcw.ui.error("写入字符串(带长度)错误。错误码为："
                            + UK_Data.LastError.toString());
                        s_simnew1.Socket_UK.close();
                        return false;
                    }
                    nlen = UK_Data.return_value;

                    //设置字符串长度到缓冲区中,
                    s_simnew1.SetBuf(nlen, 0);
                }
                    break;
                case 5: {
                    if (UK_Data.LastError != 0) {
                        uglcw.ui.error("SetBuf设置缓冲区时错误，错误码为："
                            + UK_Data.LastError.toString());
                        s_simnew1.Socket_UK.close();
                        return false;
                    }
                    //将缓冲区的数据即字符串长度写入到UK的地址0中

                    address = 0;

                    s_simnew1.YWriteEx(address, 1, "ffffffff",
                        "ffffffff", DevicePath);//写入字符串的长度到地址0
                }
                    break;

                case 6: {
                    //window.alert("初始化加密锁成功");
                    updateDog(gMemId, 1, keyid);
                }
                    break;

            }
        }

        s_simnew1.Socket_UK.onclose = function () {

        }

        return true;
    } catch (e) {
        alert(e.name + ": " + e.message);
        return false;
    }

}

function Handle_IE10() {

    try {
        var DevicePath, mylen, ret, username, mykey, outstring, address, mydata, i, InString, versionex, version,
            seed;

        //建立操作我们的锁的控件对象，
        s_simnew1 = new ActiveXObject("Syunew3A.s_simnew3");

        DevicePath = s_simnew1.FindPort(0);//'查找加密锁
        //DevicePath = s_simnew1.FindPort_2(0,1,  70967193);//'查找指定的加密锁（使用普通算法）
        if (s_simnew1.LastError != 0) {
            window.alert("未发现加密锁，请插入加密锁");
            return false;
        } else {
            keyid = toHex(s_simnew1.GetID_1(DevicePath))
                + toHex(s_simnew1.GetID_2(DevicePath));
            if (s_simnew1.LastError != 0) {
                window.alert("获取ID错误,错误码是"
                    + s_simnew1.LastError.toString());
                return false;
            }

            InString = gMobile;

            //写入字符串到地址1
            nlen = s_simnew1.YWriteString(InString, 1, "ffffffff",
                "ffffffff", DevicePath);
            if (s_simnew1.LastError != 0) {
                window.alert("写入字符串(带长度)错误。");
                return false;
            }
            //写入字符串的长度到地址0
            s_simnew1.SetBuf(nlen, 0);
            ret = s_simnew1.YWriteEx(0, 1, "ffffffff", "ffffffff",
                DevicePath);
            if (ret != 0) {
                window.alert("写入字符串长度错误。错误码：");
                return false;
            }

            updateDog(gMemId, 1, keyid);

        }

        return true;
    } catch (e) {
        alert(e.name + ": " + e.message);
        return false;
    }

}