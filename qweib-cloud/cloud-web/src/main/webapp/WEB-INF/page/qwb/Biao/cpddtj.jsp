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

	<body>
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
			url="manager/cpddtjPage?dataTp=${dataTp }" title="产品订单统计表" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="true" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" showFooter="true">
			<thead>
				<tr>
				    <th field="wareNm" width="100" align="center">
						商品名称
					</th>
					<th field="xsTp" width="120" align="center">
						销售类型
					</th>
					<th field="wareDw" width="80" align="center">
						单位
					</th>
					<th field="nums" width="60" align="center">
						订单数量
					</th>
					<th field="wareDj" width="60" align="center">
						单价
					</th>
					<th field="zjs" width="60" align="center">
						订单金额
					</th>
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
		   时间: <input name="stime" id="stime"  onClick="WdatePicker();" style="width: 100px;" value="${etime}" readonly="readonly"/>
	         	   <img onclick="WdatePicker({el:'stime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         	   -
	         	<input name="etime" id="etime"  onClick="WdatePicker();" style="width: 100px;" value="${etime}" readonly="readonly"/>
	         	   <img onclick="WdatePicker({el:'etime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	        销售类型:<select name="xsTp" id="xsTp">
	                  <option value="">全部</option>
	                  <option value="正常销售">正常销售</option>
	                  <option value="促销折让">促销折让</option>
	                  <option value="消费折让">消费折让</option>
	                  <option value="费用折让">费用折让</option>
	                  <option value="其它">其它</option>
	               </select>
	        配送指定:<select name="pszd" id="pszd">
	                  <option value="">全部</option>
	                  <option value="公司直送">公司直送</option>
	                  <option value="转二批配送">转二批配送</option>
	            </select>        
	        客户名称: <input name="khNm" id="khNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
		   业务员名称: <input name="memberNm" id="memberNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>   
	               <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:querycpddtj();">查询</a>
		</div>
		<script type="text/javascript">
		   //查询
			function querycpddtj(){
				$("#datagrid").datagrid('load',{
					url:"manager/cpddtjPage",
					stime:$("#stime").val(),
					etime:$("#etime").val(),
					xsTp:$("#xsTp").val(),
					pszd:$("#pszd").val(),
					khNm:$("#khNm").val(),
					memberNm:$("#memberNm").val()
				});
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					querycpddtj();
				}
			}
			
			
		</script>
	</body>
</html>
