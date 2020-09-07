<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>商品上架管理</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="uglcw-layout-container">
        <div class="uglcw-layout-fixed" style="width: 200px">
            <div class="layui-card" id="putOnWareTypeEdit">
                <div class="layui-card-body">
                    <button onclick="javascript:getChecked();" class="k-button k-info">上架商品类别编辑</button>
                </div>
            </div>
            <div class="layui-card">
                <div class="layui-card-header">
                    商品分类
                </div>
                <div class="layui-card-body">
                    <div id="tree" uglcw-role="tree"
                         uglcw-options="
							url:'manager/shopWareType/queryShopWaretypesByShopQy',
                            expandable:function(node){
                            	return node.id == '0';
                            },
							select: function(e){
								var node = this.dataItem(e.node)
								uglcw.ui.get('#waretypeNm').value(node.text);
								loadWareType(node.id, 0);//TODO 再次请求数据
							}
                    ">
                    </div>
                </div>
            </div>
        </div>
        <div class="uglcw-layout-content">
            <div class="layui-card">
                <div class="layui-card-header btn-group">
                    <ul uglcw-role="buttongroup">
                        <li style="display: none;" onclick="save()" id="save" class="k-info" data-icon="save">保存</li>
                    </ul>
                </div>
                <div class="layui-card-body">
                    <form class="form-horizontal" id="waretypefrm" uglcw-role="validator">
                        <input id="waretypeId" type="hidden" uglcw-model="waretypeId" id="waretypeId" uglcw-role="textbox">
                        <input id="waretypePid" type="hidden" uglcw-model="waretypePid" id="waretypePid"
                               uglcw-role="textbox">
                        <div class="form-group">
                            <label class="control-label col-xs-3">上级分类</label>
                            <div class="col-xs-6">
                                <input uglcw-role="textbox" uglcw-validate="required" uglcw-model="upWaretypeNm" disabled
                                       id="upWaretypeSpan"
                                       value="无"/>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3">分类名称</label>
                            <div class="col-xs-6">
                                <input id="waretypeNm" uglcw-validate="required" uglcw-role="textbox" disabled
                                       uglcw-model="waretypeNm">
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="control-label col-xs-3">图片</label>
                            <div class="col-xs-20">
                                <div id="album" uglcw-options="cropper: true" uglcw-role="album"></div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<%--添加或修改--%>
<script type="text/x-uglcw-template" id="form">
    <div class="layui-card">
        <div class="layui-card-body">
            <div id="tree2" uglcw-role="tree"
                 uglcw-options="
					 	lazy:false,
                        url:'${base}manager/shopWareType/shopWaretypes_new',
                        checkboxes:{
                            checkChildren: true
                         },
                         checkbox:true,
                        select: function(e){
                        }
                    ">
            </div>
        </div>
    </div>
</script>


<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        uglcw.ui.init();
        uglcw.ui.loaded()

    })


    //-------------------------------------------------------------------------------------------
    function getChecked() {
        uglcw.ui.Modal.showTreeSelector({
            lazy: false,
            loadOnDemand: false,
            expandable: function (node) {
                if (node.id == 0) {
                    return true;
                }
                if (node.checked || node.halfChecked) {
                    return true;
                }
                // return false
                return false;
            },
            checkable: function(node){
                delete node['halfChecked']
                return node.checked
            },
            area: ['300px', '600px'],
            url: '${base}manager/shopWareType/shopWaretypes_new',
            yes: function (checkNodes, nodes, smooth) {
                var cIds = [];
                var bIds = [];
                $.map(checkNodes, function (item) {
                    if (item.checked && item.id) {
                        cIds.push(item.id)
                    } else if (item.halfChecked  && item.id) {
                        bIds.push(item.id)
                    }
                })
                saveMenu(cIds, bIds);
            }
        })
    }

    //保存
    function saveMenu(cIds, Iids) {
        var cStr;//全选id
        var bStr;//部分选中
        if (cIds != null && cIds != undefined && cIds != '') {
            cStr = cIds.join(',');
        }
        if (Iids != null && Iids != undefined && Iids != '') {
            bStr = Iids.join(',');
        }
        $.ajax({
            url: "${base}manager/shopWareType/updateWaretypeShopQY",
            type: "post",
            data: {
                cIds: cStr,
                iIds: bStr
            },
            success: function (response) {
                if (response == '1') {
                    uglcw.ui.success('修改成功');
                    //window.location.reload()//刷新当前页面.
                    uglcw.ui.get("#tree").reload();
                } else {
                    uglcw.ui.error('修改失败');
                }
            }
        });
    }

    //点击商品分类--加载数据
    function loadWareType(id, isType) {
        if (id == 0) {
            uglcw.ui.bind($("#waretypefrm"), {
                waretypeId: "",
                waretypePid: "",
                upWaretypeNm: '无',
                waretypeNm: "根节点",
                isType: isType
            });
            $("#save").hide();
            return;
        }
        $("#save").show();
        uglcw.ui.loading();
        $.ajax({
            url: "${base}manager/getwaretype",
            type: "post",
            data: {id: id, isType: isType},
            success: function (json) {
                uglcw.ui.loaded();
                if (json) {
                    json.upWaretypeNm = json.upWaretypeNm || '无';
                    uglcw.ui.bind($("form"), json);
                    var pics = $.map(json.waretypePicList, function (item) {
                        return {
                            id: item.id,
                            thumb: item.picMini,
                            url: '/upload/' + item.pic,
                            title: '/upload/' + item.pic,
                            waretypeId: item.waretypeId
                        }
                    });
                    uglcw.ui.get('#album').value(pics);

                }
            },
            error: function () {
                uglcw.ui.loaded();
            }
        });
    }

    //保存
    function save() {
        if (!uglcw.ui.get('form').validate()) {
            return;
        }
        var form = uglcw.ui.bind('form');
        var data = uglcw.ui.bindFormData('form');
        var album = uglcw.ui.get('#album');
        data.append('delPicIds', album.getDeleted().join(','));
        $(album.value()).each(function (idx, item) {
            if (item.file) {
                data.append('file' + item.fid, item.file, item.title);
            }
        });
        uglcw.ui.confirm('确定保存吗？', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/operwaretype',
                type: 'post',
                data: data,
                processData: false,
                contentType: false,
                success: function (response) {
                    uglcw.ui.loaded();
                    if (response === '2') {
                        uglcw.ui.success('修改成功');
                    } else if (response === '-1') {
                        return uglcw.ui.error('操作失败');
                    } else if (response === '-2') {
                        return uglcw.ui.error('商品分类不能超过2级');
                    } else if (response === '-3') {
                        return uglcw.ui.error('该商品分类名称已经存在');
                    } else {
                        uglcw.ui.success('添加成功')
                    }
                    uglcw.ui.get('#tree' + form.isType).reload();
                },
                error: function () {
                    uglcw.ui.loaded();
                }
            })
        })
    }

</script>
</body>
</html>
