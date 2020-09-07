<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>付货款管理</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query query">
                <li>
                    <%--<select uglcw-role="combobox" uglcw-options="value: ''" uglcw-model="inType" placeholder="入库类型">--%>
                        <%--<option value="采购入库">采购入库</option>--%>
                        <%--<option value="其它入库">其它入库</option>--%>
                        <%--<option value="采购退货">采购退货</option>--%>
                        <%--<option value="销售退货">销售退货</option>--%>
                        <%--<option value="杂费单">杂费单</option>--%>
                    <%--</select>--%>
                        <div style="width: 250px">
                    <select uglcw-model="inTypes" id="inTypesModel" style="width: 300px;"  uglcw-role="multiselect">
                        <option value="采购入库">采购入库</option>
                        <option value="其它入库">其它入库</option>
                        <option value="采购退货">采购退货</option>
                        <option value="销售退货">销售退货</option>
                        <option value="杂费单">杂费单</option>
                        <option value="固定费用单">固定费用单</option>
                        <option value="应付往来单位初始化">应付往来单位初始化</option>
                    </select>
                        </div>
                </li>
                <li>
                    <input type="hidden" uglcw-model="jz" value="1" uglcw-role="textbox">
                    <input uglcw-model="proName" uglcw-role="textbox" placeholder="往来单位">
                </li>
                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker" placeholder="开始时间" value="${sdate}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                </li>
                <li style="width: 70px;">
                    <input uglcw-role="numeric" data-min="0" uglcw-model="beginAmt" placeholder="单据金额">
                </li>
                <li style="width: 20px!important;"><span style="line-height: 30px;">到</span></li>
                <li style="width: 70px;">
                    <input uglcw-role="numeric" uglcw-model="endAmt" placeholder="销售金额">
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
            <div id="grid" uglcw-role="grid"
                 uglcw-options="
                    responsive:['.header',40],
                    toolbar: uglcw.util.template($('#toolbar').html()),
                    id:'id',
                    dblclick: function(row){
                         var query = uglcw.ui.bind('.query');
                         query.proName=row.proName;
                         query.proType=row.proType;
                         uglcw.ui.openTab('待付款单据', '${base}manager/toUnitPayPage?' + $.map(query, function (v, k) {
                            return k + '=' + (v);
                        }).join('&'));
                    },
                    criteria: '.uglcw-query',
                    url: '${base}manager/queryYfkUnitStat',
                    aggregate:[
                     {field: 'totalAmt', aggregate: 'SUM'},
                     {field: 'disAmt', aggregate: 'SUM'},
                     {field: 'disAmt1', aggregate: 'SUM'},
                     {field: 'freeAmt', aggregate: 'SUM'},
                     {field: 'payAmt', aggregate: 'SUM'}
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
                        	totalAmt: 0,
                        	disAmt: 0,
                        	disAmt1: 0,
                        	freeAmt: 0,
                        	payAmt: 0
                        };
                        if (response.rows && response.rows.length > 0) {
                            aggregate = uglcw.extend(aggregate, response.rows[response.rows.length - 1]);
                        }
                        return aggregate;
                      }
                     },
                    pageable: true,
                    ">
                <div data-field="proName" uglcw-options="width:180,tooltip: true, footerTemplate: '合计'">往来单位</div>
                <div data-field="disAmt"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= data.disAmt#'">销售金额
                </div>
                <div data-field="disAmt1"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= data.disAmt1#'">发货金额
                </div>
                <div data-field="payAmt"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= data.payAmt#'">已付金额
                </div>
                <div data-field="freeAmt"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= data.freeAmt#'">核销金额
                </div>
                <div data-field="totalAmt"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= data.totalAmt#'">应付金额
                </div>
                <div data-field="options"
                     uglcw-options="width:200, template: uglcw.util.template($('#op-tpl').html()) ">操作
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-uglcw-template" id="toolbar">
    <a role="button" class="k-button k-button-icontext"
       href="javascript:showPayList();">
        <span class="k-icon k-i-search"></span>付款记录
    </a>
    <a role="button" class="k-button k-button-icontext"
       href="javascript:toUnitRecPage();">
        <span class="k-icon k-i-search"></span>待付款单据
    </a>
</script>

<script type="text/x-uglcw-template" id="op-tpl">
    <button class="k-button k-info" onclick="toAutoRec(#= data.proId#, '#= data.proName#', '#= data.proType#', #= data.totalAmt#,'${defaultAcc}')">付款
    </button>
</script>
<script type="text/x-uglcw-template" id="rec-dialog">
    <div class="layui-card">
        <div class="layui-card-body">
            <form class="form-horizontal" uglcw-role="validator">
                <div class="form-group">
                    <label class="control-label col-xs-6">往来单位</label>
                    <div class="col-xs-18">
                        <input uglcw-role="textbox" uglcw-model="inTypes" type="hidden">
                        <input uglcw-role="textbox" uglcw-model="proId" type="hidden">
                        <input uglcw-role="textbox" uglcw-model="proType" type="hidden">
                        <input uglcw-role="textbox" readonly uglcw-model="proName">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">应付金额</label>
                    <div class="col-xs-18">
                        <input uglcw-role="numeric" uglcw-model="amt" readonly>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">本次应付</label>
                    <div class="col-xs-18">
                        <input uglcw-validate="required" data-min="0" uglcw-role="numeric" uglcw-model="cash">
                        <div id="middleInDiv">
                            <span>其中</span>
                            <span id="xsthDiv">
                            销售退货:<input uglcw-role="numeric" uglcw-model="xsthAmt"  style="width: 80px">
                            <input uglcw-role="textbox" uglcw-model="cmpXsthAmt" type="hidden"  >
                            </span>
                            <span id="cgthDiv">
                            采购退货:<input uglcw-role="numeric" uglcw-model="cgthAmt"  style="width: 80px">
                            <input uglcw-role="textbox" uglcw-model="cmpCgthAmt" type="hidden">
                            </span>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">付款账号</label>
                    <div class="col-xs-18">
                        <tag:select2 validate="required" name="accId" id="accId" tableName="fin_account" headerKey=""
                                     whereBlock="status=0" headerValue="--请选择--" displayKey="id"
                                     displayValue="acc_name"/>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-xs-6">备注</label>
                    <div class="col-xs-18">
                        <textarea uglcw-role="textbox" uglcw-model="remarks"></textarea>
                    </div>
                </div>
                <div class="form-group">
                    <%--<p class="col-xs-24" style="color:red;">--%>
                        <%--说明：自动匹配付款功能，在付款时不需要选择待付款单，系统会自己根据付款的金额匹配相应的未付款发票单且会根据发票最早的时间逐单匹配，此操作不含【销售退货】【采购退货】；</p>--%>
                <%--</div>--%>
            </form>
        </div>
    </div>
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        uglcw.ui.init();
        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        })
        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.uglcw-query');
        })

        // <option value="采购入库">采购入库</option>
        //     <option value="其它入库">其它入库</option>
        //     <option value="采购退货">采购退货</option>
        //     <option value="销售退货">销售退货</option>
        //     <option value="杂费单">杂费单</option>
        //     <option value="应付往来单位初始化">应付往来单位初始化</option>
        // var dataSource = [
        //     { name: "采购入库", userId: '采购入库' },
        //     { name: "其它入库", userId: '其它入库' },
        //     { name: "采购退货", userId: '采购退货' },
        //     { name: "销售退货", userId: '销售退货' },
        //     { name: "杂费单", userId: '杂费单' },
        //     { name: "应付往来单位初始化", userId: '应付往来单位初始化' }
        // ];
        // var inType = $("#inTypes").kendoMultiSelect({
        //     placeholder: "-- 入库类型 --",
        //     dataTextField: "name",
        //     dataValueField: "userId",
        //     autoBind: false,
        //     dataSource:  dataSource,
        //     value: [        //默认选择当前项 (无选择项时显示placeholder的值)
        //         { name: "采购入库", userId: '采购入库' },
        //         { name: "其它入库", userId: '其它入库' }
        //     ]
        // }).data("kendoMultiSelect");



        uglcw.ui.loaded()
    })


    function toAutoRec(proId, proName,proType, amt,defaultAcc) {
        var rtn = uglcw.ui.Modal.open({
            content: $('#rec-dialog').html(),
            title: '付款',
            success: function (container) {
                var form = $(container).find('form');
                uglcw.ui.init(container);
                var inTypes = uglcw.ui.get("#inTypesModel").value();
                uglcw.ui.bind(form, {proId: proId, proName: proName,proType:proType, amt: amt, cash: amt,inTypes:inTypes,accId:defaultAcc});
                laodThAmt(proId,proName,form);
            },
            yes: function (container) {
                var form = $(container).find('form');
                var validate = uglcw.ui.get(form).validate();
                if (validate) {
                    var data = uglcw.ui.bind(form);

                    var cmpAmt = 0;
                    if(data.xsthAmt!="") {
                        cmpAmt = data.xsthAmt;
                        if(parseFloat(data.xsthAmt)>parseFloat(data.cmpXsthAmt)){
                            uglcw.ui.info('销售退货不能大于' + data.cmpXsthAmt);
                            return false;
                        }
                        if(parseFloat(data.xsthAmt)>parseFloat(data.amt)){
                            uglcw.ui.info('销售退货不能大于' + data.cash);
                            return false;
                        }
                    }

                    if(data.cgthAmt!="") {
                        cmpAmt += parseFloat(data.cgthAmt);
                        if(parseFloat(data.cgthAmt)>0){
                            uglcw.ui.info('采购退货必须小于0');
                            return false;
                        }
                        if(parseFloat(Math.abs(data.cgthAmt))>parseFloat(Math.abs(data.cmpCgthAmt))){
                            uglcw.ui.info('采购退货不能大于' + data.cmpCgthAmt);
                            return false;
                        }
                    }
                    // if(parseFloat(data.cash)<=0){
                    //     uglcw.ui.info('本次收款必须大于0');
                    //     return false;
                    // }
                    if(parseFloat(data.cash) < parseFloat(cmpAmt)){
                        uglcw.ui.info('本次付款不能小于'+cmpAmt);
                        return false;
                    }

                    if(data.cash<0){
                        if(parseFloat(data.cash)>= 0){
                            uglcw.ui.info('本次付款必须小于0');
                            return false;
                        }
                        if (parseFloat(Math.abs(data.cash)) > parseFloat(Math.abs(data.amt))) {
                            uglcw.ui.info('本次付款不能大于' + data.amt);
                            return false;
                        }
                    }else{
                        if (parseFloat(data.cash) > parseFloat(data.amt)) {
                            uglcw.ui.info('本次付款不能大于' + data.amt);
                            return false;
                        }
                    }
                    uglcw.ui.confirm('确定付款吗？', function () {
                        $.ajax({
                            url: '${base}manager/autoPayBill',
                            data: data,
                            success: function (response) {
                                if (response.state) {
                                    uglcw.ui.success(response.msg);
                                    uglcw.ui.Modal.close(rtn);
                                } else {
                                    uglcw.ui.error(response.msg);
                                }
                            }
                        })
                    })
                }
                return false;
            }
        })

    }

    function laodThAmt(proId, proName,form) {
        var data = uglcw.ui.bind('.query');
        data.proId=proId;
        data.proName=proName;
        var loadBool = false;
        if(data.inTypes==""){
            loadBool=true;
            $("#middleInDiv").show();
        }else if(data.inTypes=="销售退货"){
            loadBool=true;
            $("#middleInDiv").hide();
        }else if(data.inTypes=="采购退货"){
            loadBool=true;
            $("#middleInDiv").hide();
        } else if(data.inTypes.indexOf("销售退货")!=-1&&data.inTypes.indexOf("采购退货")==-1) {
            loadBool = true;
            $("#middleInDiv").show();
            $("#cgthDiv").hide();
        } else if(data.inTypes.indexOf("采购退货")!=-1&&data.inTypes.indexOf("销售退货")==-1) {
            loadBool = true;
            $("#middleInDiv").show();
            $("#xsthDiv").hide();
        } else if(data.inTypes.indexOf("采购退货")!=-1&&data.inTypes.indexOf("销售退货")!=-1) {
            loadBool = true;
            $("#middleInDiv").show();
        }else{
            loadBool=false;
            $("#middleInDiv").hide();
        }
        if(!loadBool){
            return;
        }
        $.ajax({
            url: '${base}manager/laodThAmt',
            data: data,
            success: function (response) {
                if (response.state) {
                  var datas = response.datas;
                  for(var i=0;i<datas.length;i++){
                      var ds = datas[i];
                      if(ds.inType=="销售退货"){
                          uglcw.ui.bind(form, {xsthAmt: ds.totalAmt,cmpXsthAmt: ds.totalAmt});
                      }else if(ds.inType=="采购退货"){
                          uglcw.ui.bind(form, {cgthAmt: ds.totalAmt,cmpCgthAmt: ds.totalAmt});
                      }
                  }
                }
            }
        })
    }

    function showPayList() {
        uglcw.ui.openTab('付款记录', '${base}manager/queryPayPageByBillId?dataTp=1')
    }

    function toUnitRecPage() {
        var query = uglcw.ui.bind('.query');
        uglcw.ui.openTab('待付款单据', '${base}manager/toUnitPayPage?' + $.map(query, function (v, k) {
            return k + '=' + (v || '');
        }).join('&'));
    }

</script>
</body>
</html>
