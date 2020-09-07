/**

 @Name：layuiAdmin iframe版主入口
 @Author：贤心
 @Site：http://www.layui.com/admin/
 @License：LPPL

 */
var digitArray = new Array('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f');

function toHex(n) {
    var result = ''
    var start = true;

    for (var i = 32; i > 0;) {
        i -= 4;
        var digit = (n >> i) & 0xf;

        if (!start || digit != 0) {
            start = false;
            result += digitArray[digit];
        }
    }
    return (result == '' ? '0' : result);
}

layui.extend({
    setter: 'config' //配置模块
    , admin: 'lib/admin' //核心模块
    , view: 'lib/view' //视图渲染模块
    , contextMenu: 'modules/contextMenu'
}).define(['setter', 'admin', 'contextMenu'], function (exports) {
    var bConnect = 0;
    var setter = layui.setter
        , element = layui.element
        , admin = layui.admin
        , tabsPage = admin.tabsPage
        , view = layui.view
        , form = layui.form
        , t = layui.contextMenu
        , TABS_HEADER = '#LAY_app_tabsheader>li'

        //打开标签页
        , openTabsPage = function (url, text) {

            //遍历页签选项卡
            var matchTo
                , tabs = $('#LAY_app_tabsheader>li')
                , path = url.replace(/(^http(s*):)|(\?[\s\S]*$)/g, '');

            admin.pageHistory.pageChange(url, text);
            tabs.each(function (index) {
                var li = $(this)
                    , layid = li.attr('lay-id');

                if (layid === url) {
                    matchTo = true;
                    tabsPage.index = index;
                }
            });

            text = text || '新标签页';

            if (setter.pageTabs) {
                //如果未在选项卡中匹配到，则追加选项卡
                if (!matchTo) {
                    $('#refresh-btn').addClass('layui-anim-rotate layui-anim-loop');
                    $(APP_BODY).append([
                        '<div class="layadmin-tabsbody-item layui-show">'
                        , '<iframe src="' + url + '" frameborder="0" class="layadmin-iframe" onload="layui.index.onFrameLoaded()"></iframe>'
                        , '</div>'
                    ].join(''));
                    tabsPage.index = tabs.length;
                    element.tabAdd(FILTER_TAB_TBAS, {
                        title: '<span>' + text + '</span>'
                        , id: url
                        , attr: path
                    });
                }
            } else {
                var iframe = admin.tabsBody(admin.tabsPage.index).find('.layadmin-iframe');
                iframe[0].contentWindow.location.href = url;
            }

            //定位当前tabs
            element.tabChange(FILTER_TAB_TBAS, url);
            admin.tabsBodyChange(tabsPage.index, {
                url: url
                , text: text
            });
        }

        , APP_BODY = '#LAY_app_body', FILTER_TAB_TBAS = 'layadmin-layout-tabs'
        , TABS_BODY = 'layadmin-tabsbody-item'
        , $ = layui.$, $win = $(window);

    //初始
    //if (admin.screen() < 2) admin.sideFlexible();

    //将模块根路径设置为 controller 目录
    layui.config({
        base: setter.base + 'modules/'
    });

    //扩展 lib 目录下的其它模块
    layui.each(setter.extend, function (index, item) {
        var mods = {};
        mods[item] = '{/}' + setter.base + 'lib/extend/' + item;
        layui.extend(mods);
    });

    view().autoRender();

    //加载公共模块
    layui.use('common');

    var showSubMenu = function (index) {
        $('.menu-top').removeClass('layui-this')
        $('#top-menu-' + index).addClass('layui-this')
        var t = document.getElementById('sub-menu-' + index);
        if (t) {
            $('#LAY-system-side-menu').html(t.innerHTML);
            //重新渲染
            layui.element.init();
            $('#LAY-system-side-menu').removeClass('layui-anim-upbit');
            setTimeout(function () {
                $('#LAY-system-side-menu').addClass('layui-anim-upbit');
            }, 50);
        }
    }

    var refreshPage= function () {
        //alert(11);
        //$('#refresh-btn').addClass('layui-anim-rotate layui-anim-loop');
        var ELEM_IFRAME = '.layadmin-iframe', TABS_HEADER = '#LAY_app_tabsheader>li',
            TABS_REMOVE = 'LAY-system-pagetabs-remove';

        var iframe = admin.tabsBody(admin.tabsPage.index).find(ELEM_IFRAME);
        iframe[0].contentWindow.location.reload(true);
    }

    var logout = function () {
        window.location.href = '/manager/loginout'
    }


    var init = function () {
        if (navigator.userAgent.indexOf("MSIE") > 0 && !navigator.userAgent.indexOf("opera") > -1) return;
        try {

        } catch (e) {
            alert(e.name + ": " + e.message);
            return false;
        }
    }

    function checkDog(companyId) {


    }

    function doChangeCompany(companyId) {
        var dogUser = $("#dogUser").val();
        var idKey = $("#idKey").val();
        var EncData = $("#EncData").val();
        var optype = $('#optype').val();
        window.location.href = "/manager/changeCompany?companyId=" + companyId + "&optype=" + optype + "&dogUser=" + dogUser + "&idKey=" + idKey + "&EncData=" + EncData;
    }


    var changeCompany = function (companyId) {
        checkDog(companyId)
    }

    var passwordScore = function (password) {
        var score = 0;
        if (!password)
            return score;

        // award every unique letter until 5 repetitions
        var letters = new Object();
        for (var i = 0; i < password.length; i++) {
            letters[password[i]] = (letters[password[i]] || 0) + 1;
            score += 5.0 / letters[password[i]];
        }

        // bonus points for mixing it up
        var variations = {
            digits: /\d/.test(password),
            lower: /[a-z]/.test(password),
            upper: /[A-Z]/.test(password),
            nonWords: /\W/.test(password),
        }

        var variationCount = 0;
        for (var check in variations) {
            variationCount += (variations[check] == true) ? 1 : 0;
        }
        score += (variationCount - 1) * 10;

        return parseInt(score);
    }

    var password = {
        open: function () {
            layer.open({
                title: '修改密码',
                type: 1,
                area: '500px',
                offset: '100px',
                content: $('#update-password-dialog'),
                btn: ['确定修改', '取消'],
                success: function (layero, index) {
                    layui.form.render();
                    layui.form.verify({
                        checkRepeat: function (value, dom) {
                            var password = $('#' + $(dom).data('check')).val();
                            if (value !== password) {
                                return '两次输入不一致'
                            }
                        },
                        pass: function (val, dom) {
                            if (!val || val.length < 6 || val.length > 16) {
                                return '请输入6至16位密码';
                            }
                            var score = passwordScore(val)
                            if (score <= 30) {
                                return '密码强度太低，数字、大小写字母及特殊符号至少包含2种'
                            }
                        }
                    });
                    layui.form.on('submit(change-pwd)', function (data) {
                        $.ajax({
                            url: '/manager/account/password',
                            type: 'post',
                            contentType: 'application/json',
                            dataType: 'json',
                            data: JSON.stringify({
                                oldPassword: hex_md5(data.field.oldPassword),
                                newPassword: hex_md5(data.field.newPassword)
                            }),
                            success: function (response) {
                                if (response.code == 200) {
                                    layer.msg('修改成功', {icon: 1});
                                    layer.close(index);
                                } else {
                                    layer.msg(response.message);
                                }
                            }
                        })
                    })
                },
                yes: function (index, layero) {
                    layero.find('.btn-change-pwd').click();
                }
            })
        },
        check: function (e) {
            var password = $(e).val();
            var score = passwordScore(password);
            var strength = -1;
            if (score > 80) {
                strength = 2;
            } else if (score >= 60) {
                strength = 1;
            } else if (score >= 30) {
                strength = 0;
            }
            console.log(strength);
            var blocks = $('.password-validation .passwordStrength');
            blocks.removeAttr('class');
            blocks.addClass('passwordStrength');
            if (strength < 1) {
                $('#strengthLow').addClass('passwordLow');
                $('#strengthflag').html('弱');
            } else if (strength === 1) {
                $('#strengthLow').addClass('passwordMid');
                $('#strengthMid').addClass('passwordMid');
                $('#strengthflag').html('中');
            } else if (strength === 2) {
                blocks.addClass('passwordHigh');
                $('#strengthflag').html('强');
            }

        },
    }

    var login = {
        open: function () {
            if ($('form[lay-filter="login-form"]').length > 0) {
                return;
            }
            layer.open({
                title: '您的账号在其它地方登录，或已经超时',
                type: 1,
                area: '400px',
                offset: '100px',
                content: $('#login-dialog').html(),
                btn: ['登录'],
                success: function (layero, index) {
                    layui.form.render();
                    $('#login-password').val('');
                    layui.form.on('submit(login)', function (data) {
                        var param = data.field;
                        param.password = hex_md5(param.password);
                        $.ajax({
                            url: '/manager/login',
                            type: 'post',
                            dataType: 'json',
                            contentType: 'application/json',
                            data: JSON.stringify(param),
                            success: function (response) {
                                if (response.code === 200) {
                                    layer.msg('登录成功, 请重新操作', {icon: 1});
                                    layer.close(index);
                                } else {
                                    layer.msg(response.message);
                                }
                            }
                        })
                        return false;
                    })
                },
                yes: function (index, layero) {
                    layero.find('.login-btn').click();
                    return false;
                }
            })
        }
    }

    var showOrders = function () {
        view.req({
            url: '/manager/queryBforderMsgls?time=' + new Date().getTime(),
            type: 'get',
            dataType: 'json',
            success: function (response) {
                if (response.state == 1) {
                    setter.orders = response.rows || []
                    if (setter.orders.length > 0) {
                        $('#order-notice-dot').show();
                    } else {
                        $('#order-notice-dot').hide();
                    }
                    admin.popupRight({
                        area: '400px',
                        id: 'order-popup'
                        , success: function () {
                            view(this.id).render('system/order');
                        }
                    });
                }
            }
        })
    }
    var readMsg = function (e) {
        var index = parseInt($(e).attr('data-index'))
        $.ajax({
            url: '/manager/updateBforderMsgisRead',
            type: 'get',
            data: {
                id: $(e).attr('data-id'),
                time: new Date().getTime()
            },
            success: function (response) {
                if (response === '1') {
                    setter.orders.splice(index, 1)
                    if (setter.orders.length > 0) {
                        $('#order-notice-dot').show();
                    } else {
                        $('#order-notice-dot').hide();
                    }
                    view('order-popup').render('system/order')
                }
            }
        })
    }
    var toChangeCompany = function () {
        layer.open({
            type: 1
            , title: false //不显示标题栏
            , closeBtn: false
            , area: '300px;'
            , offset: '100px'
            //, shade: 0.8
            , btn: ['切换', '取消']
            , btnAlign: 'c'
            , moveType: 1 //拖拽模式，0或者1
            , content: $('#company-switching')
            , success: function (layero) {

            },
            yes: function (index, layero) {
                var t = layero.find('.layui-nav-child .layui-this a');
                var companyId = $(t).attr('data-id');
                changeCompany(companyId);
            }
        });
    };

    var getQueryString = function (url) {
        url = url || window.location.href;
        var vars = {}, hash;
        var hashes = url.slice(url.indexOf('?') + 1).split('&');
        for (var i = 0; i < hashes.length; i++) {
            hash = hashes[i].split('=');
            vars[hash[0]] = hash[1];
        }
        return vars;
    }

    var loginDialogDelayTimer;
    window.openLoginDialog = function () {
        window.clearTimeout(loginDialogDelayTimer);
        loginDialogDelayTimer = setTimeout(function () {
            login.open();
        }, 200);
    };

    window.close = function (title) {
        window.closeWin(title);
    };

    window.add = function (title, url) {
        var refererUrl = $(TABS_HEADER).eq(admin.tabsPage.index).attr('lay-id');
        var params = getQueryString(refererUrl);
        var targetParams = getQueryString(url);
        var sticky = params._sticky || _STICKY;
        if (!targetParams._sticky && sticky) {
            if (url.indexOf('?') === -1) {
                url += '?_sticky=' + sticky;
            } else {
                url += '&_sticky=' + sticky;
            }
        }
        window.openTab(title, url, true);
    };
    window.closeWin = function (title) {
        if (!title) {
            return
        }
        var hit = -1;
        $(TABS_HEADER).each(function (i, t) {
            var span = $(t).find('span');
            if (span.length > 0) {
                var txt = span.text().trim();
                if (title == txt) {
                    hit = i
                    return false;
                }
            }
        });
        if (hit !== -1) {
            $(TABS_HEADER).eq(hit).find('.layui-tab-close').trigger('click');
        }
    }

    window.openTab = function (title, url, refresh) {
        layui.index.openTabsPage(url, title, refresh);
    };

    window.closeCurrentTab = function () {
        layui.admin.events.closeThisTabs()
    };

    window.closeOtherTabs = function () {
        layui.admin.events.closeOtherTabs();
    };

    window.closeAllTabs = function () {
        layui.admin.events.closeAllTabs();
    };

    window.replaceCurrentTab = function (title, url) {
        admin.replaceCurrentTab(title, url);
    };

    var onFrameLoaded = function () {
        $('#refresh-btn').removeClass('layui-anim-rotate layui-anim-loop');
    };

    $('#nav-tabs').off('contextmenu.tab').on('contextmenu.tab', 'li', function (v) {
        var $li = $(this), tabIndex = $li.index();
        var ELEM_IFRAME = '.layadmin-iframe', TABS_HEADER = '#LAY_app_tabsheader>li',
            TABS_REMOVE = 'LAY-system-pagetabs-remove';
        var menus = [
            {
                icon: 'layui-icon layui-icon-refresh',
                name: '刷新当前',
                click: function () {
                    $('#refresh-btn').addClass('layui-anim-rotate layui-anim-loop');
                    var iframe = admin.tabsBody($li.index()).find(ELEM_IFRAME);
                    iframe[0].contentWindow.location.reload(true);
                }
            },
            {
                icon: 'layui-icon layui-icon-close',
                name: '关闭右侧',
                click: function () {
                    $(TABS_HEADER + ':gt(' + tabIndex + ')').remove();
                    $(APP_BODY).find('.' + TABS_BODY + ':gt(' + tabIndex + ')').remove();
                    $li.trigger('click');
                }
            },
            {
                icon: 'layui-icon layui-icon-close',
                name: '关闭其他',
                click: function () {
                    $(TABS_HEADER).each(function (idx, item) {
                        if (idx && idx !== tabIndex) {
                            $(item).addClass(TABS_REMOVE);
                            $("#LAY_app_body").find('.layadmin-tabsbody-item:eq(' + idx + ')').addClass(TABS_REMOVE);
                        }
                    });
                    $('.' + TABS_REMOVE).remove();
                    $li.trigger('click');
                }
            },
            {
                icon: 'layui-icon layui-icon-close',
                name: '关闭全部',
                click: function () {
                    layui.admin.events.closeAllTabs();
                }
            }
        ];
        if (tabIndex) {
            menus.push({
                icon: 'layui-icon layui-icon-close-fill ctx-ic-lg',
                name: '关闭当前',
                click: function () {
                    $li.find('.layui-tab-close').trigger('click');
                }
            });
        }
        t.show(menus, v.clientX, v.clientY);
        return false;
    })

    //对外输出
    exports('index', {
        openTabsPage: openTabsPage,
        showSubMenu: showSubMenu,
        logout: logout,
        init: init,
        login: login,
        changeCompany: changeCompany,
        password: password,
        showOrders: showOrders,
        readMsg: readMsg,
        toChangeCompany: toChangeCompany,
        onFrameLoaded: onFrameLoaded,
        refreshPage:refreshPage
    });
});
