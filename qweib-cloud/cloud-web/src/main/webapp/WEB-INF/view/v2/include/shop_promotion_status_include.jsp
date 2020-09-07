<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.qweib.cloud.biz.mall.util.status.GeneralStatusEnum" %>
<%@ page import="com.qweib.cloud.biz.mall.util.status.GeneralRunStatusEnum" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.qweib.commons.mapper.JsonMapper" %>
<%
    Map<Integer, String> generalStatusMap = GeneralStatusEnum.getStatusMap();
    request.setAttribute("generalStatusMap", generalStatusMap);
    Map<Integer, String> generalRunStatusMap = GeneralRunStatusEnum.getStatusMap();
    Object obj = request.getAttribute("runStatusMap");
    if (obj != null) {
        generalRunStatusMap = (Map) obj;
    }
    request.setAttribute("generalRunStatusMap", generalRunStatusMap);
%>
<script type="text/javascript">
    var generalStatusArray = [];
    <c:forEach items="${generalStatusMap}" var="map">
    generalStatusArray.push({'${map.key}': '${map.value}'});
    </c:forEach>

    var generalRunStatusArray = [];
    <c:forEach items="${generalRunStatusMap}" var="map">
    generalRunStatusArray.push({'${map.key}': '${map.value}'});
    </c:forEach>


    function getStatus(status) {
        for (var i in generalStatusArray) {
            var item = generalStatusArray[i];
            if (item[status]) {
                return item[status];
            }
        }
    }

    function getRunStatus(status) {
        for (var i in generalRunStatusArray) {
            var item = generalRunStatusArray[i];
            if (item[status]) {
                return item[status];
            }
        }
    }


    //提交方法
    function submitStatusFun(url, confirmText, data) {
        if (arguments.length == 2) {
            arguments[2] = arguments[1];
            arguments[1] = null;
        }
        var submit = function (url, data) {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}' + url,
                type: 'post',
                data: JSON.stringify(data),
                dataType: 'json',
                contentType: 'application/json',
                success: function (response) {
                    uglcw.ui.loaded();
                    if (response.state) {
                        uglcw.ui.success(response.message);
                        uglcw.ui.get('#grid').reload();
                    } else {
                        uglcw.ui.error(response.message);
                    }
                },
                error: function () {
                    uglcw.ui.loaded();
                }
            })
        }
        if (confirmText) {
            uglcw.ui.confirm(confirmText, function () {
                submit(url, data);
            })
        } else {
            submit(arguments[0], arguments[2]);
        }
    }

    //结束状态
    function updateStatusEnd() {
        var rows = uglcw.ui.get('#grid').selectedRow();
        if (!rows || rows.length == 0) {
            uglcw.ui.error('请选择');
            return;
        }
        var error=false;
        rows.forEach(function (value) {
            if (value.status == 1) {
                uglcw.ui.error(value.title+'已开启，必须关闭才能结束');
                error=true;
                return;
            }
        })
        if(error)return;
        uglcw.ui.confirm('确认结束活动吗?', function () {
            rows.forEach(function (value) {
                if (value.status != 2) {
                    var data = {};
                    data.id = value.id;
                    data.status = 2;
                    submitStatusFun(editStatusUrl, data);
                }
            })
        });
    }

    //修改状态
    function g_updateStatus(id, currentState, targetState) {
        var title = '';
        if (targetState === 1) {
            title = '确定开启活动吗？'
        } else if (targetState === 0) {
            title = '确定关闭活动吗？'
        } else if (targetState === 2) {
            title = '确定结束活动吗？'
        }
        var data = {};
        data.id = id;
        data.status = targetState;
        submitStatusFun(editStatusUrl, title, data);
    }

    //修改结束时间
    function updateEndTime(id, endTime) {
        uglcw.ui.Modal.open({
            title: '活动结束时间',
            area: '400px',
            content: uglcw.util.template($('#endtime-setting-tpl').html())({data: {endTime: endTime}}),
            success: function (c) {
                uglcw.ui.init(c);
            },
            yes: function (c) {
                var form = uglcw.ui.bind(c);
                if (!form) {
                    uglcw.ui.error('请选择时间');
                    return false;
                }
                var data = {};
                data.id = id;
                data.endTime = form.endTime;
                submitStatusFun(editStatusUrl, data);
                return true;
            }
        });
    }
</script>




<%--状态--%>
<script id="g_status_tpl" type="text/x-uglcw-template">
    # if(updateStatusFun == null || updateStatusFun == undefined || updateStatusFun === '' || updateStatusFun== "undefined"){ #
    #   var updateStatusFun = "" #
    # } #
    # updateStatusFun=updateStatusFun || 'g_updateStatus'#
    # if(data.status == '1'){ #
    <button onclick="javascript:#=updateStatusFun#(#= data.id#, #= data.status#,0);"
            class="k-button k-info">开
    </button>
    # }else if(data.status == '0' && data.runStatus == '0'){ #
    <button onclick="javascript:#=updateStatusFun#(#= data.id#, #= data.status#,1);"
            class="k-button k-info">关
    </button>
    # } else{ #
        #=getStatus(data.status)#
    #}#
</script>
<%--运行状态--%>
<script id="g_runState_tpl" type="text/x-uglcw-template">
    #=getRunStatus(data.runStatus)#
</script>

<%--操作--%>
<script id="g_opt_tpl" type="text/x-uglcw-template">
    #if (data.status ==0 ){#
    <button class="k-button k-success" type="button" onclick="edit(#=data.id#,'#=data.title#')">编辑</button>
    #}if (data.runStatus==1){#
    <button class="k-button k-success" type="button" onclick="updateEndTime(#=data.id#,'#=data.endTime#')">修改结束时间
    </button>
    #}#
</script>

<%--修改结束时间--%>
<script id="endtime-setting-tpl" type="text/x-uglcw-template">
    <div class="layui-card">
        <div class="layui-card-body">
            <div style="display: inline-flex; vertical-align: middle;">
                <label style="line-height: 30px;">结束时间：</label>
                <div style="width: 250px;">
                    <input uglcw-role="datetimepicker" uglcw-model="endTime"
                           uglcw-options="value: new Date(), disableDates: function(date){
                             var now = new Date().setHours(0, 0, 0, 0);
                             return date && date.valueOf() < now.valueOf();
                           }"/>
                </div>
            </div>
        </div>
    </div>
</script>
