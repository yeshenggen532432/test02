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
                        <input uglcw-role="textbox" type="hidden" uglcw-model="id" id="id" value="${bc.id}"/>
                        <input uglcw-role="textbox" type="hidden" uglcw-model="status" id="status" value="${bc.status}"/>
                        <div class="form-group">
                            <label class="control-label col-xs-3">班次编码</label>
                            <div class="col-xs-6">
                                <input id="textbox" uglcw-role="textbox" uglcw-model="bcCode" value="${bc.bcCode}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3">班次名称</label>
                            <div class="col-xs-6">
                                <input id="bcName" uglcw-role="textbox" uglcw-model="bcName" value="${bc.bcName}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3">上班弹性时间</label>
                            <div class="col-xs-6">
                                <input id="earlyMinute" uglcw-role="textbox" uglcw-model="earlyMinute"
                                       value="${bc.earlyMinute}">

                            </div>
                            分钟
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3">下班弹性时间</label>
                            <div class="col-xs-6">
                                <input id="lateMinute" uglcw-role="textbox" uglcw-model="lateMinute"
                                       value="${bc.lateMinute}">

                            </div>
                            分钟
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3">最早上班签到时间</label>
                            <div class="col-xs-6">
                                <input id="beforeMinute" uglcw-role="textbox" uglcw-model="beforeMinute"
                                       value="${bc.beforeMinute}">
                            </div>
                            分钟
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3">最晚下班签到时间</label>
                            <div class="col-xs-6">
                                <input id="afterMinute" uglcw-role="textbox" uglcw-model="afterMinute"
                                       value="${bc.afterMinute}">
                            </div>
                            分钟
                        </div>

                        <div class="form-group">
                            <label class="control-label col-xs-3">跨天否</label>
                            <div class="col-xs-6">
                                <input type="checkbox" id="crossDay" uglcw-model="crossDay" uglcw-role="checkbox"
                                       uglcw-value="${bc.crossDay}">
                                <label class="k-checkbox-label" for="crossDay" style="vertical-align:middle;"></label>
                            </div>
                        </div>

                        <%--<div class="form-group">--%>
                        <%--<label class="control-label col-xs-3">地址</label>--%>
                        <%--<div class="col-xs-6">--%>
                        <%--<select uglcw-role="combobox" uglcw-model="address" value="${bc.address}"--%>
                        <%--uglcw-options="--%>
                        <%--value:'${bc.address}',--%>
                        <%--url: '${base}manager/bc/queryAddressList',--%>
                        <%--loadFilter:{--%>
                        <%--data: function(response){return response.rows ||[];}--%>
                        <%--},--%>
                        <%--dataTextField: 'address',--%>
                        <%--dataValueField: 'address'--%>
                        <%--"--%>
                        <%-->--%>
                        <%--</select>--%>
                        <%--</div>--%>
                        <%--</div>--%>
                        <div class="form-group">
                            <label class="control-label col-xs-3">考勤地址</label>
                            <div class="col-xs-6">
                                <input uglcw-role="textbox" uglcw-model="address" id="address" value="${bc.address}">
                            </div>
                            <div class="col-xs-6">
                                <input uglcw-role="button" type="button" value="标注" onclick="javascript:showMap();"/>
                                <input uglcw-role="button" type="button" value="选择地址"
                                       onclick="javascript:showAddress();"/>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3">经纬度</label>
                            <div class="col-xs-2">
                                <input uglcw-role="textbox" uglcw-model="longitude" id="longitude" value="${bc.longitude}"
                                       disabled/>
                            </div>
                            <div class="col-xs-2">
                                <input uglcw-role="textbox" uglcw-model="latitude" id="latitude" value="${bc.latitude}"
                                       disabled/>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3">允许范围(数字)</label>
                            <div class="col-xs-6">
                                <input id="areaLong" uglcw-role="numeric" uglcw-model="areaLong" value="${bc.areaLong}">
                            </div>
                            <div class="col-xs-4 ">
                                <input type="checkbox" id="checkbox" uglcw-model="outOf" uglcw-role="checkbox" uglcw-value="${bc.outOf}">
                                <label for="checkbox">是否可超出范围</label>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3">备注</label>
                            <div class="col-xs-6">
                                <textarea id="remarks" uglcw-role="textbox" uglcw-model="remarks">${bc.remarks}</textarea>
                            </div>
                        </div>
                        <div class="time-container">
                            <c:if test="${!empty list}">
                                <c:forEach items="${list}" var="list" varStatus="s">
                                    <div class="form-group">
                                        <label class="control-label col-xs-3">上班时间</label>
                                        <div class="col-xs-6">
                                            <input class="sb" uglcw-role="timepicker" uglcw-options="format:'HH:mm'"
                                                   uglcw-model="subList[${s.count-1}].startTime"
                                                   value="${list.startTime}">
                                        </div>
                                        <div class="col-xs-6">
                                            <input class="xb" uglcw-role="timepicker" placeholder="下班时间"
                                                   uglcw-options="format:'HH:mm'"
                                                   uglcw-model="subList[${s.count-1}].endTime" value="${list.endTime}">
                                        </div>
                                        <div class="col-xs-6">
                                            <c:if test="${s.last}">
                                                <button id="btn-add" class="k-button"><i
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
                                </c:forEach>
                            </c:if>
                        </div>
                        <div class="form-group">
                            <div class="control-label col-xs-3"></div>
                            <div class="col-xs-6">

                            </div>
                        </div>
                        <div class="form-group">
                            <div class="control-label col-xs-5">
                                <button uglcw-role="button" class="k-info" onclick="save();">保存</button>
                                <button uglcw-role="button" class="k-default" onclick="toback();">取消</button>
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
        <label class="control-label col-xs-3">上班时间</label>
        <div class="col-xs-6">
            <input class="sb" uglcw-role="timepicker" uglcw-options="format:'HH:mm'"
                   uglcw-model="subList[#= index#].startTime">
        </div>
        <div class="col-xs-6">
            <input class="xb" uglcw-role="timepicker" placeholder="下班时间"
                   uglcw-model="subList[#= index#].endTime" uglcw-options="format:'HH:mm'">

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
<%@include file="/WEB-INF/view/v2/include/map.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();
        if (isAdd()) {
            showLocation();
        }
        uglcw.ui.loaded();
        $('.time-container').on('click', '#btn-add', function () {
            var count = $('.time-container').find('.form-group').length
            var html = uglcw.util.template($('#item-tpl').html())({index: count});
            $('.time-container #btn-add').remove();
            $('.time-container').append(html);
            uglcw.ui.init('.time-container .form-group:last');
            if (count >= 1) {
                $('#btn-remove').show();
            }
        })
    })

    function removeItem(btn) {
        $(btn).closest('.form-group').remove();
        $('.time-container .form-group').each(function (i, group) {
            $(group).find('.sb').attr('uglcw-model', 'subList[' + i + '].startTime');
            $(group).find('.xb').attr('uglcw-model', 'subList[' + i + '].endTime');
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
            url: '${base}manager/bc/saveKqBc',
            data: uglcw.ui.bind('.form-horizontal'),  //绑定值
            success: function (data) {
                if (data == "1") {
                    uglcw.ui.success("保存成功")
                    toback();
                } else {
                    uglcw.ui.error('失败');//错误提示
                    return;
                }
            }
        })
    }

    function toback() {
        location.href = "${base}/manager/bc/toBaseBc";
    }

    //显示地图
    function showMap() {
        var oldCity, oldLng, oldLat, oldAddress;
        oldLng = uglcw.ui.get("#longitude").value();
        oldLat = uglcw.ui.get("#latitude").value();
        oldAddress = uglcw.ui.get("#address").value();
        if (isAdd() && !oldLng) {
            oldLng = mLng;
            oldLat = mLat;
        }
        g_showMap({oldLng: oldLng, oldLat: oldLat, searchCondition: oldAddress, city: oldCity}, function (data) {
            uglcw.ui.get("#longitude").value(data.lng);
            uglcw.ui.get("#latitude").value(data.lat);
            uglcw.ui.get("#address").value(data.street + data.streetNumber);
            uglcw.ui.success('获取成功');
        });
    }

    //定位
    var mLng, mLat;

    function showLocation() {
        uglcw_location(function (r) {
            mLat = r.latitude;
            mLng = r.longitude;
            // uglcw.ui.get("#longitude").value(r.longitude);
            // uglcw.ui.get("#latitude").value(r.latitude);
        })
    }

    //判断是否添加的
    function isAdd() {
        var isAdd = true;
        var bc = ${fns:toJson(bc)};
        if (bc) {
            isAdd = false;
        }
        return isAdd;
    }

    //选择地址
    function showAddress() {
        uglcw.ui.Modal.showGridSelector({
            closable: false,
            title: false,
            <%--url: '${base}manager/bc/queryAddressList',--%>
            url: '${base}manager/kqBcAddress/queryList',
            pageable: true,
            // query: function (params) {
            //     params.extra = new Date().getTime();
            //     return params;
            // },
            checkboxes: false,
            checkbox: false,
            area: ['650px', '350px'],
            // criteria: '<input placeholder="请输入关键字" uglcw-role="textbox" uglcw-model="keyword">',
            columns: [
                {field: 'address', title: '地址', width: 160, tooltip:true},
                {field: 'longitude', title: '经度', width: 100},
                {field: 'latitude', title: '纬度', width: 100},
            ],
            yes: function (nodes) {
                if(nodes){
                    uglcw.ui.get("#longitude").value(nodes[0].longitude);
                    uglcw.ui.get("#latitude").value(nodes[0].latitude);
                    uglcw.ui.get("#address").value(nodes[0].address);
                    uglcw.ui.success('选择地址成功');
                }
            }
        })
    }

</script>
</body>
</html>
