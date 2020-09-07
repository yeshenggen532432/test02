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
							<form action="manager/weixinPay/updatePayConfig" name="weixinPayConfigForm" id="weixinPayConfigForm" method="post" >
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
												<td style="height:10px;"></td>
											</tr>
											<tr>
												<td  style="text-align:right;"><label class="control-label">公众号appID</label></td>
												<td>
													<input uglcw-role="textbox" type='hidden' id="id" value="${shopWxset.id }"  uglcw-model='id'/>
													<input uglcw-role="textbox" id="appid" value="${shopWxset.appid }"  uglcw-model='appid' style="width:500px;" ondblclick="$('.k-success').css('display','')"/>
												</td>
												<td>
													<button uglcw-role="button" class="k-error" id="cleanAppId"  onclick="return clean_app_id()">清空</button>
												</td>
											</tr>
											<!-- 表格行间距 --><tr><td style="height:10px;"></td></tr>
											<tr>
												<td  style="text-align:right;"><label class="control-label">公众号子AppID</label></td>
												<td>
													<input uglcw-role="textbox" id="subAppid" value="${shopWxset.subAppid}"  uglcw-model='subAppid' style="width:500px;"/>
												</td>
												<td>
													<button uglcw-role="button" class="k-error" id="cleanSubAppId"  onclick="return clean_sub_appId()">清空</button>
												</td>
											</tr>
											<!-- 表格行间距 --><tr><td style="height:10px;"></td></tr>
											<tr>
												<td style="text-align:right;"><label class="control-label">公众号appSecret</label></td>
												<td>
													<input uglcw-role="textbox" id="appsecret" value="${shopWxset.appsecret}"  uglcw-model='appsecret' style="width:500px;"/>
												</td>
												<td>
													<button uglcw-role="button" class="k-error" id="cleanAppSecret"  onclick="return clean_app_secret()">清空</button>
												</td>
											</tr>
											<!-- 表格行间距 --><tr><td style="height:10px;"></td></tr>
											<tr>
												<td style="text-align:right;"><label class="control-label">商户号</label></td>
												<td>
													<input uglcw-role="textbox" id="mchId" value="${shopWxset.mchId}"  uglcw-model='mchId' style="width:500px;"/>
												</td>
												<td>
													<button uglcw-role="button" class="k-error" id="cleanMchId"  onclick="return clean_mch_id()">清空</button>
												</td>
											</tr>
											<!-- 表格行间距 --><tr><td style="height:10px;"></td></tr>
											<tr>
												<td style="text-align:right;"><label class="control-label">子商户号</label></td>
												<td>
													<input uglcw-role="textbox" id="subMchId" value="${shopWxset.subMchId}"  uglcw-model='subMchId' style="width:500px;"/>
												</td>
												<td>
													<button uglcw-role="button" class="k-error" onclick="return clean_sub_mch_id()">清空</button>
												</td>
											</tr>
											<!-- 表格行间距 --><tr><td style="height:10px;"></td></tr>
											<tr>
												<td style="text-align:right;"><label class="control-label">支付key</label></td>
												<td>
													<input uglcw-role="textbox" id="wxkey" value="${shopWxset.wxkey}"  uglcw-model='wxkey' style="width:500px;"/>
												</td>
												<td>
													<button uglcw-role="button" class="k-error" id="cleanWxKey" onclick="return clean_wx_key()">清空</button>
												</td>
											</tr>
											<!-- 表格行间距 --><tr><td style="height:10px;"></td></tr>
											<tr hidden="true">
												<td style="text-align:right;">shopNo：</td>
												<td>
													<input uglcw-role="textbox"  id="shopNo" readonly="readonly" value="${shopWxset.shopNo}"  uglcw-model='shopNo' style="width:500px;"/>
												</td>
											</tr>
											<tr>
												<td style="text-align:right;"><label class="control-label">回调地址</label></td>
												<td>
													<input uglcw-role="textbox" id="backUrl" value="${shopWxset.backUrl}"  uglcw-model='backUrl' style="width:500px;"/>
												</td>
												<td>
													<button uglcw-role="button" class="k-error" id="cleanBackUrl"  onclick="return clean_back_url()">清空</button>
												</td>
											</tr>
											<!-- 表格行间距 --><tr><td style="height:10px;"></td></tr>
											<tr>
												<td style="text-align:right;"><label class="control-label" style="margin-bottom: 10px;">开启状态</label></td>
												<td>
													<input type="checkbox" uglcw-role="checkbox" uglcw-value="${shopWxset.status}" uglcw-options="type:'number'" id="checkbox_status" uglcw-model="status"/>
													<label for="checkbox_status"></label>
												</td>
											</tr>
											<!-- 表格行间距 --><tr><td style="height:10px;"></td></tr>
											<tr><td style="height:10px;"></td><!-- 表格行间距 --></tr>
											<tr>
												<td colspan="3" style="text-align:center;">
													<button uglcw-role="button" class="k-success"  onclick="return savePayConfig()" style="display:none;width:80px">保存</button>
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
    function savePayConfig(){

        var updatePayConfig_url="manager/weixinPay/updatePayConfig";
        var dataJson=uglcw.ui.bind('body');
        console.log(dataJson);
        $.ajax({
            url:updatePayConfig_url,
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

    function clean_app_id(){
        $("#appid").val("");
        $("#appid").focus();
        return false;
    }
    function clean_sub_appId(){
        $("#subAppid").val("");
        $("#subAppid").focus();
        return false;
    }
    function clean_app_secret(){
        $("#appsecret").val("");
        $("#appsecret").focus();
        return false;
    }
    function clean_mch_id(){
        $("#mchId").val("");
        $("#mchId").focus();
        return false;
    }
    function clean_sub_mch_id(){
        $("#subMchId").val("");
        $("#subMchId").focus();
        return false;
    }
    function clean_wx_key(){
        $("#wxkey").val("");
        $("#wxkey").focus();
        return false;
    }
    function clean_back_url(){
        $("#backUrl").val("");
        $("#backUrl").focus();
        return false;
    }


</script>
</body>
</html>
