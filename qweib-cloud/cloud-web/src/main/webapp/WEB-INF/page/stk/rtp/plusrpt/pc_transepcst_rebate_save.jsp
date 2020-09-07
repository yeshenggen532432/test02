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
		<script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
	</head>

	<body onload="initGrid()">
		<table id="datagrid"  fit="true" singleSelect="true"
			 title="" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="false" pagination="false" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" showFooter="true" data-options="onLoadSuccess: onLoadSuccess">
			
		</table>
		<div id="tb" style="padding:5px;height:auto">
		<input type="hidden" id="sdate" value="${sdate}" />
		<input type="hidden" id="edate" value="${edate}" />
		<input type="hidden" id="outType" value="${outType}" />
		<input type="hidden" id="customerType" value="${customerType}" />
		<input type="hidden" id="khNm" value="${khNm}" />
		<input type="hidden" id="epCustomerName" value="${epCustomerName}" />
		<input type="hidden" id="dateType" value="${dateType}" />
		<input type="hidden" id="wareNm" value="${wareNm}" />
		 标题: <input name="rptTitle" id="rptTitle" style="width:180px;height: 20px;" value="${title}" />
		 备注: <input name="remarks" id="remark" style="width:320px;height: 20px;" />
	     
	               <a class="easyui-linkbutton" iconCls="icon-save" href="javascript:saveRpt();">保存</a>
		</div>
		<script type="text/javascript">
		 var autoTitleDatas = eval('${autoTitleJson}');
		 var autoPriceDatas = eval('${autoPriceJson}');
		   //查询
		   //initGrid();
		   var cols = new Array(); 
		   function initGrid()
		   {
			   
	    	   var col = {
						field: 'epCustomerName',
						title: '所属二批客户名称',
						width: 140,
						align:'center'
				};
	    	    cols.push(col);
	    	   
	    	    var col = {
						field: 'khNm',
						title: '终端客户名称',
						width: 140,
						align:'center'
				};
	    	    cols.push(col);
	    	    
	    	    var col = {
						field: 'wareNm',
						title: '商品名称',
						width: 120,
						align:'center'
				};
	    	    cols.push(col);

	    	    var col = {
						field: 'outQty',
						title: '发货数量',
						width: 100,
						align:'center',
						formatter:amtformatter
				};
	    	    cols.push(col);
				
	    	    
	    	    var col = {
						field: 'rate',
						title: '单件返利',
						width: 100,
						align:'center',
						formatter:amtformatter
				};
	    	    cols.push(col);
	    	    
	    	    var col = {
						field: 'amt',
						title: '返利总额',
						width: 100,
						align:'center',
						formatter:amtformatter
				};
	    	    cols.push(col);

				$('#datagrid').datagrid({
    	    		columns:[
    	    		  		cols
    	    		  	]
						}
    	    );
				queryData();
		   }
		   function queryData(){
			   $('#datagrid').datagrid({
					url:"manager/queryStkCstTransRebate",
					queryParams:{
						sdate:$("#sdate").val(),
						edate:$("#edate").val(),
						outType:$("#outType").val(),
						khNm:$("#khNm").val(),
						epCustomerName:$("#epCustomerName").val(),
						customerType:$("#customerType").val(),
						timeType:$("#timeType").val(),
						wareNm:$("#wareNm").val()
						}
						}
   	   			 );
		   }
		   function formatterMny(v)
			{
				if (v != null) {
                   return numeral(v).format("0,0.00");
               }else{
            	   return v; 
               }
			}
			function amtformatter(v,row)
			{
				if (row != null) {
                    return numeral(v).format("0,0.00");
                }
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					 queryData();
				}
			}
			
			function onDblClickRow(rowIndex, rowData)
		    {
		    	var sdate = $("#sdate").val();
		    	var edate = $("#edate").val();
		    	var outType = $("#xsTp").val();
		    	var epCustomerName=rowData.epCustomerName;
		    	parent.closeWin('客户毛利明细统计');
		    	parent.add('客户毛利明细统计','manager/queryAutoCstStatDetail?sdate=' + sdate + '&edate=' + edate +'&epCustomerName='+epCustomerName+'&outType=' + outType + '&stkUnit=' + rowData.stkUnit);
		    	//parent.add('发货' + rowData.id,'manager/showstkoutcheck?dataTp=1&billId=' + rowData.id);
		    }
		    
		    function onLoadSuccess(data) {
		    	
        		var start = 0;
       	 		var end = 0;
        		if (data.total > 0) {
            	var temp = data.rows[0].epCustomerName;
            	for (var i = 1; i < data.rows.length; i++) {
                if (temp == data.rows[i].epCustomerName) {
                    end++;
                } else {
                    if (end > start) {
                         $("#datagrid").datagrid('mergeCells', {
                            index: start,
                            rowspan: end - start + 1,
                            field: 'epCustomerName'
                        });
                        
                    }
                    temp = data.rows[i].epCustomerName;
                    start = i;
                    end = i;
                }
            	}
            /*这里是为了判断重复内容出现在最后的情况，如ABCC*/
            	if (end > start) {
                 		$("#datagrid").datagrid('mergeCells', {
                            index: start,
                            rowspan: end - start + 1,
                            field: 'epCustomerName'
                        });
                       
            		}
        		}
    		}
			
			function mergeCol(data,colName){
				var start = 0;
       	 		var end = 0;
        		if (data.total > 0) {
            	var temp = data.rows[0][colName];
            	for (var i = 1; i < data.rows.length; i++) {
                if (temp == data.rows[i][colName]) {
                    end++;
                } else {
                    if (end > start) {
                         $("#datagrid").datagrid('mergeCells', {
                            index: start,
                            rowspan: end - start + 1,
                            field: colName
                        });
                    }
                    temp = data.rows[i][colName];
                    start = i;
                    end = i;
                }
            	}
            /*这里是为了判断重复内容出现在最后的情况，如ABCC*/
            	if (end > start) {
                 $("#datagrid").datagrid('mergeCells', {
                    index: start,
                    rowspan: end - start + 1,
                    field: colName
                });
            		}
        		}
        		
			}
			
			function showMainDetail(){
				var sdate = $("#sdate").val();
		    	var edate = $("#edate").val();
		    	var outType = $("#xsTp").val();
		    	var stkUnit = $("#khNm").val();
		    	var epCustomerName = $("#epCustomerName").val();
		    	var customerType = $("#customerType").val();
		    	parent.closeWin('客户毛利明细统计表');
		    	parent.add('客户毛利明细统计表','manager/queryAutoCstStatDetail?sdate=' + sdate + '&edate=' + edate +'&epCustomerName='+epCustomerName+'&outType=' + outType + '&customerType='+customerType+'&stkUnit=' + stkUnit);
			}
			
			
			
			
			
			
			 function formatAutoAmt(val,row,index){
			    	var price = "";
			    	var map = row.autoMap
			    	var html ="";	
			    	for(var key in map){
			    		  if(key==this.value){
			    			  html = map[key];
			    		  }
			    		}
			    	return formatterMny(html);
;
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
			 
			 
			 function saveRpt()
			 {
			 //alert(JSON.stringify(cols));
			 	var rows = $("#datagrid").datagrid("getRows");
			 	var sdate = $("#sdate").val();
			 	var edate = $("#edate").val();
			 	var outType = $("#outType").val();
			 	var khNm = $("#khNm").val();
			 	var epCustomerName = $("#epCustomerName").val();
			 	var customerType = $("#customerType").val();
			 	var dateType=$("#dateType").val();
			 	var dateTypeStr = "发票日期";
			 	if(+dateType == 1)dateTypeStr = "发货日期";
			 	var wareNm = $("#wareNm").val();
			 	var paramStr = dateTypeStr + ":" + sdate + "-" + edate + " 销售类型:" + outType + " 客户名称:" + khNm +  " 客户类型:" + customerType + " 所属二批客户名:" + epCustomerName + " 商品名称:" + wareNm;
			 	var merCols = 'epCustomerName';
		    	var dataStr = '{"paramStr":"' + paramStr + '","merCols":"' + merCols + '",' 
		    	 			+'"rows":'  +  JSON.stringify(rows)
		    	  			+ ',"cols":' + JSON.stringify(cols) + "}";
		    	
			 	var path = "manager/saveAutoCstDetailStat";
			 	$.ajax({
        		url: path,
        		type: "POST",
        		data : {"rptTitle":$("#rptTitle").val(),"remark":$("#remark").val(),"rptType":10,"saveHtml":dataStr},
        		dataType: 'json',
        		async : false,
        		success: function (data) {
        		data = eval(data);
							if(parseInt(data)>0){
								alert("保存成功！");
								parent.closeWin('生成的统计表');
						    	parent.add('生成的统计表','manager/toStkCstStatQuery?rptType=10');
							}else{
								alert("保存失败！");
							}
        			}
    			});
			 }
		</script>
	</body>
</html>
