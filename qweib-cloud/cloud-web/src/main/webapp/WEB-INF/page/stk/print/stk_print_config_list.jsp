<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<base href="<%=basePath%>"/>
<c:set var="base" value="<%=basePath%>"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>打印列设置</title>

    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">
    <script type="text/javascript" src="${base}resource/jquery-1.8.0.min.js"></script>
    <script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
    <script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
    <style>
        tr {
            background-color: #FFF;
            height: 30px;
            vertical-align: middle;
            padding: 3px;
        }

        td {
            padding-left: 10px;
        }
        td:last-child{
            border: none;
        }
    </style>
</head>
<body style="text-align: center;padding: 15px;">
<div style="margin: 5px; text-align: center">
    <table style="width: 590px" border="1"
           cellpadding="0" cellspacing="1">
        <thead>
        <tr>
            <th style="width: 40px">序号</th>
            <th style="width: 60px">列名</th>
            <th style="width: 80px">长度(总长度100)</th>
            <th style="width: 60px;">对齐方式</th>
            <th>高度</th>
            <th>小数位</th>
            <th>字体大小</th>
            <th>排序</th>
            <th style="width: 80px">
                显示
            </th>
            <th style="width: 80px">操作</th>
            <th>&nbsp;</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${datas }" var="data" varStatus="s">
            <tr>
                <td>${s.index+1 }
                </td>
                <td>
                    <input name="fdFieldName" id="fdFieldName${s.index}" type="text" style="border: 0px solid #ddd;"
                           value="${data.fdFieldName}" onchange="changeFieldName(this,${data.id })"/>
                </td>
                <td>
                    <input name="fdWidth" id="fdWidth${s.index}" type="text" style="border: 0px solid #ddd;width: 100px"
                           onkeyup="CheckInFloat(this)" value="${data.fdWidth}"
                           onchange="changeFdWidth(this,${data.id })"/>
                </td>
                <td>
                    <select name="fdAlign" id="fdAlign${s.index}"
                            onchange="onFieldChange(this,${data.id }, 'fdAlign')">
                        <option <c:if test="${data.fdAlign == null or data.fdAlign == 0}">selected</c:if>  value="0">居中</option>
                        <option <c:if test="${data.fdAlign == 1}">selected</c:if> value="1">左对齐</option>
                        <option <c:if test="${data.fdAlign == 2}">selected</c:if> value="2">右对齐</option>
                    </select>
                </td>
                <td>
                    <input name="fdHeight" id="fdHeight${s.index}" type="text"
                           style="border: 0px solid #ddd;width: 50px"
                           onkeyup="CheckInFloat(this)" value="${data.fdHeight}"
                           onchange="changeFdHeight(this,${data.id })"/>
                </td>
                <td>
                    <input name="fdDecimals" id="fdDecimals${s.index}" type="text"
                           style="border: 0px solid #ddd;width: 50px"
                           onkeyup="CheckInFloat(this)" value="${data.fdDecimals}"
                           onchange="onFieldChange(this,${data.id }, 'fdDecimals')"/>
                </td>
                <td>
                    <select onchange="changeFdFontsize(this, ${data.id})">
                        <c:forEach begin="10" end="35" var="i">
                            <option
                                    <c:if test="${data.fdFontsize==i}">selected</c:if> >${i}</option>
                        </c:forEach>
                    </select>
                        <%--<input name="fdFontsize" id="fdFontsize${s.index}" type="text"
                               style="border: 0px solid #ddd;width: 50px"
                               onkeyup="CheckInFloat(this)" value="${data.fdFontsize}"
                               onchange="changeFdFontsize(this,${data.id })"/>--%>
                </td>
                <td>
                    <input name="orderCd" id="orderCd${s.index}" type="text" style="border: 0px solid #ddd;width: 40px"
                           onkeyup="CheckInFloat(this)" value="${data.orderCd}"
                           onchange="changeOrderCd(this,${data.id })"/>
                </td>
                <td>
                    <div style="width: 40px;">
                        <c:if test="${ data.fdStatus eq 1}"><span id="fdStatusTxt${s.index }">是</span></c:if>
                        <c:if test="${ data.fdStatus eq 0}"><span id="fdStatusTxt${s.index }">否</span></c:if>
                        <input type="hidden" id="fdStatus${s.index }" value="${data.fdStatus }"/>
                    </div>
                </td>

                <td>
                    <div>
                        <c:if test="${ data.fdStatus eq 1}">
                            <button id="btnfield${s.index }" type="button"
                                    onclick="updateFdStatus(${s.index},${data.id })">隐藏
                            </button>
                        </c:if>
                        <c:if test="${ data.fdStatus eq 0}">
                            <button id="btnfield${s.index }" type="button"
                                    onclick="updateFdStatus(${s.index},${data.id })">显示
                            </button>
                        </c:if>
                    </div>
                </td>
                <td>&nbsp;</td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
</body>
<script>
    function CheckInFloat(oInput) {
        if (window.event.keyCode == 37 || window.event.keyCode == 37) {
            return;
        }
        if ('' != oInput.value.replace(/\d{1,}\{0,1}\d{0,}/, '')) {
            oInput.value = oInput.value.match(/\d{1,}\{0,1}\d{0,}/) == null ? '' : oInput.value.match(/\d{1,}\{0,1}\d{0,}/);
        }
    }
</script>
</html>
