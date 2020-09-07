<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>${name}编辑</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        tr.import-status, tr.import-status.k-state-focused {
            background: #b6fbbe !important;
            background-color: #b6fbbe !important;
            /*color: #FFF;*/
        }

        <%--  .uglcw-grid.k-grid .k-command-cell .k-button.k-grid-edit,
         .uglcw-grid.k-grid .k-command-cell .k-button.k-grid-update,
         .uglcw-grid.k-grid .k-command-cell .k-button.k-grid-cancel {
             width: inherit;
             height: inherit;
             border: none;
         }

         .uglcw-grid.k-grid td.k-command-cell {
             text-overflow: inherit;
         }--%>
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="form-horizontal">
        <input type="hidden" uglcw-model="importStatus" id="importStatus" uglcw-role="textbox" value="${importStatus}">
        <input type="hidden" uglcw-model="importId" id="importId" uglcw-role="textbox" value="${id}">
    </div>
    <div class="uglcw-layout-container">
        <div class="uglcw-layout-content">
            <%--表格：start--%>
            <div class="layui-card">
                <div class="layui-card-body full">
                    <div id="grid" uglcw-role="grid"
                         uglcw-options='
						    toolbar: kendo.template($("#toolbar").html()),
							id:"id",
							responsive: [".header", 40],
							checkbox:true,
							editable:true,
							pageable: true,
							autoMove: false,
							rowNumber: true,
							autoAppendRow: false,
                    		criteria: ".form-horizontal",
                    		dataBound: function(){
                    		    uglcw.ui.init("#grid .k-grid-content");
                                var data = this.dataSource.data();
                                $(data).each(function(i, row){
                                    if(row.importStatus){
                                        var $row = $("#grid").find("tr[data-uid="+row.uid+"]");
                                        $row.addClass("import-status");
                                        $row.find(".k-checkbox").prop("disabled", true);
                                        $row.find(".k-checkbox-label").addClass("k-state-disabled");
                                        $row.off("click");
                                        $row.find(".k-grid-Delete").remove();
                                    }
                                })
                                $("#grid .k-command-cell a").attr("href", "javascript:void(0);")

                    		},
                    		url:"${base}manager/sysImportTemp/queryItemPage",
                    		transport: {
                    		    destroy: function(){
                    		        console.log("on destroy")
                    		    }
                    		},
                    		loadFilter:{
                    		    data: function(response){
                    		        var rows = [];
                    		         if(response.rows && response.rows.length > 0){
                                            rows = $.map(response.rows, function(row){
                                                var temp= JSON.parse(row.contextJson);
                                                var isNull=true;
                                               for(var val in temp){
                                                    if(temp[val]){
                                                        isNull=false;
                                                        break;
                                                    }
                                               }
                                               if(!isNull){
                                                    temp.id=row.id;
                                                    temp.importStatus=row.importStatus;
                                                }
                                                return temp;
                                            });
                    		         }
                    		         return rows;
                    		    }
                    		 }
                    	'>
                        <c:set var="sUnitOrsmallUnit" value=""/>
                        <c:forEach items="${titleList}" var="item">
                            <div data-field="${item.field}"
                                 uglcw-options="width:100,
                                 <c:if test="${fn:length(item.title) gt 7}">width:${fn:length(item.title)*14},</c:if>
                                 <c:if test="${'1' eq inputDown && (item.field=='sUnit' || item.field=='smallUnitScale')}">
                                <c:if test="${item.field=='sUnit'}">
                                <c:set var="sUnitOrsmallUnit" value="1"/>
                                </c:if>
                                <c:if test="${item.field=='smallUnitScale'}">
                                <c:set var="sUnitOrsmallUnit" value="2"/>
                                </c:if>
                                    template: uglcw.util.template($('#unitTempl').html()),
                                 </c:if>
                             editor: function(container, options){
                             var model = options.model;
                             if(model.importStatus){
                                $('<span>'+model['${item.field}']+'</span>').appendTo(container);
                                return ;
                             }

                            var dataStyle='';
                            if((options.field=='sUnit' || options.field=='smallUnitScale')&&model.bUnit){
                                var binput=$('<input disabled style=\'width:35%\' data-bind=\'value:bUnit\'>');
                                binput.appendTo(container);
                                new uglcw.ui.TextBox(binput).init();
                                dataStyle='style=\'width:55%\'';
                            }
                             var input = $('<input '+dataStyle+' name=\'${item.field}\' data-bind=\'value:${item.field}\'>');
                             input.appendTo(container);
                            <c:choose>
                            <c:when test="${item.type !=null && (item.type=='Integer' || item.type=='Double' || item.type=='Float' || item.type=='BigDecimal')}">var widget = new uglcw.ui.Numeric(input);</c:when>
                            <c:otherwise> var widget = new uglcw.ui.TextBox(input);</c:otherwise>
                            </c:choose>
                             widget.init({
                             value: model.${item.field}
                             })
                             }"
                            >${item.title}
                            </div>
                        </c:forEach>
                        <%--<div data-field="op" uglcw-options="width:80,command:'destroy'">操作</div>--%>
                        <div data-field="op" uglcw-options="width:150,command:[{
                            name: 'remove',
                            text: '-',
                            click: function(e){
                               deleteRow(e);
                            }
                        }]">操作
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script id="unitTempl" type="text/x-uglcw-template">
    #= data.bUnit !=null ?  data.bUnit +':'+ (data.sUnit||data.smallUnitScale) :  data.sUnit||'' #
</script>

<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:addRow();" class="k-button k-button-icontext">
        <span class="k-icon k-i-plus-outline"></span>新增一行
    </a>
    <a role="button" href="javascript:batchRemove();" class="k-button k-button-icontext">
        <span class="k-icon k-i-delete"></span>批量删除
    </a>

    <%-- <a role="button" href="javascript:toSave();" style="color: blue;" class="k-button k-button-icontext">
         <span class="k-icon k-i-save"></span>暂存
     </a>--%>
    <a role="button" href="javascript:toImportData(0);" class="k-button k-button-icontext" title="只导入当前页未导入数据">
        <span class="k-icon k-i-upload"></span>导入本页数据
    </a>
    <a role="button" href="javascript:toImportData(1);" class="k-button k-button-icontext" title="仅导入选中行数据">
        <span class="k-icon k-i-upload"></span>导入已选中
    </a>
    <a role="button" href="javascript:toImportData(10);" class="k-button k-button-icontext" title="导入所有未导入数据,不支持搜索过滤">
        <span class="k-icon k-i-upload"></span>全部导入
    </a>
    &nbsp;&nbsp;
    <select onchange="loadAll(this.value)">
        <option value="">显示全部数据</option>
        <option value="1" <c:if test="${importStatus==1}">selected</c:if>>显示已导入数据</option>
        <option value="0" <c:if test="${importStatus==0}">selected</c:if>>显示未导入数据</option>
    </select>
    <a id="otherElement">
        <c:if test="${!empty operationScript}">
            <c:forEach items="${operationScript}" var="item">
                ${item}
            </c:forEach>
        </c:if>
    </a>
    <span id="errorMsgButton"></span>
    <span id="lastErrorMsg" style="display: none"></span>
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<%@include file="/WEB-INF/view/v2/include/progress.jsp" %>

<script>

    var deleteIds = [];
    var changeIds = [];
    $(function () {
        //ui:初始化
        uglcw.ui.init();
        uglcw.layout.init();
        /*       uglcw.ui.get('#grid').on('save', function (e) {
                   console.log('on save', arguments);
                   //e.preventDefault();
                   save();
               })*/
        uglcw.ui.get('#grid').k().dataSource.bind('change', function (e) {
            var row = e.items[0];
            if (!row) return;
            //修改和删除时记录对应的ID，新增或成功导入的不记录
            if (e.action == 'itemchange') {
                if (row.id && row.id > 0 && !row.importStatus) {
                    var isExists = false;
                    $(changeIds).each(function (i, item) {
                        if (item == row.id) {
                            isExists = true;
                        }
                    })
                    if (!isExists) {
                        changeIds.push(row.id);
                        save(function (data) {

                        });
                    }
                } else {
                    save(function (data) {
                        row.id = data.id;
                    });
                }
            }
            if (e.action == 'remove') {
                if (row.id && row.id > 0 && !row.importStatus) {
                    deleteIds.push(row.id);
                }
            }
        })
        uglcw.ui.loaded();
    })

    function reload () {
        var queryStr=[];
        $('.query').each(function (i,item) {
            queryStr.push(item.name+":"+item.value);
        })
        uglcw.ui.get('#queryStr').value(queryStr.join(','));
        uglcw.ui.get('#grid').reload();
    }

    var id = -1;

    //增加行
    function addRow() {
        uglcw.ui.get('#grid').addRow({
            id: id--,
            qty: 1,
            amt: 0,
            <c:if test="${!empty sUnitOrsmallUnit}">
            bUnit: 1,
            <c:if test="${'1' eq sUnitOrsmallUnit}">
            sUnit: 1
            </c:if>
            <c:if test="${'2' eq sUnitOrsmallUnit}">
            smallUnitScale: 1
            </c:if>
            </c:if>
        });
    }

    //删除行
    function deleteRow(e) {
        var row = uglcw.ui.get('#grid').k().dataItem($(e.target).closest('tr'));
        if (row && row.id) {
            if (row.importStatus) {
                uglcw.ui.error('已审核数据不可删除')
                return false;
            }
            deleteIds.push(row.id);
            uglcw.ui.confirm("是否确定删除,将不可恢复", function () {
                save(function () {
                    uglcw.ui.get('#grid').k().dataSource.remove(row);
                });
            })
        }
    }

    //批量删除
    function batchRemove() {
        uglcw.ui.confirm("是否确定批量删除,将不可恢复", function () {
            uglcw.ui.get('#grid').removeSelectedRow(true);
            save(function () {
            });
        })
    }

    function loadAll(status) {
        $('#importStatus').val(status);
        uglcw.ui.get('#grid').reload();
    }

    function toSave() {
        uglcw.ui.confirm("是否确定暂存", function () {
            save();
        })
    }

    function save(callFun) {
        var datas = uglcw.ui.get("#grid").value();
        //过滤空行，如果整行都是空不上传
        /* if (!datas || datas.length == 0) {
             uglcw.ui.error("无数据不可保存");
             return;
         }*/
        //过滤成功导入数据
        datas = datas.filter(function (item) {
            if (item.id && item.id < 0) item.id = "";//新增数据
            if (!item.importStatus) {
                if (item.id) {//如果ID存在时，验证是否有修改过
                    var temp = null;
                    $(changeIds).each(function (j, changeId) {
                        if (changeId == item.id) {
                            temp = item;//成功的数据不在提交
                            return;
                        }
                    })
                    if (temp)
                        return temp;
                } else {
                    delete item.qty;
                    delete item.amt;
                    var objLen = 0;
                    for (var i in item) {
                        objLen++;
                    }
                    console.log(objLen);
                    if (objLen > 1)
                        return item;
                }
            }
        });
        if (datas && datas.length == 0 && deleteIds.length == 0 && changeIds.length == 0) {
            uglcw.ui.get('#grid').reload();
            uglcw.ui.error("无数据修改无须保存");
            return;
        }
        //uglcw.ui.loading();
        $.ajax({
            url: "${base}manager/sysImportTemp/updateOrSave?type=${type}",
            data: {
                importId: uglcw.ui.get("#importId").value(),
                contextJson: JSON.stringify(datas),
                deleteIds: deleteIds.join(","),
                changeIds: changeIds.join(",")
            },
            type: "post",
            success: function (resp) {
                uglcw.ui.loaded();
                if (resp && resp.state) {
                    if (resp.importId) {
                        uglcw.ui.get("#importId").value(resp.importId);
                        location.href = "${base}manager/sysImportTemp/toEdit?type=${type}&_sticky=v2&id=" + resp.importId;
                        return;
                    }
                    deleteIds = [];
                    changeIds = [];
                    uglcw.ui.success(resp.msg);
                    if (!callFun) {
                        uglcw.ui.get('#grid').reload();
                    } else {
                        callFun(resp);
                    }
                } else {
                    uglcw.ui.error(resp.msg);
                }
                return false;
            }, error: function () {
                uglcw.ui.loaded();
            }
        });
    }

    function toImportData(flag) {
        uglcw.ui.confirm("是否确认导入", function () {
            var mustSave = false;
            //如果有删除或修改时必须先保存
            if ((deleteIds && deleteIds.length > 0) || (changeIds && changeIds.length > 0)) {
                mustSave = true;
            }
            if (!mustSave) {
                var datas = uglcw.ui.get("#grid").value();
                $(datas).each(function (i, item) {
                    if (item.id && item.id < 0) {
                        mustSave = true;
                        return;
                    }
                })
            }
            if (mustSave) {//如果有修改时先暂存后在提交
                uglcw.ui.error("数据有修改请先暂存后在导入");
                return;
            }
            importData(flag);
        })
    }

    //导入
    function importData(flag) {
        var idArray = [];
        if (flag == 10) {
            idArray.push(0);
        } else if (flag == 1) {
            idArray = getGridIds(1);
            if (idArray.length == 0) {
                uglcw.ui.error("请选择需要导入的数据");
                return;
            }
        } else {
            idArray = getGridIds(0);
            if (idArray.length == 0) {
                uglcw.ui.error("本页暂无未导入的数据");
                return;
            }
        }
        if (hideProgress)
            hideProgress();
        var data = {importId: uglcw.ui.get("#importId").value(), ids: idArray.join(","), type: '${type}'};
        $(".dataVaildata").each(function (i, item) {
            var name = $(item).attr("name");
            var va = $(item).val();
            if ('checkbox' == $(item).attr('type') || 'radio' == $(item).attr('type')) {
                va = $(item).is(":checked");
            }
            data[name] = va;
        })
        uglcw.ui.loading();
        $.ajax({
            url: '${base}${editUrl}',
            data: data,
            type: "post",
            success: function (resp) {
                uglcw.ui.loaded();
                if (resp.taskId) {
                    if (resp.operationScript) {
                        eval(resp.operationScript);
                    }
                    showProgress(resp.taskId, function (data) {
                        //$("#otherElement").html("");
                        $("#errorMsgButton").html("");
                        if (data && data.remark) {
                            var remark = JSON.parse(data.remark);
                            if (!remark) return;
                            var errorMsg = '';
                            if (remark.errorMsg) {
                                $("#lastErrorMsg").html(remark.errorMsg);
                                errorMsg = '<a onclick="javascript:lastErrorMsgShow();" style="color:blue;">查看错误消息</a>';
                            }
                            var operationScript = '';
                            if (remark.operationScript) {
                                operationScript = "&nbsp;&nbsp;&nbsp;" + remark.operationScript;
                            }
                            //$("#otherElement").html(operationScript + "&nbsp;&nbsp;&nbsp;" + errorMsg);
                            $("#errorMsgButton").html(errorMsg);
                            if (remark.successMsg) {
                                $("#info", ".progress").html(remark.successMsg + errorMsg);
                            }
                        }
                        uglcw.ui.get('#grid').reload();
                    });
                    if (resp.msg)
                        uglcw.ui.success(resp.msg);
                    return;
                }
                if (resp && resp.state) {
                    uglcw.ui.success(resp.msg);
                    uglcw.ui.get('#grid').reload();
                } else {
                    uglcw.ui.error(resp.msg);
                }
                return false;
            }, error: function () {
                uglcw.ui.loaded();
            }
        });
    }

    //最后一次错误提示
    function lastErrorMsgShow() {
        //uglcw.ui.confirm($("#lastErrorMsg").html());
        uglcw.ui.Modal.open({
            title: '错误消息',
            maxmin: false,
            content: $("#lastErrorMsg").html(),
            btns: ['取消'],
            yes: function (c) {
            },
            btn2: function (c) {
            }
        })
    }

    function getGridIds(type) {
        var datas = uglcw.ui.get("#grid").value();
        if (type == 1)
            datas = uglcw.ui.get('#grid').selectedRow();
        var idArray = [];
        $(datas).each(function (i, item) {
            if (!item.importStatus && item.id > 0) {//成功的数据不在提交
                idArray.push(item.id);
            }
        });
        return idArray;
    }
</script>
</body>
</html>
