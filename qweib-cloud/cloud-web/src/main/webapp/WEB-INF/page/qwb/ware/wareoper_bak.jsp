<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>企微宝</title>
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<style type="text/css">
			.divDel{
				position: relative;
				width:200px;
				height:160px;
				margin:15px 0px 5px;
			}
			.imgDel{
				width:20px;
				height:20px;
				position: absolute;
				right: 5px;
				top: 5px;
			}
		</style>
	</head>
	<body>
  			<form action="manager/operware" name="warefrm1" id="warefrm1" method="post" enctype="multipart/form-data">
  			  	<input  type="hidden" name="putOn" id="putOn" value="${ware.putOn}"/>
  			  	<input  type="hidden" name="wareId" id="wareId" value="${ware.wareId}"/>
  			    <input type="hidden" name="fbtime" id="fbtime" value="${ware.fbtime}" />
  				<input type="hidden" name="waretype" id="waretype" />
  				<c:set var="subIds" value=""/>
  				<input type="hidden" name="delSubIds" id="delSubIds" />
  			<div id="easyTabs" class="easyui-tabs" style="width:auto;height:auto;">
			    <div title="商品信息" style="padding:20px;">
			    <div class="box" >
					<dl id="dl1" style="font-size: 13px">
					<fieldset style="width:99%;border:1px dotted skyblue;-moz-border-radius: 5px; -webkit-border-radius: 5px; -khtml-border-radius: 5px; border-radius: 5px;  ">
	        		<legend  style="border:0px;background-color:white; font-size: 13px;color:teal;">基本信息</legend>
	      			<dd >
	      				<span class="title">商品编号*：</span>
	        			<input class="reg_input" name="wareCode" id="wareCode" value="${ware.wareCode}" style="width: 180px;font-size: 13px"/>
	        			<span id="wareCodeTip" class="onshow"></span>
	        		</dd>
	      			<dd>
	      				<span class="title">商品名称*：</span>
	        			<input class="reg_input" name="wareNm" id="wareNm" value="${ware.wareNm}" style="width: 240px;font-size: 13px"/>
	        			<span id="wareNmTip" class="onshow"></span>
	        		</dd>
	        		<dd>
	      				<span class="title">助记码：</span>
	        			<input class="reg_input" name="py" id="py" value="${ware.py}" style="width: 240px;font-size: 13px"/>
	        			<span id="pyTip" class="onshow"></span>
	        		</dd>
	        		<dd>
	        			<span class="title">商品类别*：</span>
	        			<select id="waretypecomb" class="easyui-combotree" style="width:200px;"   
	        					data-options="url:'manager/syswaretypes',animate:true,dnd:true,onClick: function(node){
						setTypeWare(node.id);
						}"></select>
	        		</dd>
	        		<dd>
	      				<span class="title">规&nbsp;&nbsp;&nbsp;&nbsp;格*：</span>
	        			<input class="reg_input" name="wareGg" id="wareGg" value="${ware.wareGg}" style="width: 100px;;font-size: 13px"/>
	        			<span id="wareGgTip" class="onshow"></span>
	        		</dd>
	        		</fieldset>
	        		<fieldset style="width:99%;border:1px dotted skyblue;-moz-border-radius: 5px; -webkit-border-radius: 5px; -khtml-border-radius: 5px; border-radius: 5px; ">
	        		<legend  style="border:0px;background-color:white;font-size: 13px;color:teal">大单位信息</legend>
	        		<dd>
	      				<span class="title">大单位*：</span>
	        			<input class="reg_input" name="wareDw" id="wareDw" value="${ware.wareDw}" style="width: 100px;font-size: 13px"/>
	        			<span id="wareDwTip" class="onshow"></span><input type="radio" value="" name="unitCheck" id="bUnitCheck"/><span style="font-size: 7px">开单默认</span>
	        		</dd>
	        		<dd>
	      				<span class="title">条&nbsp;&nbsp;&nbsp;码：</span>
	        			<input class="reg_input" name="packBarCode" id="packBarCode" value="${ware.packBarCode}" style="width: 200px;font-size: 13px"/>
	        			<span id="wareDwTip" class="onshow"></span>
	        		</dd>
	        		<dd>
	      				<span class="title">采购价*：</span>
	        			<input class="reg_input" name="inPrice" id="inPrice" value="${ware.inPrice}" style="width: 100px;font-size: 13px"/>
	        			<span id="wareInPriceTip" class="onshow"></span>
	        		</dd>
	        		<dd>
	      				<span class="title">批发价*：</span>
	        			<input class="reg_input" name="wareDj" id="wareDj" value="${ware.wareDj}" style="width: 100px;font-size: 13px"/>
	        			<span id="wareDjTip" class="onshow"></span>
	        		</dd>
	        		<dd>
	      				<span class="title">零售价：</span>
	        			<input class="reg_input" name="lsPrice" id="lsPrice" value="${ware.lsPrice}" style="width: 100px;font-size: 13px"/>
	        		</dd>
	        		<dd>
	      				<span class="title">预警数量：</span>
	        			<input class="reg_input" name="warnQty" id="warnQty" value="${ware.warnQty}" style="width: 100px;font-size: 13px"/>
	        			<span id="warnQtyTip" class="onshow"></span>
	        		</dd>
	        		</fieldset>
	        		<fieldset style="width:99%;border:1px dotted skyblue;-moz-border-radius: 5px;  
    -webkit-border-radius: 5px;  
    -khtml-border-radius: 5px;  
    border-radius: 5px;">
	        		<legend  style="border:0px;background-color:white;font-size: 13px;color:teal">小单位信息</legend>
	        		<dd>
	        			<input  type="hidden" name="maxUnitCode" id="maxUnitCode" value="${ware.maxUnitCode}" style="width: 100px"/>
	        			<input  type="hidden" name="minUnitCode" id="minUnitCode" value="${ware.minUnitCode}" style="width: 100px"/>
	      				<span class="title">小单位*：</span>
	        			<input class="reg_input" name="minUnit" id="minUnit" value="${ware.minUnit}" style="width: 100px"/>
	        			<span id="wareDjTip" class="onshow"></span>
	        				<input type="radio" name="unitCheck" value="1" id="sUnitCheck"/><span style="font-size: 7px">开单默认</span>
	        		</dd>
	        		<c:if test="${isSUnitPrice=='1'}">
						<dd>
	      				<span class="title">批发价*：</span>
	        			<input class="reg_input" name="sunitPrice" id="sunitPrice" value="${ware.sunitPrice}" style="width: 100px;font-size: 13px"/>
	        			<span id="wareInPriceTip" class="onshow"></span>
					</c:if>
	        		<dd>
	      				<span class="title">条&nbsp;&nbsp;&nbsp;码：</span>
	        			<input class="reg_input" name="beBarCode" id="beBarCode" value="${ware.beBarCode}" style="width: 200px;font-size: 13px"/>
	        			<span id="beBarCodeTip" class="onshow"></span>
	        		</dd>
	        		<dd>
	      				<span class="title">换算比例*：</span>
	      				<span style="font-size: 10px" >
	        				<input class="reg_input" name="bUnit" id="bUnit" value="${ware.bUnit}"  onkeyup="CheckInFloat(this)" onchange="calUnit()" style="width: 30px"/>
	        				*大单位
	        				=
	        				<input class="reg_input" name="sUnit" id="sUnit" value="${ware.sUnit}"  onkeyup="CheckInFloat(this)" onchange="calUnit()" style="width: 30px"/>*小单位
	        			</span>
	        			&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-size: 10px;"><input class="reg_input" name="hsNum" id="hsNum" value="${ware.hsNum}" readonly="readonly" style="width: 40px"/></span>
	        		</dd>
	        		</fieldset>
	        		<fieldset style="width:99%;border:1px dotted skyblue;-moz-border-radius: 5px;  
    -webkit-border-radius: 5px;  
    -khtml-border-radius: 5px;  
    border-radius: 5px;">
	        		<legend  style="border:0px;background-color:white;font-size: 13px;color:teal">其它信息</legend>
	        		<dd>
	      				<span class="title">别名：</span>
	      				<input class="reg_input" name="aliasName" id="aliasName" value="${ware.aliasName}" style="width: 100px;font-size: 13px"/>
	        		</dd>
	        		<dd>
	      				<span class="title">标识码：</span>
	        			<input class="reg_input" name="asnNo" id="asnNo" value="${ware.asnNo}" style="width: 100px;font-size: 13px"/>
	        		</dd>
	        		<dd>
	      				<span class="title">生产厂商：</span>
	        			<input class="reg_input" name="providerName" id="providerName" value="${ware.providerName}" style="width: 100px;font-size: 13px"/>
	        		</dd>
	        		<dd>
	      				<span class="title">保&nbsp;质&nbsp;期：</span>
	        			<input class="reg_input" name="qualityDays" id="qualityDays" value="${ware.qualityDays}" style="width: 100px;font-size: 13px"/>
	        			<span id="qualityDaysTip" class="onshow"></span>
	        		</dd>
	        		<dd>
	      				<span class="title">运输费用：</span>
	        			<input class="reg_input" name="tranAmt" id="tranAmt" value="${ware.tranAmt}" style="width: 100px;font-size: 13px"/>
	        			<span id="wareDjTip" class="onshow"></span>
	        		</dd>
	        		<dd>
	      				<span class="title">提成费用：</span>
	        			<input class="reg_input" name="tcAmt" id="tcAmt" value="${ware.tcAmt}" style="width: 100px;font-size: 13px"/>
	        			<span id="wareDjTip" class="onshow"></span>
	        		</dd>
	        		<dd>
		      			<span class="title">是否常用：</span>
		        		<input type="radio" name="isCy" id="isCy1" value="1" checked="checked"/>是
		        		<input type="radio" name="isCy" id="isCy2" value="2"/>否
		        	</dd>
		        	<dd>
		      			<span class="title">是否启用：</span>
		        		<input type="radio" name="status" id="status1" value="1" checked="checked"/>是
		        		<input type="radio" name="status" id="status2" value="2"/>否
		        	</dd>
		        	<dd style="display: none">
		        		<span class="title">开单默认小单位：</span>
		        		<input type="checkbox" name="sunitFront" value="1" id="sunitFront" ${ware.sunitFront eq '1'?'checked':'' }>
		        	</dd>
		        	<dd>
	      				<span class="title">备&nbsp;&nbsp;&nbsp;&nbsp;注：</span>
	        			<input class="reg_input" name="remark" id="remark" value="${ware.remark}" style="width: 240px"/>
	        			<span id="remarkTip" class="onshow"></span>
	        		</dd>
	        		</fieldset>
	        		</dl>
	        		</div>
			    </div>
			    
			    <!-- ================= 图片开始=================== -->
			    <div title="商品图片" style="overflow:auto;padding:20px;">
		        	<dl id="dl2">
						<c:if test="${empty ware.warePicList}">
			       			<dd id="ddphoto1">
			     				<div class="divDel">
				        			<img id="photoImg21" alt="" style="width: 200px;height: 160px;" src="resource/images/login_bg.jpg"/ >
				        			<img class="imgDel" alt=""   style="width: 20px;height: 20px;" src="resource/shop/mobile/images/delete_1.png" onclick="deleteRows(1);"/>
			        			</div>
			        			<div id="editDiv2" >
			        				<input type="file" accept="image/*" name="file21" id="file21" onchange="showPictrue(1)"  class="uploadFile"/>
			        			</div>
			 				</dd>
			       		</c:if>
			       		
			       		<c:if test="${!empty ware.warePicList}">
				      		<c:forEach items="${ware.warePicList}" var="item" varStatus="s">
				      			<dd id="ddphoto${s.index+1}">
				      				<input type="hidden" name="subId" id="subId${s.index+1}" value="${item.id}"/>
				      				<c:set var="subIds" value="${subIds},${item.id },"/>
				        			<div class="divDel">
					        			<c:if test="${!empty item.pic}">
					        				<img id="photoImg2${s.index+1}" alt=""   style="width: 200px;height: 160px;" src="upload/${item.pic}"/>
					        			</c:if>
					        			<c:if test="${empty item.pic}">
					        				<img id="photoImg2${s.index+1}" alt=""   style="width: 200px;height: 160px;" src="resource/images/login_bg.jpg"/>
					        			</c:if>
					        			<img class="imgDel" alt=""   style="width: 20px;height: 20px;" src="resource/shop/mobile/images/delete_1.png" onclick="deleteRows('${s.index+1}');"/>
				        			</div>
				        			
				        			<div id="editDiv${s.index+1}" >
				        				<a class="easyui-linkbutton" iconcls="icon-edit" href="javascript:void(0);" onclick="modifyRows('${s.index+1}');">编辑</a>
				        			</div>
								</dd>
							</c:forEach>
			       		</c:if>
	       			</dl>
		       		<dd style="margin:20px 0px;">
						<a class="easyui-linkbutton" iconcls="icon-add" href="javascript:void(0);" onclick="addRows(this);">增加图片</a>
					</dd>
			    </div>
			    <!-- ================= 图片结束=================== -->
			</div>
	        	<div class="f_reg_but" style="clear:both">
	    			<input type="button" value="保存" class="l_button" onclick="toSubmit();"/>
	      			<input type="button" value="返回" class="b_button" onclick="toback();"/>
	     		</div>
	  		</form>
		
	    <script type="text/javascript">
		   function toSubmit(){
				if ($.formValidator.pageIsValid()==true){
					var bUnit=$("#bUnit").val();
					var sUnit=$("#sUnit").val();
					if(bUnit==""&&sUnit==""){
						alert("单位换算不能为空！");
						return;
					}
					if($("#inPrice").val()==""){
						$("#inPrice").val(0);
					}
					
					var subId = document.getElementsByName("subId");
					var subIds = '${subIds}';
					if(subId!=undefined){
						for(var i=0;i<subId.length;i++){
							var id = subId[i].value;
							if(id!=""){
								subIds = subIds.replace(id+",",'');
							}
						}
					}
					document.getElementById("delSubIds").value=subIds;
					
					var unitCheck = $("input[name='unitCheck']:checked").val();
					if(unitCheck==1){
						$("#sunitFront").attr('checked',true);
					}else{
						$("#sunitFront").attr('checked',false);
					}
					//easyUi的from表单的ajax请求接口
					$("#warefrm1").form('submit',{
						type:"POST",
						//url:"manager/operware",
						onSubmit: function(param){//参数
							param.delPicIds = delPicIds;
					    },
						success:function(data){
							if(data=="1"){
								alert("添加成功");
								toback();
							}else if(data=="2"){
								alert("修改成功");
								toback();
							}else if(data=="-2"){
								alert("该商品名称已存在了");
								return;
							}else if(data=="-3"){
								alert("该商品编码已存在了");
								return;
							}else if(data == "-4"){
								alert("该商品小单位条码已存在了");
								return;
							}else if(data =="-5"){
								alert("该商品大单位条码已存在了");
								return;
							}else{
								alert("操作失败");
							}
						}
					});
				}
			}
		    function setTypeWare(typeId){
		    	$("#waretype").val(typeId);
		    }
			function toback(){
				window.parent.$('#editdlg').dialog('close');
				window.parent.reloadware();
				//location.href="${base}/manager/towares?wtype="+$("#waretype").val();
			}
			$(function(){
			    var waretype ="${ware.waretype}";
			    var wareId ="${ware.wareId}";
			    if(waretype){
			       $("#waretype").val(waretype);
			    }else{
			       $("#waretype").val("${wtype}");
			    }
			    $.formValidator.initConfig();
			    $("#wareNm").formValidator({onShow:"请输入(25个字以内)",onFocus:"请输入(25个字以内)",onCorrect:"通过"}).inputValidator({min:1,max:50,onError:"请输入(25个字以内)"});
			    $("#wareCode").formValidator({onShow:"请输入(20个字符以内)",onFocus:"请输入(20个字符以内)",onCorrect:"通过"}).inputValidator({min:1,max:20,onError:"请输入(20个字符以内)"});
			    $("#wareGg").formValidator({onShow:"请输入(10个字以内)",onFocus:"请输入(10个字以内)",onCorrect:"通过"}).inputValidator({min:1,max:20,onError:"请输入(10个字以内)"});
			    $("#wareDw").formValidator({onShow:"请输入(5个字以内)",onFocus:"请输入(5个字以内)",onCorrect:"通过"}).inputValidator({min:1,max:10,onError:"请输入(5个字以内)"});
			    $("#wareDj").formValidator({onShow:"请输单价",onFocus:"请输单价"}).regexValidator({regExp:"money",dataType:"enum",onError:"单价格式不正确"});
			    $("#minUnit").formValidator({onShow:"请输入(5个字以内)",onFocus:"请输入(5个字以内)",onCorrect:"通过"}).inputValidator({min:1,max:10,onError:"请输入(5个字以内)"});
			    $("#hsNum").formValidator({onShow:"请输入(5个字以内)",onFocus:"请输入(5个字以内)",onCorrect:"通过"}).inputValidator({min:1,max:20,onError:"请输入(5个字以内)"});
			    var isCy = "${ware.isCy}";
				if(isCy!=""){
				   document.getElementById("isCy"+isCy).checked=true;
				}
				var status = "${ware.status}";
				if(status!=""){
				   document.getElementById("status"+status).checked=true;
				}
				var wareCode = "${ware.wareCode}";
				if(wareCode!=""){
					document.getElementById("wareCode").readOnly=true;
				}
				/*
				if(status==""){
					 document.getElementById("status1").checked=true;
				}*/
				$('#waretypecomb').combotree('setValue', '${wareType.waretypeNm}');
				
				$("#sUnit").attr("readonly",'${wareIsUse}');
				$("#bUnit").attr("readonly",'${wareIsUse}');
				 var bool = ${!permission:checkUserButtonPdm("qwb.sysWare.desc")};
				$("#sUnit").attr("readonly",bool);
				$("#bUnit").attr("readonly",bool);
				
				if('${ware.sunitFront}'=='1'){
					$("#sUnitCheck").attr('checked','true');
				}else{
					$("#bUnitCheck").attr('checked','true');
				}
				
				if(wareId==""){
					$("#sUnit").attr("readonly",false);
					$("#bUnit").attr("readonly",false);
				}
				
				//var a = $("input[name='unitCheck']:checked").val();
				
				
			});
			//计算换算单位
			function calUnit(){
				var bUnit=$("#bUnit").val();
				var sUnit=$("#sUnit").val();
				if(bUnit!=""&&sUnit!=""){
					var hsNum = parseFloat(sUnit)/parseFloat(bUnit);
					console.log("hsNum:"+hsNum);
					console.log("hsNum.toFixed(7)："+hsNum.toFixed(7));
					$("#hsNum").val(hsNum.toFixed(7));
				}
			}
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
			
			//*************************图片相关：开始******************************************
			//显示图片
			function showPictrue(n){
				console.log("showPictrue:"+n);
				var r= new FileReader();
				f=document.getElementById("file2"+n).files[0];
				r.readAsDataURL(f);
				r.onload=function  (e) {
					document.getElementById('photoImg2'+n).src=this.result;
				}
				//修改时记录要删除的图片id
				if(Number(len)>=Number(n)){
					var picId = $("#subId"+n).val();
					console.log("picId:"+picId);
					if(picId!=null && picId!=undefined && picId!=""){
						//记录删除的图片id
						if(delPicIds==""){
							delPicIds=""+picId;
						}else{
							delPicIds+=","+picId;
						}
						console.log(delPicIds);
					}
				}
			}
			
			//添加照片
			var index="${len}";
			var len="${len}";//记录个数
			function addRows(obj){
				index++;
				var strs = "<dd id=\"ddphoto"+index+"\">";
				strs+="<span class=\"title\">";
				strs+="<div class=\"divDel\">";
				strs+="<img id=\"photoImg2"+index+"\" alt=\"\" style=\"width: 200px;height: 160px;\" src=\"resource/images/login_bg.jpg\" />";
				strs+="<img class=\"imgDel\" src=\"resource/shop/mobile/images/delete_1.png\" onclick=\"deleteRows('"+index+"');\" />" 
				strs+="</div>";
				strs+="<div id=\"editDiv"+index+"\">";
				strs+="<input type=\"file\" accept=\"image/*\" name=\"file2"+index+"\" id=\"file2"+index+"\" onchange=\'showPictrue("+index+")\'  class=\"uploadFile\"/>";
				strs+="</div>";
				strs+="</dd>";
				$("#dl2").append(strs);
			}
			
			//删除照片
			var delPicIds="";
			function deleteRows(c){
				var picId = $("#subId"+c).val();
				if(picId!=null && picId!=undefined && picId!=""){
					//记录删除的图片id
					if(delPicIds==""){
						delPicIds=""+picId;
					}else{
						delPicIds+=","+picId;
					}
				}
				var ddphoto = document.getElementById("ddphoto"+c);
				ddphoto.parentNode.removeChild(ddphoto);
			}
			//编辑图片
			function modifyRows(n){
				var str="<input type='file' accept='image/*' name='file2"+n+"' id='file2"+n+"'  onchange='showPictrue("+n+")'   class='uploadFile'/>";
				if($("#file2"+n+"").length>0){
				}else{
					$("#editDiv"+n).append(str);
				}
			}
			//*************************图片相关：结束******************************************
			
		</script>	
	</body>
</html>
