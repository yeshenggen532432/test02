<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>企微宝</title>
		<%@include file="/WEB-INF/page/include/source.jsp"%>
	</head>
	<body>

		<div class="box">
  			<form action="manager/bc/saveKqBc" name="BonusSharfrm" id="BonusSharfrm" method="post">
  			<input  type="hidden" name="id" id="id" value="${bc.id}"/>
  				<dl id="dl">
  				<dt class="f14 b">班次信息</dt>
  				<dd>
	      				<span class="title">班次编码：</span>
	        			<input class="reg_input" name="bcCode" id="bcCode" value="${bc.bcCode}" style="width: 120px"/>
	        			<span id="memberNmTip" class="onshow"></span>
	        	</dd>
	        	<dd>
	      				<span class="title">班次名称：</span>
	        			<input class="reg_input" name="bcName" id="bcName" value="${bc.bcName}" style="width: 120px"/>

	        	</dd>

				<dd>
	      				<span class="title">上班弹性时间：</span>
	        			<input class="reg_input" name="earlyMinute" id="earlyMinute" value="${bc.earlyMinute}" style="width: 120px"/>分钟

	        	</dd>
	        	<dd>
	      				<span class="title">下班弹性时间：</span>
	        			<input class="reg_input" name="lateMinute" id="lateMinute" value="${bc.lateMinute}" style="width: 120px"/>分钟

	        	</dd>
	        	<dd>
	      				<span class="title">最早上班签到时间：</span>
	        			<input class="reg_input" name="beforeMinute" id="beforeMinute" value="${bc.beforeMinute}" style="width: 120px"/>分钟

	        	</dd>
	        	<dd>
	      				<span class="title">最晚下班签到时间：</span>
	        			<input class="reg_input" name="afterMinute" id="afterMinute" value="${bc.afterMinute}" style="width: 120px"/>分钟

	        	</dd>
	        	<dd>
	      				<span class="title">跨天否：</span>
	        			<input type="checkbox" name="crossDay1" id="crossDay1" />
	        			<input type="hidden" name="crossDay" id="crossDay" value="${bc.crossDay}" />
	        			<input type="hidden" name="status" id="status" value="${bc.status}" />
	        			<input type="hidden" name="latitude" id="latitude" value="${bc.latitude}" />
	        			<input type="hidden" name="longitude" id="longitude" value="${bc.longitude}" />
	        			<input type="hidden" name="outOf" id="outOf" value="${bc.outOf}" />
	        			<input type="hidden" name="address1" id="address1" value="${bc.address}"/>


	        	</dd>
	        	<dd>
	        	<span class="title">地址：</span>
	        	<select id="address" name="address" value="${bc.address}">
	        					<option value=""></option>

			  					</select>
	        	</dd>
	        	<dd>
	        	<span class="title">允许范围：</span>
	        	<input type="text" id="areaLong" name="areaLong" value="${bc.areaLong}">米 &nbsp;&nbsp;&nbsp;&nbsp;
	        	<input type="checkbox" id="chkOutOf" />	是否可超出范围
	        	</dd>
	        	<dd>
	      				<span class="title">备注：</span>
	        			<input class="reg_input" name="remarks" id="remarks" value="${bc.remarks}" style="width: 220px"/>

	        	</dd>

	      			<c:if test="${!empty list}">
		        		<c:forEach items="${list}" var="list" varStatus="s">
		        		    <dd id="dds${s.count}">
			  					<span class="title"><b>${s.count}.</b>上班时间：</span>

			  					<input id="startTime${s.count}" name="subList[${s.count-1}].startTime" value="${list.startTime}" class="reg_input" style="width: 150px"/>
			         			<span id="startTime${s.count}Tip" class="onshow"></span>
						    </dd>
						    <dd id="dde${s.count}">
			  					<span class="title">下班时间：</span>
			  					<input id="endTime${s.count}" name="subList[${s.count-1}].endTime" value="${list.endTime}" class="reg_input" style="width: 150px"/>
			         			<span id="endTime${s.count}Tip" class="onshow"></span>
						    </dd>

						    <c:if test="${s.count==detailCount}">
								<dd id="ddbuttonM${s.count}"/>
							</c:if>
							<c:if test="${s.count!=detailCount}">
								<dd id="ddbuttonM${s.count}" style="display: none;"/>
							</c:if>
								<span class="title"></span>
								<a class="easyui-linkbutton" iconcls="icon-add" href="javascript:void(0);" onclick="addRows(this);">增加</a>
								<c:if test="${s.count>1}">
									<a class="easyui-linkbutton" iconcls="icon-remove" href="javascript:void(0);" onclick="deleteRows('${s.count}');">删除</a>
								</c:if>
						</c:forEach>
		        		</c:if>
                </dl>
	    		<div class="f_reg_but">
	    			<input type="button" value="保存" class="l_button" onclick="toSubmit();"/>
	    			<input type="button" value="返回" class="b_button" onclick="toback();"/>
	      		</div>
	  		</form>
		</div>

		<script type="text/javascript">
		   var index = "${detailCount}";
		   if($("#crossDay").val() == "1")
			   {
			   $("#crossDay1").prop('checked','true');

			   }
		   else {

			   $("#crossDay1").removeAttr('checked');

		   }
		   if($("#outOf").val() == "1")
			   {
			   $("#chkOutOf").prop('checked','true');
			   }
		   else
			   {
			   $("#chkOutOf").removeAttr('checked');
			   }
		   function toSubmit(){
			   if($("#crossDay1").is(":checked"))$("#crossDay").val(1);
			   else $("#crossDay").val(0);
			   if($("#chkOutOf").is(":checked"))$("#outOf").val(1);
			   else $("#outOf").val(0);
			   if ($.formValidator.pageIsValid()==true){
					$("#BonusSharfrm").form('submit',{
						success:function(data){
							if(data=="1"){
								alert("保存成功");
								toback();
							}else{
								alert("操作失败");
							}
						}
					});
				}
			}
			function toback(){
				location.href="${base}/manager/bc/toBaseBc";
			}
			$(function(){
			    $.formValidator.initConfig();
				for(var i=1;i<=index;i++){
					$("#startTime"+i).formValidator({ // 验证：发送时间
			            onshow: "（必填）",
			            onfocus: "（必填）请输入上班时间 HH:mm",
			            oncorrect: "（正确）"
			        }).functionValidator({
			            fun: function (val, elem) {
			                if (!/^\d{2}:\d{2}$/.test(val)) {
			                    return "（错误）请输入上班时间";
			                }
			                return true;
			            }
			        });

					$("#endTime"+i).formValidator({ // 验证：发送时间
			            onshow: "（必填）",
			            onfocus: "（必填）请输入下班时间 HH:mm",
			            oncorrect: "（正确）"
			        }).functionValidator({
			            fun: function (val, elem) {
			                if (!/^\d{2}:\d{2}$/.test(val)) {
			                    return "（错误）请输入下班时间";
			                }
			                return true;
			            }
			        });
				   //$("#startTime"+i).formValidator({onShow:"请输分钟",onFocus:"请输分钟"}).regexValidator({regExp:"money",dataType:"enum",onError:"时间格式不正确"});
				   //$("#endTime"+i).formValidator({onShow:"请输分钟",onFocus:"请输分钟"}).regexValidator({regExp:"money",dataType:"enum",onError:"时间格式不正确"});

				}
			});
			//添加
			function addRows(obj){
			    obj.parentNode.style.display="none";
				index++;
				var strs = "<dd id=\"dds"+index+"\"><span class=\"title\"><b>"+index+".</b>开始时间：</span><input id=\"startTime"+index+"\" name=\"subList["+(index-1)+"].startTime\"  class=\"reg_input\" style=\"width: 150px\"/><span id=\"startTime"+index+"Tip\" class=\"onshow\"></span></dd>";
				strs+="<dd id=\"dde"+index+"\"><span class=\"title\">结束时间：</span><input id=\"endTime"+index+"\" name=\"subList["+(index-1)+"].endTime\" class=\"reg_input\" style=\"width: 150px\"/><span id=\"endTime"+index+"Tip\" class=\"onshow\"></span></dd>";

				strs+="<dd id=\"ddbuttonM"+index+"\"><span class=\"title\"></span>&nbsp;<a class=\"easyui-linkbutton l-btn\" iconcls=\"icon-add\" href=\"javascript:void(0);\" onclick=\"addRows(this);\">";
				strs+="<span class=\"l-btn-left\"><span class=\"l-btn-text icon-add l-btn-icon-left\">增加</span></span></a>&nbsp;";
				strs+="<a class=\"easyui-linkbutton l-btn\" iconcls=\"icon-remove\" href=\"javascript:void(0);\" onclick=\"deleteRows('"+index+"');\">";
				strs+="<span class=\"l-btn-left\"><span class=\"l-btn-text icon-add l-btn-icon-left\">删除</span></span></a></dd>";
				$("#dl").append(strs);
				$("#startTime"+index).formValidator({ // 验证：发送时间
		            onshow: "（必填）",
		            onfocus: "（必填）请输入上班时间 HH:mm",
		            oncorrect: "（正确）"
		        }).functionValidator({
		            fun: function (val, elem) {
		                if (!/^\d{2}:\d{2}$/.test(val)) {
		                    return "（错误）请输入上班时间";
		                }
		                return true;
		            }
		        });

				$("#endTime"+index).formValidator({ // 验证：发送时间
		            onshow: "（必填）",
		            onfocus: "（必填）请输入下班时间 HH:mm",
		            oncorrect: "（正确）"
		        }).functionValidator({
		            fun: function (val, elem) {
		                if (!/^\d{2}:\d{2}$/.test(val)) {
		                    return "（错误）请输入下班时间";
		                }
		                return true;
		            }
		        });

		    }
			//删除
			function deleteRows(c){
				var dds = document.getElementById("dds"+c);
				var dde = document.getElementById("dde"+c);
				var ddbuttonM = document.getElementById("ddbuttonM"+c);
				dds.parentNode.removeChild(dds);
				dde.parentNode.removeChild(dde);
				ddbuttonM.parentNode.removeChild(ddbuttonM);
				index--;
				document.getElementById("ddbuttonM"+(c-1)).style.display="block";
			}

			function loadAddress(){

				var path = "manager/bc/queryAddressList";
				$.ajax({
			        url: path,
			        type: "POST",
			        data : {"status":1},
			        dataType: 'json',
			        async : false,
			        success: function (json) {
			        	if(json.state){
			        		var size = json.rows.length;
			        		bcList = json.rows;
			        		for(var i = 0;i<size;i++)
			        		$("#address").append("<option value='"+json.rows[i].address+"'>"+json.rows[i].address+"</option>");  //.options.add( new Option(json.rows[i].bcName,json.rows[i].id));


			        	}
			        }
			    });
				var address1 = $("#address1").val();
				$("#address").val(address1);

			}
			loadAddress();

		</script>
	</body>
</html>

