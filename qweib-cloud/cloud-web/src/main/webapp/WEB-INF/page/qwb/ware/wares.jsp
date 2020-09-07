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

<body onload="queryWare()">
<input type="hidden" name="wtype" id="wtype" value="${wtype}"/>
<div class="easyui-layout" data-options="fit:true">
    <div data-options="region:'center',border:false" title="">
        <div class="easyui-layout" data-options="fit:true">
            <div data-options="region:'north',border:false" title="查询条件" style="height:60px">
                <div style="width: 970px;">
                    <span id="wareNmSpan">商品名称</span>: <input name="wareNm" id="wareNm" class="easyui-textbox" onkeydown="toQuery(event);" />

                    大单位条码: <input name="packBarCode" id="packBarCode" class="easyui-textbox"/>
                    小单位条码: <input name="beBarCode" id="beBarCode" class="easyui-textbox"/>
                    商品状态：<select name="status" id="status">
                    <option value="">全部</option>
                    <option value="1">启用</option>
                    <option value="2">不启用</option>
                </select>
                    <input type="hidden" name="wtype" id="wtypeid" value="${wtype}"/>
                    <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryWare();">查询</a>
                </div>
            </div>
            <div data-options="region:'center',border:false" title="数据列表">
                <table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="false"
                       url="manager/wares?wtype=${wtype}&isType=${isType}" border="false"
                       rownumbers="true" fitColumns="false" pagination="true"
                       pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#gridbar">
                    <thead frozen="true">
                    <th field="wareId" checkbox="true"></th>
                    <th field="wareCode" width="80" align="center">
                        商品编码
                    </th>
                    <th field="wareNm" width="100" align="left">
                        商品名称
                    </th>
                    </thead>
                    <thead>
                    <tr>
                        <th field="py" width="100" align="left">
                            助记码
                        </th>
                        <th field="waretypeNm" width="80" align="center" formatter="formatType">
                            所属分类
                        </th>
                        <th field="brandNm" width="80" align="center">
                            所属品牌
                        </th>
                        <th field="qualityDays" width="80" align="center">
                            保质期
                        </th>
                        <th field="wareGg" width="80" align="left">
                            规格
                        </th>
                        <th field="wareDw" width="60" align="center">
                            大单位
                        </th>
                        <th field="packBarCode" width="100" align="center">
                            大单位条码
                        </th>
                        <th field="minUnit" width="100" align="center">
                            小单位
                        </th>
                        <th field="beBarCode" width="100" align="center">
                            小单位条码
                        </th>
                        <th field="sunitFront" width="80" align="center" formatter="sunitFrontFormatter">
                            默认开单
                        </th>
                        <th field="inPrice" width="60" align="center" formatter="formatInPrice">
                            采购价
                        </th>
                        <th field="wareDj" width="60" align="center">
                            批发价
                        </th>
                        <th field="lsPrice" width="60" align="center">
                            大单位原价
                        </th>
                        <th field="tranAmt" width="60" align="center" formatter="formatTranAmt">
                            运输费用
                        </th>
                        <th field="tcAmt" width="60" align="center" formatter="formatTcAmt">
                            提成费用
                        </th>
                        <th field="multiSpecNm" width="60" align="center">
                            所属多规格商品
                        </th>
                        <th field="asnNo" width="60" align="center" formatter="formatField2">
                            标识码
                        </th>
                        <th field="fbtime" width="100" align="center">
                            发布时间
                        </th>
                        <th field="status" width="60" align="center" formatter="formatterStatus">
                            是否启用
                        </th>
                        <th field="isCy" width="60" align="center" formatter="formatterSt">
                            是否常用
                        </th>
                    </tr>
                    </thead>
                </table>
                <div id="gridbar">
                    <div style="padding: 2px">
                        <tag:permission name="添加" image="icon-add" onclick="javascript:toaddware();"
                                        buttonCode="qwb.sysWare.add"></tag:permission>
                        <tag:permission name="修改" image="icon-page_edit" onclick="javascript:toupdateware();"
                                        buttonCode="qwb.sysWare.modify"></tag:permission>
                        <tag:permission name="删除" image="icon-delete" onclick="javascript:toDel();"
                                        buttonCode="qwb.sysWare.delete"></tag:permission>
                        <tag:permission name="编辑" image="icon-redo" id="editPrice" onclick="javascript:editPrice();"
                                        buttonCode="qwb.sysWare.editcost"></tag:permission>

                        <tag:permission name="按客户等级设置商品销售价格" image="icon-redo" onclick="javascript:setLevelPrice();"
                                        buttonCode="qwb.sysWare.setcusprice"></tag:permission>

                        <tag:permission name="按客户类型设置商品销售价格" image="icon-redo" onclick="javascript:setTypePrice();"
                                        buttonCode="qwb.sysWare.setqdprice"></tag:permission>

                        <tag:permission name="下载模板" image="icon-redo" onclick="javascript:toWareModel();"
                                        buttonCode="qwb.sysWare.download"></tag:permission>
                        <tag:permission name="上传商品" image="icon-redo" onclick="javascript:toUpWare();"
                                        buttonCode="qwb.sysWare.upload"></tag:permission>

                        <a id="wareDataDownLoad"   class="easyui-linkbutton" style="display: none" plain="true" iconCls="icon-redo" href="javascript:toWareDataModel()">下载数据</a>

                        <tag:permission name="设置费用价格" image="icon-redo" onclick="javascript:setCostPrice();"
                                        buttonCode="qwb.sysWare.setcost"></tag:permission>

                        <tag:permission name="批量调整商品类别" image="icon-redo" onclick="javascript:updateWareType();"
                                        buttonCode="qwb.sysWare.batchwaretype"></tag:permission>
                        <tag:permission name="批量调整开单单位" image="icon-redo" onclick="javascript:updateSunitFront();"
                                        buttonCode="qwb.sysWare.batchwaretype"></tag:permission>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div id="upDiv" class="easyui-window" style="width:500px;height:100px;padding:10px;"
     minimizable="false" maximizable="false" collapsible="false" closed="true">
    <form action="manager/toUpWareTemplateData" id="upFrm" method="post" enctype="multipart/form-data">
        <table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr height="30px">
                <td>选择文件：</td>
                <td>
                    <input type="file" name="upFile" id="upFile" title="check"/>
                </td>
                <td><input type="button" onclick="toUpWareExcel();" style="width: 50px" value="上传"/></td>
            </tr>
        </table>
    </form>
</div>

<div id="sunitFrontDialog" closed="true"
     class="easyui-dialog"
     style="width:250px;height: 130px;padding: 10px;"
     title="设置默认开单单位"
     data-options="
        iconCls: 'icon-save',
        buttons:[{
					text:'确定',
					iconCls:'icon-ok',
					handler:function(){
						batchUpdateSunitFront();
					}
				},{
					text:'取消',
					handler:function(){
						$('#sunitFrontDialog').dialog('close');
					}
				}]"
>
    <div id="sunit-form" style="display: inline-flex; margin: 10px;">
        <div>
            <label>大单位:</label>
            <input id="bigUnit" type="radio" checked name="sunitFront" value="">
        </div>
        <div style="margin-left: 30px;">
            <label>小单位:</label>
            <input type="radio" id="smallUnit" name="sunitFront" value="1">
        </div>
    </div>
</div>

<div id="dlg" closed="true" class="easyui-dialog" title="商品类别" style="width:250px;height:130px;padding:10px"
     data-options="
				iconCls: 'icon-save',
				
				buttons: [{
					text:'确定',
					iconCls:'icon-ok',
					handler:function(){
						batchUpdateWareType();
					}
				},{
					text:'取消',
					handler:function(){
						$('#dlg').dialog('close');
					}
				}]
			">
    <select id="waretypecomb" class="easyui-combotree" style="width:200px;"
            data-options="url:'manager/syswaretypes',animate:true,dnd:true,onClick: function(node){
						setTypeWare(node.id);
						}"></select>
    <input type="hidden" id="waretype"/>
</div>
<div id="editdlg" closed="true" class="easyui-dialog" maximized="true" title="编辑"
     style="width:600px;height:500px;padding:10px">
    <iframe name="editfrm" id="editfrm" frameborder="0" marginheight="0" marginwidth="0" width="100%"
            height="100%"></iframe>
</div>
<script type="text/javascript">
    $("#status").val("1");

    //查询
    function queryWare() {
        $("#datagrid").datagrid('load', {
            url: "manager/wares",
            wareNm: $("#wareNm").val(),
            status: $("#status").val(),
            packBarCode: $('#packBarCode').val(),
            beBarCode: $('#beBarCode').val()
        });
    }

    //添加
    function toaddware() {
        // var id = document.getElementById("wtypeid").value;
        // if (id == 0) {
        //     alert("没有商品类别或者没选择商品类别，不能添加商品！");
        // } else {
            // window.location.href="${base}/manager/tooperware?wtype="+$("#wtype").val();
            document.getElementById("editfrm").src = "${base}/manager/tooperware?wtype=" + $("#wtype").val();
            $('#editdlg').dialog('open');
      //  }
    }

    function reloadware() {
        $("#datagrid").datagrid("reload");
    }

    //修改
    function toupdateware() {
        var row = $('#datagrid').datagrid('getSelected');
        if (row) {
            var Id = row.wareId;
            document.getElementById("editfrm").src = "${base}/manager/tooperware?Id=" + Id + "&wtype=" + $("#wtype").val();
            $('#editdlg').dialog('open');
            //window.location.href="${base}/manager/tooperware?Id="+Id+"&wtype="+$("#wtype").val();
        } else {
            alert("请选择行");
        }
    }

    function formatType(val, row, index) {
        return row.waretypeNm;
    }

    //详情
    function toxq() {
        var row = $('#datagrid').datagrid('getSelected');
        if (row) {
            var Id = row.wareId;
            window.parent.parent.add(row.wareNm, "${base}/manager/warexq?Id=" + Id);
        } else {
            alert("请选择行");
        }
    }

    function updateWareType() {
        var rows = $('#datagrid').datagrid('getSelections');
        var ids = "";
        for (var i = 0; i < rows.length; i++) {
            ids = ids + "," + rows[i].wareId;
        }
        $('#waretypecomb').combotree('setValue', "");
        $('#waretype').val("");
        $('#dlg').dialog('open');
    }

    function updateSunitFront() {
        var rows = $('#datagrid').datagrid('getSelections');
        if (!rows || rows.length < 1) {
            $.messager.alert('提示', '请选择商品!');
            return;
        }
        $('#sunitFrontDialog').dialog('open');
    }

    function batchUpdateSunitFront() {
        var rows = $('#datagrid').datagrid('getSelections');
        if (!rows || rows.length < 1) {
            $.messager.alert('提示', '请选择商品!');
            return;
        }

        var ids = $.map(rows, function (row) {
            return row.wareId
        });

        var unitType = $('#sunit-form').find('input[type="radio"]:checked').val()

        $.ajax({
            url: '/manager/batchUpdateWareSunitFront',
            data: JSON.stringify({
                ids: ids,
                type: unitType,
            }),
            contentType: 'application/json',
            dataType: 'json',
            type: 'post',
            success: function (response) {
                if (response.code == 200) {
                    $('#sunitFrontDialog').dialog('close');
                    queryWare();
                }
            }
        })

    }

    function batchUpdateWareType() {
        var rows = $('#datagrid').datagrid('getSelections');
        var ids = "";
        for (var i = 0; i < rows.length; i++) {
            if (ids != '') {
                ids = ids + ",";
            }
            ids = ids + rows[i].wareId;
        }
        if (ids == "") {
            $.messager.alert('提示', '请选择商品！');
            return;
        }
        var wareType = $("#waretype").val();
        if (wareType == "") {
            $.messager.alert('Warning', '请选择商品类别！');
            return;
        }
        $.messager.confirm('Confirm', '是否确定更改商品类别?', function (r) {
            if (r) {
                $.ajax({
                    url: "manager/batchUpdateWareType",
                    data: "ids=" + ids + "&wareType=" + wareType,
                    type: "post",
                    success: function (json) {
                        if (json != "-1") {
                            //alert("更新成功");
                            $('#dlg').dialog('close');
                            queryWare();
                        } else {
                            $.messager.alert('Error', '商品类别更新失败！');
                            return;
                        }
                    }
                });
            }
        });

    }

    function setTypeWare(typeId) {
        $("#waretype").val(typeId);
    }

    //删除
    function toDel() {
        var ids = [];
        var rows = $("#datagrid").datagrid("getSelections");
        for (var i = 0; i < rows.length; i++) {
            ids.push(rows[i].wareId);
        }
        if (ids.length > 0) {
            if (confirm("是否要删除选中的商品?")) {
                $.ajax({
                    url: "manager/deleteware",
                    data: "ids=" + ids,
                    type: "post",
                    success: function (json) {
                        if (json == "1") {
                            alert("删除成功");
                            queryWare();
                        } else if (json == "2") {
                            alert("删除失败,该商品已使用!");
                        } else {
                            alert("删除失败");
                            return;
                        }
                    }
                });
            }
        }
    }

    function formatInPrice(val, row, index) {
        var inPrice = row.inPrice;
        if (inPrice == undefined || inPrice == "undefined") {
            inPrice = 0.0;
        }
        return "<input type='text' style='display:none' size='7' onclick='gjr_CellClick(this)' onchange='changeInPrice(this," + row.wareId + ")' name='inPrice' value='" + inPrice + "'/><span name='inPrice1'>" + inPrice + "</span>";
    }

    function formatTranAmt(val, row, index) {
        var tranAmt = row.tranAmt;
        if (tranAmt == undefined || tranAmt == "undefined") {
            tranAmt = 0.0;
        }
        return "<input type='text' style='display:none' size='7' onclick='gjr_CellClick(this)' onchange='changeTranPrice(this," + row.wareId + ")' name='tranAmt' value='" + tranAmt + "'/><span name='tranAmt1'>" + tranAmt + "</span>";
    }

    function formatTcAmt(val, row, index) {
        var tcAmt = row.tcAmt;
        if (tcAmt == undefined || tcAmt == "undefined") {
            tcAmt = 0.0;
        }
        return "<input type='text' style='display:none' size='7' onclick='gjr_CellClick(this)' onchange='changeTcPrice(this," + row.wareId + ")' name='tcAmt' value='" + tcAmt + "'/><span name='tcAmt1'>" + tcAmt + "</span>";
    }

    function changeInPrice(obj, wareId) {
        $.ajax({
            url: "manager/updateWareInPrice",
            type: "post",
            data: "id=" + wareId + "&inPrice=" + obj.value,
            success: function (data) {
                if (data == '1') {
                    //alert("操作成功");
                    //queryWare();
                } else {
                    alert("操作失败");
                    return;
                }
            }
        });
    }

    function changeTranPrice(obj, wareId) {
        $.ajax({
            url: "manager/updateWareTranAmt",
            type: "post",
            data: "id=" + wareId + "&tranAmt=" + obj.value,
            success: function (data) {
                if (data == '1') {
                    //alert("操作成功");
                    //queryWare();
                } else {
                    alert("操作失败");
                    return;
                }
            }
        });
    }

    function changeTcPrice(obj, wareId) {
        $.ajax({
            url: "manager/updateWareTcAmt",
            type: "post",
            data: "id=" + wareId + "&tcAmt=" + obj.value,
            success: function (data) {
                if (data == '1') {
                    //alert("操作成功");
                    //queryWare();
                } else {
                    alert("操作失败");
                    return;
                }
            }
        });
    }

    var k = 1;

    function editPrice() {
        var inPrice = document.getElementsByName("inPrice");
        var inPrice1 = document.getElementsByName("inPrice1");
        var tranAmt = document.getElementsByName("tranAmt");
        var tranAmt1 = document.getElementsByName("tranAmt1");
        var tcAmt = document.getElementsByName("tcAmt");
        var tcAmt1 = document.getElementsByName("tcAmt1");

        var aliasName = document.getElementsByName("aliasName");
        var aliasName1 = document.getElementsByName("aliasName1");

        var asnNo = document.getElementsByName("asnNo");
        var asnNo1 = document.getElementsByName("asnNo1");
        for (var i = 0; i < tranAmt.length; i++) {
            if (k == 1) {
                tranAmt[i].style.display = '';
                tranAmt1[i].style.display = 'none';
                tcAmt[i].style.display = '';
                tcAmt1[i].style.display = 'none';
                inPrice[i].style.display = '';
                inPrice1[i].style.display = 'none';
               /* aliasName[i].style.display = '';
                aliasName1[i].style.display = 'none';
                asnNo[i].style.display = '';
                asnNo1[i].style.display = 'none';*/
            } else {
                tranAmt[i].style.display = 'none';
                tranAmt1[i].style.display = '';
                tcAmt[i].style.display = 'none';
                tcAmt1[i].style.display = '';
                inPrice[i].style.display = 'none';
                inPrice1[i].style.display = '';
               /* aliasName[i].style.display = 'none';
                aliasName1[i].style.display = '';
                asnNo[i].style.display = 'none';
                asnNo1[i].style.display = '';*/
            }
        }
        if (k == 1) {
            document.getElementById("editPrice").innerHTML = "关闭编辑";
            k = 0;
        } else {
            document.getElementById("editPrice").innerHTML = "编辑";
            k = 1;
        }
    }

    function formatterSt(val, row) {
        if (val == 1) {
            return "<input style='width:60px;height:27px;background-color:#36BDEF;color:#FFFFFF;' type='button' value='是' onclick='updateStudyTop(this, " + row.wareId + ",2)'/>";
        } else {
            return "<input style='width:60px;height:27px;background-color:#36BDEF;color:#FFFFFF;' type='button' value='否' onclick='updateStudyTop(this, " + row.wareId + ",1)'/>";
        }
    }

    function formatterStatus(val, row) {
        if (val == 1) {
            return "是";
        } else {
            return "否";
        }
    }

    //修改是否常用
    function updateStudyTop(_this, id, isCy) {
        $.ajax({
            url: "manager/updateWareIsCy",
            type: "post",
            data: "id=" + id + "&isCy=" + isCy,
            success: function (data) {
                if (data == '1') {
                    alert("操作成功");
                    queryWare();
                } else {
                    alert("操作失败");
                    return;
                }
            }
        });
    }

    //上传文件
    function toUpWareExcel() {
        $("#upFrm").form('submit', {
            success: function (data) {
                if (data == '1') {
                    alert("上传成功");
                    //document.getElementById("upDiv").window('close');
                    //parent.parent.closeWin('导入商品信息确认');
                    //parent.parent.add('导入商品信息确认','manager/towaresimport');
                    queryWare();
                } else {
                    alert(data);
                }
                onclose();
            },
            onSubmit: function () {
                DIVAlert("<img src='resource/images/loading.gif' width='50px' height='50px'/>");
            }
        });
    }

    //下载模板
    function toWareModel() {
        if (confirm("是否下载商品上传需要的文档?")) {
            window.location.href = "manager/toWareImportTemplate";
        }

    }

    function toWareDataModel() {
        if (confirm("是否下载商品数据?")) {
            window.location.href = "manager/toWareImportData";
        }

    }

    function toShowImportWare() {
        parent.parent.closeWin('导入商品信息确认');
        parent.parent.add('导入商品信息确认', 'manager/towaresimport');
    }

    function changeFieldValue(o, id, field) {
        $.ajax({
            url: "manager/updateTabWare",
            data: {id: id, value: o.value, field: field},
            type: "post",
            success: function (json) {

            }
        });
    }

    function formatField1(val, row, index) {
        return "<input type='text' style='display:none' size='12'  onchange='changeFieldValue(this," + row.wareId + ",\"aliasName\")' name='aliasName' value='" + val + " '/><span name='aliasName1'>" + val + "</span>";

    }

    function formatField2(val, row, index) {
        return "<input type='text' style='display:none' size='12'  onchange='changeFieldValue(this," + row.wareId + ",\"asnNo\")' name='asnNo' value='" + val + "'/><span name='asnNo1'>" + val + "</span>";
    }

    //显示上传框
    function toUpWare() {
        $("#upDiv").window({title: '上传', modal: true});
        $("#upDiv").window('open');
    }

    function setLevelPrice() {
        window.parent.parent.add("按客户等级设置商品销售价格", "manager/levelpricewaretype");
    }

    function setTypePrice() {
        window.parent.parent.add("按渠道类型设置商品销售价格", "manager/qdtypepricewaretype");
    }

    function setCostPrice() {
        window.parent.parent.add("设置费用价格", "manager/autopricewaretype");
    }

    function setCgPrice() {
        window.parent.parent.add("设置采购价格", "manager/stkWare?dataTp=1");
    }

    function gjr_CellClick(o) {
        o.select();
    }

    function sunitFrontFormatter(val, row) {
        return val ? '<span style="color:red;">小单位</span>' : '大单位';
    }
    $("#wareNmSpan").dblclick(function(){
        $("#wareDataDownLoad").show();
    });

</script>
</body>
</html>
