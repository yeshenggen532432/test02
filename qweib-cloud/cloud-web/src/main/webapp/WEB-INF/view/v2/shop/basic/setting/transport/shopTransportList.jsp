<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>运费模版列表</title>
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
    <div class="uglcw-layout-container">
        <div class="uglcw-layout-content">
            <%--表格：start--%>
            <div class="layui-card">
                <div class="layui-card-body full">
                    <div id="grid" uglcw-role="grid"
                         uglcw-options="
						    toolbar: kendo.template($('#toolbar').html()),
							id:'id',
							checkbox:true,
							pageable: true,
                    		url: '${base}/manager/shopTransport/queryListAjax',
                    		criteria: '.form-horizontal'
                    	">

                        <div data-field="模板名称" uglcw-options="
								width:180,
								template:uglcw.util.template($('#title_template').html())
								">
                        </div>
                        <div data-field="isDefault"
                             uglcw-options="width:100, template: uglcw.util.template($('#isDefault_template').html())">是否默认
                        </div>
                        <div data-field="oper"
                             uglcw-options="width:300, template: uglcw.util.template($('#oper_template').html())">操作
                        </div>
                        <div data-field="desc"
                             uglcw-options="width:300, template: uglcw.util.template($('#desc_template').html())">备注
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="${base}/manager/shopTransport/toAddOrEdit" class="k-button k-button-icontext">
        <span class="k-icon k-i-plus-outline"></span>添加模版
    </a>
    <a role="button" href="javascript:toedit();" class="k-button k-button-icontext">
        <span class="k-icon k-i-track-changes-accept"></span>修改模版
    </a>
    <a role="button" href="javascript:todel();" class="k-button k-button-icontext">
        <span class="k-icon k-i-delete"></span>删除模版
    </a>
    <a role="button" href="javascript:openWindow();" class="k-button k-button-icontext">
        <span class="k-icon k-i-reload"></span>查看所有商品
    </a>

</script>
<%--是否默认--%>
<script id="title_template" type="text/x-uglcw-template">
    <button class="k-button k-info" onclick="update(#=data.id#,'#=data.title#')">#=data.title#</button>
</script>
<%--是否默认--%>
<script id="isDefault_template" type="text/x-uglcw-template">
    <span>#= data.isDefault == '1' ? '是' : '否' #</span>
</script>
<%--操作--%>
<script id="oper_template" type="text/x-uglcw-template">
   <button class="k-button k-info" onclick="openWindow(#=data.id#)">添加商品</button>
   <button class="k-button k-info" onclick="openExittsWindow(#=data.id#)">移除商品</button>
   <button class="k-button k-info" onclick="openExittsWindow(#=data.id#,1)">查看商品</button>
   #if (data.isDefault != '1') {#
   <button class="k-button k-info" onclick="updateDef(#=data.id#)">设为默认</button>
   #}#
</script>
<%--描述--%>
<script id="desc_template" type="text/x-uglcw-template">
    #= data.isDefault == '1'?'商品未设置运费模版时,统一使用此模版':'' #
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>

<%--设置商品分组--%>
<script type="text/x-uglcw-template" id="transportTemp">
    <div class="layui-card">
        <div class="layui-card-body">
            <form class="form-horizontal">
                <div class="form-group">
                    <label class="control-label col-xs-6">运费模版</label>
                    <div class="col-xs-16">
                        <input uglcw-role="combobox" uglcw-model="multiselect" id="multiselect"
                               uglcw-options="
                                        loadFilter: {
                                            data: function(resp){
                                                return resp;
                                            }
                                        },
										url: '${base}/manager/shopTransport/queryListAjax?flag=1',
										dataTextField: 'title',
										dataValueField: 'id'
										"
                        />
                    </div>
                </div>

            </form>
        </div>
    </div>
</script>

<script>
    $(function () {
        //ui:初始化
        uglcw.ui.init();


        resize();
        $(window).resize(resize);
        uglcw.ui.loaded();
    })

    var delay;

    function resize() {
        if (delay) {
            clearTimeout(delay);
        }
        delay = setTimeout(function () {
            var grid = uglcw.ui.get('#grid').k();
            var padding = 15;
            var height = $(window).height() - padding - $('.header').height() - 40;
            grid.setOptions({
                height: height,
                autoBind: true
            })
        }, 200)
    }

    /**
     * 已存在数据
     */
    function openExittsWindow(id,look) {
        if(!id){
            uglcw.ui.toast("请选择");
            return false;
        }
            var buttons=["移出","取消"];
            var title="移出已存在商品";
            if(look){
                var buttons=[];
                title="查看已存在商品";
            }
            uglcw.ui.Modal.showGridSelector({
                title:title,
                width: 500,
                id: 'wareId',
                pageable: true,
                url: '${base}/manager/shopWareTransport/shopSelectWareData?showExists=1&transportId='+id,
                query: function (params) {
                    //params.stkId = uglcw.ui.get('#stkId').value()
                },
                btns:buttons,
                checkbox: true,
                criteria: '<input uglcw-role="textbox" placeholder="输入关键字" uglcw-model="wareNm">',
                columns: [
                    {field: 'wareNm', title: '商品名称', width:300, tooltip: true},
                    {field: 'wareGg', title: '规格', width: 120}
                ],
                yes: delTransport
            })

    }
    //删除模版
    function delTransport(data) {
        if(!data||data.length==0){
            uglcw.ui.toast("请勾选您要操作的行！")
            return;
        }
        var ids="";
        $(data).each(function (i, item) {
            if (ids != "") {
                ids += "," + item.wareId;
            } else {
                ids = item.wareId;
            }
        })
        var url = "manager/shopWareTransport/deletes";
        uglcw.ui.loading();
        $.ajax({
            url: url,
            data: {"ids": ids},
            type: "post",
            success: function (data) {
                uglcw.ui.loaded();
                if (data.state) {
                    uglcw.ui.success('移出成功');
                    //uglcw.ui.get('#grid').reload();
                    uglcw.ui.get($('.uglcw-selector-container .uglcw-grid')).reload()
                    return false;
                } else {
                    uglcw.ui.error('移出失败');
                    return false;
                }
            }
        });

    }

    //选择商品加入模版或所有商品对应的运费模版
    function openWindow(id) {
        if(!id)id="";
        var buttons=["选择模版","取消"];
        var yes = updateTransportShow
        var transportName={field: 'transportName', title: '运费模版', width: 100};
        if(id){
            transportName={field: 'transportName', title: '运费模版', width: 0, hidden: true};
            var buttons=["加入","取消"];
            yes = function(data){
                return updateTransport(data,id);
            }
        }

        uglcw.ui.Modal.showTreeGridSelector({
            tree: {
                url: '${base}manager/shopWareNewType/shopWaretypesExists',
                lazy:false,
                model: 'waretype',
                id: 'id',
                expandable: function (node) {
                    return node.id == 0;
                },
                loadFilter:function(response){
                    $(response).each(function(index,item){
                        if(item.text=='根节点'){
                            item.text='商品分类'
                        }
                    })
                    return response;
                },
            },
            title:"选择模版",
            width: 900,
            id: 'wareId',
            pageable: true,
            url: '${base}/manager/shopWareTransport/shopSelectWareData?transportId='+id,
            query: function (params) {
                //params.stkId = uglcw.ui.get('#stkId').value()
            },
            btns:buttons,
            checkbox: true,
            criteria: '<input uglcw-role="textbox" placeholder="输入关键字" uglcw-model="wareNm">',
            columns: [
                {field: 'wareCode', title: '商品编码', width: 120, tooltip: true},
                {field: 'wareNm', title: '商品名称', width: 250},
                {field: 'wareDw', title: '大单位', width: 120},
                {field: 'minUnit', title: '小单位', width: 120},
                transportName
            ],
            yes: yes,
            cancel:function () {
                //alert(11);
            }
        })
    }

    //设置商品运费模版
    function updateTransportShow(ids) {
        uglcw.ui.Modal.open({
            content: $('#transportTemp').html(),
            success: function (container) {
                uglcw.ui.init($(container));
            },
            yes: function (container) {
                var transportId = uglcw.ui.get("#multiselect").value();
                if(!transportId){
                    uglcw.ui.toast("请选择运费模版！")
                    return;
                }
                if(transportId.split(",").length>1){
                    uglcw.ui.toast("运费模版一次只能选择一个！")
                    return;
                }
                updateTransport(ids,transportId);
                uglcw.ui.Modal.close();
                return false;
            }
        })
    }

    //修改模版
    function updateTransport(data,transportId) {
        if(!data||data.length==0){
            uglcw.ui.toast("请勾选您要操作的行！")
            return;
        }
        var ids="";
        $(data).each(function (i, item) {
            if (ids != "") {
                ids += "," + item.wareId;
            } else {
                ids = item.wareId;
            }
        })
        var url = "manager/shopWareTransport/saveByIds";
        uglcw.ui.loading();
        $.ajax({
            url: url,
            data: {"ids": ids, "transportId": transportId},
            type: "post",
            success: function (data) {
                uglcw.ui.loaded();
                if (data.state) {
                    uglcw.ui.success('修改成功');
                    //uglcw.ui.get('#grid').reload();
                    uglcw.ui.get($('.uglcw-selector-container .uglcw-grid')).reload()
                    return false;
                } else {
                    uglcw.ui.error('操作失败');
                    return false;
                }
            }
        });

    }

    //修改
    function toedit() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            var row=selection[0];
            update(row.id,row.title);
        } else {
            uglcw.ui.toast("请选择行");
        }
    }
    /**
     * 修改
     * @param id
     * @param title
     * @returns {boolean}
     */
    function update(id,title) {
        if (title == '包邮') {
            uglcw.ui.toast("包邮不可修改");
            return false;
        }
        window.location.href = "${base}/manager/shopTransport/toAddOrEdit?transportId=" + id;
    }

    //删除
    function todel() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            if(selection.length>1){
                uglcw.ui.toast("删除不能批量操作");
                return false;
            }
            var row = selection[0];
            //update(row.id, row.title);
            if (row.title == '包邮') {
                uglcw.ui.toast("包邮不可删除");
                return false;
            }
            uglcw.ui.confirm("是否要删除运费模版?",function () {
                $.ajax({
                    url: "${base}/manager/shopTransport/del",
                    data: "transportId=" + row.id,
                    type: "post",
                    success: function (json) {
                        if (json.state) {
                            resize();
                        } else {
                            uglcw.ui.toast(json.message);
                            return;
                        }
                    }
                });
            });

        } else {
            uglcw.ui.toast("请勾选你要操作的行！")
        }
    }
    //修改默认包邮
    function updateDef(id) {
        $.post("${base}/manager/shopTransport/updateDef", {"transportId": id}, function (data) {
            if (!data.state)uglcw.ui.toast(data.message);
            else resize();
        })
    }
</script>
</body>
</html>
