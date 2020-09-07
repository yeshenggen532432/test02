<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>驰用T3</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="uglcw-layout-container">
        <div class="uglcw-layout-fixed" style="width: 400px">
            <div class="layui-card">
                <div class="layui-card-body full">
                    <div id="grid" uglcw-role="grid"
                         uglcw-options="{
                    responsive:[40],
                    id:'id',
                    url: 'manager/pos/queryTicketType',
                    checkbox: true
                    }">
                        <div data-field="ticketNo" uglcw-options="width:'auto'">编号</div>
                        <div data-field="ticketName" uglcw-options="width:'auto'">类型名称</div>
                        <div data-field="amt" uglcw-options="width:'auto'">面值</div>
                        <div data-field="waretypeNm" uglcw-options="width:'auto'">限制消费</div>
                    </div>
                </div>
            </div>
        </div>
        <div class="uglcw-layout-content">
            <div class="layui-card header">
                <div class="layui-card-body">
                    <ul class="uglcw-query form-horizontal" id="export">
                        <li>
                            <select uglcw-role="combobox" uglcw-model="status" placeholder="状态">
                                <option value="-9">全部</option>
                                <option value="0">未使用</option>
                                <option value="1">已使用</option>
                            </select>
                        </li>
                        <li>
                            <input uglcw-role="textbox" uglcw-model="memberNm" placeholder="会员名称">
                        </li>
                        <li>
                            <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                            <button id="reset" class="k-button" uglcw-role="button">重置</button>
                        </li>
                    </ul>
                </div>
            </div>
            <div class="layui-card">
                <div class="layui-card-body full">
                    <form style="display: none" class="query">
                        <input type="hidden" uglcw-role="textbox" uglcw-model="id">
                    </form>

                    <div id="itemgrid" uglcw-role="grid"
                         uglcw-options="{
                    responsive:['.header',40],
                    id:'id',
                    url: 'manager/pos/queryTicketPage',
                    criteria: '.query',
                    pageable: true,
                    checkbox: true
                    }">
                        <div data-field="ticketBarcode" uglcw-options="width:140,tooltip: true">券编号</div>
                        <div data-field="memberName" uglcw-options="width:120">会员名称</div>
                        <div data-field="endDate" uglcw-options="width:120">有效期</div>
                        <div data-field="status"
                             uglcw-options="width:120, template: uglcw.util.template($('#statusformatter').html())">状态
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/x-kendo-template" id="statusformatter">
    #if(data.status == 0){#
    未使用
    #}else{#
    已使用
    #}#

</script>
<script id="t" type="text/uglcw-template">
    <div class="layui-card">
        <div class="layui-card-body">
            <div class="form-horizontal" uglcw-role="validator" id="dlg">
                <div class="form-group">
                    <label class="control-label col-xs-8">充值金额</label>
                    <div class="col-xs-14">
                        <input uglcw-role="textbox" uglcw-model="inputCash" uglcw-validate="required">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">赠送金额</label>
                    <div class="col-xs-14">
                        <input uglcw-model="freeCost" uglcw-role="textbox">
                    </div>
                </div>
            </div>
        </div>
    </div>
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();

        uglcw.ui.get('#grid').on('change', function (e) {
            var row = this.dataItem(this.select());//获取所有的数据
            console.log(row);//输出信息
            uglcw.ui.bind('.query', {id: row.id});//绑定id
            uglcw.ui.get('#itemgrid').reload(); //加载数据
        })


        uglcw.ui.loaded()

    })

</script>
</body>
</html>