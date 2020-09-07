<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>商品信息导入</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <%--2右边：表格start--%>
        <div class="layui-col-md12">
            <%--表格：start--%>
            <div class="layui-card">
                <div class="layui-card-body full">
                    <div id="grid" uglcw-role="grid"
                         uglcw-options="
                            responsive:['.header',40],
						    toolbar: kendo.template($('#toolbar').html()),
							id:'id',
							pageable: true,
                    		url: '${base}manager/sysWareImportMain/page',
                    		criteria: '.query',
                    		dblclick: function(row){
                                    uglcw.ui.openTab(row.title, '${base}manager/sysWareImportMain/toWareType?mastId='+row.id);
                            },
                    	">
                        <div data-field="title" uglcw-options="width:100">标题</div>
                        <div data-field="operName" uglcw-options="width:100">操作人</div>
                    </div>
                </div>
            </div>
            <%--表格：end--%>
        </div>
        <%--2右边：表格end--%>
    </div>
</div>

<script type="text/x-kendo-template" id="toolbar">
    <a role="button" class="k-button k-button-icontext" href="javascript:download();">
        <span class="k-icon k-i-download"></span>下载模板
    </a>
    <a role="button" class="k-button k-button-icontext" href="javascript:showUpload();">
        <span class="k-icon k-i-upload"></span>上传数据
    </a>
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        //ui:初始化
        uglcw.ui.init();
        uglcw.ui.loaded();
    })

    //-----------------------------------------------------------------------------------------
    //下载
    function download() {
        uglcw.ui.confirm('是否下载商品模版？', function () {
            window.location.href = '${base}manager/toWareImportTemplate'
        })
    }
    //上传
    function showUpload() {
        uglcw.ui.Modal.showUpload({
            url: '${base}manager/toUpWareTemplateData',
            field: 'upFile',
            error: function (e) {
                uglcw.ui.notice({
                    type: 'error',
                    title:'上传失败',
                    desc: e.XMLHttpRequest.responseText
                });
                console.log('error------------', arguments)
            },
            complete: function () {
                console.log('complete', arguments);
            },
            success: function (e) {
                if (e.response == '1') {
                    uglcw.ui.success('导入成功');
                    uglcw.ui.get('#grid').reload();
                } else {
                    uglcw.ui.error(e.response);
                }
            }
        })
    }

</script>
</body>
</html>
