<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>产品出库统计表</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="uglcw-layout-container">
        <div class="uglcw-layout-fixed" style="width: 200px">
            <div class="layui-card">
                <div class="layui-card-header">商品分类</div>
                <div class="layui-card-body">
                    <div uglcw-role="tree"
                         uglcw-options="
                       url: '${base}manager/waretypes',
                       expandable: function(node){
                        return node.id === 0;
                       },
                       select: function(e){
                        var node = this.dataItem(e.node);
                        uglcw.ui.get('#wareType').value(node.id);
                        uglcw.ui.get('#grid').reload();
                       }

                    "
                    ></div>
                </div>
            </div>
        </div>
        <div class="uglcw-layout-content">
            <div class="layui-card header">
                <div class="layui-card-body">
                    <div class="form-horizontal query">
                        <div class="form-group" style="margin-bottom: 0px;">
                            <input type="hidden" uglcw-model="waretype" value="0" id="wareType" uglcw-role="textbox">

                            <div class="col-xs-4">
                                <input uglcw-role="textbox" uglcw-model="yymm" placeholder="年月" value="${yymm}">
                            </div>
                            <div class="col-xs-4">
                                <input uglcw-role="textbox" uglcw-model="wareNm" placeholder="商品名称">
                            </div>
                            <div class="col-xs-4">
                                <select uglcw-role="combobox" uglcw-model="stkId" uglcw-options="
                                    placeholder:'仓库',
									url: '${base}manager/queryBaseStorage',
									dataTextField:'stkName',
									dataValueField:'id'
								">
                                </select>
                            </div>
                            <div class="col-xs-4" style="margin-top: 10px;">
                                <input type="checkbox" uglcw-options="type:'number'" uglcw-role="checkbox"
                                       uglcw-model="hideZero" id="ignoreZero">
                                <label class="k-checkbox-label" for="ignoreZero">过滤0值</label>
                            </div>
                            <div class="col-xs-4">
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
                    responsive:['.header',40],
                    id:'id',
                    columnMenu: true,
                    toolbar: uglcw.util.template($('#toolbar').html()),
                    url: '${base}manager/stkmonth/queryMonthDetailPage',
                    criteria: '.query',
                    dblclick: function(row){
                     var query = uglcw.ui.bind('.query');
                         query.wareId=row.wareId;
                         uglcw.ui.openTab('明细_'+ row.wareNm, '${base}manager/queryOutdetailList?dataTp=1&' + $.map(query, function (v, k) {
                            return k + '=' + (v || '');
                        }).join('&'));
                    },
                    aggregate:[
                     {field: 'sumAmt', aggregate: 'SUM'},
                     {field: 'sumAmt1', aggregate: 'SUM'},
                     {field: 'sumQty', aggregate: 'SUM'},
                     {field: 'sumQty1', aggregate: 'SUM'}
                    ],
                    loadFilter: {
                      data: function (response) {
                        if(!response || !response.rows){
                            return [];
                        }
                        if(response.total == 0){
                        	return [];
                        }
                        response.rows.splice(response.rows.length - 1, 1);
                        $(response.rows).each(function(idx, row){
                            var initInQty = row.initInQty =='' ? 0 : row.initInQty;
                            var inQty = row.inQty == '' ? 0 : row.inQty;
                            var inQty1 = row.inQty1 == '' ? 0 : row.inQty1;
                            var rtnQty = row.rtnQty == '' ? 0 : row.rtnQty;
                            var transInQty = row.transInQty == '' ? 0 : row.transInQty;
                            var zzInQty = row.zzInQty == '' ? 0 : row.zzInQty;
                            var cxInQty = row.cxInQty == ''? 0 : row.cxInQty;
                            var scQty = row.scQty == '' ? 0 : row.scQty;
                            var checkInQty = row.checkInQty == '' ? 0 : row.checkInQty;
                            row._bqQty = parseFloat(initInQty)
                            + parseFloat(inQty)
                            + parseFloat(inQty1)
                            + parseFloat(rtnQty)
                            + parseFloat(transInQty)
                            + parseFloat(zzInQty)
                            + parseFloat(cxInQty)
                            + parseFloat(scQty)
                            + parseFloat(checkInQty);
                            var outQty11 = row.outQty11 == '' ? 0 : row.outQty11;
                            var outQty12 = row.outQty12 == '' ? 0 : row.outQty12;
                            var outQty13 = row.outQty13 == '' ? 0 : row.outQty13;
                            var outQty14 = row.outQty14 == '' ? 0 : row.outQty14;
                            var outQty15 = row.outQty15 =='' ? 0 : row.outQty15;
                            var shopSaleQty = row.shopSaleQty == '' ? 0 : row.shopSaleQty;
                            var otherOutQty = row.otherOutQty == ''? 0 : row.otherOutQty;
                            var purRtnQty = row.purRtnQty == '' ? 0 : row.purRtnQty;
                            var transOutQty = row.transOutQty == '' ? 0 : row.transOutQty;
                            var zzOutQty = row.zzOutQty == '' ? 0 : row.zzOutQty;
                            var cxOutQty = row.cxOutQty == '' ? 0 : row.cxOutQty;
                            var useQty = row.useQty == '' ? 0 : row.useQty;
                            var lenOutQty = row.lenOutQty == '' ? 0 : row.lenOutQty;
                            var lossQty = row.lossQty == '' ? 0 : row.lossQty;
                            var lendQty = row.lendQty == '' ? 0 : row.lendQty;
                            var checkOutQty = row.checkOutQty == '' ? 0 : row.checkOutQty;
                            row._bqck = parseFloat(outQty11)
                            + parseFloat(outQty12)
                            + parseFloat(outQty13)
                            + parseFloat(outQty14)
                            + parseFloat(outQty15)
                            + parseFloat(shopSaleQty)
                            + parseFloat(otherOutQty)
                            + parseFloat(purRtnQty)
                            + parseFloat(transOutQty)
                            + parseFloat(zzOutQty)
                            + parseFloat(cxOutQty)
                            + parseFloat(useQty)
                            + parseFloat(lenOutQty)
                            + parseFloat(lossQty)
                            + parseFloat(lendQty)
                            + parseFloat(checkOutQty)
                            ;
                        })
                        return response.rows || []
                      },
                      total: function (response) {
                        return response.total;
                      },
                      aggregates: function (response) {
                        var aggregate = {
                        sumQty:0,
                        sumQty1:0,
                        sumAmt:0,
                        sumAmt1:0
                        };
                        if (response.rows && response.rows.length > 0) {
                            aggregate = uglcw.extend(aggregate, response.rows[response.rows.length - 1])
                        }
                        return aggregate;
                      }
                     }
                    ">
                        <div data-field="wareNm" uglcw-options="width: 120,footerTemplate: '合计'">商品名称</div>
                        <div data-field="unitName" uglcw-options="width: 80">单位</div>
                        <div data-field="initQty"
                             uglcw-options="width: 100,format: '{0:n2}',footerTemplate: '#= uglcw.util.toString(data.sumQty,\'n2\')#'">
                            期初数量
                        </div>
                        <div data-field="_bqQty"
                             uglcw-options="width: 100,format: '{0:n2}',footerTemplate: '#= uglcw.util.toString(data._bqQty,\'n2\')#'">
                            本期入库
                        </div>
                        <div data-field="initAmt"
                             uglcw-options="width: 100,format: '{0:n2}',footerTemplate: '#= uglcw.util.toString(data.initAmt,\'n2\')#'">
                            期初金额
                        </div>
                        <div data-field="avgPrice"
                             uglcw-options="width: 100,format: '{0:n2}',footerTemplate: '#= uglcw.util.toString(data.avgPrice,\'n2\')#'">
                            平均价格
                        </div>
                        <div data-field="initAmt"
                             uglcw-options="width: 100,format: '{0:n2}',footerTemplate: '#= uglcw.util.toString(data.initAmt,\'n2\')#'">
                            期初金额
                        </div>
                        <div data-field="initInQty"
                             uglcw-options="width: 100,format: '{0:n2}',footerTemplate: '#= uglcw.util.toString(data.initInQty,\'n2\')#'">
                            初始化入库
                        </div>
                        <div data-field="initInAmt"
                             uglcw-options="width: 130,format: '{0:n2}',footerTemplate: '#= uglcw.util.toString(data.initInAmt,\'n2\')#'">
                            初始化入库金额
                        </div>
                        <div data-field="inQty"
                             uglcw-options="width: 100,format: '{0:n2}',footerTemplate: '#= uglcw.util.toString(data.inQty,\'n2\')#'">
                            采购入库
                        </div>
                        <div data-field="inAmt"
                             uglcw-options="width: 100, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.inAmt,\'n2\')#'">
                            采购金额
                        </div>
                        <div data-field="otherTypeInQty"
                             uglcw-options="width: 120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.otherTypeInQty,\'n2\')#'">
                            其它类型入库
                        </div>
                        <div data-field="inQty1"
                             uglcw-options="width: 120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.其它入库,\'n2\')#'">
                            其它入库
                        </div>
                        <div data-field="inAmt1"
                             uglcw-options="width: 120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.inAmt1,\'n2\')#'">
                            其它入库金额
                        </div>
                        <div data-field="rtnQty"
                             uglcw-options="width: 100, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.rtnQty,\'n2\')#'">
                            销售退货
                        </div>
                        <div data-field="rtnAmt"
                             uglcw-options="width: 100, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.rtnAmt,\'n2\')#'">
                            退货金额
                        </div>
                        <div data-field="transInQty"
                             uglcw-options="width: 100, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.transInQty,\'n2\')#'">
                            移入数量
                        </div>
                        <div data-field="transInAmt"
                             uglcw-options="width: 100, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.transInAmt,\'n2\')#'">
                            移入金额
                        </div>
                        <div data-field="zzInQty"
                             uglcw-options="width: 100, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.zzInQty,\'n2\')#'">
                            组装数量
                        </div>
                        <div data-field="zzInAmt"
                             uglcw-options="width: 100, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.zzInAmt,\'n2\')#'">
                            组装金额
                        </div>
                        <div data-field="cxInQty"
                             uglcw-options="width: 120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.cxInQty,\'n2\')#'">
                            拆卸入库数量
                        </div>
                        <div data-field="cxInAmt"
                             uglcw-options="width: 120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.cxInAmt,\'n2\')#'">
                            拆卸入库金额
                        </div>
                        <div data-field="scQty"
                             uglcw-options="width: 100, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.scQty,\'n2\')#'">
                            生产数量
                        </div>
                        <div data-field="scAmt"
                             uglcw-options="width: 100, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.scAmt,\'n2\')#'">
                            生产金额
                        </div>
                        <div data-field="hkQty"
                             uglcw-options="width: 120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.hkQty,\'n2\')#'">
                            领料回库数量
                        </div>
                        <div data-field="hkAmt"
                             uglcw-options="width: 120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.hkAmt,\'n2\')#'">
                            领料回库金额
                        </div>
                        <div data-field="scQty"
                             uglcw-options="width: 100, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.scQty,\'n2\')#'">
                            生产数量
                        </div>
                        <div data-field="checkInQty"
                             uglcw-options="width: 100, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.checkInQty,\'n2\')#'">
                            盘盈数量
                        </div>
                        <div data-field="checkInAmt"
                             uglcw-options="width: 100, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.checkInAmt,\'n2\')#'">
                            盘盈金额
                        </div>
                        <div data-field="outAmt11"
                             uglcw-options="width: 100, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.outAmt11,\'n2\')#'">
                            正常销售
                        </div>
                        <div data-field="checkInQty"
                             uglcw-options="width: 100, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.checkInQty,\'n2\')#'">
                            销售金额
                        </div>
                        <div data-field="otherTypeOutQty"
                             uglcw-options="width: 120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.otherTypeOutQty,\'n2\')#'">
                            其它类型出库
                        </div>
                        <div data-field="otherTypeOutAmt"
                             uglcw-options="width: 130, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.otherTypeOutAmt,\'n2\')#'">
                            其它类型出库金额
                        </div>
                        <div data-field="outQty12"
                             uglcw-options="width: 120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.outQty12,\'n2\')#'">
                            促销折让数量
                        </div>
                        <div data-field="outAmt12"
                             uglcw-options="width: 120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.outAmt12,\'n2\')#'">
                            促销折让金额
                        </div>
                        <div data-field="outQty13"
                             uglcw-options="width: 120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.outQty13,\'n2\')#'">
                            消费折让数量
                        </div>
                        <div data-field="outQty14"
                             uglcw-options="width: 120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.outQty14,\'n2\')#'">
                            费用折让数量
                        </div>
                        <div data-field="outAmt14"
                             uglcw-options="width: 120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.outAmt14,\'n2\')#'">
                            费用折让金额
                        </div>
                        <div data-field="outQty15"
                             uglcw-options="width: 120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.outQty15,\'n2\')#'">
                            其它销售数量
                        </div>
                        <div data-field="outAmt15"
                             uglcw-options="width: 120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.outAmt15,\'n2\')#'">
                            其它销售金额
                        </div>
                        <div data-field="shopSaleQty"
                             uglcw-options="width: 120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.shopSaleQty,\'n2\')#'">
                            终端零售数量
                        </div>
                        <div data-field="shopSaleAmt"
                             uglcw-options="width: 120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.shopSaleAmt,\'n2\')#'">
                            终端零售金额
                        </div>
                        <div data-field="otherOutQty"
                             uglcw-options="width: 120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.otherOutQty,\'n2\')#'">
                            其它出库数量
                        </div>
                        <div data-field="otherOutAmt"
                             uglcw-options="width: 120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.otherOutAmt,\'n2\')#'">
                            其它出库金额
                        </div>
                        <div data-field="purRtnQty"
                             uglcw-options="width: 120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.purRtnQty,\'n2\')#'">
                            采购退货数量
                        </div>
                        <div data-field="purRtnAmt"
                             uglcw-options="width: 120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.purRtnAmt,\'n2\')#'">
                            采购退货金额
                        </div>
                        <div data-field="transOutQty"
                             uglcw-options="width: 120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.transOutQty,\'n2\')#'">
                            移出数量
                        </div>
                        <div data-field="transOutAmt"
                             uglcw-options="width: 120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.transOutAmt,\'n2\')#'">
                            移出金额
                        </div>
                        <div data-field="zzOutQty"
                             uglcw-options="width: 120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.zzOutQty,\'n2\')#'">
                            组装出库数量
                        </div>
                        <div data-field="zzOutAmt"
                             uglcw-options="width: 120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.zzOutAmt,\'n2\')#'">
                            组装出库金额
                        </div>
                        <div data-field="cxOutQty"
                             uglcw-options="width: 120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.cxOutQty,\'n2\')#'">
                            拆卸出库数量
                        </div>
                        <div data-field="cxOutAmt"
                             uglcw-options="width: 120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.cxOutAmt,\'n2\')#'">
                            拆卸出库金额
                        </div>
                        <div data-field="useQty"
                             uglcw-options="width: 120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.useQty,\'n2\')#'">
                            领料数量
                        </div>
                        <div data-field="useAmt"
                             uglcw-options="width: 120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.useAmt,\'n2\')#'">
                            领料金额
                        </div>
                        <div data-field="lenOutQty"
                             uglcw-options="width: 120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.lenOutQty,\'n2\')#'">
                            领用数量
                        </div>
                        <div data-field="lenOutAmt"
                             uglcw-options="width: 120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.lenOutAmt,\'n2\')#'">
                            领用金额
                        </div>
                        <div data-field="lossQty"
                             uglcw-options="width: 120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.lossQty,\'n2\')#'">
                            报损数量
                        </div>
                        <div data-field="lossAmt"
                             uglcw-options="width: 120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.lossAmt,\'n2\')#'">
                            报损金额
                        </div>
                        <div data-field="lendQty"
                             uglcw-options="width: 120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.lendQty,\'n2\')#'">
                            借出数量
                        </div>
                        <div data-field="lendAmt"
                             uglcw-options="width: 120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.lendAmt,\'n2\')#'">
                            借出金额
                        </div>
                        <div data-field="checkOutQty"
                             uglcw-options="width: 120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.checkOutQty,\'n2\')#'">
                            盘亏数量
                        </div>
                        <div data-field="checkOutAmt"
                             uglcw-options="width: 120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.checkOutAmt,\'n2\')#'">
                            盘亏金额
                        </div>
                        <div data-field="_bqck"
                             uglcw-options="width: 120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data._bqck,\'n2\')#'">
                            本期出库
                        </div>
                        <div data-field="endQty"
                             uglcw-options="width: 120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.endQty,\'n2\')#'">
                            期末数量
                        </div>
                        <div data-field="endAmt"
                             uglcw-options="width: 120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.endAmt,\'n2\')#'">
                            期末金额
                        </div>
                        <div data-field="avgPrice1"
                             uglcw-options="width: 120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.avgPrice1,\'n2\')#'">
                            期末平均单价
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-uglcw-template" id="toolbar">
    <a role="button" href="javascript:calInventory();" class="k-button k-button-icontext">
        <span class="k-icon k-i-calculator"></span>重新计算库存
    </a>
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        uglcw.ui.init();
        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        });

        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal');
            uglcw.ui.get('#gird').reload();
        });
        uglcw.ui.loaded()
    });


    function calInventory() {
        uglcw.ui.confirm('确定重新计算库存吗？', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/updateStorageQty',
                type: 'post',
                success: function (response) {
                    uglcw.ui.loaded();
                    if (response.state) {
                        uglcw.ui.success('计算成功')
                    } else {
                        uglcw.ui.error('提交失败')
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
