<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>运费模版列表</title>
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">
    <%@include file="/WEB-INF/page/include/source.jsp" %>
    <script type="text/javascript" src="resource/loadDiv.js"></script>
</head>
<body>
<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="false"
       url="${base}/manager/shopTransport/queryListAjax" border="false"
       rownumbers="true" fitColumns="false" pagination="true"
       pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
    <thead>
    <tr>
        <th field="id" checkbox="true"></th>
        <th field="title" width="180" align="center" formatter="formatterTitle">
            模版名称
        </th>
        <th field="isDefault" width="100" align="center" formatter="formatterisDefault">
            是否默认
        </th>
        <th field="_oper" width="300" align="left" formatter="formatterOper">
            操作
        </th>
        <th field="_desc" width="300" align="center" formatter="formatterDesc">
            备注
        </th>
    </tr>
    </thead>
</table>
<div id="tb" style="padding:5px;height:auto">
    <%--分组名称: <input name="name" id="name" style="width:156px;height: 20px;" />
    <a class="easyui-linkbutton" iconCls="icon-search" plain="true" href="javascript:query();">查询</a>--%>
    <a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="${base}/manager/shopTransport/toAddOrEdit">添加模版</a>
    <a class="easyui-linkbutton" iconCls="icon-edit" plain="true" href="javascript:toedit();">修改模版</a>
    <a class="easyui-linkbutton" iconCls="icon-remove" plain="true" href="javascript:todel();">删除模版</a>
    <a class="easyui-linkbutton" iconCls="icon-reload" plain="true" href="javascript:openWindow();">查看所有商品</a>
</div>
<div id="choiceWindow" class="easyui-window" title="选择商品" style="width:1000px;height:800px;"
     minimizable="false" maximizable="false" collapsible="false" closed="true" modal="true">
    <iframe name="windowifrm" id="windowifrm" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
</div>


<script type="text/javascript">

    //查询
    function query() {
        $("#datagrid").datagrid('load', {
            url: "${base}/manager/shopTransport/queryListAjax"
        });
    }

    function openWindow(id) {
        if(!id)id="";
        $("#choiceWindow").window(  {width:700,
            height:600,title:"选择商品"});
        var top = $(".easyui-linkbutton").offset().top + 50;
        var left = $(".easyui-linkbutton").offset().left + 50;

        $('#choiceWindow').window('open').window('resize', {top: top, left: left});
        //$("#choiceWindow").window("open");
        //if(!document.getElementById("windowifrm").src)
        document.getElementById("windowifrm").src="${base}/manager/shopWareTransport/toWareType?transportId="+id;
    }

    //添加或修改
    function edit(row) {
        qwb.ui.Modal.open({
            content: $('#form').html(),
            success: function (container) {
                qwb.ui.init($(container));
                if (row) {
                    qwb.ui.bind($(container), row);
                }
            }
        })
    }


    function openExittsWindow(id,look) {
        if(!look)look="";
        $("#choiceWindow").window(  {width:500,
            height:600,title:"选择商品"});
        var top = $(".easyui-linkbutton").offset().top + 50;
        var left = $(".easyui-linkbutton").offset().left + 50;

        $('#choiceWindow').window('open').window('resize', {top: top, left: left});

        //$("#choiceWindow").window("open");
        //if(!document.getElementById("windowifrm").src)
        document.getElementById("windowifrm").src="${base}/manager/shopWareTransport/shopWareTransportPage?showExists=1&transportId="+id+"&look="+look;
    }

    //修改
    function toedit() {
        var row = $('#datagrid').datagrid('getSelected');
        if (row) {
            update(row.id,row.title);
        } else {
            $.messager.alert('Error', "请选择行");
        }
    }

    //删除
    function todel() {
        var row = $('#datagrid').datagrid('getSelected');
        if (row) {
            if (row.title == '包邮') {
                $.messager.alert('Error', "包邮不可删除");
                return false;
            }
            if($('#datagrid').datagrid('getSelections').length>1){
                $.messager.alert('Error', "删除不能批量操作");
                return false;
            }

            if (confirm("是否要删除运费模版?")) {
                $.ajax({
                    url: "${base}/manager/shopTransport/del",
                    data: "transportId=" + row.id,
                    type: "post",
                    success: function (json) {
                        if (json.state) {
                            //alert("删除成功");
                            query();
                        } else {
                            $.messager.alert('Error', json.message);
                            return;
                        }
                    }
                });
            }
        } else {
            $.messager.alert('Error', "请选择行");
        }
    }

    function formatterisDefault(val, row) {
        var html = "";
        html = "否";
        if (row.isDefault == '1') {
            html = "是";
        }
        return html;
    }

    function formatterOper(val, row) {
        var html ="";
        html+='<button onclick="openWindow('+ row.id +')">添加商品</button>&nbsp;&nbsp;';
        html+='<button onclick="openExittsWindow('+ row.id +')">移除商品</button>&nbsp;&nbsp;';
        html+='<button onclick="openExittsWindow('+ row.id +',1)">查看商品</button>&nbsp;&nbsp;';
        if (row.isDefault != '1') {
            html+='<button onclick="updateDef('+ row.id +')">设为默认</button>&nbsp;&nbsp;';
        }
        return html;
    }

    function formatterDesc(val, row) {
        if (row.isDefault == '1') {
           return "商品未设置运费模版时,统一使用此模版";
        }
    }

    function updateDef(id) {
        $.post("${base}/manager/shopTransport/updateDef", {"transportId": id}, function (data) {
            if (!data.state) $.messager.alert('Error', data.message);
            else query();
        })
    }

    function formatterTitle(val, row) {
        return "<a href='javascript:update(" + row.id + ",\""+val+"\");'>" + val + "</a>";
    }

    function update(id,title) {
        if (title == '包邮') {
            $.messager.alert('Error', "包邮不可修改");
            return false;
        }
        window.location.href = "${base}/manager/shopTransport/toAddOrEdit?transportId=" + id;
    }
</script>
</body>
</html>
