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

	<body onload="initGrid()">
	<input type="hidden" id="billId" value="${billId}" />
	<input type="hidden" id="remarks" value="${remarks}" />
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
			 title="" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="false" pagination="true" nowrap="false"
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" >
		<thead>
				<tr>
				    <th field="id" width="50" align="center" hidden="true">
						id
					</th>
				</tr>
			</thead>	
		</table>
		
		<div id="tb" style="padding:5px;height:auto">	
		<div style="margin-bottom:5px">   
		 &nbsp;&nbsp;<span style="background-color:#FF00FF;border: 1;color:white ">&nbsp;被冲红单&nbsp;</span>&nbsp;<span style="background-color:red;border: 1;color:white">&nbsp;&nbsp;&nbsp;冲红单&nbsp;&nbsp;&nbsp;</span>&nbsp;<span style="background-color:blue;border: 1;color:white">&nbsp;&nbsp;&nbsp;作废单&nbsp;&nbsp;&nbsp;</span>
		</div>	
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
		   //$("#billStatus").val("未收货");
		    //initGrid();
		    function initGrid()
		    {
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
							field: 'remarks',
							title: '类型',
							width: 100,
							align:'center'
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'billNo',
							title: '单号',
							width: 135,
							align:'center'
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'accTimeStr',
							title: '日期',
							width: 100,
							align:'center'
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'inAmt',
							title: '收入金额',
							width: 100,
							align:'center'
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'outAmt',
							title: '支出金额',
							width: 100,
							align:'center'
											
					};
		    	    cols.push(col);
		    	   
		    	    var col = {
							field: 'operator',
							title: '操作员',
							width: 80,
							align:'center'
											
					};
		    	    cols.push(col);

		    	    var col = {
							field: 'status',
							title: '状态',
							width: 80,
							align:'center',
							formatter:formatterStr
					};
		    	    cols.push(col);
		    	    
		    	    var col = {
							field: 'remarks1',
							title: '备注',
							width: 200,
							align:'left'		
					};
		    	    cols.push(col);
		    	    
		    	    var col = {
							field: '_operator',
							title: '操作',
							width: 120,
							align:'center',
							formatter:formatterSt3
					};
		    	    cols.push(col);

		    	    $('#datagrid').datagrid({
		    	    	url:"manager/queryAccIoPage",
		    	    	queryParams:{		    	    		
		    	    		billId:$("#billId").val(),									
							remarks:$("#remarks").val()
			    	    	
			    	    	},
		    	    		columns:[
		    	    		  		cols
		    	    		  	],
	    	    		  	 rowStyler:function(index,row){    
		    	    		  	 if (row.status==2){      
		   	    		             return 'color:blue;text-decoration:line-through;font-weight:bold;';      
		   	    		         } 
		   	    		         if (row.status==3){      
		   	    		             return 'color:#FF00FF;font-weight:bold;';      
		   	    		         }  
		   	    		         if (row.status==4){      
		   	    		             return 'color:red;font-weight:bold;';      
		   	    		         }
    	    		     } 
			    	    }
		    	    );
		    	    //$('#datagrid').datagrid('reload'); 
			}
		    //查询物流公司
			function queryorder(){
				$("#datagrid").datagrid('load',{
					url:"manager/queryAccIoPage?database="+database,					
					billId:$("#billId").val(),									
					remarks:$("#remarks").val()
					
				});
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					queryorder();
				}
			}
			//导出
			
			function amtformatter(v,row)
			{
				if (row != null) {
                    return toThousands(v);//numeral(v).format("0,0.00");
                }
			}	    
		    
			function formatterSt3(val,row){
			     
		      	var ret ="";
		      	if(row.status == 0)
		      		ret = "<input style='width:60px;height:27px' type='button' value='作废' onclick='cancelBill("+row.id+",\""+row.remarks+"\")'/>";
	      	        return ret;
		      		
		   } 
			
			function cancelBill(id,type){
				 
				  var url = "manager/deleteFinBackIn";
				  if(type=="还款支出"){
					  url = "manager/deleteFinBackOut";
				  }
			      $.messager.confirm('确认', '您确认要作废吗？', function(r) {
				  if (r) {
					$.ajax({
						url:url,
						type:"post",
						data:"ioId="+id,
						success:function(json){
							if(json.state){
							    alert("操作成功");
							    $('#datagrid').datagrid('reload'); 
							}else{
								alert("操作失败" + json.msg);
								return;
							}
						}
					});
				  }
				 });
				 }
			
			 function formatterStr(v,row){
				   if(v==0){
					   return "正常";
				   }else if(v==2){
					   return "作废";
				   }else if(v==3){
					   return "被冲红单";
				   }else if(v==4){
					   return "冲红单";
				   }
				   
			   }
		</script>
	</body>
</html>
