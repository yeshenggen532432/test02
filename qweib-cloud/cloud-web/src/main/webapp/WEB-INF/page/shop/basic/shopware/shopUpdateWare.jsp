<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>企微宝</title>
    <%@include file="/WEB-INF/page/include/source.jsp"%>
    <script type="text/javascript" src="<%=basePath%>/resource/wangEditor/wangEditor.min.js" ></script>
    <link rel="stylesheet" type="text/css" href="<%=basePath%>/resource/shop/pc/css/cropper.css">
    <script type="text/javascript" src="<%=basePath%>/resource/shop/pc/js/cropper.js"></script>
    <style type="text/css">
        .divDel{
            position: relative;
            width:150px;
            height:150px;
            margin:15px 0px 5px;
        }
        .imgDel{
            width:20px;
            height:20px;
            position: absolute;
            right: 5px;
            top: 5px;
        }
        .left_title{width:200px; display:inline-block; text-align:left; padding-left:30px}
        .right_input{width: 100px;font-size: 13px}

        .warn{
            font-size:10px;
            color:#ff0000;
        }
        .img-container{
            background-color: #f7f7f7;
            text-align: center;
            width: 825px;
            height: 497px;
        }
        .img-container > img {
            max-width: 100%;
        }
        #editor{
            width: 800px;
        }
        .w-e-text-container{
            height: 500px !important;
        }
    </style>
</head>
<body>
<form action="" name="warefrm" id="warefrm" method="post" enctype="multipart/form-data">
    <input type="hidden" name="wareId" id="wareId" value="${ware.wareId}"/>
    <input type="hidden" name="wtype" id="wtype" value="${wtype}"/>
    <input type="hidden" name="groupIds" id="groupIds" value="${groupIds}"/>

    <!-- ================= tab=================== -->
    <div id="easyTabs" class="easyui-tabs" style="width:auto;height:auto;">
        <!-- ================= 基础开始=================== -->
        <div title="商品信息" style="padding:20px;">
            <div class="box" >
                <dl id="dl1" style="font-size: 13px">
                    <!-- ================= 基础结束 =================== -->
                    <fieldset style="width:99%;border:1px dotted skyblue;-moz-border-radius: 5px;
					-webkit-border-radius: 5px;
					-khtml-border-radius: 5px;
					border-radius: 5px;" class="showClass">
                        <legend  style="border:0px;background-color:white;font-size: 13px;color:teal">一、商品基本信息</legend>
                        <dd>
                            <span class="left_title">1.商品名称*：</span>
                            <input class="reg_input" name="wareNm" id="wareNm" value="${ware.wareNm}" style="width: 150px;font-size: 13px" disabled/>
                        </dd>
                        <dd>
                            <span class="left_title">(一) 大单位信息</span>
                        </dd>
                        <dd>
                            <span class="left_title">1.大单位名称*：</span>
                            <input class="reg_input right_input" name="wareDw" id="wareDw" value="${ware.wareDw}" disabled/>
                        </dd>
                        <dd>
                            <span class="left_title">2.大单位规格*：</span>
                            <input class="reg_input right_input" name="wareGg" id="wareGg" value="${ware.wareGg}" disabled/>
                        </dd>
                        <dd>
                            <span class="left_title">3.大单位条码：</span>
                            <input class="reg_input right_input" name="packBarCode" id="packBarCode" value="${ware.packBarCode}" disabled/>
                        </dd>
                        <dd>
                            <span class="left_title">4.大单位批发价*：</span>
                            <input class="reg_input right_input" name="wareDj" id="wareDj" value="${ware.wareDj}"  disabled/>
                        </dd>
                        <dd>
                            <span class="left_title">5.大单位原价：</span>
                            <input class="reg_input right_input" name="lsPrice" id="lsPrice" value="${ware.lsPrice}"  disabled/>
                        </dd>
                        <dd>
                            <span class="left_title">(二) 小单位信息</span>
                        </dd>
                        <dd>
                            <span class="left_title">1.小单位名称*：</span>
                            <input class="reg_input right_input" name="minUnit" id="minUnit" value="${ware.minUnit}" disabled/>
                        </dd>
                        <dd>
                            <%--备注smallWareGg数据库暂时没有--%>
                            <span class="left_title">2.小单位规格*：</span>
                            <input class="reg_input right_input" name="minWareGg" id="minWareGg" value="${ware.minWareGg}" disabled/>
                        </dd>
                        <dd>
                            <span class="left_title">3.小单位条码：</span>
                            <input class="reg_input right_input" name="beBarCode" id="beBarCode" value="${ware.beBarCode}" disabled/>
                        </dd>
                        <dd>
                            <span class="left_title">4.小单位批发价*：</span>
                            <input class="reg_input right_input" name="sunitPrice" id="sunitPrice" value="${ware.sunitPrice}"  disabled/>
                        </dd>
                        <dd>
                            <%--备注smallLsPrice数据库暂时没有--%>
                            <span class="left_title">5.小单位原价：</span>
                            <input class="reg_input right_input" name="minLsPrice" id="minLsPrice" value="${ware.minLsPrice}" disabled/>
                        </dd>
                    </fieldset>

                    <fieldset style="width:99%;border:1px dotted skyblue;-moz-border-radius: 5px;
					-webkit-border-radius: 5px;
					-khtml-border-radius: 5px;
					border-radius: 5px;" class="showClass">
                        <legend  style="border:0px;background-color:white;font-size: 13px;color:teal">二、自营商城商品信息</legend>
                        <dd>
                            <span class="left_title">1.自营商城商品别称：</span>
                            <input class="reg_input right_input" name="shopWareAlias" id="shopWareAlias" value="${ware.shopWareAlias}" />
                        </dd>
                        <dd>
                            <span class="left_title">2.自营商城商品大单位：</span>
                            是否显示<input type="checkbox" name="shopWarePriceShow" value="1" <c:if test="${ware.shopWarePriceShow==1}">checked</c:if> onchange="return priceShowChange(this)">
                            &nbsp;&nbsp;默认单位<input type="radio" name="shopWarePriceDefault" value="0" <c:if test="${ware.shopWarePriceDefault==0}">checked</c:if>>
                        </dd>
                        <dd style="display: none">
                            <span class="left_title">3.自营商城商品大单位批发价：</span>
                            <input class="reg_input right_input" name="shopWarePrice" id="shopWarePrice" value="${ware.shopWarePrice}"/>
                        </dd>
                        <dd>
                            <span class="left_title">3.自营商城商品大单原价：</span>
                            <input class="reg_input right_input" name="shopWareLsPrice" id="shopWareLsPrice" value="${ware.shopWareLsPrice}" title="请在商品价格设置菜单中进行原价统一设置"/>
                        </dd>
                        <dd style="display: none">
                            <span class="left_title">5.自营商城商品大单位促销价：</span>
                            <input class="reg_input right_input" name="shopWareCxPrice" id="shopWareCxPrice" value="${ware.shopWareCxPrice}" />
                        </dd>
                        <dd>
                            <span class="left_title">4.自营商城商品小单位：</span>
                            是否显示<input type="checkbox" name="shopWareSmallPriceShow" value="1" <c:if test="${ware.shopWareSmallPriceShow==1}">checked</c:if> onchange="return priceShowChange(this)">
                            &nbsp;&nbsp;默认单位<input type="radio" name="shopWarePriceDefault" value="1" <c:if test="${ware.shopWarePriceDefault==1}">checked</c:if>>
                        </dd>
                        <dd style="display: none">
                            <span class="left_title">7.自营商城商品小单位批发价：</span>
                            <input class="reg_input right_input" name="shopWareSmallPrice" id="shopWareSmallPrice" value="${ware.shopWareSmallPrice}" />
                        </dd>
                        <dd>
                            <span class="left_title">5.自营商城商品小单位原价：</span>
                            <input class="reg_input right_input" name="shopWareSmallLsPrice" id="shopWareSmallLsPrice" value="${ware.shopWareSmallLsPrice}"/>
                        </dd>
                        <dd style="display: none">
                            <span class="left_title">9.自营商城商品小单位促销价：</span>
                            <input class="reg_input right_input" name="shopWareSmallCxPrice" id="shopWareSmallCxPrice" value="${ware.shopWareSmallCxPrice}" />
                        </dd>
                    </fieldset>
                </dl>
            </div>
        </div>
        <!-- ================= 商品信息：结束 =================== -->

        <!-- ================= 商品描述：开始 =================== -->
        <div title="商品描述" style="padding:20px;">
            <div class="box" ><dl id="dl3" style="font-size: 13px"><dd><div id="editor">${ware.wareDesc=="null"?"":ware.wareDesc}</div></dd></dl></div>
        </div>
        <!-- ================= 商品描述 =================== -->

        <!-- ================= 图片开始=================== -->
        <div title="商品图片" style="overflow:auto;padding:20px;">
            <span class="warn">建议图片规格(400*400)</span>
            <dl id="dl2">
                <c:if test="${empty ware.warePicList}">
                    <dd id="ddphoto1">
                        <div class="divDel">
                            <img id="photoImg21" alt="" style="width: 100%;height: 100%" src="resource/images/login_bg.jpg">
                            <img class="imgDel" alt=""   style="width: 20px;height: 20px;" src="resource/shop/mobile/images/delete_1.png" onclick="deleteRows(1);"/>
                        </div>
                        <div id="editDiv2" >
                            <input type="file" accept="image/*" name="file1" id="file1" class="uploadFile" classId="1"/>
                        </div>
                    </dd>
                </c:if>

                <c:if test="${!empty ware.warePicList}">
                    <c:forEach items="${ware.warePicList}" var="item" varStatus="s">
                        <dd id="ddphoto${s.index+1}">
                            <input type="hidden" name="subId" id="subId${s.index+1}" value="${item.id}"/>
                            <c:set var="subIds" value="${subIds},${item.id },"/>
                            <div class="divDel" >
                                <c:if test="${!empty item.pic}">
                                    <img id="photoImg2${s.index+1}" alt=""   style="width: 100%;height: 100%" data-id="${item.id}" src="upload/${item.pic}" picMini="${item.picMini}" pic="${item.pic}"/>
                                </c:if>
                                <c:if test="${empty item.pic}">
                                    <img id="photoImg2${s.index+1}" alt=""   style="width: 100%;height: 100%" src="resource/images/login_bg.jpg"/>
                                </c:if>
                                <img class="imgDel" alt=""   style="width: 20px;height: 20px;" src="resource/shop/mobile/images/delete_1.png" onclick="deleteRows('${s.index+1}');"/>
                            </div>

                            <div id="editDiv${s.index+1}" >
                                <a class="easyui-linkbutton" iconcls="icon-edit" href="javascript:void(0);" onclick="modifyRows('${s.index+1}');">编辑</a>
                            </div>
                        </dd>
                    </c:forEach>
                </c:if>
            </dl>
            <dd style="margin:20px 0px;">
                <a class="easyui-linkbutton" iconcls="icon-add" href="javascript:void(0);" onclick="addRows(this);">增加图片</a>
            </dd>
        </div>
        <!-- ================= 图片结束=================== -->
    </div>

    <!-- 保存；返回 -->
    <div class="f_reg_but" style="clear:both">
        <input type="button" value="保存" class="l_button" onclick="toSubmit();"/>
        <input type="button" value="返回" class="b_button" onclick="toBack();"/>
    </div>

</form>

<%--图片裁剪：开始--%>
<div id="w" class="easyui-window" title="图片裁剪" data-options="iconCls:'icon-save',closed:true" style="width: 825px;height: 538px;">
    <%--裁剪的原图片，按钮--%>
    <div style="margin: 10px">
        <button id="cropper" type="button" class="easyui-linkbutton" >保存裁剪</button>
    </div>
    <div class="img-container">
        <img id="image" src="" alt="Picture">
    </div>
</div>
<%--图片裁剪：结束--%>

<script type="text/javascript">

    window.onload = function(){
        warBaseInfo();
        wangEditorConfig();
        priceShowChange(null,true);
    }

    //富文本配置
    var editor;
    function wangEditorConfig(){
        var E = window.wangEditor
        editor = new E('#editor');
        editor.customConfig.uploadImgServer = "/manager/photo/wangEditorUpload";
        editor.customConfig.uploadFileName = "file";
        editor.customConfig.uploadImgMaxSize = 3 * 1024 * 1024;
        editor.customConfig.uploadImgMaxLength = 5;
        editor.customConfig.uploadImgHooks = {
            before: function (xhr, editor, files) {
            },
            success: function (xhr, editor, result) {
            },
            fail: function (xhr, editor, result) {
            },
            error: function (xhr, editor) {
            },
            timeout: function (xhr, editor) {
            },
        }
        editor.customConfig.customAlert = function (info) {
            alert("自定义提示：" + info);
        }
        editor.create();
    }


    //提交
    var formData = new FormData();
    function toSubmit(){
        //取得富文本HTML内容
        var html = editor.txt.html();
        /*if("<p><br></p>"==html){
            html=null;
        }*/

        formData.append("wareId",$("#wareId").val());
        formData.append("shopWareAlias",$("#shopWareAlias").val());
        formData.append("shopWarePrice",$("#shopWarePrice").val());
        formData.append("shopWareLsPrice",$("#shopWareLsPrice").val());
        formData.append("shopWareCxPrice",$("#shopWareCxPrice").val());
        formData.append("shopWareSmallPrice",$("#shopWareSmallPrice").val());
        formData.append("shopWareSmallLsPrice",$("#shopWareSmallLsPrice").val());
        formData.append("shopWareSmallCxPrice",$("#shopWareSmallCxPrice").val());

        formData.append("shopWarePriceShow",$("input[name='shopWarePriceShow']").prop('checked')?1:0);
        formData.append("shopWareSmallPriceShow",$("input[name='shopWareSmallPriceShow']").prop('checked')?1:0);
        formData.append("shopWarePriceDefault",$("input:radio[name='shopWarePriceDefault']:checked").val());

        //formData.append("delPicIds",delPicIds);
        formData.append("html",html);
        var imgItems=[];
        $(".divDel").each(function(i,item){
            var imgItem={};
            $("img",item).each(function(j,img){
                if($(img).attr("picMini")){
                    imgItem.pic=$(img).attr("pic");
                    imgItem.picMini=$(img).attr("picMini");
                    imgItem.id=$(img).attr("data-id");
                    imgItems.push(imgItem);
                }
            });
        });


        formData.append("pics",JSON.stringify(imgItems));

        $.ajax({
            url:"manager/shopWare/updateWare",
            type: "POST",
            data: formData,
            processData: false,
            contentType: false,
            success:function(data){
                if(data=="1"){
                    alert("添加成功");
                    toBack();
                }else if(data=="2"){
                    alert("修改成功");
                    formData = null;
                    formData = new FormData();
                    toBack();
                }else if(data=="-2"){
                    alert("该商品名称已存在了");
                    return;
                }else if(data=="-3"){
                    alert("该商品编码已存在了");
                    return;
                }else{
                    alert("操作失败");
                }
            },
            error:function(data) {
            },
        });
    }
    //返回
    function toBack(){
        window.close();
        var groupIds=$("#groupIds").val();
        if(groupIds!=null && groupIds!=""){
            location.href="${base}/manager/shopWare/toPage?groupIds="+groupIds;
        }else{
            location.href="${base}/manager/shopWare/toPage?wtype="+$("#wtype").val();
        }
    }

    //--------------------图片相关：开始-----------------

    //添加照片
    var index="${len}";
    var len=${len};//记录个数
    function addRows(obj){
        index++;
        var strs = "<dd id=\"ddphoto"+index+"\">";
        strs+="<span class=\"title\">";
        strs+="<div class=\"divDel\" >";
        strs+="<img id=\"photoImg2"+index+"\" alt=\"\" style=\"width: 100%;height: 100%\" src=\"resource/images/login_bg.jpg\" />";
        strs+="<img class=\"imgDel\" src=\"resource/shop/mobile/images/delete_1.png\" onclick=\"deleteRows('"+index+"');\" />"
        strs+="</div>";
        strs+="<div id=\"editDiv"+index+"\">";
        strs+="<input type=\"file\" accept=\"image/*\" name=\"file"+index+"\" id=\"file"+index+"\" class=\"uploadFile\" classId='"+index+"'/>";
        strs+="</div>";
        strs+="</dd>";
        $("#dl2").append(strs);
    }

    //删除照片
    //var delPicIds="";
    function deleteRows(c){
        var picId = $("#subId"+c).val();
        if(picId!=null && picId!=undefined && picId!=""){
            //记录删除的图片id
            /*if(delPicIds==""){
                delPicIds=""+picId;
            }else{
                delPicIds+=","+picId;
            }*/
        }
        var ddphoto = document.getElementById("ddphoto"+c);
        ddphoto.parentNode.removeChild(ddphoto);
    }

    //编辑图片
    function modifyRows(n){
        var str="<input type='file' accept='image/*' name='file"+n+"' id='file"+n+"' class='uploadFile' classId='"+n+"'/>";
        if($("#file"+n+"").length>0){
        }else{
            $("#editDiv"+n).append(str);
        }
    }

    //裁剪
    var classId;
    var uploadedImageName;
    var uploadedImageType;
    var uploadedImageURL;
    var URL = window.URL || window.webkitURL;
    var options = {
        aspectRatio: 80 / 85,
        preview: '.img-preview',
    };
    $("#dl2").on('change','.uploadFile',function () {
        $("#w").window('open');
        classId = this.getAttribute("classId");
        console.log("classId:"+classId);
        var files = this.files;
        var file;
        if (files && files.length) {
            file = files[0];
            if (/^image\/\w+$/.test(file.type)) {
                uploadedImageName = file.name;
                uploadedImageType = file.type;
            }
            uploadedImageURL = URL.createObjectURL(file);
            $("#image").cropper('destroy').attr('src', uploadedImageURL).cropper(options);
            $("#dl2 #file"+classId).val('');
        }else{
            window.alert('请选择图片文件');
        }
    });

    $("#cropper").on('click',function () {
        $("#w").window('close');
        var cropCanvas = $('#image').cropper('getCroppedCanvas');
        var cropUrl = cropCanvas.toDataURL(uploadedImageType, 0.4);
        $("#dl2 #photoImg2"+classId).attr('src',cropUrl);

        cropCanvas.toBlob(function(blob) {
            //通过has(key)来判断是否存在对应的key值
          /*  if(formData.has("file"+classId)){
                formData.set("file"+classId, blob, uploadedImageName);
            }else{
                formData.append("file"+classId, blob, uploadedImageName);
            }*/
            var formImgData = new FormData();
            formImgData.append("file"+classId, blob, uploadedImageName);
            $.ajax({
                url:"manager/shopWare/updatePhotos",
                type: "POST",
                data: formImgData,
                processData: false,
                contentType: false,
                success:function(data){
                    if(data){
                        $("#dl2 #photoImg2"+classId).attr('picMini',data.smallFile);
                        $("#dl2 #photoImg2"+classId).attr('pic',data.fileNames);
                    }
                }
            });


            $('#image').attr('src','');
        })

        //修改时记录要删除的图片id
       /* if(Number(len)>=Number(classId)){
            var picId = $("#subId"+classId).val();
            console.log("picId:"+picId);
            if(picId!=null && picId!=undefined && picId!=""){
                //记录删除的图片id
                if(delPicIds==""){
                    delPicIds=""+picId;
                }else{
                    delPicIds+=","+picId;
                }
                console.log(delPicIds);
            }
        }*/
    })
    //--------------------图片相关：结束-----------------

    function warBaseInfo() {
        var wareDj = "${ware.wareDj}";
        var lsPrice = "${ware.lsPrice}";
        var shopWarePrice = "${ware.shopWarePrice}";
        var shopWareLsPrice = "${ware.shopWareLsPrice}";

        if(shopWarePrice == null || shopWarePrice == undefined || shopWarePrice == ''){
            $("#shopWarePrice").val(wareDj);
        }else{
            $("#shopWarePrice").val(shopWarePrice);
        }
        if(shopWareLsPrice == null || shopWareLsPrice == undefined || shopWareLsPrice == ''){
            $("#shopWareLsPrice").val(lsPrice);
        }else{
            $("#shopWareLsPrice").val(shopWareLsPrice);
        }
    }

    //大小单位显示和默认切换方法
    function priceShowChange(th,load){
        var shopWarePriceShow=$("input[name='shopWarePriceShow']").prop('checked');
        var shopWareSmallPriceShow=$("input[name='shopWareSmallPriceShow']").prop('checked');
        var shopWarePriceDefault0=$("input:radio[name='shopWarePriceDefault'][value='0']");//大单位默认
        var shopWarePriceDefault1=$("input:radio[name='shopWarePriceDefault'][value='1']");

        if(!shopWarePriceShow&&!shopWareSmallPriceShow){//两个同时不显示
            $(th).prop("checked",true);
             alert("大小单位不能两个同时隐藏");
            return false;
        }
        if(!$("#wareDw").val()&&!$("#wareGg").val()&&!$("#minUnit").val()&&!$("#minWareGg").val()){
            alert("大小单位名称或规格不能同时为空");
            return false;
        }
        //如果显示大单位时验证名称和规格是否有填写
        if(shopWarePriceShow&&!$("#wareDw").val()&&!$("#wareGg").val()){
            if(!load)
                alert("大单位名称规格未设置");
            $("input[name='shopWarePriceShow']").prop('checked',false);
            //$("input[name='shopWareSmallPriceShow']").prop('checked',true);
            $(shopWarePriceDefault0).prop("checked",false);
            $(shopWarePriceDefault0).prop("disabled",true);
            $(shopWarePriceDefault1).prop("checked",true);
            return false;
        }
        //如果显示小单位时验证名称和规格是否有填写
        if(shopWareSmallPriceShow&&!$("#minUnit").val()&&!$("#minWareGg").val()){
            if(!load)
                alert("小单位名称规格未设置");
            $("input[name='shopWarePriceShow']").prop('checked',true);
            $("input[name='shopWareSmallPriceShow']").prop('checked',false);
            $(shopWarePriceDefault1).prop("checked",false);
            $(shopWarePriceDefault1).prop("disabled",true);
            $(shopWarePriceDefault0).prop("checked",true);
            return false;
        }

        //如果大单位不显示时默认需要选中小单位
        if(!shopWarePriceShow&&shopWareSmallPriceShow){//大单位不显示
            $(shopWarePriceDefault1).prop("checked",true);
            $(shopWarePriceDefault0).prop("disabled",true);
            $(shopWarePriceDefault1).prop("disabled",false);
        }else if(shopWarePriceShow&&!shopWareSmallPriceShow){//小单位不显示
            $(shopWarePriceDefault0).prop("checked",true);
            $(shopWarePriceDefault1).prop("disabled",true);
            $(shopWarePriceDefault0).prop("disabled",false);
        }else{
            $(shopWarePriceDefault0).prop("disabled",false);
            $(shopWarePriceDefault1).prop("disabled",false);
        }
    }
</script>
</body>
</html>
