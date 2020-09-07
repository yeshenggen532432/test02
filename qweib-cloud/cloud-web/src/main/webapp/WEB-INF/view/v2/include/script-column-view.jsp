<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script id="custom-settings-tpl" type="text/x-uglcw-template">
    <div class="bill-custom-settings uglcw-layout-container">
        <div class="uglcw-layout-content">
                        <div data-type="1" data-name="slave" class="grid-column" uglcw-role="grid" uglcw-options="
                         draggable: true,
                         editable: true,
                         id: 'id',
                         height: 340,
                         rowNumber: true,
                         autoAppendRow: false,
                         lockable:false
                        ">
                            <div data-field="checkbox" uglcw-options="
                            width: 60,
                            attributes: { class: 'column-checkbox'},
                            template: uglcw.util.template($('#column-setting-checkbox-tpl').html())
                            ">显示
                            </div>
                            <div data-field="title">列名</div>
                            <div data-field="width" uglcw-options="hidden:true,schema:{type:'number'}">列宽</div>
                        </div>
        </div>
    </div>
</script>

<script id="column-setting-checkbox-tpl" type="text/x-uglcw-template">
    <input
            #if(data.reserved){#
            disabled
            #}#
            #if(!data.hidden){#
            checked
            #}#
            class="k-checkbox" id="#=data.uid#" onchange="onCheckboxChange(this)" type="checkbox">
    <label for="#= data.uid#" class="bill-setting-checkbox k-checkbox-label k-no-text"></label>
</script>

<script>
    function showColumnSetting(url,namespace) {
        var modalIndex = uglcw.ui.Modal.open({
            maxmin: false,
            title: '设置列表显示(选择完要点保存)',
            content: $('#custom-settings-tpl').html(),
            area: ['600px', '415px'],
            btns: ['保存','取消'],
            success: function (c) {
                uglcw.ui.init(c);
                var init = function (config, initialized) {
                    $(c).data('initialized', initialized);
                    uglcw.ui.get($(c).find('.uglcw-grid.grid-column')).value(config.slave);
                    $(c).find('.uglcw-grid').each(function () {
                        var that = $(this);
                        uglcw.ui.get(that).k().dataSource.bind("change", function () {
                            that.data('_changed', true);
                        })
                    });
                };
                var templateConfig;
                //alert(CTX +url);
                $.ajax({
                    async: false,
                    url: CTX +url,
                    success: function (config) {
                        templateConfig = config;
                    }
                })
                $.ajax({
                    url: CTX + 'manager/common/bill/config/'+namespace,
                    type: 'GET',
                    success: function (response) {
                        init(mergeConfig(response.data, templateConfig), !!response.data);
                    }
                });
            },
            yes: function (c) {
                //保存
                uglcw.ui.confirm('确定保存配置吗', function () {
                    var delta = [], initialized = $(c).data('initialized');
                    var config = {};
                    $(c).find('.uglcw-grid').each(function () {
                        var $grid = $(this);
                           type = $grid.data('type');
                           name = $grid.data('name');
                        var data = $.map(uglcw.ui.get($grid).value(), function (item, index) {
                            item.sort = index;
                            item.type = type;
                            return item;
                        });
                        if (!initialized || (initialized && $grid.data('_changed'))) {
                            delta = delta.concat(data);
                            config[name] = data;
                        }
                    });
                    var method = initialized ? 'PUT' : 'POST';

                    if (delta.length === 0) {
                        uglcw.ui.info('无修改');
                        return uglcw.ui.Modal.close(modalIndex);
                    }
                    uglcw.ui.loading();

                    $.ajax({
                        url: CTX + 'manager/common/bill/config/'+namespace,
                        type: method,
                        contentType: 'application/json',
                        data: JSON.stringify({items: delta}),
                        dataType: 'json',
                        success: function (response) {
                            uglcw.ui.loaded();
                            if (response.success) {
                                uglcw.ui.success(response.message +',请重新打开页面才可生效');
                                uglcw.ui.Modal.close();
                                if (config.master) {
                                    var masterModels = uglcw.ui.bind('.form-collapsable');
                                    renderMaster(config.master);
                                    uglcw.ui.init('.form-collapsable');
                                    uglcw.ui.bind('.form-collapsable', masterModels);
                                }
                                uglcw.ui.get('#grid').reload();
                                uglcw.ui.Modal.close(modalIndex);
                            } else {
                                uglcw.ui.error(response.message || '保存失败');
                            }
                        },
                        error: function () {
                            uglcw.ui.loaded();
                        }
                    })
                })
                return false;
            }

        })
    }
    function mergeConfig(serverConfig, templateConfig) {
        serverConfig = serverConfig || {}
        serverConfig.slave = serverConfig.slave || [];
        delete serverConfig['namespace'];
        delete serverConfig['id'];
        $.map(templateConfig, function (configs, key) {
            $(configs).each(function (i, config) {
                var hit = false;
                $(serverConfig[key]).each(function (j, sc) {
                    if (sc.field === config.field) {
                        hit = true;
                        return false;
                    }
                });
                if (!hit) {
                    serverConfig[key].push(config)
                }
            });
        })
        $.map(serverConfig, function (scs, key) {
            var removed = [];
            $(scs).each(function (k, sc) {
                var hit = false;
                $(templateConfig[key]).each(function (l, tc) {
                    if (sc.field === tc.field) {
                        hit = true;
                        return false;
                    }
                })
                if (!hit) {
                    removed.push({
                        group: key,
                        field: sc.field
                    })
                }
            })
            if (removed.length > 0) {
                $(removed).each(function (i, item) {
                    var index = -1;
                    $(serverConfig[item.group]).each(function (j, f) {
                        if (f.field === item.field) {
                            index = j;
                            return false;
                        }
                    });
                    if (index !== -1) {
                        serverConfig[item.group].splice(index, 1);
                    }
                })
            }
        })
        return serverConfig;
    }

    function onCheckboxChange(el) {
        var grid = uglcw.ui.get($(el).closest('.uglcw-grid'));
        var row = grid.k().dataItem($(el).closest('tr'));
        row.set('hidden', !uglcw.util.toBoolean($(el).is(':checked')));
    }

    function initColumnShow(namespace){
        var grid= uglcw.ui.get('#grid');
        $.ajax({
            url: CTX + 'manager/common/bill/config/'+namespace,
            type: 'GET',
            success: function (response) {
                if(response.data){
                    $.map(response.data.slave, function (scs, key) {
                        $(scs).each(function (k, sc) {
                            if(sc.hidden){
                                grid.hideColumn(sc.field);
                            }
                            //console.log(k+":"+sc.title+":"+sc.field+":"+sc.hidden);
                        })
                    });
                }
            }
        });
    }

</script>