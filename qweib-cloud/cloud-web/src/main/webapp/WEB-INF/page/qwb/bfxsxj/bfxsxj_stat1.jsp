<%@ page language="java" pageEncoding="UTF-8"%>
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
	</head>

	<body class="easyui-layout" >
	<div data-options="region:'west',split:true,title:'商品分类树'"
		 style="width:150px;padding-top: 5px;">
		<ul id="waretypetree" class="easyui-tree"
			data-options="url:'manager/syswaretypes',animate:true,dnd:true,onClick: function(node){
					queryByWaretypeId(node.id);
				},onDblClick:function(node){
					$(this).tree('toggle', node.target);
				}">
		</ul>
	</div>
	<div id="wareTypeDiv" data-options="region:'center'" title="销售小结">
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
			 title="销售小结信息列表" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="true" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" data-options="onDblClickRow: onDblClickRow">
			<thead>
				<tr>
				    <th field="cid" width="50" align="center" hidden="true">
						cid
					</th>
					
					<th field="khNm" width="120" align="center">
						客户名称
					</th>
					
					<th field="kcNum" width="100" align="center">
						公司产品最后库存数
					</th>
					<th field="kcNum1" width="100" align="center">
						非公司产品最后库存数
					</th>
					<th field="dhNum" width="100" align="center">
						到货数量
					</th>					
					<th field="sxNum" width="100" align="center">
						实销数量
					</th>	
					<th field="ddNum" width="100" align="center">
						订单数量
					</th>					
					
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
		起止日期: <input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         			-
	         		  <input name="edate" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	     客户类型: <select name="customerType" id="customerType" style="width: 100px;"></select>
	 客户名称: <input name="khNm" id="khNm" style="width:100px;height: 20px;"/>	  
	    公司类别:<select name="noCompany" id="noCompany">
	                  <option value="0">全部</option>
	                  <option value="2">公司类别</option>
	                  <option value="1">非公司类别</option>					 
	               </select>
	合作方式: <select name="hzfsNm" id="hzfsNm" style="width: 125px;">
	        		              <option value="">合部</option>
			        			 <c:forEach items="${hzfsls}" var="hzfsls">
			        			  <option value="${hzfsls.hzfsNm}" <c:if test="${hzfsls.hzfsNm==customer.hzfsNm}">selected</c:if>>${hzfsls.hzfsNm}</option>
			        			 </c:forEach>
			        		   </select>
	业务员: <input name="staff" id="staff" style="width:100px;height: 20px;"/>	  	        		   
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:querySumPage(0);">查询</a>
			<a class="easyui-linkbutton" iconCls="icon-print" href="javascript:myexport();">导出</a>
			<input type="hidden" id="waretypeId" value="0"/>
			<input type="hidden" id="database" value="${database}"/>
			<%@include file="/WEB-INF/page/export/export.jsp"%>	
		</div>
	</div>
		<script type="text/javascript">
			function formatterSt(v,row){
				if(v>0){
				   return "临期("+v+")";
				}else{
				   return "正常";
				}
			}
			function queryByWaretypeId(id)
			{

				querySumPage(id);
			}
			function querySumPage(wareType){
		    		  

				$('#datagrid').datagrid({
					url:"manager/sumBfxsxjPage1",
					queryParams:{	
					sdate:$("#sdate").val(),
					edate:$("#edate").val(),					
					customerType:$("#customerType").val(),
					noCompany:$("#noCompany").val(),
					khNm:$("#khNm").val(),
					hzfsNm:$("#hzfsNm").val(),
					memberNm:$("#staff").val(),
						waretype:wareType
					}
					
				});
			  
			  
			}
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
	 function addDate(date, days) {
         if (days == undefined || days == '') {
             days = 1;
         }
         var date = new Date(date);
         date.setDate(date.getDate() + days);
         var month = date.getMonth() + 1;
         var day = date.getDate();
         return date.getFullYear() + '-' + getFormatDate(month) + '-' + getFormatDate(day);
     }
	 function getFormatDate(arg) {
         if (arg == undefined || arg == '') {
             return '';
         }

         var re = arg + '';
         if (re.length < 2) {
             re = '0' + re;
         }

         return re;
     }
	 function myexport(){
			var database = $("#database").val();
			var sdate=$("#sdate").val();
			var edate=$("#edate").val();	
			edate = addDate(edate,1);			
			var customerType =$("#customerType").val();
			var noCompany=$("#noCompany").val();
			var khNm = $("#khNm").val();
			
		    
			exportData('sysBfxsxjService','sumBfxsxjPage1','com.cnlife.qwb.model.SysBfxsxj',"{sdate:"+sdate+",edate:"+edate+",database:'"+database+"',customerType:'" + customerType + "',noCompany:" + noCompany + ",khNm:'" + khNm + "'}","拜访销售总结汇总表");
			
			
		}
	 
	 function onDblClickRow(rowIndex, rowData)
	    {
			var sdate = $("#sdate").val();
	    	var edate = $("#edate").val();	   
	    	var noCompany=$("#noCompany").val();
	    	var cid = rowData.cid	    	
	    	parent.closeWin('拜访销售小结-' + rowData.khNm);
	    	parent.add('拜访销售小结-' + rowData.khNm,'manager/toSumBfxsxj1?sdate=' + sdate + '&edate=' + edate + '&cid=' + cid + '&noCompany=' + noCompany );
	    }

		</script>
	</body>
</html>
