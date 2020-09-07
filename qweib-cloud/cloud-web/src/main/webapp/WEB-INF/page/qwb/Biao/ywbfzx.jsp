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
			url="manager/ywbfzxPage?dataTp=${dataTp }" title="业务拜访执行表" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="true" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
			<thead>
				<tr>
				    <th field="mid" width="50" align="center" hidden="true">
						业务员id
					</th>
					<th field="cid" width="50" align="center" hidden="true">
						客户id
					</th>
					<th field="qddate" width="50" align="center" hidden="true">
						签到日期
					</th>
					<th field="timed" width="100" align="center">
						时间段
					</th>
					<th field="khNm" width="120" align="center">
						客户名称
					</th>
					<th field="memberNm" width="80" align="center">
						业务员名称
					</th>
					<th field="qdtpNum" width="60" align="center" formatter="formatterStPic1">
						签到图片
					</th>
					<th field="sdhtpNum" width="80" align="center" formatter="formatterStPic2">
						生动化陈列采集图片
					</th>
					<th field="kcjctpNum" width="60" align="center" formatter="formatterStPic3">
						库存检查图片
					</th>
					<th field="count1" width="200" align="center" formatter="formatterSt1">
						订单信息
					</th>
					<th field="count2" width="200" align="center" formatter="formatterSt2">
						库存信息
					</th>
					<th field="bfbz" width="60" align="center">
						完成拜访步骤
					</th>
					<th field="khdjNm" width="60" align="center">
						客户等级
					</th>
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
		   时间: <input name="qddate" id="qddate"  onClick="WdatePicker();" style="width: 100px;" value="${qddate}" readonly="readonly"/>
	         	<img onclick="WdatePicker({el:'qddate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	       业务员名称: <input name="memberNm" id="memberNm" style="width:100px;height: 20px;" onkeydown="toQuery(event);"/>
	       客户名称: <input name="khNm" id="khNm" style="width:100px;height: 20px;" onkeydown="toQuery(event);"/>
	       客户等级: <select name="khdjNm" id="khdjNm">
	                  <option value="">全部</option>
	                  <c:forEach items="${list}" var="list">
						<option value="${list.khdjNm}">${list.khdjNm}</option>
					  </c:forEach>
	               </select>   	   
	               <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryywbfzx();">查询</a>
		</div>
		<script type="text/javascript">
		   //查询
			function queryywbfzx(){
				$("#datagrid").datagrid('load',{
					url:"manager/ywbfzxPage",
					qddate:$("#qddate").val(),
					memberNm:$("#memberNm").val(),
					khNm:$("#khNm").val(),
					khdjNm:$("#khdjNm").val()
				});
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					queryywbfzx();
				}
			}
			function formatterSt1(v,row){
				var hl='<table width="100%">';
				if(row.list1.length>0){
			        hl +='<tr>';
			        hl +='<td width="60%;"><b>商品名称</b></td>';
			        hl +='<td width="40%;"><b>数量</font></b></td>';
			        hl +='</tr>';
		        }
		        for(var i=0;i<row.list1.length;i++){
		            hl +='<tr>';
			        hl +='<td>'+row.list1[i].wareNm+'</td>';
			        hl +='<td>'+row.list1[i].wareNum+'</td>';
			        hl +='</tr>';
		        }
		        hl +='</table>';
  			    return hl;
			}
			function formatterSt2(v,row){
				var hl='<table width="100%">';
				if(row.list2.length>0){
			        hl +='<tr>';
			        hl +='<td width="60%;"><b>商品名称</b></td>';
			        hl +='<td width="40%;"><b>数量</font></b></td>';
			        hl +='</tr>';
		        }
		        for(var i=0;i<row.list2.length;i++){
		            hl +='<tr>';
			        hl +='<td>'+row.list2[i].wareNm+'</td>';
			        hl +='<td>'+row.list2[i].kcNum+'</td>';
			        hl +='</tr>';
		        }
		        hl +='</table>';
  			    return hl;
			}
			function formatterStPic1(v,row){
				return '<a class="easyui-linkbutton" iconCls="icon-search" plain="true" href="javascript:todetail(\'图片详情\','+row.mid+','+row.cid+',\''+row.qddate+'\',\'1\');">'+v+'</a>';
			}
			function formatterStPic2(v,row){
				return '<a class="easyui-linkbutton" iconCls="icon-search" plain="true" href="javascript:todetail(\'图片详情\','+row.mid+','+row.cid+',\''+row.qddate+'\',\'2\');">'+v+'</a>';
			}
			function formatterStPic3(v,row){
				return '<a class="easyui-linkbutton" iconCls="icon-search" plain="true" href="javascript:todetail(\'图片详情\','+row.mid+','+row.cid+',\''+row.qddate+'\',\'3\');">'+v+'</a>';
			}
			function todetail(title,mid,cid,qddate,tp){
			    window.parent.add(title,"manager/bfcPicXq?mid="+mid+"&cid="+cid+"&qddate="+qddate+"&tp="+tp);
			}
			
		</script>
	</body>
</html>
