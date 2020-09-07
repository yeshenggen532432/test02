<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>生产产品列表</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<%@include file="/WEB-INF/page/include/source.jsp"%>
	<script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
	<script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
</head>
<body>
<div id="tb">
		产品名称:
		<input name="relaWareNm" id="relaWareNm" style="width:120px;height: 20px;" />
		<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:query();">查询</a>
	<a class="easyui-linkbutton" iconCls="icon-edit" href="javascript:add();">新增配方</a>
	<%--<a class="easyui-linkbutton" iconCls="icon-edit" href="javascript:edit(0);">调整所有原料配方</a>--%>
	<%--<a class="easyui-linkbutton" iconCls="icon-edit" href="javascript:showAll();">配方总列表</a>--%>
	<a class="easyui-linkbutton" iconCls="icon-edit" href="javascript:quick();">快速领料</a>
	<a class="easyui-linkbutton" iconCls="icon-edit" href="javascript:query();">刷新</a>
</div>


<table id="datagrid" class="easyui-datagrid" toolbar="#tb" style="width:700px;">
	<thead>
	</thead>
</table>
<div id="quickDialog" closed="true" class="easyui-dialog" style="width:370px; height:400px;" title="快速领料"
	 data-options="
				buttons: [{
					text:'确定',
					iconCls:'icon-ok',
					handler:function(){
						toSaveQuick();
					}
				},{
					text:'取消',
					handler:function(){
						$('#quickDialog').dialog('close');
					}
				}]
			"
>
	<iframe name="quickDialogfrm" id="quickDialogfrm" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
	<div id="choiceWindow" class="easyui-window" style="width:800px;height:400px;"
		 minimizable="false" maximizable="false" collapsible="false" closed="true" modal="true">
		<iframe name="windowifrm" id="windowifrm" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
	</div>

	<div id="showReadersWin" class="easyui-window" style="width:400px;height:300px;"
		 minimizable="false" maximizable="false" collapsible="false" closed="true" modal="true">
		<div id="showReaders">

		</div>
	</div>


</div>
<script type="text/javascript">
	function initGrid()
	{
		var cols = new Array();
		var col = {
			field : 'ck',
			checkbox : true
		};
		cols.push(col);
		var col = {
			field: 'relaWareId',
			title: 'relaWareId',
			width: 100,
			align:'center',
			hidden:'true'
		};
		cols.push(col);

		var col = {
			field: 'relaWareNm',
			title: '生产产品',
			width: 100,
			align:'center'

		};
		cols.push(col);

		var col = {
			field: '_operate',
			title: '操作',
			width: 450,
			align:'center',
			formatter:formatterOper

		};
		cols.push(col);

		$('#datagrid').datagrid({
			url:"manager/stkProduceWareTpl/list",
			queryParams:{

			},
			columns:[
				cols
			]}
		);
	}


	function query() {
		$("#datagrid").datagrid('load',{
			url:"manager/stkProduceWareTpl/list",
			relaWareNm:$("#relaWareNm").val()
		});
	}
	
	function edit(id,name)
	{
		if(id==0){
			window.parent.close("调整所有原料配方");
			window.parent.add("调整所有原料配方","manager/stkProduceWareTpl/edit");
		}else{
			window.parent.close(name+"_编辑配方");
			window.parent.add(name+"_编辑配方","manager/stkProduceWareTpl/edit?relaWareId="+id);
		}

	}


	function copy(id,name)
	{
			if(!window.confirm("是否创建新配方产品！")){
				return;
			}
			window.parent.close("新增配方");
			window.parent.add("新增配方","manager/stkProduceWareTpl/copy?relaWareId="+id);

	}

	function add()
	{
		window.parent.close("新增配方");
		window.parent.add("新增配方","manager/stkProduceWareTpl/add");
	}

	function quick(){
		var billName="快速领料";
		parent.closeWin(billName);
		var ids = "";
		var rows = $("#datagrid").datagrid("getSelections");
		for (var i = 0; i < rows.length; i++) {
			if (ids != "") {
				ids += ",";
			}
			ids += rows[i].relaWareId;
		}
		parent.add(billName,'<%=basePath%>manager/stkProduceWareTpl/mainWareList?relaWareIds='+ids);
	}

	function formatterOper(val,row){
		var url = "<a href='javascript:;;' onclick='showWareItems(\""+row.relaWareId+"\",\""+row.relaWareNm+"\")'>查看配方<a/>";
			url +="&nbsp;&nbsp;|<a href='javascript:;;' onclick='edit(\""+row.relaWareId+"\",\""+row.relaWareNm+"\")'>修改配方<a/>";
			url +="&nbsp;&nbsp;|<a href='javascript:;;' onclick='deleteRelaWare(\""+row.relaWareId+"\",\""+row.relaWareNm+"\")'>删除配方<a/>";
			url +="&nbsp;&nbsp;|<a href='javascript:;;' onclick='selectMember(\""+row.relaWareId+"\")'>添加阅读人员<a/>";
			if(row.readersIds!=""){
				url +="&nbsp;&nbsp;|<a href='javascript:;;' onclick='showMember(\""+row.relaWareId+"\",\""+row.readersIds+"\",\""+row.readersNms+"\")'>查看可阅读人员<a/>";
			}

		url +="&nbsp;&nbsp;|<a href='javascript:;;' onclick='copy(\""+row.relaWareId+"\",\""+row.relaWareNm+"\")'>复制配方<a/>";
		return url;
	}

	function showWareItems(id,name){
		window.parent.close(name+"_配方");
		window.parent.add(name+"_配方","manager/stkProduceWareTpl/toListItems?relaWareId="+id);
	}

	function showAll(){
		window.parent.close("总配方列表");
		window.parent.add("总配方列表","manager/stkProduceWareTpl/toListItems");
	}
	var relaWareId="";
	function showMember(relaWareId,readerIds,readerNms){
		if(readerIds!=""){
			var ids = readerIds.split(",");
            var nms = readerNms.split(",");
            var html = "";
            $("#showReaders").html("");
            html="<table border='1' width='300px'>";
            for(var i=0;i<ids.length;i++){
				var tr="<tr><td>"+nms[i]+"</td><td><a onclick='deleteReader(\""+relaWareId+"\",\""+ids[i]+"\",\""+nms[i]+"\")'>删除</a></td></tr>";
				html +=tr;
			}
            html+="</table>";
			$("#showReaders").html(html);
			$("#showReadersWin").window({
				title:"查看人员",
				top:getScrollTop()+50
			});
			$("#showReadersWin").window('open');
		}
	}

	function deleteRelaWare(relaWareId) {
		if(!window.confirm("是否确定删除该配方！")){
			return;
		}
		$.ajax({
			url: "<%=basePath %>/manager/stkProduceWareTpl/deleteByRelaId",
			type: "POST",
			data : {"relaWareId":relaWareId},
			dataType: 'json',
			async : false,
			success: function (json) {
				if(json.state){
					query();
				}else{
					alert(json.msg);
				}
			}
		});
	}

	function deleteReader(relaWareId,id,name) {
		if(!window.confirm("是否确定删除该人员！")){
			return;
		}
		$.ajax({
			url: "<%=basePath %>/manager/stkProduceWareTpl/deleteReaders",
			type: "POST",
			data : {"relaWareId":relaWareId,"readersIds":id,"readersNms":name},
			dataType: 'json',
			async : false,
			success: function (json) {
				if(json.state){
					refresh();
				}else{
					alert(json.msg);
				}
				$("#showReadersWin").window('close');
			}
		});
	}

	function selectMember(id){
		relaWareId = id;
		document.getElementById("windowifrm").src="manager/selectmember";
		$("#choiceWindow").window({
			title:"选择人员",
			top:getScrollTop()+50
		});
		$("#choiceWindow").window('open');
	}

	function setMember(memberId,memberNm){
		$.ajax({
			url: "<%=basePath %>/manager/stkProduceWareTpl/updateReader",
			type: "POST",
			data : {"relaWareId":relaWareId,"readersIds":memberId,"readersNms":memberNm},
			dataType: 'json',
			async : false,
			success: function (json) {
				if(json.state){
					refresh();
				}else{
					alert(json.msg);
				}
				$("#choiceWindow").window('close');
			}
		});
	}
	initGrid();
</script>
</body>
</html>
