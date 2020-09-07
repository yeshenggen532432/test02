<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>驰用T3</title>

		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
		<script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
		<style>
		.beQty-imput{width:70px}
		</style>
	</head>

	<body>
		
		<div id="tb" style="padding:5px;height:auto">
			<span style="display: none">
			 时间类型:<select name="timeType" id="timeType">
			 		 <option value="2">销售时间</option>
	                 <option value="1">发货时间</option>
	           	   </select>  
		   时间: <input name="stime" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
	         	   <img onclick="WdatePicker({el:'stime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         	   -
	         	<input name="etime" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
	         	   <img onclick="WdatePicker({el:'etime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         客户类型: <select name="customerType" id="customerType" style="width: 100px;"></select>
	         客户名称: <input name="khNm" id="khNm"  value="${stkUnit}"  style="width:120px;height: 20px;" />
	         所属二批: <input name="epCustomerName" id="epCustomerName"  value="${epCustomerName}"  style="width:120px;height: 20px;" />
				<input name="wtype" type="hidden" id="wtype" value="${wtype}"/>
		 	 <br/>
		 	 销售类型:<select name="xsTp" id="xsTp">
	                   <option value="">全部</option>
	                  <option value="正常销售">正常销售</option>
					  <option value="促销折让">促销折让</option>
					  <option value="消费折让">消费折让</option>
					  <option value="费用折让">费用折让</option>
					  <option value="其他销售">其他销售</option>
					   <option value="其它出库">其它出库</option>
	               </select>
	               <script type="text/javascript">
	               if('${outType}'!=''){
	            	   document.getElementById("xsTp").value='${outType}';
	               }
	               </script>
	           </span>    
	               <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:updateSubmit();">保存</a>
			<form action="manager/saveAutoCstDetailStat" name="saveAutoCstDetailStatfrm" id="saveAutoCstDetailStatfrm" method="post">
			<input type="hidden" name="rptType" value="3"/>
			报表标题：<input name="rptTitle" value="${sdate}-${edate}客户费用明细统计表" size="80"/>
			<br/>
			备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注：
			<textarea name="remark" rows="5" cols="90">报表参数--时间:${sdate}-${edate},销售类型:${outType},客户类型:${customerType },所属二批:${epCustomerName }
			</textarea>
			<br/>
			是否同步更新价格：
			<input type="radio" name="updatePrice" value="1" >是
			<input type="radio" name="updatePrice" value="0" checked="checked">否
			<textarea  name="saveHtml" id="saveHtml" style="display:none "></textarea>
			</form>
			<div id="saveHtmlDiv">
			<table border="1" cellpadding="1" cellspacing="1"><tr><td>序号</td><td>&nbsp;&nbsp;客户名称</td><td>&nbsp;&nbsp;商品名称</td><td>销售数量</td><td>销售收入</td><td>平均单位售价</td><td>销售成本</td><c:forEach items="${autoList }" var="title"><td>${title.name }</td></c:forEach><td>销售毛利</td><td>平均单位毛利</td></tr><c:set var="len" value="${fn:length(datas)}"/><c:forEach items="${datas }" var="d" varStatus="s"><tr><td>${s.index+1 }</td><td>${d.stkUnit }</td><td>${d.wareNm }</td><td><input readonly="readonly" id="items_sumQty_${s.index }" size="7"  name="items[${s.index}].sumQty" class="beQty-imput" value="${d.sumQty }"/></td><td>${d.sumAmt }</td><td><input  readonly="readonly" id="items_avgPrice_${s.index}" size="7"  name="items[${s.index}].avgPrice" value="${d.avgPrice}"/></td><td>${d.sumCost }</td><c:forEach items="${autoList }" var="title" varStatus="k"><td><c:set var="cprice" value=""/><c:set var="priceId" value=""/><c:set var="flag" value="0"/><c:forEach items="${sacpList}" var="price"><c:if test="${d.wareId eq  price.wareId && title.id eq price.autoId && d.stkUnitId eq price.customerId}"><c:set var="cprice" value="${price.price }"/><c:set var="priceId" value="${price.id }"/><c:set var="flag" value="1"/></c:if></c:forEach><c:if test="${flag eq 0}"><c:forEach items="${autoPriceList}" var="price"><c:if test="${d.wareId eq  price.wareId && title.id eq price.autoId }"><c:set var="cprice" value="${price.price }"/></c:if></c:forEach></c:if><input name="auotoPriceOrg_${s.index}" type="hidden"   id="auto_Price_org_${d.wareId }_${title.id }_${s.index}" value="${cprice}"/><input name="auotoPrice_${s.index}"   id="auto_Price_${d.wareId }_${title.id }_${s.index}" onchange='changeWareAutoPrice(${d.wareId },${title.id },${s.index},${d.stkUnitId })' size="7" class="bePrice-imput" value="${cprice}"/><input  id="auto_price_Id_${d.wareId }_${title.id }_${s.index}" size="7" type="hidden" value="${priceId}"/></td></c:forEach><td><input type="hidden" name="items[${s.index}].disAmtOrg"  id="items_disAmt_org_${s.index}" value="${d.disAmt }"/><input  readonly="readonly"  name="items[${s.index}].disAmt" class="disAmt-imput" id="items_disAmt_${s.index}" value="${d.disAmt }"/></td> <td><input readonly="readonly"  name="items[${s.index}].avgAmt" class="beMny-imput" id="items_avgAmt_${s.index}" value="${d.avgAmt }"/></td> </tr><c:set var="flag" value="0"/></c:forEach></table>
			</div>
		</div>
		<script type="text/javascript">
	     function calMny(){
	     	var mnyTotal=0;
	     	var len = "${len}";
	     	var k = parseInt(len);
		     $(".disAmt-imput").each(function() {
		         var thisValue = $(this).val();
		         var index = $(this).index();
		         if(index<(k-2)){
		        	 if (thisValue != '' ) {
			        	 mnyTotal += parseFloat(thisValue);
			         }
		         }
		     });
		     mnyTotal = mnyTotal.toFixed(2);
		     $("#items_disAmt_"+(k-1)).val(mnyTotal);
	     }
			 function updateSubmit(){
				 document.getElementById("saveHtml").value="";
				 document.getElementById("saveHtml").value=$("#saveHtmlDiv").formhtml();
				 $("#saveAutoCstDetailStatfrm").form('submit',{
						success:function(data){
							data = eval(data)
							if(parseInt(data)>0){
								alert("保存成功！");
								parent.closeWin('生成的统计表');
						    	parent.add('生成的统计表','manager/querySaveRptDataStat?rptType=3');
							}else{
								alert("保存失败！");
							}
						}
				});
				//document.getElementById("saveAutoCstDetailStatfrm").submit();
			   }
			 
			 function changeWareAutoPrice(wareId,autoId,index,customerId){
				 
					var sumQty=  $("#items_sumQty_"+index+"").val();
				 	var autoPrice = 0;
				 	 $("input[name='auotoPrice_"+index+"']").each(function() {
				         var thisValue = $(this).val();
				       	 if(thisValue!=""){
				       		autoPrice = parseFloat(autoPrice)+parseFloat(thisValue);
				       	 }
				     });
				 	var autoPriceOrg = 0;
				 	 $("input[name='auotoPriceOrg_"+index+"']").each(function() {
				         var thisValue = $(this).val();
				       	 if(thisValue!=""){
				       		autoPriceOrg = parseFloat(autoPriceOrg)+parseFloat(thisValue);
				       	 }
				     });
				 	var autoAmt = parseFloat(autoPrice)-parseFloat(autoPriceOrg);
				 	autoAmt = parseFloat(sumQty)*parseFloat(autoAmt); 
				 	var costAmtOrg = $("#items_disAmt_org_"+index+"").val();
				 	costAmt = parseFloat(costAmtOrg)-(autoAmt);
				 	var avgPrice = parseFloat(costAmt)/parseFloat(sumQty);
				 	$("#items_disAmt_"+index+"").attr("value",costAmt);
				 	$("#items_avgAmt_"+index+"").attr("value",avgPrice.toFixed(2));
				 	calMny();
				 	var isUpdatePrice = $("input[name='updatePrice']:checked").val();
					if(isUpdatePrice==0){
						return;
					}
			    	var autoPriceId = document.getElementById("auto_price_Id_"+wareId+"_"+autoId+"_"+index).value;
					var autoPrice =  document.getElementById("auto_Price_"+wareId+"_"+autoId+"_"+index).value;
					$.ajax({
						url:"manager/updateAutoCustomerPrice",
						type:"post",
						data:"id="+autoPriceId+"&wareId="+wareId+"&price="+autoPrice+"&autoId="+autoId+"&customerId="+customerId,
						success:function(data){
							if(data!='0'){
								if(autoPriceId==""){
									document.getElementById("auto_price_Id_"+wareId+"_"+autoId+"_"+index).value=data;
								}
							}else{
								alert("操作失败");
								return;
							}
						}
					});
			    }
			 
			 (function ($) {
				    var oldHTML = $.fn.html;
				    $.fn.formhtml = function () {
				        if (arguments.length) return oldHTML.apply(this, arguments);
				        $("input,textarea,button", this).each(function () {
				            this.setAttribute('value', this.value);
				        });
				        $(":radio,:checkbox", this).each(function () {
				            // im not really even sure you need to do this for "checked"
				            // but what the heck, better safe than sorry
				            if (this.checked) this.setAttribute('checked', 'checked');
				            else this.removeAttribute('checked');
				        });
				        $("option", this).each(function () {
				            // also not sure, but, better safe...
				            if (this.selected) this.setAttribute('selected', 'selected');
				            else this.removeAttribute('selected');
				        });
				        return oldHTML.apply(this);
				    };

				    //optional to override real .html() if you want
				    // $.fn.html = $.fn.formhtml;
				})(jQuery);
			 function loadCustomerType(){
					$.ajax({
						url:"manager/queryarealist1",
						type:"post",
						success:function(data){
							if(data){
							   var list = data.list1;
							    var img="";
							     img +='<option value="">--请选择--</option>';
							    for(var i=0;i<list.length;i++){
							      if(list[i].qdtpNm!=''){
							           img +='<option value="'+list[i].qdtpNm+'">'+list[i].qdtpNm+'</option>';
							       }
							    }
							   $("#customerType").html(img);
							 }
						}
					});
				}
		 loadCustomerType();
		</script>
	</body>
</html>
