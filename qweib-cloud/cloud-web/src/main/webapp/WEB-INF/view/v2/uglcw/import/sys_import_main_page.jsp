<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>${typeBean.name}导入</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }

        #other-text {
            color: black;
            background-color: rgba(0, 123, 255, .35);
            font-weight: 800;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-card master">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options="
                            responsive:['.header',40],
						    toolbar: kendo.template($('#toolbar').html()),
							id:'id',
							pageable: true,
                    		url: '${base}manager/sysImportTemp/mainPage?type=${sysImportTemp.type}',
                    		criteria: '.query',
                    		dblclick: function(row){
                    		    var title='';
                    		    if(row.title.indexOf('导入')!=-1){
                                    title=row.title;
                                }else{
                                    title=(row.status?' 已导入 ':' 未导入 ')+row.title;
                                }
                                uglcw.ui.openTab(title, '${base}manager/sysImportTemp/toEdit?type=${sysImportTemp.type}&id='+row.id+'&importStatus='+row.status);
                            },
                    	">
                <div data-field="title" uglcw-options="width:300,template:uglcw.util.template($('#titleTempl').html())">标题
                </div>
                <div data-field="operName" uglcw-options="width:100">操作人</div>
            </div>
        </div>
    </div>
</div>

<%--商品名称--%>
<script id="titleTempl" type="text/x-uglcw-template">
    #if(data.title.indexOf('导入')!=-1){#
    #=data.title#
    #}else{#
    #=data.saveDate+(data.status?' 已导入 ':' 未导入 ')+data.title#
    #}#
</script>

<script type="text/x-kendo-template" id="toolbar">
    <c:if test="${!empty typeBean.otherToolBarMap}">
        <c:forEach items="${typeBean.otherToolBarMap}" var="map">
            <c:if test="${map.key =='双单位模版' || map.key =='大单位模版'}">
                <a role="button" class="k-button k-button-icontext" id="other-text" href="${base}${map.value}">&nbsp;&nbsp;&nbsp;${map.key}&nbsp;&nbsp;&nbsp;</a>
            </c:if>
        </c:forEach>
    </c:if>
    <c:if test="${typeBean.downExcelModelUrl !=null}">
        <c:set var="otherText" value=""/>
        <c:choose>
            <c:when test="${sysImportTemp.type ==1}"><c:set var="otherText" value="双"/></c:when>
            <c:when test="${sysImportTemp.type ==11}"><c:set var="otherText" value="单"/></c:when>
            <c:otherwise></c:otherwise>
        </c:choose>
        <a role="button" class="k-button k-button-icontext" href="javascript:download();">
            <span class="k-icon k-i-download"></span>下载EXCEL<c:if test="${! empty otherText}"><span
                id="other-text">${otherText}</span></c:if>模板
        </a>
        <a role="button" class="k-button k-button-icontext" href="javascript:showUpload();">
            <span class="k-icon k-i-upload"></span>上传EXCEL<c:if test="${! empty otherText}"><span
                id="other-text">${otherText}</span></c:if>模板
        </a>
    </c:if>
    <a role="button" class="k-button k-button-icontext"
       href="javascript:toCreate()">
        <span class="k-icon k-i-track-changes-accept"></span>新增空${typeBean.name}在线编辑
    </a>
    <c:if test="${typeBean.downDataToImportTempUrl !=null}">
        <c:set var="downDataFun" value="toDownDataToImportTemp('${typeBean.downDataToImportTempUrl}');"/>
        <c:set var="downDataText" value="全部"/>
        <c:if test="${typeBean.downDataToImportTempFun !=null}">
            <c:set var="downDataFun"
                   value="${typeBean.downDataToImportTempFun}('${typeBean.downDataToImportTempUrl}');"/>
            <c:set var="downDataText" value=""/>
        </c:if>
        <a role="button" class="k-button k-button-icontext" href="javascript:${downDataFun}">
            <span class="k-icon k-i-download"></span>导出${downDataText}${typeBean.name}在线编辑
        </a>
    </c:if>

    <c:if test="${typeBean.downDataToExcelUrl !=null}">
        <c:set var="downDataFun" value="toDownDataToImportTemp('${typeBean.downDataToExcelUrl}',1);"/>
        <c:set var="downDataText" value="全部"/>
        <c:if test="${typeBean.downDataToImportTempFun !=null}">
            <c:set var="downDataFun"
                   value="${typeBean.downDataToImportTempFun}('${typeBean.downDataToExcelUrl}',1);"/>
            <c:set var="downDataText" value=""/>
        </c:if>
        <a role="button" class="k-button k-button-icontext" href="javascript:${downDataFun}">
            <span class="k-icon k-i-download"></span>导出${downDataText}${typeBean.name}EXCEL
        </a>
    </c:if>

    <c:if test="${!empty typeBean.otherToolBarMap}">
        <c:forEach items="${typeBean.otherToolBarMap}" var="map">
            <c:if test="${map.key !='双单位模版' && map.key !='大单位模版'}">
                <a role="button" class="k-button k-button-icontext" href="${base}${map.value}">
                    <span class="k-icon k-i-download"></span>${map.key}
                </a>
            </c:if>
        </c:forEach>
    </c:if>
    <c:if test="${typeBean.oldMainPageUrl !=null}">
        <a role="button" class="k-button k-button-icontext" style="color: red;"
           href="javascript:uglcw.ui.openTab('旧版历史${typeBean.name}导入','${base}${typeBean.oldMainPageUrl}');">
            <span class="k-icon k-i-upload"></span>旧版历史导入
        </a>
    </c:if>
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>

<script id="product-template" type="text/uglcw-template">
    <div class="uglcw-selector-container">
        <div class="layui-card header">
            <div class="layui-card-body">
                <ul class="uglcw-query form-horizontal">
                    <c:if test="${sysImportTemp.type==5}">
                        <li>
                            <input uglcw-model="customerName" id="customerName" uglcw-role="textbox" placeholder="客户名称">
                        </li>
                    </c:if>
                    <li>
                        <input type="hidden" uglcw-model="waretype" id="waretype" uglcw-role="textbox">
                        <input type="hidden" uglcw-model="isType" id="isType" uglcw-role="textbox">
                        <div>
                            <input uglcw-role="gridselector" placeholder="选择分类" uglcw-options="click: function(){
                                    selectType();
                                }" uglcw-model="wareTypeNm" id="wareTypeNm"/>
                        </div>
                    </li>
                    <li>
                        <input uglcw-model="wareNm" id="wareNm" uglcw-role="textbox" placeholder="商品名称">
                    </li>
                </ul>
            </div>
        </div>
    </div>
</script>

<script id="product-type-selector-template" type="text/uglcw-template">
    <div class="uglcw-selector-container">
        <div style="line-height: 30px">
            已选:
            <button style="display: none;" id="_type_name" class="k-button k-info ghost"></button>
        </div>
        <div style="padding: 2px;height: 344px;">
            <input type="hidden" uglcw-role="textbox" id="_type_id">
            <input type="hidden" uglcw-role="textbox" id="_isType">
            <input type="hidden" uglcw-role="textbox" id="_upWaretypeNm">
            <ul uglcw-role="accordion">
                <li>
                    <span>库存商品类</span>
                    <div>
                        <div uglcw-role="tree"
                             uglcw-options="
                                url:'${base}manager/syswaretypes?isType=0',
                                id:'id',
                                expandable:function(node){
                                    return node.id == '0';
                                },
                                loadFilter:function(response){
                                $(response).each(function(index,item){
                                if(item.text=='根节点'){
                                    item.text='库存商品类'
                                }
                                })
                                return response;
                                },
                                select: function(e){
                                    var node = this.dataItem(e.node);
                                    uglcw.ui.get('#_type_id').value(node.id);
                                    uglcw.ui.get('#_isType').value(0);
                                    uglcw.ui.get('#_upWaretypeNm').value('库存商品类');
                                    $('#_type_name').text(node.text);
                                    $('#_type_name').show();
                                }
                            ">
                        </div>
                    </div>
                </li>
                <li>
                    <span>原辅材料类</span>
                    <div uglcw-role="tree"
                         uglcw-options="
                                url:'${base}manager/syswaretypes?isType=1',
                                id:'id',
                                expandable:function(node){
                                    return node.id == '0';
                                },
                                loadFilter:function(response){
                                $(response).each(function(index,item){
                                if(item.text=='根节点'){
                                item.text='原辅材料类'
                                }
                                })
                                return response;
                                },
                                select: function(e){
                                    var node = this.dataItem(e.node);
                                    uglcw.ui.get('#_type_id').value(node.id);
                                    uglcw.ui.get('#_isType').value(1);
                                    uglcw.ui.get('#_upWaretypeNm').value('原辅材料类');
                                    $('#_type_name').text(node.text);
                                    $('#_type_name').show();
                                }
                            ">
                    </div>
                </li>
                <li>
                    <span>低值易耗品类</span>
                    <div uglcw-role="tree"
                         uglcw-options="
                                url:'${base}manager/syswaretypes?isType=2',
                                id:'id',
                                expandable:function(node){
                                    return node.id == '0';
                                },
                                loadFilter:function(response){
                                $(response).each(function(index,item){
                                if(item.text=='根节点'){
                                item.text='低值易耗品类'
                                }
                                })
                                return response;
                                },
                                select: function(e){
                                    var node = this.dataItem(e.node);
                                    uglcw.ui.get('#_type_id').value(node.id);
                                    uglcw.ui.get('#_isType').value(2);
                                    uglcw.ui.get('#_upWaretypeNm').value('低值易耗品类');
                                    $('#_type_name').text(node.text);
                                    $('#_type_name').show();
                                }
                            ">
                    </div>
                </li>
                <li>
                    <span>固定资产类</span>
                    <div uglcw-role="tree"
                         uglcw-options="
                                url:'${base}manager/syswaretypes?isType=3',
                                id:'id',
                                expandable:function(node){
                                    return node.id == '0';
                                },
                                loadFilter:function(response){
                                $(response).each(function(index,item){
                                if(item.text=='根节点'){
                                item.text='固定资产类'
                                }
                                })
                                return response;
                                },
                                select: function(e){
                                    var node = this.dataItem(e.node);
                                    uglcw.ui.get('#_type_id').value(node.id);
                                    uglcw.ui.get('#_isType').value(3);
                                    uglcw.ui.get('#_upWaretypeNm').value('固定资产类');
                                    $('#_type_name').text(node.text);
                                    $('#_type_name').show();

                                }
                            ">
                    </div>
                </li>
            </ul>
        </div>
    </div>
</script>

<script>
    var toUpExcel = '${base}manager/sysImportTemp/toUpExcel';
    <c:if test="${typeBean.toUpExcelUrl !=null}">
    toUpExcel = '${base}${typeBean.toUpExcelUrl}';
    </c:if>
    $(function () {
        //ui:初始化
        uglcw.ui.init();

        uglcw.ui.loaded();
    })

    function toCreate() {
        var url = '${base}manager/sysImportTemp/toEdit';
        <c:if test="${!empty typeBean.toCreateEmptyUrl}">
        url = '${bean}${typeBean.toCreateEmptyUrl}';
        </c:if>
        uglcw.ui.openTab('新增${typeBean.name}', url + "?type=${sysImportTemp.type}&_sticky=v2");
    }

    function toDownDataToImportTemp(url, model) {
        var text = "在线编辑";
        if (model) text = "到Excel";
        uglcw.ui.confirm('是否导出数据' + text + '？<br/>导出时间可能较久请耐心等待！', function () {
            downDataToImportTemp(null, url, model);
        });
    }

    function downDataToImportTemp(data, url, model) {
        if (model) {
            var param = 'downExcel=1';
            for (var k in data) {
                if (param) param += "&";
                param += k + '=' + data[k];
            }
            var sp = "?";
            if (url.indexOf('?') > 0)
                sp = '&';
            window.open("${base}" + url + sp + param);
            return false;
        }
        uglcw.ui.loading();
        $.ajax({
            url: "${base}" + url,
            data: data,
            type: "POST",
            success: function (data) {
                uglcw.ui.loaded();
                if (data.state) {
                    uglcw.ui.get('#grid').reload();
                    uglcw.ui.success(data.msg);
                    uglcw.ui.openTab("编辑${typeBean.name}", "${base}manager/sysImportTemp/toEdit?type=${sysImportTemp.type}&_sticky=v2&id=" + data.importId);
                } else {
                    uglcw.ui.error(data.msg);
                }
                return data.state;
            }
        });
    }

    //-----------------------------------------------------------------------------------------
    //下载
    function download() {
        uglcw.ui.confirm('是否下载${typeBean.name}模版？', function () {
            window.location.href = '${base}${typeBean.downExcelModelUrl}'
        })
    }

    //上传
    function showUpload() {
        uglcw.ui.Modal.showUpload({
            url: toUpExcel + '?type=${sysImportTemp.type}',
            field: 'upFile',
            error: function (e) {
                uglcw.ui.notice({
                    type: 'error',
                    title: '上传失败',
                    desc: e.XMLHttpRequest.responseText
                });
                console.log('error------------', arguments)
            },
            complete: function () {
                console.log('complete', arguments);
            },
            success: function (e) {
                uglcw.ui.loaded();
                if (!e.response) {
                    uglcw.ui.error("返回出现错误");
                }
                var data = e.response;
                if (data.state) {
                    uglcw.ui.get('#grid').reload();
                    uglcw.ui.success(data.msg || data.message);
                    uglcw.ui.openTab("编辑${typeBean.name}", "${base}manager/sysImportTemp/toEdit?type=${sysImportTemp.type}&_sticky=v2&id=" + data.importId);
                } else {
                    uglcw.ui.error(data.msg || data.message);
                }
            }
        })
    }

    //商品搜索模版
    function productTemplate(url, model) {
        var i = uglcw.ui.Modal.open({
            checkbox: true,
            selection: 'single',
            title: false,
            maxmin: false,
            resizable: false,
            move: true,
            btns: ['确定', '取消'],
            area: ['400', '100px'],
            content: $('#product-template').html(),
            success: function (c) {
                uglcw.ui.init(c);
            },
            yes: function (c) {
                var data = {};
                $("input", c).each(function (i, item) {
                    var name = $(item).attr("uglcw-model");
                    data[name] = $(item).val();
                });
                downDataToImportTemp(data, url, model);
                return true;
            }
        })
    }

    //分类页面打开
    function selectType() {
        var i = uglcw.ui.Modal.open({
            checkbox: true,
            selection: 'single',
            title: false,
            maxmin: false,
            resizable: false,
            move: true,
            btns: ['确定', '取消'],
            area: ['400', '415px'],
            content: $('#product-type-selector-template').html(),
            success: function (c) {
                uglcw.ui.init(c);
            },
            yes: function (c) {
                var typeId = uglcw.ui.get($(c).find('#_type_id')).value();//选中树id
                var isType = uglcw.ui.get($(c).find('#_isType')).value();//选中树id
                $("#waretype").val(typeId);
                $("#isType").val(isType);
                $('#wareTypeNm').val($('#_type_name').text());
                return true;

            }
        })
    }
</script>
</body>
</html>
