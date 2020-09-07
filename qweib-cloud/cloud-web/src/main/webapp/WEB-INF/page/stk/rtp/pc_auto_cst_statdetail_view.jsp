<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>企微宝</title>

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
			<form action="manager/saveAutoCstDetailStat" name="saveAutoCstDetailStatfrm" id="saveAutoCstDetailStatfrm" method="post">
			<input type="hidden" name="rptType" value="3"/>
			报表标题：<input name="rptTitle" value="${sdate}-${edate}客户费用明细统计表" size="80"/>
			<br/>
			备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注：
			<textarea name="remark" rows="5" cols="90">报表参数--时间:${sdate}-${edate},销售类型:${outType},客户类型:${customerType },所属二批:${epCustomerName }
			</textarea>
			<textarea  name="saveHtml" id="saveHtml" style="display:none "></textarea>
			 <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:updateSubmit();">保存</a>
			</form>
			<div id="saveHtmlDiv">
				${datas}
			</div>
		</div>
		<script type="text/javascript">
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
			
		</script>
	</body>
</html>
