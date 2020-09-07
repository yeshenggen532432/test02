<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>企微宝</title>

    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">
    <%@include file="/WEB-INF/page/include/source.jsp" %>
    <script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
</head>

<body onload="initData()">
<input type="hidden" id="accId" value="${accId}"/>


<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
       title="" iconCls="icon-save" border="false"
       rownumbers="true" fitColumns="false"
       toolbar="#tb">

</table>
<div id="tb" style="padding:5px;height:auto">

    <a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:addBankClick();">增加银行账号</a>
    <a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:addWxClick();">增加微信账号</a>
    <a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:addZfbClick();">增加支付账号</a>
    <a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:addWkClick();">增加无卡账号</a>
    <a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:showTemplate();">数据参考</a>
    <br/>
    &nbsp;&nbsp;&nbsp;&nbsp;
    <input type="radio" name="chkStatus" onclick="javascript:queryList();" checked="checked" value="0"/>正常
    <input type="radio" name="chkStatus" onclick="javascript:queryList();" value="1"/>停用
    <input type="radio" name="chkStatus" onclick="javascript:queryList();" value=""/>全部
</div>
<div id="wxdlg" closed="true" class="easyui-dialog" title="微信账号" style="width:400px;height:200px;padding:10px"
     data-options="
				iconCls: 'icon-save',
				
				buttons: [{
					text:'确定',
					iconCls:'icon-ok',
					handler:function(){
						editWx();
					}
				},{
					text:'取消',
					handler:function(){
						$('#wxdlg').dialog('close');
					}
				}]
			">
    账号: <input name="accNo" id="accNo" value="${accNo}" style="width:120px;height: 20px;"/>
    <br/>
    <br/>
    备注: <input name="wxremarks" id="wxremarks" value="${remarks}" style="width:150px;height: 20px;"/>
</div>

<div id="zfbdlg" closed="true" class="easyui-dialog" title="支付宝账号" style="width:400px;height:200px;padding:10px"
     data-options="
				iconCls: 'icon-save',
				
				buttons: [{
					text:'确定',
					iconCls:'icon-ok',
					handler:function(){
						editZfb();
					}
				},{
					text:'取消',
					handler:function(){
						$('#zfbdlg').dialog('close');
					}
				}]
			">
    账号: <input name="accNo1" id="accNo1" value="${accNo}" style="width:120px;height: 20px;"/>
    <br/>
    <br/>
    备注: <input name="zfbremarks" id="zfbremarks" value="${remarks}" style="width:150px;height: 20px;"/>
</div>

<div id="wkdlg" closed="true" class="easyui-dialog" title="无卡账号" style="width:400px;height:200px;padding:10px"
     data-options="
				iconCls: 'icon-save',
				
				buttons: [{
					text:'确定',
					iconCls:'icon-ok',
					handler:function(){
						editWk();
					}
				},{
					text:'取消',
					handler:function(){
						$('#wkdlg').dialog('close');
					}
				}]
			">
    账号: <input name="accNo4" id="accNo4" value="${accNo}" style="width:120px;height: 20px;"/>
    <br/>
    <br/>
    备注: <input name="wkremarks" id="wkremarks" value="${remarks}" style="width:150px;height: 20px;"/>
</div>


<div id="bankdlg" closed="true" class="easyui-dialog" title="银行账号" style="width:400px;height:200px;padding:10px"
     data-options="
				iconCls: 'icon-save',
				
				buttons: [{
					text:'确定',
					iconCls:'icon-ok',
					handler:function(){
						edtBank();
					}
				},{
					text:'取消',
					handler:function(){
						$('#bankdlg').dialog('close');
					}
				}]
			">
    账号: <input name="accNo2" id="accNo2" value="${accNo}" style="width:220px;height: 20px;"/>
    <br/>
    <br/>

    <div style="position:relative;">
        银行:
        <span style="margin-left:100px;width:18px;overflow:hidden;">
		<select id="bankSel" style="width:220px;margin-left:-100px"
                onchange="this.parentNode.nextSibling.value=this.value">
		
 		</select></span><input name="box" style="width:193px;position:absolute;left:30px;" id="bankName">
    </div>

    <br/>
    备注: <input name="bankremarks" id="bankremarks" value="${remarks}" style="width:250px;height: 20px;"/>
</div>

<script type="text/javascript">
    var database = "${database}";

    //queryBasestorage();

    function initData() {
        initGrid();
        queryBank();
    }

    //querydata;
    function initGrid() {
        var cols = new Array();
        var col = {
            field: 'id',
            title: 'id',
            width: 100,
            align: 'center',
            hidden: true
        };
        cols.push(col);
        var col = {
            field: 'accTypeName',
            title: '账号类型',
            width: 80,
            align: 'center'

        };
        cols.push(col);


        var col = {
            field: 'accNo',
            title: '账号',
            width: 150,
            align: 'center'


        };
        cols.push(col);

        var col = {
            field: 'accAmt',
            title: '余额',
            width: 120,
            align: 'center'


        };
        cols.push(col);

        var col = {
            field: 'bankName',
            title: '其它',
            width: 120,
            align: 'center'


        };
        cols.push(col);

        var col = {
            field: 'status',
            title: '状态',
            width: 60,
            align: 'center',
            formatter: formatterStatus


        };
        cols.push(col);

        var col = {
            field: 'isPost',
            title: '是否过账账户',
            width: 100,
            align: 'center',
            formatter: formatterPost
        };
        cols.push(col);

        var col = {
            field: 'isPay',
            title: '是否默认付款账户',
            width: 100,
            align: 'center',
            formatter: formatterPay
        };
        cols.push(col);

        var col = {
            field: 'remarks',
            title: '备注',
            width: 120,
            align: 'center'


        };
        cols.push(col);


        var col = {
            field: '_operator',
            title: '操作',
            width: 260,
            align: 'center',
            formatter: formatterSt3


        };
        cols.push(col);
        var status = $("input[name='chkStatus']:checked").val();
        $('#datagrid').datagrid(
            {
                url: "manager/queryAccountLists",
                queryParams: {
                    jz: "1",
                    status: status
                },
                columns: [
                    cols
                ]
            }
        );
        // $('#datagrid').datagrid('reload');
    }

    //查询物流公司

    function queryList() {
        var status = $("input[name='chkStatus']:checked").val();
        $('#datagrid').datagrid(
            {
                url: "manager/queryAccountLists",
                queryParams: {
                    jz: "1",
                    status: status
                }
            }
        );
    }

    function addWxClick() {
        $("#accId").val(0);
        $('#wxdlg').dialog('open');
    }


    function editWx() {
        var accNo = $("#accNo").val();
        if (accNo == "") {
            alert("请输入账号");
            return;
        }
        var id = $("#accId").val();
        var remarks = $("#wxremarks").val();
        $.ajax({
            url: "manager/saveAccount",
            data: "id=" + id + '&accNo=' + accNo + '&remarks=' + remarks + '&accType=1',
            type: "post",
            success: function (json) {
                if (json.state) {
                    showMsg("保存成功");
                    $('#wxdlg').dialog('close');
                    $("#datagrid").datagrid("reload");
                } else {
                    showMsg("保存失败" + json.msg);
                }
            }
        });
    }

    function addWkClick() {
        $("#accId").val(0);
        $('#wkdlg').dialog('open');
    }

    function editWk() {
        var accNo = $("#accNo4").val();
        if (accNo == "") {
            alert("请输入账号");
            return;
        }
        var id = $("#accId").val();
        var remarks = $("#wkremarks").val();
        $.ajax({
            url: "manager/saveAccount",
            data: "id=" + id + '&accNo=' + accNo + '&remarks=' + remarks + '&accType=4',
            type: "post",
            success: function (json) {
                if (json.state) {
                    showMsg("保存成功");
                    $('#wkdlg').dialog('close');
                    $("#datagrid").datagrid("reload");
                } else {
                    showMsg("保存失败" + json.msg);
                }
            }
        });
    }

    function toEditWk(id) {
        $("#accId").val(id);

        var accNo = "";
        var remarks = "";
        $.ajax({
            url: "manager/queryAccountById",
            data: "accId=" + id,
            type: "post",
            success: function (json) {

                if (json.state) {
                    accNo = json.accNo;
                    remarks = json.remarks;
                    $("#accNo4").val(accNo);

                    $("#wkremarks").val(remarks);
                    $('#wkdlg').dialog('open');
                } else {
                    showMsg("删除失败" + json.msg);
                }
            }
        });

    }


    function addZfbClick() {
        $("#accId").val(0);
        $('#zfbdlg').dialog('open');
    }


    function editZfb() {
        var accNo = $("#accNo1").val();
        if (accNo == "") {
            alert("请输入账号");
            return;
        }
        var id = $("#accId").val();
        var remarks = $("#zfbremarks").val();
        $.ajax({
            url: "manager/saveAccount",
            data: "id=" + id + '&accNo=' + accNo + '&remarks=' + remarks + '&accType=2',
            type: "post",
            success: function (json) {
                if (json.state) {
                    showMsg("保存成功");
                    $('#zfbdlg').dialog('close');
                    $("#datagrid").datagrid("reload");
                } else {
                    showMsg("保存失败" + json.msg);
                }
            }
        });
    }

    function addBankClick() {
        $("#accId").val(0);
        $("#accNo2").val("");
        $("#bankName").val("");
        $("#bankSel").val("");
        $("#bankremarks").val("");
        $('#bankdlg').dialog('open');
    }


    function edtBank() {
        var accNo = $("#accNo2").val();
        if (accNo == "") {
            alert("请输入账号");
            return;
        }
        var id = $("#accId").val();
        var remarks = $("#bankremarks").val();
        var bankName = $("#bankName").val();
        $.ajax({
            url: "manager/saveAccount",
            data: "id=" + id + '&accNo=' + accNo + '&remarks=' + remarks + '&accType=3' + '&bankName=' + bankName,
            type: "post",
            success: function (json) {
                if (json.state) {
                    showMsg("保存成功");
                    $('#bankdlg').dialog('close');
                    $("#datagrid").datagrid("reload");
                } else {
                    showMsg("保存失败" + json.msg);
                }
            }
        });
    }

    function toEditWx(id) {
        $("#accId").val(id);

        var accNo = "";
        var remarks = "";
        $.ajax({
            url: "manager/queryAccountById",
            data: "accId=" + id,
            type: "post",
            success: function (json) {

                if (json.state) {
                    accNo = json.accNo;
                    remarks = json.remarks;
                    $("#accNo").val(accNo);

                    $("#wxremarks").val(remarks);
                    $('#wxdlg').dialog('open');
                } else {
                    showMsg("删除失败" + json.msg);
                }
            }
        });

    }

    function toEditZfb(id) {
        $("#accId").val(id);

        var accNo = "";
        var remarks = "";
        $.ajax({
            url: "manager/queryAccountById",
            data: "accId=" + id,
            type: "post",
            success: function (json) {

                if (json.state) {
                    accNo = json.accNo;
                    remarks = json.remarks;
                    $("#accNo1").val(accNo);

                    $("#zfbremarks").val(remarks);
                    $('#zfbdlg').dialog('open');
                } else {
                    showMsg("删除失败" + json.msg);
                }
            }
        });

    }

    function toEditBank(id) {
        $("#accId").val(id);

        var accNo = "";
        var remarks = "";
        var bankName = "";
        $.ajax({
            url: "manager/queryAccountById",
            data: "accId=" + id,
            type: "post",
            success: function (json) {

                if (json.state) {
                    accNo = json.accNo;
                    remarks = json.remarks;
                    bankName = json.bankName;
                    $("#accNo2").val(accNo);

                    $("#bankremarks").val(remarks);
                    $("#bankName").val(bankName);
                    $('#bankdlg').dialog('open');
                } else {
                    showMsg("删除失败" + json.msg);
                }
            }
        });

    }

    function toEdit(id) {
        var accType = 0;
        var rows = $("#datagrid").datagrid("getRows");
        for (var i = 0; i < rows.length; i++) {
            if (rows[i].id == id) {
                accType = rows[i].accType;
                break;
            }
        }
        if (accType == 1) toEditWx(id);
        if (accType == 2) toEditZfb(id);
        if (accType == 3) toEditBank(id);
        if (accType == 4) toEditWk(id);
    }

    function formatterSt3(val, row, index) {
        if (row.accType == 0) {
            var ret = "<input style='width:100px;height:27px' type='button' id='btnStatus" + index + "' value='销售一键过账账户' onclick='updatePostAccount(" + row.id + "," + index + ")'/>";
            ret += "<br/><input style='width:100px;height:27px' type='button' id='btnStatus" + index + "' value='默认付款账户' onclick='updatePayAccount(" + row.id + "," + index + ")'/>";
            return ret;
        }
        var ret = "<input style='width:60px;height:27px' type='button' value='修改' onclick='toEdit(" + row.id + ")'/>"
            + "<br/><input style='width:60px;height:27px' type='button' value='删除' onclick='deleteAccount(" + row.id + ")'/>"
        ;
        if (row.status == 0) {
            ret += "<br/><input style='width:60px;height:27px' type='button' id='btnStatus" + index + "' value='禁用' onclick='updateAccountStatus(" + row.id + "," + index + ")'/>";
        } else {
            ret += "<br/><input style='width:60px;height:27px' type='button' id='btnStatus" + index + "' value='启用' onclick='updateAccountStatus(" + row.id + "," + index + ")'/>";
        }
        ret += "<br/><input style='width:100px;height:27px' type='button' id='btnStatus" + index + "' value='销售一键过账账户' onclick='updatePostAccount(" + row.id + "," + index + ")'/>";
        ret += "<br/><input style='width:100px;height:27px' type='button' id='btnStatus" + index + "' value='默认付款账户' onclick='updatePayAccount(" + row.id + "," + index + ")'/>";
        return ret;

    }

    function formatterStatus(val, row, index) {
        if (val == 0) {
            return "<span style='display:none' id='statushid" + index + "'>" + val + "</span><span id='statustxt" + index + "'>正常";
        } else {
            return "<span style='display:none' id='statushid" + index + "'>" + val + "</span><span id='statustxt" + index + "'>禁用";
        }
    }

    function formatterPost(val, row, index) {
        if (val == 1) {
            return "是";
        } else {
            return "否";
        }
    }

    function formatterPay(val, row, index) {
        if (val == 1) {
            return "是";
        } else {
            return "否";
        }
    }

    function updateAccountStatus(id, index) {
        var status = document.getElementById("statushid" + index).innerText;
        var flag = 0;
        if (status == 0) {
            flag = 1;
        } else {
            flag = 0;
        }
        $.ajax({
            url: "manager/updateAccountStatus",
            data: "id=" + id + "&status=" + flag,
            type: "post",
            success: function (json) {
                if (json.state) {
                    alert("操作成功！");
                    if (status == 0) {
                        document.getElementById("statushid" + index).innerText = 1;
                        document.getElementById("statustxt" + index).innerText = "禁用";
                        document.getElementById("btnStatus" + index).value = "启用";
                    } else {
                        document.getElementById("statushid" + index).innerText = 0;
                        document.getElementById("statustxt" + index).innerText = "正常";
                        document.getElementById("btnStatus" + index).value = "禁用";
                    }
                } else {
                    alert(json.msg);
                }
            }
        });
    }


    function updatePostAccount(id, index) {
        $.ajax({
            url: "manager/updatePostAccount",
            data: "id=" + id + "&post=1",
            type: "post",
            success: function (json) {
                if (json.state) {
                    alert("操作成功！");
                    queryList();
                } else {
                    alert(json.msg);
                }
            }
        });
    }

    function updatePayAccount(id, index) {
        $.ajax({
            url: "manager/updatePayAccount",
            data: "id=" + id + "&post=1",
            type: "post",
            success: function (json) {
                if (json.state) {
                    alert("操作成功！");
                    queryList();
                } else {
                    alert(json.msg);
                }
            }
        });
    }


    function queryBank() {
        var path = "manager/queryBank";
        //var token = $("#tmptoken").val();
        //alert(token);
        $.ajax({
            url: path,
            type: "POST",
            data: {"token11": ""},
            dataType: 'json',
            async: false,
            success: function (json) {
                if (json.state) {
                    var size = json.rows.length;

                    var objSelect = document.getElementById("bankSel");
                    objSelect.options.add(new Option(''), '');

                    for (var i = 0; i < size; i++) {
                        objSelect.options.add(new Option(json.rows[i], json.rows[i]));


                    }


                }
            }
        });
    }

    function showTemplate() {
        parent.closeWin('账号参考数据');
        parent.add('账号参考数据', 'manager/toAccountTemplate');
    }
</script>
</body>
</html>
