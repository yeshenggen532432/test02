<!--监听按钮事件-->
<script type="text/javascript" src="<%=basePath%>/resource/jquery.jdirk.js?v=20190703"></script>
<script>
    /**
     * 获取顶层window
     * @returns {Window}
     */
    function getWindow() {
        var obj = window.self;
        while (true) {
            if (obj.document.getElementById("reLoginWindow")) {
                return obj;
            }
            obj = obj.window.parent;
        }
        return obj;
    }


</script>

<script>

    $.fn.datagrid.defaults.loadFilter = function (data) {
        if (data && data.code == 413) {
            var win = getWindow();
            win.relogin();
            data.rows = []
            data.total = 0
        }
        return data;
    }
    $.ajaxSetup({
        dataFilter: function (data, type) {
            return data;
        },
        complete: function (xhr) {
            if (xhr.getResponseHeader('content-type').indexOf('json') !== -1) {
                try {
                    var resp = JSON.parse(xhr.responseText);
                    if (resp && resp.code === 413) {
                        var win = getWindow();
                        win.relogin();
                    }
                } catch (e) {
                    console.log(e);
                }

            }
        }
    });

    $.fn.form.methods.submit = function (target, options) {
        var _success = options.success;
        var url = options.url || $(target).attr('action');
        options.success = function (response, status, xhr) {
            if (xhr.getResponseHeader('content-type').indexOf('json') !== -1) {
                try {
                    var resp = JSON.parse(xhr.responseText);
                    if (resp && resp.code === 413) {
                        var win = getWindow();
                        win.relogin();
                        return;
                    }
                } catch (e) {
                }
            }
            if ($.isFunction(_success)) {
                _success(response)
            }
        };
        var data = $(target).serializeObject({transcript: 'overlay'});
        var ajaxOptions = {
            url: url,
            type: options.type || $(target).attr('method') || 'post',
            dataType: 'text', //XXX 原form提交 response均为text格式
            data: data,
            error: options.error || function () {
                console.log(arguments);
            },
            success: options.success
        };
        if (ajaxOptions.contentType && ajaxOptions.contentType === 'application/json') {
            ajaxOptions.data = JSON.stringify(ajaxOptions.data);
        }
        if (data instanceof FormData) {
            ajaxOptions.processData = false;
            ajaxOptions.contentType = false;
            if (options.onSubmit && $.isFunction(options.onSubmit)) {
                var param = {};
                options.onSubmit({});
                $.map(param, function (v, k) {
                    data.append(k, v);
                })
            }
        } else if (options.onSubmit && $.isFunction(options.onSubmit)) {
            options.onSubmit(data);
        }

        $.ajax(ajaxOptions);
    }
</script>