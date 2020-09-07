<%@ page language="java" pageEncoding="utf-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<title>图片剪裁</title>
		<script src="resource/jquery.imgareaselect.pack.js"></script>
		<link rel="stylesheet" type="text/css" href="resource/css/imgareaselect-default.css" />
<style type="text/css">	
<!--
 html,body{font-size:12px;width:100%;height:100%;margin:0;padding:0;}
 .img{margin:6px 0;}
 .resizebutton{background-color:#FFF;border:1px solid #000;padding:4px;cursor:pointer;cursor:hand;position:absolute;display:none;}
 .scrollX{position:absolute;background-color:#FFF;border:1px outset #ffffff;filter:Alpha(Opacity=80);opacity:0.8;-moz-user-select:none;}
 .scrollX div{
  width:122px;
 height:10px;
 margin:8px 6px;
 -moz-user-select:none;
 background-color: green;
 }
 .scrollX div p{
 cursor:pointer;
 cursor:hand;
 position:static;
 margin-left:5px;
 width:17px;
 height:11px;
 -moz-user-select:none;
 background-color: black;
 }
-->
</style>
</head>
	<body>
	  <div style="margin-top: 5px;width: 100%;">
	  	<div style="float: left;text-align: left;padding-left: 5px;" id="checkDiv">
		    <a class="easyui-linkbutton" href="javascript:ajaxSubmit();">确定</a>
			<a class="easyui-linkbutton" href="javascript:hideImgWin();">取消</a>
		</div>
		<div>
			<span id="imgCpu">100%</span>
			<a class="easyui-linkbutton" data-options="iconCls:'icon-add'" href="javascript:enlarge();">放大</a>
			<a class="easyui-linkbutton" data-options="iconCls:'icon-remove'" href="javascript:narrow();">缩小</a>
		<div>
	  </div>
	  <div id="imgDiv" align="center" class="img">
			<img id="tempImg" src="upload/temp/${imgsrc}"/>
			<input type="hidden" name="srcpath" id="srcpath" value="${imgsrc}">
			<input type="hidden" name="x1" id="x1" value="7" />
			<input type="hidden" name="y1" id="y1" value="7" />
			<input type="hidden" name="width" id="width" value="210" />
			<input type="hidden" name="height" id="height" value="220" />
	  </div>
		<script type="text/javascript">
          //图片Div的宽度和高度
          var divWidth;
          var divHeight;
          var maxCpu;
          var minCpu;
          var ias;
          //设置选框
		  $(document).ready(function () {
		  	   //初始化PhotoSize
		       PhotoSize.init();
		       function resize(){
		          //窗口的宽度和高度
		          var windowW = document.body.clientWidth;
		          var windowH = document.body.clientHeight;
		          divWidth = windowW;
		          divHeight = windowH-36;
        	   	  document.getElementById("checkDiv").style.width=windowW-210;
        	   	  //初始化图片比例
		       	  initImgSize();
		       	  //初始化选择区域
		       	  myAreaSelect();
		       }
		       //初始化窗口Div大小
		       resize();
		       window.onresize = function(){
	              resize();
	           }
	           //图片剪裁控件
	           ias = $('#tempImg').imgAreaSelect({ 
		           selectionColor:'white', x1: 0, y1: 0, x2: 210, y2: 220, 
		           selectionOpacity: 0.2 ,
		           instance:true,
		           resizable:false,
		           maxHeight:220,
		           maxWidth:210,
		           minHeight:220,
		           minWidth:210,
		           persistent:true,
		           onSelectEnd: preview 
		       });
          });
          function myAreaSelect(){
          	   if(ias){
          	   	  ias.update();
          	   }
          }
          var PhotoSize = {
			  cpu: 1, // 当前缩放倍数值
			  elem: "", // 图片
			  elsn: "", //显示上盘
			  photoWidth: 0, // 图片初始宽度记录
			  photoHeight: 0, // 图片初始高度记录
			  init: function(){
				     this.elem = document.getElementById("tempImg");
				     this.elsn = document.getElementById("imgCpu");
				     this.photoWidth = this.elem.scrollWidth;
				     this.photoHeight = this.elem.scrollHeight;
			  },
			  action: function(x){
				    if(x == 0){
				       this.cpu = 1;
				    }else if(x==1){
				       this.cpu = parseFloat(this.cpu.add(0.1),10);
				       if(this.cpu>1){
				       	  this.cpu=1;
				       }
				    }else if(x==-1){
				       this.cpu = parseFloat(this.cpu.sub(0.1),10);
				       if(this.cpu<0.1){
				       	  this.cpu=0.1;
				       }
				    }
				    var tempWidth = this.photoWidth * this.cpu;
				    var tempHeight = this.photoHeight * this.cpu;
				    if(tempWidth<=210 || tempHeight<=220){
				    	this.cpu = parseFloat(this.cpu.add(0.1),10);
				    	return;
				    }
				    this.elem.style.width =  tempWidth+"px";
				    this.elem.style.height =  tempHeight+"px";
				    this.elsn.innerHTML=(this.cpu*100)+"%";
			  },
			  changeSize: function(x){
			  		this.cpu=x;
			  		maxCpu=x;
			  	    this.elem.style.width = this.photoWidth * this.cpu +"px";
				    this.elem.style.height = this.photoHeight * this.cpu +"px";
				    this.elsn.innerHTML=(this.cpu*100)+"%";
			  }
		  };
		  //初始化图片大小
		  function initImgSize(){
		  	  if(PhotoSize.photoWidth>divWidth && PhotoSize.photoHeight>divHeight){
		      	  var widthRate = divWidth/PhotoSize.photoWidth;
		      	  var heightRate = divHeight/PhotoSize.photoHeight;
		      	  if(heightRate>widthRate){
		      	  	 var heightRate = Math.floor(divHeight.div(PhotoSize.photoHeight)*10)/10;
		      	  	 PhotoSize.changeSize(heightRate);
		      	  }else{
		      	  	 var widthRate = Math.floor(divWidth.div(PhotoSize.photoWidth)*10)/10;
		             PhotoSize.changeSize(widthRate);
		      	  }
		      }else if(PhotoSize.photoWidth>divWidth){
		          var widthRate = Math.floor(divWidth.div(PhotoSize.photoWidth)*10)/10;
		          PhotoSize.changeSize(widthRate);
		      }else if(PhotoSize.photoHeight>divHeight){
		      	  var heightRate = Math.floor(divHeight.div(PhotoSize.photoHeight)*10)/10;
		      	  PhotoSize.changeSize(heightRate);
		      }
		  }
		  //利用jquery中的data方法来保存生成的数据
          function preview(img, selection) {  
	         $('#x1').val(selection.x1); 
	         $('#y1').val(selection.y1); 
          }
          //保存图片
          function ajaxSubmit(){
          	 $.ajax({
          	 	url:'${base}/manager/imgCoordinate',
          	 	method:'post',
          	 	data:'x1='+$('#x1').val()+'&y1='+$('#y1').val()+'&width='+$('#width').val()+'&height='+$('#height').val()+'&srcpath='+$('#srcpath').val()+"&imgWidth="+PhotoSize.elem.scrollWidth+"&imgHeight="+PhotoSize.elem.scrollHeight,
          	 	success:function(data){
          	 		if(data=="-1"){
          	 			alert("图片处理失败");
          	 		}else{
          	 		    window.parent.showPhotoMini2(data,"${str2}",'${str1}','${imgsrc}');
          	 		}
          	 	}
          	 });
          }
          //取消
          function hideImgWin(){
              window.parent.hideImgWin2();
          }
          //放大
          function enlarge(){
          	  if(PhotoSize.cpu>=maxCpu){
          	  	  return;
          	  }
          	  PhotoSize.action(1);
          	  myAreaSelect();
          }
          //缩小
          function narrow(){
          	  if(PhotoSize.cpu<=minCpu){
          	  	return;
          	  }
          	  PhotoSize.action(-1);
          	  myAreaSelect();
          }
     </script>
	</body>
</html>
