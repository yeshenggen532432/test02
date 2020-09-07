<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>公司基础信息管理</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-card">
        <div class="layui-card-header">
            <button id="save" uglcw-role="button" class="k-primary" data-icon="save" onclick="javascript:save();">
                保存
            </button>
        </div>
        <div class="layui-card-body">
            <form class="form-horizontal" uglcw-role="validator">
                <div class="layui-card">
                    <div class="layui-card-body">
                        <input uglcw-model="id" id="id" value="${company.id}" uglcw-role="textbox"
                               type="hidden"/>
                        <div class="form-group">
                            <label class="control-label col-xs-3">企业名称</label>
                            <div class="col-xs-4">
                                <input id="name" uglcw-validate="required" uglcw-role="textbox" uglcw-model="name"
                                       value="${company.name}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3">所属行业</label>
                            <div class="col-xs-12">
                                <input uglcw-role="combobox" uglcw-model="industryId" style="width: 243px;"
                                       id="industryId"
                                       uglcw-options="
                                            url: '${base}manager/company/industry',
                                            autoWidth: true,
                                            loadFilter:{
                                                data: function(response){
                                                    return response.data ||[];
                                                }
                                            },
                                            change: loadCategory,
                                            value:'${company.industryId}',
                                            dataTextField: 'name',
                                            dataValueField: 'id'
                                            "
                                >
                                <input style="width: 220px;" id="category" uglcw-role="dropdowntree" uglcw-options="
                                            value:'${company.categoryId}',
                                            dataTextField: 'name',
                                            dataValueField: 'id',
                                            url: '${base}manager/company/category',
                                            autoWidth: true,
                                            loadFilter:function(response){
                                                return response.data ||[];
                                            },
											placeholder:'所属种类'
										" uglcw-model="categoryId">

                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3">经营品牌</label>
                            <div class="col-xs-4">
                                <input id="brand" uglcw-role="textbox"
                                       uglcw-model="brand" value="${company.brand}">
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="control-label col-xs-3">负责人</label>
                            <div class="col-xs-4">
                                <input id="leader" uglcw-role="textbox"
                                       uglcw-model="leader" value="${company.leader}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3">联系电话</label>
                            <div class="col-xs-4">
                                <input id="telephone" uglcw-role="textbox"
                                       uglcw-model="tel" value="${company.tel}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3">邮箱</label>
                            <div class="col-xs-4">
                                <input id="email" uglcw-role="textbox"
                                       uglcw-model="email" value="${company.email}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3">地址</label>
                            <div class="col-xs-4">
                                <input id="address" uglcw-role="textbox"
                                       uglcw-model="address" value="${company.address}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3">员工人数</label>
                            <div class="col-xs-4">
                                <input id="staffNumber" uglcw-role="textbox"
                                       uglcw-model="employeeCount" value="${company.employeeCount}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3">业务总人数</label>
                            <div class="col-xs-4">
                                <input id="staffCount" uglcw-role="textbox"
                                       uglcw-model="salesmanCount" value="${company.salesmanCount}">
                            </div>
                        </div>
                        <!--<div class="form-group">
                            <label class="control-label col-xs-3">营业执业号</label>
                            <div class="col-xs-4">
                                <input id="businessNumber" uglcw-role="textbox"
                                       uglcw-model="bizLicenseNumber" value="${company.bizLicenseNumber}">
                            </div>
                        </div>-->


                       <!-- <div class="form-group">
                            <label class="control-label col-xs-3">营业执业图片</label>
                            <div class="col-xs-16">
                                <div id="album1" uglcw-model="bizLicensePic"
                                     uglcw-options="accept:'image/*', cropper: 2,multiple:false,limit:1, dataSource: [
												<c:if test="${! empty company.bizLicensePic}">
                                                    {
                                                       id: 1,
                                                       url: '${company.bizLicensePic}',
                                                       thumb: '${company.bizLicensePic}'
                                                    }
                                                </c:if>
												],

                                                 async:{
                                            saveUrl: '${base}manager/company/uploadLogo',
                                            saveField: 'file'
                                             },
                                             success: function(response){
                                                if(response.code == 200){
                                                    var url = '/upload/' + response.data.fileNames[0];
                                                    return {
                                                        thumb: url,
                                                        url: url
                                                    }
                                                }
                                             }" uglcw-role="album"></div>
                            </div>
                        </div>
                    </div>-->
                </div>
            </form>
        </div>
    </div>
</div>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        //ui:初始化
        uglcw.ui.init();
        uglcw.ui.loaded();
        var industryId = uglcw.ui.get('#industryId').value();
        if (industryId) {
            loadCategory();
        }
    })

    function loadCategory() {
        $.ajax({
            url: '${base}manager/company/category',
            data: {
                industryId: uglcw.ui.get('[uglcw-model=industryId]').value()
            },
            success: function (response) {
                if (response.code == 200) {
                    var data = response.data || []
                    var nodes = uglcw.util.arrayToTree(data, {
                        parent: 'parentId',
                        children: 'items',
                        root: '-1'
                    })
                    uglcw.ui.get('#category').k().dataSource.data(nodes)
                }
            }
        })
    }


    //保存
    function save() {
        var name = uglcw.ui.get('#name').value();
        if (name == null) {
            uglcw.ui.warning('请输入企业名称')
        }
        if (!uglcw.ui.get('form').validate()) {
            return;
        }
        var data = uglcw.ui.bind('form');
        //logo
        if (data.bizLicensePic && data.bizLicensePic.length > 0) {
            data.bizLicensePic = data.bizLicensePic[0].url
        }
        uglcw.ui.confirm('确定保存吗？', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/company',
                type: 'post',
                data: data,
                success: function (response) {
                    uglcw.ui.loaded();
                    if (response.success) {
                        uglcw.ui.success('保存成功');
                        setTimeout(function () {
                            uglcw.ui.reload()
                        }, 1500)
                    } else {
                        uglcw.ui.error('保存失败');
                    }
                },
                error: function () {
                    uglcw.ui.loaded();
                }
            })
        })
    }


</script>
</body>
</html>
