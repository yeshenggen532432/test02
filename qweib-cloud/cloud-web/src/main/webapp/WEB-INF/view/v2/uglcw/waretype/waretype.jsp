<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>商品分类管理</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style type="text/css">
        input[type="checkbox"] {
            margin: 50px auto;
            width: 500px;
        }
    </style>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="uglcw-layout-container">
        <div class="uglcw-layout-fixed" style="width: 200px">
            <div class="layui-card">
                <div class="layui-card-body full" uglcw-role="resizable" uglcw-options="responsive:[35], resize: function(){
                    setTimeout(function(){
                        uglcw.ui.get('#accordion').resize();
                    }, 500)
                }">
                    <ul uglcw-role="accordion" id="accordion">
                        <li>
                            <span>库存商品类</span>
                            <div>
                                <div id="tree0" uglcw-role="tree"
                                     uglcw-options="
                                     loadOnDemand: false,
                                url:'${base}manager/syswaretypes?isType=0',
                                loadFilter:function(response){
                                    $(response).each(function(index,item){
                                        if(item.text=='根节点'){
                                         item.text='库存商品类';
                                        }
                                    })
                                    return response;
                                },
                                expandable:function(node){
                                    return node.id == '0';
                                },
                                select: function(e){
                                    //debugger;
                                    var node = this.dataItem(e.node);
                                    var ids = [];
                                    var collect = function(node){
                                        if(node.id == 0){
                                            return;
                                        }
                                        ids.push(node.id);
                                        if(node.hasChildren){
                                            $(node.children.view()).each(function(idx,child){
                                                collect(child)
                                             })
                                        }
                                     }
                                    collect(node);
                                    console.log('children:', ids);
                                    $('#waretypefrm').data('collected', ids);
                                    uglcw.ui.get('#waretypeNm').value(node.text);
                                    loadWareType(node.id, 0,'库存商品类',node.pid,node.leaf);
                                }
                            ">
                                </div>
                            </div>
                        </li>
                        <li>
                            <span>原辅材料类</span>
                            <div id="tree1" uglcw-role="tree"
                                 uglcw-options="
                                  loadOnDemand: false,
                                expandable:function(node){
                                    if(node.id == '0')return true;
                                    return false;
                                },
                                url:'${base}manager/syswaretypes?isType=1',
                                  loadFilter:function(response){
                                  $(response).each(function(index,item){
                                        if(item.text=='根节点'){
                                         item.text='原辅材料类';
                                        }
                                    })
                                    return response;
                                },
                                select: function(e){
                                    var node = this.dataItem(e.node);
                                     var ids = [];
                                    var collect = function(node){
                                        if(node.id == 0){
                                            return;
                                        }
                                        ids.push(node.id);
                                        if(node.hasChildren){
                                            $(node.children.view()).each(function(idx,child){
                                                collect(child)
                                             })
                                        }
                                     }
                                    collect(node);
                                    console.log('children:', ids);
                                    $('#waretypefrm').data('collected', ids);
                                    uglcw.ui.get('#waretypeNm').value(node.text);
                                     loadWareType(node.id, 1,'原辅材料类',node.pid,node.leaf);
                                    //TODO 再次请求数据
                                }
                            ">
                            </div>
                        </li>
                        <li>
                            <span>低值易耗品类</span>
                            <div id="tree2" uglcw-role="tree"
                                 uglcw-options="
                                  loadOnDemand: false,
                                expandable:function(node){
                                    if(node.id == '0')return true;
                                    return false;
                                },
                                 url:'${base}manager/syswaretypes?isType=2',
                                 loadFilter:function(response){
                                  $(response).each(function(index,item){
                                        if(item.text=='根节点'){
                                         item.text='低值易耗品类';
                                        }
                                    })
                                    return response;
                                },
                                select: function(e){
                                    var node = this.dataItem(e.node);
                                     var ids = [];
                                    var collect = function(node){
                                        if(node.id == 0){
                                            return;
                                        }
                                        ids.push(node.id);
                                        if(node.hasChildren){
                                            $(node.children.view()).each(function(idx,child){
                                                collect(child)
                                             })
                                        }
                                     }
                                    collect(node);
                                    console.log('children:', ids);
                                    $('#waretypefrm').data('collected', ids);
                                    uglcw.ui.get('#waretypeNm').value(node.text);
                                    loadWareType(node.id, 2,'低值易耗品类',node.pid,node.leaf);
                                    //TODO 再次请求数据
                                }
                            ">
                            </div>
                        </li>
                        <li>
                            <span>固定资产类</span>
                            <div id="tree3" uglcw-role="tree"
                                 uglcw-options="
                                  loadOnDemand: false,
                                expandable:function(node){
                                    if(node.id == '0')return true;
                                    return false;
                                },
                                url:'${base}manager/syswaretypes?isType=3',
                                loadFilter:function(response){
                                  $(response).each(function(index,item){
                                        if(item.text=='根节点'){
                                         item.text='固定资产类';
                                        }
                                    })
                                    return response;
                                },
                                select: function(e){
                                    var node = this.dataItem(e.node);
                                     var ids = [];
                                    var collect = function(node){
                                        if(node.id == 0){
                                            return;
                                        }
                                        ids.push(node.id);
                                        if(node.hasChildren){
                                            $(node.children.view()).each(function(idx,child){
                                                collect(child)
                                             })
                                        }
                                     }
                                    collect(node);
                                    console.log('children:', ids);
                                    $('#waretypefrm').data('collected', ids);
                                    uglcw.ui.get('#waretypeNm').value(node.text);
                                    loadWareType(node.id, 3,'固定资产类',node.pid,node.leaf);
                                    //TODO 再次请求数据
                                }
                            ">
                            </div>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
        <div class="uglcw-layout-content">
            <div class="layui-card">
                <div class="layui-card-header btn-group">
                    <ul uglcw-role="buttongroup">
                        <li id="add" onclick="add()" class="k-info" data-icon="add">新增一级分类</li>
                        <li style="display: none;" onclick="addChild()" id="add-child" class="k-info" data-icon="add">
                            新增下级分类
                        </li>
                        <li onclick="save()" id="save" class="k-info" data-icon="save" style="display: none">保存</li>
                        <li style="display: none;" onclick="remove()" id="remove" class="k-error" data-icon="trash">删除
                        </li>
                    </ul>
                </div>
                <div class="layui-card-body" uglcw-role="resizable" uglcw-options="responsive:['.btn-group',35]" id="bodyDiv" style="display: none">
                    <form class="form-horizontal" id="waretypefrm" uglcw-role="validator">
                        <%--<input type="hidden" id="isType" uglcw-model="isType" uglcw-role="textbox" value="0">--%>
                        <input id="waretypeId" type="hidden" uglcw-model="waretypeId" id="waretypeId" uglcw-role="textbox">
                        <input id="waretypePid" type="hidden" uglcw-model="waretypePid" id="waretypePid"
                               uglcw-role="textbox">
                        <div class="form-group" id="isTypeUp">
                            <label class="control-label col-xs-3">上级分类</label>
                            <div class="col-xs-6">
                                <input uglcw-role="textbox" uglcw-validate="required" uglcw-model="upWaretypeNm"
                                       id="upWaretypeSpan" onclick="removal();" value="库存商品类" />
                            </div>
                        </div>
                            <div class="form-group" id="isTypeDiv">
                                <label class="control-label col-xs-3">上级分类</label>
                                <div class="col-xs-6">
                                    <select uglcw-role="combobox" uglcw-model="isType" id="isType" uglcw-options="allowInput: false">
                                        <option value="0">库存商品</option>
                                        <option value="1">原辅材料</option>
                                        <option value="2">低值易耗品类</option>
                                        <option value="3">固定资产类</option>
                                    </select>
                                </div>
                            </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3">分类名称</label>
                            <div class="col-xs-6">
                                <input id="waretypeNm" uglcw-validate="required" uglcw-role="textbox"
                                       uglcw-model="waretypeNm">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3">非公司类别</label>
                            <div class="col-xs-6">
                                <input type="checkbox" value="1" uglcw-model="noCompany" id="noCompany"
                                       uglcw-options="type:'number'"
                                       uglcw-role="checkbox">
                                <label class="k-checkbox-label" for="noCompany" style="vertical-align:middle;"></label>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="control-label col-xs-3">排序</label>
                            <div class="col-xs-6">
                                <input id="sort" uglcw-role="textbox"
                                       uglcw-model="sort" >
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="control-label col-xs-3">图片</label>
                            <div class="col-xs-20">
                                <div id="album" uglcw-options="accept:'image/*',cropper: true,limit:1" uglcw-role="album"></div>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3">商品编辑</label>
                            <div class="col-xs-12 actions">
                                <button type="button" id="del" onclick="delWare();"
                                        class="k-button k-info ghost">移出
                                </button>
                                <button type="button" id="query" onclick="queryWare();"
                                        class="k-button k-info ghost">
                                    查看
                                </button>
                                <button style="display: none;" type="button" id="creator" onclick="addWare();"
                                        class="k-button k-info ghost">创建商品
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>



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
                                        if(item.children && item.children.length > 0) {
                                            $(item.children).each(function(i, child){
                                                child.state = 'open';
                                            })
                                        }
                                    }
                                })
                                return response;
                                },
                                select: function(e){
                                    var node = this.dataItem(e.node);
                                    uglcw.ui.get('#_type_id').value(node.id);
                                    uglcw.ui.get('#_isType').value(0);
                                    uglcw.ui.get('#_upWaretypeNm').value(node.text);
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
                                        if(item.children && item.children.length > 0) {
                                            $(item.children).each(function(i, child){
                                                child.state = 'open';
                                            })
                                        }
                                    }
                                })
                                return response;
                                },
                                select: function(e){
                                    var node = this.dataItem(e.node);
                                    uglcw.ui.get('#_type_id').value(node.id);
                                    uglcw.ui.get('#_isType').value(1);
                                    uglcw.ui.get('#_upWaretypeNm').value(node.text);
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
                                         if(item.children && item.children.length > 0) {
                                            $(item.children).each(function(i, child){
                                                child.state = 'open';
                                            })
                                        }
                                    }
                                })
                                return response;
                                },
                                select: function(e){
                                    var node = this.dataItem(e.node);
                                    uglcw.ui.get('#_type_id').value(node.id);
                                    uglcw.ui.get('#_isType').value(2);
                                    uglcw.ui.get('#_upWaretypeNm').value(node.text);
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
                                         if(item.children && item.children.length > 0) {
                                            $(item.children).each(function(i, child){
                                                child.state = 'open';
                                            })
                                        }
                                    }
                                })
                                return response;
                                },
                                select: function(e){
                                    var node = this.dataItem(e.node);
                                    uglcw.ui.get('#_type_id').value(node.id);
                                    uglcw.ui.get('#_isType').value(3);
                                    uglcw.ui.get('#_upWaretypeNm').value(node.text);
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


<script id="ware-type-selector-template" type="text/uglcw-template">
    <div class="uglcw-selector-container">
        <div style="line-height: 30px">
            已选:
            <button style="display: none;" id="__type_name" class="k-button k-info ghost"></button>
        </div>
        <div style="padding: 2px;height: 344px;">
            <input type="hidden" uglcw-role="textbox" id="__type_id">
            <input type="hidden" uglcw-role="textbox" id="__isType">
            <input type="hidden" uglcw-role="textbox" id="__upWaretypeNm">
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
                                    uglcw.ui.get('#__type_id').value(node.id);
                                    uglcw.ui.get('#__isType').value(0);
                                    uglcw.ui.get('#__upWaretypeNm').value('库存商品类');
                                    $('#__type_name').text(node.text);
                                    $('#__type_name').show();
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
                                    uglcw.ui.get('#__type_id').value(node.id);
                                    uglcw.ui.get('#__isType').value(1);
                                    uglcw.ui.get('#__upWaretypeNm').value('原辅材料类');
                                    $('#__type_name').text(node.text);
                                    $('#__type_name').show();
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
                                    uglcw.ui.get('#__type_id').value(node.id);
                                    uglcw.ui.get('#__isType').value(2);
                                    uglcw.ui.get('#__upWaretypeNm').value('低值易耗品类');
                                    $('#__type_name').text(node.text);
                                    $('#__type_name').show();
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
                                      item.text='固定资产'
                                    }
                                })
                                return response;
                                },
                                select: function(e){
                                    var node = this.dataItem(e.node);
                                    uglcw.ui.get('#__type_id').value(node.id);
                                    uglcw.ui.get('#__isType').value(3);
                                    uglcw.ui.get('#__upWaretypeNm').value('固定资产类');
                                    $('#__type_name').text(node.text);
                                    $('#__type_name').show();

                                }
                            ">
                    </div>
                </li>
            </ul>
        </div>
    </div>
</script>


<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();
        uglcw.ui.get('#accordion').resize();
        uglcw.ui.loaded()
    });

    var type, types = ['库存商品类', '原辅材料类', '低值易耗品类', '固定资产类'];//新增一级分类保存的时候type为undefined

    function loadWareType(id, isType, name, waretypePid,waretypeLeaf) {
        type = isType;
        $("#add-child").hide();
        $("#save").hide();
        $("#remove").hide();
        $("#add").hide();
        $("#creator").hide();

        if (waretypePid == undefined) {
            uglcw.ui.bind($("#waretypefrm"), {
                waretypeId: "",
                waretypePid: "",
                upWaretypeNm: name,
                waretypeNm: name,
                noCompany: 0,
                isType: isType
            });
            $("#add").show();
            $("#save").show();
        } else if (waretypePid == 0) {
            //显示二级分类
            $("#add-child").show();
            $("#save").show();
            $("#remove").show();
        } else if (waretypePid != 0) {
            //显示三级分类
            $("#save").show();
            $("#remove").show();
        }
        if(waretypeLeaf == 1){
            $("#creator").show();
        }
        if (id > 0) {
            uglcw.ui.loading();
            $.ajax({
                url: "${base}manager/getwaretype",
                type: "post",
                data: {id: id, isType: isType},
                success: function (json) {
                    uglcw.ui.loaded();
                    if (json) {
                        json.upWaretypeNm = json.upWaretypeNm || name;
                        json.noCompany = json.noCompany || 0;
                        uglcw.ui.bind($("form"), json);
                        uglcw.ui.get('#sort').value(json.sort==undefined?"":json.sort);
                        var pics = $.map(json.waretypePicList, function (item) {
                            return {
                                id: item.id,
                                thumb: '/upload/' + item.picMini,
                                url: '/upload/' + item.pic,
                                title: '/upload/' + item.pic,
                                waretypeId: item.waretypeId,
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
        showField(0,id,waretypePid);
    }

    //新增一级分类
    function add() {
        var type = uglcw.ui.bind("form");
        uglcw.ui.clear('form', {
            isType: type.isType,
            upWaretypeNm: type.upWaretypeNm    //新增一级分类时候指定上级分类名称
        }, {
            excludeHidden: false
        })
        uglcw.ui.get('#album').value([]);
        showField(1,type.waretypeId,type.waretypePid);
    }

   function showField(op,id,waretypePid){
       var form = uglcw.ui.bind("form");
       if(op==0){
           if(id==0){
               $("#save").hide();
               $("#bodyDiv").hide();
           }else{
               $("#bodyDiv").show();
               $("#save").show();
               if(id!=0&&waretypePid==0){
                   $("#isTypeDiv").hide();
                   $("#isTypeUp").show();
               }else{
                   $("#isTypeDiv").hide();
                   $("#isTypeUp").show();
               }
           }
       }else if(op==1){
           $("#bodyDiv").show();
           $("#save").show();
           $("#isTypeDiv").show();
           $("#isTypeUp").hide();
       }else if(op==2){
           $("#bodyDiv").show();
           $("#save").show();
           $("#isTypeDiv").hide();
           $("#isTypeUp").show();
       }

   }

    //新增下级
    function addChild() {
        //获取当前选中的数据
        var type = uglcw.ui.bind('form');
        if (!type.waretypeId) {
            return uglcw.ui.warning('请选择上级分类');
        }
        //清除并赋予新值
        uglcw.ui.clear('form', {
            upWaretypeNm: type.waretypeNm, //上级分类
            waretypeNm: "",
            waretypePid: type.waretypeId, //上级分类ID
            isType: type.isType,
            noCompany: type.noCompany
        }, {
            excludeHidden: false
        });
        uglcw.ui.get('#album').value([]);
        showField(2,type.waretypeId,type.waretypePid);
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
        var num3 = new RegExp("^(0|[1-9][0-9]*)$");
        var sortVal = $("#sort").val();
        if(sortVal != "" && !num3.test(sortVal)){
            uglcw.ui.error("排序请填写正整数");
            return;
        }
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
                    } else if (response === '-4') {
                        return uglcw.ui.error('该一级分类已经添加商品，请先移除再新增下级分类！');
                    } else {
                        uglcw.ui.success('添加成功');

                    }
                    //if (type != form.isType) {
                    //    uglcw.ui.get('#tree' + type).reload();//解决type为undefined 定义在上面
                    //}
                    uglcw.ui.get('#tree' + form.isType).reload();
                },
                error: function () {
                    uglcw.ui.loaded();
                }
            })
        })
    }

    function remove() {
        var data = uglcw.ui.bind('form');
        if (data.waretypeId) {
            uglcw.ui.confirm('确定删除分类[' + data.waretypeNm + ']吗?', function () {
                uglcw.ui.loading();
                $.ajax({
                    url: '${base}manager/deletewaretype',
                    type: 'post',
                    data: {id: data.waretypeId},
                    success: function (response) {
                        uglcw.ui.loaded();
                        if (response) {
                            if (response === '1') {
                                uglcw.ui.info('删除成功');
                                uglcw.ui.get('#tree' + data.isType).reload();
                                $("#save").hide();  //保存
                                $("#remove").hide(); //取消
                                uglcw.ui.clear('form', {
                                    upWaretypeNm: '', //上级分类
                                    waretypeNm: "",
                                    waretypePid: 0, //上级分类ID
                                    isType: 0,
                                    noCompany: 0
                                }, {
                                    excludeHidden: false
                                });
                            } else if (response == '2') {
                                uglcw.ui.error('该商品分类下有商品不能删除');
                            } else if (response == '3') {
                                uglcw.ui.error('请先删除子分类');
                            }
                        }
                    },
                    error: function () {
                        uglcw.ui.loaded();
                        uglcw.ui.error('请求失败');
                    }
                })
            })
        }
    }

    //迁移商品
    function delWare() {
        var isType = uglcw.ui.get('#isType').value();
        var ids = $('#waretypefrm').data('collected') || [];//获取选中节点和其所有节点
        var url = '${base}manager/dialogShopWareTypePage?isType=' + isType;
        var waretypeId = [];
        $(ids).each(function (i, id) {
            waretypeId.push('waretypeId=' + id);
        });
        if (waretypeId.length > 0) {
            url += ('&' + waretypeId.join('&'));
        }
        var j = uglcw.ui.Modal.showGridSelector({
            btns: ['移入商品分类', '取消'],
            closable: true,
            title: false,
            url: url,
            query: function (params) {
                params.status = 1;
            },
            checkbox: true,
            width: 700,
            height: 400,
            criteria: '<input placeholder="请输入关键字" uglcw-role="textbox" uglcw-model="wareNm">',
            columns: [
                {field: 'wareNm', title: '商品名称', width: 200, tooltip: true},
                {field: 'wareGg', title: '规格', width: 220, tooltip: true},
                {field: 'wareCode', title: '商品编码', width: 160},
            ],
            yes: function (data) {
                console.log(data)
                var i = uglcw.ui.Modal.open({
                    checkbox: true,
                    selection: 'single',
                    title: false,
                    maxmin: false,
                    resizable: false,
                    move: true,
                    btns: ['确定', '取消'],
                    area: ['400', '415px'],
                    content: $('#ware-type-selector-template').html(),
                    success: function (c) {
                        uglcw.ui.init(c);
                    },
                    yes: function (c) {
                        var typeId = uglcw.ui.get($(c).find('#__type_id')).value();//选中树id
                        $.ajax({
                            url: '${base}manager/batchUpdateShopWaretypeId',
                            data: {
                                typeId: typeId,
                                ids: $.map(data, function (item) {
                                    return item.wareId
                                }).join(',')
                            },
                            success: function (response) {
                                if (response.code == 200) {
                                    uglcw.ui.success("操作成功");
                                    uglcw.ui.Modal.close(i);
                                    uglcw.ui.Modal.close(j);
                                } else {
                                    uglcw.ui.error(response.message ||'操作失败！');
                                    return;
                                }
                            }
                        })

                        return false;

                    }
                })
                return false;
            }
        })

    }

    //查询商品
    function queryWare() {
        var isType = uglcw.ui.get('#isType').value();
        var ids = $('#waretypefrm').data('collected') || [];//获取选中节点和其所有节点
        var url = '${base}manager/dialogShopWareTypePage?isType=' + isType;
        var waretypeId = [];
        $(ids).each(function (i, id) {
            waretypeId.push('waretypeId=' + id);
        });
        if (waretypeId.length > 0) {
            url += ('&' + waretypeId.join('&'));
        }
        // var waretypeId = uglcw.ui.get('#waretypeId').value();
        uglcw.ui.Modal.showGridSelector({
            btns: [],
            closable: true,
            title: false,
            url: url,
            query: function (params) {
                params.status = 1;
            },
            checkbox: true,
            width: 650,
            height: 400,
            criteria: '<input placeholder="请输入关键字" uglcw-role="textbox" uglcw-model="wareNm">',
            columns: [
                {field: 'wareNm', title: '商品名称', width: 200, tooltip: true},
                {field: 'wareGg', title: '规格', width: 220, tooltip: true},
                {field: 'wareCode', title: '商品编码', width: 160},
            ],
        })
    }

    //商品分类移动
    function removal() {
        var form = uglcw.ui.bind('form');
        if (form.waretypeNm != "") {
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
                    var isType = uglcw.ui.get($(c).find('#_isType')).value();
                    uglcw.ui.get("#upWaretypeSpan").value(uglcw.ui.get($(c).find('#_upWaretypeNm')).value());   //选择根节点的时候一起存下 分类名称，赋值给上级分类
                    $.ajax({
                        url: '${base}manager/updateWaretypePid',
                        data: {
                            typeId: typeId,
                            id: uglcw.ui.get('#waretypeId').value(),
                            isType: isType
                        },
                        success: function (response) {
                            if (response.code == 200) {
                                if (type != isType) {
                                    uglcw.ui.get('#tree' + isType).reload();
                                }
                                uglcw.ui.get('#tree' + form.isType).reload();
                                uglcw.ui.Modal.close(i);
                                uglcw.ui.success("操作成功");
                            } else {
                                uglcw.ui.error(response.message || '操作失败');
                                return;
                            }
                        }
                    })

                    return false;

                }
            })
        }
    }
    function addWare() {
        var id = uglcw.ui.get('#waretypeId').value();
        uglcw.ui.openTab('编辑', '${base}manager/tooperware?wtype='+ id+'&click_flag='+0);
    }
</script>
</body>
</html>
