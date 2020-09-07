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

	<body onload="queryData()">
	<input type="hidden" id="id" value="${id}" />
	
		<table id="datagrid"  fit="true" singleSelect="true"
			 title="" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="false"  toolbar="#tb" showFooter="true" data-options="onLoadSuccess: onLoadSuccess">
			
		</table>
		<div id="tb" style="padding:5px;height:auto">
		   标题: <input name="rptTitle" id="rptTitle" style="width:180px;height: 20px;" value="${title}" />
		   备注: <input name="remarks" id="remark" style="width:320px;height: 20px;" />
	     <span id="paramStr">
	     </span>
	              
	               
		</div>
		<script type="text/javascript">
		 var autoTitleDatas = eval('${autoTitleJson}');
		 var autoPriceDatas = eval('${autoPriceJson}');
		   //查询
		   //initGrid();
		   var merCols = new Array();
		   function initGrid(cols)
		   {
			   
	    	   

				$('#datagrid').datagrid({
    	    		columns:[
    	    		  		cols
    	    		  	]
						}
    	    );
    	    
		   }
		   function queryData(){
		   var path = "manager/queryCstStatMastData";
		   var id= $("#id").val();
		   
			   $.ajax({
        		url: path,
        		type: "POST",
        		data : {"id":id},
        		dataType: 'json',
        		async : false,
        		success: function (json) {
        			if(json.state){
        				//alert(json.blodHtml);
        				$("#rptTitle").val(json.rptTitle);
        				$("#remark").val(json.remark);
        				
        				var obj = eval('(' + json.blodHtml +  ')');
        				$("#paramStr").text(obj.paramStr);
        				//alert(obj.merCols);
        				merCols = obj.merCols.split(",");
        				//alert(merCols.length);
        				initGrid(obj.cols);
        				//var rows = JSON.stringify(obj.rows);
        				$('#datagrid').datagrid('loadData',{"total" : 1,"rows" : obj.rows});   
				
        		
        		}
        	}
    		});
   	   		//document.getElementById("saveHtml").value=$("#saveHtmlDiv").formhtml();
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
		    	if(merCols.length == 0)return;
        		var start = 0;
       	 		var end = 0;
        		if (data.total > 0) {
            	var temp = data.rows[0][merCols[0]];
            	for (var i = 1; i < data.rows.length; i++) {
                if (temp == data.rows[i][merCols[0]]) {
                    end++;
                } else {
                    if (end > start) {
                         $("#datagrid").datagrid('mergeCells', {
                            index: start,
                            rowspan: end - start + 1,
                            field: merCols[0]
                        });
                         for(var j = 1;j<merCols.length;j++)
                        	 {
                        	 $("#datagrid").datagrid('mergeCells', {
                                 index: start,
                                 rowspan: end - start + 1,
                                 field: merCols[j]
                             });
                        	 }
                        
                    }
                    temp = data.rows[i][merCols[0]];
                    start = i;
                    end = i;
                }
            	}
            /*这里是为了判断重复内容出现在最后的情况，如ABCC*/
            	if (end > start) {
                 		$("#datagrid").datagrid('mergeCells', {
                            index: start,
                            rowspan: end - start + 1,
                            field: merCols[0]
                        });
                 		for(var j = 1;j<merCols.length;j++)
                   	 	{
                   	 	$("#datagrid").datagrid('mergeCells', {
                            index: start,
                            rowspan: end - start + 1,
                            field: merCols[j]
                        });
                   	 	}
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
			
			
			function createRptData()
		    {
				var sdate = $("#sdate").val();
		    	var edate = $("#edate").val();
		    	var outType = $("#xsTp").val();
		    	var stkUnit = $("#khNm").val();
		    	var epCustomerName = $("#epCustomerName").val();
		    	var customerType = $("#customerType").val();
		    	parent.closeWin('生成客户费用统计表');
		    	parent.add('生成客户费用统计表','manager/queryAutoCstStatDetailList?sdate=' + sdate + '&edate=' + edate +'&outType='+outType+'&stkUnit=' + stkUnit+'&customerType='+customerType+'&epCustomerName='+epCustomerName);
		    }
			
			function queryRpt()
		    {
		    	parent.closeWin('生成的统计表');
		    	parent.add('生成的统计表','manager/querySaveRptDataStat?rptType=4');
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
			 function saveRpt()
			 {
			 alert(JSON.stringify(cols));
			 	var rows = $("#datagrid").datagrid("getRows");
			 	var sdate = $("#sdate").val();
			 	var edate = $("#edate").val();
			 	var outType = $("#outType").val();
			 	var khNm = $("#khNm").val();
			 	var epCustomerName = $("#epCustomerName").val();
			 	var customerType = $("#customerType").val();
			 	var dateType=$("#dateType").val();
		    	var dataStr = '{"state":true,"sdate":"' + sdate + '","edate":"' + edate + '","outType":"' + outType 
		    	 			+ '","khNm":"' + khNm + '","epCustomerName":"' + epCustomerName + '","customerType":"' + customerType + '","dateType":' + dateType+ ',"rows":'  +  JSON.stringify(rows)
		    	  			+ ',"cols":' + JSON.stringify(cols) + "}";
			 	var path = "manager/saveAutoCstDetailStat";
			 	$.ajax({
        		url: path,
        		type: "POST",
        		data : {"rptTitle":$("#rptTitle").val(),"remark":$("#remark").val(),"rptType":6,"saveHtml":dataStr},
        		dataType: 'json',
        		async : false,
        		success: function (data) {
        		data = eval(data);
							if(parseInt(data)>0){
								alert("保存成功！");
								parent.closeWin('生成的统计表');
						    	parent.add('生成的统计表','manager/toStkCstStatQuery?rptType=6');
							}else{
								alert("保存失败！");
							}
        			}
    			});
			 }
			 loadCustomerType();
		</script>
	</body>
</html>
