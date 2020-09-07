<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>客户</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <%@include file="/WEB-INF/view/v2/include/edit-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }

        .query .k-widget.k-numerictextbox {
            display: none;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal query">
                <input type="hidden" uglcw-role="numeric" uglcw-model="isDb" id="isDb" value="2">
                <input type="hidden" uglcw-role="textbox" uglcw-model="database" id="database" value="${datasource}">
                <%--   <input style="display: none;" uglcw-role="numeric" uglcw-model="nullStaff" id="nullStaff" value="0">--%>
                <li>
                    <select uglcw-role="combobox" uglcw-model="qdtpNm"
                            placeholder="客户类型"
                            uglcw-options="
                                            url: '${base}manager/queryarealist1',
                                            dataTextField: 'qdtpNm',
                                            dataValueField: 'qdtpNm',
                                            index:-1,
                                             loadFilter:{
                                             data: function(response){    //过滤数据
                                               return response.list1 || []
                                             }
                                            }
                                        "
                    >
                    </select>
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="khdjNm" placeholder="客户等级" uglcw-options="value: ''">
                        <c:forEach items="${list}" var="list">
                            <option value="${list.khdjNm}">${list.khdjNm}</option>
                        </c:forEach>
                    </select>
                </li>
                <li>
                    <input uglcw-model="khNm" uglcw-role="textbox" placeholder="客户名称">
                </li>
                <li>
                    <input uglcw-model="memberNm" uglcw-role="textbox" placeholder="业务员">
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="isDb" placeholder="客户状态">
                        <option value="2" selected="selected">正常</option>
                        <option value="1">倒闭</option>
                        <option value="3">可恢复</option>
                    </select>
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="hzfsNm" placeholder="合作方式" uglcw-options="value: ''">
                        <c:forEach items="${hzfsls}" var="hzfsls">
                            <option value="${hzfsls.hzfsNm}"
                                    <c:if test="${hzfsls.hzfsNm==customer.hzfsNm}">selected</c:if>>${hzfsls.hzfsNm}</option>
                        </c:forEach>
                    </select>
                </li>
                <li>
                    <input uglcw-model="regionId" id="regionId" uglcw-role="textbox" type="hidden">
                    <%--<input uglcw-model="regionNm" id="regionNm" uglcw-role="textbox" placeholder="客户所属片区" onclick="chooseRegion();">--%>
                    <input id="regionNm" uglcw-role="gridselector" uglcw-model="regionNm" placeholder="客户所属片区"
                           uglcw-options="allowInput: false, clearButton: false, click: chooseRegion">
                </li>
                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                </li>
                <li>
                    <input type="checkbox" uglcw-model="nullStaff" uglcw-role="checkbox"
                           id="nullStaff" value="0">
                    <label style="margin-top: 10px;" class="k-checkbox-label" for="nullStaff">无业务员客户</label>
                </li>
                <li>
                    <input type="checkbox" uglcw-model="latitude" uglcw-role="checkbox"
                           id="latitude" value="0">
                    <label style="margin-top: 10px;" class="k-checkbox-label" for="latitude">位置异常员客户</label>
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
            <div id="grid" class="uglcw-grid-compact" uglcw-role="grid"
                 uglcw-options="
                    responsive:['.header',40],
                    id:'id',
                             toolbar: uglcw.util.template($('#toolbar').html()),
                    url: '${base}manager/customerPage?dataTp=${dataTp}',
                    criteria: '.query',
                    pageable: true,
                    checkbox: true,
                    dblclick: function(row){
                        toUpdatecustomer(row);
                    }
                    ">
                <div data-field="khCode" uglcw-options="width:120">客户编码</div>
                <div data-field="khNm" uglcw-options="
                                width:120,
                                headerTemplate: uglcw.util.template($('#header_khNm').html()),
                                template:function(row){
                                    return uglcw.util.template($('#val').html())({val:row.khNm, data: row, field:'khNm'})
                                }
                                ">
                </div>
                <%--   <div data-field="linkman"
                        uglcw-options="width:120, template: '#= data.linkman === \'null\' ? \'\' : data.linkman#'">负责人
                   </div>--%>
                <div data-field="linkman" uglcw-options="
                                width:120,
                                headerTemplate: uglcw.util.template($('#header_linkman').html()),
                                template:function(row){
                                    return uglcw.util.template($('#val').html())({val:row.linkman, data: row, field:'linkman'})
                                }
                                ">
                </div>
                <%-- <div data-field="tel" uglcw-options="width:120, template: '#= data.tel === \'null\' ? \'\' : data.tel#'">
                     负责人电话
                 </div>--%>
                <div data-field="tel" uglcw-options="
                                width:120,
                                headerTemplate: uglcw.util.template($('#header_tel').html()),
                                template:function(row){
                                    return uglcw.util.template($('#val').html())({val:row.tel, data: row, field:'tel'})
                                }
                                ">
                </div>
                ad
                <%--   <div data-field="mobile"
                        uglcw-options="width:120, template: '#= data.mobile === \'null\' ? \'\' : data.mobile#'">负责人手机
                   </div>--%>
                <div data-field="mobile" uglcw-options="
                                width:120,
                                headerTemplate: uglcw.util.template($('#header_mobile').html()),
                                template:function(row){
                                    return uglcw.util.template($('#val').html())({val:row.mobile, data: row, field:'mobile'})
                                }
                                ">
                </div>
                <%--<div data-field="rzMobile" uglcw-options="width:120">认证手机</div>--%>
                <div data-field="rzMobile" uglcw-options="
								width:120,
								headerTemplate:  uglcw.util.template($('#header_edit_template').html())({title: '商城手机认证',field:'rzMobile'}),
								template:function(row){
									return uglcw.util.template($('#data_edit_template').html())({value:row.rzMobile, id:row.id, field:'rzMobile',callback:'rzMobileChange'})
								}
								">
                </div>
                <div data-field="address" uglcw-options="
                                width:120,
                                headerTemplate: uglcw.util.template($('#header_address').html()),
                                template:function(row){
                                    return uglcw.util.template($('#val').html())({val:row.address, data: row, field:'address'})
                                }
                                ">
                </div>
                <div data-field="memberNm" uglcw-options="width:100">业务员</div>
                <div data-field="qdtpNm"
                     uglcw-options="width:120, template: '#= data.qdtpNm === \'null\' ? \'\' : data.qdtpNm#'">客户类型
                </div>
                <div data-field="khdjNm"
                     uglcw-options="width:120, template: '#= data.khdjNm === \'null\' ? \'\' : data.khdjNm#'">客户等级
                </div>
                <div data-field="shopName"
                     uglcw-options="width:120, template: '#= data.shopName === \'null\' ? \'\' : data.shopName#'">加盟连锁店
                </div>
                <%-- <div data-field="bfpcNm"
                      uglcw-options="width:120, template: '#= data.bfpcNm === \'null\' ? \'\' : data.bfpcNm#'">拜访频次
                 </div>--%>
                <div data-field="bfpcNm" uglcw-options="
                                width:120,
                                headerTemplate: uglcw.util.template($('#header_bfpcNm').html()),
                                template:function(row){
                                    return uglcw.util.template($('#val').html())({val:row.bfpcNm, data: row, field:'bfpcNm'})
                                }
                                ">
                </div>
                <div data-field="xsjdNm"
                     uglcw-options="width:120, template: '#= data.xsjdNm === \'null\' ? \'\' : data.xsjdNm#'">销售阶段
                </div>
                <div data-field="sctpNm" uglcw-options="width:120">市场类型</div>
                <div data-field="hzfsNm"
                     uglcw-options="width:120, template: '#= data.hzfsNm === \'null\' ? \'\' : data.hzfsNm#'">合作方式
                </div>
                <div data-field="regionNm" uglcw-options="width:120">客户归属片区</div>
                <div data-field="shZt" uglcw-options="width:100">审核状态</div>
                <div data-field="uscCode" uglcw-options="width:160">社会信用统一代码</div>

                <div data-field="memberMobile" uglcw-options="width:120">业务员手机号</div>
                <div data-field="branchName" uglcw-options="width:100">部门</div>
                <div data-field="ghtpNm" uglcw-options="width:100">供货类型</div>
                <div data-field="pkhCode" uglcw-options="width:120">供货经销商编码</div>
                <div data-field="pkhNm" uglcw-options="width:120">供货经销商</div>
                <div data-field="jyfw" uglcw-options="width:100">销售区域</div>
                <div data-field="fgqy"
                     uglcw-options="width:100, template: '#= data.fgqy === \'null\' ? \'\' : data.fgqy#'">覆盖区域
                </div>
                <div data-field="longitude" uglcw-options="width:120">经度</div>
                <div data-field="latitude" uglcw-options="width:120">纬度</div>
                <div data-field="province" uglcw-options="width:120">省</div>
                <div data-field="city" uglcw-options="width:120">城市</div>
                <div data-field="area"
                     uglcw-options="width:120, template: '#= data.area === \'null\' ? \'\' : data.area#'">区县
                </div>
                <div data-field="openDate"
                     uglcw-options="width:120, template: '#= data.openDate === \'null\' ? \'\' : data.openDate#'">开户日期
                </div>
                <div data-field="closeDate"
                     uglcw-options="width:120, template: '#= data.closeDate === \'null\' ? \'\' : data.closeDate#'">闭户日期
                </div>
                <div data-field="isYx" uglcw-options="width:120,template: uglcw.util.template($('#formatterSt2').html())">
                    是否有效
                </div>
                <div data-field="isDb" uglcw-options="width:120,template: uglcw.util.template($('#formatterSt3').html())">
                    客户状态
                </div>
                <div data-field="remo"
                     uglcw-options="width:160, template: '#= data.remo === \'null\' ? \'\' : data.remo#'">备注
                </div>
                <div data-field="createTime" uglcw-options="width:160">创建日期</div>
                <div data-field="shTime" uglcw-options="width:160">审核时间</div>
                <div data-field="shMemberNm" uglcw-options="width:120">审核人</div>
                <%--<div data-field="erpCode" uglcw-options="width:120">ERP编码</div>--%>
                <div data-field="py" uglcw-options="width:120">助记码</div>

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
    <%-- <a role="button" href="javascript:updatekhTp();"
        class="k-button k-button-icontext">
         <span class="k-icon k-i-redo"></span>转经销商
     </a>--%>
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
    <%--<a role="button" class="k-button k-button-icontext"--%>
    <%--href="javascript:toCustomerModel();">--%>
    <%--<span class="k-icon k-i-download"></span>下载模板--%>
    <%--</a>--%>
    <%--<a role="button" class="k-button k-button-icontext"--%>
    <%--href="javascript:showUpload();">--%>
    <%--<span class="k-icon k-i-upload"></span>上传客户--%>
    <%--</a>--%>
    <%-- <a role="button" class="k-button k-button-icontext"
        href="javascript:toExport();">
         <span class="k-icon k-i-image-export"></span>导出--%>
    <a role="button" class="k-button k-button-icontext"
       href="javascript:setPrice();">
        <span class="k-icon k-i-settings"></span>设置运输费用
    </a>
    <%--    </a><a role="button" class="k-button k-button-icontext"
               href="javascript:setAutoPrice();">
            <span class="k-icon k-i-settings"></span>设置自定义费用--%>

    <a role="button" class="k-button k-button-icontext"
       href="javascript:setPy();">
        <span class="k-icon k-i-settings"></span>生成助记码
    </a>
    <a role="button" class="k-button k-button-icontext"
       href="javascript:updateCustomerType();">
        <span class="k-icon k-i-settings"></span>批量调整客户状态
    </a>
</script>

<script id="header_khNm" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('khNm');">客户名称✎</span>
</script>
<script id="header_linkman" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('linkman');">负责人✎</span>
</script>
<script id="header_tel" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('tel');">负责人电话✎</span>
</script>
<script id="header_mobile" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('mobile');">负责人手机✎</span>
</script>
<script id="header_address" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('address');">地址✎</span>
</script>
<script id="header_bfpcNm" type="text/x-uglcw-template">
    <span onclick="javascript:operatePrice('bfpcNm');">拜访频次✎</span>
</script>
<script id="val" type="text/x-uglcw-template">
    # var id = data.id #
    # if(val == null || val == undefined || val === '' || val== "undefined"){ #
    #    val = "" #
    # } #

    <input class="#=field#_input k-textbox" name="#=field#_input" uglcw-role="textbox"
           style="height:25px;display:none" onchange="changePrice(this,'#= field #',#= id #)" value='#= val #'>
    <span class="#=field#_span" id="#=field#_span_#=id#">#= val #</span>
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

<script id="batch" type="text/uglcw-template">
    <div class="layui-card">
        <div class="layui-card-body">
            <div class="form-horizontal" uglcw-role="validator" id="category">
                <div class="form-group" style="display: none">

                    <label class="control-label col-xs-6">客户类型</label>
                    <div class=" col-xs-16">
                        <tag:select2 name="customerType" id="customerType" displayValue="qdtp_nm" headerKey=""
                                     headerValue="不修改" width="120px" displayKey="id"
                                     tableName="sys_qdtype"></tag:select2>
                    </div>
                </div>
                <div class="form-group" style="display: none">
                    <label class="control-label col-xs-6">客户等级</label>
                    <div class=" col-xs-16">
                        <select uglcw-role="combobox" uglcw-model="khdjNm" placeholder="客户等级"
                                uglcw-options="index:-1">
                            <option value="">不修改</option>
                            <c:forEach items="${list}" var="list">
                                <option value="${list.khdjNm}">${list.khdjNm}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
                <div class="form-group" style="display: none">
                    <label class="control-label col-xs-6">合作方式</label>
                    <div class="col-xs-16">
                        <select uglcw-role="combobox" uglcw-model="hzfsNm" placeholder="合作方式"
                                uglcw-options="index:-1">
                            <option value="">不修改</option>
                            <c:forEach items="${hzfsls}" var="hzfsls">
                                <option value="${hzfsls.hzfsNm}"
                                        <c:if test="${hzfsls.hzfsNm==customer.hzfsNm}">selected</c:if>>${hzfsls.hzfsNm}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">客户状态</label>
                    <div class=" col-xs-16">
                        <select uglcw-role="combobox" uglcw-model="isDb" placeholder="客户状态"
                                uglcw-options="index:-1">
                            <option value="0" selected="selected">不修改</option>
                            <option value="2">正常</option>
                            <option value="1">倒闭</option>
                            <option value="3">可恢复</option>
                        </select>
                    </div>
                </div>
                <div class="form-group" style="display: none">
                    <label class="control-label col-xs-6">客户归属片区</label>
                    <div class="col-xs-16">
                        <input uglcw-role="dropdowntree" uglcw-model="regionId"
                               uglcw-options="
                                        url: 'manager/sysRegions'
                                       "
                        >
                    </div>
                </div>
            </div>
        </div>
    </div>
</script>
<script type="text/x-kendo-template" id="formatterSt2">
    #if(data.isYx==1){#
    有效
    #} else {#
    无效
    #}#

</script>
<script type="text/x-kendo-template" id="formatterSt3">
    #if (data.isDb==2) {#
    <button class="k-button k-info" onclick="updatekhIsdb(#= data.id#,1)"><i class="k-icon"></i>正常</button>
    # }else if(data.isDb=='1'){#
    <button class="k-button" onclick="updatekhIsdb(#= data.id#,2)"><i class="k-icon "></i>倒闭</button>
    # }else if(data.isDb==3){#
    <button class="k-button" onclick="updatekhIsdb(#= data.id#,2)"><i class="k-icon "></i>可恢复</button>
    #}#
</script>

<script id="product-type-selector-template" type="text/uglcw-template">
    <div class="uglcw-selector-container">
        <div style="line-height: 30px">
            已选:
            <button style="display: none;" id="_type_name" class="k-button k-info ghost"></button>
        </div>
        <div style="padding: 2px;height: 344px;">
            <input type="hidden" uglcw-role="textbox" id="_region_id">
            <input type="hidden" uglcw-role="textbox" id="_region_name">
            <div>
                <div uglcw-role="tree"
                     uglcw-options="
                                url:'${base}manager/regions',
                                id:'id',
                                expandable:function(node){
                                    return node.id == '0';
                                },
                                loadFilter:function(response){
                                    $(response).each(function(index,item){
                                        if(item.text=='根节点'){
                                            item.text='客户所属区域'
                                        }
                                    })
                                    return response;
                                },
                                select: function(e){
                                    var node = this.dataItem(e.node);
                                    var nodeId = node.id;
                                    var nodeName = node.text;
                                    if('0' == node.id){
                                        nodeId = '';
                                        nodeName = '';
                                    }
                                    uglcw.ui.get('#_region_id').value(nodeId);
                                    uglcw.ui.get('#_region_name').value(nodeName);
                                    $('#_type_name').text(node.text);
                                    $('#_type_name').show();
                                }
                            ">
                </div>
            </div>
        </div>
    </div>
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
    });

    function operatePrice(field) {
        var display = $("." + field + "_input").css('display');
        if (display == 'none') {
            $("." + field + "_input").show();
            $("." + field + "_span").hide();
        } else {
            $("." + field + "_input").hide();
            $("." + field + "_span").show();
        }
    }

    function changePrice(e, field, id) {
        $.ajax({
            url: "${base}manager/updateCustomer",
            type: "post",
            data: {
                id: id,
                field: field,
                val: e.value
            },
            success: function (data) {
                if (data == '1') {
                    $("#" + field + "_span_" + id).text(e.value);
                } else {
                    uglcw.ui.toast("保存失败");
                }
            }
        });

    }

    //修改客户是否倒闭
    function updatekhIsdb(id, isDb) {
        uglcw.ui.confirm('您确认修改客户状态吗?', function () {
            $.ajax({
                url: "manager/updatekhIsdb",
                type: "post",
                data: "id=" + id + "&isDb=" + isDb,
                success: function (data) {
                    if (data == '1') {
                        uglcw.ui.success("操作成功");
                        uglcw.ui.get('#grid').reload();//刷新页面

                    } else {
                        uglcw.ui.error("操作失败");
                        return;
                    }
                }
            });
        })
    }

    function setPrice() {//设置费用
        var selection = uglcw.ui.get('#grid').selectedRow();//选中当前行数据
        if (selection) {
            var id = selection[0].id;
            var khNm = selection[0].khNm;
            uglcw.ui.openTab(khNm + '_设置运输费用', '${base}/manager/customerwaretype?customerId=' + id);
        } else {
            uglcw.ui.warning('请选择要设置的客户！');
        }
    }

    /*    function setAutoPrice() {//设置自定义费用
            var selection = uglcw.ui.get('#grid').selectedRow();//选中当前行数据
            if (selection) {
                var id = selection[0].id;
                var khNm = selection[0].khNm;
                top.layui.index.openTabsPage('${base}/manager/autopricecustomerwaretype?customerId=' + id, khNm + '-设置自定义费用');
        } else {
            uglcw.ui.warning('请选择要设置的客户！');
        }

    }*/

    function updateShZt() {//审批
        var selection = uglcw.ui.get('#grid').selectedRow();//选中当前行数据
        if (selection) {
            uglcw.ui.Modal.open({
                area: '500px',
                content: $('#t').html(),
                okText: '审批',
                success: function (container) {
                    uglcw.ui.init($(container));//初始化
                },
                yes: function (container) {
                    var valid = uglcw.ui.get($(container).find('.form-horizontal')).validate();
                    if (valid) {
                        var chkObjs = uglcw.ui.bind($("#bind"))
                        var shZt = chkObjs.shtp
                        $.ajax({
                            url: '${base}/manager/updateShZt',
                            data: {
                                ids: $.map(selection, function (row) {  //选中多行数据审批
                                    return row.id
                                }).join(','),
                                shZt: shZt
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
        } else {
            uglcw.ui.warning('请选择要审核的数据！');
        }

    }

    function zryd() {//转业代
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) {
            var i = uglcw.ui.Modal.showGridSelector({
                btns: ['确定', '取消'],
                closable: false,
                title: false,
                url: 'manager/memberPage?memberUse=1',
                query: function (params) {
                    params.extra = new Date().getTime();

                },
                checkbox: false,
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
                        url: "manager/updateZryd",
                        type: "post",
                        data: {
                            ids: $.map(selection, function (row) {  //选中多行数据审批
                                return row.id
                            }).join(','),
                            Mid: nodes[0].memberId,
                        },
                        success: function (data) {
                            if (data == '1') {
                                uglcw.ui.success('转业代成功');
                                uglcw.ui.Modal.close(i);
                                uglcw.ui.get('#grid').k().dataSource.read();//刷新页面
                            } else {
                                uglcw.ui.error('转业代失败');
                                return;
                            }
                        }
                    });
                    console.log(nodes);

                }
            });

        } else {
            uglcw.ui.warning('请选择要转让的数据！');
        }
    }

    function setPy() {//生产助记码
        uglcw.ui.confirm('是否生成助记码', function () {
            $.ajax({
                url: '${base}/manager/updateCustomerPy',
                data: {
                    ids: 0,
                },
                type: 'post',
                success: function (json) {
                    if (json == "1") {
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

    /*

        function updatekhTp() {//转经销商
            var selection = uglcw.ui.get('#grid').selectedRow();
            if (selection) {
                uglcw.ui.confirm('确认要转经销商吗', function () {
                    $.ajax({
                        url: '${base}/manager/updatekhTp',
                    data: {
                        ids: $.map(selection, function (row) {  //选中多行数据删除
                            return row.id
                        }).join(','),
                        khTp: 1,
                    },
                    type: 'post',
                    dataType: 'json',
                    success: function (json) {
                        if (json == "1") {
                            uglcw.ui.success('操作成功');
                            uglcw.ui.get('#grid').reload();//刷新页面数据
                        } else {
                            uglcw.ui.error('操作失败');//错误提示
                            return;
                        }
                    }
                })
            })

        } else {
            uglcw.ui.warning('请选择要转客户的数据！');
        }
    }
*/

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
                        if (json) {
                            if (json == 1) {
                                uglcw.ui.success("删除成功");
                                uglcw.ui.get('#grid').k().dataSource.read();//刷新页面
                            }
                        } else {
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

    function toCustomerModel() {//下载模板
        uglcw.ui.confirm('是否下载客户上传需要的文档?', function () {
            window.location.href = '${base}manager/toCustomerModel';
        })
    }


    function showUpload() {//上传客户
        uglcw.ui.Modal.showUpload({
            url: '${base}manager/toUpCustomerExcel',
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

    function updateCustomerType() {//批量调整客户信息
        var selection = uglcw.ui.get('#grid').selectedRow();//选中当前行数据
        if (selection) {
            uglcw.ui.Modal.open({
                area: '500px',
                content: $('#batch').html(),
                success: function (container) {
                    uglcw.ui.init($(container));//初始化

                },
                yes: function (container) {
                    var valid = uglcw.ui.get($(container).find('.form-horizontal')).validate();
                    if (valid) {

                        var textbox = uglcw.ui.bind($("#category"));
                        var hzfsNm = textbox.hzfsNm;
                        var khdjNm = textbox.khdjNm;
                        var isDb = textbox.isDb;
                        var regionId = textbox.regionId;
                        $.ajax({
                            url: '${base}/manager/batchUpdateCustomerType',
                            data: {
                                ids: $.map(selection, function (row) {  //选中多行数据删除
                                    return row.id
                                }).join(','),
                                hzfsNm: hzfsNm,
                                khdjNm: khdjNm,
                                isDb: isDb,
                                regionId: regionId
                            },
                            type: 'post',
                            success: function (json) {
                                if (json != "-1") {
                                    uglcw.ui.get('#grid').k().dataSource.read();//刷新页面
                                } else {
                                    uglcw.ui.error('商品类别更新失败');
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

        } else {
            uglcw.ui.warning('请选择客户！');
        }
    }

    //添加客户
    function toaddcustomer(id) {
        uglcw.ui.openTab('添加客户', '${base}/manager/toopercustomer?khTp=2');
    }

    //修改客户
    function toUpdatecustomer(row) {
        var selection;
        if (row) {
            selection = [row];
        } else {
            selection = uglcw.ui.get('#grid').selectedRow();
        }
        if (selection) {
            var id = selection[0].id;
            var name = selection[0].khNm;
            uglcw.ui.openTab('修改客户_' + name, '${base}/manager/toopercustomer?khTp=2&Id=' + id);
        } else {
            uglcw.ui.toast("请勾选你要操作的行！")
        }
    }

    //-------------------------------订阅：start---------------------------------------------
    //订阅
    uglcw.io.on('refreshCustomer', function (data) {
        if (data == 'success') {
            uglcw.ui.get('#grid').reload();
        }
    })
    //-------------------------------订阅：end---------------------------------------------

    //商城手机认证
    function rzMobileChange(value, field, id, th, call, again) {
        if (!again) again = '';
        $.ajax({
            url: "${base}manager/changeRzMobile",
            type: "post",
            data: {id: id, mobile: value, again: again},
            success: function (data) {
                if (data.state) {
                    callSuccessFun(value, field, id);
                    uglcw.ui.success('操作成功');
                } else {
                    if (data.code) {
                        uglcw.ui.confirm(data.msg, function () {
                            rzMobileChange(value, field, id, th, null, true);
                        }, function () {

                        })
                    } else {
                        uglcw.ui.toast(data.msg);
                    }
                }
            }
        });
    }

    //客户所属区域
    function chooseRegion() {
        var i = uglcw.ui.Modal.open({
            checkbox: true,
            selection: 'single',
            title: false,
            maxmin: false,
            resizable: false,
            move: true,
            btns: ['确定', '取消'],
            area: ['400', '415px'],
            content: $('#product-type-selector-template').html(),
            success: function (c) {
                uglcw.ui.init(c);
            },
            yes: function (c) {
                var regionId = uglcw.ui.get($(c).find('#_region_id')).value();//选中树id
                var regionName = uglcw.ui.get($(c).find('#_region_name')).value();
                uglcw.ui.get("#regionId").value(regionId);
                uglcw.ui.get("#regionNm").value(regionName);
                uglcw.ui.Modal.close(i);
                return false;
            }
        })

    }
</script>
<%--<tag:exporter service="sysCustomerService" method="queryCustomer2"
              bean="com.qweib.cloud.core.domain.SysCustomer"
              condition=".query" description="客户记录"
              beforeExport="beforeExport"

/>

<script>
    function beforeExport(condition){
        condition.isDb = parseInt(condition.isDb);
        condition.khTp = 2;
        return condition;
    }
</script>--%>
</body>
</html>
