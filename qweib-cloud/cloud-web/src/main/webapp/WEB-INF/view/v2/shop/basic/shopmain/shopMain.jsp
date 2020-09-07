<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>商城首页设置</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }

        .tyWidth {
            width: 200px
        }

        .left_title {
            width: 200px;
            display: inline-block;
            text-align: left;
            padding-left: 30px
        }

        .category-name span {
            line-height: 80px;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md12">
            <div class="layui-card">
                <div class="layui-card-header">
                    <button id="save" uglcw-role="button" class="k-primary" data-icon="save" onclick="javascript:save();">
                        保存
                    </button>
                </div>
                <div class="layui-card-body">
                    <form class="form-horizontal" uglcw-role="validator">
                        <div class="layui-card">
                            <div class="layui-card-body">
                                <input uglcw-model="id" id="id" value="${shopMallInfo.id}" uglcw-role="textbox"
                                       type="hidden"/>
                                <input uglcw-model="colorIndex" id="colorIndex" value="${shopMallInfo.colorIndex}" uglcw-role="textbox"
                                       type="hidden"/>
                                <input uglcw-model="colorValue" id="colorValue" value="${shopMallInfo.colorValue}" uglcw-role="textbox"
                                       type="hidden"/>

                                <div class="form-group">
                                    <label class="control-label col-xs-3">1、店铺名称</label>
                                    <div class="col-xs-16">
                                        <input style="width: 200px;" uglcw-model="name" id="name" uglcw-role="textbox"
                                               value="${shopMallInfo.name}">
                                    </div>
                                </div>


                                <div class="form-group">
                                    <label class="control-label col-xs-3">2、店铺logo</label>
                                    <div class="col-xs-16">
                                        <div id="logo_album"
                                             uglcw-options="accept:'image/*',cropper: true,multiple:false,limit:1,
                                             async:{
                                                 saveUrl: '${base}manager/upload/multipleAndCompression?path=shop/logo',
                                                 saveField: 'file'
                                             },
                                             success: function(response){
                                                if(response.success){
                                                    return {url:'/upload/' + response.data.fileNames[0], thumb: '/upload/' + response.data.smallFile[0]}
                                                }
                                             },
                                             dataSource: [
												<c:if test="${! empty shopMallInfo.logo}">
                                                    {
                                                       id: 1,
                                                       url: '/upload/${shopMallInfo.logo}',
                                                       thumb: '/upload/${shopMallInfo.logo}'
                                                    }
                                                </c:if>
												]" uglcw-role="album"></div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="control-label col-xs-3">3、服务电话</label>
                                    <div class="col-xs-16">
                                        <input style="width: 200px;" uglcw-model="tel" id="tel" uglcw-role="textbox"
                                               value="${shopMallInfo.tel}">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="control-label col-xs-3">4、主题颜色</label>
                                    <div>
                                        <label class="col-xs-3"  style="background-color:#c40001;height: 30px;width:60px;margin:10px"></label>
                                    </div>
                                    <div>
                                        <label class="control-label col-xs-3" style="background-color: #0A9E00;height: 30px;width:60px;margin:10px"></label>
                                    </div>
                                    <div>
                                        <label class="control-label col-xs-3" style="background-color: #076ce0;height: 30px;width:60px;margin:10px"></label>
                                    </div>
                                    <div>
                                        <label class="control-label col-xs-3"  style="background-color: #ff6537;height: 30px;width:60px;margin:10px"></label>
                                    </div>
                                    <div>
                                        <label class="control-label col-xs-3"  style="background-color: #ec3c9f;height: 30px;width:60px;margin:10px"></label>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="control-label col-xs-3"></label>
                                    <div>
                                        <input type="radio" name="color" id="color1" class="col-xs-3" style="width:60px;margin:10px"/>
                                    </div>
                                    <div>
                                        <input type="radio" name="color" id="color2" class="col-xs-3" style="width:60px;margin:10px"/>
                                    </div>
                                    <div>
                                        <input type="radio" name="color" id="color3" class="col-xs-3" style="width:60px;margin:10px"/>
                                    </div>
                                    <div>
                                        <input type="radio" name="color" id="color4" class="col-xs-3" style="width:60px;margin:10px"/>
                                    </div>
                                    <div>
                                        <input type="radio" name="color" id="color5" class="col-xs-3" style="width:60px;margin:10px"/>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="control-label col-xs-3">5、广告图</label>
                                    <div class="col-xs-16">
                                        <div id="banner_album" uglcw-options="accept:'image/*',cropper: true, aspectRatio:70/35,limit:3,sortable:false,
                                        async:{
                                             saveUrl: '${base}manager/upload/multipleAndCompression?path=shop/banner/pic',
                                             saveField: 'file'
                                         },
                                         success: function(response){
                                            if(response.success){
                                                return {url:'/upload/' + response.data.fileNames[0], thumb: '/upload/' + response.data.smallFile[0]}
                                            }
                                         },
                                        dataSource: $.map(picBannerList || [], function(pic){
                                                    return {
                                                        mid: pic.id,
                                                        url: '/upload/'+pic.pic,
                                                        thumb: '/upload/'+pic.picMini
                                                    }
                                                })" uglcw-role="album"></div>

                                        <%--<div id="album21" uglcw-options="cropper: true,aspectRatio:70/35,limit:3" uglcw-role="album"></div>--%>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="control-label col-xs-3">6、首页推荐分类<br/>(最多10个)打(√)选择</label>
                                    <div class="col-xs-5">
                                        <div id="grid-category" uglcw-role="grid" uglcw-options="
                                                id: 'waretypeId',
                                                pageable: false,
                                                editable: true,
                                                checkbox:true,
                                                url: '${base}manager/shopWareType/queryWaretypeOne',
                                                loadFilter:{
                                                    data: function(response){
                                                        return response.wareTypes || [];
                                                    }
                                                },
                                                dataBound: function(){
                                                    var that = this;
                                                    var checked = '${shopMallInfo.waretype}'.split(',');
                                                    $.each(that.items(), function(i, item){
                                                                   var row = that.dataItem(item);
                                                                   if(checked.indexOf(row.waretypeId+'')!=-1){
                                                                                that.select(item);
                                                                            } });
                                                    uglcw.ui.init($('#grid-category'));
                                                    $('#grid-category').find('tr').unbind();
                                                }
                                            ">
                                            <div data-field="waretypeNm"
                                                 uglcw-options="attributes:{class:'category-name'},tooltip: true, width: 100">
                                                分类
                                            </div>
                                            <div data-field="picList"
                                                 uglcw-options="align:'left', width: 100,template:uglcw.util.template($('#picList').html())">
                                                分类图片
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/x-uglcw-template" id="waretype_tpl">

</script>

<script id="picList" type="text/x-uglcw-template">
    <div class="album2" id="category_album_#=data.waretypeId#" uglcw-options="accept:'image/*',cropper: true,
     limit:1,
     sortable:false,
     async:{
         saveUrl: '${base}manager/upload/multipleAndCompression?path=waretype/pic',
         saveField: 'file'
     },
     success: function(response){
        if(response.success){
            return {url:'/upload/' + response.data.fileNames[0], thumb: '/upload/' + response.data.smallFile[0],id:''}
        }
     },
     dataSource: $.map(uglcw.ui.get('\\#grid-category').k().dataItem($('\\#grid-category').find('tr[data-uid=#= data.uid#]')).waretypePicList, function(pic){
    return {
        mid: pic.id,
        waretypeId: pic.waretypeId,
        url: '/upload/'+pic.pic,
        thumb: '/upload/'+pic.picMini
    }
    })" uglcw-role="album"></div>
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    var picBannerList = ${fns:toJson(shopMallInfo.bannerList)}
        $(function () {
            //ui:初始化
            uglcw.ui.init();
            uglcw.ui.loaded();
            var colorIndex = uglcw.ui.get("#colorIndex").value();
            if(colorIndex == 0)$("#color1").attr("checked", "checked");
            if(colorIndex == 1)$("#color2").attr("checked", "checked");
            if(colorIndex == 2)$("#color3").attr("checked", "checked");
            if(colorIndex == 3)$("#color4").attr("checked", "checked");
            if(colorIndex == 4)$("#color5").attr("checked", "checked");
        })

    //保存
    function save() {
        var logo_album = uglcw.ui.get('#logo_album').value();
        if (logo_album && logo_album.length == 0) {
            uglcw.ui.error('请选择店铺logo');
            return false;
        }
        var rd=document.getElementsByName('color');
        var speedNum = 0;
        var colorValue ="#c40001";
        if(rd[0].checked)
        {
            speedNum = 0;
            colorValue = "#c40001";
        }
        if(rd[1].checked)
        {
            speedNum = 1;
            colorValue="#0A9E00";
        }
        if(rd[2].checked)
        {
            speedNum = 2;
            colorValue="#076ce0";
        }
        if(rd[3].checked)
        {
            speedNum = 3;
            colorValue="#ff6537";
        }
        if(rd[4].checked)
        {
            speedNum = 3;
            colorValue="#ec3c9f";
        }

        uglcw.ui.get("#colorIndex").value(speedNum);
        uglcw.ui.get("#colorValue").value(colorValue);
        var form = uglcw.ui.bind('form');
        //广告图
        var banner_album = uglcw.ui.get('#banner_album').value();
        form.logo = logo_album[0].thumb.replace('/upload/', '');
        if (banner_album && banner_album.length > 0) {
            var bannerList = [];
            banner_album.forEach(function (item) {
                var obj = {};
                obj.id = item.mid || '';
                obj.picMini = item.thumb.replace('/upload/', '');
                obj.pic = item.url.replace('/upload/', '');
                bannerList.push(obj);
            })
            form.bannerList = bannerList;
        }

        //所有分类和图片
        var selectWaretypes = [];
        var rows = uglcw.ui.get($('#grid-category')).value();
        if (rows) {
            rows.forEach(function (row) {
                var uglcw_album = uglcw.ui.get($('#grid-category').find('#category_album_' + row.waretypeId));
                if (uglcw_album && uglcw_album.value().length > 0) {
                    row.waretypePicList = [];
                    var item = uglcw_album.value()[0];
                    var obj = {};
                    obj.id = item.mid || '';
                    obj.waretypeId = row.waretypeId;
                    obj.pic = item.url.replace('/upload/', '');
                    obj.picMini = item.thumb.replace('/upload/', '');
                    row.waretypePicList.push(obj);
                } else {
                    row.waretypePicList = [];
                }
            })
        }
        form.selectWaretypes = rows;
        //选择分类
        var selectWaretypeIds = [];
        var selectCategory = uglcw.ui.get($('#grid-category')).selectedRow();
        if (selectCategory) {
            for (var i = 0; i < selectCategory.length; i++) {
                selectWaretypeIds.push(selectCategory[i].waretypeId);
            }
        }
        form.selectWaretypeIds = selectWaretypeIds.join(',');

        uglcw.ui.confirm('确定保存吗？', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/shopMain/updateConfigSet',
                type: 'post',
                contentType: 'application/json',
                data: JSON.stringify(form),
                success: function (response) {
                    uglcw.ui.loaded();
                    if (response.state) {
                        uglcw.ui.success('保存成功');
                        //location.href = location.href;
                    } else {
                        return uglcw.ui.error('保存失败');
                    }
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
