<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal query">
                <li>
                    <select uglcw-role="combobox" placeholder="客户类型" uglcw-model="qdtpNm"
                            uglcw-options="
                                  url: '${base}manager/queryarealist1',
                                  loadFilter:{
                                    data: function(response){return response.list1 ||[];}
                                  },
                                  dataTextField: 'qdtpNm',
                                  dataValueField: 'qdtpNm'
                                "
                    >

                    </select>
                </li>
                <li>
                    <input uglcw-model="khNm" uglcw-role="textbox" placeholder="客户名称">
                </li>
                <li>
                    <input uglcw-model="epCustomerName" uglcw-role="textbox" placeholder="所属二批">
                </li>
                <li style="width: 300px;">
                    <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                    <button class="k-button k-info" onclick="submitFee()">保存</button>
                    <span>&nbsp;&nbsp;注：只保存本页数据</span>
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
                    url: '${base}manager/queryCustomerFeePage',
                    criteria: '.query',
                    pageable: true,
                    ">
                <div data-field="khNm" uglcw-options="width:180">客户名称</div>
                <div data-field="epCustomerName" uglcw-options="width:180">所属二批</div>
                <div data-field="fee"
                     uglcw-options="width:180, template: '#= data.fee == \'0\' ? \'\' : uglcw.util.toString(data.fee || 0,\'n2\')#'">
                    固定费用
                </div>
            </div>
        </div>
    </div>
</div>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        uglcw.ui.init();
        //显示商品
        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        })


        uglcw.ui.loaded()
    })

    function submitFee() {//保存
        var rows = uglcw.ui.get('#grid').value();
        var path = "${base}manager/SaveCustomerFee";
        $.ajax({
            url: path,
            type: "POST",
            data: {"feeStr": JSON.stringify(rows)},
            dataType: 'json',
            async: false,
            success: function (json) {
                if (json.state) {
                    uglcw.ui.success('保存成功');
                }
            }
        });

    }
</script>
</body>
</html>
