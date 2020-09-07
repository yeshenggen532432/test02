<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>商城-修改商品</title>
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
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-card">
        <div class="layui-card-header">
            <button id="save" uglcw-role="button" class="k-primary" data-icon="save" onclick="javascript:save();">保存
            </button>
        </div>
        <div class="layui-card-body">
            <form class="form-horizontal" uglcw-role="validator">
                <div uglcw-role="tabs">
                    <ul>
                        <li>商品信息</li>
                        <li>描述和图片</li>
                    </ul>
                    <%--======================商品信息:start===========================--%>
                    <div>
                        <div class="layui-col-md6">
                            <div class="layui-card">
                                <div class="layui-card-header">
                                    商品基本信息
                                </div>
                                <div class="layui-card-body">
                                    <input uglcw-model="wareId" id="wareId" value="${ware.wareId}" uglcw-role="textbox"
                                           type="hidden"/>
                                    <div class="form-group">
                                        <label class="control-label col-xs-5">1.商品名称</label>
                                        <div class="col-xs-12">
                                            <input style="width: 200px;" uglcw-model="wareNm" id="wareNm"
                                                   uglcw-role="textbox" value="${ware.wareNm}">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="control-label col-xs-5">2.大小单位比例</label>
                                        <div class="col-xs-12">
                                            <input style="width: 200px;" uglcw-model="hsNum" id="hsNum"
                                                   uglcw-role="textbox" value="${ware.hsNum}">
                                        </div>
                                    </div>
                                    <span class="left_title">(一) 大单位信息</span>
                                    <div class="form-group">
                                        <label class="control-label col-xs-5">1.大单位名称</label>
                                        <div class="col-xs-12">
                                            <input style="width: 200px;" uglcw-model="wareDw" id="wareDw"
                                                   uglcw-role="textbox" value="${ware.wareDw}">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="control-label col-xs-5">2.规格(大)</label>
                                        <div class="col-xs-12">
                                            <input style="width: 200px;" uglcw-model="wareGg" id="wareGg"
                                                   uglcw-role="textbox" value="${ware.wareGg}">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="control-label col-xs-5">3.条码(大)</label>
                                        <div class="col-xs-12">
                                            <input style="width: 200px;" uglcw-model="packBarCode" id="packBarCode"
                                                   uglcw-role="textbox" value="${ware.packBarCode}">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="control-label col-xs-5">4.批发价(大)</label>
                                        <div class="col-xs-12">
                                            <input style="width: 200px;" uglcw-model="wareDj" id="wareDj"
                                                   uglcw-role="textbox" value="${ware.wareDj}">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="control-label col-xs-5">5.销售原价(大)</label>
                                        <div class="col-xs-12">
                                            <input style="width: 200px;" uglcw-model="lsPrice" id="lsPrice"
                                                   uglcw-role="textbox" value="${ware.lsPrice}">
                                        </div>
                                    </div>
                                    <span class="left_title">(二) 小单位信息</span>
                                    <div class="form-group">
                                        <label class="control-label col-xs-5">1.小单位名称</label>
                                        <div class="col-xs-12">
                                            <input style="width: 200px;" uglcw-model="minUnit" id="minUnit"
                                                   uglcw-role="textbox" value="${ware.minUnit}">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="control-label col-xs-5">2.规格(小)</label>
                                        <div class="col-xs-12">
                                            <input style="width: 200px;" uglcw-model="minWareGg" id="minWareGg"
                                                   uglcw-role="textbox" value="${ware.minWareGg}">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="control-label col-xs-5">3.条码(小)</label>
                                        <div class="col-xs-12">
                                            <input style="width: 200px;" uglcw-model="beBarCode" id="beBarCode"
                                                   uglcw-role="textbox" value="${ware.beBarCode}">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="control-label col-xs-5">4.批发价(小)</label>
                                        <div class="col-xs-12">
                                            <input style="width: 200px;" uglcw-model="sunitPrice" id="sunitPrice"
                                                   uglcw-role="textbox" value="${ware.sunitPrice}">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="control-label col-xs-5">5.销售原价(小)</label>
                                        <div class="col-xs-12">
                                            <input style="width: 200px;" uglcw-model="minLsPrice" id="minLsPrice"
                                                   uglcw-role="textbox" value="${ware.minLsPrice}">
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="layui-col-md6">
                            <div class="layui-card">
                                <div class="layui-card-header">
                                    自营商城商品信息
                                </div>
                                <div class="layui-card-body">
                                    <div class="form-group">
                                        <label class="control-label col-xs-10">1.自营商城商品别称</label>
                                        <div class="col-xs-10">
                                            <input style="width: 200px;" uglcw-model="shopWareAlias" id="shopWareAlias"
                                                   uglcw-role="textbox" value="${ware.shopWareAlias}">
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="control-label col-xs-10">2.自营商城排序</label>
                                        <div class="col-xs-10">
                                            <input style="width: 200px;" uglcw-model="shopSort" id="shopSort"
                                                   uglcw-role="textbox" value="${ware.shopSort}">
                                        </div>
                                    </div>

                                    <span class="left_title">(一) 大单位信息</span>
                                    <div class="form-group">
                                        <label class="control-label col-xs-10">1.自营商城商品大单位</label>
                                        <div class="col-xs-10">
                                            是否显示<input type="checkbox" name="shopWarePriceShow" value="1"
                                                       <c:if test="${ware.shopWarePriceShow==null ||ware.shopWarePriceShow==1}">checked</c:if>
                                                       onchange="return priceShowChange(this)">
                                            &nbsp;&nbsp;默认单位<input type="radio" name="shopWarePriceDefault" value="0"
                                                                   <c:if test="${ware.shopWarePriceDefault==0}">checked</c:if>>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="control-label col-xs-10">2.自营商城商品大单位零售价</label>
                                        <div class="col-xs-10" title="请在商品价格设置菜单中进行原价统一设置">
                                            <input style="width: 200px;" uglcw-model="shopWareLsPrice"
                                                   id="shopWareLsPrice" uglcw-role="textbox"
                                                   value="${ware.shopWareLsPrice}">
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="control-label col-xs-10">3.自营商城商品大单位批发价</label>
                                        <div class="col-xs-10">
                                            <input style="width: 200px;" uglcw-model="shopWarePrice" id="shopWarePrice"
                                                   uglcw-role="textbox" value="${ware.shopWarePrice}">
                                        </div>
                                    </div>



                                    <span class="left_title">(二) 小单位信息</span>
                                    <div class="form-group">
                                        <label class="control-label col-xs-10">1.自营商城商品小单位</label>
                                        <div class="col-xs-10">
                                            是否显示<input type="checkbox" name="shopWareSmallPriceShow" value="1"
                                                       <c:if test="${ware.shopWareSmallPriceShow==1}">checked</c:if>
                                                       onchange="return priceShowChange(this)">
                                            &nbsp;&nbsp;默认单位<input type="radio" name="shopWarePriceDefault" value="1"
                                                                   <c:if test="${ware.shopWarePriceDefault==1}">checked</c:if>>
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="control-label col-xs-10">2.自营商城商品小单位零售价</label>
                                        <div class="col-xs-10">
                                            <input style="width: 200px;" uglcw-model="shopWareSmallLsPrice"
                                                   id="shopWareSmallLsPrice" uglcw-role="textbox"
                                                   value="${ware.shopWareSmallLsPrice}">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="control-label col-xs-10">3.自营商城商品小单位批发价</label>
                                        <div class="col-xs-10">
                                            <input style="width: 200px;" uglcw-model="shopWareSmallPrice"
                                                   id="shopWareSmallPrice" uglcw-role="textbox"
                                                   value="${ware.shopWareSmallPrice}">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="control-label col-xs-10">3.销售单数</label>
                                        <div class="col-xs-10">
                                            <input style="width: 200px;" uglcw-model="saleQty"
                                                   id="saleQty" uglcw-role="textbox"
                                                   value="${ware.saleQty}">
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <%--======================商品信息:end===========================--%>

                    <%--======================商品图片:start===========================--%>
                    <div>
                        <div class="layui-col-md12">
                            <div class="layui-card">
                                <div class="layui-card-header">
                                    商品图片
                                </div>
                                <div class="layui-card-body">
                                    <div class="form-group">
                                        <div class="col-xs-20">
                                            <div id="album" uglcw-options="
                                                        accept:'image/*',
                                                        cropper: 2,
                                                        async:{
                                                            saveUrl: '${base}manager/shopWare/updatePhotos',
                                                            saveField: 'file',
                                                        },
                                                        success: function(response){
                                                           return {
                                                                url: '/upload/'+response.fileNames[0],
                                                                thumb: '/upload/'+ response.smallFile[0]
                                                           }
                                                        }
                                                    " uglcw-role="album"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="layui-card">
                                <div class="layui-card-header">
                                    商品简述 <input style="width: 300px;" uglcw-model="wareResume"
                                                id="wareResume" uglcw-role="textbox"
                                                value="${ware.wareResume}" maxlength="20">
                                </div>
                            </div>
                            <div class="layui-card">
                                <div class="layui-card-header">
                                    商品描述
                                </div>
                                <div class="layui-card-body">
                                    <div class="form-group">
                                        <div class="col-xs-20">
                                            <div id="editor" uglcw-model="editor" uglcw-role="wangeditor"
                                                 style="width: 800px"
                                                 uglcw-options="
                                                            uploadImgServer: '${base}/manager/photo/wangEditorUpload',
                                                            uploadFileName: 'file',
                                                            uploadImgMaxSize: 3 * 1024 * 1024,
                                                            uploadImgMaxLength: 5
                                                            ">
                                                ${ware.wareDesc}
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <%--======================商品图片:start===========================--%>

                </div>
            </form>
        </div>
    </div>
</div>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        //ui:初始化
        uglcw.ui.init();
        resize();
        $(window).resize(resize);
        uglcw.ui.loaded();

        initPic();
        priceShowChange(null, true);
    })

    var delay;

    function resize() {
        if (delay) {
            clearTimeout(delay);
        }
        delay = setTimeout(function () {
        }, 200)
    }

    //-----------------------------------------------------------------------------------------
    function initPic() {
        var pics = $.map(${fns:toJson(ware.warePicList)}, function (item) {
            return {
                itemId: item.id,
                thumb: '/upload/' + item.picMini,
                url: '/upload/' + item.pic,
                title: '/upload/' + item.pic,
            }
        });
        uglcw.ui.get('#album').value(pics);
    }

    //保存
    function save() {
        if (!uglcw.ui.get('form').validate()) {
            return;
        }
        var form = uglcw.ui.bind('form');
        var data = uglcw.ui.bindFormData('form');
        data.append("shopWarePriceShow", $("input[name='shopWarePriceShow']").prop('checked') ? 1 : 0);
        data.append("shopWareSmallPriceShow", $("input[name='shopWareSmallPriceShow']").prop('checked') ? 1 : 0);
        data.append("shopWarePriceDefault", $("input:radio[name='shopWarePriceDefault']:checked").val());

        var album = uglcw.ui.get('#album');
        /*data.append('delPicIds', album.getDeleted().join(','));
        $(album.value()).each(function (idx, item) {
            if (item.file) {
                data.append('file' + item.fid, item.file, item.title);
            }
        });*/


        var imgItems = [];
        $(album.value()).each(function (i, item) {
            var imgItem = {};
            imgItem.pic = item.url.replace("/upload/", "");
            imgItem.picMini = item.thumb.replace("/upload/", "");
            imgItem.id = item.itemId;
            imgItems.push(imgItem);
        });
        data.append("pics", JSON.stringify(imgItems));

        var html = uglcw.ui.get('#editor').value();
        data.append('html', html);
        uglcw.ui.confirm('确定保存吗？', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/shopWare/updateWare',
                type: 'post',
                data: data,
                processData: false,
                contentType: false,
                success: function (response) {
                    uglcw.ui.loaded();
                    if (response === '1') {
                        uglcw.ui.success('添加成功');
                        //uglcw.io.emit("refershShopWare", "success");
                        uglcw.ui.closeCurrentTab();//关闭当前页
                    } else if (response === '2') {
                        uglcw.ui.success('修改成功');
                        //uglcw.io.emit("refershShopWare", "success");
                        uglcw.ui.closeCurrentTab();//关闭当前页
                    } else if (response === '-1') {
                        return uglcw.ui.error('操作失败');
                    } else if (response === '-2') {
                        return uglcw.ui.error('该商品名称已存在了');
                    } else if (response === '-3') {
                        return uglcw.ui.error('该商品编码已存在了');
                    } else {
                        return uglcw.ui.error('操作失败');
                    }
                },
                error: function () {
                    uglcw.ui.loaded();
                }
            })
        })
    }

    //大小单位显示和默认切换方法
    function priceShowChange(th, load) {
        var shopWarePriceShow = $("input[name='shopWarePriceShow']").prop('checked');
        var shopWareSmallPriceShow = $("input[name='shopWareSmallPriceShow']").prop('checked');
        var shopWarePriceDefault0 = $("input:radio[name='shopWarePriceDefault'][value='0']");//大单位默认
        var shopWarePriceDefault1 = $("input:radio[name='shopWarePriceDefault'][value='1']");

        if (!shopWarePriceShow && !shopWareSmallPriceShow) {//两个同时不显示
            $(th).prop("checked", true);
            uglcw.ui.error("大小单位不能两个同时隐藏");
            return false;
        }
        if (!$("#wareDw").val() && !$("#wareGg").val() && !$("#minUnit").val() && !$("#minWareGg").val()) {
            uglcw.ui.error("大小单位名称或规格不能同时为空");
            return false;
        }
        //如果显示大单位时验证名称和规格是否有填写
        if (shopWarePriceShow && !$("#wareDw").val() && !$("#wareGg").val()) {
            if (!load)
                uglcw.ui.error("大单位名称规格未设置");
            $("input[name='shopWarePriceShow']").prop('checked', false);
            //$("input[name='shopWareSmallPriceShow']").prop('checked',true);
            $(shopWarePriceDefault0).prop("checked", false);
            $(shopWarePriceDefault0).prop("disabled", true);
            $(shopWarePriceDefault1).prop("checked", true);
            return false;
        }
        //如果显示小单位时验证名称和规格是否有填写
        if (shopWareSmallPriceShow && !$("#minUnit").val() && !$("#minWareGg").val()) {
            if (!load)
                uglcw.ui.error("小单位名称规格未设置");
            $("input[name='shopWarePriceShow']").prop('checked', true);
            $("input[name='shopWareSmallPriceShow']").prop('checked', false);
            $(shopWarePriceDefault1).prop("checked", false);
            $(shopWarePriceDefault1).prop("disabled", true);
            $(shopWarePriceDefault0).prop("checked", true);
            return false;
        }

        //如果大单位不显示时默认需要选中小单位
        if (!shopWarePriceShow && shopWareSmallPriceShow) {//大单位不显示
            $(shopWarePriceDefault1).prop("checked", true);
            $(shopWarePriceDefault0).prop("disabled", true);
            $(shopWarePriceDefault1).prop("disabled", false);
        } else if (shopWarePriceShow && !shopWareSmallPriceShow) {//小单位不显示
            $(shopWarePriceDefault0).prop("checked", true);
            $(shopWarePriceDefault1).prop("disabled", true);
            $(shopWarePriceDefault0).prop("disabled", false);
        } else {
            $(shopWarePriceDefault0).prop("disabled", false);
            $(shopWarePriceDefault1).prop("disabled", false);
        }
    }

</script>
</body>
</html>
