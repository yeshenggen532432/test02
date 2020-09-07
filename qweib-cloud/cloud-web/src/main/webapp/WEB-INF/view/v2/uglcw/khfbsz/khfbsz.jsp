<%@ page language="java" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>驰用T3</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md12">
            <div class="layui-card">
                <div class="layui-card-body">
                    <div class="form-horizontal" uglcw-role="validator" novalidate>
                        <div class="time-container">
                            <c:if test="${!empty list}">
                                <c:forEach items="${list}" var="list" varStatus="s">
                                    <div class="form-group">
                                        <label class="control-label col-xs-3">开始分钟</label>
                                        <div class="col-xs-4">
                                            <input class="sb" uglcw-role="textbox"
                                                   uglcw-model="KhfbszList[${s.count-1}].snums"
                                                   value="${list.snums}">
                                        </div>
                                        <div class="col-xs-4">
                                            <input class="xb" uglcw-role="textbox"
                                                   uglcw-model="KhfbszList[${s.count-1}].enums" value="${list.enums}">
                                        </div>
                                        <div class="col-xs-4">
                                            <select uglcw-role="combobox" uglcw-model="KhfbszList[${s.count-1}].ysz">
                                                <option value="">请选择颜色</option>
                                                <option value="红色" <c:if test="${list.ysz=='红色'}">selected</c:if>>红色
                                                </option>
                                                <option value="绿色" <c:if test="${list.ysz=='绿色'}">selected</c:if>>绿色
                                                </option>
                                                <option value="黑色" <c:if test="${list.ysz=='黑色'}">selected</c:if>>黑色
                                                </option>
                                                <option value="黄色" <c:if test="${list.ysz=='黄色'}">selected</c:if>>黄色
                                                </option>
                                            </select>
                                        </div>
                                        <div class="col-xs-8">
                                            <div style="display: inline-flex;">
                                                <c:if test="${s.last}">
                                                    <button style="margin-right: 10px;" id="btn-add" class="k-button"><i
                                                            class="k-icon k-i-plus-circle"></i>增加
                                                    </button>
                                                </c:if>
                                                <div class="btn-remove"></div>
                                                <c:if test="${s.count > 1}">
                                                    <button onclick="removeItem(this)" class="k-button"><i
                                                            class="k-icon k-i-minus-circle"></i>删除
                                                    </button>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:if>
                            <c:if test="${empty list}">
                                <div class="form-group">
                                    <label class="control-label col-xs-3">开始分钟</label>
                                    <div class="col-xs-4">
                                        <input class="sb" uglcw-role="textbox"
                                               uglcw-model="KhfbszList[0].snums" uglcw-validate="required">
                                    </div>
                                    <div class="col-xs-4">
                                        <input class="xb" uglcw-role="textbox" placeholder="结束分钟"
                                               uglcw-model="KhfbszList[0].enums" uglcw-validate="required">

                                    </div>
                                    <div class="col-xs-4">
                                        <select class="tinct" uglcw-role="combobox" uglcw-model="KhfbszList[0].ysz">
                                            <option value="">请选择颜色</option>
                                            <option value="红色" >红色</option>
                                            <option value="绿色">绿色</option>
                                            <option value="黑色">黑色</option>
                                            <option value="黄色">黄色</option>
                                        </select>
                                    </div>
                                    <div class="col-xs-6">
                                        <button id="btn-add" class="k-button"><i
                                                class="k-icon k-i-plus-circle"></i>增加
                                        </button>
                                        <button class="btn-remove k-button" onclick="removeItem(this)"><i
                                                class="k-icon k-i-minus-circle"></i>删除
                                        </button>
                                    </div>
                                </div>
                            </c:if>
                        </div>
                        <div class="form-group">
                            <div class="control-label col-xs-3"></div>
                            <div class="col-xs-6">

                            </div>
                        </div>
                        <div class="form-group">
                            <div class="control-label col-xs-5">
                                <button uglcw-role="button" class="k-success" onclick="save();">保存</button>
                                <button uglcw-role="button" class="k-default" onclick="cancel();">取消</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/uglcw-x-template" id="item-tpl">
    <div class="form-group">
        <label class="control-label col-xs-3">开始分钟</label>
        <div class="col-xs-4">
            <input class="sb" uglcw-role="textbox"
                   uglcw-model="KhfbszList[#= index#].snums">
        </div>
        <div class="col-xs-4">
            <input class="xb" uglcw-role="textbox" placeholder="结束分钟"
                   uglcw-model="KhfbszList[#= index#].enums">

        </div>
        <div class="col-xs-4">
            <select class="tinct" uglcw-role="combobox" uglcw-model="KhfbszList[#= index#].ysz">
                <option value="">请选择颜色</option>
                <option value="红色" >红色</option>
                <option value="绿色">绿色</option>
                <option value="黑色">黑色</option>
                <option value="黄色">黄色</option>
            </select>
        </div>
        <div class="col-xs-6">
            <button id="btn-add" class="k-button"><i
                    class="k-icon k-i-plus-circle"></i>增加
            </button>
            <button class="btn-remove k-button" onclick="removeItem(this)"><i
                    class="k-icon k-i-minus-circle"></i>删除
            </button>
        </div>
    </div>
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();
        uglcw.ui.loaded();
        $('.time-container').on('click', '#btn-add', function () {
            var count = $('.time-container').find('.form-group').length
            var html = uglcw.util.template($('#item-tpl').html())({index: count});
            $('.time-container #btn-add').remove();
            $('.time-container').append(html);
            uglcw.ui.init('.time-container .form-group:last');
        })
    })
        function removeItem(btn) {
            $(btn).closest('.form-group').remove();
            $('.time-container .form-group').each(function (i, group) {
                $(group).find('.sb').attr('uglcw-model', 'subList[' + i + '].snums');
                $(group).find('.xb').attr('uglcw-model', 'subList[' + i + '].enums');
                $(group).find('.tinct').attr('uglcw-model', 'subList[' + i + '].ysz');
            })
            if ($('.time-container #btn-add').length < 1) {
                var html = '   <button id="btn-add" class="k-button"><i\n' +
                    '                    class="k-icon k-i-plus-circle"></i>增加\n' +
                    '            </button>';
                $('.time-container .form-group:last').find('.btn-remove').before(html);
            }
        }

        function save() {
            $.ajax({
                url: '${base}/manager/addKhfbszLs?dataTp=1"',
                data: uglcw.ui.bind('.form-horizontal'),  //绑定值
                type: 'post',
                success: function (data) {
                    if (data === "1") {
                        uglcw.ui.success('修改成功');
                        setTimeout(function () {
                            toback();
                        }, 1000)
                    } else {
                        uglcw.ui.error('操作失败');
                    }
                }
            })
        }

        function toback() {
            location.href = "${base}/manager/queryKhfbszLs";
        }
</script>
</body>
</html>
