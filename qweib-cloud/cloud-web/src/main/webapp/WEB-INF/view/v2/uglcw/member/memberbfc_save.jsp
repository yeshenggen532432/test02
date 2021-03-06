<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>驰用T3</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }

        .pic-container {
            display: inline-flex;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal">
                <li style="width: 280px">
                    <input type="hidden" uglcw-model="jz" value="1" uglcw-role="textbox">
                    <input type="hidden" id="branchId" uglcw-role="textbox" uglcw-model="branchId"
                           value="${branchId}">
                    <input type="hidden" id="memberNm" uglcw-role="textbox" uglcw-model="memberNm"
                           value="${memberNm}">
                    <input type="hidden" id="khNm" uglcw-role="textbox" uglcw-model="khNm" value="${khNm}">
                    <input type="hidden" id="qdtpNm" uglcw-role="textbox" uglcw-model="qdtpNm"
                           value="${qdtpNm}">
                    <input type="hidden" id="khdjNm" uglcw-role="textbox" uglcw-model="khdjNm"
                           value="${khdjNm}">
                    <input type="hidden" id="stime" uglcw-role="textbox" uglcw-model="stime" value="${stime}">
                    <input type="hidden" id="etime" uglcw-role="textbox" uglcw-model="etime" value="${etime}">
                    <input type="hidden" id="picIndex1" uglcw-role="textbox" uglcw-model="picIndex1"
                           value="${picIndex1}">
                    <input type="hidden" id="picIndex2" uglcw-role="textbox" uglcw-model="picIndex2"
                           value="${picIndex2}">
                    <input type="hidden" id="picIndex3" uglcw-role="textbox" uglcw-model="picIndex3"
                           value="${picIndex3}">
                    <input type="hidden" id="picIndex4" uglcw-role="textbox" uglcw-model="picIndex4"
                           value="${picIndex4}">
                    <input type="hidden" id="isShow" value="${isShow}" uglcw-role="textbox"
                           uglcw-model="isShow">


                    <input uglcw-model="rptTitle" uglcw-role="textbox" placeholder="标题" value="${title}">
                </li>
                <li>
                    <input uglcw-model="remarks" uglcw-role="textbox" placeholder="备注">
                </li>
                <li>
                    <button uglcw-role="button" class="k-info" onclick="saveRpt()">保存</button>
                </li>
            </ul>
        </div>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options="{
                     responsive:['.header',40],
                    id:'id',
                    url:'${base}/manager/memberbfcPage',
                    criteria: '.form-horizontal',

                    }">

                <div data-field="deleterow" uglcw-options="width:100, command:'destroy'
                            ">操作
                </div>
                <div data-field="qddate" uglcw-options="{width:100}">拜访日期</div>
                <div data-field="memberNm" uglcw-options="{width:100}">业务员</div>
                <div data-field="memberMobile" uglcw-options="{width:120}">手机号</div>
                <div data-field="branchName" uglcw-options="{width:100}">部门</div>
                <div data-field="khNm" uglcw-options="{width:180}">客户</div>
                <div data-field="qdtpNm" uglcw-options="{width:100,
                         template: '#= data.qdtpNm === \'null\' ? \'\' : data.qdtpNm#'}">客户类型
                </div>
                <div data-field="khdjNm" uglcw-options="{width:100,
                         template: '#= data.khdjNm === \'null\' ? \'\' : data.khdjNm#'}">客户等级
                </div>
                <div data-field="remo" uglcw-options="{width:100,
                         template: '#= data.remo === \'null\' ? \'\' : data.remo#'}">客户备注
                </div>
                <div data-field="qdtime" uglcw-options="{width:160}">签到时间</div>
                <div data-field="ldtime" uglcw-options="{width:160}">离店时间</div>
                <div data-field="bfsc" uglcw-options="{width:120}">拜访时长</div>
                <div data-field="imageListStr" uglcw-options="{width:360
                       ,template: uglcw.util.template($('#formatterSt').html())}">拜访拍照
                </div>
                <div data-field="oper1" uglcw-options="{width:100,
                        template: uglcw.util.template($('#formatterSt2').html())}">销售小结明细
                </div>
                <div data-field="bcbfzj" uglcw-options="{width:100}">拜访总结</div>
                <div data-field="dbsx" uglcw-options="{width:100}">代办事项</div>
                <div data-field="qdaddress" uglcw-options="{width:275}">签到地址</div>
                <div data-field="khaddress" uglcw-options="{width:275}">客户地址</div>
                <div data-field="linkman" uglcw-options="{width:100}">负责人</div>
                <div data-field="tel" uglcw-options="{width:120,
                         template: '#= data.tel === \'null\' ? \'\' : data.tel#'}">负责人电话
                </div>
                <div data-field="mobile" uglcw-options="{width:120}">负责人手机</div>
            </div>
        </div>
    </div>
</div>
</div>
<script id="formatterSt2" type="text/x-kendo-template">
    <a style="color:blue;"
       href="javascript:todetail2('#= data.qddate##= data.memberNm##= data.khNm#','#= data.mid#','#= data.cid#','#= data.qddate#')">查看</a>
</script>
<script id="formatterSt" type="text/x-kendo-template">
    <div class="pic-container">
        #for (var i=0; i
        <data.listpic.length
                ;i++){#
                # var pic=data.listpic[i];#
        <div class="pic-item">
            <a href="javascript:void(0);" onclick="preview(this, #= i#)">
                <img src="/upload/#= pic.picMin#" style="height: 20px;">
            </a>
            <br>
            <span class="pic-desc">#= pic.nm#</span>
        </div>
        #}#
    </div>

</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();
        uglcw.ui.loaded();
        uglcw.ui.loaded()
    })


    function todetail2(title, mid, cid, xjdate) {//查看
        uglcw.ui.openTab(title, '${base}manager/toqueryBfxsxj?mid=' + mid + '&cid=' + cid + '&xjdate=' + xjdate);
    }

    function preview(a, index) {
        var row = uglcw.ui.get('#grid').k().dataItem($(a).closest('tr'));
        layer.photos({
            photos: {
                start: index, data: $.map(row.listpic, function (item) {
                    return {
                        src: '/upload/' + item.pic,
                        pid: uglcw.util.uuid(),
                        alt: item.nm,
                        thumb: '/upload/' + item.picMin
                    }
                })
            }, anim: 5
        });
    }

    function saveRpt() {//保存

        var rows = uglcw.ui.get('#grid').value();
        var cols = $.map(uglcw.ui.get('#grid').k().options.columns, function (col) {
            return {field: col.field, title: col.title.trim()}
        })
        var data = uglcw.ui.bind('.form-horizontal');
        var dateTypeStr = "日期";
        var paramStr = dateTypeStr + ":" + data.sdate + "-" + data.edate + " 业务员:" + data.memberNm;
        var merCols = '';
        var saveHtml = {
            paramStr: paramStr,
            merCols: merCols,
            rows: rows,
            cols: cols
        }
        data.rptType = 11;
        data.saveHtml = JSON.stringify(saveHtml);
        $.ajax({
            url: '${base}manager/saveAutoCstDetailStat',
            data: data,
            type: 'post',
            dataType: 'json',
            success: function (data) {
                data = eval(data);
                if (parseInt(data) > 0) {
                    uglcw.ui.success('保存成功！');
                    uglcw.ui.openTab('生成的统计表', '${base}manager/toMemberbfcQuery?rptType=11');
                } else {
                    uglcw.ui.error('保存失败！');
                }
            }
        })
    }

</script>
</body>
</html>
