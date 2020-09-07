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
		<script type="text/javascript" src="<%=basePath%>/resource/datagrid-export.js"></script>

	</head>

	<body onload="queryData()">
	<input type="hidden" id="id" value="${id}" />
	<input type="hidden" id="database" value="${database}"/>
		<table id="datagrid"  fit="true" singleSelect="true"
			 title="" iconCls="icon-save" border="false" pagination="true"
			pageSize=20 pageList="[10,20,50,100,200,500,1000]"
			rownumbers="true" fitColumns="false"  toolbar="#tb" showFooter="true" >
			
		</table>
		<div id="tb" style="padding:5px;height:auto">
		   标题: <input name="rptTitle" id="rptTitle" style="width:180px;height: 20px;" value="${title}" />
		   备注: <input name="remarks" id="remark" style="width:320px;height: 20px;" />
	     <span id="paramStr">
	     
	     </span>
	     <a class="easyui-linkbutton" iconCls="icon-print" href="javascript:myexport();">导出</a>         
	               
		</div>
		<%@include file="/WEB-INF/page/export/export.jsp"%>	
		<script type="text/javascript">
		 var autoTitleDatas = eval('${autoTitleJson}');
		 var autoPriceDatas = eval('${autoPriceJson}');
		   //查询
		   //initGrid();
		    var cols = new Array(); 
		   function initGrid()
		   {
			   var col = {
						field: 'id',
						title: '拜访id',
						width: 100,
						align:'center',
						hidden:true
						
										
				};
			   var col = {
						field: 'mid',
						title: '业务id',
						width: 100,
						align:'center',
						hidden:true
						
										
				};
	    	    cols.push(col);
	    	    var col = {
						field: 'cid',
						title: '客户id',
						width: 100,
						align:'center',
						hidden:true
						
										
				};
	    	    var col = {
						field: 'qddate',
						title: '拜访日期',
						width: 80,
						align:'center'
				};
	    	    cols.push(col);
	    	    var col = {
						field: 'memberNm',
						title: '业务员',
						width: 100,
						align:'center'
				};
	    	    cols.push(col);
	    	    var col = {
						field: 'memberMobile',
						title: '手机号',
						width: 100,
						align:'center'
				};
	    	    cols.push(col);
		    
	    	    var col = {
						field: 'branchName',
						title: '部门',
						width: 80,
						align:'center'
				};
	    	    cols.push(col);
	    	    
	    	    var col = {
						field: 'khNm',
						title: '客户',
						width: 120,
						align:'center'
				};
	    	    cols.push(col);
	    	    var col = {
						field: 'qdtpNm',
						title: '客户类型',
						width: 80,
						align:'center'
				};
	    	    cols.push(col);
			
	    	    var col = {
						field: 'khdjNm',
						title: '客户等级',
						width: 80,
						align:'center'
				};
	    	    cols.push(col);
	    	    
	    	    var col = {
						field: 'remo',
						title: '客户备注',
						width: 120,
						align:'center'
				};
	    	    cols.push(col);
	    	    var col = {
						field: 'qdtime',
						title: '签到时间',
						width: 150,
						align:'center'
				};
	    	    cols.push(col);
				
	    	    var col = {
						field: 'ldtime',
						title: '离店时间',
						width: 150,
						align:'center'
				};
	    	    cols.push(col);
			
	    	    var col = {
						field: 'bfsc',
						title: '拜访时长',
						width: 120,
						align:'center'
				};
	    	    cols.push(col);
	    	    
	    	    var col = {
						field: 'imageListStr',
						title: '拜访拍照',
						width: 120,
						align:'center',
						formatter:formatterSt
				};
	    	    cols.push(col);
	    	    
	    	    var col = {
						field: 'oper1',
						title: '销售小结明细',
						width: 100,
						align:'center',
						formatter:formatterSt2
				};
	    	    cols.push(col);
	    	    
	    	    var col = {
						field: 'bcbfzj',
						title: '拜访总结',
						width: 100,
						align:'center'
				};
	    	    cols.push(col);
	    	    
	    	    var col = {
						field: 'dbsx',
						title: '代办事项',
						width: 100,
						align:'center'
				};
	    	    cols.push(col);
	    	    
	    	    var col = {
						field: 'qdaddress',
						title: '签到地址',
						width: 275,
						align:'center'
				};
	    	    cols.push(col);
	    	    
	    	    var col = {
						field: 'khaddress',
						title: '客户地址',
						width: 275,
						align:'center'
				};
	    	    cols.push(col);
			
	    	    var col = {
						field: 'linkman',
						title: '负责人',
						width: 120,
						align:'center'
				};
	    	    cols.push(col);
			
	    	    var col = {
						field: 'tel',
						title: '负责人电话',
						width: 120,
						align:'center'
				};
	    	    cols.push(col);
	    	    
	    	    var col = {
						field: 'mobile',
						title: '负责人手机',
						width: 120,
						align:'center'
				};
	    	    cols.push(col);    	    
			
	    	    
	    	    

				$('#datagrid').datagrid({
 	    		columns:[
 	    		  		cols
 	    		  	]
						}
 	    );
				
		   }
		   var merCols = new Array();
		   
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
        				initGrid();
        				//var rows = JSON.stringify(obj.rows);
        				$('#datagrid').datagrid('loadData',{"total" : 1,"rows" : obj.rows});   
				
        		
        		}
        	}
    		});
   	   		//document.getElementById("saveHtml").value=$("#saveHtmlDiv").formhtml();
		   }
		   
		   function formatterSt(v,row){		    	
		        var hl='<table>';
		        hl +='<tr>';
		        for(var i=0;i<row.listpic.length;i++){
		           if((i+1)%4==0){
		              hl +='<td>&nbsp;&nbsp;&nbsp;<a href="javascript:toBigPic(\''+row.listpic[i].pic+'\');"><img style="width: 85px;" src="${base}upload/'+row.listpic[i].picMin+'"/></a></br>&nbsp;&nbsp;&nbsp;'+row.listpic[i].nm+'</td>';
		              hl +='</tr>';
		              hl +='<tr>';
		           }else{
		             hl +='<td>&nbsp;&nbsp;&nbsp;<a href="javascript:toBigPic(\''+row.listpic[i].pic+'\');"><img style="width: 85px;" src="${base}upload/'+row.listpic[i].picMin+'"/></a></br>&nbsp;&nbsp;&nbsp;'+row.listpic[i].nm+'</td>';
		           }
		        }
		        hl +='</tr>';
 			    hl +='</table>';
 			    return hl;
			}
		   
		   function formatterSt2(v,row){
				return '<a class="easyui-linkbutton" iconCls="icon-search" plain="true" href="javascript:todetail2(\''+row.qddate+'/'+row.memberNm+'/'+row.khNm+'\','+row.mid+','+row.cid+',\''+row.qddate+'\');">查看</a>';
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

			    }
			 
			 function myexport(){
				 //$('#datagrid').datagrid('toExcel','dg.xls');
				 var id= $("#id").val();
				 var database = $("#database").val();
					exportData('stkCheckService','queryRptDataRptMain1','com.qweib.cloud.core.domain.SysBfKhXx',"{id:"+id+",database:'"+database+"'}","业务员拜访记录");
	  			} 
		</script>
	</body>
</html>
