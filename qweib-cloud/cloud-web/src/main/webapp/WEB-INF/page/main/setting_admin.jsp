<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>企微宝用户密码修改</title>
    <%@include file="/WEB-INF/page/include/source.jsp" %>
    <script type="text/javascript" src="resource/md5.js"></script>
</head>
<body>

<div class="box">
    <form action="manager/company/role/admin/save" name="member_form" id="member_form" method="post">
        <input type="hidden" name="memberPwd" id="memberPwd" />
        <span style="color: red"><c:if test="${not empty param.msg }">${param.msg }</c:if></span>
        <dl id="dl">
            <dd>
                <span class="title">姓名：</span>
                <input class="reg_input" name="memberNm" id="memberNm" style="width: 120px"/>
                <span id="memberNmTip" class="onshow"></span>
            </dd>
            <dd>
                <span class="title">手机号：</span>
                <input class="reg_input" name="memberMobile" id="memberMobile" style="width: 120px"/>
            </dd>
            <dd>
                <span class="title">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;密&nbsp;&nbsp;码：</span>
                <input type="password" class="reg_input" name="oldMemberPwd" id="oldMemberPwd" style="width: 120px"/>
                <span id="oldMemberPwdTip" class="onshow"></span>
            </dd>
            <dd>
                <span class="title">密码确认：</span>
                <input type="password" class="reg_input" name="repeatPwd" id="repeatPwd" style="width: 120px"/>
                <span id="memberPwdTip" class="onshow"></span>
            </dd>
        </dl>
        <div class="f_reg_but">
            <input type="button" value="指定自己为管理员" onclick="assignMyself();"/>
            <input type="button" value="保存并设为管理员" onclick="formSubmit();"/>
        </div>
    </form>
</div>

<script type="text/javascript">
    $(function () {
        $.formValidator.initConfig();
        $("#oldMemberPwd").formValidator({
            onShow: "请输入(至少6个字符以上)",
            onFocus: "请输入(至少6个字符以上)",
            onCorrect: "通过"
        }).inputValidator({min: 6, max: 100, onError: "请输入(至少6个字符以上)"});
        $("#repeatPwd").formValidator({
            onShow: "请输入(至少6个字符以上)",
            onFocus: "请输入(至少6个字符以上)",
            onCorrect: "通过"
        }).inputValidator({min: 6, max: 100, onError: "请输入(至少6个字符以上)"});
    });

    //更改角色判断
    function formSubmit() {
        if ($.formValidator.pageIsValid() == true) {
            var oldMemberPwd = $("#oldMemberPwd").val();
            var repeatPwd = $("#repeatPwd").val();
            if (repeatPwd == "123456") {
                $.messager.alert('消息', '密码不能为123456!', 'info');
                return;
            }
            if (oldMemberPwd != repeatPwd) {
                $.messager.alert('消息', '新密码不能等于原密码!', 'info');
                return;
            }

            repeatPwd = hex_md5(repeatPwd);
            $("#memberPwd").val(repeatPwd);
            $("#member_form").form('submit', {
                success: function (data) {
                    var response = JSON.parse(data);
                    alert(response.message);
                    if (response.code == 200) {
                        var memberNm = $("#memberNm").val();
                        window.parent.close(memberNm);
                    }
                }
            });
        }
    }

    function assignMyself() {
        $.ajax({
            type: "post",
            url: "manager/company/role/admin/assign",
            data: {usrid: ${memberId}},
            dataType: 'json',
            success: function (response) {
                alert(response.message);
                if (response.code == 200) {
                    var memberNm = $("#memberNm").val();
                    window.parent.close(memberNm);
                }
            }
        });
    }
</script>
</body>
</html>