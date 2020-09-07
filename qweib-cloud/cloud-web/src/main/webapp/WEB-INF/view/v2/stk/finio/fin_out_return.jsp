<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>往来回款收入</title>
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
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal" id="export">
                <li>
                    <input type="hidden" uglcw-model="jz" value="1" uglcw-role="textbox">
                    <input type="hidden" uglcw-model="status" value="1" uglcw-role="textbox">
                    <input type="hidden" uglcw-model="isNeedPay" value="0" uglcw-role="textbox">
                    <input uglcw-role="textbox" uglcw-model="billNo" placeholder="借出单号">
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="proName" placeholder="往来单位">
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="itemName" placeholder="明细科目名称">
                </li>
                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker" >
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="isNeedPay" placeholder="还款状态" uglcw-options="value:0">
                        <option value="0">未还清</option>
                        <option value="1">已还清</option>
                    </select>
                </li>
                <li>
                    <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                    <button id="reset" class="k-button" uglcw-role="button">重置</button>
                    <span  ondblclick="showInit()">&nbsp;&nbsp;</span>
                    <script>
                        function showInit() {
                            $("#init").show();
                        }
                    </script>
                    <button id="init" uglcw-role="button" style="display: none" class="k-button k-info" onclick="initData()">同步数据</button>
                </li>
            </ul>
        </div>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options="
                        pageable: true,
                        rowNumber: true,
                        criteria: '.form-horizontal',
                        toolbar: kendo.template($('#toolbar').html()),
                         dblclick:function(row){
                           uglcw.ui.openTab('往来借出'+row.id, '${base}manager/showFinOutEdit?_sticky=v2&billId='+ row.id+$.map( function(v, k){  //只带id
                            return k+'='+(v||'');
                           }).join('&'));
                         },
                         loadFilter: {
                         data: function (response) {
                         response.rows.splice( response.rows.length - 1, 1);
                         return response.rows || []
                       },
                       aggregates: function (response) {
                         var aggregate = {};
                       if (response.rows && response.rows.length > 0) {
                            aggregate = response.rows[response.rows.length - 1]
                       }
                        return aggregate;
                       }
                     },
                        responsive:['.header',40],
                        id:'id',
                        url: 'manager/queryFinOutForReturnPage',
                        criteria: '.form-horizontal',
                        pageable: true
                     ">
                <div data-field="billNo" uglcw-options="width:160">借出单号</div>
                <div data-field="billTimeStr" uglcw-options="width:140">单据日期</div>
                <div data-field="proName" uglcw-options="width:120">往来单位</div>
                <div data-field="accName" uglcw-options="width:140">账户名称</div>
                <div data-field="_operator"
                     uglcw-options="width:220, template: uglcw.util.template($('#formatterSt3').html())">操作
                </div>
                <div data-field="totalAmt" uglcw-options="width:120">借款金额</div>
                <div data-field="_upayAmt"
                     uglcw-options="width:120, template: '#=uglcw.util.toString( data.totalAmt-data.payAmt-data.freeAmt,\'n2\' )#'">
                    未回款金额
                </div>
                <div data-field="payAmt" uglcw-options="width:100">回款金额</div>
                <div data-field="freeAmt" uglcw-options="width:100">核销金额</div>
                <div data-field="count"
                     uglcw-options="width:200,template: function(data){
                            return kendo.template($('#formatterSt').html())(data.list);
                         }">科目信息
                </div>

                <div data-field="remarks" uglcw-options="width:120">备注</div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:showTotal();" class="k-button k-button-icontext">
        <span class="k-icon k-i-zoom"></span>应回款统计
    </a>

</script>
<!--核销-->
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
                                  url: '${base}manager/queryUseCostItemList?typeName=经营费用',
                                  loadFilter:{
                                    data: function(response){
                                    var itemId = '';
                                    $(response.rows).each(function (i, row) {
                                           if(row.itemName=='核销未收款'){
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
<!--收款表单-->
<script id="current_receipts" type="text/uglcw-template">
    <div class="layui-card">
        <div class="layui-card-body">
            <div class="form-horizontal  proceeds" uglcw-role="validator">
                <input type="hidden" uglcw-role="textbox" uglcw-model="billId"/>
                <div class="form-group">
                    <label class="control-label col-xs-8">回款对象</label>
                    <div class="col-xs-14">
                        <!--收款对象ID-->
                        <input type="hidden" uglcw-role="textbox" uglcw-model="objId"/>
                        <input uglcw-role="textbox" uglcw-model="objName" readonly
                               uglcw-validate="required">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">已回款</label>
                    <div class="col-xs-14">
                        <input uglcw-role="textbox" uglcw-model="payAmt" disabled>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">应收回款</label>
                    <div class="col-xs-14">
                        <input uglcw-role="textbox" uglcw-model="needRec" disabled>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">收款时间</label>
                    <div class="col-xs-14">
                        <input id="inDate" uglcw-role="datetimepicker" uglcw-options="format:'yyyy-MM-dd HH:mm'"
                               uglcw-model="accTimeStr">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">本次回款</label>
                    <div class="col-xs-14">
                        <input uglcw-validate="required" uglcw-role="numeric" id="ioAmt"  uglcw-model="ioAmt" onchange="changeAmt(this,'itemGrid')">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-8">收款账户</label>
                    <div class="control-label col-xs-14">
                        <select uglcw-validate="required" uglcw-role="combobox" uglcw-model="accId"
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
                            待回金额
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
    # if(data.totalAmt > (data.payAmt+data.freeAmt)){ #
    <button class="k-button k-info" onclick="toFinReturn(this,#= data.id#)"><i class="k-icon"></i>回款
    </button>
    <button class="k-button k-info" onclick="toFreePay(this,#= data.id#)"><i class="k-icon"></i>核销
    </button>
    # } #

    # if((data.payAmt+data.freeAmt) >0){ #
    <button class="k-button k-info" onclick="showDetail(#= data.id#,'#=data.billNo#')">回款明细<i class="k-icon"></i>
    </button>
    # } #

</script>
<script id="formatterSt" type="text/x-kendo-template">
    <table class="product-grid">
        <tbody>
        <tr style="font-weight: bold;">
            <td style="width: 10px;">明细科目名称</td>
            <td style="width: 5px;">借出金额</td>
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


    function toFreePay(e) { //核销
        var btn = e;
        var row = uglcw.ui.get('#grid').k().dataItem($(btn).closest('tr')).toJSON();
        row.billId = row.id;
        row.toPayAmt = row.totalAmt-row.payAmt-row.freeAmt;
        row.freeAmt = row.totalAmt - row.payAmt - row.freeAmt;
        var rtn = uglcw.ui.Modal.open({
            area: '500px',
            content: $('#t').html(),
            success: function (container) {
                uglcw.ui.init($(container));
                uglcw.ui.bind($(container), row);
                checkInItems(row,'freeAmt','itemFreeGrid');
            },
            yes: function (container) {
                var valid = uglcw.ui.get($(container).find('.form-horizontal')).validate();
                if (valid) {
                    //如果费用科目为空，默认为核销未收款
                    if(uglcw.ui.get('#costId').value()==''){
                        var itemId;
                        $("select[name$='costId'] option").each(function(){
                            if($(this).text() == "核销未收款"){
                                itemId = $(this).val();
                                return false;
                            }
                        });
                        uglcw.ui.get('#costId').value(itemId);
                    }
                    var data = uglcw.ui.bind($("#verification_sheet"));
                    var url = '${base}/manager/updateFinOutFreeAmt';
                    if(row.billNo.indexOf("WLJC")==-1){
                        url = '${base}/manager/finInitQtWlMain/updateFinInitOutFreeAmt';
                    }
                    var items = uglcw.ui.get('#itemFreeGrid').bind();
                    if (items.length < 1) {
                        uglcw.ui.error('明细不允许空');
                        return;
                    }
                    data.itemStr = JSON.stringify(items);
                    uglcw.ui.confirm('是否确定核销?', function () {
                        $.ajax({
                            url: url,
                            data: data,
                            type: 'post',
                            success: function (json) {
                                if (json.state) {
                                    uglcw.ui.success('核销成功');
                                    uglcw.ui.get('#grid').reload();//刷新页面数据
                                } else {
                                    uglcw.ui.error('核销失败' + json.msg);
                                }
                                uglcw.ui.Modal.close(rtn);
                            }
                        })
                    })
                } else {
                    uglcw.ui.error('失败');
                    uglcw.ui.Modal.close(rtn);
                }
                return false;
            }
        });
    }

    function toFinReturn(e) {//收款  fin_return
        var btn = e;
        var row = uglcw.ui.get('#grid').k().dataItem($(btn).closest('tr')); //获取点击行的数据
        //列表数据字段 -> 提交表单数据字段
        row.objId = row.proId;
        row.objName = row.proName;
        row.objType = row.proType;
        row.needRec = row.totalAmt - row.payAmt-row.freeAmt;
        row.toPayAmt = row.totalAmt-row.payAmt-row.freeAmt;
        row.billId = row.id;
        row.accTimeStr = uglcw.util.toString(new Date(), 'yyyy-MM-dd HH:mm:ss');
        row.ioAmt = row.needRec;
        var rtn = uglcw.ui.Modal.open({
            area: '500px',
            content: $('#current_receipts').html(),
            success: function (container) {
                uglcw.ui.init($(container));
                uglcw.ui.bind($(container), row);//把数据赋值给弹框
                checkInItems(row,'ioAmt','itemGrid');
            },
            yes: function (container) {
                var valid = uglcw.ui.get($(container).find('.proceeds')).validate();
                if (valid) {
                    var form = uglcw.ui.bind($(container).find('.proceeds'));
                    var data = uglcw.ui.bind(container);
                    if (parseInt(form.needRec) < parseInt(form.ioAmt)) {
                        return uglcw.ui.warning("本次回款不能大于应收回款");
                    }
                    var url = '${base}/manager/addFinBackIn';
                    if(row.billNo.indexOf("WLJC")==-1&&row.billNo.indexOf("LO")==-1){
                        url = '${base}/manager/finInitQtWlMain/addFinInitBackIn';
                    }
                    var items = uglcw.ui.get('#itemGrid').bind();
                    if (items.length < 1) {
                        uglcw.ui.error('明细不允许空');
                        return;
                    }
                    form.itemStr = JSON.stringify(items);
                    uglcw.ui.confirm('是否确定回款？', function () {
                        uglcw.ui.loading();
                        $.ajax({
                            url: url,
                            type: 'post',
                            dataType: 'json',
                            data: form,
                            success: function (json) {
                                uglcw.ui.loaded();
                                if (json.state) {
                                    json.billId = json.id;
                                    uglcw.ui.success('回款成功');
                                    uglcw.ui.get('#grid').reload();//刷新页面数据
                                } else {
                                    uglcw.ui.error(json.msg);
                                }
                                uglcw.ui.Modal.close(rtn);
                            },
                            error: function () {
                                uglcw.ui.loaded();
                                uglcw.ui.Modal.close(rtn);
                            }
                        })
                    })
                } else {
                    uglcw.ui.error('校验失败');
                    return false;
                }
                return false;
            }
        });
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
        var url = "${base}/manager/queryOutSubToReturnByBillId";
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
                        setItemGridData(gridId,sumId,json.rows);
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


    function showDetail(id,billNo) {
        <%--var url = '${base}manager/finaccio1?remarks=借款收回&billId=' + id;--%>
        <%--if(billNo.indexOf("WLJC")==-1){--%>
            <%--url = '${base}manager/finaccio1?remarks=初始借款收回&billId=' + id;--%>
        <%--}--%>
        var url = "${base}manager/toFinOutReturnPage?_sticky=v2&sourceBillId="+id+"&sourceBillNo="+billNo+"";
        uglcw.ui.openTab('回款明细',url);
    }

    function initData() {
        uglcw.ui.confirm('是否确定同步数据?', function () {
         uglcw.ui.loading();
        var url = "${base}/manager/updateAutoCreateReturnBill";
        $.ajax({
            url: url,
            data: {},
            type: 'post',
            success: function (json) {
                uglcw.ui.loaded();
                if (json.state) {
                    uglcw.ui.info('同步数据成功！');
                }
            },
            error: function () {
                uglcw.ui.info('同步数据错误！');
            }
        })
        });
    }


    function showTotal() {
        uglcw.ui.openTab('应回款统计', '${base}manager/toFinOutTotal?_sticky=v2');
    }
</script>
</body>
</html>
