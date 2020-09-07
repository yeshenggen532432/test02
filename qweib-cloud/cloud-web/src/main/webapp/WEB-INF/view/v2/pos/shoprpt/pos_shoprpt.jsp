<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>各门店报表</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="uglcw-layout-container">
        <div class="uglcw-layout-fixed" style="width: 200px;">
            <div class="layui-card">
                <div class="layui-card-header">
                    报表列表
                </div>
                <div class="layui-card-body">
                    <div id="tree" uglcw-role="tree"
                         uglcw-options="
                        url:'${base}manager/pos/PosShopRptFuncs',
                        expandable: function(){
                            return true;
                        },
                        loadFilter:function(response){
                                    $(response).each(function(index,item){
                                        if(item.text=='根节点'){
                                         item.text='报表列表';
                                        }
                                    })
                                    return response;
                                },
                        select: function(e){
                            var node = this.dataItem(e.node)
                            console.log(node);
                            toShowRpt(node);
                            <%--uglcw.ui.get('#waretypeId').value(node.id);--%>
                            <%--uglcw.ui.get('#waretypeNm').value(node.text);--%>
                        }
                    "
                    >
                    </div>
                </div>
            </div>
        </div>
        <div class="uglcw-layout-content" style="padding-left: 5px;padding-right: 5px;">
            <iframe src="${base}manager/pos/toPosShopRptByName" name="rptIframe" id="rptIframe" frameborder="0"

                    marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
        </div>
    </div>
</div>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        uglcw.ui.init();
        var treeHeight = $(window).height() - $('').height() - 100;
        var iframeHeight = $(window).height();
        $('#tree').height(treeHeight + "px");
        $('#rptIframe').height(iframeHeight - 35 + "px");
        uglcw.ui.loaded();
    })

    //点击商品分类树查询
    function toShowRpt(node) {
        var funcName = node.text;
        // var parent =$('#leftTree').tree('getParent', node.target);
        var id = node.id, shopNo = '';
        var parent = node.parentNode();
        if (parent) {
            shopNo = parent.shopNo || '';
        }

        var path = "${base}manager/pos/toPosShopRptByName?rptName=" + funcName + "&parentId=" + id + "&shopNo=" + shopNo;
        document.getElementById("rptIframe").src = path;
    }

</script>
</body>
</html>
