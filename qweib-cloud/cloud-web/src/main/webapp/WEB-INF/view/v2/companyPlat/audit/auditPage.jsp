<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>审批列表</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md12">
            <div class="layui-card header">
                <div class="layui-card-body">
                    <ul class="uglcw-query form-horizontal" id="export">
                        <li>
                            <input type="hidden" uglcw-model="jz" value="1" uglcw-role="textbox">
                            <input uglcw-model="atime" uglcw-role="datepicker" value="${atime}">
                        </li>
                        <li>
                            <input uglcw-model="btime" uglcw-role="datepicker" value="${btime}">
                        </li>
                        <li>
                            <select uglcw-role="combobox" uglcw-model="auditTp" >
                                <c:forEach items="${modelList}" var="item">
                                    <option value="${item.id}"}>${item.shortName !=null? item.shortName: item.name}</option>
                                </c:forEach>
                                <%--<option value="">全部</option>--%>
                                <%--<option value="1">请假</option>--%>
                                <%--<option value="2">报销</option>--%>
                                <%--<option value="3">出差</option>--%>
                                <%--<option value="4">物品领用</option>--%>
                                <%--<option value="5">通用审批</option>--%>
                            </select>
                        </li>
                        <li>
                            <input uglcw-model="memberNm" uglcw-role="textbox" placeholder="申请人">
                        </li>
                        <li>
                            <input uglcw-model="tp" uglcw-role="textbox" placeholder="内容">
                        </li>
                        <li>
                            <input uglcw-model="dsc" uglcw-role="textbox" placeholder="详情">
                        </li>
                        <li>
                            <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                            <button id="reset" class="k-button" uglcw-role="button">重置</button>
                        </li>
                    </ul>
                </div>
            </div>
            <div class="layui-card">
                <div class="layui-card-body full">
                    <div id="grid" uglcw-role="grid"
                         uglcw-options="{
                            checkbox:'true',
                            responsive:['.header',40],
                            id:'id',
                            toolbar: kendo.template($('#toolbar').html()),
                            url: 'manager/auditPage?dataTp=${dataTp}',
                            criteria: '.form-horizontal',
                            pageable: true,
                            dblclick:function(row){
                                todetail(row.auditNo)
                            }
                    }">
                        <div data-field="auditNo" uglcw-options="width:150,tooltip: true">审批编号</div>
                        <%--<div data-field="auditTp"--%>
                        <%--uglcw-options="width:100, template: uglcw.util.template($('#formatterTp').html())">类型--%>
                        <%--</div>--%>
                        <div data-field="modelName"
                            uglcw-options="{width:150,template: uglcw.util.template($('#formatterModel').html())}">模板类型
                        </div>
                        <div data-field="title" uglcw-options="{width:150,tooltip:true}">标题</div>
                        <div data-field="branchName" uglcw-options="{width:100}">部门</div>
                        <div data-field="memberNm" uglcw-options="{width:100}">申请人</div>
                        <div data-field="addTime" uglcw-options="{width:160}">申请时间</div>
                        <div data-field="checkTime" uglcw-options="{width:160}">审批时间</div>
                        <div data-field="amount" uglcw-options="{width:100}">审批金额</div>
                        <div data-field="tp" uglcw-options="{width:120}">内容</div>
                        <div data-field="dsc" uglcw-options="width:150,tooltip: true">详情</div>
                        <div data-field="opera"
                             uglcw-options="{width:100,template: uglcw.util.template($('#formatterOpear').html())}">操作
                        </div>
                        <div data-field="picList"
                             uglcw-options="align:'left', width:300,template:uglcw.util.template($('#picList').html())">图片
                        </div>
                        <div data-field="fileList"
                             uglcw-options="align:'left', width:600,template:uglcw.util.template($('#fileList').html())">附件
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:toLoadExcel();" class="k-button k-button-icontext">
        <span class="k-icon k-i-download"></span>导出
    </a>
    <a role="button" href="javascript:toDel();" class="k-button k-button-icontext">
        <span class="k-icon k-i-trash"></span>删除
    </a>
</script>

<script id="formatterTp" type="text/x-kendo-template">
    #if(data.auditTp=='1'){#
    请假
    #}else if(data.auditTp=='2'){#
    报销
    #}else if(data.auditTp=='3'){#
    出差
    #}else if(data.auditTp=='4'){#
    物品领用
    #}else if(data.auditTp=='5'){#
    通用审批
    #}#
</script>

<script id="formatterOpear" type="text/x-kendo-template">
    <a href="javascript:todetail('#= data.auditNo#');" style='text-decoration:none;color: blue'>详情</a>
</script>
<script id="formatterModel" type="text/x-kendo-template">
    #if(data.modelName){#
    #=data.modelName#
    #}else{#
        #if(data.auditTp=='1'){#
        请假
        #}else if(data.auditTp=='2'){#
        报销
        #}else if(data.auditTp=='3'){#
        出差
        #}else if(data.auditTp=='4'){#
        物品领用
        #}else if(data.auditTp=='5'){#
        通用审批
        #}#
    #}#
</script>

<%--图片--%>
<script id="picList" type="text/x-uglcw-template">
    <div class="uglcw-album">
        <div id="album-list" class="album-list">
            #if(data.picList)for(var i = 0;i < data.picList.length ; i++){#
                    # var item=data.picList[i];#
            <div class="album-item">
                # if(item.type != "1"){ #
                <img src="/upload/#= item.picMini#" style="border: 1px solid red;">
                # }else{ #
                <img src="/upload/#= item.picMini#">
                # } #
                <div class="album-item-cover">
                    <i class="ion-ios-eye" onclick="preview(this, #= i#)"></i>
                    <%--<i class="ion-ios-photos" onclick="setAsPrimary(this, #= i#)"></i>--%>
                </div>
            </div>
            #}#
        </div>
    </div>
</script>

<%--附件--%>
<script id="fileList" type="text/x-uglcw-template">
        <div >
            #if(data.fileList)for(var i = 0;i < data.fileList.length ; i++){#
                # var item=data.fileList[i];#
                # var ext=item.ext#
                # if(ext == 'png' || ext == 'jpg' || ext == 'jpeg'){ #
                <div class="album-item">
                    <img src="/upload/#= item.path#">
                    <div class="album-item-cover">
                        <i class="ion-ios-eye" onclick="previewFile('#=item.path#')"></i>
                    </div>
                </div>
                # }else{ #
                <a class="k-button" href="/upload/#=item.path#"  charset="UTF-8" target="_blank"> <i class="k-icon k-i-download"></i> #= item.origin #</a>
                #}#
            #}#
        </div>
</script>


<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();

        uglcw.ui.get('#search').on('click', function () {   //搜索（查询）
            uglcw.ui.get('#grid').k().dataSource.read();
        })

        uglcw.ui.get('#reset').on('click', function () {    //重置
            uglcw.ui.clear('.form-horizontal');
        })
        uglcw.ui.loaded()
    })


    function toDel() {
        var selection = uglcw.ui.get('#grid').selectedRow();
        if (selection) { //判断是否为空
            uglcw.ui.confirm('是否要删除选中的审批?', function () {
                $.ajax({
                    url: '${base}/manager/deleteAuditByNo',
                    data: {
                        auditNo: $.map(selection, function (row) {  //选中多行数据删除
                            return row.auditNo
                        }).join(',')
                    },
                    type: 'post',
                    success: function (json) {
                        if (json) {
                            if (json == 1) {
                                uglcw.ui.success("删除成功");
                                uglcw.ui.get('#grid').k().dataSource.read();//刷新页面
                            }
                        } else {
                            uglcw.ui.error("删除失败");//错误提示
                            return;
                        }
                    }
                })
            })
        } else {
            uglcw.ui.warning('请选择行！');
        }

    }

    function toLoadExcel() {//导出成Excel
        var textbox = uglcw.ui.bind($("#export")) //绑定值
        var time1 = textbox.atime;
        var time2 = textbox.btime;
        var etp = textbox.auditTp;
        var edsc = textbox.dsc;
        var tps = textbox.tp;
        var memberNmS = textbox.memberNm;
        window.location.href = '${base}/manager/loadAuditExcel?time1=' + time1 + '&time2=' + time2 + '&etp=' + etp + '&edsc=' + edsc + '&tps=' + tps + '&memberNmS' + memberNmS;  //多参数
    }

    function todetail(auditNo) {//详情页面
        uglcw.ui.openTab(auditNo, "${base}/manager/toAuditDetail?auditNo=" + auditNo);
    }

    // 放大图片
    function preview(e, index) {
        var grid = uglcw.ui.get('#grid');
        var row = grid.k().dataItem($(e).closest('tr'));
        layer.photos({
            photos: {
                start: index, data: $.map(row.picList, function (item) {
                    return {
                        src: '/upload/' + item.pic,
                        pid: item.id,
                        alt: item.pic,
                        thumb: '/upload/' + item.picMini
                    }
                })
            }, anim: 5
        });
    }

    // 放大图片
    function previewFile(pic) {
        var picList = [];
        picList.push(pic)
        layer.photos({
            photos: {
                start: 0, data: $.map(picList, function (item) {
                    return {
                        src: '/upload/' + item,
                        pid: item.id,
                        alt: item.pic,
                        thumb: '/upload/' + item.pic
                    }
                })
            }, anim: 5
        });
    }

    //下载
    function download(e, index) {
        var grid = uglcw.ui.get('#grid');
        var row = grid.k().dataItem($(e).closest('tr'));
        uglcw.ui.confirm('是否下载'+row.fileList[index].origin+'？', function () {
            // window.location.href = row.fileList[index].url
            // window.location.href = "http://192.168.1.11/upload/sjk1460427117375139/audit/2020/03/17/3ec121eda308495381d4698e06f958e4.txt"
            // var newWin = window.open('_blank');
            // newWin.location = 'http://192.168.1.11/upload/sjk1460427117375139/audit/2020/03/17/3ec121eda308495381d4698e06f958e4.txt';
            // newWin.document.characterSet="UTF-8";

            var url = "http://192.168.1.11/upload/sjk1460427117375139/audit/2020/03/17/3ec121eda308495381d4698e06f958e4.txt";

            // //创建a标签
            // var a = document.createElement('a');
            // a.setAttribute('href', url);
            // a.setAttribute('download', url.split('/').pop()); //分割路径，取出最后一个元素
            // a.setAttribute('target', '_blank');
            // a.setAttribute('id', 'DownloadFile');
            // if(document.getElementById('DownloadFile')) {
            //     document.body.removeChild(document.getElementById('DownloadFile'));
            // }
            // document.body.appendChild(a);
            // a.click();

            var a = window.open (url,"111","height=0,width=0, top=100 left=50 toolbar=no,menubar=no,scrollbars=no,resizable=on,location=no,status=no");

            a.document.execCommand("SaveAs");

            a.window.close();

            a.close();
        })
    }






</script>
</body>
</html>
