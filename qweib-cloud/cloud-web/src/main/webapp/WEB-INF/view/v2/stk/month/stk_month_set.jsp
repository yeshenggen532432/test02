<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>月份设置</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal">
                <li>

                    <select uglcw-role="combobox" uglcw-model="year" id="year" uglcw-options="value: '${year}',
                             allowInput: false"
                            placeholder="年份">
                        <option value="2020">2020</option>
                        <option value="2021">2021</option>
                        <option value="2022">2022</option>
                        <option value="2023">2023</option>
                        <option value="2024">2024</option>
                        <option value="2025">2025</option>
                        <option value="2026">2026</option>
                        <option value="2027">2027</option>
                        <option value="2028">2028</option>
                        <option value="2029">2029</option>
                        <option value="2030">2030</option>
                        <option value="2031">2031</option>
                        <option value="2032">2032</option>
                        <option value="2033">2033</option>
                        <option value="2034">2034</option>
                        <option value="2035">2035</option>
                    </select>
                    <%--<input uglcw-model="year" id="year" uglcw-role="datepicker" uglcw-options="width: 120, format: 'yyyy',schema:{ type: 'date'}" value="${year}">--%>
                </li>
                <li>
                    <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                </li>
            </ul>
        </div>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options="
                            responsive:['.header',40],
							id:'id',
							editable: true,
							toolbar: uglcw.util.template($('#toolbar').html()),
							pageable: true,
							rowNumber:true,
                    		url: '${base}manager/stkmonth/queryMonthSet',
                    		criteria: '.form-horizontal',
                    	">
                <div data-field="id" uglcw-options="width:100,hidden:true">id</div>
                <div data-field="yymm" uglcw-options="width:120">年月</div>
                <div data-field="startDate" uglcw-options="width:150">开始日期</div>

                <%--<div data-field="endDate" uglcw-options="width: 120, format: 'yyyy-MM-dd',--%>
                             <%--schema:{ type: 'date'},--%>
                             <%--editor: productDateEditor--%>
                            <%--">结束日期--%>
                <%--</div>--%>
                <div data-field="endDate" uglcw-options="width: 120, format: 'yyyy-MM-dd',
                             schema:{ type: 'date'},
                             editor: productDateEditor
                            ">结束日期
                </div>
                <div data-field="isReadOnly" uglcw-options="width:80,template: uglcw.util.template($('#isReadOnly').html())">月结状态</div>
                <div data-field="">&nbsp;</div>


            </div>
        </div>
    </div>
</div>
<script type="text/x-uglcw-template" id="toolbar">
    <a role="button" id="addMonth" href="javascript:addMonth();" class="k-button k-button-icontext">
        <span class="k-icon k-i-add"></span>增加月份
    </a>
    <a role="button" id="delMonth" href="javascript:delMonth();" class="k-button k-button-icontext">
        <span class="k-icon k-i-trash"></span>删除最后月份
    </a>
    <span style="color: red">
        点击结束日期可修改
    </span>
</script>

<script id="header_endDate" type="text/x-uglcw-template">
    <span>截至日期</span>
</script>

<script id="endDate" type="text/x-uglcw-template">
    # var yymm = data.yymm #
    <input uglcw-model="endDate" uglcw-role="datepicker" value="#= val #"
           onchange="changeDate(this,'#= field #','#= yymm#')">

</script>

<script id="isReadOnly" type="text/x-uglcw-template">
    #= getStatus(data)#
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        //ui:初始化
        uglcw.ui.init();
        //查询
        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        })
        uglcw.ui.get('#year').on('change',function () {
            uglcw.ui.get('#grid').reload();
        })
        uglcw.ui.loaded();
    })

    function delMonth() {
        $.ajax({
            url: "${base}manager/stkmonth/deleteMonthSet",
            type: "post",
            data: "",
            success: function (data) {
                if (data.state) {
                    //$("#"+field+"_span_"+wareId).text(o.value);
                    uglcw.ui.get('#grid').reload();
                } else {
                    uglcw.ui.error("操作失败");

                }
            }
        });
    }

    function getStatus(data) {
            if(data.isReadOnly==0){
                return "未结";
            }
            if(data.isReadOnly==1){
                return "已结";
            }
    }

    function addMonth() {
        $.ajax({
            url: "${base}manager/stkmonth/addInitMonthSet",
            type: "post",
            data: "addyear=" + $("#year").val(),
            success: function (data) {
                if (data.state) {
                    //$("#"+field+"_span_"+wareId).text(o.value);
                    uglcw.ui.get('#grid').reload();
                    uglcw.ui.success("操作成功")
                    setTimeout(function () {
                        //滚动到底部;
                        uglcw.ui.get('#grid').scrollBottom();
                        uglcw.ui.get('#grid').k().select($('#grid .k-grid-content tr:last'))
                    }, 500)
                } else {
                    uglcw.ui.error('操作失败');
                }
            }
        });
    }


    //---------------------------------------------------------------------------------------------------------------

    function changeDate(val,yymm) {
        $.ajax({
            url: "manager/stkmonth/updateMonthSet",
            type: "post",
            data: "endDate=" + val + "&yymm=" + yymm,
            success: function (data) {
                if (data.state) {
                    //$("#"+field+"_span_"+wareId).text(o.value);
                    uglcw.ui.get('#grid').reload();
                } else {
                    alert("操作失败");
                    return;
                }
            }
        });
    }

    function productDateEditor(container, options){
        var model = options.model;
        if(model.isReadOnly==1){
            return;
        }
        var input = $('<input data-bind="value:endDate" name="endDate"/>');
        input.appendTo(container);
        var picker = new uglcw.ui.DatePicker(input);
        picker.init({
            format: 'yyyy-MM-dd',
            change: function () {
                model.endDate = picker.value();
                changeDate(model.endDate,model.yymm);
            },
        });
        picker.k().open();
    }

</script>
</body>
</html>
