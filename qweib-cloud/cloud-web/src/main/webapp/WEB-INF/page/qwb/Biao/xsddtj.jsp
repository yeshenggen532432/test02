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
			url="manager/xsddtjPage?dataTp=${dataTp }" title="销售订单统计表" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="true" pagination="true" 
			pageSize=20 data-options="onLoadSuccess: onLoadSuccess" pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
			<thead>
				<tr>
				    <th field="khNm" width="120" align="center">
						客户名称
					</th>
					<th field="memberNm" width="80" align="center">
						业务员名称
					</th>
					<th field="count1" width="500" align="center" formatter="formatterSt1">
						订单信息
					</th>
					<th field="zje" width="50" align="center">
						金额总计
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
	     订单状态:<select name="orderZt" id="orderZt">
	                  <option value="">全部</option>
	                  <option value="审核">审核</option>
	                  <option value="未审核">未审核</option>
	            </select>
	     配送指定:<select name="pszd" id="pszd">
	                  <option value="">全部</option>
	                  <option value="公司直送">公司直送</option>
	                  <option value="转二批配送">转二批配送</option>
	            </select>              	   
	     客户名称: <input name="khNm" id="khNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
		 业务员名称: <input name="memberNm" id="memberNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
	               <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryxsddtj();">查询</a>
	               <font color="red"><span id="zsxx" style="margin-left: 10px;"></span></font>
		</div>
		<script type="text/javascript">
		   //查询
			function queryxsddtj(){
				$("#datagrid").datagrid('load',{
					url:"manager/xsddtjPage",
					stime:$("#stime").val(),
					etime:$("#etime").val(),
					orderZt:$("#orderZt").val(),
					pszd:$("#pszd").val(),
					khNm:$("#khNm").val(),
					memberNm:$("#memberNm").val()
				});
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					queryxsddtj();
				}
			}
			function formatterSt1(v,row){
				var hl='<table width="100%">';
				if(row.list1.length>0){
			        hl +='<tr>';
			        hl +='<td width="30%;"><b>商品名称</b></td>';
			        hl +='<td width="20%;"><b>销售类型</font></b></td>';
			        hl +='<td width="20%;"><b>单位</b></td>';
			        hl +='<td width="10%;"><b>订单数量</font></b></td>';
			        hl +='<td width="10%;"><b>单价</b></td>';
			        hl +='<td width="10%;"><b>订单金额</font></b></td>';
			        hl +='</tr>';
		        }
		        for(var i=0;i<row.list1.length;i++){
		            hl +='<tr>';
			        hl +='<td>'+row.list1[i].wareNm+'</td>';
			        hl +='<td>'+row.list1[i].xsTp+'</td>';
			        hl +='<td>'+row.list1[i].wareDw+'</td>';
			        hl +='<td>'+row.list1[i].wareNum+'</td>';
			        hl +='<td>'+row.list1[i].wareDj+'</td>';
			        hl +='<td>'+row.list1[i].wareZj+'</td>';
			        hl +='</tr>';
		        }
		        hl +='</table>';
  			    return hl;
			}
			function onLoadSuccess(data){
			   $("#zsxx").html(data.footer[0].memberNm);
			}
		</script>
	</body>
</html>
