<%@ page language="java" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
	<title>驰用T3</title>
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
								<form action="manager/WeixinConfig/updateConfig" name="weixinConfigForm" id="weixinConfigForm" method="post" >
									<dl id="dl">
										<dd >
											<table  style="margin-top:20px;margin-left:20px;border-collapse:   separate;   border-spacing:   10px;">
												<tr>
													<td colspan="3" >
			           <span style="width:100px;padding-top:20px;">登录微信公众平台,在基础设置的公众号开发信息下把开发者ID(AppID)、开发者密码(AppSecret)填到这里的appID和appsecret：
			           </span>
													</td>
												</tr>
												<tr>
													<td style="height:5px;"></td>
												</tr>
												<tr>
													<td  style="text-align:right;"><label class="control-label">appID</label></td>
													<td>
														<input  uglcw-role="textbox" id="id" value="${config.id }" type="hidden" uglcw-model='id'/>
														<input  uglcw-role="textbox" id="appId"  uglcw-model='appId' value="${config.appId }" ondblclick="$('.k-success').css('display','')" style="width:500px;"/>
													</td>
													<td>
														<button uglcw-role="button" id="cleanAppId" class="k-error" onclick="return cleanId();">清空</button>
													</td>
												</tr>
												<tr>
													<td style="height:5px;"></td>
												</tr>
												<tr>
													<td style="text-align:right;"><label class="control-label">appsecret</label></td>
													<td>
														<input uglcw-role="textbox" id="appSecret" value="${config.appSecret }"  uglcw-model='appSecret' style="width:500px;"/>
													</td>
													<td>
														<button uglcw-role="button" id="cleanAppSecret" class="k-error" onclick="return cleanSecret();">清空</button>
													</td>
												</tr>
												<tr>
													<td style="height:5px;"></td>
												</tr>
												<tr>
													<td colspan="3" >
														<span style="width:100px;padding-top:20px;">复制这里的url和token到微信公众平台的基本配置的服务器配置的url和token(响应微信回复配置)：</span>
													</td>
												</tr>
												<tr>
													<td colspan="3" style="height:5px;">
													</td>
												</tr>
												<tr>
													<td style="text-align:right;"><label class="control-label">url</label></td>
													<td>
														<input uglcw-role="textbox" id="url" uglcw-model='url' readonly="readonly" value="${config.url }" style="width:500px;"/>
													</td>
													<td>
														<input uglcw-role='button' class="k-error" id="copyUrl" data-clipboard-action="copy" data-clipboard-target="#url" value="复制" style="width:55px;">
													</td>
												</tr>
												<tr>
													<td colspan="3" style="height:5px;">
													</td>
												</tr>
												<tr>
													<td style="text-align:right;"><label class="control-label">token</label></td>
													<td>
														<input uglcw-role="textbox" id="token" uglcw-model='token' readonly="readonly" value="${config.token }"   style="width:500px;"/>
													</td>
													<td>
														<input uglcw-role='button' class="k-error" id="copyToken" data-clipboard-action="copy" data-clipboard-target="#token" value="复制" style="width: 55px">
													</td>
												</tr>
												<tr>
													<td colspan="3" style="height:5px;">
													</td>
												</tr>
												<tr>
													<td colspan="3" >
														<span style="width:100px;padding-top:20px;">复制这里的白名单IP到微信公众平台的基本配置的IP白名单：</span>
													</td>
												</tr>
												<tr>
													<td colspan="3" style="height:5px;">
													</td>
												</tr>
												<tr>
													<td style="text-align:right;"><label class="control-label">白名单IP</label></td>
													<td>
														<input uglcw-role="textbox" id="uglcwIp" uglcw-model='uglcwIp' readonly="readonly" value="${uglcwIp}"   style="width:500px;"/>
													</td>
													<td>
														<input uglcw-role='button' class="k-error" id="copyuglcwIp" data-clipboard-action="copy" data-clipboard-target="#uglcwIp" value="复制" style="width: 55px"/>
													</td>
												</tr>
												<tr>
													<td style="height:5px;"></td>
												</tr>
												<tr>
													<td colspan="3" style="text-align:center;">
														<button style="display: none" uglcw-role="button" class="k-success"  onclick="return saveConfig()" style="width:80px">保存</button>
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

    function save() {
        $.ajax({
            url: '${base}/manager/updatereportcd',
            data: uglcw.ui.bind($("#bind")),  //绑定值
            type: 'post',
            success: function (data) {
                if (data === "1") {
                    uglcw.ui.success('修改成功');
                    setTimeout(function () {
                        uglcw.ui.reload();
                    }, 1000)
                } else {
                    uglcw.ui.error('操作失败');
                }
            }
        })
    }

    $(function () {
        var clipboard = new ClipboardJS('#copyUrl');
        clipboard.on('success', function(e) {
            uglcw.ui.success("复制成功！");
        });
        clipboard.on('error', function(e) {
            uglcw.ui.error("复制失败：浏览器不支持,请手动复制！");
        });

        var clipboard1 = new ClipboardJS('#copyToken');
        clipboard1.on('success', function(e) {
            uglcw.ui.success("复制成功！");
        });
        clipboard1.on('error', function(e) {
            uglcw.ui.error("复制失败：浏览器不支持,请手动复制！");
        });

        var clipboard2 = new ClipboardJS('#copyuglcwIp');
        clipboard2.on('success', function(e) {
            uglcw.ui.success("复制成功！");
        });
        clipboard2.on('error', function(e) {
            uglcw.ui.error("复制失败：浏览器不支持,请手动复制！");
        });
    });
    function saveConfig(){

        var updateConfig_url="manager/WeixinConfig/updateConfig";
        var dataJson=uglcw.ui.bind('.form-horizontal');
        console.log(dataJson);
        $.ajax({
            url:updateConfig_url,
            data:dataJson,
            type:"POST",
            success:function(json) {
                console.log(json);
                if(json.state){
                    uglcw.ui.success("保存成功!");
                    $("#id").val(json.id);
                }else{
                    uglcw.ui.error("保存失败!");
                }
            }
        });
        return false;
    }
    function cleanId(){
        $("#appId").val("");
        $("#appId").focus();
        return false;
    }
    function cleanSecret(){
        $("#appSecret").val("");
        $("#appSecret").focus();
        return false;
    }


</script>
</body>
</html>
