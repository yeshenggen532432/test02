/**
 * 判断字符串是否已str开头
 * @param str
 * @returns {Boolean}
 */
String.prototype.startWith=function(str){
if(str==null||str==""||this.length==0||str.length>this.length)
  return false;
if(this.substr(0,str.length)==str)
  return true;
else
  return false;
return true;
}
/**
 * 判断字符串是否str以结尾
 * @param str
 * @returns {Boolean}
 */
 String.prototype.endWith=function(str){  
     if(str==null||str==""||this.length==0||str.length>this.length)  
       return false;  
     if(this.substring(this.length-str.length)==str)  
       return true;  
     else  
       return false;  
     return true;  
 }  

//防止缓存页面
function addPresentTime(URL){
	var dynamicTime = new Date();
	dynamicTime = dynamicTime.getTime();
	
	//对已经有次参数的地址，不继续追加！
	if(URL.indexOf("newtime=") != -1){
		URL = URL.replace(/(\?|\&)newtime=\d*/,'')
	}	
	var n = (URL.indexOf("?") == -1) ? "?" : "&";
	URL = URL + n + "newtime=" + dynamicTime;
	return URL;
}

/***
 * 解决ie 7，8 对Array.indexOf()方法不支持的问题
 * 
 */
if(!Array.indexOf){
    Array.prototype.indexOf = function(obj){
        for(var i=0; i<this.length; i++){
            if(this[i]==obj){
                return i;
            }
        }
        return -1;
    }
}
