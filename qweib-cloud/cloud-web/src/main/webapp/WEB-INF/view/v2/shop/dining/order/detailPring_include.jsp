<%@ page language="java" pageEncoding="UTF-8" %>
<script language="javascript" type="text/javascript">
    var LODOP; //声明为全局变量

    function printDetail(id, param) {
        $.get('${base}manager/shopDiningOrderDetail/diningOrderDetailList?doId=' + id, function (data) {
            if (data.state) {
                MyPreview(data.obj, param);
            } else {
                uglcw.ui.error(data.message);
            }

        });
    }

    function printOrder(orderId, param) {
        $.get('${base}manager/shopDiningOrderDetail/diningOrderDetailList?orderId=' + orderId, function (data) {
            if (data.state)
                MyPreview(data.obj, param);
        });
    }

    var c1w = 0;
    var c2w = 100;
    var c3w = 70;
    var c4w = 40;
    var c5w = 70;
    var pageWidth = 750;
    var dataLineHigth = 50;
    var intHeight = 20;

    function MyPreview(detailList, param) {
        AddTitle(param);
        var iCurLine = 102;//标题行之后的数据从位置80px开始打印
        var wareZj = 0;
        for (i = 0; i < detailList.length; i++) {
            let obj = detailList[i];
            wareZj += obj.wareZj;
            //LODOP.ADD_PRINT_TEXT(iCurLine, 20, c1w, 20, (i + 1));
            LODOP.ADD_PRINT_TEXT(iCurLine, c1w + intHeight, 500, intHeight, obj.detailWareNm);
            LODOP.ADD_PRINT_TEXT(iCurLine + 15, c1w + intHeight, 100, intHeight, obj.detailWareGg);
            LODOP.ADD_PRINT_TEXT(iCurLine + 15, c2w + c1w + intHeight, c3w, intHeight, obj.wareDj.toFixed(2));
            LODOP.ADD_PRINT_TEXT(iCurLine + 15, c3w + c2w + c1w + intHeight, c4w, intHeight, obj.wareNum);
            LODOP.ADD_PRINT_TEXT(iCurLine + 15, c4w + c3w + c2w + c1w + intHeight, c5w, intHeight, obj.wareZj.toFixed(2));
            /*LODOP.SET_PRINT_STYLEA(1, "FontSize", 10);
            LODOP.SET_PRINT_STYLEA(2, "FontSize", 10);
            LODOP.SET_PRINT_STYLEA(3, "FontSize", 10);
            LODOP.SET_PRINT_STYLEA(4, "FontSize", 10);*/

            iCurLine = iCurLine + 35;//每行占25px
        }
        var doDiscountAmount = param.doDiscountAmount;
        LODOP.ADD_PRINT_LINE(iCurLine, 14, iCurLine, pageWidth - 100, 0, 1);
        iCurLine = iCurLine + 5;
        LODOP.ADD_PRINT_TEXT(iCurLine, intHeight, 150, intHeight, "总金额:" + wareZj.toFixed(2));
        iCurLine = iCurLine + 15;
        LODOP.ADD_PRINT_TEXT(iCurLine, intHeight, 300, intHeight, "优惠金额:" + doDiscountAmount);
        iCurLine = iCurLine + 15;
        LODOP.ADD_PRINT_TEXT(iCurLine, intHeight, 300, intHeight, "合计:" + (wareZj - doDiscountAmount).toFixed(2));
        iCurLine = iCurLine + 15;
        LODOP.ADD_PRINT_LINE(iCurLine, 14, iCurLine, pageWidth - 100, 0, 1);
        iCurLine = iCurLine + 5;
        LODOP.ADD_PRINT_TEXT(iCurLine, intHeight, 300, intHeight, "打印时间:" + new Date().format("yyyy-MM-dd hh:mm:ss"));


        LODOP.SET_PRINT_PAGESIZE(3, pageWidth, 100, "纸张名称");//这里3表示纵向打印且纸高“按内容的高度”；1385表示纸宽138.5mm；45表示页底空白4.5mm
        LODOP.PREVIEW();//打印预览
        //LODOP.PRINT_DESIGN();//打印设计
        //LODOP.PRINT();//直接打印
        //LODOP.PRINT_SETUP();//打印维护
    };

    function AddTitle(param) {
        LODOP = getLodop();
        LODOP.PRINT_INIT("打印控件功能演示_Lodop功能_不同高度幅面");
        LODOP.ADD_PRINT_TEXT(0, 70, 355, 30, "${shopName}");
        LODOP.SET_PRINT_STYLEA(1, "FontSize", 13);
        LODOP.SET_PRINT_STYLEA(1, "Bold", 1);
        LODOP.ADD_PRINT_TEXT(30, intHeight, 500, intHeight, "单号:" + param.orderNo);
        LODOP.ADD_PRINT_TEXT(50, intHeight, 200, intHeight, "桌号:" + param.diningName + "  人数:" + param.peopleNumber);
        LODOP.ADD_PRINT_TEXT(75, c1w + intHeight, c2w, intHeight, "菜品");
        LODOP.ADD_PRINT_TEXT(75, c2w + c1w + intHeight, c3w, intHeight, "单价");
        LODOP.ADD_PRINT_TEXT(75, c3w + c2w + c1w + intHeight, c4w, intHeight, "数量");
        LODOP.ADD_PRINT_TEXT(75, c4w + c3w + c2w + c1w + intHeight, c5w, intHeight, "小计");
        LODOP.ADD_PRINT_LINE(70, 14, 70, pageWidth - 100, 0, 1);
        LODOP.ADD_PRINT_LINE(95, 14, 95, pageWidth - 100, 0, 1);
    };

    function getSelectedPrintIndex() {
        return document.getElementById("PrinterList").value;
    };

    function sendKitchenPreview(params) {
        LODOP = getLodop();
        LODOP.PRINT_INIT("打印控件功能演示_Lodop功能_不同高度幅面");
        //LODOP.SET_PRINT_MODE("POS_BASEON_PAPER",true);//该语句可使输出以纸张边缘为基点
        LODOP.SET_PRINTER_INDEX(getSelectedPrintIndex());
        LODOP.SET_PRINT_PAGESIZE(3, pageWidth, 100, "纸张名称");//这里3表示纵向打印且纸高“按内容的高度”；1385表示纸宽138.5mm；45表示页底空白4.5mm
        var row = 0;
        LODOP.SET_PRINT_STYLE("FontSize", 13);
        params.forEach(function (param) {
            LODOP.ADD_PRINT_TEXT(0, 70, 355, 30, param.diningName);
            //LODOP.SET_PRINT_STYLEA(1, "FontSize", 13);
            //LODOP.SET_PRINT_STYLEA(1, "Bold", 1);

            row = row + 1;
            LODOP.ADD_PRINT_TEXT(30, intHeight, 500, intHeight, "菜品:" + param.detailWareNm);
            //LODOP.SET_PRINT_STYLEA(2, "FontSize", 13);
            //LODOP.SET_PRINT_STYLEA(3, "Bold", 1);

            LODOP.ADD_PRINT_TEXT(55, intHeight, 200, intHeight, "规格:" + param.detailWareGg + "  数量:" + param.wareNum);
            LODOP.ADD_PRINT_TEXT(75, intHeight, 300, intHeight, "打印时间:" + new Date().format("yyyy-MM-dd hh:mm:ss"));
            LODOP.NewPage();
            row = row + 2;
        })
        LODOP.PREVIEW();//打印预览
        //LODOP.PRINT_DESIGN();//打印设计
        //LODOP.PRINT();//直接打印
        //LODOP.PRINT_SETUP();//打印维护
    };


    Date.prototype.format = function (fmt) {
        var o = {
            "M+": this.getMonth() + 1,                 //月份
            "d+": this.getDate(),                    //日
            "h+": this.getHours(),                   //小时
            "m+": this.getMinutes(),                 //分
            "s+": this.getSeconds(),                 //秒
            "q+": Math.floor((this.getMonth() + 3) / 3), //季度
            "S": this.getMilliseconds()             //毫秒
        };
        if (/(y+)/.test(fmt)) {
            fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
        }
        for (var k in o) {
            if (new RegExp("(" + k + ")").test(fmt)) {
                fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
            }
        }
        return fmt;
    }
</script>