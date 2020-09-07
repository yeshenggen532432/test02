<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>企微宝</title>

    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">
    <%@include file="/WEB-INF/page/include/source.jsp" %>
    <script type="text/javascript" src="resource/loadDiv.js"></script>
</head>

<body>
<input type="hidden" name="wtype" id="wtype" value="${wtype}"/>
<input type="hidden" name="mastId" id="mastId" value="${mastId}"/>
<div class="easyui-layout" data-options="fit:true">
    <div data-options="region:'center',border:false" title="">
        <div class="easyui-layout" data-options="fit:true">
            <div data-options="region:'north',border:false" title="查询与修改" style="height:60px">
                <div style="width: 970px;">
                    商品名称: <input name="productName" id="productName" class="easyui-textbox" onkeydown="queryWare();"/>
                    <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryWare();">查询</a>
                    <a class="easyui-linkbutton" iconCls="icon-edit" href="javascript:toUpdateWare();">修改商品信息</a>
                    <a class="easyui-linkbutton" iconCls="icon-edit" href="javascript:importToDb();">导入产品库</a>
                </div>
            </div>
            <div data-options="region:'center',border:false" title="数据列表">
                <table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
                       url="/manager/company/product/temp/productPage?recordId=${recordId}" border="false"
                       rownumbers="true" fitColumns="false" pagination="true"
                       pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#gridbar"
                       data-options="method:'get',
                       onBeforeLoad : function(param){
                            param['size'] = param.rows;
                            delete param.rows;
                            }"
                >
                    <thead frozen="true">
                    <th field="id" width="60" align="right" hidden="true">
                        id
                    </th>
                    <th field="categoryName" width="80" align="center">
                        所属分类
                    </th>
                    <th field="productCode" width="80" align="left">
                        商品编号
                    </th>
                    <th field="productName" width="100" align="left">
                        商品名称
                    </th>
                    </thead>
                    <thead>
                    <tr>
                        <th field="bigUnitName" width="80" align="center">
                            大单位名称
                        </th>
                        <th field="bigUnitSpec" width="80" align="center">
                            大单位规格
                        </th>
                        <th field="bigUnitScale" width="100" align="center">
                            大单位换算基数
                        </th>
                        <th field="bigBarCode" width="80" align="center">
                            大单位条码
                        </th>
                        <th field="bigPurchasePrice" width="100" align="right">
                            大单位采购价格
                        </th>
                        <th field="bigSalePrice" width="100" align="right">
                            大单位销售单价
                        </th>
                        <th field="smallUnitName" width="80" align="center">
                            小单位名称
                        </th>
                        <th field="smallUnitSpec" width="80" align="center">
                            小单位规格
                        </th>
                        <th field="smallUnitScale" width="100" align="center">
                            小单位换算基数
                        </th>
                        <th field="smallBarCode" width="80" align="center">
                            小单位条码
                        </th>
                        <th field="smallSalePrice" width="80" align="right">
                            小单位销售价
                        </th>
                        <th field="expirationDate" width="60" align="center">
                            保质期
                        </th>
                        <th field="providerName" width="100" align="center">
                            生产厂家
                        </th>
                        <th field="updatedName" width="60" align="center">
                            更新人
                        </th>
                    </tr>
                    </thead>
                </table>
                <div id="gridbar">
                    <div style="padding: 2px">

                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="updateWareDiv" class="easyui-window" style="width:520px;height:400px;overflow-y: scroll;"
         title="修改商品信息" minimizable="false" modal="true" collapsible="false" closed="true">
        <input name="id" id="id" style="width:120px;height: 20px;display: none;"/>
        <br/>
        <br/>
        <label style="width: 100px;display: inline-block;text-align: right;">所属分类:</label><input name="categoryName"
                                                                                                 id="categoryName"
                                                                                                 style="width:150px;height: 20px;"/>
        <br/>
        <br/>
        <label style="width: 100px;display: inline-block;text-align: right;">商品编号:</label><input name="productCode"
                                                                                                 id="productCode"
                                                                                                 style="width:150px;height: 20px;"/>
        <br/>
        <br/>
        <label style="width: 100px;display: inline-block;text-align: right;">商品名称:</label><input name="productName1"
                                                                                                 id="productName1"
                                                                                                 style="width:150px;height: 20px;"/>
        <br/>
        <br/>
        <label style="width: 100px;display: inline-block;text-align: right;">大单位名称:</label><input name="bigUnitName"
                                                                                                  id="bigUnitName"
                                                                                                  style="width:150px;height: 20px;"/>
        <br/>
        <br/>
        <label style="width: 100px;display: inline-block;text-align: right;">大单位规格:</label><input name="bigUnitSpec"
                                                                                                  id="bigUnitSpec"
                                                                                                  style="width:150px;height: 20px;"/>
        <br/>
        <br/>
        <label style="width: 100px;display: inline-block;text-align: right;">大单位换算基数:</label><input name="bigUnitScale"
                                                                                                    id="bigUnitScale"
                                                                                                    style="width:150px;height: 20px;"/>
        <br/>
        <br/>
        <label style="width: 100px;display: inline-block;text-align: right;">大单位条码:</label><input name="bigBarCode"
                                                                                                  id="bigBarCode"
                                                                                                  style="width:150px;height: 20px;"/>
        <br/>
        <br/>
        <label style="width: 100px;display: inline-block;text-align: right;">大单位采购价格:</label><input
            name="bigPurchasePrice" id="bigPurchasePrice" style="width:150px;height: 20px;"/>
        <br/>
        <br/>
        <label style="width: 100px;display: inline-block;text-align: right;">大单位销售单价:</label><input name="bigSalePrice"
                                                                                                    id="bigSalePrice"
                                                                                                    style="width:150px;height: 20px;"/>
        <br/>
        <br/>
        <label style="width: 100px;display: inline-block;text-align: right;">小单位名称:</label><input name="smallUnitName"
                                                                                                  id="smallUnitName"
                                                                                                  style="width:150px;height: 20px;"/>
        <br/>
        <br/>
        <label style="width: 100px;display: inline-block;text-align: right;">小单位换算基数:</label><input
            name="smallUnitScale" id="smallUnitScale" style="width:150px;height: 20px;"/>
        <br/>
        <br/>
        <label style="width: 100px;display: inline-block;text-align: right;">小单位条码:</label><input name="smallBarCode"
                                                                                                  id="smallBarCode"
                                                                                                  style="width:150px;height: 20px;"/>
        <br/>
        <br/>
        <label style="width: 100px;display: inline-block;text-align: right;">小单位销售价:</label><input name="smallSalePrice"
                                                                                                   id="smallSalePrice"
                                                                                                   style="width:150px;height: 20px;"/>
        <br/>
        <br/>
        <label style="width: 100px;display: inline-block;text-align: right;">保质期:</label><input name="expirationDate"
                                                                                                id="expirationDate"
                                                                                                style="width:150px;height: 20px;"/>
        <br/>
        <br/>
        <label style="width: 100px;display: inline-block;text-align: right;">生产厂家:</label><input name="providerName"
                                                                                                 id="providerName"
                                                                                                 style="width:150px;height: 20px;"/>
        <br/>
        <br/>
        <label style="width: 100px;display: inline-block;text-align: right;">备注:</label><input name="remark"
                                                                                                 id="remark"
                                                                                                 style="width:150px;height: 20px;"/>
        <input name="updatedName" id="updatedName" style="width:150px;height: 20px;display: none;"/>
        <a class="easyui-linkbutton" iconCls="icon-save" href="javascript:updateWare();" style="margin-left:230px; ">保存修改</a>
        <br/>
        <br/>
    </div>
</div>

</div>
<script type="text/javascript">
    function queryWare() {
        $("#datagrid").datagrid('load', {
            productName: $("#productName").val().trim(),
        });
    }

    function reloadware() {
        $("#datagrid").datagrid("reload");
    }

    function formatType(val, row, index) {
        return row.waretypeNm;
    }

    function formatterSt(val, row) {
        if (val == 1) {
            return "是";
        } else {
            return "否";
        }
    }

    function formatterStatus(val, row) {
        if (val == 1) {
            return "是";
        } else {
            return "否";
        }
    }

    function toUpdateWare() {
        var rows = $("#datagrid").datagrid("getSelections");
        if (rows.length == 0) {
            alert("请选择商品信息！");
        } else {
            var rows = $("#datagrid").datagrid("getSelections");
            $("#id").val(rows[0].id);
            $("#categoryName").val(rows[0].categoryName);
            $("#productCode").val(rows[0].productCode);
            $("#productName1").val(rows[0].productName);
            $("#bigUnitName").val(rows[0].bigUnitName);
            $("#bigUnitSpec").val(rows[0].bigUnitSpec);
            $("#bigUnitScale").val(rows[0].bigUnitScale);
            $("#bigBarCode").val(rows[0].bigBarCode);
            $("#bigPurchasePrice").val(rows[0].bigPurchasePrice);
            $("#bigSalePrice").val(rows[0].bigSalePrice);
            $("#smallUnitName").val(rows[0].smallUnitName);
            $("#smallUnitSpec").val(rows[0].smallUnitSpec);
            $("#smallUnitScale").val(rows[0].smallUnitScale);
            $("#smallBarCode").val(rows[0].smallBarCode);
            $("#smallSalePrice").val(rows[0].smallSalePrice);
            $("#expirationDate").val(rows[0].expirationDate);
            $("#providerName").val(rows[0].providerName);
            $("#updatedName").val(rows[0].updatedName);
            $("#remark").val(rows[0].remark);
            $("#updateWareDiv").window('open');
        }
    }

    function importToDb() {
        $.ajax({
            url: "/manager/company/product/temp_record/import_to_db",
            data: {"recordId": "${recordId}"},
            type: "post",
            success: function (response) {
                alert(response.message);
            }
        });
    }

    function updateWare() {
        $.ajax({
            url: "/manager/company/product/temp/" + $("#id").val(),
            data: JSON.stringify({
                "categoryName": $("#categoryName").val(),
                "productCode": $("#productCode").val(),
                "productName": $("#productName1").val(),
                "bigUnitName": $("#bigUnitName").val(),
                "bigUnitSpec": $("#bigUnitSpec").val(),
                "bigUnitScale": $("#bigUnitScale").val(),
                "bigBarCode": $("#bigBarCode").val(),
                "bigPurchasePrice": $("#bigPurchasePrice").val(),
                "bigSalePrice": $("#bigSalePrice").val(),
                "smallUnitName": $("#smallUnitName").val(),
                "smallUnitSpec": $("#smallUnitSpec").val(),
                "smallUnitScale": $("#smallUnitScale").val(),
                "smallBarCode": $("#smallBarCode").val(),
                "smallSalePrice": $("#smallSalePrice").val(),
                "expirationDate": $("#expirationDate").val(),
                "providerName": $("#providerName").val(),
            }),
            type: "post",
            contentType: "application/json",
            success: function (data) {
                if (data.state) {
                    alert(data.message);
                    $("#updateWareDiv").window('close');
                    $("#datagrid").datagrid("reload");

                } else {
                    alert(data.message);
                }
            }
        });
    }

</script>
</body>
</html>
