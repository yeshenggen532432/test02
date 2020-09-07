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

    状态: <select name="status" id="status">
    <option value="1">正常</option>
    <option value="-1">作废</option>
    <option value="0">全部</option>
</select>
    <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryData();">查询</a>




</div>

<div id="dlg" closed="true" class="easyui-dialog" title="完结" style="width:400px;height:200px;padding:10px"
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
            field: 'procDateStr',
            title: '月结时间',
            width: 120,
            align: 'center'

        };
        cols.push(col);
        var col = {
            field: 'startDate',
            title: '开始日期',
            width: 100,
            align: 'center'

        };
        cols.push(col);
        var col = {
            field: 'endDate',
            title: '结束日期',
            width: 100,
            align: 'center'

        };
        cols.push(col);

        var col = {
            field: 'status',
            title: '状态',
            width: 80,
            align: 'center',
            formatter: formatterStatus

        };
        cols.push(col);

        var col = {
            field: '_operator',
            title: '操作',
            width: 160,
            align: 'center',
            formatter: formatterSt3


        };
        cols.push(col);

        $('#datagrid').datagrid({
                url: "manager/stkmonth/queryMonthPage",
                queryParams: {
                    year: $("#year").val(),
                    status: $("#status").val()


                },
                columns: [
                    cols
                ]
            }
        );
        //$('#datagrid').datagrid('reload');
    }

    //查询物流公司
    function queryData() {
        $("#datagrid").datagrid('load', {
            url: "manager/stkmonth/queryMonthPage",
            year: $("#year").val(),
            status: $("#status").val()

        });

    }

    //回车查询
    function toQuery(e) {
        var key = window.event ? e.keyCode : e.which;
        if (key == 13) {
            queryData();
        }
    }



    function formatterStatus(val, row) {
        if (val == -1) return "作废";
        if (val == 1) return "正常";

    }



    function todetail(yymm) {
        window.parent.add("月结明细" + yymm, "manager/stkmonth/toMonthDetail?yymm=" + yymm);
    }

    function cancelBill(id) {

        var path = "manager/stkmonth/cancelMonthProc";
        $.ajax({
            url: path,
            type: "POST",
            data : {"id":id},
            dataType: 'json',
            async : false,
            success: function (json) {
                if(json.state){

                    alert('作废成功');
                    $("#datagrid").datagrid("reload");

                }
                else
                {
                    alert(json.msg);

                }
            }
        });

    }

    function formatterSt3(val, row) {


        if (row.id == 0) return "";
        var ret = "<input style='width:60px;height:27px' type='button' value='查看明细' onclick='todetail(\"" + row.yymm + "\")'/>";
        ret = ret + "<input style='width:60px;height:27px' type='button' value='作废' onclick='cancelBill(" + row.id + ")'/>";

        return ret;

    }

</script>
</body>
</html>
