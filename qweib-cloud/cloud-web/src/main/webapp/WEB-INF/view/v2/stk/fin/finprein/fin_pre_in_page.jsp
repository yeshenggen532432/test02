<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>驰用T3</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }

        .row-color-blue {
            color: blue;
            text-decoration: line-through;
            font-weight: bold;
        }

        .row-color-pink {
            color: #FF00FF;
            font-weight: bold;
        }

        .row-color-red {
            color: red;
            font-weight: bold;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal" id="export">
                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                </li>
                <li>
                    <input type="hidden" uglcw-model="jz" value="1" uglcw-role="textbox">
                    <input uglcw-role="textbox" uglcw-model="billNo" placeholder="预收单号">
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="proName" placeholder="往来单位">
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="itemName" placeholder="明细科目名称">
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="status" placeholder="单据状态">
                        <option value="-1">单据状态</option>
                        <option value="1">已审核</option>
                        <option value="0">未审核</option>
                        <option value="2">作废</option>
                        <option value="3">被冲红单</option>
                        <option value="4">冲红单</option>
                    </select>
                </li>
                <li>
                    <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                    <button id="reset" class="k-button" uglcw-role="button">重置</button>
                </li>
                <li style="width: 250px !important; padding-top: 5px">
                    <span style="background-color:#FF00FF;border: 1;color:white ">&nbsp;被冲红单&nbsp;</span>
                    &nbsp;<span style="background-color:red;border: 1;color:white">&nbsp;&nbsp;&nbsp;冲红单&nbsp;&nbsp;&nbsp;</span>
                    &nbsp;<span style="background-color:blue;border: 1;color:white">&nbsp;&nbsp;&nbsp;作废单&nbsp;&nbsp;&nbsp;</span>
                </li>
            </ul>
        </div>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options="{
                    toolbar: kendo.template($('#toolbar').html()),
                     dblclick:function(row){
                       uglcw.ui.openTab('往来预收信息'+row.id, '${base}manager/showFinPreInEdit?billId='+ row.id+$.map( function(v, k){
                        return k+'='+(v||'');
                       }).join('&'));
                     },
                    responsive:['.header',40],
                    id:'id',
                    pageable: true,
                    rowNumber: true,
                    criteria: '.uglcw-query.form-horizontal',
                    url: 'manager/queryFinPreInPage',
                      dataBound: function(){
                        var data = this.dataSource.view();
                        $(data).each(function(idx, row){
                            var clazz = ''
                            if(row.status == 2){
                                clazz = 'row-color-blue';
                            }else if(row.status == 3){
                                clazz = 'row-color-pink';
                            }else if(row.status == 4){
                                clazz = 'row-color-red';
                            }
                            $('#grid tr[data-uid='+row.uid+']').addClass(clazz);
                        })
                    },
                    }">

                <div data-field="billNo" uglcw-options="width:170">预收单号</div>
                <div data-field="billTimeStr" uglcw-options="width:160">单据日期</div>
                <div data-field="proName" uglcw-options="width:160">往来单位</div>
                <div data-field="accName" uglcw-options="width:160">账户名称</div>
                <div data-field="_operator"
                     uglcw-options="width:300, template: uglcw.util.template($('#formatterSt3').html())">操作
                </div>
                <div data-field="totalAmt" uglcw-options="width:120">预收金额</div>
                <div data-field="payAmt" uglcw-options="width:120">已抵扣金额</div>
                <div data-field="backAmt" uglcw-options="width:120">还款金额</div>
                <div data-field="freeAmt" uglcw-options="width:120">核销金额</div>
                <div data-field="status"
                     uglcw-options="width:80, template: uglcw.util.template($('#formatterStatus').html())">状态
                </div>
                <div data-field="count"
                     uglcw-options="width:160,template: function(data){
                            return kendo.template($('#formatterSt').html())(data.list);
                         }">科目信息
                </div>

                <div data-field="remarks" uglcw-options="width:120">备注</div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:newBill();" class="k-button k-button-icontext">
        <span class="k-icon k-i-plus-outline"></span>往来预收开单
    </a>

    <a role="button" href="javascript:showPayStat();" class="k-button k-button-icontext">
        <span class="k-icon k-i-zoom"></span>预收款统计
    </a>

</script>
<script type="text/x-kendo-template" id="formatterStatus">
    #if(data.status==0){#
    未审批
    #}else if(data.status==1){#
    已审批
    #}else if(data.status==2){#
    作废
    #}else if(data.status==3){#
    被冲红单
    #}else if(data.status==4){#
    冲红单
    #}#
</script>
<script type="text/x-kendo-template" id="formatterSt3">
    # if(data.status =='1' || data.status ==0){ #
    <button class="k-button k-error" onclick="cancelBill(#= data.id#, 1)"><i class="k-icon"></i>作废</button>
    # } #

    # if(data.status =='0'){ #
    <button class="k-button k-success" onclick="auditBill1(#= data.id#, 1)"><i class="k-icon "></i>审核</button>
    # } #

    # if(data.totalAmt > (data.payAmt+data.freeAmt+data.backAmt) && data.status==1 ){ #
    <button class="k-button k-info " onclick="toFinReturn(this,#= data.id#)">还款</button>
    <button class="k-button k-info" onclick="toFreePay(this,#= data.id#)">核销</button>
    # } #

    # if(data.backAmt >0||data.freeAmt >0||data.payAmt >0){ #
    <button class="k-button k-info" onclick="showDetail(#= data.id#)">还款明细</button>
    # } #

</script>
<script id="formatterSt" type="text/x-kendo-template">
    <table class="product-grid">
        <tbody>
        <tr style="font-weight: bold;">
            <td style="width: 10px;">明细科目名称</td>
            <td style="width: 5px;">预收金额</td>
        </tr>
        #for (var i=0; i< data.length; i++) { #
        <tr>
            <td>#= data[i].itemName #</td>
            <td>#= data[i].amt #</td>
        </tr>
        # }#
        </tbody>
    </table>
</script>

<script id="t" type="text/uglcw-template">
    <div class="layui-card">
        <div class="layui-card-body">
            <div class="form-horizontal" uglcw-role="validator" id="verification_sheet">
                <div class="form-group">
                    <label class="control-label col-xs-8">核销金额</label>
                    <div class="col-xs-14">
                        <input type="hidden" uglcw-role="textbox" id="billId" uglcw-model="billId"/>
                        <input uglcw-role="textbox" uglcw-model="freeAmt" id="freeAmt" onchange="changeAmt(this,'itemFreeGrid')" uglcw-validate="required">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">核销科目</label>

                    <div class="col-xs-14">
                        <select uglcw-role="combobox" id="costId" uglcw-model="costId"
                                uglcw-options="
                                  url: '${base}manager/queryUseIncomeItemList?typeName=营业外收入',
                                  loadFilter:{
                                    data: function(response){
                                    var itemId = '';
                                    $(response.rows).each(function (i, row) {
                                           if(row.itemName=='核销未付款项'){
                                                itemId = row.id;
                                           }
                                       });
                                       uglcw.ui.get('#costId').value(itemId);
                                    return response.rows ||[];
                                    }
                                  },
                                  dataTextField: 'itemName',
                                  dataValueField: 'id'
                                "
                        >
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">备注</label>
                    <div class="col-xs-14">
                        <textarea uglcw-role="textbox" uglcw-model="remarks"></textarea>
                    </div>
                </div>
                <div class="form-group" id="inFreeItemDiv">
                    <div id="itemFreeGrid" uglcw-role="grid"
                         uglcw-options='
                          id: "id",
                          editable: true,
                          height:130,
                          navigatable: true'
                    >
                        <div data-field="itemId" uglcw-options="hidden:true,editable: false">明细科目Id</div>
                        <div data-field="itemName" uglcw-options="width: 110,editable: false">明细科目名称</div>
                        <div data-field="initAmt"
                             uglcw-options="width:70,editable: false">
                            剩余金额
                        </div>
                        <div data-field="amt"
                             uglcw-options="width:70, format:'{0:n2}',schema:{type:'number'}">
                            核销金额
                        </div>
                        <div data-field="options" uglcw-options="width: 60, command:'destroy'">
                            操作
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</script>


<script id="current_receipts" type="text/uglcw-template">
    <div class="layui-card">
        <div class="layui-card-body">
            <div class="form-horizontal  proceeds" uglcw-role="validator">
                <input type="hidden" uglcw-model="billId" uglcw-role="textbox"/>
                <div class="form-group">
                    <label class="control-label col-xs-8">还款对象</label>
                    <div class="col-xs-14">
                        <input type="hidden" uglcw-model="objId" uglcw-role="textbox"/>
                        <input uglcw-role="textbox" uglcw-model="objName" readonly>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">已还款</label>
                    <div class="col-xs-14">
                        <input uglcw-role="textbox" uglcw-model="payAmt" disabled>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">应还款</label>
                    <div class="col-xs-14">
                        <input uglcw-role="textbox" uglcw-model="needRec" disabled>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">还款时间</label>
                    <div class="col-xs-14">
                        <input uglcw-role="datetimepicker" uglcw-options="format:'yyyy-MM-dd HH:mm'"
                               uglcw-model="accTimeStr">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">本次还款</label>
                    <div class="col-xs-14">
                        <input uglcw-role="numeric" uglcw-validate="required" id="ioAmt" uglcw-model="ioAmt" onchange="changeAmt(this,'itemGrid')">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">还款账户</label>
                    <div class="control-label col-xs-14">
                        <select uglcw-role="combobox" uglcw-validate="required" uglcw-model="accId"
                                uglcw-options="
                                  url: '${base}manager/queryAccountList',
                                  loadFilter:{
                                    data: function(response){return response.rows ||[];}
                                  },
                                  dataTextField: 'accName',
                                  dataValueField: 'id'
                                "
                        >
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">备注</label>
                    <div class="col-xs-14">
                        <textarea uglcw-role="textbox" uglcw-model="remarks1"></textarea>
                    </div>
                </div>
                <div class="form-group" id="inItemDiv">
                    <div id="itemGrid" uglcw-role="grid"
                         uglcw-options='
                          id: "id",
                          editable: true,
                          height:130,
                          navigatable: true'
                    >
                        <div data-field="itemId" uglcw-options="hidden:true,editable: false">明细科目Id</div>
                        <div data-field="itemName" uglcw-options="width: 110,editable: false">明细科目名称</div>
                        <div data-field="initAmt"
                             uglcw-options="width:70,editable: false">
                            剩余金额
                        </div>
                        <div data-field="amt"
                             uglcw-options="width:70, format:'{0:n2}',schema:{type:'number'}">
                            待还金额
                        </div>
                        <div data-field="options" uglcw-options="width: 60, command:'destroy'">
                            操作
                        </div>
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

        uglcw.ui.get('#search').on('click', function () {   //搜索（查询）
            uglcw.ui.get('#grid').k().dataSource.read();
        })

        uglcw.ui.get('#reset').on('click', function () {    //重置
            uglcw.ui.clear('.form-horizontal');
        })
        uglcw.ui.loaded()
    })


    function auditBill1(id) {
        uglcw.ui.confirm('您确认要审核吗？', function () {
            $.ajax({
                url: "manager/updateFinPreInAudit",
                type: "post",
                data: "billId=" + id,
                success: function (json) {
                    if (json.state) {
                        uglcw.ui.success('操作成功');
                        uglcw.ui.get('#grid').reload();
                    } else {
                        uglcw.ui.error('操作失败' + json.msg);
                        return;
                    }
                }
            });
        });
    }

    function cancelBill(id) {
        uglcw.ui.confirm('您确认要作废吗？', function () {
            $.ajax({
                url: "manager/cancelFinPreIn",
                type: "post",
                data: "billId=" + id,
                success: function (json) {
                    if (json.state) {
                        uglcw.ui.success('操作成功');
                        uglcw.ui.get('#grid').reload();
                    } else {
                        uglcw.ui.error('操作失败' + json.msg);
                        return;
                    }
                }
            });
        });
    }

    function toFreePay(e) { //核销
        var btn = e;
        var row = uglcw.ui.get('#grid').k().dataItem($(btn).closest('tr')).toJSON(); //获取点击行的数据
        row.billId = row.id;
        row.freeAmt = row.totalAmt - row.payAmt - row.freeAmt-row.backAmt;
        var rtn = uglcw.ui.Modal.open({
            area: '500px',
            content: $('#t').html(),
            success: function (container) {
                uglcw.ui.init($(container));
                uglcw.ui.bind($(container), row);
                console.log(row);
                checkInItems(row,'freeAmt','itemFreeGrid');
            },
            yes: function (container) {
                var valid = uglcw.ui.get($(container).find('.form-horizontal')).validate();
                var items = uglcw.ui.get('#itemFreeGrid').bind();
                if (items.length < 1) {
                    uglcw.ui.error('明细不允许空');
                    return;
                }
                if (valid) {
                    //如果费用科目为空，默认为核销未付款项
                    if(uglcw.ui.get('#costId').value()==''){
                        var itemId;
                        $("select[name$='costId'] option").each(function(){
                            if($(this).text() == "核销未付款项"){
                                itemId = $(this).val();
                                return false;
                            }
                        });
                        uglcw.ui.get('#costId').value(itemId);
                    }
                    var data = uglcw.ui.bind($("#verification_sheet"));
                    data.itemStr = JSON.stringify(items);
                    uglcw.ui.confirm('是否确定核销?', function () {
                        $.ajax({
                            url: '${base}/manager/updateFinPreInFreeAmt',
                            data: data,
                            type: 'post',
                            success: function (json) {
                                if (json.state) {
                                    uglcw.ui.success('核销成功');
                                    uglcw.ui.get('#grid').reload();//刷新页面数据
                                    uglcw.ui.Modal.close(rtn);
                                } else {
                                    uglcw.ui.error('核销失败' + json.msg);
                                }

                            }
                        })
                    })
                } else {
                    uglcw.ui.error('失败');

                }
                return false;
            }
        });
    }

    function toFinReturn(e) {//还款
        var btn = e;
        var row = uglcw.ui.get('#grid').k().dataItem($(btn).closest('tr')).toJSON(); //获取点击行的数据
        //列表数据字段 -> 提交表单数据字段
        row.objId = row.proId;
        row.objName = row.proName;
        row.objType = row.proType;
        row.payAmt = row.payAmt + row.freeAmt+row.backAmt;
        row.needRec = row.totalAmt - row.payAmt;
        row.billId = row.id;
        row.accTimeStr = uglcw.util.toString(new Date(), 'yyyy-MM-dd HH:mm:ss');
        row.ioAmt = row.needRec;
        var rtn = uglcw.ui.Modal.open({
            area: '500px',
            content: $('#current_receipts').html(),
            success: function (container) {
                uglcw.ui.init($(container));
                uglcw.ui.bind($(container), row);
                console.log(row);
                checkInItems(row,'ioAmt','itemGrid');
            },
            yes: function (container) {
                var valid = uglcw.ui.get($(container).find('.form-horizontal')).validate();
                if (valid) {
                    var data = uglcw.ui.bind(container);
                    if (data.ioAmt > data.needRec) {
                        return uglcw.ui.warning('本次还款不能大于应还款金额');
                    }
                    uglcw.ui.loading();
                    var items = uglcw.ui.get('#itemGrid').bind();
                    if (items.length < 1) {
                        uglcw.ui.error('明细不允许空');
                        return;
                    }
                    data.itemStr = JSON.stringify(items);
                    uglcw.ui.confirm('是否确定还款?', function () {
                        $.ajax({
                            url: '${base}/manager/addInPay',
                            data: data,
                            type: 'post',
                            success: function (json) {
                                uglcw.ui.loaded();
                                if (json.state) {
                                    uglcw.ui.success('还款成功');
                                    //json.billId = json.id;
                                    uglcw.ui.get('#grid').reload();//刷新页面数据
                                    uglcw.ui.Modal.close(rtn);
                                } else {
                                    uglcw.ui.error(json.msg || '还款失败');
                                }

                            },
                            error: function () {
                                uglcw.ui.error('还款失败');
                                uglcw.ui.loaded();
                            }
                        })
                    })
                } else {
                    uglcw.ui.error('失败');
                    uglcw.ui.loaded();
                }
                return false;
            }
        });
    }

    function showDetail(billId) {
        uglcw.ui.openTab('预收还款明细', '${base}manager/toFinPreInPayPage?billId='+billId);
    }

    function showPayStat() {
        uglcw.ui.openTab('预收款统计', '${base}manager/toFinPreInUnitStat?dataTp=1')

    }

    function newBill() {
        uglcw.ui.openTab('往来预收开单', '${base}manager/toFinPreInEdit')
    }

    function checkInItems(row,sumId,gridId) {
        if(row.itemId!=0&&row.itemName!=''){
            var initAmt = row.toPayAmt;
            var json = {
                rows:[{
                    itemId:row.itemId,
                    itemName:row.itemName,
                    amt:initAmt,
                    initAmt:initAmt
                }]
            }
            setItemGridData(gridId,sumId,json.rows);
            return;
        }
        var url = "${base}/manager/queryPreInSubToReturnByBillId";
        $.ajax({
            url: url,
            data: {"billId":row.billId},
            type: 'post',
            success: function (json) {
                uglcw.ui.loaded();
                if (json.state) {
                    if(json.rows.length>0){
                        $(json.rows).each(function (i, row) {
                            row.initAmt = row.amt;
                        })
                        setItemGridData(gridId,sumId,json.rows)
                    }
                }
            },
            error: function () {
            }
        })
    }

    function setItemGridData(gridId,sumId,rows) {
        uglcw.ui.get('#'+gridId).addRow(rows);
        uglcw.ui.get('#'+gridId).commit();
        uglcw.ui.get('#'+gridId).k().dataSource.bind('change', function (e) {
            var action = e.action;
            if (action === 'itemchange') {
                var item = e.items[0];
                if(item.amt>item.initAmt){
                    uglcw.ui.warning('金额不能大于'+item.initAmt);
                    item.amt=item.initAmt;
                    return;
                }
                calTotalAmount(gridId,sumId);
            }

        });
    }

    function changeAmt(o,gridId) {
        if(o.value==""){
            o.value=0;
        }
        var ioAmt = parseFloat(o.value);
        var ds = uglcw.ui.get('#'+gridId).k().dataSource;
        var data = ds.data().toJSON();
        $(data).each(function (idx, item) {
            var initAmt = (Number(item.initAmt || 0));
            var amt = 0;
            if(ioAmt>0){
                if(initAmt<=ioAmt){
                    amt = initAmt;
                    ioAmt=parseFloat(ioAmt)-parseFloat(initAmt);
                }else{
                    amt = ioAmt;
                    ioAmt = 0;
                }
            }
            item.amt = amt;
            //uglcw.ui.get('#itemGrid').commit();
        })
        uglcw.ui.get('#'+gridId).bind(data);
        uglcw.ui.get('#'+gridId).commit();

    }

    function calTotalAmount(gridId,sumId) {
        var ds = uglcw.ui.get('#'+gridId).k().dataSource;
        var data = ds.data().toJSON();
        var total = 0;
        $(data).each(function (idx, item) {
            total += (Number(item.amt || 0))
        })
        uglcw.ui.get('#'+sumId).value(total.toFixed(2));
    }

</script>
</body>
</html>
