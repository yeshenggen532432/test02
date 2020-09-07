<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>企微宝</title>

    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">
    <%@include file="/WEB-INF/page/include/source.jsp"%>
</head>

<body class="easyui-layout">
<div data-options="region:'west',split:true,title:'报表列表'"
     style="width:150px;padding-top: 5px;">
    <ul id="leftTree" class="easyui-tree"
        data-options="url:'manager/pos/PosShopRptFuncs',animate:true,dnd:true,onClick: function(node){
					toShowRpt(node);
				},onDblClick:function(node){
					$(this).tree('toggle', node.target);
				}">
    </ul>
</div>
<div id="wareTypeDiv" data-options="region:'center'" title="门店报表信息">
    <iframe src="manager/pos/toPosShopRptByName" name="rptfrm" id="rptfrm" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
</div>
<script type="text/javascript">
    //点击商品分类树查询
    function toShowRpt(node){
        //alert(node.text);
        var funcName = node.text;
        var parent =$('#leftTree').tree('getParent', node.target);

        var path = "${base}/manager/pos/toPosShopRptByName?rptName="+funcName + "&parentId=" + parent.id;
        document.getElementById("rptfrm").src= path;
    }
</script>
</body>
</html>
