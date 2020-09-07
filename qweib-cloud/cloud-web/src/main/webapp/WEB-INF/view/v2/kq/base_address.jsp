<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
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
    <div class="uglcw-layout-container">
        <div class="uglcw-layout-fixed" style="width: 410px;">
            <div class="layui-card">
                <div class="layui-card-body full">
                    <button uglcw-role="button" class="k-info" onclick="editAddress()">创建地址</button>
                    <div uglcw-role="grid" id="grid1"
                         uglcw-options="
                         responsive:[40],
						 id:'id',
                         url: '${base}manager/kqBcAddress/queryList',
                         <%--url: '${base}manager/bc/queryAddressList',--%>
                         dblclick:function(row){
                            uglcw.ui.get('#address').value(row.address);
                            uglcw.ui.get('#grid').k().setOptions({
                                autoBind: true
                            })
                         }
                        "
                    >
                        <div data-field="address" uglcw-options="width:'auto',tooltip: true">地址</div>
                        <div data-field="latLng" uglcw-options="width:150,tooltip:true,template: uglcw.util.template($('#formatterLatLng').html())">经纬度</div>
                        <div data-field="oper" uglcw-options="width:70,template: uglcw.util.template($('#formatterOper').html())">操作</div>
                    </div>
                </div>
            </div>
        </div>
        <div class="uglcw-layout-content">
            <div class="layui-card">
                <div class="query">
                    <input type="hidden" uglcw-role="textbox" uglcw-model="address" id="address">
                </div>
                <div class="layui-card-body full">
                    <div id="grid" uglcw-role="grid"
                         uglcw-options="
                            responsive:[40],
							autoBind: false,
							id:'id',
							url: '${base}manager/bc/queryKqBcPage',
							criteria: '.query',
							pageable: true,
                    ">
                        <div data-field="bcCode" uglcw-options="width:'auto'">班次编码</div>
                        <div data-field="bcName" uglcw-options="width:'auto'">班次名称</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>


<script id="formatterOper" type="text/uglcw-template">
    # if(data.type){ #
    # console.log(data) #
    <button class="k-button success" onclick="editAddress(this)">修改</button>
    # }else{ #
    <button class="k-button k-info" onclick="showAddressEdit(this,'#=data.address#')"><i class="k-icon k-i-info"></i>修改</button>
    # } #

</script>

<script id="formatterLatLng" type="text/uglcw-template">
    # var latitude = data.latitude #
    # var longitude = data.longitude #
    # if(data.latitude && data.latitude!='0'){ #
    # var s = longitude +','+ latitude #
    #= s #
    # } #
</script>

<script id="dlg" type="text/uglcw-template">
    <div class="layui-card">
        <div class="layui-card-body">
            <div class="form-horizontal" uglcw-role="validator">
                <div class="form-group">
                    <label class="control-label col-xs-8">修改地址</label>
                    <div class="col-xs-14">
                        <input uglcw-role="textbox" uglcw-model="address">
                        <input type="hidden" uglcw-role="textbox" uglcw-model="address1" id="address1">
                    </div>
                </div>
            </div>
        </div>
    </div>
</script>

<%--添加或修改--%>
<script type="text/x-uglcw-template" id="form-new-address">
    <div class="layui-card">
        <div class="layui-card-body">
            <form class="form-horizontal" uglcw-role="validator">
                <div class="form-group">
                    <input uglcw-role="textbox" uglcw-model="id" type="hidden">
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">考勤地址</label>
                    <div class="col-xs-14">
                        <input uglcw-role="textbox" uglcw-model="address" id="new-address" uglcw-validate="required">
                    </div>
                    <div class="col-xs-3">
                        <input uglcw-role="button" type="button" value="标注" onclick="showMap()"/>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">经纬度</label>
                    <div class="col-xs-7">
                        <input uglcw-role="textbox" uglcw-model="longitude" id="new-longitude"  disabled uglcw-validate="required"/>
                    </div>
                    <div class="col-xs-7">
                        <input uglcw-role="textbox" uglcw-model="latitude" id="new-latitude"  disabled uglcw-validate="required"/>
                    </div>
                </div>
            </form>
        </div>
    </div>
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<%@include file="/WEB-INF/view/v2/include/map.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();
        showLocation()
        uglcw.ui.loaded()
    })



    function showAddressEdit(e) {//修改地址
        var btn = e;
        var row = uglcw.ui.get('#grid1').k().dataItem($(btn).closest('tr'));
        console.log("行数据1："+row)
        uglcw.ui.Modal.open({
            area: '500px',
            content: $('#dlg').html(),
            success: function (container) {
                uglcw.ui.init($(container));
                uglcw.ui.bind($(container), {
                    address1: row.address,
                    address: row.address

                });
            },
            yes: function (container) {
                var valid = uglcw.ui.get($(container).find('.form-horizontal')).validate();
                if (valid) {
                    var data = uglcw.ui.bind('.form-horizontal');
                    $.ajax({
                        url: '${base}/manager/bc/updateKqAddress',
                        data: data,
                        type: 'post',
                        success: function (data) {
                            if (data.state) {
                                uglcw.ui.success('操作成功');
                                uglcw.ui.get('#grid1').reload();//刷新页面
                            } else {
                                uglcw.ui.error("操作失败");
                            }
                        }
                    })
                } else {
                    uglcw.ui.error('失败');
                    return false;
                }
            }
        });
    }

    //添加或修改
    var modalId;
    function editAddress(e) {
        var row = uglcw.ui.get('#grid1').k().dataItem($(e).closest('tr'));
        console.log("行数据2："+row)
        modalId = uglcw.ui.Modal.open({
            content: $('#form-new-address').html(),
            success: function (container) {
                uglcw.ui.init($(container));
                if (row) {
                    uglcw.ui.bind($(container), {
                        id: row.id,
                        address: row.address,
                        longitude: row.longitude,
                        latitude: row.latitude,
                    });
                }
            },
            yes: function (container) {
                var valid = uglcw.ui.get($(container).find('form')).validate();
                if (!valid) {
                    return false;
                }
                var data = uglcw.ui.bind($(container).find('form'));
                $.ajax({
                    url: '${base}/manager/kqBcAddress/save',
                    data: data,
                    type: 'post',
                    success: function (data) {
                        if (data.state) {
                            uglcw.ui.success(data.msg);
                            uglcw.ui.get('#grid1').reload();//刷新页面
                            uglcw.ui.Modal.close(modalId)
                        } else {
                            uglcw.ui.error("操作失败");
                        }
                    }
                })
                return false;
            }
        })
    }


    //显示地图
    function showMap() {
        var oldCity, oldLng, oldLat, oldAddress;
        oldLng = uglcw.ui.get("#new-longitude").value();
        oldLat = uglcw.ui.get("#new-latitude").value();
        oldAddress = uglcw.ui.get("#new-address").value();
        if(!oldLng || (oldLng == '0')){
            oldLng = mLng;
            oldLat = mLat;
        }
        g_showMap({oldLng: oldLng, oldLat: oldLat, searchCondition: oldAddress, city: oldCity}, function (data) {
            uglcw.ui.get("#new-longitude").value(data.lng);
            uglcw.ui.get("#new-latitude").value(data.lat);
            uglcw.ui.get("#new-address").value(data.street + data.streetNumber);
            uglcw.ui.success('获取成功');
        });
    }

    //定位
    var mLng, mLat;
    function showLocation() {
        uglcw_location(function (r) {
            mLat = r.latitude;
            mLng = r.longitude;
        })
    }
</script>
</body>
</html>
