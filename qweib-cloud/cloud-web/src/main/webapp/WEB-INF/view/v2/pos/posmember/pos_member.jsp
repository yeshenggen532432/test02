<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>驰用T3</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md12">
            <div class="layui-card header">
                <div class="layui-card-body">
                    <div class="form-horizontal query" id="export">
                        <div class="form-group" style="margin-bottom: 10px;">
                            <input type="hidden"  uglcw-role="textbox"  uglcw-model="shopNo" id="shopNo" value="${shopNo}"/>
                            <input type="hidden"  uglcw-role="textbox"  uglcw-model="source" id="source" value="${source}"/>
                            <input type="hidden" uglcw-role="textbox" uglcw-model="database" id="database" value="${database}">

                            <div class="col-xs-3">
                                <select uglcw-role="combobox" uglcw-model="shopNo" id="shopName" placeholder="连锁店">
                                    <option value="">全部</option>
                                </select>
                            </div>
                            <div class="col-xs-3">
                                <input uglcw-role="textbox" uglcw-model="name" id="cstName" placeholder="姓名">
                            </div>

                            <div class="col-xs-3">
                                <input uglcw-role="textbox" uglcw-model="cardNo" id="cardNo" placeholder="卡号">
                            </div>
                            <div class="col-xs-3">
                                <input uglcw-role="textbox" uglcw-model="mobile" id="mobile" placeholder="电话">
                            </div>

                            <div class="col-xs-3">
                                <select uglcw-role="combobox" uglcw-model="status">
                                    <option value="-2">全部</option>
                                    <option value="0">挂失</option>
                                </select>
                            </div>
                            <div class="col-xs-3">
                                <select uglcw-role="combobox" uglcw-model="cardType" id="cardType">
                                    <option value="">全部</option>
                                </select>
                            </div>
                            <div class="col-xs-3">
                                <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                                <button id="reset" class="k-button" uglcw-role="button">重置</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="layui-card">
                <div class="layui-card-body full">
                    <div id="grid" uglcw-role="grid"
                         uglcw-options="{
                    responsive:['.header',40],
                    toolbar: kendo.template($('#toolbar').html()),
                    id:'id',pageable:true,
                    url: 'manager/pos/queryMemberPage',
                    criteria: '.form-horizontal',

                    }">

                        <div data-field="openId" uglcw-options="width:140,tooltip:true">会员编号</div>
                        <div data-field="name" uglcw-options="width:120,tooltip:true">会员名称</div>
                        <div data-field="sex" uglcw-options="width:80">性别</div>
                        <div data-field="birthday" uglcw-options="width:100">生日</div>
                        <div data-field="mobile" uglcw-options="width:120">电话</div>

                        <div data-field="regDateStr" uglcw-options="width:120">注册日期</div>

                        <div data-field="cardNo" uglcw-options="width:80">卡号</div>

                        <div data-field="typeName" uglcw-options="width:80">卡类型</div>

                        <div data-field="inputCash"
                             uglcw-options="width:90,template: '#= data.inputCash ? uglcw.util.toString(data.inputCash,\'n2\'): \' \'#'">剩余金额</div>

                        <div data-field="freeCost"
                             uglcw-options="width:90,template: '#= data.freeCost ? uglcw.util.toString(data.freeCost,\'n2\'): \' \'#'">剩余赠送</div>
                        <div data-field="sumValue" uglcw-options="width:80">积分</div>
                        <div data-field="cardDate" uglcw-options="width:100">有效期</div>
                        <div data-field="status"
                             uglcw-options="width:80,template: uglcw.util.template($('#formatterStatus').html())">状态</div>
                        <div data-field="address" uglcw-options="width:120,tooltip: true">地址</div>
                        <div data-field="lastTimeStr" uglcw-options="width:120">最后消费时间</div>

                        <div data-field="shopName" uglcw-options="width:100">所属门店</div>


                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-kendo-template" id="formatterStatus">
    #if(data.status ==-1){#
    退卡
    #}#
    #if(data.status ==0){#
    挂失
    #}#
    #if(data.status ==1){#
    正常
    #}#
</script>
<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:toExport();" class="k-button k-button-icontext">
        <span class="k-icon k-i-download"></span>导出会员
    </a>
    <a role="button" href="javascript:toUpCustomer();" class="k-button k-button-icontext">
        <span class="k-icon k-i-upload"></span>导入会员
    </a>

</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();

        uglcw.ui.get('#search').on('click', function () {   //搜索（查询）
            uglcw.ui.get('#grid').k().dataSource.read();
        })

        uglcw.ui.get('#reset').on('click', function () {    //重置
            uglcw.ui.clear('.form-horizontal');
        })
        uglcw.ui.loaded()
    })

    function toUpCustomer() {//导入会员
        uglcw.ui.Modal.showUpload({
            url: '${base}manager/pos/toUpMemberTemplateData',
            field: 'upFile',
            error: function () {
                console.log('error', arguments)
            },
            complete: function () {
                console.log('complete', arguments);
            },
            success: function (e) {
                if (e.response != '1') {
                    uglcw.ui.error(e.response);
                } else {
                    uglcw.ui.success('导入成功');
                    uglcw.ui.get('#grid').reload();
                }
            }
        })
    }
</script>
<tag:exporter service="posMemberService" method="queryMemberPage"
              bean="com.qweib.cloud.biz.pos.model.PosMember"
              description="出库单记录"
              beforeExport="beforeExport"

/>
<script>
    function beforeExport(param){//构造参数
        return {
            source: uglcw.ui.get('#source').value(),
            cardType:uglcw.ui.get('#cardType').value(),
            mobile:uglcw.ui.get('#mobile').value(),
            cardNo:uglcw.ui.get('#cardNo').value(),
            database:uglcw.ui.get('#database').value(),
            shopNo:uglcw.ui.get('#shopName').value(),
            name:uglcw.ui.get('#cstName').value(),
        }
    }
</script>
</body>
</html>
