<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>经销商</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }
        .query .k-widget.k-numerictextbox{
            display: none;
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
                    <div class="form-horizontal query" id="choiceBox">
                        <input style="display: none;" type="hidden" uglcw-role="numeric" uglcw-model="isDb" id="isDb" value="2">
                        <input type="hidden" uglcw-role="textbox" uglcw-model="database" id="database" value="${datasource}">
                        <input  style="display: none;" uglcw-role="numeric" uglcw-model="khTp" id="khTp" value="1">
                        <div class="form-group" style="margin-bottom: 10px;">
                            <div class="col-xs-3">
                                <input uglcw-model="khNm" uglcw-role="textbox" placeholder="经销商名称">
                            </div>
                            <div class="col-xs-3">
                                <input uglcw-model="memberNm" uglcw-role="textbox" placeholder="业务员">
                            </div>

                            <div class="col-xs-3">
                                <select uglcw-role="combobox" uglcw-model="isDb" placeholder="经销商状态">
                                    <option value="">全部</option>
                                    <option value="2" selected="selected">正常</option>
                                    <option value="1">倒闭</option>
                                    <option value="3">可恢复</option>
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
                         uglcw-options="
                    id:'id',
                    toolbar: kendo.template($('#toolbar').html()),
                    url: 'manager/customerPage?khTp=1&dataTp=${dataTp}',
                    criteria: '.query',
                    pageable: true,
                    ">
                        <div data-field="inDate" uglcw-options="
                        width:50, selectable: true, type: 'checkbox', locked: true,
                        headerAttributes: {'class': 'uglcw-grid-checkbox'}
                        "></div>
                        <div data-field="khCode" uglcw-options="width:120">经销商编码</div>
                        <div data-field="khNm" uglcw-options="width:160">经销商名称</div>
                        <div data-field="jxsjbNm" uglcw-options="width:100, template: '#= data.jxsjbNm === \'null\' ? \'\' : data.jxsjbNm#'">经销商级别</div>
                        <div data-field="jxsflNm" uglcw-options="width:120, template: '#= data.jxsflNm === \'null\' ? \'\' : data.jxsflNm#'">经销商分类</div>
                        <div data-field="jxsztNm" uglcw-options="width:120, template: '#= data.jxsztNm === \'null\' ? \'\' : data.jxsztNm#'">经销商状态</div>
                        <div data-field="bfpcNm" uglcw-options="width:120, template: '#= data.bfpcNm === \'null\' ? \'\' : data.bfpcNm#'">拜访频次</div>
                        <div data-field="memberNm" uglcw-options="width:120">业务员</div>
                        <div data-field="memberMobile" uglcw-options="width:120">业务员手机号</div>
                        <div data-field="branchName" uglcw-options="width:120">部门</div>
                        <div data-field="shZt" uglcw-options="width:120, template: '#= data.shZt === \'null\' ? \'\' : data.shZt#'">审核状态</div>
                        <div data-field="fman" uglcw-options="width:120, template: '#= data.fman === \'null\' ? \'\' : data.fman#'">法人</div>
                        <div data-field="ftel" uglcw-options="width:120, template: '#= data.ftel === \'null\' ? \'\' : data.ftel#'">法人电话</div>
                        <div data-field="linkman" uglcw-options="width:100, template: '#= data.linkman === \'null\' ? \'\' : data.linkman#'">主要联系人</div>
                        <div data-field="tel" uglcw-options="width:100, template: '#= data.tel === \'null\' ? \'\' : data.tel#'">联系人电话</div>
                        <div data-field="mobile" uglcw-options="width:160, template: '#= data.mobile === \'null\' ? \'\' : data.mobile#'">联系人手机</div>
                        <div data-field="address" uglcw-options="width:275">收货地址</div>
                        <div data-field="longitude" uglcw-options="width:100">经度</div>
                        <div data-field="latitude" uglcw-options="width:100">纬度</div>
                        <div data-field="province" uglcw-options="width:100">省</div>
                        <div data-field="city" uglcw-options="width:100">城市</div>
                        <div data-field="area" uglcw-options="width:100, template: '#= data.area === \'null\' ? \'\' : data.area#'">区县</div>
                        <div data-field="jyfw" uglcw-options="width:100">经营范围</div>
                        <div data-field="fgqy" uglcw-options="width:100, template: '#= data.fgqy === \'null\' ? \'\' : data.fgqy#'">覆盖区域</div>
                        <div data-field="nxse" uglcw-options="width:100">年销售额</div>
                        <div data-field="ckmj" uglcw-options="width:100">仓库面积</div>
                        <div data-field="isYx" uglcw-options="width:100,template: uglcw.util.template($('#isYx').html())">是否有效</div>
                        <div data-field="isOpen" uglcw-options="width:120,template: uglcw.util.template($('#isOpen').html())">是否开户</div>
                        <div data-field="isDb" uglcw-options="width:120,template: uglcw.util.template($('#formatterSt4').html())">经销商状态</div>
                        <div data-field="openDate" uglcw-options="width:120">开户日期</div>
                        <div data-field="closeDate" uglcw-options="width:120">闭户日期</div>
                        <div data-field="dlqtpl" uglcw-options="width:120">代理其他品类</div>
                        <div data-field="dlqtpp" uglcw-options="width:120">代理其他品牌</div>
                        <div data-field="remo" uglcw-options="width:160, template: '#= data.remo === \'null\' ? \'\' : data.remo#'">备注</div>
                        <div data-field="createTime" uglcw-options="width:160">创建日期</div>
                        <div data-field="shTime" uglcw-options="width:160">审核时间</div>
                        <div data-field="shMemberNm" uglcw-options="width:80">审核人</div>
                        <div data-field="erpCode" uglcw-options="width:80">ERP编码</div>
                        <div data-field="py" uglcw-options="width:120">助记码</div>

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:toaddcustomer();"
       class="k-button k-button-icontext">
        <span class="k-icon k-i-plus-outline"></span>添加
    </a>
    <a role="button" href="javascript:toUpdatecustomer();"
       class="k-button k-button-icontext">
        <span class="k-icon k-i-pencil"></span>修改</a>
    <a role="button" href="javascript:updatekhTp();"
       class="k-button k-button-icontext">
        <span class="k-icon k-i-redo"></span>转客户
    </a>
    <a role="button" href="javascript:zryd();"
       class="k-button k-button-icontext">
        <span class="k-icon k-i-redo"></span>转业代
    </a>
    <a role="button" href="javascript:updateShZt();"
       class="k-button k-button-icontext k-grid-add-other">
        <span class="k-icon k-i-checkmark"></span>审批</a>
    <a role="button" class="k-button k-button-icontext"
       href="javascript:toDel();">
        <span class="k-icon k-i-trash"></span>删除
    </a>
    <a role="button" class="k-button k-button-icontext"
       href="javascript:toExport();">
        <span class="k-icon k-i-image-export"></span>导出
    </a><a role="button" class="k-button k-button-icontext"
           href="javascript:setPrice();">
        <span class="k-icon k-i-settings"></span>设置费用
    </a><a role="button" class="k-button k-button-icontext"
           href="javascript:setPy();">
        <span class="k-icon k-i-js"></span>生成助记码
    </a>
</script>

<script id="t" type="text/uglcw-template">
    <div class="layui-card">
        <div class="layui-card-body">
            <div class="form-horizontal" uglcw-role="validator" id="bind">
                <div class="form-group">
                    <input uglcw-role="textbox" type="hidden" uglcw-model="idz"/>
                    <div class="control-label  col-xs-16">
                        <ul uglcw-role="radio" uglcw-model="shtp"
                            uglcw-options='"layout":"horizontal","dataSource":[{"text":"通过","value":"审核通过"},{"text":"不通过","value":"审核不通过"}]'></ul>
                    </div>
                </div>
            </div>
        </div>
    </div>

</script>
<script type="text/x-kendo-template" id="isYx">
    #if(data.isYx==1){#
    有效
    #} else {#
    无效
    #}#

</script>
<script type="text/x-kendo-template" id="isOpen">
    #if(data.isOpen==1){#
    是
    #} else {#
    否
    #}#

</script>
<script type="text/x-kendo-template" id="formatterSt4">
    #if (data.isDb==2) {#
    <button class="k-button" onclick="updatekhIsdb(#= data.id#,1)"><i class="k-icon "></i>正常</button>
    # }else if(data.isDb=='1'){#
    <button class="k-button" onclick="updateStatus(#= data.id#,2)"><i class="k-icon "></i>倒闭</button>
    # }else if(data.isDb==3){#
    <button class="k-button" onclick="updateStatus(#= data.id#,2)"><i class="k-icon "></i>可恢复</button>
    #}#


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


        resize();
        $(window).resize(resize)
        uglcw.ui.loaded()
    })

    var delay;

    function resize() {
        if (delay) {
            clearTimeout(delay);
        }
        delay = setTimeout(function () {
            var grid = uglcw.ui.get('#grid').k();
            var padding = 15;
            var height = $(window).height() - padding - $('.header').height() - $('.k-grid-toolbar').height();
            grid.setOptions({
                height: height,
                autoBind: true
            })
        }, 200)
    }
    //修改客户是否倒闭
    function updatekhIsdb(id,isDb){
        $.ajax({
            url:"manager/updatekhIsdb",
            type:"post",
            data:"id="+id+"&isDb="+isDb,
            success:function(data){
                if(data=='1'){
                    uglcw.ui.success("操作成功");
                    uglcw.ui.get('#grid').reload();//刷新页面

                }else{
                    uglcw.ui.error("操作失败");
                    return;
                }
            }
        });
    }

    function setPrice() {
        var selection = uglcw.ui.get('#grid').selectedRow();//选中当前行数据
        if (selection) {
            var id = selection[0].id;
            var khNm = selection[0].khNm;
            top.layui.index.openTabsPage('${base}/manager/customerwaretype?customerId=' + id, '设置费用' + khNm);
        } else {
            uglcw.ui.warning('请选择要设置的客户！');
        }
    }
    function zryd() { //转业代
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            uglcw.ui.Modal.showGridSelector({
                closable: false,
                title: false,
                url: 'manager/memberPage?memberUse=1',
                query: function (params) {
                    params.extra = new Date().getTime();
                },
                checkbox: true,
                width: 650,
                height: 400,
                criteria: '<input placeholder="姓名" uglcw-role="textbox" uglcw-model="memberNm">',
                columns: [
                    {field: 'memberNm', title: '姓名', width: 180},
                    {field: 'memberMobile', title: '手机号', width: 180},
                    {field: 'branchName', title: '部门', width: 180},
                ],
                yes: function (nodes) {
                    $.ajax({
                        url:"manager/updateZryd",
                        type:"post",
                        data:{
                            ids: $.map(selection, function (row) {  //选中多行数据审批
                                return row.id
                            }).join(','),
                            Mid:selection[0].memId
                        },
                        success:function(data){
                            if(data=='1'){
                                uglcw.ui.success('转业代成功');
                                uglcw.ui.get('#grid').k().dataSource.read();//刷新页面
                            }else{
                                uglcw.ui.error('转业代失败');
                                return;
                            }
                        }
                    });
                    console.log(nodes);
                }
            })
        }else{
            uglcw.ui.warning('请选择要转让的数据！');
        }
    }

    function  updateShZt() {  //审批
        var selection = uglcw.ui.get('#grid').selectedRow();//选中当前行数据
        if(selection){
        uglcw.ui.Modal.open({
            area: '500px',
            content: $('#t').html(),
            okText:'审批',
            success: function (container) {
                uglcw.ui.init($(container));//初始化
            },
            yes: function (container) {
                var valid = uglcw.ui.get($(container).find('.form-horizontal')).validate();
                if (valid) {
                    var chkObjs=uglcw.ui.bind($("#bind"))
                    var shZt=chkObjs.shtp
                    $.ajax({
                        url: '${base}/manager/updateShZt',
                        data: {
                            ids: $.map(selection, function (row) {  //选中多行数据审批
                                return row.id
                            }).join(','),
                            shZt:shZt
                        },
                        type: 'post',
                        success: function (data) {
                            if (data == "1") {
                                uglcw.ui.success('审核成功');
                                uglcw.ui.get('#grid').k().dataSource.read();//刷新页面
                            } else {
                                uglcw.ui.error('审核失败');
                                uglcw.ui.get('#grid').k().dataSource.read();//刷新页面
                                return;
                            }
                        }
                    })
                } else {
                    uglcw.ui.error('失败');
                    return false;
                }
            }
        });
        }else {
            uglcw.ui.warning('请选择要审核的数据！');
        }

    }

    function updatekhTp() {//转客户
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            uglcw.ui.confirm('确认要转客户吗', function () {
                $.ajax({
                    url: '${base}/manager/updatekhTp',
                    data: {
                        ids: $.map(selection, function (row) {  //选中多行数据删除
                            return row.id
                        }).join(','),
                        khTp: 2,
                    },
                    type: 'post',
                    dataType: 'json',
                    success: function (json) {
                        if (json=="1") {
                            uglcw.ui.success('操作成功');
                            uglcw.ui.get('#grid').reload();//刷新页面数据
                        } else {
                            uglcw.ui.error('操作失败');//错误提示
                            return;
                        }
                    }
                })
            })

        }else{
            uglcw.ui.warning('请选择要转客户的数据！');
        }

    }
function setPy() {//生产助记码
    uglcw.ui.confirm('是否生成助记码', function () {
        $.ajax({
            url: '${base}/manager/updateCustomerPy',
            data: {
                ids:0,
            },
            type: 'post',
            success: function (json) {
                if (json=="1") {
                    uglcw.ui.success('操作成功');
                    uglcw.ui.get('#grid').reload();//刷新页面数据
                } else {
                    uglcw.ui.error('操作失败');//错误提示
                    return;
                }
            }
        })
    })

}

    function toDel() {//删除
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) { //判断是否为空
            uglcw.ui.confirm('您确认想要删除记录吗?', function () {
                $.ajax({
                    url: '${base}/manager/delcustomer',
                    data: {
                        ids: $.map(selection, function (row) {  //选中多行数据删除
                            return row.id
                        }).join(',')
                    },
                    type: 'post',
                    success: function (json) {
                        if (json == 1) {
                                uglcw.ui.success("删除成功");
                                uglcw.ui.get('#grid').reload();//刷新页面
                        } else if(json ==1) {
                            uglcw.ui.error("删除失败");//错误提示
                            return;
                        }
                    }
                })
            })
        } else {
            uglcw.ui.warning('请选择要删除的数据！');
        }
    }

    //添加客户
    function toaddcustomer(id) {
        uglcw.ui.openTab('添加客户','${base}/manager/toopercustomer?khTp=1');
    }
    //修改客户
    function toUpdatecustomer() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            var id = selection[0].id;
            var name = selection[0].khNm;
            uglcw.ui.openTab('修改客户_'+name,'${base}/manager/toopercustomer?khTp=1&Id='+id);
        }else{
            uglcw.ui.toast("请勾选你要操作的行！")
        }
    }
    //-------------------------------订阅：start---------------------------------------------
    //订阅
    uglcw.io.on('refreshCustomer-jxs', function(data){
        if(data == 'success'){
            uglcw.ui.get('#grid').reload();
        }
    })
    //-------------------------------订阅：end---------------------------------------------
</script>
<tag:exporter service="sysCustomerService" method="queryCustomer2"
              bean="com.qweib.cloud.core.domain.SysCustomer"
              condition=".query" description="经销商记录"
              beforeExport="beforeExport"
/>
<script>
    function beforeExport(condition){
        condition.isDb = parseInt(condition.isDb);
        return condition;
    }
</script>

</body>
</html>
