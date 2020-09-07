(function ($, window, uglcw) {
    'use strict';
    var common = {};
    common.refreshPageToken = function (opts) {
        opts = uglcw.extend(opts, {
            model: 'page_token'
        });
        uglcw.ui.loading();
        $.ajax({
                url: '/page/token/generate',
                type: 'get',
                dataType: 'json',
                success: function (response) {
                    uglcw.ui.loaded();
                    if (response.code === 200) {
                        uglcw.ui.get('[uglcw-model=' + opts.model + ']').value(response.data);
                    } else {
                        uglcw.ui.warning('获取token失败，请手动刷新页面');
                    }
                },
                error: function () {
                    uglcw.ui.loaded();
                    uglcw.ui.error('获取token失败');
                }
            }
        )
    };

    uglcw.biz = common;
})(jQuery, window, uglcw);