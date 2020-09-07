<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>驰用T3</title>
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
                <tag:select2 name="driverId" id="driverId" tclass="pcl_sel" headerKey=""
                             headerValue="--司机--" tableName="stk_driver" displayKey="id"
                             displayValue="driver_name"/>
            </li>
            <li>
                <tag:select2 name="vehId" id="vehId" tclass="pcl_sel" headerKey=""
                             headerValue="--车辆--" tableName="stk_vehicle" displayKey="id" displayValue="veh_no"/>
            </li>
            <li>
                <input class="k-textbox" uglcw-role="textbox" uglcw-model="khNm" placeholder="客户名称">
            </li>
            <li>
                <input class="k-textbox" uglcw-role="textbox" uglcw-model="billNo" placeholder="配送单号">
            </li>

            <li>
                <input class="k-textbox" uglcw-role="textbox" value="${outNo}" uglcw-model="outNo" placeholder="发票单号">
            </li>

            <li style="display:${param.show eq 1?'':'none'}">

                <select uglcw-model="psState" uglcw-role="combobox" id="psState" uglcw-options="value: '${psState}'">
                    <option value="">配送状态</option>
                    <option value="0">待分配</option>
                    <option value="1">待接收</option>
                    <option value="2">已接收</option>
                    <option value="3">配送中</option>
                    <option value="4">已收货</option>
                    <option value="6">已生成发货单</option>
                    <option value="5">配送终止</option>
                </select>
            </li>
            <li style="display:${param.show eq 1?'':'none'}">
                <select uglcw-model="billStatus" uglcw-role="combobox" id="billStatus" uglcw-options="value: '${billStatus}'">
                    <option value="">单据状态</option>
                    <option value="1">正常单</option>
                    <option value="2">作废单</option>
                </select>
            </li>
            <li>
                <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}">
            </li>
            <li>
                <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
            </li>
            <li>
                <tag:select2 name="stkId" id="stkId" tableName="stk_storage"
                             whereBlock="status=1 or status is null"
                             headerKey="-1" headerValue=""
                             displayKey="id" displayValue="stk_name" placeholder="仓库"/>
            </li>
            <li>
                <input class="k-textbox" uglcw-role="textbox" uglcw-model="wareNm" placeholder="商品名称">
            </li>
            <li>
                <input class="k-textbox" uglcw-role="textbox" uglcw-model="remarks" placeholder="备注">
            </li>
            <li>
                <input type="checkbox" uglcw-role="checkbox" id="showProducts">
                <label style="margin-top: 10px;" class="k-checkbox-label" for="showProducts">显示商品</label>
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
                    url: '${base}manager/stkDelivery/page',
                    criteria: '.uglcw-query',
                    pageable: true,
                    dblclick:function(row){
                        showDetail(row.id);
                    },
                    aggregate:[
                     {field: 'ddNum', aggregate: 'SUM'},
                     {field: 'disAmt1', aggregate: 'SUM'},
                     {field: 'disAmt', aggregate: 'SUM'},
                    ],
                    loadFilter: {
                      data: function (response) {
                        response.rows.splice(response.rows.length - 1, 1);
                        return response.rows || []
                      },
                      total: function (response) {
                        return response.total;
                      },
                      aggregates: function (response) {
                        var aggregate = {
                        	disAmt1: 0,
                        	disAmt: 0,
                        	ddNum: 0,
                        };
                        if (response.rows && response.rows.length > 0) {
                            aggregate = uglcw.extend(aggregate, response.rows[response.rows.length - 1]);
                        }
                        return aggregate;
                      }
                     }

                    ">
            <div data-field="driverName" uglcw-options="width:80">司机</div>
            <div data-field="vehNo" uglcw-options="width:120">车辆</div>
            <div data-field="billNo" uglcw-options="
                          width:180,
                          template: function(dataItem){
                           return uglcw.util.template($('#bill-no').html())(dataItem);
                          },
                          footerTemplate: '合计'
                        ">配送单号
            </div>
            <div data-field="outNo" uglcw-options="width:160">单号</div>
            <div data-field="khNm" uglcw-options="width:140,tooltip:true">客户名称</div>
            <div data-field="outType" uglcw-options="width:130">销售类型</div>
            <div data-field="status" uglcw-options="width:100,hidden:${param.show eq 1?false:true}, template: uglcw.util.template($('#status-tpl').html())">
                单据状态
            </div>
            <div data-field="psState" uglcw-options="width:100, template: uglcw.util.template($('#ps-state-tpl').html())">
                配送状态
            </div>
            <div data-field="outDate" uglcw-options="width:140">配送日期</div>
            <div data-field="count" uglcw-options="width:700, hidden: true,
                         template: function(data){
                            return uglcw.util.template($('#product-list').html())(data.list);
                         }
                        ">商品信息
            </div>
            <div data-field="ddNum"
                 uglcw-options="width:80, format:'{0:n2}', footerTemplate:'#= uglcw.util.toString(data.ddNum,\'n2\')#'">配送数量
            </div>
            <div data-field="disAmt1"
                 uglcw-options="width:100, format:'{0:n2}', footerTemplate:'#= uglcw.util.toString(data.disAmt1,\'n2\')#'">
                配送金额
            </div>
            <div data-field="tel" uglcw-options="width:100,tooltip:true">电话</div>
            <div data-field="address" uglcw-options="width:160,tooltip:true">地址</div>
            <div data-field="shr" uglcw-options="width:120">创建人</div>
            <div data-field="remarks" uglcw-options="width:200, tooltip: true">备注</div>
            <div data-field="epCustomerName" uglcw-options="width:120">所属二批</div>
        </div>
    </div>
</div>
<script id="toolbar" type="text/x-uglcw-template">
    <c:if test="${psState eq 0}">
        <a role="button" href="javascript:sendToDriver(1);" class="k-button k-button-icontext k-grid-add-purchase">
            <span class="k-icon ion-md-car"></span>发送到司机
        </a>
        <a role="button" href="javascript:showDeliveryDriverStat();" class="k-button k-button-icontext k-grid-add-purchase">
            <span class="k-icon k-i-search"></span>待分配统计
        </a>
    </c:if>
    <c:if test="${psState ne 4 && psState ne 5 && psState ne 6}">
        <a role="button" href="javascript:sendFinish(4);" class="k-button k-button-icontext k-grid-add-purchase">
            <span class="k-icon ion-md-done-all"></span>已收货
        </a>
    </c:if>
    <c:if test="${psState ne 4 && psState ne 5 && psState ne 6}">
        <a role="button" href="javascript:sendUnFinish(5);" class="k-button k-button-icontext k-grid-add-purchase">
            <span class="k-icon ion-md-power"></span>配送终止
        </a>
    </c:if>
    <c:if test="${psState eq 6}">
        <a role="button" href="javascript:showDeliveryDriverStat();" class="k-button k-button-icontext k-grid-add-purchase">
            <span class="k-icon k-i-search"></span>配送概况
        </a>
    </c:if>
    <%--  <a role="button" href="javascript:driverMap();" class="k-button k-button-icontext k-grid-add-purchase">
          <span class="k-icon ion-md-map"></span>司机路线图
      </a>--%>
    <a role="button" href="javascript:refresh();" class="k-button k-button-icontext k-grid-add-purchase">
        <span class="k-icon k-i-refresh"></span>刷新
    </a>
    <a role="button" href="javascript:showOutList();" class="k-button k-button-icontext k-grid-add-purchase">
        <span class="k-icon k-i-search"></span>发货明细查询
    </a>


</script>
<script id="status-tpl" type="text/x-uglcw-template">
    #if(data.status == -2){#
    正常单
    #}else if(data.status == 1){#
    正常单
    #}else if(data.status == 0){#
    正常单
    #}else if(data.status == 2){#
    已作废
    #}#
</script>
<script id="ps-state-tpl" type="text/x-uglcw-template">
    # if(data.psState == 0){#
    待分配
    # } else if(data.psState == 1){ #
    待接收
    # } else if(data.psState == 2){ #
    已接收
    # } else if(data.psState == 3){ #
    配送中
    # } else if(data.psState == 4){ #
    已收货
    # } else if(data.psState == 6){ #
    已生成发货单
    # } else if(data.psState == 5){ #
    配送终止
    #}#
</script>

<script id="product-list" type="text/x-kendo-template">
    <table class="product-grid">
        <tbody>
        <tr style="font-weight: bold;">
            <td style="width: 100px;">商品名称</td>
            <td style="width: 60px;">销售类型</td>
            <td style="width: 50px;">单位</td>
            <td style="width: 60px;">规格</td>
            <c:if test="${permission:checkUserFieldPdm('stk.stkSend.lookqty')}">
                <td style="width: 40px;">数量</td>
            </c:if>
            <c:if test="${permission:checkUserFieldPdm('stk.stkSend.lookprice')}">
                <td style="width: 40px;">单价</td>
            </c:if>
            <c:if test="${permission:checkUserFieldPdm('stk.stkSend.lookamt')}">
                <td style="width: 40px;">总价</td>
            </c:if>
            <c:if test="${permission:checkUserFieldPdm('stk.stkSend.lookqty')}">
                <td style="width: 60px;">已发数量</td>
                <td style="width: 60px;">未发数量</td>
            </c:if>
        </tr>

        #for (var i=0; i< data.length; i++) { #
        <tr>
            <td>#= data[i].wareNm #</td>
            <td>#= data[i].xsTp #</td>
            <td>#= data[i].unitName #</td>
            <td>#= data[i].wareGg #</td>
            <c:if test="${permission:checkUserFieldPdm('stk.stkSend.lookqty')}">
                <td>#= data[i].qty #</td>
            </c:if>
            <c:if test="${permission:checkUserFieldPdm('stk.stkSend.lookprice')}">
                <td>#= data[i].price #</td>
            </c:if>
            <c:if test="${permission:checkUserFieldPdm('stk.stkSend.lookamt')}">
                <td>#= uglcw.util.toString(data[i].amt, "n") #</td>
            </c:if>
            <c:if test="${permission:checkUserFieldPdm('stk.stkSend.lookqty')}">
                <td>#= data[i].outQty #</td>
                <td>#= data[i].outQty1 #</td>
            </c:if>
        </tr>
        # }#
        </tbody>
    </table>
</script>
<script id="bill-no" type="text/x-kendo-template">
    <a href="javascript:showDetail(#= data.id#);" style="color: \\#337ab7;font-size: 12px; font-weight: bold;">#=
        data.billNo#</a>
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        uglcw.ui.init();
        //显示商品
        uglcw.ui.get('#showProducts').on('change', function () {
            var checked = uglcw.ui.get('#showProducts').value();
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
        uglcw.ui.openTab('物流配送信息' + id, '${base}manager/stkDelivery/show?billId=' + id);
    }

    function refresh() {
        uglcw.ui.get('#grid').reload();
    }

    function showOutList() {
        uglcw.ui.openTab('发货明细查询', '${base}manager/outdetailquery?deliveryNo=');
    }

    function sendToDriver() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (!selection) {
            return uglcw.ui.info('请选择要发送的记录');
        }
        var valid = true;
        $(selection).each(function (idx, item) {
            if (item.psState != 0) {
                valid = false;
                return false;
            }
        })
        if (!valid) {
            return uglcw.ui.info('请选择配送状态[待分配]的进行发送！');
        }
        uglcw.ui.confirm('是否确定发送到司机？', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/stkDelivery/sendToDriver',
                type: 'post',
                data: {
                    psState: 1, ids: $.map(selection, function (row) {
                        return row.id
                    }).join(',')
                },
                dataType: 'json',
                success: function (response) {
                    uglcw.ui.loaded();
                    if (response.state) {
                        uglcw.ui.success('发送成功');
                        uglcw.ui.get('#grid').reload();
                    } else {
                        uglcw.ui.error('发送失败');
                    }
                },
                error: function () {
                    uglcw.ui.error('发送失败');
                    uglcw.ui.loaded();
                }
            })

        })
    }

    function sendFinish() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (!selection) {
            return uglcw.ui.error('请选择要发送的记录');
        }
        var valid = true;
        $(selection).each(function (idx, item) {

            if (item.status == 2) {
                valid = false;
                uglcw.ui.error(item.billNo + '该单据作废，不能操作！');
                return false;
            }

            if (item.psState == 4) {
                valid = false;
                uglcw.ui.error('请选择配送状态为非[配送完成]的进行操作！');
                return false;
            }
        });

        if (!valid) {
            return
        }
        uglcw.ui.confirm('是否确定该操作？', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/stkDelivery/sendFinish',
                type: 'post',
                data: {
                    psState: 4,
                    ids: $.map(selection, function (row) {
                        return row.id
                    }).join(',')
                },
                dataType: 'json',
                success: function (response) {
                    uglcw.ui.loaded();
                    if (response.state) {
                        uglcw.ui.success('操作成功');
                        uglcw.ui.get('#grid').reload();
                    } else {
                        uglcw.ui.error('操作失败');
                    }
                },
                error: function () {
                    uglcw.ui.error('操作失败');
                    uglcw.ui.loaded();
                }
            })

        })
    }

    function sendUnFinish() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (!selection) {
            return uglcw.ui.error('请选择要操作的记录');
        }
        var valid = true;
        $(selection).each(function (idx, item) {
            if (item.status == 2) {
                valid = false;
                uglcw.ui.error(item.billNo + '该单据作废，不能操作！');
                return false;
            }

            if (item.psState == 5) {
                valid = false;
                uglcw.ui.error('请选择配送状态为非[配送中止]的进行操作！');
                return false;
            }
        });

        if (!valid) {
            return
        }
        uglcw.ui.confirm('是否确定该操作？', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/stkDelivery/sendFinish',
                type: 'post',
                data: {
                    psState: 5,
                    ids: $.map(selection, function (row) {
                        return row.id
                    }).join(',')
                },
                dataType: 'json',
                success: function (response) {
                    uglcw.ui.loaded();
                    if (response.state) {
                        uglcw.ui.success('操作成功');
                        uglcw.ui.get('#grid').reload();
                    } else {
                        uglcw.ui.error('发送失败');
                    }
                },
                error: function () {
                    uglcw.ui.error('发送失败');
                    uglcw.ui.loaded();
                }
            })

        })
    }

    function showDeliveryDriverStat(){
        var q = uglcw.ui.bind('.uglcw-query');

        if(q.sdate==null){
            q.sdate='';
        }
        if(q.edate==null){
            q.edate='';
        }

        var url = "";
        var title = "";

        if(q.psState==0){
            title = "待分配统计";
            url='${base}manager/stkDelivery/deliveryDriverDfpStat?'+ $.map(q, function(v, k){
                return k + '=' + (v);
            }).join('&');
        }
        if(q.psState==6){
            title = "配送概况";
            url='${base}manager/stkDelivery/deliveryDriverStat?'+ $.map(q, function(v, k){
                return k + '=' + (v);
            }).join('&');
        }
        if(url==""){
            return
        }
        uglcw.ui.openTab(title,url );
    }

    function driverMap() {
        uglcw.ui.openTab('司机路线图', '${base}manager/stkDelivery/toDriverMap?psState=${psState}');
    }
</script>
</body>
</html>