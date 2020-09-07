<%@ page language="java" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>驰用T3</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        /*  .k-save {
              color: #fff;
              border-color: #6bb7f3;
              background-color: #6bb7f3;
          }*/
        .k-cancel {
            border: 1px solid transparent;
            border-radius: 6px;
            padding: .4em 2em;
            color: #fff;
            background-color: #6bb7f3;
        }

        .k-save {
            display: inline-flex;
            justify-content: center;
            align-items: center;
            text-decoration: none; /*for <a> link*/
            margin: 2px;
            border: 1px solid transparent;
            border-radius: 6px;
            padding: .4em 2em;
            color: #fff;
            background-color: #6bb7f3;
        }
    </style>
</head>
<body>
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md12">
            <div class="layui-card">
                <div class="layui-card-body">
                    <form class="form-horizontal" uglcw-role="validator" novalidate>
                        <input uglcw-role="textbox" type="hidden" uglcw-model="id" id="id" value="${bc.id}"/>
                        <input type="hidden" uglcw-role="textbox" id = "cashPay" uglcw-model = "cashPay" />
                        <input type="hidden" uglcw-role="textbox" id = "bankpay" uglcw-model = "bankpay" />
                        <input type="hidden" uglcw-role="textbox" id = "wxPay" uglcw-model = "wxPay" />
                        <input type="hidden" uglcw-role="textbox" id = "zfbPay" uglcw-model = "zfbPay" />
                        <div class="form-group">
                            <label class="control-label col-xs-3">卡类型*</label>
                            <div class="col-xs-4">
                                <tag:select2 id="cardTypeSel" name="cardType" displayKey="id"
                                             onchange="chooseCardType();" headerValue="请选择卡类型" headerKey="0"
                                             displayValue="type_name" tableName="shop_member_type"/>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3">卡号*</label>
                            <div class="col-xs-4">
                                <input id="cardNo" uglcw-role="textbox" uglcw-model="cardNo"uglcw-validate="required">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3">工本费</label>
                            <div class="col-xs-4">
                                <input id="cardCost" uglcw-role="textbox" uglcw-model="cardCost"
                                >
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3">底金</label>
                            <div class="col-xs-4">
                                <input id="inputCash" uglcw-role="textbox" uglcw-model="inputCash"
                                    >

                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3">赠送金额</label>
                            <div class="col-xs-4">
                                <input id="freeCost" uglcw-role="textbox" uglcw-model="freeCost"
                                       >
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3">姓名*：</label>
                            <div class="col-xs-4">
                                <input id="name" uglcw-role="textbox" uglcw-model="name" uglcw-validate="required"
                                       >
                            </div>
                        </div>


                        <div class="form-group">
                            <label class="control-label col-xs-3">性别</label>
                            <div class="col-xs-4">
                                <select uglcw-role="combobox" uglcw-model="sex" uglcw-options='"index": -1'>
                                    < <option value="男">男</option>
                                    <option value="女">女</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="control-label col-xs-3">电话</label>
                            <div class="col-xs-4">
                                <input id="mobile" uglcw-role="textbox" uglcw-model="mobile" uglcw-validate="required"/>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="control-label col-xs-3">生日</label>
                            <div class="col-xs-2">
                                <input id="month" uglcw-role="textbox" uglcw-model="month">
                            </div>
                            <div class="col-xs-2">
                                <input id="day" uglcw-role="textbox" uglcw-model="day">

                            </div>
                        </div>

                        <div class="form-group">
                            <label class="control-label col-xs-3">地址</label>
                            <div class="col-xs-4">
                                <input id="address" uglcw-role="textbox" uglcw-model="address">
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="control-label col-xs-6">
                                <button uglcw-role="button" class="k-success" onclick="save();">保存</button>
                                <button uglcw-role="button" class="k-default" onclick="cancel();">取消</button>
                            </div>
                        </div>

                    </form>
                </div>
            </div>

        </div>
    </div>
</div>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();

        resize();
        $(window).resize(resize)
        uglcw.ui.loaded()
    })

    var delay;

    function resize() {
        if (delay) {
            clearTimeout(delay);
        }
        delay = setTimeout(function () {
            var grid = uglcw.ui.get('#grid').k();
            var padding = 15;
            var height = $(window).height() - padding - $('.header').height() - $('.k-grid-toolbar').height();
            grid.setOptions({
                height: height,
                autoBind: true
            })
        }, 200)
    }
    function save() {
        $.ajax({
            url: '${base}manager/pos/posMemberRegist',
            type: 'post',
            success: function (data) {
                if (data.data) {
                    uglcw.ui.success('注册成功');
                } else {
                    uglcw.ui.error("操作失败");
                }
            }
        })
        
    }

</script>
</body>
</html>
