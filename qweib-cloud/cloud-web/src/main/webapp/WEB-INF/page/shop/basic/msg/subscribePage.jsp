<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>会员消息订阅</title>
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">
    <%@include file="/WEB-INF/page/include/source.jsp" %>
    <script type="text/javascript" src="resource/loadDiv.js"></script>
    <style type="text/css">
        #weixinMsgMemberCountLabel {
            color: red;
        }

        #weixinMsgChatMemberCountLabel {
            color: red;
        }
    </style>
</head>
<body>
<div id="tb11">
    <div>
        <a class="easyui-linkbutton" iconCls="icon-save" href="javascript:toAdd();">保存</a>
    </div>
</div>
<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="false"
       url="/manager/sysMemberMsgSubscribe/subscribeData" border="false">
    <thead>
    <tr>
        <th field="sysSubjectName" width="150" align="center" formatter="formatName">
            名称
        </th>
        <th field="pushNotice" width="100" align="center" formatter="formatPushNotice">
            推送
        </th>
        <th field="mobileNotice" width="100" align="center" formatter="formatMobileNotice">
            短信
        </th>
        <th field="emailNotice" width="100" align="center" formatter="formatEmailNotice">
            邮件
        </th>
        <th  field="wxNotice" width="100" align="center" formatter="formatWxNotice">
            微信
        </th>
</table>
<%--js--%>
<script type="text/javascript">
    function formatName(val, row) {
        return '<input type="hidden" name="sysSubjectId" value="' + row.sysSubjectId + '" >'+val;
    }

    function formatPushNotice(val) {
        return checkBox('pushNotice', val);
    }

    function formatMobileNotice(val) {
        return checkBox('mobileNotice', val);
    }

    function formatEmailNotice(val) {
        return checkBox('emailNotice', val);
    }

    function formatWxNotice(val) {
        return checkBox('wxNotice', val);
    }

    function checkBox(name, val) {
        var html = '<input type="checkbox" name="' + name + '" value="1" ';
        if (val)
            html += "checked";
        if(name != 'pushNotice')
            html+=" disabled ";
        html += ' >';
        return html;
    }

    function toAdd() {
        var list = [];
        $('tr').each(function (i, item) {
            var obj = {};
            var pushNotice = 0, mobileNotice = 0, emailNotice = 0, wxNotice = 0;
            $("input[type=checkbox]", item).each(function (j, va) {
                var name = $(va).attr("name");
                if ("pushNotice" == name && $(va).prop("checked")) pushNotice = 1;
                if ("mobileNotice" == name && $(va).prop("checked")) mobileNotice = 1;
                if ("emailNotice" == name && $(va).prop("checked")) emailNotice = 1;
                if ("wxNotice" == name && $(va).prop("checked")) wxNotice = 1;
            });
            if (pushNotice + mobileNotice + emailNotice + wxNotice > 0) {
                obj.pushNotice = pushNotice;
                obj.mobileNotice = mobileNotice;
                obj.emailNotice = emailNotice;
                obj.wxNotice = wxNotice;
                obj.sysSubjectId= $("input[name=sysSubjectId]", item).val();
            }
            if (Object.keys(obj).length)
                list.push(obj);
        });
        console.log(list);

        //var rows = $('#datagrid').datagrid('getRows');无法获取到checked改变所以上面自己写获取数据
        if (confirm("是否确定修改订阅?")) {
            $.ajax({
                url: "/manager/sysMemberMsgSubscribe/add",
                dataType: "json",
                contentType: "application/json", // 指定这个协议很重要
                data: JSON.stringify(list), //只有这一个参数，json格式，后台解析为实体，后台可以直接用
                type: "post",
                success: function (json) {
                    if (json) {
                        alert("操作成功");
                    } else {
                        alert("操作失败");
                    }
                }
            });
        }
    }

    $(function () {
        $.extend($.fn.datagrid.methods, {
            getChecked: function (jq) {
                var rr = [];
                var rows = jq.datagrid('getRows');
                jq.datagrid('getPanel').find('div.datagrid-cell input:checked').each(function () {
                    var index = $(this).parents('tr:first').attr('datagrid-row-index');
                    rr.push(rows[index]);
                });
                return rr;
            }
        });

    });

</script>
</body>
</html>
