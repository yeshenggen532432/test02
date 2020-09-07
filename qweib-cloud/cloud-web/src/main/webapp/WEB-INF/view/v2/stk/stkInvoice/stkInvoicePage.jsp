<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>配货单列表</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        html, body {
            height: 100%;
            margin: 0 auto;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-card header" style="margin-bottom: 0px;">
    <div class="layui-card-body">
        <ul class="uglcw-query">
            <li>
                <input type="hidden" uglcw-model="jz" uglcw-role="textbox" value="1"/>
                <input type="hidden" uglcw-model="status" uglcw-role="textbox" value="${status}"/>

                <%--<tag:select2 name="driverId" id="driverId" tclass="pcl_sel" headerKey=""--%>
                             <%--headerValue="--司机--" tableName="stk_driver" displayKey="id"--%>
                             <%--displayValue="driver_name"/>--%>
            </li>

            <li>
                <input class="k-textbox" uglcw-role="textbox" value="${billNo}" uglcw-model="billNo" placeholder="配货单号">
            </li>

            <li>
                <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}">
            </li>
            <li>
                <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
            </li>
            <li>
                <tag:select2 name="stkId" id="stkId" tableName="stk_storage" headerKey="-1" headerValue=""
                             displayKey="id" displayValue="stk_name" placeholder="仓库"/>
            </li>
            <%--<li>--%>
                <%--<input class="k-textbox" uglcw-role="textbox" uglcw-model="wareNm" placeholder="商品名称">--%>
            <%--</li>--%>
            <li>
                <input class="k-textbox" uglcw-role="textbox" uglcw-model="remarks" placeholder="备注">
            </li>
            <li>
                <input type="checkbox" uglcw-role="checkbox" uglcw-value="1" id="showBills">
                <label style="margin-top: 10px;" class="k-checkbox-label" for="showBills">显示明细</label>
            </li>
            <li>
                <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                <button id="reset" class="k-button" uglcw-role="button">重置</button>
            </li>
        </ul>
    </div>
</div>
<div class="layui-card" style="margin-bottom: 0px;">
    <div class="layui-card-body full">
        <div id="grid" uglcw-role="grid"
             uglcw-options="
                    responsive:['.header',40],
                    id:'id',
                    toolbar: uglcw.util.template($('#toolbar').html()),
                    checkbox: true,
                    url: '${base}manager/stkInvoice/page',
                    criteria: '.uglcw-query',
                    pageable: true,
                    dblclick:function(row){
                        showDetail(row.id);
                    },
                    loadFilter: {
                      data: function (response) {
                        response.rows.splice(response.rows.length - 1, 1);
                        return response.rows || []
                      },
                      total: function (response) {
                        return response.total;
                      }
                     }

                    ">
            <%--<div data-field="driverName" uglcw-options="width:80">司机</div>--%>
            <%--<div data-field="vehNo" uglcw-options="width:120">车辆</div>--%>
            <div data-field="stkName" uglcw-options="width:120">配货仓库</div>
            <div data-field="billNo" uglcw-options="
                          width:180,
                          template: function(dataItem){
                           return uglcw.util.template($('#bill-no').html())(dataItem);
                          },
                          footerTemplate: '合计'
                        ">配货单号
            </div>
            <div data-field="billTimeStr" uglcw-options="width:140">配货日期</div>
            <div data-field="status" uglcw-options="width:100, template: uglcw.util.template($('#status-tpl').html())">
                单据状态
            </div>
            <div data-field="createName" uglcw-options="width:140">创建人</div>
            <div data-field="submitUser" uglcw-options="width:140">审批人</div>
            <div data-field="op" uglcw-options="width:230, template: uglcw.util.template($('#opt-tpl').html())">操作</div>
            <div data-field="count" uglcw-options="width:700,
                     template: function(data){
                        return kendo.template($('#bill-list').html())(data.list);
                     }
                    ">单据信息
            </div>
            <div data-field="remarks" uglcw-options="width:200, tooltip: true">备注</div>
        </div>
    </div>
</div>
<script id="toolbar" type="text/x-uglcw-template">

    <a role="button" href="javascript:refresh();" class="k-button k-button-icontext k-grid-add-purchase">
        <span class="k-icon k-i-refresh"></span>刷新
    </a>

</script>

<script id="opt-tpl" type="text-x-uglcw-template">
    #if(data.status !=2) {#
    #if(data.fhState !=1) {#
    <button class="k-button k-success"  style="display: ${auotCreateFhd}"  onclick="send(#=data.id#, '#= data.status#')"><i class="k-icon"></i>发货
    </button>
    # } #
    #if(data.psState !=1) {#
    <button class="k-button k-info" style="display: ${auotCreateFhd}" onclick="sendToDriver(this)"><i
            class="k-icon"></i>发给司机
    </button>
    # } #
    <button class="k-button k-info" onclick="cancelBill(#=data.id#, '#= data.status#')"><i
            class="k-icon"></i>作废
    </button>
    # } #
</script>

<script id="status-tpl" type="text/x-uglcw-template">
    #if(data.status == -2){#
    正常单
    #}else if(data.status == 1){#
    已配货
    #}else if(data.status == 2){#
    已作废
    #}#
</script>

<script id="bill-list" type="text/x-kendo-template">
    <table class="product-grid">
        <tbody>
        <tr style="font-weight: bold;">
            <td style="width: 100px;">单号</td>
            <td style="width: 60px;">客户</td>
            <td style="width: 60px;">车辆</td>
            <td style="width: 50px;">司机</td>
        </tr>
        #for (var i=0; i< data.length; i++) { #
        <tr>
            <td>#= data[i].sourceBillNo #</td>
            <td>#= data[i].proName #</td>
            <td>#= data[i].vehNo #</td>
            <td>#= data[i].driverName #</td>
        </tr>
        # }#
        </tbody>
    </table>
</script>
<script id="bill-no" type="text/x-kendo-template">
    <a href="javascript:showDetail(#= data.id#);" style="color: \\#337ab7;font-size: 12px; font-weight: bold;">#=
        data.billNo#</a>
</script>

<script type="text/x-uglcw-template" id="veh_driver_template">
    <div class="layui-card">
        <div class="layui-card-body">
            <div class="form-horizontal" uglcw-role="validator">
                <div class="form-group"  id="vehId_div">
                    <label class="col-xs-6">车辆</label>
                    <div class="col-xs-18">
                        <tag:select2 name="vehId" id="vehId" tclass="pcl_sel" headerKey=""
                                        headerValue="--车辆--" tableName="stk_vehicle" displayKey="id" displayValue="veh_no"/>
                     </div>
                </div>
                <div class="form-group" id="driverId_div">
                    <label class="col-xs-6">司机</label>
                    <div class="col-xs-18">
                        <tag:select2 name="driverId" id="driverId" tclass="pcl_sel" headerKey=""
                                     headerValue="--司机--" tableName="stk_driver" displayKey="id"
                                     displayValue="driver_name"/>
                    </div>
                </div>

                <div class="form-group">
                    <label class="col-xs-6">车辆同步</label>
                    <div class="col-xs-18">
                        <input type="checkbox" uglcw-role="checkbox"  id="updateRelateBill">
                        <label style="margin-top: 10px;" class="k-checkbox-label" for="updateRelateBill">单据全部派发给该车辆</label>
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
        //显示明细
        uglcw.ui.get('#showBills').on('change', function () {
            var checked = uglcw.ui.get('#showBills').value();
            var grid = uglcw.ui.get('#grid');
            if (checked) {
                grid.showColumn('count');
            } else {
                grid.hideColumn('count');
            }
        });

        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        });

        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.uglcw-query', {sdate: '${sdate}', edate: '${edate}'});
        });


        uglcw.ui.loaded()
    });

    function showDetail(id) {
        uglcw.ui.openTab('配货单信息' + id, '${base}manager/stkInvoice/show?billId=' + id);
    }

    function refresh() {
        uglcw.ui.get('#grid').reload();
    }


    function send(billId,status) {
        if (status == 2) {
            return uglcw.ui.error('该单据已作废');
        }
        uglcw.ui.confirm('确定发货吗？', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/auditSaleBill',
                data: {billId: billId},
                type: 'post',
                dataType: 'json',
                success: function (json) {
                    uglcw.ui.loaded();
                    if(json.state){
                        uglcw.ui.success(json.msg);
                        uglcw.ui.get('#grid').reload();
                    }
                    else
                    {
                        uglcw.ui.error(json.msg || '操作失败');
                    }
                },
                error: function () {
                    uglcw.ui.loaded();
                }
            })
        })

    }


    function sendToDriver(el) {
        var row = uglcw.ui.get("#grid").k().dataItem($(el).closest("tr"));
        var datas = row.list;
        var bool=true;
        var msg = "";
        var sourceBillId = "";
        var sourceBillNo = "";
        var billId = row.id;
        var driverId = 0;
        var vehId = 0;
        $.map(datas, function (p) {
            if((p.vehId==null||p.vehId==0||p.vehId==undefined)
                    ||
                (p.driverId==null||p.driverId==0||p.driverId==undefined)){
                msg = p.sourceBillNo+",车辆或司机为空，不能发货";
                bool=false;
                sourceBillId = p.sourceBillId;
                sourceBillNo = p.sourceBillNo;
                driverId = p.driverId;
                vehId = p.vehId;
                return;
            }
        })

        if(!bool){
            uglcw.ui.warning(msg+'&nbsp;<a href="javascript:setVehCar('+sourceBillId+',\''+sourceBillNo+'\','+billId+','+driverId+','+vehId+')" style="color:blue">去设置</a>');
        }else{
            uglcw.ui.confirm('确定发给司机吗？', function () {
                uglcw.ui.loading();
                $.ajax({
                    url: '${base}manager/stkInvoice/sendToDriverFromInvoice',
                    data: {billId: billId},
                    type: 'post',
                    dataType: 'json',
                    success: function (json) {
                        uglcw.ui.loaded();
                        if(json.state){
                            uglcw.ui.success(json.msg);
                            uglcw.ui.get('#grid').reload();
                        }
                        else
                        {
                            uglcw.ui.error(json.msg || '操作失败');
                        }
                    },
                    error: function () {
                        uglcw.ui.loaded();
                    }
                })
            })
        }
    }


    function cancelBill(billId,status) {
        if (status == 2) {
            return uglcw.ui.error('该单据已作废');
        }
        uglcw.ui.confirm('确定作废吗？', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/stkInvoice/cancel',
                data: {billId: billId},
                type: 'post',
                dataType: 'json',
                success: function (json) {
                    uglcw.ui.loaded();
                    if(json.state){
                        uglcw.ui.success('作废成功');
                        uglcw.ui.get('#grid').reload();
                    }
                    else
                    {
                        uglcw.ui.error(json.msg || '作废失败');
                    }
                },
                error: function () {
                    uglcw.ui.loaded();
                }
            })
        })

    }

    function setVehCar(sourceBillId,sourceBillNo,billId,driverId,vehId){
        var title =sourceBillNo+'设置车辆司机';
        var form = {
            driverId: driverId,
            vehId:vehId
        }

        var rtn = uglcw.ui.Modal.open({
            title:title,
            content: $('#veh_driver_template').html(),
            success: function (container) {
                uglcw.ui.init(container);
                uglcw.ui.bind(container, form);
            },
            yes: function (container) {
                var validator = uglcw.ui.get($(container).find('.form-horizontal'));
                if (validator.validate()) {
                    var data = uglcw.ui.bind(container);
                    uglcw.ui.confirm('确定更新吗?', function () {
                        uglcw.ui.loading();
                        var url = '${base}manager/stkInvoice/updateSubBatch';

                        var chkValue = uglcw.ui.get('#updateRelateBill').value();

                        $.ajax({
                            url:url,
                            data: {
                                vehId: data.vehId,
                                driverId: data.driverId,
                                sourceBillId: sourceBillId,
                                sourceBillNo: sourceBillNo,
                                billId:billId,
                                chkValue:chkValue
                            },
                            type: 'post',
                            success: function (response) {
                                uglcw.ui.loaded();
                                if (response.state) {
                                    uglcw.ui.success('更新成功');
                                    uglcw.ui.get('#grid').reload();
                                    uglcw.ui.Modal.close(rtn);
                                } else {
                                    uglcw.ui.error(response.msg || '更新失败');
                                }
                            },
                            error: function () {
                                uglcw.ui.error('更新失败');
                                uglcw.ui.loaded();
                            }
                        })
                    })
                }
                return false;
            }
        })

    }


</script>
</body>
</html>