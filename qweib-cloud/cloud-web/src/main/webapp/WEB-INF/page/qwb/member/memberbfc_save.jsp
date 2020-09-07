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

<body>
<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
       title="业务员拜访明细列表" iconCls="icon-save" border="false"
       rownumbers="true" fitColumns="false" pagination="false"
       toolbar="#tb">

</table>
<div id="tb" style="padding:5px;height:auto">
    <input type="hidden" id="branchId" value="${branchId}"/>
    <input type="hidden" id="memberNm" value="${memberNm}"/>
    <input type="hidden" id="khNm" value="${khNm}"/>
    <input type="hidden" id="qdtpNm" value="${qdtpNm}"/>
    <input type="hidden" id="khdjNm" value="${khdjNm}"/>
    <input type="hidden" id="stime" value="${stime}"/>
    <input type="hidden" id="etime" value="${etime}"/>
    <input type="hidden" id="picIndex1" value="${picIndex1}"/>
    <input type="hidden" id="picIndex2" value="${picIndex2}"/>
    <input type="hidden" id="picIndex3" value="${picIndex3}"/>
    <input type="hidden" id="picIndex4" value="${picIndex4}"/>
    <input type="hidden" id="isShow" value="${isShow}"/>

    标题: <input name="rptTitle" id="rptTitle" style="width:180px;height: 20px;" value="${title}"/>
    备注: <input name="remarks" id="remark" style="width:320px;height: 20px;"/>

    <a class="easyui-linkbutton" iconCls="icon-save" href="javascript:saveRpt();">保存</a>

</div>
<div id="bigPicDiv" class="easyui-window" title="图片" style="width:315px;top: 110px;overflow: hidden;"
     minimizable="false" maximizable="false" modal="true" collapsible="false"
     closed="true">
    <img style="width: 300px;" id="photoImg" alt=""/>
</div>
<script type="text/javascript">
    var cols = new Array();

    function initGrid() {
        var col = {
            field: 'id',
            title: '拜访id',
            width: 100,
            align: 'center',
            hidden: true


        };
        var col = {
            field: 'mid',
            title: '业务id',
            width: 100,
            align: 'center',
            hidden: true


        };
        cols.push(col);
        var col = {
            field: 'cid',
            title: '客户id',
            width: 100,
            align: 'center',
            hidden: true


        };
        var col = {
            field: 'deleterow',
            title: '操作',
            width: 100,
            align: 'center',
            formatter: formatterSt3
        };
        cols.push(col);
        var col = {
            field: 'qddate',
            title: '拜访日期',
            width: 80,
            align: 'center'
        };
        cols.push(col);
        var col = {
            field: 'memberNm',
            title: '业务员',
            width: 100,
            align: 'center'
        };
        cols.push(col);
        var col = {
            field: 'memberMobile',
            title: '手机号',
            width: 100,
            align: 'center'
        };
        cols.push(col);

        var col = {
            field: 'branchName',
            title: '部门',
            width: 80,
            align: 'center'
        };
        cols.push(col);

        var col = {
            field: 'khNm',
            title: '客户',
            width: 120,
            align: 'center'
        };
        cols.push(col);
        var col = {
            field: 'qdtpNm',
            title: '客户类型',
            width: 80,
            align: 'center'
        };
        cols.push(col);

        var col = {
            field: 'khdjNm',
            title: '客户等级',
            width: 80,
            align: 'center'
        };
        cols.push(col);

        var col = {
            field: 'remo',
            title: '客户备注',
            width: 120,
            align: 'center'
        };
        cols.push(col);
        var col = {
            field: 'qdtime',
            title: '签到时间',
            width: 150,
            align: 'center'
        };
        cols.push(col);

        var col = {
            field: 'ldtime',
            title: '离店时间',
            width: 150,
            align: 'center'
        };
        cols.push(col);

        var col = {
            field: 'bfsc',
            title: '拜访时长',
            width: 120,
            align: 'center'
        };
        cols.push(col);

        var col = {
            field: 'imageListStr',
            title: '拜访拍照',
            width: 120,
            align: 'center',
            formatter: formatterSt
        };
        cols.push(col);

        var col = {
            field: 'oper1',
            title: '销售小结明细',
            width: 100,
            align: 'center',
            formatter: formatterSt2
        };
        cols.push(col);

        var col = {
            field: 'bcbfzj',
            title: '拜访总结',
            width: 100,
            align: 'center'
        };
        cols.push(col);

        var col = {
            field: 'dbsx',
            title: '代办事项',
            width: 100,
            align: 'center'
        };
        cols.push(col);

        var col = {
            field: 'qdaddress',
            title: '签到地址',
            width: 275,
            align: 'center'
        };
        cols.push(col);

        var col = {
            field: 'khaddress',
            title: '客户地址',
            width: 275,
            align: 'center'
        };
        cols.push(col);

        var col = {
            field: 'linkman',
            title: '负责人',
            width: 120,
            align: 'center'
        };
        cols.push(col);

        var col = {
            field: 'tel',
            title: '负责人电话',
            width: 120,
            align: 'center'
        };
        cols.push(col);

        var col = {
            field: 'mobile',
            title: '负责人手机',
            width: 120,
            align: 'center'
        };
        cols.push(col);


        $('#datagrid').datagrid({
                columns: [
                    cols
                ]
            }
        );
        querymemberbfc();
    }

    //查询
    function querymemberbfc() {
        var picIndex1 = $("#picIndex1").val();
        var picIndex2 = $("#picIndex2").val();
        var picIndex3 = $("#picIndex3").val();
        var picIndex4 = $("#picIndex4").val();
        var isShow = $("#isShow").val();
        $('#datagrid').datagrid({
                url: "manager/memberbfcPage",
                queryParams: {
                    jz: "1",
                    khNm: $("#khNm").val(),
                    memberNm: $("#memberNm").val(),
                    stime: $("#stime").val(),
                    etime: $("#etime").val(),
                    picIndex1: picIndex1,
                    picIndex2: picIndex2,
                    picIndex3: picIndex3,
                    picIndex4: picIndex4,
                    isShow: isShow,
                    etime: $("#etime").val(),
                    qdtpNm: $("#qdtpNm").val(),
                    khdjNm: $("#khdjNm").val(),
                    branchId: $("#branchId").val()
                }
            }
        );

    }

    //回车查询
    function toQuery(e) {
        var key = window.event ? e.keyCode : e.which;
        if (key == 13) {
            querymemberbfc();
        }
    }

    function formatterSt(v, row) {
        var hl = '<table>';
        hl += '<tr>';
        for (var i = 0; i < row.listpic.length; i++) {
            if ((i + 1) % 4 == 0) {
                hl += '<td>&nbsp;&nbsp;&nbsp;<a href="javascript:toBigPic(\'' + row.listpic[i].pic + '\');"><img style="width: 85px;" src="${base}upload/' + row.listpic[i].picMin + '"/></a></br>&nbsp;&nbsp;&nbsp;' + row.listpic[i].nm + '</td>';
                hl += '</tr>';
                hl += '<tr>';
            } else {
                hl += '<td>&nbsp;&nbsp;&nbsp;<a href="javascript:toBigPic(\'' + row.listpic[i].pic + '\');"><img style="width: 85px;" src="${base}upload/' + row.listpic[i].picMin + '"/></a></br>&nbsp;&nbsp;&nbsp;' + row.listpic[i].nm + '</td>';
            }
        }
        hl += '</tr>';
        hl += '</table>';
        return hl;
    }

    function formatterSt3(val, row, index) {

        index = index - 1;
        return "<input style='width:60px;height:27px' type='button' value='删除' onclick='deleteRow(this, " + row.id + ")'/>";

    }

    function deleteRow(_this, id) {
        var rows = $("#datagrid").datagrid("getRows");
        for (var i = 0; i < rows.length; i++) {
            if (rows[i].id == id) {
                $("#datagrid").datagrid('deleteRow', i);
                break;
            }
        }

    }

    function todetail(title, mid, cid, qddate) {
        window.parent.add(title, "manager/memberbfcPicXq?mid=" + mid + "&cid=" + cid + "&qddate=" + qddate);
    }

    function formatterSt2(v, row) {
        return '<a class="easyui-linkbutton" iconCls="icon-search" plain="true" href="javascript:todetail2(\'' + row.qddate + '/' + row.memberNm + '/' + row.khNm + '\',' + row.mid + ',' + row.cid + ',\'' + row.qddate + '\');">查看</a>';
    }

    function todetail2(title, mid, cid, xjdate) {
        window.parent.add(title, "manager/toqueryBfxsxj?mid=" + mid + "&cid=" + cid + "&xjdate=" + xjdate);
    }

    function toBigPic(picurl) {
        document.getElementById("photoImg").setAttribute("src", "${base}upload/" + picurl);
        $("#bigPicDiv").window("open");
    }

    $('#bigPicDiv').window({
        onBeforeClose: function () {
            document.getElementById("photoImg").setAttribute("src", "");
        }
    });

    //获取客户类别
    function arealist1() {
        $.ajax({
            url: "manager/queryarealist1",
            type: "post",
            success: function (data) {
                if (data) {
                    var list = data.list1;
                    var img = "";
                    img += '<option value="">--请选择--</option>';
                    for (var i = 0; i < list.length; i++) {
                        if (list[i].qdtpNm != '') {
                            if (list[i].qdtpNm == qdtpNm) {
                                img += '<option value="' + list[i].qdtpNm + '" selected="selected">' + list[i].qdtpNm + '</option>';
                            } else {
                                img += '<option value="' + list[i].qdtpNm + '">' + list[i].qdtpNm + '</option>';
                            }
                        }
                    }
                    $("#qdtpNm").html(img);
                }
            }
        });
    }

    function saveRpt() {
        //alert(JSON.stringify(cols));
        var rows = $("#datagrid").datagrid("getRows");
        var sdate = $("#stime").val();
        var edate = $("#etime").val();

        var memberNm = $("#memberNm").val();
        var dateTypeStr = "日期";
        var paramStr = dateTypeStr + ":" + sdate + "-" + edate + " 业务员:" + memberNm;
        var merCols = '';
        var dataStr = '{"paramStr":"' + paramStr + '","merCols":"' + merCols + '",'
            + '"rows":' + JSON.stringify(rows)
            + ',"cols":' + JSON.stringify(cols) + "}";

        var path = "manager/saveAutoCstDetailStat";
        $.ajax({
            url: path,
            type: "POST",
            data: {"rptTitle": $("#rptTitle").val(), "remark": $("#remark").val(), "rptType": 11, "saveHtml": dataStr},
            dataType: 'json',
            async: false,
            success: function (data) {
                data = eval(data);
                if (parseInt(data) > 0) {
                    alert("保存成功！");
                    parent.closeWin('生成的统计表');
                    parent.add('生成的统计表', 'manager/toMemberbfcQuery?rptType=11');
                } else {
                    alert("保存失败！");
                }
            }
        });
    }

    arealist1();
    initGrid();
</script>
</body>
</html>
