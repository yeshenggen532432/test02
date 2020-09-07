<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<base href="<%=basePath%>"/>
<c:set var="base" value="<%=basePath%>" />
<!DOCTYPE html>
<html style="overflow-x:hidden;overflow-y:auto;" class="">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>企微宝--云上微管理平台</title>
	<meta http-equiv="Cache-Control" content="no-store">
	<meta http-equiv="Pragma" content="no-cache">
	<meta http-equiv="Expires" content="0">
	<meta http-equiv="X-UA-Compatible" content="IE=7,IE=9,IE=10,IE=edge">
	<link href="${base }/resource/login/css/bootstrap.min.css" type="text/css" rel="stylesheet">
	<link href="${base }/resource/login/css/login.css" type="text/css" rel="stylesheet">
	<link rel="icon" href="${base }/resource/ico/favicon.ico" type="image/x-icon" />
	<link rel="shortcut icon" href="${base }/resource/ico/favicon.ico" type="image/x-icon" />
	<script type="text/javascript" src="${base }/resource/jquery-1.8.0.min.js"></script>
	<script type="text/javascript" src="<%=basePath %>/resource/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="${base }/resource/md5.js"></script>
	<script type="text/javascript" src="${base }/resource/showMsg.js"></script>
	<script type="text/javascript" src="${base }/resource/stkstyle/js/Syunew3.js"></script>

	<meta name="decorator" content="default">
	<style type="text/css">
		input{height:30px;*margin-top:4px;line-height:30px;border-radius: 4px;}
	</style>
</head>
<body style="background-image: url('${base }/resource/login/images/login-bg-1.jpg');">
<div class="container">
	<!--[if lte IE 6]><br/><div class='alert alert-block' style="text-align:left;padding-bottom:10px;"><a class="close" data-dismiss="alert">x</a><h4>温馨提示：</h4><p>你使用的浏览器版本过低。为了获得更好的浏览体验，我们强烈建议您 <a href="http://browsehappy.com" target="_blank">升级</a> 到最新版本的IE浏览器，或者使用较新版本的 Chrome、Firefox、Safari 等。</p></div><![endif]-->
	<div id="messageBox" class="alert alert-error hide" style="filter:alpha(opacity:30); opacity:0.8;"><button data-dismiss="alert" class="close" onclick="funCloseMsg()">×</button>
		<label id="loginError" class="error"></label>
	</div>
	<div id="login-wraper">
		<form name="loginFrm" id="loginFrm" class="form login-form" action="${base}/manager/reDoLogin" method="post" novalidate="novalidate">
			<input type="hidden" name="usrPwd" id="usrPwd"/>
			<input type="hidden" name="idKey" id="idKey" />
			<input type="hidden" name="EncData" id="EncData"/>
			<input type="hidden" name="dogUser" id="dogUser"/>
			<input type="hidden" name="srvRnd" id="srvRnd" value="${rnd}"/>
			<legend><span style="color:#08c;">企微宝</span></legend>
			<div class="body">
				<div class="control-group">
					<div class="controls">
						<input type="text" name="usrNo" id="usrNo" value="${usrNo}" class="required" style="height: 30px" value="" placeholder="登录名">
					</div>
				</div>
				<div class="control-group">
					<div class="controls">
						<input type="password" onkeydown="tologinSubmit(event);" name="tempPwd" id="tempPwd" class="required" style="height: 30px" placeholder="密码">
					</div>
				</div>
			</div>
			<div class="footer">
				<label class="checkbox inline">
					<input type="checkbox" id="rememberMe" name="rememberMe"> <span style="color:yellow;">记住我</span>
				</label>
				<input class="btn btn-primary" type="button" value="登 录"  onclick="toSubmit()">
			</div>
		</form>
	</div>
</div>
</body>
</html>
<script>
	//回车登录
	function tologinSubmit(e){
		var key = window.event?e.keyCode:e.which;
		if(key==13){
			toSubmit();
		}
	}
	//登陆
	function toSubmit(){
		var tempPwd = $("#tempPwd").val();
		var usrNo = $("#usrNo").val();
		if(usrNo==''){
			$("#loginError").html("用户名不能为空!");
			$("#messageBox").show();
			setTimeout(function(){$("#messageBox").hide();},3000);
			return false;
		}
		if(tempPwd==''){
			$("#loginError").html("密码不能为空!");
			$("#messageBox").show();
			setTimeout(function(){$("#messageBox").hide();},3000);
			return false;
		}
		if(document.getElementById("rememberMe").checked==true){
			setCookie();
		}else{
			delCookie();
		}
		$("#usrPwd").val(hex_md5(tempPwd));
		checkDog();

	}

	function login() {
		$("#loginFrm").form('submit',{
			success:function(data){
				var json = eval("("+data+")");
				if(json.state){
					window.parent.$("#reLoginWindow").window('close');
				}else{
					alert(json.msg);
				}
			}
		});
	}

	function funCloseMsg(){
		$("#messageBox").hide();
	}
	//提示语和用户名聚焦
	window.onload=function(){
		$("#usrNo").focus();
		//showMsg("${showMsg}");
		$("#loginError").html(getMsg("${showMsg}"));
		if("${showMsg}"!=""){
			$("#messageBox").show();
			setTimeout(function(){$("#messageBox").hide();},3000);
		}
	}
	var bConnect=0;
	function load()
	{
		//如果是IE10及以下浏览器，则跳过不处理
		if(navigator.userAgent.indexOf("MSIE")>0 && !navigator.userAgent.indexOf("opera") > -1) return;
		try
		{
			var s_pnp=new SoftKey3W();
			s_pnp.Socket_UK.onopen = function()
			{
				bConnect=1;//代表已经连接，用于判断是否安装了客户端服务
			}
			//在使用事件插拨时，注意，一定不要关掉Sockey，否则无法监测事件插拨
			s_pnp.Socket_UK.onmessage =function got_packet(Msg)
			{
				var PnpData = JSON.parse(Msg.data);
				if(PnpData.type=="PnpEvent")//如果是插拨事件处理消息
				{
					if(PnpData.IsIn)
					{
						//alert("UKEY已被插入，被插入的锁的路径是："+PnpData.DevicePath);
					}
					else
					{
						//alert("UKEY已被拨出，被拨出的锁的路径是："+PnpData.DevicePath);
					}
				}
			}
			s_pnp.Socket_UK.onclose = function()
			{
			}
		}
		catch(e)
		{
			alert(e.name + ": " + e.message);
			return false;
		}
	}
	var digitArray = new Array('0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f');
	function toHex( n ) {
		var result = ''
		var start = true;
		for ( var i=32; i>0; ) {
			i -= 4;
			var digit = ( n >> i ) & 0xf;

			if (!start || digit != 0) {
				start = false;
				result += digitArray[digit];
			}
		}

		return ( result == '' ? '0' : result );
	}
	function checkDog()
	{
		//如果是IE10及以下浏览器，则使用AVCTIVEX控件的方式
		if(navigator.userAgent.indexOf("MSIE")>0 && !navigator.userAgent.indexOf("opera") > -1) return Handle_IE10();

		//判断是否安装了服务程序，如果没有安装提示用户安装
		if(bConnect==0)
		{
			//window.alert ( "未能连接服务程序，请确定服务程序是否安装。");return false;
			login();
			return false;
		}
		var DevicePath,ret,n,mylen,ID_1,ID_2,addr;
		try
		{
			//由于是使用事件消息的方式与服务程序进行通讯，
			//好处是不用安装插件，不分系统及版本，控件也不会被拦截，同时安装服务程序后，可以立即使用，不用重启浏览器
			//不好的地方，就是但写代码会复杂一些
			var s_simnew1=new SoftKey3W(); //创建UK类

			s_simnew1.Socket_UK.onopen = function() {
				s_simnew1.ResetOrder();//这里调用ResetOrder将计数清零，这样，消息处理处就会收到0序号的消息，通过计数及序号的方式，从而生产流程
			}
			//写代码时一定要注意，每调用我们的一个UKEY函数，就会生产一个计数，即增加一个序号，较好的逻辑是一个序号的消息处理中，只调用我们一个UKEY的函数
			s_simnew1.Socket_UK.onmessage =function got_packet(Msg)
			{
				var UK_Data = JSON.parse(Msg.data);
				// alert(Msg.data);
				if(UK_Data.type!="Process")return ;//如果不是流程处理消息，则跳过
				switch(UK_Data.order)
				{
					case 0:
					{
						s_simnew1.FindPort(0);//发送命令取UK的路径
					}
						break;//!!!!!重要提示，如果在调试中，发现代码不对，一定要注意，是不是少了break,这个少了是很常见的错误
					case 1:
					{
						if( UK_Data.LastError!=0){
							//window.alert ( "未发现加密锁，请插入加密锁");
							s_simnew1.Socket_UK.close();
							login();
							return false;
						}
						DevicePath=UK_Data.return_value;//获得返回的UK的路径
						s_simnew1.GetID_1(DevicePath); //发送命令取ID_1
					}
						break;
					case 2:
					{
						if( UK_Data.LastError!=0){ window.alert("返回ID号错误，错误码为："+UK_Data.LastError.toString());s_simnew1.Socket_UK.close();return false;}
						ID_1=UK_Data.return_value;//获得返回的UK的ID_1
						s_simnew1.GetID_2(DevicePath); //发送命令取ID_2
					}
						break;
					case 3:
					{
						if( UK_Data.LastError!=0){ window.alert("取得ID错误，错误码为："+UK_Data.LastError.toString());s_simnew1.Socket_UK.close();return false;}
						ID_2=UK_Data.return_value;//获得返回的UK的ID_2
						loginFrm.idKey.value=toHex(ID_1)+toHex(ID_2);
						s_simnew1.ContinueOrder();//为了方便阅读，这里调用了一句继续下一行的计算的命令，因为在这个消息中没有调用我们的函数，所以要调用这个
					}
						break;
					case 4:
					{
						//获取设置在锁中的用户名
						//先从地址0读取字符串的长度,使用默认的读密码"FFFFFFFF","FFFFFFFF"
						addr=0;
						s_simnew1.YReadEx(addr,1,"ffffffff","ffffffff",DevicePath);//发送命令取UK地址0的数据
					}
						break;
					case 5:
					{
						if( UK_Data.LastError!=0){ window.alert("读数据时错误，错误码为："+UK_Data.LastError.toString());s_simnew1.Socket_UK.close();return false;}
						s_simnew1.GetBuf(0);//发送命令从数据缓冲区中数据
					}
						break;
					case 6:
					{
						if( UK_Data.LastError!=0){ window.alert("调用GetBuf时错误，错误码为："+UK_Data.LastError.toString());s_simnew1.Socket_UK.close();return false;}
						mylen=UK_Data.return_value;//获得返回的数据缓冲区中数据
						//再从地址1读取相应的长度的字符串，,使用默认的读密码"FFFFFFFF","FFFFFFFF"
						addr=1;
						s_simnew1.YReadString(addr,mylen, "ffffffff", "ffffffff", DevicePath);//发送命令从UK地址1中取字符串
					}
						break;
					case 7:
					{
						if( UK_Data.LastError!=0){ window.alert("读取字符串时错误，错误码为："+UK_Data.LastError.toString());s_simnew1.Socket_UK.close();return false;}
						loginFrm.dogUser.value=UK_Data.return_value;//获得返回的UK地址1的字符串
						//这里返回对随机数的HASH结果
						var str = "" + loginFrm.srvRnd.value;
						s_simnew1.EncString(str,DevicePath);//发送命令让UK进行加密操作
					}
						break;
					case 8:
					{
						if( UK_Data.LastError!=0){ window.alert("进行加密运行算时错误，错误码为："+UK_Data.LastError.toString());s_simnew1.Socket_UK.close();return false;}
						loginFrm.EncData.value=UK_Data.return_value;//获得返回的加密后的字符串
						//!!!!!注意，这里一定要主动提交，
						login()
						//所有工作处理完成后，关掉Socket
						s_simnew1.Socket_UK.close();
					}
						break;
				}
			}
			s_simnew1.Socket_UK.onclose = function(){

			}
			return true;
		}
		catch (e)
		{
			alert(e.name + ": " + e.message);
		}
	}
	function Handle_IE10()
	{
		var DevicePath,ret,n,mylen;
		try
		{
			//建立操作我们的锁的控件对象，用于操作我们的锁
			var s_simnew1;
			//创建控件
			s_simnew1=new ActiveXObject("Syunew3A.s_simnew3");
			//查找是否存在锁,这里使用了FindPort函数
			DevicePath = s_simnew1.FindPort(0);
			if( s_simnew1.LastError!= 0 )
			{
				//window.alert ( "未发现加密锁，请插入加密锁。");
				return false;
			}
			//'读取锁的ID
			loginFrm.idKey.value=toHex(s_simnew1.GetID_1(DevicePath))+toHex(s_simnew1.GetID_2(DevicePath));
			if( s_simnew1.LastError!= 0 )
			{
				window.alert( "返回ID号错误，错误码为："+s_simnew1.LastError.toString());
				return false;
			}
			//获取设置在锁中的用户名
			//先从地址0读取字符串的长度,使用默认的读密码"FFFFFFFF","FFFFFFFF"
			ret=s_simnew1.YReadEx(0,1,"ffffffff","ffffffff",DevicePath);
			mylen =s_simnew1.GetBuf(0);
			//再从地址1读取相应的长度的字符串，,使用默认的读密码"FFFFFFFF","FFFFFFFF"
			loginFrm.dogUser.value=s_simnew1.YReadString(1,mylen, "ffffffff", "ffffffff", DevicePath);
			if( s_simnew1.LastError!= 0 )
			{
				window.alert(  "读取用户名时错误，错误码为："+s_simnew1.LastError.toString());
				return false;
			}
			//这里返回对随机数的HASH结果
			var str = "" + loginFrm.srvRnd.value;
			loginFrm.EncData.value=s_simnew1.EncString(str,DevicePath);
			if( s_simnew1.LastError!= 0 )
			{
				window.alert( "进行加密运行算时错误，错误码为："+s_simnew1.LastError.toString());
				return false;
			}
			login();
			return ;
		}
		catch (e)
		{
			alert(e.name + ": " + e.message+"。可能是没有安装相应的控件或插件");
		}
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
		var startName =CookieString.substring(0, CookieString.indexOf("="));
		if(startName=="JSESSIONID"){
			return;
		}
		if(startName=="JSESSIONID"){//表示JSESSIONID在前面
			name=CookieString.substring(CookieString.replace('=','a').indexOf('=')+1);//截取第二个“=”之后的字符串
		}else{
			//start = CookieString.indexOf("=");
			//end = CookieString.indexOf(";");
			//name = CookieString.substring(start + 1, end);
			name=CookieString;
		}
		name = decodeURIComponent(name);
		if(name=="JSESSIONID="){
			return;
		}
		var arr = name.split("##");

		if(arr!=undefined){
			var useNos= arr[0].split('name=');
			if(useNos[1]!=undefined){
				document.getElementsByName("usrNo")[0].value =useNos[1];
			}
		}
		if(arr[1]!=undefined){
			document.getElementsByName("tempPwd")[0].value = arr[1].substring(arr[1].indexOf('='));
		}
		document.getElementById("rememberMe").checked = true;
	}
	function delCookie(){
		var expires = new Date();
		expires.setTime(expires.getTime() + 12 * 30 * 24 * 60 * 60 * 1000*(-1));//设置用户名可以保存一年
		var nameString;//用户名
		var expireString;//过期时间
		expireString = expires.toGMTString();
		var cookieString = 'name=;expires=' + expireString ;//设置Cookie为name=""和expires=""
		document.cookie = cookieString	;
	}
	/*
     *说明：进入页面设置Cookie值
     */
	function setCookie(){
		var expires = new Date();
		expires.setTime(expires.getTime() + 12 * 30 * 24 * 60 * 60 * 1000);//设置用户名可以保存一年
		var nameString;//用户名
		var expireString;//过期时间
		nameString = document.getElementsByName("usrNo")[0].value+
				'##'+document.getElementsByName("tempPwd")[0].value+'##'+document.getElementById("rememberMe").checked;
		expireString = expires.toGMTString();
		var cookieString = 'name=' + encodeURIComponent(nameString)+ ';expires=' + expireString ;//设置Cookie为name=""和expires=""
		document.cookie = cookieString	;
	}
	load();
	getCookie();
</script>