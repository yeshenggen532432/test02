<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>支付宝设置</title>
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
        <div class="layui-col-md12">
            <div class="layui-card header">
                <div class="layui-card-body">
                    <div class="form-horizontal" uglcw-role="validator">
                        <input uglcw-role="textbox" uglcw-model="id" id="id" value="${zfbset.id}" type="hidden" >
                        <%--<input uglcw-role="textbox" uglcw-model="status" id="status" value="${wxset.status}" type="hidden" >--%>

                        <div class="form-group">
                            <label class="control-label col-xs-3">*连锁店</label>
                            <div class="col-xs-5">
                                <tag:select2 name="shopNo" id="shopNo" tableName="pos_shopinfo"  displayKey="shop_no" displayValue="shop_name" onchange="queryWxset()"/>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3">pid</label>
                            <div class="col-xs-16">
                                <input style="width: 312px;" uglcw-model="pid" id="pid" uglcw-role="textbox" value="${zfbset.pid}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3">appid</label>
                            <div class="col-xs-16">
                                <input style="width: 312px;" uglcw-model="appid" id="appid" uglcw-role="textbox" value="${zfbset.appid}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3">商户私钥</label>
                            <div class="col-xs-16">
                                <input style="width: 312px;" uglcw-model="privateKey" id="privateKey" uglcw-role="textbox" value="${zfbset.privateKey}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3">商户公钥</label>
                            <div class="col-xs-16">
                                <input style="width: 312px;" uglcw-model="publicKey" id="publicKey" uglcw-role="textbox" value="${zfbset.publicKey}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3">支付宝公钥</label>
                            <div class="col-xs-16">
                                <input style="width: 312px;" uglcw-model="alipayPublicKey" id="alipayPublicKey" uglcw-role="textbox" value="${zfbset.alipayPublicKey}">
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="control-label col-xs-3" for="status">启用支付宝否</label>
                            <div class="col-xs-16">
                                <input type="checkbox" id="status" uglcw-model="status" uglcw-role="checkbox" uglcw-options="type:'number'" uglcw-value="${wxset.status}">
                                <label for="status"></label>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3"></label>
                            <div class="col-xs-16">
                                <button onclick="javascript:toSumbit();" class="k-button k-info">保存</button>
                            </div>
                        </div>

                    </div>
                </div>

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
        })

        var delay;
        function resize() {
            if (delay) {
                clearTimeout(delay);
            }
            delay = setTimeout(function () {
                // var grid = uglcw.ui.get('#grid').k();
                // var padding = 15;
                // var height = $(window).height() - padding - $('.header').height() - 40;
                // grid.setOptions({
                // 	height: height,
                // 	autoBind: true
                // })
            }, 200)
        }

        //-----------------------------------------------------------------------------------------



        function toSumbit() {
            var valid = uglcw.ui.get('.form-horizontal').validate();
            if (!valid) {
                return false;
            }
            var data = uglcw.ui.bind('.form-horizontal');
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/pos/savePosZfbSet',
                type: 'post',
                data: data,
                async: false,
                success: function (resp) {
                    uglcw.ui.loaded();
                    if (resp == '1') {
                        uglcw.ui.toast('保存成功');
                    }else {
                        uglcw.ui.error('保存失败');
                    }
                }
            })
        }


        //切换连锁店
        function queryWxset(){
            var shopNo = $("#shopNo").val();
            $.ajax({
                url:"${base}manager/pos/queryZfbSet",
                data:"shopNo=" + shopNo,
                type:"post",
                success:function(data){
                    if(data){
                        var list = data.rows;
                        if(list.length> 0){
                            uglcw.ui.bind($('.form-horizontal'), list[0]);
                        }else{
                            uglcw.ui.get('#id').value('');
                            uglcw.ui.get('#pid').value('');
                            uglcw.ui.get('#appid').value('');
                            uglcw.ui.get('#privateKey').value('');
                            uglcw.ui.get('#publicKey').value('');
                            uglcw.ui.get('#alipayPublicKey').value('');
                            uglcw.ui.get('#status').value(1);
                        }
                    }
                }
            });



        }

    </script>
</body>
</html>
