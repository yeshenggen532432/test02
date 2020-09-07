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
    <script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
</head>

<body>
<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
       title="" iconCls="icon-save" border="false"
       rownumbers="true" fitColumns="false" pagination="true"
       pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" data-options="">

</table>
<div id="tb" style="padding:5px;height:auto">

    年份: <input name="year" id="year" style="width:120px;height: 20px;" onkeydown="toQuery(event);" value="${year}"/>


    <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryData();">查询</a>
    <a class="easyui-linkbutton" iconCls="icon-add" href="javascript:addMonth();">增加月份</a>
    <a class="easyui-linkbutton" iconCls="icon-delete" href="javascript:deleteMonth();">删除最后月份</a>




</div>

<div id="dlg" closed="true" class="easyui-dialog" title="月结设置" style="width:400px;height:200px;padding:10px"
     data-options="
				iconCls: 'icon-save',

				buttons: [{
					text:'确定',
					iconCls:'icon-ok',
					handler:function(){
						closeBill();
					}
				},{
					text:'取消',
					handler:function(){
						document.getElementById('wjRemark').value='';
						$('#dlg').dialog('close');
					}
				}]
			">

</div>

<script type="text/javascript">
    initGrid();

    //queryorder();
    function initGrid() {


        var cols = new Array();
        var col = {
            field: 'id',
            title: 'id',
            width: 50,
            align: 'center',
            hidden: 'true'

        };
        cols.push(col);
        var col = {
            field: 'yymm',
            title: '年月',
            width: 135,
            align: 'center'

        };
        cols.push(col);
        var col = {
            field: 'startDate',
            title: '开始日期',
            width: 135,
            align: 'center'

        };
        cols.push(col);

        var col = {
            field: 'endDate',
            title: '截止日期',
            width: 100,
            align: 'center',
            formatter:formatDateField

        };
        cols.push(col);






        $('#datagrid').datagrid({
                url: "manager/stkmonth/queryMonthSet",
                queryParams: {
                    year: $("#year").val()


                },
                columns: [
                    cols
                ]
            }
        );
        //$('#datagrid').datagrid('reload');
    }

    function formatDateField(val,row,index) {
        if (val == undefined || val== "undefined") {
            val = "";
        }
        if(row.isReadOnly == 1)
        return "<input class="+this.field+"_imput"+" type='text' style='display:none' size='7' onClick='WdatePicker();' onchange='changeDate(this,\""+this.field+"\",\"" + row.id + "\")' name="+this.field+"_input"+" value='" + val + "'/><span class="+this.field+"_span"+" id="+this.field+"_span_"+row.id+">" + val + "</span>";
        return "<input class="+this.field+"_imput"+" type='text' size='7' onClick='WdatePicker();' onchange='changeDate(this,\""+this.field+"\",\"" + row.yymm + "\")' name="+this.field+"_input"+" value='" + val + "'/><span class="+this.field+"_span"+" id="+this.field+"_span_"+row.id+" style='display:none'>" + val + "</span>";
    }

    //查询物流公司
    function queryData() {
        $("#datagrid").datagrid('load', {
            url: "manager/stkmonth/queryMonthSet",
            year: $("#year").val()

        });

    }

    //回车查询
    function toQuery(e) {
        var key = window.event ? e.keyCode : e.which;
        if (key == 13) {
            queryData();
        }
    }




    function changeDate(o,field,yymm){
        $.ajax({
            url: "manager/stkmonth/updateMonthSet",
            type: "post",
            data: "endDate=" + o.value + "&yymm=" + yymm,
            success: function (data) {
                if (data.state) {
                    //$("#"+field+"_span_"+wareId).text(o.value);
                    $("#datagrid").datagrid("reload");
                } else {
                    alert("操作失败");
                    return;
                }
            }
        });
    }

    function addMonth(){
        $.ajax({
            url: "manager/stkmonth/addInitMonthSet",
            type: "post",
            data: "addyear=" + $("#year").val(),
            success: function (data) {
                if (data.state) {
                    //$("#"+field+"_span_"+wareId).text(o.value);
                    $("#datagrid").datagrid("reload");
                } else {
                    alert("操作失败");
                    return;
                }
            }
        });
    }
    function deleteMonth()
    {
        $.ajax({
            url: "manager/stkmonth/deleteMonthSet",
            type: "post",
            data: "",
            success: function (data) {
                if (data.state) {
                    //$("#"+field+"_span_"+wareId).text(o.value);
                    $("#datagrid").datagrid("reload");
                } else {
                    alert("操作失败");
                    return;
                }
            }
        });
    }

    function formatterSt3(val, row) {


        if (row.id == 0) return "";
        var ret = "<input style='width:60px;height:27px' type='button' value='删除' onclick='deleteMonth(\"" + row.yymm + "\")'/>";

        return ret;

    }


</script>
</body>
</html>
