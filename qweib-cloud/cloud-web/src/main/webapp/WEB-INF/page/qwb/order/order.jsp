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

	<body onload="queryorder()">
		<table id="datagrid"  fit="true" singleSelect="true"
			 iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="false" pagination="true" 
			nowrap="false",
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" data-options="onDblClickRow: onDblClickRow">
			<thead>
				<tr>
				    <th field="id" width="50" align="center" hidden="true">
						订单id
					</th>
					<th field="orderNo" width="135" align="center">
						订单号
					</th>
					<th field="orderZt" width="75" align="center" formatter="formatterSt2">
						订单状态
					</th>
					<th field="pszd" width="100" align="center">
						配送指定
					</th>
					<th field="oddate" width="80" align="center">
						下单日期
					</th>
					<th field="odtime" width="80" align="center">
						时间
					</th>
					<th field="shTime" width="120" align="center">
						送货时间
					</th>
					<th field="khNm" width="100" align="center" >
						客户名称
					</th>
					<th field="memberNm" width="80" align="center" >
						业务员名称
					</th>
					<th field="count" width="520" align="center" formatter="formatterSt">
						商品信息
					</th>
					<th field="zje" width="60" align="center" >
						总金额
					</th>
					<th field="zdzk" width="60" align="center" >
						整单折扣
					</th>
					<th field="cjje" width="60" align="center" >
						成交金额
					</th>
					
					<th field="remo" width="200" align="center" >
						备注
					</th>
					<th field="shr" width="80" align="center" >
						收货人
					</th>
					<th field="tel" width="100" align="center" >
						电话
					</th>
					<th field="address" width="275" align="center" >
						地址
					</th>
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
		            订单号: <input name="orderNo" id="orderNo" style="width:120px;height: 20px;" value="${orderNo}" onkeydown="toQuery(event);"/>
			客户名称: <input name="khNm" id="khNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
			业务员名称: <input name="memberNm" id="memberNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
			下单日期: <input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         			-
	         		  <input name="edate" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	        配送指定: <select name="pszd" id="pszd">
	                    <option value="">全部</option>
	                    <option value="公司直送">公司直送</option>
	                    <option value="转二批配送">转二批配送</option>
	                </select>	  		  
	         订单状态: <select name="orderZt" id="orderZt" >
	                    <option value="">全部</option>
	                    <option value="审核">审核</option>
	                    <option value="未审核" ${orderZt eq '未审核'?'selected':''}>未审核</option>
	                    <option value="已作废">已作废</option>
	                </select>
	          订单类别: <select name="orderLb" id="orderLb">
	           		<option value="">全部</option>
	                <option value="拜访单">拜访单</option>
	                <option value="电话单">电话单</option>
	                <option value="车销单">车销单</option>
	           </select>
	          仓库：<tag:select name="stkId" id="stkId" tableName="stk_storage" whereBlock="status=1 or status is null" headerKey="" headerValue="--请选择--" displayKey="id" displayValue="stk_name"/>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryorder();">查询</a>
			<a class="easyui-linkbutton" iconCls="icon-remove" plain="true" href="javascript:toZf();">作废</a>
			<a class="easyui-linkbutton" iconCls="icon-remove" plain="true" href="javascript:toDel();">删除</a>
			<a class="easyui-linkbutton" iconCls="icon-search" plain="true" href="javascript:addorder();">新增</a>
			<a class="easyui-linkbutton" iconCls="icon-search" plain="true" href="javascript:toShow();">修改</a>
			<a class="easyui-linkbutton" iconCls="icon-redo" plain="true" href="javascript:toLoadExcel();">导出</a>
			<a class="easyui-linkbutton" iconCls="icon-print" plain="true" href="javascript:toPrint();">打印</a>
		</div>
		<div>
		  	<form action="manager/orderExcel" name="loadfrm" id="loadfrm" method="post">
		  		<input type="text" name="orderNo2" id="orderNo2"/>
				<input type="text" name="khNm2" id="khNm2"/>
				<input type="text" name="memberNm2" id="memberNm2"/>
				<input type="text" name="sdate2" id="sdate2"/>
				<input type="text" name="edate2" id="edate2"/>
				<input type="text" name="orderZt2" id="orderZt2"/>
				<input type="text" name="pszd2" id="pszd2"/>
		  	</form>
	  	</div>
		<%@include file="/WEB-INF/page/export/export.jsp"%>
		<script type="text/javascript">
		    var database="${database}";
			function queryorder(){
				
				 var cols = new Array(); 
		    	    var col = {
							field: 'id',
							title: 'id',
							width: 50,
							align:'center',
							hidden:'true'
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'orderNo',
							title: '订单号',
							width: 135,
							align:'center'
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'orderZt',
							title: '订单状态',
							width: 75,
							align:'center',
							
							formatter:formatterSt2
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'pszd',
							title: '配送指定',
							width: 100,
							align:'center',
							
							formatter:formatterSt2
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'oddate',
							title: '下单日期',
							width: 100,
							align:'center',
							formatter:formatterSt2
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'odtime',
							title: '时间',
							width: 80,
							align:'center'
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'shTime',
							title: '送货时间',
							width: 120,
							align:'center'
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'khNm',
							title: '客户名称',
							width: 100,
							align:'center'
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'memberNm',
							title: '业务员名称',
							width: 80,
							align:'center'
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'count',
							title: '商品信息',
							width: 520,
							align:'center',
							formatter:formatterSt
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'zje',
							title: '总金额',
							width: 60,
							align:'center',
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'zdzk',
							title: '整单折扣',
							width: 60,
							align:'center'
					};
		    	    cols.push(col);
			
		    	    var col = {
							field: 'cjje',
							title: '成交金额',
							width: 60,
							align:'center'
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'remo',
							title: '备注',
							width: 200,
							align:'center',
							nowrap:false 	
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'shr',
							title: '收货人',
							width: 80,
							align:'center'
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'tel',
							title: '电话',
							width: 100,
							align:'center'
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'address',
							title: '电话',
							width: 275,
							align:'center'
					};
		    	    cols.push(col);
		    	    $('#datagrid').datagrid({
		    	    	 url:"manager/bforderPage?database="+database,
		    	    	 nowrap:false,       
                         cache:false, 
                         border: false,
                         rownumbers: true,
                         striped : true,
                         fixed:true,
		    	    	queryParams:{
		    	    		jz:"1",
		    	    		orderNo:$("#orderNo").val(),
							khNm:$("#khNm").val(),
							memberNm:$("#memberNm").val(),
							orderZt:$("#orderZt").val(),
							pszd:$("#pszd").val(),
							sdate:$("#sdate").val(),
							edate:$("#edate").val(),
							stkId:$("#stkId").val(),
							orderLb:$("#orderLb").val()
			    	    	},
		    	    		columns:[
		    	    		  		cols
		    	    		  	]
		    	    		
		    	    }
		    	    );
		    	    $('#datagrid').datagrid('reload');
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					queryorder();
				}
			}
			//导出
			function myexport(){
			     exportData('sysBforderService','queryBforderPage','com.cnlife.qwb.model.SysBforder',"{khNm:'"+$("#khNm").val()+"',memberNm:'"+$("#memberNm").val()+"',database:'"+database+"',sdate:'"+$("#sdate").val()+"',edate:'"+$("#edate").val()+"'}","销售订单记录");
  			}
			function formatterSt(v,row){
				var hl='<table>';
				if(row.list.length>0){
			        hl +='<tr>';
			        hl +='<td width="120px;"><b>商品名称</b></td>';
			        hl +='<td width="80px;"><b>销售类型</b></td>';
			        hl +='<td width="60px;"><b>单位</font></b></td>';
			        hl +='<td width="80px;"><b>规格</font></b></td>';
			        hl +='<td width="60px;"><b>数量</font></b></td>';
			        hl +='<td width="60px;"><b>单价</font></b></td>';
			        hl +='<td width="60px;"><b>总价</font></b></td>';
			        hl +='</tr>';
		        }
		        for(var i=0;i<row.list.length;i++){
		            hl +='<tr>';
			        hl +='<td>'+row.list[i].wareNm+'</td>';
			        hl +='<td>'+row.list[i].xsTp+'</td>';
			        hl +='<td>'+row.list[i].wareDw+'</td>';
			        hl +='<td>'+row.list[i].wareGg+'</td>';
			        hl +='<td>'+row.list[i].wareNum+'</td>';
			        hl +='<td>'+row.list[i].wareDj+'</td>';
			        hl +='<td>'+row.list[i].wareZj+'</td>';
			        hl +='</tr>';
		        }
		        hl +='</table>';
  			    return hl;
			}
			
			function addorder(){
				window.parent.add("销售订单","manager/addorder");
			}
			
			function todetail(title,id){
				window.parent.add(title,"manager/queryBforderDetailPage?orderId="+id);
			}
			function formatterSt2(val,row){
			  if(row.list.length>0){
			    if(val=='未审核'){
		            return "<input style='width:60px;height:27px' type='button' value='未审核' onclick='updateOrderSh(this, "+row.id+")'/>";
			     }else{
			        return val;   
			     }
			  }
		    } 
		    //修改审核
		    function updateOrderSh(_this,id){
		      $.messager.confirm('确认', '您确认要审核吗？', function(r) {
			  if (r) {
				$.ajax({
					url:"manager/updateOrderSh",
					type:"post",
					data:"id="+id+"&sh=审核",
					success:function(data){
						if(data=='1'){
						    alert("操作成功");
							queryorder();
						}else{
							alert("操作失败");
							return;
						}
					}
				});
			  }
			 });
			 }
			 //导出成excel
		    function toLoadExcel(){
		        $('#orderNo2').val($('#orderNo').val());
				$('#khNm2').val($('#khNm').val());
				$('#memberNm2').val($('#memberNm').val());   
				$('#sdate2').val($('#sdate').val()); 
				$('#edate2').val($('#edate').val());
				$('#orderZt2').val($('#orderZt').val());  
				$('#pszd2').val($('#pszd').val()); 
				$('#loadfrm').form('submit',{
					success:function(data){
						alert(data);
					}
				});
			}
			 
		    function toShow() {
				var id = "";
				var rows = $("#datagrid").datagrid("getSelections");
				for ( var i = 0; i < rows.length; i++) {
					id=rows[i].id;
					break;
				}
				if(id==""){
					alert("请选中一条纪录");
				}
				window.parent.add("销售订单","manager/showorder?id="+id);
			}
			
		    function onDblClickRow(rowIndex, rowData)
		    {
		    	window.parent.add("销售订单","manager/showorder?id="+rowData.id);
		    }
		    
			//删除
		    function toDel() {
				var ids = [];
				var rows = $("#datagrid").datagrid("getSelections");
				for ( var i = 0; i < rows.length; i++) {
					ids.push(rows[i].id);
					if(rows[i].orderZt=='审核'){
					   alert("该订单审核了，不能删除");
					   return;
					}
				}
				if (ids.length > 0) {
					$.messager.confirm('确认', '您确认想要删除记录吗？', function(r) {
						if (r) {
							$.ajax( {
								url : "manager/deleteOrder",
								data : "id=" + ids,
								type : "post",
								success : function(json) {
									if (json == 1) {
										showMsg("删除成功");
										$("#datagrid").datagrid("reload");
									} else if (json == -1) {
										showMsg("删除失败");
									}
								}
							});
						}
					});
				} else {
					showMsg("请选择要删除的数据");
				}
			}
			//作废
		    function toZf() {
				var ids = [];
				var rows = $("#datagrid").datagrid("getSelections");
				for ( var i = 0; i < rows.length; i++) {
					ids.push(rows[i].id);
					if(rows[i].orderZt=='未审核'){
					   alert("该订单未审核，不能作废");
					   return;
					}
					if(rows[i].orderZt=='已作废'){
					   alert("该订单已作废，不能再作废");
					   return;
					}
				}
				if (ids.length > 0) {
					$.messager.confirm('确认', '您确认想要作废该记录吗？', function(r) {
						if (r) {
							$.ajax( {
								url : "manager/updateOrderZf",
								data : "id=" + ids,
								type : "post",
								success : function(json) {
									if (json == 1) {
										showMsg("作废成功");
										$("#datagrid").datagrid("reload");
									} else if (json == -1) {
										showMsg("作废失败");
									}
								}
							});
						}
					});
				} else {
					showMsg("请选择要作废的数据");
				}
			}
		  //打印
			 function toPrint() {
				var ids = [];
				var rows = $("#datagrid").datagrid("getSelections");
				for ( var i = 0; i < rows.length; i++) {
					ids.push(rows[i].id);
					
					
				}
				if(rows.length > 1)
					{
					showMsg("只能选择一张单据");
					return;
					}
				if (ids.length > 0) {
					window.parent.add("订单打印","manager/showorderprint?billId=" + ids[0]);
					
				} else {
					showMsg("请选择要打印的数据");
				}
			}
			if('${orderNo}'!=""){
				queryorder();
			}
		</script>
	</body>
</html>
