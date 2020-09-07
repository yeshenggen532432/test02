<%@ page language="java" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<base href="<%=basePath%>"/>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="base" value="<%=basePath%>" />
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>企微宝</title>
<!-- <link type="image/x-icon" href="img/favicon.ico" rel="icon"/> -->
<!-- <link href="img/favicon.ico" rel="shortcut icon"/> -->
<meta name="description" content="" />
<meta name="keywords" content="" />
<link rel="stylesheet" type="text/css" href="${base }/resource/themes/icon.css">
<link rel="icon" href="${base }/resource/ico/favicon.ico" type="image/x-icon" />
<link rel="shortcut icon" href="${base }/resource/ico/favicon.ico" type="image/x-icon" />

<link rel="stylesheet" href="${base }/resource/login/css/jquery.fullpage.css">
<link rel="stylesheet" type="text/css" href="${base }/resource/login/css/dd_new_index.css">


<script type="text/javascript" src="${base }/resource/jquery-1.8.0.min.js"></script>
 <!--<script src="${base }/resource/login/js/jquery.min.js"></script> -->
<script src="${base }/resource/login/js/jquery-ui.min.js"></script>
<script src="${base }/resource/login/js/jquery.fullpage.min.js"></script>
<script type="text/javascript" src="resource/md5.js"></script>
<script type="text/javascript" src="resource/showMsg.js"></script>
<script type="text/javascript" src="resource/stkstyle/js/Syunew3.js"></script>
<script type="text/javascript">
		
		/////页面效果执行/////
		$(function(){
				var height = $(window).height();
				/*alert(height);*/
				if(height > 800){
					$(".section h3").css("top","10%");
				}else{
					$(".section h3").css("top","1%");
				}
				
				function getArgs() {
					var args = {};
					var query = window.location.search.substring(1);
					var pairs = query.split("&");
					for (var i = 0; i < pairs.length; i++) {
						var pos = pairs[i].indexOf('=');
				
						if (pos != -1) {
							var argname = pairs[i].substring(0, pos);
							var value = pairs[i].substring(pos + 1);
							args[argname] = value;
						}
					}
					return args;
				};
				var args = getArgs();
				var is_jump = false;
				if(args.from != undefined) {
					is_jump = true;
				}
				var ua = window.navigator.userAgent.toLowerCase();
				if ((ua.indexOf('android') != -1) || (ua.indexOf('iphone') != -1)) {
					//if(is_jump) {
					//	location.replace('http://a.app.qq.com/o/simple.jsp?pkgname=org.pingchuan.dingwork');
					//}else 
					//if(ua.indexOf('android') != -1) {
						//location.replace('${base }/upload/app/cnlife/CnlifeApp.apk');
					//}else if(ua.indexOf('iphone') != -1) {
						//location.replace('${base }/upload/app/cnlife/CnlifeApp.ipa');
					//}
				}
				if($.browser.msie && $.browser.version < 10){
					$('body').addClass('ltie10');
				}
				//if(navigator.userAgent.indexOf('Firefox') >= 0){
					//$('#dowebok').fullpage({});
				//}
				$('#dowebok').fullpage({
					verticalCentered: false,
					anchors: ['page1', 'page2', 'page3', 'page4', 'page5', 'page6', 'page7', 'page8'],
					navigation: true,
					navigationTooltips: ['首页','易推事', '审批', '员工圈', '知识库', '通讯录', '考勤', '下载APP'],
					paddingBottom:document.body.clientHeight
				});
		});
	</script>
</head>
<body >
	<div id="dowebok">
		<!--dingding start-->
		<div class="section section21">
			<div class="bg"><img src="${base}/resource/login/picture/1-5.png" alt=""></div>
			
			<div class="hgroup"></div>
			<a href="https://www.pgyer.com/05W5" target="_blank">
				<div class="bg91"></div>
			</a>
			<div class="bg92"></div>
			<a href="https://www.pgyer.com/05W5" target="_blank">
				<div class="bg93"></div>
			</a>
		</div>
		<div class="section section22">
			<div class="bg"><img src="${base }/resource/login/picture/2-5.png" alt=""></div>
			<div class="bg81"></div>
			<div class="dd21"></div>
			<div class="dd22"></div>
			<h3>易推事</h3>
			<div class="dd23"></div>
		</div>
		<div class="section section23">
			<div class="bg"><img src="${base }/resource/login/picture/2-5-3.png" alt=""></div>
			<div class="bg81"></div>
			<div class="bg21"></div>
			<div class="bg22"></div>
			<div class="bg23"></div>
			<h3>审批</h3>
			<div class="bg24"></div>
		</div>
		<div class="section section24">
			<div class="bg"><img src="${base }/resource/login/picture/2-5-4.png" alt=""></div>
			<div class="bg81"></div>
			<div class="bg82"></div>
			<div class="bg83"></div>
			<div class="bg84"></div>
			<div class="bg85"></div>
			<h3>员工圈</h3>
			<div class="bg86"></div>
		</div>
		<div class="section section25">
			<div class="bg"><img src="${base }/resource/login/picture/2-5-5.png" alt=""></div>
			<div class="bg81"></div>
			<div class="dd21"></div>
			<div class="dd22"></div>
			<h3>知识库</h3>
			<div class="dd23"></div>
		</div>
		<div class="section section27">
			<div class="bg"><img src="${base }/resource/login/picture/7-1.png" alt=""></div>
			<div class="dd71"></div>
			<div class="dd72"></div>
			<!--<div class="dd73"></div>-->
			<div class="dd74"></div>
			<div class="dd75"></div>
			<h3>通讯录</h3>
		</div>
		<div class="section section28">
			<div class="bg"><img src="${base }/resource/login/picture/7-1-2.png" alt=""></div>
			<div class="dd81"></div>
			<div class="dd82"></div>
			<div class="dd83"></div>
			<div class="dd84"></div>
			<div class="dd85"></div>
			<h3>考勤</h3>
		</div>
		<div class="section section213">
			<div class="bg"><img src="${base }/resource/login/picture/13-5.png" alt=""></div>
			<div class="dd131"></div>
			<a href="http://mp.qweib.com/upload/app/QweibApp.apk" >
				<div class="dd132"></div>
			</a>
			<a href="http://mp.qweib.com/upload/app/QweibApp.ipa">
				<div class="dd133"></div>
			</a>
			<h3></h3>
			<div class="dd134">
					Copyright&copy 厦门企微宝网络科技有限公司<!-- </a> -->. All Rights Reserved.<br>
					<a href="${base }" target="_blank" title="企微宝">企微宝</a> 版权所有<br/>
                    <a  target="_blank" href="http://www.miitbeian.gov.cn/">闽ICP备16015739号-1</a>
					
                   
			</div>
		</div>
		<!--dingding end-->
		<!-- 点击登录框 -->
	</div>
	<div class="theme-buy">
		<a class="btn btn-primary theme-login" href="javascript:;">登录</a>
	</div>
	<div class="theme-alert">
		<div class="theme-popover-mask"></div>
		<div class="theme-popover">
			<div class="theme-poptit">
				<a href="javascript:;" title="关闭" class="close">×</a>
				<h3>登录</h3>
			</div>
			<div class="theme-popbod dform">
				<form action="${base }/manager/dologin" class="theme-signin" name="loginFrm" id="loginFrm"  method="post">
					<input type="hidden" name="usrPwd" id="usrPwd"/>
					<input type="hidden" name="idKey" id="idKey" />
					<input type="hidden" name="EncData" id="EncData"/>
					<input type="hidden" name="dogUser" id="dogUser"/>
					<input type="hidden" name="srvRnd" id="srvRnd" value="${rnd}"/>
					<ol>
						<!--<li><h4>你必须先登录！</h4></li>-->
						<li><strong>用户名：</strong><input class="ipt" name="usrNo" id="usrNo" value="${usrNo}" size="20" 
								    onkeydown="tologinSubmit(event);"/><span class="nmspan">*</span></li>
						<li><strong>密码：</strong><input class="ipt" type="password" name="tempPwd" id="tempPwd" size="20" 
								onkeydown="tologinSubmit(event);"/><span class="pwdspan">*</span></li>
						<li><input class="but2" type="text"" value=" 登 录 " onclick="toSubmit()" /></li>
					</ol>
				</form>
			</div>
		</div>
	</div>
	<!-- <script type="text/javascript">
		$(document).ready(function($){

			$('.theme-login').click(function(){
				alert(11)
				$('.theme-alert').css({
					height:"100%",
					background:"red"
				});
				$('.theme-popover-mask').show();
				$('.theme-popover-mask').height($(document).height());
				$('.theme-popover').slideDown(200);
			})
			$('.theme-poptit .close').click(function(){
				$('.theme-alert').css({
					height:"10%",
					background:"red"
				});
				$('.theme-popover-mask').hide();
				$('.theme-popover').slideUp(200)

			})

		});
</script> -->
	
	<script type="text/javascript">
		/////页面事件执行/////
		$(".btn").click(function() {
			$(".theme-alert").height($(document).height());
			$('.theme-popover-mask').show();
			$('.theme-popover').css({
				position:"fixed"
			});
			$('.theme-popover').slideDown("slow");
			$(this).hide();
		})
		$('.theme-poptit .close').click(function(){
			$('.theme-popover-mask').hide();
			$(".theme-alert").height(0);
			$('.theme-popover').slideUp("slow");
			$(".btn").show();

		})
		//提示语和用户名聚焦
		window.onload=function(){
			$("#usrNo").focus();
			showMsg("${showMsg}");
		}
		//登陆
		function toSubmit(){
			
			var tempPwd = $("#tempPwd").val();
			var usrNo = $("#usrNo").val();
			if(usrNo==''){
				$('.nmspan').html("用户名不能为空");
				return;
			}else{
				$('.nmspan').html("*");
			}
			if(tempPwd==''){
				$('.pwdspan').html("密码不能为空");
				return;
			}else{
				$('.pwdspan').html("*");
			}
			$("#usrPwd").val(hex_md5(tempPwd));
			checkDog();
			
		}
		
		
		//回车登陆
		function tologinSubmit(e){
			var key = window.event?e.keyCode:e.which;
			if(key==13){
				toSubmit();
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
		    	$("#loginFrm").submit();
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
			                    	$("#loginFrm").submit();
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
		                        $("#loginFrm").submit();
		 
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
				$("#loginFrm").submit();
				
				return ;

			}
			catch (e) 
			{
				alert(e.name + ": " + e.message+"。可能是没有安装相应的控件或插件");
			}
		}
		load();
	</script>
</body>
</html>