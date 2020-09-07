<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<div id="exportwin" class="easyui-window" title="导出向导" style="width:600px;height:400px" data-options="iconCls:'icon-print',modal:true,collapsible:false,minimizable:false,maximizable:false" closed="true">
	<div class="easyui-layout" data-options="fit:true">   
        <div data-options="region:'center'">   
                <table id="exportdatagrid" class="easyui-datagrid" fit="true" iconCls="icon-save" border="false" style="width: 580px;height: 300px;"
					rownumbers="true" fitColumns="true" title="选择要导出的列">
					<thead>
							<tr>
								<th field="ck" checkbox="true"></th>
								<th field="columnkey" width="50" align="center" hidden='true'>
									columnkey
								</th>
								<th field="columnname" width="50" align="center" >
									列名称
								</th>
							</tr>
					</thead>
				</table>  
        </div>   
        <div data-options="region:'south',split:true" style="height:45px;">
        	<div id="tb1" style="height:auto;vertical-align: bottom;padding-left: 30px;padding-right: 5px" align="right">
				<label>选择导出的格式:</label> 
				<select name="exportstyle" id="exportstyle">
					<option value="1">EXCEL</option>
					<option value="2">文本</option>
				</select>
				&nbsp;&nbsp;
				<label>选择导出的内容:</label> 
				<select name="exportcontent" id="exportcontent">
					<option value="1">只导出本页</option>
					<option value="2">导出全部</option>
				</select>
				&nbsp;&nbsp;
				<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:start();">开始导出</a>
			</div>
        </div>   
    </div> 

	
</div>  

<script type="text/javascript">

	function trim(s){
	     return s.replace(/(^\s*)|(\s*$)/g,'');
	}
	
	var pclassname;
  	var pmethod;
  	var pbean;
  	var pcondition;
  	var pdiscribe;
  	
	function CustomData(key,name){
		this.name = name;
		this.key = key;
	}
	
	CustomData.prototype.toString = function(){
		return "{key:'"+this.key+"',name:'"+this.name+"'}";
	}

	function exportData(classname,method,bean,condition,discribe){
		pclassname = classname;
		pmethod = method;
		pbean = bean;
		pcondition = condition;
		pdiscribe = discribe;
	
		$("#exportwin").window('open');
		var columns = $('#datagrid').datagrid('getColumnFields');
		var r = "{total:"+columns.length+",rows:[";
		var str = '';
		for(var i=0;i<columns.length;i++){
			var column =  $('#datagrid').datagrid('getColumnOption',columns[i]);
			if(!column.hidden&&column.field!='opt'&&column.field!="ck"){
				str+="{columnkey:'"+column.field+"',columnname:'"+trim(column.title)+"'},";
			}
		}
		
		if(str!=''){
			str = str.substring(0,str.length-1);
		}
		r=r+str+"]}";
		var json = eval("("+r+")");
		$('#exportdatagrid').datagrid('loadData',json);
		
		$('#exportdatagrid').datagrid('selectAll');
	}
	
	function start(){
		var options = $('#datagrid').datagrid('getPager').data("pagination").options;
		var curr = options.pageNumber;
		var total = options.total;
		var pageSize = options.pageSize;
		var columns = $('#exportdatagrid').datagrid('getSelections');
		var columnary = new Array();
		for(var i=0;i<columns.length;i++){
			var d = new CustomData(columns[i].columnkey,columns[i].columnname);
			columnary.push(d.toString());
		}
		
		if(columnary.length==0){
			showMsg('请选择要导出的列');
		}
	
		window.location.href="${base}/manager/export?classname="+pclassname+"&method="+pmethod+"&condition="+encodeURIComponent(pcondition)+"&bean="+pbean+"&discribe="+encodeURIComponent(pdiscribe)+"&exportstyle="+$('#exportstyle').val()
		+"&exportcontent="+$('#exportcontent').val()+"&pageSize="+pageSize+"&pageNumber="+curr+"&total="+total+"&data="+encodeURIComponent("["+columnary.join(",")+"]");
		/**$.post("manager/export",
			{ 
			  classname: pclassname,
			  method: pmethod,
			  bean:pbean,
			  condition:pcondition,
			  discribe:pdiscribe,
			  exportstyle: $('#exportstyle').val(),
			  exportcontent: $('#exportcontent').val(),
			  pageSize:pageSize,
			  pageNumber:curr,
			  total:total,
			  data:"["+columnary.join(",")+']'
			}
	   );**/
	}
	
</script>
