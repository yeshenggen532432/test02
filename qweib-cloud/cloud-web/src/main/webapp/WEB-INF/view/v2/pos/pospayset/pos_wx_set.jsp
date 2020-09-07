<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>微信支付设置</title>
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
                        <input uglcw-role="textbox" uglcw-model="id" id="id" value="${wxset.id}" type="hidden" >
                        <%--<input uglcw-role="textbox" uglcw-model="status" id="status" value="${wxset.status}" type="hidden" >--%>

                        <div class="form-group">
                            <label class="control-label col-xs-3">*连锁店</label>
                            <div class="col-xs-5">
                                <tag:select2 name="shopNo" id="shopNo" tableName="pos_shopinfo"  displayKey="shop_no" displayValue="shop_name" onchange="queryWxset()"/>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3">appid</label>
                            <div class="col-xs-16">
                                <input style="width: 312px;" uglcw-model="appid" id="appid" uglcw-role="textbox" value="${wxset.appid}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3">商户号</label>
                            <div class="col-xs-16">
                                <input style="width: 312px;" uglcw-model="mchId" id="mchId" uglcw-role="textbox" value="${wxset.mchId}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3">Key</label>
                            <div class="col-xs-16">
                                <input style="width: 312px;" uglcw-model="wxkey" id="wxkey" uglcw-role="textbox" value="${wxset.wxkey}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3">分商户号</label>
                            <div class="col-xs-16">
                                <input style="width: 312px;" uglcw-model="subMchId" id="subMchId" uglcw-role="textbox" value="${wxset.subMchId}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3" for="status">启用微信支付否</label>
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
                url: '${base}manager/pos/savePosWxSet',
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
                url:"${base}manager/pos/queryWxSet",
                data:"shopNo=" + shopNo,
                type:"post",
                success:function(data){
                    if(data){
                        var list = data.rows;
                        if(list.length> 0){
                            uglcw.ui.bind($('.form-horizontal'), list[0]);
                        }else{
                            uglcw.ui.get('#id').value('');
                            uglcw.ui.get('#appid').value('');
                            uglcw.ui.get('#mchId').value('');
                            uglcw.ui.get('#wxkey').value('');
                            uglcw.ui.get('#subMchId').value('');
                            uglcw.ui.get('#status').value(1);
                        }
                    }
                }
            });



        }

    </script>
</body>
</html>
