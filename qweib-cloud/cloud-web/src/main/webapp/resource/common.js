/****全局变量****/
var UA = navigator.userAgent.toLowerCase();
//判断浏览器
var NV = { 
	version: (UA.match( /.+(?:rv|it|ra|ie)[\/: ]([\d.]+)/ ) || [])[1], 
	safari: ( (/safari/.test(UA)) && (!(/chrome/.test(UA))) ), 
	opera:  /opera/.test(UA),
	chrome:( (/chrome/.test(UA)) && (!(/maxthon/.test(UA))) ),
	msie: /msie/.test(UA), 
	firefox: /firefox/.test(UA),
	maxthon: /maxthon/.test(UA)
};

/****通用方法****/
//去空格
function trim(str){
	if(null==str||str==undefined||str==""){
		return "";
	}
	str = str.replace(/(^\s*)|(\s*$)/g, "");
	str = str.replace(/[\r\n]/g, ""); //去掉回车换行
	return str;
}
//日期格式化
function dateFormate(obj){
	if(obj==null||obj==undefined){
		return "";
	}else{
		var year = obj.getYear();
		var month = obj.getMonth()+1;
		var date = obj.getDate();
		return year+"-"+monthFormate(month)+"-"+date;
	}
}

//日期格式化(2014-03-27 13:47:44.0)
function dateFormateStr(obj,patten){
	if(obj==""||obj==null){
		return null;
	}
	var arys = obj.split(" ");
	var date = arys[0];
	var time = arys[1];
	time = time.substring(0,time.length-1);
	var ymd = date.split("-");
	if(patten=="yyyy年MM月dd日"){
		return ymd[0]+"年"+ymd[1]+"月"+ymd[2]+"日";
	}else if(patten=="yyyy年MM月dd日  hh:mm:ss"){
		return ymd[0]+"年"+ymd[1]+"月"+ymd[2]+"日 "+hms;
	}
	return ymd[0]+"年"+ymd[1]+"月"+ymd[2]+"日";
}

//月份格式化
function monthFormate(month){
	if(month<10){
		return "0"+month;
	}else{
		return month;
	}
}
//说明： 判断是否为数字(包括负值)
function isFloat(iNum){
	if(!iNum){
		return false;
	}
	var strP = /^(-{0,1})\d+(\.\d+)?$/;    //数字的正则表达
	//不符合正则表达失，返回false
	if(!strP.test(iNum)){
		return false;
	}
	try{
  		if(parseFloat(iNum)!=iNum){
  			return false;
  		}
  	}catch(ex){
   		return false;
  	}
  	return true;
}
//只允许输入正整数
function inputNumber(e){
	var code = (e.keyCode ? e.keyCode : e.which);
	if( (code>=48&&code<=57) || (code>=96&&code<=105) || code==8 || code==13 || code==37 || code==39 ){
		return;
	}
	if(NV.firefox){
		e.preventDefault();
	}else if(NV.chrome){
		//229--在输入法状态下的键盘值
		if(code==229){
			obj.blur();
			return;
		}
		e.preventDefault();
	}else if(NV.opera){
		e.preventDefault();
	}else if(NV.safari){
		e.preventDefault();
	}else if(NV.maxthon){
		//229--在输入法状态下的键盘值
		if(code==229){
			obj.blur();
			return;
		}
		e.preventDefault();
	}else if(NV.msie){
		var version = NV.version;
		if(version>8){
			e.preventDefault();
		}else{
			e.returnValue=false;
		}
	}
	return;
}
//只允许输入正负整数
function inputNumbers(e,obj){
	var code = (e.keyCode ? e.keyCode : e.which);
	if( (code>=48&&code<=57) || (code>=96&&code<=105) || code==8 || code==13 || code==37 || code==39 ){
		return;
	}
	//'-'
	if((code==109||code==189)&&obj.selectionStart==0){
		return;
	}
	if(NV.firefox){
		e.preventDefault();
	}else if(NV.chrome){
		//229--在输入法状态下的键盘值
		if(code==229){
			obj.blur();
			return;
		}
		e.preventDefault();
	}else if(NV.opera){
		e.preventDefault();
	}else if(NV.safari){
		e.preventDefault();
	}else if(NV.maxthon){
		//229--在输入法状态下的键盘值
		if(code==229){
			obj.blur();
			return;
		}
		e.preventDefault();
	}else if(NV.msie){
		var version = NV.version;
		if(version>8){
			e.preventDefault();
		}else{
			e.returnValue=false;
		}
	}
	return;
}
//只允许输入正数
function inputFloat(e,obj){
	var code = (e.keyCode ? e.keyCode : e.which);
	if( (code>=48&&code<=57) || (code>=96&&code<=105) || code==8 || code==13 || code==37 || code==39 ){
		return;
	}
	//'.' 
	if(code==190||code==110){
		var vl = obj.value; 
		if(vl.indexOf(".")==-1){
			return;
		}
	}
	if(NV.firefox){
		e.preventDefault();
	}else if(NV.chrome){
		//229--在输入法状态下的键盘值
		if(code==229){
			obj.blur();
			return;
		}
		e.preventDefault();
	}else if(NV.opera){
		e.preventDefault();
	}else if(NV.safari){
		e.preventDefault();
	}else if(NV.maxthon){
		//229--在输入法状态下的键盘值
		if(code==229){
			obj.blur();
			return;
		}
		e.preventDefault();
	}else if(NV.msie){
		var version = NV.version;
		if(version>8){
			e.preventDefault();
		}else{
			e.returnValue=false;
		}
	}
	return;
}
//只允许输入正负数
function inputFloats(e,obj){
	var code = (e.keyCode ? e.keyCode : e.which);
	if( (code>=48&&code<=57) || (code>=96&&code<=105) || code==8 || code==13 || code==37 || code==39 ){
		return;
	}
	//'-'
	if((code==109||code==189)&&obj.selectionStart==0){
		return;
	}
	//'.' 
	if(code==190||code==110){
		var vl = obj.value; 
		if(vl.indexOf(".")==-1){
			return;
		}
	}
	if(NV.firefox){
		e.preventDefault();
	}else if(NV.chrome){
		//229--在输入法状态下的键盘值
		if(code==229){
			obj.blur();
			return;
		}
		e.preventDefault();
	}else if(NV.opera){
		e.preventDefault();
	}else if(NV.safari){
		e.preventDefault();
	}else if(NV.maxthon){
		//229--在输入法状态下的键盘值
		if(code==229){
			obj.blur();
			return;
		}
		e.preventDefault();
	}else if(NV.msie){
		var version = NV.version;
		if(version>8){
			e.preventDefault();
		}else{
			e.returnValue=false;
		}
	}
	return;
}
//说明： 判断是否为数字(不包括负值)
function isNumber(iNum){
	if(!iNum){
		return false;
	}
	var strP = /^\d+$/;    //数字的正则表达
	//不符合正则表达失，返回false
	if(!strP.test(iNum)){
		return false;
	}
	try{
  		if(parseFloat(iNum)!=iNum){
  			return false;
  		}
  	}catch(ex){
   		return false;
  	}
  	return true;
}
//说明： 判断是否为数字(包括负值)
function isNumbers(iNum){
	if(!iNum){
		return false;
	}
	var strP = /^-{0,1}\d+$/;    //数字的正则表达
	//不符合正则表达失，返回false
	if(!strP.test(iNum)){
		return false;
	}
	try{
  		if(parseFloat(iNum)!=iNum){
  			return false;
  		}
  	}catch(ex){
   		return false;
  	}
  	return true;
}
/*
 *说明： 判断是否为中文
 *@创建：作者:yxy
 */
function isExistZh(vl){
	if(!vl){
		return false;
	}
	var strP = /^.*[\u4E00-\u9FA5]+.*$/;//正则表达
	//不符合正则表达失，返回false
	if(!strP.test(vl)){
		return false;
	}
  	return true;
}
//允许图片的格式
var allowImgExt=".jpg|.jpeg|.png|";
function checkExt(obj,msg){
	if(obj.value==""){
		return false;
	}
	var fileExt=obj.value.substr(obj.value.lastIndexOf(".")).toLowerCase();
	//判断文件类型是否允许上传
	if(allowImgExt.indexOf(fileExt+"|")==-1) {
		$.messager.alert('提示信息',msg+"必须为jpg或者png格式的图片");
		obj.value="";
	    return false;
	}
	return true;
}
//重填
function toreset(frm){
	document.getElementById(frm).reset();
}
//弹出提示信息
function showMsg(msg){
	$.messager.alert('提示信息',msg,'info');
}
//添加编辑器
var kindEditor={};
function addEditor(textarea,form){
	KindEditor.ready(function(K) {
		kindEditor = KindEditor.create('textarea[name="'+textarea+'"]', {
			cssPath : '/cnlife/resource/kindeditor/plugins/code/prettify.css',
			uploadJson : '/cnlife/resource/kindeditor/jsp/upload_json.jsp',
			fileManagerJson : '/cnlife/resource/kindeditor/jsp/file_manager_json.jsp',
			allowFileManager : true
		});
	});
}
function myformatter(date){
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
}
function getScrollTop(){
	var scrollTop=0;
	if(document.documentElement&&document.documentElement.scrollTop){
		scrollTop=document.documentElement.scrollTop;
	}else if(document.body){
		scrollTop=document.body.scrollTop;
	}
	return scrollTop;
}
//加法函数  
function accAdd(arg1, arg2) {  
    var r1, r2, m;  
    try {  
        r1 = arg1.toString().split(".")[1].length;  
    }  
    catch (e) {  
        r1 = 0;  
    }  
    try {  
        r2 = arg2.toString().split(".")[1].length;  
    }  
    catch (e) {  
        r2 = 0;  
    }  
    m = Math.pow(10, Math.max(r1, r2));  
    return (arg1 * m + arg2 * m) / m;  
}   
//给Number类型增加一个add方法，，使用时直接用 .add 即可完成计算。   
Number.prototype.add = function (arg) {  
    return accAdd(arg, this);  
};  
  
//减法函数  
function Subtr(arg1, arg2) {  
    var r1, r2, m, n;  
    try {  
        r1 = arg1.toString().split(".")[1].length;  
    }
    catch (e) {  
        r1 = 0;  
    }
    try {  
        r2 = arg2.toString().split(".")[1].length;  
    }
    catch (e) {  
        r2 = 0;  
    }
    m = Math.pow(10, Math.max(r1, r2));  
     //last modify by deeka  
     //动态控制精度长度  
    n = (r1 >= r2) ? r1 : r2;  
    return ((arg1 * m - arg2 * m) / m).toFixed(n);  
}
  
//给Number类型增加一个add方法，，使用时直接用 .sub 即可完成计算。   
Number.prototype.sub = function (arg) {  
    return Subtr(this, arg);  
};  
  
//乘法函数  
function accMul(arg1, arg2) {  
    var m = 0, s1 = arg1.toString(), s2 = arg2.toString();  
    try {  
        m += s1.split(".")[1].length;  
    }  
    catch (e) {  
    }  
    try {  
        m += s2.split(".")[1].length;  
    }  
    catch (e) {  
    }  
    return Number(s1.replace(".", "")) * Number(s2.replace(".", "")) / Math.pow(10, m);  
}   
//给Number类型增加一个mul方法，使用时直接用 .mul 即可完成计算。   
Number.prototype.mul = function (arg) {  
    return accMul(arg, this);  
};   
  
//除法函数  
function accDiv(arg1, arg2) {  
    var t1 = 0, t2 = 0, r1, r2;  
    try {  
        t1 = arg1.toString().split(".")[1].length;  
    }  
    catch (e) {  
    }  
    try {  
        t2 = arg2.toString().split(".")[1].length;  
    }  
    catch (e) {  
    }  
    with (Math) {  
        r1 = Number(arg1.toString().replace(".", ""));  
        r2 = Number(arg2.toString().replace(".", ""));  
        return (r1 / r2) * pow(10, t2 - t1);  
    }  
}   
//给Number类型增加一个div方法，，使用时直接用 .div 即可完成计算。   
Number.prototype.div = function (arg) {  
    return accDiv(this, arg);  
};
function CheckInFloat(oInput)
{
	if(window.event.keyCode==37||window.event.keyCode==37){
		return;
	}
    if('' != oInput.value.replace(/\d{1,}\.{0,1}\d{0,}/,''))
    {
        oInput.value = oInput.value.match(/\d{1,}\.{0,1}\d{0,}/) == null ? '' :oInput.value.match(/\d{1,}\.{0,1}\d{0,}/);
    }
}
//只能输入数字
$(document).on("keyup",".number",function(){//keyup事件处理
	$(this).val($(this).val().replace(/\D|^0/g,''));
})