<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>其他应收账款初始化-添加</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }
    </style>
    <script>
        var itemsJson = {};
    </script>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md12">
            <div class="layui-card master">
                <div class="layui-card-header btn-group">
                    <ul uglcw-role="buttongroup">
                        <li onclick="submitStk()" data-icon="save" class="k-info">暂存</li>
                    </ul>
                </div>
                <form class="form-horizontal" uglcw-role="validator">
                </form>
            </div>
            <div class="layui-row layui-col-space15">
                <div class="layui-col-md12">
                    <div class="layui-card">
                        <div class="layui-card-body full">
                            <div id="grid" uglcw-role="grid"
                                 uglcw-options='
								 responsive:[".master",40],
								  id: "id",
								  toolbar: uglcw.util.template($("#toolbar").html()),
								  editable: true,
								  height:400,
								  navigatable: true,
								'
                            >
                                <div data-field="proName" uglcw-options="
									width: 150,
									headerTemplate: templateName,
									editor: function(container, options){
										var input = $('<input data-bind=\'value:proName\' readonly>');
										input.appendTo(container);
										var selector = new uglcw.ui.GridSelector(input);
										selector.init({
											click: function(){
												chooseItem(container, options.model, selector);
											}
										})
									}
									">
                                </div>
                                <div data-field="amt"
                                     uglcw-options="width: 150,schema:{type: 'number', validation:{min:0}}">
                                    初始化借款金额
                                </div>
                                <div data-field="itemName" uglcw-options="width: 150,
									 editor: function(container, options){
										var input = $('<input>');
										input.appendTo(container);
										console.log(options);
										var model = options.model;
										var selector = new uglcw.ui.ComboBox(input);
										selector.init({
											value: model.id,
											dataSource:itemsJson,
											dataTextField: 'itemName',
											dataValueField: 'id',
											select: function(e){
												var item = e.dataItem;
												model.itemId = item.id,
												model.itemName = item.itemName;
											}
										})
									}">往来明细科目
                                </div>
                                <div data-field="options" uglcw-options="width: 150, command:'destroy'">操作</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<tag:compositive-selector-template/>
<tag:costitem-selector-template/>
<script type="text/x-kendo-template" id="toolbar">
    <a role="button" href="javascript:addRow();" class="k-button k-button-icontext">
        <span class="k-icon k-i-plus-outline"></span>添加
    </a>
</script>
<script id="_header" type="text/x-uglcw-template">
    # var bizType = '${bizType}'; #
    #  if(bizType == 'CSHGYSJK'){ #
    往来供应商
    # }else if(bizType == 'CSHGYSJK'){ #
    往来客户
    # }else if(bizType == 'CSHGYSJK'){ #
    员工名称
    # } #
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();
        loadDataInit();
        setTimeout(uglcw.ui.loaded, 210);
    })

    function addRow() {//添加
        uglcw.ui.get('#grid').addRow({
            amt: ''
        });
    }

    function submitStk() {//保存
        var data = uglcw.ui.bind('.form-horizontal');

        var row = uglcw.ui.get('#grid').bind();//绑定表单数据
        if (row.length == 0) {
            uglcw.ui.warning("请添加明细！")
            return false;
        }

        var valid = true;
        $(row).each(function (index, item) {
            if (!item.proId) {
                valid = false;
                uglcw.ui.warning('第[' + (index + 1) + ']行,请选择对象');
                return false;
            }
            if (!item.amt) {
                valid = false;
                uglcw.ui.warning('第[' + (index + 1) + ')]行,请输入金额');
                return false;
            }
            $.map(item, function (v, k) {
                data['list[' + index + '].' + k] = v;
            })
        })
        if (!valid) {
            return;
        }
        uglcw.ui.confirm('保存后将不能修改,是否确定保存？', function () {
            uglcw.ui.loading();
            $.ajax({
                url: '${base}manager/finInitQtWlMain/save',
                type: 'post',
                data: data,
                dataType: 'json',
                success: function (json) {
                    uglcw.ui.loaded()
                    if (json.state) {
                        uglcw.ui.success('暂存成功');
                        setTimeout(function () {
                            uglcw.io.emit('refreshInitYgjk-${bizType}', "${bizType}");//发布事件
                            uglcw.ui.closeCurrentTab();//关闭当前页
                        }, 1000);
                    } else {
                        uglcw.ui.warning(json.msg || '操作失败');
                    }
                },
                error: function () {
                    uglcw.ui.loaded()
                }
            })
        })
    }


    //----------------------------------------------------------------------------------------------------------
    function templateName() {
        var str = '往来供应商';
        if (bizType == 'CSHGYSJC') {
            str = '往来供应商';
        }
        if (bizType == 'CSHKHJC') {
            str = '往来客户';
        }
        if (bizType == 'CSHYGJC') {
            str = '员工名称';
        }
        return str;
    }


    var bizType = '${bizType}';
    var proType = '${proType}';
    var c, m, s;

    function chooseItem(container, model, selector) {
        c = container;
        m = model;
        s = selector;
        if (bizType == 'CSHGYSJC') {
            showSelectJxc(container, model, selector);
        }
        if (bizType == 'CSHKHJC') {
            showSelectCustomeer(container, model, selector);
        }
        if (bizType == 'CSHYGJC') {
            showSelectMember(container, model, selector);
        }

    }

    //选择供货经销商
    function showSelectJxc(c, m, s) {
        uglcw.ui.Modal.showGridSelector({
            closable: false,
            title: false,
            url: '${base}manager/selectProviderList',
            // query: function (params) {
            //     params.extra = new Date().getTime();
            // },
            checkbox: false,
            width: 650,
            height: 400,
            criteria: '<input placeholder="请输入客户名称" uglcw-role="textbox" uglcw-model="khNm">',
            columns: [
                {field: 'proName', title: '供应商名称', width: 150},
                {field: 'contact', title: '联系人', width: 100},
                {field: 'mobile', title: '电话', width: 150},
            ],
            yes: function (nodes) {
                var row = nodes[0];
             /*   s.value(row.proName);*/
                m.set('proId', row.id);
                m.set('ioMark', 1);
                m.set('bizType', '${bizType}');
                m.set('proType', '${proType}');
                m.set('proName', row.proName);
                uglcw.ui.get('#grid').commit();
            }
        })
    }

    //选择客户
    function showSelectCustomeer(c, m, s) {
        uglcw.ui.Modal.showGridSelector({
            closable: false,
            title: false,
            url: '${base}manager/customerPage?khTp=2',
            // query: function (params) {
            //     params.extra = new Date().getTime();
            // },
            checkbox: false,
            width: 650,
            height: 400,
            criteria: '<input placeholder="请输入客户名称" uglcw-role="textbox" uglcw-model="khNm">',
            columns: [
                {field: 'khCode', title: '编码', width: 50},
                {field: 'khNm', title: '名称', width: 160},
                {field: 'linkman', title: '联系人', width: 160},
            ],
            yes: function (nodes) {
                var row = nodes[0];
               /* s.value(row.khNm);*/
                m.set('proId', row.id);
                m.set('ioMark', 1);
                m.set('bizType', '${bizType}');
                m.set('proType', '${proType}');
                m.set('proName', row.khNm);
                uglcw.ui.get('#grid').commit();
            }
        })
    }

    //选择员工
    function showSelectMember(c, m, s) {
        uglcw.ui.Modal.showGridSelector({
            closable: false,
            title: false,
            url: '${base}manager/memberPage',
            // query: function (params) {
            //     params.extra = new Date().getTime();
            // },
            checkbox: false,
            width: 650,
            height: 400,
            criteria: '<input placeholder="请输入姓名" uglcw-role="textbox" uglcw-model="memberNm">',
            columns: [
                {field: 'memberNm', title: '姓名', width: 100},
                {field: 'memberMobile', title: '手机号码', width: 150},
                {field: 'branchName', title: '部门', width: 150},
            ],
            yes: function (nodes) {
                var row = nodes[0];
            /*    s.value(row.khNm);*/
                m.set('proId', row.memberId);
                m.set('ioMark', 1);
                m.set('bizType', '${bizType}');
                m.set('proType', '${proType}');
                m.set('proName', row.memberNm);
                uglcw.ui.get('#grid').commit();
            }
        })
    }

    function loadDataInit() {
        var path = "${base}manager/queryUseIoItemList";
        $.ajax({
            url: path,
            type: "POST",
            data: {"typeName": '其它应收款'},
            dataType: 'json',
            async: false,
            success: function (json) {
                if (json.state) {
                    var size = json.rows.length;
                    itemsJson = json.rows;
                    /*if(
                    ${billId}!=0){
						return;
					}*/
                    for (var i = 0; i < size; i++) {
                        if (json.rows[i].itemName == '其它应收借出款项') {
                            uglcw.ui.get('#grid').addRow({
                                itemId: json.rows[i].id,
                                itemName: json.rows[i].itemName,
                                typeName: json.rows[i].typeName,
                                remarks: ''
                            })
                        }
                    }
                }
            }
        });
    }

</script>
</body>
</html>
