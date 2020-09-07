<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>驰用T3</title>
    <meta name="referrer" content="never">
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }

        #tb {
            background-color: #F4F4F4;
        }

        label:not(.k-radio-label)::after {
            content: "";
        }

        #menuTableDiv {
            height: 430px;
        }

        #menuTable {
            margin-top: 150px;
            border-style: solid;
            border-width: 1px;
            cellspacing: 1px;
            width: 450px;
            text-align: center;
        }

        #menuTable td {
            border: 3px solid #F4F4F4;
            width: 25%;
            height: 30px;
        }

        #menuTable button {
            height: 25px;
            width: 100px;
            display: none;
        }

        #saveMenuConfig {
            height: 30px;
            width: 100px;
        }

        #saveMenuConfig {
            height: 30px;
            width: 100px;
        }

        #menuMaterialEdit {
            height: 430px;
            /*background:#F4F4F4;
            border-left-color:#d9dadc;
            border-left-width:2px;
            border-left-style:solid;
            width:50%;
            margin-top:20px;
            padding-left:20px;
            float:left;*/

        }

        #menuMaterialEdit button {
            width: 80px;
            height: 30px;
            position: relative;
            /*left:15%;*/
            font-size: 13px;
        }

        #menuMaterialEdit p {
            /*margin-top:20px;*/
            margin-left: 20px;
            font-size: 13px;
            margin-bottom: 10px;
        }

        .typeRadio {
            /*content: "菜单内容:";*/
            /*margin-top:20px;*/
            margin-left: 40px;
            font-size: 13px;
        }

        #menuMaterialEdit label {
            margin-top: 20px;
            /*padding-left:20px;*/

        }

        .menuName {
            margin-left: 10px;
            height: 30px;
            width: 300px;
            font-size: 13px;
        }

        .contentRadio {
            margin-left: 5px;
            cursor: pointer;
        }

        .hiddenDiv {
            display: none;
        }

        .textarea {
            align: center;
            height: 180px;
            width: 380px;
            margin-left: 35px;
        }

        .upload {
            height: 100px;
            width: 500px;
        }

        #imageTable {
            border: 2px solid #F4F4F4;
            /*background:#ffffff;*/
            width: 380px;
            height: 180px;
            margin-top: 20px;
            margin-left: 30px;
            cellspacing: 0;
            cellpadding: 0

        }

        #imageTable td {
            border: 2px solid #F4F4F4;
            align: center;
        }

        #imageTable button {
            width: 60px;
        }

        #imageTable img {
            width: 280px;
            height: 180px;
        }

        #menuButtonMaterialContentImage input {
            width: 300px;
        }

        #menuButtonMaterialContentImage p {
            margin-left: 30px;
        }

        #newsTable {
            border: 2px solid #F4F4F4;
            /*background:#ffffff;
            width:550px;*/
            height: 180px;
            margin-top: 20px;
            margin-left: 30px;
            cellspacing: 0;
            cellpadding: 0

        }

        #newsTable td {
            border: 2px solid #F4F4F4;
            align: center;
        }

        #newsTable button {
            width: 60px;
        }

        #newsTable img {
            width: 280px;
            height: 180px;
        }

        #menuButtonMaterialContentNews input {
            width: 300px;
        }

        #menuButtonMaterialContentNews p {
            margin-left: 30px;
        }

    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">

        <div class="layui-col-md12">
            <%--1上边：菜单栏start--%>
            <div class="layui-card-header">
                <div class="layui-card-body">
                    <div class="form-horizontal">
                        <div class="form-group" style="margin-bottom: 10px;">
                            <!--菜单栏按钮-->
                            <div class="col-xs-24">
                                <button id="addLeftButton" class="k-button k-info" uglcw-role="button"
                                        onclick="addLeftButton();">
                                    <i class="k-icon k-i-add"></i>增加左边菜单
                                </button>
                                <button id="addMiddleButton" class="k-button k-info" uglcw-role="button"
                                        onclick="addMiddleButton();">
                                    <i class="k-icon k-i-add"></i>增加中间菜单
                                </button>
                                <button id="addRightButton" class="k-button k-info" uglcw-role="button"
                                        onclick="addRightButton();">
                                    <i class="k-icon k-i-add"></i>增加右边菜单
                                </button>
                                <button id="updateWeixinMenu" class="k-button k-info" uglcw-role="button"
                                        onclick="updateWeixinMenu();">
                                    <i class="k-icon k-i-check"></i>发布微信公众号菜单
                                </button>
                                <button id="refresh" class="k-button k-info" uglcw-role="button" onclick="refresh();">
                                    <i class="k-icon k-i-refresh"></i>刷新
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <%--自定义菜单--%>
        </div>
        <%--自定义菜单按钮--%>
        <div class="layui-col-md6">
            <div class="layui-card">
                <div id="menuTableDiv" class="layui-card-body">
                    <table id="menuTable" class="table">
                        <tr>
                            <td><label class="control-label">菜单</label></td>
                            <td><label class="control-label">左边菜单</label></td>
                            <td><label class="control-label">中间菜单</label></td>
                            <td><label class="control-label">右边菜单</label></td>
                        </tr>
                        <tr>
                            <td><label class="control-label">子菜单5</label></td>
                            <td>
                                <button uglcw-role="button" class="k-info" id="left5" onclick="left5()"></button>
                            </td>
                            <td>
                                <button uglcw-role="button" class="k-info" id="middle5" onclick="middle5()"></button>
                            </td>
                            <td>
                                <button uglcw-role="button" class="k-info" id="right5" onclick="right5()"></button>
                            </td>
                        </tr>
                        <tr>
                            <td><label class="control-label">子菜单4</label></td>
                            <td>
                                <button uglcw-role="button" class="k-info" id="left4" onclick="left4()"></button>
                            </td>
                            <td>
                                <button uglcw-role="button" class="k-info" id="middle4" onclick="middle4()"></button>
                            </td>
                            <td>
                                <button uglcw-role="button" class="k-info" id="right4" onclick="right4()"></button>
                            </td>
                        </tr>
                        <tr>
                            <td><label class="control-label">子菜单3</label></td>
                            <td>
                                <button uglcw-role="button" class="k-info" id="left3" onclick="left3()"></button>
                            </td>
                            <td>
                                <button uglcw-role="button" class="k-info" id="middle3" onclick="middle3()"></button>
                            </td>
                            <td>
                                <button uglcw-role="button" class="k-info" id="right3" onclick="right3()"></button>
                            </td>
                        </tr>
                        <tr>
                            <td><label class="control-label">子菜单2</label></td>
                            <td>
                                <button uglcw-role="button" class="k-info" id="left2" onclick="left2()"></button>
                            </td>
                            <td>
                                <button uglcw-role="button" class="k-info" id="middle2" onclick="middle2()"></button>
                            </td>
                            <td>
                                <button uglcw-role="button" class="k-info" id="right2" onclick="right2()"></button>
                            </td>
                        </tr>
                        <tr>
                            <td><label class="control-label">子菜单1</label></td>
                            <td>
                                <button uglcw-role="button" class="k-info" id="left1" onclick="left1()"></button>
                            </td>
                            <td>
                                <button uglcw-role="button" class="k-info" id="middle1" onclick="middle1()"></button>
                            </td>
                            <td>
                                <button uglcw-role="button" class="k-info" id="right1" onclick="right1()"></button>
                            </td>
                        </tr>
                        <tr>
                            <td><label class="control-label">主菜单0</label></td>
                            <td>
                                <button uglcw-role="button" class="k-info" id="left0" onclick="left0()"></button>
                            </td>
                            <td>
                                <button uglcw-role="button" class="k-info" id="middle0" onclick="middle0()"></button>
                            </td>
                            <td>
                                <button uglcw-role="button" class="k-info" id="right0" onclick="right0()"></button>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>


        <%--2右边：表格start--%>
        <div class="layui-col-md6">
            <%--表格：start--%>
            <div class="layui-card">
                <div class="layui-card-body full">

                    <%--微信菜单按钮素材编辑--%>
                    <div id="menuMaterialEdit">
                        <p><label class="control-label">按钮位置:</label><label id="buttonPosition"
                                                                            style="width: 45px;"></label>
                            <label class="control-label">按钮号:</label><label id="buttonNo" style="width: 45px;"></label>
                            <label class="control-label">按钮类型:</label><label id="buttonType"
                                                                             style="width: 45px;"></label>
                            <button class="k-button" uglcw-role="button" onclick="return saveButtonMaterial();"><i
                                    class="k-icon k-i-save"></i>保存
                            </button>
                            <button class="k-button" uglcw-role="button" onclick="return deleteButtonMaterial();"><i
                                    class="k-icon k-i-delete"></i>删除
                            </button>

                        </p>
                        <%--<<form class="form-horizontal" uglcw-role="validator">
                            <div class="form-group" style="display: inline;">
                                按钮位置：<label id="buttonPosition" style="width: 40px;"></label>
                                按钮号：<label id="buttonNo" style="width: 40px;"></label>
                                按钮类型：<label id="buttonType" style="width: 40px;"></label>
                                <button class="k-button" uglcw-role="button" onclick="return saveButtonMaterial();"><i class="k-icon k-i-save"></i>保存</button>
                                <button class="k-button" uglcw-role="button" onclick="return deleteButtonMaterial();"><i class="k-icon k-i-delete"></i>删除</button>
                            </div>
                        </form>--%>
                        <form action="" name="menuMaterialEditForm" id="menuMaterialEditForm" method="post">
                            <p id="menuButtonName"><label class="control-label">菜单名称:&nbsp;&nbsp;&nbsp;</label><input
                                    uglcw-role="textbox" class="reg_input" id="buttonName" style="width:240px;"
                                    maxlength="8" uglcw-options="min: 1, max: 8"/></p>
                        </form>


                        <p>
                            <label class="control-label" style="display: inline;">菜单内容:</label>
                        <ul uglcw-role="radio" uglcw-model="radio" id="contentRadio"
                            uglcw-value="1"
                            class="typeRadio"
                            style="display: inline;"
                            uglcw-options='layout:"horizontal",
                                    change:function(v){ buttonMaterialContentType(v); },
                                    dataSource:[{"text":"跳转网页","value":"url"},{"text":"文字","value":"text"},{"text":"图片","value":"image"},{"text":"图文消息","value":"news"}]
                                    '></ul>
                        </p>
                        <%--<label class="contentRadio"><input type="radio" name="buttonMaterialContentType" onclick="buttonMaterialContentType()" value="url" class="content"/>跳转网页</label>
                        <label class="contentRadio"><input type="radio" name="buttonMaterialContentType" onclick="buttonMaterialContentType()" value="text" class="content"/>文字</label>
                        <label class="contentRadio"><input type="radio" name="buttonMaterialContentType" onclick="buttonMaterialContentType()" value="image" class="content"/>图片</label>
                        <label class="contentRadio"><input type="radio" name="buttonMaterialContentType" onclick="buttonMaterialContentType()" value="news" class="content"/>图文消息</label>--%>


                        <div id="buttonMaterialContent" class="">
                            <div id="buttonMaterialContentView" class="hiddenDiv">
                                <p><label class="control-label">订阅者点击该子菜单会跳到以下链接:</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    <%--<button class="k-button" uglcw-role="button" onclick="setuglcwShopUrl();" style="width: 150px;"><i class="k-icon k-i-edit"></i>旧首页</button>--%>
                                    <button class="k-button" uglcw-role="button" onclick="setuglcwShopUrl(2);"
                                            style="width: 150px;"><i class="k-icon k-i-edit"></i>直购商城
                                    </button>
                                </p>
                                <p><label class="control-label">页面地址:</label><textarea uglcw-role="textbox"
                                                                                       id="buttonMaterialContentUrl"
                                                                                       style="height: 100px"
                                                                                       maxlength="2083"
                                                                                       uglcw-options="min: 1, max: 2083"></textarea>
                                    <span id="buttonMaterialContentUrlTip" class="onshow"></span></p>
                            </div>
                            <div id="menuButtonMaterialContentTextarea">

                                <p><textarea class="reg_input" name="buttonMaterialContentTextarea"
                                             id="buttonMaterialContentTextarea"
                                             style="width:350px;height:180px;resize:none;margin-left:30px;"></textarea>
                                    <span id="buttonMaterialContentTextareaTip" class="onshow"></span></p>
                            </div>
                            <div id="menuButtonMaterialContentImage" class="hiddenDiv">
                                <table id="imageTable">
                                    <tr>
                                        <td width="280">
                                            <img id="buttonImage" alt="" src="">
                                        </td>
                                        <td width="100">
                                            <a class="k-button k-info" href="javascript:showImageWin();"><i
                                                    class="k-icon k-i-plus-circle"></i>设置图片</a>
                                        </td>
                                    </tr>
                                </table>
                                <p>image_id:&nbsp;&nbsp;&nbsp;<lable id="buttonImagID" stype="width:200px"/>
                                </p>
                            </div>
                            <div id="menuButtonMaterialContentNews">
                                <table id="newsTable">
                                    <tr>
                                        <td width="280">
                                            <img id="buttonNewsImage" alt="" src="">
                                        </td>
                                        <td width="100">
                                            <lable id="buttonNewsTitle"></lable>
                                        </td>
                                        <td width="100">
                                            <a class="k-button k-info" href="javascript:showNewsWin();"><i
                                                    class="k-icon k-i-plus-circle"></i>设置图文</a>
                                        </td>
                                    </tr>
                                </table>
                                <p>image_id&nbsp;&nbsp;&nbsp;<lable id="buttonNewsImageID" stype="width:200px"/>
                                </p>
                            </div>
                        </div>
                    </div>


                </div>
            </div>
            <%--表格：end--%>
        </div>
        <%--2右边：表格end--%>
    </div>
</div>

<%--添加关键词--%>
<%--<script type="text/x-uglcw-template" id="keywordAddDiv">
	<div class="layui-card">
		<div class="layui-card-body">
			<form class="form-horizontal" uglcw-role="validator">
				<div class="form-group">
					<label class="control-label col-xs-6">关键词</label>
					<div class="col-xs-16">
						<textarea uglcw-role="textbox" uglcw-model="keyword"  uglcw-validate="required" maxlength="30" uglcw-options="min: 1, max: 30"></textarea>
					</div>
				</div>
			</form>
		</div>
	</div>
</script>--%>

<%--设置图片--%>
<script type="text/x-uglcw-template" id="imageAddDiv">
    <div class="layui-col-md12">
        <div class="layui-card">
            <div class="layui-card-body">
                <div id="grid" uglcw-role="grid"
                     uglcw-options="
                                id:'id',
                                checkbox:true,
                                pageable: true,
                                url: '${base}/manager/WeixinConfig/imagePage',
                                criteria: '.form-horizontal',
                            ">
                    <div data-field="id" uglcw-options="width:60">图片id</div>
                    <div data-field="picMini" uglcw-options="width:200,template: uglcw.util.template($('#picMini').html())">
                        图片
                    </div>
                    <div data-field="uploadTime" uglcw-options="width:150"> 上传日期</div>
                    <div data-field="mediaId" uglcw-options="width:130,template: uglcw.util.template($('#mediaId').html())">
                        微信公众平台图片
                    </div>
                    <div data-field="setImage"
                         uglcw-options="width:80,template: uglcw.util.template($('#setImage').html())">设置
                    </div>
                </div>
            </div>
        </div>
    </div>
</script>

<%--设置新闻--%>
<script type="text/x-uglcw-template" id="newsAddDiv">
    <div class="layui-col-md12">
        <div class="layui-card">
            <div class="layui-card-body">
                <div id="newsGrid" uglcw-role="grid"
                     uglcw-options="
                                id:'id',
                                checkbox:true,
                                pageable: true,
                                url: '${base}/manager/getNewsMaterialList',
                                criteria: '.form-horizontal',
                            ">
                    <div data-field="media_id" uglcw-options="width:300,hidden:true">素材id</div>
                    <div data-field="thumb" uglcw-options="width:300,template: uglcw.util.template($('#thumb').html())">封面
                    </div>
                    <div data-field="title"
                         uglcw-options="width:130,tooltip: true,template: uglcw.util.template($('#title').html())">标题
                    </div>
                    <div data-field="setNews" uglcw-options="width:80,template: uglcw.util.template($('#setNews').html())">
                        设置
                    </div>
                </div>
            </div>
        </div>
    </div>
</script>

<%--上架状态--%>
<script id="header_pfPrice" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('pfPrice');">商城批发价(大)✎</span>
</script>
<script id="header_lsPrice" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('lsPrice');">商城零售价(大)✎</span>
</script>
<script id="header_cxPrice" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('cxPrice');">商城大单位促销价✎</span>
</script>
<script id="header_minPfPrice" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('minPfPrice');">商城批发价(小)✎</span>
</script>
<script id="header_minLsPrice" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('minLsPrice');">商城零售价(小)✎</span>
</script>
<script id="header_minCxPrice" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('minCxPrice');">商城小单位促销价✎</span>
</script>
<script id="price" type="text/x-uglcw-template">
    # var wareId = data.wareId #
    # if(val == null || val == undefined || val === '' || val== "undefined"){ #
    #    val = "" #
    # } #

    <input class="#=field#_input k-textbox" name="#=field#_input" uglcw-role="numeric" uglcw-validate="number"
           style="height:25px;display:none" onchange="changePrice(this,'#= field #',#= wareId #)" value='#= val #'>
    <span class="#=field#_span" id="#=field#_span_#=wareId#">#= val #</span>

</script>
<script id="edit" type="text/x-uglcw-template">
    <button onclick="javascript:editKeyword('#= data.keyword#');" class="k-button k-info">编辑</button>
</script>
<%--<script id="delete" type="text/x-uglcw-template">
	<button onclick="javascript:deleteKeyword('#= data.keyword#');" class="k-button k-info">删除</button>
</script>--%>
<script id="picMini" type="text/x-uglcw-template">
    <input type="image" src="upload/#= data.picMini#" height="180" width="180" align="middle"
           style="margin-top:10px;margin-bottom:10px;"/>
</script>
<script id="thumb" type="text/x-uglcw-template">
    #var thumb=data.content.news_item[0].thumb_url;#
    <input type="image" src="#=thumb#" height="180" width="280" align="middle"
           style="margin-top:10px;margin-bottom:10px;"/>
</script>
<script id="title" type="text/x-uglcw-template">
    #var title=data.content.news_item[0].title;#
    #=title#
</script>
<script id="mediaId" type="text/x-uglcw-template">
    #if(data.mediaId == ""){#
    未上传
    #}else{#
    已上传
    #}#
</script>
<script id="setImage" type="text/x-uglcw-template">
    <input style='width:60px;height:27px' type='button' value='设置'
           onclick='setImageMaterial("#= data.pic#","#= data.id#")'/>
</script>
<script id="setNews" type="text/x-uglcw-template">
    #var thumb=data.content.news_item[0].thumb_url;#
    #var title=data.content.news_item[0].title;#
    <input style='width:60px;height:27px' type='button' value='设置'
           onclick='setNewsMaterial("#=thumb#","#=title#","#= data.media_id#")'/>
</script>


<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script type="text/javascript" src="<%=basePath%>/resource/formValidator/formValidator-4.1.3.js"></script>
<script type="text/javascript" src="<%=basePath%>/resource/formValidator/formValidatorRegex.js"></script>
<script>

    var newsNum = 0;

    $(function () {
        //ui:初始化
        uglcw.ui.init();

        /*//增加关键词
        uglcw.ui.get('#addKeyWordButton').on('click', function () {
            uglcw.ui.Modal.open({
                content: $('#keywordAddDiv').html(),
                success: function (container) {
                    uglcw.ui.init($(container));
                    uglcw.ui.bind($(container).find('form'));
                },
                yes: function (container) {
                    var valid = uglcw.ui.get($(container).find('form')).validate();
                    if (!valid) {
                        return false;
                    }
                    var data = uglcw.ui.bind($(container).find('form'));
                    uglcw.ui.loading();
                    $.ajax({
                        url: '





        ${base}/manager/weiXinReply/addKeyword',
                        type: 'post',
                        data: data,
                        async: false,
                        success:function(data){
                            uglcw.ui.loaded();
                            if(data=="1"){
                                uglcw.ui.success("保存成功!");
                                uglcw.ui.get('#grid').reload();
                                uglcw.ui.Modal.close();
                            }else{
                                if(data=="0"){
                                    uglcw.ui.error("保存失败!关键词已存在!");
                                }else{
                                    uglcw.ui.error("保存失败");
                                }
                            }
                        }
                    })
                    return false;
                }
            })

        })*/


        /* //刷新
         uglcw.ui.get('#freshButton').on('click', function () {
             uglcw.ui.clear('.form-horizontal');
             uglcw.ui.get('#grid').reload();
         })*/

        /*   resize();
           $(window).resize(resize);*/
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

    //---------------------------------------------------------------------------------------------------------------

    function operatePrice(field) {
        var display = $("." + field + "_input").css('display');
        if (display == 'none') {
            $("." + field + "_input").show();
            $("." + field + "_span").hide();
        } else {
            $("." + field + "_input").hide();
            $("." + field + "_span").show();
        }
    }

    function changePrice(o, field, wareId) {
        $.ajax({
            url: "manager/shopWare/updateShopWarePrice2",
            type: "post",
            data: "id=" + wareId + "&price=" + o.value + "&field=" + field,
            success: function (data) {
                if (data == '1') {
                    $("#" + field + "_span_" + wareId).text(o.value);
                } else {
                    uglcw.ui.toast("价格保存失败");
                }
            }
        });
    }

    function toSubscribeReply() {
        //打开自定义被关注回复页面
        var url = "/manager/weiXinReply/toSubscribeReply";
        mainiframe.location.href = url;
    }

    function toReceiveReply() {
        //打开自定义收到消息回复页面
        var url = "/manager/weiXinReply/toReceiveReply";
        mainiframe.location.href = url;
    }

    function toKeywordReply() {
        //打开自定义关键词分页页面
        var url = "/manager/weiXinReply/toKeywordReply";
        mainiframe.location.href = url;
    }

    //打开编辑页面
    function editKeyword(keyword) {
        var url = "/manager/weiXinReply/toKeywordReplyDetail?keyword=" + keyword;
        window.location.href = url;
    }

    //删除关键词
    function deleteKeyword(keyword) {
        uglcw.ui.confirm('你确定要删除关键词 ' + keyword + ' 吗?', function () {
            var deleteKeyword_url = "/manager/weiXinReply/deleteKeyword?keyword=" + keyword;
            var msg = $.ajax({url: deleteKeyword_url, async: false});
            var json = $.parseJSON(msg.responseText);
            if (json.state) {
                uglcw.ui.success("删除成功!");
                uglcw.ui.get('#grid').reload();
            } else {
                uglcw.ui.error("删除失败!");
            }
        })
    }

    /* //添加关键词
     function addKeyword() {
         uglcw.ui.Modal.open({
             content: $('#form').html(),
             success: function (container) {
                 uglcw.ui.init($(container));
                 if (row) {
                     uglcw.ui.bind($(container), row);
                 }
             },
             yes: function (container) {
                 var valid = uglcw.ui.get($(container).find('form')).validate();
                 if (!valid) {
                     return false;
                 }
                 var data = uglcw.ui.bind($(container).find('form'));
                 uglcw.ui.loading();
                 $.ajax({
                     url: '${base}manager/shopWareGroup/editGroup',
                    type: 'post',
                    data: data,
                    async: false,
                    success: function (resp) {
                        uglcw.ui.loaded();
                        if (resp === '1') {
                            uglcw.ui.success('添加成功');
                            uglcw.ui.get('#grid').reload();
                            uglcw.ui.Modal.close();
                        } else if (resp === '2') {
                            uglcw.ui.success('修改成功');
                            uglcw.ui.get('#grid').reload();
                            uglcw.ui.Modal.close();
                        } else if (resp === '3') {
                            uglcw.ui.error('该分组名称已存在');
                        } else {
                            uglcw.ui.error('操作失败');
                        }
                    }
                })
                return false;
            }
        })
    }*/

    //自定义被关注回复
    function toSubscribeReply() {
        //打开自定义被关注回复页面
        var url = "/manager/weiXinReply/toSubscribeReply";
        uglcw.ui.openTab('自定义被关注回复', url);
    }

    //打开自定义收到消息回复页面
    function toReceiveReply() {
        var url = "/manager/weiXinReply/toReceiveReply";
        uglcw.ui.openTab('自定义收到消息回复', url);
    }


    $(function () {
        clearMenuMaterial();
        toValidate();
        queryMenuButton();
    });

    function imageFormatter(val, row) {
        if (val != "") {
            return "<input  type=\"image\" src=\"" + "upload/" + val + "\" height=\"180\" width=\"180\" align=\"middle\" style=\"margin-top:10px;margin-bottom:10px;\"/>";
        }
    }

    function media_idFormatter(val, row) {
        if (row.mediaId == "") {
            return "未上传";
        } else {
            return "已上传";
        }
    }

    //查询菜单按钮
    function queryMenuButton() {
        var getMenuButton_url = "/manager/getMenuButton";
        var msg = $.ajax({url: getMenuButton_url, async: false});
        var json = $.parseJSON(msg.responseText);
        var leftButtonList = json.leftButtonList;
        var middleButtonList = json.middleButtonList;
        var rightButtonList = json.rightButtonList;
        for (var i = 0; i < json.leftButtonNum; i++) {
            $("#" + leftButtonList[i].position + leftButtonList[i].button_no).html(leftButtonList[i].name);
            $("#" + leftButtonList[i].position + leftButtonList[i].button_no).show();
        }
        for (var i = 0; i < json.middleButtonNum; i++) {
            $("#" + middleButtonList[i].position + middleButtonList[i].button_no).html(middleButtonList[i].name);
            $("#" + middleButtonList[i].position + middleButtonList[i].button_no).show();
        }
        for (var i = 0; i < json.rightButtonNum; i++) {
            $("#" + rightButtonList[i].position + rightButtonList[i].button_no).html(rightButtonList[i].name);
            $("#" + rightButtonList[i].position + rightButtonList[i].button_no).show();
        }
    }

    //表单验证
    function toValidate() {
        /*$.formValidator.initConfig({validatorGroup:"1"});
        $.formValidator.initConfig({validatorGroup:"2"});
        $.formValidator.initConfig({validatorGroup:"3"});
        if($("#buttonNo").html()=="0"){
            $("#buttonName").formValidator({validatorGroup:"1",onShow:"1~4个字或1~8个字母",onFocus:"1~4个字或1~8个字母",onCorrect:"通过"}).inputValidator({min:1,max:8,onError:"1~4个字或1~8个字母"});
        }else{
            $("#buttonName").formValidator({validatorGroup:"1",onShow:"1~8个字或1~16个字母",onFocus:"1~8个字或1~16个字母",onCorrect:"通过"}).inputValidator({min:1,max:16,onError:"1~8个字或1~16个字母"});
        }
        $("#buttonMaterialContentUrl").formValidator({validatorGroup:"2",onShow:"1~2083个字符",onFocus:"1~2083个字符",onCorrect:"通过"}).inputValidator({min:1,max:2083,onError:"1~2083个字符"});
        $("#buttonMaterialContentTextarea").formValidator({validatorGroup:"3",onShow:"1~600个字",onFocus:"1~600个字",onCorrect:"通过"}).inputValidator({min:1,max:1200,onError:"1~600个字"});*/

    }

    //增加左边菜单
    function addLeftButton() {
        if ($("#left0").is(':hidden()')) {
            $("#left0").show();
            clearMenuMaterial();
            $("#buttonPosition").html("left");
            $("#buttonNo").html("0");
            toValidate();
            $("#buttonType").html("url");
            $("input[name=buttonMaterialContentType][value=url]").attr("checked", true);
            uglcw.ui.bind('body', {radio: 'url'});

        } else {
            if ($("#left0").html() == "") {
                uglcw.ui.error("左边主菜单还未设置！");
                return;
            } else {
                for (var i = 1; i <= 5; i++) {
                    if ($("#left" + i).is(':hidden()')) {
                        $("#left" + i).show();
                        clearMenuMaterial();
                        $("#buttonPosition").html("left");
                        $("#buttonNo").html(i);
                        $("#buttonType").html("url");
                        return;
                    } else {
                        if ($("#left" + i).html() == "") {
                            uglcw.ui.error("左边子菜单" + i + "还未设置！");
                            return;
                        }
                    }
                }
                uglcw.ui.error("左边菜单已满!");
            }
        }

    }

    //增加中间菜单
    function addMiddleButton() {
        if ($("#left0").html() == "") {
            uglcw.ui.error("左边主菜单还未设置!");
            return;
        } else {
            if ($("#middle0").is(':hidden()')) {
                $("#middle0").show();
                clearMenuMaterial();
                $("#buttonPosition").html("middle");
                $("#buttonNo").html("0");
                $("#buttonType").html("url");
            } else {
                if ($("#middle0").html() == "") {
                    uglcw.ui.error("中间主菜单还未设置！");
                    return;
                } else {
                    for (var i = 1; i <= 5; i++) {
                        if ($("#middle" + i).is(':hidden()')) {
                            $("#middle" + i).show();
                            clearMenuMaterial();
                            $("#buttonPosition").html("middle");
                            $("#buttonNo").html(i);
                            $("#buttonType").html("url");
                            return;
                        } else {
                            if ($("#middle" + i).html() == "") {
                                uglcw.ui.error("中间子菜单" + i + "还未设置！");
                                return;
                            }
                        }
                    }
                    uglcw.ui.error("中间菜单已满!");
                }
            }
        }
    }

    //增加右边菜单
    function addRightButton() {
        if ($("#middle0").html() == "") {
            uglcw.ui.error("中间主菜单还未设置!");
            return;
        } else {
            if ($("#right0").is(':hidden()')) {
                $("#right0").show();
                clearMenuMaterial();
                $("#buttonPosition").html("right");
                $("#buttonNo").html("0");
                $("#buttonType").html("url");
            } else {
                if ($("#right0").html() == "") {
                    uglcw.ui.error("右边主菜单还未设置！");
                    return;
                } else {
                    for (var i = 1; i <= 5; i++) {
                        if ($("#right" + i).is(':hidden()')) {
                            $("#right" + i).show();
                            clearMenuMaterial();
                            $("#buttonPosition").html("right");
                            $("#buttonNo").html(i);
                            $("#buttonType").html("url");
                            return;
                        } else {
                            if ($("#right" + i).html() == "") {
                                uglcw.ui.error("右边子菜单" + i + "还未设置！");
                                return;
                            }
                        }
                    }
                    uglcw.ui.error("右边菜单已满!");
                }
            }
        }
    }

    //清空菜单素材页面
    function clearMenuMaterial() {
        $("#buttonPosition").html("");
        $("#buttonNo").html("");
        $("#buttonType").html("");
        $("#buttonName").val("");
        $('input:radio[name=buttonMaterialContentType]').attr('checked', false);
        $("#buttonMaterialContentTextarea").val("");
        $("#buttonMaterialContentUrl").val("");
        $("#buttonImage").attr('src', "");
        $("#buttonImagID").html("");
        $("#buttonNews").attr('src', "");
        $("#buttonNewsTitle").html("");
        $("#buttonNewsImageID").html("");

        uglcw.ui.bind('body', {radio: 'url'});
        $("#buttonMaterialContentView").show();
        $("#menuButtonMaterialContentTextarea").hide();
        $("#menuButtonMaterialContentImage").hide();
        $("#menuButtonMaterialContentNews").hide();
        //清空图片、视频素材
    }

    function toWeixinLogin() {
        var get_url = "/manager/getWeixinLoginUrl?getWeixinLoginUrl=1";
        var msg = $.ajax({url: get_url, async: false});
        var json = $.parseJSON(msg.responseText);
        var url = json.url;
        parent.add('微信公众平台', url);
    }

    function showMaterial() {
        //获取图片素材列表

        var url = "/toPhotoMaterialPage";
        parent.add('素材管理', url);
    }

    function refresh() {
        location.reload();
    }

    //单选框
    function buttonMaterialContentType() {
        var ContentType = $("input[name=buttonMaterialContentType]:checked").val();
        $("#buttonType").html(ContentType);
        switch (ContentType) {
            case "url":
                $("#buttonMaterialContentView").show();
                $("#menuButtonMaterialContentTextarea").hide();
                $("#menuButtonMaterialContentImage").hide();
                $("#menuButtonMaterialContentNews").hide();
                break;
            case "text":
                $("#buttonMaterialContentView").hide();
                $("#menuButtonMaterialContentTextarea").show();
                $("#menuButtonMaterialContentImage").hide();
                $("#menuButtonMaterialContentNews").hide();
                break;
            case "image":
                $("#buttonMaterialContentView").hide();
                $("#menuButtonMaterialContentTextarea").hide();
                $("#menuButtonMaterialContentImage").show();
                $("#menuButtonMaterialContentNews").hide();
                break;
            case "news":
                $("#buttonMaterialContentView").hide();
                $("#menuButtonMaterialContentTextarea").hide();
                $("#menuButtonMaterialContentImage").hide();
                $("#menuButtonMaterialContentNews").show();
                break;
            default:
                break;
        }

    }

    //单选框
    function buttonMaterialContentType(ContentType) {
        $("#buttonType").html(ContentType);
        switch (ContentType) {
            case "url":
                $("#buttonMaterialContentView").show();
                $("#menuButtonMaterialContentTextarea").hide();
                $("#menuButtonMaterialContentImage").hide();
                $("#menuButtonMaterialContentNews").hide();
                break;
            case "text":
                $("#buttonMaterialContentView").hide();
                $("#menuButtonMaterialContentTextarea").show();
                $("#menuButtonMaterialContentImage").hide();
                $("#menuButtonMaterialContentNews").hide();
                break;
            case "image":
                $("#buttonMaterialContentView").hide();
                $("#menuButtonMaterialContentTextarea").hide();
                $("#menuButtonMaterialContentImage").show();
                $("#menuButtonMaterialContentNews").hide();
                break;
            case "news":
                $("#buttonMaterialContentView").hide();
                $("#menuButtonMaterialContentTextarea").hide();
                $("#menuButtonMaterialContentImage").hide();
                $("#menuButtonMaterialContentNews").show();
                break;
            default:
                break;
        }

    }

    //保存按钮素材
    function saveButtonMaterial() {
        var saveButtonMaterial_url = "/manager/saveButtonMaterial";
        var position = $("#buttonPosition").html();
        var button_no = $("#buttonNo").html();
        if (position == "" || button_no == "") {
            uglcw.ui.error("菜单没有按钮,请新增按钮！");
            return;
        }
        var type = $("#buttonType").html();
        var name = $("#buttonName").val();
        if (type == "") {
            uglcw.ui.error("请选择菜单类型！");
            return;
        }
        switch (type) {
            case "url":
                var value = $("#buttonMaterialContentUrl").val();
                var image_url = "";
                var news_title = "";
                if ($("#buttonName").val().trim() != "" && $("#buttonMaterialContentUrl").val().trim() != "") {
                    $.ajax({
                        url: saveButtonMaterial_url,
                        data: {
                            "position": position,
                            "button_no": button_no,
                            "name": name,
                            "type": type,
                            "value": value,
                            "iamge_url": image_url,
                            "news_title": news_title
                        },
                        type: "post",
                        success: function (data) {
                            if (data == "1") {
                                $("#" + position + button_no).html(name);
                                uglcw.ui.success("保存成功!");
                            } else {
                                uglcw.ui.error("保存失败");
                            }
                        }
                    });
                } else {
                    uglcw.ui.error("菜单名称或页面地址不能为空！");
                }
                break;
            case "text":
                var value = $("#buttonMaterialContentTextarea").val();
                var image_url = "";
                var news_title = "";
                if ($("#buttonName").val().trim() != "" && $("#buttonMaterialContentTextarea").val().trim() != "") {
                    $.ajax({
                        url: saveButtonMaterial_url,
                        data: "position=" + position + "&button_no=" + button_no + "&name=" + name + "&type=" + type + "&value=" + value + "&image_url" + image_url + "&news_title" + news_title,
                        type: "post",
                        success: function (data) {
                            if (data == "1") {
                                $("#" + position + button_no).html(name);
                                uglcw.ui.success("保存成功!");
                            } else {
                                uglcw.ui.error("保存失败");
                            }
                        }
                    });
                } else {
                    uglcw.ui.error("菜单名称或文字菜单内容不能为空！");
                }
                break;
            case "image":
                var value = $("#buttonImagID").html();
                var image_url = $("#buttonImage").attr("src");
                var news_title = "";
                if ($("#buttonName").val().trim() != "" && value.trim() != "") {
                    $.ajax({
                        url: saveButtonMaterial_url,
                        data: "position=" + position + "&button_no=" + button_no + "&name=" + name + "&type=" + type + "&value=" + value + "&image_url=" + image_url + "&news_title=" + news_title,
                        type: "post",
                        success: function (data) {
                            if (data == "1") {
                                $("#" + position + button_no).html(name);
                                uglcw.ui.success("保存成功!");
                            } else {
                                uglcw.ui.error("保存失败");
                            }
                        }
                    });
                } else {
                    uglcw.ui.error("菜单名称或者图片不能为空！");
                }
                break;
            case "news":
                var value = $("#buttonNewsImageID").html();
                var image_url = $("#buttonNewsImage").attr("src");
                var news_title = $("#buttonNewsTitle").html();
                if ($("#buttonName").val().trim() != "" && value.trim() != "") {
                    $.ajax({
                        url: saveButtonMaterial_url,
                        data: "position=" + position + "&button_no=" + button_no + "&name=" + name + "&type=" + type + "&value=" + value + "&image_url=" + image_url + "&news_title=" + news_title,
                        type: "post",
                        success: function (data) {
                            if (data == "1") {
                                $("#" + position + button_no).html(name);
                                uglcw.ui.success("保存成功!");
                            } else {
                                uglcw.ui.error("保存失败");
                            }
                        }
                    });
                } else {
                    uglcw.ui.error("菜单名称或者新闻不能为空！");
                }
                break;
        }
    }

    //查询图片
    function queryImageMaterial() {
        $('#imageDatagrid').datagrid({
            url: "/manager/WeixinConfig/imagePage"
        });
    }

    //查询图文
    function queryNewsMaterial() {
        var msg = $.ajax({url: "/manager/getMaterialCount", async: false});
        var json = $.parseJSON(msg.responseText);
        var news_count = json.news_count;
        $("#newsNum").html(news_count);
        $('#newsDatagrid').datagrid({
            url: "/manager/getMaterialList",
            queryParams: {
                type: "news",
                total: news_count
            }
        });
    }

    //设置图片
    function showImageWin() {
        /*  $("#imageDiv").window({title:"设置图片",modal:true});
          queryImageMaterial();
          $("#imageDiv").window('open');
          $("#imageDiv").window('center');*/

        uglcw.ui.Modal.open({
            area: ['800px', '400px'],
            content: $('#imageAddDiv').html(),
            success: function (container) {
                uglcw.ui.init($(container));
                uglcw.ui.bind($(container).find('form'));
            },
            yes: function (container) {
                var valid = uglcw.ui.get($(container).find('form')).validate();
                if (!valid) {
                    return false;
                }
                var data = uglcw.ui.bind($(container).find('form'));
                uglcw.ui.loading();
                $.ajax({
                    url: '${base}/manager/weiXinReply/addKeyword',
                    type: 'post',
                    data: data,
                    async: false,
                    success: function (data) {
                        uglcw.ui.loaded();
                        if (data == "1") {
                            uglcw.ui.success("保存成功!");
                            uglcw.ui.get('#grid').reload();
                            uglcw.ui.Modal.close();
                        } else {
                            if (data == "0") {
                                uglcw.ui.error("保存失败!关键词已存在!");
                            } else {
                                uglcw.ui.error("保存失败");
                            }
                        }
                    }
                })
                return false;
            }
        })

    }

    function showNewsWin() {
        /*$("#newsDiv").window({title:"设置图文",modal:true});
		 queryNewsMaterial();
		 $("#newsDiv").window('open');
		 $("#newsDiv").window('center');*/

        uglcw.ui.Modal.open({
            area: ['800px', '400px'],
            content: $('#newsAddDiv').html(),
            success: function (container) {
                uglcw.ui.init($(container));
                uglcw.ui.bind($(container).find('form'));
            },
            yes: function (container) {
                var valid = uglcw.ui.get($(container).find('form')).validate();
                if (!valid) {
                    return false;
                }
                var data = uglcw.ui.bind($(container).find('form'));
                uglcw.ui.loading();
                $.ajax({
                    url: '${base}/manager/weiXinReply/addKeyword',
                    type: 'post',
                    data: data,
                    async: false,
                    success: function (data) {
                        uglcw.ui.loaded();
                        if (data == "1") {
                            uglcw.ui.success("保存成功!");
                            uglcw.ui.get('#grid').reload();
                            uglcw.ui.Modal.close();
                        } else {
                            if (data == "0") {
                                uglcw.ui.error("保存失败!关键词已存在!");
                            } else {
                                uglcw.ui.error("保存失败");
                            }
                        }
                    }
                })
                return false;
            }
        })
    }

    function hideImageWin() {
        $("#imageDiv").window('close');
        $('#imageDatagrid').datagrid('reload');
    }

    function imageSetFormatter(val, row, index) {
        var ImageUrl = row.picMini;
        var image_id = row.id;
        ImageUrl = JSON.stringify(ImageUrl);
        image_id = JSON.stringify(image_id);
        return "<input style='width:60px;height:27px' type='button' value='设置' onclick='setImageMaterial(" + ImageUrl + "," + image_id + ")' />";
    }

    function setImageMaterial(ImageUrl, image_id) {
        ImageUrl = "upload/" + ImageUrl;
        $("#buttonImage").attr("src", ImageUrl);
        $("#buttonImagID").html(image_id);
        //  hideImageWin();
        uglcw.ui.Modal.close();
    }

    function setNewsMaterial(thumb, title, image_id) {
        $("#buttonNewsImage").attr("src", thumb);
        $("#buttonNewsTitle").html(title);
        $("#buttonNewsImageID").html(image_id);
        uglcw.ui.Modal.close();
    }

    //设置图文
    function newsImgFormatter(val, row, index) {
        if (val != "") {
            var thumb_photo = row.content.news_item[0].thumb_url;
            return "<input  type=\"image\" src=\"" + "" + thumb_photo + "\" height=\"180\" width=\"280\" align=\"middle\" style=\"margin-top:10px;margin-bottom:10px;\"/>";
        }
    }

    function newsTitleFormatter(val, row) {
        return row.content.news_item[0].title;
    }

    function newsSetFormatter(val, row, index) {
        var thumbImageUrl = row.content.news_item[0].thumb_url;
        var title = row.content.news_item[0].title;
        var media_id = row.media_id;
        thumbImageUrl = JSON.stringify(thumbImageUrl);
        title = JSON.stringify(title);
        media_id = JSON.stringify(media_id);
        return "<input style='width:60px;height:27px' type='button' value='设置' onclick='setNewsMaterial(" + thumbImageUrl + "," + title + "," + media_id + ")' />";
    }

    /* function setNewsMaterial(thumbImageUrl,title,image_id){
         $("#buttonNewsImage").attr("src",thumbImageUrl);
         $("#buttonNewsTitle").html(title);
         $("#buttonNewsImageID").html(image_id);
         hideNewsWin();
     }*/
    function hideNewsWin() {
        $("#newsDiv").window('close');
    }

    function left0() {
        if ($("#buttonPosition").html() != "left" || $("#buttonNo").html() != "0") {
            clearMenuMaterial();
            var getMenuButtonMaterial_url = "/manager/getMenuButtonMaterial?position=left&button_no=0";
            var msg = $.ajax({url: getMenuButtonMaterial_url, async: false});
            var json = $.parseJSON(msg.responseText);
            var buttonMaterialMap = json.buttonMaterialMap;
            if (json.state) {
                $("#buttonPosition").html(buttonMaterialMap.position);
                $("#buttonNo").html(buttonMaterialMap.button_no);
                $("#buttonName").val(buttonMaterialMap.name);
                $("#buttonType").html(buttonMaterialMap.type);
                switch (buttonMaterialMap.type) {
                    case "url":
                        $("input[name=buttonMaterialContentType][value=url]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'url'});
                        $("#buttonMaterialContentUrl").val(buttonMaterialMap.url);
                        break;
                    case "text":
                        $("input[name=buttonMaterialContentType][value=text]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'text'});
                        $("#buttonMaterialContentTextarea").val(buttonMaterialMap.text);
                        $("#buttonMaterialContentView").hide();
                        $("#menuButtonMaterialContentTextarea").show();
                        $("#menuButtonMaterialContentImage").hide();
                        $("#menuButtonMaterialContentNews").hide();
                        break;
                    case "image":
                        $("input[name=buttonMaterialContentType][value=image]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'image'});
                        $("#buttonImagID").html(buttonMaterialMap.image_id);
                        $("#buttonImage").attr('src', buttonMaterialMap.image_url);
                        $("#buttonMaterialContentView").hide();
                        $("#menuButtonMaterialContentTextarea").hide();
                        $("#menuButtonMaterialContentImage").show();
                        $("#menuButtonMaterialContentNews").hide();
                        break;
                    case "news":
                        $("input[name=buttonMaterialContentType][value=news]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'news'});
                        $("#buttonNewsImageID").html(buttonMaterialMap.media_id);
                        $("#buttonNewsImage").attr('src', buttonMaterialMap.image_url);
                        $("#buttonNewsTitle").html(buttonMaterialMap.news_title);
                        break;
                    default :
                        break;
                }
            } else {
                uglcw.ui.error("查询按钮素材失败！");
            }
        }
    }

    function left1() {
        if ($("#buttonPosition").html() != "left" || $("#buttonNo").html() != "1") {
            clearMenuMaterial();
            var getMenuButtonMaterial_url = "/manager/getMenuButtonMaterial?position=left&button_no=1";
            var msg = $.ajax({url: getMenuButtonMaterial_url, async: false});
            var json = $.parseJSON(msg.responseText);
            var buttonMaterialMap = json.buttonMaterialMap;
            if (json.state) {
                $("#buttonPosition").html(buttonMaterialMap.position);
                $("#buttonNo").html(buttonMaterialMap.button_no);
                $("#buttonName").val(buttonMaterialMap.name);
                $("#buttonType").html(buttonMaterialMap.type);
                switch (buttonMaterialMap.type) {
                    case "url":
                        $("input[name=buttonMaterialContentType][value=url]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'url'});
                        $("#buttonMaterialContentUrl").val(buttonMaterialMap.url);
                        break;
                    case "text":
                        $("input[name=buttonMaterialContentType][value=text]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'text'});
                        $("#buttonMaterialContentTextarea").val(buttonMaterialMap.text);
                        $("#buttonMaterialContentView").hide();
                        $("#menuButtonMaterialContentTextarea").show();
                        $("#menuButtonMaterialContentImage").hide();
                        $("#menuButtonMaterialContentNews").hide();
                        break;
                    case "image":
                        $("input[name=buttonMaterialContentType][value=image]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'image'});
                        $("#buttonImagID").html(buttonMaterialMap.image_id);
                        $("#buttonImage").attr('src', buttonMaterialMap.image_url);
                        $("#buttonMaterialContentView").hide();
                        $("#menuButtonMaterialContentTextarea").hide();
                        $("#menuButtonMaterialContentImage").show();
                        $("#menuButtonMaterialContentNews").hide();
                        break;
                    case "news":
                        $("input[name=buttonMaterialContentType][value=news]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'news'});
                        $("#buttonNewsImageID").html(buttonMaterialMap.media_id);
                        $("#buttonNewsImage").attr('src', buttonMaterialMap.image_url);
                        $("#buttonNewsTitle").html(buttonMaterialMap.news_title);
                        $("#buttonMaterialContentView").hide();
                        $("#menuButtonMaterialContentTextarea").hide();
                        $("#menuButtonMaterialContentImage").hide();
                        $("#menuButtonMaterialContentNews").show();
                        break;
                    default :
                        break;
                }
            } else {
                uglcw.ui.error("查询按钮素材失败！");
            }
        }
    }

    function left2() {
        if ($("#buttonPosition").html() != "left" || $("#buttonNo").html() != "2") {
            clearMenuMaterial();
            var getMenuButtonMaterial_url = "/manager/getMenuButtonMaterial?position=left&button_no=2";
            var msg = $.ajax({url: getMenuButtonMaterial_url, async: false});
            var json = $.parseJSON(msg.responseText);
            var buttonMaterialMap = json.buttonMaterialMap;
            if (json.state) {
                $("#buttonPosition").html(buttonMaterialMap.position);
                $("#buttonNo").html(buttonMaterialMap.button_no);
                $("#buttonName").val(buttonMaterialMap.name);
                $("#buttonType").html(buttonMaterialMap.type);
                switch (buttonMaterialMap.type) {
                    case "url":
                        $("input[name=buttonMaterialContentType][value=url]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'url'});
                        $("#buttonMaterialContentUrl").val(buttonMaterialMap.url);
                        break;
                    case "text":
                        $("input[name=buttonMaterialContentType][value=text]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'text'});
                        $("#buttonMaterialContentTextarea").val(buttonMaterialMap.text);
                        $("#buttonMaterialContentView").hide();
                        $("#menuButtonMaterialContentTextarea").show();
                        $("#menuButtonMaterialContentImage").hide();
                        $("#menuButtonMaterialContentNews").hide();
                        break;
                    case "image":
                        $("input[name=buttonMaterialContentType][value=image]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'image'});
                        $("#buttonImagID").html(buttonMaterialMap.image_id);
                        $("#buttonImage").attr('src', buttonMaterialMap.image_url);
                        $("#buttonMaterialContentView").hide();
                        $("#menuButtonMaterialContentTextarea").hide();
                        $("#menuButtonMaterialContentImage").show();
                        $("#menuButtonMaterialContentNews").hide();
                        break;
                    case "news":
                        $("input[name=buttonMaterialContentType][value=news]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'news'});
                        $("#buttonNewsImageID").html(buttonMaterialMap.media_id);
                        $("#buttonNewsImage").attr('src', buttonMaterialMap.image_url);
                        $("#buttonNewsTitle").html(buttonMaterialMap.news_title);
                        $("#buttonMaterialContentView").hide();
                        $("#menuButtonMaterialContentTextarea").hide();
                        $("#menuButtonMaterialContentImage").hide();
                        $("#menuButtonMaterialContentNews").show();
                        break;
                    default :
                        break;
                }
            } else {
                uglcw.ui.error("查询按钮素材失败！");
            }
        }
    }

    function left3() {
        if ($("#buttonPosition").html() != "left" || $("#buttonNo").html() != "3") {
            clearMenuMaterial();
            var getMenuButtonMaterial_url = "/manager/getMenuButtonMaterial?position=left&button_no=3";
            var msg = $.ajax({url: getMenuButtonMaterial_url, async: false});
            var json = $.parseJSON(msg.responseText);
            var buttonMaterialMap = json.buttonMaterialMap;
            if (json.state) {
                $("#buttonPosition").html(buttonMaterialMap.position);
                $("#buttonNo").html(buttonMaterialMap.button_no);
                $("#buttonName").val(buttonMaterialMap.name);
                $("#buttonType").html(buttonMaterialMap.type);
                switch (buttonMaterialMap.type) {
                    case "url":
                        $("input[name=buttonMaterialContentType][value=url]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'url'});
                        $("#buttonMaterialContentUrl").val(buttonMaterialMap.url);
                        break;
                    case "text":
                        $("input[name=buttonMaterialContentType][value=text]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'text'});
                        $("#buttonMaterialContentTextarea").val(buttonMaterialMap.text);
                        $("#buttonMaterialContentView").hide();
                        $("#menuButtonMaterialContentTextarea").show();
                        $("#menuButtonMaterialContentImage").hide();
                        $("#menuButtonMaterialContentNews").hide();
                        break;
                    case "image":
                        $("input[name=buttonMaterialContentType][value=image]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'image'});
                        $("#buttonImagID").html(buttonMaterialMap.image_id);
                        $("#buttonImage").attr('src', buttonMaterialMap.image_url);
                        $("#buttonMaterialContentView").hide();
                        $("#menuButtonMaterialContentTextarea").hide();
                        $("#menuButtonMaterialContentImage").show();
                        $("#menuButtonMaterialContentNews").hide();
                        break;
                    case "news":
                        $("input[name=buttonMaterialContentType][value=news]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'news'});
                        $("#buttonNewsImageID").html(buttonMaterialMap.media_id);
                        $("#buttonNewsImage").attr('src', buttonMaterialMap.image_url);
                        $("#buttonNewsTitle").html(buttonMaterialMap.news_title);
                        $("#buttonMaterialContentView").hide();
                        $("#menuButtonMaterialContentTextarea").hide();
                        $("#menuButtonMaterialContentImage").hide();
                        $("#menuButtonMaterialContentNews").show();
                        break;
                    default :
                        break;
                }
            } else {
                uglcw.ui.error("查询按钮素材失败！");
            }
        }
    }

    function left4() {
        if ($("#buttonPosition").html() != "left" || $("#buttonNo").html() != "4") {
            clearMenuMaterial();
            var getMenuButtonMaterial_url = "/manager/getMenuButtonMaterial?position=left&button_no=4";
            var msg = $.ajax({url: getMenuButtonMaterial_url, async: false});
            var json = $.parseJSON(msg.responseText);
            var buttonMaterialMap = json.buttonMaterialMap;
            if (json.state) {
                $("#buttonPosition").html(buttonMaterialMap.position);
                $("#buttonNo").html(buttonMaterialMap.button_no);
                $("#buttonName").val(buttonMaterialMap.name);
                $("#buttonType").html(buttonMaterialMap.type);
                switch (buttonMaterialMap.type) {
                    case "url":
                        $("input[name=buttonMaterialContentType][value=url]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'url'});
                        $("#buttonMaterialContentUrl").val(buttonMaterialMap.url);
                        break;
                    case "text":
                        $("input[name=buttonMaterialContentType][value=text]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'text'});
                        $("#buttonMaterialContentTextarea").val(buttonMaterialMap.text);
                        $("#buttonMaterialContentView").hide();
                        $("#menuButtonMaterialContentTextarea").show();
                        $("#menuButtonMaterialContentImage").hide();
                        $("#menuButtonMaterialContentNews").hide();
                        break;
                    case "image":
                        $("input[name=buttonMaterialContentType][value=image]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'image'});
                        $("#buttonImagID").html(buttonMaterialMap.image_id);
                        $("#buttonImage").attr('src', buttonMaterialMap.image_url);
                        $("#buttonMaterialContentView").hide();
                        $("#menuButtonMaterialContentTextarea").hide();
                        $("#menuButtonMaterialContentImage").show();
                        $("#menuButtonMaterialContentNews").hide();
                        break;
                    case "news":
                        $("input[name=buttonMaterialContentType][value=news]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'news'});
                        $("#buttonNewsImageID").html(buttonMaterialMap.media_id);
                        $("#buttonNewsImage").attr('src', buttonMaterialMap.image_url);
                        $("#buttonNewsTitle").html(buttonMaterialMap.news_title);
                        $("#buttonMaterialContentView").hide();
                        $("#menuButtonMaterialContentTextarea").hide();
                        $("#menuButtonMaterialContentImage").hide();
                        $("#menuButtonMaterialContentNews").show();
                        break;
                    default :
                        break;
                }
            } else {
                uglcw.ui.error("查询按钮素材失败！");
            }
        }
    }

    function left5() {
        if ($("#buttonPosition").html() != "left" || $("#buttonNo").html() != "5") {
            clearMenuMaterial();
            var getMenuButtonMaterial_url = "/manager/getMenuButtonMaterial?position=left&button_no=5";
            var msg = $.ajax({url: getMenuButtonMaterial_url, async: false});
            var json = $.parseJSON(msg.responseText);
            var buttonMaterialMap = json.buttonMaterialMap;
            if (json.state) {
                $("#buttonPosition").html(buttonMaterialMap.position);
                $("#buttonNo").html(buttonMaterialMap.button_no);
                $("#buttonName").val(buttonMaterialMap.name);
                $("#buttonType").html(buttonMaterialMap.type);
                switch (buttonMaterialMap.type) {
                    case "url":
                        $("input[name=buttonMaterialContentType][value=url]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'url'});
                        $("#buttonMaterialContentUrl").val(buttonMaterialMap.url);
                        break;
                    case "text":
                        $("input[name=buttonMaterialContentType][value=text]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'text'});
                        $("#buttonMaterialContentTextarea").val(buttonMaterialMap.text);
                        $("#buttonMaterialContentView").hide();
                        $("#menuButtonMaterialContentTextarea").show();
                        $("#menuButtonMaterialContentImage").hide();
                        $("#menuButtonMaterialContentNews").hide();
                        break;
                    case "image":
                        $("input[name=buttonMaterialContentType][value=image]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'image'});
                        $("#buttonImagID").html(buttonMaterialMap.image_id);
                        $("#buttonImage").attr('src', buttonMaterialMap.image_url);
                        $("#buttonMaterialContentView").hide();
                        $("#menuButtonMaterialContentTextarea").hide();
                        $("#menuButtonMaterialContentImage").show();
                        $("#menuButtonMaterialContentNews").hide();
                        break;
                    case "news":
                        $("input[name=buttonMaterialContentType][value=news]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'news'});
                        $("#buttonNewsImageID").html(buttonMaterialMap.media_id);
                        $("#buttonNewsImage").attr('src', buttonMaterialMap.image_url);
                        $("#buttonNewsTitle").html(buttonMaterialMap.news_title);
                        $("#buttonMaterialContentView").hide();
                        $("#menuButtonMaterialContentTextarea").hide();
                        $("#menuButtonMaterialContentImage").hide();
                        $("#menuButtonMaterialContentNews").show();
                        break;
                    default :
                        break;
                }
            } else {
                uglcw.ui.error("查询按钮素材失败！");
            }
        }
    }

    function middle0() {
        if ($("#buttonPosition").html() != "middle" || $("#buttonNo").html() != "0") {
            clearMenuMaterial();
            var getMenuButtonMaterial_url = "/manager/getMenuButtonMaterial?position=middle&button_no=0";
            var msg = $.ajax({url: getMenuButtonMaterial_url, async: false});
            var json = $.parseJSON(msg.responseText);
            var buttonMaterialMap = json.buttonMaterialMap;
            if (json.state) {
                $("#buttonPosition").html(buttonMaterialMap.position);
                $("#buttonNo").html(buttonMaterialMap.button_no);
                $("#buttonName").val(buttonMaterialMap.name);
                $("#buttonType").html(buttonMaterialMap.type);
                switch (buttonMaterialMap.type) {
                    case "url":
                        $("input[name=buttonMaterialContentType][value=url]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'url'});
                        $("#buttonMaterialContentUrl").val(buttonMaterialMap.url);
                        break;
                    case "text":
                        $("input[name=buttonMaterialContentType][value=text]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'text'});
                        $("#buttonMaterialContentTextarea").val(buttonMaterialMap.text);
                        $("#buttonMaterialContentView").hide();
                        $("#menuButtonMaterialContentTextarea").show();
                        $("#menuButtonMaterialContentImage").hide();
                        $("#menuButtonMaterialContentNews").hide();
                        break;
                    case "image":
                        $("input[name=buttonMaterialContentType][value=image]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'image'});
                        $("#buttonImagID").html(buttonMaterialMap.image_id);
                        $("#buttonImage").attr('src', buttonMaterialMap.image_url);
                        $("#buttonMaterialContentView").hide();
                        $("#menuButtonMaterialContentTextarea").hide();
                        $("#menuButtonMaterialContentImage").show();
                        $("#menuButtonMaterialContentNews").hide();
                        break;
                    case "news":
                        $("input[name=buttonMaterialContentType][value=news]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'news'});
                        $("#buttonNewsImageID").html(buttonMaterialMap.media_id);
                        $("#buttonNewsImage").attr('src', buttonMaterialMap.image_url);
                        $("#buttonNewsTitle").html(buttonMaterialMap.news_title);
                        $("#buttonMaterialContentView").hide();
                        $("#menuButtonMaterialContentTextarea").hide();
                        $("#menuButtonMaterialContentImage").hide();
                        $("#menuButtonMaterialContentNews").show();
                        break;
                    default :
                        break;
                }
            } else {
                uglcw.ui.error("查询按钮素材失败！");
            }
        }
    }

    function middle1() {
        if ($("#buttonPosition").html() != "middle" || $("#buttonNo").html() != "1") {
            clearMenuMaterial();
            var getMenuButtonMaterial_url = "/manager/getMenuButtonMaterial?position=middle&button_no=1";
            var msg = $.ajax({url: getMenuButtonMaterial_url, async: false});
            var json = $.parseJSON(msg.responseText);
            var buttonMaterialMap = json.buttonMaterialMap;
            if (json.state) {
                $("#buttonPosition").html(buttonMaterialMap.position);
                $("#buttonNo").html(buttonMaterialMap.button_no);
                $("#buttonName").val(buttonMaterialMap.name);
                $("#buttonType").html(buttonMaterialMap.type);
                switch (buttonMaterialMap.type) {
                    case "url":
                        $("input[name=buttonMaterialContentType][value=url]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'url'});
                        $("#buttonMaterialContentUrl").val(buttonMaterialMap.url);
                        break;
                    case "text":
                        $("input[name=buttonMaterialContentType][value=text]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'text'});
                        $("#buttonMaterialContentTextarea").val(buttonMaterialMap.text);
                        $("#buttonMaterialContentView").hide();
                        $("#menuButtonMaterialContentTextarea").show();
                        $("#menuButtonMaterialContentImage").hide();
                        $("#menuButtonMaterialContentNews").hide();
                        break;
                    case "image":
                        $("input[name=buttonMaterialContentType][value=image]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'image'});
                        $("#buttonImagID").html(buttonMaterialMap.image_id);
                        $("#buttonImage").attr('src', buttonMaterialMap.image_url);
                        $("#buttonMaterialContentView").hide();
                        $("#menuButtonMaterialContentTextarea").hide();
                        $("#menuButtonMaterialContentImage").show();
                        $("#menuButtonMaterialContentNews").hide();
                        break;
                    case "news":
                        $("input[name=buttonMaterialContentType][value=news]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'news'});
                        $("#buttonNewsImageID").html(buttonMaterialMap.media_id);
                        $("#buttonNewsImage").attr('src', buttonMaterialMap.image_url);
                        $("#buttonNewsTitle").html(buttonMaterialMap.news_title);
                        $("#buttonMaterialContentView").hide();
                        $("#menuButtonMaterialContentTextarea").hide();
                        $("#menuButtonMaterialContentImage").hide();
                        $("#menuButtonMaterialContentNews").show();
                        break;
                    default :
                        break;
                }
            } else {
                uglcw.ui.error("查询按钮素材失败！");
            }
        }
    }

    function middle2() {
        if ($("#buttonPosition").html() != "middle" || $("#buttonNo").html() != "2") {
            clearMenuMaterial();
            var getMenuButtonMaterial_url = "/manager/getMenuButtonMaterial?position=middle&button_no=2";
            var msg = $.ajax({url: getMenuButtonMaterial_url, async: false});
            var json = $.parseJSON(msg.responseText);
            var buttonMaterialMap = json.buttonMaterialMap;
            if (json.state) {
                $("#buttonPosition").html(buttonMaterialMap.position);
                $("#buttonNo").html(buttonMaterialMap.button_no);
                $("#buttonName").val(buttonMaterialMap.name);
                $("#buttonType").html(buttonMaterialMap.type);
                switch (buttonMaterialMap.type) {
                    case "url":
                        $("input[name=buttonMaterialContentType][value=url]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'url'});
                        $("#buttonMaterialContentUrl").val(buttonMaterialMap.url);
                        break;
                    case "text":
                        $("input[name=buttonMaterialContentType][value=text]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'text'});
                        $("#buttonMaterialContentTextarea").val(buttonMaterialMap.text);
                        $("#buttonMaterialContentView").hide();
                        $("#menuButtonMaterialContentTextarea").show();
                        $("#menuButtonMaterialContentImage").hide();
                        $("#menuButtonMaterialContentNews").hide();
                        break;
                    case "image":
                        $("input[name=buttonMaterialContentType][value=image]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'image'});
                        $("#buttonImagID").html(buttonMaterialMap.image_id);
                        $("#buttonImage").attr('src', buttonMaterialMap.image_url);
                        $("#buttonMaterialContentView").hide();
                        $("#menuButtonMaterialContentTextarea").hide();
                        $("#menuButtonMaterialContentImage").show();
                        $("#menuButtonMaterialContentNews").hide();
                        break;
                    case "news":
                        $("input[name=buttonMaterialContentType][value=news]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'news'});
                        $("#buttonNewsImageID").html(buttonMaterialMap.media_id);
                        $("#buttonNewsImage").attr('src', buttonMaterialMap.image_url);
                        $("#buttonNewsTitle").html(buttonMaterialMap.news_title);
                        $("#buttonMaterialContentView").hide();
                        $("#menuButtonMaterialContentTextarea").hide();
                        $("#menuButtonMaterialContentImage").hide();
                        $("#menuButtonMaterialContentNews").show();
                        break;
                    default :
                        break;
                }
            } else {
                uglcw.ui.error("查询按钮素材失败！");
            }
        }
    }

    function middle3() {
        if ($("#buttonPosition").html() != "middle" || $("#buttonNo").html() != "3") {
            clearMenuMaterial();
            var getMenuButtonMaterial_url = "/manager/getMenuButtonMaterial?position=middle&button_no=3";
            var msg = $.ajax({url: getMenuButtonMaterial_url, async: false});
            var json = $.parseJSON(msg.responseText);
            var buttonMaterialMap = json.buttonMaterialMap;
            if (json.state) {
                $("#buttonPosition").html(buttonMaterialMap.position);
                $("#buttonNo").html(buttonMaterialMap.button_no);
                $("#buttonName").val(buttonMaterialMap.name);
                $("#buttonType").html(buttonMaterialMap.type);
                switch (buttonMaterialMap.type) {
                    case "url":
                        $("input[name=buttonMaterialContentType][value=url]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'url'});
                        $("#buttonMaterialContentUrl").val(buttonMaterialMap.url);
                        break;
                    case "text":
                        $("input[name=buttonMaterialContentType][value=text]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'text'});
                        $("#buttonMaterialContentTextarea").val(buttonMaterialMap.text);
                        $("#buttonMaterialContentView").hide();
                        $("#menuButtonMaterialContentTextarea").show();
                        $("#menuButtonMaterialContentImage").hide();
                        $("#menuButtonMaterialContentNews").hide();
                        break;
                    case "image":
                        $("input[name=buttonMaterialContentType][value=image]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'image'});
                        $("#buttonImagID").html(buttonMaterialMap.image_id);
                        $("#buttonImage").attr('src', buttonMaterialMap.image_url);
                        $("#buttonMaterialContentView").hide();
                        $("#menuButtonMaterialContentTextarea").hide();
                        $("#menuButtonMaterialContentImage").show();
                        $("#menuButtonMaterialContentNews").hide();
                        break;
                    case "news":
                        $("input[name=buttonMaterialContentType][value=news]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'news'});
                        $("#buttonNewsImageID").html(buttonMaterialMap.media_id);
                        $("#buttonNewsImage").attr('src', buttonMaterialMap.image_url);
                        $("#buttonNewsTitle").html(buttonMaterialMap.news_title);
                        $("#buttonMaterialContentView").hide();
                        $("#menuButtonMaterialContentTextarea").hide();
                        $("#menuButtonMaterialContentImage").hide();
                        $("#menuButtonMaterialContentNews").show();
                        break;
                    default :
                        break;
                }
            } else {
                uglcw.ui.error("查询按钮素材失败！");
            }
        }
    }

    function middle4() {
        if ($("#buttonPosition").html() != "middle" || $("#buttonNo").html() != "4") {
            clearMenuMaterial();
            var getMenuButtonMaterial_url = "/manager/getMenuButtonMaterial?position=middle&button_no=4";
            var msg = $.ajax({url: getMenuButtonMaterial_url, async: false});
            var json = $.parseJSON(msg.responseText);
            var buttonMaterialMap = json.buttonMaterialMap;
            if (json.state) {
                $("#buttonPosition").html(buttonMaterialMap.position);
                $("#buttonNo").html(buttonMaterialMap.button_no);
                $("#buttonName").val(buttonMaterialMap.name);
                $("#buttonType").html(buttonMaterialMap.type);
                switch (buttonMaterialMap.type) {
                    case "url":
                        $("input[name=buttonMaterialContentType][value=url]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'url'});
                        $("#buttonMaterialContentUrl").val(buttonMaterialMap.url);
                        break;
                    case "text":
                        $("input[name=buttonMaterialContentType][value=text]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'text'});
                        $("#buttonMaterialContentTextarea").val(buttonMaterialMap.text);
                        $("#buttonMaterialContentView").hide();
                        $("#menuButtonMaterialContentTextarea").show();
                        $("#menuButtonMaterialContentImage").hide();
                        $("#menuButtonMaterialContentNews").hide();
                        break;
                    case "image":
                        $("input[name=buttonMaterialContentType][value=image]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'image'});
                        $("#buttonImagID").html(buttonMaterialMap.image_id);
                        $("#buttonImage").attr('src', buttonMaterialMap.image_url);
                        $("#buttonMaterialContentView").hide();
                        $("#menuButtonMaterialContentTextarea").hide();
                        $("#menuButtonMaterialContentImage").show();
                        $("#menuButtonMaterialContentNews").hide();
                        break;
                    case "news":
                        $("input[name=buttonMaterialContentType][value=news]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'news'});
                        $("#buttonNewsImageID").html(buttonMaterialMap.media_id);
                        $("#buttonNewsImage").attr('src', buttonMaterialMap.image_url);
                        $("#buttonNewsTitle").html(buttonMaterialMap.news_title);
                        $("#buttonMaterialContentView").hide();
                        $("#menuButtonMaterialContentTextarea").hide();
                        $("#menuButtonMaterialContentImage").hide();
                        $("#menuButtonMaterialContentNews").show();
                        break;
                    default :
                        break;
                }
            } else {
                uglcw.ui.error("查询按钮素材失败！");
            }
        }
    }

    function middle5() {
        if ($("#buttonPosition").html() != "middle" || $("#buttonNo").html() != "5") {
            clearMenuMaterial();
            var getMenuButtonMaterial_url = "/manager/getMenuButtonMaterial?position=middle&button_no=5";
            var msg = $.ajax({url: getMenuButtonMaterial_url, async: false});
            var json = $.parseJSON(msg.responseText);
            var buttonMaterialMap = json.buttonMaterialMap;
            if (json.state) {
                $("#buttonPosition").html(buttonMaterialMap.position);
                $("#buttonNo").html(buttonMaterialMap.button_no);
                $("#buttonName").val(buttonMaterialMap.name);
                $("#buttonType").html(buttonMaterialMap.type);
                switch (buttonMaterialMap.type) {
                    case "url":
                        $("input[name=buttonMaterialContentType][value=url]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'url'});
                        $("#buttonMaterialContentUrl").val(buttonMaterialMap.url);
                        break;
                    case "text":
                        $("input[name=buttonMaterialContentType][value=text]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'text'});
                        $("#buttonMaterialContentTextarea").val(buttonMaterialMap.text);
                        $("#buttonMaterialContentView").hide();
                        $("#menuButtonMaterialContentTextarea").show();
                        $("#menuButtonMaterialContentImage").hide();
                        $("#menuButtonMaterialContentNews").hide();
                        break;
                    case "image":
                        $("input[name=buttonMaterialContentType][value=image]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'image'});
                        $("#buttonImagID").html(buttonMaterialMap.image_id);
                        $("#buttonImage").attr('src', buttonMaterialMap.image_url);
                        $("#buttonMaterialContentView").hide();
                        $("#menuButtonMaterialContentTextarea").hide();
                        $("#menuButtonMaterialContentImage").show();
                        $("#menuButtonMaterialContentNews").hide();
                        break;
                    case "news":
                        $("input[name=buttonMaterialContentType][value=news]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'news'});
                        $("#buttonNewsImageID").html(buttonMaterialMap.media_id);
                        $("#buttonNewsImage").attr('src', buttonMaterialMap.image_url);
                        $("#buttonNewsTitle").html(buttonMaterialMap.news_title);
                        $("#buttonMaterialContentView").hide();
                        $("#menuButtonMaterialContentTextarea").hide();
                        $("#menuButtonMaterialContentImage").hide();
                        $("#menuButtonMaterialContentNews").show();
                        break;
                    default :
                        break;
                }
            } else {
                uglcw.ui.error("查询按钮素材失败！");
            }
        }
    }

    function right0() {
        if ($("#buttonPosition").html() != "right" || $("#buttonNo").html() != "0") {
            clearMenuMaterial();
            var getMenuButtonMaterial_url = "/manager/getMenuButtonMaterial?position=right&button_no=0";
            var msg = $.ajax({url: getMenuButtonMaterial_url, async: false});
            var json = $.parseJSON(msg.responseText);
            var buttonMaterialMap = json.buttonMaterialMap;
            if (json.state) {
                $("#buttonPosition").html(buttonMaterialMap.position);
                $("#buttonNo").html(buttonMaterialMap.button_no);
                $("#buttonName").val(buttonMaterialMap.name);
                $("#buttonType").html(buttonMaterialMap.type);
                switch (buttonMaterialMap.type) {
                    case "url":
                        $("input[name=buttonMaterialContentType][value=url]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'url'});
                        $("#buttonMaterialContentUrl").val(buttonMaterialMap.url);
                        break;
                    case "text":
                        $("input[name=buttonMaterialContentType][value=text]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'text'});
                        $("#buttonMaterialContentTextarea").val(buttonMaterialMap.text);
                        $("#buttonMaterialContentView").hide();
                        $("#menuButtonMaterialContentTextarea").show();
                        $("#menuButtonMaterialContentImage").hide();
                        $("#menuButtonMaterialContentNews").hide();
                        break;
                    case "image":
                        $("input[name=buttonMaterialContentType][value=image]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'image'});
                        $("#buttonImagID").html(buttonMaterialMap.image_id);
                        $("#buttonImage").attr('src', buttonMaterialMap.image_url);
                        $("#buttonMaterialContentView").hide();
                        $("#menuButtonMaterialContentTextarea").hide();
                        $("#menuButtonMaterialContentImage").show();
                        $("#menuButtonMaterialContentNews").hide();
                        break;
                    case "news":
                        $("input[name=buttonMaterialContentType][value=news]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'news'});
                        $("#buttonNewsImageID").html(buttonMaterialMap.media_id);
                        $("#buttonNewsImage").attr('src', buttonMaterialMap.image_url);
                        $("#buttonNewsTitle").html(buttonMaterialMap.news_title);
                        $("#buttonMaterialContentView").hide();
                        $("#menuButtonMaterialContentTextarea").hide();
                        $("#menuButtonMaterialContentImage").hide();
                        $("#menuButtonMaterialContentNews").show();
                        break;
                    default :
                        break;
                }
            } else {
                uglcw.ui.error("查询按钮素材失败！");
            }
        }
    }

    function right1() {
        if ($("#buttonPosition").html() != "right" || $("#buttonNo").html() != "1") {
            clearMenuMaterial();
            var getMenuButtonMaterial_url = "/manager/getMenuButtonMaterial?position=right&button_no=1";
            var msg = $.ajax({url: getMenuButtonMaterial_url, async: false});
            var json = $.parseJSON(msg.responseText);
            var buttonMaterialMap = json.buttonMaterialMap;
            if (json.state) {
                $("#buttonPosition").html(buttonMaterialMap.position);
                $("#buttonNo").html(buttonMaterialMap.button_no);
                $("#buttonName").val(buttonMaterialMap.name);
                $("#buttonType").html(buttonMaterialMap.type);
                switch (buttonMaterialMap.type) {
                    case "url":
                        $("input[name=buttonMaterialContentType][value=url]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'url'});
                        $("#buttonMaterialContentUrl").val(buttonMaterialMap.url);
                        break;
                    case "text":
                        $("input[name=buttonMaterialContentType][value=text]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'text'});
                        $("#buttonMaterialContentTextarea").val(buttonMaterialMap.text);
                        $("#buttonMaterialContentView").hide();
                        $("#menuButtonMaterialContentTextarea").show();
                        $("#menuButtonMaterialContentImage").hide();
                        $("#menuButtonMaterialContentNews").hide();
                        break;
                    case "image":
                        $("input[name=buttonMaterialContentType][value=image]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'image'});
                        $("#buttonImagID").html(buttonMaterialMap.image_id);
                        $("#buttonImage").attr('src', buttonMaterialMap.image_url);
                        $("#buttonMaterialContentView").hide();
                        $("#menuButtonMaterialContentTextarea").hide();
                        $("#menuButtonMaterialContentImage").show();
                        $("#menuButtonMaterialContentNews").hide();
                        break;
                    case "news":
                        $("input[name=buttonMaterialContentType][value=news]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'news'});
                        $("#buttonNewsImageID").html(buttonMaterialMap.media_id);
                        $("#buttonNewsImage").attr('src', buttonMaterialMap.image_url);
                        $("#buttonNewsTitle").html(buttonMaterialMap.news_title);
                        $("#buttonMaterialContentView").hide();
                        $("#menuButtonMaterialContentTextarea").hide();
                        $("#menuButtonMaterialContentImage").hide();
                        $("#menuButtonMaterialContentNews").show();
                        break;
                    default :
                        break;
                }
            } else {
                uglcw.ui.error("查询按钮素材失败！");
            }
        }
    }

    function right2() {
        if ($("#buttonPosition").html() != "right" || $("#buttonNo").html() != "2") {
            clearMenuMaterial();
            var getMenuButtonMaterial_url = "/manager/getMenuButtonMaterial?position=right&button_no=2";
            var msg = $.ajax({url: getMenuButtonMaterial_url, async: false});
            var json = $.parseJSON(msg.responseText);
            var buttonMaterialMap = json.buttonMaterialMap;
            if (json.state) {
                $("#buttonPosition").html(buttonMaterialMap.position);
                $("#buttonNo").html(buttonMaterialMap.button_no);
                $("#buttonName").val(buttonMaterialMap.name);
                $("#buttonType").html(buttonMaterialMap.type);
                switch (buttonMaterialMap.type) {
                    case "url":
                        $("input[name=buttonMaterialContentType][value=url]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'url'});
                        $("#buttonMaterialContentUrl").val(buttonMaterialMap.url);
                        break;
                    case "text":
                        $("input[name=buttonMaterialContentType][value=text]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'text'});
                        $("#buttonMaterialContentTextarea").val(buttonMaterialMap.text);
                        $("#buttonMaterialContentView").hide();
                        $("#menuButtonMaterialContentTextarea").show();
                        $("#menuButtonMaterialContentImage").hide();
                        $("#menuButtonMaterialContentNews").hide();
                        break;
                    case "image":
                        $("input[name=buttonMaterialContentType][value=image]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'image'});
                        $("#buttonImagID").html(buttonMaterialMap.image_id);
                        $("#buttonImage").attr('src', buttonMaterialMap.image_url);
                        $("#buttonMaterialContentView").hide();
                        $("#menuButtonMaterialContentTextarea").hide();
                        $("#menuButtonMaterialContentImage").show();
                        $("#menuButtonMaterialContentNews").hide();
                        break;
                    case "news":
                        $("input[name=buttonMaterialContentType][value=news]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'news'});
                        $("#buttonNewsImageID").html(buttonMaterialMap.media_id);
                        $("#buttonNewsImage").attr('src', buttonMaterialMap.image_url);
                        $("#buttonNewsTitle").html(buttonMaterialMap.news_title);
                        $("#buttonMaterialContentView").hide();
                        $("#menuButtonMaterialContentTextarea").hide();
                        $("#menuButtonMaterialContentImage").hide();
                        $("#menuButtonMaterialContentNews").show();
                        break;
                    default :
                        break;
                }
            } else {
                uglcw.ui.error("查询按钮素材失败！");
            }
        }
    }

    function right3() {
        if ($("#buttonPosition").html() != "right" || $("#buttonNo").html() != "3") {
            clearMenuMaterial();
            var getMenuButtonMaterial_url = "/manager/getMenuButtonMaterial?position=right&button_no=3";
            var msg = $.ajax({url: getMenuButtonMaterial_url, async: false});
            var json = $.parseJSON(msg.responseText);
            var buttonMaterialMap = json.buttonMaterialMap;
            if (json.state) {
                $("#buttonPosition").html(buttonMaterialMap.position);
                $("#buttonNo").html(buttonMaterialMap.button_no);
                $("#buttonName").val(buttonMaterialMap.name);
                $("#buttonType").html(buttonMaterialMap.type);
                switch (buttonMaterialMap.type) {
                    case "url":
                        $("input[name=buttonMaterialContentType][value=url]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'url'});
                        $("#buttonMaterialContentUrl").val(buttonMaterialMap.url);
                        break;
                    case "text":
                        $("input[name=buttonMaterialContentType][value=text]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'text'});
                        $("#buttonMaterialContentTextarea").val(buttonMaterialMap.text);
                        $("#buttonMaterialContentView").hide();
                        $("#menuButtonMaterialContentTextarea").show();
                        $("#menuButtonMaterialContentImage").hide();
                        $("#menuButtonMaterialContentNews").hide();
                        break;
                    case "image":
                        $("input[name=buttonMaterialContentType][value=image]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'image'});
                        $("#buttonImagID").html(buttonMaterialMap.image_id);
                        $("#buttonImage").attr('src', buttonMaterialMap.image_url);
                        $("#buttonMaterialContentView").hide();
                        $("#menuButtonMaterialContentTextarea").hide();
                        $("#menuButtonMaterialContentImage").show();
                        $("#menuButtonMaterialContentNews").hide();
                        break;
                    case "news":
                        $("input[name=buttonMaterialContentType][value=news]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'news'});
                        $("#buttonNewsImageID").html(buttonMaterialMap.media_id);
                        $("#buttonNewsImage").attr('src', buttonMaterialMap.image_url);
                        $("#buttonNewsTitle").html(buttonMaterialMap.news_title);
                        $("#buttonMaterialContentView").hide();
                        $("#menuButtonMaterialContentTextarea").hide();
                        $("#menuButtonMaterialContentImage").hide();
                        $("#menuButtonMaterialContentNews").show();
                        break;
                    default :
                        break;
                }
            } else {
                uglcw.ui.error("查询按钮素材失败！");
            }
        }
    }

    function right4() {
        if ($("#buttonPosition").html() != "right" || $("#buttonNo").html() != "4") {
            clearMenuMaterial();
            var getMenuButtonMaterial_url = "/manager/getMenuButtonMaterial?position=right&button_no=4";
            var msg = $.ajax({url: getMenuButtonMaterial_url, async: false});
            var json = $.parseJSON(msg.responseText);
            var buttonMaterialMap = json.buttonMaterialMap;
            if (json.state) {
                $("#buttonPosition").html(buttonMaterialMap.position);
                $("#buttonNo").html(buttonMaterialMap.button_no);
                $("#buttonName").val(buttonMaterialMap.name);
                $("#buttonType").html(buttonMaterialMap.type);
                switch (buttonMaterialMap.type) {
                    case "url":
                        $("input[name=buttonMaterialContentType][value=url]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'url'});
                        $("#buttonMaterialContentUrl").val(buttonMaterialMap.url);
                        break;
                    case "text":
                        $("input[name=buttonMaterialContentType][value=text]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'text'});
                        $("#buttonMaterialContentTextarea").val(buttonMaterialMap.text);
                        $("#buttonMaterialContentView").hide();
                        $("#menuButtonMaterialContentTextarea").show();
                        $("#menuButtonMaterialContentImage").hide();
                        $("#menuButtonMaterialContentNews").hide();
                        break;
                    case "image":
                        $("input[name=buttonMaterialContentType][value=image]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'image'});
                        $("#buttonImagID").html(buttonMaterialMap.image_id);
                        $("#buttonImage").attr('src', buttonMaterialMap.image_url);
                        $("#buttonMaterialContentView").hide();
                        $("#menuButtonMaterialContentTextarea").hide();
                        $("#menuButtonMaterialContentImage").show();
                        $("#menuButtonMaterialContentNews").hide();
                        break;
                    case "news":
                        $("input[name=buttonMaterialContentType][value=news]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'news'});
                        $("#buttonNewsImageID").html(buttonMaterialMap.media_id);
                        $("#buttonNewsImage").attr('src', buttonMaterialMap.image_url);
                        $("#buttonNewsTitle").html(buttonMaterialMap.news_title);
                        $("#buttonMaterialContentView").hide();
                        $("#menuButtonMaterialContentTextarea").hide();
                        $("#menuButtonMaterialContentImage").hide();
                        $("#menuButtonMaterialContentNews").show();
                        break;
                    default :
                        break;
                }
            } else {
                uglcw.ui.error("查询按钮素材失败！");
            }
        }
    }

    function right5() {
        if ($("#buttonPosition").html() != "right" || $("#buttonNo").html() != "5") {
            clearMenuMaterial();
            var getMenuButtonMaterial_url = "/manager/getMenuButtonMaterial?position=right&button_no=5";
            var msg = $.ajax({url: getMenuButtonMaterial_url, async: false});
            var json = $.parseJSON(msg.responseText);
            var buttonMaterialMap = json.buttonMaterialMap;
            if (json.state) {
                $("#buttonPosition").html(buttonMaterialMap.position);
                $("#buttonNo").html(buttonMaterialMap.button_no);
                $("#buttonName").val(buttonMaterialMap.name);
                $("#buttonType").html(buttonMaterialMap.type);
                switch (buttonMaterialMap.type) {
                    case "url":
                        $("input[name=buttonMaterialContentType][value=url]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'url'});
                        $("#buttonMaterialContentUrl").val(buttonMaterialMap.url);
                        break;
                    case "text":
                        $("input[name=buttonMaterialContentType][value=text]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'text'});
                        $("#buttonMaterialContentTextarea").val(buttonMaterialMap.text);
                        $("#buttonMaterialContentView").hide();
                        $("#menuButtonMaterialContentTextarea").show();
                        $("#menuButtonMaterialContentImage").hide();
                        $("#menuButtonMaterialContentNews").hide();
                        break;
                    case "image":
                        $("input[name=buttonMaterialContentType][value=image]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'image'});
                        $("#buttonImagID").html(buttonMaterialMap.image_id);
                        $("#buttonImage").attr('src', buttonMaterialMap.image_url);
                        $("#buttonMaterialContentView").hide();
                        $("#menuButtonMaterialContentTextarea").hide();
                        $("#menuButtonMaterialContentImage").show();
                        $("#menuButtonMaterialContentNews").hide();
                        break;
                    case "news":
                        $("input[name=buttonMaterialContentType][value=news]").attr("checked", true);
                        uglcw.ui.bind('body', {radio: 'news'});
                        $("#buttonNewsImageID").html(buttonMaterialMap.media_id);
                        $("#buttonNewsImage").attr('src', buttonMaterialMap.image_url);
                        $("#buttonNewsTitle").html(buttonMaterialMap.news_title);
                        $("#buttonMaterialContentView").hide();
                        $("#menuButtonMaterialContentTextarea").hide();
                        $("#menuButtonMaterialContentImage").hide();
                        $("#menuButtonMaterialContentNews").show();
                        break;
                    default :
                        break;
                }
            } else {
                uglcw.ui.error("查询按钮素材失败！");
            }
        }
    }

    function deleteButtonMaterial() {
        var buttonPosition = $("#buttonPosition").html();
        var button_no = $("#buttonNo").html();
        if (buttonPosition != "" && button_no != "") {
            uglcw.ui.confirm("是否要删除当前按钮?", function () {
                var deleteMenuButton_url = "/manager/deleteMenuButton?position=" + buttonPosition + "&button_no=" + button_no;
                var msg = $.ajax({url: deleteMenuButton_url, async: false});
                var json = $.parseJSON(msg.responseText);
                if (json.state) {
                    uglcw.ui.success("删除成功！");
                    refresh();
                } else {
                    uglcw.ui.error("删除失败！");
                }
            })
        }
    }

    function updateWeixinMenu() {
        if ($("#left0").html() == "") {
            uglcw.ui.error("没有菜单按钮！");
            return;
        }
        uglcw.ui.confirm('是否确定同步菜单到公众号', function () {
            uglcw.ui.loading();
            var msg = $.ajax({url: "/manager/mall/weixinMenu/updateWeixinMenuButton", async: false});
            uglcw.ui.loaded();
            var json = $.parseJSON(msg.responseText);
            if (json.state)
                uglcw.ui.success("微信菜单更新成功！自定义菜单设置成功！");
            else {
                uglcw.ui.error("微信菜单更新失败！" + json.message);
            }
        })

    }

    function setuglcwShopUrl(version) {
        //var getuglcwShopUrl_url="/manager/WeixinConfig/getuglcwShopUrl";
        var getuglcwShopUrl_url = "/manager/WeixinConfig/getMallIndexUrl";
        var msg = $.ajax({url: getuglcwShopUrl_url, async: false});
        var json = $.parseJSON(msg.responseText);
        $("#buttonName").val();
        if (json.state) {
            $("#buttonName").val("直购商城");
            if (version)
                version = '&v=' + version;
            else
                version = '';
            $("#buttonMaterialContentUrl").val(json.shopUrl + version);
        } else {
            uglcw.ui.error(json.msg || "获取商城地址失败！");
        }
    }

</script>
</body>
</html>
