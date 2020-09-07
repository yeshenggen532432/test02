<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>销售汇总统计表</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
    <style>
        table {
            width: 100%;
        }

        .content tr td:last-child {
            border-bottom: none !important;
        }

        .page-break {
            background: 0 0;
            border-bottom: 1px dashed gray;
            padding-bottom: 10px;
            margin-bottom: 10px;
        }
        @media print {
            .page-break {
                visibility: hidden;
                border-bottom: none;
            }

            body * {
                visibility: hidden;
            }

            .layui-card-header {
                display: none;
            }

            .preview {
                margin: 0;
            }

            #preview-wrapper, #preview-wrapper * {
                visibility: visible;
            }
        }

        .print-settings label {
            text-align: right;
        }

        .print-settings .w-e-text-container {
            height: 150px !important;
        }

        .print-settings .k-checkbox-label {
            padding-left: 20px;
            margin-right: 10px;
        }

        .print-settings .form-group {
            margin-bottom: 10px;
        }

        .print-settings .form-group .control-label:after {
            content: ':'
        }

        .layui-card-body {
            line-height: inherit !important;
        }

        .aggregate-footer td {
            border-bottom: 1px solid #000;
        }

        .aggregate-footer td:first-child {
            border-left: 1px solid #000;
        }

        .aggregate-footer td:last-child {
            border-bottom: 1px solid #000 !important;
            border-right: 1px solid #000;
        }

        label{
            margin-bottom: 0px!important;
        }
    </style>
    <script>
        function formatQty(hsNum,minSumQty,maxUnitName,minUnitName) {
            hsNum = parseFloat(hsNum) || 1;
            minSumQty = parseFloat(minSumQty)||0;
            var result = "";
            if(maxUnitName==""){
                maxUnitName="/";
            }
            if((hsNum+"").indexOf(".")!=-1){
                var sumQty = minSumQty/hsNum;
                var str = sumQty+"";
                if(str.indexOf(".")!=-1){
                    var nums = str.split(".");
                    var num1 = nums[0];
                    var num2 = nums[1];
                    if(parseFloat(num2)>0){
                        var minQty = parseFloat(0+"."+num2)*parseFloat(hsNum);
                        minQty = minQty.toFixed(2);
                        result = num1+""+maxUnitName+""+minQty+""+minUnitName;
                    }
                }else{
                    result = sumQty+maxUnitName;
                }
            }else{
                var remainder = (minSumQty) % (hsNum);
                if (remainder === 0) {
                    //整数件
                    result += '<span>' + minSumQty / hsNum + '</span>' +maxUnitName;
                } else if (remainder === minSumQty) {
                    //不足一件
                    var minQty =   Math.floor(minSumQty*100)/100;
                    result += '<span>' + minQty + '</span>' + minUnitName;
                } else {
                    //N件有余
                    var minQty = Math.floor(remainder*100)/100;
                    result += '<span>' + parseInt(minSumQty / hsNum) + '</span>' + maxUnitName + '<span>' + minQty + '</span>' + minUnitName;
                }
            }
            document.write(result);
            //return result;
        }
    </script>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card">
        <div class="layui-card-header" style="font-size: 12px;text-align: center">
            <button uglcw-role="button" onclick="printit()" uglcw-options="icon:'print'">打印
            </button>


            <button uglcw-role="button" onclick="showBills()" uglcw-options="icon:'print'">显示单据
            </button>

        </div>
        <div
                class="layui-card-body preview">
            <div style="width: 794px; margin: 0 auto;">
                <div style=" text-align: center; margin:10px auto;width:100%;" id="preview-wrapper">
                    <style>
                        blockquote, body, button, dd, div, dl, dt, form, h1, h2, h3, h4, h5, h6, input, li, ol, p, pre, td, textarea, th, ul {
                            margin: 0;
                            padding: 0;
                        }

                        .preview td {
                            height: 16px;
                            text-align: center;
                            font-family: "微软雅黑", "宋体";
                            font-size: 14px;
                            color: #000000;
                        }

                        .content tr td:last-child {
                            border-bottom: none !important;
                        }

                        .aggregate-footer td {
                            border-bottom: 1px solid #000;
                        }

                        .aggregate-footer td:first-child {
                            border-left: 1px solid #000;
                        }

                        .aggregate-footer td:last-child {
                            border-bottom: 1px solid #000 !important;
                            border-right: 1px solid #000;
                        }
                    </style>
                    <div id="showGroupWare">
                        <span style="font-size:22px;color:#000000;font-weight:bold;">销售汇总信息统计</span>
                        <table id="content1" style="border-collapse: collapse;">
                            <thead class="content">
                            <tr>
                                <td style="text-align:center;font-weight:bold;border:1px solid #000000;width:6px">
                                    no.
                                </td>
                                <td style="text-align:center;font-weight:bold;border:1px solid #000000;width:160px">
                                    商品名称
                                </td>

                                <td style="text-align:center;font-weight:bold;border:1px solid #000000;width:120px">数量
                                </td>
                                <td style="text-align:center;font-weight:bold;border:1px solid #000000;width:120px">单位
                                </td>
                                <td style="text-align:center;font-weight:bold;border:1px solid #000000;width:120px">大小数量
                                </td>
                                <td style="text-align:center;font-weight:bold;border:1px solid #000000;width:160px">平均单价
                                </td>
                                <td style="text-align:center;font-weight:bold;border:1px solid #000000;width:160px">金额
                                </td>
                            </tr>
                            </thead>
                            <tbody id="chooselist1" class="content1">
                            <c:set var="totalQty" value="0"/>
                            <c:set var="totalAmt" value="0"/>
                            <c:forEach items="${wareGroupDatas}" var="item" varStatus="s">
                                <tr>
                                    <td style="border:1px solid #000000; text-align: center">
                                            ${s.index +1}
                                    </td>
                                    <td style="border:1px solid #000000;">
                                            ${item['ware_nm'] }
                                    </td>
                                    <td style="border:1px solid #000000;">
                                            ${item['qty'] }
                                       <c:set var="totalQty" value="${item['qty']+totalQty}"/>
                                    </td>
                                    <td style="border:1px solid #000000;">
                                            ${item['unit_name'] }
                                    </td>
                                    <td style="border:1px solid #000000;">
                                        <script>
                                            formatQty('${item['hs_num'] }', '${item['min_qty'] }', '${item['unit_name'] }', '${item['min_unit'] }');
                                        </script>
                                    </td>
                                    <td style="border:1px solid #000000;">
                                        <script>
                                            var price = uglcw.util.divide('${item['amt'] }','${item['qty'] }');
                                            document.write(uglcw.util.toString(price,'n2'));
                                        </script>
                                    </td>
                                    <td style="border:1px solid #000000;">
                                            ${item['amt'] }
                                        <c:set var="totalAmt" value="${item['amt']+totalAmt}"/>
                                    </td>
                                </tr>
                            </c:forEach>
                            <tr>
                                <td style="border:1px solid #000000; text-align: center">
                                </td>
                                <td style="border:1px solid #000000;">
                                    合计
                                </td>
                                <td style="border:1px solid #000000;">
                                </td>
                                <td style="border:1px solid #000000;">
                                    <script>
                                        document.write(uglcw.util.toString(${totalQty},'n2'));
                                    </script>
                                </td>
                                <td style="border:1px solid #000000;">
                                </td>
                                <td style="border:1px solid #000000;">
                                </td>
                                <td style="border:1px solid #000000;">
                                    <script>
                                        document.write(uglcw.util.toString(${totalAmt},'n2'));
                                    </script>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div style="width: 794px;margin: 0 auto;">
                <div id="preview" style="width: 100%; text-align: center; margin: 0 auto;"></div>
            </div>
        </div>
    </div>

</div>

<script type="text/javascript">
    var editorMenus = [
        'head', 'bold', 'fontSize', 'fontName', 'italic', 'underline', 'strikeThrough', 'foreColor', 'backColor',
        'image'
    ];
    AutoPage = {
        header: null,//页面顶部显示的信息
        content: null,//页面正文TableID
        footer: null,//页面底部
        totalHeight: null,//总的高度
        tableCss: null,//正文table样式
        divID: null,//全文divID
        repeatTitle: true,
        repeatFooter: true,

        init: function (header, content, footer, totalHeight, divID, type, repeatTitle, repeatFooter) {
            AutoPage.header = header;
            AutoPage.content = content;
            AutoPage.footer = footer;
            AutoPage.totalHeight = totalHeight;
            AutoPage.divID = divID;
            AutoPage.repeatTitle = repeatTitle;
            AutoPage.repeatFooter = repeatFooter;
            //初始化分页信息
            if (type == 1)
                AutoPage.initPageSingle();
            else if (type == 2)
                AutoPage.initPageDouble();
            //隐藏原来的数据
            AutoPage.hidenContent();
            //开始分页
            //AutoPage.beginPage();

        },
        //分页 重新设定HTML内容(单行)
        initPageSingle: function () {
            var tmpRows = $("#" + AutoPage.content)[0].rows; //表格正文
            var height_tmp = 0; //一页总高度
            var html_tmp = "";  //临时存储正文
            var html_header = AutoPage.addPageBreak() + "<table style='border-collapse: collapse;'>";
            var html_foot = "</table>";
            var page = 0; //页码

            var tr0Height = tmpRows[0].clientHeight; //table标题高度
            var tr0Html = '<tr>' + tmpRows[0].innerHTML + '</tr>';//table标题内容
            height_tmp = tr0Height;
            if (AutoPage.totalHeight == 0) {
                AutoPage.totalHeight = 470;
            }
            for (var i = 1; i < tmpRows.length; i++) {
                AutoPage.removeScript(tmpRows[i]);
                var tableHeight = AutoPage.totalHeight - (page <= 1 || AutoPage.repeatTitle ? AutoPage.header.height() : 0)
                    - (AutoPage.repeatFooter ? AutoPage.footer.height() : 0);

                var trHtmp = tmpRows[i].clientHeight;//第i行高度
                if (tableHeight < trHtmp) {
                    return uglcw.ui.error('页面高度过小');
                }
                var clazz = $(tmpRows[i]).attr('class');
                var trMtmp = '<tr style="height:' + trHtmp + 'px;" ' + (clazz ? 'class="' + clazz + '"' : '') + '>' + tmpRows[i].innerHTML + '</tr>';//第i行内容
                //height_tmp += trHtmp;
                if (height_tmp + trHtmp > tableHeight) {
                    //下一页
                    console.log('------------------', height_tmp);
                    html_tmp += (html_foot + (AutoPage.repeatFooter ? AutoPage.footer.html() : '') + '</div>');
                    i--;
                    height_tmp = tr0Height;

                } else {
                    height_tmp += trHtmp;
                    if (height_tmp == tr0Height + trHtmp) {
                        html_tmp += (page <= 0 || AutoPage.repeatTitle ? AutoPage.header.html() : '') + html_header + tr0Html;
                        page++;//页码
                    }
                    html_tmp += trMtmp;
                    if (i == tmpRows.length - 1) {
                        //最后一页
                        console.log('last page------')
                        if (height_tmp + AutoPage.footer.height() > tableHeight) {
                            html_tmp += html_foot + '</div>';
                            html_tmp += AutoPage.addPageBreak() + AutoPage.footer.html() + '</div>';
                        } else {
                            html_tmp += html_foot + AutoPage.footer.html() + '</div>';
                        }
                    }
                }

            }

            $("#" + AutoPage.divID).html(html_tmp);
            var tdpagecount = $("#" + AutoPage.divID).find(".pagination");//document.getElementsByName("tdPageCount");
            for (var i = 0; i < tdpagecount.length; i++) {
                $(tdpagecount[i]).text((i + 1) + "/" + page);
            }

        },


        removeScript: function (e) {
            var scripts = e.getElementsByTagName('script')
            var i = scripts.length;
            while (i--) {
                scripts[i].parentNode.removeChild(scripts[i]);
            }
        },

        //分页 重新设定HTML内容(双行)
        initPageDouble: function () {

            var tmpRows = $("#" + AutoPage.content)[0].rows; //表格正文
            var height_tmp = 0; //一页总高度
            var html_tmp = "";  //临时存储正文
            var html_header = "<table>";
            var html_foot = "</table>";
            var page = 0; //页码

            var tr0Height = tmpRows[0].clientHeight + tmpRows[1].clientHeight; //table标题高度
            var tr0Html = "<tr>" + tmpRows[0].innerHTML + "</tr>" + "<tr>" + tmpRows[1].innerHTML + "</tr>";//table标题内容
            height_tmp = tr0Height;
            for (var i = 1; i < tmpRows.length; i++) {
                var trHtmp = tmpRows[(i - 1) * 2].clientHeight + tmpRows[(i - 1) * 2 + 1].clientHeight;//第i行高度
                var trMtmp = "<tr>" + tmpRows[(i - 1) * 2].innerHTML + "</tr>" + "<tr>" + tmpRows[(i - 1) * 2 + 1].innerHTML + "</tr>";//第i行内容

                height_tmp += trHtmp;
                if (height_tmp < AutoPage.totalHeight) {
                    if (height_tmp == tr0Height + trHtmp) {
                        html_tmp += AutoPage.header + html_header + tr0Html;
                        page++;//页码
                    }
                    html_tmp += trMtmp;
                    if (i == tmpRows.length - 1) {
                        html_tmp += html_foot + AutoPage.footer;
                    }
                } else {
                    html_tmp += html_foot + AutoPage.footer + AutoPage.addPageBreak();
                    i--;
                    height_tmp = tr0Height;
                }
            }


            $("#" + AutoPage.divID).html(html_tmp);

            var tdpagecount = $(".pagination");//document.getElementsByName("tdPageCount");

            for (var i = 0; i < tdpagecount.length; i++) {
                $(tdpagecount[i]).text((i + 1) + "/" + page);
            }

        },

        //隐藏原来的数据
        hidenContent: function () {
            $('#printcontent').hide()
        },

        ////添加分页符
        addPageBreak: function () {
            return "<div class='page-break' style='page-break-after:always;'>";
        },

    };

    $(function () {
        uglcw.ui.init();
        uglcw.ui.loaded();

        var repeatTitle = Number('${printSettings.repeatTitle}' || 1),
            repeatFooter = Number('${printSettings.repeatFooter}' || 1);
    })

    function toggleColumnDisplay(btn, expected) {
        uglcw.ui.get('.column-setting').k().dataItem($(btn).closest('tr')).set('fdStatus', expected);
    }

    function adjustAggregate() {
        var $stop = $('.aggregate-footer td.aggregate:visible:first');
        var $emptyCells = $stop.prevAll('td:not(.aggregate-txt,.aggregate-rownum)');
        $('.aggregate-footer .aggregate-txt').attr('colspan', $emptyCells.length + 1);
        $emptyCells.remove();
    }


    function doPrint() {
        window.print();
    }

    function printit() {
        window.print();
        uglcw.ui.closeCurrentTab();
    }


    function changeTemplate(o) {
        var mergeId = $("#mergeId").val();
        window.location.href = '${base}manager/showstkoutbatchprint?dataTp=1&billIds=${billIds}&fromFlag=${param.fromFlag}&templateId=' + o.value + "&merge=" + mergeId;
    }
    
    function showBills() {
        document.location.href='${base}manager/showstkoutbatchprint?fromFlag=1&billIds=${billIds}';
    }

</script>
<script type="text/javascript">
    var LODOP;

    function createPage() {
        LODOP = getLodop();
        LODOP.PRINT_INIT("${billNo}");
        //top left width height
        //LODOP.SET_PRINT_PAGESIZE(1, 2300, 1400, "");
        //LODOP.SET_PRINT_STYLEA(0,"Horient",2);
        LODOP.SET_PRINT_MODE("FULL_WIDTH_FOR_OVERFLOW", true);
        LODOP.ADD_PRINT_HTM(0, 0, '100%', '100%', document.getElementById("preview-wrapper").innerHTML);
    };

    $(function () {
        uglcw.ui.init();
        //显示商品
    });

    function lodopPrint() {
        createPage();
        LODOP.PREVIEW();
    };


</script>
</body>
</html>



