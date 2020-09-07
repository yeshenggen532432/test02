<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>商品运费设置</title>
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">
    <%@include file="/WEB-INF/page/include/source.jsp" %>
    <script type="text/javascript" src="resource/loadDiv.js"></script>
</head>
<body>
<%--备注：class="easyui-datagrid" 默认会请求一次数据--%>
<%--url="manager/shopWare/page?wtype=${wtype}&groupIds=${groupIds}" class="easyui-datagrid"--%>
<%--<input type="hidden" name="wtype" id="wtype" value="${wareType}"/>--%>
<table id="datagrid" fit="true" singleSelect="false" border="false"
       url="${base}/manager/shopWareTransport/shopSelectWareData?showExists=${showExists}&transportId=${transportId}&waretype=${waretype}"
       rownumbers="true" fitColumns="false" pagination="true"
       pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
    <thead>
    </thead>
</table>
<div id="tb" style="padding:5px;height:auto">
    商品名称: <input name="wareNm" id="wareNm" style="width:156px;height: 20px;" onkeydown="if(event.keyCode==13)queryWare();"/>
    <input type="hidden" name="waretype" id="waretype" value="${waretype}"/>
    <a class="easyui-linkbutton" iconCls="icon-search" plain="true" href="javascript:queryWare();">查询</a>&nbsp;&nbsp;
    <c:if test="${transportId==null}">
        <a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:updateTransportShow();">商品设置模版</a>&nbsp;&nbsp;
        <a class="easyui-linkbutton" iconCls="icon-delete" plain="true" href="javascript:updateTransport(1);">清除模版</a>
    </c:if>
    <c:if test="${transportId !=null}">
        <c:if test="${showExists ==null}">
        <a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:updateTransport();">加入模版</a>
        </c:if>
        <c:if test="${showExists !=null && look==null}">
            <a class="easyui-linkbutton" iconCls="icon-delete" plain="true" href="javascript:updateTransport(1);">移出</a>
        </c:if>
    </c:if>
</div>
<c:if test="${transportId==null}">
    <div id="transportTemp" closed="true" class="easyui-dialog" title="设置商品运费模版" style="width:250px;height:130px;padding:10px;"
         data-options="
				iconCls: 'icon-save',
				buttons: [{
					text:'确定',
					iconCls:'icon-ok',
					handler:function(){
						updateTransport();
					}
				},{
					text:'取消',
					handler:function(){
						$('#dlg').dialog('close');
					}
				}]
			">
        <input class="easyui-combobox" style="width: 200px;height:20px"
               name="wareGroupComb" ,
               id="wareGroupComb"
               data-options="
					url:'${base}/manager/shopTransport/queryListAjax?flag=1',
					method:'post',
					valueField:'id',
					textField:'title',
					multiple:false,
					panelHeight:'auto'
			">
    </div>
</c:if>
</div>

<script type="text/javascript">
    $(function () {
        initGrid();
    })

    function initGrid() {
        var cols = new Array();
        var col = {
            field: 'wareId',
            title: 'id',
            width: 50,
            align: 'center',
            checkbox: 'true'
        };
        cols.push(col);
        /*var col = {
            field: 'waretypeNm',
            title: '所属分类',
            width: 80,
            align:'center',
        };
        cols.push(col);*/
        var col = {
            field: 'wareNm',
            title: '商品名称',
            width: 200,
            align: 'center'
        };
        cols.push(col);
        var col = {
            field: 'wareGg',
            title: '规格',
            width: 150,
            align: 'center'
        };
        cols.push(col);
       /* var col = {
            field: 'wareDj',
            title: '批发价',
            width: 80,
            align: 'center'
        };
        cols.push(col);
        var col = {
            field: 'lsPrice',
            title: '原价',
            width: 80,
            align: 'center'
        };
        cols.push(col);*/
        <c:if test="${transportId==null}">
        var col = {
            field: 'transportName',
            title: '运费模版',
            width: 100,
            align: 'center'
        };
        cols.push(col);
        </c:if>
        $('#datagrid').datagrid({
                url: "${base}/manager/shopWareTransport/shopSelectWareData?showExists=${showExists}&transportId=${transportId}&waretype=${waretype}",
                columns: [
                    cols
                ]
            }
        );
    }

    //查询
    function queryWare() {
        $("#datagrid").datagrid('load', {
            url: "${base}/manager/shopWareTransport/shopSelectWareData?showExists=${showExists}&transportId=${transportId}",
            wareNm: $("#wareNm").val(),
        });
    }

    //弹出商品模版
    function updateTransportShow() {
        var top = $(".easyui-linkbutton").offset().top + 50;
        var left = $(".easyui-linkbutton").offset().left + 50;

        $('#transportTemp').window('open').window('resize', {top: top, left: left});
        //$('#wareGroupComb').combobox('setValues', []);
        //$('#dlg').dialog('open');
    }

    //更新运费模版
    function updateTransport(del) {
        var rows = $('#datagrid').datagrid('getSelections');
        var ids = "";
        for (var i = 0; i < rows.length; i++) {
            if (ids != '') {
                ids = ids + ",";
            }
            ids = ids + rows[i].wareId;
        }
        if (ids == "") {
            $.messager.alert('Warning', '请选择商品！');
            return;
        }

<c:if test="${transportId==null}">
        var transportId = $("#wareGroupComb").combobox("getValue");
        if (!transportId && !del) {
            $.messager.alert('Warning', '请选择模版！');
            return;
        }
        </c:if>
<c:if test="${transportId!=null}">
        var transportId =${transportId};
        </c:if>

        //var text='是否确定更改商品运费模版吗?';
        var url = "manager/shopWareTransport/saveByIds";
        if (del) {
            //	text='是否确定清除商品运费模版吗?'
            url = "manager/shopWareTransport/deletes";
        }

        //$.messager.confirm('Confirm',text,function(r){
        //	if (r){
        $.ajax({
            url: url,
            data: {"ids": ids, "transportId": transportId},
            type: "post",
            success: function (data) {
                if (data.state) {
                    //alert("更新成功");
                    //$.messager.alert('消息','更新成功!','info');
                    $('#transportTemp').dialog('close');
                    queryWare();
                } else {
                    $.messager.alert('Error', '商品类别更新失败！');
                    return;
                }
            }
        });
        //	}
        //});
    }
</script>
</body>
</html>
