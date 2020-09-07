<%@ page language="java" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>小程序配置</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <script src="<%=basePath%>/resource/clipboard.min.js"></script>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md12">
            <div class="layui-card">
                <div class="layui-card-body">
                    <div class="form-horizontal" uglcw-role="validator" novalidate id="bind">
                        <div class="box" style="width:100%;">
                            <form method="post">
                                <dl id="dl">
                                    <dd>
                                        <table style="margin-top:20px;margin-left:20px;border-collapse:   separate;   border-spacing:   10px;">
                                            <tr>
                                                <td colspan="3">
                                                    <span style="width:100px;padding-top:20px;">登录微信小程序,在基础设置的公众号开发信息下把开发者ID(AppID)、开发者密码(AppSecret)填到这里的appID和appsecret：</span><br/>
                                                    <span>服务商模式:https://pay.weixin.qq.com/wiki/doc/api/wxa/wxa_api.php?chapter=7_10&index=1</span><br/>
                                                    <span>sub_appid使用说明:https://pay.weixin.qq.com/wiki/doc/api/wxa/wxa_api.php?chapter=7_12&index=6</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height:10px;"></td>
                                            </tr>
                                            <tr>
                                                <td style="text-align:right;"><label
                                                        class="control-label">小程序appID</label></td>
                                                <td>
                                                    <input uglcw-role="textbox" type='hidden' id="id"
                                                           value="${miniWeixinConfig.id }" uglcw-model='id'/>
                                                    <input uglcw-role="textbox" id="appid"
                                                           value="${miniWeixinConfig.appid }" uglcw-model='appid'  ondblclick="$('.k-success').css('display','')"
                                                           style="width:500px;"/>
                                                </td>
                                                <td>
                                                    <button uglcw-role="button" class="k-error" id="cleanAppId"
                                                            onclick="return clean_by_id('appid')">清空
                                                    </button>
                                                </td>
                                            </tr>
                                            <!-- 表格行间距 -->
                                            <tr>
                                                <td style="height:10px;"></td>
                                            </tr>
                                            <tr>
                                                <td style="text-align:right;"><label
                                                        class="control-label">小程序appSecret</label></td>
                                                <td>
                                                    <input uglcw-role="textbox" id="appsecret"
                                                           value="${miniWeixinConfig.appsecret}" uglcw-model='appsecret'
                                                           style="width:500px;"/>
                                                </td>
                                                <td>
                                                    <button uglcw-role="button" class="k-error" id="cleanAppSecret"
                                                            onclick="return clean_by_id('appsecret')">清空
                                                    </button>
                                                </td>
                                            </tr>
                                            <!-- 表格行间距 -->
                                            <tr>
                                                <td style="height:10px;"></td>
                                            </tr>
                                            <%--<tr>
                                                <td style="text-align:right;"><label class="control-label">商户号</label>
                                                </td>
                                                <td>
                                                    <input uglcw-role="textbox" id="mchId"
                                                           value="${miniWeixinConfig.mchId}" uglcw-model='mchId'
                                                           style="width:500px;"/>
                                                </td>
                                                <td>
                                                    <button uglcw-role="button" class="k-error" id="cleanMchId"
                                                            onclick="return clean_by_id('mchId')">清空
                                                    </button>
                                                </td>
                                            </tr>
                                            <!-- 表格行间距 -->
                                            <tr>
                                                <td style="height:10px;"></td>
                                            </tr>
                                            <tr>
                                                <td style="text-align:right;"><label class="control-label">子商户号</label>
                                                </td>
                                                <td>
                                                    <input uglcw-role="textbox" id="subMchId"
                                                           value="${miniWeixinConfig.subMchId}" uglcw-model='subMchId'
                                                           style="width:500px;"/>
                                                </td>
                                                <td>
                                                    <button uglcw-role="button" class="k-error"
                                                            onclick="return clean_by_id('subMchId')">清空
                                                    </button>
                                                </td>
                                            </tr>--%>
                                            <!-- 表格行间距 -->
                                            <tr style="display: none">
                                                <td style="height:10px;"></td>
                                            </tr>
                                            <tr style="display: none">
                                                <td style="text-align:right;"><label class="control-label"
                                                                                     style="margin-bottom: 10px;">开启状态</label>
                                                </td>
                                                <td>
                                                    <input type="checkbox" uglcw-role="checkbox"
                                                           uglcw-value="1"
                                                           uglcw-options="type:'number'" id="checkbox_status"
                                                           uglcw-model="status"/>
                                                    <label for="checkbox_status"></label>
                                                </td>
                                            </tr>
                                            <!-- 表格行间距 -->
                                            <tr>
                                                <td style="height:10px;"></td>
                                            </tr>
                                            <tr>
                                                <td style="height:10px;"></td><!-- 表格行间距 --></tr>
                                            <tr>
                                                <td colspan="3" style="text-align:center;">
                                                    <button uglcw-role="button" class="k-success"
                                                            onclick="return savePayConfig()" style="width:80px;display: none">保存
                                                    </button>
                                                </td>
                                            </tr>
                                        </table>
                                    </dd>
                                </dl>
                            </form>
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
        uglcw.ui.init();
        uglcw.ui.loaded()
    })


    function savePayConfig() {
        $.ajax({
            url: "manager/miniWeixinConfig/updateConfig",
            contentType: "application/json", // 指定这个协议很重要
            data: JSON.stringify(uglcw.ui.bind('body')),
            type: "POST",
            success: function (json) {
                console.log(json);
                if (json.state) {
                    uglcw.ui.success("保存成功!");
                    $("#id").val(json.obj);
                } else {
                    uglcw.ui.error("保存失败!");
                }
            }
        });
        return false;
    }

    function clean_by_id(field) {
        $("#" + field).val("");
        $("#" + field).focus();
        return false;
    }
</script>
</body>
</html>
