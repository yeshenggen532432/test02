<%@ page language="java" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>库位纠正信息</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .uglcw-search input, select {
            height: 30px;
        }

        .layui-card-header.btn-group {
            padding-left: 0px;
            line-height: inherit;
            height: inherit;
        }

        .dropdown-header {
            border-width: 0 0 1px 0;
            text-transform: uppercase;
        }

        .dropdown-header > span {
            display: inline-block;
            padding: 10px;
        }

        .dropdown-header > span:first-child {
            width: 50px;
        }

        .k-list-container > .k-footer {
            padding: 10px;
        }

        .k-grid .k-command-cell .k-button {
            padding-top: 2px;
            padding-bottom: 2px;
        }

        .k-grid tbody tr {
            cursor: move;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-card master">
        <div class="layui-card-header btn-group">
            <div class="bill-info">
                <div class="no" style="color:green;"><span id="billNo" uglcw-model="billNo" style="height: 25px;"
                                                           readonly uglcw-role="textbox">${stkCrewCheck.billNo}</span>
                </div>
                <div class="status" style="color:red;">
                    <c:choose>
                        <c:when test="${stkCrewCheck.status eq -2 and not empty stkCrewCheck.id and stkCrewCheck.id ne 0}"><span
                                id="billStatus" style="height: 25px;width: 80px" uglcw-model="billstatus"
                                uglcw-role="textbox">暂存</span></c:when>
                        <c:when test="${stkCrewCheck.status eq 1}"><span id="billStatus" style="height: 25px;width: 80px"
                                                                      uglcw-model="billstatus"
                                                                      uglcw-role="textbox">已审批</span></c:when>
                        <c:when test="${stkCrewCheck.status eq 2}"><span id="billStatus" style="height: 25px;width: 80px"
                                                                      uglcw-model="billstatus"
                                                                      uglcw-role="textbox">已作废</span></c:when>
                        <c:otherwise>
                            <span id="billStatus" style="height: 25px;width: 80px" uglcw-model="billstatus"
                                  uglcw-role="textbox">新建</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
        <div class="layui-card-body">
            <form class="form-horizontal" uglcw-role="validator">
                <div class="form-group">
                    <label class="control-label col-xs-3">纠正时间</label>
                    <div class="col-xs-4">
                        <input  uglcw-role="textbox" uglcw-model="inDate" value="${stkCrewCheck.inDate}" readonly="readonly" />
                    </div>
                    <label class="control-label col-xs-3">操作人</label>
                    <div class="col-xs-4">
                        <input  uglcw-role="textbox" uglcw-model="createName" value="${stkCrewCheck.createName}" readonly="readonly" />
                    </div>
                    <label class="control-label col-xs-3">仓库</label>
                    <div class="col-xs-4">
                        <input  uglcw-role="textbox" uglcw-model="stkName" value="${stkCrewCheck.stkName}" readonly="readonly" />
                    </div>
                </div>
                <div class="form-group" style="display: none">
                    <label class="control-label col-xs-3">备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注</label>
                    <div class="col-xs-11">
                                <textarea uglcw-role="textbox" uglcw-model="remarks"
                                          style="width: 100%;">${stkCrewCheck.remarks}</textarea>
                    </div>
                </div>


            </form>
        </div>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options='
                         responsive:[".master",40],
                          id: "id",
                          rowNumber: true,
                          checkbox: false,
                          editable: true,
                          dragable: true,
                          height:400,
                          navigatable: true,
                          dataSource:${fns:toJson(stkCrewCheck.list)}
                        '>
                <div data-field="wareNm" uglcw-options="width:120">商品名称</div>
                <div data-field="beUnit" uglcw-options="width:120,hidden:true">单位</div>
                <div data-field="stkQty" uglcw-options="width:120">库存数量</div>
                <div data-field="qty" uglcw-options="width:120">仓位数</div>

                <div data-field="rlt" uglcw-options="width:100,template:uglcw.util.template($('#resultTpl').html())">
                    库存库位对比
                </div>
                <div data-field="checkQty" uglcw-options="width:120">实际数量</div>
                <div data-field="realQty" uglcw-options="width:120">实际数量(大)</div>
                <div data-field="unitName" uglcw-options="width:60">大单位</div>
                <div data-field="minRealQty" uglcw-options="width:120">实际数量(小)</div>
                <div data-field="minUnit" uglcw-options="width:60">小单位</div>
                <div data-field="disQty" uglcw-options="width:120">纠正数±</div>
                <div data-field="disStkQty" uglcw-options="width:120">盘盈亏±</div>
                <div data-field="minDisStkQty" uglcw-options="width:120,hidden:true">盘盈亏(小)</div>
            </div>
        </div>
    </div>
</div>
<script id="resultTpl" type="text/x-uglcw-template">
    #if(data.minStkQty!=data.minQty){#
    不一致
    #}else{#
    一致
    #}#
</script>
<script id="checkQtyTpl" type="text/x-uglcw-template">
    #var hsNum = data.hsNum || 1;#
    #var hsQty = data.minRealQty / hsNum;#
    #var checkQty = parseFloat(data.realQty)+parseFloat(hsQty);#
    # checkQty = (Math.floor(checkQty * 100) / 100)|| 0;#
    #=checkQty#
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();
        uglcw.ui.loaded();
    });
</script>
</body>
</html>
