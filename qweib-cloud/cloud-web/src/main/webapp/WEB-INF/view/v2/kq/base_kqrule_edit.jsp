<%@ page language="java" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>驰用T3</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .bc-item {
            text-align: center;
            margin-bottom: 10px;
            -webkit-box-shadow: 0 3px 6px 0 rgba(0, 0, 0, .1), 0 1px 3px 0 rgba(0, 0, 0, .08);
            box-shadow: 0 3px 6px 0 rgba(0, 0, 0, .1), 0 1px 3px 0 rgba(0, 0, 0, .08)
        }

        .bc-item .bc-title {
            font-weight: bold;
            font-size: 14px;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md12">
            <div class="layui-card">
                <div class="layui-card-header btn-group">
                    <ul uglcw-role="buttongroup">
                        <li onclick="save()" data-icon="save" class="k-success">保存</li>
                    </ul>
                </div>
                <div class="layui-card-body">
                    <form class="form-horizontal" uglcw-role="validator">
                        <input type="hidden" uglcw-role="textbox" uglcw-model="id" value="${ruleId}"/>
                        <input type="hidden" uglcw-role="textbox" uglcw-model="status" value="${status}"/>
                        <div class="form-group">
                            <label class="control-label col-xs-3">规律名称</label>
                            <div class="col-xs-4">
                                <input id="textbox" uglcw-validate="required" uglcw-role="textbox" uglcw-model="ruleName"
                                       value="${ruleName}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3">周期单位</label>
                            <div class="col-xs-4">
                                <select id="ruleUnit" uglcw-role="combobox" uglcw-model="ruleUnit" value="${ruleUnit}"
                                        uglcw-options='"index": 0, change: function(e){
                                            var i = this.value();
                                            initBcTemplate(i)
                                        }'>
                                    <option value="0">天</option>
                                    <option value="1">周</option>
                                    <option value="2">月</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3">天数</label>
                            <div class="col-xs-4">
                                <input id="days" uglcw-role="numeric" disabled uglcw-options="format:'{0:n0}'"
                                       uglcw-model="days" value="${days}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3">备注</label>
                            <div class="col-xs-4">
                                <textarea id="remarks" uglcw-role="textbox" uglcw-model="remarks">${remarks}</textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3">排班</label>
                            <div class="col-xs-20">
                                <div class="row" id="op-container">

                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

        </div>
    </div>
</div>
<script id="bc-template" type="text/x-uglcw-template">
    # for(var i= 0; i< data.count; i++){ #
    <div class="col-xs-6">
        <div class="bc-item  k-info">
            <span class="bc-title">
                #if(data.count == 7){#
                #= data.title[i]#
                #}else{#
                #= (i+1)#
                #}#
            </span>
            <input class="bc-options" uglcw-role="combobox" uglcw-model="subList[#= i#].bcId" uglcw-options="
                placeholder: '请设置班次',
                dataSource: bcList,
                dataTextField: 'bcName',
                dataValueField: 'id',
                change: function(e){
                    if(this.value()){
                       $(e.sender.element).closest('.bc-item').addClass('k-success').removeClass('k-info')
                    }else{
                        $(e.sender.element).closest('.bc-item').removeClass('k-success').addClass('k-info')
                    }
                }
            "/>
        </div>
    </div>
    # } #
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    var bcList = [];
    $(function () {
        uglcw.ui.init();
        <c:if test="${not empty kqRule}">
        var rule = eval('(' + '${kqRule}' + ')');
        </c:if>
        <c:if test="${empty kqRule}">
        var rule = {};
        </c:if>
        var settings = {};
        if (rule.subList) {
            $(rule.subList).each(function (idx, bc) {
                settings['subList[' + idx + '].bcId'] = bc.bcId
            })
        }
        uglcw.ui.bind('body', rule);
        loadWorkTypes();
        initBcTemplate(uglcw.ui.get('#ruleUnit').value());
        $('#op-container').on('click', '.bc-item', function () {
            uglcw.ui.get($(this).find('[uglcw-role=combobox]')).k().open();
        });
        uglcw.ui.bind('body', settings);
        checkSelect();
        uglcw.ui.loaded()
    });

    function checkSelect() {
        $('#op-container').find('.bc-item').each(function () {
            if (uglcw.ui.get($(this).find('[uglcw-role=combobox]')).value()) {
                $(this).addClass('k-success').removeClass('k-info')
            }
        })
    }

    function initBcTemplate(i) {
        var count = 1;
        if (i == 1) {
            count = 7;
        } else if (i == 2) {
            count = 31;
        }
        uglcw.ui.get('#days').value(count);
        var html = uglcw.util.template($('#bc-template').html())({
            count: count,
            title: ['星期一', '星期二', '星期三', '星期四', '星期五', '星期六', '星期日']
        });
        $('#op-container').html(html);
        uglcw.ui.init('#op-container');
    }

    function loadWorkTypes() {
        $.ajax({
            url: '${base}manager/bc/queryKqBcPage',
            type: 'post',
            dataType: 'json',
            data: {status: 1},
            async: false,
            success: function (response) {
                if (response.state) {
                    bcList = response.rows;
                    bcList.push({id: 0, bcName: '休息'});
                }
            }
        })
    }

    function save() {
        var valid = uglcw.ui.get('form').validate();
        if (!valid) {
            return;
        }
        uglcw.ui.loading();
        $.ajax({
            url: '${base}manager/kqrule/saveKqRule',
            type: 'post',
            data: uglcw.ui.bind('form'),
            success: function (response) {
                uglcw.ui.loaded();
                if (response == '1') {
                    uglcw.ui.success('保存成功');
                    setTimeout(function () {
                        uglcw.io.emit('refreshBcRuleList');
                        uglcw.ui.closeCurrentTab();
                        uglcw.ui.openTab('规律班次设置', '${base}manager/kqrule/toBaseKqRule')
                    }, 1500);
                } else {
                    uglcw.ui.error("操作失败");
                }
            },
            error: function () {
                uglcw.ui.loaded();
            }
        })
    }


</script>
</body>
</html>
